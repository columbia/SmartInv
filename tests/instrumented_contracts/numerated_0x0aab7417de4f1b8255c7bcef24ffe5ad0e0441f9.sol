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
28   function transferOwnership(address newOwner, address newManager, address newSink) onlyOwner public
29   {
30     owner = newOwner;
31     manager = newManager;
32     sink = newSink;
33   }
34 }
35 
36 /*
37 interface tokenRecipient
38 {
39   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
40 }
41 */
42 
43 contract SupplyInfo
44 {
45   string public name;
46   string public symbol;
47   uint8 constant public decimals = 18;
48   uint256 constant internal denominator = 10 ** uint256(decimals);
49   uint256 public totalSupply;
50 
51   constructor(
52       uint256 initialSupply,
53       string tokenName,
54       string tokenSymbol
55   )
56     public
57   {
58     totalSupply = initialSupply * denominator;
59     name = tokenName;
60     symbol = tokenSymbol;
61   }
62 }
63 
64 contract Transferable
65 {
66   mapping (address => uint256) public balanceOf;
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 
69   function _transferTokens(address _from, address _to, uint _value) internal
70   {
71     require(balanceOf[_from] >= _value, "Not enough funds");
72     require(balanceOf[_to] + _value > balanceOf[_to], "BufferOverflow on receiver side");
73 
74     // uint previousBalances = balanceOf[_from] + balanceOf[_to];
75 
76     balanceOf[_from] -= _value;
77     balanceOf[_to] += _value;
78     emit Transfer(_from, _to, _value);
79 
80     // assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
81   }
82 
83   function transfer(address _to, uint256 _value) public returns (bool success)
84   {
85     _transferTokens(msg.sender, _to, _value);
86     return true;
87   }
88 }
89 
90 
91 contract ERC20 is SupplyInfo, Transferable
92 {
93   constructor(
94       uint256 initialSupply,
95       string tokenName,
96       string tokenSymbol
97   ) SupplyInfo(initialSupply, tokenName, tokenSymbol)
98     public
99   {
100     balanceOf[this] = totalSupply;
101   }
102 }
103 
104 contract Manageable is Transferable, Owned {
105   event Deposit(
106       address indexed _from,
107       // bytes32 indexed _id,
108       uint _value,
109       string comment
110   );
111 
112   event Withdraw(
113       address indexed _to,
114       uint _value,
115       string comment
116   );
117 
118   // function deposit(bytes32 _id) public payable {
119   function deposit(string comment) public payable {
120     emit Deposit(msg.sender, msg.value, comment);
121   }
122 
123   function withdraw(uint256 amount, string comment) onlyOwner public {
124     _transferEther(sink, amount);
125     emit Withdraw(sink, amount, comment);
126   }
127 
128   function _transferEther(address _to, uint _value) internal {
129     address contractAddress = this;
130     require(contractAddress.balance >= _value);
131     _to.transfer(_value);
132   }
133 }
134 
135 contract Tradeable is ERC20, Manageable {
136 
137 
138   event Buy(address indexed who, uint256 amount, uint256 buyPrice, string comment);
139   event Sell(address indexed who, uint256 amount, uint256 sellPrice, string comment);
140 
141   function _convertEtherToToken(uint256 etherAmount, uint256 buyPrice) pure internal returns (uint256) {
142     require(buyPrice > 0, "Buy price cant be zero");
143 
144     // BufferOverflow just in case
145     require(etherAmount * denominator > etherAmount, "BufferOverflow");
146     uint256 tokenAmount = etherAmount * denominator / buyPrice;
147 
148     return tokenAmount;
149   }
150 
151   function _convertTokenToEther(uint256 tokenAmount, uint256 sellPrice) pure internal returns (uint256) {
152     require(sellPrice > 0, "Sell price cant be zero");
153 
154     // BufferOverflow just in case
155     require(tokenAmount * sellPrice > tokenAmount, "BufferOverflow");
156     uint256 etherAmount = tokenAmount * sellPrice / denominator;
157     return etherAmount;
158   }
159 
160   function _buy(uint256 etherAmount, uint256 buyPrice, string comment) internal {
161     require(etherAmount > 0, "Ether amount cant be zero");
162     uint256 tokenAmount = _convertEtherToToken(etherAmount, buyPrice);
163 
164     // At this point transaction is accepted, just send tokens in return
165     _transferTokens(this, msg.sender, tokenAmount);
166     _transferEther(sink, etherAmount);
167     emit Buy(msg.sender, tokenAmount, buyPrice, comment);
168   }
169 
170   function _sell(uint256 tokenAmount, uint256 sellPrice, string comment) internal {
171     uint256 etherAmount = _convertTokenToEther(tokenAmount, sellPrice);
172     require(etherAmount > 0, "Ether amount after convert become zero - reverting"); // makes no sense otherwise
173 
174     _transferTokens(msg.sender, this, tokenAmount);
175     _transferEther(msg.sender, tokenAmount);
176     emit Sell(msg.sender, tokenAmount,sellPrice, comment);
177   }
178 }
179 
180 contract FrezeeableAccounts is Transferable, Owned {
181   mapping (address => bool) internal frozenAccount;
182   /* This generates a public event  on the blockchain that will notify clients */
183   event FrozenFunds(address indexed target, bool indexed frozen);
184 
185   modifier notFrozen(address target)
186   {
187     require(!frozenAccount[target], "Account is frozen");
188     _;
189   }
190 
191   function freezeAccount(address target, bool freeze) onlyManager public {
192     frozenAccount[target] = freeze;
193     emit FrozenFunds(target, freeze);
194   }
195 
196   function iamFrozen() view public returns(bool isFrozen)
197   {
198     return frozenAccount[msg.sender];
199   }
200 
201   function transfer(address _to, uint256 _value) public notFrozen(msg.sender) notFrozen(_to) returns (bool success)
202   {
203     return super.transfer(_to, _value);
204   }
205 }
206 
207 contract Destructable is Owned {
208   event Destruct(string indexed comment);
209 
210   function destruct(string comment) onlyOwner public {
211     selfdestruct(owner);
212     emit Destruct(comment);
213   }
214 }
215 
216 contract CoeficientTransform is SupplyInfo
217 {
218   function applyChange(uint256 currentCoeficient, uint256 value) pure internal returns(uint256)
219   {
220     return currentCoeficient * value / denominator;
221   }
222 }
223 
224 contract DayCounter
225 {
226   uint private DayZero;
227   uint internal constant SecondsInDay = 60 * 60 * 24;
228 
229   constructor(uint ZeroDayTimestamp) public
230   {
231     DayZero = ZeroDayTimestamp;
232   }
233 
234   function daysSince(uint a, uint b) pure internal returns(uint)
235   {
236     return (b - a) / SecondsInDay;
237   }
238 
239   function DaysPast() view public returns(uint)
240   {
241     return daysSince(DayZero, now);
242   }
243 }
244 
245 contract InvestmentTransform is CoeficientTransform, DayCounter
246 {
247   uint constant private percentsPerDay = 3;
248 
249   function currentRoiInPersents() view public returns(uint)
250   {
251     uint currentPercents = percentsPerDay * DaysPast();
252     return 100 + currentPercents;
253   }
254 
255   function investmentRate(uint256 currentCoeficient) view internal returns(uint256)
256   {
257     uint256 dailyMultiply = denominator * currentRoiInPersents();
258     return applyChange(currentCoeficient, dailyMultiply);
259   }
260 }
261 
262 contract LinkedToFiatTransform is CoeficientTransform, Owned
263 {
264   uint256 public fiatDriftAncor;
265   uint256 public etherToFiatRate;
266 
267   event FiatLink(uint256 ancorDrift, uint exchangeRate);
268 
269   function setFiatLinkedCoef(uint256 newAncor, uint256 newRate) public onlyManager {
270     require(newAncor > 0 && newRate > 0, "Coeficients cant be zero");
271     fiatDriftAncor = newAncor;
272     etherToFiatRate = newRate;
273     emit FiatLink(newAncor, newRate);
274   }
275 
276   function fiatDrift(uint256 currentCoeficient) view internal returns(uint256)
277   {
278     return applyChange(currentCoeficient, fiatDriftAncor);
279   }
280 
281   function FiatToEther(uint256 amount) view internal returns(uint256)
282   {
283     uint256 fiatToEtherRate = denominator * denominator / etherToFiatRate;
284     return applyChange(amount, fiatToEtherRate);
285   }
286 
287   function EtherToFiat(uint256 amount) view internal returns(uint256)
288   {
289     return applyChange(amount, etherToFiatRate);
290   }
291 }
292 
293 contract StartStopSell is CoeficientTransform, Owned
294 {
295   bool internal buyAvailable = false;
296   bool internal sellAvailable = false;
297 
298   function updateBuySellFlags(bool allowBuy, bool allowSell) public onlyManager
299   {
300     buyAvailable = allowBuy;
301     sellAvailable = allowSell;
302   }
303 
304   modifier canBuy()
305   {
306     require(buyAvailable, "Buy currently disabled");
307     _;
308   }
309 
310   modifier canSell()
311   {
312     require(sellAvailable, "Sell currently disabled");
313     _;
314   }
315 }
316 
317 contract LISCTrade is FrezeeableAccounts, Tradeable, LinkedToFiatTransform, InvestmentTransform, StartStopSell
318 {
319   uint256 internal baseFiatPrice;
320   uint256 public minBuyAmount;
321 
322   constructor(uint256 basePrice) public
323   {
324     baseFiatPrice = basePrice;
325   }
326 
327   function priceInUSD() view public returns(uint256)
328   {
329     uint256 price = baseFiatPrice;
330     price = fiatDrift(price);
331     price = investmentRate(price);
332     require(price > 0, "USD price cant be zero");
333     return price;
334   }
335 
336   function priceInETH() view public returns(uint256)
337   {
338     return FiatToEther(priceInUSD());
339   }
340 
341   function tokensPerETH() view public returns(uint256)
342   {
343     uint256 EthPerToken = priceInETH();
344     return denominator * denominator / EthPerToken;
345   }
346 
347   function buy(string comment) payable public canBuy notFrozen(msg.sender)
348   {
349     uint256 USDAmount = EtherToFiat(msg.value);
350     require(USDAmount > minBuyAmount, "You cant buy lesser than min USD amount");
351     _buy(msg.value, tokensPerETH(), comment);
352   }
353 
354   function sell(uint256 tokenAmount, string comment) public canSell notFrozen(msg.sender)
355   {
356     _sell(tokenAmount, tokensPerETH(), comment);
357   }
358 }
359 
360 
361 contract TOKEN is ERC20, Owned, Destructable, LISCTrade  {
362 
363   event Init(uint256 basePrice, uint dayZero);
364 
365   constructor(
366       string tokenName,
367       string tokenSymbol,
368       uint basePrice,
369       uint dayZero
370   ) ERC20(0, tokenName, tokenSymbol) DayCounter(dayZero) LISCTrade(basePrice * denominator) public
371   {
372     emit Init(basePrice, dayZero);
373   }
374 
375   event Mint(address indexed target, uint256 mintedAmount, string comment);
376 
377   function mintToken(address target, uint256 mintedAmount, string comment) onlyOwner public {
378     mintedAmount *= denominator;
379     balanceOf[this] += mintedAmount;
380     totalSupply += mintedAmount;
381 
382     _transferTokens(this, target, mintedAmount);
383     emit Mint(target, mintedAmount, comment);
384   }
385 
386   function balance() view public returns(uint256)
387   {
388     return balanceOf[msg.sender];
389   }
390 
391   event Broadcast(string message);
392 
393   function broadcast(string _message) public onlyManager
394   {
395     emit Broadcast(_message);
396   }
397 
398 
399 }