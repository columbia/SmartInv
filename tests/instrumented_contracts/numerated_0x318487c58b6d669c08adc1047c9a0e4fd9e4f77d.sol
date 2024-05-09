1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://clonezone.site/exchange
5 * Discord - https://discord.gg/vbWkKPv
6 * Community Discord: https://t.me/CloneZone
7 *
8 * CloneZone Exchange token (Z3D) - Adapted from Crypto miner token concept
9 *
10 * [✓] 20% Withdraw fee
11 * [✓] 25% Deposit fee
12 * [✓] 1% Token transfer
13 * [✓] 33% Referal link
14 * [✓] 2% of all transactions from Zone Token % Daily contract will go to Z3D Holders
15 *
16 *
17 *
18 */
19 
20 contract Z3D{
21     using SafeMath for uint256;
22     
23     modifier onlyBagholders {
24         require(myTokens() > 0);
25         _;
26     }
27 
28     modifier onlyStronghands {
29         require(myDividends(true) > 0);
30         _;
31     }
32 
33     event onTokenPurchase(
34         address indexed customerAddress,
35         uint256 incomingEthereum,
36         uint256 tokensMinted,
37         address indexed referredBy,
38         uint timestamp,
39         uint256 price
40 );
41 
42     event onTokenSell(
43         address indexed customerAddress,
44         uint256 tokensBurned,
45         uint256 ethereumEarned,
46         uint timestamp,
47         uint256 price
48 );
49 
50     event onReinvestment(
51         address indexed customerAddress,
52         uint256 ethereumReinvested,
53         uint256 tokensMinted
54 );
55 
56     event onWithdraw(
57         address indexed customerAddress,
58         uint256 ethereumWithdrawn
59 );
60 
61     event Transfer(
62         address indexed from,
63         address indexed to,
64         uint256 tokens
65 );
66 
67     string public name = "Clone Zone Exchange Token";
68     string public symbol = "Z3D";
69     uint8 constant public decimals = 18;
70     uint8 constant internal entryFee_ = 25;
71     uint8 constant internal transferFee_ = 1;
72     uint8 constant internal startExitFee_ = 80;
73     uint8 constant internal finalExitFee_ = 20;
74     uint8 constant internal refferalFee_ = 33;
75     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
76     uint256 constant internal tokenPriceIncremental_ = 0.0000001 ether;
77     uint256 constant internal magnitude = 2 ** 64;
78     uint256 public stakingRequirement = 50e18;
79    
80     /// @dev Exit fee falls over period of 7 days
81     uint256 constant internal exitFeeFallDuration_ = 7 days;
82     uint256 public startTime = 0; //  January 1, 1970 12:00:00
83     
84     mapping(address => uint256) internal tokenBalanceLedger_;
85     mapping(address => uint256) internal referralBalance_;
86     mapping(address => int256) internal payoutsTo_;
87     uint256 internal tokenSupply_;
88     uint256 internal profitPerShare_;
89     address promoter1 = 0xaF9C025Ce6322A23ac00301C714f4F42895c9818;
90     address promoter2 = 0x7b705c83C8C270745955cc3ca5f80fb3acF75d83;
91     address promoter3 = 0x44503314C43422764582502e59a6B2905F999D04;
92     address promoter4 = 0xe25903C5078D01Bbea64C01DC1107f40f44141a3;
93     
94     
95     function setStartTime(uint256 _startTime) public {
96       require(msg.sender==promoter1);
97       startTime = _startTime;
98     }
99 
100     function buy(address _referredBy) public payable returns (uint256) {
101         promoter1.transfer(msg.value.div(100).mul(2));
102         promoter2.transfer(msg.value.div(100).mul(1));
103         promoter3.transfer(msg.value.div(100).mul(1));
104         promoter4.transfer(msg.value.div(100).mul(1));
105         purchaseTokens(msg.value, _referredBy);
106     }
107 
108     function() payable public {
109         promoter1.transfer(msg.value.div(100).mul(2));
110         promoter2.transfer(msg.value.div(100).mul(1));
111         promoter3.transfer(msg.value.div(100).mul(1));
112         promoter4.transfer(msg.value.div(100).mul(1));
113         purchaseTokens(msg.value, 0x0);
114     }
115 
116     function reinvest() onlyStronghands public {
117         uint256 _dividends = myDividends(false);
118         address _customerAddress = msg.sender;
119         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
120         _dividends += referralBalance_[_customerAddress];
121         referralBalance_[_customerAddress] = 0;
122         uint256 _tokens = purchaseTokens(_dividends, 0x0);
123         emit onReinvestment(_customerAddress, _dividends, _tokens);
124     }
125 
126     function exit() public {
127         address _customerAddress = msg.sender;
128         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
129         if (_tokens > 0) sell(_tokens);
130         withdraw();
131     }
132 
133     function withdraw() onlyStronghands public {
134         address _customerAddress = msg.sender;
135         uint256 _dividends = myDividends(false);
136         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
137         _dividends += referralBalance_[_customerAddress];
138         referralBalance_[_customerAddress] = 0;
139         _customerAddress.transfer(_dividends);
140         emit onWithdraw(_customerAddress, _dividends);
141     }
142 
143     function sell(uint256 _amountOfTokens) onlyBagholders public {
144         address _customerAddress = msg.sender;
145         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
146         uint256 _tokens = _amountOfTokens;
147         uint256 _ethereum = tokensToEthereum_(_tokens);
148         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
149         uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 5), 100);
150         uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
151         uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
152         uint256 _devexitindividual = SafeMath.div(SafeMath.mul(_ethereum, 2), 100); 
153         uint256 _devexitindividual1 = SafeMath.div(SafeMath.mul(_ethereum, 1), 100);
154         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
155         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
156         promoter1.transfer(_devexitindividual);
157         promoter2.transfer(_devexitindividual1);
158         promoter3.transfer(_devexitindividual1);
159         promoter4.transfer(_devexitindividual1);
160         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
161         payoutsTo_[_customerAddress] -= _updatedPayouts;
162 
163         if (tokenSupply_ > 0) {
164             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
165         }
166         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
167     }
168 
169     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
170         address _customerAddress = msg.sender;
171         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
172 
173         if (myDividends(true) > 0) {
174             withdraw();
175         }
176 
177         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
178         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
179         uint256 _dividends = tokensToEthereum_(_tokenFee);
180 
181         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
182         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
183         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
184         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
185         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
186         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
187         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
188         return true;
189     }
190 
191 
192     function totalEthereumBalance() public view returns (uint256) {
193         return this.balance;
194     }
195 
196     function totalSupply() public view returns (uint256) {
197         return tokenSupply_;
198     }
199 
200     function myTokens() public view returns (uint256) {
201         address _customerAddress = msg.sender;
202         return balanceOf(_customerAddress);
203     }
204 
205     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
206         address _customerAddress = msg.sender;
207         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
208     }
209 
210     function balanceOf(address _customerAddress) public view returns (uint256) {
211         return tokenBalanceLedger_[_customerAddress];
212     }
213 
214     function dividendsOf(address _customerAddress) public view returns (uint256) {
215         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
216     }
217 
218     function sellPrice() public view returns (uint256) {
219         // our calculation relies on the token supply, so we need supply. Doh.
220         if (tokenSupply_ == 0) {
221             return tokenPriceInitial_ - tokenPriceIncremental_;
222         } else {
223             uint256 _ethereum = tokensToEthereum_(1e18);
224             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
225             uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 5), 100);
226             uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
227             uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
228             return _taxedEthereum;
229         }
230     }
231 
232     function buyPrice() public view returns (uint256) {
233         if (tokenSupply_ == 0) {
234             return tokenPriceInitial_ + tokenPriceIncremental_;
235         } else {
236             uint256 _ethereum = tokensToEthereum_(1e18);
237             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
238             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
239 
240             return _taxedEthereum;
241         }
242     }
243 
244     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
245         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
246         uint256 _devbuyfees = SafeMath.div(SafeMath.mul(_ethereumToSpend, 5), 100);
247         uint256 _taxedEthereum1 = SafeMath.sub(_ethereumToSpend, _dividends);
248         uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devbuyfees);
249         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
250         return _amountOfTokens;
251     }
252 
253     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
254         require(_tokensToSell <= tokenSupply_);
255         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
256         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
257         uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 5), 100);
258         uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
259         uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
260         return _taxedEthereum;
261     }
262 
263    function exitFee() public view returns (uint8) {
264         if (startTime==0){
265            return startExitFee_;
266         }
267         if ( now < startTime) {
268           return startExitFee_;
269         }
270         uint256 secondsPassed = now - startTime;
271         if (secondsPassed >= exitFeeFallDuration_) {
272             return finalExitFee_;
273         }
274         uint8 totalChange = startExitFee_ - finalExitFee_;
275         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
276         uint8 currentFee = startExitFee_- currentChange;
277         return currentFee;
278     }
279     
280 
281 
282   function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
283         address _customerAddress = msg.sender;
284         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
285         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
286         uint256 _devbuyfees = SafeMath.div(SafeMath.mul(_incomingEthereum, 5), 100);
287         uint256 _dividends1 = SafeMath.sub(_undividedDividends, _referralBonus);
288         uint256 _dividends = SafeMath.sub(_dividends1, _devbuyfees);
289         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
290         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
291         uint256 _fee = _dividends * magnitude;
292 
293         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
294 
295         if (
296             _referredBy != 0x0000000000000000000000000000000000000000 &&
297             _referredBy != _customerAddress &&
298             tokenBalanceLedger_[_referredBy] >= stakingRequirement
299         ) {
300             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
301         } else {
302             _dividends = SafeMath.add(_dividends, _referralBonus);
303             _fee = _dividends * magnitude;
304         }
305 
306         if (tokenSupply_ > 0) {
307             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
308             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
309             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
310         } else {
311             tokenSupply_ = _amountOfTokens;
312         }
313 
314         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
315         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
316         payoutsTo_[_customerAddress] += _updatedPayouts;
317         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
318 
319         return _amountOfTokens;
320     }
321 
322     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
323         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
324         uint256 _tokensReceived =
325             (
326                 (
327                     SafeMath.sub(
328                         (sqrt
329                             (
330                                 (_tokenPriceInitial ** 2)
331                                 +
332                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
333                                 +
334                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
335                                 +
336                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
337                             )
338                         ), _tokenPriceInitial
339                     )
340                 ) / (tokenPriceIncremental_)
341             ) - (tokenSupply_);
342 
343         return _tokensReceived;
344     }
345 
346     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
347         uint256 tokens_ = (_tokens + 1e18);
348         uint256 _tokenSupply = (tokenSupply_ + 1e18);
349         uint256 _etherReceived =
350             (
351                 SafeMath.sub(
352                     (
353                         (
354                             (
355                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
356                             ) - tokenPriceIncremental_
357                         ) * (tokens_ - 1e18)
358                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
359                 )
360                 / 1e18);
361 
362         return _etherReceived;
363     }
364 
365     function sqrt(uint256 x) internal pure returns (uint256 y) {
366         uint256 z = (x + 1) / 2;
367         y = x;
368 
369         while (z < y) {
370             y = z;
371             z = (x / z + z) / 2;
372         }
373     }
374 
375 
376 }
377 
378 library SafeMath {
379     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
380         if (a == 0) {
381             return 0;
382         }
383         uint256 c = a * b;
384         assert(c / a == b);
385         return c;
386     }
387 
388     function div(uint256 a, uint256 b) internal pure returns (uint256) {
389         uint256 c = a / b;
390         return c;
391     }
392 
393     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
394         assert(b <= a);
395         return a - b;
396     }
397 
398     function add(uint256 a, uint256 b) internal pure returns (uint256) {
399         uint256 c = a + b;
400         assert(c >= a);
401         return c;
402     }
403 }