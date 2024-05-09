1 pragma solidity ^0.4.25;
2 
3 /*
4  [Rules]
5 
6  [✓] 10% Deposit fee
7             40% => referrer (or contract owner, if none)
8             40% => contract owner
9             20% => dividends
10  [✓] 5% Withdraw fee
11             80% => contract owner
12             20% => dividends
13  [✓] 1% Token transfer
14             100% => dividends
15 */
16 
17 contract CryptoRichmanToken {
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
35     );
36 
37     event onTokenSell(
38         address indexed customerAddress,
39         uint256 tokensBurned,
40         uint256 ethereumEarned,
41         uint timestamp,
42         uint256 price
43     );
44 
45     event onReinvestment(
46         address indexed customerAddress,
47         uint256 ethereumReinvested,
48         uint256 tokensMinted
49     );
50 
51     event onWithdraw(
52         address indexed customerAddress,
53         uint256 ethereumWithdrawn
54     );
55 
56     event Transfer(
57         address indexed from,
58         address indexed to,
59         uint256 tokens
60     );
61 
62     string public name = "Crypto Richman Token";
63     string public symbol = "CRT";
64     address constant internal boss = 0x26D5B6451048cb11a62abe605E85CB0966F0e322;
65     uint8 constant public decimals = 18;
66     uint8 constant internal entryFee_ = 10;
67     uint8 constant internal transferFee_ = 1;
68     uint8 constant internal exitFee_ = 5;
69     uint8 constant internal refferalFee_ = 40;
70     uint8 constant internal ownerFee1 = 40; /* purchase */
71     uint8 constant internal ownerFee2 = 80; /* sell */
72     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
73     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
74     uint256 constant internal magnitude = 2 ** 64;
75     uint256 public stakingRequirement = 50e18;
76     mapping(address => uint256) internal tokenBalanceLedger_;
77     mapping(address => uint256) internal referralBalance_;
78     mapping(address => int256) internal payoutsTo_;
79     uint256 internal tokenSupply_;
80     uint256 internal profitPerShare_;
81 
82     function buy(address _referredBy) public payable returns (uint256) {
83         return purchaseTokens(msg.value, _referredBy);
84     }
85 
86     function() payable public {
87         purchaseTokens(msg.value, 0x0);
88     }
89 
90     function reinvest() onlyStronghands public {
91         uint256 _dividends = myDividends(false);
92         address _customerAddress = msg.sender;
93         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
94         _dividends += referralBalance_[_customerAddress];
95         referralBalance_[_customerAddress] = 0;
96         uint256 _tokens = purchaseTokens(_dividends, 0x0);
97         emit onReinvestment(_customerAddress, _dividends, _tokens);
98     }
99 
100     function exit() public {
101         address _customerAddress = msg.sender;
102         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
103         if (_tokens > 0) sell(_tokens);
104         withdraw();
105     }
106 
107     function withdraw() onlyStronghands public {
108         address _customerAddress = msg.sender;
109         uint256 _dividends = myDividends(false);
110         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
111         _dividends += referralBalance_[_customerAddress];
112         referralBalance_[_customerAddress] = 0;
113         _customerAddress.transfer(_dividends);
114         emit onWithdraw(_customerAddress, _dividends);
115     }
116 
117     function sell(uint256 _amountOfTokens) onlyBagholders public {
118         address _customerAddress = msg.sender;
119         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
120         uint256 _tokens = _amountOfTokens;
121         uint256 _ethereum = tokensToEthereum_(_tokens);
122         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
123         uint256 forBoss = SafeMath.div(SafeMath.mul(_dividends, ownerFee2), 100);
124         _dividends = SafeMath.sub(_dividends, forBoss);
125         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
126 
127         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
128         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
129 
130         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
131         payoutsTo_[_customerAddress] -= _updatedPayouts;
132         referralBalance_[boss] = SafeMath.add(referralBalance_[boss], forBoss);
133 
134         if (tokenSupply_ > 0) {
135             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
136         }
137         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
138     }
139 
140     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
141         address _customerAddress = msg.sender;
142         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
143 
144         if (myDividends(true) > 0) {
145             withdraw();
146         }
147 
148         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
149         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
150         uint256 _dividends = tokensToEthereum_(_tokenFee);
151 
152         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
153         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
154         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
155         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
156         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
157         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
158         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
159         return true;
160     }
161 
162     function totalEthereumBalance() public view returns (uint256) {
163         return address(this).balance;
164     }
165 
166     function totalSupply() public view returns (uint256) {
167         return tokenSupply_;
168     }
169 
170     function myTokens() public view returns (uint256) {
171         address _customerAddress = msg.sender;
172         return balanceOf(_customerAddress);
173     }
174 
175     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
176         address _customerAddress = msg.sender;
177         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
178     }
179 
180     function balanceOf(address _customerAddress) public view returns (uint256) {
181         return tokenBalanceLedger_[_customerAddress];
182     }
183 
184     function dividendsOf(address _customerAddress) public view returns (uint256) {
185         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
186     }
187 
188     function sellPrice() public view returns (uint256) {
189         if (tokenSupply_ == 0) {
190             return tokenPriceInitial_ - tokenPriceIncremental_;
191         } else {
192             uint256 _ethereum = tokensToEthereum_(1e18);
193             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
194             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
195 
196             return _taxedEthereum;
197         }
198     }
199 
200     function buyPrice() public view returns (uint256) {
201         if (tokenSupply_ == 0) {
202             return tokenPriceInitial_ + tokenPriceIncremental_;
203         } else {
204             uint256 _ethereum = tokensToEthereum_(1e18);
205             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
206             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
207 
208             return _taxedEthereum;
209         }
210     }
211 
212     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
213         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
214         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
215         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
216 
217         return _amountOfTokens;
218     }
219 
220     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
221         require(_tokensToSell <= tokenSupply_);
222         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
223         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
224         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
225         return _taxedEthereum;
226     }
227 
228     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
229         address _customerAddress = msg.sender;
230         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
231         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
232         uint256 forBoss = SafeMath.div(SafeMath.mul(_undividedDividends, ownerFee1), 100);
233         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
234         _dividends = SafeMath.sub(_dividends, forBoss);
235         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
236         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
237         uint256 _fee = _dividends * magnitude;
238 
239         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
240 
241         if (
242             _referredBy != 0x0000000000000000000000000000000000000000 &&
243             _referredBy != _customerAddress &&
244             tokenBalanceLedger_[_referredBy] >= stakingRequirement
245         ) {
246             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
247         } else {
248             referralBalance_[boss] = SafeMath.add(referralBalance_[boss], _referralBonus);
249         }
250 
251         referralBalance_[boss] = SafeMath.add(referralBalance_[boss], forBoss);
252 
253         if (tokenSupply_ > 0) {
254             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
255             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
256             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
257         } else {
258             tokenSupply_ = _amountOfTokens;
259         }
260 
261         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
262         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
263         payoutsTo_[_customerAddress] += _updatedPayouts;
264         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
265 
266         return _amountOfTokens;
267     }
268 
269     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
270         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
271         uint256 _tokensReceived =
272             (
273                 (
274                     SafeMath.sub(
275                         (sqrt
276                             (
277                                 (_tokenPriceInitial ** 2)
278                                 +
279                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
280                                 +
281                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
282                                 +
283                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
284                             )
285                         ), _tokenPriceInitial
286                     )
287                 ) / (tokenPriceIncremental_)
288             ) - (tokenSupply_);
289 
290         return _tokensReceived;
291     }
292 
293     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
294         uint256 tokens_ = (_tokens + 1e18);
295         uint256 _tokenSupply = (tokenSupply_ + 1e18);
296         uint256 _etherReceived =
297             (
298                 SafeMath.sub(
299                     (
300                         (
301                             (
302                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
303                             ) - tokenPriceIncremental_
304                         ) * (tokens_ - 1e18)
305                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
306                 )
307                 / 1e18);
308 
309         return _etherReceived;
310     }
311 
312     function sqrt(uint256 x) internal pure returns (uint256 y) {
313         uint256 z = (x + 1) / 2;
314         y = x;
315 
316         while (z < y) {
317             y = z;
318             z = (x / z + z) / 2;
319         }
320     }
321 }
322 
323 library SafeMath {
324     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
325         if (a == 0) {
326             return 0;
327         }
328         uint256 c = a * b;
329         require(c / a == b);
330         return c;
331     }
332 
333     function div(uint256 a, uint256 b) internal pure returns (uint256) {
334         require(b > 0);
335         uint256 c = a / b;
336         return c;
337     }
338 
339     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
340         require(b <= a);
341         return a - b;
342     }
343 
344     function add(uint256 a, uint256 b) internal pure returns (uint256) {
345         uint256 c = a + b;
346         require(c >= a);
347         return c;
348     }
349 }