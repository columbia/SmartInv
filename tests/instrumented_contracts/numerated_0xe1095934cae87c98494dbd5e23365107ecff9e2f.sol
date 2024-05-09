1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://cryptominertoken.cloud
5 * https://discord.gg/ANBgN3P
6 *
7 * Crypto Miner Classic concept
8 *
9 * [✓] 5% Withdraw fee
10 * [✓] 15% Deposit fee
11 * [✓] 1% Token transfer
12 * [✓] 35% Referal link
13 *
14 */
15 
16 contract CryptoMinerClassic {
17 
18     modifier onlyBagholders {
19         require(myTokens() > 0);
20         _;
21     }
22 
23     modifier onlyStronghands {
24         require(myDividends(true) > 0);
25         _;
26     }
27 
28     event onTokenPurchase(
29         address indexed customerAddress,
30         uint256 incomingEthereum,
31         uint256 tokensMinted,
32         address indexed referredBy,
33         uint timestamp,
34         uint256 price
35 );
36 
37     event onTokenSell(
38         address indexed customerAddress,
39         uint256 tokensBurned,
40         uint256 ethereumEarned,
41         uint timestamp,
42         uint256 price
43 );
44 
45     event onReinvestment(
46         address indexed customerAddress,
47         uint256 ethereumReinvested,
48         uint256 tokensMinted
49 );
50 
51     event onWithdraw(
52         address indexed customerAddress,
53         uint256 ethereumWithdrawn
54 );
55 
56     event Transfer(
57         address indexed from,
58         address indexed to,
59         uint256 tokens
60 );
61 
62     string public name = "Crypto Miner Classic";
63     string public symbol = "CMC";
64     uint8 constant public decimals = 18;
65     uint8 constant internal entryFee_ = 15;
66     uint8 constant internal transferFee_ = 1;
67     uint8 constant internal exitFee_ = 5;
68     uint8 constant internal refferalFee_ = 35;
69     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
70     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
71     uint256 constant internal magnitude = 2 ** 64;
72     uint256 public stakingRequirement = 50e18;
73     mapping(address => uint256) internal tokenBalanceLedger_;
74     mapping(address => uint256) internal referralBalance_;
75     mapping(address => int256) internal payoutsTo_;
76     uint256 internal tokenSupply_;
77     uint256 internal profitPerShare_;
78 
79     function buy(address _referredBy) public payable returns (uint256) {
80         purchaseTokens(msg.value, _referredBy);
81     }
82 
83     function() payable public {
84         purchaseTokens(msg.value, 0x0);
85     }
86 
87     function reinvest() onlyStronghands public {
88         uint256 _dividends = myDividends(false);
89         address _customerAddress = msg.sender;
90         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
91         _dividends += referralBalance_[_customerAddress];
92         referralBalance_[_customerAddress] = 0;
93         uint256 _tokens = purchaseTokens(_dividends, 0x0);
94         emit onReinvestment(_customerAddress, _dividends, _tokens);
95     }
96 
97     function exit() public {
98         address _customerAddress = msg.sender;
99         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
100         if (_tokens > 0) sell(_tokens);
101         withdraw();
102     }
103 
104     function withdraw() onlyStronghands public {
105         address _customerAddress = msg.sender;
106         uint256 _dividends = myDividends(false);
107         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
108         _dividends += referralBalance_[_customerAddress];
109         referralBalance_[_customerAddress] = 0;
110         _customerAddress.transfer(_dividends);
111         emit onWithdraw(_customerAddress, _dividends);
112     }
113 
114     function sell(uint256 _amountOfTokens) onlyBagholders public {
115         address _customerAddress = msg.sender;
116         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
117         uint256 _tokens = _amountOfTokens;
118         uint256 _ethereum = tokensToEthereum_(_tokens);
119         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
120         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
121 
122         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
123         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
124 
125         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
126         payoutsTo_[_customerAddress] -= _updatedPayouts;
127 
128         if (tokenSupply_ > 0) {
129             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
130         }
131         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
132     }
133 
134     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
135         address _customerAddress = msg.sender;
136         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
137 
138         if (myDividends(true) > 0) {
139             withdraw();
140         }
141 
142         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
143         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
144         uint256 _dividends = tokensToEthereum_(_tokenFee);
145 
146         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
147         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
148         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
149         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
150         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
151         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
152         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
153         return true;
154     }
155 
156 
157     function totalEthereumBalance() public view returns (uint256) {
158         return this.balance;
159     }
160 
161     function totalSupply() public view returns (uint256) {
162         return tokenSupply_;
163     }
164 
165     function myTokens() public view returns (uint256) {
166         address _customerAddress = msg.sender;
167         return balanceOf(_customerAddress);
168     }
169 
170     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
171         address _customerAddress = msg.sender;
172         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
173     }
174 
175     function balanceOf(address _customerAddress) public view returns (uint256) {
176         return tokenBalanceLedger_[_customerAddress];
177     }
178 
179     function dividendsOf(address _customerAddress) public view returns (uint256) {
180         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
181     }
182 
183     function sellPrice() public view returns (uint256) {
184         // our calculation relies on the token supply, so we need supply. Doh.
185         if (tokenSupply_ == 0) {
186             return tokenPriceInitial_ - tokenPriceIncremental_;
187         } else {
188             uint256 _ethereum = tokensToEthereum_(1e18);
189             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
190             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
191 
192             return _taxedEthereum;
193         }
194     }
195 
196     function buyPrice() public view returns (uint256) {
197         if (tokenSupply_ == 0) {
198             return tokenPriceInitial_ + tokenPriceIncremental_;
199         } else {
200             uint256 _ethereum = tokensToEthereum_(1e18);
201             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
202             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
203 
204             return _taxedEthereum;
205         }
206     }
207 
208     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
209         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
210         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
211         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
212 
213         return _amountOfTokens;
214     }
215 
216     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
217         require(_tokensToSell <= tokenSupply_);
218         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
219         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
220         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
221         return _taxedEthereum;
222     }
223 
224 
225     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
226         address _customerAddress = msg.sender;
227         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
228         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
229         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
230         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
231         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
232         uint256 _fee = _dividends * magnitude;
233 
234         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
235 
236         if (
237             _referredBy != 0x0000000000000000000000000000000000000000 &&
238             _referredBy != _customerAddress &&
239             tokenBalanceLedger_[_referredBy] >= stakingRequirement
240         ) {
241             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
242         } else {
243             _dividends = SafeMath.add(_dividends, _referralBonus);
244             _fee = _dividends * magnitude;
245         }
246 
247         if (tokenSupply_ > 0) {
248             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
249             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
250             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
251         } else {
252             tokenSupply_ = _amountOfTokens;
253         }
254 
255         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
256         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
257         payoutsTo_[_customerAddress] += _updatedPayouts;
258         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
259 
260         return _amountOfTokens;
261     }
262 
263     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
264         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
265         uint256 _tokensReceived =
266             (
267                 (
268                     SafeMath.sub(
269                         (sqrt
270                             (
271                                 (_tokenPriceInitial ** 2)
272                                 +
273                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
274                                 +
275                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
276                                 +
277                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
278                             )
279                         ), _tokenPriceInitial
280                     )
281                 ) / (tokenPriceIncremental_)
282             ) - (tokenSupply_);
283 
284         return _tokensReceived;
285     }
286 
287     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
288         uint256 tokens_ = (_tokens + 1e18);
289         uint256 _tokenSupply = (tokenSupply_ + 1e18);
290         uint256 _etherReceived =
291             (
292                 SafeMath.sub(
293                     (
294                         (
295                             (
296                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
297                             ) - tokenPriceIncremental_
298                         ) * (tokens_ - 1e18)
299                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
300                 )
301                 / 1e18);
302 
303         return _etherReceived;
304     }
305 
306     function sqrt(uint256 x) internal pure returns (uint256 y) {
307         uint256 z = (x + 1) / 2;
308         y = x;
309 
310         while (z < y) {
311             y = z;
312             z = (x / z + z) / 2;
313         }
314     }
315 
316 
317 }
318 
319 library SafeMath {
320     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
321         if (a == 0) {
322             return 0;
323         }
324         uint256 c = a * b;
325         assert(c / a == b);
326         return c;
327     }
328 
329     function div(uint256 a, uint256 b) internal pure returns (uint256) {
330         uint256 c = a / b;
331         return c;
332     }
333 
334     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
335         assert(b <= a);
336         return a - b;
337     }
338 
339     function add(uint256 a, uint256 b) internal pure returns (uint256) {
340         uint256 c = a + b;
341         assert(c >= a);
342         return c;
343     }
344 }