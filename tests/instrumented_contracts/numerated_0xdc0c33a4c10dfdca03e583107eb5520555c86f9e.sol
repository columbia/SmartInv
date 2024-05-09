1 pragma solidity ^0.4.25;
2 /*
3 * [✓] 4% Withdraw fee
4 * [✓] 10% Deposit fee
5 * [✓] 1% Token transfer
6 * [✓] 33% Referal link
7 
8 */
9 
10 contract CryptoProfit {
11 
12     modifier onlyBagholders {
13         require(myTokens() > 0);
14         _;
15     }
16 
17     modifier onlyStronghands {
18         require(myDividends(true) > 0);
19         _;
20     }
21 
22     event onTokenPurchase(
23         address indexed customerAddress,
24         uint256 incomingEthereum,
25         uint256 tokensMinted,
26         address indexed referredBy,
27         uint timestamp,
28         uint256 price
29 );
30 
31     event onTokenSell(
32         address indexed customerAddress,
33         uint256 tokensBurned,
34         uint256 ethereumEarned,
35         uint timestamp,
36         uint256 price
37 );
38 
39     event onReinvestment(
40         address indexed customerAddress,
41         uint256 ethereumReinvested,
42         uint256 tokensMinted
43 );
44 
45     event onWithdraw(
46         address indexed customerAddress,
47         uint256 ethereumWithdrawn
48 );
49 
50     event Transfer(
51         address indexed from,
52         address indexed to,
53         uint256 tokens
54 );
55 
56     string public name = "CryptoProfit";
57     string public symbol = "CRP";
58     uint8 constant public decimals = 18;
59     uint8 constant internal entryFee_ = 4;
60     uint8 constant internal transferFee_ = 1;
61     uint8 constant internal exitFee_ = 10;
62     uint8 constant internal refferalFee_ = 33;
63     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
64     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
65     uint256 constant internal magnitude = 2 ** 64;
66     uint256 public stakingRequirement = 50e18;
67     mapping(address => uint256) internal tokenBalanceLedger_;
68     mapping(address => uint256) internal referralBalance_;
69     mapping(address => int256) internal payoutsTo_;
70     uint256 internal tokenSupply_;
71     uint256 internal profitPerShare_;
72 
73     function buy(address _referredBy) public payable returns (uint256) {
74         purchaseTokens(msg.value, _referredBy);
75     }
76 
77     function() payable public {
78         purchaseTokens(msg.value, 0x0);
79     }
80 
81     function reinvest() onlyStronghands public {
82         uint256 _dividends = myDividends(false);
83         address _customerAddress = msg.sender;
84         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
85         _dividends += referralBalance_[_customerAddress];
86         referralBalance_[_customerAddress] = 0;
87         uint256 _tokens = purchaseTokens(_dividends, 0x0);
88         emit onReinvestment(_customerAddress, _dividends, _tokens);
89     }
90 
91     function exit() public {
92         address _customerAddress = msg.sender;
93         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
94         if (_tokens > 0) sell(_tokens);
95         withdraw();
96     }
97 
98     function withdraw() onlyStronghands public {
99         address _customerAddress = msg.sender;
100         uint256 _dividends = myDividends(false);
101         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
102         _dividends += referralBalance_[_customerAddress];
103         referralBalance_[_customerAddress] = 0;
104         _customerAddress.transfer(_dividends);
105         emit onWithdraw(_customerAddress, _dividends);
106     }
107 
108     function sell(uint256 _amountOfTokens) onlyBagholders public {
109         address _customerAddress = msg.sender;
110         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
111         uint256 _tokens = _amountOfTokens;
112         uint256 _ethereum = tokensToEthereum_(_tokens);
113         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
114         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
115 
116         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
117         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
118 
119         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
120         payoutsTo_[_customerAddress] -= _updatedPayouts;
121 
122         if (tokenSupply_ > 0) {
123             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
124         }
125         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
126     }
127 
128     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
129         address _customerAddress = msg.sender;
130         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
131 
132         if (myDividends(true) > 0) {
133             withdraw();
134         }
135 
136         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
137         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
138         uint256 _dividends = tokensToEthereum_(_tokenFee);
139 
140         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
141         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
142         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
143         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
144         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
145         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
146         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
147         return true;
148     }
149 
150 
151     function totalEthereumBalance() public view returns (uint256) {
152         return address (this).balance;
153     }
154 
155     function totalSupply() public view returns (uint256) {
156         return tokenSupply_;
157     }
158 
159     function myTokens() public view returns (uint256) {
160         address _customerAddress = msg.sender;
161         return balanceOf(_customerAddress);
162     }
163 
164     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
165         address _customerAddress = msg.sender;
166         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
167     }
168 
169     function balanceOf(address _customerAddress) public view returns (uint256) {
170         return tokenBalanceLedger_[_customerAddress];
171     }
172 
173     function dividendsOf(address _customerAddress) public view returns (uint256) {
174         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
175     }
176 
177     function sellPrice() public view returns (uint256) {
178         // our calculation relies on the token supply, so we need supply. Doh.
179         if (tokenSupply_ == 0) {
180             return tokenPriceInitial_ - tokenPriceIncremental_;
181         } else {
182             uint256 _ethereum = tokensToEthereum_(1e18);
183             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
184             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
185 
186             return _taxedEthereum;
187         }
188     }
189 
190     function buyPrice() public view returns (uint256) {
191         if (tokenSupply_ == 0) {
192             return tokenPriceInitial_ + tokenPriceIncremental_;
193         } else {
194             uint256 _ethereum = tokensToEthereum_(1e18);
195             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
196             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
197 
198             return _taxedEthereum;
199         }
200     }
201 
202     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
203         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
204         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
205         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
206 
207         return _amountOfTokens;
208     }
209 
210     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
211         require(_tokensToSell <= tokenSupply_);
212         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
213         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
214         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
215         return _taxedEthereum;
216     }
217 
218 
219     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
220         address _customerAddress = msg.sender;
221         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
222         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
223         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
224         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
225         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
226         uint256 _fee = _dividends * magnitude;
227 
228         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
229 
230         if (
231             _referredBy != 0x0000000000000000000000000000000000000000 &&
232             _referredBy != _customerAddress &&
233             tokenBalanceLedger_[_referredBy] >= stakingRequirement
234         ) {
235             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
236         } else {
237             _dividends = SafeMath.add(_dividends, _referralBonus);
238             _fee = _dividends * magnitude;
239         }
240 
241         if (tokenSupply_ > 0) {
242             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
243             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
244             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
245         } else {
246             tokenSupply_ = _amountOfTokens;
247         }
248 
249         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
250         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
251         payoutsTo_[_customerAddress] += _updatedPayouts;
252         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
253 
254         return _amountOfTokens;
255     }
256 
257     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
258         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
259         uint256 _tokensReceived =
260             (
261                 (
262                     SafeMath.sub(
263                         (sqrt
264                             (
265                                 (_tokenPriceInitial ** 2)
266                                 +
267                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
268                                 +
269                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
270                                 +
271                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
272                             )
273                         ), _tokenPriceInitial
274                     )
275                 ) / (tokenPriceIncremental_)
276             ) - (tokenSupply_);
277 
278         return _tokensReceived;
279     }
280 
281     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
282         uint256 tokens_ = (_tokens + 1e18);
283         uint256 _tokenSupply = (tokenSupply_ + 1e18);
284         uint256 _etherReceived =
285             (
286                 SafeMath.sub(
287                     (
288                         (
289                             (
290                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
291                             ) - tokenPriceIncremental_
292                         ) * (tokens_ - 1e18)
293                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
294                 )
295                 / 1e18);
296 
297         return _etherReceived;
298     }
299 
300     function sqrt(uint256 x) internal pure returns (uint256 y) {
301         uint256 z = (x + 1) / 2;
302         y = x;
303 
304         while (z < y) {
305             y = z;
306             z = (x / z + z) / 2;
307         }
308     }
309 
310 
311 }
312 
313 library SafeMath {
314     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
315         if (a == 0) {
316             return 0;
317         }
318         uint256 c = a * b;
319         assert(c / a == b);
320         return c;
321     }
322 
323     function div(uint256 a, uint256 b) internal pure returns (uint256) {
324         uint256 c = a / b;
325         return c;
326     }
327 
328     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
329         assert(b <= a);
330         return a - b;
331     }
332 
333     function add(uint256 a, uint256 b) internal pure returns (uint256) {
334         uint256 c = a + b;
335         assert(c >= a);
336         return c;
337     }
338 }