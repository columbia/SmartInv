1 pragma solidity ^0.4.23;
2 
3 contract BasicAccessControl {
4     address public owner;
5     // address[] public moderators;
6     uint16 public totalModerators = 0;
7     mapping (address => bool) public moderators;
8     bool public isMaintaining = false;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     modifier onlyModerators() {
20         require(msg.sender == owner || moderators[msg.sender] == true);
21         _;
22     }
23 
24     modifier isActive {
25         require(!isMaintaining);
26         _;
27     }
28 
29     function ChangeOwner(address _newOwner) onlyOwner public {
30         if (_newOwner != address(0)) {
31             owner = _newOwner;
32         }
33     }
34 
35 
36     function AddModerator(address _newModerator) onlyOwner public {
37         if (moderators[_newModerator] == false) {
38             moderators[_newModerator] = true;
39             totalModerators += 1;
40         }
41     }
42     
43     function RemoveModerator(address _oldModerator) onlyOwner public {
44         if (moderators[_oldModerator] == true) {
45             moderators[_oldModerator] = false;
46             totalModerators -= 1;
47         }
48     }
49 
50     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
51         isMaintaining = _isMaintaining;
52     }
53 }
54 
55 contract EtheremonEnum {
56 
57     enum ResultCode {
58         SUCCESS,
59         ERROR_CLASS_NOT_FOUND,
60         ERROR_LOW_BALANCE,
61         ERROR_SEND_FAIL,
62         ERROR_NOT_TRAINER,
63         ERROR_NOT_ENOUGH_MONEY,
64         ERROR_INVALID_AMOUNT
65     }
66     
67     enum ArrayType {
68         CLASS_TYPE,
69         STAT_STEP,
70         STAT_START,
71         STAT_BASE,
72         OBJ_SKILL
73     }
74 }
75 
76 contract EtheremonDataBase is EtheremonEnum {
77     // read
78     function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
79     function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);
80 
81     // write
82     function increaseMonsterExp(uint64 _objId, uint32 amount) public;
83     function updateIndexOfArrayType(ArrayType _type, uint64 _id, uint _index, uint8 _value) public returns(uint);
84     function addMonsterIdMapping(address _trainer, uint64 _monsterId) public;
85     
86 }
87 
88 interface EtheremonMonsterNFTInterface {
89    function triggerTransferEvent(address _from, address _to, uint _tokenId) external;
90 }
91 
92 contract EtheremonAdventureHandler is BasicAccessControl, EtheremonEnum {
93     uint8 constant public STAT_MAX_VALUE = 32;
94     uint8 constant public LEVEL_MAX_VALUE = 254;
95     
96     struct MonsterObjAcc {
97         uint64 monsterId;
98         uint32 classId;
99         address trainer;
100         string name;
101         uint32 exp;
102         uint32 createIndex;
103         uint32 lastClaimIndex;
104         uint createTime;
105     }
106     
107     // address
108     address public dataContract;
109     address public monsterNFT;
110     
111     mapping(uint8 => uint32) public levelExps;
112     uint public levelItemClass = 200;
113     uint public expItemClass = 201;
114     uint public rebornItemClass = 500;
115     uint[] public rebornMonsterIds = [26359, 38315, 25480, 38313, 23402, 25241, 38307, 23473, 25236, 38472, 25445, 38430, 27113];
116     
117     function setContract(address _dataContract, address _monsterNFT) onlyModerators public {
118         dataContract = _dataContract;
119         monsterNFT = _monsterNFT;
120     }
121     
122     function setConfig(uint _levelItemClass, uint _expItemClass, uint _rebornItemClass) onlyModerators public {
123         levelItemClass = _levelItemClass;
124         expItemClass = _expItemClass;
125         rebornItemClass = _rebornItemClass;
126     }
127     
128     function genLevelExp() onlyModerators external {
129         uint8 level = 1;
130         uint32 requirement = 100;
131         uint32 sum = requirement;
132         while(level <= 100) {
133             levelExps[level] = sum;
134             level += 1;
135             requirement = (requirement * 11) / 10 + 5;
136             sum += requirement;
137         }
138     }
139     
140     function handleSingleItem(address _sender, uint _classId, uint _value, uint _target, uint _param) onlyModerators public {
141         // check ownership of _target
142         EtheremonDataBase data = EtheremonDataBase(dataContract);
143         MonsterObjAcc memory obj;
144         if (_classId == rebornItemClass) {
145             if (rebornMonsterIds.length == 0) revert();
146             _param = getRandom(_sender, block.number-1) % rebornMonsterIds.length;
147             _target = rebornMonsterIds[_param];
148             
149             // remove monsterId
150             rebornMonsterIds[_param] = rebornMonsterIds[rebornMonsterIds.length-1];
151             delete rebornMonsterIds[rebornMonsterIds.length-1];
152             rebornMonsterIds.length--;
153 
154             // transfer target to sender 
155             data.addMonsterIdMapping(_sender, uint64(_target));
156             EtheremonMonsterNFTInterface(monsterNFT).triggerTransferEvent(address(0), _sender, uint64(_target));
157 
158             return;
159         } 
160         
161         
162         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_target));
163         if (obj.monsterId != _target || obj.trainer != _sender) revert();
164         
165         if (_classId == expItemClass) {
166             // exp item
167             data.increaseMonsterExp(obj.monsterId, uint32(_value));
168         } else if (_classId == levelItemClass) {
169             // level item
170             uint8 currentLevel = getLevel(obj.exp);
171             currentLevel += uint8(_value);
172             if (levelExps[currentLevel-1] < obj.exp || currentLevel > LEVEL_MAX_VALUE)
173                 revert();
174             data.increaseMonsterExp(obj.monsterId, levelExps[currentLevel-1] - obj.exp);
175         } else {
176             revert();
177         }
178     }
179     
180     function handleMultipleItems(address _sender, uint _classId1, uint _classId2, uint _classId3, uint _target, uint _param) onlyModerators public {
181         EtheremonDataBase data = EtheremonDataBase(dataContract);
182         MonsterObjAcc memory obj;
183         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_target));
184         if (obj.monsterId != _target || obj.trainer != _sender) revert();
185         
186         
187         uint index = 0;
188         if (_classId1 == 300 && _classId2 == 301 && _classId3 == 302) {
189             //health shards
190             index = 0;
191         } else if (_classId1 == 310 && _classId2 == 311 && _classId3 == 312) {
192             // primary attack shards
193             index = 1;
194         } else if (_classId1 == 320 && _classId2 == 321 && _classId3 == 322) {
195             // primary defense shards
196             index = 2;
197         } else if (_classId1 == 330 && _classId2 == 331 && _classId3 == 332) {
198             // secondary attack shards
199             index = 3;
200         } else if (_classId1 == 340 && _classId2 == 341 && _classId3 == 342) {
201             // secondary defense shards
202             index = 4;
203         } else if (_classId1 == 350 && _classId2 == 351 && _classId3 == 352) {
204             // speed shards
205             index = 5;
206         }
207         
208         uint8 currentValue = data.getElementInArrayType(ArrayType.STAT_BASE, obj.monsterId, index);
209         if (currentValue + 1 >= LEVEL_MAX_VALUE)
210             revert();
211         data.updateIndexOfArrayType(ArrayType.STAT_BASE, obj.monsterId, index, currentValue + 1);
212     }
213     
214     // public method
215     function getRandom(address _player, uint _block) view public returns(uint) {
216         return uint(keccak256(abi.encodePacked(blockhash(_block), _player)));
217     }
218     
219     function getLevel(uint32 exp) view public returns (uint8) {
220         uint8 minIndex = 1;
221         uint8 maxIndex = 100;
222         uint8 currentIndex;
223      
224         while (minIndex < maxIndex) {
225             currentIndex = (minIndex + maxIndex) / 2;
226             if (exp < levelExps[currentIndex])
227                 maxIndex = currentIndex;
228             else
229                 minIndex = currentIndex + 1;
230         }
231 
232         return minIndex;
233     }
234 
235 }