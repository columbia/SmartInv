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
165 contract AdventureInterface {
166     function placeEMONTBid(address _bidder, uint8 _siteId, uint _bidAmount) external;
167 }
168 
169 contract EtheremonPayment is EtheremonEnum, BasicAccessControl, SafeMath {
170     uint8 constant public STAT_COUNT = 6;
171     uint8 constant public STAT_MAX = 32;
172     uint8 constant public GEN0_NO = 24;
173     
174     enum PayServiceType {
175         NONE,
176         FAST_HATCHING,
177         RANDOM_EGG,
178         ADVENTURE_PRESALE
179     }
180     
181     struct MonsterClassAcc {
182         uint32 classId;
183         uint256 price;
184         uint256 returnPrice;
185         uint32 total;
186         bool catchable;
187     }
188 
189     struct MonsterObjAcc {
190         uint64 monsterId;
191         uint32 classId;
192         address trainer;
193         string name;
194         uint32 exp;
195         uint32 createIndex;
196         uint32 lastClaimIndex;
197         uint createTime;
198     }
199     
200     // linked smart contract
201     address public dataContract;
202     address public battleContract;
203     address public tokenContract;
204     address public transformContract;
205     address public adventureContract;
206     
207     address private lastHunter = address(0x0);
208     
209     // config
210     uint public brickPrice = 6 * 10 ** 8; // 6 tokens
211     uint public fastHatchingPrice = 35 * 10 ** 8; // 15 tokens 
212     uint public buyEggPrice = 80 * 10 ** 8; // 80 tokens
213     uint public tokenPrice = 0.004 ether / 10 ** 8;
214     uint public maxDexSize = 200;
215     
216     // event
217     event EventCatchMonster(address indexed trainer, uint64 objId);
218     
219     // modifier
220     modifier requireDataContract {
221         require(dataContract != address(0));
222         _;        
223     }
224     
225     modifier requireBattleContract {
226         require(battleContract != address(0));
227         _;
228     }
229 
230     modifier requireTokenContract {
231         require(tokenContract != address(0));
232         _;
233     }
234     
235     modifier requireTransformContract {
236         require(transformContract != address(0));
237         _;
238     }
239     
240     function EtheremonPayment(address _dataContract, address _battleContract, address _tokenContract, address _transformContract, address _adventureContract) public {
241         dataContract = _dataContract;
242         battleContract = _battleContract;
243         tokenContract = _tokenContract;
244         transformContract = _transformContract;
245         adventureContract = _adventureContract;
246     }
247     
248     // helper
249     function getRandom(uint8 maxRan, uint8 index, address priAddress) constant public returns(uint8) {
250         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);
251         for (uint8 i = 0; i < index && i < 6; i ++) {
252             genNum /= 256;
253         }
254         return uint8(genNum % maxRan);
255     }
256     
257     // admin
258     function withdrawToken(address _sendTo, uint _amount) onlyModerators requireTokenContract external {
259         ERC20Interface token = ERC20Interface(tokenContract);
260         if (_amount > token.balanceOf(address(this))) {
261             revert();
262         }
263         token.transfer(_sendTo, _amount);
264     }
265     
266     function setContract(address _dataContract, address _battleContract, address _tokenContract, address _transformContract, address _adventureContract) onlyModerators external {
267         dataContract = _dataContract;
268         battleContract = _battleContract;
269         tokenContract = _tokenContract;
270         transformContract = _transformContract;
271         adventureContract = _adventureContract;
272     }
273     
274     function setConfig(uint _brickPrice, uint _tokenPrice, uint _maxDexSize, uint _fastHatchingPrice, uint _buyEggPrice) onlyModerators external {
275         brickPrice = _brickPrice;
276         tokenPrice = _tokenPrice;
277         maxDexSize = _maxDexSize;
278         fastHatchingPrice = _fastHatchingPrice;
279         buyEggPrice = _buyEggPrice;
280     }
281     
282     // battle
283     function giveBattleBonus(address _trainer, uint _amount) isActive requireBattleContract requireTokenContract public {
284         if (msg.sender != battleContract)
285             revert();
286         ERC20Interface token = ERC20Interface(tokenContract);
287         token.transfer(_trainer, _amount);
288     }
289     
290     function createCastle(address _trainer, uint _tokens, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireBattleContract requireTokenContract public returns(uint){
291         if (msg.sender != tokenContract)
292             revert();
293         BattleInterface battle = BattleInterface(battleContract);
294         battle.createCastleWithToken(_trainer, uint32(_tokens/brickPrice), _name, _a1, _a2, _a3, _s1, _s2, _s3);
295         return _tokens;
296     }
297     
298     function catchMonster(address _trainer, uint _tokens, uint32 _classId, string _name) isActive requireDataContract requireTokenContract public returns(uint){
299         if (msg.sender != tokenContract)
300             revert();
301         
302         EtheremonDataBase data = EtheremonDataBase(dataContract);
303         MonsterClassAcc memory class;
304         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
305         
306         if (class.classId == 0 || class.catchable == false) {
307             revert();
308         }
309         
310         // can not keep too much etheremon 
311         if (data.getMonsterDexSize(_trainer) > maxDexSize)
312             revert();
313 
314         uint requiredToken = class.price/tokenPrice;
315         if (_tokens < requiredToken)
316             revert();
317 
318         // add monster
319         uint64 objId = data.addMonsterObj(_classId, _trainer, _name);
320         // generate base stat for the previous one
321         for (uint i=0; i < STAT_COUNT; i+= 1) {
322             uint8 value = getRandom(STAT_MAX, uint8(i), lastHunter) + data.getElementInArrayType(ArrayType.STAT_START, uint64(_classId), i);
323             data.addElementToArrayType(ArrayType.STAT_BASE, objId, value);
324         }
325         
326         lastHunter = _trainer;
327         EventCatchMonster(_trainer, objId);
328         return requiredToken;
329     }
330     
331 
332     function payService(address _trainer, uint _tokens, uint32 _type, string _text, uint64 _param1, uint64 _param2, uint64 _param3, uint64 _param4, uint64 _param5, uint64 _param6) isActive requireTransformContract  public returns(uint result) {
333         if (msg.sender != tokenContract)
334             revert();
335         
336         TransformInterface transform = TransformInterface(transformContract);
337         AdventureInterface adventure = AdventureInterface(adventureContract);
338         if (_type == uint32(PayServiceType.FAST_HATCHING)) {
339             // remove hatching time 
340             if (_tokens < fastHatchingPrice)
341                 revert();
342             transform.removeHatchingTimeWithToken(_trainer);
343             
344             return fastHatchingPrice;
345         } else if (_type == uint32(PayServiceType.RANDOM_EGG)) {
346             if (_tokens < buyEggPrice)
347                 revert();
348             transform.buyEggWithToken(_trainer);
349 
350             return buyEggPrice;
351         } else if (_type == uint32(PayServiceType.ADVENTURE_PRESALE)) {
352             adventure.placeEMONTBid(_trainer, uint8(_param1), _tokens);
353             return _tokens;
354         } else {
355             revert();
356         }
357     }
358 }