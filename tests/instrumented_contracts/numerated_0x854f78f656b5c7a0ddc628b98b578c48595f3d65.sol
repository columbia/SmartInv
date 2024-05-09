1 pragma solidity ^0.4.18;
2 
3 contract AccessControl {
4   /// @dev The addresses of the accounts (or contracts) that can execute actions within each roles
5   address public ceoAddress;
6   address public cooAddress;
7 
8   /// @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
9   bool public paused = false;
10 
11   /// @dev The AccessControl constructor sets the original C roles of the contract to the sender account
12   function AccessControl() public {
13     ceoAddress = msg.sender;
14     cooAddress = msg.sender;
15   }
16 
17   /// @dev Access modifier for CEO-only functionality
18   modifier onlyCEO() {
19     require(msg.sender == ceoAddress);
20     _;
21   }
22 
23   /// @dev Access modifier for COO-only functionality
24   modifier onlyCOO() {
25     require(msg.sender == cooAddress);
26     _;
27   }
28 
29   /// @dev Access modifier for any CLevel functionality
30   modifier onlyCLevel() {
31     require(msg.sender == ceoAddress || msg.sender == cooAddress);
32     _;
33   }
34 
35   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO
36   /// @param _newCEO The address of the new CEO
37   function setCEO(address _newCEO) public onlyCEO {
38     require(_newCEO != address(0));
39     ceoAddress = _newCEO;
40   }
41 
42   /// @dev Assigns a new address to act as the COO. Only available to the current CEO
43   /// @param _newCOO The address of the new COO
44   function setCOO(address _newCOO) public onlyCEO {
45     require(_newCOO != address(0));
46     cooAddress = _newCOO;
47   }
48 
49   /// @dev Modifier to allow actions only when the contract IS NOT paused
50   modifier whenNotPaused() {
51     require(!paused);
52     _;
53   }
54 
55   /// @dev Modifier to allow actions only when the contract IS paused
56   modifier whenPaused {
57     require(paused);
58     _;
59   }
60 
61   /// @dev Pause the smart contract. Only can be called by the CEO
62   function pause() public onlyCEO whenNotPaused {
63      paused = true;
64   }
65 
66   /// @dev Unpauses the smart contract. Only can be called by the CEO
67   function unpause() public onlyCEO whenPaused {
68     paused = false;
69   }
70 }
71 
72 
73 contract RacingClubPresale is AccessControl {
74   using SafeMath for uint256;
75 
76   // Max number of cars (includes sales and gifts)
77   uint256 public constant MAX_CARS = 999;
78 
79   // Max number of cars to gift (includes unicorns)
80   uint256 public constant MAX_CARS_TO_GIFT = 99;
81 
82   // Max number of unicorn cars to gift
83   uint256 public constant MAX_UNICORNS_TO_GIFT = 9;
84 
85   // End date for the presale. No purchases can be made after this date.
86   // Monday, November 19, 2018 11:59:59 PM
87   uint256 public constant PRESALE_END_TIMESTAMP = 1542671999;
88 
89   // Price limits to decrease the appreciation rate
90   uint256 private constant PRICE_LIMIT_1 = 0.1 ether;
91 
92   // Appreciation steps for each price limit
93   uint256 private constant APPRECIATION_STEP_1 = 0.0005 ether;
94   uint256 private constant APPRECIATION_STEP_2 = 0.0001 ether;
95 
96   // Max count which can be bought with one transaction
97   uint256 private constant MAX_ORDER = 5;
98 
99   // 0 - 9 valid Id's for cars
100   uint256 private constant CAR_MODELS = 10;
101 
102   // The special car (the most rarest one) which can't be picked even with MAX_ORDER
103   uint256 public constant UNICORN_ID = 0;
104 
105   // Maps any number from 0 - 255 to 0 - 9 car Id
106   uint256[] private PROBABILITY_MAP = [4, 18, 32, 46, 81, 116, 151, 186, 221, 256];
107 
108   // Step by which the price should be changed
109   uint256 public appreciationStep = APPRECIATION_STEP_1;
110 
111   // Current price of the car. The price appreciation is happening with each new sale.
112   uint256 public currentPrice = 0.001 ether;
113 
114   // Overall cars count
115   uint256 public carsCount;
116 
117   // Overall gifted cars count
118   uint256 public carsGifted;
119 
120   // Gifted unicorn cars count
121   uint256 public unicornsGifted;
122 
123   // A mapping from addresses to the carIds
124   mapping (address => uint256[]) private ownerToCars;
125 
126   // A mapping from addresses to the upgrade packages
127   mapping (address => uint256) private ownerToUpgradePackages;
128 
129   // Events
130   event CarsPurchased(address indexed _owner, uint256[] _carIds, bool _upgradePackage, uint256 _pricePayed);
131   event CarGifted(address indexed _receiver, uint256 _carId, bool _upgradePackage);
132 
133   function RacingClubPresale() public {
134     // set previous contract values
135     carsCount = 98;
136     carsGifted = 6;
137     unicornsGifted = 2;
138     currentPrice = 0.05 ether;
139   }
140 
141   // Buy a car. The cars are unique within the order.
142   // If order count is 5 then one car can be preselected.
143   function purchaseCars(uint256 _carsToBuy, uint256 _pickedId, bool _upgradePackage) public payable whenNotPaused {
144     require(now < PRESALE_END_TIMESTAMP);
145     require(_carsToBuy > 0 && _carsToBuy <= MAX_ORDER);
146     require(carsCount + _carsToBuy <= MAX_CARS);
147 
148     uint256 priceToPay = calculatePrice(_carsToBuy, _upgradePackage);
149     require(msg.value >= priceToPay);
150 
151     // return excess ether
152     uint256 excess = msg.value.sub(priceToPay);
153     if (excess > 0) {
154       msg.sender.transfer(excess);
155     }
156 
157     // initialize an array for the new cars
158     uint256[] memory randomCars = new uint256[](_carsToBuy);
159     // shows from which point the randomCars array should be filled
160     uint256 startFrom = 0;
161 
162     // for MAX_ORDERs the first item is user picked
163     if (_carsToBuy == MAX_ORDER) {
164       require(_pickedId < CAR_MODELS);
165       require(_pickedId != UNICORN_ID);
166 
167       randomCars[0] = _pickedId;
168       startFrom = 1;
169     }
170     fillRandomCars(randomCars, startFrom);
171 
172     // add new cars to the owner's list
173     for (uint256 i = 0; i < randomCars.length; i++) {
174       ownerToCars[msg.sender].push(randomCars[i]);
175     }
176 
177     // increment upgrade packages
178     if (_upgradePackage) {
179       ownerToUpgradePackages[msg.sender] += _carsToBuy;
180     }
181 
182     CarsPurchased(msg.sender, randomCars, _upgradePackage, priceToPay);
183 
184     carsCount += _carsToBuy;
185     currentPrice += _carsToBuy * appreciationStep;
186 
187     // update this once per purchase
188     // to save the gas and to simplify the calculations
189     updateAppreciationStep();
190   }
191 
192   // MAX_CARS_TO_GIFT amout of cars are dedicated for gifts
193   function giftCar(address _receiver, uint256 _carId, bool _upgradePackage) public onlyCLevel {
194     // NOTE
195     // Some promo results will be calculated after the presale,
196     // so there is no need to check for the PRESALE_END_TIMESTAMP.
197 
198     require(_carId < CAR_MODELS);
199     require(_receiver != address(0));
200 
201     // check limits
202     require(carsCount < MAX_CARS);
203     require(carsGifted < MAX_CARS_TO_GIFT);
204     if (_carId == UNICORN_ID) {
205       require(unicornsGifted < MAX_UNICORNS_TO_GIFT);
206     }
207 
208     ownerToCars[_receiver].push(_carId);
209     if (_upgradePackage) {
210       ownerToUpgradePackages[_receiver] += 1;
211     }
212 
213     CarGifted(_receiver, _carId, _upgradePackage);
214 
215     carsCount += 1;
216     carsGifted += 1;
217     if (_carId == UNICORN_ID) {
218       unicornsGifted += 1;
219     }
220 
221     currentPrice += appreciationStep;
222     updateAppreciationStep();
223   }
224 
225   function calculatePrice(uint256 _carsToBuy, bool _upgradePackage) private view returns (uint256) {
226     // Arithmetic Sequence
227     // A(n) = A(0) + (n - 1) * D
228     uint256 lastPrice = currentPrice + (_carsToBuy - 1) * appreciationStep;
229 
230     // Sum of the First n Terms of an Arithmetic Sequence
231     // S(n) = n * (a(1) + a(n)) / 2
232     uint256 priceToPay = _carsToBuy * (currentPrice + lastPrice) / 2;
233 
234     // add an extra amount for the upgrade package
235     if (_upgradePackage) {
236       if (_carsToBuy < 3) {
237         priceToPay = priceToPay * 120 / 100; // 20% extra
238       } else if (_carsToBuy < 5) {
239         priceToPay = priceToPay * 115 / 100; // 15% extra
240       } else {
241         priceToPay = priceToPay * 110 / 100; // 10% extra
242       }
243     }
244 
245     return priceToPay;
246   }
247 
248   // Fill unique random cars into _randomCars starting from _startFrom
249   // as some slots may be already filled
250   function fillRandomCars(uint256[] _randomCars, uint256 _startFrom) private view {
251     // All random cars for the current purchase are generated from this 32 bytes.
252     // All purchases within a same block will get different car combinations
253     // as current price is changed at the end of the purchase.
254     //
255     // We don't need super secure random algorithm as it's just presale
256     // and if someone can time the block and grab the desired car we are just happy for him / her
257     bytes32 rand32 = keccak256(currentPrice, now);
258     uint256 randIndex = 0;
259     uint256 carId;
260 
261     for (uint256 i = _startFrom; i < _randomCars.length; i++) {
262       do {
263         // the max number for one purchase is limited to 5
264         // 32 tries are more than enough to generate 5 unique numbers
265         require(randIndex < 32);
266         carId = generateCarId(uint8(rand32[randIndex]));
267         randIndex++;
268       } while(alreadyContains(_randomCars, carId, i));
269       _randomCars[i] = carId;
270     }
271   }
272 
273   // Generate a car ID from the given serial number (0 - 255)
274   function generateCarId(uint256 _serialNumber) private view returns (uint256) {
275     for (uint256 i = 0; i < PROBABILITY_MAP.length; i++) {
276       if (_serialNumber < PROBABILITY_MAP[i]) {
277         return i;
278       }
279     }
280     // we should not reach to this point
281     assert(false);
282   }
283 
284   // Check if the given value is already in the list.
285   // By default all items are 0 so _to is used explicitly to validate 0 values.
286   function alreadyContains(uint256[] _list, uint256 _value, uint256 _to) private pure returns (bool) {
287     for (uint256 i = 0; i < _to; i++) {
288       if (_list[i] == _value) {
289         return true;
290       }
291     }
292     return false;
293   }
294 
295   function updateAppreciationStep() private {
296     // this method is called once per purcahse
297     // so use 'greater than' not to miss the limit
298     if (currentPrice > PRICE_LIMIT_1) {
299       // don't update if there is no change
300       if (appreciationStep != APPRECIATION_STEP_2) {
301         appreciationStep = APPRECIATION_STEP_2;
302       }
303     }
304   }
305 
306   function carCountOf(address _owner) public view returns (uint256 _carCount) {
307     return ownerToCars[_owner].length;
308   }
309 
310   function carOfByIndex(address _owner, uint256 _index) public view returns (uint256 _carId) {
311     return ownerToCars[_owner][_index];
312   }
313 
314   function carsOf(address _owner) public view returns (uint256[] _carIds) {
315     return ownerToCars[_owner];
316   }
317 
318   function upgradePackageCountOf(address _owner) public view returns (uint256 _upgradePackageCount) {
319     return ownerToUpgradePackages[_owner];
320   }
321 
322   function allOf(address _owner) public view returns (uint256[] _carIds, uint256 _upgradePackageCount) {
323     return (ownerToCars[_owner], ownerToUpgradePackages[_owner]);
324   }
325 
326   function getStats() public view returns (uint256 _carsCount, uint256 _carsGifted, uint256 _unicornsGifted, uint256 _currentPrice, uint256 _appreciationStep) {
327     return (carsCount, carsGifted, unicornsGifted, currentPrice, appreciationStep);
328   }
329 
330   function withdrawBalance(address _to, uint256 _amount) public onlyCEO {
331     if (_amount == 0) {
332       _amount = address(this).balance;
333     }
334 
335     if (_to == address(0)) {
336       ceoAddress.transfer(_amount);
337     } else {
338       _to.transfer(_amount);
339     }
340   }
341 
342 
343   // Raffle
344   // max count of raffle participants
345   uint256 public raffleLimit = 50;
346 
347   // list of raffle participants
348   address[] private raffleList;
349 
350   // Events
351   event Raffle2Registered(address indexed _iuser, address _user);
352   event Raffle3Registered(address _user);
353 
354   function isInRaffle(address _address) public view returns (bool) {
355     for (uint256 i = 0; i < raffleList.length; i++) {
356       if (raffleList[i] == _address) {
357         return true;
358       }
359     }
360     return false;
361   }
362 
363   function getRaffleStats() public view returns (address[], uint256) {
364     return (raffleList, raffleLimit);
365   }
366 
367   function drawRaffle(uint256 _carId) public onlyCLevel {
368     bytes32 rand32 = keccak256(now, raffleList.length);
369     uint256 winner = uint(rand32) % raffleList.length;
370 
371     giftCar(raffleList[winner], _carId, true);
372   }
373 
374   function resetRaffle() public onlyCLevel {
375     delete raffleList;
376   }
377 
378   function setRaffleLimit(uint256 _limit) public onlyCLevel {
379     raffleLimit = _limit;
380   }
381 
382   // Raffle v1
383   function registerForRaffle() public {
384     require(raffleList.length < raffleLimit);
385     require(!isInRaffle(msg.sender));
386     raffleList.push(msg.sender);
387   }
388 
389   // Raffle v2
390   function registerForRaffle2() public {
391     Raffle2Registered(msg.sender, msg.sender);
392   }
393 
394   // Raffle v3
395   function registerForRaffle3() public payable {
396     Raffle3Registered(msg.sender);
397   }
398 }
399 
400 
401 library SafeMath {
402 
403   /**
404   * @dev Multiplies two numbers, throws on overflow.
405   */
406   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
407     if (a == 0) {
408       return 0;
409     }
410     uint256 c = a * b;
411     assert(c / a == b);
412     return c;
413   }
414 
415   /**
416   * @dev Integer division of two numbers, truncating the quotient.
417   */
418   function div(uint256 a, uint256 b) internal pure returns (uint256) {
419     // assert(b > 0); // Solidity automatically throws when dividing by 0
420     uint256 c = a / b;
421     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
422     return c;
423   }
424 
425   /**
426   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
427   */
428   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
429     assert(b <= a);
430     return a - b;
431   }
432 
433   /**
434   * @dev Adds two numbers, throws on overflow.
435   */
436   function add(uint256 a, uint256 b) internal pure returns (uint256) {
437     uint256 c = a + b;
438     assert(c >= a);
439     return c;
440   }
441 }