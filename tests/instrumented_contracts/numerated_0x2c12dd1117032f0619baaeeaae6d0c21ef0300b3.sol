1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://minertoken.club
5 *
6 * Crypto miner token concept
7 *
8 * [✓] 3% Withdraw fee
9 * [✓] 12% Deposit fee
10 * [✓] 1% Token transfer
11 * [✓] 33% Referal link
12 *
13 */
14 
15 contract CryptoMinerTokenNew {
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
61     string public name = "Crypto Miner Token New";
62     string public symbol = "CMTN";
63     uint8 constant public decimals = 18;
64     uint8 constant internal entryFee_ = 12;
65     uint8 constant internal transferFee_ = 1;
66     uint8 constant internal exitFee_ = 3;
67     uint8 constant internal refferalFee_ = 33;
68     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
69     uint256 constant internal tokenPriceIncremental_ = 0.0000001 ether;
70     uint256 constant internal magnitude = 2 ** 64;
71     uint256 public stakingRequirement = 50e18;
72     mapping(address => uint256) internal tokenBalanceLedger_;
73     mapping(address => uint256) internal referralBalance_;
74     mapping(address => int256) internal payoutsTo_;
75     uint256 internal tokenSupply_;
76     uint256 internal profitPerShare_;
77 
78     function buy(address _referredBy) public payable returns (uint256) {
79         purchaseTokens(msg.value, _referredBy);
80     }
81 
82     function() payable public {
83         purchaseTokens(msg.value, 0x0);
84     }
85 
86     function reinvest() onlyStronghands public {
87         uint256 _dividends = myDividends(false);
88         address _customerAddress = msg.sender;
89         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
90         _dividends += referralBalance_[_customerAddress];
91         referralBalance_[_customerAddress] = 0;
92         uint256 _tokens = purchaseTokens(_dividends, 0x0);
93         emit onReinvestment(_customerAddress, _dividends, _tokens);
94     }
95 
96     function exit() public {
97         address _customerAddress = msg.sender;
98         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
99         if (_tokens > 0) sell(_tokens);
100         withdraw();
101     }
102 
103     function withdraw() onlyStronghands public {
104         address _customerAddress = msg.sender;
105         uint256 _dividends = myDividends(false);
106         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
107         _dividends += referralBalance_[_customerAddress];
108         referralBalance_[_customerAddress] = 0;
109         _customerAddress.transfer(_dividends);
110         emit onWithdraw(_customerAddress, _dividends);
111     }
112 
113     function sell(uint256 _amountOfTokens) onlyBagholders public {
114         address _customerAddress = msg.sender;
115         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
116         uint256 _tokens = _amountOfTokens;
117         uint256 _ethereum = tokensToEthereum_(_tokens);
118         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
119         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
120 
121         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
122         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
123 
124         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
125         payoutsTo_[_customerAddress] -= _updatedPayouts;
126 
127         if (tokenSupply_ > 0) {
128             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
129         }
130         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
131     }
132 
133     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
134         address _customerAddress = msg.sender;
135         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
136 
137         if (myDividends(true) > 0) {
138             withdraw();
139         }
140 
141         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
142         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
143         uint256 _dividends = tokensToEthereum_(_tokenFee);
144 
145         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
146         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
147         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
148         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
149         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
150         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
151         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
152         return true;
153     }
154 
155 
156     function totalEthereumBalance() public view returns (uint256) {
157         return this.balance;
158     }
159 
160     function totalSupply() public view returns (uint256) {
161         return tokenSupply_;
162     }
163 
164     function myTokens() public view returns (uint256) {
165         address _customerAddress = msg.sender;
166         return balanceOf(_customerAddress);
167     }
168 
169     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
170         address _customerAddress = msg.sender;
171         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
172     }
173 
174     function balanceOf(address _customerAddress) public view returns (uint256) {
175         return tokenBalanceLedger_[_customerAddress];
176     }
177 
178     function dividendsOf(address _customerAddress) public view returns (uint256) {
179         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
180     }
181 
182     function sellPrice() public view returns (uint256) {
183         // our calculation relies on the token supply, so we need supply. Doh.
184         if (tokenSupply_ == 0) {
185             return tokenPriceInitial_ - tokenPriceIncremental_;
186         } else {
187             uint256 _ethereum = tokensToEthereum_(1e18);
188             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
189             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
190 
191             return _taxedEthereum;
192         }
193     }
194 
195     function buyPrice() public view returns (uint256) {
196         if (tokenSupply_ == 0) {
197             return tokenPriceInitial_ + tokenPriceIncremental_;
198         } else {
199             uint256 _ethereum = tokensToEthereum_(1e18);
200             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
201             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
202 
203             return _taxedEthereum;
204         }
205     }
206 
207     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
208         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
209         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
210         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
211 
212         return _amountOfTokens;
213     }
214 
215     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
216         require(_tokensToSell <= tokenSupply_);
217         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
218         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
219         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
220         return _taxedEthereum;
221     }
222 
223 
224     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
225         address _customerAddress = msg.sender;
226         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
227         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
228         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
229         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
230         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
231         uint256 _fee = _dividends * magnitude;
232 
233         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
234 
235         if (
236             _referredBy != 0x0000000000000000000000000000000000000000 &&
237             _referredBy != _customerAddress &&
238             tokenBalanceLedger_[_referredBy] >= stakingRequirement
239         ) {
240             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
241         } else {
242             _dividends = SafeMath.add(_dividends, _referralBonus);
243             _fee = _dividends * magnitude;
244         }
245 
246         if (tokenSupply_ > 0) {
247             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
248             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
249             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
250         } else {
251             tokenSupply_ = _amountOfTokens;
252         }
253 
254         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
255         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
256         payoutsTo_[_customerAddress] += _updatedPayouts;
257         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
258 
259         return _amountOfTokens;
260     }
261 
262     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
263         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
264         uint256 _tokensReceived =
265             (
266                 (
267                     SafeMath.sub(
268                         (sqrt
269                             (
270                                 (_tokenPriceInitial ** 2)
271                                 +
272                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
273                                 +
274                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
275                                 +
276                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
277                             )
278                         ), _tokenPriceInitial
279                     )
280                 ) / (tokenPriceIncremental_)
281             ) - (tokenSupply_);
282 
283         return _tokensReceived;
284     }
285 
286     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
287         uint256 tokens_ = (_tokens + 1e18);
288         uint256 _tokenSupply = (tokenSupply_ + 1e18);
289         uint256 _etherReceived =
290             (
291                 SafeMath.sub(
292                     (
293                         (
294                             (
295                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
296                             ) - tokenPriceIncremental_
297                         ) * (tokens_ - 1e18)
298                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
299                 )
300                 / 1e18);
301 
302         return _etherReceived;
303     }
304 
305     function sqrt(uint256 x) internal pure returns (uint256 y) {
306         uint256 z = (x + 1) / 2;
307         y = x;
308 
309         while (z < y) {
310             y = z;
311             z = (x / z + z) / 2;
312         }
313     }
314 
315 
316 }
317 
318 library SafeMath {
319     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
320         if (a == 0) {
321             return 0;
322         }
323         uint256 c = a * b;
324         assert(c / a == b);
325         return c;
326     }
327 
328     function div(uint256 a, uint256 b) internal pure returns (uint256) {
329         uint256 c = a / b;
330         return c;
331     }
332 
333     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
334         assert(b <= a);
335         return a - b;
336     }
337 
338     function add(uint256 a, uint256 b) internal pure returns (uint256) {
339         uint256 c = a + b;
340         assert(c >= a);
341         return c;
342     }
343 }