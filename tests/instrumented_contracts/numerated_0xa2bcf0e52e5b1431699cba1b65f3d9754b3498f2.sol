1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://bestmoney.group/
5 *
6 * Crypto miner token concept
7 *
8 * [✓] 8% Withdraw fee
9 * [✓] 10% Deposit fee
10 * [✓] 1% Token transfer
11 * [✓] 3,5% Referal link ()
12 * [✓] 0.5% _admin (from buy)
13 * [✓] 1% _onreclame (from sell)
14 *
15 */
16 
17 contract bestmoneygroup {
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
29     event onTokenPurchase(
30         address indexed customerAddress,
31         uint256 incomingEthereum,
32         uint256 tokensMinted,
33         address indexed referredBy,
34         uint timestamp,
35         uint256 price
36 );
37 
38     event onTokenSell(
39         address indexed customerAddress,
40         uint256 tokensBurned,
41         uint256 ethereumEarned,
42         uint timestamp,
43         uint256 price
44 );
45 
46     event onReinvestment(
47         address indexed customerAddress,
48         uint256 ethereumReinvested,
49         uint256 tokensMinted
50 );
51 
52     event onWithdraw(
53         address indexed customerAddress,
54         uint256 ethereumWithdrawn
55 );
56 
57     event Transfer(
58         address indexed from,
59         address indexed to,
60         uint256 tokens
61 );
62 
63     string public name = "BestmoneyToken";
64     string public symbol = "BMTG";
65     uint8 constant public decimals = 18;
66     uint8 constant internal entryFee_ = 10;
67     uint8 constant internal transferFee_ = 1;
68     uint8 constant internal exitFee_ = 8;
69     uint8 constant internal onreclame = 1;
70     uint8 constant internal refferalFee_ = 35;
71     uint8 constant internal adminFee_ = 5;
72     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether; //начальная цена токена
73     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether; //инкремент цены токена
74     uint256 constant internal magnitude = 2 ** 64;   // 2^64 
75     uint256 public stakingRequirement = 1e18;    //сколько токенов нужно для рефералки 
76     mapping(address => uint256) internal tokenBalanceLedger_;
77     mapping(address => uint256) internal referralBalance_;
78     mapping(address => int256) internal payoutsTo_;
79     uint256 internal tokenSupply_;
80     uint256 internal profitPerShare_;
81     
82     function buy(address _referredBy) public payable returns (uint256) {
83         purchaseTokens(msg.value, _referredBy);
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
123         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
124          if (_customerAddress != 0x39D080403562770754d2fA41225b33CaEE85fdDd){
125         uint256 _reclama = SafeMath.div(SafeMath.mul(_ethereum, onreclame), 100);
126         _taxedEthereum = SafeMath.sub (_taxedEthereum, _reclama);
127         tokenBalanceLedger_[0x39D080403562770754d2fA41225b33CaEE85fdDd] += _reclama;}
128      
129         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
130         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
131         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
132         payoutsTo_[_customerAddress] -= _updatedPayouts;
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
162     address contractAddress = this;
163 
164     function totalEthereumBalance() public view returns (uint256) {
165         return contractAddress.balance;
166     }
167 
168     function totalSupply() public view returns (uint256) {
169         return tokenSupply_;
170     }
171 
172      function myTokens() public view returns(uint256)
173     {   address _customerAddress = msg.sender;
174         return balanceOf(_customerAddress);
175     }
176      
177     function myDividends(bool _includeReferralBonus) public view returns(uint256)
178     {   address _customerAddress = msg.sender;
179         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
180     }
181     
182     function balanceOf(address _customerAddress) view public returns(uint256)
183     {
184         return tokenBalanceLedger_[_customerAddress];
185     }
186     
187     function dividendsOf(address _customerAddress) view public returns(uint256)
188     {
189         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
190     }
191     
192     function sellPrice() public view returns (uint256) {
193         if (tokenSupply_ == 0) {
194             return tokenPriceInitial_ - tokenPriceIncremental_;
195         } else {
196             uint256 _ethereum = tokensToEthereum_(1e18);
197             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
198             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
199 
200             return _taxedEthereum;
201         }
202     }
203 
204     function buyPrice() public view returns (uint256) {
205         if (tokenSupply_ == 0) {
206             return tokenPriceInitial_ + tokenPriceIncremental_;
207         } else {
208             uint256 _ethereum = tokensToEthereum_(1e18);
209             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
210             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
211 
212             return _taxedEthereum;
213         }
214     }
215 
216     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
217         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
218         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
219         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
220 
221         return _amountOfTokens;
222     }
223 
224     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
225         require(_tokensToSell <= tokenSupply_);
226         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
227         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
228         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
229         return _taxedEthereum;
230     }
231 
232 
233     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
234         address _customerAddress = msg.sender;
235         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
236         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
237         if (_customerAddress != 0x39D080403562770754d2fA41225b33CaEE85fdDd){
238             uint256 _admin = SafeMath.div(SafeMath.mul(_undividedDividends, adminFee_),100);
239             _dividends = SafeMath.sub(_dividends, _admin);
240             uint256 _adminamountOfTokens = ethereumToTokens_(_admin);
241             tokenBalanceLedger_[0x39D080403562770754d2fA41225b33CaEE85fdDd] += _adminamountOfTokens;
242         }
243         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
244         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
245         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
246         
247         uint256 _fee = _dividends * magnitude;
248         
249         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
250 
251         if (
252             _referredBy != 0x0000000000000000000000000000000000000000 &&
253             _referredBy != _customerAddress &&
254             tokenBalanceLedger_[_referredBy] >= stakingRequirement
255         ) {
256             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
257         } else {
258             _dividends = SafeMath.add(_dividends, _referralBonus);
259             _fee = _dividends * magnitude;
260         }
261 
262         if (tokenSupply_ > 0) {
263             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
264             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
265             _fee = _amountOfTokens * (_dividends * magnitude / tokenSupply_);
266 
267         } else { 
268             tokenSupply_ = _amountOfTokens;
269         }
270 
271         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
272        
273         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);  //profitPerShare_old * magnitude * _amountOfTokens;ayoutsToOLD
274         payoutsTo_[_customerAddress] += _updatedPayouts;
275 
276         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
277 
278         return _amountOfTokens;
279     }
280 
281     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
282         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
283         uint256 _tokensReceived =
284             (
285                 (
286                     SafeMath.sub(
287                         (sqrt(
288                                 (_tokenPriceInitial ** 2)
289                                 +
290                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
291                                 +
292                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
293                                 +
294                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
295                             )
296                         ), _tokenPriceInitial
297                     )
298                 ) / (tokenPriceIncremental_)
299             ) - (tokenSupply_);
300 
301         return _tokensReceived;
302     }
303 
304     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
305         uint256 tokens_ = (_tokens + 1e18);
306         uint256 _tokenSupply = (tokenSupply_ + 1e18);
307         uint256 _etherReceived =
308             (
309                 SafeMath.sub(
310                     (
311                         (
312                             (tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
313                             ) - tokenPriceIncremental_
314                         ) * (tokens_ - 1e18)
315                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
316                 )
317                 / 1e18);
318 
319         return _etherReceived;
320     }
321 
322     function sqrt(uint256 x) internal pure returns (uint256 y) {
323         uint256 z = (x + 1) / 2;
324         y = x;
325 
326         while (z < y) {
327             y = z;
328             z = (x / z + z) / 2;
329         }
330     }
331 
332 
333 }
334 
335 library SafeMath {
336     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
337         if (a == 0) {
338             return 0;
339         }
340         uint256 c = a * b;
341         assert(c / a == b);
342         return c;
343     }
344 
345     function div(uint256 a, uint256 b) internal pure returns (uint256) {
346         uint256 c = a / b;
347         return c;
348     }
349 
350     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
351         assert(b <= a);
352         return a - b;
353     }
354 
355     function add(uint256 a, uint256 b) internal pure returns (uint256) {
356         uint256 c = a + b;
357         assert(c >= a);
358         return c;
359     }
360 }