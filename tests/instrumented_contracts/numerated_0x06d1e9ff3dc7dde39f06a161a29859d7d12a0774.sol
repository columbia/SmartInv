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
84 }
85 
86 contract EtheremonAdventureHandler is BasicAccessControl, EtheremonEnum {
87     uint8 constant public STAT_MAX_VALUE = 32;
88     uint8 constant public LEVEL_MAX_VALUE = 254;
89     
90     struct MonsterObjAcc {
91         uint64 monsterId;
92         uint32 classId;
93         address trainer;
94         string name;
95         uint32 exp;
96         uint32 createIndex;
97         uint32 lastClaimIndex;
98         uint createTime;
99     }
100     
101     // address
102     address public dataContract;
103     mapping(uint8 => uint32) public levelExps;
104     uint public levelItemClass = 200;
105     uint public expItemClass = 201;
106     
107     function setContract(address _dataContract) onlyModerators public {
108         dataContract = _dataContract;
109     }
110     
111     function setConfig(uint _levelItemClass, uint _expItemClass) onlyModerators public {
112         levelItemClass = _levelItemClass;
113         expItemClass = _expItemClass;
114     }
115     
116     function genLevelExp() onlyModerators external {
117         uint8 level = 1;
118         uint32 requirement = 100;
119         uint32 sum = requirement;
120         while(level <= 100) {
121             levelExps[level] = sum;
122             level += 1;
123             requirement = (requirement * 11) / 10 + 5;
124             sum += requirement;
125         }
126     }
127     
128     function handleSingleItem(address _sender, uint _classId, uint _value, uint _target, uint _param) onlyModerators public {
129         // check ownership of _target
130         EtheremonDataBase data = EtheremonDataBase(dataContract);
131         MonsterObjAcc memory obj;
132         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_target));
133         if (obj.monsterId != _target || obj.trainer != _sender) revert();
134         
135         if (_classId == expItemClass) {
136             // exp item
137             data.increaseMonsterExp(obj.monsterId, uint32(_value));
138         } else if (_classId == levelItemClass) {
139             // level item
140             uint8 currentLevel = getLevel(obj.exp);
141             currentLevel += uint8(_value);
142             if (levelExps[currentLevel-1] < obj.exp || currentLevel > LEVEL_MAX_VALUE)
143                 revert();
144             data.increaseMonsterExp(obj.monsterId, levelExps[currentLevel-1] - obj.exp);
145         }
146     }
147     
148     function handleMultipleItems(address _sender, uint _classId1, uint _classId2, uint _classId3, uint _target, uint _param) onlyModerators public {
149         EtheremonDataBase data = EtheremonDataBase(dataContract);
150         MonsterObjAcc memory obj;
151         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_target));
152         if (obj.monsterId != _target || obj.trainer != _sender) revert();
153         
154         
155         uint index = 0;
156         if (_classId1 == 300 && _classId2 == 301 && _classId3 == 302) {
157             //health shards
158             index = 0;
159         } else if (_classId1 == 310 && _classId2 == 311 && _classId3 == 312) {
160             // primary attack shards
161             index = 1;
162         } else if (_classId1 == 320 && _classId2 == 321 && _classId3 == 322) {
163             // primary defense shards
164             index = 2;
165         } else if (_classId1 == 330 && _classId2 == 331 && _classId3 == 332) {
166             // secondary attack shards
167             index = 3;
168         } else if (_classId1 == 340 && _classId2 == 341 && _classId3 == 342) {
169             // secondary defense shards
170             index = 4;
171         } else if (_classId1 == 350 && _classId2 == 351 && _classId3 == 352) {
172             // speed shards
173             index = 5;
174         }
175         
176         uint8 currentValue = data.getElementInArrayType(ArrayType.STAT_BASE, obj.monsterId, index);
177         if (currentValue + 1 >= LEVEL_MAX_VALUE)
178             revert();
179         data.updateIndexOfArrayType(ArrayType.STAT_BASE, obj.monsterId, index, currentValue + 1);
180     }
181     
182     // public method
183     function getLevel(uint32 exp) view public returns (uint8) {
184         uint8 minIndex = 1;
185         uint8 maxIndex = 100;
186         uint8 currentIndex;
187      
188         while (minIndex < maxIndex) {
189             currentIndex = (minIndex + maxIndex) / 2;
190             if (exp < levelExps[currentIndex])
191                 maxIndex = currentIndex;
192             else
193                 minIndex = currentIndex + 1;
194         }
195 
196         return minIndex;
197     }
198 
199 }