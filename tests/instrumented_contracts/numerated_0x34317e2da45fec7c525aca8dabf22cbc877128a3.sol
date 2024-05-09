1 /*  VidyaFlux 
2     ---------
3     Launch date set to 12/20/2020 @ 10:00pm (UTC)
4     
5     5% entry fee
6     5% exit fee
7     1% transfer fee 
8     1% referral fee 
9     0.5% generator fee (maintenance)
10     
11     Maintenance fee is reserved for the Team3D Inventory contract: 
12     0x9680223F7069203E361f55fEFC89B7c1A952CDcc
13     
14     Anyone who calls feedInventory() function sends maintenance 
15     balance to Inventory and gets a 1% bonus in VIDYA for the effort 
16     
17     Call inventoryFund() to view the current accumulated inventory
18     balance. */
19 
20 pragma solidity ^0.5.17;
21 
22 library SafeMath {
23 
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     if (a == 0) {
26       return 0;
27     }
28     c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     return a / b;
35   }
36 
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 
48 }
49 
50 contract TOKEN {
51    function totalSupply() external view returns (uint256);
52    function balanceOf(address account) external view returns (uint256);
53    function transfer(address recipient, uint256 amount) external returns (bool);
54    function allowance(address owner, address spender) external view returns (uint256);
55    function approve(address spender, uint256 amount) external returns (bool);
56    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57 }
58 
59 contract VidyaFLUX {
60     
61     mapping(address => bool) internal ambassadors_;
62     uint256 constant internal ambassadorMaxPurchase_ = 500000e18; // 500k
63     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
64     bool public onlyAmbassadors = true;
65     uint256 ACTIVATION_TIME =  1608501600; // 12/20/2020 @ 10:00pm (UTC)
66 
67     modifier antiEarlyWhale(uint256 _amountOfVIDYA, address _customerAddress){
68       if (now >= ACTIVATION_TIME) {
69          onlyAmbassadors = false;
70       }
71 
72       if (onlyAmbassadors) {
73          require((ambassadors_[_customerAddress] == true && (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfVIDYA) <= ambassadorMaxPurchase_));
74          ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfVIDYA);
75          _;
76       } else {
77          onlyAmbassadors = false;
78          _;
79       }
80     }
81 
82     modifier onlyTokenHolders {
83         require(myTokens() > 0);
84         _;
85     }
86 
87     modifier onlyDivis {
88         require(myDividends(true) > 0);
89         _;
90     }
91 
92     event onDistribute(
93         address indexed customerAddress,
94         uint256 price
95     );
96 
97     event onTokenPurchase(
98         address indexed customerAddress,
99         uint256 incomingVIDYA,
100         uint256 tokensMinted,
101         address indexed referredBy,
102         uint timestamp
103     );
104 
105     event onTokenSell(
106         address indexed customerAddress,
107         uint256 tokensBurned,
108         uint256 VIDYAEarned,
109         uint timestamp
110     );
111 
112     event onReinvestment(
113         address indexed customerAddress,
114         uint256 VIDYAReinvested,
115         uint256 tokensMinted
116     );
117 
118     event onWithdraw(
119         address indexed customerAddress,
120         uint256 VIDYAWithdrawn
121     );
122 
123     event Transfer(
124         address indexed from,
125         address indexed to,
126         uint256 tokens
127     );
128 
129     string public name = "VidyaFLUX";
130     string public symbol = "FLUX";
131     uint8 constant public decimals = 18;
132     uint256 internal entryFee_ = 5;
133     uint256 internal transferFee_ = 1;
134     uint256 internal exitFee_ = 5;
135     uint256 internal referralFee_ = 20; // 20% of the 5% buy or sell fees makes it 1%
136     uint256 internal maintenanceFee_ = 10; // 10% of the 5% buy or sell fees makes it 0.5%
137     address internal maintenanceAddress;
138     uint256 constant internal magnitude = 2 ** 64;
139     mapping(address => uint256) internal tokenBalanceLedger_;
140     mapping(address => uint256) internal referralBalance_;
141     mapping(address => int256) internal payoutsTo_;
142     mapping(address => uint256) internal invested_;
143     mapping(address => uint256) public allTimeRefEarnings_;
144     mapping(address => uint256) public totalInvested_;
145     mapping(address => uint256) public totalWithdrawn_;
146     uint256 internal tokenSupply_;
147     uint256 internal profitPerShare_;
148     uint256 public stakingRequirement = 0;
149     uint256 public totalHolder = 0;
150     uint256 public totalDonation = 0;
151     TOKEN erc20;
152 
153     constructor() public {
154         maintenanceAddress = address(0x9680223F7069203E361f55fEFC89B7c1A952CDcc); // Inventory contract  
155         erc20 = TOKEN(address(0x3D3D35bb9bEC23b06Ca00fe472b50E7A4c692C30)); // VIDYA token
156     }
157 
158     function checkAndTransferVIDYA(uint256 _amount) private {
159         require(erc20.transferFrom(msg.sender, address(this), _amount) == true, "transfer must succeed");
160     }
161 
162     function buy(uint256 _amount, address _referredBy) public returns (uint256) {
163         checkAndTransferVIDYA(_amount);
164         return purchaseTokens(_referredBy, msg.sender, _amount);
165     }
166 
167     function() payable external {
168         revert();
169     }
170 
171     function reinvest() onlyDivis public {
172         address _customerAddress = msg.sender;
173         uint256 _dividends = myDividends(false);
174         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
175         _dividends += referralBalance_[_customerAddress];
176         referralBalance_[_customerAddress] = 0;
177         uint256 _tokens = purchaseTokens(address(0x0), _customerAddress, _dividends);
178         emit onReinvestment(_customerAddress, _dividends, _tokens);
179     }
180 
181     function exit() external {
182         address _customerAddress = msg.sender;
183         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
184         if (_tokens > 0) sell(_tokens, address(0x0));
185         withdraw();
186     }
187 
188     function withdraw() onlyDivis public {
189         address _customerAddress = msg.sender;
190         uint256 _dividends = myDividends(false);
191         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
192         _dividends += referralBalance_[_customerAddress];
193         referralBalance_[_customerAddress] = 0;
194         totalWithdrawn_[_customerAddress] = SafeMath.add(totalWithdrawn_[_customerAddress], _dividends);
195         erc20.transfer(_customerAddress, _dividends);
196         emit onWithdraw(_customerAddress, _dividends);
197     }
198 
199     function sell(uint256 _amountOfTokens,address _referredBy) onlyTokenHolders public {
200         address _customerAddress = msg.sender;
201         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
202 
203         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_amountOfTokens, exitFee_), 100);
204 
205         uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends, maintenanceFee_), 100);
206         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, referralFee_), 100);
207 
208         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.add(_referralBonus,_maintenance));
209 
210         uint256 _taxedVIDYA = SafeMath.sub(_amountOfTokens, _undividedDividends);
211 
212         uint256 _fee = _dividends * magnitude;
213 
214         referralBalance_[maintenanceAddress] = SafeMath.add(referralBalance_[maintenanceAddress], (_maintenance));
215 
216         tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfTokens);
217         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
218 
219         if (_referredBy != address(0) && _referredBy != _customerAddress && tokenBalanceLedger_[_referredBy] >= stakingRequirement) {
220             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
221         } else {
222             _dividends = SafeMath.add(_dividends, _referralBonus);
223             _fee = _dividends * magnitude;
224         }
225 
226         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens + (_taxedVIDYA * magnitude));
227         payoutsTo_[_customerAddress] -= _updatedPayouts;
228 
229         if (tokenSupply_ > 0) {
230             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
231         }
232 
233         emit Transfer(_customerAddress, address(0), _amountOfTokens);
234         emit onTokenSell(_customerAddress, _amountOfTokens, _taxedVIDYA, now);
235 
236     }
237 
238     function transfer(address _toAddress, uint256 _amountOfTokens) onlyTokenHolders external returns (bool){
239         address _customerAddress = msg.sender;
240         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
241 
242         if (myDividends(true) > 0) {
243             withdraw();
244         }
245 
246         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
247         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
248         uint256 _dividends = _tokenFee;
249 
250         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
251 
252         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
253         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
254 
255         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
256         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
257 
258         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
259 
260         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
261 
262         return true;
263     }
264 
265     function totalVIDYABalance() public view returns (uint256) {
266         return erc20.balanceOf(address(this));
267     }
268 
269     function totalSupply() public view returns (uint256) {
270         return tokenSupply_;
271     }
272 
273     function myTokens() public view returns (uint256) {
274         address _customerAddress = msg.sender;
275         return balanceOf(_customerAddress);
276     }
277 
278     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
279         address _customerAddress = msg.sender;
280         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
281     }
282     
283     function myReferrals() public view returns (uint256) {
284         address _customerAddress = msg.sender;
285         return referralBalance_[_customerAddress];
286     }
287 
288     function balanceOf(address _customerAddress) public view returns (uint256) {
289         return tokenBalanceLedger_[_customerAddress];
290     }
291 
292     function dividendsOf(address _customerAddress) public view returns (uint256) {
293         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
294     }
295 
296     function sellPrice() public view returns (uint256) {
297         uint256 _VIDYA = 1e18;
298         return SafeMath.div(_VIDYA * SafeMath.sub(100, exitFee_), 100);
299     }
300 
301     function buyPrice() public view returns (uint256) {
302         uint256 _VIDYA = 1e18;
303         return SafeMath.div(_VIDYA * 100, SafeMath.sub(100, entryFee_));
304     }
305 
306     function calculateTokensReceived(uint256 _VIDYAToSpend) public view returns (uint256) {
307         uint256 _dividends = SafeMath.div(SafeMath.mul(_VIDYAToSpend, entryFee_), 100);
308         uint256 _amountOfTokens = SafeMath.sub(_VIDYAToSpend, _dividends);
309 
310         return _amountOfTokens;
311     }
312 
313     function calculateVIDYAReceived(uint256 _tokensToSell) public view returns (uint256) {
314         require(_tokensToSell <= tokenSupply_);
315         uint256 _dividends = SafeMath.div(SafeMath.mul(_tokensToSell, exitFee_), 100);
316         uint256 _taxedVIDYA = SafeMath.sub(_tokensToSell, _dividends);
317 
318         return _taxedVIDYA;
319     }
320 
321     function getInvested() public view returns (uint256) {
322         return invested_[msg.sender];
323     }
324 
325     function purchaseTokens(address _referredBy, address _customerAddress, uint256 _incomingVIDYA) internal antiEarlyWhale(_incomingVIDYA, _customerAddress) returns (uint256) {
326         if (getInvested() == 0) {
327           totalHolder++;
328         }
329 
330         invested_[msg.sender] += _incomingVIDYA;
331 
332         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingVIDYA, entryFee_), 100);
333 
334         uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends, maintenanceFee_), 100);
335         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, referralFee_), 100);
336 
337         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.add(_referralBonus, _maintenance));
338         uint256 _amountOfTokens = SafeMath.sub(_incomingVIDYA, _undividedDividends);
339         uint256 _fee = _dividends * magnitude;
340 
341         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
342 
343         referralBalance_[maintenanceAddress] = SafeMath.add(referralBalance_[maintenanceAddress], (_maintenance));
344 
345         if (_referredBy != address(0) && _referredBy != _customerAddress && tokenBalanceLedger_[_referredBy] >= stakingRequirement) {
346             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
347             allTimeRefEarnings_[_referredBy] = SafeMath.add(allTimeRefEarnings_[_referredBy], _referralBonus);
348             totalInvested_[_customerAddress] = SafeMath.add(totalInvested_[_customerAddress], _incomingVIDYA);
349         } else {
350             _dividends = SafeMath.add(_dividends, _referralBonus);
351             _fee = _dividends * magnitude;
352         }
353 
354         if (tokenSupply_ > 0) {
355             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
356             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
357             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
358         } else {
359             tokenSupply_ = _amountOfTokens;
360         }
361 
362         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
363 
364         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
365         payoutsTo_[_customerAddress] += _updatedPayouts;
366 
367         emit Transfer(address(0), msg.sender, _amountOfTokens);
368         emit onTokenPurchase(_customerAddress, _incomingVIDYA, _amountOfTokens, _referredBy, now);
369 
370         return _amountOfTokens;
371     }
372     
373     /*  Withdraw maintenance balance to Inventory contract 
374         Caller (msg.sender) gets 1% of the amount as bonus */
375     function feedInventory() public returns(uint256, uint256) {
376         
377         // Maintenance balance 
378         uint256 amount = referralBalance_[maintenanceAddress];
379         
380         // 1% from amount (amount * 1 / 100)
381         uint256 bonus = SafeMath.div(SafeMath.mul(amount, 1), 100);
382 
383         // This amount goes to Inventory 
384         uint256 toInventory = SafeMath.sub(amount, bonus);
385         
386         // Set maintenance balance to 0
387         referralBalance_[maintenanceAddress] = 0;
388         
389         // Send to Inventory 
390         erc20.transfer(maintenanceAddress, toInventory);
391         
392         // Send to caller 
393         erc20.transfer(msg.sender, bonus);
394         
395         // Returns the amounts for UI or w/e 
396         return (toInventory, bonus);
397         
398     }
399     
400     function inventoryFund() public view returns(uint256) {
401         return referralBalance_[maintenanceAddress];
402     }
403 
404     function getOneTimeData() public view returns(uint256, uint256, uint256, string memory, string memory) {
405         return (entryFee_, exitFee_, decimals, name, symbol);
406     }
407 
408     function multiData() public view returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
409   return (
410         // [0] Total VIDYA in contract
411         totalVIDYABalance(),
412 
413         // [1] Total FLUX supply
414         totalSupply(),
415 
416         // [2] User FLUX balance
417         balanceOf(msg.sender),
418 
419         // [3] User VIDYA balance
420         erc20.balanceOf(msg.sender),
421 
422         // [4] User divs
423         dividendsOf(msg.sender),
424 
425         // [5] Buy price
426         buyPrice(),
427 
428         // [6] Sell price
429         sellPrice(),
430 
431         // [7] All time ref earnings
432         allTimeRefEarnings_[msg.sender],
433 
434         // [8] Ref earnings
435         referralBalance_[msg.sender],
436 
437         // [9] Total invested
438         totalInvested_[msg.sender],
439 
440         // [10] Total withdrawn
441         totalWithdrawn_[msg.sender]
442 
443         );
444     }
445 }