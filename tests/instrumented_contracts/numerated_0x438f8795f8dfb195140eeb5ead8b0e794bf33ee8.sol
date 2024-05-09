1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-07
3 */
4 
5 pragma solidity ^ 0.4.26;
6 
7 library SafeMath {
8 
9  function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
10   if (a == 0) {
11    return 0;
12   }
13   c = a * b;
14   assert(c / a == b);
15   return c;
16  }
17 
18  function div(uint256 a, uint256 b) internal pure returns(uint256) {
19   return a / b;
20  }
21 
22  function sub(uint256 a, uint256 b) internal pure returns(uint256) {
23   assert(b <= a);
24   return a - b;
25  }
26 
27  function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
28   c = a + b;
29   assert(c >= a);
30   return c;
31  }
32 
33 }
34 
35 contract TOKEN {
36  function totalSupply() external view returns(uint256);
37  function balanceOf(address account) external view returns(uint256);
38  function transfer(address recipient, uint256 amount) external returns(bool);
39  function allowance(address owner, address spender) external view returns(uint256);
40  function approve(address spender, uint256 amount) external returns(bool);
41  function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);
42 }
43 
44 contract Ownable {
45  address public owner;
46  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47  constructor() public {
48   owner = msg.sender;
49  }
50  modifier onlyOwner() {
51   require(msg.sender == owner);
52   _;
53  }
54  function transferOwnership(address newOwner) public onlyOwner {
55   require(newOwner != address(0));
56   emit OwnershipTransferred(owner, newOwner);
57   owner = newOwner;
58  }
59 }
60 
61 contract GoldRain is Ownable {
62 
63  mapping(address => bool) internal ambassadors_;
64  uint256 constant internal ambassadorMaxPurchase_ = 1000000e18;
65  mapping(address => uint256) internal ambassadorAccumulatedQuota_;
66  bool public onlyAmbassadors = true;
67  uint256 ACTIVATION_TIME = 1592982000;
68 
69  modifier antiEarlyWhale(uint256 _amountOfGDRN, address _customerAddress) {
70   if (now >= ACTIVATION_TIME) {
71    onlyAmbassadors = false;
72   }
73 
74   if (onlyAmbassadors) {
75    require((ambassadors_[_customerAddress] == true && (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfGDRN) <= ambassadorMaxPurchase_));
76    ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfGDRN);
77    _;
78   } else {
79    if (now < (ACTIVATION_TIME + 60 seconds)) {
80     require(tx.gasprice <= 0.1 szabo);
81    }
82 
83    onlyAmbassadors = false;
84    _;
85   }
86  }
87 
88  modifier onlyTokenHolders {
89   require(myTokens() > 0);
90   _;
91  }
92 
93  modifier onlyDivis {
94   require(myDividends(true) > 0);
95   _;
96  }
97 
98  event onDistribute(
99   address indexed customerAddress,
100   uint256 price
101  );
102 
103  event onTokenPurchase(
104   address indexed customerAddress,
105   uint256 incomingGDRN,
106   uint256 tokensMinted,
107   address indexed referredBy,
108   uint timestamp
109  );
110 
111  event onTokenSell(
112   address indexed customerAddress,
113   uint256 tokensBurned,
114   uint256 gdrnEarned,
115   uint timestamp
116  );
117 
118  event onReinvestment(
119   address indexed customerAddress,
120   uint256 gdrnReinvested,
121   uint256 tokensMinted
122  );
123 
124  event onWithdraw(
125   address indexed customerAddress,
126   uint256 gdrnWithdrawn
127  );
128 
129  event Transfer(
130   address indexed from,
131   address indexed to,
132   uint256 tokens
133  );
134 
135  string public name = "Gold Rain";
136  string public symbol = "GDRN";
137  uint8 constant public decimals = 18;
138  uint256 internal entryFee_ = 10; // 10%
139  uint256 internal transferFee_ = 1;
140  uint256 internal exitFee_ = 10; // 10%
141  uint256 internal referralFee_ = 20; // 2% of the 10% fee
142  uint256 constant internal magnitude = 2 ** 64;
143  mapping(address => uint256) internal tokenBalanceLedger_;
144  mapping(address => uint256) internal referralBalance_;
145  mapping(address => int256) internal payoutsTo_;
146  mapping(address => uint256) internal invested_;
147  uint256 internal tokenSupply_;
148  uint256 internal profitPerShare_;
149  uint256 public stakingRequirement = 1e18; // 1 RAIN
150  uint256 public totalHolder = 0;
151  uint256 public totalDonation = 0;
152  TOKEN erc20;
153 
154  constructor() public {
155   ambassadors_[0x4ea0d6576E606778Cc9dcC329d06Ec70c3906CC2] = true;
156   erc20 = TOKEN(address(0x61cDb66e56FAD942a7b5cE3F419FfE9375E31075));
157  }
158 
159  function checkAndTransferGDRN(uint256 _amount) private {
160   require(erc20.transferFrom(msg.sender, address(this), _amount) == true, "transfer must succeed");
161  }
162 
163  function distribute(uint256 _amount) public returns(uint256) {
164   require(_amount > 0, "must be a positive value");
165   checkAndTransferGDRN(_amount);
166   totalDonation += _amount;
167   profitPerShare_ = SafeMath.add(profitPerShare_, (_amount * magnitude) / tokenSupply_);
168   emit onDistribute(msg.sender, _amount);
169  }
170 
171  function buy(uint256 _amount, address _referredBy) public returns(uint256) {
172   checkAndTransferGDRN(_amount);
173   return purchaseTokens(_referredBy, msg.sender, _amount);
174  }
175 
176  function buyFor(uint256 _amount, address _customerAddress, address _referredBy) public returns(uint256) {
177   checkAndTransferGDRN(_amount);
178   return purchaseTokens(_referredBy, _customerAddress, _amount);
179  }
180 
181  function() payable public {
182   revert();
183  }
184 
185  function reinvest() onlyDivis public {
186   address _customerAddress = msg.sender;
187   uint256 _dividends = myDividends(false);
188   payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
189   _dividends += referralBalance_[_customerAddress];
190   referralBalance_[_customerAddress] = 0;
191   uint256 _tokens = purchaseTokens(0x0, _customerAddress, _dividends);
192   emit onReinvestment(_customerAddress, _dividends, _tokens);
193  }
194 
195  function exit() external {
196   address _customerAddress = msg.sender;
197   uint256 _tokens = tokenBalanceLedger_[_customerAddress];
198   if (_tokens > 0) sell(_tokens);
199   withdraw();
200  }
201 
202  function withdraw() onlyDivis public {
203   address _customerAddress = msg.sender;
204   uint256 _dividends = myDividends(false);
205   payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
206   _dividends += referralBalance_[_customerAddress];
207   referralBalance_[_customerAddress] = 0;
208   erc20.transfer(_customerAddress, _dividends);
209   emit onWithdraw(_customerAddress, _dividends);
210  }
211 
212  function sell(uint256 _amountOfTokens) onlyTokenHolders public {
213   address _customerAddress = msg.sender;
214   require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
215 
216   uint256 _dividends = SafeMath.div(SafeMath.mul(_amountOfTokens, exitFee_), 100);
217   uint256 _taxedGDRN = SafeMath.sub(_amountOfTokens, _dividends);
218 
219   tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfTokens);
220   tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
221 
222   int256 _updatedPayouts = (int256)(profitPerShare_ * _amountOfTokens + (_taxedGDRN * magnitude));
223   payoutsTo_[_customerAddress] -= _updatedPayouts;
224 
225   if (tokenSupply_ > 0) {
226    profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
227   }
228 
229   emit Transfer(_customerAddress, address(0), _amountOfTokens);
230   emit onTokenSell(_customerAddress, _amountOfTokens, _taxedGDRN, now);
231  }
232 
233  function transfer(address _toAddress, uint256 _amountOfTokens) onlyTokenHolders external returns(bool) {
234   address _customerAddress = msg.sender;
235   require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
236 
237   if (myDividends(true) > 0) {
238    withdraw();
239   }
240 
241   uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
242   uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
243   uint256 _dividends = _tokenFee;
244 
245   tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
246 
247   tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
248   tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
249 
250   payoutsTo_[_customerAddress] -= (int256)(profitPerShare_ * _amountOfTokens);
251   payoutsTo_[_toAddress] += (int256)(profitPerShare_ * _taxedTokens);
252 
253   profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
254 
255   emit Transfer(_customerAddress, _toAddress, _taxedTokens);
256 
257   return true;
258  }
259 
260  function setName(string _name) onlyOwner public {
261   name = _name;
262  }
263 
264  function setSymbol(string _symbol) onlyOwner public {
265   symbol = _symbol;
266  }
267 
268  function totalRainBalance() public view returns(uint256) {
269   return erc20.balanceOf(address(this));
270  }
271 
272  function totalSupply() public view returns(uint256) {
273   return tokenSupply_;
274  }
275 
276  function myTokens() public view returns(uint256) {
277   address _customerAddress = msg.sender;
278   return balanceOf(_customerAddress);
279  }
280 
281  function myDividends(bool _includeReferralBonus) public view returns(uint256) {
282   address _customerAddress = msg.sender;
283   return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
284  }
285 
286  function balanceOf(address _customerAddress) public view returns(uint256) {
287   return tokenBalanceLedger_[_customerAddress];
288  }
289 
290  function dividendsOf(address _customerAddress) public view returns(uint256) {
291   return (uint256)((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
292  }
293 
294  function sellPrice() public view returns(uint256) {
295   uint256 _gdrn = 1e18;
296   uint256 _dividends = SafeMath.div(SafeMath.mul(_gdrn, exitFee_), 100);
297   uint256 _taxedGDRN = SafeMath.sub(_gdrn, _dividends);
298 
299   return _taxedGDRN;
300  }
301 
302  function buyPrice() public view returns(uint256) {
303   uint256 _gdrn = 1e18;
304   uint256 _dividends = SafeMath.div(SafeMath.mul(_gdrn, entryFee_), 100);
305   uint256 _taxedGDRN = SafeMath.add(_gdrn, _dividends);
306 
307   return _taxedGDRN;
308  }
309 
310  function calculateTokensReceived(uint256 _rainToSpend) public view returns(uint256) {
311   uint256 _dividends = SafeMath.div(SafeMath.mul(_rainToSpend, entryFee_), 100);
312   uint256 _amountOfTokens = SafeMath.sub(_rainToSpend, _dividends);
313 
314   return _amountOfTokens;
315  }
316 
317  function calculateRainReceived(uint256 _tokensToSell) public view returns(uint256) {
318   require(_tokensToSell <= tokenSupply_);
319   uint256 _dividends = SafeMath.div(SafeMath.mul(_tokensToSell, exitFee_), 100);
320   uint256 _taxedGDRN = SafeMath.sub(_tokensToSell, _dividends);
321 
322   return _taxedGDRN;
323  }
324 
325  function getInvested() public view returns(uint256) {
326   return invested_[msg.sender];
327  }
328 
329  function purchaseTokens(address _referredBy, address _customerAddress, uint256 _incomingGDRN) internal antiEarlyWhale(_incomingGDRN, _customerAddress) returns(uint256) {
330   if (getInvested() == 0) {
331    totalHolder++;
332   }
333 
334   invested_[msg.sender] += _incomingGDRN;
335 
336   uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingGDRN, entryFee_), 100);
337 
338   uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, referralFee_), 100);
339 
340   uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
341   uint256 _amountOfTokens = SafeMath.sub(_incomingGDRN, _undividedDividends);
342   uint256 _fee = _dividends * magnitude;
343 
344   require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
345 
346   if (_referredBy != address(0) && _referredBy != _customerAddress && tokenBalanceLedger_[_referredBy] >= stakingRequirement) {
347    referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
348   } else {
349    _dividends = SafeMath.add(_dividends, _referralBonus);
350    _fee = _dividends * magnitude;
351   }
352 
353   if (tokenSupply_ > 0) {
354    tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
355    profitPerShare_ += (_dividends * magnitude / tokenSupply_);
356    _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
357   } else {
358    tokenSupply_ = _amountOfTokens;
359   }
360 
361   tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
362 
363   int256 _updatedPayouts = (int256)(profitPerShare_ * _amountOfTokens - _fee);
364   payoutsTo_[_customerAddress] += _updatedPayouts;
365 
366   emit Transfer(address(0), msg.sender, _amountOfTokens);
367   emit onTokenPurchase(_customerAddress, _incomingGDRN, _amountOfTokens, _referredBy, now);
368 
369   return _amountOfTokens;
370  }
371 
372  function multiData()
373  public
374  view
375  returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
376   return (
377 
378    // [0] Total RAIN in contract
379    totalRainBalance(),
380 
381    // [1] Total GDRN supply
382    totalSupply(),
383 
384    // [2] User GDRN balance
385    balanceOf(msg.sender),
386 
387    // [3] User RAIN balance
388    erc20.balanceOf(msg.sender),
389 
390    // [4] User divs
391    dividendsOf(msg.sender),
392 
393    // [5] Buy price
394    buyPrice(),
395 
396    // [6] Sell price
397    sellPrice()
398 
399   );
400  }
401 }