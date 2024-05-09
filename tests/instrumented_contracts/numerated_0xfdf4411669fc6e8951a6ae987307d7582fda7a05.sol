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
104 }
105 
106 
107 contract EtheremonTransformData is EtheremonEnum, BasicAccessControl, SafeMath {
108     
109     struct MonsterEgg {
110         uint64 eggId;
111         uint64 objId;
112         uint32 classId;
113         address trainer;
114         uint hatchTime;
115         uint64 newObjId;
116     }
117     
118     uint64 public totalEgg = 0;
119     mapping(uint64 => MonsterEgg) public eggs; // eggId
120     mapping(address => uint64) public hatchingEggs;
121     mapping(uint64 => uint64[]) public eggList; // objId -> [eggId]
122     mapping(uint64 => uint64) public transformed; //objId -> newObjId
123     
124     // only moderators
125     /*
126     TO AVOID ANY BUGS, WE ALLOW MODERATORS TO HAVE PERMISSION TO ALL THESE FUNCTIONS AND UPDATE THEM IN EARLY BETA STAGE.
127     AFTER THE SYSTEM IS STABLE, WE WILL REMOVE OWNER OF THIS SMART CONTRACT AND ONLY KEEP ONE MODERATOR WHICH IS ETHEREMON BATTLE CONTRACT.
128     HENCE, THE DECENTRALIZED ATTRIBUTION IS GUARANTEED.
129     */
130     
131     function addEgg(uint64 _objId, uint32 _classId, address _trainer, uint _hatchTime) onlyModerators external returns(uint64) {
132         totalEgg += 1;
133         MonsterEgg storage egg = eggs[totalEgg];
134         egg.objId = _objId;
135         egg.eggId = totalEgg;
136         egg.classId = _classId;
137         egg.trainer = _trainer;
138         egg.hatchTime = _hatchTime;
139         egg.newObjId = 0;
140         hatchingEggs[_trainer] = totalEgg;
141         
142         // increase count
143         if (_objId > 0) {
144             eggList[_objId].push(totalEgg);
145         }
146         return totalEgg;
147     }
148     
149     function setHatchedEgg(uint64 _eggId, uint64 _newObjId) onlyModerators external {
150         MonsterEgg storage egg = eggs[_eggId];
151         if (egg.eggId != _eggId)
152             revert();
153         egg.newObjId = _newObjId;
154         hatchingEggs[egg.trainer] = 0;
155     }
156     
157     function setHatchTime(uint64 _eggId, uint _hatchTime) onlyModerators external {
158         MonsterEgg storage egg = eggs[_eggId];
159         if (egg.eggId != _eggId)
160             revert();
161         egg.hatchTime = _hatchTime;
162     }
163     
164     function setTranformed(uint64 _objId, uint64 _newObjId) onlyModerators external {
165         transformed[_objId] = _newObjId;
166     }
167     
168     
169     function getHatchingEggId(address _trainer) constant external returns(uint64) {
170         return hatchingEggs[_trainer];
171     }
172     
173     function getEggDataById(uint64 _eggId) constant external returns(uint64, uint64, uint32, address, uint, uint64) {
174         MonsterEgg memory egg = eggs[_eggId];
175         return (egg.eggId, egg.objId, egg.classId, egg.trainer, egg.hatchTime, egg.newObjId);
176     }
177     
178     function getHatchingEggData(address _trainer) constant external returns(uint64, uint64, uint32, address, uint, uint64) {
179         MonsterEgg memory egg = eggs[hatchingEggs[_trainer]];
180         return (egg.eggId, egg.objId, egg.classId, egg.trainer, egg.hatchTime, egg.newObjId);
181     }
182     
183     function getTranformedId(uint64 _objId) constant external returns(uint64) {
184         return transformed[_objId];
185     }
186     
187     function countEgg(uint64 _objId) constant external returns(uint) {
188         return eggList[_objId].length;
189     }
190     
191     function getEggIdByObjId(uint64 _objId, uint _index) constant external returns(uint64, uint64, uint32, address, uint, uint64) {
192         MonsterEgg memory egg = eggs[eggList[_objId][_index]];
193         return (egg.eggId, egg.objId, egg.classId, egg.trainer, egg.hatchTime, egg.newObjId);
194     }
195 }