1 pragma solidity ^0.4.25;
2 
3 /*
4 * http://www.miningtoken.ru/
5 * http://miningtoken.ru/  
6 * https://www.miningtoken.ru/
7 * https://t.me/cryptominerplus
8 *
9 * Crypto mining token concept
10 *
11 * [✓] 4% Withdraw fee
12 * [✓] 10% Deposit fee
13 * [✓] 1% Token transfer
14 * [✓] 33% Referal link
15 *
16 */
17 
18 contract CryptoMinerPlus {
19 
20     modifier onlyBagholders {
21         require(myTokens() > 0);
22         _;
23     }
24 
25     modifier onlyStronghands {
26         require(myDividends(true) > 0);
27         _;
28     }
29 
30     event onTokenPurchase(
31         address indexed customerAddress,
32         uint256 incomingEthereum,
33         uint256 tokensMinted,
34         address indexed referredBy,
35         uint timestamp,
36         uint256 price
37 );
38 
39     event onTokenSell(
40         address indexed customerAddress,
41         uint256 tokensBurned,
42         uint256 ethereumEarned,
43         uint timestamp,
44         uint256 price
45 );
46 
47     event onReinvestment(
48         address indexed customerAddress,
49         uint256 ethereumReinvested,
50         uint256 tokensMinted
51 );
52 
53     event onWithdraw(
54         address indexed customerAddress,
55         uint256 ethereumWithdrawn
56 );
57 
58     event Transfer(
59         address indexed from,
60         address indexed to,
61         uint256 tokens
62 );
63 
64     string public name = "Crypto Miner Plus";
65     string public symbol = "CMP";
66     uint8 constant public decimals = 18;
67     uint8 constant internal entryFee_ = 10;
68     uint8 constant internal transferFee_ = 1;
69     uint8 constant internal exitFee_ = 4;
70     uint8 constant internal refferalFee_ = 33;
71     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
72     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
73     uint256 constant internal magnitude = 2 ** 64;
74     uint256 public stakingRequirement = 50e18;
75     mapping(address => uint256) internal tokenBalanceLedger_;
76     mapping(address => uint256) internal referralBalance_;
77     mapping(address => int256) internal payoutsTo_;
78     uint256 internal tokenSupply_;
79     uint256 internal profitPerShare_;
80 
81     function buy(address _referredBy) public payable returns (uint256) {
82         purchaseTokens(msg.value, _referredBy);
83     }
84 
85     function() payable public {
86         purchaseTokens(msg.value, 0x0);
87     }
88 
89     function reinvest() onlyStronghands public {
90         uint256 _dividends = myDividends(false);
91         address _customerAddress = msg.sender;
92         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
93         _dividends += referralBalance_[_customerAddress];
94         referralBalance_[_customerAddress] = 0;
95         uint256 _tokens = purchaseTokens(_dividends, 0x0);
96         emit onReinvestment(_customerAddress, _dividends, _tokens);
97     }
98 
99     function exit() public {
100         address _customerAddress = msg.sender;
101         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
102         if (_tokens > 0) sell(_tokens);
103         withdraw();
104     }
105 
106     function withdraw() onlyStronghands public {
107         address _customerAddress = msg.sender;
108         uint256 _dividends = myDividends(false);
109         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
110         _dividends += referralBalance_[_customerAddress];
111         referralBalance_[_customerAddress] = 0;
112         _customerAddress.transfer(_dividends);
113         emit onWithdraw(_customerAddress, _dividends);
114     }
115 
116     function sell(uint256 _amountOfTokens) onlyBagholders public {
117         address _customerAddress = msg.sender;
118         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
119         uint256 _tokens = _amountOfTokens;
120         uint256 _ethereum = tokensToEthereum_(_tokens);
121         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
122         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
123 
124         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
125         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
126 
127         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
128         payoutsTo_[_customerAddress] -= _updatedPayouts;
129 
130         if (tokenSupply_ > 0) {
131             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
132         }
133         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
134     }
135 
136     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
137         address _customerAddress = msg.sender;
138         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
139 
140         if (myDividends(true) > 0) {
141             withdraw();
142         }
143 
144         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
145         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
146         uint256 _dividends = tokensToEthereum_(_tokenFee);
147 
148         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
149         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
150         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
151         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
152         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
153         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
154         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
155         return true;
156     }
157 
158 
159     function totalEthereumBalance() public view returns (uint256) {
160         return this.balance;
161     }
162 
163     function totalSupply() public view returns (uint256) {
164         return tokenSupply_;
165     }
166 
167     function myTokens() public view returns (uint256) {
168         address _customerAddress = msg.sender;
169         return balanceOf(_customerAddress);
170     }
171 
172     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
173         address _customerAddress = msg.sender;
174         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
175     }
176 
177     function balanceOf(address _customerAddress) public view returns (uint256) {
178         return tokenBalanceLedger_[_customerAddress];
179     }
180 
181     function dividendsOf(address _customerAddress) public view returns (uint256) {
182         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
183     }
184 
185     function sellPrice() public view returns (uint256) {
186         // our calculation relies on the token supply, so we need supply. Doh.
187         if (tokenSupply_ == 0) {
188             return tokenPriceInitial_ - tokenPriceIncremental_;
189         } else {
190             uint256 _ethereum = tokensToEthereum_(1e18);
191             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
192             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
193 
194             return _taxedEthereum;
195         }
196     }
197 
198     function buyPrice() public view returns (uint256) {
199         if (tokenSupply_ == 0) {
200             return tokenPriceInitial_ + tokenPriceIncremental_;
201         } else {
202             uint256 _ethereum = tokensToEthereum_(1e18);
203             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
204             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
205 
206             return _taxedEthereum;
207         }
208     }
209 
210     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
211         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
212         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
213         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
214 
215         return _amountOfTokens;
216     }
217 
218     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
219         require(_tokensToSell <= tokenSupply_);
220         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
221         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
222         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
223         return _taxedEthereum;
224     }
225 
226 
227     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
228         address _customerAddress = msg.sender;
229         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
230         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
231         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
232         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
233         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
234         uint256 _fee = _dividends * magnitude;
235 
236         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
237 
238         if (
239             _referredBy != 0x0000000000000000000000000000000000000000 &&
240             _referredBy != _customerAddress &&
241             tokenBalanceLedger_[_referredBy] >= stakingRequirement
242         ) {
243             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
244         } else {
245             _dividends = SafeMath.add(_dividends, _referralBonus);
246             _fee = _dividends * magnitude;
247         }
248 
249         if (tokenSupply_ > 0) {
250             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
251             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
252             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
253         } else {
254             tokenSupply_ = _amountOfTokens;
255         }
256 
257         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
258         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
259         payoutsTo_[_customerAddress] += _updatedPayouts;
260         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
261 
262         return _amountOfTokens;
263     }
264 
265     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
266         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
267         uint256 _tokensReceived =
268             (
269                 (
270                     SafeMath.sub(
271                         (sqrt
272                             (
273                                 (_tokenPriceInitial ** 2)
274                                 +
275                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
276                                 +
277                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
278                                 +
279                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
280                             )
281                         ), _tokenPriceInitial
282                     )
283                 ) / (tokenPriceIncremental_)
284             ) - (tokenSupply_);
285 
286         return _tokensReceived;
287     }
288 
289     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
290         uint256 tokens_ = (_tokens + 1e18);
291         uint256 _tokenSupply = (tokenSupply_ + 1e18);
292         uint256 _etherReceived =
293             (
294                 SafeMath.sub(
295                     (
296                         (
297                             (
298                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
299                             ) - tokenPriceIncremental_
300                         ) * (tokens_ - 1e18)
301                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
302                 )
303                 / 1e18);
304 
305         return _etherReceived;
306     }
307 
308     function sqrt(uint256 x) internal pure returns (uint256 y) {
309         uint256 z = (x + 1) / 2;
310         y = x;
311 
312         while (z < y) {
313             y = z;
314             z = (x / z + z) / 2;
315         }
316     }
317 
318 
319 }
320 
321 library SafeMath {
322     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
323         if (a == 0) {
324             return 0;
325         }
326         uint256 c = a * b;
327         assert(c / a == b);
328         return c;
329     }
330 
331     function div(uint256 a, uint256 b) internal pure returns (uint256) {
332         uint256 c = a / b;
333         return c;
334     }
335 
336     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
337         assert(b <= a);
338         return a - b;
339     }
340 
341     function add(uint256 a, uint256 b) internal pure returns (uint256) {
342         uint256 c = a + b;
343         assert(c >= a);
344         return c;
345     }
346 }