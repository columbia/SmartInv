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
50         require(moderators[msg.sender] == true);
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
94         ERROR_INVALID_AMOUNT,
95         ERROR_OBJ_NOT_FOUND,
96         ERROR_OBJ_INVALID_OWNERSHIP
97     }
98     
99     enum ArrayType {
100         CLASS_TYPE,
101         STAT_STEP,
102         STAT_START,
103         STAT_BASE,
104         OBJ_SKILL
105     }
106 }
107 
108 contract EtheremonDataBase is EtheremonEnum, BasicAccessControl, SafeMath {
109     
110     uint64 public totalMonster;
111     uint32 public totalClass;
112     
113     // write
114     function addElementToArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);
115     function removeElementOfArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);
116     function setMonsterClass(uint32 _classId, uint256 _price, uint256 _returnPrice, bool _catchable) onlyModerators public returns(uint32);
117     function addMonsterObj(uint32 _classId, address _trainer, string _name) onlyModerators public returns(uint64);
118     function setMonsterObj(uint64 _objId, string _name, uint32 _exp, uint32 _createIndex, uint32 _lastClaimIndex) onlyModerators public;
119     function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
120     function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
121     function removeMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
122     function addMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
123     function clearMonsterReturnBalance(uint64 _monsterId) onlyModerators public returns(uint256 amount);
124     function collectAllReturnBalance(address _trainer) onlyModerators public returns(uint256 amount);
125     function transferMonster(address _from, address _to, uint64 _monsterId) onlyModerators public returns(ResultCode);
126     function addExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
127     function deductExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
128     function setExtraBalance(address _trainer, uint256 _amount) onlyModerators public;
129     
130     // read
131     function getSizeArrayType(ArrayType _type, uint64 _id) constant public returns(uint);
132     function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);
133     function getMonsterClass(uint32 _classId) constant public returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);
134     function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
135     function getMonsterName(uint64 _objId) constant public returns(string name);
136     function getExtraBalance(address _trainer) constant public returns(uint256);
137     function getMonsterDexSize(address _trainer) constant public returns(uint);
138     function getMonsterObjId(address _trainer, uint index) constant public returns(uint64);
139     function getExpectedBalance(address _trainer) constant public returns(uint256);
140     function getMonsterReturn(uint64 _objId) constant public returns(uint256 current, uint256 total);
141 }
142 
143 contract EtheremonDataEvent is BasicAccessControl {
144     
145     // data contract
146     address public dataContract;
147     
148     // event
149     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
150     
151      // constructor
152     function EtheremonDataEvent(address _dataContract) public {
153         dataContract = _dataContract;
154     }
155     
156     function setContract(address _dataContract) onlyModerators public {
157         dataContract = _dataContract;
158     }
159     
160     // write action
161     
162     function addExtraBalance(address _trainer, uint256 _amount) onlyModerators external returns(uint256) {
163         EtheremonDataBase data = EtheremonDataBase(dataContract);
164         return data.addExtraBalance(_trainer, _amount);
165     }
166     
167     function setMonsterObj(uint64 _objId, string _name, uint32 _exp, uint32 _createIndex, uint32 _lastClaimIndex) onlyModerators external {
168         EtheremonDataBase data = EtheremonDataBase(dataContract);
169         data.setMonsterObj(_objId, _name, _exp, _createIndex, _lastClaimIndex);
170     }
171     
172     function removeMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public {
173         EtheremonDataBase data = EtheremonDataBase(dataContract);
174         data.removeMonsterIdMapping(_trainer, _monsterId);
175         Transfer(_trainer, address(0), _monsterId);
176     }
177     
178     function addMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public {
179         EtheremonDataBase data = EtheremonDataBase(dataContract);
180         data.addMonsterIdMapping(_trainer, _monsterId);
181         Transfer(address(0), _trainer, _monsterId);
182     }
183     
184     
185     // read action
186     function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime) {
187         EtheremonDataBase data = EtheremonDataBase(dataContract);
188         return data.getMonsterObj(_objId);
189     }
190 }