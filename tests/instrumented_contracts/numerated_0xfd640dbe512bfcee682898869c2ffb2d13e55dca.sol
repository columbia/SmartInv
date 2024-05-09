1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 }
28 
29 /**
30  * @title Pausable
31  * @dev Base contract which allows children to implement an emergency stop mechanism.
32  */
33 contract Pausable is Ownable {
34   event Pause();
35   event Unpause();
36 
37   bool public paused = true;
38 
39 
40   /**
41    * @dev Modifier to make a function callable only when the contract is not paused.
42    */
43   modifier whenNotPaused() {
44     require(!paused);
45     _;
46   }
47 
48   /**
49    * @dev Modifier to make a function callable only when the contract is paused.
50    */
51   modifier whenPaused() {
52     require(paused);
53     _;
54   }
55 
56   /**
57    * @dev called by the owner to pause, triggers stopped state
58    */
59   function pause() onlyOwner whenNotPaused public {
60     paused = true;
61     Pause();
62   }
63 
64   /**
65    * @dev called by the owner to unpause, returns to normal state
66    */
67   function unpause() onlyOwner whenPaused public {
68     paused = false;
69     Unpause();
70   }
71 }
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79     uint256 c = a * b;
80     assert(a == 0 || c / a == b);
81     return c;
82   }
83 
84   function div(uint256 a, uint256 b) internal pure returns (uint256) {
85     // assert(b > 0); // Solidity automatically throws when dividing by 0
86     uint256 c = a / b;
87     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88     return c;
89   }
90 
91   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92     assert(b <= a);
93     return a - b;
94   }
95   
96   function add(uint256 a, uint256 b) internal pure returns (uint256) {
97     uint256 c = a + b;
98     assert(c >= a);
99     return c;
100   }
101 }
102 
103 contract CryptoPhoenixes is Ownable, Pausable {
104   using SafeMath for uint256;
105 
106   address public subDev;
107   Phoenix[] private phoenixes;
108   uint256 public PHOENIX_POOL;
109   uint256 public EXPLOSION_DENOMINATOR = 1000; //Eg explosivePower = 30 -> 3%
110   bool public ALLOW_BETA = true;
111   uint BETA_CUTOFF;
112 
113   // devFunds
114   mapping (address => uint256) public devFunds;
115 
116   // dividends
117   mapping (address => uint256) public userFunds;
118 
119   // Events
120   event PhoenixPurchased(
121     uint256 _phoenixId,
122     address oldOwner,
123     address newOwner,
124     uint256 price,
125     uint256 nextPrice
126   );
127   
128   event PhoenixExploded(
129       uint256 phoenixId,
130       address owner,
131       uint256 payout,
132       uint256 price,
133       uint nextExplosionTime
134   );
135 
136   event WithdrewFunds(
137     address owner
138   );
139 
140   // Caps for price changes and cutoffs
141   uint256 constant private QUARTER_ETH_CAP  = 0.25 ether;
142   uint256 constant private ONE_ETH_CAP  = 1.0 ether;
143   uint256 public BASE_PRICE = 0.0025 ether;
144   uint256 public PRICE_CUTOFF = 1.0 ether;
145   uint256 public HIGHER_PRICE_RESET_PERCENTAGE = 20;
146   uint256 public LOWER_PRICE_RESET_PERCENTAGE = 10;
147 
148   // Struct to store Phoenix Data
149   struct Phoenix {
150     uint256 price;  // Current price of phoenix
151     uint256 dividendPayout; // The percent of the dividends pool rewarded
152     uint256 explosivePower; // Percentage that phoenix can claim from PHOENIX_POOL after explode() function is called
153     uint cooldown; // Time it takes for phoenix to recharge till next explosion
154     uint nextExplosionTime; // Time of next explosion
155     address previousOwner;  // Owner of the phoenix who triggered explosion in previous round
156     address currentOwner; // Owner of phoenix in current round
157   }
158 
159 // Check if game is in beta or not. Certain functions will be disabled after beta period ends.
160   modifier inBeta() {
161     require(ALLOW_BETA);
162     _;
163   }
164 
165 // Main function to set the beta period and sub developer
166   function CryptoPhoenixes(address _subDev) {
167     BETA_CUTOFF = now + 90 * 1 days; //Allow 3 months to tweak parameters
168     subDev = _subDev;
169   }
170   
171 // Function anyone can call to turn off beta, thus disabling some functions
172   function closeBeta() {
173     require(now >= BETA_CUTOFF);
174     ALLOW_BETA = false;
175   }
176 
177   function createPhoenix(uint256 _payoutPercentage, uint256 _explosivePower, uint _cooldown) onlyOwner public {
178     
179     var phoenix = Phoenix({
180     price: BASE_PRICE,
181     dividendPayout: _payoutPercentage,
182     explosivePower: _explosivePower,
183     cooldown: _cooldown,
184     nextExplosionTime: now,
185     previousOwner: address(0),
186     currentOwner: this
187     });
188 
189     phoenixes.push(phoenix);
190   }
191 
192   function createMultiplePhoenixes(uint256[] _payoutPercentages, uint256[] _explosivePowers, uint[] _cooldowns) onlyOwner public {
193     require(_payoutPercentages.length == _explosivePowers.length);
194     require(_explosivePowers.length == _cooldowns.length);
195     
196     for (uint256 i = 0; i < _payoutPercentages.length; i++) {
197       createPhoenix(_payoutPercentages[i],_explosivePowers[i],_cooldowns[i]);
198     }
199   }
200 
201   function getPhoenix(uint256 _phoenixId) public view returns (
202     uint256 price,
203     uint256 nextPrice,
204     uint256 dividendPayout,
205     uint256 effectivePayout,
206     uint256 explosivePower,
207     uint cooldown,
208     uint nextExplosionTime,
209     address previousOwner,
210     address currentOwner
211   ) {
212     var phoenix = phoenixes[_phoenixId];
213     price = phoenix.price;
214     nextPrice = getNextPrice(phoenix.price);
215     dividendPayout = phoenix.dividendPayout;
216     effectivePayout = phoenix.dividendPayout.mul(10000).div(getTotalPayout());
217     explosivePower = phoenix.explosivePower;
218     cooldown = phoenix.cooldown;
219     nextExplosionTime = phoenix.nextExplosionTime;
220     previousOwner = phoenix.previousOwner;
221     currentOwner = phoenix.currentOwner;
222   }
223 
224 /**
225   * @dev Determines next price of token
226   * @param _price uint256 ID of current price
227 */
228   function getNextPrice (uint256 _price) private pure returns (uint256 _nextPrice) {
229     if (_price < QUARTER_ETH_CAP) {
230       return _price.mul(140).div(100); //1.4x
231     } else if (_price < ONE_ETH_CAP) {
232       return _price.mul(130).div(100); //1.3x
233     } else {
234       return _price.mul(125).div(100); //1.25x
235     }
236   }
237 
238 /**
239   * @dev Set dividend payout of phoenix
240   * @param _phoenixId id of phoenix
241   * @param _payoutPercentage uint256 Desired payout percentage
242 */
243   function setDividendPayout (uint256 _phoenixId, uint256 _payoutPercentage) onlyOwner inBeta {
244     Phoenix phoenix = phoenixes[_phoenixId];
245     phoenix.dividendPayout = _payoutPercentage;
246   }
247 
248 /**
249   * @dev Set explosive power of phoenix
250   * @param _phoenixId id of phoenix
251   * @param _explosivePower uint256 Desired claimable percentage from PHOENIX_POOL
252 */
253   function setExplosivePower (uint256 _phoenixId, uint256 _explosivePower) onlyOwner inBeta {
254     Phoenix phoenix = phoenixes[_phoenixId];
255     phoenix.explosivePower = _explosivePower;
256   }
257 
258 /**
259   * @dev Set cooldown of phoenix
260   * @param _phoenixId id of phoenix
261   * @param _cooldown uint256 Desired cooldown time
262 */
263   function setCooldown (uint256 _phoenixId, uint256 _cooldown) onlyOwner inBeta {
264     Phoenix phoenix = phoenixes[_phoenixId];
265     phoenix.cooldown = _cooldown;
266   }
267 
268 /**
269   * @dev Set price cutoff when determining phoenix price after explosion. To adjust for ETH price fluctuations
270   * @param _price uint256 Price cutoff in wei
271 */
272   function setPriceCutoff (uint256 _price) onlyOwner {
273     PRICE_CUTOFF = _price;
274   }
275 
276 /**
277   * @dev Set price percentage for when price exceeds or equates to price cutoff to reset to
278   * @param _percentage uint256 Desired percentage
279 */
280   function setHigherPricePercentage (uint256 _percentage) onlyOwner inBeta {
281     require(_percentage > 0);
282     require(_percentage < 100);
283     HIGHER_PRICE_RESET_PERCENTAGE = _percentage;
284   }
285 
286 /**
287   * @dev Set price percentage for when price is lower than price cutoff to reset to
288   * @param _percentage uint256 Desired percentage
289 */
290   function setLowerPricePercentage (uint256 _percentage) onlyOwner inBeta {
291     require(_percentage > 0);
292     require(_percentage < 100);
293     LOWER_PRICE_RESET_PERCENTAGE = _percentage;
294   }
295 
296 /**
297   * @dev Set base price for phoenixes. To adjust for ETH price fluctuations
298   * @param _amount uint256 Desired amount in wei
299 */
300   function setBasePrice (uint256 _amount) onlyOwner {
301     require(_amount > 0);
302     BASE_PRICE = _amount;
303   }
304 
305 /**
306   * @dev Purchase show from previous owner
307   * @param _phoenixId uint256 of token
308 */
309   function purchasePhoenix(uint256 _phoenixId) whenNotPaused public payable {
310     Phoenix phoenix = phoenixes[_phoenixId];
311     //Get current price of phoenix
312     uint256 price = phoenix.price;
313 
314     // revert checks
315     require(price > 0);
316     require(msg.value >= price);
317     //prevent multiple subsequent purchases
318     require(outgoingOwner != msg.sender);
319 
320     //Get owners of phoenixes
321     address previousOwner = phoenix.previousOwner;
322     address outgoingOwner = phoenix.currentOwner;
323 
324     //Define Cut variables
325     uint256 devCut;  
326     uint256 dividendsCut; 
327     uint256 previousOwnerCut;
328     uint256 phoenixPoolCut;
329     uint256 phoenixPoolPurchaseExcessCut;
330     
331     //Calculate excess
332     uint256 purchaseExcess = msg.value.sub(price);
333 
334     //handle boundary case where we assign previousOwner to the user
335     if (previousOwner == address(0)) {
336         phoenix.previousOwner = msg.sender;
337     }
338     
339     //Calculate cuts
340     (devCut,dividendsCut,previousOwnerCut,phoenixPoolCut) = calculateCuts(price);
341 
342     // Amount payable to old owner minus the developer's and pools' cuts.
343     uint256 outgoingOwnerCut = price.sub(devCut);
344     outgoingOwnerCut = outgoingOwnerCut.sub(dividendsCut);
345     outgoingOwnerCut = outgoingOwnerCut.sub(previousOwnerCut);
346     outgoingOwnerCut = outgoingOwnerCut.sub(phoenixPoolCut);
347     
348     // Take 2% cut from leftovers of overbidding
349     phoenixPoolPurchaseExcessCut = purchaseExcess.mul(2).div(100);
350     purchaseExcess = purchaseExcess.sub(phoenixPoolPurchaseExcessCut);
351     phoenixPoolCut = phoenixPoolCut.add(phoenixPoolPurchaseExcessCut);
352 
353     // set new price
354     phoenix.price = getNextPrice(price);
355 
356     // set new owner
357     phoenix.currentOwner = msg.sender;
358 
359     //Actual transfer
360     devFunds[owner] = devFunds[owner].add(devCut.mul(7).div(10)); //70% of dev cut goes to owner
361     devFunds[subDev] = devFunds[subDev].add(devCut.mul(3).div(10)); //30% goes to other dev
362     distributeDividends(dividendsCut);
363     userFunds[previousOwner] = userFunds[previousOwner].add(previousOwnerCut);
364     PHOENIX_POOL = PHOENIX_POOL.add(phoenixPoolCut);
365 
366     //handle boundary case where we exclude currentOwner == address(this) when transferring funds
367     if (outgoingOwner != address(this)) {
368       sendFunds(outgoingOwner,outgoingOwnerCut);
369     }
370 
371     // Send refund to owner if needed
372     if (purchaseExcess > 0) {
373       sendFunds(msg.sender,purchaseExcess);
374     }
375 
376     // raise event
377     PhoenixPurchased(_phoenixId, outgoingOwner, msg.sender, price, phoenix.price);
378   }
379 
380   function calculateCuts(uint256 _price) private pure returns (
381     uint256 devCut, 
382     uint256 dividendsCut,
383     uint256 previousOwnerCut,
384     uint256 phoenixPoolCut
385     ) {
386       // Calculate cuts
387       // 2% goes to developers
388       devCut = _price.mul(2).div(100);
389 
390       // 2.5% goes to dividends
391       dividendsCut = _price.mul(25).div(1000); 
392 
393       // 0.5% goes to owner of phoenix in previous exploded round
394       previousOwnerCut = _price.mul(5).div(1000);
395 
396       // 10-12% goes to phoenix pool
397       phoenixPoolCut = calculatePhoenixPoolCut(_price);
398     }
399 
400   function calculatePhoenixPoolCut (uint256 _price) private pure returns (uint256 _poolCut) {
401       if (_price < QUARTER_ETH_CAP) {
402           return _price.mul(12).div(100); //12%
403       } else if (_price < ONE_ETH_CAP) {
404           return _price.mul(11).div(100); //11%
405       } else {
406           return _price.mul(10).div(100); //10%
407       }
408   }
409 
410   function distributeDividends(uint256 _dividendsCut) private {
411     uint256 totalPayout = getTotalPayout();
412 
413     for (uint256 i = 0; i < phoenixes.length; i++) {
414       var phoenix = phoenixes[i];
415       var payout = _dividendsCut.mul(phoenix.dividendPayout).div(totalPayout);
416       userFunds[phoenix.currentOwner] = userFunds[phoenix.currentOwner].add(payout);
417     }
418   }
419 
420   function getTotalPayout() private view returns(uint256) {
421     uint256 totalPayout = 0;
422 
423     for (uint256 i = 0; i < phoenixes.length; i++) {
424       var phoenix = phoenixes[i];
425       totalPayout = totalPayout.add(phoenix.dividendPayout);
426     }
427 
428     return totalPayout;
429   }
430     
431 //Note that the previous and current owner will be the same person after this function is called
432   function explodePhoenix(uint256 _phoenixId) whenNotPaused public {
433       Phoenix phoenix = phoenixes[_phoenixId];
434       require(msg.sender == phoenix.currentOwner);
435       require(PHOENIX_POOL > 0);
436       require(now >= phoenix.nextExplosionTime);
437       
438       uint256 payout = phoenix.explosivePower.mul(PHOENIX_POOL).div(EXPLOSION_DENOMINATOR);
439 
440       //subtract from phoenix_POOL
441       PHOENIX_POOL = PHOENIX_POOL.sub(payout);
442       
443       //decrease phoenix price
444       if (phoenix.price >= PRICE_CUTOFF) {
445         phoenix.price = phoenix.price.mul(HIGHER_PRICE_RESET_PERCENTAGE).div(100);
446       } else {
447         phoenix.price = phoenix.price.mul(LOWER_PRICE_RESET_PERCENTAGE).div(100);
448         if (phoenix.price < BASE_PRICE) {
449           phoenix.price = BASE_PRICE;
450           }
451       }
452 
453       // set previous owner to be current owner, so he can get extra dividends next round
454       phoenix.previousOwner = msg.sender;
455       // reset cooldown
456       phoenix.nextExplosionTime = now + (phoenix.cooldown * 1 minutes);
457       
458       // Finally, payout to user
459       sendFunds(msg.sender,payout);
460       
461       //raise event
462       PhoenixExploded(_phoenixId, msg.sender, payout, phoenix.price, phoenix.nextExplosionTime);
463   }
464   
465 /**
466 * @dev Try to send funds immediately
467 * If it fails, user has to manually withdraw.
468 */
469   function sendFunds(address _user, uint256 _payout) private {
470     if (!_user.send(_payout)) {
471       userFunds[_user] = userFunds[_user].add(_payout);
472     }
473   }
474 
475 /**
476 * @dev Withdraw dev cut.
477 */
478   function devWithdraw() public {
479     uint256 funds = devFunds[msg.sender];
480     require(funds > 0);
481     devFunds[msg.sender] = 0;
482     msg.sender.transfer(funds);
483   }
484 
485 /**
486 * @dev Users can withdraw their accumulated dividends
487 */
488   function withdrawFunds() public {
489     uint256 funds = userFunds[msg.sender];
490     require(funds > 0);
491     userFunds[msg.sender] = 0;
492     msg.sender.transfer(funds);
493     WithdrewFunds(msg.sender);
494   }
495 }