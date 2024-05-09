1 pragma solidity ^0.4.16;
2 
3 // copyright contact@Etheremon.com
4 
5 contract SafeMath {
6 
7     /* function assert(bool assertion) internal { */
8     /*   if (!assertion) { */
9     /*     throw; */
10     /*   } */
11     /* }      // assert no longer needed once solidity is on 0.4.10 */
12 
13     function safeAdd(uint256 x, uint256 y) pure internal returns(uint256) {
14       uint256 z = x + y;
15       assert((z >= x) && (z >= y));
16       return z;
17     }
18 
19     function safeSubtract(uint256 x, uint256 y) pure internal returns(uint256) {
20       assert(x >= y);
21       uint256 z = x - y;
22       return z;
23     }
24 
25     function safeMult(uint256 x, uint256 y) pure internal returns(uint256) {
26       uint256 z = x * y;
27       assert((x == 0)||(z/x == y));
28       return z;
29     }
30 
31 }
32 
33 contract BasicAccessControl {
34     address public owner;
35     // address[] public moderators;
36     uint16 public totalModerators = 0;
37     mapping (address => bool) public moderators;
38     bool public isMaintaining = false;
39 
40     function BasicAccessControl() public {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     modifier onlyModerators() {
50         require(msg.sender == owner || moderators[msg.sender] == true);
51         _;
52     }
53 
54     modifier isActive {
55         require(!isMaintaining);
56         _;
57     }
58 
59     function ChangeOwner(address _newOwner) onlyOwner public {
60         if (_newOwner != address(0)) {
61             owner = _newOwner;
62         }
63     }
64 
65 
66     function AddModerator(address _newModerator) onlyOwner public {
67         if (moderators[_newModerator] == false) {
68             moderators[_newModerator] = true;
69             totalModerators += 1;
70         }
71     }
72     
73     function RemoveModerator(address _oldModerator) onlyOwner public {
74         if (moderators[_oldModerator] == true) {
75             moderators[_oldModerator] = false;
76             totalModerators -= 1;
77         }
78     }
79 
80     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
81         isMaintaining = _isMaintaining;
82     }
83 }
84 
85 contract EtheremonEnum {
86 
87     enum ResultCode {
88         SUCCESS,
89         ERROR_CLASS_NOT_FOUND,
90         ERROR_LOW_BALANCE,
91         ERROR_SEND_FAIL,
92         ERROR_NOT_TRAINER,
93         ERROR_NOT_ENOUGH_MONEY,
94         ERROR_INVALID_AMOUNT
95     }
96     
97     enum ArrayType {
98         CLASS_TYPE,
99         STAT_STEP,
100         STAT_START,
101         STAT_BASE,
102         OBJ_SKILL
103     }
104     
105     enum PropertyType {
106         ANCESTOR,
107         XFACTOR
108     }
109 }
110 
111 contract EtheremonDataBase is EtheremonEnum, BasicAccessControl, SafeMath {
112     
113     uint64 public totalMonster;
114     uint32 public totalClass;
115     
116     // write
117     function withdrawEther(address _sendTo, uint _amount) onlyOwner public returns(ResultCode);
118     function addElementToArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);
119     function updateIndexOfArrayType(ArrayType _type, uint64 _id, uint _index, uint8 _value) onlyModerators public returns(uint);
120     function setMonsterClass(uint32 _classId, uint256 _price, uint256 _returnPrice, bool _catchable) onlyModerators public returns(uint32);
121     function addMonsterObj(uint32 _classId, address _trainer, string _name) onlyModerators public returns(uint64);
122     function setMonsterObj(uint64 _objId, string _name, uint32 _exp, uint32 _createIndex, uint32 _lastClaimIndex) onlyModerators public;
123     function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
124     function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
125     function removeMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
126     function addMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
127     function clearMonsterReturnBalance(uint64 _monsterId) onlyModerators public returns(uint256 amount);
128     function collectAllReturnBalance(address _trainer) onlyModerators public returns(uint256 amount);
129     function transferMonster(address _from, address _to, uint64 _monsterId) onlyModerators public returns(ResultCode);
130     function addExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
131     function deductExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
132     function setExtraBalance(address _trainer, uint256 _amount) onlyModerators public;
133     
134     // read
135     function getSizeArrayType(ArrayType _type, uint64 _id) constant public returns(uint);
136     function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);
137     function getMonsterClass(uint32 _classId) constant public returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);
138     function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
139     function getMonsterName(uint64 _objId) constant public returns(string name);
140     function getExtraBalance(address _trainer) constant public returns(uint256);
141     function getMonsterDexSize(address _trainer) constant public returns(uint);
142     function getMonsterObjId(address _trainer, uint index) constant public returns(uint64);
143     function getExpectedBalance(address _trainer) constant public returns(uint256);
144     function getMonsterReturn(uint64 _objId) constant public returns(uint256 current, uint256 total);
145 }
146 
147 contract ERC20Interface {
148     function totalSupply() public constant returns (uint);
149     function balanceOf(address tokenOwner) public constant returns (uint balance);
150     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
151     function transfer(address to, uint tokens) public returns (bool success);
152     function approve(address spender, uint tokens) public returns (bool success);
153     function transferFrom(address from, address to, uint tokens) public returns (bool success);
154 }
155 
156 contract BattleInterface {
157     function createCastleWithToken(address _trainer, uint32 _noBrick, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) external;
158 }
159 
160 contract TransformInterface {
161     function removeHatchingTimeWithToken(address _trainer) external;
162     function buyEggWithToken(address _trainer) external;
163 }
164 
165 contract EngergyInterface {
166     function topupEnergyByToken(address _player, uint _packId, uint _token) external;
167 }
168 
169 contract AdventureInterface {
170     function adventureByToken(address _player, uint _token, uint _param1, uint _param2, uint64 _param3, uint64 _param4) external;
171 }
172 
173 contract CubegoInterface {
174     function payService(address _player, uint _tokens, uint _param1, uint _param2, uint64 _param3, uint64 _param4) external;
175 }
176 
177 contract EtheremonPayment is EtheremonEnum, BasicAccessControl, SafeMath {
178     uint8 constant public STAT_COUNT = 6;
179     uint8 constant public STAT_MAX = 32;
180     uint8 constant public GEN0_NO = 24;
181     
182     enum PayServiceType {
183         NONE,
184         FAST_HATCHING,
185         RANDOM_EGG,
186         ENERGY_TOPUP,
187         ADVENTURE,
188         CUBEGO
189     }
190     
191     struct MonsterClassAcc {
192         uint32 classId;
193         uint256 price;
194         uint256 returnPrice;
195         uint32 total;
196         bool catchable;
197     }
198 
199     struct MonsterObjAcc {
200         uint64 monsterId;
201         uint32 classId;
202         address trainer;
203         string name;
204         uint32 exp;
205         uint32 createIndex;
206         uint32 lastClaimIndex;
207         uint createTime;
208     }
209     
210     // linked smart contract
211     address public dataContract;
212     address public tokenContract;
213     address public transformContract;
214     address public energyContract;
215     address public adventureContract;
216     address public cubegoContract;
217     
218     address private lastHunter = address(0x0);
219     
220     // config
221     uint public fastHatchingPrice = 35 * 10 ** 8; // 15 tokens 
222     uint public buyEggPrice = 80 * 10 ** 8; // 80 tokens
223     uint public tokenPrice = 0.004 ether / 10 ** 8;
224     uint public maxDexSize = 200;
225     
226     // event
227     event EventCatchMonster(address indexed trainer, uint64 objId);
228     
229     // modifier
230     modifier requireDataContract {
231         require(dataContract != address(0));
232         _;        
233     }
234 
235     modifier requireTokenContract {
236         require(tokenContract != address(0));
237         _;
238     }
239     
240     modifier requireTransformContract {
241         require(transformContract != address(0));
242         _;
243     }
244     
245     function EtheremonPayment(address _dataContract, address _tokenContract, address _transformContract, address _energyContract, address _adventureContract, address _cubegoContract) public {
246         dataContract = _dataContract;
247         tokenContract = _tokenContract;
248         transformContract = _transformContract;
249         energyContract = _energyContract;
250         adventureContract = _adventureContract;
251         cubegoContract = _cubegoContract;
252     }
253     
254     // helper
255     function getRandom(uint8 maxRan, uint8 index, address priAddress) constant public returns(uint8) {
256         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);
257         for (uint8 i = 0; i < index && i < 6; i ++) {
258             genNum /= 256;
259         }
260         return uint8(genNum % maxRan);
261     }
262     
263     // admin
264     function withdrawToken(address _sendTo, uint _amount) onlyModerators requireTokenContract external {
265         ERC20Interface token = ERC20Interface(tokenContract);
266         if (_amount > token.balanceOf(address(this))) {
267             revert();
268         }
269         token.transfer(_sendTo, _amount);
270     }
271     
272     function setContract(address _dataContract, address _tokenContract, address _transformContract, address _energyContract, address _adventureContract, address _cubegoContract) onlyModerators external {
273         dataContract = _dataContract;
274         tokenContract = _tokenContract;
275         transformContract = _transformContract;
276         energyContract = _energyContract;
277         adventureContract = _adventureContract;
278         cubegoContract = _cubegoContract;
279     }
280     
281     function setConfig(uint _tokenPrice, uint _maxDexSize, uint _fastHatchingPrice, uint _buyEggPrice) onlyModerators external {
282         tokenPrice = _tokenPrice;
283         maxDexSize = _maxDexSize;
284         fastHatchingPrice = _fastHatchingPrice;
285         buyEggPrice = _buyEggPrice;
286     }
287     
288     // battle
289     // function createCastle(address _trainer, uint _tokens, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireBattleContract requireTokenContract public returns(uint)
290     
291     function catchMonster(address _trainer, uint _tokens, uint32 _classId, string _name) isActive requireDataContract requireTokenContract public returns(uint){
292         if (msg.sender != tokenContract)
293             revert();
294         
295         EtheremonDataBase data = EtheremonDataBase(dataContract);
296         MonsterClassAcc memory class;
297         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
298         
299         if (class.classId == 0 || class.catchable == false) {
300             revert();
301         }
302         
303         // can not keep too much etheremon 
304         if (data.getMonsterDexSize(_trainer) > maxDexSize)
305             revert();
306 
307         uint requiredToken = class.price/tokenPrice;
308         if (_tokens < requiredToken)
309             revert();
310 
311         // add monster
312         uint64 objId = data.addMonsterObj(_classId, _trainer, _name);
313         // generate base stat for the previous one
314         for (uint i=0; i < STAT_COUNT; i+= 1) {
315             uint8 value = getRandom(STAT_MAX, uint8(i), lastHunter) + data.getElementInArrayType(ArrayType.STAT_START, uint64(_classId), i);
316             data.addElementToArrayType(ArrayType.STAT_BASE, objId, value);
317         }
318         
319         lastHunter = _trainer;
320         EventCatchMonster(_trainer, objId);
321         return requiredToken;
322     }
323     
324     
325     function _handleEnergyTopup(address _trainer, uint _param, uint _tokens) internal {
326         EngergyInterface energy = EngergyInterface(energyContract);
327         energy.topupEnergyByToken(_trainer, _param, _tokens);
328     }
329     
330 
331     function payService(address _trainer, uint _tokens, uint32 _type, string _text, uint64 _param1, uint64 _param2, uint64 _param3, uint64 _param4, uint64 _param5, uint64 _param6) isActive  public returns(uint result) {
332         if (msg.sender != tokenContract)
333             revert();
334         
335         TransformInterface transform = TransformInterface(transformContract);
336         if (_type == uint32(PayServiceType.FAST_HATCHING)) {
337             // remove hatching time 
338             if (_tokens < fastHatchingPrice)
339                 revert();
340             transform.removeHatchingTimeWithToken(_trainer);
341             
342             return fastHatchingPrice;
343         } else if (_type == uint32(PayServiceType.RANDOM_EGG)) {
344             if (_tokens < buyEggPrice)
345                 revert();
346             transform.buyEggWithToken(_trainer);
347 
348             return buyEggPrice;
349         } else if (_type == uint32(PayServiceType.ENERGY_TOPUP)) {
350             _handleEnergyTopup(_trainer, _param1, _tokens);
351             return _tokens;
352         } else if (_type == uint32(PayServiceType.ADVENTURE)) {
353             AdventureInterface adventure = AdventureInterface(adventureContract);
354             adventure.adventureByToken(_trainer, _tokens, _param1, _param2, _param3, _param4);
355             return _tokens;
356         } else if (_type == uint32(PayServiceType.CUBEGO)) {
357             CubegoInterface cubego = CubegoInterface(cubegoContract);
358             cubego.payService(_trainer, _tokens, _param1, _param2, _param3, _param4);
359             return _tokens;
360         } else {
361             revert();
362         }
363     }
364 }