1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://12hourtoken.github.io
5 * Hold to die
6 * [✓] 40% Withdraw fee
7 * [✓] 40 Deposit fee
8 * [✓] 0% Token transfer
9 * [✓] 10% Referal link
10 *
11 */
12 
13 contract TwelveHourToken {
14 
15     modifier onlyBagholders {
16         require(myTokens() > 0);
17         _;
18     }
19 
20     modifier onlyStronghands {
21         require(myDividends(true) > 0);
22         _;
23     }
24 
25     event onTokenPurchase(
26         address indexed customerAddress,
27         uint256 incomingEthereum,
28         uint256 tokensMinted,
29         address indexed referredBy,
30         uint timestamp,
31         uint256 price
32 	);
33 
34     event onTokenSell(
35         address indexed customerAddress,
36         uint256 tokensBurned,
37         uint256 ethereumEarned,
38         uint timestamp,
39         uint256 price
40 	);
41 
42     event onReinvestment(
43         address indexed customerAddress,
44         uint256 ethereumReinvested,
45         uint256 tokensMinted
46 	);
47 
48     event onWithdraw(
49         address indexed customerAddress,
50         uint256 ethereumWithdrawn
51 	);
52 
53     event Transfer(
54         address indexed from,
55         address indexed to,
56         uint256 tokens
57 	);
58 
59     string public name = "12 Hour Token";
60     string public symbol = "THT";
61     uint8 constant public decimals = 18;
62     uint8 constant internal entryFee_ = 40;
63     uint8 constant internal transferFee_ = 0;
64     uint8 constant internal exitFee_ = 40;
65     uint8 constant internal refferalFee_ = 10;
66     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
67     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
68     uint256 constant internal magnitude = 2 ** 64;
69     uint256 public stakingRequirement = 50e18;
70     mapping(address => uint256) internal tokenBalanceLedger_;
71     mapping(address => uint256) internal referralBalance_;
72     mapping(address => int256) internal payoutsTo_;
73     uint256 internal tokenSupply_;
74     uint256 internal profitPerShare_;
75 
76     function buy(address _referredBy) public payable returns (uint256) {
77         purchaseTokens(msg.value, _referredBy);
78     }
79 
80     function() payable public {
81         purchaseTokens(msg.value, 0x0);
82     }
83 
84     function reinvest() onlyStronghands public {
85         uint256 _dividends = myDividends(false);
86         address _customerAddress = msg.sender;
87         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
88         _dividends += referralBalance_[_customerAddress];
89         referralBalance_[_customerAddress] = 0;
90         uint256 _tokens = purchaseTokens(_dividends, 0x0);
91         emit onReinvestment(_customerAddress, _dividends, _tokens);
92     }
93 
94     function exit() public {
95         address _customerAddress = msg.sender;
96         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
97         if (_tokens > 0) sell(_tokens);
98         withdraw();
99     }
100 
101     function withdraw() onlyStronghands public {
102         address _customerAddress = msg.sender;
103         uint256 _dividends = myDividends(false);
104         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
105         _dividends += referralBalance_[_customerAddress];
106         referralBalance_[_customerAddress] = 0;
107         _customerAddress.transfer(_dividends);
108         emit onWithdraw(_customerAddress, _dividends);
109     }
110 
111     function sell(uint256 _amountOfTokens) onlyBagholders public {
112         address _customerAddress = msg.sender;
113         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
114         uint256 _tokens = _amountOfTokens;
115         uint256 _ethereum = tokensToEthereum_(_tokens);
116         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
117         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
118 
119         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
120         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
121 
122         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
123         payoutsTo_[_customerAddress] -= _updatedPayouts;
124 
125         if (tokenSupply_ > 0) {
126             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
127         }
128         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
129     }
130 
131     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
132         address _customerAddress = msg.sender;
133         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
134 
135         if (myDividends(true) > 0) {
136             withdraw();
137         }
138 
139         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
140         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
141         uint256 _dividends = tokensToEthereum_(_tokenFee);
142 
143         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
144         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
145         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
146         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
147         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
148         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
149         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
150         return true;
151     }
152 
153 
154     function totalEthereumBalance() public view returns (uint256) {
155         return this.balance;
156     }
157 
158     function totalSupply() public view returns (uint256) {
159         return tokenSupply_;
160     }
161 
162     function myTokens() public view returns (uint256) {
163         address _customerAddress = msg.sender;
164         return balanceOf(_customerAddress);
165     }
166 
167     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
168         address _customerAddress = msg.sender;
169         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
170     }
171 
172     function balanceOf(address _customerAddress) public view returns (uint256) {
173         return tokenBalanceLedger_[_customerAddress];
174     }
175 
176     function dividendsOf(address _customerAddress) public view returns (uint256) {
177         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
178     }
179 
180     function sellPrice() public view returns (uint256) {
181         // our calculation relies on the token supply, so we need supply. Doh.
182         if (tokenSupply_ == 0) {
183             return tokenPriceInitial_ - tokenPriceIncremental_;
184         } else {
185             uint256 _ethereum = tokensToEthereum_(1e18);
186             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
187             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
188 
189             return _taxedEthereum;
190         }
191     }
192 
193     function buyPrice() public view returns (uint256) {
194         if (tokenSupply_ == 0) {
195             return tokenPriceInitial_ + tokenPriceIncremental_;
196         } else {
197             uint256 _ethereum = tokensToEthereum_(1e18);
198             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
199             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
200 
201             return _taxedEthereum;
202         }
203     }
204 
205     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
206         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
207         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
208         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
209 
210         return _amountOfTokens;
211     }
212 
213     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
214         require(_tokensToSell <= tokenSupply_);
215         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
216         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
217         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
218         return _taxedEthereum;
219     }
220 
221 
222     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
223         address _customerAddress = msg.sender;
224         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
225         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
226         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
227         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
228         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
229         uint256 _fee = _dividends * magnitude;
230 
231         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
232 
233         if (
234             _referredBy != 0x0000000000000000000000000000000000000000 &&
235             _referredBy != _customerAddress &&
236             tokenBalanceLedger_[_referredBy] >= stakingRequirement
237         ) {
238             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
239         } else {
240             _dividends = SafeMath.add(_dividends, _referralBonus);
241             _fee = _dividends * magnitude;
242         }
243 
244         if (tokenSupply_ > 0) {
245             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
246             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
247             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
248         } else {
249             tokenSupply_ = _amountOfTokens;
250         }
251 
252         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
253         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
254         payoutsTo_[_customerAddress] += _updatedPayouts;
255         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
256 
257         return _amountOfTokens;
258     }
259 
260     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
261         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
262         uint256 _tokensReceived =
263             (
264                 (
265                     SafeMath.sub(
266                         (sqrt
267                             (
268                                 (_tokenPriceInitial ** 2)
269                                 +
270                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
271                                 +
272                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
273                                 +
274                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
275                             )
276                         ), _tokenPriceInitial
277                     )
278                 ) / (tokenPriceIncremental_)
279             ) - (tokenSupply_);
280 
281         return _tokensReceived;
282     }
283 
284     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
285         uint256 tokens_ = (_tokens + 1e18);
286         uint256 _tokenSupply = (tokenSupply_ + 1e18);
287         uint256 _etherReceived =
288             (
289                 SafeMath.sub(
290                     (
291                         (
292                             (
293                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
294                             ) - tokenPriceIncremental_
295                         ) * (tokens_ - 1e18)
296                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
297                 )
298                 / 1e18);
299 
300         return _etherReceived;
301     }
302 
303     function sqrt(uint256 x) internal pure returns (uint256 y) {
304         uint256 z = (x + 1) / 2;
305         y = x;
306 
307         while (z < y) {
308             y = z;
309             z = (x / z + z) / 2;
310         }
311     }
312 
313 
314 }
315 
316 library SafeMath {
317     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
318         if (a == 0) {
319             return 0;
320         }
321         uint256 c = a * b;
322         assert(c / a == b);
323         return c;
324     }
325 
326     function div(uint256 a, uint256 b) internal pure returns (uint256) {
327         uint256 c = a / b;
328         return c;
329     }
330 
331     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
332         assert(b <= a);
333         return a - b;
334     }
335 
336     function add(uint256 a, uint256 b) internal pure returns (uint256) {
337         uint256 c = a + b;
338         assert(c >= a);
339         return c;
340     }
341 }