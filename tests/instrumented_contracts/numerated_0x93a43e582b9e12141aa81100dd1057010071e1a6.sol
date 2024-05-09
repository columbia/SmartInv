1 pragma solidity ^0.4.25;
2 
3 /*
4 * JuJx Сhina token concept
5 *
6 *  3% Withdraw fee
7 *  14% Deposit fee
8 *  1% Token transfer
9 *  50% Referal link - 68, 16, 16
10 *
11 */
12 
13 contract JujxTokenV2 {
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
25     modifier onlyOwner() {
26         require(msg.sender == owner);
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
64     string public name = "Jujx Сhina Token";
65     string public symbol = "JJX2";
66     uint8 constant public decimals = 18;
67     uint8 constant internal entryFee_ = 14;
68     uint8 constant internal transferFee_ = 1;
69     uint8 constant internal exitFee_ = 3;
70     uint8 constant internal refferalFee_ = 25;
71     uint8 constant internal refPercFee1 = 68;
72     uint8 constant internal refPercFee2 = 16;
73     uint8 constant internal refPercFee3 = 16;
74     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
75     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
76     uint256 constant internal magnitude = 2 ** 64;
77     uint256 public stakingRequirement = 50e18;
78     mapping(address => uint256) internal tokenBalanceLedger_;
79     mapping(address => uint256) internal referralBalance_;
80     mapping(address => int256) internal payoutsTo_;
81     mapping(address => address) internal refer;
82     uint256 internal tokenSupply_;
83     uint256 internal profitPerShare_;
84     address public owner;
85 
86     constructor() public {
87         owner = msg.sender;
88     }
89 
90     function buy(address _referredBy) public payable returns (uint256) {
91         purchaseTokens(msg.value, _referredBy);
92     }
93 
94     function() payable public {
95         purchaseTokens(msg.value, 0x0);
96     }
97 
98     function reinvest() onlyStronghands public {
99         uint256 _dividends = myDividends(false);
100         address _customerAddress = msg.sender;
101         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
102         _dividends += referralBalance_[_customerAddress];
103         referralBalance_[_customerAddress] = 0;
104         uint256 _tokens = purchaseTokens(_dividends, 0x0);
105         emit onReinvestment(_customerAddress, _dividends, _tokens);
106     }
107 
108     function exit() public {
109         address _customerAddress = msg.sender;
110         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
111         if (_tokens > 0) sell(_tokens);
112         withdraw();
113     }
114 
115     function withdraw() onlyStronghands public {
116         address _customerAddress = msg.sender;
117         uint256 _dividends = myDividends(false);
118         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
119         _dividends += referralBalance_[_customerAddress];
120         referralBalance_[_customerAddress] = 0;
121         _customerAddress.transfer(_dividends);
122         emit onWithdraw(_customerAddress, _dividends);
123     }
124 
125     function sell(uint256 _amountOfTokens) onlyBagholders public {
126         address _customerAddress = msg.sender;
127         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
128         uint256 _tokens = _amountOfTokens;
129 
130         if(_customerAddress != owner) {
131             uint ownTokens = SafeMath.div(_tokens, 100);
132             tokenBalanceLedger_[owner] = SafeMath.add(tokenBalanceLedger_[owner], ownTokens);
133             _tokens = SafeMath.sub(_tokens, ownTokens);
134         }
135 
136         uint256 _ethereum = tokensToEthereum_(_tokens);
137         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
138         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
139 
140         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
141         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
142 
143         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
144         payoutsTo_[_customerAddress] -= _updatedPayouts;
145 
146         if (tokenSupply_ > 0) {
147             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
148         }
149         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
150     }
151 
152     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
153         address _customerAddress = msg.sender;
154         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
155 
156         if (myDividends(true) > 0) {
157             withdraw();
158         }
159 
160         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
161         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
162 
163         tokenBalanceLedger_[owner] = SafeMath.add(tokenBalanceLedger_[owner], _tokenFee);
164         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
165         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
166         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
167         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
168 
169         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
170         return true;
171     }
172 
173 
174     function totalEthereumBalance() public view returns (uint256) {
175         return this.balance;
176     }
177 
178     function totalSupply() public view returns (uint256) {
179         return tokenSupply_;
180     }
181 
182     function myTokens() public view returns (uint256) {
183         address _customerAddress = msg.sender;
184         return balanceOf(_customerAddress);
185     }
186 
187     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
188         address _customerAddress = msg.sender;
189         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
190     }
191 
192     function balanceOf(address _customerAddress) public view returns (uint256) {
193         return tokenBalanceLedger_[_customerAddress];
194     }
195 
196     function dividendsOf(address _customerAddress) public view returns (uint256) {
197         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
198     }
199 
200     function sellPrice() public view returns (uint256) {
201         // our calculation relies on the token supply, so we need supply. Doh.
202         if (tokenSupply_ == 0) {
203             return tokenPriceInitial_ - tokenPriceIncremental_;
204         } else {
205             uint256 _ethereum = tokensToEthereum_(1e18);
206             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
207             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
208 
209             return _taxedEthereum;
210         }
211     }
212 
213     function buyPrice() public view returns (uint256) {
214         if (tokenSupply_ == 0) {
215             return tokenPriceInitial_ + tokenPriceIncremental_;
216         } else {
217             uint256 _ethereum = tokensToEthereum_(1e18);
218             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
219             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
220 
221             return _taxedEthereum;
222         }
223     }
224 
225     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
226         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
227         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
228         uint256 _amountOfTokens = ethereumToTokens(_taxedEthereum);
229 
230         return _amountOfTokens;
231     }
232 
233     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
234         require(_tokensToSell <= tokenSupply_);
235         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
236         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
237         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
238         return _taxedEthereum;
239     }
240 
241 
242     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
243         address _customerAddress = msg.sender;
244         uint256 _undivDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
245         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undivDividends, refferalFee_), 100);
246         _undivDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, (entryFee_-1)), 100);
247         uint256 _dividends = SafeMath.sub(_undivDividends, _referralBonus);
248         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undivDividends);
249         uint256 _amountOfTokens = ethereumToTokens(_taxedEthereum);
250         uint256 _fee = _dividends * magnitude;
251 
252         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
253 
254         referralBalance_[owner] = referralBalance_[owner] + SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100);
255 
256         if (
257             _referredBy != 0x0000000000000000000000000000000000000000 &&
258             _referredBy != _customerAddress &&
259             tokenBalanceLedger_[_referredBy] >= stakingRequirement
260         ) {
261             if (refer[_customerAddress] == 0x0000000000000000000000000000000000000000) {
262                 refer[_customerAddress] = _referredBy;
263             }
264             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee1), 100));
265             address ref2 = refer[_referredBy];
266 
267             if (ref2 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[ref2] >= stakingRequirement) {
268                 referralBalance_[ref2] = SafeMath.add(referralBalance_[ref2], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee2), 100));
269                 address ref3 = refer[ref2];
270                 if (ref3 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[ref3] >= stakingRequirement) {
271                     referralBalance_[ref3] = SafeMath.add(referralBalance_[ref3], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
272                 }else{
273                     referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
274                 }
275             }else{
276                 referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee2), 100));
277                 referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
278             }
279         } else {
280             referralBalance_[owner] = SafeMath.add(referralBalance_[owner], _referralBonus);
281         }
282 
283         if (tokenSupply_ > 0) {
284             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
285             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
286             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
287         } else {
288             tokenSupply_ = _amountOfTokens;
289         }
290 
291         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
292         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
293         payoutsTo_[_customerAddress] += _updatedPayouts;
294         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
295 
296         return _amountOfTokens;
297     }
298 
299     function ethereumToTokens(uint256 _ethereum) internal view returns (uint256) {
300         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
301         uint256 _tokensReceived =
302             (
303                 (
304                     SafeMath.sub(
305                         (sqrt
306                             (
307                                 (_tokenPriceInitial ** 2)
308                                 +
309                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
310                                 +
311                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
312                                 +
313                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
314                             )
315                         ), _tokenPriceInitial
316                     )
317                 ) / (tokenPriceIncremental_)
318             ) - (tokenSupply_);
319 
320         return _tokensReceived;
321     }
322 
323     function getParent(address child) public view returns (address) {
324         return refer[child];
325     }
326 
327     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
328         uint256 tokens_ = (_tokens + 1e18);
329         uint256 _tokenSupply = (tokenSupply_ + 1e18);
330         uint256 _etherReceived =
331             (
332                 SafeMath.sub(
333                     (
334                         (
335                             (
336                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
337                             ) - tokenPriceIncremental_
338                         ) * (tokens_ - 1e18)
339                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
340                 )
341                 / 1e18);
342 
343         return _etherReceived;
344     }
345 
346     function sqrt(uint256 x) internal pure returns (uint256 y) {
347         uint256 z = (x + 1) / 2;
348         y = x;
349 
350         while (z < y) {
351             y = z;
352             z = (x / z + z) / 2;
353         }
354     }
355  function changeOwner(address _newOwner) onlyOwner public returns (bool success) {
356     owner = _newOwner;
357   }
358 }
359 
360 library SafeMath {
361     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
362         if (a == 0) {
363             return 0;
364         }
365         uint256 c = a * b;
366         assert(c / a == b);
367         return c;
368     }
369 
370     function div(uint256 a, uint256 b) internal pure returns (uint256) {
371         uint256 c = a / b;
372         return c;
373     }
374 
375     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
376         assert(b <= a);
377         return a - b;
378     }
379 
380     function add(uint256 a, uint256 b) internal pure returns (uint256) {
381         uint256 c = a + b;
382         assert(c >= a);
383         return c;
384     }
385 }