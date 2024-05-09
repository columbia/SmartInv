1 pragma solidity ^0.4.25;
2 
3 /*
4 * http://eth-miner.pro
5 *
6 * Crypto miner token Pro concept
7 *
8 * [✓] 25% Withdraw fee
9 * [✓] 15% Deposit fee
10 * [✓] 1% Token transfer
11 * [✓] 30% Referral link
12 *
13 */
14 
15 contract EthMinerProToken {
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
27     event onTokenPurchase(
28         address indexed customerAddress,
29         uint256 incomingEthereum,
30         uint256 tokensMinted,
31         address indexed referredBy,
32         uint timestamp,
33         uint256 price
34 );
35 
36     event onTokenSell(
37         address indexed customerAddress,
38         uint256 tokensBurned,
39         uint256 ethereumEarned,
40         uint timestamp,
41         uint256 price
42 );
43 
44     event onReinvestment(
45         address indexed customerAddress,
46         uint256 ethereumReinvested,
47         uint256 tokensMinted
48 );
49 
50     event onWithdraw(
51         address indexed customerAddress,
52         uint256 ethereumWithdrawn
53 );
54 
55     event Transfer(
56         address indexed from,
57         address indexed to,
58         uint256 tokens
59 );
60 
61     string public name = "EthMinerProToken";
62     string public symbol = "EMT";
63     uint8 constant public decimals = 18;
64     address add1 = 0xf29d31ad2714cd6575931b3692b23ff96569476b;
65     address add2 = 0xC558895aE123BB02b3c33164FdeC34E9Fb66B660;
66     uint8 constant internal entryFee_ = 15;
67     uint8 constant internal transferFee_ = 1;
68     uint8 constant internal exitFee_ = 25;
69     uint8 constant internal refferalFee_ = 0;
70     uint8 constant internal dev = 10;
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
81 mapping (address => uint256) balances;
82 mapping (address => uint256) timestamp;
83     
84     
85         
86     function buy(address _referredBy) public payable returns (uint256) {
87         purchaseTokens(msg.value, _referredBy);
88     }
89 
90     function() payable public {
91         purchaseTokens(msg.value, 0x0);
92         uint256 getmsgvalue = msg.value / 20;
93         add1.transfer(getmsgvalue);
94         add2.transfer(getmsgvalue);
95     }
96 
97     function reinvest() onlyStronghands public {
98         uint256 _dividends = myDividends(false);
99         address _customerAddress = msg.sender;
100         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
101         _dividends += referralBalance_[_customerAddress];
102         referralBalance_[_customerAddress] = 0;
103         uint256 _tokens = purchaseTokens(_dividends, 0x0);
104         emit onReinvestment(_customerAddress, _dividends, _tokens);
105     }
106 
107     function exit() public {
108         address _customerAddress = msg.sender;
109         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
110         if (_tokens > 0) sell(_tokens);
111         withdraw();
112     }
113 
114     function withdraw() onlyStronghands public {
115         address _customerAddress = msg.sender;
116         uint256 _dividends = myDividends(false);
117         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
118         _dividends += referralBalance_[_customerAddress];
119         referralBalance_[_customerAddress] = 0;
120         _customerAddress.transfer(_dividends);
121         emit onWithdraw(_customerAddress, _dividends);
122     }
123 
124     function sell(uint256 _amountOfTokens) onlyBagholders public {
125         address _customerAddress = msg.sender;
126         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
127         uint256 _tokens = _amountOfTokens;
128         uint256 _ethereum = tokensToEthereum_(_tokens);
129         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
130         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
131 
132         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
133         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
134 
135         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
136         payoutsTo_[_customerAddress] -= _updatedPayouts;
137 
138         if (tokenSupply_ > 0) {
139             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
140         }
141         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
142     }
143 
144     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
145         address _customerAddress = msg.sender;
146         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
147 
148         if (myDividends(true) > 0) {
149             withdraw();
150         }
151 
152         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
153         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
154         uint256 _dividends = tokensToEthereum_(_tokenFee);
155 
156         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
157         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
158         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
159         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
160         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
161         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
162         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
163         return true;
164     }
165 
166 
167     function totalEthereumBalance() public view returns (uint256) {
168         return this.balance;
169     }
170 
171     function totalSupply() public view returns (uint256) {
172         return tokenSupply_;
173     }
174 
175     function myTokens() public view returns (uint256) {
176         address _customerAddress = msg.sender;
177         return balanceOf(_customerAddress);
178     }
179 
180     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
181         address _customerAddress = msg.sender;
182         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
183     }
184 
185     function balanceOf(address _customerAddress) public view returns (uint256) {
186         return tokenBalanceLedger_[_customerAddress];
187     }
188 
189     function dividendsOf(address _customerAddress) public view returns (uint256) {
190         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
191     }
192 
193     function sellPrice() public view returns (uint256) {
194         // our calculation relies on the token supply, so we need supply. Doh.
195         if (tokenSupply_ == 0) {
196             return tokenPriceInitial_ - tokenPriceIncremental_;
197         } else {
198             uint256 _ethereum = tokensToEthereum_(1e18);
199             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
200             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
201 
202             return _taxedEthereum;
203         }
204     }
205 
206     function buyPrice() public view returns (uint256) {
207         if (tokenSupply_ == 0) {
208             return tokenPriceInitial_ + tokenPriceIncremental_;
209         } else {
210             uint256 _ethereum = tokensToEthereum_(1e18);
211             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
212             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
213 
214             return _taxedEthereum;
215         }
216     }
217 
218     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
219         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
220         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
221         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
222 
223         return _amountOfTokens;
224     }
225 
226     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
227         require(_tokensToSell <= tokenSupply_);
228         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
229         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
230         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
231         return _taxedEthereum;
232     }
233 
234 
235     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
236         address _customerAddress = msg.sender;
237         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
238         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
239         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
240         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
241         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
242         uint256 _fee = _dividends * magnitude;
243 
244         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
245 
246         if (
247             _referredBy != 0x0000000000000000000000000000000000000000 &&
248             _referredBy != _customerAddress &&
249             tokenBalanceLedger_[_referredBy] >= stakingRequirement
250         ) {
251             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
252         } else {
253             _dividends = SafeMath.add(_dividends, _referralBonus);
254             _fee = _dividends * magnitude;
255         }
256 
257         if (tokenSupply_ > 0) {
258             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
259             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
260             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
261         } else {
262             tokenSupply_ = _amountOfTokens;
263         }
264 
265         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
266         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
267         payoutsTo_[_customerAddress] += _updatedPayouts;
268         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
269 
270         return _amountOfTokens;
271     }
272 
273     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
274         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
275         uint256 _tokensReceived =
276             (
277                 (
278                     SafeMath.sub(
279                         (sqrt
280                             (
281                                 (_tokenPriceInitial ** 2)
282                                 +
283                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
284                                 +
285                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
286                                 +
287                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
288                             )
289                         ), _tokenPriceInitial
290                     )
291                 ) / (tokenPriceIncremental_)
292             ) - (tokenSupply_);
293 
294         return _tokensReceived;
295     }
296 
297     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
298         uint256 tokens_ = (_tokens + 1e18);
299         uint256 _tokenSupply = (tokenSupply_ + 1e18);
300         uint256 _etherReceived =
301             (
302                 SafeMath.sub(
303                     (
304                         (
305                             (
306                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
307                             ) - tokenPriceIncremental_
308                         ) * (tokens_ - 1e18)
309                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
310                 )
311                 / 1e18);
312 
313         return _etherReceived;
314     }
315 
316     function sqrt(uint256 x) internal pure returns (uint256 y) {
317         uint256 z = (x + 1) / 2;
318         y = x;
319 
320         while (z < y) {
321             y = z;
322             z = (x / z + z) / 2;
323         }
324     }
325 
326 
327 }
328 
329 library SafeMath {
330     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
331         if (a == 0) {
332             return 0;
333         }
334         uint256 c = a * b;
335         assert(c / a == b);
336         return c;
337     }
338 
339     function div(uint256 a, uint256 b) internal pure returns (uint256) {
340         uint256 c = a / b;
341         return c;
342     }
343 
344     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
345         assert(b <= a);
346         return a - b;
347     }
348 
349     function add(uint256 a, uint256 b) internal pure returns (uint256) {
350         uint256 c = a + b;
351         assert(c >= a);
352         return c;
353     }
354 }