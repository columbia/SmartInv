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
86   // Thursday, May 10, 2018 11:59:59 PM
87   uint256 public constant PRESALE_END_TIMESTAMP = 1525996799;
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
133   // Buy a car. The cars are unique within the order.
134   // If order count is 5 then one car can be preselected.
135   function purchaseCars(uint256 _carsToBuy, uint256 _pickedId, bool _upgradePackage) public payable whenNotPaused {
136     require(now < PRESALE_END_TIMESTAMP);
137     require(_carsToBuy > 0 && _carsToBuy <= MAX_ORDER);
138     require(carsCount + _carsToBuy <= MAX_CARS);
139 
140     uint256 priceToPay = calculatePrice(_carsToBuy, _upgradePackage);
141     require(msg.value >= priceToPay);
142 
143     // return excess ether
144     uint256 excess = msg.value.sub(priceToPay);
145     if (excess > 0) {
146       msg.sender.transfer(excess);
147     }
148 
149     // initialize an array for the new cars
150     uint256[] memory randomCars = new uint256[](_carsToBuy);
151     // shows from which point the randomCars array should be filled
152     uint256 startFrom = 0;
153 
154     // for MAX_ORDERs the first item is user picked
155     if (_carsToBuy == MAX_ORDER) {
156       require(_pickedId < CAR_MODELS);
157       require(_pickedId != UNICORN_ID);
158 
159       randomCars[0] = _pickedId;
160       startFrom = 1;
161     }
162     fillRandomCars(randomCars, startFrom);
163 
164     // add new cars to the owner's list
165     for (uint256 i = 0; i < randomCars.length; i++) {
166       ownerToCars[msg.sender].push(randomCars[i]);
167     }
168 
169     // increment upgrade packages
170     if (_upgradePackage) {
171       ownerToUpgradePackages[msg.sender] += _carsToBuy;
172     }
173 
174     CarsPurchased(msg.sender, randomCars, _upgradePackage, priceToPay);
175 
176     carsCount += _carsToBuy;
177     currentPrice += _carsToBuy * appreciationStep;
178 
179     // update this once per purchase
180     // to save the gas and to simplify the calculations
181     updateAppreciationStep();
182   }
183 
184   // MAX_CARS_TO_GIFT amout of cars are dedicated for gifts
185   function giftCar(address _receiver, uint256 _carId, bool _upgradePackage) public onlyCLevel {
186     // NOTE
187     // Some promo results will be calculated after the presale,
188     // so there is no need to check for the PRESALE_END_TIMESTAMP.
189 
190     require(_carId < CAR_MODELS);
191     require(_receiver != address(0));
192 
193     // check limits
194     require(carsCount < MAX_CARS);
195     require(carsGifted < MAX_CARS_TO_GIFT);
196     if (_carId == UNICORN_ID) {
197       require(unicornsGifted < MAX_UNICORNS_TO_GIFT);
198     }
199 
200     ownerToCars[_receiver].push(_carId);
201     if (_upgradePackage) {
202       ownerToUpgradePackages[_receiver] += 1;
203     }
204 
205     CarGifted(_receiver, _carId, _upgradePackage);
206 
207     carsCount += 1;
208     carsGifted += 1;
209     if (_carId == UNICORN_ID) {
210       unicornsGifted += 1;
211     }
212 
213     currentPrice += appreciationStep;
214     updateAppreciationStep();
215   }
216 
217   function calculatePrice(uint256 _carsToBuy, bool _upgradePackage) private view returns (uint256) {
218     // Arithmetic Sequence
219     // A(n) = A(0) + (n - 1) * D
220     uint256 lastPrice = currentPrice + (_carsToBuy - 1) * appreciationStep;
221 
222     // Sum of the First n Terms of an Arithmetic Sequence
223     // S(n) = n * (a(1) + a(n)) / 2
224     uint256 priceToPay = _carsToBuy * (currentPrice + lastPrice) / 2;
225 
226     // add an extra amount for the upgrade package
227     if (_upgradePackage) {
228       if (_carsToBuy < 3) {
229         priceToPay = priceToPay * 120 / 100; // 20% extra
230       } else if (_carsToBuy < 5) {
231         priceToPay = priceToPay * 115 / 100; // 15% extra
232       } else {
233         priceToPay = priceToPay * 110 / 100; // 10% extra
234       }
235     }
236 
237     return priceToPay;
238   }
239 
240   // Fill unique random cars into _randomCars starting from _startFrom
241   // as some slots may be already filled
242   function fillRandomCars(uint256[] _randomCars, uint256 _startFrom) private view {
243     // All random cars for the current purchase are generated from this 32 bytes.
244     // All purchases within a same block will get different car combinations
245     // as current price is changed at the end of the purchase.
246     //
247     // We don't need super secure random algorithm as it's just presale
248     // and if someone can time the block and grab the desired car we are just happy for him / her
249     bytes32 rand32 = keccak256(currentPrice, now);
250     uint256 randIndex = 0;
251     uint256 carId;
252 
253     for (uint256 i = _startFrom; i < _randomCars.length; i++) {
254       do {
255         // the max number for one purchase is limited to 5
256         // 32 tries are more than enough to generate 5 unique numbers
257         require(randIndex < 32);
258         carId = generateCarId(uint8(rand32[randIndex]));
259         randIndex++;
260       } while(alreadyContains(_randomCars, carId, i));
261       _randomCars[i] = carId;
262     }
263   }
264 
265   // Generate a car ID from the given serial number (0 - 255)
266   function generateCarId(uint256 _serialNumber) private view returns (uint256) {
267     for (uint256 i = 0; i < PROBABILITY_MAP.length; i++) {
268       if (_serialNumber < PROBABILITY_MAP[i]) {
269         return i;
270       }
271     }
272     // we should not reach to this point
273     assert(false);
274   }
275 
276   // Check if the given value is already in the list.
277   // By default all items are 0 so _to is used explicitly to validate 0 values.
278   function alreadyContains(uint256[] _list, uint256 _value, uint256 _to) private pure returns (bool) {
279     for (uint256 i = 0; i < _to; i++) {
280       if (_list[i] == _value) {
281         return true;
282       }
283     }
284     return false;
285   }
286 
287   function updateAppreciationStep() private {
288     // this method is called once per purcahse
289     // so use 'greater than' not to miss the limit
290     if (currentPrice > PRICE_LIMIT_1) {
291       // don't update if there is no change
292       if (appreciationStep != APPRECIATION_STEP_2) {
293         appreciationStep = APPRECIATION_STEP_2;
294       }
295     }
296   }
297 
298   function carCountOf(address _owner) public view returns (uint256 _carCount) {
299     return ownerToCars[_owner].length;
300   }
301 
302   function carOfByIndex(address _owner, uint256 _index) public view returns (uint256 _carId) {
303     return ownerToCars[_owner][_index];
304   }
305 
306   function carsOf(address _owner) public view returns (uint256[] _carIds) {
307     return ownerToCars[_owner];
308   }
309 
310   function upgradePackageCountOf(address _owner) public view returns (uint256 _upgradePackageCount) {
311     return ownerToUpgradePackages[_owner];
312   }
313 
314   function allOf(address _owner) public view returns (uint256[] _carIds, uint256 _upgradePackageCount) {
315     return (ownerToCars[_owner], ownerToUpgradePackages[_owner]);
316   }
317 
318   function getStats() public view returns (uint256 _carsCount, uint256 _carsGifted, uint256 _unicornsGifted, uint256 _currentPrice, uint256 _appreciationStep) {
319     return (carsCount, carsGifted, unicornsGifted, currentPrice, appreciationStep);
320   }
321 
322   function withdrawBalance(address _to, uint256 _amount) public onlyCEO {
323     if (_amount == 0) {
324       _amount = address(this).balance;
325     }
326 
327     if (_to == address(0)) {
328       ceoAddress.transfer(_amount);
329     } else {
330       _to.transfer(_amount);
331     }
332   }
333 
334 
335   // Raffle
336   // max count of raffle participants
337   uint256 public raffleLimit = 50;
338 
339   // list of raffle participants
340   address[] private raffleList;
341 
342   // Events
343   event Raffle2Registered(address indexed _iuser, address _user);
344   event Raffle3Registered(address _user);
345 
346   function isInRaffle(address _address) public view returns (bool) {
347     for (uint256 i = 0; i < raffleList.length; i++) {
348       if (raffleList[i] == _address) {
349         return true;
350       }
351     }
352     return false;
353   }
354 
355   function getRaffleStats() public view returns (address[], uint256) {
356     return (raffleList, raffleLimit);
357   }
358 
359   function drawRaffle(uint256 _carId) public onlyCLevel {
360     bytes32 rand32 = keccak256(now, raffleList.length);
361     uint256 winner = uint(rand32) % raffleList.length;
362 
363     giftCar(raffleList[winner], _carId, true);
364   }
365 
366   function resetRaffle() public onlyCLevel {
367     delete raffleList;
368   }
369 
370   function setRaffleLimit(uint256 _limit) public onlyCLevel {
371     raffleLimit = _limit;
372   }
373 
374   // Raffle v1
375   function registerForRaffle() public {
376     require(raffleList.length < raffleLimit);
377     require(!isInRaffle(msg.sender));
378     raffleList.push(msg.sender);
379   }
380 
381   // Raffle v2
382   function registerForRaffle2() public {
383     Raffle2Registered(msg.sender, msg.sender);
384   }
385 
386   // Raffle v3
387   function registerForRaffle3() public payable {
388     Raffle3Registered(msg.sender);
389   }
390 }
391 
392 
393 library SafeMath {
394 
395   /**
396   * @dev Multiplies two numbers, throws on overflow.
397   */
398   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
399     if (a == 0) {
400       return 0;
401     }
402     uint256 c = a * b;
403     assert(c / a == b);
404     return c;
405   }
406 
407   /**
408   * @dev Integer division of two numbers, truncating the quotient.
409   */
410   function div(uint256 a, uint256 b) internal pure returns (uint256) {
411     // assert(b > 0); // Solidity automatically throws when dividing by 0
412     uint256 c = a / b;
413     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
414     return c;
415   }
416 
417   /**
418   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
419   */
420   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
421     assert(b <= a);
422     return a - b;
423   }
424 
425   /**
426   * @dev Adds two numbers, throws on overflow.
427   */
428   function add(uint256 a, uint256 b) internal pure returns (uint256) {
429     uint256 c = a + b;
430     assert(c >= a);
431     return c;
432   }
433 }