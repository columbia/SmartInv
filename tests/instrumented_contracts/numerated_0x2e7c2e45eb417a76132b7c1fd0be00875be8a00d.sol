1 pragma solidity ^0.4.20;
2 
3 /*
4 * TimeChip.
5 *
6 * Here's the deal. The divisor is initially 4, which means 100/4 = 25% dividend rate.
7 * For every fifteen minutes that passes, the divisor increases by one. Once it hits 100 (1% rate), it resets to 4.
8 * After this, the divisor increases by 1 once per 24 hours, and the cycle continues.
9 *
10 * The token price will change as time passes as a result regardless of the amount people put in. Time is a legitimate factor.
11 * Factor updates every time a token purchase is made and sufficient time has passed. Want to update it? Buy a finney.
12 *
13 * Look sharp, everyone.
14 */
15 
16 contract TimeChip {
17 
18     modifier onlyBagholders() {
19         require(myTokens() > 0);
20         _;
21     }
22     
23     modifier onlyStronghands() {
24         require(myDividends(true) > 0);
25         _;
26     }
27 
28     modifier onlyAdministrator(){
29         address _customerAddress = msg.sender;
30         require(administrators[(_customerAddress)]);
31         _;
32     }
33     
34     modifier antiEarlyWhale(uint256 _amountOfEthereum){
35         address _customerAddress = msg.sender;
36         
37         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
38             require(
39                 ambassadors_[_customerAddress] == true &&
40                 
41                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
42                 
43             );
44              
45             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
46         
47             _;
48         } else {
49             onlyAmbassadors = false;
50             _;    
51         }
52         
53     }
54     
55     event onTokenPurchase(
56         address indexed customerAddress,
57         uint256 incomingEthereum,
58         uint256 tokensMinted,
59         address indexed referredBy
60     );
61     
62     event onTokenSell(
63         address indexed customerAddress,
64         uint256 tokensBurned,
65         uint256 ethereumEarned
66     );
67     
68     event onReinvestment(
69         address indexed customerAddress,
70         uint256 ethereumReinvested,
71         uint256 tokensMinted
72     );
73     
74     event onWithdraw(
75         address indexed customerAddress,
76         uint256 ethereumWithdrawn
77     );
78     
79     // ERC20
80     event Transfer(
81         address indexed from,
82         address indexed to,
83         uint256 tokens
84     );
85     
86     string public name = "Time Chip";
87     string public symbol = "SAND";
88     uint8 constant public decimals = 18;
89     uint256 internal dividendFee_ = 4;
90     uint256 internal launchTime = now;
91     uint256 internal secsPerStep = 900;
92     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
93     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
94     uint256 constant internal magnitude = 2**64;
95 
96 
97     uint256 public stakingRequirement = 1e18;
98     
99     mapping(address => bool) internal ambassadors_;
100     uint256 constant internal ambassadorMaxPurchase_ = 2.0 ether;
101     uint256 constant internal ambassadorQuota_ = 2.0 ether;
102     
103     mapping(address => uint256) internal tokenBalanceLedger_;
104     mapping(address => uint256) internal referralBalance_;
105     mapping(address => int256) internal payoutsTo_;
106     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
107     uint256 internal tokenSupply_ = 0;
108     uint256 internal profitPerShare_;
109     
110     mapping(address => bool) public administrators;
111     
112     bool public onlyAmbassadors = true;
113 
114     function TimeChip()
115         public
116     {
117         administrators[msg.sender] = true;
118         
119         ambassadors_[msg.sender] = true;
120         ambassadors_[0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB] = true; // Harry asked first, the rest of you weren't... IN TIME (ayyyy)
121         ambassadors_[0x283C19656a3D6B9f2A6e47029Ae3636df28d8601] = true; // This is new, for Oracle. If he wants in, he has to message me on CGT.
122         
123         launchTime = now;
124     }
125 
126     function buy(address _referredBy)
127         public
128         payable
129         returns(uint256)
130     {
131         purchaseTokens(msg.value, _referredBy);
132     }
133     
134     function()
135         payable
136         public
137     {
138         purchaseTokens(msg.value, 0x0);
139     }
140     
141     function reinvest()
142         onlyStronghands()
143         public
144     {
145         uint256 _dividends = myDividends(false);
146         
147         address _customerAddress = msg.sender;
148         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
149         
150         _dividends += referralBalance_[_customerAddress];
151         referralBalance_[_customerAddress] = 0;
152         
153         uint256 _tokens = purchaseTokens(_dividends, 0x0);
154         
155         onReinvestment(_customerAddress, _dividends, _tokens);
156     }
157 
158     function exit()
159         public
160     {
161         address _customerAddress = msg.sender;
162         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
163         if(_tokens > 0) sell(_tokens);
164         
165         withdraw();
166     }
167 
168     function withdraw()
169         onlyStronghands()
170         public
171     {
172         address _customerAddress = msg.sender;
173         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
174         
175         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
176         
177         _dividends += referralBalance_[_customerAddress];
178         referralBalance_[_customerAddress] = 0;
179         
180         _customerAddress.transfer(_dividends);
181         
182         onWithdraw(_customerAddress, _dividends);
183     }
184     
185     function sell(uint256 _amountOfTokens)
186         onlyBagholders()
187         public
188     {
189         address _customerAddress = msg.sender;
190         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
191         uint256 _tokens = _amountOfTokens;
192         uint256 _ethereum = tokensToEthereum_(_tokens);
193         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
194         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
195         
196         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
197         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
198         
199         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
200         payoutsTo_[_customerAddress] -= _updatedPayouts;       
201         
202         if (tokenSupply_ > 0) {
203             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
204         }
205         
206         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
207     }
208     
209     function transfer(address _toAddress, uint256 _amountOfTokens)
210         onlyBagholders()
211         public
212         returns(bool)
213     {
214         address _customerAddress = msg.sender;
215         
216         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
217         
218         if(myDividends(true) > 0) withdraw();
219         
220         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
221         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
222         uint256 _dividends = tokensToEthereum_(_tokenFee);
223   
224         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
225 
226         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
227         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
228         
229         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
230         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
231         
232         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
233         
234         Transfer(_customerAddress, _toAddress, _taxedTokens);
235         
236         return true;
237        
238     }
239     
240     function disableInitialStage()
241         onlyAdministrator()
242         public
243     {
244         onlyAmbassadors = false;
245         
246         launchTime = now;
247     }
248     
249     function setAdministrator(address _identifier, bool _status)
250         onlyAdministrator()
251         public
252     {
253         administrators[_identifier] = _status;
254     }
255     
256     function setStakingRequirement(uint256 _amountOfTokens)
257         onlyAdministrator()
258         public
259     {
260         stakingRequirement = _amountOfTokens;
261     }
262     
263     function resetLaunchTime()
264         onlyAdministrator()
265         public
266     {
267         launchTime = now;
268     }
269     
270     function setName(string _name)
271         onlyAdministrator()
272         public
273     {
274         name = _name;
275     }
276     
277     function setSymbol(string _symbol)
278         onlyAdministrator()
279         public
280     {
281         symbol = _symbol;
282     }
283 
284     
285     function totalEthereumBalance()
286         public
287         view
288         returns(uint)
289     {
290         return this.balance;
291     }
292     
293     function currentDividendRate()
294         public
295         view
296         returns(uint256)
297     {
298         return dividendFee_;
299     }
300     
301     function totalSupply()
302         public
303         view
304         returns(uint256)
305     {
306         return tokenSupply_;
307     }
308     
309     function myTokens()
310         public
311         view
312         returns(uint256)
313     {
314         address _customerAddress = msg.sender;
315         return balanceOf(_customerAddress);
316     }
317     
318     function myDividends(bool _includeReferralBonus) 
319         public 
320         view 
321         returns(uint256)
322     {
323         address _customerAddress = msg.sender;
324         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
325     }
326     
327     function balanceOf(address _customerAddress)
328         view
329         public
330         returns(uint256)
331     {
332         return tokenBalanceLedger_[_customerAddress];
333     }
334     
335     function dividendsOf(address _customerAddress)
336         view
337         public
338         returns(uint256)
339     {
340         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
341     }
342     
343     function sellPrice() 
344         public 
345         view 
346         returns(uint256)
347     {
348         if(tokenSupply_ == 0){
349             return tokenPriceInitial_ - tokenPriceIncremental_;
350         } else {
351             uint256 _ethereum = tokensToEthereum_(1e18);
352             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
353             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
354             return _taxedEthereum;
355         }
356     }
357     
358     function buyPrice() 
359         public 
360         view 
361         returns(uint256)
362     {
363         if(tokenSupply_ == 0){
364             return tokenPriceInitial_ + tokenPriceIncremental_;
365         } else {
366             uint256 _ethereum = tokensToEthereum_(1e18);
367             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
368             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
369             return _taxedEthereum;
370         }
371     }
372     
373     function calculateTokensReceived(uint256 _ethereumToSpend) 
374         public 
375         view 
376         returns(uint256)
377     {
378         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
379         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
380         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
381         
382         return _amountOfTokens;
383     }
384     
385     function calculateEthereumReceived(uint256 _tokensToSell) 
386         public 
387         view 
388         returns(uint256)
389     {
390         require(_tokensToSell <= tokenSupply_);
391         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
392         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
393         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
394         return _taxedEthereum;
395     }
396     
397     
398     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
399         antiEarlyWhale(_incomingEthereum)
400         internal
401         returns(uint256)
402     {
403         uint256 timeIncrement = SafeMath.div(SafeMath.sub(now, launchTime), secsPerStep);
404         
405         if (onlyAmbassadors) {
406             dividendFee_ = 4;
407         } else
408         {
409             if (timeIncrement > 96) {
410                 dividendFee_ = SafeMath.add(4, SafeMath.div(timeIncrement, 96));
411             } else {
412                 dividendFee_ = SafeMath.add(4, timeIncrement);   
413             }
414         }
415         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
416         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
417         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
418         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
419         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
420         uint256 _fee = _dividends * magnitude;
421  
422         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
423         
424         if(
425             _referredBy != 0x0000000000000000000000000000000000000000 &&
426 
427             _referredBy != msg.sender &&
428             
429             tokenBalanceLedger_[_referredBy] >= stakingRequirement
430         ){
431             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
432         } else {
433             _dividends = SafeMath.add(_dividends, _referralBonus);
434             _fee = _dividends * magnitude;
435         }
436         
437         if(tokenSupply_ > 0){
438             
439             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
440  
441             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
442             
443             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
444         
445         } else {
446             tokenSupply_ = _amountOfTokens;
447         }
448         
449         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
450         
451         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
452         payoutsTo_[msg.sender] += _updatedPayouts;
453         
454         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
455         
456         return _amountOfTokens;
457     }
458 
459     function ethereumToTokens_(uint256 _ethereum)
460         internal
461         view
462         returns(uint256)
463     {
464         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
465         uint256 _tokensReceived = 
466          (
467             (
468                 SafeMath.sub(
469                     (sqrt
470                         (
471                             (_tokenPriceInitial**2)
472                             +
473                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
474                             +
475                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
476                             +
477                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
478                         )
479                     ), _tokenPriceInitial
480                 )
481             )/(tokenPriceIncremental_)
482         )-(tokenSupply_)
483         ;
484   
485         return _tokensReceived;
486     }
487     
488      function tokensToEthereum_(uint256 _tokens)
489         internal
490         view
491         returns(uint256)
492     {
493 
494         uint256 tokens_ = (_tokens + 1e18);
495         uint256 _tokenSupply = (tokenSupply_ + 1e18);
496         uint256 _etherReceived =
497         (
498             SafeMath.sub(
499                 (
500                     (
501                         (
502                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
503                         )-tokenPriceIncremental_
504                     )*(tokens_ - 1e18)
505                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
506             )
507         /1e18);
508         return _etherReceived;
509     }
510     
511     function sqrt(uint x) internal pure returns (uint y) {
512         uint z = (x + 1) / 2;
513         y = x;
514         while (z < y) {
515             y = z;
516             z = (x / z + z) / 2;
517         }
518     }
519 }
520 
521 /**
522  * @title SafeMath
523  * @dev Math operations with safety checks that throw on error
524  */
525 library SafeMath {
526 
527     /**
528     * @dev Multiplies two numbers, throws on overflow.
529     */
530     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
531         if (a == 0) {
532             return 0;
533         }
534         uint256 c = a * b;
535         assert(c / a == b);
536         return c;
537     }
538 
539     /**
540     * @dev Integer division of two numbers, truncating the quotient.
541     */
542     function div(uint256 a, uint256 b) internal pure returns (uint256) {
543         // assert(b > 0); // Solidity automatically throws when dividing by 0
544         uint256 c = a / b;
545         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
546         return c;
547     }
548 
549     /**
550     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
551     */
552     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
553         assert(b <= a);
554         return a - b;
555     }
556 
557     /**
558     * @dev Adds two numbers, throws on overflow.
559     */
560     function add(uint256 a, uint256 b) internal pure returns (uint256) {
561         uint256 c = a + b;
562         assert(c >= a);
563         return c;
564     }
565 }