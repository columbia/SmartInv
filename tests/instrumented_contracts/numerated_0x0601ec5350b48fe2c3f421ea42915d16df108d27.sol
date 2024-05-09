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
65 contract Pausable is Ownable {
66     event Pause();
67     event Unpause();
68 
69     bool public paused = false;
70 
71     modifier whenNotPaused() {
72         require(!paused, "contract is paused");
73         _;
74     }
75 
76     modifier whenPaused() {
77         require(paused, "contract is not paused");
78         _;
79     }
80 
81     function pause() public onlyOwner whenNotPaused {
82         paused = true;
83         emit Pause();
84     }
85 
86     function unpause() public onlyOwner whenPaused {
87         paused = false;
88         emit Unpause();
89     }
90 }
91 
92 contract Controllable is Ownable {
93     mapping(address => bool) controllers;
94 
95     modifier onlyController {
96         require(_isController(msg.sender), "no controller rights");
97         _;
98     }
99 
100     function _isController(address _controller) internal view returns (bool) {
101         return controllers[_controller];
102     }
103 
104     function _setControllers(address[] _controllers) internal {
105         for (uint256 i = 0; i < _controllers.length; i++) {
106             _validateAddress(_controllers[i]);
107             controllers[_controllers[i]] = true;
108         }
109     }
110 }
111 
112 contract Upgradable is Controllable {
113     address[] internalDependencies;
114     address[] externalDependencies;
115 
116     function getInternalDependencies() public view returns(address[]) {
117         return internalDependencies;
118     }
119 
120     function getExternalDependencies() public view returns(address[]) {
121         return externalDependencies;
122     }
123 
124     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
125         for (uint256 i = 0; i < _newDependencies.length; i++) {
126             _validateAddress(_newDependencies[i]);
127         }
128         internalDependencies = _newDependencies;
129     }
130 
131     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
132         externalDependencies = _newDependencies;
133         _setControllers(_newDependencies);
134     }
135 }
136 
137 contract HumanOriented {
138     modifier onlyHuman() {
139         require(msg.sender == tx.origin, "not a human");
140         _;
141     }
142 }
143 
144 contract Events {
145     function emitEggCreated(address, uint256) external;
146     function emitDragonOnSale(address, uint256) external;
147     function emitDragonRemovedFromSale(address, uint256) external;
148     function emitDragonRemovedFromBreeding(address, uint256) external;
149     function emitDragonOnBreeding(address, uint256) external;
150     function emitDragonBought(address, address, uint256, uint256) external;
151     function emitDragonBreedingBought(address, address, uint256, uint256) external;
152     function emitDistributionUpdated(uint256, uint256, uint256) external;
153     function emitEggOnSale(address, uint256) external;
154     function emitEggRemovedFromSale(address, uint256) external;
155     function emitEggBought(address, address, uint256, uint256) external;
156     function emitGoldSellOrderCreated(address, uint256, uint256) external;
157     function emitGoldSellOrderCancelled(address) external;
158     function emitGoldSold(address, address, uint256, uint256) external;
159     function emitGoldBuyOrderCreated(address, uint256, uint256) external;
160     function emitGoldBuyOrderCancelled(address) external;
161     function emitGoldBought(address, address, uint256, uint256) external;
162     function emitSkillOnSale(address, uint256) external;
163     function emitSkillRemovedFromSale(address, uint256) external;
164     function emitSkillBought(address, address, uint256, uint256, uint256) external;
165 }
166 
167 
168 contract MarketplaceController {
169     function buyEgg(address, uint256, uint256, uint256, bool) external returns (address, uint256, bool);
170     function sellEgg(address, uint256, uint256, uint256, uint16, bool) external;
171     function removeEggFromSale(address, uint256) external;
172     function buyDragon(address, uint256, uint256, uint256, bool) external returns (address, uint256, bool);
173     function sellDragon(address, uint256, uint256, uint256, uint16, bool) external;
174     function removeDragonFromSale(address, uint256) external;
175     function buyBreeding(address, uint256, uint256, uint256, uint256, bool) external returns (uint256, address, uint256, bool);
176     function sellBreeding(address, uint256, uint256, uint256, uint16, bool) external;
177     function removeBreedingFromSale(address, uint256) external;
178     function buySkill(address, uint256, uint256, uint256, uint32) external returns (address, uint256, bool);
179     function sellSkill(address, uint256, uint256) external;
180     function removeSkillFromSale(address, uint256) external;
181 }
182 
183 contract GoldMarketplace {
184     function createSellOrder(address, uint256, uint256) external;
185     function cancelSellOrder(address) external;
186     function fillSellOrder(address, uint256, address, uint256, uint256) external returns (uint256);
187     function createBuyOrder(address, uint256, uint256, uint256) external;
188     function cancelBuyOrder(address) external;
189     function fillBuyOrder(address, address, uint256, uint256) external returns (uint256);
190 }
191 
192 
193 
194 
195 //////////////CONTRACT//////////////
196 
197 
198 
199 
200 contract MainMarket is Pausable, Upgradable, HumanOriented {
201     using SafeMath256 for uint256;
202 
203     MarketplaceController public marketplaceController;
204     GoldMarketplace goldMarketplace;
205     Events events;
206 
207     // MARKETPLACE
208 
209     function _transferEth(
210         address _from,
211         address _to,
212         uint256 _available,
213         uint256 _required_,
214         bool _isGold
215     ) internal {
216         uint256 _required = _required_;
217         if (_isGold) {
218             _required = 0;
219         }
220 
221         _to.transfer(_required);
222         if (_available > _required) {
223             _from.transfer(_available.sub(_required));
224         }
225     }
226 
227     // EGG
228 
229     function buyEgg(
230         uint256 _id,
231         uint256 _expectedPrice,
232         bool _isGold
233     ) external onlyHuman whenNotPaused payable {
234         (
235             address _seller,
236             uint256 _price,
237             bool _success
238         ) = marketplaceController.buyEgg(
239             msg.sender,
240             msg.value,
241             _id,
242             _expectedPrice,
243             _isGold
244         );
245         if (_success) {
246             _transferEth(msg.sender, _seller, msg.value, _price, _isGold);
247             events.emitEggBought(msg.sender, _seller, _id, _price);
248         } else {
249             msg.sender.transfer(msg.value);
250             events.emitEggRemovedFromSale(_seller, _id);
251         }
252     }
253 
254     function sellEgg(
255         uint256 _id,
256         uint256 _maxPrice,
257         uint256 _minPrice,
258         uint16 _period,
259         bool _isGold
260     ) external onlyHuman whenNotPaused {
261         marketplaceController.sellEgg(msg.sender, _id, _maxPrice, _minPrice, _period, _isGold);
262         events.emitEggOnSale(msg.sender, _id);
263     }
264 
265     function removeEggFromSale(uint256 _id) external onlyHuman whenNotPaused {
266         marketplaceController.removeEggFromSale(msg.sender, _id);
267         events.emitEggRemovedFromSale(msg.sender, _id);
268     }
269 
270     // DRAGON
271 
272     function buyDragon(
273         uint256 _id,
274         uint256 _expectedPrice,
275         bool _isGold
276     ) external onlyHuman whenNotPaused payable {
277         (
278             address _seller,
279             uint256 _price,
280             bool _success
281         ) = marketplaceController.buyDragon(
282             msg.sender,
283             msg.value,
284             _id,
285             _expectedPrice,
286             _isGold
287         );
288         if (_success) {
289             _transferEth(msg.sender, _seller, msg.value, _price, _isGold);
290             events.emitDragonBought(msg.sender, _seller, _id, _price);
291         } else {
292             msg.sender.transfer(msg.value);
293             events.emitDragonRemovedFromSale(_seller, _id);
294         }
295     }
296 
297     function sellDragon(
298         uint256 _id,
299         uint256 _maxPrice,
300         uint256 _minPrice,
301         uint16 _period,
302         bool _isGold
303     ) external onlyHuman whenNotPaused {
304         marketplaceController.sellDragon(msg.sender, _id, _maxPrice, _minPrice, _period, _isGold);
305         events.emitDragonOnSale(msg.sender, _id);
306     }
307 
308     function removeDragonFromSale(uint256 _id) external onlyHuman whenNotPaused {
309         marketplaceController.removeDragonFromSale(msg.sender, _id);
310         events.emitDragonRemovedFromSale(msg.sender, _id);
311     }
312 
313     // BREEDING
314 
315     function buyBreeding(
316         uint256 _momId,
317         uint256 _dadId,
318         uint256 _expectedPrice,
319         bool _isGold
320     ) external onlyHuman whenNotPaused payable {
321         (
322             uint256 _eggId,
323             address _seller,
324             uint256 _price,
325             bool _success
326         ) = marketplaceController.buyBreeding(
327             msg.sender,
328             msg.value,
329             _momId,
330             _dadId,
331             _expectedPrice,
332             _isGold
333         );
334         if (_success) {
335             events.emitEggCreated(msg.sender, _eggId);
336             _transferEth(msg.sender, _seller, msg.value, _price, _isGold);
337             events.emitDragonBreedingBought(msg.sender, _seller, _dadId, _price);
338         } else {
339             msg.sender.transfer(msg.value);
340             events.emitDragonRemovedFromBreeding(_seller, _dadId);
341         }
342     }
343 
344     function sellBreeding(
345         uint256 _id,
346         uint256 _maxPrice,
347         uint256 _minPrice,
348         uint16 _period,
349         bool _isGold
350     ) external onlyHuman whenNotPaused {
351         marketplaceController.sellBreeding(msg.sender, _id, _maxPrice, _minPrice, _period, _isGold);
352         events.emitDragonOnBreeding(msg.sender, _id);
353     }
354 
355     function removeBreedingFromSale(uint256 _id) external onlyHuman whenNotPaused {
356         marketplaceController.removeBreedingFromSale(msg.sender, _id);
357         events.emitDragonRemovedFromBreeding(msg.sender, _id);
358     }
359 
360     // GOLD
361 
362     // SELL
363 
364     function fillGoldSellOrder(
365         address _seller,
366         uint256 _price,
367         uint256 _amount
368     ) external onlyHuman whenNotPaused payable {
369         address(goldMarketplace).transfer(msg.value);
370         uint256 _priceForOne = goldMarketplace.fillSellOrder(msg.sender, msg.value, _seller, _price, _amount);
371         events.emitGoldSold(msg.sender, _seller, _amount, _priceForOne);
372     }
373 
374     function createGoldSellOrder(
375         uint256 _price,
376         uint256 _amount
377     ) external onlyHuman whenNotPaused {
378         goldMarketplace.createSellOrder(msg.sender, _price, _amount);
379         events.emitGoldSellOrderCreated(msg.sender, _price, _amount);
380     }
381 
382     function cancelGoldSellOrder() external onlyHuman whenNotPaused {
383         goldMarketplace.cancelSellOrder(msg.sender);
384         events.emitGoldSellOrderCancelled(msg.sender);
385     }
386 
387     // BUY
388 
389     function fillGoldBuyOrder(
390         address _buyer,
391         uint256 _price,
392         uint256 _amount
393     ) external onlyHuman whenNotPaused {
394         uint256 _priceForOne = goldMarketplace.fillBuyOrder(msg.sender, _buyer, _price, _amount);
395         events.emitGoldBought(msg.sender, _buyer, _amount, _priceForOne);
396     }
397 
398     function createGoldBuyOrder(
399         uint256 _price,
400         uint256 _amount
401     ) external onlyHuman whenNotPaused payable {
402         address(goldMarketplace).transfer(msg.value);
403         goldMarketplace.createBuyOrder(msg.sender, msg.value, _price, _amount);
404         events.emitGoldBuyOrderCreated(msg.sender, _price, _amount);
405     }
406 
407     function cancelGoldBuyOrder() external onlyHuman whenNotPaused {
408         goldMarketplace.cancelBuyOrder(msg.sender);
409         events.emitGoldBuyOrderCancelled(msg.sender);
410     }
411 
412     // SKILL
413 
414     function buySkill(
415         uint256 _id,
416         uint256 _target,
417         uint256 _expectedPrice,
418         uint32 _expectedEffect
419     ) external onlyHuman whenNotPaused {
420         (
421             address _seller,
422             uint256 _price,
423             bool _success
424         ) = marketplaceController.buySkill(
425             msg.sender,
426             _id,
427             _target,
428             _expectedPrice,
429             _expectedEffect
430         );
431 
432         if (_success) {
433             events.emitSkillBought(msg.sender, _seller, _id, _target, _price);
434         } else {
435             events.emitSkillRemovedFromSale(_seller, _id);
436         }
437     }
438 
439     function sellSkill(
440         uint256 _id,
441         uint256 _price
442     ) external onlyHuman whenNotPaused {
443         marketplaceController.sellSkill(msg.sender, _id, _price);
444         events.emitSkillOnSale(msg.sender, _id);
445     }
446 
447     function removeSkillFromSale(uint256 _id) external onlyHuman whenNotPaused {
448         marketplaceController.removeSkillFromSale(msg.sender, _id);
449         events.emitSkillRemovedFromSale(msg.sender, _id);
450     }
451 
452     // UPDATE CONTRACT
453 
454     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
455         super.setInternalDependencies(_newDependencies);
456 
457         marketplaceController = MarketplaceController(_newDependencies[0]);
458         goldMarketplace = GoldMarketplace(_newDependencies[1]);
459         events = Events(_newDependencies[2]);
460     }
461 }