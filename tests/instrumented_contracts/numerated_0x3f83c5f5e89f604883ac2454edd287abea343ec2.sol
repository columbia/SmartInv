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
31 contract TOKEN {
32    function totalSupply() external view returns (uint256);
33    function balanceOf(address account) external view returns (uint256);
34    function transfer(address recipient, uint256 amount) external returns (bool);
35    function allowance(address owner, address spender) external view returns (uint256);
36    function approve(address spender, uint256 amount) external returns (bool);
37    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
38 }
39 
40 contract Ownable {
41 
42   address public owner;
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46   constructor() public {
47     owner = address(0x72bEe2Cf43f658F3EdF5f4E08bAB03b5F777FA0A);
48   }
49 
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55   function transferOwnership(address newOwner) public onlyOwner {
56     require(newOwner != address(0));
57     emit OwnershipTransferred(owner, newOwner);
58     owner = newOwner;
59   }
60 
61 }
62 
63 contract Pyrahex is Ownable {
64 
65     mapping(address => bool) internal ambassadors_;
66     uint256 constant internal ambassadorMaxPurchase_ = 1000000e8;
67     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
68     bool public onlyAmbassadors = true;
69     uint256 ACTIVATION_TIME = 1577646000;
70 
71     modifier antiEarlyWhale(uint256 _amountOfHEX, address _customerAddress){
72       if (now >= ACTIVATION_TIME) {
73          onlyAmbassadors = false;
74       }
75 
76       if (onlyAmbassadors) {
77          require((ambassadors_[_customerAddress] == true && (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfHEX) <= ambassadorMaxPurchase_));
78          ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfHEX);
79          _;
80       } else {
81         if(now < (ACTIVATION_TIME + 60 seconds)) {
82           require(tx.gasprice <= 0.1 szabo);
83         }
84 
85          onlyAmbassadors = false;
86          _;
87       }
88     }
89 
90     modifier onlyTokenHolders {
91         require(myTokens() > 0);
92         _;
93     }
94 
95     modifier onlyDivis {
96         require(myDividends(true) > 0);
97         _;
98     }
99 
100     event onDistribute(
101         address indexed customerAddress,
102         uint256 price
103     );
104 
105     event onTokenPurchase(
106         address indexed customerAddress,
107         uint256 incomingHEX,
108         uint256 tokensMinted,
109         address indexed referredBy,
110         uint timestamp
111     );
112 
113     event onTokenSell(
114         address indexed customerAddress,
115         uint256 tokensBurned,
116         uint256 hexEarned,
117         uint timestamp
118     );
119 
120     event onReinvestment(
121         address indexed customerAddress,
122         uint256 hexReinvested,
123         uint256 tokensMinted
124     );
125 
126     event onWithdraw(
127         address indexed customerAddress,
128         uint256 hexWithdrawn
129     );
130 
131     event Transfer(
132         address indexed from,
133         address indexed to,
134         uint256 tokens
135     );
136 
137     string public name = "PYRAHEX";
138     string public symbol = "PYRA";
139     uint8 constant public decimals = 8;
140     uint256 internal entryFee_ = 10;
141     uint256 internal transferFee_ = 1;
142     uint256 internal exitFee_ = 10;
143     uint256 internal referralFee_ = 20; // 20% of the 10% buy or sell fees makes it 2%
144     uint256 internal maintenanceFee_ = 20; // 20% of the 10% buy or sell fees makes it 2%
145     address internal maintenanceAddress1;
146     address internal maintenanceAddress2;
147     uint256 constant internal magnitude = 2 ** 64;
148     mapping(address => uint256) internal tokenBalanceLedger_;
149     mapping(address => uint256) internal referralBalance_;
150     mapping(address => int256) internal payoutsTo_;
151     mapping(address => uint256) internal invested_;
152     uint256 internal tokenSupply_;
153     uint256 internal profitPerShare_;
154     uint256 public stakingRequirement = 110000e8;
155     uint256 public totalHolder = 0;
156     uint256 public totalDonation = 0;
157     TOKEN erc20;
158 
159     constructor() public {
160         maintenanceAddress1 = address(0x72bEe2Cf43f658F3EdF5f4E08bAB03b5F777FA0A);
161         maintenanceAddress2 = address(0x074F21a36217d7615d0202faA926aEFEBB5a9999);
162 
163         ambassadors_[0x72bEe2Cf43f658F3EdF5f4E08bAB03b5F777FA0A] = true; // Coder
164         ambassadors_[0x074F21a36217d7615d0202faA926aEFEBB5a9999] = true; // Lordshill
165         ambassadors_[0xAA7A7C2DECB180f68F11E975e6D92B5Dc06083A6] = true; // NumberOfThings
166         ambassadors_[0x5138240E96360ad64010C27eB0c685A8b2eDE4F2] = true; // Sniped
167         ambassadors_[0x53e1eB6a53d9354d43155f76861C5a2AC80ef361] = true; // DRE
168         ambassadors_[0xCdB84A89BB3D2ad99a39AfAd0068DC11B8280FbC] = true; // Pyraboy
169         ambassadors_[0x73018870D10173ae6F71Cac3047ED3b6d175F274] = true; // Cryptochron
170         ambassadors_[0xc1630A61bB995623210FDA8323B522574270a268] = true; // Pocket
171         ambassadors_[0xEfB79c12af54CF6F8633AfcFF8019A533d7D1C3A] = true; // Arti
172         ambassadors_[0xEc31176d4df0509115abC8065A8a3F8275aafF2b] = true; // Udaman
173         ambassadors_[0x875CDdfF875Ee34A262a9d6Cf3d80eE04Fb5129D] = true; // Kingoffomo
174         ambassadors_[0x843f2C19bc6df9E32B482E2F9ad6C078001088b1] = true; // Bitcoin 4 life
175         ambassadors_[0x1c743E84FfcAfF4E51E9f3Edf88fa3a6681658b4] = true; // Falconcrypto
176         ambassadors_[0x87cb806192eC699398511c7aB44b3595C051D13C] = true; // Xcrypto247
177 
178         erc20 = TOKEN(address(0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39));
179     }
180 
181     function updateMaintenanceAddress1(address maintenance) public {
182         require(maintenance != address(0) && msg.sender == maintenanceAddress1);
183         maintenanceAddress1 = maintenance;
184     }
185 
186     function updateMaintenanceAddress2(address maintenance) public {
187         require(maintenance != address(0) && msg.sender == maintenanceAddress2);
188         maintenanceAddress2 = maintenance;
189     }
190 
191     function checkAndTransferHEX(uint256 _amount) private {
192         require(erc20.transferFrom(msg.sender, address(this), _amount) == true, "transfer must succeed");
193     }
194 
195     function distribute(uint256 _amount) public returns (uint256) {
196         require(_amount > 0, "must be a positive value");
197         checkAndTransferHEX(_amount);
198         totalDonation += _amount;
199         profitPerShare_ = SafeMath.add(profitPerShare_, (_amount * magnitude) / tokenSupply_);
200         emit onDistribute(msg.sender, _amount);
201     }
202 
203     function buy(uint256 _amount, address _referredBy) public returns (uint256) {
204         checkAndTransferHEX(_amount);
205         return purchaseTokens(_referredBy, msg.sender, _amount);
206     }
207 
208     function buyFor(uint256 _amount, address _customerAddress, address _referredBy) public returns (uint256) {
209         checkAndTransferHEX(_amount);
210         return purchaseTokens(_referredBy, _customerAddress, _amount);
211     }
212 
213     function() payable public {
214         revert();
215     }
216 
217     function reinvest() onlyDivis public {
218         address _customerAddress = msg.sender;
219         uint256 _dividends = myDividends(false);
220         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
221         _dividends += referralBalance_[_customerAddress];
222         referralBalance_[_customerAddress] = 0;
223         uint256 _tokens = purchaseTokens(0x0, _customerAddress, _dividends);
224         emit onReinvestment(_customerAddress, _dividends, _tokens);
225     }
226 
227     function exit() external {
228         address _customerAddress = msg.sender;
229         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
230         if (_tokens > 0) sell(_tokens);
231         withdraw();
232     }
233 
234     function withdraw() onlyDivis public {
235         address _customerAddress = msg.sender;
236         uint256 _dividends = myDividends(false);
237         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
238         _dividends += referralBalance_[_customerAddress];
239         referralBalance_[_customerAddress] = 0;
240         erc20.transfer(_customerAddress, _dividends);
241         emit onWithdraw(_customerAddress, _dividends);
242     }
243 
244     function sell(uint256 _amountOfTokens) onlyTokenHolders public {
245         address _customerAddress = msg.sender;
246         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
247 
248         uint256 _dividends = SafeMath.div(SafeMath.mul(_amountOfTokens, exitFee_), 100);
249         uint256 _taxedHEX = SafeMath.sub(_amountOfTokens, _dividends);
250 
251         tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfTokens);
252         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
253 
254         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens + (_taxedHEX * magnitude));
255         payoutsTo_[_customerAddress] -= _updatedPayouts;
256 
257         if (tokenSupply_ > 0) {
258             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
259         }
260 
261         emit Transfer(_customerAddress, address(0), _amountOfTokens);
262         emit onTokenSell(_customerAddress, _amountOfTokens, _taxedHEX, now);
263     }
264 
265     function transfer(address _toAddress, uint256 _amountOfTokens) onlyTokenHolders external returns (bool){
266         address _customerAddress = msg.sender;
267         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
268 
269         if (myDividends(true) > 0) {
270             withdraw();
271         }
272 
273         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
274         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
275         uint256 _dividends = _tokenFee;
276 
277         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
278 
279         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
280         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
281 
282         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
283         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
284 
285         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
286 
287         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
288 
289         return true;
290     }
291 
292     function setName(string _name) onlyOwner public
293     {
294        name = _name;
295     }
296 
297     function setSymbol(string _symbol) onlyOwner public
298     {
299        symbol = _symbol;
300     }
301 
302     function totalHexBalance() public view returns (uint256) {
303         return erc20.balanceOf(address(this));
304     }
305 
306     function totalSupply() public view returns (uint256) {
307         return tokenSupply_;
308     }
309 
310     function myTokens() public view returns (uint256) {
311         address _customerAddress = msg.sender;
312         return balanceOf(_customerAddress);
313     }
314 
315     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
316         address _customerAddress = msg.sender;
317         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
318     }
319 
320     function balanceOf(address _customerAddress) public view returns (uint256) {
321         return tokenBalanceLedger_[_customerAddress];
322     }
323 
324     function dividendsOf(address _customerAddress) public view returns (uint256) {
325         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
326     }
327 
328     function sellPrice() public view returns (uint256) {
329         uint256 _hex = 1e8;
330         uint256 _dividends = SafeMath.div(SafeMath.mul(_hex, exitFee_), 100);
331         uint256 _taxedHEX = SafeMath.sub(_hex, _dividends);
332 
333         return _taxedHEX;
334     }
335 
336     function buyPrice() public view returns (uint256) {
337         uint256 _hex = 1e8;
338         uint256 _dividends = SafeMath.div(SafeMath.mul(_hex, entryFee_), 100);
339         uint256 _taxedHEX = SafeMath.add(_hex, _dividends);
340 
341         return _taxedHEX;
342     }
343 
344     function calculateTokensReceived(uint256 _hexToSpend) public view returns (uint256) {
345         uint256 _dividends = SafeMath.div(SafeMath.mul(_hexToSpend, entryFee_), 100);
346         uint256 _amountOfTokens = SafeMath.sub(_hexToSpend, _dividends);
347 
348         return _amountOfTokens;
349     }
350 
351     function calculateHexReceived(uint256 _tokensToSell) public view returns (uint256) {
352         require(_tokensToSell <= tokenSupply_);
353         uint256 _dividends = SafeMath.div(SafeMath.mul(_tokensToSell, exitFee_), 100);
354         uint256 _taxedHEX = SafeMath.sub(_tokensToSell, _dividends);
355 
356         return _taxedHEX;
357     }
358 
359     function getInvested() public view returns (uint256) {
360         return invested_[msg.sender];
361     }
362 
363     function purchaseTokens(address _referredBy, address _customerAddress, uint256 _incomingHEX) internal antiEarlyWhale(_incomingHEX, _customerAddress) returns (uint256) {
364         if (getInvested() == 0) {
365           totalHolder++;
366         }
367 
368         invested_[msg.sender] += _incomingHEX;
369 
370         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingHEX, entryFee_), 100);
371 
372         uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends, maintenanceFee_), 100);
373         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, referralFee_), 100);
374 
375         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.add(_referralBonus,_maintenance));
376         uint256 _amountOfTokens = SafeMath.sub(_incomingHEX, _undividedDividends);
377         uint256 _fee = _dividends * magnitude;
378 
379         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
380 
381         referralBalance_[maintenanceAddress1] = SafeMath.add(referralBalance_[maintenanceAddress1], (_maintenance/2));
382         referralBalance_[maintenanceAddress2] = SafeMath.add(referralBalance_[maintenanceAddress2], (_maintenance/2));
383 
384         if (_referredBy != address(0) && _referredBy != _customerAddress && tokenBalanceLedger_[_referredBy] >= stakingRequirement) {
385             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
386         } else {
387             _dividends = SafeMath.add(_dividends, _referralBonus);
388             _fee = _dividends * magnitude;
389         }
390 
391         if (tokenSupply_ > 0) {
392             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
393             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
394             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
395         } else {
396             tokenSupply_ = _amountOfTokens;
397         }
398 
399         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
400 
401         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
402         payoutsTo_[_customerAddress] += _updatedPayouts;
403 
404         emit Transfer(address(0), msg.sender, _amountOfTokens);
405         emit onTokenPurchase(_customerAddress, _incomingHEX, _amountOfTokens, _referredBy, now);
406 
407         return _amountOfTokens;
408     }
409 }