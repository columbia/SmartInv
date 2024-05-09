1 pragma solidity ^0.4.13;
2 
3 contract AcceptsProofofHumanity {
4     E25 public tokenContract;
5 
6     function AcceptsProofofHumanity(address _tokenContract) public {
7         tokenContract = E25(_tokenContract);
8     }
9 
10     modifier onlyTokenContract { 
11         require(msg.sender == address(tokenContract));
12         _;
13     }
14 
15     
16     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
17 }
18 
19 
20 contract E25 {
21   
22     modifier onlyBagholders() {
23         require(myTokens() > 0);
24         _;
25     }
26 
27     modifier onlyStronghands() {
28         require(myDividends(true) > 0);
29         _;
30     }
31 
32     modifier notContract() {
33       require (msg.sender == tx.origin);
34       _;
35     }
36 
37   
38     modifier onlyAdministrator(){
39         address _customerAddress = msg.sender;
40         require(administrators[_customerAddress]);
41         _;
42     }
43   
44     event onTokenPurchase(
45         address indexed customerAddress,
46         uint256 incomingEthereum,
47         uint256 tokensMinted,
48         address indexed referredBy
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
68   
69     event Transfer(
70         address indexed from,
71         address indexed to,
72         uint256 tokens
73     );
74 
75 
76    
77     string public name = "E25";
78     string public symbol = "E25";
79     uint8 constant public decimals = 18;
80     uint8 constant internal dividendFee_ = 21;
81     uint8 constant internal charityFee_ = 4;
82     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
83     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
84     uint256 constant internal magnitude = 2**64;
85 
86     
87     address constant public giveEthCharityAddress = 0x9f8162583f7Da0a35a5C00e90bb15f22DcdE41eD;
88     uint256 public totalEthCharityRecieved; 
89     uint256 public totalEthCharityCollected; 
90 
91     uint256 public stakingRequirement = 100e18;
92     mapping(address => uint256) internal tokenBalanceLedger_;
93     mapping(address => uint256) internal referralBalance_;
94     mapping(address => int256) internal payoutsTo_;
95    
96     uint256 internal tokenSupply_ = 0;
97     uint256 internal profitPerShare_;
98     mapping(address => bool) public administrators;
99 
100 
101     mapping(address => bool) public canAcceptTokens_; 
102 
103     function E25()
104         public
105     {
106   
107         
108     }
109 
110 
111    
112     function buy(address _referredBy)
113         public
114         payable
115         returns(uint256)
116     {
117         purchaseInternal(msg.value, _referredBy);
118     }
119 
120    
121     function()
122         payable
123         public
124     {
125         purchaseInternal(msg.value, 0x0);
126     }
127 
128    
129     function payCharity() payable public {
130       uint256 ethToPay = SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);
131       require(ethToPay > 1);
132       totalEthCharityRecieved = SafeMath.add(totalEthCharityRecieved, ethToPay);
133       if(!giveEthCharityAddress.call.value(ethToPay).gas(400000)()) {
134          totalEthCharityRecieved = SafeMath.sub(totalEthCharityRecieved, ethToPay);
135       }
136     }
137 
138    
139     function reinvest()
140         onlyStronghands()
141         public
142     {
143         uint256 _dividends = myDividends(false); 
144         address _customerAddress = msg.sender;
145         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
146         _dividends += referralBalance_[_customerAddress];
147         referralBalance_[_customerAddress] = 0;
148         uint256 _tokens = purchaseTokens(_dividends, 0x0);
149 
150         onReinvestment(_customerAddress, _dividends, _tokens);
151     }
152 
153     
154     function exit()
155         public
156     {
157         
158         address _customerAddress = msg.sender;
159         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
160         if(_tokens > 0) sell(_tokens);
161 
162         
163         withdraw();
164     }
165 
166    
167     function withdraw()
168         onlyStronghands()
169         public
170     {
171        
172         address _customerAddress = msg.sender;
173         uint256 _dividends = myDividends(false); 
174 
175        
176         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
177 
178        
179         _dividends += referralBalance_[_customerAddress];
180         referralBalance_[_customerAddress] = 0;
181 
182         
183         _customerAddress.transfer(_dividends);
184 
185         
186         onWithdraw(_customerAddress, _dividends);
187     }
188 
189    
190     function sell(uint256 _amountOfTokens)
191         onlyBagholders()
192         public
193     {
194        
195         address _customerAddress = msg.sender;
196        
197         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
198         uint256 _tokens = _amountOfTokens;
199         uint256 _ethereum = tokensToEthereum_(_tokens);
200 
201         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
202         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
203 
204         
205         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
206 
207        
208         totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);
209 
210         
211         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
212         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
213 
214         
215         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
216         payoutsTo_[_customerAddress] -= _updatedPayouts;
217 
218         
219         if (tokenSupply_ > 0) {
220             
221             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
222         }
223 
224        
225         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
226     }
227 
228 
229   
230     function transfer(address _toAddress, uint256 _amountOfTokens)
231         onlyBagholders()
232         public
233         returns(bool)
234     {
235         
236         address _customerAddress = msg.sender;
237 
238        
239         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
240 
241         if(myDividends(true) > 0) withdraw();
242 
243         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
244         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
245         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
246         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
247 
248         Transfer(_customerAddress, _toAddress, _amountOfTokens);
249 
250        
251         return true;
252     }
253 
254    
255     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
256       require(_to != address(0));
257       require(canAcceptTokens_[_to] == true); 
258       require(transfer(_to, _value)); 
259 
260       if (isContract(_to)) {
261         AcceptsProofofHumanity receiver = AcceptsProofofHumanity(_to);
262         require(receiver.tokenFallback(msg.sender, _value, _data));
263       }
264 
265       return true;
266     }
267 
268      function isContract(address _addr) private view returns (bool is_contract) {
269       
270        uint length;
271        assembly { length := extcodesize(_addr) }
272        return length > 0;
273      }
274 
275   
276     
277     function totalEthereumBalance()
278         public
279         view
280         returns(uint)
281     {
282         return this.balance;
283     }
284 
285     
286     function totalSupply()
287         public
288         view
289         returns(uint256)
290     {
291         return tokenSupply_;
292     }
293 
294     
295     function myTokens()
296         public
297         view
298         returns(uint256)
299     {
300         address _customerAddress = msg.sender;
301         return balanceOf(_customerAddress);
302     }
303 
304    
305     function myDividends(bool _includeReferralBonus)
306         public
307         view
308         returns(uint256)
309     {
310         address _customerAddress = msg.sender;
311         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
312     }
313 
314    
315     function balanceOf(address _customerAddress)
316         view
317         public
318         returns(uint256)
319     {
320         return tokenBalanceLedger_[_customerAddress];
321     }
322 
323  function dividendsOf(address _customerAddress)
324         view
325         public
326         returns(uint256)
327     {
328         return (uint256) ((int256)(SafeMath.mul(profitPerShare_ ,tokenBalanceLedger_[_customerAddress])) - payoutsTo_[_customerAddress]) / magnitude;
329     }
330 
331     
332     function sellPrice()
333         public
334         view
335         returns(uint256)
336     {
337         
338         if(tokenSupply_ == 0){
339             return tokenPriceInitial_ - tokenPriceIncremental_;
340         } else {
341             uint256 _ethereum = tokensToEthereum_(1e18);
342             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
343             uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
344             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
345             return _taxedEthereum;
346         }
347     }
348 
349    
350     function buyPrice()
351         public
352         view
353         returns(uint256)
354     {
355         
356         if(tokenSupply_ == 0){
357             return tokenPriceInitial_ + tokenPriceIncremental_;
358         } else {
359             uint256 _ethereum = tokensToEthereum_(1e18);
360             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
361             uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
362             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _charityPayout);
363             return _taxedEthereum;
364         }
365     }
366 
367   
368     function calculateTokensReceived(uint256 _ethereumToSpend)
369         public
370         view
371         returns(uint256)
372     {
373         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
374         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, charityFee_), 100);
375         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _charityPayout);
376         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
377         return _amountOfTokens;
378     }
379 
380    
381     function calculateEthereumReceived(uint256 _tokensToSell)
382         public
383         view
384         returns(uint256)
385     {
386         require(_tokensToSell <= tokenSupply_);
387         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
388         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
389         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
390         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
391         return _taxedEthereum;
392     }
393 
394     
395     function etherToSendCharity()
396         public
397         view
398         returns(uint256) {
399         return SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);
400     }
401 
402 
403     
404     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
405       notContract()
406       internal
407       returns(uint256) {
408 
409       uint256 purchaseEthereum = _incomingEthereum;
410       uint256 excess;
411       if(purchaseEthereum > 5 ether) { 
412           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { 
413               purchaseEthereum = 5 ether;
414               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
415           }
416       }
417 
418       purchaseTokens(purchaseEthereum, _referredBy);
419 
420       if (excess > 0) {
421         msg.sender.transfer(excess);
422       }
423     }
424 
425 
426     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
427         internal
428         returns(uint256)
429     {
430         
431         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
432         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
433         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, charityFee_), 100);
434         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
435         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _charityPayout);
436 
437         totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);
438 
439         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
440         uint256 _fee = _dividends * magnitude;
441 
442         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
443 
444         
445         if(
446             
447             _referredBy != 0x0000000000000000000000000000000000000000 &&
448 
449            
450             _referredBy != msg.sender &&
451 
452           
453             tokenBalanceLedger_[_referredBy] >= stakingRequirement
454         ){
455             
456             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
457         } else {
458           
459             _dividends = SafeMath.add(_dividends, _referralBonus);
460             _fee = _dividends * magnitude;
461         }
462 
463         
464         if(tokenSupply_ > 0){
465 
466            
467             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
468 
469             
470             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
471 
472            
473             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
474 
475         } else {
476            
477             tokenSupply_ = _amountOfTokens;
478         }
479 
480        
481         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
482 
483        
484         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
485         payoutsTo_[msg.sender] += _updatedPayouts;
486 
487         
488         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
489 
490         return _amountOfTokens;
491     }
492 
493   
494     function ethereumToTokens_(uint256 _ethereum)
495         internal
496         view
497         returns(uint256)
498     {
499         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
500         uint256 _tokensReceived =
501          (
502             (
503               
504                 SafeMath.sub(
505                     (sqrt
506                         (
507                             (_tokenPriceInitial**2)
508                             +
509                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
510                             +
511                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
512                             +
513                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
514                         )
515                     ), _tokenPriceInitial
516                 )
517             )/(tokenPriceIncremental_)
518         )-(tokenSupply_)
519         ;
520 
521         return _tokensReceived;
522     }
523 
524  
525      function tokensToEthereum_(uint256 _tokens)
526         internal
527         view
528         returns(uint256)
529     {
530 
531         uint256 tokens_ = (_tokens + 1e18);
532         uint256 _tokenSupply = (tokenSupply_ + 1e18);
533         uint256 _etherReceived =
534         (
535             
536             SafeMath.sub(
537                 (
538                     (
539                         (
540                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
541                         )-tokenPriceIncremental_
542                     )*(tokens_ - 1e18)
543                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
544             )
545         /1e18);
546         return _etherReceived;
547     }
548 
549 
550     function sqrt(uint x) internal pure returns (uint y) {
551         uint z = (x + 1) / 2;
552         y = x;
553         while (z < y) {
554             y = z;
555             z = (x / z + z) / 2;
556         }
557     }
558 }
559 
560 
561 library SafeMath {
562 
563  
564     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
565         if (a == 0) {
566             return 0;
567         }
568         uint256 c = a * b;
569         assert(c / a == b);
570         return c;
571     }
572 
573   
574     function div(uint256 a, uint256 b) internal pure returns (uint256) {
575         
576         uint256 c = a / b;
577       
578         return c;
579     }
580 
581    
582     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
583         assert(b <= a);
584         return a - b;
585     }
586 
587   
588     function add(uint256 a, uint256 b) internal pure returns (uint256) {
589         uint256 c = a + b;
590         assert(c >= a);
591         return c;
592     }
593 }