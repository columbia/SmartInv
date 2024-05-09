1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://etherholders.com
5 *
6 * Community stokc EtherHolders
7 *
8 * [✓] 50% Deposit fee
9 * [✓] 0% Withdraw fee
10 *
11 */
12 
13 contract EtherHolders{
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
25     event onTokenPurchase(
26         address indexed customerAddress,
27         uint256 incomingEthereum,
28         uint256 tokensMinted,
29         address indexed referredBy,
30         uint timestamp,
31         uint256 price
32 );
33 
34     event onTokenSell(
35         address indexed customerAddress,
36         uint256 tokensBurned,
37         uint256 ethereumEarned,
38         uint timestamp,
39         uint256 price
40 );
41 
42     event onReinvestment(
43         address indexed customerAddress,
44         uint256 ethereumReinvested,
45         uint256 tokensMinted
46 );
47 
48     event onWithdraw(
49         address indexed customerAddress,
50         uint256 ethereumWithdrawn
51 );
52 
53     event Transfer(
54         address indexed from,
55         address indexed to,
56         uint256 tokens
57 );
58 
59     string public name = "EtherHolder";
60     string public symbol = "EH";
61     uint8 constant public decimals = 18;
62     uint8 constant internal entryFee_ = 50;
63     uint8 constant internal exitFee_ = 0;
64     uint8 constant internal transferFee_ = 0;
65     uint8 constant internal refferalFee_ = 0;
66     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
67     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
68     uint256 constant internal magnitude = 2 ** 64;
69     uint256 public stakingRequirement = 0;
70     mapping(address => uint256) internal tokenBalanceLedger_;
71     mapping(address => uint256) internal referralBalance_;
72     mapping(address => int256) internal payoutsTo_;
73     uint256 internal tokenSupply_;
74     uint256 internal profitPerShare_;
75 
76     function buy(address _referredBy) public payable returns (uint256) {
77         purchaseTokens(msg.value, _referredBy);
78     }
79 
80     function() payable public {
81         purchaseTokens(msg.value, 0x0);
82     }
83 
84     function reinvest() onlyStronghands public {
85         uint256 _dividends = myDividends(false);
86         address _customerAddress = msg.sender;
87         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
88         _dividends += referralBalance_[_customerAddress];
89         referralBalance_[_customerAddress] = 0;
90         uint256 _tokens = purchaseTokens(_dividends, 0x0);
91         emit onReinvestment(_customerAddress, _dividends, _tokens);
92     }
93 
94     function exit() public {
95         address _customerAddress = msg.sender;
96         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
97         if (_tokens > 0) sell(_tokens);
98         withdraw();
99     }
100 
101     function withdraw() onlyStronghands public {
102         address _customerAddress = msg.sender;
103         uint256 _dividends = myDividends(false);
104         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
105         _dividends += referralBalance_[_customerAddress];
106         referralBalance_[_customerAddress] = 0;
107         _customerAddress.transfer(_dividends);
108         emit onWithdraw(_customerAddress, _dividends);
109     }
110 
111     function sell(uint256 _amountOfTokens) onlyBagholders public {
112         address _customerAddress = msg.sender;
113         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
114         uint256 _tokens = _amountOfTokens;
115         uint256 _ethereum = tokensToEthereum_(_tokens);
116         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
117         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
118 
119         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
120 
121         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
122         payoutsTo_[_customerAddress] -= _updatedPayouts;
123 
124         if (tokenSupply_ > 0) {
125             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
126         }
127         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
128     }
129 
130     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
131         address _customerAddress = msg.sender;
132         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
133 
134         if (myDividends(true) > 0) {
135             withdraw();
136         }
137 
138         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
139         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
140         uint256 _dividends = tokensToEthereum_(_tokenFee);
141 
142         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
143         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
144         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
145         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
146         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
147         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
148         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
149         return true;
150     }
151 
152 
153     function totalEthereumBalance() public view returns (uint256) {
154         return this.balance;
155     }
156 
157     function totalSupply() public view returns (uint256) {
158         return tokenSupply_;
159     }
160 
161     function myTokens() public view returns (uint256) {
162         address _customerAddress = msg.sender;
163         return balanceOf(_customerAddress);
164     }
165 
166     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
167         address _customerAddress = msg.sender;
168         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
169     }
170 
171     function balanceOf(address _customerAddress) public view returns (uint256) {
172         return tokenBalanceLedger_[_customerAddress];
173     }
174 
175     function dividendsOf(address _customerAddress) public view returns (uint256) {
176         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
177     }
178 
179     function sellPrice() public view returns (uint256) {
180         // our calculation relies on the token supply, so we need supply. Doh.
181         if (tokenSupply_ == 0) {
182             return tokenPriceInitial_ - tokenPriceIncremental_;
183         } else {
184             uint256 _ethereum = tokensToEthereum_(1e18);
185             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
186             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
187 
188             return _taxedEthereum;
189         }
190     }
191 
192     function buyPrice() public view returns (uint256) {
193         if (tokenSupply_ == 0) {
194             return tokenPriceInitial_ + tokenPriceIncremental_;
195         } else {
196             uint256 _ethereum = tokensToEthereum_(1e18);
197             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
198             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
199 
200             return _taxedEthereum;
201         }
202     }
203 
204     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
205         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
206         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
207         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
208 
209         return _amountOfTokens;
210     }
211 
212     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
213         require(_tokensToSell <= tokenSupply_);
214         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
215         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
216         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
217         return _taxedEthereum;
218     }
219 
220 
221     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
222         address _customerAddress = msg.sender;
223         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
224         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
225         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
226         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
227         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
228         uint256 _fee = _dividends * magnitude;
229 
230         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
231 
232         if (
233             _referredBy != 0x0000000000000000000000000000000000000000 &&
234             _referredBy != _customerAddress &&
235             tokenBalanceLedger_[_referredBy] >= stakingRequirement
236         ) {
237             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
238         } else {
239             _dividends = SafeMath.add(_dividends, _referralBonus);
240             _fee = _dividends * magnitude;
241         }
242 
243         if (tokenSupply_ > 0) {
244             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
245             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
246             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
247         } else {
248             tokenSupply_ = _amountOfTokens;
249         }
250 
251         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
252         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
253         payoutsTo_[_customerAddress] += _updatedPayouts;
254         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
255 
256         return _amountOfTokens;
257     }
258 
259     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
260         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
261         uint256 _tokensReceived =
262             (
263                 (
264                     SafeMath.sub(
265                         (sqrt
266                             (
267                                 (_tokenPriceInitial ** 2)
268                                 +
269                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
270                                 +
271                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
272                                 +
273                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
274                             )
275                         ), _tokenPriceInitial
276                     )
277                 ) / (tokenPriceIncremental_)
278             ) - (tokenSupply_);
279 
280         return _tokensReceived;
281     }
282 
283     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
284         uint256 tokens_ = (_tokens + 1e18);
285         uint256 _tokenSupply = (tokenSupply_ + 1e18);
286         uint256 _etherReceived =
287             (
288                 SafeMath.sub(
289                     (
290                         (
291                             (
292                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
293                             ) - tokenPriceIncremental_
294                         ) * (tokens_ - 1e18)
295                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
296                 )
297                 / 1e18);
298 
299         return _etherReceived;
300     }
301 
302     function sqrt(uint256 x) internal pure returns (uint256 y) {
303         uint256 z = (x + 1) / 2;
304         y = x;
305 
306         while (z < y) {
307             y = z;
308             z = (x / z + z) / 2;
309         }
310     }
311 
312 
313 }
314 
315 library SafeMath {
316     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
317         if (a == 0) {
318             return 0;
319         }
320         uint256 c = a * b;
321         assert(c / a == b);
322         return c;
323     }
324 
325     function div(uint256 a, uint256 b) internal pure returns (uint256) {
326         uint256 c = a / b;
327         return c;
328     }
329 
330     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
331         assert(b <= a);
332         return a - b;
333     }
334 
335     function add(uint256 a, uint256 b) internal pure returns (uint256) {
336         uint256 c = a + b;
337         assert(c >= a);
338         return c;
339     }
340 }