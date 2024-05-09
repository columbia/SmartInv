1 pragma solidity ^0.4.26;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {
7       return 0;
8     }
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a / b;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 
29 }
30 
31 contract Ownable {
32 
33   address public owner;
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37   constructor() public {
38     owner = address(0xe21AC1CAE34c532a38B604669E18557B2d8840Fc);
39   }
40 
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   function transferOwnership(address newOwner) public onlyOwner {
47     require(newOwner != address(0));
48     emit OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 contract EKS is Ownable {
55 
56     uint256 ACTIVATION_TIME = 1580688000;
57 
58     modifier isActivated {
59         require(now >= ACTIVATION_TIME);
60         _;
61     }
62 
63     modifier onlyCustodian() {
64       require(msg.sender == custodianAddress);
65       _;
66     }
67 
68     modifier onlyTokenHolders {
69         require(myTokens() > 0);
70         _;
71     }
72 
73     modifier onlyDivis {
74         require(myDividends() > 0);
75         _;
76     }
77 
78     event onDistribute(
79         address indexed customerAddress,
80         uint256 price
81     );
82 
83     event onTokenPurchase(
84         address indexed customerAddress,
85         uint256 incomingETH,
86         uint256 tokensMinted,
87         uint timestamp
88     );
89 
90     event onTokenSell(
91         address indexed customerAddress,
92         uint256 tokensBurned,
93         uint256 ethereumEarned,
94         uint timestamp
95     );
96 
97     event onRoll(
98         address indexed customerAddress,
99         uint256 ethereumRolled,
100         uint256 tokensMinted
101     );
102 
103     event onWithdraw(
104         address indexed customerAddress,
105         uint256 ethereumWithdrawn
106     );
107 
108     event Transfer(
109         address indexed from,
110         address indexed to,
111         uint256 tokens
112     );
113 
114     string public name = "Tewkenaire Stable";
115     string public symbol = "STABLE";
116     uint8 constant public decimals = 18;
117 
118     uint256 internal entryFee_ = 10;
119     uint256 internal transferFee_ = 1;
120     uint256 internal exitFee_ = 10;
121     uint256 internal tewkenaireFee_ = 10; // 10% of the 10% buy or sell fees makes it 1%
122     uint256 internal maintenanceFee_ = 10; // 10% of the 10% buy or sell fees makes it 1%
123 
124     address internal maintenanceAddress;
125     address internal custodianAddress;
126 
127     address public approvedAddress1;
128     address public approvedAddress2;
129     address public distributionAddress;
130     uint256 public totalFundCollected;
131     uint256 public totalLaunchFundCollected;
132 
133     uint256 constant internal magnitude = 2 ** 64;
134     mapping(address => uint256) internal tokenBalanceLedger_;
135     mapping(address => int256) internal payoutsTo_;
136     mapping(address => uint256) public deposits;
137     mapping(address => uint256) public withdrawals;
138     uint256 internal tokenSupply_;
139     uint256 internal profitPerShare_;
140     uint256 public totalPlayer = 0;
141     uint256 public totalDonation = 0;
142 
143     bool public postLaunch = false;
144 
145     constructor() public {
146         maintenanceAddress = address(0xe21AC1CAE34c532a38B604669E18557B2d8840Fc);
147         custodianAddress = address(0x24B23bB643082026227e945C7833B81426057b10);
148         distributionAddress = address(0xfE8D614431E5fea2329B05839f29B553b1Cb99A2);
149         approvedAddress1 = distributionAddress;
150         approvedAddress2 = distributionAddress;
151     }
152 
153     function distribute() public payable returns (uint256) {
154         require(msg.value > 0 && postLaunch == true);
155         totalDonation += msg.value;
156         profitPerShare_ = SafeMath.add(profitPerShare_, (msg.value * magnitude) / tokenSupply_);
157         emit onDistribute(msg.sender, msg.value);
158     }
159 
160     function distributeLaunchFund() public {
161         require(totalLaunchFundCollected > 0 && postLaunch == false && now >= ACTIVATION_TIME + 24 hours);
162         profitPerShare_ = SafeMath.add(profitPerShare_, (totalLaunchFundCollected * magnitude) / tokenSupply_);
163         postLaunch = true;
164     }
165 
166     function buy() public payable returns (uint256) {
167         return purchaseTokens(msg.sender, msg.value);
168     }
169 
170     function buyFor(address _customerAddress) public payable returns (uint256) {
171         return purchaseTokens(_customerAddress, msg.value);
172     }
173 
174     function() payable public {
175         purchaseTokens(msg.sender, msg.value);
176     }
177 
178     function roll() onlyDivis public {
179         address _customerAddress = msg.sender;
180         uint256 _dividends = myDividends();
181         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
182         uint256 _tokens = purchaseTokens(_customerAddress, _dividends);
183         emit onRoll(_customerAddress, _dividends, _tokens);
184     }
185 
186     function exit() external {
187         address _customerAddress = msg.sender;
188         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
189         if (_tokens > 0) sell(_tokens);
190         withdraw();
191     }
192 
193     function withdraw() onlyDivis public {
194         address _customerAddress = msg.sender;
195         uint256 _dividends = myDividends();
196         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
197         _customerAddress.transfer(_dividends);
198         withdrawals[_customerAddress] += _dividends;
199         emit onWithdraw(_customerAddress, _dividends);
200     }
201 
202     function sell(uint256 _amountOfTokens) onlyTokenHolders public {
203         address _customerAddress = msg.sender;
204         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
205 
206         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_amountOfTokens, exitFee_), 100);
207 
208         uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends, maintenanceFee_),100);
209         maintenanceAddress.transfer(_maintenance);
210 
211         uint256 _tewkenaire = SafeMath.div(SafeMath.mul(_undividedDividends, tewkenaireFee_), 100);
212         totalFundCollected += _tewkenaire;
213         distributionAddress.transfer(_tewkenaire);
214 
215         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.add(_maintenance,_tewkenaire));
216         uint256 _taxedETH = SafeMath.sub(_amountOfTokens, _undividedDividends);
217 
218         tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfTokens);
219         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
220 
221         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens + (_taxedETH * magnitude));
222         payoutsTo_[_customerAddress] -= _updatedPayouts;
223 
224         if (postLaunch == false) {
225             totalLaunchFundCollected = SafeMath.add(totalLaunchFundCollected, _dividends);
226         } else if (tokenSupply_ > 0) {
227             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
228         }
229 
230         emit Transfer(_customerAddress, address(0), _amountOfTokens);
231         emit onTokenSell(_customerAddress, _amountOfTokens, _taxedETH, now);
232     }
233 
234     function transfer(address _toAddress, uint256 _amountOfTokens) onlyTokenHolders external returns (bool){
235         address _customerAddress = msg.sender;
236         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
237 
238         if (myDividends() > 0) {
239             withdraw();
240         }
241 
242         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
243         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
244         uint256 _dividends = _tokenFee;
245 
246         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
247 
248         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
249         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
250 
251         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
252         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
253 
254         if (postLaunch == false) {
255           totalLaunchFundCollected = SafeMath.add(totalLaunchFundCollected, _dividends);
256         } else {
257           profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
258         }
259 
260         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
261 
262         return true;
263     }
264 
265     function setName(string _name) onlyOwner public
266     {
267         name = _name;
268     }
269 
270     function setSymbol(string _symbol) onlyOwner public
271     {
272         symbol = _symbol;
273     }
274 
275     function approveAddress1(address _proposedAddress) onlyOwner public
276     {
277         approvedAddress1 = _proposedAddress;
278     }
279 
280     function approveAddress2(address _proposedAddress) onlyCustodian public
281     {
282         approvedAddress2 = _proposedAddress;
283     }
284 
285     function setAtomicSwapAddress() public
286     {
287         require(approvedAddress1 == approvedAddress2);
288         require(tx.origin == approvedAddress1);
289         distributionAddress = approvedAddress1;
290     }
291 
292     function totalEthereumBalance() public view returns (uint256) {
293         return address(this).balance;
294     }
295 
296     function totalSupply() public view returns (uint256) {
297         return tokenSupply_;
298     }
299 
300     function myTokens() public view returns (uint256) {
301         address _customerAddress = msg.sender;
302         return balanceOf(_customerAddress);
303     }
304 
305     function myDividends() public view returns (uint256) {
306         address _customerAddress = msg.sender;
307         return dividendsOf(_customerAddress);
308     }
309 
310     function balanceOf(address _customerAddress) public view returns (uint256) {
311         return tokenBalanceLedger_[_customerAddress];
312     }
313 
314     function dividendsOf(address _customerAddress) public view returns (uint256) {
315         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
316     }
317 
318     function sellPrice() public view returns (uint256) {
319         uint256 _ethereum = 1e18;
320         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
321         uint256 _taxedETH = SafeMath.sub(_ethereum, _dividends);
322 
323         return _taxedETH;
324     }
325 
326     function buyPrice() public view returns (uint256) {
327         uint256 _ethereum = 1e18;
328         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
329         uint256 _taxedETH = SafeMath.add(_ethereum, _dividends);
330 
331         return _taxedETH;
332     }
333 
334     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
335         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
336         uint256 _amountOfTokens = SafeMath.sub(_ethereumToSpend, _dividends);
337 
338         return _amountOfTokens;
339     }
340 
341     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
342         require(_tokensToSell <= tokenSupply_);
343         uint256 _dividends = SafeMath.div(SafeMath.mul(_tokensToSell, exitFee_), 100);
344         uint256 _taxedETH = SafeMath.sub(_tokensToSell, _dividends);
345 
346         return _taxedETH;
347     }
348 
349     function purchaseTokens(address _customerAddress, uint256 _incomingETH) internal isActivated returns (uint256) {
350         if (deposits[_customerAddress] == 0) {
351           totalPlayer++;
352         }
353 
354         deposits[_customerAddress] += _incomingETH;
355 
356         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingETH, entryFee_), 100);
357 
358         uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends, maintenanceFee_), 100);
359         maintenanceAddress.transfer(_maintenance);
360 
361         uint256 _tewkenaire = SafeMath.div(SafeMath.mul(_undividedDividends, tewkenaireFee_), 100);
362         totalFundCollected += _tewkenaire;
363         distributionAddress.transfer(_tewkenaire);
364 
365         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.add(_tewkenaire,_maintenance));
366         uint256 _amountOfTokens = SafeMath.sub(_incomingETH, _undividedDividends);
367         uint256 _fee = _dividends * magnitude;
368 
369         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
370 
371         if (postLaunch == false) {
372             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
373             totalLaunchFundCollected = SafeMath.add(totalLaunchFundCollected, _dividends);
374             _fee = 0;
375         } else if (tokenSupply_ > 0) {
376             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
377             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
378             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
379         } else {
380             tokenSupply_ = _amountOfTokens;
381         }
382 
383         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
384 
385         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
386         payoutsTo_[_customerAddress] += _updatedPayouts;
387 
388         emit Transfer(address(0), _customerAddress, _amountOfTokens);
389         emit onTokenPurchase(_customerAddress, _incomingETH, _amountOfTokens, now);
390 
391         return _amountOfTokens;
392     }
393 }