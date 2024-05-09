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
83     function decreaseMonsterExp(uint64 _objId, uint32 amount) public;
84     function updateIndexOfArrayType(ArrayType _type, uint64 _id, uint _index, uint8 _value) public returns(uint);
85     function addMonsterIdMapping(address _trainer, uint64 _monsterId) public;
86     
87 }
88 
89 interface EtheremonMonsterNFTInterface {
90    function triggerTransferEvent(address _from, address _to, uint _tokenId) external;
91 }
92 
93 contract EtheremonAdventureHandler is BasicAccessControl, EtheremonEnum {
94     uint8 constant public STAT_MAX_VALUE = 32;
95     uint8 constant public LEVEL_MAX_VALUE = 254;
96     
97     struct MonsterObjAcc {
98         uint64 monsterId;
99         uint32 classId;
100         address trainer;
101         string name;
102         uint32 exp;
103         uint32 createIndex;
104         uint32 lastClaimIndex;
105         uint createTime;
106     }
107     
108     // address
109     address public dataContract;
110     address public monsterNFT;
111     
112     mapping(uint8 => uint32) public levelExps;
113     uint public levelItemClass = 200;
114     uint public expItemClass = 201;
115     uint public rebornItemClass = 500;
116     uint[] public rebornMonsterIds = [25252, 25264, 25267, 25372, 25256, 25259, 25367, 25433];
117     
118     function setContract(address _dataContract, address _monsterNFT) onlyModerators public {
119         dataContract = _dataContract;
120         monsterNFT = _monsterNFT;
121     }
122     
123     function setConfig(uint _levelItemClass, uint _expItemClass, uint _rebornItemClass) onlyModerators public {
124         levelItemClass = _levelItemClass;
125         expItemClass = _expItemClass;
126         rebornItemClass = _rebornItemClass;
127     }
128     
129     function genLevelExp() onlyModerators external {
130         uint8 level = 1;
131         uint32 requirement = 100;
132         uint32 sum = requirement;
133         while(level <= 100) {
134             levelExps[level] = sum;
135             level += 1;
136             requirement = (requirement * 11) / 10 + 5;
137             sum += requirement;
138         }
139     }
140     
141     function handleSingleItem(address _sender, uint _classId, uint _value, uint _target, uint _param) onlyModerators public {
142         // check ownership of _target
143         EtheremonDataBase data = EtheremonDataBase(dataContract);
144         MonsterObjAcc memory obj;
145         if (_classId == rebornItemClass) {
146             if (rebornMonsterIds.length == 0) revert();
147             _param = getRandom(_sender, block.number-1) % rebornMonsterIds.length;
148             _target = rebornMonsterIds[_param];
149             
150             // remove monsterId
151             rebornMonsterIds[_param] = rebornMonsterIds[rebornMonsterIds.length-1];
152             delete rebornMonsterIds[rebornMonsterIds.length-1];
153             rebornMonsterIds.length--;
154 
155             // get old exp 
156             (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_target));
157             data.decreaseMonsterExp(obj.monsterId, uint32(obj.exp) - 1);
158 
159             // transfer target to sender 
160             data.addMonsterIdMapping(_sender, uint64(_target));
161             EtheremonMonsterNFTInterface(monsterNFT).triggerTransferEvent(address(0), _sender, uint64(_target));
162 
163             return;
164         } else {
165             (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_target));
166             if (obj.monsterId != _target || obj.trainer != _sender) revert();
167         }  
168         
169         if (_classId == expItemClass) {
170             // exp item
171             data.increaseMonsterExp(obj.monsterId, uint32(_value));
172         } else if (_classId == levelItemClass) {
173             // level item
174             uint8 currentLevel = getLevel(obj.exp);
175             currentLevel += uint8(_value);
176             if (levelExps[currentLevel-1] < obj.exp || currentLevel > LEVEL_MAX_VALUE)
177                 revert();
178             data.increaseMonsterExp(obj.monsterId, levelExps[currentLevel-1] - obj.exp);
179         } else {
180             revert();
181         }
182     }
183     
184     function handleMultipleItems(address _sender, uint _classId1, uint _classId2, uint _classId3, uint _target, uint _param) onlyModerators public {
185         EtheremonDataBase data = EtheremonDataBase(dataContract);
186         MonsterObjAcc memory obj;
187         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_target));
188         if (obj.monsterId != _target || obj.trainer != _sender) revert();
189         
190         
191         uint index = 0;
192         if (_classId1 == 300 && _classId2 == 301 && _classId3 == 302) {
193             //health shards
194             index = 0;
195         } else if (_classId1 == 310 && _classId2 == 311 && _classId3 == 312) {
196             // primary attack shards
197             index = 1;
198         } else if (_classId1 == 320 && _classId2 == 321 && _classId3 == 322) {
199             // primary defense shards
200             index = 2;
201         } else if (_classId1 == 330 && _classId2 == 331 && _classId3 == 332) {
202             // secondary attack shards
203             index = 3;
204         } else if (_classId1 == 340 && _classId2 == 341 && _classId3 == 342) {
205             // secondary defense shards
206             index = 4;
207         } else if (_classId1 == 350 && _classId2 == 351 && _classId3 == 352) {
208             // speed shards
209             index = 5;
210         }
211         
212         uint8 currentValue = data.getElementInArrayType(ArrayType.STAT_BASE, obj.monsterId, index);
213         if (currentValue + 1 >= LEVEL_MAX_VALUE)
214             revert();
215         data.updateIndexOfArrayType(ArrayType.STAT_BASE, obj.monsterId, index, currentValue + 1);
216     }
217     
218     // public method
219     function getRandom(address _player, uint _block) view public returns(uint) {
220         return uint(keccak256(abi.encodePacked(blockhash(_block), _player)));
221     }
222     
223     function getLevel(uint32 exp) view public returns (uint8) {
224         uint8 minIndex = 1;
225         uint8 maxIndex = 100;
226         uint8 currentIndex;
227      
228         while (minIndex < maxIndex) {
229             currentIndex = (minIndex + maxIndex) / 2;
230             if (exp < levelExps[currentIndex])
231                 maxIndex = currentIndex;
232             else
233                 minIndex = currentIndex + 1;
234         }
235 
236         return minIndex;
237     }
238 
239 }