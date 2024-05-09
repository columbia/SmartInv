1 pragma solidity ^0.4.16;
2 
3 contract BasicAccessControl {
4     address public owner;
5     // address[] public moderators;
6     uint16 public totalModerators = 0;
7     mapping (address => bool) public moderators;
8     bool public isMaintaining = false;
9 
10     function BasicAccessControl() public {
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
56     enum ArrayType {
57         CLASS_TYPE,
58         STAT_STEP,
59         STAT_START,
60         STAT_BASE,
61         OBJ_SKILL
62     }
63 }
64 
65 interface EtheremonTradeInterface {
66     function isOnTrading(uint64 _objId) constant external returns(bool);
67 }
68 
69 contract EtheremonDataBase is EtheremonEnum {
70     uint64 public totalMonster;
71 
72     function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
73     function getMonsterDexSize(address _trainer) constant public returns(uint);
74     function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);
75     
76     function addMonsterObj(uint32 _classId, address _trainer, string _name)  public returns(uint64);
77     function addElementToArrayType(ArrayType _type, uint64 _id, uint8 _value) public returns(uint);
78 }
79 
80 interface EtheremonRankData {
81     function setPlayer(address _trainer, uint64 _a0, uint64 _a1, uint64 _a2, uint64 _s0, uint64 _s1, uint64 _s2) external returns(uint32 playerId);
82     function isOnBattle(address _trainer, uint64 _objId) constant external returns(bool);
83 }
84 
85 contract EtheremonRankBattle is BasicAccessControl, EtheremonEnum {
86 
87     struct MonsterObjAcc {
88         uint64 monsterId;
89         uint32 classId;
90         address trainer;
91         string name;
92         uint32 exp;
93         uint32 createIndex;
94         uint32 lastClaimIndex;
95         uint createTime;
96     }
97     
98     // linked smart contract
99     address public dataContract;
100     address public tradeContract;
101     address public rankDataContract;
102     
103     // modifier
104     modifier requireDataContract {
105         require(dataContract != address(0));
106         _;
107     }
108     
109     modifier requireTradeContract {
110         require(tradeContract != address(0));
111         _;
112     }
113 
114     modifier requireRankDataContract {
115         require(rankDataContract != address(0));
116         _;
117     }
118 
119     // event
120     event EventUpdateCastle(address indexed trainer, uint32 playerId);
121     
122     function EtheremonRankBattle(address _dataContract, address _tradeContract, address _rankDataContract) public {
123         dataContract = _dataContract;
124         tradeContract = _tradeContract;
125         rankDataContract = _rankDataContract;
126     }
127     
128     function setContract(address _dataContract, address _tradeContract, address _rankDataContract) onlyModerators external {
129         dataContract = _dataContract;
130         tradeContract = _tradeContract;
131         rankDataContract = _rankDataContract;
132     }
133 
134     // public
135     
136     function getValidClassId(uint64 _objId, address _owner) constant public returns(uint32) {
137         EtheremonDataBase data = EtheremonDataBase(dataContract);
138         MonsterObjAcc memory obj;
139         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
140         if (obj.trainer != _owner || obj.classId == 21) return 0;
141         return obj.classId;
142     }
143     
144     function hasValidParam(address _trainer, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) constant public returns(bool) {
145         if (_a1 == 0 || _a2 == 0 || _a3 == 0)
146             return false;
147         if (_a1 == _a2 || _a1 == _a3 || _a1 == _s1 || _a1 == _s2 || _a1 == _s3)
148             return false;
149         if (_a2 == _a3 || _a2 == _s1 || _a2 == _s2 || _a2 == _s3)
150             return false;
151         if (_a3 == _s1 || _a3 == _s2 || _a3 == _s3)
152             return false;
153         if (_s1 > 0 && (_s1 == _s2 || _s1 == _s3))
154             return false;
155         if (_s2 > 0 && (_s2 == _s3))
156             return false;
157         
158         uint32 classA1 = getValidClassId(_a1, _trainer);
159         uint32 classA2 = getValidClassId(_a2, _trainer);
160         uint32 classA3 = getValidClassId(_a3, _trainer);
161         
162         if (classA1 == 0 || classA2 == 0 || classA3 == 0)
163             return false;
164         if (classA1 == classA2 || classA1 == classA3 || classA2 == classA3)
165             return false;
166         if (_s1 > 0 && getValidClassId(_s1, _trainer) == 0)
167             return false;
168         if (_s2 > 0 && getValidClassId(_s2, _trainer) == 0)
169             return false;
170         if (_s3 > 0 && getValidClassId(_s3, _trainer) == 0)
171             return false;
172         return true;
173     }
174     
175     function setCastle(uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireDataContract 
176         requireTradeContract requireRankDataContract external {
177         
178         if (!hasValidParam(msg.sender, _a1, _a2, _a3, _s1, _s2, _s3))
179             revert();
180         
181         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
182         if (trade.isOnTrading(_a1) || trade.isOnTrading(_a2) || trade.isOnTrading(_a3) || 
183             trade.isOnTrading(_s1) || trade.isOnTrading(_s2) || trade.isOnTrading(_s3))
184             revert();
185 
186         EtheremonRankData rank = EtheremonRankData(rankDataContract);
187         uint32 playerId = rank.setPlayer(msg.sender, _a1, _a2, _a3, _s1, _s2, _s3);
188         EventUpdateCastle(msg.sender, playerId);
189     }
190     
191     function isOnBattle(uint64 _objId) constant external requireDataContract requireRankDataContract returns(bool) {
192         EtheremonDataBase data = EtheremonDataBase(dataContract);
193         MonsterObjAcc memory obj;
194         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
195         if (obj.monsterId == 0)
196             return false;
197         EtheremonRankData rank = EtheremonRankData(rankDataContract);
198         return rank.isOnBattle(obj.trainer, _objId);
199     }
200 }