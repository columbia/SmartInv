1 pragma solidity ^0.4.25;
2  
3 /*
4 *
5 * Eth Exchange by AceWins.io
6 * 24% Buy Fees
7 * 24% Sell Fees
8 * 1% Transfer Fees
9 * 8% Affiliate Commission
10 * 0.10% Daily Interest (As long as sufficient ETH is available in the allocated pool)
11 * Website: https://www.acedapp.net
12 * Casino Website: https://www.acewins.io
13 */
14 
15 
16 contract Ownable {
17     
18     address public owner;
19 
20     constructor() public {
21         owner = msg.sender;
22     }
23     
24 
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30 }
31 
32 
33 contract AceDapp is Ownable{
34     using SafeMath for uint256;
35     
36      modifier onlyBagholders {
37         require(myTokens() > 0);
38         _;
39     }
40       
41      modifier onlyStronghands {
42         require(myDividends(true) > 0);
43         _;
44     }
45     
46    
47       
48     event onTokenPurchase(
49         address indexed customerAddress,
50         uint256 incomingEthereum,
51         uint256 tokensMinted,
52         address indexed referredBy,
53         uint timestamp,
54         uint256 price
55 );
56 
57     event onTokenSell(
58         address indexed customerAddress,
59         uint256 tokensBurned,
60         uint256 ethereumEarned,
61         uint timestamp,
62         uint256 price
63 );
64 
65     event onReinvestment(
66         address indexed customerAddress,
67         uint256 ethereumReinvested,
68         uint256 tokensMinted
69 );
70 
71     event onWithdraw(
72         address indexed customerAddress,
73         uint256 ethereumWithdrawn
74 );
75 
76     event Transfer(
77         address indexed from,
78         address indexed to,
79         uint256 tokens
80 );
81 
82     string public name = "ETH Exchange";
83     string public symbol = "ATH";
84     uint8 constant public decimals = 18;
85     uint8 constant internal entryFee_ = 29; //Includes the dev fee & the money alloted for the daily fixed interest. 24% is the actual fee charged for buy.
86     uint8 constant internal transferFee_ = 1;
87     uint8 constant internal ExitFee_ = 24; 
88     uint8 constant internal refferalFee_ = 8;
89     uint8 constant internal DevFee_ = 15; //Actual dev fee is only 1.5%. This value will be divided by 10 and used. Since we cannot use a decimal here, a round number is used.
90     uint8 constant internal DailyInterest_ = 1; 
91     uint8 constant internal IntFee_ = 35; //This value will be divided by 10 and used. Since we cannot use a decimal here, a round number is used.
92     uint256 public InterestPool_ = 0; 
93     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
94     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
95     uint256 constant internal magnitude = 2**64;
96     uint256 public stakingRequirement = 50e18;
97   
98     
99     mapping(address => uint256) internal tokenBalanceLedger_;
100     mapping(address => uint256) internal referralBalance_;
101     mapping(address => int256) internal payoutsTo_;
102     uint256 internal tokenSupply_;
103     uint256 internal profitPerShare_;
104     address dev = 0xA4d05a1c22C8Abe6CCB2333C092EC80bd0955031;
105     
106 
107         function buy(address _referredBy) public payable returns (uint256) {
108         uint256 DevFee1 = msg.value.div(100).mul(DevFee_);
109         uint256 DevFeeFinal = SafeMath.div(DevFee1, 10);
110         dev.transfer(DevFeeFinal);
111         uint256 DailyInt1 = msg.value.div(100).mul(IntFee_);
112         uint256 DailyIntFinal = SafeMath.div(DailyInt1, 10);
113         InterestPool_ += DailyIntFinal;
114         purchaseTokens(msg.value, _referredBy);
115     }
116     
117         function() payable public {
118         uint256 DevFee1 = msg.value.div(100).mul(DevFee_);
119         uint256 DevFeeFinal = SafeMath.div(DevFee1, 10);
120         dev.transfer(DevFeeFinal);
121         uint256 DailyInt1 = msg.value.div(100).mul(IntFee_);
122         uint256 DailyIntFinal = SafeMath.div(DailyInt1, 10);
123         InterestPool_ += DailyIntFinal;
124         purchaseTokens(msg.value, 0x0);
125     }
126     
127         function IDD() public {
128         require(msg.sender==owner);
129         uint256 Contract_Bal = SafeMath.sub((address(this).balance), InterestPool_);
130         uint256 DailyInterest1 = SafeMath.div(SafeMath.mul(Contract_Bal, DailyInterest_), 100);   
131         uint256 DailyInterestFinal = SafeMath.div(DailyInterest1, 10);
132         InterestPool_ -= DailyInterestFinal;
133         DividendsDistribution(DailyInterestFinal, 0x0);
134      }
135     
136     function DivsAddon() public payable returns (uint256) {
137         DividendsDistribution(msg.value, 0x0);
138     }
139     
140     
141 
142         function reinvest() onlyStronghands public {
143         uint256 _dividends = myDividends(false);
144         address _customerAddress = msg.sender;
145         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
146         _dividends += referralBalance_[_customerAddress];
147         referralBalance_[_customerAddress] = 0;
148         uint256 _tokens = purchaseTokens(_dividends, 0x0);
149         emit onReinvestment(_customerAddress, _dividends, _tokens);
150     }
151 
152     function exit() public {
153         address _customerAddress = msg.sender;
154         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
155         if (_tokens > 0) sell(_tokens);
156         withdraw();
157     }
158 
159     function withdraw() onlyStronghands public {
160         address _customerAddress = msg.sender;
161         uint256 _dividends = myDividends(false);
162         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
163         _dividends += referralBalance_[_customerAddress];
164         referralBalance_[_customerAddress] = 0;
165         _customerAddress.transfer(_dividends);
166         emit onWithdraw(_customerAddress, _dividends);
167     }
168 
169     function sell(uint256 _amountOfTokens) onlyBagholders public {
170         address _customerAddress = msg.sender;
171         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
172         uint256 _tokens = _amountOfTokens;
173         uint256 _ethereum = tokensToEthereum_(_tokens);
174         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
175         uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 5), 100);
176         uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
177         uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
178         uint256 _devexitindividual = SafeMath.div(SafeMath.mul(_ethereum, DevFee_), 100);
179         uint256 _devexitindividual_final = SafeMath.div(_devexitindividual, 10);
180         uint256 DailyInt1 = SafeMath.div(SafeMath.mul(_ethereum, IntFee_), 100);
181         uint256 DailyIntFinal = SafeMath.div(DailyInt1, 10);
182         InterestPool_ += DailyIntFinal;
183         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
184         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
185         dev.transfer(_devexitindividual_final); 
186         
187         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
188         payoutsTo_[_customerAddress] -= _updatedPayouts;
189 
190         if (tokenSupply_ > 0) {
191             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
192         }
193         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
194     }
195 
196     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
197         address _customerAddress = msg.sender;
198         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
199 
200         if (myDividends(true) > 0) {
201             withdraw();
202         }
203 
204         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
205         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
206         uint256 _dividends = tokensToEthereum_(_tokenFee);
207 
208         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
209         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
210         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
211         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
212         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
213         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
214         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
215         return true;
216     }
217 
218 
219     function totalEthereumBalance() public view returns (uint256) {
220         return this.balance;
221     }
222 
223     function totalSupply() public view returns (uint256) {
224         return tokenSupply_;
225     }
226 
227     function myTokens() public view returns (uint256) {
228         address _customerAddress = msg.sender;
229         return balanceOf(_customerAddress);
230     }
231 
232     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
233         address _customerAddress = msg.sender;
234         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
235     }
236 
237     function balanceOf(address _customerAddress) public view returns (uint256) {
238         return tokenBalanceLedger_[_customerAddress];
239     }
240 
241     function dividendsOf(address _customerAddress) public view returns (uint256) {
242         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
243     }
244 
245     function sellPrice() public view returns (uint256) {
246         // our calculation relies on the token supply, so we need supply. Doh.
247         if (tokenSupply_ == 0) {
248             return tokenPriceInitial_ - tokenPriceIncremental_;
249         } else {
250             uint256 _ethereum = tokensToEthereum_(1e18);
251             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
252             uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 5), 100);
253             uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
254             uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
255             return _taxedEthereum;
256         }
257     }
258 
259     function buyPrice() public view returns (uint256) {
260         if (tokenSupply_ == 0) {
261             return tokenPriceInitial_ + tokenPriceIncremental_;
262         } else {
263             uint256 _ethereum = tokensToEthereum_(1e18);
264             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
265             uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 5), 100);
266             uint256 _taxedEthereum1 = SafeMath.add(_ethereum, _dividends);
267             uint256 _taxedEthereum = SafeMath.add(_taxedEthereum1, _devexit);
268             return _taxedEthereum;
269         }
270     }
271 
272     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
273         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
274         uint256 _devbuyfees = SafeMath.div(SafeMath.mul(_ethereumToSpend, 5), 100);
275         uint256 _taxedEthereum1 = SafeMath.sub(_ethereumToSpend, _dividends);
276         uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devbuyfees);
277         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
278         return _amountOfTokens;
279     }
280 
281     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
282         require(_tokensToSell <= tokenSupply_);
283         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
284         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
285         uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 5), 100);
286         uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
287         uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
288         return _taxedEthereum;
289     }
290 
291    function exitFee() public view returns (uint8) {
292         return ExitFee_;
293     }
294     
295 
296 
297   function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
298         address _customerAddress = msg.sender;
299         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
300         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
301         uint256 _devbuyfees = SafeMath.div(SafeMath.mul(_incomingEthereum, 5), 100);
302         uint256 _dividends1 = SafeMath.sub(_undividedDividends, _referralBonus);
303         uint256 _dividends = SafeMath.sub(_dividends1, _devbuyfees);
304         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
305         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
306         uint256 _fee = _dividends * magnitude;
307 
308         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
309 
310         if (
311             _referredBy != 0x0000000000000000000000000000000000000000 &&
312             _referredBy != _customerAddress &&
313             tokenBalanceLedger_[_referredBy] >= stakingRequirement
314         ) {
315             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
316         } else {
317             _dividends = SafeMath.add(_dividends, _referralBonus);
318             _fee = _dividends * magnitude;
319         }
320 
321         if (tokenSupply_ > 0) {
322             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
323             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
324             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
325         } else {
326             tokenSupply_ = _amountOfTokens;
327         }
328 
329         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
330         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
331         payoutsTo_[_customerAddress] += _updatedPayouts;
332         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
333 
334         return _amountOfTokens;
335     }
336 
337 
338        function DividendsDistribution(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
339         address _customerAddress = msg.sender;
340         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, 100), 100);
341         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
342         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
343         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
344         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
345         uint256 _fee = _dividends * magnitude;
346 
347         require(_amountOfTokens >= 0 && SafeMath.add(_amountOfTokens, tokenSupply_) >= tokenSupply_);
348 
349         if (
350             _referredBy != 0x0000000000000000000000000000000000000000 &&
351             _referredBy != _customerAddress &&
352             tokenBalanceLedger_[_referredBy] >= stakingRequirement
353         ) {
354             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
355         } else {
356             _dividends = SafeMath.add(_dividends, _referralBonus);
357             _fee = _dividends * magnitude;
358         }
359 
360         if (tokenSupply_ > 0) {
361             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
362             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
363             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
364         } else {
365             tokenSupply_ = _amountOfTokens;
366         }
367 
368         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
369         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
370         payoutsTo_[_customerAddress] += _updatedPayouts;
371         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
372 
373         return _amountOfTokens;
374     }
375 
376     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
377         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
378         uint256 _tokensReceived =
379             (
380                 (
381                     SafeMath.sub(
382                         (sqrt
383                             (
384                                 (_tokenPriceInitial ** 2)
385                                 +
386                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
387                                 +
388                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
389                                 +
390                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
391                             )
392                         ), _tokenPriceInitial
393                     )
394                 ) / (tokenPriceIncremental_)
395             ) - (tokenSupply_);
396 
397         return _tokensReceived;
398     }
399 
400     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
401         uint256 tokens_ = (_tokens + 1e18);
402         uint256 _tokenSupply = (tokenSupply_ + 1e18);
403         uint256 _etherReceived =
404             (
405                 SafeMath.sub(
406                     (
407                         (
408                             (
409                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
410                             ) - tokenPriceIncremental_
411                         ) * (tokens_ - 1e18)
412                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
413                 )
414                 / 1e18);
415 
416         return _etherReceived;
417     }
418 
419  
420 
421     function sqrt(uint256 x) internal pure returns (uint256 y) {
422         uint256 z = (x + 1) / 2;
423         y = x;
424 
425         while (z < y) {
426             y = z;
427             z = (x / z + z) / 2;
428         }
429     }
430 
431 
432 }
433 
434 library SafeMath {
435     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
436         if (a == 0) {
437             return 0;
438         }
439         uint256 c = a * b;
440         assert(c / a == b);
441         return c;
442     }
443 
444     function div(uint256 a, uint256 b) internal pure returns (uint256) {
445         uint256 c = a / b;
446         return c;
447     }
448 
449     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
450         assert(b <= a);
451         return a - b;
452     }
453 
454     function add(uint256 a, uint256 b) internal pure returns (uint256) {
455         uint256 c = a + b;
456         assert(c >= a);
457         return c;
458     }
459 }