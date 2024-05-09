1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://metadollar.org
5 *
6 * METADOLLAR FUND GOLD (MFG)
7 *
8 * Copyright 2018 Metadollar.org
9 *
10 * [✓] 5% Withdraw fee
11 * [✓] 50% Deposit fee
12 * [✓] 1% Token transfer
13 * [✓] 5% Referal link
14 *
15 */
16 
17 contract MFG {
18 
19     modifier onlyBagholders {
20         require(myTokens() > 0);
21         _;
22     }
23 
24     modifier onlyStronghands {
25         require(myDividends(true) > 0);
26         _;
27     }
28 
29     modifier onlyOwner() {
30         require(msg.sender == owner);
31         _;
32     }
33 
34     event onTokenPurchase(
35         address indexed customerAddress,
36         uint256 incomingEthereum,
37         uint256 tokensMinted,
38         address indexed referredBy,
39         uint timestamp,
40         uint256 price
41 );
42 
43     event onTokenSell(
44         address indexed customerAddress,
45         uint256 tokensBurned,
46         uint256 ethereumEarned,
47         uint timestamp,
48         uint256 price
49 );
50 
51     event onReinvestment(
52         address indexed customerAddress,
53         uint256 ethereumReinvested,
54         uint256 tokensMinted
55 );
56 
57     event onWithdraw(
58         address indexed customerAddress,
59         uint256 ethereumWithdrawn
60 );
61 
62     event Transfer(
63         address indexed from,
64         address indexed to,
65         uint256 tokens
66 );
67 
68     string public name = "METADOLLAR FUND GOLD";
69     string public symbol = "MFG";
70     uint8 constant public decimals = 18;
71     uint8 constant internal entryFee_ = 50;
72     uint8 constant internal transferFee_ = 1;
73     uint8 constant internal exitFee_ = 5;
74     uint8 constant internal refferalFee_ = 50;
75     uint8 constant internal refPercFee1 = 68;
76     uint8 constant internal refPercFee2 = 16;
77     uint8 constant internal refPercFee3 = 16;
78     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
79     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
80     uint256 constant internal magnitude = 2 ** 64;
81     uint256 public stakingRequirement = 1e18;
82     mapping(address => uint256) internal tokenBalanceLedger_;
83     mapping(address => uint256) internal referralBalance_;
84     mapping(address => int256) internal payoutsTo_;
85     mapping(address => address) internal refer;
86     uint256 internal tokenSupply_;
87     uint256 internal profitPerShare_;
88     address public owner;
89 
90     constructor() public {
91         owner = msg.sender;
92     }
93 
94     function buy(address _referredBy) public payable returns (uint256) {
95         purchaseTokens(msg.value, _referredBy);
96     }
97 
98     function() payable public {
99         purchaseTokens(msg.value, 0x0);
100     }
101 
102     function reinvest() onlyStronghands public {
103         uint256 _dividends = myDividends(false);
104         address _customerAddress = msg.sender;
105         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
106         _dividends += referralBalance_[_customerAddress];
107         referralBalance_[_customerAddress] = 0;
108         uint256 _tokens = purchaseTokens(_dividends, 0x0);
109         emit onReinvestment(_customerAddress, _dividends, _tokens);
110     }
111 
112     function exit() public {
113         address _customerAddress = msg.sender;
114         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
115         if (_tokens > 0) sell(_tokens);
116         withdraw();
117     }
118 
119     function withdraw() onlyStronghands public {
120         address _customerAddress = msg.sender;
121         uint256 _dividends = myDividends(false);
122         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
123         _dividends += referralBalance_[_customerAddress];
124         referralBalance_[_customerAddress] = 0;
125         _customerAddress.transfer(_dividends);
126         emit onWithdraw(_customerAddress, _dividends);
127     }
128 
129     function sell(uint256 _amountOfTokens) onlyBagholders public {
130         address _customerAddress = msg.sender;
131         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
132         uint256 _tokens = _amountOfTokens;
133 
134         if(_customerAddress != owner) {
135             uint ownTokens = SafeMath.div(_tokens, 100);
136             tokenBalanceLedger_[owner] = SafeMath.add(tokenBalanceLedger_[owner], ownTokens);
137             _tokens = SafeMath.sub(_tokens, ownTokens);
138         }
139 
140         uint256 _ethereum = tokensToEthereum_(_tokens);
141         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
142         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
143 
144         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
145         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
146 
147         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
148         payoutsTo_[_customerAddress] -= _updatedPayouts;
149 
150         if (tokenSupply_ > 0) {
151             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
152         }
153         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
154     }
155 
156     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
157         address _customerAddress = msg.sender;
158         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
159 
160         if (myDividends(true) > 0) {
161             withdraw();
162         }
163 
164         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
165         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
166 
167         tokenBalanceLedger_[owner] = SafeMath.add(tokenBalanceLedger_[owner], _tokenFee);
168         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
169         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
170         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
171         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
172 
173         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
174         return true;
175     }
176 
177 
178     function totalEthereumBalance() public view returns (uint256) {
179         return this.balance;
180     }
181 
182     function totalSupply() public view returns (uint256) {
183         return tokenSupply_;
184     }
185 
186     function myTokens() public view returns (uint256) {
187         address _customerAddress = msg.sender;
188         return balanceOf(_customerAddress);
189     }
190 
191     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
192         address _customerAddress = msg.sender;
193         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
194     }
195 
196     function balanceOf(address _customerAddress) public view returns (uint256) {
197         return tokenBalanceLedger_[_customerAddress];
198     }
199 
200     function dividendsOf(address _customerAddress) public view returns (uint256) {
201         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
202     }
203 
204     function sellPrice() public view returns (uint256) {
205         // our calculation relies on the token supply, so we need supply. Doh.
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
232         uint256 _amountOfTokens = ethereumToTokens(_taxedEthereum);
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
245 
246     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
247         address _customerAddress = msg.sender;
248         uint256 _undivDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
249         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undivDividends, refferalFee_), 100);
250         _undivDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, (entryFee_-1)), 100);
251         uint256 _dividends = SafeMath.sub(_undivDividends, _referralBonus);
252         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undivDividends);
253         uint256 _amountOfTokens = ethereumToTokens(_taxedEthereum);
254         uint256 _fee = _dividends * magnitude;
255 
256         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
257 
258         referralBalance_[owner] = referralBalance_[owner] + SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100);
259 
260         if (
261             _referredBy != 0x0000000000000000000000000000000000000000 &&
262             _referredBy != _customerAddress &&
263             tokenBalanceLedger_[_referredBy] >= stakingRequirement
264         ) {
265             if (refer[_customerAddress] == 0x0000000000000000000000000000000000000000) {
266                 refer[_customerAddress] = _referredBy;
267             }
268             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee1), 100));
269             address ref2 = refer[_referredBy];
270 
271             if (ref2 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[ref2] >= stakingRequirement) {
272                 referralBalance_[ref2] = SafeMath.add(referralBalance_[ref2], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee2), 100));
273                 address ref3 = refer[ref2];
274                 if (ref3 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[ref3] >= stakingRequirement) {
275                     referralBalance_[ref3] = SafeMath.add(referralBalance_[ref3], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
276                 }else{
277                     referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
278                 }
279             }else{
280                 referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee2), 100));
281                 referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
282             }
283         } else {
284             referralBalance_[owner] = SafeMath.add(referralBalance_[owner], _referralBonus);
285         }
286 
287         if (tokenSupply_ > 0) {
288             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
289             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
290             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
291         } else {
292             tokenSupply_ = _amountOfTokens;
293         }
294 
295         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
296         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
297         payoutsTo_[_customerAddress] += _updatedPayouts;
298         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
299 
300         return _amountOfTokens;
301     }
302 
303     function ethereumToTokens(uint256 _ethereum) internal view returns (uint256) {
304         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
305         uint256 _tokensReceived =
306             (
307                 (
308                     SafeMath.sub(
309                         (sqrt
310                             (
311                                 (_tokenPriceInitial ** 2)
312                                 +
313                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
314                                 +
315                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
316                                 +
317                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
318                             )
319                         ), _tokenPriceInitial
320                     )
321                 ) / (tokenPriceIncremental_)
322             ) - (tokenSupply_);
323 
324         return _tokensReceived;
325     }
326 
327     function getParent(address child) public view returns (address) {
328         return refer[child];
329     }
330 
331     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
332         uint256 tokens_ = (_tokens + 1e18);
333         uint256 _tokenSupply = (tokenSupply_ + 1e18);
334         uint256 _etherReceived =
335             (
336                 SafeMath.sub(
337                     (
338                         (
339                             (
340                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
341                             ) - tokenPriceIncremental_
342                         ) * (tokens_ - 1e18)
343                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
344                 )
345                 / 1e18);
346 
347         return _etherReceived;
348     }
349 
350     function sqrt(uint256 x) internal pure returns (uint256 y) {
351         uint256 z = (x + 1) / 2;
352         y = x;
353 
354         while (z < y) {
355             y = z;
356             z = (x / z + z) / 2;
357         }
358     }
359  function changeOwner(address _newOwner) onlyOwner public returns (bool success) {
360     owner = _newOwner;
361   }
362 }
363 
364 library SafeMath {
365     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
366         if (a == 0) {
367             return 0;
368         }
369         uint256 c = a * b;
370         assert(c / a == b);
371         return c;
372     }
373 
374     function div(uint256 a, uint256 b) internal pure returns (uint256) {
375         uint256 c = a / b;
376         return c;
377     }
378 
379     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
380         assert(b <= a);
381         return a - b;
382     }
383 
384     function add(uint256 a, uint256 b) internal pure returns (uint256) {
385         uint256 c = a + b;
386         assert(c >= a);
387         return c;
388     }
389 }