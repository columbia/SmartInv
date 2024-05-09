1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC-721 Non-Fungible Token Standard
5  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
6  */
7 contract ERC721 {
8     // Required methods
9     function totalSupply() public view returns (uint256 total);
10     function balanceOf(address _owner) public view returns (uint256 balance);
11     function ownerOf(uint256 _tokenId) external view returns (address owner);
12     function approve(address _to, uint256 _tokenId) external;
13     function transfer(address _to, uint256 _tokenId) external;
14     function transferFrom(address _from, address _to, uint256 _tokenId) external;
15 
16     // Events
17     event Transfer(address from, address to, uint256 tokenId);
18     event Approval(address owner, address approved, uint256 tokenId);
19 }
20 
21 contract AccessControl {
22 
23     event ContractUpgrade(address newContract);
24 
25     address public addressDev;
26     address public addressFin;
27     address public addressOps;
28 
29     modifier onlyDeveloper() {
30         require(msg.sender == addressDev);
31         _;
32     }
33 
34     modifier onlyFinance() {
35         require(msg.sender == addressFin);
36         _;
37     }
38 
39     modifier onlyOperation() {
40         require(msg.sender == addressOps);
41         _;
42     }
43 
44     modifier onlyTeamMembers() {
45         require(
46             msg.sender == addressDev ||
47             msg.sender == addressFin ||
48             msg.sender == addressOps
49         );
50         _;
51     }
52 
53     function setDeveloper(address _newDeveloper) external onlyDeveloper {
54         require(_newDeveloper != address(0));
55 
56         addressDev = _newDeveloper;
57     }
58 
59     function setFinance(address _newFinance) external onlyDeveloper {
60         require(_newFinance != address(0));
61 
62         addressFin = _newFinance;
63     }
64 
65     function setOperation(address _newOperation) external onlyDeveloper {
66         require(_newOperation != address(0));
67 
68         addressOps = _newOperation;
69     }
70 }
71 
72 contract Ownable {
73   address public owner;
74 
75   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77   function Ownable() public {
78     owner = msg.sender;
79   }
80 
81   modifier onlyOwner() {
82     require(msg.sender == owner);
83     _;
84   }
85 
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92 }
93 
94 contract Pausable is Ownable {
95   event Pause();
96   event Unpause();
97 
98   bool public paused = false;
99 
100   modifier whenNotPaused() {
101     require(!paused);
102     _;
103   }
104 
105   modifier whenPaused() {
106     require(paused);
107     _;
108   }
109 
110   function pause() onlyOwner whenNotPaused public {
111     paused = true;
112     Pause();
113   }
114 
115   function unpause() onlyOwner whenPaused public {
116     paused = false;
117     Unpause();
118   }
119 }
120 
121 // Basic mineral operations and counters, defines the constructor
122 contract MineralBase is AccessControl, Pausable {
123 
124     bool public isPresale = true;
125 
126     uint16 public discounts = 10000;
127     uint32 constant TOTAL_SUPPLY = 8888888;
128     uint32 public oresLeft;
129     uint32 gemsLeft;
130 
131     // Price of ORE (50 pieces in presale, only 1 afterwards)
132     uint64 public orePrice = 1e16;
133 
134     mapping(address => uint) internal ownerOreCount;
135 
136     // Constructor
137     function MineralBase() public {
138 
139         // Assign ownership to the creator
140         owner = msg.sender;
141         addressDev = owner;
142         addressFin = owner;
143         addressOps = owner;
144 
145         // Initializing counters
146         oresLeft = TOTAL_SUPPLY;
147         gemsLeft = TOTAL_SUPPLY;
148 
149         // Transfering ORES to the team
150         ownerOreCount[msg.sender] += oresLeft / 2;
151         oresLeft = oresLeft / 2;
152     }
153 
154     function balanceOfOre(address _owner) public view returns (uint256 _balance) {
155         return ownerOreCount[_owner];
156     }
157 
158     function sendOre(address _recipient, uint _amount) external payable {
159         require(balanceOfOre(msg.sender) >= _amount);
160         ownerOreCount[msg.sender] -= _amount;
161         ownerOreCount[_recipient] += _amount;
162     }
163 
164     function endPresale() onlyTeamMembers external {
165         isPresale = false;
166         discounts = 0;
167     }
168 }
169 
170 // The Factory holds the defined counts and provides an exclusive operations
171 contract MineralFactory is MineralBase {
172 
173     uint8 constant MODULUS = 100;
174     uint8 constant CATEGORY_COUNT = 50;
175     uint64 constant EXTRACT_PRICE = 1e16;
176 
177     uint32[] mineralCounts = [
178         8880, 9768, 10744, 11819, 13001,
179         19304, 21234, 23358, 25694, 28263,
180         28956, 31852, 35037, 38541, 42395,
181         43434, 47778, 52556, 57811, 63592,
182         65152, 71667, 78834, 86717, 95389,
183         97728, 107501, 118251, 130076, 143084,
184         146592, 161251, 177377, 195114, 214626,
185         219888, 241877, 266065, 292672, 321939,
186         329833, 362816, 399098, 439008, 482909,
187         494750, 544225, 598647, 658512, 724385];
188 
189     uint64[] polishingPrice = [
190         200e16, 180e16, 160e16, 130e16, 100e16,
191         80e16, 60e16, 40e16, 20e16, 5e16];
192 
193     mapping(address => uint) internal ownerGemCount;
194     mapping (uint256 => address) public gemIndexToOwner;
195     mapping (uint256 => address) public gemIndexToApproved;
196 
197     Gemstone[] public gemstones;
198 
199     struct Gemstone {
200         uint category;
201         string name;
202         uint256 colour;
203         uint64 extractionTime;
204         uint64 polishedTime;
205         uint256 price;
206     }
207 
208     function _getRandomMineralId() private view returns (uint32) {
209         return uint32(uint256(keccak256(block.timestamp, block.difficulty))%oresLeft);
210     }
211 
212      function _getPolishingPrice(uint _category) private view returns (uint) {
213         return polishingPrice[_category / 5];
214     }
215 
216     function _generateRandomHash(string _str) private view returns (uint) {
217         uint rand = uint(keccak256(_str));
218         return rand % MODULUS;
219     }
220 
221     function _getCategoryIdx(uint position) private view returns (uint8) {
222         uint32 tempSum = 0;
223         //Chosen category index, 255 for no category selected - when we are out of minerals
224         uint8 chosenIdx = 255;
225 
226         for (uint8 i = 0; i < mineralCounts.length; i++) {
227             uint32 value = mineralCounts[i];
228             tempSum += value;
229             if (tempSum > position) {
230                 //Mineral counts is 50, so this is safe to do
231                 chosenIdx = i;
232                 break;
233             }
234         }
235         return chosenIdx;
236     }
237 
238     function extractOre(string _name) external payable returns (uint8, uint256) {
239         require(gemsLeft > 0);
240         require(msg.value >= EXTRACT_PRICE);
241         require(ownerOreCount[msg.sender] > 0);
242 
243         uint32 randomNumber = _getRandomMineralId();
244         uint8 categoryIdx = _getCategoryIdx(randomNumber);
245 
246         require(categoryIdx < CATEGORY_COUNT);
247 
248         //Decrease the mineral count for the category
249         mineralCounts[categoryIdx] = mineralCounts[categoryIdx] - 1;
250         //Decrease total mineral count
251         gemsLeft = gemsLeft - 1;
252 
253         Gemstone memory _stone = Gemstone({
254             category : categoryIdx,
255             name : _name,
256             colour : _generateRandomHash(_name),
257             extractionTime : uint64(block.timestamp),
258             polishedTime : 0,
259             price : 0
260         });
261 
262         uint256 newStoneId = gemstones.push(_stone) - 1;
263 
264         ownerOreCount[msg.sender]--;
265         ownerGemCount[msg.sender]++;
266         gemIndexToOwner[newStoneId] = msg.sender;
267 
268         return (categoryIdx, _stone.colour);
269     }
270 
271     function polishRoughStone(uint256 _gemId) external payable {
272         uint gainedWei = msg.value;
273         require(gemIndexToOwner[_gemId] == msg.sender);
274 
275         Gemstone storage gem = gemstones[_gemId];
276         require(gem.polishedTime == 0);
277         require(gainedWei >= _getPolishingPrice(gem.category));
278 
279         gem.polishedTime = uint64(block.timestamp);
280     }
281 }
282 
283 // The Ownership contract makes sure the requirements of the NFT are met
284 contract MineralOwnership is MineralFactory, ERC721 {
285 
286     string public constant name = "CryptoMinerals";
287     string public constant symbol = "GEM";
288 
289     function _owns(address _claimant, uint256 _gemId) internal view returns (bool) {
290         return gemIndexToOwner[_gemId] == _claimant;
291     }
292 
293     // Assigns ownership of a specific gem to an address.
294     function _transfer(address _from, address _to, uint256 _gemId) internal {
295         require(_from != address(0));
296         require(_to != address(0));
297 
298         ownerGemCount[_from]--;
299         ownerGemCount[_to]++;
300         gemIndexToOwner[_gemId] = _to;
301         Transfer(_from, _to, _gemId);
302     }
303 
304     function _approvedFor(address _claimant, uint256 _gemId) internal view returns (bool) {
305         return gemIndexToApproved[_gemId] == _claimant;
306     }
307 
308     function _approve(uint256 _gemId, address _approved) internal {
309         gemIndexToApproved[_gemId] = _approved;
310     }
311 
312     // Required for ERC-721 compliance
313     function balanceOf(address _owner) public view returns (uint256 count) {
314         return ownerGemCount[_owner];
315     }
316 
317     // Required for ERC-721 compliance.
318     function transfer(address _to, uint256 _gemId) external whenNotPaused {
319         require(_to != address(0));
320         require(_to != address(this));
321 
322         require(_owns(msg.sender, _gemId));
323         _transfer(msg.sender, _to, _gemId);
324     }
325 
326     // Required for ERC-721 compliance.
327     function approve(address _to, uint256 _gemId) external whenNotPaused {
328         require(_owns(msg.sender, _gemId));
329         _approve(_gemId, _to);
330         Approval(msg.sender, _to, _gemId);
331     }
332 
333     // Required for ERC-721 compliance.
334     function transferFrom(address _from, address _to, uint256 _gemId) external whenNotPaused {
335         require(_to != address(0));
336         require(_to != address(this));
337 
338         require(_approvedFor(msg.sender, _gemId));
339         require(_owns(_from, _gemId));
340 
341         _transfer(_from, _to, _gemId);
342     }
343 
344     // Required for ERC-721 compliance.
345     function totalSupply() public view returns (uint) {
346         return TOTAL_SUPPLY - gemsLeft;
347     }
348 
349     // Required for ERC-721 compliance.
350     function ownerOf(uint256 _gemId) external view returns (address owner) {
351         owner = gemIndexToOwner[_gemId];
352         require(owner != address(0));
353     }
354 
355     // Required for ERC-721 compliance.
356     function implementsERC721() public view returns (bool implementsERC721) {
357         return true;
358     }
359 
360     function gemsOfOwner(address _owner) external view returns(uint256[] ownerGems) {
361         uint256 gemCount = balanceOf(_owner);
362 
363         if (gemCount == 0) {
364             return new uint256[](0);
365         } else {
366             uint256[] memory result = new uint256[](gemCount);
367             uint256 totalGems = totalSupply();
368             uint256 resultIndex = 0;
369             uint256 gemId;
370 
371             for (gemId = 0; gemId <= totalGems; gemId++) {
372                 if (gemIndexToOwner[gemId] == _owner) {
373                     result[resultIndex] = gemId;
374                     resultIndex++;
375                 }
376             }
377 
378             return result;
379         }
380     }
381 }
382 
383 // This contract introduces functionalities for the basic trading
384 contract MineralMarket is MineralOwnership {
385 
386     function buyOre() external payable {
387         require(msg.sender != address(0));
388         require(msg.value >= orePrice);
389         require(oresLeft > 0);
390 
391         uint8 amount;
392         if (isPresale) {
393             require(discounts > 0);
394             amount = 50;
395             discounts--;
396         } else {
397             amount = 1;
398         }
399         oresLeft -= amount;
400         ownerOreCount[msg.sender] += amount;
401     }
402 
403     function buyGem(uint _gemId) external payable {
404         uint gainedWei = msg.value;
405         require(msg.sender != address(0));
406         require(_gemId < gemstones.length);
407         require(gemIndexToOwner[_gemId] == address(this));
408 
409         Gemstone storage gem = gemstones[_gemId];
410         require(gainedWei >= gem.price);
411 
412         _transfer(address(this), msg.sender, _gemId);
413     }
414 
415    function mintGem(uint _categoryIdx, string _name, uint256 _colour, bool _polished, uint256 _price) onlyTeamMembers external {
416 
417         require(gemsLeft > 0);
418         require(_categoryIdx < CATEGORY_COUNT);
419 
420         //Decrease the mineral count for the category if not PROMO gem
421         if (_categoryIdx < CATEGORY_COUNT){
422              mineralCounts[_categoryIdx] = mineralCounts[_categoryIdx] - 1;
423         }
424 
425         uint64 stamp = 0;
426         if (_polished) {
427             stamp = uint64(block.timestamp);
428         }
429 
430         //Decrease counters
431         gemsLeft = gemsLeft - 1;
432         oresLeft--;
433 
434         Gemstone memory _stone = Gemstone({
435             category : _categoryIdx,
436             name : _name,
437             colour : _colour,
438             extractionTime : uint64(block.timestamp),
439             polishedTime : stamp,
440             price : _price
441         });
442 
443         uint256 newStoneId = gemstones.push(_stone) - 1;
444         ownerGemCount[address(this)]++;
445         gemIndexToOwner[newStoneId] = address(this);
446     }
447 
448     function setPrice(uint256 _gemId, uint256 _price) onlyTeamMembers external {
449         require(_gemId < gemstones.length);
450         Gemstone storage gem = gemstones[_gemId];
451         gem.price = uint64(_price);
452     }
453 
454     function setMyPrice(uint256 _gemId, uint256 _price) external {
455         require(_gemId < gemstones.length);
456         require(gemIndexToOwner[_gemId] == msg.sender);
457         Gemstone storage gem = gemstones[_gemId];
458         gem.price = uint64(_price);
459     }
460 
461     function withdrawBalance() onlyTeamMembers external {
462         bool res = owner.send(address(this).balance);
463     }
464 }