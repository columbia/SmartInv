1 pragma solidity 0.4.25;
2 
3 library SafeMath256 {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29     function pow(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) return 0;
31         if (b == 0) return 1;
32 
33         uint256 c = a ** b;
34         assert(c / (a ** (b - 1)) == a);
35         return c;
36     }
37 }
38 
39 contract Ownable {
40     address public owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     function _validateAddress(address _addr) internal pure {
45         require(_addr != address(0), "invalid address");
46     }
47 
48     constructor() public {
49         owner = msg.sender;
50     }
51 
52     modifier onlyOwner() {
53         require(msg.sender == owner, "not a contract owner");
54         _;
55     }
56 
57     function transferOwnership(address newOwner) public onlyOwner {
58         _validateAddress(newOwner);
59         emit OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61     }
62 
63 }
64 
65 contract Controllable is Ownable {
66     mapping(address => bool) controllers;
67 
68     modifier onlyController {
69         require(_isController(msg.sender), "no controller rights");
70         _;
71     }
72 
73     function _isController(address _controller) internal view returns (bool) {
74         return controllers[_controller];
75     }
76 
77     function _setControllers(address[] _controllers) internal {
78         for (uint256 i = 0; i < _controllers.length; i++) {
79             _validateAddress(_controllers[i]);
80             controllers[_controllers[i]] = true;
81         }
82     }
83 }
84 
85 contract Upgradable is Controllable {
86     address[] internalDependencies;
87     address[] externalDependencies;
88 
89     function getInternalDependencies() public view returns(address[]) {
90         return internalDependencies;
91     }
92 
93     function getExternalDependencies() public view returns(address[]) {
94         return externalDependencies;
95     }
96 
97     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
98         for (uint256 i = 0; i < _newDependencies.length; i++) {
99             _validateAddress(_newDependencies[i]);
100         }
101         internalDependencies = _newDependencies;
102     }
103 
104     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
105         externalDependencies = _newDependencies;
106         _setControllers(_newDependencies);
107     }
108 }
109 
110 contract Core {
111     function breed(address, uint256, uint256) external returns (uint256);
112     function isEggInNest(uint256) external view returns (bool);
113     function useDragonSpecialPeacefulSkill(address, uint256, uint256) external;
114 }
115 
116 contract Marketplace {
117     function sellToken(uint256, address, uint256, uint256, uint16, bool) external;
118     function removeFromAuction(uint256) external;
119     function buyToken(uint256, uint256, uint256, bool) external returns (uint256);
120     function sellerOf(uint256) external view returns (address);
121 }
122 
123 contract EggMarketplace is Marketplace {}
124 contract DragonMarketplace is Marketplace {}
125 contract BreedingMarketplace is Marketplace {}
126 
127 contract GoldMarketplace {}
128 
129 contract SkillMarketplace is Upgradable {
130     function sellToken(uint256, uint256) external;
131     function removeFromAuction(uint256) external;
132     function getAuction(uint256) external view returns (uint256);
133 }
134 
135 contract ERC721Token {
136     function ownerOf(uint256) public view returns (address);
137     function exists(uint256) public view returns (bool);
138     function remoteApprove(address, uint256) external;
139     function isApprovedOrOwner(address, uint256) public view returns (bool);
140     function transferFrom(address, address, uint256) public;
141 }
142 
143 contract DragonStorage is ERC721Token {}
144 contract EggStorage is ERC721Token {}
145 
146 contract ERC20 {
147     function balanceOf(address) public view returns (uint256);
148 }
149 
150 contract Gold is ERC20 {
151     function remoteTransfer(address, uint256) external;
152 }
153 
154 contract Getter {
155     function isDragonBreedingAllowed(uint256) external view returns (bool);
156     function getDragonSpecialPeacefulSkill(uint256) external view returns (uint8, uint32, uint32);
157     function isDragonInGladiatorBattle(uint256) public view returns (bool);
158 }
159 
160 
161 
162 
163 //////////////CONTRACT//////////////
164 
165 
166 
167 
168 contract MarketplaceController is Upgradable {
169     using SafeMath256 for uint256;
170 
171     Core core;
172     BreedingMarketplace breedingMarketplace;
173     EggMarketplace eggMarketplace;
174     DragonMarketplace dragonMarketplace;
175     GoldMarketplace goldMarketplace;
176     SkillMarketplace skillMarketplace;
177     DragonStorage dragonStorage;
178     EggStorage eggStorage;
179     Gold goldTokens;
180     Getter getter;
181 
182     // ACTIONS WITH OWN TOKEN
183 
184     function _isEggOwner(address _user, uint256 _tokenId) internal view returns (bool) {
185         return _user == eggStorage.ownerOf(_tokenId);
186     }
187 
188     function _isDragonOwner(address _user, uint256 _tokenId) internal view returns (bool) {
189         return _user == dragonStorage.ownerOf(_tokenId);
190     }
191 
192     function _checkOwner(bool _isOwner) internal pure {
193         require(_isOwner, "not an owner");
194     }
195 
196     function _checkEggOwner(uint256 _tokenId, address _user) internal view {
197         _checkOwner(_isEggOwner(_user, _tokenId));
198     }
199 
200     function _checkDragonOwner(uint256 _tokenId, address _user) internal view {
201         _checkOwner(_isDragonOwner(_user, _tokenId));
202     }
203 
204     function _compareBuyerAndSeller(address _buyer, address _seller) internal pure {
205         require(_buyer != _seller, "seller can't be buyer");
206     }
207 
208     function _checkTheDragonIsNotInGladiatorBattle(uint256 _id) internal view {
209         require(!getter.isDragonInGladiatorBattle(_id), "dragon participates in gladiator battle");
210     }
211 
212     function _checkIfBreedingIsAllowed(uint256 _id) internal view {
213         require(getter.isDragonBreedingAllowed(_id), "dragon has no enough DNA points for breeding");
214     }
215 
216     function _checkEnoughGold(uint256 _required, uint256 _available) internal pure {
217         require(_required <= _available, "not enough gold");
218     }
219 
220     function _safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
221         return b > a ? 0 : a.sub(b);
222     }
223 
224     // MARKETPLACE
225 
226     function _transferGold(address _to, uint256 _value) internal {
227         goldTokens.remoteTransfer(_to, _value);
228     }
229 
230     // EGG
231 
232     function buyEgg(
233         address _sender,
234         uint256 _value,
235         uint256 _id,
236         uint256 _expectedPrice,
237         bool _isGold
238     ) external onlyController returns (address seller, uint256 price, bool success) {
239         seller = eggMarketplace.sellerOf(_id);
240         _compareBuyerAndSeller(_sender, seller);
241 
242         if (eggStorage.isApprovedOrOwner(this, _id) && _isEggOwner(seller, _id)) {
243             uint256 _balance = goldTokens.balanceOf(_sender);
244             price = eggMarketplace.buyToken(_id, _isGold ? _balance : _value, _expectedPrice, _isGold);
245             eggStorage.transferFrom(seller, _sender, _id);
246             if (_isGold) {
247                 _transferGold(seller, price);
248             }
249             success = true;
250         } else {
251             eggMarketplace.removeFromAuction(_id);
252             success = false;
253         }
254     }
255 
256     function sellEgg(
257         address _sender,
258         uint256 _id,
259         uint256 _maxPrice,
260         uint256 _minPrice,
261         uint16 _period,
262         bool _isGold
263     ) external onlyController {
264         _checkEggOwner(_id, _sender);
265         require(!core.isEggInNest(_id), "egg is in nest");
266         eggStorage.remoteApprove(this, _id);
267         eggMarketplace.sellToken(_id, _sender, _maxPrice, _minPrice, _period, _isGold);
268     }
269 
270     function removeEggFromSale(
271         address _sender,
272         uint256 _id
273     ) external onlyController {
274         _checkEggOwner(_id, _sender);
275         eggMarketplace.removeFromAuction(_id);
276     }
277 
278     // DRAGON
279 
280     function buyDragon(
281         address _sender,
282         uint256 _value,
283         uint256 _id,
284         uint256 _expectedPrice,
285         bool _isGold
286     ) external onlyController returns (address seller, uint256 price, bool success) {
287         seller = dragonMarketplace.sellerOf(_id);
288         _compareBuyerAndSeller(_sender, seller);
289 
290         if (dragonStorage.isApprovedOrOwner(this, _id) && _isDragonOwner(seller, _id)) {
291             uint256 _balance = goldTokens.balanceOf(_sender);
292             price = dragonMarketplace.buyToken(_id, _isGold ? _balance : _value, _expectedPrice, _isGold);
293             dragonStorage.transferFrom(seller, _sender, _id);
294             if (_isGold) {
295                 _transferGold(seller, price);
296             }
297             success = true;
298         } else {
299             dragonMarketplace.removeFromAuction(_id);
300             success = false;
301         }
302     }
303 
304     function sellDragon(
305         address _sender,
306         uint256 _id,
307         uint256 _maxPrice,
308         uint256 _minPrice,
309         uint16 _period,
310         bool _isGold
311     ) external onlyController {
312         _checkDragonOwner(_id, _sender);
313         _checkTheDragonIsNotInGladiatorBattle(_id);
314         require(breedingMarketplace.sellerOf(_id) == address(0), "dragon is on breeding sale");
315         dragonStorage.remoteApprove(this, _id);
316 
317         dragonMarketplace.sellToken(_id, _sender, _maxPrice, _minPrice, _period, _isGold);
318     }
319 
320     function removeDragonFromSale(
321         address _sender,
322         uint256 _id
323     ) external onlyController {
324         _checkDragonOwner(_id, _sender);
325         dragonMarketplace.removeFromAuction(_id);
326     }
327 
328     // BREEDING
329 
330     function buyBreeding(
331         address _sender,
332         uint256 _value,
333         uint256 _momId,
334         uint256 _dadId,
335         uint256 _expectedPrice,
336         bool _isGold
337     ) external onlyController returns (uint256 eggId, address seller, uint256 price, bool success) {
338         _checkIfBreedingIsAllowed(_momId);
339         require(_momId != _dadId, "the same dragon");
340         _checkDragonOwner(_momId, _sender);
341         seller = breedingMarketplace.sellerOf(_dadId);
342         _compareBuyerAndSeller(_sender, seller);
343 
344         if (getter.isDragonBreedingAllowed(_dadId) && _isDragonOwner(seller, _dadId)) {
345             uint256 _balance = goldTokens.balanceOf(_sender);
346             price = breedingMarketplace.buyToken(_dadId, _isGold ? _balance : _value, _expectedPrice, _isGold);
347             eggId = core.breed(_sender, _momId, _dadId);
348             if (_isGold) {
349                 _transferGold(seller, price);
350             }
351             success = true;
352         } else {
353             breedingMarketplace.removeFromAuction(_dadId);
354             success = false;
355         }
356     }
357 
358     function sellBreeding(
359         address _sender,
360         uint256 _id,
361         uint256 _maxPrice,
362         uint256 _minPrice,
363         uint16 _period,
364         bool _isGold
365     ) external onlyController {
366         _checkIfBreedingIsAllowed(_id);
367         _checkDragonOwner(_id, _sender);
368         _checkTheDragonIsNotInGladiatorBattle(_id);
369         require(dragonMarketplace.sellerOf(_id) == address(0), "dragon is on sale");
370         breedingMarketplace.sellToken(_id, _sender, _maxPrice, _minPrice, _period, _isGold);
371     }
372 
373     function removeBreedingFromSale(
374         address _sender,
375         uint256 _id
376     ) external onlyController {
377         _checkDragonOwner(_id, _sender);
378         breedingMarketplace.removeFromAuction(_id);
379     }
380 
381     // SKILL
382 
383     function buySkill(
384         address _sender,
385         uint256 _id,
386         uint256 _target,
387         uint256 _expectedPrice,
388         uint32 _expectedEffect
389     ) external onlyController returns (address seller, uint256 price, bool success) {
390         if (dragonStorage.exists(_id)) {
391             price = skillMarketplace.getAuction(_id);
392             seller = dragonStorage.ownerOf(_id);
393             _compareBuyerAndSeller(_sender, seller);
394             _checkTheDragonIsNotInGladiatorBattle(_id);
395             _checkTheDragonIsNotInGladiatorBattle(_target);
396 
397             require(price <= _expectedPrice, "wrong price");
398             uint256 _balance = goldTokens.balanceOf(_sender);
399             _checkEnoughGold(price, _balance);
400 
401             ( , , uint32 _effect) = getter.getDragonSpecialPeacefulSkill(_id);
402             require(_effect >= _expectedEffect, "effect decreased");
403 
404             core.useDragonSpecialPeacefulSkill(seller, _id, _target);
405 
406             _transferGold(seller, price);
407             success = true;
408         } else {
409             skillMarketplace.removeFromAuction(_id);
410             success = false;
411         }
412     }
413 
414     function sellSkill(
415         address _sender,
416         uint256 _id,
417         uint256 _price
418     ) external onlyController {
419         _checkDragonOwner(_id, _sender);
420         _checkTheDragonIsNotInGladiatorBattle(_id);
421         (uint8 _skillClass, , ) = getter.getDragonSpecialPeacefulSkill(_id);
422         require(_skillClass > 0, "special peaceful skill is not yet set");
423 
424         skillMarketplace.sellToken(_id, _price);
425     }
426 
427     function removeSkillFromSale(
428         address _sender,
429         uint256 _id
430     ) external onlyController {
431         _checkDragonOwner(_id, _sender);
432         skillMarketplace.removeFromAuction(_id);
433     }
434 
435     // UPDATE CONTRACT
436 
437     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
438         super.setInternalDependencies(_newDependencies);
439 
440         core = Core(_newDependencies[0]);
441         dragonStorage = DragonStorage(_newDependencies[1]);
442         eggStorage = EggStorage(_newDependencies[2]);
443         dragonMarketplace = DragonMarketplace(_newDependencies[3]);
444         breedingMarketplace = BreedingMarketplace(_newDependencies[4]);
445         eggMarketplace = EggMarketplace(_newDependencies[5]);
446         goldMarketplace = GoldMarketplace(_newDependencies[6]);
447         skillMarketplace = SkillMarketplace(_newDependencies[7]);
448         goldTokens = Gold(_newDependencies[8]);
449         getter = Getter(_newDependencies[9]);
450     }
451 }