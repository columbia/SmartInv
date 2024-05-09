1 pragma solidity ^0.4.19;
2 
3 	////////////////////////////////////
4 	////// CRYPTO SURPRISE
5 	////// https://cryptosurprise.me
6 	////////////////////////////////////
7 	
8 contract CryptoSurprise
9 {
10     using SetLibrary for SetLibrary.Set;
11     
12     ////////////////////////////////////
13     ////// CONSTANTS
14     
15     uint256 constant public BAG_TRANSFER_FEE = 0.05 ether;
16     uint256 constant public BAG_TRANSFER_MINIMUM_AMOUNT_OF_BUYS = 4;
17     
18     
19     ////////////////////////////////////
20     ////// STATE VARIABLES
21     
22     struct BagType
23     {
24         // Constants
25         string name;
26         
27         uint256 startPrice;
28         uint256 priceMultiplierPerBuy; // For example, 2 000 000 means 100% increase. (100% = doubling every buy)
29         
30         uint256 startCommission; // 0 to 1 000 000, for example 100 000 means 10%
31         uint256 commissionIncrementPerBuy;
32         uint256 maximumCommission;
33         
34         uint256 supplyHardCap;
35         
36         // Variables
37         uint256 currentSupply;
38     }
39     
40     struct Bag
41     {
42         // Constants
43         uint256 bagTypeIndex;
44         
45         // Variables
46         uint256 amountOfBuys;
47         address owner;
48         uint256 commission; // 0 to 1 000 000, for example 100 000 means 10%
49         uint256 price;
50         
51         uint256 availableTimestamp;
52     }
53     
54     // Variable that remembers the current owner
55     address public owner;
56     BagType[] public bagTypes;
57     Bag[] public bags;
58     
59     mapping(address => uint256) public addressToTotalEtherSpent;
60     mapping(address => uint256) public addressToTotalPurchasesMade;
61     mapping(address => SetLibrary.Set) private ownerToBagIndices;
62     address[] public allParticipants;
63     
64     
65     ////////////////////////////////////
66     ////// PLAYER FUNCTIONS
67     
68     function buyBag(uint256 _bagIndex) external payable
69     {
70         // Make sure that the bag exists
71         require(_bagIndex < bags.length);
72         
73         // Reference the bag data and bag type data
74         Bag storage bag = bags[_bagIndex];
75         BagType storage bagType = bagTypes[bag.bagTypeIndex];
76         
77         // Make sure the bag is already available
78         require(now >= bag.availableTimestamp);
79         
80         // Make sure the caller payed at least the current price
81         require(msg.value >= bag.price);
82         uint256 refund = msg.value - bag.price;
83         
84         // Remember who the previous owner was
85         address previousOwner = bag.owner;
86         
87         // Set the buyer as the new owner
88         bag.owner = msg.sender;
89         
90         // Calculate the previous and next price
91         uint256 previousPrice = bag.price * 1000000 / bagType.priceMultiplierPerBuy;
92         uint256 nextPrice = bag.price * bagType.priceMultiplierPerBuy / 1000000;
93         
94         // Calculate how much the previous owner should get:
95         uint256 previousOwnerReward;
96         
97         // If this is the first buy: the full current price
98         if (bag.amountOfBuys == 0)
99         {
100             previousOwnerReward = bag.price;
101         }
102         
103         // otherwise: previous price + the commission
104         else
105         {
106             previousOwnerReward = bag.price * bag.commission / 1000000;
107             //previousOwnerReward = previousPrice + previousPrice * bag.commission / 1000000;
108         }
109         
110         // Set the new price of the bag
111         bag.price = nextPrice;
112         
113         // Increment the amountOfBuys counter
114         bag.amountOfBuys++;
115         
116         // If this is NOT the first buy of this bag:
117         if (bag.amountOfBuys > 1)
118         {
119             // Increase the commission up to the maximum
120             if (bag.commission < bagType.maximumCommission)
121             {
122                 uint256 newCommission = bag.commission + bagType.commissionIncrementPerBuy;
123                 
124                 if (newCommission >= bagType.maximumCommission)
125                 {
126                     bag.commission = bagType.maximumCommission;
127                 }
128                 else 
129                 {
130                     bag.commission = newCommission;
131                 }
132             }
133         }
134         
135         // Record statistics
136         if (addressToTotalPurchasesMade[msg.sender] == 0)
137         {
138             allParticipants.push(msg.sender);
139         }
140         addressToTotalEtherSpent[msg.sender] += msg.value;
141         addressToTotalPurchasesMade[msg.sender]++;
142         
143         // Transfer the reward to the previous owner. If the previous owner is
144         // the CryptoSurprise smart contract itself, we don't need to perform any
145         // transfer because the contract already has it.
146         if (previousOwner != address(this))
147         {
148             previousOwner.transfer(previousOwnerReward);
149         }
150         
151         if (refund > 0)
152         {
153             msg.sender.transfer(refund);
154         }
155     }
156     
157     function transferBag(address _newOwner, uint256 _bagIndex) public payable
158     {
159         // Require payment
160         require(msg.value == BAG_TRANSFER_FEE);
161         
162         // Perform the transfer
163         _transferBag(msg.sender, _newOwner, _bagIndex);
164     }
165     
166     
167     ////////////////////////////////////
168     ////// OWNER FUNCTIONS
169     
170     // Constructor function
171     function CryptoSurprise() public
172     {
173         owner = msg.sender;
174         
175         bagTypes.push(BagType({
176             name: "Blue",
177             
178             startPrice: 0.04 ether,
179             priceMultiplierPerBuy: 1300000, // 130%
180             
181             startCommission: 850000, // 85%
182             commissionIncrementPerBuy: 5000, // 0.5 %-point
183             maximumCommission: 900000, // 90%
184             
185             supplyHardCap: 600,
186             
187             currentSupply: 0
188         }));
189 		bagTypes.push(BagType({
190             name: "Red",
191             
192             startPrice: 0.03 ether,
193             priceMultiplierPerBuy: 1330000, // 133%
194             
195             startCommission: 870000, // 87%
196             commissionIncrementPerBuy: 5000, // 0.5 %-point
197             maximumCommission: 920000, // 92%
198             
199             supplyHardCap: 300,
200             
201             currentSupply: 0
202         }));
203 		bagTypes.push(BagType({
204             name: "Green",
205             
206             startPrice: 0.02 ether,
207             priceMultiplierPerBuy: 1360000, // 136%
208             
209             startCommission: 890000, // 89%
210             commissionIncrementPerBuy: 5000, // 0.5 %-point
211             maximumCommission: 940000, // 94%
212             
213             supplyHardCap: 150,
214             
215             currentSupply: 0
216         }));
217 		bagTypes.push(BagType({
218             name: "Black",
219             
220             startPrice: 0.1 ether,
221             priceMultiplierPerBuy: 1450000, // 145%
222             
223             startCommission: 920000, // 92%
224             commissionIncrementPerBuy: 10000, // 1 %-point
225             maximumCommission: 960000, // 96%
226             
227             supplyHardCap: 50,
228             
229             currentSupply: 0
230         }));
231 		bagTypes.push(BagType({
232             name: "Pink",
233             
234             startPrice: 1 ether,
235             priceMultiplierPerBuy: 1500000, // 150%
236             
237             startCommission: 940000, // 94%
238             commissionIncrementPerBuy: 10000, // 1 %-point
239             maximumCommission: 980000, // 98%
240             
241             supplyHardCap: 10,
242             
243             currentSupply: 0
244         }));
245 		bagTypes.push(BagType({
246             name: "White",
247             
248             startPrice: 10 ether,
249             priceMultiplierPerBuy: 1500000, // 150%
250             
251             startCommission: 970000, // 97%
252             commissionIncrementPerBuy: 10000, // 1 %-point
253             maximumCommission: 990000, // 99%
254             
255             supplyHardCap: 1,
256             
257             currentSupply: 0
258         }));
259     }
260     
261     // Function that allows the current owner to transfer ownership
262     function transferOwnership(address _newOwner) external
263     {
264         require(msg.sender == owner);
265         owner = _newOwner;
266     }
267     
268     // Only the owner can deposit ETH by sending it directly to the contract
269     function () payable external
270     {
271         require(msg.sender == owner);
272     }
273     
274     // Function that allows the current owner to withdraw any amount
275     // of ETH from the contract
276     function withdrawEther(uint256 amount) external
277     {
278         require(msg.sender == owner);
279         owner.transfer(amount);
280     }
281     
282     function addBag(uint256 _bagTypeIndex) external
283     {
284         addBagAndGift(_bagTypeIndex, address(this));
285     }
286     function addBagDelayed(uint256 _bagTypeIndex, uint256 _delaySeconds) external
287     {
288         addBagAndGiftAtTime(_bagTypeIndex, address(this), now + _delaySeconds);
289     }
290     
291     function addBagAndGift(uint256 _bagTypeIndex, address _firstOwner) public
292     {
293         addBagAndGiftAtTime(_bagTypeIndex, _firstOwner, now);
294     }
295     function addBagAndGiftAtTime(uint256 _bagTypeIndex, address _firstOwner, uint256 _timestamp) public
296     {
297         require(msg.sender == owner);
298         
299         require(_bagTypeIndex < bagTypes.length);
300         
301         BagType storage bagType = bagTypes[_bagTypeIndex];
302         
303         require(bagType.currentSupply < bagType.supplyHardCap);
304         
305         bags.push(Bag({
306             bagTypeIndex: _bagTypeIndex,
307             
308             amountOfBuys: 0,
309             owner: _firstOwner,
310             commission: bagType.startCommission,
311             price: bagType.startPrice,
312             
313             availableTimestamp: _timestamp
314         }));
315         
316         bagType.currentSupply++;
317     }
318     
319 
320     
321     ////////////////////////////////////
322     ////// INTERNAL FUNCTIONS
323     
324     function _transferBag(address _from, address _to, uint256 _bagIndex) internal
325     {
326         // Make sure that the bag exists
327         require(_bagIndex < bags.length);
328         
329         // Bag may not be transferred before it has been bought x times
330         require(bags[_bagIndex].amountOfBuys >= BAG_TRANSFER_MINIMUM_AMOUNT_OF_BUYS);
331         
332         // Make sure that the sender is the current owner of the bag
333         require(bags[_bagIndex].owner == _from);
334         
335         // Set the new owner
336         bags[_bagIndex].owner = _to;
337         ownerToBagIndices[_from].remove(_bagIndex);
338         ownerToBagIndices[_to].add(_bagIndex);
339         
340         // Trigger blockchain event
341         Transfer(_from, _to, _bagIndex);
342     }
343     
344     
345     ////////////////////////////////////
346     ////// VIEW FUNCTIONS FOR USER INTERFACE
347     
348     function amountOfBags() external view returns (uint256)
349     {
350         return bags.length;
351     }
352     function amountOfBagTypes() external view returns (uint256)
353     {
354         return bagTypes.length;
355     }
356     function amountOfParticipants() external view returns (uint256)
357     {
358         return allParticipants.length;
359     }
360     
361     
362     ////////////////////////////////////
363     ////// ERC721 NON FUNGIBLE TOKEN INTERFACE
364     
365     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
366     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
367     
368     function name() external pure returns (string)
369     {
370         return "Bags";
371     }
372     
373     function symbol() external pure returns (string)
374     {
375         return "BAG";
376     }
377     
378     function totalSupply() external view returns (uint256)
379     {
380         return bags.length;
381     }
382     
383     function balanceOf(address _owner) external view returns (uint256)
384     {
385         return ownerToBagIndices[_owner].size();
386     }
387     
388     function ownerOf(uint256 _bagIndex) external view returns (address)
389     {
390         require(_bagIndex < bags.length);
391         
392         return bags[_bagIndex].owner;
393     }
394     mapping(address => mapping(address => mapping(uint256 => bool))) private ownerToAddressToBagIndexAllowed;
395     function approve(address _to, uint256 _bagIndex) external
396     {
397         require(_bagIndex < bags.length);
398         
399         require(msg.sender == bags[_bagIndex].owner);
400         
401         ownerToAddressToBagIndexAllowed[msg.sender][_to][_bagIndex] = true;
402     }
403     
404     function takeOwnership(uint256 _bagIndex) external
405     {
406         require(_bagIndex < bags.length);
407         
408         address previousOwner = bags[_bagIndex].owner;
409         
410         require(ownerToAddressToBagIndexAllowed[previousOwner][msg.sender][_bagIndex] == true);
411         
412         ownerToAddressToBagIndexAllowed[previousOwner][msg.sender][_bagIndex] = false;
413         
414         _transferBag(previousOwner, msg.sender, _bagIndex);
415     }
416     
417     function transfer(address _to, uint256 _bagIndex) external
418     {
419         transferBag(_to, _bagIndex);
420     }
421     
422     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256)
423     {
424         require(_index < ownerToBagIndices[_owner].size());
425         
426         return ownerToBagIndices[_owner].values[_index];
427     }
428 }
429  
430 library SetLibrary
431 {
432     struct ArrayIndexAndExistsFlag
433     {
434         uint256 index;
435         bool exists;
436     }
437     struct Set
438     {
439         mapping(uint256 => ArrayIndexAndExistsFlag) valuesMapping;
440         uint256[] values;
441     }
442     function add(Set storage self, uint256 value) public returns (bool added)
443     {
444         // If the value is already in the set, we don't need to do anything
445         if (self.valuesMapping[value].exists == true) return false;
446         
447         // Remember that the value is in the set, and remember the value's array index
448         self.valuesMapping[value] = ArrayIndexAndExistsFlag({index: self.values.length, exists: true});
449         
450         // Add the value to the array of unique values
451         self.values.push(value);
452         
453         return true;
454     }
455     function contains(Set storage self, uint256 value) public view returns (bool contained)
456     {
457         return self.valuesMapping[value].exists;
458     }
459     function remove(Set storage self, uint256 value) public returns (bool removed)
460     {
461         // If the value is not in the set, we don't need to do anything
462         if (self.valuesMapping[value].exists == false) return false;
463         
464         // Remember that the value is not in the set
465         self.valuesMapping[value].exists = false;
466         
467         // Now we need to remove the value from the array. To prevent leaking
468         // storage space, we move the last value in the array into the spot that
469         // contains the element we're removing.
470         if (self.valuesMapping[value].index < self.values.length-1)
471         {
472             uint256 valueToMove = self.values[self.values.length-1];
473             uint256 indexToMoveItTo = self.valuesMapping[value].index;
474             self.values[indexToMoveItTo] = valueToMove;
475             self.valuesMapping[valueToMove].index = indexToMoveItTo;
476         }
477         
478         // Now we remove the last element from the array, because we just duplicated it.
479         // We don't free the storage allocation of the removed last element,
480         // because it will most likely be used again by a call to add().
481         // De-allocating and re-allocating storage space costs more gas than
482         // just keeping it allocated and unused.
483         
484         // Uncomment this line to save gas if your use case does not call add() after remove():
485         // delete self.values[self.values.length-1];
486         self.values.length--;
487         
488         // We do free the storage allocation in the mapping, because it is
489         // less likely that the exact same value will added again.
490         delete self.valuesMapping[value];
491         
492         return true;
493     }
494     function size(Set storage self) public view returns (uint256 amountOfValues)
495     {
496         return self.values.length;
497     }
498     
499     // Also accept address and bytes32 types, so the user doesn't have to cast.
500     function add(Set storage self, address value) public returns (bool added) { return add(self, uint256(value)); }
501     function add(Set storage self, bytes32 value) public returns (bool added) { return add(self, uint256(value)); }
502     function contains(Set storage self, address value) public view returns (bool contained) { return contains(self, uint256(value)); }
503     function contains(Set storage self, bytes32 value) public view returns (bool contained) { return contains(self, uint256(value)); }
504     function remove(Set storage self, address value) public returns (bool removed) { return remove(self, uint256(value)); }
505     function remove(Set storage self, bytes32 value) public returns (bool removed) { return remove(self, uint256(value)); }
506 }