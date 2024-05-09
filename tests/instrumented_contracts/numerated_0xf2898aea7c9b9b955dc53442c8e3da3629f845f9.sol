1 pragma solidity ^0.4.24;
2 
3 /*
4     * Эдуарда Затулывитер
5     * Владислава Стешенко
6     * Официальный старт:  10.11.2018.
7     *
8     * По вопросам рекламы обращаться eduardzatulyviter@gmail.com
9 */
10 
11 /*
12     * Eduard Zatulyvitter
13     * Vladyslav Steshenko
14     * Official launch: 10.11.2018
15     *
16     * Advertise: eduardzatulyviter@gmail.com
17 */
18 
19 /* Token concept New Concept Token
20 
21 *  11% Deposit fee - комиссия за вход в проект (все средства распределяются между держателями токенов)
22 *  1% Token transfer
23 *  3,5% Referal link ()
24 *  0.5% _admin (from buy)
25 *  3% _advert (from sell)
26 *  4% Withdraw fee - комиссия за выход из проект (все средства распределяются между держателями токенов)
27 *
28 *
29 *  11% Deposit fee - commission for entering the project (all funds are distributed among holders of tokens)
30 *  1% Token transfer
31 *  3,5% Referal link ()
32 *  0.5% _admin (from buy)
33 *  3% _advert (from sell)
34 *  4% Withdraw fee - commission for exit from the project (all funds are distributed among holders of tokens)
35 *
36 */
37 
38 contract NewConceptToken {
39 
40     modifier onlyBagholders {
41         require(myTokens() > 0);
42         _;
43     }
44     modifier onlyStronghands {
45         require(myDividends(true) > 0);
46         _;
47     }
48     event onTokenPurchase(
49         address indexed customerAddress,
50         uint256 incomingEthereum,
51         uint256 tokensMinted,
52         address indexed referredBy,
53         uint timestamp,
54         uint256 price
55 );
56     event onTokenSell(
57         address indexed customerAddress,
58         uint256 tokensBurned,
59         uint256 ethereumEarned,
60         uint timestamp,
61         uint256 price
62 );
63     event onReinvestment(
64         address indexed customerAddress,
65         uint256 ethereumReinvested,
66         uint256 tokensMinted
67 );
68     event onWithdraw(
69         address indexed customerAddress,
70         uint256 ethereumWithdrawn
71 );
72     event Transfer(
73         address indexed from,
74         address indexed to,
75         uint256 tokens
76 );
77     string public name = "New Concept Token";
78     string public symbol = "NCT";
79     uint8 constant public decimals = 18;
80     uint8 constant internal entryFee_ = 11;
81     uint8 constant internal transferFee_ = 1;
82     uint8 constant internal exitFee_ = 4;
83     uint8 constant internal advertFee = 3;
84     uint8 constant internal refferalFee_ = 35;
85     uint8 constant internal adminFee_ = 5;
86     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
87     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
88     uint256 constant internal magnitude = 2 ** 64;   // 2^64
89     uint256 public stakingRequirement = 1e18;
90     mapping(address => uint256) internal tokenBalanceLedger_;
91     mapping(address => uint256) internal referralBalance_;
92     mapping(address => int256) internal payoutsTo_;
93     uint256 internal tokenSupply_;
94     uint256 internal profitPerShare_;
95     address creator = 0x606D38c1C2d6E0252D7fb52415Fd9f2722899fb4;
96 
97     function buy(address _referredBy) public payable returns (uint256) {
98         purchaseTokens(msg.value, _referredBy);
99     }
100     function() payable public {
101         purchaseTokens(msg.value, 0x0);
102     }
103 
104     function reinvest() onlyStronghands public {
105         uint256 _dividends = myDividends(false);
106         address _customerAddress = msg.sender;
107         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
108         _dividends += referralBalance_[_customerAddress];
109         referralBalance_[_customerAddress] = 0;
110         uint256 _tokens = purchaseTokens(_dividends, 0x0);
111         emit onReinvestment(_customerAddress, _dividends, _tokens);
112     }
113 
114     function exit() public {
115         address _customerAddress = msg.sender;
116         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
117         if (_tokens > 0) sell(_tokens);
118         withdraw();
119     }
120 
121     function withdraw() onlyStronghands public {
122         address _customerAddress = msg.sender;
123         uint256 _dividends = myDividends(false);
124         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
125         _dividends += referralBalance_[_customerAddress];
126         referralBalance_[_customerAddress] = 0;
127         _customerAddress.transfer(_dividends);
128         emit onWithdraw(_customerAddress, _dividends);
129     }
130 
131     function sell(uint256 _amountOfTokens) onlyBagholders public {
132         address _customerAddress = msg.sender;
133         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
134         uint256 _tokens = _amountOfTokens;
135         uint256 _ethereum = tokensToEthereum_(_tokens);
136         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
137         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
138         if (_customerAddress != creator) {
139           uint256 _advert = SafeMath.div(SafeMath.mul(_ethereum, advertFee), 100);
140           _taxedEthereum = SafeMath.sub (_taxedEthereum, _advert);
141           tokenBalanceLedger_[creator] += _advert;
142         }
143 
144         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
145         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
146         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
147         payoutsTo_[_customerAddress] -= _updatedPayouts;
148 
149         if (tokenSupply_ > 0) {
150             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
151         }
152         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
153     }
154 
155     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
156         address _customerAddress = msg.sender;
157         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
158 
159         if (myDividends(true) > 0) {
160             withdraw();
161         }
162 
163         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
164         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
165         uint256 _dividends = tokensToEthereum_(_tokenFee);
166 
167         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
168         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
169         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
170         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
171         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
172         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
173         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
174         return true;
175     }
176 
177     address contractAddress = this;
178 
179     function totalEthereumBalance() public view returns (uint256) {
180         return contractAddress.balance;
181     }
182 
183     function totalSupply() public view returns (uint256) {
184         return tokenSupply_;
185     }
186 
187     function myTokens() public view returns(uint256) {
188         address _customerAddress = msg.sender;
189         return balanceOf(_customerAddress);
190     }
191 
192     function myDividends(bool _includeReferralBonus) public view returns(uint256) {
193         address _customerAddress = msg.sender;
194         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
195     }
196 
197     function balanceOf(address _customerAddress) view public returns(uint256){
198         return tokenBalanceLedger_[_customerAddress];
199     }
200 
201     function dividendsOf(address _customerAddress) view public returns(uint256) {
202         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
203     }
204 
205     function sellPrice() public view returns (uint256) {
206         if (tokenSupply_ == 0) {
207             return tokenPriceInitial_ - tokenPriceIncremental_;
208         } else {
209             uint256 _ethereum = tokensToEthereum_(1e18);
210             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
211             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
212 
213             return _taxedEthereum;
214         }
215     }
216 
217     function buyPrice() public view returns (uint256) {
218         if (tokenSupply_ == 0) {
219             return tokenPriceInitial_ + tokenPriceIncremental_;
220         } else {
221             uint256 _ethereum = tokensToEthereum_(1e18);
222             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
223             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
224 
225             return _taxedEthereum;
226         }
227     }
228 
229     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
230         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
231         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
232         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
233 
234         return _amountOfTokens;
235     }
236 
237     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
238         require(_tokensToSell <= tokenSupply_);
239         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
240         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
241         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
242         return _taxedEthereum;
243     }
244 
245     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
246         address _customerAddress = msg.sender;
247         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
248         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
249         if (_customerAddress != creator){
250             uint256 _admin = SafeMath.div(SafeMath.mul(_undividedDividends, adminFee_),100);
251             _dividends = SafeMath.sub(_dividends, _admin);
252             uint256 _adminamountOfTokens = ethereumToTokens_(_admin);
253             tokenBalanceLedger_[creator] += _adminamountOfTokens;
254         }
255         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
256         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
257         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
258 
259         uint256 _fee = _dividends * magnitude;
260 
261         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
262 
263         if (
264             _referredBy != 0x0000000000000000000000000000000000000000 &&
265             _referredBy != _customerAddress &&
266             tokenBalanceLedger_[_referredBy] >= stakingRequirement
267         ) {
268             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
269         } else {
270             _dividends = SafeMath.add(_dividends, _referralBonus);
271             _fee = _dividends * magnitude;
272         }
273 
274         if (tokenSupply_ > 0) {
275             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
276             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
277             _fee = _amountOfTokens * (_dividends * magnitude / tokenSupply_);
278 
279         } else {
280             tokenSupply_ = _amountOfTokens;
281         }
282 
283         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
284 
285         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);  //profitPerShare_old * magnitude * _amountOfTokens;ayoutsToOLD
286         payoutsTo_[_customerAddress] += _updatedPayouts;
287 
288         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
289 
290         return _amountOfTokens;
291     }
292 
293     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
294         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
295         uint256 _tokensReceived =
296             (
297                 (
298                     SafeMath.sub(
299                         (sqrt(
300                                 (_tokenPriceInitial ** 2)
301                                 +
302                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
303                                 +
304                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
305                                 +
306                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
307                             )
308                         ), _tokenPriceInitial
309                     )
310                 ) / (tokenPriceIncremental_)
311             ) - (tokenSupply_);
312 
313         return _tokensReceived;
314     }
315 
316     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
317         uint256 tokens_ = (_tokens + 1e18);
318         uint256 _tokenSupply = (tokenSupply_ + 1e18);
319         uint256 _etherReceived =
320             (
321                 SafeMath.sub(
322                     (
323                         (
324                             (tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
325                             ) - tokenPriceIncremental_
326                         ) * (tokens_ - 1e18)
327                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
328                 )
329                 / 1e18);
330 
331         return _etherReceived;
332     }
333 
334     function sqrt(uint256 x) internal pure returns (uint256 y) {
335         uint256 z = (x + 1) / 2;
336         y = x;
337 
338         while (z < y) {
339             y = z;
340             z = (x / z + z) / 2;
341         }
342     }
343 }
344 
345 library SafeMath {
346     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
347         if (a == 0) {
348             return 0;
349         }
350         uint256 c = a * b;
351         assert(c / a == b);
352         return c;
353     }
354     function div(uint256 a, uint256 b) internal pure returns (uint256) {
355         uint256 c = a / b;
356         return c;
357     }
358     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
359         assert(b <= a);
360         return a - b;
361     }
362     function add(uint256 a, uint256 b) internal pure returns (uint256) {
363         uint256 c = a + b;
364         assert(c >= a);
365         return c;
366     }
367 }