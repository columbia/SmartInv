1 pragma solidity 0.4.24;
2 
3 contract ItemsStorage {
4 
5     /* ------ ITEMS STORAGE ------ */
6 
7     uint256[] private ships;
8     uint256[] private radars;
9     uint256[] private scanners;
10     uint256[] private droids;
11     uint256[] private engines;
12     uint256[] private fuels;
13     uint256[] private generators;
14     uint256[] private guns;
15     uint256[] private microModules;
16     uint256[] private artefacts;
17 
18     uint256[] private usersShips;
19     uint256[] private usersRadars;
20     uint256[] private usersScanners;
21     uint256[] private usersDroids;
22     uint256[] private usersEngines;
23     uint256[] private usersFuels;
24     uint256[] private usersGenerators;
25     uint256[] private usersGuns;
26     uint256[] private usersMicroModules;
27     uint256[] private usersArtefacts;
28 
29     address private ownerOfItemsStorage;
30     address private logicContractAddress;
31     address private eternalStorageContractAddress;
32 
33     constructor() public {
34         ownerOfItemsStorage = msg.sender;
35     }
36 
37     /* ------ MODIFIERS ------ */
38 
39     modifier onlyOwnerOfItemsStorage() {
40         require(msg.sender == ownerOfItemsStorage);
41         _;
42     }
43 
44     modifier onlyLogicContract() {
45         require(msg.sender == logicContractAddress);
46         _;
47     }
48 
49     modifier onlyEternalStorageContract() {
50         require(msg.sender == eternalStorageContractAddress);
51         _;
52     }
53 
54     function destroyItemsStorage() public onlyOwnerOfItemsStorage {
55         selfdestruct(0xd135377eB20666725D518c967F23e168045Ee11F);
56     }
57 
58     /* ------ BUY OPERATION ------ */
59 
60     function _compareStrings (string _string1, string _string2) private pure returns (bool) {
61        return keccak256(abi.encodePacked(_string1)) == keccak256(abi.encodePacked(_string2));
62     }
63 
64     function addItem(string _itemType) public onlyEternalStorageContract returns(uint256) {
65 
66         uint256 newItemId;
67         if (_compareStrings(_itemType, "ship")) {
68             newItemId = usersShips.length + 1;
69             usersShips.push(newItemId);
70         } else if (_compareStrings(_itemType, "radar")) {
71             newItemId = usersRadars.length + 1;
72             usersRadars.push(newItemId);
73         } else if (_compareStrings(_itemType, "scanner")) {
74             newItemId = usersScanners.length + 1;
75             usersScanners.push(newItemId);
76         } else if (_compareStrings(_itemType, "droid")) {
77             newItemId = usersDroids.length + 1;
78             usersDroids.push(newItemId);
79         } else if (_compareStrings(_itemType, "engine")) {
80             newItemId = usersEngines.length + 1;
81             usersEngines.push(newItemId);
82         } else if (_compareStrings(_itemType, "fuel")) {
83             newItemId = usersFuels.length + 1;
84             usersFuels.push(newItemId);
85         } else if (_compareStrings(_itemType, "generator")) {
86             newItemId = usersGenerators.length + 1;
87             usersGenerators.push(newItemId);
88         } else if (_compareStrings(_itemType, "gun")) {
89             newItemId = usersGuns.length + 1;
90             usersGuns.push(newItemId);
91         } else if (_compareStrings(_itemType, "microModule")) {
92             newItemId = usersMicroModules.length + 1;
93             usersMicroModules.push(newItemId);
94         }
95 
96         return newItemId;
97     }
98 
99     /* ------ GET ALL POSSIBLE USERS ITEMS ------ */
100 
101     function getUsersShipsIds() public onlyLogicContract view returns(uint256[]) {
102         return usersShips;
103     }
104 
105     function getUsersRadarsIds() public onlyLogicContract view returns(uint256[]) {
106         return usersRadars;
107     }
108 
109     function getUsersScannersIds() public onlyLogicContract view returns(uint256[]) {
110         return usersScanners;
111     }
112 
113     function getUsersDroidsIds() public onlyLogicContract view returns(uint256[]) {
114         return usersDroids;
115     }
116 
117     function getUsersEnginesIds() public onlyLogicContract view returns(uint256[]) {
118         return usersEngines;
119     }
120 
121     function getUsersFuelsIds() public onlyLogicContract view returns(uint256[]) {
122         return usersFuels;
123     }
124 
125     function getUsersGeneratorsIds() public onlyLogicContract view returns(uint256[]) {
126         return usersGenerators;
127     }
128 
129     function getUsersGunsIds() public onlyLogicContract view returns(uint256[]) {
130         return usersGuns;
131     }
132 
133     function getUsersMicroModulesIds() public onlyLogicContract view returns(uint256[]) {
134         return usersMicroModules;
135     }
136 
137     function getUsersArtefactsIds() public onlyLogicContract view returns(uint256[]) {
138         return usersArtefacts;
139     }
140 
141      /* ------ READING METHODS FOR ALL ITEMS ------ */
142 
143 
144     function getShipsIds() public onlyLogicContract view returns(uint256[]) {
145         return ships;
146     }
147 
148     function getRadarsIds() public onlyLogicContract view returns(uint256[]) {
149         return radars;
150     }
151 
152     function getScannersIds() public onlyLogicContract view returns(uint256[]) {
153         return scanners;
154     }
155 
156     function getDroidsIds() public onlyLogicContract view returns(uint256[]) {
157         return droids;
158     }
159 
160     function getEnginesIds() public onlyLogicContract view returns(uint256[]) {
161         return engines;
162     }
163 
164     function getFuelsIds() public onlyLogicContract view returns(uint256[]) {
165         return fuels;
166     }
167 
168     function getGeneratorsIds() public onlyLogicContract view returns(uint256[]) {
169         return generators;
170     }
171 
172     function getGunsIds() public onlyLogicContract view returns(uint256[]) {
173         return guns;
174     }
175 
176     function getMicroModulesIds() public onlyLogicContract view returns(uint256[]) {
177         return microModules;
178     }
179 
180     function getArtefactsIds() public onlyLogicContract view returns(uint256[]) {
181         return artefacts;
182     }
183     
184     /* ------ DEV CREATION METHODS ------ */
185 
186     // Ships
187     function createShip(uint256 _shipId) public onlyEternalStorageContract {
188         ships.push(_shipId);
189     }
190 
191     // Radars
192     function createRadar(uint256 _radarId) public onlyEternalStorageContract {
193         radars.push(_radarId);
194     }
195 
196     // Scanners
197     function createScanner(uint256 _scannerId) public onlyEternalStorageContract {
198         scanners.push(_scannerId);
199     }
200 
201     // Droids
202     function createDroid(uint256 _droidId) public onlyEternalStorageContract {
203         droids.push(_droidId);
204     }
205 
206     // Fuels
207     function createFuel(uint256 _fuelId) public onlyEternalStorageContract {
208         fuels.push(_fuelId);
209     }
210 
211     // Generators
212     function createGenerator(uint256 _generatorId) public onlyEternalStorageContract {
213         generators.push(_generatorId);
214     }
215 
216     // Engines
217     function createEngine(uint256 _engineId) public onlyEternalStorageContract {
218         engines.push(_engineId);
219     }
220 
221     // Guns
222     function createGun(uint256 _gunId) public onlyEternalStorageContract {
223         guns.push(_gunId);
224     }
225 
226     // Micro modules
227     function createMicroModule(uint256 _microModuleId) public onlyEternalStorageContract {
228         microModules.push(_microModuleId);
229     }
230 
231     // Artefacts
232     function createArtefact(uint256 _artefactId) public onlyEternalStorageContract {
233         artefacts.push(_artefactId);
234     }
235 
236 
237     /* ------ CHANGE OWNERSHIP OF ITEMS STORAGE ------ */
238 
239     function transferOwnershipOfItemsStorage(address _newOwnerOfItemsStorage) public onlyOwnerOfItemsStorage {
240         _transferOwnershipOfItemsStorage(_newOwnerOfItemsStorage);
241     }
242 
243     function _transferOwnershipOfItemsStorage(address _newOwnerOfItemsStorage) private {
244         require(_newOwnerOfItemsStorage != address(0));
245         ownerOfItemsStorage = _newOwnerOfItemsStorage;
246     }
247 
248     /* ------ CHANGE LOGIC CONTRACT ADDRESS ------ */
249 
250     function changeLogicContractAddress(address _newLogicContractAddress) public onlyOwnerOfItemsStorage {
251         _changeLogicContractAddress(_newLogicContractAddress);
252     }
253 
254     function _changeLogicContractAddress(address _newLogicContractAddress) private {
255         require(_newLogicContractAddress != address(0));
256         logicContractAddress = _newLogicContractAddress;
257     }
258 
259     /* ------ CHANGE ETERNAL STORAGE CONTRACT ADDRESS ------ */
260 
261     function changeEternalStorageContractAddress(address _newEternalStorageContractAddress) public onlyOwnerOfItemsStorage {
262         _changeEternalStorageContractAddress(_newEternalStorageContractAddress);
263     }
264 
265     function _changeEternalStorageContractAddress(address _newEternalStorageContractAddress) private {
266         require(_newEternalStorageContractAddress != address(0));
267         eternalStorageContractAddress = _newEternalStorageContractAddress;
268     }
269 }