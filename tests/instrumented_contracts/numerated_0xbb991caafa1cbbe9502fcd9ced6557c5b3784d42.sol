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
70     function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
71     function getMonsterDexSize(address _trainer) constant public returns(uint);
72     function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);
73     
74     function addMonsterObj(uint32 _classId, address _trainer, string _name)  public returns(uint64);
75     function addElementToArrayType(ArrayType _type, uint64 _id, uint8 _value) public returns(uint);
76 }
77 
78 interface EtheremonRankData {
79     function setPlayer(address _trainer, uint64 _a0, uint64 _a1, uint64 _a2, uint64 _s0, uint64 _s1, uint64 _s2) external returns(uint32 playerId);
80 }
81 
82 contract EtheremonRankBattle is BasicAccessControl, EtheremonEnum {
83 
84     struct MonsterObjAcc {
85         uint64 monsterId;
86         uint32 classId;
87         address trainer;
88         string name;
89         uint32 exp;
90         uint32 createIndex;
91         uint32 lastClaimIndex;
92         uint createTime;
93     }
94     
95     // linked smart contract
96     address public dataContract;
97     address public tradeContract;
98     address public rankDataContract;
99     
100     uint32[3] public starterClasses;
101     uint public maxDexSize = 200;
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
121     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
122     
123     function EtheremonRankBattle(address _dataContract, address _tradeContract, address _rankDataContract) public {
124         dataContract = _dataContract;
125         tradeContract = _tradeContract;
126         rankDataContract = _rankDataContract;
127     }
128     
129     function setContract(address _dataContract, address _tradeContract, address _rankDataContract) onlyModerators external {
130         dataContract = _dataContract;
131         tradeContract = _tradeContract;
132         rankDataContract = _rankDataContract;
133     }
134 
135     function setStarterClass(uint _index, uint32 _classId) onlyModerators external {
136         starterClasses[_index] = _classId;
137     }
138     
139     function quickSetStarterClasses() onlyModerators external {
140         starterClasses[0] = 25;
141         starterClasses[1] = 26;
142         starterClasses[2] = 27;
143     }
144     
145     function setMaxDexSize(uint _value) onlyModerators external {
146         maxDexSize = _value;
147     }
148 
149     // public
150     
151     // public functions
152     function getRandom(uint _seed) constant public returns(uint) {
153         return uint(keccak256(block.timestamp, block.difficulty)) ^ _seed;
154     }
155     
156     function getValidClassId(uint64 _objId, address _owner) constant public returns(uint32) {
157         EtheremonDataBase data = EtheremonDataBase(dataContract);
158         MonsterObjAcc memory obj;
159         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
160         if (obj.trainer != _owner || obj.classId == 21) return 0;
161         return obj.classId;
162     }
163     
164     function hasValidParam(address _trainer, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) constant public returns(bool) {
165         if (_a1 == 0 || _a2 == 0 || _a3 == 0)
166             return false;
167         if (_a1 == _a2 || _a1 == _a3 || _a1 == _s1 || _a1 == _s2 || _a1 == _s3)
168             return false;
169         if (_a2 == _a3 || _a2 == _s1 || _a2 == _s2 || _a2 == _s3)
170             return false;
171         if (_a3 == _s1 || _a3 == _s2 || _a3 == _s3)
172             return false;
173         if (_s1 > 0 && (_s1 == _s2 || _s1 == _s3))
174             return false;
175         if (_s2 > 0 && (_s2 == _s3))
176             return false;
177         
178         uint32 classA1 = getValidClassId(_a1, _trainer);
179         uint32 classA2 = getValidClassId(_a2, _trainer);
180         uint32 classA3 = getValidClassId(_a3, _trainer);
181         
182         if (classA1 == 0 || classA2 == 0 || classA3 == 0)
183             return false;
184         if (classA1 == classA2 || classA1 == classA3 || classA2 == classA3)
185             return false;
186         if (_s1 > 0 && getValidClassId(_s1, _trainer) == 0)
187             return false;
188         if (_s2 > 0 && getValidClassId(_s2, _trainer) == 0)
189             return false;
190         if (_s3 > 0 && getValidClassId(_s3, _trainer) == 0)
191             return false;
192         return true;
193     }
194     
195     function setCastle(uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireDataContract 
196         requireTradeContract requireRankDataContract external {
197         
198         if (!hasValidParam(msg.sender, _a1, _a2, _a3, _s1, _s2, _s3))
199             revert();
200         
201         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
202         if (trade.isOnTrading(_a1) || trade.isOnTrading(_a2) || trade.isOnTrading(_a3) || 
203             trade.isOnTrading(_s1) || trade.isOnTrading(_s2) || trade.isOnTrading(_s3))
204             revert();
205 
206         EtheremonRankData rank = EtheremonRankData(rankDataContract);
207         uint32 playerId = rank.setPlayer(msg.sender, _a1, _a2, _a3, _s1, _s2, _s3);
208         EventUpdateCastle(msg.sender, playerId);
209     }
210     
211     function catchStarters() isActive requireDataContract external {
212         EtheremonDataBase data = EtheremonDataBase(dataContract);
213 
214         // can not keep too many etheremon 
215         if (data.getMonsterDexSize(msg.sender) > maxDexSize)
216             revert();
217         
218         uint i = 0;
219         uint j = 0;
220         uint seed = 0;
221         uint64 objId = 0;
222         uint32 classId = 0;
223         uint8 value = 0;
224         for (i = 0; i < starterClasses.length; i+=1) {
225             classId = starterClasses[i];
226             seed = getRandom(uint(block.blockhash(block.number - i)));
227             objId = data.addMonsterObj(classId, msg.sender, "..name me...");
228             for (j = 0; j < 6; j += 1) {
229                 seed = seed ^ (i + j);
230                 value = uint8(seed % 32) + data.getElementInArrayType(ArrayType.STAT_START, uint64(classId), j);
231                 data.addElementToArrayType(ArrayType.STAT_BASE, objId, value);
232             }
233             
234             Transfer(address(0), msg.sender, objId);
235         } 
236     }
237 }