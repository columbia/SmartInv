1 pragma solidity ^0.4.25;
2 
3 /*
4 *
5 * Proof of No Dump
6 *
7 * [?] 35% Withdraw fee
8 * [?] 15% Deposit fee
9 * [?] 1% Token transfer
10 * [?] 30% Referral link
11 *
12 */
13 
14 contract ProofofNoDump{
15     using SafeMath for uint256;
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
61     string public name = "Proof Of No Dump";
62     string public symbol = "POND";
63     uint8 constant public decimals = 18;
64     uint8 constant internal entryFee_ = 15;
65     uint8 constant internal transferFee_ = 1;
66     uint8 constant internal exitFee_ = 29;
67     uint8 constant internal refferalFee_ = 30;
68     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
69     uint256 constant internal tokenPriceIncremental_ = 0.0000001 ether;
70     uint256 constant internal magnitude = 2 ** 64;
71     uint256 public stakingRequirement = 50e18;
72     mapping(address => uint256) internal tokenBalanceLedger_;
73     mapping(address => uint256) internal referralBalance_;
74     mapping(address => int256) internal payoutsTo_;
75     uint256 internal tokenSupply_;
76     uint256 internal profitPerShare_;
77     address promoter1 = 0xbfb297616ffa0124a288e212d1e6df5299c9f8d0;
78     address promoter2 = 0xC558895aE123BB02b3c33164FdeC34E9Fb66B660;
79     address promoter3 = 0x20007c6aa01e6a0e73d1baB69666438FF43B5ed8;
80 
81     function buy(address _referredBy) public payable returns (uint256) {
82         promoter1.transfer(msg.value.div(100).mul(2));
83         promoter2.transfer(msg.value.div(100).mul(2));
84         promoter3.transfer(msg.value.div(100).mul(2));
85         uint256 percent = msg.value.mul(6).div(100);
86         uint256 purchasevalue = msg.value.sub(percent);
87         purchaseTokens(purchasevalue, _referredBy);
88     }
89 
90     function() payable public {
91         promoter1.transfer(msg.value.div(100).mul(2));
92         promoter2.transfer(msg.value.div(100).mul(2));
93         promoter3.transfer(msg.value.div(100).mul(2));
94         uint256 percent = msg.value.mul(6).div(100);
95         uint256 purchasevalue1 = msg.value.sub(percent);
96         purchaseTokens(purchasevalue1, 0x0);
97     }
98 
99     function reinvest() onlyStronghands public {
100         uint256 _dividends = myDividends(false);
101         address _customerAddress = msg.sender;
102         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
103         _dividends += referralBalance_[_customerAddress];
104         referralBalance_[_customerAddress] = 0;
105         uint256 _tokens = purchaseTokens(_dividends, 0x0);
106         emit onReinvestment(_customerAddress, _dividends, _tokens);
107     }
108 
109     function exit() public {
110         address _customerAddress = msg.sender;
111         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
112         if (_tokens > 0) sell(_tokens);
113         withdraw();
114     }
115 
116     function withdraw() onlyStronghands public {
117         address _customerAddress = msg.sender;
118         uint256 _dividends = myDividends(false);
119         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
120         _dividends += referralBalance_[_customerAddress];
121         referralBalance_[_customerAddress] = 0;
122         _customerAddress.transfer(_dividends);
123         emit onWithdraw(_customerAddress, _dividends);
124     }
125 
126     function sell(uint256 _amountOfTokens) onlyBagholders public {
127         address _customerAddress = msg.sender;
128         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
129         uint256 _tokens = _amountOfTokens;
130         uint256 _ethereum = tokensToEthereum_(_tokens);
131         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
132         uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 6), 100);
133         uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
134         uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
135         uint256 _devexitindividual = SafeMath.div(SafeMath.mul(_ethereum, 2), 100); 
136         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
137         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
138         promoter1.transfer(_devexitindividual);
139         promoter2.transfer(_devexitindividual);
140         promoter3.transfer(_devexitindividual);
141         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
142         payoutsTo_[_customerAddress] -= _updatedPayouts;
143 
144         if (tokenSupply_ > 0) {
145             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
146         }
147         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
148     }
149 
150     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
151         address _customerAddress = msg.sender;
152         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
153 
154         if (myDividends(true) > 0) {
155             withdraw();
156         }
157 
158         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
159         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
160         uint256 _dividends = tokensToEthereum_(_tokenFee);
161 
162         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
163         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
164         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
165         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
166         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
167         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
168         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
169         return true;
170     }
171 
172 
173     function totalEthereumBalance() public view returns (uint256) {
174         return this.balance;
175     }
176 
177     function totalSupply() public view returns (uint256) {
178         return tokenSupply_;
179     }
180 
181     function myTokens() public view returns (uint256) {
182         address _customerAddress = msg.sender;
183         return balanceOf(_customerAddress);
184     }
185 
186     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
187         address _customerAddress = msg.sender;
188         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
189     }
190 
191     function balanceOf(address _customerAddress) public view returns (uint256) {
192         return tokenBalanceLedger_[_customerAddress];
193     }
194 
195     function dividendsOf(address _customerAddress) public view returns (uint256) {
196         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
197     }
198 
199     function sellPrice() public view returns (uint256) {
200         // our calculation relies on the token supply, so we need supply. Doh.
201         if (tokenSupply_ == 0) {
202             return tokenPriceInitial_ - tokenPriceIncremental_;
203         } else {
204             uint256 _ethereum = tokensToEthereum_(1e18);
205             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
206             uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 6), 100);
207             uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
208             uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
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
228         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
229 
230         return _amountOfTokens;
231     }
232 
233     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
234         require(_tokensToSell <= tokenSupply_);
235         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
236         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
237         uint256 _devexit = SafeMath.div(SafeMath.mul(_ethereum, 6), 100);
238         uint256 _taxedEthereum1 = SafeMath.sub(_ethereum, _dividends);
239         uint256 _taxedEthereum = SafeMath.sub(_taxedEthereum1, _devexit);
240         return _taxedEthereum;
241     }
242 
243 
244     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
245         address _customerAddress = msg.sender;
246         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
247         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
248         uint256 _devbuyfees = SafeMath.div(SafeMath.mul(_incomingEthereum, 5), 100);
249         uint256 _dividends1 = SafeMath.sub(_undividedDividends, _referralBonus);
250         uint256 _dividends = SafeMath.sub(_dividends1, _devbuyfees);
251         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
252         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
253         uint256 _fee = _dividends * magnitude;
254 
255         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
256 
257         if (
258             _referredBy != 0x0000000000000000000000000000000000000000 &&
259             _referredBy != _customerAddress &&
260             tokenBalanceLedger_[_referredBy] >= stakingRequirement
261         ) {
262             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
263         } else {
264             _dividends = SafeMath.add(_dividends, _referralBonus);
265             _fee = _dividends * magnitude;
266         }
267 
268         if (tokenSupply_ > 0) {
269             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
270             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
271             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
272         } else {
273             tokenSupply_ = _amountOfTokens;
274         }
275 
276         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
277         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
278         payoutsTo_[_customerAddress] += _updatedPayouts;
279         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
280 
281         return _amountOfTokens;
282     }
283 
284     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
285         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
286         uint256 _tokensReceived =
287             (
288                 (
289                     SafeMath.sub(
290                         (sqrt
291                             (
292                                 (_tokenPriceInitial ** 2)
293                                 +
294                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
295                                 +
296                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
297                                 +
298                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
299                             )
300                         ), _tokenPriceInitial
301                     )
302                 ) / (tokenPriceIncremental_)
303             ) - (tokenSupply_);
304 
305         return _tokensReceived;
306     }
307 
308     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
309         uint256 tokens_ = (_tokens + 1e18);
310         uint256 _tokenSupply = (tokenSupply_ + 1e18);
311         uint256 _etherReceived =
312             (
313                 SafeMath.sub(
314                     (
315                         (
316                             (
317                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
318                             ) - tokenPriceIncremental_
319                         ) * (tokens_ - 1e18)
320                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
321                 )
322                 / 1e18);
323 
324         return _etherReceived;
325     }
326 
327     function sqrt(uint256 x) internal pure returns (uint256 y) {
328         uint256 z = (x + 1) / 2;
329         y = x;
330 
331         while (z < y) {
332             y = z;
333             z = (x / z + z) / 2;
334         }
335     }
336 
337 
338 }
339 
340 library SafeMath {
341     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
342         if (a == 0) {
343             return 0;
344         }
345         uint256 c = a * b;
346         assert(c / a == b);
347         return c;
348     }
349 
350     function div(uint256 a, uint256 b) internal pure returns (uint256) {
351         uint256 c = a / b;
352         return c;
353     }
354 
355     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
356         assert(b <= a);
357         return a - b;
358     }
359 
360     function add(uint256 a, uint256 b) internal pure returns (uint256) {
361         uint256 c = a + b;
362         assert(c >= a);
363         return c;
364     }
365 }