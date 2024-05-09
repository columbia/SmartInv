1 pragma solidity 0.4.25;
2 
3 
4 contract Ownable {
5     address public owner;
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     function _validateAddress(address _addr) internal pure {
10         require(_addr != address(0), "invalid address");
11     }
12 
13     constructor() public {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner() {
18         require(msg.sender == owner, "not a contract owner");
19         _;
20     }
21 
22     function transferOwnership(address newOwner) public onlyOwner {
23         _validateAddress(newOwner);
24         emit OwnershipTransferred(owner, newOwner);
25         owner = newOwner;
26     }
27 
28 }
29 
30 contract Pausable is Ownable {
31     event Pause();
32     event Unpause();
33 
34     bool public paused = false;
35 
36     modifier whenNotPaused() {
37         require(!paused, "contract is paused");
38         _;
39     }
40 
41     modifier whenPaused() {
42         require(paused, "contract is not paused");
43         _;
44     }
45 
46     function pause() public onlyOwner whenNotPaused {
47         paused = true;
48         emit Pause();
49     }
50 
51     function unpause() public onlyOwner whenPaused {
52         paused = false;
53         emit Unpause();
54     }
55 }
56 
57 contract Controllable is Ownable {
58     mapping(address => bool) controllers;
59 
60     modifier onlyController {
61         require(_isController(msg.sender), "no controller rights");
62         _;
63     }
64 
65     function _isController(address _controller) internal view returns (bool) {
66         return controllers[_controller];
67     }
68 
69     function _setControllers(address[] _controllers) internal {
70         for (uint256 i = 0; i < _controllers.length; i++) {
71             _validateAddress(_controllers[i]);
72             controllers[_controllers[i]] = true;
73         }
74     }
75 }
76 
77 contract Upgradable is Controllable {
78     address[] internalDependencies;
79     address[] externalDependencies;
80 
81     function getInternalDependencies() public view returns(address[]) {
82         return internalDependencies;
83     }
84 
85     function getExternalDependencies() public view returns(address[]) {
86         return externalDependencies;
87     }
88 
89     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
90         for (uint256 i = 0; i < _newDependencies.length; i++) {
91             _validateAddress(_newDependencies[i]);
92         }
93         internalDependencies = _newDependencies;
94     }
95 
96     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
97         externalDependencies = _newDependencies;
98         _setControllers(_newDependencies);
99     }
100 }
101 
102 contract HumanOriented {
103     modifier onlyHuman() {
104         require(msg.sender == tx.origin, "not a human");
105         _;
106     }
107 }
108 
109 
110 contract Events {
111     function emitEggClaimed(address, uint256) external {}
112     function emitEggSentToNest(address, uint256) external {}
113     function emitDragonUpgraded(uint256) external {}
114     function emitEggHatched(address, uint256, uint256) external {}
115     function emitEggCreated(address, uint256) external {}
116     function emitDistributionUpdated(uint256, uint256, uint256) external {}
117     function emitSkillSet(uint256) external {}
118     function emitSkillUsed(uint256, uint256) external {}
119     function emitDragonNameSet(uint256, bytes32) external {}
120     function emitDragonTacticsSet(uint256, uint8, uint8) external {}
121     function emitUserNameSet(address, bytes32) external {}
122     function emitLeaderboardRewardsDistributed(uint256[10], address[10]) external {}
123 }
124 
125 contract User {
126     mapping (bytes32 => bool) public existingNames;
127     mapping (address => bytes32) public names;
128 
129     function getName(address) external view returns (bytes32) {}
130     function setName(address, string) external returns (bytes32) {}
131 }
132 
133 contract CoreController {
134     function claimEgg(address, uint8) external returns (uint256, uint256, uint256, uint256) {}
135     function sendToNest(address, uint256) external returns (bool, uint256, uint256, address) {}
136     function breed(address, uint256, uint256) external returns (uint256) {}
137     function upgradeDragonGenes(address, uint256, uint16[10]) external {}
138     function setDragonTactics(address, uint256, uint8, uint8) external {}
139     function setDragonName(address, uint256, string) external returns (bytes32) {}
140     function setDragonSpecialPeacefulSkill(address, uint256, uint8) external {}
141     function useDragonSpecialPeacefulSkill(address, uint256, uint256) external {}
142     function distributeLeaderboardRewards() external returns (uint256[10], address[10]) {}
143 }
144 
145 
146 
147 
148 //////////////CONTRACT//////////////
149 
150 
151 
152 
153 contract MainBase is Pausable, Upgradable, HumanOriented {
154     CoreController coreController;
155     User user;
156     Events events;
157 
158     function claimEgg(uint8 _dragonType) external onlyHuman whenNotPaused {
159         (
160             uint256 _eggId,
161             uint256 _restAmount,
162             uint256 _lastBlock,
163             uint256 _interval
164         ) = coreController.claimEgg(msg.sender, _dragonType);
165 
166         events.emitEggClaimed(msg.sender, _eggId);
167         events.emitDistributionUpdated(_restAmount, _lastBlock, _interval);
168     }
169 
170     // ACTIONS WITH OWN TOKENS
171 
172     function sendToNest(
173         uint256 _eggId
174     ) external onlyHuman whenNotPaused {
175         (
176             bool _isHatched,
177             uint256 _newDragonId,
178             uint256 _hatchedId,
179             address _owner
180         ) = coreController.sendToNest(msg.sender, _eggId);
181 
182         events.emitEggSentToNest(msg.sender, _eggId);
183 
184         if (_isHatched) {
185             events.emitEggHatched(_owner, _newDragonId, _hatchedId);
186         }
187     }
188 
189     function breed(uint256 _momId, uint256 _dadId) external onlyHuman whenNotPaused {
190         uint256 eggId = coreController.breed(msg.sender, _momId, _dadId);
191         events.emitEggCreated(msg.sender, eggId);
192     }
193 
194     function upgradeDragonGenes(uint256 _id, uint16[10] _dnaPoints) external onlyHuman whenNotPaused {
195         coreController.upgradeDragonGenes(msg.sender, _id, _dnaPoints);
196         events.emitDragonUpgraded(_id);
197     }
198 
199     function setDragonTactics(uint256 _id, uint8 _melee, uint8 _attack) external onlyHuman whenNotPaused {
200         coreController.setDragonTactics(msg.sender, _id, _melee, _attack);
201         events.emitDragonTacticsSet(_id, _melee, _attack);
202     }
203 
204     function setDragonName(uint256 _id, string _name) external onlyHuman whenNotPaused returns (bytes32 name) {
205         name = coreController.setDragonName(msg.sender, _id, _name);
206         events.emitDragonNameSet(_id, name);
207     }
208 
209     function setDragonSpecialPeacefulSkill(uint256 _id, uint8 _class) external onlyHuman whenNotPaused {
210         coreController.setDragonSpecialPeacefulSkill(msg.sender, _id, _class);
211         events.emitSkillSet(_id);
212     }
213 
214     function useDragonSpecialPeacefulSkill(uint256 _id, uint256 _target) external onlyHuman whenNotPaused {
215         coreController.useDragonSpecialPeacefulSkill(msg.sender, _id, _target);
216         events.emitSkillUsed(_id, _target);
217     }
218 
219     // LEADERBOARD
220 
221     function distributeLeaderboardRewards() external onlyHuman whenNotPaused {
222         (
223             uint256[10] memory _dragons,
224             address[10] memory _users
225         ) = coreController.distributeLeaderboardRewards();
226         events.emitLeaderboardRewardsDistributed(_dragons, _users);
227     }
228 
229     // USER
230 
231     function setName(string _name) external onlyHuman whenNotPaused returns (bytes32 name) {
232         name = user.setName(msg.sender, _name);
233         events.emitUserNameSet(msg.sender, name);
234     }
235 
236     function getName(address _user) external view returns (bytes32) {
237         return user.getName(_user);
238     }
239 
240     // UPDATE CONTRACT
241 
242     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
243         super.setInternalDependencies(_newDependencies);
244 
245         coreController = CoreController(_newDependencies[0]);
246         user = User(_newDependencies[1]);
247         events = Events(_newDependencies[2]);
248     }
249 }