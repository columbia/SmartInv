1 pragma solidity ^0.4.25;
2 
3 /*
4 * http://betterdivs.pw
5 *
6 * BetterDivs concept
7 *
8 * [✓] 10% Withdraw fee
9 * [✓] 20% Deposit fee
10 * [✓] 1% Token transfer
11 * [✓] No Referral Tokens Go to Everyone
12 * [✓] 5% Promotion
13 * BetterDivs is a platform built for short term minting profit accumulation. 
14 * Our service works as exchange wallet for securing your assets in form of decentralized fully automated (BDT) token. 
15 * Token is built to function without any 2nd or 3rd party control. 
16 * All tokens are visible on main network and traceable for full transparency with no governance or overseeing institution involved.
17 * Concept of this token works as follows: 
18 *    BDT Holders have increasing assets via hour that most of the time is being accumulated without any actual use-case. 
19 *    So when you collect your Minting profit of example 1.00 ETH after time it still remains as same amount of coins. 
20 *    Our goal is to change that. If you have accumulated assets worth 1.00 ETH and transform it into BDT you will receive matching amount of tokens to your ETH according to current market price. 
21 *    As token amount grows you will generate more and more ETH same as other users whom have joined the platform. 
22 *    Withdraw actions on platform conduct 10% withdraw fees from value that is transformed into BDT assets that works as return of investment for token holders within platform. 
23 *    While you keep your assets as long as accumulated enough growth % from (investment - fees) you have no risk of losing any assets. 
24 *    Therefore we would like to point out that while you join the platform and have not reached return that covers initial fee you have a very small risk of losing only assets paid in fees if a total market collapse occurs;
25 *    As for token holder you will earn shared amount of every transformation to BDT token or withdraw that is proportional your token amount vs total tokens in circulation. 
26 *    All fees conducted from any users on the platform are fully paid out to token holders without any fee.
27 *
28 */
29 
30 contract BetterDivs {
31 
32     modifier onlyBagholders {
33         require(myTokens() > 0);
34         _;
35     }
36 
37     modifier onlyStronghands {
38         require(myDividends(true) > 0);
39         _;
40     }
41 
42     event onTokenPurchase(
43         address indexed customerAddress,
44         uint256 incomingEthereum,
45         uint256 tokensMinted,
46         address indexed referredBy,
47         uint timestamp,
48         uint256 price
49 );
50 
51     event onTokenSell(
52         address indexed customerAddress,
53         uint256 tokensBurned,
54         uint256 ethereumEarned,
55         uint timestamp,
56         uint256 price
57 );
58 
59     event onReinvestment(
60         address indexed customerAddress,
61         uint256 ethereumReinvested,
62         uint256 tokensMinted
63 );
64 
65     event onWithdraw(
66         address indexed customerAddress,
67         uint256 ethereumWithdrawn
68 );
69 
70     event Transfer(
71         address indexed from,
72         address indexed to,
73         uint256 tokens
74 );
75 
76     string public name = "BetterDivsToken";
77     string public symbol = "BDT";
78     uint8 constant public decimals = 18;
79     address promo1 = 0x1b03379ef25085bee82a4b3e88c2dcf5881f8731;
80     address promo2 = 0x04afad681f265cf9f1ae14b01b28b40d745824b3;
81     uint8 constant internal entryFee_ = 20;
82     uint8 constant internal transferFee_ = 1;
83     uint8 constant internal exitFee_ = 10;
84     uint8 constant internal refferalFee_ = 0;
85     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
86     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
87     uint256 constant internal magnitude = 2 ** 64;
88     uint256 public stakingRequirement = 50e18;
89     mapping(address => uint256) internal tokenBalanceLedger_;
90     mapping(address => uint256) internal referralBalance_;
91     mapping(address => int256) internal payoutsTo_;
92     uint256 internal tokenSupply_;
93     uint256 internal profitPerShare_;
94 
95 mapping (address => uint256) balances;
96 mapping (address => uint256) timestamp;
97     
98     
99         
100     function buy(address _referredBy) public payable returns (uint256) {
101         purchaseTokens(msg.value, _referredBy);
102         uint256 getmsgvalue = msg.value / 20;
103         promo1.transfer(getmsgvalue);
104         promo2.transfer(getmsgvalue);
105     }
106 
107     function() payable public {
108         purchaseTokens(msg.value, 0x0);
109         uint256 getmsgvalue = msg.value / 20;
110         promo1.transfer(getmsgvalue);
111         promo2.transfer(getmsgvalue);
112     }
113 
114     function reinvest() onlyStronghands public {
115         uint256 _dividends = myDividends(false);
116         address _customerAddress = msg.sender;
117         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
118         _dividends += referralBalance_[_customerAddress];
119         referralBalance_[_customerAddress] = 0;
120         uint256 _tokens = purchaseTokens(_dividends, 0x0);
121         emit onReinvestment(_customerAddress, _dividends, _tokens);
122     }
123 
124     function exit() public {
125         address _customerAddress = msg.sender;
126         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
127         if (_tokens > 0) sell(_tokens);
128         withdraw();
129     }
130 
131     function withdraw() onlyStronghands public {
132         address _customerAddress = msg.sender;
133         uint256 _dividends = myDividends(false);
134         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
135         _dividends += referralBalance_[_customerAddress];
136         referralBalance_[_customerAddress] = 0;
137         _customerAddress.transfer(_dividends);
138         emit onWithdraw(_customerAddress, _dividends);
139     }
140 
141     function sell(uint256 _amountOfTokens) onlyBagholders public {
142         address _customerAddress = msg.sender;
143         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
144         uint256 _tokens = _amountOfTokens;
145         uint256 _ethereum = tokensToEthereum_(_tokens);
146         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
147         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
148 
149         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
150         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
151 
152         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
153         payoutsTo_[_customerAddress] -= _updatedPayouts;
154 
155         if (tokenSupply_ > 0) {
156             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
157         }
158         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
159     }
160 
161     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
162         address _customerAddress = msg.sender;
163         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
164 
165         if (myDividends(true) > 0) {
166             withdraw();
167         }
168 
169         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
170         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
171         uint256 _dividends = tokensToEthereum_(_tokenFee);
172 
173         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
174         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
175         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
176         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
177         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
178         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
179         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
180         return true;
181     }
182 
183 
184     function totalEthereumBalance() public view returns (uint256) {
185         return this.balance;
186     }
187 
188     function totalSupply() public view returns (uint256) {
189         return tokenSupply_;
190     }
191 
192     function myTokens() public view returns (uint256) {
193         address _customerAddress = msg.sender;
194         return balanceOf(_customerAddress);
195     }
196 
197     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
198         address _customerAddress = msg.sender;
199         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
200     }
201 
202     function balanceOf(address _customerAddress) public view returns (uint256) {
203         return tokenBalanceLedger_[_customerAddress];
204     }
205 
206     function dividendsOf(address _customerAddress) public view returns (uint256) {
207         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
208     }
209 
210     function sellPrice() public view returns (uint256) {
211         // our calculation relies on the token supply, so we need supply. Doh.
212         if (tokenSupply_ == 0) {
213             return tokenPriceInitial_ - tokenPriceIncremental_;
214         } else {
215             uint256 _ethereum = tokensToEthereum_(1e18);
216             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
217             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
218 
219             return _taxedEthereum;
220         }
221     }
222 
223     function buyPrice() public view returns (uint256) {
224         if (tokenSupply_ == 0) {
225             return tokenPriceInitial_ + tokenPriceIncremental_;
226         } else {
227             uint256 _ethereum = tokensToEthereum_(1e18);
228             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
229             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
230 
231             return _taxedEthereum;
232         }
233     }
234 
235     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
236         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
237         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
238         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
239 
240         return _amountOfTokens;
241     }
242 
243     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
244         require(_tokensToSell <= tokenSupply_);
245         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
246         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
247         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
248         return _taxedEthereum;
249     }
250 
251 
252     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
253         address _customerAddress = msg.sender;
254         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
255         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
256         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
257         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
258         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
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
277             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
278         } else {
279             tokenSupply_ = _amountOfTokens;
280         }
281 
282         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
283         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
284         payoutsTo_[_customerAddress] += _updatedPayouts;
285         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
286 
287         return _amountOfTokens;
288     }
289 
290     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
291         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
292         uint256 _tokensReceived =
293             (
294                 (
295                     SafeMath.sub(
296                         (sqrt
297                             (
298                                 (_tokenPriceInitial ** 2)
299                                 +
300                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
301                                 +
302                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
303                                 +
304                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
305                             )
306                         ), _tokenPriceInitial
307                     )
308                 ) / (tokenPriceIncremental_)
309             ) - (tokenSupply_);
310 
311         return _tokensReceived;
312     }
313 
314     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
315         uint256 tokens_ = (_tokens + 1e18);
316         uint256 _tokenSupply = (tokenSupply_ + 1e18);
317         uint256 _etherReceived =
318             (
319                 SafeMath.sub(
320                     (
321                         (
322                             (
323                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
324                             ) - tokenPriceIncremental_
325                         ) * (tokens_ - 1e18)
326                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
327                 )
328                 / 1e18);
329 
330         return _etherReceived;
331     }
332 
333     function sqrt(uint256 x) internal pure returns (uint256 y) {
334         uint256 z = (x + 1) / 2;
335         y = x;
336 
337         while (z < y) {
338             y = z;
339             z = (x / z + z) / 2;
340         }
341     }
342 
343 
344 }
345 
346 library SafeMath {
347     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
348         if (a == 0) {
349             return 0;
350         }
351         uint256 c = a * b;
352         assert(c / a == b);
353         return c;
354     }
355 
356     function div(uint256 a, uint256 b) internal pure returns (uint256) {
357         uint256 c = a / b;
358         return c;
359     }
360 
361     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
362         assert(b <= a);
363         return a - b;
364     }
365 
366     function add(uint256 a, uint256 b) internal pure returns (uint256) {
367         uint256 c = a + b;
368         assert(c >= a);
369         return c;
370     }
371 }