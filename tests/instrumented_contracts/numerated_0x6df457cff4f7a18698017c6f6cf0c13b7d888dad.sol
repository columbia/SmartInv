1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://clonezone.site/exchange
5 * Discord - https://discord.gg/vbWkKPv
6 * Community Discord: https://t.me/CloneZone
7 *
8 * CloneZone Exchange token (Z3D) - Adapted from Crypto miner token concept
9 *
10 * [✓] 4% Withdraw fee
11 * [✓] 10% Deposit fee
12 * [✓] 1% Token transfer
13 * [✓] 33% Referal link
14 * [✓] 2% of all transactions from Zone Token % Daily contract will go to Z3D Holders
15 */
16 
17 contract Z3D {
18 
19     modifier onlyBagholders {
20         require(myTokens() > 0);
21         _;
22     }
23 
24     modifier onlyStronghands {
25         require(myDividends(true) > 0);
26         _;
27     }
28 
29     event onTokenPurchase(
30         address indexed customerAddress,
31         uint256 incomingEthereum,
32         uint256 tokensMinted,
33         address indexed referredBy,
34         uint timestamp,
35         uint256 price
36 );
37 
38     event onTokenSell(
39         address indexed customerAddress,
40         uint256 tokensBurned,
41         uint256 ethereumEarned,
42         uint timestamp,
43         uint256 price
44 );
45 
46     event onReinvestment(
47         address indexed customerAddress,
48         uint256 ethereumReinvested,
49         uint256 tokensMinted
50 );
51 
52     event onWithdraw(
53         address indexed customerAddress,
54         uint256 ethereumWithdrawn
55 );
56 
57     event Transfer(
58         address indexed from,
59         address indexed to,
60         uint256 tokens
61 );
62 
63     string public name = "Zone Exchange Token";
64     string public symbol = "Z3D";
65     uint8 constant public decimals = 18;
66     uint8 constant internal entryFee_ = 10;
67     uint8 constant internal transferFee_ = 1;
68     uint8 constant internal exitFee_ = 4;
69     uint8 constant internal refferalFee_ = 33;
70     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
71     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
72     uint256 constant internal magnitude = 2 ** 64;
73     uint256 public stakingRequirement = 50e18;
74     mapping(address => uint256) internal tokenBalanceLedger_;
75     mapping(address => uint256) internal referralBalance_;
76     mapping(address => int256) internal payoutsTo_;
77     uint256 internal tokenSupply_;
78     uint256 internal profitPerShare_;
79 
80     function buy(address _referredBy) public payable returns (uint256) {
81         purchaseTokens(msg.value, _referredBy);
82     }
83 
84     function() payable public {
85         purchaseTokens(msg.value, 0x0);
86     }
87 
88     function reinvest() onlyStronghands public {
89         uint256 _dividends = myDividends(false);
90         address _customerAddress = msg.sender;
91         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
92         _dividends += referralBalance_[_customerAddress];
93         referralBalance_[_customerAddress] = 0;
94         uint256 _tokens = purchaseTokens(_dividends, 0x0);
95         emit onReinvestment(_customerAddress, _dividends, _tokens);
96     }
97 
98     function exit() public {
99         address _customerAddress = msg.sender;
100         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
101         if (_tokens > 0) sell(_tokens);
102         withdraw();
103     }
104 
105     function withdraw() onlyStronghands public {
106         address _customerAddress = msg.sender;
107         uint256 _dividends = myDividends(false);
108         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
109         _dividends += referralBalance_[_customerAddress];
110         referralBalance_[_customerAddress] = 0;
111         _customerAddress.transfer(_dividends);
112         emit onWithdraw(_customerAddress, _dividends);
113     }
114 
115     function sell(uint256 _amountOfTokens) onlyBagholders public {
116         address _customerAddress = msg.sender;
117         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
118         uint256 _tokens = _amountOfTokens;
119         uint256 _ethereum = tokensToEthereum_(_tokens);
120         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
121         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
122 
123         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
124         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
125 
126         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
127         payoutsTo_[_customerAddress] -= _updatedPayouts;
128 
129         if (tokenSupply_ > 0) {
130             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
131         }
132         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
133     }
134 
135     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
136         address _customerAddress = msg.sender;
137         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
138 
139         if (myDividends(true) > 0) {
140             withdraw();
141         }
142 
143         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
144         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
145         uint256 _dividends = tokensToEthereum_(_tokenFee);
146 
147         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
148         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
149         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
150         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
151         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
152         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
153         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
154         return true;
155     }
156 
157 
158     function totalEthereumBalance() public view returns (uint256) {
159         return this.balance;
160     }
161 
162     function totalSupply() public view returns (uint256) {
163         return tokenSupply_;
164     }
165 
166     function myTokens() public view returns (uint256) {
167         address _customerAddress = msg.sender;
168         return balanceOf(_customerAddress);
169     }
170 
171     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
172         address _customerAddress = msg.sender;
173         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
174     }
175 
176     function balanceOf(address _customerAddress) public view returns (uint256) {
177         return tokenBalanceLedger_[_customerAddress];
178     }
179 
180     function dividendsOf(address _customerAddress) public view returns (uint256) {
181         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
182     }
183 
184     function sellPrice() public view returns (uint256) {
185         // our calculation relies on the token supply, so we need supply. Doh.
186         if (tokenSupply_ == 0) {
187             return tokenPriceInitial_ - tokenPriceIncremental_;
188         } else {
189             uint256 _ethereum = tokensToEthereum_(1e18);
190             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
191             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
192 
193             return _taxedEthereum;
194         }
195     }
196 
197     function buyPrice() public view returns (uint256) {
198         if (tokenSupply_ == 0) {
199             return tokenPriceInitial_ + tokenPriceIncremental_;
200         } else {
201             uint256 _ethereum = tokensToEthereum_(1e18);
202             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
203             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
204 
205             return _taxedEthereum;
206         }
207     }
208 
209     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
210         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
211         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
212         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
213 
214         return _amountOfTokens;
215     }
216 
217     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
218         require(_tokensToSell <= tokenSupply_);
219         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
220         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
221         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
222         return _taxedEthereum;
223     }
224 
225 
226     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
227         address _customerAddress = msg.sender;
228         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
229         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
230         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
231         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
232         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
233         uint256 _fee = _dividends * magnitude;
234 
235         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
236 
237         if (
238             _referredBy != 0x0000000000000000000000000000000000000000 &&
239             _referredBy != _customerAddress &&
240             tokenBalanceLedger_[_referredBy] >= stakingRequirement
241         ) {
242             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
243         } else {
244             _dividends = SafeMath.add(_dividends, _referralBonus);
245             _fee = _dividends * magnitude;
246         }
247 
248         if (tokenSupply_ > 0) {
249             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
250             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
251             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
252         } else {
253             tokenSupply_ = _amountOfTokens;
254         }
255 
256         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
257         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
258         payoutsTo_[_customerAddress] += _updatedPayouts;
259         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
260 
261         return _amountOfTokens;
262     }
263 
264     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
265         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
266         uint256 _tokensReceived =
267             (
268                 (
269                     SafeMath.sub(
270                         (sqrt
271                             (
272                                 (_tokenPriceInitial ** 2)
273                                 +
274                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
275                                 +
276                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
277                                 +
278                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
279                             )
280                         ), _tokenPriceInitial
281                     )
282                 ) / (tokenPriceIncremental_)
283             ) - (tokenSupply_);
284 
285         return _tokensReceived;
286     }
287 
288     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
289         uint256 tokens_ = (_tokens + 1e18);
290         uint256 _tokenSupply = (tokenSupply_ + 1e18);
291         uint256 _etherReceived =
292             (
293                 SafeMath.sub(
294                     (
295                         (
296                             (
297                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
298                             ) - tokenPriceIncremental_
299                         ) * (tokens_ - 1e18)
300                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
301                 )
302                 / 1e18);
303 
304         return _etherReceived;
305     }
306 
307     function sqrt(uint256 x) internal pure returns (uint256 y) {
308         uint256 z = (x + 1) / 2;
309         y = x;
310 
311         while (z < y) {
312             y = z;
313             z = (x / z + z) / 2;
314         }
315     }
316 
317 
318 }
319 
320 library SafeMath {
321     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
322         if (a == 0) {
323             return 0;
324         }
325         uint256 c = a * b;
326         assert(c / a == b);
327         return c;
328     }
329 
330     function div(uint256 a, uint256 b) internal pure returns (uint256) {
331         uint256 c = a / b;
332         return c;
333     }
334 
335     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
336         assert(b <= a);
337         return a - b;
338     }
339 
340     function add(uint256 a, uint256 b) internal pure returns (uint256) {
341         uint256 c = a + b;
342         assert(c >= a);
343         return c;
344     }
345 }