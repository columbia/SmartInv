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
107 contract EtheremonCastleBattle is EtheremonEnum, BasicAccessControl, SafeMath {
108     uint8 constant public NO_BATTLE_LOG = 4;
109     
110     struct CastleData {
111         uint index; // in active castle if > 0
112         string name;
113         address owner;
114         uint32 totalWin;
115         uint32 totalLose;
116         uint64[6] monsters; // 3 attackers, 3 supporters
117         uint64[4] battleList;
118         uint32 brickNumber;
119         uint createTime;
120     }
121     
122     struct BattleDataLog {
123         uint32 castleId;
124         address attacker;
125         uint32[3] castleExps; // 3 attackers
126         uint64[6] attackerObjIds;
127         uint32[3] attackerExps;
128         uint8[3] randoms;
129         uint8 result;
130     }
131     
132     struct TrainerBattleLog {
133         uint32 lastCastle;
134         uint32 totalWin;
135         uint32 totalLose;
136         uint64[4] battleList;
137         uint32 totalBrick;
138     }
139     
140     mapping(uint64 => BattleDataLog) battles;
141     mapping(address => uint32) trainerCastle;
142     mapping(address => TrainerBattleLog) trannerBattleLog;
143     mapping(uint32 => CastleData) castleData;
144     uint32[] activeCastleList;
145 
146     uint32 public totalCastle = 0;
147     uint64 public totalBattle = 0;
148     
149     // only moderators
150     /*
151     TO AVOID ANY BUGS, WE ALLOW MODERATORS TO HAVE PERMISSION TO ALL THESE FUNCTIONS AND UPDATE THEM IN EARLY BETA STAGE.
152     AFTER THE SYSTEM IS STABLE, WE WILL REMOVE OWNER OF THIS SMART CONTRACT AND ONLY KEEP ONE MODERATOR WHICH IS ETHEREMON BATTLE CONTRACT.
153     HENCE, THE DECENTRALIZED ATTRIBUTION IS GUARANTEED.
154     */
155     
156     function addCastle(address _trainer, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3, uint32 _brickNumber) onlyModerators external returns(uint32 currentCastleId){
157         currentCastleId = trainerCastle[_trainer];
158         if (currentCastleId > 0)
159             return currentCastleId;
160 
161         totalCastle += 1;
162         currentCastleId = totalCastle;
163         CastleData storage castle = castleData[currentCastleId];
164         castle.name = _name;
165         castle.owner = _trainer;
166         castle.monsters[0] = _a1;
167         castle.monsters[1] = _a2;
168         castle.monsters[2] = _a3;
169         castle.monsters[3] = _s1;
170         castle.monsters[4] = _s2;
171         castle.monsters[5] = _s3;
172         castle.brickNumber = _brickNumber;
173         castle.createTime = now;
174         
175         castle.index = ++activeCastleList.length;
176         activeCastleList[castle.index-1] = currentCastleId;
177         // mark sender
178         trainerCastle[_trainer] = currentCastleId;
179     }
180     
181     function renameCastle(uint32 _castleId, string _name) onlyModerators external {
182         CastleData storage castle = castleData[_castleId];
183         castle.name = _name;
184     }
185     
186     function removeCastleFromActive(uint32 _castleId) onlyModerators external {
187         CastleData storage castle = castleData[_castleId];
188         if (castle.index == 0)
189             return;
190         
191         trainerCastle[castle.owner] = 0;
192         if (castle.index <= activeCastleList.length) {
193             // Move an existing element into the vacated key slot.
194             castleData[activeCastleList[activeCastleList.length-1]].index = castle.index;
195             activeCastleList[castle.index-1] = activeCastleList[activeCastleList.length-1];
196             activeCastleList.length -= 1;
197             castle.index = 0;
198         }
199         
200         trannerBattleLog[castle.owner].lastCastle = _castleId;
201     }
202     
203     function addBattleLog(uint32 _castleId, address _attacker, 
204         uint8 _ran1, uint8 _ran2, uint8 _ran3, uint8 _result, uint32 _castleExp1, uint32 _castleExp2, uint32 _castleExp3) onlyModerators external returns(uint64) {
205         totalBattle += 1;
206         BattleDataLog storage battleLog = battles[totalBattle];
207         battleLog.castleId = _castleId;
208         battleLog.attacker = _attacker;
209         battleLog.randoms[0] = _ran1;
210         battleLog.randoms[1] = _ran2;
211         battleLog.randoms[2] = _ran3;
212         battleLog.result = _result;
213         battleLog.castleExps[0] = _castleExp1;
214         battleLog.castleExps[1] = _castleExp2;
215         battleLog.castleExps[2] = _castleExp3;
216         
217         // 
218         CastleData storage castle = castleData[_castleId];
219         TrainerBattleLog storage trainerLog = trannerBattleLog[_attacker];
220         /*
221         CASTLE_WIN = 0 
222         CASTLE_LOSE = 1 
223         CASTLE_DESTROYED= 2
224         */
225         if (_result == 0) { // win
226             castle.totalWin += 1;
227             trainerLog.totalLose += 1;              
228         } else {
229             castle.totalLose += 1;
230             trainerLog.totalWin += 1;
231             if (_result == 2) { // destroy
232                 trainerLog.totalBrick += castle.brickNumber / 2;
233             }
234         }
235 
236         castle.battleList[(castle.totalLose + castle.totalWin - 1)%NO_BATTLE_LOG] = totalBattle;
237         trainerLog.battleList[(trainerLog.totalWin + trainerLog.totalLose - 1)%NO_BATTLE_LOG] = totalBattle;
238         
239         return totalBattle;
240     }
241     
242     function addBattleLogMonsterInfo(uint64 _battleId, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3, uint32 _exp1, uint32 _exp2, uint32 _exp3) onlyModerators external {
243         BattleDataLog storage battleLog = battles[_battleId];
244         battleLog.attackerObjIds[0] = _a1;
245         battleLog.attackerObjIds[1] = _a2;
246         battleLog.attackerObjIds[2] = _a3;
247         battleLog.attackerObjIds[3] = _s1;
248         battleLog.attackerObjIds[4] = _s2;
249         battleLog.attackerObjIds[5] = _s3;
250         
251         battleLog.attackerExps[0] = _exp1;
252         battleLog.attackerExps[1] = _exp2;
253         battleLog.attackerExps[2] = _exp3;
254     }
255     
256     function deductTrainerBrick(address _trainer, uint32 _deductAmount) onlyModerators external returns(bool){
257         TrainerBattleLog storage trainerLog = trannerBattleLog[_trainer];
258         if (trainerLog.totalBrick < _deductAmount)
259             return false;
260         trainerLog.totalBrick -= _deductAmount;
261         return true;
262     }
263     
264     // read access 
265     function isCastleActive(uint32 _castleId) constant external returns(bool){
266         CastleData storage castle = castleData[_castleId];
267         return (castle.index > 0);
268     }
269     
270     function countActiveCastle() constant external returns(uint) {
271         return activeCastleList.length;
272     }
273     
274     function getActiveCastleId(uint index) constant external returns(uint32) {
275         return activeCastleList[index];
276     }
277     
278     function getCastleBasicInfo(address _owner) constant external returns(uint32, uint, uint32) {
279         uint32 currentCastleId = trainerCastle[_owner];
280         if (currentCastleId == 0)
281             return (0, 0, 0);
282         CastleData memory castle = castleData[currentCastleId];
283         return (currentCastleId, castle.index, castle.brickNumber);
284     }
285     
286     function getCastleBasicInfoById(uint32 _castleId) constant external returns(uint, address, uint32) {
287         CastleData memory castle = castleData[_castleId];
288         return (castle.index, castle.owner, castle.brickNumber);
289     }
290     
291     function getCastleObjInfo(uint32 _castleId) constant external returns(uint64, uint64, uint64, uint64, uint64, uint64) {
292         CastleData memory castle = castleData[_castleId];
293         return (castle.monsters[0], castle.monsters[1], castle.monsters[2], castle.monsters[3], castle.monsters[4], castle.monsters[5]);
294     }
295     
296     function getCastleWinLose(uint32 _castleId) constant external returns(uint32, uint32, uint32) {
297         CastleData memory castle = castleData[_castleId];
298         return (castle.totalWin, castle.totalLose, castle.brickNumber);
299     }
300     
301     function getCastleStats(uint32 _castleId) constant external returns(string, address, uint32, uint32, uint32, uint) {
302         CastleData memory castle = castleData[_castleId];
303         return (castle.name, castle.owner, castle.brickNumber, castle.totalWin, castle.totalLose, castle.createTime);
304     }
305 
306     function getBattleDataLog(uint64 _battleId) constant external returns(uint32, address, uint8, uint8, uint8, uint8, uint32, uint32, uint32) {
307         BattleDataLog memory battleLog = battles[_battleId];
308         return (battleLog.castleId, battleLog.attacker, battleLog.result, battleLog.randoms[0], battleLog.randoms[1], 
309             battleLog.randoms[2], battleLog.castleExps[0], battleLog.castleExps[1], battleLog.castleExps[2]);
310     }
311     
312     function getBattleAttackerLog(uint64 _battleId) constant external returns(uint64, uint64, uint64, uint64, uint64, uint64, uint32, uint32, uint32) {
313         BattleDataLog memory battleLog = battles[_battleId];
314         return (battleLog.attackerObjIds[0], battleLog.attackerObjIds[1], battleLog.attackerObjIds[2], battleLog.attackerObjIds[3], battleLog.attackerObjIds[4], 
315             battleLog.attackerObjIds[5], battleLog.attackerExps[0], battleLog.attackerExps[1], battleLog.attackerExps[2]);
316     }
317     
318     function getCastleBattleList(uint32 _castleId) constant external returns(uint64, uint64, uint64, uint64) {
319         CastleData storage castle = castleData[_castleId];
320         return (castle.battleList[0], castle.battleList[1], castle.battleList[2], castle.battleList[3]);
321     }
322     
323     function getTrainerBattleInfo(address _trainer) constant external returns(uint32, uint32, uint32, uint32, uint64, uint64, uint64, uint64) {
324         TrainerBattleLog memory trainerLog = trannerBattleLog[_trainer];
325         return (trainerLog.totalWin, trainerLog.totalLose, trainerLog.lastCastle, trainerLog.totalBrick, trainerLog.battleList[0], trainerLog.battleList[1], trainerLog.battleList[2], 
326             trainerLog.battleList[3]);
327     }
328     
329     function getTrainerBrick(address _trainer) constant external returns(uint32) {
330         return trannerBattleLog[_trainer].totalBrick;
331     }
332     
333     function isOnCastle(uint32 _castleId, uint64 _objId) constant external returns(bool) {
334         CastleData storage castle = castleData[_castleId];
335         if (castle.index > 0) {
336             for (uint i = 0; i < castle.monsters.length; i++)
337                 if (castle.monsters[i] == _objId)
338                     return true;
339             return false;
340         }
341         return false;
342     }
343 }