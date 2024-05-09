1 pragma solidity ^0.4.25;
2 
3 /*
4 * [✓] 3% Снятие платы
5 * [✓] 12% Плата за депозит
6 * [✓] 1% Передача токена
7 * [✓] 33% Ссылка
8 *
9 */
10 
11 contract CryptoMinerTokenReloaded {
12 
13     modifier onlyBagholders {
14         require(myTokens() > 0);
15         _;
16     }
17 
18     modifier onlyStronghands {
19         require(myDividends(true) > 0);
20         _;
21     }
22 
23     event onTokenPurchase(
24         address indexed customerAddress,
25         uint256 incomingEthereum,
26         uint256 tokensMinted,
27         address indexed referredBy,
28         uint timestamp,
29         uint256 price
30 );
31 
32     event onTokenSell(
33         address indexed customerAddress,
34         uint256 tokensBurned,
35         uint256 ethereumEarned,
36         uint timestamp,
37         uint256 price
38 );
39 
40     event onReinvestment(
41         address indexed customerAddress,
42         uint256 ethereumReinvested,
43         uint256 tokensMinted
44 );
45 
46     event onWithdraw(
47         address indexed customerAddress,
48         uint256 ethereumWithdrawn
49 );
50 
51     event Transfer(
52         address indexed from,
53         address indexed to,
54         uint256 tokens
55 );
56 
57     string public name = "Crypto Miner Token Reloaded";
58     string public symbol = "CMPR";
59     uint8 constant public decimals = 18;
60     uint8 constant internal entryFee_ = 12;
61     uint8 constant internal transferFee_ = 1;
62     uint8 constant internal exitFee_ = 3;
63     uint8 constant internal refferalFee_ = 33;
64     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
65     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
66     uint256 constant internal magnitude = 2 ** 64;
67     uint256 public stakingRequirement = 50e18;
68     mapping(address => uint256) internal tokenBalanceLedger_;
69     mapping(address => uint256) internal referralBalance_;
70     mapping(address => int256) internal payoutsTo_;
71     uint256 internal tokenSupply_;
72     uint256 internal profitPerShare_;
73 
74     function buy(address _referredBy) public payable returns (uint256) {
75         purchaseTokens(msg.value, _referredBy);
76     }
77 
78     function() payable public {
79         purchaseTokens(msg.value, 0x0);
80     }
81 
82     function reinvest() onlyStronghands public {
83         uint256 _dividends = myDividends(false);
84         address _customerAddress = msg.sender;
85         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
86         _dividends += referralBalance_[_customerAddress];
87         referralBalance_[_customerAddress] = 0;
88         uint256 _tokens = purchaseTokens(_dividends, 0x0);
89         emit onReinvestment(_customerAddress, _dividends, _tokens);
90     }
91 
92     function exit() public {
93         address _customerAddress = msg.sender;
94         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
95         if (_tokens > 0) sell(_tokens);
96         withdraw();
97     }
98 
99     function withdraw() onlyStronghands public {
100         address _customerAddress = msg.sender;
101         uint256 _dividends = myDividends(false);
102         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
103         _dividends += referralBalance_[_customerAddress];
104         referralBalance_[_customerAddress] = 0;
105         _customerAddress.transfer(_dividends);
106         emit onWithdraw(_customerAddress, _dividends);
107     }
108 
109     function sell(uint256 _amountOfTokens) onlyBagholders public {
110         address _customerAddress = msg.sender;
111         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
112         uint256 _tokens = _amountOfTokens;
113         uint256 _ethereum = tokensToEthereum_(_tokens);
114         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
115         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
116 
117         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
118         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
119 
120         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
121         payoutsTo_[_customerAddress] -= _updatedPayouts;
122 
123         if (tokenSupply_ > 0) {
124             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
125         }
126         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
127     }
128 
129     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
130         address _customerAddress = msg.sender;
131         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
132 
133         if (myDividends(true) > 0) {
134             withdraw();
135         }
136 
137         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
138         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
139         uint256 _dividends = tokensToEthereum_(_tokenFee);
140 
141         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
142         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
143         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
144         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
145         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
146         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
147         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
148         return true;
149     }
150 
151 
152     function totalEthereumBalance() public view returns (uint256) {
153         return this.balance;
154     }
155 
156     function totalSupply() public view returns (uint256) {
157         return tokenSupply_;
158     }
159 
160     function myTokens() public view returns (uint256) {
161         address _customerAddress = msg.sender;
162         return balanceOf(_customerAddress);
163     }
164 
165     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
166         address _customerAddress = msg.sender;
167         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
168     }
169 
170     function balanceOf(address _customerAddress) public view returns (uint256) {
171         return tokenBalanceLedger_[_customerAddress];
172     }
173 
174     function dividendsOf(address _customerAddress) public view returns (uint256) {
175         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
176     }
177 
178     function sellPrice() public view returns (uint256) {
179         // our calculation relies on the token supply, so we need supply. Doh.
180         if (tokenSupply_ == 0) {
181             return tokenPriceInitial_ - tokenPriceIncremental_;
182         } else {
183             uint256 _ethereum = tokensToEthereum_(1e18);
184             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
185             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
186 
187             return _taxedEthereum;
188         }
189     }
190 
191     function buyPrice() public view returns (uint256) {
192         if (tokenSupply_ == 0) {
193             return tokenPriceInitial_ + tokenPriceIncremental_;
194         } else {
195             uint256 _ethereum = tokensToEthereum_(1e18);
196             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
197             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
198 
199             return _taxedEthereum;
200         }
201     }
202 
203     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
204         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
205         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
206         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
207 
208         return _amountOfTokens;
209     }
210 
211     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
212         require(_tokensToSell <= tokenSupply_);
213         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
214         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
215         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
216         return _taxedEthereum;
217     }
218 
219 
220     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
221         address _customerAddress = msg.sender;
222         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
223         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
224         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
225         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
226         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
227         uint256 _fee = _dividends * magnitude;
228 
229         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
230 
231         if (
232             _referredBy != 0x0000000000000000000000000000000000000000 &&
233             _referredBy != _customerAddress &&
234             tokenBalanceLedger_[_referredBy] >= stakingRequirement
235         ) {
236             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
237         } else {
238             _dividends = SafeMath.add(_dividends, _referralBonus);
239             _fee = _dividends * magnitude;
240         }
241 
242         if (tokenSupply_ > 0) {
243             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
244             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
245             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
246         } else {
247             tokenSupply_ = _amountOfTokens;
248         }
249 
250         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
251         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
252         payoutsTo_[_customerAddress] += _updatedPayouts;
253         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
254 
255         return _amountOfTokens;
256     }
257 
258     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
259         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
260         uint256 _tokensReceived =
261             (
262                 (
263                     SafeMath.sub(
264                         (sqrt
265                             (
266                                 (_tokenPriceInitial ** 2)
267                                 +
268                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
269                                 +
270                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
271                                 +
272                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
273                             )
274                         ), _tokenPriceInitial
275                     )
276                 ) / (tokenPriceIncremental_)
277             ) - (tokenSupply_);
278 
279         return _tokensReceived;
280     }
281 
282     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
283         uint256 tokens_ = (_tokens + 1e18);
284         uint256 _tokenSupply = (tokenSupply_ + 1e18);
285         uint256 _etherReceived =
286             (
287                 SafeMath.sub(
288                     (
289                         (
290                             (
291                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
292                             ) - tokenPriceIncremental_
293                         ) * (tokens_ - 1e18)
294                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
295                 )
296                 / 1e18);
297 
298         return _etherReceived;
299     }
300 
301     function sqrt(uint256 x) internal pure returns (uint256 y) {
302         uint256 z = (x + 1) / 2;
303         y = x;
304 
305         while (z < y) {
306             y = z;
307             z = (x / z + z) / 2;
308         }
309     }
310 
311 
312 }
313 
314 library SafeMath {
315     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
316         if (a == 0) {
317             return 0;
318         }
319         uint256 c = a * b;
320         assert(c / a == b);
321         return c;
322     }
323 
324     function div(uint256 a, uint256 b) internal pure returns (uint256) {
325         uint256 c = a / b;
326         return c;
327     }
328 
329     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
330         assert(b <= a);
331         return a - b;
332     }
333 
334     function add(uint256 a, uint256 b) internal pure returns (uint256) {
335         uint256 c = a + b;
336         assert(c >= a);
337         return c;
338     }
339 }