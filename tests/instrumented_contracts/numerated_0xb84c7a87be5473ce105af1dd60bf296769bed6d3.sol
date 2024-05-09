1 pragma solidity ^0.4.18;
2 
3 
4 contract InterfaceContentCreatorUniverse {
5   function ownerOf(uint256 _tokenId) public view returns (address _owner);
6   function priceOf(uint256 _tokenId) public view returns (uint256 price);
7   function getNextPrice(uint price, uint _tokenId) public pure returns (uint);
8   function lastSubTokenBuyerOf(uint tokenId) public view returns(address);
9   function lastSubTokenCreatorOf(uint tokenId) public view returns(address);
10 
11   //
12   function createCollectible(uint256 tokenId, uint256 _price, address creator, address owner) external ;
13 }
14 
15 contract InterfaceYCC {
16   function payForUpgrade(address user, uint price) external  returns (bool success);
17   function mintCoinsForOldCollectibles(address to, uint256 amount, address universeOwner) external  returns (bool success);
18   function tradePreToken(uint price, address buyer, address seller, uint burnPercent, address universeOwner) external;
19   function payoutForMining(address user, uint amount) external;
20   uint256 public totalSupply;
21 }
22 
23 contract InterfaceMining {
24   function createMineForToken(uint tokenId, uint level, uint xp, uint nextLevelBreak, uint blocknumber) external;
25   function payoutMining(uint tokenId, address owner, address newOwner) external;
26   function levelUpMining(uint tokenId) external;
27 }
28 
29 library SafeMath {
30 
31   /**
32   * @dev Multiplies two numbers, throws on overflow.
33   */
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     if (a == 0) {
36       return 0;
37     }
38     uint256 c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42 
43   /**
44   * @dev Integer division of two numbers, truncating the quotient.
45   */
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return c;
51   }
52 
53   /**
54   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
55   */
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     assert(b <= a);
58     return a - b;
59   }
60 
61   /**
62   * @dev Adds two numbers, throws on overflow.
63   */
64   function add(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 contract Owned {
72   // The addresses of the accounts (or contracts) that can execute actions within each roles.
73   address public ceoAddress;
74   address public cooAddress;
75   address private newCeoAddress;
76   address private newCooAddress;
77 
78 
79   function Owned() public {
80       ceoAddress = msg.sender;
81       cooAddress = msg.sender;
82   }
83 
84   /*** ACCESS MODIFIERS ***/
85   /// @dev Access modifier for CEO-only functionality
86   modifier onlyCEO() {
87     require(msg.sender == ceoAddress);
88     _;
89   }
90 
91   /// @dev Access modifier for COO-only functionality
92   modifier onlyCOO() {
93     require(msg.sender == cooAddress);
94     _;
95   }
96 
97   /// Access modifier for contract owner only functionality
98   modifier onlyCLevel() {
99     require(
100       msg.sender == ceoAddress ||
101       msg.sender == cooAddress
102     );
103     _;
104   }
105 
106   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
107   /// @param _newCEO The address of the new CEO
108   function setCEO(address _newCEO) public onlyCEO {
109     require(_newCEO != address(0));
110     newCeoAddress = _newCEO;
111   }
112 
113   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
114   /// @param _newCOO The address of the new COO
115   function setCOO(address _newCOO) public onlyCEO {
116     require(_newCOO != address(0));
117     newCooAddress = _newCOO;
118   }
119 
120   function acceptCeoOwnership() public {
121       require(msg.sender == newCeoAddress);
122       require(address(0) != newCeoAddress);
123       ceoAddress = newCeoAddress;
124       newCeoAddress = address(0);
125   }
126 
127   function acceptCooOwnership() public {
128       require(msg.sender == newCooAddress);
129       require(address(0) != newCooAddress);
130       cooAddress = newCooAddress;
131       newCooAddress = address(0);
132   }
133 
134   mapping (address => bool) public youCollectContracts;
135   function addYouCollectContract(address contractAddress, bool active) public onlyCOO {
136     youCollectContracts[contractAddress] = active;
137   }
138   modifier onlyYCC() {
139     require(youCollectContracts[msg.sender]);
140     _;
141   }
142 
143   InterfaceYCC ycc;
144   InterfaceContentCreatorUniverse yct;
145   InterfaceMining ycm;
146   function setMainYouCollectContractAddresses(address yccContract, address yctContract, address ycmContract, address[] otherContracts) public onlyCOO {
147     ycc = InterfaceYCC(yccContract);
148     yct = InterfaceContentCreatorUniverse(yctContract);
149     ycm = InterfaceMining(ycmContract);
150     youCollectContracts[yccContract] = true;
151     youCollectContracts[yctContract] = true;
152     youCollectContracts[ycmContract] = true;
153     for (uint16 index = 0; index < otherContracts.length; index++) {
154       youCollectContracts[otherContracts[index]] = true;
155     }
156   }
157   function setYccContractAddress(address yccContract) public onlyCOO {
158     ycc = InterfaceYCC(yccContract);
159     youCollectContracts[yccContract] = true;
160   }
161   function setYctContractAddress(address yctContract) public onlyCOO {
162     yct = InterfaceContentCreatorUniverse(yctContract);
163     youCollectContracts[yctContract] = true;
164   }
165   function setYcmContractAddress(address ycmContract) public onlyCOO {
166     ycm = InterfaceMining(ycmContract);
167     youCollectContracts[ycmContract] = true;
168   }
169 
170 }
171 
172 contract TransferInterfaceERC721YC {
173   function transferToken(address to, uint256 tokenId) public returns (bool success);
174 }
175 contract TransferInterfaceERC20 {
176   function transfer(address to, uint tokens) public returns (bool success);
177 }
178 
179 // ----------------------------------------------------------------------------
180 // ERC Token Standard #20 Interface
181 // https://github.com/ConsenSys/Tokens/blob/master/contracts/eip20/EIP20.sol
182 // ----------------------------------------------------------------------------
183 contract YouCollectBase is Owned {
184   using SafeMath for uint256;
185 
186   event RedButton(uint value, uint totalSupply);
187 
188   // Payout
189   function payout(address _to) public onlyCLevel {
190     _payout(_to, this.balance);
191   }
192   function payout(address _to, uint amount) public onlyCLevel {
193     if (amount>this.balance)
194       amount = this.balance;
195     _payout(_to, amount);
196   }
197   function _payout(address _to, uint amount) private {
198     if (_to == address(0)) {
199       ceoAddress.transfer(amount);
200     } else {
201       _to.transfer(amount);
202     }
203   }
204 
205   // ------------------------------------------------------------------------
206   // Owner can transfer out any accidentally sent ERC20 tokens
207   // ------------------------------------------------------------------------
208   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyCEO returns (bool success) {
209       return TransferInterfaceERC20(tokenAddress).transfer(ceoAddress, tokens);
210   }
211 }
212 
213 
214 contract InterfaceSpawn {
215     uint public totalVotes;
216     function getVotes(uint id) public view returns (uint _votes);
217 }
218 
219 contract RocketsAndResources is YouCollectBase {
220     InterfaceSpawn subcontinentDiscoveryVoting;
221 
222     event RocketLaunch(uint _rocketTokenId);
223     event RocketAddFunds(uint _rocketTokenId, uint _res, uint _yccAmount, address _sender);
224     event ResourcesDiscovered(uint _cityTokenId);
225     event ResourcesTransfered(uint cityTokenId, uint _rocketTokenId, uint _res, uint _count);
226 
227     // ---------------------------
228     // Configuration    
229     bool public contractActive = false;
230 
231     uint discoveryCooldownMin = 1500;
232     uint discoveryCooldownMax = 6000;
233     uint discoveryPriceMin =  2000000000000000000000000;
234     uint discoveryPriceMax = 25000000000000000000000000;
235 
236     uint rocketTravelTimeA = 10000;         // in resource-traveltime-formula A/x
237     uint rocketTravelTimeMinBlocks = 24000; // added to traveltimes of resources
238     uint rocketEarliestLaunchTime;
239     // ---------------------------
240 
241     mapping (uint => uint) discoveryLastBlock;
242     
243     mapping (uint => uint[]) cityResourceRichness;  // eg [1, 6, 0, 0] --- gets added to resource-counts on discovery
244     mapping (uint => uint[]) cityResourceCount;
245     
246 
247     mapping (uint => uint[]) rocketResourceCount;
248     mapping (uint => uint[]) rocketResourceYccFunds;
249     mapping (uint => uint[]) rocketResourcePrices;
250 
251     mapping (uint => uint) rocketLaunchBlock;           // when owner launched the rocket
252     mapping (uint => uint) rocketTravelTimeAtLaunch;    // when launched, we record the travel time (in case we change params in the formula)
253     mapping (uint => uint) rocketTravelTimeIncrease;
254     
255     uint64 constant MAX_SUBCONTINENT_INDEX = 10000000000000;
256     
257     function RocketsAndResources() public {
258         rocketEarliestLaunchTime = block.number + 36000; // earliest launch is 6 days after contract deploy
259     }
260 
261     function setSubcontinentDiscoveryVotingContract(address spawnContract) public onlyCOO {
262         subcontinentDiscoveryVoting = InterfaceSpawn(spawnContract);
263     }
264 
265     function setContractActive(bool contractActive_) public onlyCOO {
266         contractActive = contractActive_;
267     }
268 
269     function setConfiguration(
270         uint discoveryCooldownMin_,
271         uint discoveryCooldownMax_,
272         uint discoveryPriceMin_,
273         uint discoveryPriceMax_,
274         uint rocketEarliestLaunchTime_,
275         uint rocketTravelTimeA_,
276         uint rocketTravelTimeMinBlocks_
277     ) public onlyYCC 
278     {
279         discoveryCooldownMin = discoveryCooldownMin_;
280         discoveryCooldownMax = discoveryCooldownMax_;
281         discoveryPriceMin = discoveryPriceMin_;
282         discoveryPriceMax = discoveryPriceMax_;
283         rocketEarliestLaunchTime = rocketEarliestLaunchTime_;
284         rocketTravelTimeA = rocketTravelTimeA_;
285         rocketTravelTimeMinBlocks = rocketTravelTimeMinBlocks_;
286     }
287 
288     function setCityValues(uint[] cityTokenIds_, uint resourceLen_, uint[] resourceRichness_, uint[] resourceCounts_) public onlyYCC {
289         uint len = cityTokenIds_.length;
290         for (uint i = 0; i < len; i++) {
291             uint city = cityTokenIds_[i];
292             uint resourceBaseIdx = i * resourceLen_;
293             cityResourceRichness[city] = new uint[](resourceLen_);
294             cityResourceCount[city] = new uint[](resourceLen_);
295             for (uint j = 0; j < resourceLen_; j++) {
296                 cityResourceRichness[city][j] = resourceRichness_[resourceBaseIdx + j];
297                 cityResourceCount[city][j] = resourceCounts_[resourceBaseIdx + j];
298             }
299         }
300     }
301 
302     function setRocketValues(uint[] rocketTokenIds_, uint resourceLen_, uint[] resourceYccFunds_, uint[] resourcePrices_, uint[] resourceCounts_) public onlyYCC {
303         uint len = rocketTokenIds_.length;
304         for (uint i = 0; i < len; i++) {
305             uint rocket = rocketTokenIds_[i];
306             uint resourceBaseIdx = i * resourceLen_;
307             rocketResourceCount[rocket] = new uint[](resourceLen_);
308             rocketResourcePrices[rocket] = new uint[](resourceLen_);
309             rocketResourceYccFunds[rocket] = new uint[](resourceLen_);
310             for (uint j = 0; j < resourceLen_; j++) {
311                 rocketResourceCount[rocket][j] = resourceCounts_[resourceBaseIdx + j];
312                 rocketResourcePrices[rocket][j] = resourcePrices_[resourceBaseIdx + j];
313                 rocketResourceYccFunds[rocket][j] = resourceYccFunds_[resourceBaseIdx + j];
314             }
315         }
316     }
317 
318     function getCityResources(uint cityTokenId_) public view returns (uint[] _resourceCounts) {
319         _resourceCounts = cityResourceCount[cityTokenId_];
320     }
321 
322     function getCityResourceRichness(uint cityTokenId_) public onlyYCC view returns (uint[] _resourceRichness) {
323         _resourceRichness = cityResourceRichness[cityTokenId_];
324     }
325 
326     function cityTransferResources(uint cityTokenId_, uint rocketTokenId_, uint res_, uint count_) public {
327         require(contractActive);
328         require(yct.ownerOf(cityTokenId_)==msg.sender);
329 
330         uint yccAmount = rocketResourcePrices[rocketTokenId_][res_] * count_;
331         
332         require(cityResourceCount[cityTokenId_][res_] >= count_);
333         require(rocketResourceYccFunds[rocketTokenId_][res_] >= yccAmount);
334 
335         cityResourceCount[cityTokenId_][res_] -= count_;
336         rocketResourceCount[rocketTokenId_][res_] += count_;
337         rocketResourceYccFunds[rocketTokenId_][res_] -= yccAmount;
338 
339         ycc.payoutForMining(msg.sender, yccAmount);
340 
341         ResourcesTransfered(cityTokenId_, rocketTokenId_, res_, count_);
342     }
343     
344     /*
345         Resource Discovery
346     */
347     function discoveryCooldown(uint cityTokenId_) public view returns (uint _cooldownBlocks) {
348         uint totalVotes = subcontinentDiscoveryVoting.totalVotes();
349         if (totalVotes <= 0) 
350             totalVotes = 1;
351         uint range = discoveryCooldownMax-discoveryCooldownMin;
352         uint subcontinentId = cityTokenId_ % MAX_SUBCONTINENT_INDEX;
353         _cooldownBlocks = range - (subcontinentDiscoveryVoting.getVotes(subcontinentId).mul(range)).div(totalVotes) + discoveryCooldownMin;
354     }
355     function discoveryPrice(uint cityTokenId_) public view returns (uint _price) {
356         uint totalVotes = subcontinentDiscoveryVoting.totalVotes();
357         if (totalVotes <= 0) 
358             totalVotes = 1;
359         uint range = discoveryPriceMax-discoveryPriceMin;
360         uint subcontinentId = cityTokenId_ % MAX_SUBCONTINENT_INDEX;
361         _price = range - (subcontinentDiscoveryVoting.getVotes(subcontinentId).mul(range)).div(totalVotes) + discoveryPriceMin;
362     }
363 
364     function discoveryBlocksUntilAllowed(uint cityTokenId_) public view returns (uint _blocks) {
365         uint blockNextDiscoveryAllowed = discoveryLastBlock[cityTokenId_] + discoveryCooldown(cityTokenId_);
366         if (block.number > blockNextDiscoveryAllowed) {
367             _blocks = 0;
368         } else {
369             _blocks = blockNextDiscoveryAllowed - block.number;
370         }
371     }
372     
373     function discoverResources(uint cityTokenId_) public {
374         require(contractActive);
375         require(discoveryBlocksUntilAllowed(cityTokenId_) == 0);
376 
377         uint yccAmount = this.discoveryPrice(cityTokenId_);
378         ycc.payForUpgrade(msg.sender, yccAmount);
379         
380         discoveryLastBlock[cityTokenId_] = block.number;
381         
382         uint resourceRichnessLen = cityResourceRichness[cityTokenId_].length;
383         for (uint i = 0; i < resourceRichnessLen; i++) {
384             cityResourceCount[cityTokenId_][i] += cityResourceRichness[cityTokenId_][i];
385         }
386         ResourcesDiscovered(cityTokenId_);
387     }
388     
389     /*
390         Rockets
391     */
392     function rocketTravelTimeByResource(uint rocketTokenId_, uint res_) public view returns (uint _blocks) {
393         _blocks = rocketTravelTimeA * 6000 / rocketResourceCount[rocketTokenId_][res_];
394     }
395     function rocketTravelTime(uint rocketTokenId_) public view returns (uint _travelTimeBlocks) {
396         _travelTimeBlocks = rocketTravelTimeMinBlocks + rocketTravelTimeIncrease[rocketTokenId_];
397         
398         uint resourceLen = rocketResourceCount[rocketTokenId_].length;
399         for (uint i = 0; i < resourceLen; i++) {
400             _travelTimeBlocks += rocketTravelTimeA * 6000 / rocketResourceCount[rocketTokenId_][i];
401         }
402     }
403     function rocketBlocksUntilAllowedToLaunch() public view returns (uint _blocksUntilAllowed) {
404         if (block.number > rocketEarliestLaunchTime) {
405             _blocksUntilAllowed = 0;
406         } else {
407             _blocksUntilAllowed = rocketEarliestLaunchTime - block.number;
408         }
409     }
410     function rocketIsLaunched(uint rocketTokenId_) public view returns (bool _isLaunched) { 
411         _isLaunched = rocketLaunchBlock[rocketTokenId_] > 0;
412     }
413     function rocketArrivalTime(uint rocketTokenId_) public view returns (uint) {
414         require(rocketLaunchBlock[rocketTokenId_] > 0);
415         return rocketLaunchBlock[rocketTokenId_] + rocketTravelTimeAtLaunch[rocketTokenId_];
416     }
417     function increaseArrivalTime(uint rocketTokenId_, uint blocks) public onlyYCC {
418         if (rocketLaunchBlock[rocketTokenId_] > 0)
419             rocketTravelTimeAtLaunch[rocketTokenId_] = rocketTravelTimeAtLaunch[rocketTokenId_] + blocks;
420         else
421             rocketTravelTimeIncrease[rocketTokenId_] = rocketTravelTimeIncrease[rocketTokenId_] + blocks;
422     }
423     function decreaseArrivalTime(uint rocketTokenId_, uint blocks) public onlyYCC {
424         if (rocketLaunchBlock[rocketTokenId_] > 0)
425             rocketTravelTimeAtLaunch[rocketTokenId_] = rocketTravelTimeAtLaunch[rocketTokenId_] - blocks;
426         else
427             rocketTravelTimeIncrease[rocketTokenId_] = rocketTravelTimeIncrease[rocketTokenId_] - blocks;
428     }
429     function rocketTimeUntilMoon(uint rocketTokenId_) public view returns (uint _untilMoonBlocks) {
430         uint arrivalTime = rocketArrivalTime(rocketTokenId_);
431         if (block.number > arrivalTime) {
432             _untilMoonBlocks = 0;
433         } else {
434             _untilMoonBlocks = arrivalTime - block.number;
435         }
436     }
437     function rocketGetResourceValues(uint rocketTokenId_) public view returns (uint[] _yccAmounts, uint[] _resourcePrices, uint[] _resourceCounts) {
438         _yccAmounts = rocketResourceYccFunds[rocketTokenId_];
439         _resourcePrices = rocketResourcePrices[rocketTokenId_];
440         _resourceCounts = rocketResourceCount[rocketTokenId_];
441     }
442 
443 
444     function rocketSetResourcePrice(uint rocketTokenId_, uint res_, uint yccPrice_) public {
445         require(contractActive);
446         require(yct.ownerOf(rocketTokenId_)==msg.sender);
447         require(yccPrice_ > 0);
448         rocketResourcePrices[rocketTokenId_][res_] = yccPrice_;
449     }
450 
451     function rocketAddFunds(uint rocketTokenId_, uint res_, uint yccAmount_) public {
452         require(contractActive);
453         ycc.payForUpgrade(msg.sender, yccAmount_);
454         rocketResourceYccFunds[rocketTokenId_][res_] += yccAmount_;
455 
456         RocketAddFunds(rocketTokenId_, res_, yccAmount_, msg.sender);
457     }
458 
459     function rocketLaunch(uint rocketTokenId_) public {
460         require(contractActive);
461         require(block.number > rocketEarliestLaunchTime);
462         require(yct.ownerOf(rocketTokenId_)==msg.sender);
463 
464         rocketLaunchBlock[rocketTokenId_] = block.number;
465         rocketTravelTimeAtLaunch[rocketTokenId_] = rocketTravelTime(rocketTokenId_);
466 
467         RocketLaunch(rocketTokenId_);
468     }
469 }