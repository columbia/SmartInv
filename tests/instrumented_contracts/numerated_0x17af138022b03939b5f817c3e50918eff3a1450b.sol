1 pragma solidity ^0.4.25;
2 
3 /*
4  [Rules]
5 
6  [✓] 10% Deposit fee
7             33% => referrer (or contract owner, if none)
8             10% => contract owner
9             57% => dividends
10  [✓] 4% Withdraw fee
11             25% => contract owner
12             75% => dividends
13  [✓] 1% Token transfer
14             100% => dividends
15 */
16 
17 contract MoonProjectToken {
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
62     string public name = "Moon Project Token";
63     string public symbol = "MPT";
64     address constant internal boss = 0xf5CfBA66DCe0C942d06d374Ba8C66A71BE886077;
65     uint8 constant public decimals = 18;
66     uint8 constant internal entryFee_ = 10;
67     uint8 constant internal transferFee_ = 1;
68     uint8 constant internal exitFee_ = 4;
69     uint8 constant internal refferalFee_ = 33;
70     uint8 constant internal ownerFee1 = 10;
71     uint8 constant internal ownerFee2 = 25;
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
162 
163     function totalEthereumBalance() public view returns (uint256) {
164         return address(this).balance;
165     }
166 
167     function totalSupply() public view returns (uint256) {
168         return tokenSupply_;
169     }
170 
171     function myTokens() public view returns (uint256) {
172         address _customerAddress = msg.sender;
173         return balanceOf(_customerAddress);
174     }
175 
176     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
177         address _customerAddress = msg.sender;
178         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
179     }
180 
181     function balanceOf(address _customerAddress) public view returns (uint256) {
182         return tokenBalanceLedger_[_customerAddress];
183     }
184 
185     function dividendsOf(address _customerAddress) public view returns (uint256) {
186         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
187     }
188 
189     function sellPrice() public view returns (uint256) {
190         // our calculation relies on the token supply, so we need supply. Doh.
191         if (tokenSupply_ == 0) {
192             return tokenPriceInitial_ - tokenPriceIncremental_;
193         } else {
194             uint256 _ethereum = tokensToEthereum_(1e18);
195             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
196             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
197 
198             return _taxedEthereum;
199         }
200     }
201 
202     function buyPrice() public view returns (uint256) {
203         if (tokenSupply_ == 0) {
204             return tokenPriceInitial_ + tokenPriceIncremental_;
205         } else {
206             uint256 _ethereum = tokensToEthereum_(1e18);
207             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
208             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
209 
210             return _taxedEthereum;
211         }
212     }
213 
214     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
215         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
216         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
217         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
218 
219         return _amountOfTokens;
220     }
221 
222     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
223         require(_tokensToSell <= tokenSupply_);
224         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
225         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
226         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
227         return _taxedEthereum;
228     }
229 
230 
231     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
232         address _customerAddress = msg.sender;
233         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
234         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
235         uint256 forBoss = SafeMath.div(SafeMath.mul(_undividedDividends, ownerFee1), 100);
236         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
237         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
238         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
239         uint256 _fee = _dividends * magnitude;
240 
241         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
242 
243         if (
244             _referredBy != 0x0000000000000000000000000000000000000000 &&
245             _referredBy != _customerAddress &&
246             tokenBalanceLedger_[_referredBy] >= stakingRequirement
247         ) {
248             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
249         } else {
250             referralBalance_[boss] = SafeMath.add(referralBalance_[boss], _referralBonus);
251         }
252 
253         referralBalance_[boss] = SafeMath.add(referralBalance_[boss], forBoss);
254 
255         if (tokenSupply_ > 0) {
256             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
257             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
258             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
259         } else {
260             tokenSupply_ = _amountOfTokens;
261         }
262 
263         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
264         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
265         payoutsTo_[_customerAddress] += _updatedPayouts;
266         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
267 
268         return _amountOfTokens;
269     }
270 
271     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
272         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
273         uint256 _tokensReceived =
274             (
275                 (
276                     SafeMath.sub(
277                         (sqrt
278                             (
279                                 (_tokenPriceInitial ** 2)
280                                 +
281                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
282                                 +
283                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
284                                 +
285                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
286                             )
287                         ), _tokenPriceInitial
288                     )
289                 ) / (tokenPriceIncremental_)
290             ) - (tokenSupply_);
291 
292         return _tokensReceived;
293     }
294 
295     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
296         uint256 tokens_ = (_tokens + 1e18);
297         uint256 _tokenSupply = (tokenSupply_ + 1e18);
298         uint256 _etherReceived =
299             (
300                 SafeMath.sub(
301                     (
302                         (
303                             (
304                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
305                             ) - tokenPriceIncremental_
306                         ) * (tokens_ - 1e18)
307                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
308                 )
309                 / 1e18);
310 
311         return _etherReceived;
312     }
313 
314     function sqrt(uint256 x) internal pure returns (uint256 y) {
315         uint256 z = (x + 1) / 2;
316         y = x;
317 
318         while (z < y) {
319             y = z;
320             z = (x / z + z) / 2;
321         }
322     }
323 }
324 
325 library SafeMath {
326     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
327         if (a == 0) {
328             return 0;
329         }
330         uint256 c = a * b;
331         require(c / a == b);
332         return c;
333     }
334 
335     function div(uint256 a, uint256 b) internal pure returns (uint256) {
336         require(b > 0);
337         uint256 c = a / b;
338         return c;
339     }
340 
341     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
342         require(b <= a);
343         return a - b;
344     }
345 
346     function add(uint256 a, uint256 b) internal pure returns (uint256) {
347         uint256 c = a + b;
348         require(c >= a);
349         return c;
350     }
351 }