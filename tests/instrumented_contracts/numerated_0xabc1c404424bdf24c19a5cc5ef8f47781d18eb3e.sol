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
35     address[] public moderators;
36 
37     function BasicAccessControl() public {
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     modifier onlyModerators() {
47         if (msg.sender != owner) {
48             bool found = false;
49             for (uint index = 0; index < moderators.length; index++) {
50                 if (moderators[index] == msg.sender) {
51                     found = true;
52                     break;
53                 }
54             }
55             require(found);
56         }
57         _;
58     }
59 
60     function ChangeOwner(address _newOwner) onlyOwner public {
61         if (_newOwner != address(0)) {
62             owner = _newOwner;
63         }
64     }
65 
66     function Kill() onlyOwner public {
67         selfdestruct(owner);
68     }
69 
70     function AddModerator(address _newModerator) onlyOwner public {
71         if (_newModerator != address(0)) {
72             for (uint index = 0; index < moderators.length; index++) {
73                 if (moderators[index] == _newModerator) {
74                     return;
75                 }
76             }
77             moderators.push(_newModerator);
78         }
79     }
80     
81     function RemoveModerator(address _oldModerator) onlyOwner public {
82         uint foundIndex = 0;
83         for (; foundIndex < moderators.length; foundIndex++) {
84             if (moderators[foundIndex] == _oldModerator) {
85                 break;
86             }
87         }
88         if (foundIndex < moderators.length) {
89             moderators[foundIndex] = moderators[moderators.length-1];
90             delete moderators[moderators.length-1];
91             moderators.length--;
92         }
93     }
94 }
95 
96 
97 contract EtheremonEnum {
98 
99     enum ResultCode {
100         SUCCESS,
101         ERROR_CLASS_NOT_FOUND,
102         ERROR_LOW_BALANCE,
103         ERROR_SEND_FAIL,
104         ERROR_NOT_TRAINER,
105         ERROR_NOT_ENOUGH_MONEY,
106         ERROR_INVALID_AMOUNT
107     }
108     
109     enum ArrayType {
110         CLASS_TYPE,
111         STAT_STEP,
112         STAT_START,
113         STAT_BASE,
114         OBJ_SKILL
115     }
116 }
117 
118 contract EtheremonDataBase is EtheremonEnum, BasicAccessControl, SafeMath {
119     
120     uint64 public totalMonster;
121     uint32 public totalClass;
122     
123     // write
124     function addElementToArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);
125     function updateIndexOfArrayType(ArrayType _type, uint64 _id, uint _index, uint8 _value) onlyModerators public returns(uint);
126     function setMonsterClass(uint32 _classId, uint256 _price, uint256 _returnPrice, bool _catchable) onlyModerators public returns(uint32);
127     function addMonsterObj(uint32 _classId, address _trainer, string _name) onlyModerators public returns(uint64);
128     function setMonsterObj(uint64 _objId, string _name, uint32 _exp, uint32 _createIndex, uint32 _lastClaimIndex) onlyModerators public;
129     function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
130     function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
131     function removeMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
132     function addMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
133     function clearMonsterReturnBalance(uint64 _monsterId) onlyModerators public returns(uint256 amount);
134     function collectAllReturnBalance(address _trainer) onlyModerators public returns(uint256 amount);
135     function transferMonster(address _from, address _to, uint64 _monsterId) onlyModerators public returns(ResultCode);
136     function addExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
137     function deductExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
138     function setExtraBalance(address _trainer, uint256 _amount) onlyModerators public;
139     
140     // read
141     function getSizeArrayType(ArrayType _type, uint64 _id) constant public returns(uint);
142     function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);
143     function getMonsterClass(uint32 _classId) constant public returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);
144     function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
145     function getMonsterName(uint64 _objId) constant public returns(string name);
146     function getExtraBalance(address _trainer) constant public returns(uint256);
147     function getMonsterDexSize(address _trainer) constant public returns(uint);
148     function getMonsterObjId(address _trainer, uint index) constant public returns(uint64);
149     function getExpectedBalance(address _trainer) constant public returns(uint256);
150     function getMonsterReturn(uint64 _objId) constant public returns(uint256 current, uint256 total);
151 }
152 
153 contract EtheremonData is EtheremonDataBase {
154 
155     struct MonsterClass {
156         uint32 classId;
157         uint8[] types;
158         uint8[] statSteps;
159         uint8[] statStarts;
160         uint256 price;
161         uint256 returnPrice;
162         uint32 total;
163         bool catchable;
164     }
165     
166     struct MonsterObj {
167         uint64 monsterId;
168         uint32 classId;
169         address trainer;
170         string name;
171         uint32 exp;
172         uint8[] statBases;
173         uint8[] skills;
174         uint32 createIndex;
175         uint32 lastClaimIndex;
176         uint createTime;
177     }
178 
179     mapping(uint32 => MonsterClass) public monsterClass;
180     mapping(uint64 => MonsterObj) public monsterWorld;
181     mapping(address => uint64[]) public trainerDex;
182     mapping(address => uint256) public trainerExtraBalance;
183     
184     
185     // write access
186     function withdrawEther(address _sendTo, uint _amount) onlyOwner public returns(ResultCode) {
187         if (_amount > this.balance) {
188             return ResultCode.ERROR_INVALID_AMOUNT;
189         }
190         
191         _sendTo.transfer(_amount);
192         return ResultCode.SUCCESS;
193     }
194     
195     function addElementToArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint) {
196         uint8[] storage array = monsterWorld[_id].statBases;
197         if (_type == ArrayType.CLASS_TYPE) {
198             array = monsterClass[uint32(_id)].types;
199         } else if (_type == ArrayType.STAT_STEP) {
200             array = monsterClass[uint32(_id)].statSteps;
201         } else if (_type == ArrayType.STAT_START) {
202             array = monsterClass[uint32(_id)].statStarts;
203         } else if (_type == ArrayType.OBJ_SKILL) {
204             array = monsterWorld[_id].skills;
205         }
206         array.push(_value);
207         return array.length;
208     }
209     
210     function updateIndexOfArrayType(ArrayType _type, uint64 _id, uint _index, uint8 _value) onlyModerators public returns(uint) {
211         uint8[] storage array = monsterWorld[_id].statBases;
212         if (_type == ArrayType.CLASS_TYPE) {
213             array = monsterClass[uint32(_id)].types;
214         } else if (_type == ArrayType.STAT_STEP) {
215             array = monsterClass[uint32(_id)].statSteps;
216         } else if (_type == ArrayType.STAT_START) {
217             array = monsterClass[uint32(_id)].statStarts;
218         } else if (_type == ArrayType.OBJ_SKILL) {
219             array = monsterWorld[_id].skills;
220         }
221         if (_index < array.length) {
222             if (_value == 255) {
223                 // consider as delete
224                 for(uint i = _index; i < array.length - 1; i++) {
225                     array[i] = array[i+1];
226                 }
227                 delete array[array.length-1];
228                 array.length--;
229             } else {
230                 array[_index] = _value;
231             }
232         }
233     }
234     
235     function setMonsterClass(uint32 _classId, uint256 _price, uint256 _returnPrice, bool _catchable) onlyModerators public returns(uint32) {
236         MonsterClass storage class = monsterClass[_classId];
237         if (class.classId == 0) {
238             totalClass += 1;
239         }
240         class.classId = _classId;
241         class.price = _price;
242         class.returnPrice = _returnPrice;
243         class.catchable = _catchable;
244         return totalClass;
245     }
246     
247     function addMonsterObj(uint32 _classId, address _trainer, string _name) onlyModerators public returns(uint64) {
248         MonsterClass storage class = monsterClass[_classId];
249         if (class.classId == 0)
250             return 0;
251                 
252         // construct new monster
253         totalMonster += 1;
254         class.total += 1;
255 
256         MonsterObj storage obj = monsterWorld[totalMonster];
257         obj.monsterId = totalMonster;
258         obj.classId = _classId;
259         obj.trainer = _trainer;
260         obj.name = _name;
261         obj.exp = 1;
262         obj.createIndex = class.total;
263         obj.lastClaimIndex = class.total;
264         obj.createTime = now;
265 
266         // add to monsterdex
267         addMonsterIdMapping(_trainer, obj.monsterId);
268         return obj.monsterId;
269     }
270     
271     function setMonsterObj(uint64 _objId, string _name, uint32 _exp, uint32 _createIndex, uint32 _lastClaimIndex) onlyModerators public {
272         MonsterObj storage obj = monsterWorld[_objId];
273         if (obj.monsterId == _objId) {
274             obj.name = _name;
275             obj.exp = _exp;
276             obj.createIndex = _createIndex;
277             obj.lastClaimIndex = _lastClaimIndex;
278         }
279     }
280 
281     function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public {
282         MonsterObj storage obj = monsterWorld[_objId];
283         if (obj.monsterId == _objId) {
284             obj.exp = uint32(safeAdd(obj.exp, amount));
285         }
286     }
287 
288     function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public {
289         MonsterObj storage obj = monsterWorld[_objId];
290         if (obj.monsterId == _objId) {
291             obj.exp = uint32(safeSubtract(obj.exp, amount));
292         }
293     }
294 
295     function removeMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public {
296         uint foundIndex = 0;
297         uint64[] storage objIdList = trainerDex[_trainer];
298         for (; foundIndex < objIdList.length; foundIndex++) {
299             if (objIdList[foundIndex] == _monsterId) {
300                 break;
301             }
302         }
303         if (foundIndex < objIdList.length) {
304             objIdList[foundIndex] = objIdList[objIdList.length-1];
305             delete objIdList[objIdList.length-1];
306             objIdList.length--;
307             MonsterObj storage monster = monsterWorld[_monsterId];
308             monster.trainer = 0;
309         }
310     }
311     
312     function addMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public {
313         if (_trainer != address(0) && _monsterId > 0) {
314             uint64[] storage objIdList = trainerDex[_trainer];
315             for (uint i = 0; i < objIdList.length; i++) {
316                 if (objIdList[i] == _monsterId) {
317                     return;
318                 }
319             }
320             objIdList.push(_monsterId);
321             MonsterObj storage monster = monsterWorld[_monsterId];
322             monster.trainer = _trainer;
323         }
324     }
325     
326     function clearMonsterReturnBalance(uint64 _monsterId) onlyModerators public returns(uint256) {
327         MonsterObj storage monster = monsterWorld[_monsterId];
328         MonsterClass storage class = monsterClass[monster.classId];
329         if (monster.monsterId == 0 || class.classId == 0)
330             return 0;
331         uint256 amount = 0;
332         uint32 gap = uint32(safeSubtract(class.total, monster.lastClaimIndex));
333         if (gap > 0) {
334             monster.lastClaimIndex = class.total;
335             amount = safeMult(gap, class.returnPrice);
336             trainerExtraBalance[monster.trainer] = safeAdd(trainerExtraBalance[monster.trainer], amount);
337         }
338         return amount;
339     }
340     
341     function collectAllReturnBalance(address _trainer) onlyModerators public returns(uint256 amount) {
342         uint64[] storage objIdList = trainerDex[_trainer];
343         for (uint i = 0; i < objIdList.length; i++) {
344             clearMonsterReturnBalance(objIdList[i]);
345         }
346         return trainerExtraBalance[_trainer];
347     }
348     
349     function transferMonster(address _from, address _to, uint64 _monsterId) onlyModerators public returns(ResultCode) {
350         MonsterObj storage monster = monsterWorld[_monsterId];
351         if (monster.trainer != _from) {
352             return ResultCode.ERROR_NOT_TRAINER;
353         }
354         
355         clearMonsterReturnBalance(_monsterId);
356         
357         removeMonsterIdMapping(_from, _monsterId);
358         addMonsterIdMapping(_to, _monsterId);
359         return ResultCode.SUCCESS;
360     }
361     
362     function addExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256) {
363         trainerExtraBalance[_trainer] = safeAdd(trainerExtraBalance[_trainer], _amount);
364         return trainerExtraBalance[_trainer];
365     }
366     
367     function deductExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256) {
368         trainerExtraBalance[_trainer] = safeSubtract(trainerExtraBalance[_trainer], _amount);
369         return trainerExtraBalance[_trainer];
370     }
371     
372     function setExtraBalance(address _trainer, uint256 _amount) onlyModerators public {
373         trainerExtraBalance[_trainer] = _amount;
374     }
375     
376     
377     // public
378     function () payable public {
379         addExtraBalance(msg.sender, msg.value);
380     }
381 
382     // read access
383     function getSizeArrayType(ArrayType _type, uint64 _id) constant public returns(uint) {
384         uint8[] storage array = monsterWorld[_id].statBases;
385         if (_type == ArrayType.CLASS_TYPE) {
386             array = monsterClass[uint32(_id)].types;
387         } else if (_type == ArrayType.STAT_STEP) {
388             array = monsterClass[uint32(_id)].statSteps;
389         } else if (_type == ArrayType.STAT_START) {
390             array = monsterClass[uint32(_id)].statStarts;
391         } else if (_type == ArrayType.OBJ_SKILL) {
392             array = monsterWorld[_id].skills;
393         }
394         return array.length;
395     }
396     
397     function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8) {
398         uint8[] storage array = monsterWorld[_id].statBases;
399         if (_type == ArrayType.CLASS_TYPE) {
400             array = monsterClass[uint32(_id)].types;
401         } else if (_type == ArrayType.STAT_STEP) {
402             array = monsterClass[uint32(_id)].statSteps;
403         } else if (_type == ArrayType.STAT_START) {
404             array = monsterClass[uint32(_id)].statStarts;
405         } else if (_type == ArrayType.OBJ_SKILL) {
406             array = monsterWorld[_id].skills;
407         }
408         if (_index >= array.length)
409             return 0;
410         return array[_index];
411     }
412     
413     
414     function getMonsterClass(uint32 _classId) constant public returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable) {
415         MonsterClass storage class = monsterClass[_classId];
416         classId = class.classId;
417         price = class.price;
418         returnPrice = class.returnPrice;
419         total = class.total;
420         catchable = class.catchable;
421     }
422     
423     function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime) {
424         MonsterObj storage monster = monsterWorld[_objId];
425         objId = monster.monsterId;
426         classId = monster.classId;
427         trainer = monster.trainer;
428         exp = monster.exp;
429         createIndex = monster.createIndex;
430         lastClaimIndex = monster.lastClaimIndex;
431         createTime = monster.createTime;
432     }
433     
434     function getMonsterName(uint64 _objId) constant public returns(string name) {
435         return monsterWorld[_objId].name;
436     }
437 
438     function getExtraBalance(address _trainer) constant public returns(uint256) {
439         return trainerExtraBalance[_trainer];
440     }
441     
442     function getMonsterDexSize(address _trainer) constant public returns(uint) {
443         return trainerDex[_trainer].length;
444     }
445     
446     function getMonsterObjId(address _trainer, uint index) constant public returns(uint64) {
447         if (index >= trainerDex[_trainer].length)
448             return 0;
449         return trainerDex[_trainer][index];
450     }
451     
452     function getExpectedBalance(address _trainer) constant public returns(uint256) {
453         uint64[] storage objIdList = trainerDex[_trainer];
454         uint256 monsterBalance = 0;
455         for (uint i = 0; i < objIdList.length; i++) {
456             MonsterObj memory monster = monsterWorld[objIdList[i]];
457             MonsterClass storage class = monsterClass[monster.classId];
458             uint32 gap = uint32(safeSubtract(class.total, monster.lastClaimIndex));
459             monsterBalance += safeMult(gap, class.returnPrice);
460         }
461         return monsterBalance;
462     }
463     
464     function getMonsterReturn(uint64 _objId) constant public returns(uint256 current, uint256 total) {
465         MonsterObj memory monster = monsterWorld[_objId];
466         MonsterClass storage class = monsterClass[monster.classId];
467         uint32 totalGap = uint32(safeSubtract(class.total, monster.createIndex));
468         uint32 currentGap = uint32(safeSubtract(class.total, monster.lastClaimIndex));
469         return (safeMult(currentGap, class.returnPrice), safeMult(totalGap, class.returnPrice));
470     }
471 
472 }