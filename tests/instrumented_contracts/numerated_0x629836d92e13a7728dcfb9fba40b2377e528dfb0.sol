1 pragma solidity ^0.4.25;
2  
3 
4 
5 
6 contract Ownable {
7     
8     address public owner;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13     
14 
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19 
20 }
21 
22 
23 contract CypherBank is Ownable{
24     using SafeMath for uint256;
25     
26      modifier onlyBagholders {
27         require(myTokens() > 0);
28         _;
29     }
30       
31      modifier onlyStronghands {
32         require(myDividends(true) > 0);
33         _;
34     }
35     
36    
37       
38     event onTokenPurchase(
39         address indexed customerAddress,
40         uint256 incomingEthereum,
41         uint256 tokensMinted,
42         address indexed referredBy,
43         uint timestamp,
44         uint256 price
45 );
46 
47     event onTokenSell(
48         address indexed customerAddress,
49         uint256 tokensBurned,
50         uint256 ethereumEarned,
51         uint timestamp,
52         uint256 price
53 );
54 
55     event onReinvestment(
56         address indexed customerAddress,
57         uint256 ethereumReinvested,
58         uint256 tokensMinted
59 );
60 
61     event onWithdraw(
62         address indexed customerAddress,
63         uint256 ethereumWithdrawn
64 );
65 
66     event Transfer(
67         address indexed from,
68         address indexed to,
69         uint256 tokens
70 );
71 
72     string public name = "Cypher Bank";
73     string public symbol = "CBT";
74     uint8 constant public decimals = 18;
75     uint8 constant internal entryFee_ = 15; //Includes the Dev Game fund & the money alloted for the daily fixed interest. 10% is the actual fee charged for buy.
76     uint8 constant internal transferFee_ = 1;
77     uint8 constant internal ExitFee_ = 20; 
78     uint8 constant internal refferalFee_ = 8;
79     uint8 constant internal DevFee_ = 25; //Dev Game fund, This value will be divided by 10 and used. Since we cannot use a decimal here, a round number is used.
80     uint8 constant internal DailyInterest_ = 1; 
81     uint8 constant internal IntFee_ = 25; //Vault Fund This value will be divided by 10 and used. Since we cannot use a decimal here, a round number is used.
82     uint256 public InterestPool_ = 0; 
83     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
84     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
85     uint256 constant internal magnitude = 2**64;
86     uint256 public stakingRequirement = 50e18;
87   
88     
89     mapping(address => uint256) internal tokenBalanceLedger_;
90     mapping(address => uint256) internal referralBalance_;
91     mapping(address => int256) internal payoutsTo_;
92     uint256 internal tokenSupply_;
93     uint256 internal profitPerShare_;
94     address dev = 0xbD4DA497c4F4B035935adb72c65302e6b9b19fd7;
95     
96 
97         function buy(address _referredBy) public payable returns (uint256) {
98         uint256 DevFee1 = msg.value.div(100).mul(DevFee_);
99         uint256 DevFeeFinal = SafeMath.div(DevFee1, 10);
100         dev.transfer(DevFeeFinal);
101         uint256 DailyInt1 = msg.value.div(100).mul(IntFee_);
102         uint256 DailyIntFinal = SafeMath.div(DailyInt1, 10);
103         InterestPool_ += DailyIntFinal;
104         purchaseTokens(msg.value, _referredBy);
105     }
106     
107         function() payable public {
108         uint256 DevFee1 = msg.value.div(100).mul(DevFee_);
109         uint256 DevFeeFinal = SafeMath.div(DevFee1, 10);
110         dev.transfer(DevFeeFinal);
111         uint256 DailyInt1 = msg.value.div(100).mul(IntFee_);
112         uint256 DailyIntFinal = SafeMath.div(DailyInt1, 10);
113         InterestPool_ += DailyIntFinal;
114         purchaseTokens(msg.value, 0x0);
115     }
116     
117         function IDD() public {
118         require(msg.sender==owner);
119         uint256 Contract_Bal = SafeMath.sub((address(this).balance), InterestPool_);
120         uint256 DailyInterest1 = SafeMath.div(SafeMath.mul(Contract_Bal, DailyInterest_), 100);   
121         uint256 DailyInterestFinal = SafeMath.div(DailyInterest1, 10);
122         InterestPool_ -= DailyInterestFinal;
123         DividendsDistribution(DailyInterestFinal, 0x0);
124      }
125     
126     function DivsAddon() public payable returns (uint256) {
127         DividendsDistribution(msg.value, 0x0);
128     }
129     
130     
131 
132         function reinvest() onlyStronghands public {
133         uint256 _dividends = myDividends(false);
134         address _customerAddress = msg.sender;
135         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
136         _dividends += referralBalance_[_customerAddress];
137         referralBalance_[_customerAddress] = 0;
138         uint256 _tokens = purchaseTokens(_dividends, 0x0);
139         emit onReinvestment(_customerAddress, _dividends, _tokens);
140     }
141 
142     function exit() public {
143         address _customerAddress = msg.sender;
144         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
145         if (_tokens > 0) sell(_tokens);
146         withdraw();
147     }
148 
149     function withdraw() onlyStronghands public {
150         address _customerAddress = msg.sender;
151         uint256 _dividends = myDividends(false);
152         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
153         _dividends += referralBalance_[_customerAddress];
154         referralBalance_[_customerAddress] = 0;
155         _customerAddress.transfer(_dividends);
156         emit onWithdraw(_customerAddress, _dividends);
157     }
158 
159     function sell(uint256 _amountOfTokens) onlyBagholders public {
160         address _customerAddress = msg.sender;
161         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
162         uint256 _tokens = _amountOfTokens;
163         uint256 _ethereum = tokensToEthereum_(_tokens);
164         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
165         uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 5), 100);
166         uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
167         uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
168         uint256 _devexitindividual = SafeMath.div(SafeMath.mul(_ethereum, DevFee_), 100);
169         uint256 _devexitindividual_final = SafeMath.div(_devexitindividual, 10);
170         uint256 DailyInt1 = SafeMath.div(SafeMath.mul(_ethereum, IntFee_), 100);
171         uint256 DailyIntFinal = SafeMath.div(DailyInt1, 10);
172         InterestPool_ += DailyIntFinal;
173         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
174         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
175         dev.transfer(_devexitindividual_final); 
176         
177         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
178         payoutsTo_[_customerAddress] -= _updatedPayouts;
179 
180         if (tokenSupply_ > 0) {
181             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
182         }
183         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
184     }
185 
186     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
187         address _customerAddress = msg.sender;
188         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
189 
190         if (myDividends(true) > 0) {
191             withdraw();
192         }
193 
194         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
195         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
196         uint256 _dividends = tokensToEthereum_(_tokenFee);
197 
198         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
199         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
200         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
201         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
202         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
203         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
204         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
205         return true;
206     }
207 
208 
209     function totalEthereumBalance() public view returns (uint256) {
210         return this.balance;
211     }
212 
213     function totalSupply() public view returns (uint256) {
214         return tokenSupply_;
215     }
216 
217     function myTokens() public view returns (uint256) {
218         address _customerAddress = msg.sender;
219         return balanceOf(_customerAddress);
220     }
221 
222     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
223         address _customerAddress = msg.sender;
224         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
225     }
226 
227     function balanceOf(address _customerAddress) public view returns (uint256) {
228         return tokenBalanceLedger_[_customerAddress];
229     }
230 
231     function dividendsOf(address _customerAddress) public view returns (uint256) {
232         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
233     }
234 
235     function sellPrice() public view returns (uint256) {
236         // our calculation relies on the token supply, so we need supply. Doh.
237         if (tokenSupply_ == 0) {
238             return tokenPriceInitial_ - tokenPriceIncremental_;
239         } else {
240             uint256 _ethereum = tokensToEthereum_(1e18);
241             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
242             uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 5), 100);
243             uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
244             uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
245             return _taxedEthereum;
246         }
247     }
248 
249     function buyPrice() public view returns (uint256) {
250         if (tokenSupply_ == 0) {
251             return tokenPriceInitial_ + tokenPriceIncremental_;
252         } else {
253             uint256 _ethereum = tokensToEthereum_(1e18);
254             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
255             uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 5), 100);
256             uint256 _taxedEthereum1 = SafeMath.add(_ethereum, _dividends);
257             uint256 _taxedEthereum = SafeMath.add(_taxedEthereum1, _devexit);
258             return _taxedEthereum;
259         }
260     }
261 
262     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
263         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
264         uint256 _devbuyfees = SafeMath.div(SafeMath.mul(_ethereumToSpend, 5), 100);
265         uint256 _taxedEthereum1 = SafeMath.sub(_ethereumToSpend, _dividends);
266         uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devbuyfees);
267         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
268         return _amountOfTokens;
269     }
270 
271     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
272         require(_tokensToSell <= tokenSupply_);
273         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
274         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
275         uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 5), 100);
276         uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
277         uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
278         return _taxedEthereum;
279     }
280 
281    function exitFee() public view returns (uint8) {
282         return ExitFee_;
283     }
284     
285 
286 
287   function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
288         address _customerAddress = msg.sender;
289         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
290         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
291         uint256 _devbuyfees = SafeMath.div(SafeMath.mul(_incomingEthereum, 5), 100);
292         uint256 _dividends1 = SafeMath.sub(_undividedDividends, _referralBonus);
293         uint256 _dividends = SafeMath.sub(_dividends1, _devbuyfees);
294         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
295         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
296         uint256 _fee = _dividends * magnitude;
297 
298         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
299 
300         if (
301             _referredBy != 0x0000000000000000000000000000000000000000 &&
302             _referredBy != _customerAddress &&
303             tokenBalanceLedger_[_referredBy] >= stakingRequirement
304         ) {
305             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
306         } else {
307             _dividends = SafeMath.add(_dividends, _referralBonus);
308             _fee = _dividends * magnitude;
309         }
310 
311         if (tokenSupply_ > 0) {
312             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
313             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
314             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
315         } else {
316             tokenSupply_ = _amountOfTokens;
317         }
318 
319         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
320         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
321         payoutsTo_[_customerAddress] += _updatedPayouts;
322         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
323 
324         return _amountOfTokens;
325     }
326 
327 
328        function DividendsDistribution(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
329         address _customerAddress = msg.sender;
330         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, 100), 100);
331         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
332         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
333         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
334         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
335         uint256 _fee = _dividends * magnitude;
336 
337         require(_amountOfTokens >= 0 && SafeMath.add(_amountOfTokens, tokenSupply_) >= tokenSupply_);
338 
339         if (
340             _referredBy != 0x0000000000000000000000000000000000000000 &&
341             _referredBy != _customerAddress &&
342             tokenBalanceLedger_[_referredBy] >= stakingRequirement
343         ) {
344             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
345         } else {
346             _dividends = SafeMath.add(_dividends, _referralBonus);
347             _fee = _dividends * magnitude;
348         }
349 
350         if (tokenSupply_ > 0) {
351             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
352             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
353             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
354         } else {
355             tokenSupply_ = _amountOfTokens;
356         }
357 
358         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
359         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
360         payoutsTo_[_customerAddress] += _updatedPayouts;
361         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
362 
363         return _amountOfTokens;
364     }
365 
366     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
367         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
368         uint256 _tokensReceived =
369             (
370                 (
371                     SafeMath.sub(
372                         (sqrt
373                             (
374                                 (_tokenPriceInitial ** 2)
375                                 +
376                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
377                                 +
378                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
379                                 +
380                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
381                             )
382                         ), _tokenPriceInitial
383                     )
384                 ) / (tokenPriceIncremental_)
385             ) - (tokenSupply_);
386 
387         return _tokensReceived;
388     }
389 
390     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
391         uint256 tokens_ = (_tokens + 1e18);
392         uint256 _tokenSupply = (tokenSupply_ + 1e18);
393         uint256 _etherReceived =
394             (
395                 SafeMath.sub(
396                     (
397                         (
398                             (
399                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
400                             ) - tokenPriceIncremental_
401                         ) * (tokens_ - 1e18)
402                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
403                 )
404                 / 1e18);
405 
406         return _etherReceived;
407     }
408 
409  
410 
411     function sqrt(uint256 x) internal pure returns (uint256 y) {
412         uint256 z = (x + 1) / 2;
413         y = x;
414 
415         while (z < y) {
416             y = z;
417             z = (x / z + z) / 2;
418         }
419     }
420 
421 
422 }
423 
424 library SafeMath {
425     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
426         if (a == 0) {
427             return 0;
428         }
429         uint256 c = a * b;
430         assert(c / a == b);
431         return c;
432     }
433 
434     function div(uint256 a, uint256 b) internal pure returns (uint256) {
435         uint256 c = a / b;
436         return c;
437     }
438 
439     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
440         assert(b <= a);
441         return a - b;
442     }
443 
444     function add(uint256 a, uint256 b) internal pure returns (uint256) {
445         uint256 c = a + b;
446         assert(c >= a);
447         return c;
448     }
449 }