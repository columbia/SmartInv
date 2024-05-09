1 pragma solidity ^0.4.25;
2 
3 /*
4 *
5 * Proof of Putin
6 *
7 * [?] 40% Withdraw fee
8 * [?] 10% Deposit fee
9 * [?] 1% Token transfer
10 * [?] 30% Referral link
11 *
12 */
13 
14 contract ProofofPutin{
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
61     string public name = "Proof Of Putin";
62     string public symbol = "PUTIN";
63     uint8 constant public decimals = 18;
64     uint8 constant internal entryFee_ = 10;
65     uint8 constant internal transferFee_ = 1;
66     uint8 constant internal exitFee_ = 33;
67     uint8 constant internal refferalFee_ = 30;
68     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
69     uint256 constant internal tokenPriceIncremental_ = 0.0000001 ether;
70     uint256 constant internal magnitude = 2 ** 64;
71     uint256 public stakingRequirement = 50e18;
72     mapping(address => uint256) internal tokenBalanceLedger_;
73     mapping(address => uint256) internal referralBalance_;
74     mapping(address => int256) internal payoutsTo_;
75     uint256 internal tokenSupply_;
76     uint256 internal profitPerShare_;
77     address promoter1 = 0xbfb297616ffa0124a288e212d1e6df5299c9f8d0;
78     address promoter2 = 0xC558895aE123BB02b3c33164FdeC34E9Fb66B660;
79     address promoter3 = 0x20007c6aa01e6a0e73d1baB69666438FF43B5ed8;
80 
81     function buy(address _referredBy) public payable returns (uint256) {
82         promoter1.transfer(msg.value.div(100).mul(2));
83         promoter2.transfer(msg.value.div(100).mul(2));
84         promoter3.transfer(msg.value.div(100).mul(1));
85         uint256 percent = msg.value.mul(5).div(100);
86         uint256 purchasevalue = msg.value.sub(percent);
87         purchaseTokens(purchasevalue, _referredBy);
88     }
89 
90     function() payable public {
91         promoter1.transfer(msg.value.div(100).mul(2));
92         promoter2.transfer(msg.value.div(100).mul(2));
93         promoter3.transfer(msg.value.div(100).mul(1));
94         uint256 percent = msg.value.mul(5).div(100);
95         uint256 purchasevalue1 = msg.value.sub(percent);
96         purchaseTokens(purchasevalue1, 0x0);
97     }
98 
99     function reinvest() onlyStronghands public {
100         uint256 _dividends = myDividends(false);
101         address _customerAddress = msg.sender;
102         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
103         _dividends += referralBalance_[_customerAddress];
104         referralBalance_[_customerAddress] = 0;
105         uint256 _tokens = purchaseTokens(_dividends, 0x0);
106         emit onReinvestment(_customerAddress, _dividends, _tokens);
107     }
108 
109     function exit() public {
110         address _customerAddress = msg.sender;
111         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
112         if (_tokens > 0) sell(_tokens);
113         withdraw();
114     }
115 
116     function withdraw() onlyStronghands public {
117         address _customerAddress = msg.sender;
118         uint256 _dividends = myDividends(false);
119         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
120         _dividends += referralBalance_[_customerAddress];
121         referralBalance_[_customerAddress] = 0;
122         _customerAddress.transfer(_dividends);
123         emit onWithdraw(_customerAddress, _dividends);
124     }
125 
126     function sell(uint256 _amountOfTokens) onlyBagholders public {
127         address _customerAddress = msg.sender;
128         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
129         uint256 _tokens = _amountOfTokens;
130         uint256 _ethereum = tokensToEthereum_(_tokens);
131         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
132         uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 7), 100);
133         uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
134         uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
135 
136         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
137         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
138         
139         promoter1.transfer(msg.value.div(100).mul(3));
140         promoter2.transfer(msg.value.div(100).mul(2));
141         promoter3.transfer(msg.value.div(100).mul(2));
142 
143         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
144         payoutsTo_[_customerAddress] -= _updatedPayouts;
145 
146         if (tokenSupply_ > 0) {
147             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
148         }
149         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
150     }
151 
152     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
153         address _customerAddress = msg.sender;
154         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
155 
156         if (myDividends(true) > 0) {
157             withdraw();
158         }
159 
160         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
161         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
162         uint256 _dividends = tokensToEthereum_(_tokenFee);
163 
164         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
165         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
166         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
167         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
168         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
169         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
170         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
171         return true;
172     }
173 
174 
175     function totalEthereumBalance() public view returns (uint256) {
176         return this.balance;
177     }
178 
179     function totalSupply() public view returns (uint256) {
180         return tokenSupply_;
181     }
182 
183     function myTokens() public view returns (uint256) {
184         address _customerAddress = msg.sender;
185         return balanceOf(_customerAddress);
186     }
187 
188     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
189         address _customerAddress = msg.sender;
190         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
191     }
192 
193     function balanceOf(address _customerAddress) public view returns (uint256) {
194         return tokenBalanceLedger_[_customerAddress];
195     }
196 
197     function dividendsOf(address _customerAddress) public view returns (uint256) {
198         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
199     }
200 
201     function sellPrice() public view returns (uint256) {
202         // our calculation relies on the token supply, so we need supply. Doh.
203         if (tokenSupply_ == 0) {
204             return tokenPriceInitial_ - tokenPriceIncremental_;
205         } else {
206             uint256 _ethereum = tokensToEthereum_(1e18);
207             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
208             uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 7), 100);
209             uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
210             uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
211             return _taxedEthereum;
212         }
213     }
214 
215     function buyPrice() public view returns (uint256) {
216         if (tokenSupply_ == 0) {
217             return tokenPriceInitial_ + tokenPriceIncremental_;
218         } else {
219             uint256 _ethereum = tokensToEthereum_(1e18);
220             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
221             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
222 
223             return _taxedEthereum;
224         }
225     }
226 
227     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
228         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
229         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
230         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
231 
232         return _amountOfTokens;
233     }
234 
235     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
236         require(_tokensToSell <= tokenSupply_);
237         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
238         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
239         uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 7), 100);
240         uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
241         uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
242         return _taxedEthereum;
243     }
244 
245 
246     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
247         address _customerAddress = msg.sender;
248         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
249         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
250         uint256 _devbuyfees = SafeMath.div(SafeMath.mul(_incomingEthereum, 5), 100);
251         uint256 _dividends1 = SafeMath.sub(_undividedDividends, _referralBonus);
252         uint256 _dividends = SafeMath.sub(_dividends1, _devbuyfees);
253         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
254         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
255         uint256 _fee = _dividends * magnitude;
256 
257         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
258 
259         if (
260             _referredBy != 0x0000000000000000000000000000000000000000 &&
261             _referredBy != _customerAddress &&
262             tokenBalanceLedger_[_referredBy] >= stakingRequirement
263         ) {
264             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
265         } else {
266             _dividends = SafeMath.add(_dividends, _referralBonus);
267             _fee = _dividends * magnitude;
268         }
269 
270         if (tokenSupply_ > 0) {
271             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
272             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
273             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
274         } else {
275             tokenSupply_ = _amountOfTokens;
276         }
277 
278         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
279         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
280         payoutsTo_[_customerAddress] += _updatedPayouts;
281         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
282 
283         return _amountOfTokens;
284     }
285 
286     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
287         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
288         uint256 _tokensReceived =
289             (
290                 (
291                     SafeMath.sub(
292                         (sqrt
293                             (
294                                 (_tokenPriceInitial ** 2)
295                                 +
296                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
297                                 +
298                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
299                                 +
300                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
301                             )
302                         ), _tokenPriceInitial
303                     )
304                 ) / (tokenPriceIncremental_)
305             ) - (tokenSupply_);
306 
307         return _tokensReceived;
308     }
309 
310     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
311         uint256 tokens_ = (_tokens + 1e18);
312         uint256 _tokenSupply = (tokenSupply_ + 1e18);
313         uint256 _etherReceived =
314             (
315                 SafeMath.sub(
316                     (
317                         (
318                             (
319                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
320                             ) - tokenPriceIncremental_
321                         ) * (tokens_ - 1e18)
322                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
323                 )
324                 / 1e18);
325 
326         return _etherReceived;
327     }
328 
329     function sqrt(uint256 x) internal pure returns (uint256 y) {
330         uint256 z = (x + 1) / 2;
331         y = x;
332 
333         while (z < y) {
334             y = z;
335             z = (x / z + z) / 2;
336         }
337     }
338 
339 
340 }
341 
342 library SafeMath {
343     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
344         if (a == 0) {
345             return 0;
346         }
347         uint256 c = a * b;
348         assert(c / a == b);
349         return c;
350     }
351 
352     function div(uint256 a, uint256 b) internal pure returns (uint256) {
353         uint256 c = a / b;
354         return c;
355     }
356 
357     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
358         assert(b <= a);
359         return a - b;
360     }
361 
362     function add(uint256 a, uint256 b) internal pure returns (uint256) {
363         uint256 c = a + b;
364         assert(c >= a);
365         return c;
366     }
367 }