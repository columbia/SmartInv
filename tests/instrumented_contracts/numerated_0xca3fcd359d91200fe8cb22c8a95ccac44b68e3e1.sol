1 pragma solidity ^0.4.20;
2 
3 /*
4 ===================================
5     ____
6    / __ \ ____   ____   ____   __  __
7   / /_/ // __ \ / __ \ / __ \ / / / /
8  / ____// /_/ // /_/ // /_/ // /_/ /
9 /_/     \____// .___// .___/ \__, /
10              /_/    /_/     /____/
11 
12 Proof of Purchases Providing Yields
13 ===================================
14 
15 This application uses open source code,
16 we acknowledge and are grateful to the developers of the original PoWH 3D.
17 
18 Visit 0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe to learn more.
19 */
20 
21 contract Poppy {
22 
23     modifier onlyTokenHolders() {
24         require(myTokens() > 0);
25         _;
26     }
27 
28     modifier onlyProfitHolders() {
29         require(myDividends(true) > 0);
30         _;
31     }
32 
33     modifier onlyAdministrator(){
34         address _customerAddress = msg.sender;
35         require(administrators[keccak256(_customerAddress)]);
36         _;
37     }
38 
39     event onTokenPurchase(
40         address indexed customerAddress,
41         uint256 incomingEthereum,
42         uint256 tokensMinted,
43         address indexed referredBy
44     );
45 
46     event onTokenSell(
47         address indexed customerAddress,
48         uint256 tokensBurned,
49         uint256 ethereumEarned
50     );
51 
52     event onReinvestment(
53         address indexed customerAddress,
54         uint256 ethereumReinvested,
55         uint256 tokensMinted
56     );
57 
58     event onWithdraw(
59         address indexed customerAddress,
60         uint256 ethereumWithdrawn
61     );
62 
63     event Transfer(
64         address indexed from,
65         address indexed to,
66         uint256 tokens
67     );
68 
69     string public name = "Poppy";
70     string public symbol = "XPY";
71     uint8 constant public decimals = 18;
72     uint8 constant internal dividendFee_ = 100;
73     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
74     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
75     uint256 constant internal magnitude = 2**64;
76 
77     uint256 public stakingRequirement = 100e18;
78 
79     mapping(address => uint256) internal tokenBalanceLedger_;
80     mapping(address => uint256) internal referralBalance_;
81     mapping(address => int256) internal payoutsTo_;
82     uint256 internal tokenSupply_ = 0;
83     uint256 internal profitPerShare_;
84 
85     mapping(bytes32 => bool) public administrators;
86 
87     function Poppy()
88         public
89     {
90         administrators[0x4543c2cf87cc692c1b7ebfef60c9cd7f9e3d2813f276079bc1b5eba1007ada51] = true;
91     }
92 
93     function buy(address _referredBy)
94         public
95         payable
96         returns(uint256)
97     {
98         purchaseTokens(msg.value, _referredBy);
99     }
100 
101     function()
102         payable
103         public
104     {
105         purchaseTokens(msg.value, 0x0);
106     }
107 
108     function reinvest()
109         onlyProfitHolders()
110         public
111     {
112 
113         uint256 _dividends = myDividends(false);
114 
115         address _customerAddress = msg.sender;
116         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
117 
118         _dividends += referralBalance_[_customerAddress];
119         referralBalance_[_customerAddress] = 0;
120 
121         uint256 _tokens = purchaseTokens(_dividends, 0x0);
122 
123         onReinvestment(_customerAddress, _dividends, _tokens);
124     }
125 
126     function exit()
127         public
128     {
129         address _customerAddress = msg.sender;
130         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
131         if(_tokens > 0) sell(_tokens);
132 
133         withdraw();
134     }
135 
136     function withdraw()
137         onlyProfitHolders()
138         public
139     {
140         address _customerAddress = msg.sender;
141         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
142 
143         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
144 
145         _dividends += referralBalance_[_customerAddress];
146         referralBalance_[_customerAddress] = 0;
147 
148         _customerAddress.transfer(_dividends);
149 
150         onWithdraw(_customerAddress, _dividends);
151     }
152 
153     function sell(uint256 _amountOfTokens)
154         onlyTokenHolders()
155         public
156     {
157 
158         address _customerAddress = msg.sender;
159         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
160         uint256 _tokens = _amountOfTokens;
161         uint256 _ethereum = tokensToEthereum_(_tokens);
162         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
163         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
164 
165         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
166         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
167 
168         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
169         payoutsTo_[_customerAddress] -= _updatedPayouts;
170 
171         if (tokenSupply_ > 0) {
172             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
173         }
174 
175         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
176     }
177 
178     function transfer(address _toAddress, uint256 _amountOfTokens)
179         onlyTokenHolders()
180         public
181         returns(bool)
182     {
183 
184         address _customerAddress = msg.sender;
185 
186         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
187 
188         if(myDividends(true) > 0) withdraw();
189 
190         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
191         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
192         uint256 _dividends = tokensToEthereum_(_tokenFee);
193 
194         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
195 
196         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
197         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
198 
199         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
200         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
201 
202         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
203 
204         Transfer(_customerAddress, _toAddress, _taxedTokens);
205 
206         return true;
207 
208     }
209 
210     function setAdministrator(bytes32 _identifier, bool _status)
211         onlyAdministrator()
212         public
213     {
214         administrators[_identifier] = _status;
215     }
216 
217     function setStakingRequirement(uint256 _amountOfTokens)
218         onlyAdministrator()
219         public
220     {
221         stakingRequirement = _amountOfTokens;
222     }
223 
224     function setName(string _name)
225         onlyAdministrator()
226         public
227     {
228         name = _name;
229     }
230 
231     function setSymbol(string _symbol)
232         onlyAdministrator()
233         public
234     {
235         symbol = _symbol;
236     }
237 
238     function totalEthereumBalance()
239         public
240         view
241         returns(uint)
242     {
243         return this.balance;
244     }
245 
246     function totalSupply()
247         public
248         view
249         returns(uint256)
250     {
251         return tokenSupply_;
252     }
253 
254     function myTokens()
255         public
256         view
257         returns(uint256)
258     {
259         address _customerAddress = msg.sender;
260         return balanceOf(_customerAddress);
261     }
262 
263     function myDividends(bool _includeReferralBonus)
264         public
265         view
266         returns(uint256)
267     {
268         address _customerAddress = msg.sender;
269         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
270     }
271 
272     function balanceOf(address _customerAddress)
273         view
274         public
275         returns(uint256)
276     {
277         return tokenBalanceLedger_[_customerAddress];
278     }
279 
280     function dividendsOf(address _customerAddress)
281         view
282         public
283         returns(uint256)
284     {
285         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
286     }
287 
288     function sellPrice()
289         public
290         view
291         returns(uint256)
292     {
293         if(tokenSupply_ == 0){
294             return tokenPriceInitial_ - tokenPriceIncremental_;
295         } else {
296             uint256 _ethereum = tokensToEthereum_(1e18);
297             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
298             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
299             return _taxedEthereum;
300         }
301     }
302 
303     function buyPrice()
304         public
305         view
306         returns(uint256)
307     {
308         if(tokenSupply_ == 0){
309             return tokenPriceInitial_ + tokenPriceIncremental_;
310         } else {
311             uint256 _ethereum = tokensToEthereum_(1e18);
312             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
313             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
314             return _taxedEthereum;
315         }
316     }
317 
318     function calculateTokensReceived(uint256 _ethereumToSpend)
319         public
320         view
321         returns(uint256)
322     {
323         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
324         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
325         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
326 
327         return _amountOfTokens;
328     }
329 
330     function calculateEthereumReceived(uint256 _tokensToSell)
331         public
332         view
333         returns(uint256)
334     {
335         require(_tokensToSell <= tokenSupply_);
336         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
337         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
338         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
339         return _taxedEthereum;
340     }
341 
342     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
343         internal
344         returns(uint256)
345     {
346         address _customerAddress = msg.sender;
347         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
348         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
349         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
350         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
351         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
352         uint256 _fee = _dividends * magnitude;
353 
354         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
355 
356         if(
357             _referredBy != 0x0000000000000000000000000000000000000000 &&
358 
359             _referredBy != _customerAddress &&
360 
361             tokenBalanceLedger_[_referredBy] >= stakingRequirement
362         ){
363             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
364         } else {
365             _dividends = SafeMath.add(_dividends, _referralBonus);
366             _fee = _dividends * magnitude;
367         }
368 
369         if(tokenSupply_ > 0){
370 
371             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
372 
373             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
374 
375             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
376 
377         } else {
378             tokenSupply_ = _amountOfTokens;
379         }
380         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
381 
382         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
383         payoutsTo_[_customerAddress] += _updatedPayouts;
384 
385         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
386 
387         return _amountOfTokens;
388     }
389 
390     function ethereumToTokens_(uint256 _ethereum)
391         internal
392         view
393         returns(uint256)
394     {
395         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
396         uint256 _tokensReceived =
397          (
398             (
399                 SafeMath.sub(
400                     (sqrt
401                         (
402                             (_tokenPriceInitial**2)
403                             +
404                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
405                             +
406                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
407                             +
408                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
409                         )
410                     ), _tokenPriceInitial
411                 )
412             )/(tokenPriceIncremental_)
413         )-(tokenSupply_)
414         ;
415 
416         return _tokensReceived;
417     }
418 
419      function tokensToEthereum_(uint256 _tokens)
420         internal
421         view
422         returns(uint256)
423     {
424 
425         uint256 tokens_ = (_tokens + 1e18);
426         uint256 _tokenSupply = (tokenSupply_ + 1e18);
427         uint256 _etherReceived =
428         (
429             SafeMath.sub(
430                 (
431                     (
432                         (
433                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
434                         )-tokenPriceIncremental_
435                     )*(tokens_ - 1e18)
436                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
437             )
438         /1e18);
439         return _etherReceived;
440     }
441 
442     function sqrt(uint x) internal pure returns (uint y) {
443         uint z = (x + 1) / 2;
444         y = x;
445         while (z < y) {
446             y = z;
447             z = (x / z + z) / 2;
448         }
449     }
450 }
451 
452 library SafeMath {
453 
454     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
455         if (a == 0) {
456             return 0;
457         }
458         uint256 c = a * b;
459         assert(c / a == b);
460         return c;
461     }
462 
463     function div(uint256 a, uint256 b) internal pure returns (uint256) {
464         uint256 c = a / b;
465         return c;
466     }
467 
468     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
469         assert(b <= a);
470         return a - b;
471     }
472 
473     function add(uint256 a, uint256 b) internal pure returns (uint256) {
474         uint256 c = a + b;
475         assert(c >= a);
476         return c;
477     }
478 }