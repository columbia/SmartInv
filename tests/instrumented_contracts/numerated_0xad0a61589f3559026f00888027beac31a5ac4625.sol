1 pragma solidity ^0.4.25;
2 
3 /*
4     Neutrino Token Standard v1.1
5     + fund() payable
6     + 2 days free deposit
7 
8     [Rules]
9 
10     [✓] 10% Deposit fee
11             33% => referrer (or contract owner, if none)
12             10% => contract owner
13             57% => dividends
14     [✓] 1% Withdraw fee
15             100% => contract owner
16 */
17 
18 contract NeutrinoTokenStandard {
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
36     );
37 
38     event onTokenSell(
39         address indexed customerAddress,
40         uint256 tokensBurned,
41         uint256 ethereumEarned,
42         uint timestamp,
43         uint256 price
44     );
45 
46     event onReinvestment(
47         address indexed customerAddress,
48         uint256 ethereumReinvested,
49         uint256 tokensMinted
50     );
51 
52     event onWithdraw(
53         address indexed customerAddress,
54         uint256 ethereumWithdrawn
55     );
56     
57     event OnFunded(
58         address indexed source,
59         uint256 value,
60         uint256 perShare
61     );
62 
63     string public name = "Neutrino Token Standard";
64     string public symbol = "NTS";
65     address constant internal boss = 0x10d915C0B3e01090C7B5f80eF2D9CdB616283853;
66     uint8 constant public decimals = 18;
67     uint8 constant internal entryFee_ = 10;
68     uint8 constant internal exitFee_ = 1;
69     uint8 constant internal refferalFee_ = 33;
70     uint8 constant internal ownerFee1 = 10;
71     uint8 constant internal ownerFee2 = 25;
72     uint32 holdTimeInBlocks = 558000;
73     uint256 constant internal tokenPrice = 0.001 ether;
74     
75     uint256 constant internal magnitude = 2 ** 64;
76     uint256 public stakingRequirement = 50e18;
77     mapping(address => uint256) internal tokenBalanceLedger_;
78     mapping(address => uint256) public referralBalance_;
79     mapping(address => int256) internal payoutsTo_;
80     mapping(address => uint256) public since;
81 
82     uint256 internal tokenSupply_;
83     uint256 internal profitPerShare_;
84     uint256 internal start_;
85     
86     constructor() public {
87         start_ = block.number;
88     }
89 
90     function buy(address _referredBy) public payable returns (uint256) {
91         return purchaseTokens(msg.value, _referredBy);
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
129         uint256 _ethereum = tokensToEthereum_(_tokens);
130 
131         uint8 applyFee;
132         uint256 _dividends;
133         uint256 forBoss;
134         uint256 _taxedEthereum;
135         
136         if (since[msg.sender] + holdTimeInBlocks > block.number) {
137             applyFee = 20;
138 
139             _dividends = SafeMath.div(SafeMath.mul(_ethereum, applyFee), 100);
140             forBoss = SafeMath.div(SafeMath.mul(_dividends, ownerFee2), 100);
141             _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
142             
143             _dividends = SafeMath.sub(_dividends, forBoss);
144             
145             tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
146     
147             if (tokenSupply_ > 0) {
148                 profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
149             } else {
150                 referralBalance_[boss] += _dividends;
151             }
152         } else {
153             applyFee = exitFee_;
154             
155             forBoss = SafeMath.div(SafeMath.mul(_ethereum, applyFee), 100);
156             _taxedEthereum = SafeMath.sub(_ethereum, forBoss);
157             
158             tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
159         }
160         
161         referralBalance_[boss] = SafeMath.add(referralBalance_[boss], forBoss);
162         
163         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
164         
165         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
166         payoutsTo_[_customerAddress] -= _updatedPayouts;
167         
168         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
169     }
170 
171 
172     function totalSupply() public view returns (uint256) {
173         return tokenSupply_;
174     }
175 
176     function myTokens() public view returns (uint256) {
177         address _customerAddress = msg.sender;
178         return balanceOf(_customerAddress);
179     }
180 
181     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
182         address _customerAddress = msg.sender;
183         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
184     }
185 
186     function balanceOf(address _customerAddress) public view returns (uint256) {
187         return tokenBalanceLedger_[_customerAddress];
188     }
189 
190     function dividendsOf(address _customerAddress) public view returns (uint256) {
191         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
192     }
193 
194     function sellPrice() public pure returns (uint256) {
195         uint256 _ethereum = tokensToEthereum_(1e18);
196         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
197         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
198 
199         return _taxedEthereum;
200     }
201 
202     function buyPrice() public pure returns (uint256) {
203         uint256 _ethereum = tokensToEthereum_(1e18);
204         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
205         uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
206 
207         return _taxedEthereum;
208     }
209 
210     function calculateTokensReceived(uint256 _ethereumToSpend) public pure returns (uint256) {
211         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
212         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
213         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
214 
215         return _amountOfTokens;
216     }
217 
218     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
219         require(_tokensToSell <= tokenSupply_);
220         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
221         uint8 applyFee = exitFee_;
222         if (since[msg.sender] + holdTimeInBlocks > block.number) applyFee = 20;
223         
224         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, applyFee), 100);
225         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
226         return _taxedEthereum;
227     }
228 
229     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
230         address _customerAddress = msg.sender;
231         uint8 _entryFee = entryFee_;
232         if (block.number < start_ + 12130) _entryFee = 0;
233         
234         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, _entryFee), 100);
235         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
236         uint256 forBoss = SafeMath.div(SafeMath.mul(_undividedDividends, ownerFee1), 100);
237         uint256 _dividends = SafeMath.sub(SafeMath.sub(_undividedDividends, _referralBonus), forBoss);
238         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
239         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
240         uint256 _fee = _dividends * magnitude;
241 
242         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
243 
244         if (
245             _referredBy != 0x0000000000000000000000000000000000000000 &&
246             _referredBy != _customerAddress &&
247             tokenBalanceLedger_[_referredBy] >= stakingRequirement
248         ) {
249             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
250             emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
251         } else {
252             referralBalance_[boss] = SafeMath.add(referralBalance_[boss], _referralBonus);
253             emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, 0x0, now, buyPrice());
254         }
255 
256         referralBalance_[boss] = SafeMath.add(referralBalance_[boss], forBoss);
257 
258         if (tokenSupply_ > 0) {
259             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
260             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
261             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
262         } else {
263             tokenSupply_ = _amountOfTokens;
264         }
265 
266         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
267         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
268         payoutsTo_[_customerAddress] += _updatedPayouts;
269         if (since[msg.sender] == 0) since[msg.sender] = block.number;
270 
271         return _amountOfTokens;
272     }
273 
274     function ethereumToTokens_(uint256 _ethereum) public pure returns (uint256) {
275         uint256 _tokensReceived = SafeMath.div(SafeMath.mul(_ethereum, 1e18), tokenPrice);
276 
277         return _tokensReceived;
278     }
279 
280     function tokensToEthereum_(uint256 _tokens) public pure returns (uint256) {
281         uint256 _etherReceived = SafeMath.div(SafeMath.mul(_tokens, tokenPrice), 1e18);
282 
283         return _etherReceived;
284     }
285     
286     function fund() public payable {
287         uint256 perShare = msg.value * magnitude / tokenSupply_;
288         profitPerShare_ += perShare;
289         emit OnFunded(msg.sender, msg.value, perShare);
290     }
291 }
292 
293 library SafeMath {
294     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
295         if (a == 0) {
296             return 0;
297         }
298         uint256 c = a * b;
299         require(c / a == b);
300         return c;
301     }
302 
303     function div(uint256 a, uint256 b) internal pure returns (uint256) {
304         require(b > 0);
305         uint256 c = a / b;
306         return c;
307     }
308 
309     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
310         require(b <= a);
311         return a - b;
312     }
313 
314     function add(uint256 a, uint256 b) internal pure returns (uint256) {
315         uint256 c = a + b;
316         require(c >= a);
317         return c;
318     }
319 }