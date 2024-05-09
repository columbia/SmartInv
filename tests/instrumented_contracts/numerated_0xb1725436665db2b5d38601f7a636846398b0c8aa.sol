1 pragma solidity ^0.4.25;
2 
3 /*
4 * [✓] 4% Withdraw fee
5 * [✓] 10% Deposit fee
6 * [✓] 1% Token transfer
7 * [✓] 33% Referal link
8 
9 test contract
10 *
11 */
12 
13 contract EthereumMinerTokenClassic {
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
59     string public name = "Ethereum Miner Token Classic";
60     string public symbol = "EMC";
61     uint8 constant public decimals = 18;
62     uint8 constant internal entryFee_ = 10;
63     uint8 constant internal transferFee_ = 1;
64     uint8 constant internal exitFee_ = 4;
65     uint8 constant internal refferalFee_ = 33;
66     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
67     uint256 constant internal magnitude = 4 ** 64;
68     uint256 public stakingRequirement = 50e18;
69     mapping(address => uint256) internal tokenBalanceLedger_;
70     mapping(address => uint256) internal referralBalance_;
71     mapping(address => int256) internal payoutsTo_;
72     uint256 internal tokenSupply_;
73     uint256  tokenPriceIncremental_ = 0.000000005 ether;
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
119         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
120         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
121 
122         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
123         payoutsTo_[_customerAddress] -= _updatedPayouts;
124 
125         if (tokenSupply_ > 0) {
126             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
127         }
128         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
129     }
130 
131     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
132         address _customerAddress = msg.sender;
133         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
134 
135         if (myDividends(true) > 0) {
136             withdraw();
137         }
138 
139         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
140         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
141         uint256 _dividends = tokensToEthereum_(_tokenFee);
142 
143         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
144         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
145         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
146         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
147         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
148         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
149         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
150         return true;
151     }
152 
153 
154     function totalEthereumBalance() public view returns (uint256) {
155         return this.balance;
156     }
157 
158     function totalSupply() public view returns (uint256) {
159         return tokenSupply_;
160     }
161 
162     function myTokens() public view returns (uint256) {
163         address _customerAddress = msg.sender;
164         return balanceOf(_customerAddress);
165     }
166 
167     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
168         address _customerAddress = msg.sender;
169         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
170     }
171 
172     function balanceOf(address _customerAddress) public view returns (uint256) {
173         return tokenBalanceLedger_[_customerAddress];
174     }
175 
176     function dividendsOf(address _customerAddress) public view returns (uint256) {
177         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
178     }
179 
180     function sellPrice() public view returns (uint256) {
181         // our calculation relies on the token supply, so we need supply. Doh.
182         if (tokenSupply_ == 0) {
183             return tokenPriceInitial_ - tokenPriceIncremental_;
184         } else {
185             uint256 _ethereum = tokensToEthereum_(1e18);
186             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
187             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
188 
189             return _taxedEthereum;
190         }
191     }
192 
193     function buyPrice() public view returns (uint256) {
194         if (tokenSupply_ == 0) {
195             return tokenPriceInitial_ + tokenPriceIncremental_;
196         } else {
197             uint256 _ethereum = tokensToEthereum_(1e18);
198             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
199             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
200 
201             return _taxedEthereum;
202         }
203     }
204 
205     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
206         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
207         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
208         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
209 
210         return _amountOfTokens;
211     }
212 
213     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
214         require(_tokensToSell <= tokenSupply_);
215         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
216         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
217         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
218         return _taxedEthereum;
219     }
220 
221 
222     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
223         address _customerAddress = msg.sender;
224         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
225         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
226         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
227         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
228         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
229         uint256 _fee = _dividends * magnitude;
230          
231 
232         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
233 
234         if (
235             _referredBy != 0x0000000000000000000000000000000000000000 &&
236             _referredBy != _customerAddress &&
237             tokenBalanceLedger_[_referredBy] >= stakingRequirement
238         ) {
239             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
240         } else {
241             _dividends = SafeMath.add(_dividends, _referralBonus);
242             _fee = _dividends * magnitude;
243         }
244 
245         if (tokenSupply_ > 0) {
246             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
247             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
248             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
249         } else {
250             tokenSupply_ = _amountOfTokens;
251         }
252 
253         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
254         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
255         payoutsTo_[_customerAddress] += _updatedPayouts;
256         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
257 
258         return _amountOfTokens;
259     }
260 
261     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
262         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
263         if(tokenSupply_ >= 18953 * 1e18)
264         {        
265          tokenPriceIncremental_ = 0.00000001 ether; 
266         }  
267         uint256 _tokensReceived =
268             (
269                 (
270                     SafeMath.sub(
271                         (sqrt
272                             (
273                                 (_tokenPriceInitial ** 2)
274                                 +
275                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
276                                 +
277                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
278                                 +
279                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
280                             )
281                         ), _tokenPriceInitial
282                     )
283                 ) / (tokenPriceIncremental_)
284             ) - (tokenSupply_);
285 
286         return _tokensReceived;
287     }
288 
289     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
290         uint256 tokens_ = (_tokens + 1e18);
291         uint256 _tokenSupply = (tokenSupply_ + 1e18);
292         uint256 _etherReceived =
293             (
294                 SafeMath.sub(
295                     (
296                         (
297                             (
298                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
299                             ) - tokenPriceIncremental_
300                         ) * (tokens_ - 1e18)
301                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
302                 )
303                 / 1e18);
304 
305         return _etherReceived;
306     }
307 
308     function sqrt(uint256 x) internal pure returns (uint256 y) {
309         uint256 z = (x + 1) / 2;
310         y = x;
311 
312         while (z < y) {
313             y = z;
314             z = (x / z + z) / 2;
315         }
316     }
317 
318 
319 }
320 
321 library SafeMath {
322     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
323         if (a == 0) {
324             return 0;
325         }
326         uint256 c = a * b;
327         assert(c / a == b);
328         return c;
329     }
330 
331     function div(uint256 a, uint256 b) internal pure returns (uint256) {
332         uint256 c = a / b;
333         return c;
334     }
335 
336     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
337         assert(b <= a);
338         return a - b;
339     }
340 
341     function add(uint256 a, uint256 b) internal pure returns (uint256) {
342         uint256 c = a + b;
343         assert(c >= a);
344         return c;
345     }
346 }