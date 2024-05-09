1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://jujx.io
5 *
6 * JuJx china token concept
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
66     string public name = "Jujx china Token";
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
131         uint256 _ethereum = tokensToEthereum_(_tokens);
132         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
133         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
134 
135         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
136         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
137 
138         uint256 _updatedPayouts = (uint256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
139         uint256 _ownerProfit = SafeMath.div(SafeMath.mul(_updatedPayouts, 1), 100);
140         referralBalance_[owner] = SafeMath.add(referralBalance_[owner], _ownerProfit);
141         payoutsTo_[_customerAddress] -= (int256) (_updatedPayouts + _ownerProfit);
142 
143         if (tokenSupply_ > 0) {
144             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
145         }
146         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
147     }
148 
149     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
150         address _customerAddress = msg.sender;
151         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
152 
153         if (myDividends(true) > 0) {
154             withdraw();
155         }
156 
157         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
158         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
159 
160         tokenBalanceLedger_[owner] = SafeMath.add(tokenBalanceLedger_[owner], _tokenFee);
161         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
162         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
163         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
164         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
165 
166         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
167         return true;
168     }
169 
170 
171     function totalEthereumBalance() public view returns (uint256) {
172         return this.balance;
173     }
174 
175     function totalSupply() public view returns (uint256) {
176         return tokenSupply_;
177     }
178 
179     function myTokens() public view returns (uint256) {
180         address _customerAddress = msg.sender;
181         return balanceOf(_customerAddress);
182     }
183 
184     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
185         address _customerAddress = msg.sender;
186         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
187     }
188 
189     function balanceOf(address _customerAddress) public view returns (uint256) {
190         return tokenBalanceLedger_[_customerAddress];
191     }
192 
193     function dividendsOf(address _customerAddress) public view returns (uint256) {
194         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
195     }
196 
197     function sellPrice() public view returns (uint256) {
198         // our calculation relies on the token supply, so we need supply. Doh.
199         if (tokenSupply_ == 0) {
200             return tokenPriceInitial_ - tokenPriceIncremental_;
201         } else {
202             uint256 _ethereum = tokensToEthereum_(1e18);
203             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
204             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
205 
206             return _taxedEthereum;
207         }
208     }
209 
210     function buyPrice() public view returns (uint256) {
211         if (tokenSupply_ == 0) {
212             return tokenPriceInitial_ + tokenPriceIncremental_;
213         } else {
214             uint256 _ethereum = tokensToEthereum_(1e18);
215             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
216             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
217 
218             return _taxedEthereum;
219         }
220     }
221 
222     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
223         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
224         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
225         uint256 _amountOfTokens = ethereumToTokens(_taxedEthereum);
226 
227         return _amountOfTokens;
228     }
229 
230     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
231         require(_tokensToSell <= tokenSupply_);
232         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
233         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
234         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
235         return _taxedEthereum;
236     }
237 
238 
239     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
240         address _customerAddress = msg.sender;
241         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
242         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
243         _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, (entryFee_-1)), 100);
244         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
245         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
246         uint256 _amountOfTokens = ethereumToTokens(_taxedEthereum);
247         uint256 _fee = _dividends * magnitude;
248 
249         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
250 
251         referralBalance_[owner] = referralBalance_[owner] + SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100);
252 
253         if (
254             _referredBy != 0x0000000000000000000000000000000000000000 &&
255             _referredBy != _customerAddress &&
256             tokenBalanceLedger_[_referredBy] >= stakingRequirement
257         ) {
258             if (refer[_customerAddress] == 0x0000000000000000000000000000000000000000) {
259                 refer[_customerAddress] = _referredBy;
260             }
261             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee1), 100));
262             address ref2 = refer[_referredBy];
263 
264             if (ref2 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[ref2] >= stakingRequirement) {
265                 referralBalance_[ref2] = SafeMath.add(referralBalance_[ref2], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee2), 100));
266                 address ref3 = refer[ref2];
267                 if (ref3 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[ref3] >= stakingRequirement) {
268                     referralBalance_[ref3] = SafeMath.add(referralBalance_[ref3], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
269                 }else{
270                     referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
271                 }
272             }else{
273                 referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee2), 100));
274                 referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
275             }
276         } else {
277             referralBalance_[owner] = SafeMath.add(referralBalance_[owner], _referralBonus);
278         }
279 
280         if (tokenSupply_ > 0) {
281             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
282             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
283             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
284         } else {
285             tokenSupply_ = _amountOfTokens;
286         }
287 
288         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
289         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
290         payoutsTo_[_customerAddress] += _updatedPayouts;
291         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
292 
293         return _amountOfTokens;
294     }
295 
296     function ethereumToTokens(uint256 _ethereum) internal view returns (uint256) {
297         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
298         uint256 _tokensReceived =
299             (
300                 (
301                     SafeMath.sub(
302                         (sqrt
303                             (
304                                 (_tokenPriceInitial ** 2)
305                                 +
306                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
307                                 +
308                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
309                                 +
310                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
311                             )
312                         ), _tokenPriceInitial
313                     )
314                 ) / (tokenPriceIncremental_)
315             ) - (tokenSupply_);
316 
317         return _tokensReceived;
318     }
319 
320     function getParent(address child) public view returns (address) {
321         return refer[child];
322     }
323 
324     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
325         uint256 tokens_ = (_tokens + 1e18);
326         uint256 _tokenSupply = (tokenSupply_ + 1e18);
327         uint256 _etherReceived =
328             (
329                 SafeMath.sub(
330                     (
331                         (
332                             (
333                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
334                             ) - tokenPriceIncremental_
335                         ) * (tokens_ - 1e18)
336                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
337                 )
338                 / 1e18);
339 
340         return _etherReceived;
341     }
342 
343     function sqrt(uint256 x) internal pure returns (uint256 y) {
344         uint256 z = (x + 1) / 2;
345         y = x;
346 
347         while (z < y) {
348             y = z;
349             z = (x / z + z) / 2;
350         }
351     }
352  function changeOwner(address _newOwner) onlyOwner public returns (bool success) {
353     owner = _newOwner;
354   }
355 }
356 
357 library SafeMath {
358     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
359         if (a == 0) {
360             return 0;
361         }
362         uint256 c = a * b;
363         assert(c / a == b);
364         return c;
365     }
366 
367     function div(uint256 a, uint256 b) internal pure returns (uint256) {
368         uint256 c = a / b;
369         return c;
370     }
371 
372     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
373         assert(b <= a);
374         return a - b;
375     }
376 
377     function add(uint256 a, uint256 b) internal pure returns (uint256) {
378         uint256 c = a + b;
379         assert(c >= a);
380         return c;
381     }
382 }