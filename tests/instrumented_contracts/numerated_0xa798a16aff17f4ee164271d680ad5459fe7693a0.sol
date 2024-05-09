1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://t.me/HAMSTER_WARS
5 * http://hamsterwars.cloud
6 *
7 * [✓] 8% Withdraw fee
8 * [✓] 5% Deposit fee
9 * [✓] 1% Token transfer
10 * [✓] 39% Referal link
11 *
12 */
13 
14 contract HamsterWarsTokens {
15 
16     modifier onlyBagholders {
17         require(myTokens() > 0);
18         _;
19     }
20 
21     modifier onlyStronghands {
22         require(myDividends(true) > 0);
23         _;
24     }
25 
26     event onTokenPurchase(
27         address indexed customerAddress,
28         uint256 incomingEthereum,
29         uint256 tokensMinted,
30         address indexed referredBy,
31         uint timestamp,
32         uint256 price
33 );
34 
35     event onTokenSell(
36         address indexed customerAddress,
37         uint256 tokensBurned,
38         uint256 ethereumEarned,
39         uint timestamp,
40         uint256 price
41 );
42 
43     event onReinvestment(
44         address indexed customerAddress,
45         uint256 ethereumReinvested,
46         uint256 tokensMinted
47 );
48 
49     event onWithdraw(
50         address indexed customerAddress,
51         uint256 ethereumWithdrawn
52 );
53 
54     event Transfer(
55         address indexed from,
56         address indexed to,
57         uint256 tokens
58 );
59 
60     string public name = "HamsterWarsTokens";
61     string public symbol = "HWT";
62     uint8 constant public decimals = 18;
63     uint8 constant internal entryFee_ = 5;
64     uint8 constant internal transferFee_ = 1;
65     uint8 constant internal exitFee_ = 8;
66     uint8 constant internal refferalFee_ = 39;
67     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
68     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
69     uint256 constant internal magnitude = 2 ** 64;
70     uint256 public stakingRequirement = 50e18;
71     mapping(address => uint256) internal tokenBalanceLedger_;
72     mapping(address => uint256) internal referralBalance_;
73     mapping(address => int256) internal payoutsTo_;
74     uint256 internal tokenSupply_;
75     uint256 internal profitPerShare_;
76 
77     function buy(address _referredBy) public payable returns (uint256) {
78         purchaseTokens(msg.value, _referredBy);
79     }
80 
81     function() payable public {
82         purchaseTokens(msg.value, 0x0);
83     }
84 
85     function reinvest() onlyStronghands public {
86         uint256 _dividends = myDividends(false);
87         address _customerAddress = msg.sender;
88         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
89         _dividends += referralBalance_[_customerAddress];
90         referralBalance_[_customerAddress] = 0;
91         uint256 _tokens = purchaseTokens(_dividends, 0x0);
92         emit onReinvestment(_customerAddress, _dividends, _tokens);
93     }
94 
95     function exit() public {
96         address _customerAddress = msg.sender;
97         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
98         if (_tokens > 0) sell(_tokens);
99         withdraw();
100     }
101 
102     function withdraw() onlyStronghands public {
103         address _customerAddress = msg.sender;
104         uint256 _dividends = myDividends(false);
105         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
106         _dividends += referralBalance_[_customerAddress];
107         referralBalance_[_customerAddress] = 0;
108         _customerAddress.transfer(_dividends);
109         emit onWithdraw(_customerAddress, _dividends);
110     }
111 
112     function sell(uint256 _amountOfTokens) onlyBagholders public {
113         address _customerAddress = msg.sender;
114         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
115         uint256 _tokens = _amountOfTokens;
116         uint256 _ethereum = tokensToEthereum_(_tokens);
117         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
118         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
119 
120         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
121         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
122 
123         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
124         payoutsTo_[_customerAddress] -= _updatedPayouts;
125 
126         if (tokenSupply_ > 0) {
127             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
128         }
129         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
130     }
131 
132     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
133         address _customerAddress = msg.sender;
134         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
135 
136         if (myDividends(true) > 0) {
137             withdraw();
138         }
139 
140         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
141         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
142         uint256 _dividends = tokensToEthereum_(_tokenFee);
143 
144         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
145         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
146         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
147         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
148         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
149         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
150         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
151         return true;
152     }
153 
154 
155     function totalEthereumBalance() public view returns (uint256) {
156         return address(this).balance;
157     }
158 
159     function totalSupply() public view returns (uint256) {
160         return tokenSupply_;
161     }
162 
163     function myTokens() public view returns (uint256) {
164         address _customerAddress = msg.sender;
165         return balanceOf(_customerAddress);
166     }
167 
168     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
169         address _customerAddress = msg.sender;
170         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
171     }
172 
173     function balanceOf(address _customerAddress) public view returns (uint256) {
174         return tokenBalanceLedger_[_customerAddress];
175     }
176 
177     function dividendsOf(address _customerAddress) public view returns (uint256) {
178         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
179     }
180 
181     function sellPrice() public view returns (uint256) {
182         // our calculation relies on the token supply, so we need supply. Doh.
183         if (tokenSupply_ == 0) {
184             return tokenPriceInitial_ - tokenPriceIncremental_;
185         } else {
186             uint256 _ethereum = tokensToEthereum_(1e18);
187             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
188             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
189 
190             return _taxedEthereum;
191         }
192     }
193 
194     function buyPrice() public view returns (uint256) {
195         if (tokenSupply_ == 0) {
196             return tokenPriceInitial_ + tokenPriceIncremental_;
197         } else {
198             uint256 _ethereum = tokensToEthereum_(1e18);
199             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
200             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
201 
202             return _taxedEthereum;
203         }
204     }
205 
206     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
207         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
208         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
209         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
210 
211         return _amountOfTokens;
212     }
213 
214     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
215         require(_tokensToSell <= tokenSupply_);
216         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
217         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
218         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
219         return _taxedEthereum;
220     }
221 
222 
223     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
224         address _customerAddress = msg.sender;
225         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
226         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
227         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
228         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
229         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
230         uint256 _fee = _dividends * magnitude;
231 
232         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
233 
234         if (
235             _referredBy != 0x0000000000000000000000000000000000000000 &&
236             _referredBy != _customerAddress &&
237             tokenBalanceLedger_[_referredBy] >= stakingRequirement
238         ) {
239             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
240         } else {
241             _dividends = SafeMath.add(_dividends, _referralBonus);
242             _fee = _dividends * magnitude;
243         }
244 
245         if (tokenSupply_ > 0) {
246             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
247             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
248             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
249         } else {
250             tokenSupply_ = _amountOfTokens;
251         }
252 
253         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
254         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
255         payoutsTo_[_customerAddress] += _updatedPayouts;
256         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
257 
258         return _amountOfTokens;
259     }
260 
261     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
262         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
263         uint256 _tokensReceived =
264             (
265                 (
266                     SafeMath.sub(
267                         (sqrt
268                             (
269                                 (_tokenPriceInitial ** 2)
270                                 +
271                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
272                                 +
273                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
274                                 +
275                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
276                             )
277                         ), _tokenPriceInitial
278                     )
279                 ) / (tokenPriceIncremental_)
280             ) - (tokenSupply_);
281 
282         return _tokensReceived;
283     }
284 
285     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
286         uint256 tokens_ = (_tokens + 1e18);
287         uint256 _tokenSupply = (tokenSupply_ + 1e18);
288         uint256 _etherReceived =
289             (
290                 SafeMath.sub(
291                     (
292                         (
293                             (
294                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
295                             ) - tokenPriceIncremental_
296                         ) * (tokens_ - 1e18)
297                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
298                 )
299                 / 1e18);
300 
301         return _etherReceived;
302     }
303 
304     function sqrt(uint256 x) internal pure returns (uint256 y) {
305         uint256 z = (x + 1) / 2;
306         y = x;
307 
308         while (z < y) {
309             y = z;
310             z = (x / z + z) / 2;
311         }
312     }
313 
314 
315 }
316 
317 library SafeMath {
318     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
319         if (a == 0) {
320             return 0;
321         }
322         uint256 c = a * b;
323         assert(c / a == b);
324         return c;
325     }
326 
327     function div(uint256 a, uint256 b) internal pure returns (uint256) {
328         uint256 c = a / b;
329         return c;
330     }
331 
332     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
333         assert(b <= a);
334         return a - b;
335     }
336 
337     function add(uint256 a, uint256 b) internal pure returns (uint256) {
338         uint256 c = a + b;
339         assert(c >= a);
340         return c;
341     }
342 }