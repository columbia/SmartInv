1 pragma solidity ^0.4.18;
2 
3 // Etheremon ERC721
4 
5 // copyright contact@Etheremon.com
6 
7 contract SafeMath {
8 
9     /* function assert(bool assertion) internal { */
10     /*   if (!assertion) { */
11     /*     throw; */
12     /*   } */
13     /* }      // assert no longer needed once solidity is on 0.4.10 */
14 
15     function safeAdd(uint256 x, uint256 y) pure internal returns(uint256) {
16       uint256 z = x + y;
17       assert((z >= x) && (z >= y));
18       return z;
19     }
20 
21     function safeSubtract(uint256 x, uint256 y) pure internal returns(uint256) {
22       assert(x >= y);
23       uint256 z = x - y;
24       return z;
25     }
26 
27     function safeMult(uint256 x, uint256 y) pure internal returns(uint256) {
28       uint256 z = x * y;
29       assert((x == 0)||(z/x == y));
30       return z;
31     }
32 
33 }
34 
35 contract BasicAccessControl {
36     address public owner;
37     // address[] public moderators;
38     uint16 public totalModerators = 0;
39     mapping (address => bool) public moderators;
40     bool public isMaintaining = true;
41 
42     function BasicAccessControl() public {
43         owner = msg.sender;
44     }
45 
46     modifier onlyOwner {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     modifier onlyModerators() {
52         require(moderators[msg.sender] == true);
53         _;
54     }
55 
56     modifier isActive {
57         require(!isMaintaining);
58         _;
59     }
60 
61     function ChangeOwner(address _newOwner) onlyOwner public {
62         if (_newOwner != address(0)) {
63             owner = _newOwner;
64         }
65     }
66 
67     function AddModerator(address _newModerator) onlyOwner public {
68         if (moderators[_newModerator] == false) {
69             moderators[_newModerator] = true;
70             totalModerators += 1;
71         }
72     }
73     
74     function RemoveModerator(address _oldModerator) onlyOwner public {
75         if (moderators[_oldModerator] == true) {
76             moderators[_oldModerator] = false;
77             totalModerators -= 1;
78         }
79     }
80     
81     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
82         isMaintaining = _isMaintaining;
83     }
84 }
85 
86 
87 contract EtheremonEnum {
88 
89     enum ResultCode {
90         SUCCESS,
91         ERROR_CLASS_NOT_FOUND,
92         ERROR_LOW_BALANCE,
93         ERROR_SEND_FAIL,
94         ERROR_NOT_TRAINER,
95         ERROR_NOT_ENOUGH_MONEY,
96         ERROR_INVALID_AMOUNT
97     }
98     
99     enum ArrayType {
100         CLASS_TYPE,
101         STAT_STEP,
102         STAT_START,
103         STAT_BASE,
104         OBJ_SKILL
105     }
106     
107     enum PropertyType {
108         ANCESTOR,
109         XFACTOR
110     }
111 }
112 
113 contract EtheremonDataBase is EtheremonEnum, BasicAccessControl, SafeMath {
114     
115     uint64 public totalMonster;
116     uint32 public totalClass;
117     
118     // write
119     function withdrawEther(address _sendTo, uint _amount) onlyOwner public returns(ResultCode);
120     function addElementToArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);
121     function updateIndexOfArrayType(ArrayType _type, uint64 _id, uint _index, uint8 _value) onlyModerators public returns(uint);
122     function setMonsterClass(uint32 _classId, uint256 _price, uint256 _returnPrice, bool _catchable) onlyModerators public returns(uint32);
123     function addMonsterObj(uint32 _classId, address _trainer, string _name) onlyModerators public returns(uint64);
124     function setMonsterObj(uint64 _objId, string _name, uint32 _exp, uint32 _createIndex, uint32 _lastClaimIndex) onlyModerators public;
125     function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
126     function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
127     function removeMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
128     function addMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
129     function clearMonsterReturnBalance(uint64 _monsterId) onlyModerators public returns(uint256 amount);
130     function collectAllReturnBalance(address _trainer) onlyModerators public returns(uint256 amount);
131     function transferMonster(address _from, address _to, uint64 _monsterId) onlyModerators public returns(ResultCode);
132     function addExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
133     function deductExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
134     function setExtraBalance(address _trainer, uint256 _amount) onlyModerators public;
135     
136     // read
137     function getSizeArrayType(ArrayType _type, uint64 _id) constant public returns(uint);
138     function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);
139     function getMonsterClass(uint32 _classId) constant public returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);
140     function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
141     function getMonsterName(uint64 _objId) constant public returns(string name);
142     function getExtraBalance(address _trainer) constant public returns(uint256);
143     function getMonsterDexSize(address _trainer) constant public returns(uint);
144     function getMonsterObjId(address _trainer, uint index) constant public returns(uint64);
145     function getExpectedBalance(address _trainer) constant public returns(uint256);
146     function getMonsterReturn(uint64 _objId) constant public returns(uint256 current, uint256 total);
147 }
148 
149 
150 interface EtheremonBattle {
151     function isOnBattle(uint64 _objId) constant external returns(bool);
152 }
153 
154 interface EtheremonTradeInterface {
155     function isOnTrading(uint64 _objId) constant external returns(bool);
156 }
157 
158 contract ERC721 {
159     // ERC20 compatible functions
160     // function name() constant returns (string name);
161     // function symbol() constant returns (string symbol);
162     function totalSupply() public constant returns (uint256 supply);
163     function balanceOf(address _owner) public constant returns (uint256 balance);
164     // Functions that define ownership
165     function ownerOf(uint256 _tokenId) public constant returns (address owner);
166     function approve(address _to, uint256 _tokenId) external;
167     function takeOwnership(uint256 _tokenId) external;
168     function transfer(address _to, uint256 _tokenId) external;
169     function transferFrom(address _from, address _to, uint256 _tokenId) external;
170     function tokenOfOwnerByIndex(address _owner, uint256 _index) public constant returns (uint tokenId);
171     // Token metadata
172     //function tokenMetadata(uint256 _tokenId) constant returns (string infoUrl);
173 
174     // Events
175     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
176     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
177 }
178 
179 contract EtheremonAsset is BasicAccessControl, ERC721 {
180     string public constant name = "EtheremonAsset";
181     string public constant symbol = "EMONA";
182     
183     mapping (address => mapping (uint256 => address)) public allowed;
184     
185     // data contract
186     address public dataContract;
187     address public battleContract;
188     address public tradeContract;
189     
190     // helper struct
191     struct MonsterClassAcc {
192         uint32 classId;
193         uint256 price;
194         uint256 returnPrice;
195         uint32 total;
196         bool catchable;
197     }
198 
199     struct MonsterObjAcc {
200         uint64 monsterId;
201         uint32 classId;
202         address trainer;
203         string name;
204         uint32 exp;
205         uint32 createIndex;
206         uint32 lastClaimIndex;
207         uint createTime;
208     }
209 
210     // modifier
211     
212     modifier requireDataContract {
213         require(dataContract != address(0));
214         _;
215     }
216     
217     modifier requireBattleContract {
218         require(battleContract != address(0));
219         _;
220     }
221     
222     modifier requireTradeContract {
223         require(tradeContract != address(0));
224         _;        
225     }
226     
227     function EtheremonAsset(address _dataContract, address _battleContract, address _tradeContract) public {
228         dataContract = _dataContract;
229         battleContract = _battleContract;
230         tradeContract = _tradeContract;
231     }
232 
233     function setContract(address _dataContract, address _battleContract, address _tradeContract) onlyModerators external {
234         dataContract = _dataContract;
235         battleContract = _battleContract;
236         tradeContract = _tradeContract;
237     }
238     
239     
240     // public
241     
242     function totalSupply() public constant requireDataContract returns (uint256 supply){
243         EtheremonDataBase data = EtheremonDataBase(dataContract);
244         return data.totalMonster();
245     }
246     
247     function balanceOf(address _owner) public constant requireDataContract returns (uint balance) {
248         EtheremonDataBase data = EtheremonDataBase(dataContract);
249         return data.getMonsterDexSize(_owner);
250     }
251     
252     function ownerOf(uint256 _tokenId) public constant requireDataContract returns (address owner) {
253         EtheremonDataBase data = EtheremonDataBase(dataContract);
254         MonsterObjAcc memory obj;
255         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
256         require(obj.monsterId == uint64(_tokenId));
257         return obj.trainer;
258     }
259     
260     function approve(address _to, uint256 _tokenId) isActive external {
261         require(msg.sender == ownerOf(_tokenId));
262         require(msg.sender != _to);
263         allowed[msg.sender][_tokenId] = _to;
264         Approval(msg.sender, _to, _tokenId);
265     }
266     
267     function takeOwnership(uint256 _tokenId) requireDataContract requireBattleContract requireTradeContract isActive external {
268         EtheremonDataBase data = EtheremonDataBase(dataContract);
269         MonsterObjAcc memory obj;
270         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
271         
272         require(obj.monsterId == uint64(_tokenId));
273         require(msg.sender != obj.trainer);
274         
275         require(allowed[obj.trainer][_tokenId] == msg.sender);
276         
277         // check battle & trade contract 
278         EtheremonBattle battle = EtheremonBattle(battleContract);
279         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
280         if (battle.isOnBattle(obj.monsterId) || trade.isOnTrading(obj.monsterId))
281             revert();
282         
283         // remove allowed
284         allowed[obj.trainer][_tokenId] = address(0);
285 
286         // transfer owner
287         data.removeMonsterIdMapping(obj.trainer, obj.monsterId);
288         data.addMonsterIdMapping(msg.sender, obj.monsterId);
289         
290         Transfer(obj.trainer, msg.sender, _tokenId);
291     }
292     
293     function transfer(address _to, uint256 _tokenId) requireDataContract isActive external {
294         EtheremonDataBase data = EtheremonDataBase(dataContract);
295         MonsterObjAcc memory obj;
296         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
297         
298         require(obj.monsterId == uint64(_tokenId));
299         require(obj.trainer == msg.sender);
300         require(msg.sender != _to);
301         require(_to != address(0));
302         
303         // check battle & trade contract 
304         EtheremonBattle battle = EtheremonBattle(battleContract);
305         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
306         if (battle.isOnBattle(obj.monsterId) || trade.isOnTrading(obj.monsterId))
307             revert();
308         
309         // remove allowed
310         allowed[obj.trainer][_tokenId] = address(0);
311         
312         // transfer owner
313         data.removeMonsterIdMapping(obj.trainer, obj.monsterId);
314         data.addMonsterIdMapping(msg.sender, obj.monsterId);
315         
316         Transfer(obj.trainer, _to, _tokenId);
317     }
318     
319     function transferFrom(address _from, address _to, uint256 _tokenId) requireDataContract requireBattleContract requireTradeContract external {
320         EtheremonDataBase data = EtheremonDataBase(dataContract);
321         MonsterObjAcc memory obj;
322         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
323         
324         require(obj.monsterId == uint64(_tokenId));
325         require(obj.trainer == _from);
326         require(_to != address(0));
327         require(_to != _from);
328         require(allowed[_from][_tokenId] == msg.sender);
329     
330         // check battle & trade contract 
331         EtheremonBattle battle = EtheremonBattle(battleContract);
332         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
333         if (battle.isOnBattle(obj.monsterId) || trade.isOnTrading(obj.monsterId))
334             revert();
335         
336         // remove allowed
337         allowed[_from][_tokenId] = address(0);
338 
339         // transfer owner
340         data.removeMonsterIdMapping(obj.trainer, obj.monsterId);
341         data.addMonsterIdMapping(_to, obj.monsterId);
342         
343         Transfer(obj.trainer, _to, _tokenId);
344     }
345     
346     function tokenOfOwnerByIndex(address _owner, uint256 _index) public constant requireDataContract returns (uint tokenId) {
347         EtheremonDataBase data = EtheremonDataBase(dataContract);
348         return data.getMonsterObjId(_owner, _index);
349     }
350 }