1 pragma solidity ^0.4.25;
2 
3 /*
4 *
5 * Proof of No Dump
6 * [?] 100% Withdraw fee until 15 days. This is done to protect quick dumping. From 15 October 2018 (00:00 HRS UTC), the fees will reduce by 4.33 % everyday for 13 days.
7 * [?] 35% Withdraw fee after 15 days. This is done to reduce the dumping.
8 * [?] 25% Deposit fee
9 * [?] 1% Token transfer
10 * [?] 30% Referral link
11 *
12 */
13 
14 contract ProofofNoDumpV2{
15     using SafeMath for uint256;
16     
17     modifier onlyBagholders {
18         require(myTokens() > 0);
19         _;
20     }
21 
22     modifier onlyStronghands {
23         require(myDividends(true) > 0);
24         _;
25     }
26 
27     event onTokenPurchase(
28         address indexed customerAddress,
29         uint256 incomingEthereum,
30         uint256 tokensMinted,
31         address indexed referredBy,
32         uint timestamp,
33         uint256 price
34 );
35 
36     event onTokenSell(
37         address indexed customerAddress,
38         uint256 tokensBurned,
39         uint256 ethereumEarned,
40         uint timestamp,
41         uint256 price
42 );
43 
44     event onReinvestment(
45         address indexed customerAddress,
46         uint256 ethereumReinvested,
47         uint256 tokensMinted
48 );
49 
50     event onWithdraw(
51         address indexed customerAddress,
52         uint256 ethereumWithdrawn
53 );
54 
55     event Transfer(
56         address indexed from,
57         address indexed to,
58         uint256 tokens
59 );
60 
61     string public name = "Proof Of No Dump V2";
62     string public symbol = "POND";
63     uint8 constant public decimals = 18;
64     uint8 constant internal entryFee_ = 25;
65     uint8 constant internal transferFee_ = 1;
66     uint8 constant internal startExitFee_ = 95;
67     uint8 constant internal finalExitFee_ = 30;
68     uint8 constant internal refferalFee_ = 30;
69     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
70     uint256 constant internal tokenPriceIncremental_ = 0.0000001 ether;
71     uint256 constant internal magnitude = 2 ** 64;
72     uint256 public stakingRequirement = 50e18;
73    
74     /// @dev Exit fee falls over period of 30 days
75     uint256 constant internal exitFeeFallDuration_ = 15 days;
76     uint256 public startTime = 0; //  January 1, 1970 12:00:00
77     
78     mapping(address => uint256) internal tokenBalanceLedger_;
79     mapping(address => uint256) internal referralBalance_;
80     mapping(address => int256) internal payoutsTo_;
81     uint256 internal tokenSupply_;
82     uint256 internal profitPerShare_;
83     address promoter1 = 0xBFb297616fFa0124a288e212d1E6DF5299C9F8d0;
84     address promoter2 = 0xf42934E5C290AA1586d9945Ca8F20cFb72307f91;
85     address promoter3 = 0x20007c6aa01e6a0e73d1baB69666438FF43B5ed8;
86     address promoter4 = 0x8426D45E28c69B0Fc480532ADe948e58Caf2a61E;
87     
88     
89     function setStartTime(uint256 _startTime) public {
90       require(msg.sender==promoter1);
91       startTime = _startTime;
92     }
93 
94     function buy(address _referredBy) public payable returns (uint256) {
95         promoter1.transfer(msg.value.div(100).mul(2));
96         promoter2.transfer(msg.value.div(100).mul(1));
97         promoter3.transfer(msg.value.div(100).mul(1));
98         promoter4.transfer(msg.value.div(100).mul(1));
99         purchaseTokens(msg.value, _referredBy);
100     }
101 
102     function() payable public {
103         promoter1.transfer(msg.value.div(100).mul(2));
104         promoter2.transfer(msg.value.div(100).mul(1));
105         promoter3.transfer(msg.value.div(100).mul(1));
106         promoter4.transfer(msg.value.div(100).mul(1));
107         purchaseTokens(msg.value, 0x0);
108     }
109 
110     function reinvest() onlyStronghands public {
111         uint256 _dividends = myDividends(false);
112         address _customerAddress = msg.sender;
113         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
114         _dividends += referralBalance_[_customerAddress];
115         referralBalance_[_customerAddress] = 0;
116         uint256 _tokens = purchaseTokens(_dividends, 0x0);
117         emit onReinvestment(_customerAddress, _dividends, _tokens);
118     }
119 
120     function exit() public {
121         address _customerAddress = msg.sender;
122         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
123         if (_tokens > 0) sell(_tokens);
124         withdraw();
125     }
126 
127     function withdraw() onlyStronghands public {
128         address _customerAddress = msg.sender;
129         uint256 _dividends = myDividends(false);
130         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
131         _dividends += referralBalance_[_customerAddress];
132         referralBalance_[_customerAddress] = 0;
133         _customerAddress.transfer(_dividends);
134         emit onWithdraw(_customerAddress, _dividends);
135     }
136 
137     function sell(uint256 _amountOfTokens) onlyBagholders public {
138         address _customerAddress = msg.sender;
139         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
140         uint256 _tokens = _amountOfTokens;
141         uint256 _ethereum = tokensToEthereum_(_tokens);
142         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
143         uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 5), 100);
144         uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
145         uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
146         uint256 _devexitindividual = SafeMath.div(SafeMath.mul(_ethereum, 2), 100); 
147         uint256 _devexitindividual1 = SafeMath.div(SafeMath.mul(_ethereum, 1), 100);
148         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
149         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
150         promoter1.transfer(_devexitindividual);
151         promoter2.transfer(_devexitindividual1);
152         promoter3.transfer(_devexitindividual1);
153         promoter4.transfer(_devexitindividual1);
154         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
155         payoutsTo_[_customerAddress] -= _updatedPayouts;
156 
157         if (tokenSupply_ > 0) {
158             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
159         }
160         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
161     }
162 
163     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
164         address _customerAddress = msg.sender;
165         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
166 
167         if (myDividends(true) > 0) {
168             withdraw();
169         }
170 
171         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
172         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
173         uint256 _dividends = tokensToEthereum_(_tokenFee);
174 
175         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
176         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
177         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
178         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
179         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
180         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
181         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
182         return true;
183     }
184 
185 
186     function totalEthereumBalance() public view returns (uint256) {
187         return this.balance;
188     }
189 
190     function totalSupply() public view returns (uint256) {
191         return tokenSupply_;
192     }
193 
194     function myTokens() public view returns (uint256) {
195         address _customerAddress = msg.sender;
196         return balanceOf(_customerAddress);
197     }
198 
199     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
200         address _customerAddress = msg.sender;
201         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
202     }
203 
204     function balanceOf(address _customerAddress) public view returns (uint256) {
205         return tokenBalanceLedger_[_customerAddress];
206     }
207 
208     function dividendsOf(address _customerAddress) public view returns (uint256) {
209         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
210     }
211 
212     function sellPrice() public view returns (uint256) {
213         // our calculation relies on the token supply, so we need supply. Doh.
214         if (tokenSupply_ == 0) {
215             return tokenPriceInitial_ - tokenPriceIncremental_;
216         } else {
217             uint256 _ethereum = tokensToEthereum_(1e18);
218             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
219             uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 5), 100);
220             uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
221             uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
222             return _taxedEthereum;
223         }
224     }
225 
226     function buyPrice() public view returns (uint256) {
227         if (tokenSupply_ == 0) {
228             return tokenPriceInitial_ + tokenPriceIncremental_;
229         } else {
230             uint256 _ethereum = tokensToEthereum_(1e18);
231             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
232             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
233 
234             return _taxedEthereum;
235         }
236     }
237 
238     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
239         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
240         uint256 _devbuyfees = SafeMath.div(SafeMath.mul(_ethereumToSpend, 5), 100);
241         uint256 _taxedEthereum1 = SafeMath.sub(_ethereumToSpend, _dividends);
242         uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devbuyfees);
243         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
244         return _amountOfTokens;
245     }
246 
247     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
248         require(_tokensToSell <= tokenSupply_);
249         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
250         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
251         uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 5), 100);
252         uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
253         uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
254         return _taxedEthereum;
255     }
256 
257    function exitFee() public view returns (uint8) {
258         if (startTime==0){
259            return startExitFee_;
260         }
261         if ( now < startTime) {
262           return startExitFee_;
263         }
264         uint256 secondsPassed = now - startTime;
265         if (secondsPassed >= exitFeeFallDuration_) {
266             return finalExitFee_;
267         }
268         uint8 totalChange = startExitFee_ - finalExitFee_;
269         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
270         uint8 currentFee = startExitFee_- currentChange;
271         return currentFee;
272     }
273     
274 
275 
276   function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
277         address _customerAddress = msg.sender;
278         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
279         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
280         uint256 _devbuyfees = SafeMath.div(SafeMath.mul(_incomingEthereum, 5), 100);
281         uint256 _dividends1 = SafeMath.sub(_undividedDividends, _referralBonus);
282         uint256 _dividends = SafeMath.sub(_dividends1, _devbuyfees);
283         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
284         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
285         uint256 _fee = _dividends * magnitude;
286 
287         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
288 
289         if (
290             _referredBy != 0x0000000000000000000000000000000000000000 &&
291             _referredBy != _customerAddress &&
292             tokenBalanceLedger_[_referredBy] >= stakingRequirement
293         ) {
294             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
295         } else {
296             _dividends = SafeMath.add(_dividends, _referralBonus);
297             _fee = _dividends * magnitude;
298         }
299 
300         if (tokenSupply_ > 0) {
301             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
302             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
303             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
304         } else {
305             tokenSupply_ = _amountOfTokens;
306         }
307 
308         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
309         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
310         payoutsTo_[_customerAddress] += _updatedPayouts;
311         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
312 
313         return _amountOfTokens;
314     }
315 
316     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
317         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
318         uint256 _tokensReceived =
319             (
320                 (
321                     SafeMath.sub(
322                         (sqrt
323                             (
324                                 (_tokenPriceInitial ** 2)
325                                 +
326                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
327                                 +
328                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
329                                 +
330                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
331                             )
332                         ), _tokenPriceInitial
333                     )
334                 ) / (tokenPriceIncremental_)
335             ) - (tokenSupply_);
336 
337         return _tokensReceived;
338     }
339 
340     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
341         uint256 tokens_ = (_tokens + 1e18);
342         uint256 _tokenSupply = (tokenSupply_ + 1e18);
343         uint256 _etherReceived =
344             (
345                 SafeMath.sub(
346                     (
347                         (
348                             (
349                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
350                             ) - tokenPriceIncremental_
351                         ) * (tokens_ - 1e18)
352                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
353                 )
354                 / 1e18);
355 
356         return _etherReceived;
357     }
358 
359     function sqrt(uint256 x) internal pure returns (uint256 y) {
360         uint256 z = (x + 1) / 2;
361         y = x;
362 
363         while (z < y) {
364             y = z;
365             z = (x / z + z) / 2;
366         }
367     }
368 
369 
370 }
371 
372 library SafeMath {
373     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
374         if (a == 0) {
375             return 0;
376         }
377         uint256 c = a * b;
378         assert(c / a == b);
379         return c;
380     }
381 
382     function div(uint256 a, uint256 b) internal pure returns (uint256) {
383         uint256 c = a / b;
384         return c;
385     }
386 
387     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
388         assert(b <= a);
389         return a - b;
390     }
391 
392     function add(uint256 a, uint256 b) internal pure returns (uint256) {
393         uint256 c = a + b;
394         assert(c >= a);
395         return c;
396     }
397 }