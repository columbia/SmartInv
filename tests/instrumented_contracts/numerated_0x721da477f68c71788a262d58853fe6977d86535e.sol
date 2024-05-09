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
38     bool public isMaintaining = true;
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
160 contract EtheremonPayment is EtheremonEnum, BasicAccessControl, SafeMath {
161     uint8 constant public STAT_COUNT = 6;
162     uint8 constant public STAT_MAX = 32;
163     uint8 constant public GEN0_NO = 24;
164     
165     struct MonsterClassAcc {
166         uint32 classId;
167         uint256 price;
168         uint256 returnPrice;
169         uint32 total;
170         bool catchable;
171     }
172 
173     struct MonsterObjAcc {
174         uint64 monsterId;
175         uint32 classId;
176         address trainer;
177         string name;
178         uint32 exp;
179         uint32 createIndex;
180         uint32 lastClaimIndex;
181         uint createTime;
182     }
183     
184     // linked smart contract
185     address public dataContract;
186     address public battleContract;
187     address public tokenContract;
188     
189     address private lastHunter = address(0x0);
190     
191     // config
192     uint public brickPrice = 2 * 10 ** 8; // 2 tokens
193     uint public tokenPrice = 0.004 ether / 10 ** 8;
194     uint public maxDexSize = 500;
195     
196     // event
197     event EventCatchMonster(address indexed trainer, uint64 objId);
198     
199     // modifier
200     modifier requireDataContract {
201         require(dataContract != address(0));
202         _;        
203     }
204     
205     modifier requireBattleContract {
206         require(battleContract != address(0));
207         _;
208     }
209 
210     modifier requireTokenContract {
211         require(tokenContract != address(0));
212         _;
213     }
214     
215     function EtheremonPayment(address _dataContract, address _battleContract, address _tokenContract) public {
216         dataContract = _dataContract;
217         battleContract = _battleContract;
218         tokenContract = _tokenContract;
219     }
220     
221     // helper
222     function getRandom(uint8 maxRan, uint8 index, address priAddress) constant public returns(uint8) {
223         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);
224         for (uint8 i = 0; i < index && i < 6; i ++) {
225             genNum /= 256;
226         }
227         return uint8(genNum % maxRan);
228     }
229     
230     // admin
231     function withdrawToken(address _sendTo, uint _amount) onlyModerators requireTokenContract external {
232         ERC20Interface token = ERC20Interface(tokenContract);
233         if (_amount > token.balanceOf(address(this))) {
234             revert();
235         }
236         token.transfer(_sendTo, _amount);
237     }
238     
239     function setContract(address _dataContract, address _battleContract, address _tokenContract) onlyModerators external {
240         dataContract = _dataContract;
241         battleContract = _battleContract;
242         tokenContract = _tokenContract;
243     }
244     
245     function setConfig(uint _brickPrice, uint _tokenPrice, uint _maxDexSize) onlyModerators external {
246         brickPrice = _brickPrice;
247         tokenPrice = _tokenPrice;
248         maxDexSize = _maxDexSize;
249     }
250     
251     // battle
252     function giveBattleBonus(address _trainer, uint _amount) isActive requireBattleContract requireTokenContract public {
253         if (msg.sender != battleContract)
254             revert();
255         ERC20Interface token = ERC20Interface(tokenContract);
256         token.transfer(_trainer, _amount);
257     }
258     
259     function createCastle(address _trainer, uint _tokens, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireBattleContract requireTokenContract public returns(uint){
260         if (msg.sender != tokenContract)
261             revert();
262         BattleInterface battle = BattleInterface(battleContract);
263         battle.createCastleWithToken(_trainer, uint32(_tokens/brickPrice), _name, _a1, _a2, _a3, _s1, _s2, _s3);
264         return _tokens;
265     }
266     
267     function catchMonster(address _trainer, uint _tokens, uint32 _classId, string _name) isActive requireDataContract requireTokenContract public returns(uint){
268         if (msg.sender != tokenContract)
269             revert();
270         
271         EtheremonDataBase data = EtheremonDataBase(dataContract);
272         MonsterClassAcc memory class;
273         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
274         
275         if (class.classId == 0 || class.catchable == false) {
276             revert();
277         }
278         
279         // can not keep too much etheremon 
280         if (data.getMonsterDexSize(_trainer) > maxDexSize)
281             revert();
282 
283         uint requiredToken = class.price/tokenPrice;
284         if (_tokens < requiredToken)
285             revert();
286 
287         // add monster
288         uint64 objId = data.addMonsterObj(_classId, _trainer, _name);
289         // generate base stat for the previous one
290         for (uint i=0; i < STAT_COUNT; i+= 1) {
291             uint8 value = getRandom(STAT_MAX, uint8(i), lastHunter) + data.getElementInArrayType(ArrayType.STAT_START, uint64(_classId), i);
292             data.addElementToArrayType(ArrayType.STAT_BASE, objId, value);
293         }
294         
295         lastHunter = _trainer;
296         EventCatchMonster(_trainer, objId);
297         return requiredToken;
298     }
299     
300     /*
301     function payService(address _trainer, uint _tokens, uint32 _type, string _text, uint64 _param1, uint64 _param2, uint64 _param3) public returns(uint) {
302         if (msg.sender != tokenContract)
303             revert();
304     }*/
305 }