1 pragma solidity ^0.4.20;
2 
3 /*
4 * TEST OF YA BOI GRIPZ
5 *
6 */
7 
8 contract Griptest {
9 
10 
11     /*=================================
12     =            MODIFIERS            =
13     =================================*/
14 
15     /// @dev Only people with tokens
16     modifier onlyBagholders {
17         require(myTokens() > 0);
18         _;
19     }
20 
21     /// @dev Only people with profits
22     modifier onlyStronghands {
23         require(myDividends(true) > 0);
24         _;
25     }
26 
27 
28     /*==============================
29     =            EVENTS            =
30     ==============================*/
31 
32     event onTokenPurchase(
33         address indexed customerAddress,
34         uint256 incomingEthereum,
35         uint256 tokensMinted,
36         address indexed referredBy,
37         uint timestamp,
38         uint256 price
39     );
40 
41     event onTokenSell(
42         address indexed customerAddress,
43         uint256 tokensBurned,
44         uint256 ethereumEarned,
45         uint timestamp,
46         uint256 price
47     );
48 
49     event onReinvestment(
50         address indexed customerAddress,
51         uint256 ethereumReinvested,
52         uint256 tokensMinted
53     );
54 
55     event onWithdraw(
56         address indexed customerAddress,
57         uint256 ethereumWithdrawn
58     );
59 
60     // ERC20
61     event Transfer(
62         address indexed from,
63         address indexed to,
64         uint256 tokens
65     );
66 
67 
68     /*=====================================
69     =            CONFIGURABLES            =
70     =====================================*/
71 
72     string public name = "Griptest";
73     string public symbol = "GRIPT";
74     uint8 constant public decimals = 18;
75 
76     /// @dev 15% dividends for token purchase
77     uint8 constant internal entryFee_ = 20;
78 
79     /// @dev 10% dividends for token transfer
80     uint8 constant internal transferFee_ = 10;
81 
82     /// @dev 25% dividends for token selling
83     uint8 constant internal exitFee_ = 25;
84 
85     /// @dev 35% of entryFee_ (i.e. 7% dividends) is given to referrer
86     uint8 constant internal refferalFee_ = 35;
87 
88     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
89     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
90     uint256 constant internal magnitude = 2 ** 64;
91 
92     /// @dev proof of stake (defaults at 50 tokens)
93     uint256 public stakingRequirement = 50e18;
94 
95 
96    /*=================================
97     =            DATASETS            =
98     ================================*/
99 
100     // amount of shares for each address (scaled number)
101     mapping(address => uint256) internal tokenBalanceLedger_;
102     mapping(address => uint256) internal referralBalance_;
103     mapping(address => int256) internal payoutsTo_;
104     uint256 internal tokenSupply_;
105     uint256 internal profitPerShare_;
106 
107 
108     /*=======================================
109     =            PUBLIC FUNCTIONS           =
110     =======================================*/
111 
112     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
113     function buy(address _referredBy) public payable returns (uint256) {
114         purchaseTokens(msg.value, _referredBy);
115     }
116 
117     /**
118      * @dev Fallback function to handle ethereum that was send straight to the contract
119      *  Unfortunately we cannot use a referral address this way.
120      */
121     function() payable public {
122         purchaseTokens(msg.value, 0x0);
123     }
124 
125     /// @dev Converts all of caller's dividends to tokens.
126     function reinvest() onlyStronghands public {
127         // fetch dividends
128         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
129 
130         // pay out the dividends virtually
131         address _customerAddress = msg.sender;
132         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
133 
134         // retrieve ref. bonus
135         _dividends += referralBalance_[_customerAddress];
136         referralBalance_[_customerAddress] = 0;
137 
138         // dispatch a buy order with the virtualized "withdrawn dividends"
139         uint256 _tokens = purchaseTokens(_dividends, 0x0);
140 
141         // fire event
142         onReinvestment(_customerAddress, _dividends, _tokens);
143     }
144 
145     /// @dev Alias of sell() and withdraw().
146     function exit() public {
147         // get token count for caller & sell them all
148         address _customerAddress = msg.sender;
149         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
150         if (_tokens > 0) sell(_tokens);
151 
152         // lambo delivery service
153         withdraw();
154     }
155 
156     /// @dev Withdraws all of the callers earnings.
157     function withdraw() onlyStronghands public {
158         // setup data
159         address _customerAddress = msg.sender;
160         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
161 
162         // update dividend tracker
163         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
164 
165         // add ref. bonus
166         _dividends += referralBalance_[_customerAddress];
167         referralBalance_[_customerAddress] = 0;
168 
169         // lambo delivery service
170         _customerAddress.transfer(_dividends);
171 
172         // fire event
173         onWithdraw(_customerAddress, _dividends);
174     }
175 
176     /// @dev Liquifies tokens to ethereum.
177     function sell(uint256 _amountOfTokens) onlyBagholders public {
178         // setup data
179         address _customerAddress = msg.sender;
180         // russian hackers BTFO
181         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
182         uint256 _tokens = _amountOfTokens;
183         uint256 _ethereum = tokensToEthereum_(_tokens);
184         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
185         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
186 
187         // burn the sold tokens
188         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
189         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
190 
191         // update dividends tracker
192         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
193         payoutsTo_[_customerAddress] -= _updatedPayouts;
194 
195         // dividing by zero is a bad idea
196         if (tokenSupply_ > 0) {
197             // update the amount of dividends per token
198             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
199         }
200 
201         // fire event
202         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
203     }
204 
205 
206     /**
207      * @dev Transfer tokens from the caller to a new holder.
208      *  Remember, there's a 15% fee here as well.
209      */
210     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
211         // setup
212         address _customerAddress = msg.sender;
213 
214         // make sure we have the requested tokens
215         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
216 
217         // withdraw all outstanding dividends first
218         if (myDividends(true) > 0) {
219             withdraw();
220         }
221 
222         // liquify 10% of the tokens that are transfered
223         // these are dispersed to shareholders
224         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
225         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
226         uint256 _dividends = tokensToEthereum_(_tokenFee);
227 
228         // burn the fee tokens
229         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
230 
231         // exchange tokens
232         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
233         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
234 
235         // update dividend trackers
236         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
237         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
238 
239         // disperse dividends among holders
240         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
241 
242         // fire event
243         Transfer(_customerAddress, _toAddress, _taxedTokens);
244 
245         // ERC20
246         return true;
247     }
248 
249 
250     /*=====================================
251     =      HELPERS AND CALCULATORS        =
252     =====================================*/
253 
254     /**
255      * @dev Method to view the current Ethereum stored in the contract
256      *  Example: totalEthereumBalance()
257      */
258     function totalEthereumBalance() public view returns (uint256) {
259         return this.balance;
260     }
261 
262     /// @dev Retrieve the total token supply.
263     function totalSupply() public view returns (uint256) {
264         return tokenSupply_;
265     }
266 
267     /// @dev Retrieve the tokens owned by the caller.
268     function myTokens() public view returns (uint256) {
269         address _customerAddress = msg.sender;
270         return balanceOf(_customerAddress);
271     }
272 
273     /**
274      * @dev Retrieve the dividends owned by the caller.
275      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
276      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
277      *  But in the internal calculations, we want them separate.
278      */
279     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
280         address _customerAddress = msg.sender;
281         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
282     }
283 
284     /// @dev Retrieve the token balance of any single address.
285     function balanceOf(address _customerAddress) public view returns (uint256) {
286         return tokenBalanceLedger_[_customerAddress];
287     }
288 
289     /// @dev Retrieve the dividend balance of any single address.
290     function dividendsOf(address _customerAddress) public view returns (uint256) {
291         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
292     }
293 
294     /// @dev Return the sell price of 1 individual token.
295     function sellPrice() public view returns (uint256) {
296         // our calculation relies on the token supply, so we need supply. Doh.
297         if (tokenSupply_ == 0) {
298             return tokenPriceInitial_ - tokenPriceIncremental_;
299         } else {
300             uint256 _ethereum = tokensToEthereum_(1e18);
301             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
302             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
303 
304             return _taxedEthereum;
305         }
306     }
307 
308     /// @dev Return the buy price of 1 individual token.
309     function buyPrice() public view returns (uint256) {
310         // our calculation relies on the token supply, so we need supply. Doh.
311         if (tokenSupply_ == 0) {
312             return tokenPriceInitial_ + tokenPriceIncremental_;
313         } else {
314             uint256 _ethereum = tokensToEthereum_(1e18);
315             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
316             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
317 
318             return _taxedEthereum;
319         }
320     }
321 
322     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
323     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
324         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
325         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
326         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
327 
328         return _amountOfTokens;
329     }
330 
331     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
332     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
333         require(_tokensToSell <= tokenSupply_);
334         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
335         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
336         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
337         return _taxedEthereum;
338     }
339 
340 
341     /*==========================================
342     =            INTERNAL FUNCTIONS            =
343     ==========================================*/
344 
345     /// @dev Internal function to actually purchase the tokens.
346     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
347         // data setup
348         address _customerAddress = msg.sender;
349         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
350         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
351         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
352         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
353         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
354         uint256 _fee = _dividends * magnitude;
355 
356         // no point in continuing execution if OP is a poorfag russian hacker
357         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
358         // (or hackers)
359         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
360         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
361 
362         // is the user referred by a masternode?
363         if (
364             // is this a referred purchase?
365             _referredBy != 0x0000000000000000000000000000000000000000 &&
366 
367             // no cheating!
368             _referredBy != _customerAddress &&
369 
370             // does the referrer have at least X whole tokens?
371             // i.e is the referrer a godly chad masternode
372             tokenBalanceLedger_[_referredBy] >= stakingRequirement
373         ) {
374             // wealth redistribution
375             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
376         } else {
377             // no ref purchase
378             // add the referral bonus back to the global dividends cake
379             _dividends = SafeMath.add(_dividends, _referralBonus);
380             _fee = _dividends * magnitude;
381         }
382 
383         // we can't give people infinite ethereum
384         if (tokenSupply_ > 0) {
385             // add tokens to the pool
386             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
387 
388             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
389             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
390 
391             // calculate the amount of tokens the customer receives over his purchase
392             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
393         } else {
394             // add tokens to the pool
395             tokenSupply_ = _amountOfTokens;
396         }
397 
398         // update circulating supply & the ledger address for the customer
399         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
400 
401         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
402         // really i know you think you do but you don't
403         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
404         payoutsTo_[_customerAddress] += _updatedPayouts;
405 
406         // fire event
407         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
408 
409         return _amountOfTokens;
410     }
411 
412     /**
413      * @dev Calculate Token price based on an amount of incoming ethereum
414      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
415      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
416      */
417     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
418         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
419         uint256 _tokensReceived =
420          (
421             (
422                 // underflow attempts BTFO
423                 SafeMath.sub(
424                     (sqrt
425                         (
426                             (_tokenPriceInitial ** 2)
427                             +
428                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
429                             +
430                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
431                             +
432                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
433                         )
434                     ), _tokenPriceInitial
435                 )
436             ) / (tokenPriceIncremental_)
437         ) - (tokenSupply_);
438 
439         return _tokensReceived;
440     }
441 
442     /**
443      * @dev Calculate token sell value.
444      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
445      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
446      */
447     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
448         uint256 tokens_ = (_tokens + 1e18);
449         uint256 _tokenSupply = (tokenSupply_ + 1e18);
450         uint256 _etherReceived =
451         (
452             // underflow attempts BTFO
453             SafeMath.sub(
454                 (
455                     (
456                         (
457                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
458                         ) - tokenPriceIncremental_
459                     ) * (tokens_ - 1e18)
460                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
461             )
462         / 1e18);
463 
464         return _etherReceived;
465     }
466 
467     /// @dev This is where all your gas goes.
468     function sqrt(uint256 x) internal pure returns (uint256 y) {
469         uint256 z = (x + 1) / 2;
470         y = x;
471 
472         while (z < y) {
473             y = z;
474             z = (x / z + z) / 2;
475         }
476     }
477 
478 
479 }
480 
481 /**
482  * @title SafeMath
483  * @dev Math operations with safety checks that throw on error
484  */
485 library SafeMath {
486 
487     /**
488     * @dev Multiplies two numbers, throws on overflow.
489     */
490     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
491         if (a == 0) {
492             return 0;
493         }
494         uint256 c = a * b;
495         assert(c / a == b);
496         return c;
497     }
498 
499     /**
500     * @dev Integer division of two numbers, truncating the quotient.
501     */
502     function div(uint256 a, uint256 b) internal pure returns (uint256) {
503         // assert(b > 0); // Solidity automatically throws when dividing by 0
504         uint256 c = a / b;
505         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
506         return c;
507     }
508 
509     /**
510     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
511     */
512     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
513         assert(b <= a);
514         return a - b;
515     }
516 
517     /**
518     * @dev Adds two numbers, throws on overflow.
519     */
520     function add(uint256 a, uint256 b) internal pure returns (uint256) {
521         uint256 c = a + b;
522         assert(c >= a);
523         return c;
524     }
525 
526 }