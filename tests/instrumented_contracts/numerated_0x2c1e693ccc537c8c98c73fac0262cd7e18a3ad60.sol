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
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) public onlyOwner {
34     require(newOwner != address(0));
35     OwnershipTransferred(owner, newOwner);
36     owner = newOwner;
37   }
38 
39 }
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46 
47   /**
48   * @dev Multiplies two numbers, throws on overflow.
49   */
50   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51     if (a == 0) {
52       return 0;
53     }
54     uint256 c = a * b;
55     assert(c / a == b);
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers, truncating the quotient.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     // uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return a / b;
67   }
68 
69   /**
70   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
71   */
72   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73     assert(b <= a);
74     return a - b;
75   }
76 
77   /**
78   * @dev Adds two numbers, throws on overflow.
79   */
80   function add(uint256 a, uint256 b) internal pure returns (uint256) {
81     uint256 c = a + b;
82     assert(c >= a);
83     return c;
84   }
85 }
86 
87 /**
88  * @title RefundVault
89  * @dev This contract is used for storing funds while a crowdsale
90  * is in progress. Supports refunding the money if crowdsale fails,
91  * and forwarding it if crowdsale is successful.
92  */
93 contract RefundVault is Ownable {
94   using SafeMath for uint256;
95 
96   enum State { Active, Refunding, Closed }
97 
98   mapping (address => uint256) public deposited;
99   address public wallet;
100   State public state;
101 
102   event Closed();
103   event RefundsEnabled();
104   event Refunded(address indexed beneficiary, uint256 weiAmount);
105 
106   /**
107    * @param _wallet Vault address
108    */
109   function RefundVault(address _wallet) public {
110     require(_wallet != address(0));
111     wallet = _wallet;
112     state = State.Active;
113   }
114 
115   /**
116    * @param investor Investor address
117    */
118   function deposit(address investor) onlyOwner public payable {
119     require(state == State.Active);
120     deposited[investor] = deposited[investor].add(msg.value);
121   }
122 
123   function close() onlyOwner public {
124     require(state == State.Active);
125     state = State.Closed;
126     Closed();
127     wallet.transfer(address(this).balance);
128   }
129 
130   function enableRefunds() onlyOwner public {
131     require(state == State.Active);
132     state = State.Refunding;
133     RefundsEnabled();
134   }
135 
136   /**
137    * @param investor Investor address
138    */
139   function refund(address investor) public {
140     require(state == State.Refunding);
141     uint256 depositedValue = deposited[investor];
142     deposited[investor] = 0;
143     investor.transfer(depositedValue);
144     Refunded(investor, depositedValue);
145   }
146 }
147 
148 /**
149  * @title LandSale
150  * @dev Landsale contract is a timed, refundable crowdsale for land. It has
151  * a tiered increasing price element based on number of land sold per type.
152  * @notice We omit a fallback function to prevent accidental sends to this contract.
153  */
154 contract LandSale is Ownable {
155     using SafeMath for uint256;
156 
157     uint256 public openingTime;
158     uint256 public closingTime;
159 
160     uint256 constant public VILLAGE_START_PRICE = 1200000000000000; // 0.0012 ETH
161     uint256 constant public TOWN_START_PRICE = 5000000000000000; // 0.005 ETH
162     uint256 constant public CITY_START_PRICE = 20000000000000000; // 0.02 ETH
163 
164     uint256 constant public VILLAGE_INCREASE_RATE = 500000000000000; // 0.0005 ETH
165     uint256 constant public TOWN_INCREASE_RATE = 2500000000000000; // 0.0025 ETH
166     uint256 constant public CITY_INCREASE_RATE = 12500000000000000; // 0.0125 ETH
167 
168     // Address where funds are collected
169     address public wallet;
170 
171     // Amount of wei raised
172     uint256 public weiRaised;
173 
174     // minimum amount of funds to be raised in wei
175     uint256 public goal;
176 
177     // refund vault used to hold funds while crowdsale is running
178     RefundVault public vault;
179 
180     // Array of addresses who purchased land via their ethereum address
181     address[] public walletUsers;
182     uint256 public walletUserCount;
183 
184     // Array of users who purchased land via other method (ex. CC)
185     bytes32[] public ccUsers;
186     uint256 public ccUserCount;
187 
188     // Number of each landType sold
189     uint256 public villagesSold;
190     uint256 public townsSold;
191     uint256 public citiesSold;
192 
193 
194     // 0 - Plot
195     // 1 - Village
196     // 2 - Town
197     // 3 - City
198 
199     // user wallet address -> # of land
200     mapping (address => uint256) public addressToNumVillages;
201     mapping (address => uint256) public addressToNumTowns;
202     mapping (address => uint256) public addressToNumCities;
203 
204     // user id hash -> # of land
205     mapping (bytes32 => uint256) public userToNumVillages;
206     mapping (bytes32 => uint256) public userToNumTowns;
207     mapping (bytes32 => uint256) public userToNumCities;
208 
209     bool private paused = false;
210     bool public isFinalized = false;
211 
212     /**
213      * @dev Send events for every purchase. Also send an event when LandSale is complete
214      */
215     event LandPurchased(address indexed purchaser, uint256 value, uint8 landType, uint256 quantity);
216     event LandPurchasedCC(bytes32 indexed userId, address indexed purchaser, uint8 landType, uint256 quantity);
217     event Finalized();
218 
219     /**
220      * @dev Reverts if not in crowdsale time range.
221      */
222     modifier onlyWhileOpen {
223         require(block.timestamp >= openingTime && block.timestamp <= closingTime && !paused);
224         _;
225     }
226 
227     /**
228      * @dev Constructor. One-time set up of goal and opening/closing times of landsale
229      */
230     function LandSale(address _wallet, uint256 _goal,
231                         uint256 _openingTime, uint256 _closingTime) public {
232         require(_wallet != address(0));
233         require(_goal > 0);
234         require(_openingTime >= block.timestamp);
235         require(_closingTime >= _openingTime);
236 
237         wallet = _wallet;
238         vault = new RefundVault(wallet);
239         goal = _goal;
240         openingTime = _openingTime;
241         closingTime = _closingTime;
242     }
243 
244     /**
245      * @dev Add new ethereum wallet users to array
246      */
247     function addWalletAddress(address walletAddress) private {
248         if ((addressToNumVillages[walletAddress] == 0) &&
249             (addressToNumTowns[walletAddress] == 0) &&
250             (addressToNumCities[walletAddress] == 0)) {
251             // only add address to array during first land purchase
252             walletUsers.push(msg.sender);
253             walletUserCount++;
254         }
255     }
256 
257     /**
258      * @dev Add new CC users to array
259      */
260     function addCCUser(bytes32 user) private {
261         if ((userToNumVillages[user] == 0) &&
262             (userToNumTowns[user] == 0) &&
263             (userToNumCities[user] == 0)) {
264             // only add user to array during first land purchase
265             ccUsers.push(user);
266             ccUserCount++;
267         }
268     }
269 
270     /**
271      * @dev Purchase a village. For bulk purchase, current price honored for all
272      * villages purchased.
273      */
274     function purchaseVillage(uint256 numVillages) payable public onlyWhileOpen {
275         require(msg.value >= (villagePrice()*numVillages));
276         require(numVillages > 0);
277 
278         weiRaised = weiRaised.add(msg.value);
279 
280         villagesSold = villagesSold.add(numVillages);
281         addWalletAddress(msg.sender);
282         addressToNumVillages[msg.sender] = addressToNumVillages[msg.sender].add(numVillages);
283 
284         _forwardFunds();
285         LandPurchased(msg.sender, msg.value, 1, numVillages);
286     }
287 
288     /**
289      * @dev Purchase a town. For bulk purchase, current price honored for all
290      * towns purchased.
291      */
292     function purchaseTown(uint256 numTowns) payable public onlyWhileOpen {
293         require(msg.value >= (townPrice()*numTowns));
294         require(numTowns > 0);
295 
296         weiRaised = weiRaised.add(msg.value);
297 
298         townsSold = townsSold.add(numTowns);
299         addWalletAddress(msg.sender);
300         addressToNumTowns[msg.sender] = addressToNumTowns[msg.sender].add(numTowns);
301 
302         _forwardFunds();
303         LandPurchased(msg.sender, msg.value, 2, numTowns);
304     }
305 
306     /**
307      * @dev Purchase a city. For bulk purchase, current price honored for all
308      * cities purchased.
309      */
310     function purchaseCity(uint256 numCities) payable public onlyWhileOpen {
311         require(msg.value >= (cityPrice()*numCities));
312         require(numCities > 0);
313 
314         weiRaised = weiRaised.add(msg.value);
315 
316         citiesSold = citiesSold.add(numCities);
317         addWalletAddress(msg.sender);
318         addressToNumCities[msg.sender] = addressToNumCities[msg.sender].add(numCities);
319 
320         _forwardFunds();
321         LandPurchased(msg.sender, msg.value, 3, numCities);
322     }
323 
324     /**
325      * @dev Accounting for the CC purchases for audit purposes (no actual ETH transfer here)
326      */
327     function purchaseLandWithCC(uint8 landType, bytes32 userId, uint256 num) public onlyOwner onlyWhileOpen {
328         require(landType <= 3);
329         require(num > 0);
330 
331         addCCUser(userId);
332 
333         if (landType == 3) {
334             weiRaised = weiRaised.add(cityPrice()*num);
335             citiesSold = citiesSold.add(num);
336             userToNumCities[userId] = userToNumCities[userId].add(num);
337         } else if (landType == 2) {
338             weiRaised = weiRaised.add(townPrice()*num);
339             townsSold = townsSold.add(num);
340             userToNumTowns[userId] = userToNumTowns[userId].add(num);
341         } else if (landType == 1) {
342             weiRaised = weiRaised.add(villagePrice()*num);
343             villagesSold = villagesSold.add(num);
344             userToNumVillages[userId] = userToNumVillages[userId].add(num);
345         }
346 
347         LandPurchasedCC(userId, msg.sender, landType, num);
348     }
349 
350     /**
351      * @dev Returns the current price of a village. Price raises every 10 purchases.
352      */
353     function villagePrice() view public returns(uint256) {
354         return VILLAGE_START_PRICE.add((villagesSold.div(10).mul(VILLAGE_INCREASE_RATE)));
355     }
356 
357     /**
358      * @dev Returns the current price of a town. Price raises every 10 purchases
359      */
360     function townPrice() view public returns(uint256) {
361         return TOWN_START_PRICE.add((townsSold.div(10).mul(TOWN_INCREASE_RATE)));
362     }
363 
364     /**
365      * @dev Returns the current price of a city. Price raises every 10 purchases
366      */
367     function cityPrice() view public returns(uint256) {
368         return CITY_START_PRICE.add((citiesSold.div(10).mul(CITY_INCREASE_RATE)));
369     }
370 
371     /**
372      * @dev Allows owner to pause puchases during the landsale
373      */
374     function pause() onlyOwner public {
375         paused = true;
376     }
377 
378     /**
379      * @dev Allows owner to resume puchases during the landsale
380      */
381     function resume() onlyOwner public {
382         paused = false;
383     }
384 
385     /**
386      * @dev Allows owner to check the paused status
387      * @return Whether landsale is paused
388      */
389     function isPaused () onlyOwner public view returns(bool) {
390         return paused;
391     }
392 
393     /**
394      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
395      * @return Whether crowdsale period has elapsed
396      */
397     function hasClosed() public view returns (bool) {
398         return block.timestamp > closingTime;
399     }
400 
401     /**
402      * @dev Investors can claim refunds here if crowdsale is unsuccessful
403      */
404     function claimRefund() public {
405         require(isFinalized);
406         require(!goalReached());
407 
408         vault.refund(msg.sender);
409     }
410 
411     /**
412      * @dev Checks whether funding goal was reached.
413      * @return Whether funding goal was reached
414      */
415     function goalReached() public view returns (bool) {
416         return weiRaised >= goal;
417     }
418 
419     /**
420      * @dev vault finalization task, called when owner calls finalize()
421      */
422     function finalize() onlyOwner public {
423         require(!isFinalized);
424         require(hasClosed());
425 
426         if (goalReached()) {
427           vault.close();
428         } else {
429           vault.enableRefunds();
430         }
431 
432         Finalized();
433 
434         isFinalized = true;
435     }
436 
437     /**
438      * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
439      */
440     function _forwardFunds() internal {
441         vault.deposit.value(msg.value)(msg.sender);
442     }
443 }