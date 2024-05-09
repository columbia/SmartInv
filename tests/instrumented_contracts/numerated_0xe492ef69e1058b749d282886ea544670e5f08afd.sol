1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://totalmoney.group
5 *
6 * Total Crypto miner token concept
7 *
8 * [✓] 6% Withdraw fee
9 * [✓] 12% Deposit fee
10 * [✓] 1% Token transfer
11 * [✓] 3% Referal link ()
12 * [✓] 1% _admin (from buy)
13 * [✓] 1% _onreclame (from sell)
14 *
15 */
16 
17 contract TotalMoney {
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
29     modifier onlyAdmin () {
30         require(msg.sender == admin);
31         _;
32     }
33 
34     modifier buyActive() {
35         require(active == true);
36         _;
37     }
38    
39     event onTokenPurchase(
40         address indexed customerAddress,
41         uint256 incomingEthereum,
42         uint256 tokensMinted,
43         address indexed referredBy,
44         uint timestamp,
45         uint256 price
46 );
47 
48     event onTokenSell(
49         address indexed customerAddress,
50         uint256 tokensBurned,
51         uint256 ethereumEarned,
52         uint timestamp,
53         uint256 price
54 );
55 
56     event onReinvestment(
57         address indexed customerAddress,
58         uint256 ethereumReinvested,
59         uint256 tokensMinted
60 );
61 
62     event onWithdraw(
63         address indexed customerAddress,
64         uint256 ethereumWithdrawn
65 );
66 
67     event Transfer(
68         address indexed from,
69         address indexed to,
70         uint256 tokens
71 );
72 
73     string public name = "TotalMoney";
74     string public symbol = "TMG";
75     uint8 constant public decimals = 18;
76     uint8 constant internal entryFee_ = 12;
77     uint8 constant internal transferFee_ = 1;
78     uint8 constant internal exitFee_ = 6;
79     uint8 constant internal onreclame = 1;
80     uint8 constant internal refferalFee_ = 30;
81     uint8 constant internal adminFee_ = 10;
82     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether; //начальная цена токена
83     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether; //инкремент цены токена
84     uint256 constant internal magnitude = 2 ** 64;   // 2^64 
85     uint256 public stakingRequirement = 1e18;    //сколько токенов нужно для рефералки 
86     mapping(address => uint256) internal tokenBalanceLedger_;
87     mapping(address => uint256) internal referralBalance_;
88     mapping(address => int256) internal payoutsTo_;
89     bool internal active = false;
90     address internal admin;
91     uint256 internal tokenSupply_;
92     uint256 internal profitPerShare_;
93 
94     constructor() public {
95         admin = msg.sender;
96     }
97     
98     function buy(address _referredBy) buyActive public payable returns (uint256) {
99         purchaseTokens(msg.value, _referredBy);
100     }
101 
102     function() buyActive payable public {
103         purchaseTokens(msg.value, 0x0);
104     }
105 
106     function reinvest() buyActive onlyStronghands public {
107         uint256 _dividends = myDividends(false);
108         address _customerAddress = msg.sender;
109         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
110         _dividends += referralBalance_[_customerAddress];
111         referralBalance_[_customerAddress] = 0;
112         uint256 _tokens = purchaseTokens(_dividends, 0x0);
113         emit onReinvestment(_customerAddress, _dividends, _tokens);
114     }
115 
116     function exit() public {
117         address _customerAddress = msg.sender;
118         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
119         if (_tokens > 0) sell(_tokens);
120         withdraw();
121     }
122 
123     function withdraw() onlyStronghands public {
124         address _customerAddress = msg.sender;
125         uint256 _dividends = myDividends(false);
126         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
127         _dividends += referralBalance_[_customerAddress];
128         referralBalance_[_customerAddress] = 0;
129         _customerAddress.transfer(_dividends);
130         emit onWithdraw(_customerAddress, _dividends);
131     }
132 
133     function sell(uint256 _amountOfTokens) onlyBagholders public {
134         address _customerAddress = msg.sender;
135         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
136         uint256 _tokens = _amountOfTokens;
137         uint256 _ethereum = tokensToEthereum_(_tokens);
138         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
139         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
140         if (_customerAddress != admin ) {
141             uint256 _reclama = SafeMath.div(SafeMath.mul(_ethereum, onreclame), 100);
142             _taxedEthereum = SafeMath.sub (_taxedEthereum, _reclama);
143             tokenBalanceLedger_[admin] += _reclama;
144         }
145      
146         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
147         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
148         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
149         payoutsTo_[_customerAddress] -= _updatedPayouts;
150         
151         if (tokenSupply_ > 0) {
152             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
153         }
154         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
155     }
156 
157     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
158         address _customerAddress = msg.sender;
159         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
160 
161         if (myDividends(true) > 0) {
162             withdraw();
163         }
164 
165         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
166         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
167         uint256 _dividends = tokensToEthereum_(_tokenFee);
168 
169         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
170         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
171         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
172         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
173         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
174         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
175         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
176         return true;
177     }
178 
179     function setActive() onlyAdmin public payable {
180         purchaseTokens(msg.value, 0x0);
181         active = true;
182     }
183 
184     address contractAddress = this;
185 
186     function totalEthereumBalance() public view returns (uint256) {
187         return contractAddress.balance;
188     }
189 
190     function totalSupply() public view returns (uint256) {
191         return tokenSupply_;
192     }
193 
194      function myTokens() public view returns(uint256)
195     {   address _customerAddress = msg.sender;
196         return balanceOf(_customerAddress);
197     }
198      
199     function myDividends(bool _includeReferralBonus) public view returns(uint256)
200     {   address _customerAddress = msg.sender;
201         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
202     }
203     
204     function balanceOf(address _customerAddress) view public returns(uint256)
205     {
206         return tokenBalanceLedger_[_customerAddress];
207     }
208     
209     function dividendsOf(address _customerAddress) view public returns(uint256)
210     {
211         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
212     }
213     
214     function sellPrice() public view returns (uint256) {
215         if (tokenSupply_ == 0) {
216             return tokenPriceInitial_ - tokenPriceIncremental_;
217         } else {
218             uint256 _ethereum = tokensToEthereum_(1e18);
219             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
220             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
221 
222             return _taxedEthereum;
223         }
224     }
225 
226     function buyPrice() public view returns (uint256) {
227         if (tokenSupply_ == 0) {
228             return tokenPriceInitial_ + tokenPriceIncremental_;
229         } else {
230             uint256 _ethereum = tokensToEthereum_(1e18);
231             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
232             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
233 
234             return _taxedEthereum;
235         }
236     }
237 
238     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
239         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
240         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
241         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
242 
243         return _amountOfTokens;
244     }
245 
246     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
247         require(_tokensToSell <= tokenSupply_);
248         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
249         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
250         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
251         return _taxedEthereum;
252     }
253 
254 
255     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
256         address _customerAddress = msg.sender;
257         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
258         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
259         if (_customerAddress != admin) {
260             uint256 _admin = SafeMath.div(SafeMath.mul(_undividedDividends, adminFee_),100);
261             _dividends = SafeMath.sub(_dividends, _admin);
262             uint256 _adminamountOfTokens = ethereumToTokens_(_admin);
263             tokenBalanceLedger_[admin] += _adminamountOfTokens;
264         }
265         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
266         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
267         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
268         
269         uint256 _fee = _dividends * magnitude;
270         
271         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
272 
273         if (
274             _referredBy != 0x0000000000000000000000000000000000000000 &&
275             _referredBy != _customerAddress &&
276             tokenBalanceLedger_[_referredBy] >= stakingRequirement
277         ) {
278             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
279         } else {
280             _dividends = SafeMath.add(_dividends, _referralBonus);
281             _fee = _dividends * magnitude;
282         }
283 
284         if (tokenSupply_ > 0) {
285             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
286             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
287             _fee = _amountOfTokens * (_dividends * magnitude / tokenSupply_);
288 
289         } else { 
290             tokenSupply_ = _amountOfTokens;
291         }
292 
293         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
294        
295         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);  //profitPerShare_old * magnitude * _amountOfTokens;ayoutsToOLD
296         payoutsTo_[_customerAddress] += _updatedPayouts;
297 
298         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
299 
300         return _amountOfTokens;
301     }
302 
303     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
304         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
305         uint256 _tokensReceived =
306             (
307                 (
308                     SafeMath.sub(
309                         (sqrt(
310                                 (_tokenPriceInitial ** 2)
311                                 +
312                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
313                                 +
314                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
315                                 +
316                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
317                             )
318                         ), _tokenPriceInitial
319                     )
320                 ) / (tokenPriceIncremental_)
321             ) - (tokenSupply_);
322 
323         return _tokensReceived;
324     }
325 
326     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
327         uint256 tokens_ = (_tokens + 1e18);
328         uint256 _tokenSupply = (tokenSupply_ + 1e18);
329         uint256 _etherReceived =
330             (
331                 SafeMath.sub(
332                     (
333                         (
334                             (tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
335                             ) - tokenPriceIncremental_
336                         ) * (tokens_ - 1e18)
337                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
338                 )
339                 / 1e18);
340 
341         return _etherReceived;
342     }
343 
344     function sqrt(uint256 x) internal pure returns (uint256 y) {
345         uint256 z = (x + 1) / 2;
346         y = x;
347 
348         while (z < y) {
349             y = z;
350             z = (x / z + z) / 2;
351         }
352     }
353 
354 
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