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
183   uint8 constant public CLASS_BEAST = 0;
184   uint8 constant public CLASS_AQUATIC = 2;
185   uint8 constant public CLASS_PLANT = 4;
186 
187   uint256 constant public INITIAL_PRICE_INCREMENT = 1600 szabo; // 0.0016 Ether
188   uint256 constant public INITIAL_PRICE = INITIAL_PRICE_INCREMENT;
189   uint256 constant public REF_CREDITS_PER_AXIE = 5;
190 
191   mapping (uint8 => uint256) public currentPrices;
192   mapping (uint8 => uint256) public priceIncrements;
193 
194   mapping (uint8 => uint256) public totalAxiesAdopted;
195   mapping (address => mapping (uint8 => uint256)) public axiesAdopted;
196 
197   mapping (address => uint256) public referralCredits;
198   mapping (address => uint256) public axiesRewarded;
199   uint256 public totalAxiesRewarded;
200 
201   event AxiesAdopted(
202     address indexed adopter,
203     uint8 indexed clazz,
204     uint256 quantity,
205     address indexed referrer
206   );
207 
208   event AxiesRewarded(address indexed receiver, uint256 quantity);
209 
210   event AdoptedAxiesRedeemed(address indexed receiver, uint8 indexed clazz, uint256 quantity);
211   event RewardedAxiesRedeemed(address indexed receiver, uint256 quantity);
212 
213   function AxiePresale() public {
214     priceIncrements[CLASS_BEAST] = priceIncrements[CLASS_AQUATIC] = //
215       priceIncrements[CLASS_PLANT] = INITIAL_PRICE_INCREMENT;
216 
217     currentPrices[CLASS_BEAST] = currentPrices[CLASS_AQUATIC] = //
218       currentPrices[CLASS_PLANT] = INITIAL_PRICE;
219   }
220 
221   function axiesPrice(
222     uint256 beastQuantity,
223     uint256 aquaticQuantity,
224     uint256 plantQuantity
225   )
226     public
227     view
228     returns (uint256 totalPrice)
229   {
230     uint256 price;
231 
232     (price,,) = _axiesPrice(CLASS_BEAST, beastQuantity);
233     totalPrice = totalPrice.add(price);
234 
235     (price,,) = _axiesPrice(CLASS_AQUATIC, aquaticQuantity);
236     totalPrice = totalPrice.add(price);
237 
238     (price,,) = _axiesPrice(CLASS_PLANT, plantQuantity);
239     totalPrice = totalPrice.add(price);
240   }
241 
242   function adoptAxies(
243     uint256 beastQuantity,
244     uint256 aquaticQuantity,
245     uint256 plantQuantity,
246     address referrer
247   )
248     public
249     payable
250     whenNotPaused
251   {
252     require(beastQuantity <= 3);
253     require(aquaticQuantity <= 3);
254     require(plantQuantity <= 3);
255 
256     address adopter = msg.sender;
257     address actualReferrer = 0x0;
258 
259     // An adopter cannot be his/her own referrer.
260     if (referrer != adopter) {
261       actualReferrer = referrer;
262     }
263 
264     uint256 value = msg.value;
265     uint256 price;
266 
267     if (beastQuantity > 0) {
268       price = _adoptAxies(
269         adopter,
270         CLASS_BEAST,
271         beastQuantity,
272         actualReferrer
273       );
274 
275       require(value >= price);
276       value -= price;
277     }
278 
279     if (aquaticQuantity > 0) {
280       price = _adoptAxies(
281         adopter,
282         CLASS_AQUATIC,
283         aquaticQuantity,
284         actualReferrer
285       );
286 
287       require(value >= price);
288       value -= price;
289     }
290 
291     if (plantQuantity > 0) {
292       price = _adoptAxies(
293         adopter,
294         CLASS_PLANT,
295         plantQuantity,
296         actualReferrer
297       );
298 
299       require(value >= price);
300       value -= price;
301     }
302 
303     msg.sender.transfer(value);
304 
305     // The current referral is ignored if the referrer's address is 0x0.
306     if (actualReferrer != 0x0) {
307       uint256 numCredit = referralCredits[actualReferrer]
308         .add(beastQuantity)
309         .add(aquaticQuantity)
310         .add(plantQuantity);
311 
312       uint256 numReward = numCredit / REF_CREDITS_PER_AXIE;
313 
314       if (numReward > 0) {
315         referralCredits[actualReferrer] = numCredit % REF_CREDITS_PER_AXIE;
316         axiesRewarded[actualReferrer] = axiesRewarded[actualReferrer].add(numReward);
317         totalAxiesRewarded = totalAxiesRewarded.add(numReward);
318         AxiesRewarded(actualReferrer, numReward);
319       } else {
320         referralCredits[actualReferrer] = numCredit;
321       }
322     }
323   }
324 
325   function redeemAdoptedAxies(
326     address receiver,
327     uint256 beastQuantity,
328     uint256 aquaticQuantity,
329     uint256 plantQuantity
330   )
331     public
332     onlyOwner
333     whenNotPaused
334     returns (
335       uint256 /* remainingBeastQuantity */,
336       uint256 /* remainingAquaticQuantity */,
337       uint256 /* remainingPlantQuantity */
338     )
339   {
340     return (
341       _redeemAdoptedAxies(receiver, CLASS_BEAST, beastQuantity),
342       _redeemAdoptedAxies(receiver, CLASS_AQUATIC, aquaticQuantity),
343       _redeemAdoptedAxies(receiver, CLASS_PLANT, plantQuantity)
344     );
345   }
346 
347   function redeemRewardedAxies(
348     address receiver,
349     uint256 quantity
350   )
351     public
352     onlyOwner
353     whenNotPaused
354     returns (uint256 remainingQuantity)
355   {
356     remainingQuantity = axiesRewarded[receiver] = axiesRewarded[receiver].sub(quantity);
357 
358     if (quantity > 0) {
359       // This requires that rewarded Axies are always included in the total
360       // to make sure overflow won't happen.
361       totalAxiesRewarded -= quantity;
362 
363       RewardedAxiesRedeemed(receiver, quantity);
364     }
365   }
366 
367   /**
368    * @dev Calculate price of Axies from the same class.
369    * @param clazz The class of Axies.
370    * @param quantity Number of Axies to be calculated.
371    */
372   function _axiesPrice(
373     uint8 clazz,
374     uint256 quantity
375   )
376     private
377     view
378     returns (uint256 totalPrice, uint256 priceIncrement, uint256 currentPrice)
379   {
380     priceIncrement = priceIncrements[clazz];
381     currentPrice = currentPrices[clazz];
382 
383     uint256 nextPrice;
384 
385     for (uint256 i = 0; i < quantity; i++) {
386       totalPrice = totalPrice.add(currentPrice);
387       nextPrice = currentPrice.add(priceIncrement);
388 
389       if (nextPrice / 100 finney != currentPrice / 100 finney) {
390         priceIncrement >>= 1;
391       }
392 
393       currentPrice = nextPrice;
394     }
395   }
396 
397   /**
398    * @dev Adopt some Axies from the same class.
399    * @param adopter Address of the adopter.
400    * @param clazz The class of adopted Axies.
401    * @param quantity Number of Axies to be adopted, this should be positive.
402    * @param referrer Address of the referrer.
403    */
404   function _adoptAxies(
405     address adopter,
406     uint8 clazz,
407     uint256 quantity,
408     address referrer
409   )
410     private
411     returns (uint256 totalPrice)
412   {
413     (totalPrice, priceIncrements[clazz], currentPrices[clazz]) = _axiesPrice(clazz, quantity);
414 
415     axiesAdopted[adopter][clazz] = axiesAdopted[adopter][clazz].add(quantity);
416     totalAxiesAdopted[clazz] = totalAxiesAdopted[clazz].add(quantity);
417 
418     AxiesAdopted(
419       adopter,
420       clazz,
421       quantity,
422       referrer
423     );
424   }
425 
426   /**
427    * @dev Redeem adopted Axies from the same class.
428    * @param receiver Address of the receiver.
429    * @param clazz The class of adopted Axies.
430    * @param quantity Number of adopted Axies to be redeemed.
431    */
432   function _redeemAdoptedAxies(
433     address receiver,
434     uint8 clazz,
435     uint256 quantity
436   )
437     private
438     returns (uint256 remainingQuantity)
439   {
440     remainingQuantity = axiesAdopted[receiver][clazz] = axiesAdopted[receiver][clazz].sub(quantity);
441 
442     if (quantity > 0) {
443       // This requires that adopted Axies are always included in the total
444       // to make sure overflow won't happen.
445       totalAxiesAdopted[clazz] -= quantity;
446 
447       AdoptedAxiesRedeemed(receiver, clazz, quantity);
448     }
449   }
450 }