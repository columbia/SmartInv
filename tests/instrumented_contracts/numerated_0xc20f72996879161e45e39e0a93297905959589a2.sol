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
173 contract EtheremonPayment is EtheremonEnum, BasicAccessControl, SafeMath {
174     uint8 constant public STAT_COUNT = 6;
175     uint8 constant public STAT_MAX = 32;
176     uint8 constant public GEN0_NO = 24;
177     
178     enum PayServiceType {
179         NONE,
180         FAST_HATCHING,
181         RANDOM_EGG,
182         ENERGY_TOPUP,
183         ADVENTURE
184     }
185     
186     struct MonsterClassAcc {
187         uint32 classId;
188         uint256 price;
189         uint256 returnPrice;
190         uint32 total;
191         bool catchable;
192     }
193 
194     struct MonsterObjAcc {
195         uint64 monsterId;
196         uint32 classId;
197         address trainer;
198         string name;
199         uint32 exp;
200         uint32 createIndex;
201         uint32 lastClaimIndex;
202         uint createTime;
203     }
204     
205     // linked smart contract
206     address public dataContract;
207     address public tokenContract;
208     address public transformContract;
209     address public energyContract;
210     address public adventureContract;
211     
212     address private lastHunter = address(0x0);
213     
214     // config
215     uint public fastHatchingPrice = 35 * 10 ** 8; // 15 tokens 
216     uint public buyEggPrice = 80 * 10 ** 8; // 80 tokens
217     uint public tokenPrice = 0.004 ether / 10 ** 8;
218     uint public maxDexSize = 200;
219     
220     // event
221     event EventCatchMonster(address indexed trainer, uint64 objId);
222     
223     // modifier
224     modifier requireDataContract {
225         require(dataContract != address(0));
226         _;        
227     }
228 
229     modifier requireTokenContract {
230         require(tokenContract != address(0));
231         _;
232     }
233     
234     modifier requireTransformContract {
235         require(transformContract != address(0));
236         _;
237     }
238     
239     function EtheremonPayment(address _dataContract, address _tokenContract, address _transformContract, address _energyContract, address _adventureContract) public {
240         dataContract = _dataContract;
241         tokenContract = _tokenContract;
242         transformContract = _transformContract;
243         energyContract = _energyContract;
244         adventureContract = _adventureContract;
245     }
246     
247     // helper
248     function getRandom(uint8 maxRan, uint8 index, address priAddress) constant public returns(uint8) {
249         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);
250         for (uint8 i = 0; i < index && i < 6; i ++) {
251             genNum /= 256;
252         }
253         return uint8(genNum % maxRan);
254     }
255     
256     // admin
257     function withdrawToken(address _sendTo, uint _amount) onlyModerators requireTokenContract external {
258         ERC20Interface token = ERC20Interface(tokenContract);
259         if (_amount > token.balanceOf(address(this))) {
260             revert();
261         }
262         token.transfer(_sendTo, _amount);
263     }
264     
265     function setContract(address _dataContract, address _tokenContract, address _transformContract, address _energyContract, address _adventureContract) onlyModerators external {
266         dataContract = _dataContract;
267         tokenContract = _tokenContract;
268         transformContract = _transformContract;
269         energyContract = _energyContract;
270         adventureContract = _adventureContract;
271     }
272     
273     function setConfig(uint _tokenPrice, uint _maxDexSize, uint _fastHatchingPrice, uint _buyEggPrice) onlyModerators external {
274         tokenPrice = _tokenPrice;
275         maxDexSize = _maxDexSize;
276         fastHatchingPrice = _fastHatchingPrice;
277         buyEggPrice = _buyEggPrice;
278     }
279     
280     // battle
281     // function createCastle(address _trainer, uint _tokens, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireBattleContract requireTokenContract public returns(uint)
282     
283     function catchMonster(address _trainer, uint _tokens, uint32 _classId, string _name) isActive requireDataContract requireTokenContract public returns(uint){
284         if (msg.sender != tokenContract)
285             revert();
286         
287         EtheremonDataBase data = EtheremonDataBase(dataContract);
288         MonsterClassAcc memory class;
289         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
290         
291         if (class.classId == 0 || class.catchable == false) {
292             revert();
293         }
294         
295         // can not keep too much etheremon 
296         if (data.getMonsterDexSize(_trainer) > maxDexSize)
297             revert();
298 
299         uint requiredToken = class.price/tokenPrice;
300         if (_tokens < requiredToken)
301             revert();
302 
303         // add monster
304         uint64 objId = data.addMonsterObj(_classId, _trainer, _name);
305         // generate base stat for the previous one
306         for (uint i=0; i < STAT_COUNT; i+= 1) {
307             uint8 value = getRandom(STAT_MAX, uint8(i), lastHunter) + data.getElementInArrayType(ArrayType.STAT_START, uint64(_classId), i);
308             data.addElementToArrayType(ArrayType.STAT_BASE, objId, value);
309         }
310         
311         lastHunter = _trainer;
312         EventCatchMonster(_trainer, objId);
313         return requiredToken;
314     }
315     
316     
317     function _handleEnergyTopup(address _trainer, uint _param, uint _tokens) internal {
318         EngergyInterface energy = EngergyInterface(energyContract);
319         energy.topupEnergyByToken(_trainer, _param, _tokens);
320     }
321     
322 
323     function payService(address _trainer, uint _tokens, uint32 _type, string _text, uint64 _param1, uint64 _param2, uint64 _param3, uint64 _param4, uint64 _param5, uint64 _param6) isActive  public returns(uint result) {
324         if (msg.sender != tokenContract)
325             revert();
326         
327         TransformInterface transform = TransformInterface(transformContract);
328         if (_type == uint32(PayServiceType.FAST_HATCHING)) {
329             // remove hatching time 
330             if (_tokens < fastHatchingPrice)
331                 revert();
332             transform.removeHatchingTimeWithToken(_trainer);
333             
334             return fastHatchingPrice;
335         } else if (_type == uint32(PayServiceType.RANDOM_EGG)) {
336             if (_tokens < buyEggPrice)
337                 revert();
338             transform.buyEggWithToken(_trainer);
339 
340             return buyEggPrice;
341         } else if (_type == uint32(PayServiceType.ENERGY_TOPUP)) {
342             _handleEnergyTopup(_trainer, _param1, _tokens);
343             return _tokens;
344         } else if (_type == uint32(PayServiceType.ADVENTURE)) {
345             AdventureInterface adventure = AdventureInterface(adventureContract);
346             adventure.adventureByToken(_trainer, _tokens, _param1, _param2, _param3, _param4);
347             return _tokens;
348         } else {
349             revert();
350         }
351     }
352 }