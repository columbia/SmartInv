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
38 }
39 
40 library Shared {
41     struct Spinner {
42         string name;
43         uint256 class;
44         uint8 speed;
45         uint8 momentum;
46         uint8 inertia;
47         uint256 _id;
48         address spinnerOwner;
49         uint256 created;
50         uint256 purchasePrice;
51         uint256 purchaseIndex;    
52     }
53 
54     struct SpinnerMint {
55         bool purchasable;
56         uint startPrice;
57         uint currentPrice;
58         uint returnPrice;
59     }
60 }
61 
62 
63 contract SpinnerDatabase is Ownable {
64     
65     uint256 public totalSpinners;
66     uint256 public availableThemedSpinners;
67     uint256 public maxSpinners; //prevent hoarding
68     uint256 public currentUniqueSpinnerPrice;
69     uint256 spinnerModulus = 16777216; //16,777,216 or 256^3 possible unique spinners
70     uint256 public uniqueSpinners;
71 
72     address[] public uniqueSpinnerOwners;
73     
74     address public owner;
75     address public processorAddress;
76     address public factoryAddress;
77     address public marketAddress;
78 
79     function setProcessorAddress(address processAddress) public onlyOwner {
80         processorAddress = processAddress;
81     }
82 
83     function setFactoryAddress(address factorAddress) public onlyOwner {
84         factoryAddress = factorAddress;
85     }
86 
87     function setMarketAddress(address market) public onlyOwner {
88         marketAddress = market;
89     }
90 
91     mapping (uint => uint) public spinnerCounts;
92     mapping (address => uint) public balances;
93     mapping (address => uint) public earn;
94     mapping (uint => Shared.SpinnerMint) public themedSpinners;
95     mapping (address => Shared.Spinner[]) public SpinnersByAddress;
96     mapping (uint => address[]) public OwnersBySpinner;
97     mapping (address => uint) public SpinnerCountsByAddress;
98     mapping (uint => uint) public originalPricesBySpinner;
99     mapping (uint => uint) public spinnerCountsByType;
100 
101     function SpinnerDatabase() public {
102         totalSpinners = 0;
103         maxSpinners = 512;
104         availableThemedSpinners = 0;
105         uniqueSpinners = 0;
106         currentUniqueSpinnerPrice = 1 ether;
107         owner = msg.sender;
108         
109     }
110 
111     function addSpinner(string _name, uint _type, address creator, uint value, uint8 speed, uint8 momentum, uint8 inertia) external {
112         require(msg.sender == factoryAddress);
113         uint256 _id = uint(uint(keccak256(_type)) + uint(keccak256(block.timestamp + uint(keccak256(msg.sender)))));
114         uint256 purchaseIndex = spinnerCountsByType[_type];
115         SpinnersByAddress[creator].push(Shared.Spinner(_name, _type, speed, momentum, inertia, _id, creator, block.timestamp, value, purchaseIndex));
116         incrementBalances(_type); //payout owners
117         OwnersBySpinner[_type].push(creator); //Add new owner of Spinner
118         incrementThemedSpinnerPrice(_type); //increase price
119         spinnerCounts[_type]++; //Total Purchased of Spinner
120         totalSpinners++; //Total Purchased overall
121         SpinnerCountsByAddress[creator]++; //Total Owned
122         spinnerCountsByType[_type]++; //increment count of type    
123     }
124 
125     function addUniqueSpinner(string _name, uint _type, address creator, uint value, uint8 speed, uint8 momentum, uint8 inertia) external {
126         require(msg.sender == factoryAddress); 
127         uint256 _id = uint(uint(keccak256(_type)) + uint(keccak256(block.timestamp + uint(keccak256(msg.sender)))));
128         uint256 purchaseIndex = uniqueSpinners;
129         SpinnersByAddress[creator].push(Shared.Spinner(_name, _type, speed, momentum, inertia, _id, creator, block.timestamp, value, purchaseIndex));
130         uniqueSpinnerOwners.push(creator); //Add new owner of Spinner
131         uniqueSpinners++; //Total Purchased of Spinner
132         totalSpinners++; //Total Purchased overall
133         SpinnerCountsByAddress[creator]++; //Total Owned
134     }
135 
136     function changeOwnership(string _name, uint _id, uint _type, address originalOwner, address newOwner) external {
137         require(msg.sender == marketAddress);
138         uint256 totalSpinnersOwned = SpinnerCountsByAddress[originalOwner];
139         for (uint256 i = 0; i < totalSpinnersOwned; i++) {
140             uint mySpinnerId = getSpinnerData(originalOwner, i)._id;
141             if (mySpinnerId == _id) {
142                 executeOwnershipChange(i, _id, _type, originalOwner, newOwner, _name);
143                 break;
144             }
145         }
146         changeOwnershipStepTwo(_type, originalOwner, newOwner);
147     }
148 
149     function changeOwnershipStepTwo(uint _type, address originalOwner, address newOwner) private {
150         uint totalSpinnersOfType = spinnerCountsByType[_type];
151         address[] storage owners = OwnersBySpinner[_type];
152         for (uint j = 0; j < totalSpinnersOfType; j++) {
153             if (owners[j] == originalOwner) {
154                 owners[j] = newOwner;
155                 break;
156             }
157         }
158         OwnersBySpinner[_type] = owners;    
159     }
160 
161     function changeUniqueOwnership(string _name, uint _id, address originalOwner, address newOwner) external {
162         require(msg.sender == marketAddress);
163         uint256 totalSpinnersOwned = SpinnerCountsByAddress[originalOwner];
164         for (uint256 i = 0; i < totalSpinnersOwned; i++) {
165             uint mySpinnerId = getSpinnerData(originalOwner, i)._id;
166             if (mySpinnerId == _id) {
167                 uint spinnerType = getSpinnerData(originalOwner, i).class;
168                 executeOwnershipChange(i, _id, spinnerType, originalOwner, newOwner, _name);
169                 break;
170             }
171         }
172         changeUniqueOwnershipStepTwo(originalOwner, newOwner);
173     }
174     
175     function changeUniqueOwnershipStepTwo(address originalOwner, address newOwner) private {
176         uint totalUniqueSpinners = uniqueSpinners;
177         for (uint j = 0; j < totalUniqueSpinners; j++) {
178             if (uniqueSpinnerOwners[j] == originalOwner) {
179                 uniqueSpinnerOwners[j] = newOwner;
180                 break;
181             }
182         }  
183     }
184 
185     function executeOwnershipChange(uint i, uint _id, uint _type, address originalOwner, address newOwner, string _name) private {
186         uint8 spinnerSpeed = getSpinnerData(originalOwner, i).speed;
187         uint8 spinnerMomentum = getSpinnerData(originalOwner, i).momentum;
188         uint8 spinnerInertia = getSpinnerData(originalOwner, i).inertia;
189         uint spinnerTimestamp = getSpinnerData(originalOwner, i).created;
190         uint spinnerPurchasePrice = getSpinnerData(originalOwner, i).purchasePrice;
191         uint spinnerPurchaseIndex  = getSpinnerData(originalOwner, i).purchaseIndex;
192         SpinnerCountsByAddress[originalOwner]--;
193         delete SpinnersByAddress[originalOwner][i];
194         SpinnersByAddress[newOwner].push(Shared.Spinner(_name, _type, spinnerSpeed, spinnerMomentum, spinnerInertia, _id, newOwner, spinnerTimestamp, spinnerPurchasePrice, spinnerPurchaseIndex));
195         SpinnerCountsByAddress[newOwner]++;  
196     }
197 
198 
199     function generateThemedSpinners(uint seed, uint price, uint returnPrice) external {
200         require(msg.sender == factoryAddress);
201         themedSpinners[seed] = Shared.SpinnerMint(true, price, price, returnPrice);
202         originalPricesBySpinner[seed] = price;
203         availableThemedSpinners++;
204     }
205 
206     function incrementThemedSpinnerPrice(uint seed) private {
207         themedSpinners[seed].currentPrice = themedSpinners[seed].currentPrice + themedSpinners[seed].returnPrice;
208     }
209 
210     function getSpinnerPrice(uint seed) public view returns (uint) {
211         return themedSpinners[seed].currentPrice;
212     }
213 
214     function getUniqueSpinnerPrice() public view returns (uint) {
215         return currentUniqueSpinnerPrice;
216     }
217 
218     function setUniqueSpinnerPrice(uint cost) public onlyOwner {
219         currentUniqueSpinnerPrice = cost;
220     }
221 
222     function getBalance(address walletAddress) public view returns (uint) {
223         return balances[walletAddress];
224     }
225 
226     function getSpinnerData(address walletAddress, uint index) public view returns (Shared.Spinner) {
227         return SpinnersByAddress[walletAddress][index];
228     } 
229 
230     function getOriginalSpinnerPrice(uint256 _id) public view returns (uint) {
231         return originalPricesBySpinner[_id];
232     }
233 
234     function doesAddressOwnSpinner(address walletAddress, uint _id) public view returns (bool) {
235         uint count = spinnerCountsByType[_id + spinnerModulus];
236         for (uint i=0; i<count; i++) {
237             if (keccak256(SpinnersByAddress[walletAddress][i].spinnerOwner) == keccak256(walletAddress)) {
238                 return true;
239             }
240         }
241         return false;
242     }
243 
244     function incrementBalances(uint _type) private {
245         uint totalPurchased = spinnerCounts[_type];
246         address[] storage owners = OwnersBySpinner[_type];
247         uint payout = themedSpinners[_type].returnPrice;
248         for (uint i = 0; i < totalPurchased; i++) {
249             balances[owners[i]] = balances[owners[i]] + payout;
250             earn[owners[i]] = earn[owners[i]] + payout;
251         }
252     }
253 
254     function decrementBalance(address walletAddress, uint amount) external {
255         require(msg.sender == processorAddress);
256         require(amount <= balances[walletAddress]);
257         balances[walletAddress] = balances[walletAddress] - amount;
258     }
259 }
260 
261 contract SpinnerFactory is Ownable {
262 
263     function SpinnerFactory(address _spinnerDatabaseAddress) public {
264         databaseAddress = _spinnerDatabaseAddress;
265     }
266 
267     address public databaseAddress;
268     address public processorAddress;
269     uint256 public spinnerModulus = 16777216; //16,777,216 or 256^3 possible unique spinners
270 
271     address public owner;
272 
273     mapping (uint => bool) public initialSpinners; //mapping of initial spinners
274 
275     function setProcessorAddress(address processAddress) public onlyOwner {
276         processorAddress = processAddress;
277     }
278 
279     function _generateRandomSeed() internal view returns (uint) {
280         uint rand = uint(keccak256(uint(block.blockhash(block.number-1)) + uint(keccak256(msg.sender))));
281         return rand % spinnerModulus;
282     }
283 
284     function createUniqueSpinner(string _name, address creator, uint value) external {
285         require(msg.sender == processorAddress);
286         uint _seed = _generateRandomSeed();
287         SpinnerDatabase database = SpinnerDatabase(databaseAddress);
288         database.addUniqueSpinner(_name, _seed, creator, value, uint8(keccak256(_seed + 1)) % 64 + 64, uint8(keccak256(_seed + 2)) % 64 + 64, uint8(keccak256(_seed + 3)) % 64 + 64);
289     }
290 
291    function createThemedSpinner(string _name, uint _type, address creator, uint value) external {
292         require(msg.sender == processorAddress);
293         require(initialSpinners[_type] == true);
294         uint _seed = _generateRandomSeed();
295         SpinnerDatabase database = SpinnerDatabase(databaseAddress);
296         database.addSpinner(_name, _type, creator, value, uint8(keccak256(_seed + 1)) % 64 + 64, uint8(keccak256(_seed + 2)) % 64 + 64, uint8(keccak256(_seed + 3)) % 64 + 64);
297     }
298 
299     function addNewSpinner(uint _type) public onlyOwner {
300         initialSpinners[_type] = true;
301     }
302 
303     function blockNewSpinnerPurchase(uint _type) public onlyOwner {
304         initialSpinners[_type] = false;
305     }
306 
307     function mintGen0Spinners() public onlyOwner {
308         SpinnerDatabase database = SpinnerDatabase(databaseAddress);
309         addNewSpinner(1 + spinnerModulus);
310         database.generateThemedSpinners(1 + spinnerModulus, 1 ether, .01 ether);
311         addNewSpinner(2 + spinnerModulus);
312         database.generateThemedSpinners(2 + spinnerModulus, 1 ether, .01 ether);
313         addNewSpinner(3 + spinnerModulus);
314         database.generateThemedSpinners(3 + spinnerModulus, .75 ether, .0075 ether);
315         addNewSpinner(4 + spinnerModulus);
316         database.generateThemedSpinners(4 + spinnerModulus, .75 ether, .0075 ether);
317         addNewSpinner(5 + spinnerModulus);
318         database.generateThemedSpinners(5 + spinnerModulus, .75 ether, .0075 ether);
319         addNewSpinner(6 + spinnerModulus);
320         database.generateThemedSpinners(6 + spinnerModulus, .75 ether, .0075 ether);
321         addNewSpinner(7 + spinnerModulus);
322         database.generateThemedSpinners(7 + spinnerModulus, .75 ether, .0075 ether);
323         addNewSpinner(8 + spinnerModulus);
324         database.generateThemedSpinners(8 + spinnerModulus, .75 ether, .0075 ether);
325         addNewSpinner(9 + spinnerModulus);
326         database.generateThemedSpinners(9 + spinnerModulus, .5 ether, .005 ether);
327         addNewSpinner(10 + spinnerModulus);
328         database.generateThemedSpinners(10 + spinnerModulus, .5 ether, .005 ether);
329         addNewSpinner(11 + spinnerModulus);
330         database.generateThemedSpinners(11 + spinnerModulus, .5 ether, .005 ether);
331         addNewSpinner(12 + spinnerModulus);
332         database.generateThemedSpinners(12 + spinnerModulus, .5 ether, .005 ether);
333         addNewSpinner(13 + spinnerModulus);
334         database.generateThemedSpinners(13 + spinnerModulus, .2 ether, .002 ether);
335         addNewSpinner(14 + spinnerModulus);
336         database.generateThemedSpinners(14 + spinnerModulus, .2 ether, .002 ether);
337         addNewSpinner(15 + spinnerModulus);
338         database.generateThemedSpinners(15 + spinnerModulus, .3 ether, .003 ether);
339         addNewSpinner(16 + spinnerModulus);
340         database.generateThemedSpinners(16 + spinnerModulus, .3 ether, .003 ether);
341         addNewSpinner(17 + spinnerModulus);
342         database.generateThemedSpinners(17 + spinnerModulus, .05 ether, .0005 ether);
343         addNewSpinner(18 + spinnerModulus);
344         database.generateThemedSpinners(18 + spinnerModulus, .05 ether, .0005 ether);
345         addNewSpinner(19 + spinnerModulus);
346         database.generateThemedSpinners(19 + spinnerModulus, .008 ether, .00008 ether);
347         addNewSpinner(20 + spinnerModulus);
348         database.generateThemedSpinners(20 + spinnerModulus, .001 ether, .00001 ether);
349     }
350 
351     function mintNewSpinner(uint _id, uint price, uint returnPrice) public onlyOwner {
352         SpinnerDatabase database = SpinnerDatabase(databaseAddress);
353         addNewSpinner(_id + spinnerModulus);
354         database.generateThemedSpinners(_id + spinnerModulus, price, returnPrice);
355     }
356 }
357     
358 contract SpinnerProcessor is Ownable {
359 
360     uint256 spinnerModulus = 16777216; //16,777,216 or 256^3 possible unique spinners
361 
362     modifier whenNotPaused() {
363         require(!paused);
364         _;
365     }
366 
367     modifier uniqueSpinnersActivated() {
368         require(uniqueSpinnersActive);
369         _;
370     }
371 
372     address public owner;
373 
374     function pause() public onlyOwner {
375         paused = true;
376     }
377 
378     function unpause() public onlyOwner {
379         paused = false;
380     }
381 
382     function activateUniqueSpinners() public onlyOwner {
383         uniqueSpinnersActive = true;
384     }   
385     
386     bool public paused;
387     bool public uniqueSpinnersActive;
388 
389     address factoryAddress;
390     address databaseAddress;
391     address ownerAddress;
392 
393     uint256 ownerEarn;
394     uint256 ownerBalance;
395 
396     function viewBalance() view public returns (uint256) {
397         return this.balance;
398     }
399 
400     function SpinnerProcessor(address _spinnerFactoryAddress, address _spinnerDatabaseAddress, address _ownerAddress) public {
401         factoryAddress = _spinnerFactoryAddress;
402         databaseAddress = _spinnerDatabaseAddress;
403         ownerAddress = _ownerAddress;
404         paused = true;
405         uniqueSpinnersActive = false;
406     }
407 
408     function purchaseThemedSpinner(string _name, uint _id) public payable whenNotPaused {
409         SpinnerDatabase database = SpinnerDatabase(databaseAddress);
410         uint currentPrice = database.getSpinnerPrice(_id + spinnerModulus);
411         require(msg.value == currentPrice);
412         uint ownerPayout = database.getOriginalSpinnerPrice(_id + spinnerModulus);
413         ownerEarn = ownerEarn + ownerPayout;
414         ownerBalance = ownerBalance + ownerPayout;    
415         SpinnerFactory factory = SpinnerFactory(factoryAddress);
416         factory.createThemedSpinner(_name, _id + spinnerModulus, msg.sender, msg.value);
417     }
418 
419     function purchaseUniqueSpinner(string _name) public payable whenNotPaused uniqueSpinnersActivated {
420         SpinnerDatabase database = SpinnerDatabase(databaseAddress);
421         uint currentPrice = database.getUniqueSpinnerPrice();
422         require(msg.value == currentPrice);
423         SpinnerFactory factory = SpinnerFactory(factoryAddress);
424         factory.createUniqueSpinner(_name, msg.sender, msg.value);
425     }
426 
427     function cashOut() public whenNotPaused {
428         SpinnerDatabase database = SpinnerDatabase(databaseAddress);
429         uint balance = database.getBalance(msg.sender);
430         uint contractBalance = this.balance;
431         require(balance <= contractBalance);
432         database.decrementBalance(msg.sender, balance);
433         msg.sender.transfer(balance);
434     }
435 
436     function OwnerCashout() public onlyOwner {
437         require(ownerBalance <= this.balance);
438         msg.sender.transfer(ownerBalance);
439         ownerBalance = 0;
440     }
441 
442     function transferBalance(address newProcessor) public onlyOwner {
443         newProcessor.transfer(this.balance);
444     }
445 
446     function () payable public {}
447 
448 }