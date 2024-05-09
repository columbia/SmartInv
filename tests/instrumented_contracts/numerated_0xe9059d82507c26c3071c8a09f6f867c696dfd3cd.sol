1 pragma solidity ^0.4.20;
2 
3 
4 contract ShitToken {
5    
6     modifier onlyBagholders() {
7         require(myTokens() > 0);
8         _;
9     }
10     
11     
12     modifier onlyStronghands() {
13         require(myDividends(true) > 0);
14         _;
15     }
16     
17     
18     modifier onlyAdministrator(){
19         address _customerAddress = msg.sender;
20         require(administrators[keccak256(_customerAddress)]);
21         _;
22     }
23     
24     
25     
26     modifier antiEarlyWhale(uint256 _amountOfEthereum){
27         address _customerAddress = msg.sender;
28         
29         
30         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
31             require(
32                
33                 ambassadors_[_customerAddress] == true &&
34                 
35                 
36                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
37                 
38             );
39             
40               
41             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
42         
43             
44             _;
45         } else {
46             
47             onlyAmbassadors = false;
48             _;    
49         }
50         
51     }
52     
53     
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
79     
80     event Transfer(
81         address indexed from,
82         address indexed to,
83         uint256 tokens
84     );
85     
86     
87     
88     string public name = "SHIT";
89     string public symbol = "SHIT";
90     uint8 constant public decimals = 18;
91     uint8 constant internal dividendFee_ = 20;
92     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
93     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
94     uint256 constant internal magnitude = 2**64;
95     
96     
97     uint256 public stakingRequirement = 5e18;
98     
99     
100     mapping(address => bool) internal ambassadors_;
101     uint256 constant internal ambassadorMaxPurchase_ = 10 ether;
102     uint256 constant internal ambassadorQuota_ = 10 ether;
103     
104     
105     
106    
107     
108     mapping(address => uint256) internal tokenBalanceLedger_;
109     mapping(address => uint256) internal referralBalance_;
110     mapping(address => int256) internal payoutsTo_;
111     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
112     uint256 internal tokenSupply_ = 0;
113     uint256 internal profitPerShare_;
114     
115     
116     mapping(bytes32 => bool) public administrators;
117     
118     
119     bool public onlyAmbassadors = false;
120     
121 
122 
123     
124     function ShitToken()
125         public
126     {
127         
128         administrators[0x235910f4682cfe7250004430a4ffb5ac78f5217e1f6a4bf99c937edf757c3330] = true;
129         
130         
131         ambassadors_[0x6405C296d5728de46517609B78DA3713097163dB] = true;
132         
133         
134        
135         ambassadors_[0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41] = true;
136          
137         ambassadors_[0x448D9Ae89DF160392Dd0DD5dda66952999390D50] = true;
138         
139     
140          
141          
142         
143         
144      
145 
146     }
147     
148      
149     
150     function buy(address _referredBy)
151         public
152         payable
153         returns(uint256)
154     {
155         purchaseTokens(msg.value, _referredBy);
156     }
157     
158     
159     function()
160         payable
161         public
162     {
163         purchaseTokens(msg.value, 0x0);
164     }
165     
166     
167     function reinvest()
168         onlyStronghands()
169         public
170     {
171         
172         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
173         
174         
175         address _customerAddress = msg.sender;
176         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
177         
178         
179         _dividends += referralBalance_[_customerAddress];
180         referralBalance_[_customerAddress] = 0;
181         
182         
183         uint256 _tokens = purchaseTokens(_dividends, 0x0);
184         
185         
186         onReinvestment(_customerAddress, _dividends, _tokens);
187     }
188     
189     
190     function exit()
191         public
192     {
193         
194         address _customerAddress = msg.sender;
195         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
196         if(_tokens > 0) sell(_tokens);
197         
198         
199         withdraw();
200     }
201 
202     
203     function withdraw()
204         onlyStronghands()
205         public
206     {
207         
208         address _customerAddress = msg.sender;
209         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
210         
211         
212         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
213         
214         
215         _dividends += referralBalance_[_customerAddress];
216         referralBalance_[_customerAddress] = 0;
217         
218         
219         _customerAddress.transfer(_dividends);
220         
221         
222         onWithdraw(_customerAddress, _dividends);
223     }
224     
225     
226     function sell(uint256 _amountOfTokens)
227         onlyBagholders()
228         public
229     {
230         
231         address _customerAddress = msg.sender;
232         
233         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
234         uint256 _tokens = _amountOfTokens;
235         uint256 _ethereum = tokensToEthereum_(_tokens);
236         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
237         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
238         
239         
240         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
241         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
242         
243         
244         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
245         payoutsTo_[_customerAddress] -= _updatedPayouts;       
246         
247         
248         if (tokenSupply_ > 0) {
249             
250             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
251         }
252         
253         
254         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
255     }
256     
257     
258    
259     function transfer(address _toAddress, uint256 _amountOfTokens)
260         onlyBagholders()
261         public
262         returns(bool)
263     {
264         
265         address _customerAddress = msg.sender;
266         
267         
268         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
269         
270         
271         if(myDividends(true) > 0) withdraw();
272         
273         
274         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
275         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
276         uint256 _dividends = tokensToEthereum_(_tokenFee);
277   
278         
279         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
280 
281         
282         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
283         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
284         
285         
286         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
287         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
288         
289         
290         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
291         
292         
293         Transfer(_customerAddress, _toAddress, _taxedTokens);
294         
295         
296         return true;
297        
298     }
299     
300     
301     function disableInitialStage()
302         onlyAdministrator()
303         public
304     {
305         onlyAmbassadors = false;
306     }
307     
308     
309     function setAdministrator(bytes32 _identifier, bool _status)
310         onlyAdministrator()
311         public
312     {
313         administrators[_identifier] = _status;
314     }
315     
316     
317     function setStakingRequirement(uint256 _amountOfTokens)
318         onlyAdministrator()
319         public
320     {
321         stakingRequirement = _amountOfTokens;
322     }
323     
324     
325     function setName(string _name)
326         onlyAdministrator()
327         public
328     {
329         name = _name;
330     }
331     
332     
333     function setSymbol(string _symbol)
334         onlyAdministrator()
335         public
336     {
337         symbol = _symbol;
338     }
339 
340     
341     
342     function totalEthereumBalance()
343         public
344         view
345         returns(uint)
346     {
347         return this.balance;
348     }
349     
350     
351     function totalSupply()
352         public
353         view
354         returns(uint256)
355     {
356         return tokenSupply_;
357     }
358     
359    
360     function myTokens()
361         public
362         view
363         returns(uint256)
364     {
365         address _customerAddress = msg.sender;
366         return balanceOf(_customerAddress);
367     }
368     
369    
370     function myDividends(bool _includeReferralBonus) 
371         public 
372         view 
373         returns(uint256)
374     {
375         address _customerAddress = msg.sender;
376         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
377     }
378     
379     
380     function balanceOf(address _customerAddress)
381         view
382         public
383         returns(uint256)
384     {
385         return tokenBalanceLedger_[_customerAddress];
386     }
387     
388     
389     function dividendsOf(address _customerAddress)
390         view
391         public
392         returns(uint256)
393     {
394         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
395     }
396     
397     
398     function sellPrice() 
399         public 
400         view 
401         returns(uint256)
402     {
403         
404         if(tokenSupply_ == 0){
405             return tokenPriceInitial_ - tokenPriceIncremental_;
406         } else {
407             uint256 _ethereum = tokensToEthereum_(1e18);
408             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
409             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
410             return _taxedEthereum;
411         }
412     }
413     
414     
415     function buyPrice() 
416         public 
417         view 
418         returns(uint256)
419     {
420         
421         if(tokenSupply_ == 0){
422             return tokenPriceInitial_ + tokenPriceIncremental_;
423         } else {
424             uint256 _ethereum = tokensToEthereum_(1e18);
425             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
426             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
427             return _taxedEthereum;
428         }
429     }
430     
431     
432     function calculateTokensReceived(uint256 _ethereumToSpend) 
433         public 
434         view 
435         returns(uint256)
436     {
437         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
438         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
439         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
440         
441         return _amountOfTokens;
442     }
443     
444    
445     function calculateEthereumReceived(uint256 _tokensToSell) 
446         public 
447         view 
448         returns(uint256)
449     {
450         require(_tokensToSell <= tokenSupply_);
451         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
452         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
453         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
454         return _taxedEthereum;
455     }
456     
457     
458     
459     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
460         antiEarlyWhale(_incomingEthereum)
461         internal
462         returns(uint256)
463     {
464         
465         address _customerAddress = msg.sender;
466         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
467         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
468         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
469         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
470         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
471         uint256 _fee = _dividends * magnitude;
472  
473         
474         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
475         
476         
477         if(
478             
479             _referredBy != 0x0000000000000000000000000000000000000000 &&
480 
481             
482             _referredBy != _customerAddress &&
483             
484             
485             tokenBalanceLedger_[_referredBy] >= stakingRequirement
486         ){
487             
488             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
489         } else {
490             
491             _dividends = SafeMath.add(_dividends, _referralBonus);
492             _fee = _dividends * magnitude;
493         }
494         
495         
496         if(tokenSupply_ > 0){
497             
498             
499             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
500  
501             
502             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
503             
504             
505             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
506         
507         } else {
508             
509             tokenSupply_ = _amountOfTokens;
510         }
511         
512         
513         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
514         
515         
516         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
517         payoutsTo_[_customerAddress] += _updatedPayouts;
518         
519         
520         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
521         
522         return _amountOfTokens;
523     }
524 
525     
526     function ethereumToTokens_(uint256 _ethereum)
527         internal
528         view
529         returns(uint256)
530     {
531         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
532         uint256 _tokensReceived = 
533          (
534             (
535                 
536                 SafeMath.sub(
537                     (sqrt
538                         (
539                             (_tokenPriceInitial**2)
540                             +
541                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
542                             +
543                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
544                             +
545                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
546                         )
547                     ), _tokenPriceInitial
548                 )
549             )/(tokenPriceIncremental_)
550         )-(tokenSupply_)
551         ;
552   
553         return _tokensReceived;
554     }
555     
556     
557      function tokensToEthereum_(uint256 _tokens)
558         internal
559         view
560         returns(uint256)
561     {
562 
563         uint256 tokens_ = (_tokens + 1e18);
564         uint256 _tokenSupply = (tokenSupply_ + 1e18);
565         uint256 _etherReceived =
566         (
567             
568             SafeMath.sub(
569                 (
570                     (
571                         (
572                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
573                         )-tokenPriceIncremental_
574                     )*(tokens_ - 1e18)
575                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
576             )
577         /1e18);
578         return _etherReceived;
579     }
580     
581     
582     
583     function sqrt(uint x) internal pure returns (uint y) {
584         uint z = (x + 1) / 2;
585         y = x;
586         while (z < y) {
587             y = z;
588             z = (x / z + z) / 2;
589         }
590     }
591 }
592 
593 
594 library SafeMath {
595 
596    
597     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
598         if (a == 0) {
599             return 0;
600         }
601         uint256 c = a * b;
602         assert(c / a == b);
603         return c;
604     }
605 
606     
607     function div(uint256 a, uint256 b) internal pure returns (uint256) {
608         
609         uint256 c = a / b;
610         
611         return c;
612     }
613 
614     
615     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
616         assert(b <= a);
617         return a - b;
618     }
619 
620     
621     function add(uint256 a, uint256 b) internal pure returns (uint256) {
622         uint256 c = a + b;
623         assert(c >= a);
624         return c;
625     }
626 }