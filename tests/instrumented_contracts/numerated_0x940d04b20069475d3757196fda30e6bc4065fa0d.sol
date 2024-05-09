1 pragma solidity ^0.4.24;
2 
3 contract Owned
4 {
5   address internal owner;
6   address private manager;
7   address internal sink;
8 
9   constructor() public
10   {
11     owner = msg.sender;
12     manager = msg.sender;
13     sink = msg.sender;
14   }
15 
16   modifier onlyOwner
17   {
18     require(msg.sender == owner, "Contract owner is required");
19     _;
20   }
21 
22   modifier onlyManager
23   {
24     require(msg.sender == manager, "Contract manager is required");
25     _;
26   }
27 
28   modifier onlyManagerNUser(address user)
29   {
30     require(msg.sender == manager || msg.sender == user, "Contract manager or wallet owner is required");
31     _;
32   }
33 
34   function transferOwnership(address newOwner, address newManager, address newSink) onlyOwner public
35   {
36     owner = newOwner;
37     manager = newManager;
38     sink = newSink;
39   }
40 }
41 
42 /*
43 interface tokenRecipient
44 {
45   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
46 }
47 */
48 
49 contract SupplyInfo
50 {
51   string public name;
52   string public symbol;
53   uint8 constant public decimals = 18;
54   uint256 constant internal denominator = 10 ** uint256(decimals);
55   uint256 public totalSupply;
56 
57   constructor(
58       uint256 initialSupply,
59       string tokenName,
60       string tokenSymbol
61   )
62     public
63   {
64     totalSupply = initialSupply * denominator;
65     name = tokenName;
66     symbol = tokenSymbol;
67   }
68 }
69 
70 contract Transferable
71 {
72   mapping (address => uint256) public balanceOf;
73   event Transfer(address indexed from, address indexed to, uint256 value);
74 
75   function _transferTokens(address _from, address _to, uint _value) internal
76   {
77     require(balanceOf[_from] >= _value, "Not enough funds");
78     require(balanceOf[_to] + _value >= balanceOf[_to], "BufferOverflow on receiver side");
79 
80     // uint previousBalances = balanceOf[_from] + balanceOf[_to];
81 
82     balanceOf[_from] -= _value;
83     balanceOf[_to] += _value;
84     emit Transfer(_from, _to, _value);
85 
86     // assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
87   }
88 
89   function transfer(address _to, uint256 _value) public returns (bool success)
90   {
91     _transferTokens(msg.sender, _to, _value);
92     return true;
93   }
94 
95 
96 }
97 
98 
99 contract ERC20 is SupplyInfo, Transferable
100 {
101   constructor(
102       uint256 initialSupply,
103       string tokenName,
104       string tokenSymbol
105   ) SupplyInfo(initialSupply, tokenName, tokenSymbol)
106     public
107   {
108     balanceOf[this] = totalSupply;
109   }
110 }
111 
112 contract Manageable is Transferable, Owned {
113   event Deposit(
114       address indexed _from,
115       // bytes32 indexed _id,
116       uint _value,
117       string comment
118   );
119 
120   event Withdraw(
121       address indexed _to,
122       uint _value,
123       string comment
124   );
125 
126   // function deposit(bytes32 _id) public payable {
127   function deposit(string comment) public payable {
128     emit Deposit(msg.sender, msg.value, comment);
129   }
130 
131   function withdraw(uint256 amount, string comment) onlyOwner public {
132     _transferEther(sink, amount);
133     emit Withdraw(sink, amount, comment);
134   }
135 
136   function _transferEther(address _to, uint _value) internal {
137     address contractAddress = this;
138     require(contractAddress.balance >= _value);
139     _to.transfer(_value);
140   }
141 }
142 
143 contract Tradeable is ERC20, Manageable {
144 
145 
146   event Buy(address indexed who, uint256 amount, uint256 buyPrice, string comment);
147   event Sell(address indexed who, uint256 amount, uint256 sellPrice, string comment);
148 
149   function _convertEtherToToken(uint256 etherAmount, uint256 buyPrice) pure internal returns (uint256) {
150     require(buyPrice > 0, "Buy price cant be zero");
151 
152     // BufferOverflow just in case
153     require(etherAmount * denominator > etherAmount, "BufferOverflow");
154     uint256 tokenAmount = etherAmount * denominator / buyPrice;
155 
156     return tokenAmount;
157   }
158 
159   function _convertTokenToEther(uint256 tokenAmount, uint256 sellPrice) pure internal returns (uint256) {
160     require(sellPrice > 0, "Sell price cant be zero");
161 
162     // BufferOverflow just in case
163     require(tokenAmount * sellPrice > tokenAmount, "BufferOverflow");
164     uint256 etherAmount = tokenAmount * sellPrice / denominator;
165     return etherAmount;
166   }
167 
168   function _buy(uint256 etherAmount, uint256 buyPrice, string comment) internal {
169     require(etherAmount > 0, "Ether amount cant be zero");
170     uint256 tokenAmount = _convertEtherToToken(etherAmount, buyPrice);
171 
172     // At this point transaction is accepted, just send tokens in return
173     _transferTokens(this, msg.sender, tokenAmount);
174     _transferEther(sink, etherAmount);
175     emit Buy(msg.sender, tokenAmount, buyPrice, comment);
176   }
177 
178   function _sell(uint256 tokenAmount, uint256 sellPrice, string comment) internal {
179     uint256 etherAmount = _convertTokenToEther(tokenAmount, sellPrice);
180     require(etherAmount > 0, "Ether amount after convert become zero - reverting"); // makes no sense otherwise
181 
182     _transferTokens(msg.sender, this, tokenAmount);
183     _transferEther(msg.sender, tokenAmount);
184     emit Sell(msg.sender, tokenAmount,sellPrice, comment);
185   }
186 }
187 
188 contract FrezeeableAccounts is Transferable, Owned {
189   mapping (address => bool) internal frozenAccount;
190   /* This generates a public event  on the blockchain that will notify clients */
191   event FrozenFunds(address indexed target, bool indexed frozen);
192 
193   modifier notFrozen(address target)
194   {
195     require(!frozenAccount[target], "Account is frozen");
196     _;
197   }
198 
199   function freezeAccount(address target, bool freeze) onlyManager public {
200     frozenAccount[target] = freeze;
201     emit FrozenFunds(target, freeze);
202   }
203 
204   function iamFrozen() view public returns(bool isFrozen)
205   {
206     return frozenAccount[msg.sender];
207   }
208 
209   function transfer(address _to, uint256 _value) public notFrozen(msg.sender) notFrozen(_to) returns (bool success)
210   {
211     return super.transfer(_to, _value);
212   }
213 }
214 
215 contract Destructable is Owned {
216   event Destruct(string indexed comment);
217 
218   function destruct(string comment) onlyOwner public {
219     selfdestruct(owner);
220     emit Destruct(comment);
221   }
222 }
223 
224 contract CoeficientTransform is SupplyInfo
225 {
226   function applyChange(uint256 currentCoeficient, uint256 value) pure internal returns(uint256)
227   {
228     return currentCoeficient * value / denominator;
229   }
230 
231   function deduceChange(uint256 currentCoeficient, uint256 value) pure internal returns(uint256)
232   {
233     require(value > 0, "Cant deduce zero change");
234     uint256 opposite = denominator * denominator / value;
235     return applyChange(currentCoeficient, opposite);
236   }
237 }
238 
239 contract DayCounter
240 {
241   uint private DayZero;
242   uint internal constant SecondsInDay = 60 * 60 * 24;
243 
244   constructor(uint ZeroDayTimestamp) public
245   {
246     DayZero = ZeroDayTimestamp;
247   }
248 
249   function daysSince(uint a, uint b) pure internal returns(uint)
250   {
251     return (b - a) / SecondsInDay;
252   }
253 
254   function DaysPast() view public returns(uint)
255   {
256     return daysSince(DayZero, now);
257   }
258 }
259 
260 contract InvestmentTransform is CoeficientTransform, DayCounter
261 {
262   uint constant private percentsPerDay = 3;
263 
264   function currentRoiInPersents() view public returns(uint)
265   {
266     uint currentPercents = percentsPerDay * DaysPast();
267     return 100 + currentPercents;
268   }
269 
270   function investmentRate(uint256 currentCoeficient) view internal returns(uint256)
271   {
272     uint256 dailyMultiply = denominator * currentRoiInPersents() / 100;
273     return applyChange(currentCoeficient, dailyMultiply);
274   }
275 }
276 
277 contract LinkedToFiatTransform is CoeficientTransform, Owned
278 {
279   uint256 public fiatDriftAncor;
280   uint256 public etherToFiatRate;
281 
282   event FiatLink(uint256 ancorDrift, uint exchangeRate);
283 
284   function setFiatLinkedCoef(uint256 newAncor, uint256 newRate) public onlyManager {
285     require(newAncor > 0 && newRate > 0, "Coeficients cant be zero");
286     fiatDriftAncor = newAncor;
287     etherToFiatRate = newRate;
288     emit FiatLink(newAncor, newRate);
289   }
290 
291   function fiatDrift(uint256 currentCoeficient) view internal returns(uint256)
292   {
293     return applyChange(currentCoeficient, fiatDriftAncor);
294   }
295 
296   function FiatToEther(uint256 amount) view internal returns(uint256)
297   {
298     return deduceChange(amount, etherToFiatRate);
299   }
300 
301   function EtherToFiat(uint256 amount) view internal returns(uint256)
302   {
303     return applyChange(amount, etherToFiatRate);
304   }
305 }
306 
307 contract StartStopSell is CoeficientTransform, Owned
308 {
309   bool internal buyAvailable = false;
310   bool internal sellAvailable = false;
311 
312   function updateBuySellFlags(bool allowBuy, bool allowSell) public onlyManager
313   {
314     buyAvailable = allowBuy;
315     sellAvailable = allowSell;
316   }
317 
318   modifier canBuy()
319   {
320     require(buyAvailable, "Buy currently disabled");
321     _;
322   }
323 
324   modifier canSell()
325   {
326     require(sellAvailable, "Sell currently disabled");
327     _;
328   }
329 }
330 
331 contract LISCTrade is FrezeeableAccounts, Tradeable, LinkedToFiatTransform, InvestmentTransform, StartStopSell
332 {
333   uint256 internal baseFiatPrice;
334   uint256 public minBuyAmount;
335 
336   constructor(uint256 basePrice) public
337   {
338     baseFiatPrice = basePrice;
339   }
340 
341   function setMinTrade(uint256 _minBuyAmount) onlyManager public
342   {
343     minBuyAmount = _minBuyAmount;
344   }
345 
346   function priceInUSD() view public returns(uint256)
347   {
348     uint256 price = baseFiatPrice;
349     price = fiatDrift(price);
350     price = investmentRate(price);
351     require(price > 0, "USD price cant be zero");
352     return price;
353   }
354 
355   function priceInETH() view public returns(uint256)
356   {
357     return FiatToEther(priceInUSD());
358   }
359 
360   function tokensPerETH() view public returns(uint256)
361   {
362     uint256 EthPerToken = priceInETH();
363     return deduceChange(denominator, EthPerToken);
364   }
365 
366   function buy(string comment) payable public canBuy notFrozen(msg.sender)
367   {
368     uint256 USDAmount = EtherToFiat(msg.value);
369     require(USDAmount > minBuyAmount, "You cant buy lesser than min USD amount");
370     _buy(msg.value, priceInETH(), comment);
371   }
372 
373   function sell(uint256 tokenAmount, string comment) public canSell notFrozen(msg.sender)
374   {
375     _sell(tokenAmount, priceInETH(), comment);
376   }
377 }
378 
379 
380 contract MintNBurn is ERC20
381 {
382   event Mint(address indexed target, uint256 mintedAmount, string comment);
383   event Burn(address indexed target, uint256 mintedAmount, string comment);
384 
385 
386   function mintToken(address target, uint256 mintedAmount, string comment) internal
387   {
388     balanceOf[this] += mintedAmount;
389     totalSupply += mintedAmount;
390 
391     _transferTokens(this, target, mintedAmount);
392     emit Mint(target, mintedAmount, comment);
393   }
394 
395   function burnToken(address target, uint256 amount, string comment) internal
396   {
397     _transferTokens(msg.sender, this, amount);
398     balanceOf[this] -= amount;
399     totalSupply -= amount;
400     emit Burn(target, amount, comment);
401   }
402 }
403 
404 contract Upgradeable is MintNBurn, Owned
405 {
406   address private prevVersion;
407   address private newVersion = 0x0;
408   mapping (address => bool) public upgraded;
409 
410   constructor(address upgradeFrom) internal {
411     prevVersion = upgradeFrom;
412   }
413 
414   function setUpgradeTo(address upgradeTo) public onlyOwner {
415     newVersion = upgradeTo;
416   }
417 
418   function upgradeAvalable() view public returns(bool) {
419     return newVersion != 0x0;
420   }
421 
422   function upgradeMe() public {
423     upgradeUser(msg.sender);
424   }
425 
426   function upgradeUser(address target) public onlyManagerNUser(target)
427   {
428     require(upgradeAvalable(), "New version not yet available");
429     Upgradeable newContract = Upgradeable(newVersion);
430     require(!newContract.upgraded(target), "Your account already been upgraded");
431     newContract.importUser(target);
432     burnToken(target, balanceOf[target], "Upgrading to new version");
433   }
434 
435   function importMe() public {
436     importUser(msg.sender);
437   }
438 
439   function importUser(address target) onlyManager public
440   {
441     require(!upgraded[target], "Account already been upgraded");
442     upgraded[target] = true;
443     Transferable oldContract = Transferable(prevVersion);
444     uint256 amount = oldContract.balanceOf(target);
445     mintToken(target, amount, "Upgrade from previous version");
446   }
447 }
448 
449 contract TOKEN is ERC20, Owned, Destructable, LISCTrade, Upgradeable  {
450 
451   event Init(uint256 basePrice, uint dayZero);
452 
453   constructor(
454       string tokenName,
455       string tokenSymbol,
456       uint basePrice,
457       uint dayZero
458   ) ERC20(0, tokenName, tokenSymbol) DayCounter(dayZero) LISCTrade(basePrice * denominator) Upgradeable(0x0) public
459   {
460     emit Init(basePrice, dayZero);
461   }
462 
463   event Mint(address indexed target, uint256 mintedAmount, string comment);
464 
465   function mint(address target, uint256 mintedAmount, string comment) onlyOwner public {
466     mintedAmount *= denominator;
467     mintToken(target, mintedAmount, comment);
468   }
469 
470   function burn(uint256 amount, string comment) private
471   {
472     burnToken(msg.sender, amount, comment);
473   }
474 
475   function balance() view public returns(uint256)
476   {
477     return balanceOf[msg.sender];
478   }
479 
480   event Broadcast(string message);
481 
482   function broadcast(string _message) public onlyManager
483   {
484     emit Broadcast(_message);
485   }
486 
487 
488 }