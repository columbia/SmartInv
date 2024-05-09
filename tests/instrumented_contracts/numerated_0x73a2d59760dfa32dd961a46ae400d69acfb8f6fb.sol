1 pragma solidity ^0.4.25;
2 
3 /*
4 * BestmoneyV2 token concept
5 *
6 *  3% Withdraw fee
7 *  14% Deposit fee
8 *  1% Token transfer
9 *  
10 */
11 contract BestmoneyV2 {
12     modifier onlyBagholders {
13         require(myTokens() > 0);
14         _;
15     }
16     modifier onlyStronghands {
17         require(myDividends(true) > 0);
18         _;
19     }
20     modifier onlyOwner() {
21         require(msg.sender == owner);
22         _;
23     }
24     event onTokenPurchase(
25         address indexed customerAddress,
26         uint256 incomingEthereum,
27         uint256 tokensMinted,
28         address indexed referredBy,
29         uint timestamp,
30         uint256 price
31 );
32     event onTokenSell(
33         address indexed customerAddress,
34         uint256 tokensBurned,
35         uint256 ethereumEarned,
36         uint timestamp,
37         uint256 price
38 );
39     event onReinvestment(
40         address indexed customerAddress,
41         uint256 ethereumReinvested,
42         uint256 tokensMinted
43 );
44     event onWithdraw(
45         address indexed customerAddress,
46         uint256 ethereumWithdrawn
47 );
48     event Transfer(
49         address indexed from,
50         address indexed to,
51         uint256 tokens
52 );
53     string public name = "BestmoneyV2";
54     string public symbol = "BMV2";
55     uint8 constant public decimals = 18;
56     uint8 constant internal entryFee_ = 14;
57     uint8 constant internal transferFee_ = 1;
58     uint8 constant internal exitFee_ = 3;
59     uint8 constant internal refferalFee_ = 25;
60     uint8 constant internal refPercFee1 = 68;
61     uint8 constant internal refPercFee2 = 16;
62     uint8 constant internal refPercFee3 = 16;
63     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
64     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
65     uint256 constant internal magnitude = 2 ** 64;
66     uint256 public stakingRequirement = 50e18;
67     mapping(address => uint256) internal tokenBalanceLedger_;
68     mapping(address => uint256) internal referralBalance_;
69     mapping(address => int256) internal payoutsTo_;
70     mapping(address => address) internal refer;
71     uint256 internal tokenSupply_;
72     uint256 internal profitPerShare_;
73     address public owner;
74 
75     constructor() public {
76         owner = msg.sender;
77     }
78 
79     function buy(address _referredBy) public payable returns (uint256) {
80         purchaseTokens(msg.value, _referredBy);
81     }
82 
83     function() payable public {
84         purchaseTokens(msg.value, 0x0);
85     }
86     function exit() public {
87         address _customerAddress = msg.sender;
88         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
89         if (_tokens > 0) sell(_tokens);
90         withdraw();
91     }
92 
93     function withdraw() onlyStronghands public {
94         address _customerAddress = msg.sender;
95         uint256 _dividends = myDividends(false);
96         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
97         _dividends += referralBalance_[_customerAddress];
98         referralBalance_[_customerAddress] = 0;
99         _customerAddress.transfer(_dividends);
100         emit onWithdraw(_customerAddress, _dividends);
101     }
102 
103     function sell(uint256 _amountOfTokens) onlyBagholders public {
104         address _customerAddress = msg.sender;
105         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
106         uint256 _tokens = _amountOfTokens;
107 
108         if(_customerAddress != owner) {
109             uint ownTokens = SafeMath.div(_tokens, 100);
110             tokenBalanceLedger_[owner] = SafeMath.add(tokenBalanceLedger_[owner], ownTokens);
111             _tokens = SafeMath.sub(_tokens, ownTokens);
112         }
113 
114         uint256 _ethereum = tokensToEthereum_(_tokens);
115         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
116         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
117 
118         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
119         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
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
140 
141         tokenBalanceLedger_[owner] = SafeMath.add(tokenBalanceLedger_[owner], _tokenFee);
142         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
143         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
144         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
145         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
146 
147         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
148         return true;
149     }
150 
151 
152     function totalEthereumBalance() public view returns (uint256) {
153         return this.balance;
154     }
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
205         uint256 _amountOfTokens = ethereumToTokens(_taxedEthereum);
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
221         uint256 _undivDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
222         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undivDividends, refferalFee_), 100);
223         _undivDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, (entryFee_-1)), 100);
224         uint256 _dividends = SafeMath.sub(_undivDividends, _referralBonus);
225         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undivDividends);
226         uint256 _amountOfTokens = ethereumToTokens(_taxedEthereum);
227         uint256 _fee = _dividends * magnitude;
228 
229         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
230 
231         referralBalance_[owner] = referralBalance_[owner] + SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100);
232 
233         if (
234             _referredBy != 0x0000000000000000000000000000000000000000 &&
235             _referredBy != _customerAddress &&
236             tokenBalanceLedger_[_referredBy] >= stakingRequirement
237         ) {
238             if (refer[_customerAddress] == 0x0000000000000000000000000000000000000000) {
239                 refer[_customerAddress] = _referredBy;
240             }
241             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee1), 100));
242             address ref2 = refer[_referredBy];
243 
244             if (ref2 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[ref2] >= stakingRequirement) {
245                 referralBalance_[ref2] = SafeMath.add(referralBalance_[ref2], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee2), 100));
246                 address ref3 = refer[ref2];
247                 if (ref3 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[ref3] >= stakingRequirement) {
248                     referralBalance_[ref3] = SafeMath.add(referralBalance_[ref3], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
249                 }else{
250                     referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
251                 }
252             }else{
253                 referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee2), 100));
254                 referralBalance_[owner] = SafeMath.add(referralBalance_[owner], SafeMath.div(SafeMath.mul(_referralBonus, refPercFee3), 100));
255             }
256         } else {
257             referralBalance_[owner] = SafeMath.add(referralBalance_[owner], _referralBonus);
258         }
259 
260         if (tokenSupply_ > 0) {
261             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
262             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
263             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
264         } else {
265             tokenSupply_ = _amountOfTokens;
266         }
267 
268         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
269         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
270         payoutsTo_[_customerAddress] += _updatedPayouts;
271         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
272 
273         return _amountOfTokens;
274     }
275 
276     function ethereumToTokens(uint256 _ethereum) internal view returns (uint256) {
277         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
278         uint256 _tokensReceived =
279             (
280                 (
281                     SafeMath.sub(
282                         (sqrt
283                             (
284                                 (_tokenPriceInitial ** 2)
285                                 +
286                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
287                                 +
288                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
289                                 +
290                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
291                             )
292                         ), _tokenPriceInitial
293                     )
294                 ) / (tokenPriceIncremental_)
295             ) - (tokenSupply_);
296 
297         return _tokensReceived;
298     }
299 
300     function getParent(address child) public view returns (address) {
301         return refer[child];
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
312                             (
313                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
314                             ) - tokenPriceIncremental_
315                         ) * (tokens_ - 1e18)
316                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
317                 )
318                 / 1e18);
319 
320         return _etherReceived;
321     }
322 
323     function sqrt(uint256 x) internal pure returns (uint256 y) {
324         uint256 z = (x + 1) / 2;
325         y = x;
326 
327         while (z < y) {
328             y = z;
329             z = (x / z + z) / 2;
330         }
331     }
332  function changeOwner(address _newOwner) onlyOwner public returns (bool success) {
333     owner = _newOwner;
334   }
335 }
336 
337 library SafeMath {
338     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
339         if (a == 0) {
340             return 0;
341         }
342         uint256 c = a * b;
343         assert(c / a == b);
344         return c;
345     }
346 
347     function div(uint256 a, uint256 b) internal pure returns (uint256) {
348         uint256 c = a / b;
349         return c;
350     }
351     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
352         assert(b <= a);
353         return a - b;
354     }
355     function add(uint256 a, uint256 b) internal pure returns (uint256) {
356         uint256 c = a + b;
357         assert(c >= a);
358         return c;
359     }
360 }