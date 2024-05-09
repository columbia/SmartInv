1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://jujx.io
5 *
6 * JuJx Сhina token concept
7 *
8 * [✓] 5% Withdraw fee
9 * [✓] 12% Deposit fee
10 * [✓] 1% Token transfer
11 * [✓] 50% Referal link - 68, 16, 16
12 *
13 */
14 
15 contract JujxToken {
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
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32     event onTokenPurchase(
33         address indexed customerAddress,
34         uint256 incomingEthereum,
35         uint256 tokensMinted,
36         address indexed referredBy,
37         uint timestamp,
38         uint256 price
39 );
40 
41     event onTokenSell(
42         address indexed customerAddress,
43         uint256 tokensBurned,
44         uint256 ethereumEarned,
45         uint timestamp,
46         uint256 price
47 );
48 
49     event onReinvestment(
50         address indexed customerAddress,
51         uint256 ethereumReinvested,
52         uint256 tokensMinted
53 );
54 
55     event onWithdraw(
56         address indexed customerAddress,
57         uint256 ethereumWithdrawn
58 );
59 
60     event Transfer(
61         address indexed from,
62         address indexed to,
63         uint256 tokens
64 );
65 
66     string public name = "Jujx Сhina Token";
67     string public symbol = "JJX";
68     uint8 constant public decimals = 18;
69     uint8 constant internal entryFee_ = 12;
70     uint8 constant internal transferFee_ = 1;
71     uint8 constant internal exitFee_ = 5;
72     uint8 constant internal refferalFee_ = 25;
73     uint8 constant internal refPercFee1 = 68;
74     uint8 constant internal refPercFee2 = 16;
75     uint8 constant internal refPercFee3 = 16;
76     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
77     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
78     uint256 constant internal magnitude = 2 ** 64;
79     uint256 public stakingRequirement = 50e18;
80     mapping(address => uint256) internal tokenBalanceLedger_;
81     mapping(address => uint256) internal referralBalance_;
82     mapping(address => int256) internal payoutsTo_;
83     mapping(address => address) internal refer;
84     uint256 internal tokenSupply_;
85     uint256 internal profitPerShare_;
86     address public owner;
87 
88     constructor() public {
89         owner = msg.sender;
90     }
91 
92     function buy(address _referredBy) public payable returns (uint256) {
93         purchaseTokens(msg.value, _referredBy);
94     }
95 
96     function() payable public {
97         purchaseTokens(msg.value, 0x0);
98     }
99 
100     function reinvest() onlyStronghands public {
101         uint256 _dividends = myDividends(false);
102         address _customerAddress = msg.sender;
103         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
104         _dividends += referralBalance_[_customerAddress];
105         referralBalance_[_customerAddress] = 0;
106         uint256 _tokens = purchaseTokens(_dividends, 0x0);
107         emit onReinvestment(_customerAddress, _dividends, _tokens);
108     }
109 
110     function exit() public {
111         address _customerAddress = msg.sender;
112         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
113         if (_tokens > 0) sell(_tokens);
114         withdraw();
115     }
116 
117     function withdraw() onlyStronghands public {
118         address _customerAddress = msg.sender;
119         uint256 _dividends = myDividends(false);
120         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
121         _dividends += referralBalance_[_customerAddress];
122         referralBalance_[_customerAddress] = 0;
123         _customerAddress.transfer(_dividends);
124         emit onWithdraw(_customerAddress, _dividends);
125     }
126 
127     function sell(uint256 _amountOfTokens) onlyBagholders public {
128         address _customerAddress = msg.sender;
129         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
130         uint256 _tokens = _amountOfTokens;
131 
132         if(_customerAddress != owner) {
133             uint ownTokens = SafeMath.div(_tokens, 100);
134             tokenBalanceLedger_[owner] = SafeMath.add(tokenBalanceLedger_[owner], ownTokens);
135             _tokens = SafeMath.sub(_tokens, ownTokens);
136         }
137 
138         uint256 _ethereum = tokensToEthereum_(_tokens);
139         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
140         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
141 
142         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
143         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
144 
145         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
146         payoutsTo_[_customerAddress] -= _updatedPayouts;
147 
148         if (tokenSupply_ > 0) {
149             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
150         }
151         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
152     }
153 
154     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
155         address _customerAddress = msg.sender;
156         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
157 
158         if (myDividends(true) > 0) {
159             withdraw();
160         }
161 
162         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
163         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
164 
165         tokenBalanceLedger_[owner] = SafeMath.add(tokenBalanceLedger_[owner], _tokenFee);
166         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
167         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
168         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
169         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
170 
171         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
172         return true;
173     }
174 
175 
176     function totalEthereumBalance() public view returns (uint256) {
177         return this.balance;
178     }
179 
180     function totalSupply() public view returns (uint256) {
181         return tokenSupply_;
182     }
183 
184     function myTokens() public view returns (uint256) {
185         address _customerAddress = msg.sender;
186         return balanceOf(_customerAddress);
187     }
188 
189     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
190         address _customerAddress = msg.sender;
191         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
192     }
193 
194     function balanceOf(address _customerAddress) public view returns (uint256) {
195         return tokenBalanceLedger_[_customerAddress];
196     }
197 
198     function dividendsOf(address _customerAddress) public view returns (uint256) {
199         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
200     }
201 
202     function sellPrice() public view returns (uint256) {
203         // our calculation relies on the token supply, so we need supply. Doh.
204         if (tokenSupply_ == 0) {
205             return tokenPriceInitial_ - tokenPriceIncremental_;
206         } else {
207             uint256 _ethereum = tokensToEthereum_(1e18);
208             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
209             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
210 
211             return _taxedEthereum;
212         }
213     }
214 
215     function buyPrice() public view returns (uint256) {
216         if (tokenSupply_ == 0) {
217             return tokenPriceInitial_ + tokenPriceIncremental_;
218         } else {
219             uint256 _ethereum = tokensToEthereum_(1e18);
220             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
221             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
222 
223             return _taxedEthereum;
224         }
225     }
226 
227     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
228         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
229         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
230         uint256 _amountOfTokens = ethereumToTokens(_taxedEthereum);
231 
232         return _amountOfTokens;
233     }
234 
235     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
236         require(_tokensToSell <= tokenSupply_);
237         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
238         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
239         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
240         return _taxedEthereum;
241     }
242 
243 
244     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
245         address _customerAddress = msg.sender;
246         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
247         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
248         _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, (entryFee_-1)), 100);
249         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
250         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
251         uint256 _amountOfTokens = ethereumToTokens(_taxedEthereum);
252         uint256 _fee = _dividends * magnitude;
253 
254         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
255 
256         referralBalance_[owner] = referralBalance_[owner] + SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100);
257 
258         if (
259             _referredBy != 0x0000000000000000000000000000000000000000 &&
260             _referredBy != _customerAddress &&
261             tokenBalanceLedger_[_referredBy] >= stakingRequirement
262         ) {
263             if (refer[_customerAddress] == 0x0000000000000000000000000000000000000000) {
264                 refer[_customerAddress] = _referredBy;
265             }
266             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee1), 100));
267             address ref2 = refer[_referredBy];
268 
269             if (ref2 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[ref2] >= stakingRequirement) {
270                 referralBalance_[ref2] = SafeMath.add(referralBalance_[ref2], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee2), 100));
271                 address ref3 = refer[ref2];
272                 if (ref3 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[ref3] >= stakingRequirement) {
273                     referralBalance_[ref3] = SafeMath.add(referralBalance_[ref3], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
274                 }else{
275                     referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
276                 }
277             }else{
278                 referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee2), 100));
279                 referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
280             }
281         } else {
282             referralBalance_[owner] = SafeMath.add(referralBalance_[owner], _referralBonus);
283         }
284 
285         if (tokenSupply_ > 0) {
286             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
287             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
288             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
289         } else {
290             tokenSupply_ = _amountOfTokens;
291         }
292 
293         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
294         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
295         payoutsTo_[_customerAddress] += _updatedPayouts;
296         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
297 
298         return _amountOfTokens;
299     }
300 
301     function ethereumToTokens(uint256 _ethereum) internal view returns (uint256) {
302         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
303         uint256 _tokensReceived =
304             (
305                 (
306                     SafeMath.sub(
307                         (sqrt
308                             (
309                                 (_tokenPriceInitial ** 2)
310                                 +
311                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
312                                 +
313                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
314                                 +
315                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
316                             )
317                         ), _tokenPriceInitial
318                     )
319                 ) / (tokenPriceIncremental_)
320             ) - (tokenSupply_);
321 
322         return _tokensReceived;
323     }
324 
325     function getParent(address child) public view returns (address) {
326         return refer[child];
327     }
328 
329     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
330         uint256 tokens_ = (_tokens + 1e18);
331         uint256 _tokenSupply = (tokenSupply_ + 1e18);
332         uint256 _etherReceived =
333             (
334                 SafeMath.sub(
335                     (
336                         (
337                             (
338                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
339                             ) - tokenPriceIncremental_
340                         ) * (tokens_ - 1e18)
341                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
342                 )
343                 / 1e18);
344 
345         return _etherReceived;
346     }
347 
348     function sqrt(uint256 x) internal pure returns (uint256 y) {
349         uint256 z = (x + 1) / 2;
350         y = x;
351 
352         while (z < y) {
353             y = z;
354             z = (x / z + z) / 2;
355         }
356     }
357  function changeOwner(address _newOwner) onlyOwner public returns (bool success) {
358     owner = _newOwner;
359   }
360 }
361 
362 library SafeMath {
363     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
364         if (a == 0) {
365             return 0;
366         }
367         uint256 c = a * b;
368         assert(c / a == b);
369         return c;
370     }
371 
372     function div(uint256 a, uint256 b) internal pure returns (uint256) {
373         uint256 c = a / b;
374         return c;
375     }
376 
377     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
378         assert(b <= a);
379         return a - b;
380     }
381 
382     function add(uint256 a, uint256 b) internal pure returns (uint256) {
383         uint256 c = a + b;
384         assert(c >= a);
385         return c;
386     }
387 }