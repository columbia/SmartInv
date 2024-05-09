1 /*
2     SPI CLUB
3     SPI Staking Contract
4     --------------------
5     10% buy fee
6     10% sell fee 
7     2% referral fee 
8     1% transfer fee 
9     
10     Launch time 12/18/2020 @ 12:00pm
11     SPI token 0x9B02dD390a603Add5c07f9fd9175b7DABE8D63B7
12 */
13 
14 pragma solidity ^ 0.4.26;
15 
16 library SafeMath {
17 
18  function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
19   if (a == 0) {
20    return 0;
21   }
22   c = a * b;
23   assert(c / a == b);
24   return c;
25  }
26 
27  function div(uint256 a, uint256 b) internal pure returns(uint256) {
28   return a / b;
29  }
30 
31  function sub(uint256 a, uint256 b) internal pure returns(uint256) {
32   assert(b <= a);
33   return a - b;
34  }
35 
36  function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
37   c = a + b;
38   assert(c >= a);
39   return c;
40  }
41 
42 }
43 
44 contract TOKEN {
45  function totalSupply() external view returns(uint256);
46  function balanceOf(address account) external view returns(uint256);
47  function transfer(address recipient, uint256 amount) external returns(bool);
48  function allowance(address owner, address spender) external view returns(uint256);
49  function approve(address spender, uint256 amount) external returns(bool);
50  function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);
51 }
52 
53 contract Ownable {
54  address public owner;
55  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56  constructor() public {
57   owner = msg.sender;
58  }
59  modifier onlyOwner() {
60   require(msg.sender == owner);
61   _;
62  }
63  function transferOwnership(address newOwner) public onlyOwner {
64   require(newOwner != address(0));
65   emit OwnershipTransferred(owner, newOwner);
66   owner = newOwner;
67  }
68 }
69 
70 contract SPIClub is Ownable {
71 
72  mapping(address => bool) internal ambassadors_;
73  uint256 constant internal ambassadorMaxPurchase_ = 10000e18; // 10k
74  mapping(address => uint256) internal ambassadorAccumulatedQuota_;
75  bool public onlyAmbassadors = true;
76  uint256 ACTIVATION_TIME = 1608292800; // 12/18/2020 @ 12:00pm (UTC)
77 
78  modifier antiEarlyWhale(uint256 _amountOfSTAT, address _customerAddress) {
79   if (now >= ACTIVATION_TIME) {
80    onlyAmbassadors = false;
81   }
82 
83   if (onlyAmbassadors) {
84    require((ambassadors_[_customerAddress] == true && (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfSTAT) <= ambassadorMaxPurchase_));
85    ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfSTAT);
86    _;
87   } else {
88    onlyAmbassadors = false;
89    _;
90   }
91  }
92 
93  modifier onlyTokenHolders {
94   require(myTokens() > 0);
95   _;
96  }
97 
98  modifier onlyDivis {
99   require(myDividends(true) > 0);
100   _;
101  }
102 
103  event onDistribute(
104   address indexed customerAddress,
105   uint256 price
106  );
107 
108  event onTokenPurchase(
109   address indexed customerAddress,
110   uint256 incomingSTAT,
111   uint256 tokensMinted,
112   address indexed referredBy,
113   uint timestamp
114  );
115 
116  event onTokenSell(
117   address indexed customerAddress,
118   uint256 tokensBurned,
119   uint256 statEarned,
120   uint timestamp
121  );
122 
123  event onReinvestment(
124   address indexed customerAddress,
125   uint256 statReinvested,
126   uint256 tokensMinted
127  );
128 
129  event onWithdraw(
130   address indexed customerAddress,
131   uint256 statWithdrawn
132  );
133 
134  event Transfer(
135   address indexed from,
136   address indexed to,
137   uint256 tokens
138  );
139 
140  string public name = "SPI Club";
141  string public symbol = "SPIC";
142  uint8 constant public decimals = 18;
143  uint256 internal entryFee_ = 10; // 10%
144  uint256 internal transferFee_ = 1;
145  uint256 internal exitFee_ = 10; // 10%
146  uint256 internal referralFee_ = 20; // 2% of the 10% fee 
147  uint256 constant internal magnitude = 2 ** 64;
148  mapping(address => uint256) internal tokenBalanceLedger_;
149  mapping(address => uint256) internal referralBalance_;
150  mapping(address => int256) internal payoutsTo_;
151  mapping(address => uint256) internal invested_;
152  uint256 internal tokenSupply_;
153  uint256 internal profitPerShare_;
154  uint256 public stakingRequirement;
155  uint256 public totalHolder = 0;
156  uint256 public totalDonation = 0;
157  TOKEN erc20;
158 
159  constructor() public {
160   erc20 = TOKEN(address(0x9B02dD390a603Add5c07f9fd9175b7DABE8D63B7));
161  }
162 
163  function checkAndTransferSTAT(uint256 _amount) private {
164   require(erc20.transferFrom(msg.sender, address(this), _amount) == true, "transfer must succeed");
165  }
166 
167  function distribute(uint256 _amount) public returns(uint256) {
168   require(_amount > 0, "must be a positive value");
169   checkAndTransferSTAT(_amount);
170   totalDonation += _amount;
171   profitPerShare_ = SafeMath.add(profitPerShare_, (_amount * magnitude) / tokenSupply_);
172   emit onDistribute(msg.sender, _amount);
173  }
174 
175  function buy(uint256 _amount, address _referredBy) public returns(uint256) {
176   checkAndTransferSTAT(_amount);
177   return purchaseTokens(_referredBy, msg.sender, _amount);
178  }
179 
180  function buyFor(uint256 _amount, address _customerAddress, address _referredBy) public returns(uint256) {
181   checkAndTransferSTAT(_amount);
182   return purchaseTokens(_referredBy, _customerAddress, _amount);
183  }
184 
185  function() payable public {
186   revert();
187  }
188 
189  function reinvest() onlyDivis public {
190   address _customerAddress = msg.sender;
191   uint256 _dividends = myDividends(false);
192   payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
193   _dividends += referralBalance_[_customerAddress];
194   referralBalance_[_customerAddress] = 0;
195   uint256 _tokens = purchaseTokens(0x0, _customerAddress, _dividends);
196   emit onReinvestment(_customerAddress, _dividends, _tokens);
197  }
198 
199  function exit() external {
200   address _customerAddress = msg.sender;
201   uint256 _tokens = tokenBalanceLedger_[_customerAddress];
202   if (_tokens > 0) sell(_tokens);
203   withdraw();
204  }
205 
206  function withdraw() onlyDivis public {
207   address _customerAddress = msg.sender;
208   uint256 _dividends = myDividends(false);
209   payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
210   _dividends += referralBalance_[_customerAddress];
211   referralBalance_[_customerAddress] = 0;
212   erc20.transfer(_customerAddress, _dividends);
213   emit onWithdraw(_customerAddress, _dividends);
214  }
215 
216  function sell(uint256 _amountOfTokens) onlyTokenHolders public {
217   address _customerAddress = msg.sender;
218   require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
219 
220   uint256 _dividends = SafeMath.div(SafeMath.mul(_amountOfTokens, exitFee_), 100);
221   uint256 _taxedSTAT = SafeMath.sub(_amountOfTokens, _dividends);
222 
223   tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfTokens);
224   tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
225 
226   int256 _updatedPayouts = (int256)(profitPerShare_ * _amountOfTokens + (_taxedSTAT * magnitude));
227   payoutsTo_[_customerAddress] -= _updatedPayouts;
228 
229   if (tokenSupply_ > 0) {
230    profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
231   }
232 
233   emit Transfer(_customerAddress, address(0), _amountOfTokens);
234   emit onTokenSell(_customerAddress, _amountOfTokens, _taxedSTAT, now);
235  }
236 
237  function transfer(address _toAddress, uint256 _amountOfTokens) onlyTokenHolders external returns(bool) {
238   address _customerAddress = msg.sender;
239   require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
240 
241   if (myDividends(true) > 0) {
242    withdraw();
243   }
244 
245   uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
246   uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
247   uint256 _dividends = _tokenFee;
248 
249   tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
250 
251   tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
252   tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
253 
254   payoutsTo_[_customerAddress] -= (int256)(profitPerShare_ * _amountOfTokens);
255   payoutsTo_[_toAddress] += (int256)(profitPerShare_ * _taxedTokens);
256 
257   profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
258 
259   emit Transfer(_customerAddress, _toAddress, _taxedTokens);
260 
261   return true;
262  }
263 
264  function setName(string _name) onlyOwner public {
265   name = _name;
266  }
267 
268  function setSymbol(string _symbol) onlyOwner public {
269   symbol = _symbol;
270  }
271 
272  function totalPowerBalance() public view returns(uint256) {
273   return erc20.balanceOf(address(this));
274  }
275 
276  function totalSupply() public view returns(uint256) {
277   return tokenSupply_;
278  }
279 
280  function myTokens() public view returns(uint256) {
281   address _customerAddress = msg.sender;
282   return balanceOf(_customerAddress);
283  }
284 
285  function myDividends(bool _includeReferralBonus) public view returns(uint256) {
286   address _customerAddress = msg.sender;
287   return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
288  }
289 
290  function balanceOf(address _customerAddress) public view returns(uint256) {
291   return tokenBalanceLedger_[_customerAddress];
292  }
293 
294  function dividendsOf(address _customerAddress) public view returns(uint256) {
295   return (uint256)((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
296  }
297 
298  function sellPrice() public view returns(uint256) {
299   uint256 _stat = 1e18;
300   uint256 _dividends = SafeMath.div(SafeMath.mul(_stat, exitFee_), 100);
301   uint256 _taxedSTAT = SafeMath.sub(_stat, _dividends);
302 
303   return _taxedSTAT;
304  }
305 
306  function buyPrice() public view returns(uint256) {
307   uint256 _stat = 1e18;
308   uint256 _dividends = SafeMath.div(SafeMath.mul(_stat, entryFee_), 100);
309   uint256 _taxedSTAT = SafeMath.add(_stat, _dividends);
310 
311   return _taxedSTAT;
312  }
313 
314  function calculateTokensReceived(uint256 _powerToSpend) public view returns(uint256) {
315   uint256 _dividends = SafeMath.div(SafeMath.mul(_powerToSpend, entryFee_), 100);
316   uint256 _amountOfTokens = SafeMath.sub(_powerToSpend, _dividends);
317 
318   return _amountOfTokens;
319  }
320 
321  function calculatePowerReceived(uint256 _tokensToSell) public view returns(uint256) {
322   require(_tokensToSell <= tokenSupply_);
323   uint256 _dividends = SafeMath.div(SafeMath.mul(_tokensToSell, exitFee_), 100);
324   uint256 _taxedSTAT = SafeMath.sub(_tokensToSell, _dividends);
325 
326   return _taxedSTAT;
327  }
328 
329  function getInvested() public view returns(uint256) {
330   return invested_[msg.sender];
331  }
332 
333  function purchaseTokens(address _referredBy, address _customerAddress, uint256 _incomingSTAT) internal antiEarlyWhale(_incomingSTAT, _customerAddress) returns(uint256) {
334   if (getInvested() == 0) {
335    totalHolder++;
336   }
337 
338   invested_[msg.sender] += _incomingSTAT;
339 
340   uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingSTAT, entryFee_), 100);
341 
342   uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, referralFee_), 100);
343 
344   uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
345   uint256 _amountOfTokens = SafeMath.sub(_incomingSTAT, _undividedDividends);
346   uint256 _fee = _dividends * magnitude;
347 
348   require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
349 
350   if (_referredBy != address(0) && _referredBy != _customerAddress && tokenBalanceLedger_[_referredBy] >= stakingRequirement) {
351    referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
352   } else {
353    _dividends = SafeMath.add(_dividends, _referralBonus);
354    _fee = _dividends * magnitude;
355   }
356 
357   if (tokenSupply_ > 0) {
358    tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
359    profitPerShare_ += (_dividends * magnitude / tokenSupply_);
360    _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
361   } else {
362    tokenSupply_ = _amountOfTokens;
363   }
364 
365   tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
366 
367   int256 _updatedPayouts = (int256)(profitPerShare_ * _amountOfTokens - _fee);
368   payoutsTo_[_customerAddress] += _updatedPayouts;
369 
370   emit Transfer(address(0), msg.sender, _amountOfTokens);
371   emit onTokenPurchase(_customerAddress, _incomingSTAT, _amountOfTokens, _referredBy, now);
372 
373   return _amountOfTokens;
374  }
375 
376  function multiData()
377  public
378  view
379  returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
380   return (
381    totalPowerBalance(),
382    totalSupply(),
383    balanceOf(msg.sender),
384    erc20.balanceOf(msg.sender),
385    dividendsOf(msg.sender),
386    buyPrice(),
387    sellPrice()
388 
389   );
390  }
391 }