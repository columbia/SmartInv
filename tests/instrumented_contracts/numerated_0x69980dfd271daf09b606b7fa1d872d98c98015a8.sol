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
111     function isEggOwner(address, uint256) external view returns (bool);
112     function createEgg(address, uint8) external returns (uint256);
113     function sendToNest(uint256) external returns (bool, uint256, uint256, address);
114     function openEgg(address, uint256, uint256) internal returns (uint256);
115     function breed(address, uint256, uint256) external returns (uint256);
116     function setDragonRemainingHealthAndMana(uint256, uint32, uint32) external;
117     function increaseDragonExperience(uint256, uint256) external;
118     function upgradeDragonGenes(uint256, uint16[10]) external;
119     function increaseDragonWins(uint256) external;
120     function increaseDragonDefeats(uint256) external;
121     function setDragonTactics(uint256, uint8, uint8) external;
122     function setDragonName(uint256, string) external returns (bytes32);
123     function setDragonSpecialPeacefulSkill(uint256, uint8) external;
124     function useDragonSpecialPeacefulSkill(address, uint256, uint256) external;
125     function updateLeaderboardRewardTime() external;
126     function getDragonsFromLeaderboard() external view returns (uint256[10]);
127     function getLeaderboardRewards(uint256) external view returns (uint256[10]);
128 }
129 
130 contract Treasury {
131     uint256 public hatchingPrice;
132     function giveGold(address, uint256) external;
133     function takeGold(uint256) external;
134     function burnGold(uint256) external;
135     function remainingGold() external view returns (uint256);
136 }
137 
138 contract Getter {
139     function getDragonsAmount() external view returns (uint256);
140     function isDragonBreedingAllowed(uint256) external view returns (bool);
141     function getDragonNamePriceByLength(uint256) external view returns (uint256);
142     function isEggOnSale(uint256) external view returns (bool);
143     function isDragonOnSale(uint256) public view returns (bool);
144     function isBreedingOnSale(uint256) public view returns (bool);
145     function isDragonOwner(address, uint256) external view returns (bool);
146     function ownerOfDragon(uint256) public view returns (address);
147     function isDragonInGladiatorBattle(uint256) public view returns (bool);
148 }
149 
150 contract Distribution {
151     function claim(uint8) external returns (uint256, uint256, uint256);
152 }
153 
154 
155 
156 
157 //////////////CONTRACT//////////////
158 
159 
160 
161 
162 contract CoreController is Upgradable {
163     using SafeMath256 for uint256;
164 
165     Core core;
166     Treasury treasury;
167     Getter getter;
168     Distribution distribution;
169 
170     function _isDragonOwner(address _user, uint256 _id) internal view returns (bool) {
171         return getter.isDragonOwner(_user, _id);
172     }
173 
174     function _checkTheDragonIsNotInGladiatorBattle(uint256 _id) internal view {
175         require(!getter.isDragonInGladiatorBattle(_id), "dragon participates in gladiator battle");
176     }
177 
178     function _checkTheDragonIsNotOnSale(uint256 _id) internal view {
179         require(!getter.isDragonOnSale(_id), "dragon is on sale");
180     }
181 
182     function _checkTheDragonIsNotOnBreeding(uint256 _id) internal view {
183         require(!getter.isBreedingOnSale(_id), "dragon is on breeding sale");
184     }
185 
186     function _checkThatEnoughDNAPoints(uint256 _id) internal view {
187         require(getter.isDragonBreedingAllowed(_id), "dragon has no enough DNA points for breeding");
188     }
189 
190     function _checkDragonOwner(address _user, uint256 _id) internal view {
191         require(_isDragonOwner(_user, _id), "not an owner");
192     }
193 
194     function claimEgg(
195         address _sender,
196         uint8 _dragonType
197     ) external onlyController returns (
198         uint256 eggId,
199         uint256 restAmount,
200         uint256 lastBlock,
201         uint256 interval
202     ) {
203         (restAmount, lastBlock, interval) = distribution.claim(_dragonType);
204         eggId = core.createEgg(_sender, _dragonType);
205 
206         uint256 _goldReward = treasury.hatchingPrice();
207         uint256 _goldAmount = treasury.remainingGold();
208         if (_goldReward > _goldAmount) _goldReward = _goldAmount;
209         treasury.giveGold(_sender, _goldReward);
210     }
211 
212     // ACTIONS WITH OWN TOKEN
213 
214     function sendToNest(
215         address _sender,
216         uint256 _eggId
217     ) external onlyController returns (bool, uint256, uint256, address) {
218         require(!getter.isEggOnSale(_eggId), "egg is on sale");
219         require(core.isEggOwner(_sender, _eggId), "not an egg owner");
220 
221         uint256 _hatchingPrice = treasury.hatchingPrice();
222         treasury.takeGold(_hatchingPrice);
223         if (getter.getDragonsAmount() > 9997) { // 9997 + 2 (in the nest) + 1 (just sent) = 10000 dragons without gold burning
224             treasury.burnGold(_hatchingPrice.div(2));
225         }
226 
227         return core.sendToNest(_eggId);
228     }
229 
230     function breed(
231         address _sender,
232         uint256 _momId,
233         uint256 _dadId
234     ) external onlyController returns (uint256 eggId) {
235         _checkThatEnoughDNAPoints(_momId);
236         _checkThatEnoughDNAPoints(_dadId);
237         _checkTheDragonIsNotOnBreeding(_momId);
238         _checkTheDragonIsNotOnBreeding(_dadId);
239         _checkTheDragonIsNotOnSale(_momId);
240         _checkTheDragonIsNotOnSale(_dadId);
241         _checkTheDragonIsNotInGladiatorBattle(_momId);
242         _checkTheDragonIsNotInGladiatorBattle(_dadId);
243         _checkDragonOwner(_sender, _momId);
244         _checkDragonOwner(_sender, _dadId);
245         require(_momId != _dadId, "the same dragon");
246 
247         return core.breed(_sender, _momId, _dadId);
248     }
249 
250     function upgradeDragonGenes(
251         address _sender,
252         uint256 _id,
253         uint16[10] _dnaPoints
254     ) external onlyController {
255         _checkTheDragonIsNotOnBreeding(_id);
256         _checkTheDragonIsNotOnSale(_id);
257         _checkTheDragonIsNotInGladiatorBattle(_id);
258         _checkDragonOwner(_sender, _id);
259         core.upgradeDragonGenes(_id, _dnaPoints);
260     }
261 
262     function setDragonTactics(
263         address _sender,
264         uint256 _id,
265         uint8 _melee,
266         uint8 _attack
267     ) external onlyController {
268         _checkDragonOwner(_sender, _id);
269         core.setDragonTactics(_id, _melee, _attack);
270     }
271 
272     function setDragonName(
273         address _sender,
274         uint256 _id,
275         string _name
276     ) external onlyController returns (bytes32) {
277         _checkDragonOwner(_sender, _id);
278 
279         uint256 _length = bytes(_name).length;
280         uint256 _price = getter.getDragonNamePriceByLength(_length);
281 
282         if (_price > 0) {
283             treasury.takeGold(_price);
284         }
285 
286         return core.setDragonName(_id, _name);
287     }
288 
289     function setDragonSpecialPeacefulSkill(address _sender, uint256 _id, uint8 _class) external onlyController {
290         _checkDragonOwner(_sender, _id);
291         core.setDragonSpecialPeacefulSkill(_id, _class);
292     }
293 
294     function useDragonSpecialPeacefulSkill(address _sender, uint256 _id, uint256 _target) external onlyController {
295         _checkDragonOwner(_sender, _id);
296         _checkTheDragonIsNotInGladiatorBattle(_id);
297         _checkTheDragonIsNotInGladiatorBattle(_target);
298         core.useDragonSpecialPeacefulSkill(_sender, _id, _target);
299     }
300 
301     function distributeLeaderboardRewards() external onlyController returns (
302         uint256[10] dragons,
303         address[10] users
304     ) {
305         core.updateLeaderboardRewardTime();
306         uint256 _hatchingPrice = treasury.hatchingPrice();
307         uint256[10] memory _rewards = core.getLeaderboardRewards(_hatchingPrice);
308 
309         dragons = core.getDragonsFromLeaderboard();
310         uint8 i;
311         for (i = 0; i < dragons.length; i++) {
312             if (dragons[i] == 0) continue;
313             users[i] = getter.ownerOfDragon(dragons[i]);
314         }
315 
316         uint256 _remainingGold = treasury.remainingGold();
317         uint256 _reward;
318         for (i = 0; i < users.length; i++) {
319             if (_remainingGold == 0) break;
320             if (users[i] == address(0)) continue;
321 
322             _reward = _rewards[i];
323             if (_reward > _remainingGold) {
324                 _reward = _remainingGold;
325             }
326             treasury.giveGold(users[i], _reward);
327             _remainingGold = _remainingGold.sub(_reward);
328         }
329     }
330 
331     // UPDATE CONTRACT
332 
333     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
334         super.setInternalDependencies(_newDependencies);
335 
336         core = Core(_newDependencies[0]);
337         treasury = Treasury(_newDependencies[1]);
338         getter = Getter(_newDependencies[2]);
339         distribution = Distribution(_newDependencies[3]);
340     }
341 }