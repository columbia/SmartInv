1 pragma solidity ^0.4.25;
2 
3 /*
4 *
5 * JuJx Сhina token concept
6 *
7 * [✓] 5% Withdraw fee
8 * [✓] 12% Deposit fee
9 * [✓] 1% Token transfer
10 * [✓] 50% Referal link - 68, 16, 16
11 *
12 */
13 
14 contract JujxToken_new {
15 
16     modifier onlyBagholders {
17         require(myTokens() > 0);
18         _;
19     }
20 
21     modifier onlyStronghands {
22         require(myDividends(true) > 0);
23         _;
24     }
25 
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     event onTokenPurchase(
32         address indexed customerAddress,
33         uint256 incomingEthereum,
34         uint256 tokensMinted,
35         address indexed referredBy,
36         uint timestamp,
37         uint256 price
38 );
39 
40     event onTokenSell(
41         address indexed customerAddress,
42         uint256 tokensBurned,
43         uint256 ethereumEarned,
44         uint timestamp,
45         uint256 price
46 );
47 
48     event onReinvestment(
49         address indexed customerAddress,
50         uint256 ethereumReinvested,
51         uint256 tokensMinted
52 );
53 
54     event onWithdraw(
55         address indexed customerAddress,
56         uint256 ethereumWithdrawn
57 );
58 
59     event Transfer(
60         address indexed from,
61         address indexed to,
62         uint256 tokens
63 );
64 
65     string public name = "Jujx Сhina Token new";
66     string public symbol = "JJXN";
67     uint8 constant public decimals = 18;
68     uint8 constant internal entryFee_ = 12;
69     uint8 constant internal transferFee_ = 1;
70     uint8 constant internal exitFee_ = 5;
71     uint8 constant internal refferalFee_ = 25;
72     uint8 constant internal refPercFee1 = 68;
73     uint8 constant internal refPercFee2 = 16;
74     uint8 constant internal refPercFee3 = 16;
75     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
76     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
77     uint256 constant internal magnitude = 2 ** 64;
78     uint256 public stakingRequirement = 50e18;
79     mapping(address => uint256) internal tokenBalanceLedger_;
80     mapping(address => uint256) internal referralBalance_;
81     mapping(address => int256) internal payoutsTo_;
82     mapping(address => address) internal refer;
83     uint256 internal tokenSupply_;
84     uint256 internal profitPerShare_;
85     address public owner;
86 
87     constructor() public {
88         owner = msg.sender;
89     }
90 
91     function buy(address _referredBy) public payable returns (uint256) {
92         purchaseTokens(msg.value, _referredBy);
93     }
94 
95     function() payable public {
96         purchaseTokens(msg.value, 0x0);
97     }
98 
99     function reinvest() onlyStronghands public {
100         uint256 _dividends = myDividends(false);
101         address _customerAddress = msg.sender;
102         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
103         _dividends += referralBalance_[_customerAddress];
104         referralBalance_[_customerAddress] = 0;
105         uint256 _tokens = purchaseTokens(_dividends, 0x0);
106         emit onReinvestment(_customerAddress, _dividends, _tokens);
107     }
108 
109     function exit() public {
110         address _customerAddress = msg.sender;
111         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
112         if (_tokens > 0) sell(_tokens);
113         withdraw();
114     }
115 
116     function withdraw() onlyStronghands public {
117         address _customerAddress = msg.sender;
118         uint256 _dividends = myDividends(false);
119         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
120         _dividends += referralBalance_[_customerAddress];
121         referralBalance_[_customerAddress] = 0;
122         _customerAddress.transfer(_dividends);
123         emit onWithdraw(_customerAddress, _dividends);
124     }
125 
126     function sell(uint256 _amountOfTokens) onlyBagholders public {
127         address _customerAddress = msg.sender;
128         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
129         uint256 _tokens = _amountOfTokens;
130 
131         if(_customerAddress != owner) {
132             uint ownTokens = SafeMath.div(_tokens, 100);
133             tokenBalanceLedger_[owner] = SafeMath.add(tokenBalanceLedger_[owner], ownTokens);
134             _tokens = SafeMath.sub(_tokens, ownTokens);
135         }
136 
137         uint256 _ethereum = tokensToEthereum_(_tokens);
138         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
139         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
140 
141         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
142         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
143 
144         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
145         payoutsTo_[_customerAddress] -= _updatedPayouts;
146 
147         if (tokenSupply_ > 0) {
148             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
149         }
150         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
151     }
152 
153     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
154         address _customerAddress = msg.sender;
155         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
156 
157         if (myDividends(true) > 0) {
158             withdraw();
159         }
160 
161         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
162         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
163 
164         tokenBalanceLedger_[owner] = SafeMath.add(tokenBalanceLedger_[owner], _tokenFee);
165         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
166         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
167         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
168         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
169 
170         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
171         return true;
172     }
173 
174 
175     function totalEthereumBalance() public view returns (uint256) {
176         return this.balance;
177     }
178 
179     function totalSupply() public view returns (uint256) {
180         return tokenSupply_;
181     }
182 
183     function myTokens() public view returns (uint256) {
184         address _customerAddress = msg.sender;
185         return balanceOf(_customerAddress);
186     }
187 
188     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
189         address _customerAddress = msg.sender;
190         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
191     }
192 
193     function balanceOf(address _customerAddress) public view returns (uint256) {
194         return tokenBalanceLedger_[_customerAddress];
195     }
196 
197     function dividendsOf(address _customerAddress) public view returns (uint256) {
198         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
199     }
200 
201     function sellPrice() public view returns (uint256) {
202         // our calculation relies on the token supply, so we need supply. Doh.
203         if (tokenSupply_ == 0) {
204             return tokenPriceInitial_ - tokenPriceIncremental_;
205         } else {
206             uint256 _ethereum = tokensToEthereum_(1e18);
207             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
208             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
209 
210             return _taxedEthereum;
211         }
212     }
213 
214     function buyPrice() public view returns (uint256) {
215         if (tokenSupply_ == 0) {
216             return tokenPriceInitial_ + tokenPriceIncremental_;
217         } else {
218             uint256 _ethereum = tokensToEthereum_(1e18);
219             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
220             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
221 
222             return _taxedEthereum;
223         }
224     }
225 
226     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
227         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
228         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
229         uint256 _amountOfTokens = ethereumToTokens(_taxedEthereum);
230 
231         return _amountOfTokens;
232     }
233 
234     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
235         require(_tokensToSell <= tokenSupply_);
236         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
237         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
238         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
239         return _taxedEthereum;
240     }
241 
242 
243     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
244         address _customerAddress = msg.sender;
245         uint256 _undivDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
246         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undivDividends, refferalFee_), 100);
247         _undivDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, (entryFee_-1)), 100);
248         uint256 _dividends = SafeMath.sub(_undivDividends, _referralBonus);
249         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undivDividends);
250         uint256 _amountOfTokens = ethereumToTokens(_taxedEthereum);
251         uint256 _fee = _dividends * magnitude;
252 
253         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
254 
255         referralBalance_[owner] = referralBalance_[owner] + SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100);
256 
257         if (
258             _referredBy != 0x0000000000000000000000000000000000000000 &&
259             _referredBy != _customerAddress &&
260             tokenBalanceLedger_[_referredBy] >= stakingRequirement
261         ) {
262             if (refer[_customerAddress] == 0x0000000000000000000000000000000000000000) {
263                 refer[_customerAddress] = _referredBy;
264             }
265             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee1), 100));
266             address ref2 = refer[_referredBy];
267 
268             if (ref2 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[ref2] >= stakingRequirement) {
269                 referralBalance_[ref2] = SafeMath.add(referralBalance_[ref2], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee2), 100));
270                 address ref3 = refer[ref2];
271                 if (ref3 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[ref3] >= stakingRequirement) {
272                     referralBalance_[ref3] = SafeMath.add(referralBalance_[ref3], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
273                 }else{
274                     referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
275                 }
276             }else{
277                 referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee2), 100));
278                 referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
279             }
280         } else {
281             referralBalance_[owner] = SafeMath.add(referralBalance_[owner], _referralBonus);
282         }
283 
284         if (tokenSupply_ > 0) {
285             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
286             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
287             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
288         } else {
289             tokenSupply_ = _amountOfTokens;
290         }
291 
292         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
293         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
294         payoutsTo_[_customerAddress] += _updatedPayouts;
295         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
296 
297         return _amountOfTokens;
298     }
299 
300     function ethereumToTokens(uint256 _ethereum) internal view returns (uint256) {
301         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
302         uint256 _tokensReceived =
303             (
304                 (
305                     SafeMath.sub(
306                         (sqrt
307                             (
308                                 (_tokenPriceInitial ** 2)
309                                 +
310                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
311                                 +
312                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
313                                 +
314                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
315                             )
316                         ), _tokenPriceInitial
317                     )
318                 ) / (tokenPriceIncremental_)
319             ) - (tokenSupply_);
320 
321         return _tokensReceived;
322     }
323 
324     function getParent(address child) public view returns (address) {
325         return refer[child];
326     }
327 
328     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
329         uint256 tokens_ = (_tokens + 1e18);
330         uint256 _tokenSupply = (tokenSupply_ + 1e18);
331         uint256 _etherReceived =
332             (
333                 SafeMath.sub(
334                     (
335                         (
336                             (
337                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
338                             ) - tokenPriceIncremental_
339                         ) * (tokens_ - 1e18)
340                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
341                 )
342                 / 1e18);
343 
344         return _etherReceived;
345     }
346 
347     function sqrt(uint256 x) internal pure returns (uint256 y) {
348         uint256 z = (x + 1) / 2;
349         y = x;
350 
351         while (z < y) {
352             y = z;
353             z = (x / z + z) / 2;
354         }
355     }
356  function changeOwner(address _newOwner) onlyOwner public returns (bool success) {
357     owner = _newOwner;
358   }
359 }
360 
361 library SafeMath {
362     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
363         if (a == 0) {
364             return 0;
365         }
366         uint256 c = a * b;
367         assert(c / a == b);
368         return c;
369     }
370 
371     function div(uint256 a, uint256 b) internal pure returns (uint256) {
372         uint256 c = a / b;
373         return c;
374     }
375 
376     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
377         assert(b <= a);
378         return a - b;
379     }
380 
381     function add(uint256 a, uint256 b) internal pure returns (uint256) {
382         uint256 c = a + b;
383         assert(c >= a);
384         return c;
385     }
386 }