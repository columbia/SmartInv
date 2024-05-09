1 pragma solidity ^0.4.19;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     Unpause();
88   }
89 }
90 
91 // File: zeppelin-solidity/contracts/math/SafeMath.sol
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103     if (a == 0) {
104       return 0;
105     }
106     uint256 c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return c;
119   }
120 
121   /**
122   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256) {
133     uint256 c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 // File: zeppelin-solidity/contracts/ownership/HasNoEther.sol
140 
141 /**
142  * @title Contracts that should not own Ether
143  * @author Remco Bloemen <remco@2π.com>
144  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
145  * in the contract, it will allow the owner to reclaim this ether.
146  * @notice Ether can still be send to this contract by:
147  * calling functions labeled `payable`
148  * `selfdestruct(contract_address)`
149  * mining directly to the contract address
150 */
151 contract HasNoEther is Ownable {
152 
153   /**
154   * @dev Constructor that rejects incoming Ether
155   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
156   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
157   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
158   * we could use assembly to access msg.value.
159   */
160   function HasNoEther() public payable {
161     require(msg.value == 0);
162   }
163 
164   /**
165    * @dev Disallows direct send by settings a default function without the `payable` flag.
166    */
167   function() external {
168   }
169 
170   /**
171    * @dev Transfer all Ether held by the contract to the owner.
172    */
173   function reclaimEther() external onlyOwner {
174     assert(owner.send(this.balance));
175   }
176 }
177 
178 // File: contracts/AxiePresale.sol
179 
180 contract AxiePresale is HasNoEther, Pausable {
181   using SafeMath for uint256;
182 
183   // No Axies can be adopted after this end date: Friday, March 16, 2018 11:59:59 PM GMT.
184   uint256 constant public PRESALE_END_TIMESTAMP = 1521244799;
185 
186   uint8 constant public CLASS_BEAST = 0;
187   uint8 constant public CLASS_AQUATIC = 2;
188   uint8 constant public CLASS_PLANT = 4;
189 
190   uint256 constant public INITIAL_PRICE_INCREMENT = 1600 szabo; // 0.0016 Ether
191   uint256 constant public INITIAL_PRICE = INITIAL_PRICE_INCREMENT;
192   uint256 constant public REF_CREDITS_PER_AXIE = 5;
193 
194   mapping (uint8 => uint256) public currentPrices;
195   mapping (uint8 => uint256) public priceIncrements;
196 
197   mapping (uint8 => uint256) public totalAxiesAdopted;
198   mapping (address => mapping (uint8 => uint256)) public axiesAdopted;
199 
200   mapping (address => uint256) public referralCredits;
201   mapping (address => uint256) public axiesRewarded;
202   uint256 public totalAxiesRewarded;
203 
204   event AxiesAdopted(
205     address indexed adopter,
206     uint8 indexed clazz,
207     uint256 quantity,
208     address indexed referrer
209   );
210 
211   event AxiesRewarded(address indexed receiver, uint256 quantity);
212 
213   event AdoptedAxiesRedeemed(address indexed receiver, uint8 indexed clazz, uint256 quantity);
214   event RewardedAxiesRedeemed(address indexed receiver, uint256 quantity);
215 
216   function AxiePresale() public {
217     priceIncrements[CLASS_BEAST] = priceIncrements[CLASS_AQUATIC] = //
218       priceIncrements[CLASS_PLANT] = INITIAL_PRICE_INCREMENT;
219 
220     currentPrices[CLASS_BEAST] = currentPrices[CLASS_AQUATIC] = //
221       currentPrices[CLASS_PLANT] = INITIAL_PRICE;
222   }
223 
224   function axiesPrice(
225     uint256 beastQuantity,
226     uint256 aquaticQuantity,
227     uint256 plantQuantity
228   )
229     public
230     view
231     returns (uint256 totalPrice)
232   {
233     uint256 price;
234 
235     (price,,) = _axiesPrice(CLASS_BEAST, beastQuantity);
236     totalPrice = totalPrice.add(price);
237 
238     (price,,) = _axiesPrice(CLASS_AQUATIC, aquaticQuantity);
239     totalPrice = totalPrice.add(price);
240 
241     (price,,) = _axiesPrice(CLASS_PLANT, plantQuantity);
242     totalPrice = totalPrice.add(price);
243   }
244 
245   function adoptAxies(
246     uint256 beastQuantity,
247     uint256 aquaticQuantity,
248     uint256 plantQuantity,
249     address referrer
250   )
251     public
252     payable
253     whenNotPaused
254   {
255     require(now <= PRESALE_END_TIMESTAMP);
256 
257     require(beastQuantity <= 3);
258     require(aquaticQuantity <= 3);
259     require(plantQuantity <= 3);
260 
261     address adopter = msg.sender;
262     address actualReferrer = 0x0;
263 
264     // An adopter cannot be his/her own referrer.
265     if (referrer != adopter) {
266       actualReferrer = referrer;
267     }
268 
269     uint256 value = msg.value;
270     uint256 price;
271 
272     if (beastQuantity > 0) {
273       price = _adoptAxies(
274         adopter,
275         CLASS_BEAST,
276         beastQuantity,
277         actualReferrer
278       );
279 
280       require(value >= price);
281       value -= price;
282     }
283 
284     if (aquaticQuantity > 0) {
285       price = _adoptAxies(
286         adopter,
287         CLASS_AQUATIC,
288         aquaticQuantity,
289         actualReferrer
290       );
291 
292       require(value >= price);
293       value -= price;
294     }
295 
296     if (plantQuantity > 0) {
297       price = _adoptAxies(
298         adopter,
299         CLASS_PLANT,
300         plantQuantity,
301         actualReferrer
302       );
303 
304       require(value >= price);
305       value -= price;
306     }
307 
308     msg.sender.transfer(value);
309 
310     // The current referral is ignored if the referrer's address is 0x0.
311     if (actualReferrer != 0x0) {
312       uint256 numCredit = referralCredits[actualReferrer]
313         .add(beastQuantity)
314         .add(aquaticQuantity)
315         .add(plantQuantity);
316 
317       uint256 numReward = numCredit / REF_CREDITS_PER_AXIE;
318 
319       if (numReward > 0) {
320         referralCredits[actualReferrer] = numCredit % REF_CREDITS_PER_AXIE;
321         axiesRewarded[actualReferrer] = axiesRewarded[actualReferrer].add(numReward);
322         totalAxiesRewarded = totalAxiesRewarded.add(numReward);
323         AxiesRewarded(actualReferrer, numReward);
324       } else {
325         referralCredits[actualReferrer] = numCredit;
326       }
327     }
328   }
329 
330   function redeemAdoptedAxies(
331     address receiver,
332     uint256 beastQuantity,
333     uint256 aquaticQuantity,
334     uint256 plantQuantity
335   )
336     public
337     onlyOwner
338     returns (
339       uint256 /* remainingBeastQuantity */,
340       uint256 /* remainingAquaticQuantity */,
341       uint256 /* remainingPlantQuantity */
342     )
343   {
344     return (
345       _redeemAdoptedAxies(receiver, CLASS_BEAST, beastQuantity),
346       _redeemAdoptedAxies(receiver, CLASS_AQUATIC, aquaticQuantity),
347       _redeemAdoptedAxies(receiver, CLASS_PLANT, plantQuantity)
348     );
349   }
350 
351   function redeemRewardedAxies(
352     address receiver,
353     uint256 quantity
354   )
355     public
356     onlyOwner
357     returns (uint256 remainingQuantity)
358   {
359     remainingQuantity = axiesRewarded[receiver] = axiesRewarded[receiver].sub(quantity);
360 
361     if (quantity > 0) {
362       // This requires that rewarded Axies are always included in the total
363       // to make sure overflow won't happen.
364       totalAxiesRewarded -= quantity;
365 
366       RewardedAxiesRedeemed(receiver, quantity);
367     }
368   }
369 
370   /**
371    * @dev Calculate price of Axies from the same class.
372    * @param clazz The class of Axies.
373    * @param quantity Number of Axies to be calculated.
374    */
375   function _axiesPrice(
376     uint8 clazz,
377     uint256 quantity
378   )
379     private
380     view
381     returns (uint256 totalPrice, uint256 priceIncrement, uint256 currentPrice)
382   {
383     priceIncrement = priceIncrements[clazz];
384     currentPrice = currentPrices[clazz];
385 
386     uint256 nextPrice;
387 
388     for (uint256 i = 0; i < quantity; i++) {
389       totalPrice = totalPrice.add(currentPrice);
390       nextPrice = currentPrice.add(priceIncrement);
391 
392       if (nextPrice / 100 finney != currentPrice / 100 finney) {
393         priceIncrement >>= 1;
394       }
395 
396       currentPrice = nextPrice;
397     }
398   }
399 
400   /**
401    * @dev Adopt some Axies from the same class.
402    * @param adopter Address of the adopter.
403    * @param clazz The class of adopted Axies.
404    * @param quantity Number of Axies to be adopted, this should be positive.
405    * @param referrer Address of the referrer.
406    */
407   function _adoptAxies(
408     address adopter,
409     uint8 clazz,
410     uint256 quantity,
411     address referrer
412   )
413     private
414     returns (uint256 totalPrice)
415   {
416     (totalPrice, priceIncrements[clazz], currentPrices[clazz]) = _axiesPrice(clazz, quantity);
417 
418     axiesAdopted[adopter][clazz] = axiesAdopted[adopter][clazz].add(quantity);
419     totalAxiesAdopted[clazz] = totalAxiesAdopted[clazz].add(quantity);
420 
421     AxiesAdopted(
422       adopter,
423       clazz,
424       quantity,
425       referrer
426     );
427   }
428 
429   /**
430    * @dev Redeem adopted Axies from the same class.
431    * @param receiver Address of the receiver.
432    * @param clazz The class of adopted Axies.
433    * @param quantity Number of adopted Axies to be redeemed.
434    */
435   function _redeemAdoptedAxies(
436     address receiver,
437     uint8 clazz,
438     uint256 quantity
439   )
440     private
441     returns (uint256 remainingQuantity)
442   {
443     remainingQuantity = axiesAdopted[receiver][clazz] = axiesAdopted[receiver][clazz].sub(quantity);
444 
445     if (quantity > 0) {
446       // This requires that adopted Axies are always included in the total
447       // to make sure overflow won't happen.
448       totalAxiesAdopted[clazz] -= quantity;
449 
450       AdoptedAxiesRedeemed(receiver, clazz, quantity);
451     }
452   }
453 }