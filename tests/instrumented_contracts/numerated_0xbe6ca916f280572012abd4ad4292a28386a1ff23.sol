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
125     function removeElementOfArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);
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
206         for (uint index = 0; index < array.length; index++) {
207             if (array[index] == _value) {
208                 return array.length;
209             }
210         }
211         array.push(_value);
212         return array.length;
213     }
214     
215     function removeElementOfArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint) {
216         uint8[] storage array = monsterWorld[_id].statBases;
217         if (_type == ArrayType.CLASS_TYPE) {
218             array = monsterClass[uint32(_id)].types;
219         } else if (_type == ArrayType.STAT_STEP) {
220             array = monsterClass[uint32(_id)].statSteps;
221         } else if (_type == ArrayType.STAT_START) {
222             array = monsterClass[uint32(_id)].statStarts;
223         } else if (_type == ArrayType.OBJ_SKILL) {
224             array = monsterWorld[_id].skills;
225         }
226         uint foundIndex = 0;
227         for (; foundIndex < array.length; foundIndex++) {
228             if (array[foundIndex] == _value) {
229                 break;
230             }
231         }
232         if (foundIndex < array.length) {
233             array[foundIndex] = array[array.length-1];
234             delete array[array.length-1];
235             array.length--;
236         }
237     }
238     
239     function setMonsterClass(uint32 _classId, uint256 _price, uint256 _returnPrice, bool _catchable) onlyModerators public returns(uint32) {
240         MonsterClass storage class = monsterClass[_classId];
241         if (class.classId == 0) {
242             totalClass += 1;
243         }
244         class.classId = _classId;
245         class.price = _price;
246         class.returnPrice = _returnPrice;
247         class.catchable = _catchable;
248         return totalClass;
249     }
250     
251     function addMonsterObj(uint32 _classId, address _trainer, string _name) onlyModerators public returns(uint64) {
252         MonsterClass storage class = monsterClass[_classId];
253         if (class.classId == 0)
254             return 0;
255                 
256         // construct new monster
257         totalMonster += 1;
258         class.total += 1;
259 
260         MonsterObj storage obj = monsterWorld[totalMonster];
261         obj.monsterId = totalMonster;
262         obj.classId = _classId;
263         obj.trainer = _trainer;
264         obj.name = _name;
265         obj.exp = 1;
266         obj.createIndex = class.total;
267         obj.lastClaimIndex = class.total;
268         obj.createTime = now;
269 
270         // add to monsterdex
271         addMonsterIdMapping(_trainer, obj.monsterId);
272         return obj.monsterId;
273     }
274     
275     function setMonsterObj(uint64 _objId, string _name, uint32 _exp, uint32 _createIndex, uint32 _lastClaimIndex) onlyModerators public {
276         MonsterObj storage obj = monsterWorld[_objId];
277         if (obj.monsterId == _objId) {
278             obj.name = _name;
279             obj.exp = _exp;
280             obj.createIndex = _createIndex;
281             obj.lastClaimIndex = _lastClaimIndex;
282         }
283     }
284 
285     function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public {
286         MonsterObj storage obj = monsterWorld[_objId];
287         if (obj.monsterId == _objId) {
288             obj.exp = uint32(safeAdd(obj.exp, amount));
289         }
290     }
291 
292     function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public {
293         MonsterObj storage obj = monsterWorld[_objId];
294         if (obj.monsterId == _objId) {
295             obj.exp = uint32(safeSubtract(obj.exp, amount));
296         }
297     }
298 
299     function removeMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public {
300         uint foundIndex = 0;
301         uint64[] storage objIdList = trainerDex[_trainer];
302         for (; foundIndex < objIdList.length; foundIndex++) {
303             if (objIdList[foundIndex] == _monsterId) {
304                 break;
305             }
306         }
307         if (foundIndex < objIdList.length) {
308             objIdList[foundIndex] = objIdList[objIdList.length-1];
309             delete objIdList[objIdList.length-1];
310             objIdList.length--;
311             MonsterObj storage monster = monsterWorld[_monsterId];
312             monster.trainer = 0;
313         }
314     }
315     
316     function addMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public {
317         if (_trainer != address(0) && _monsterId > 0) {
318             uint64[] storage objIdList = trainerDex[_trainer];
319             for (uint i = 0; i < objIdList.length; i++) {
320                 if (objIdList[i] == _monsterId) {
321                     return;
322                 }
323             }
324             objIdList.push(_monsterId);
325             MonsterObj storage monster = monsterWorld[_monsterId];
326             monster.trainer = _trainer;
327         }
328     }
329     
330     function clearMonsterReturnBalance(uint64 _monsterId) onlyModerators public returns(uint256) {
331         MonsterObj storage monster = monsterWorld[_monsterId];
332         MonsterClass storage class = monsterClass[monster.classId];
333         if (monster.monsterId == 0 || class.classId == 0)
334             return 0;
335         uint256 amount = 0;
336         uint32 gap = uint32(safeSubtract(class.total, monster.lastClaimIndex));
337         if (gap > 0) {
338             monster.lastClaimIndex = class.total;
339             amount = safeMult(gap, class.returnPrice);
340             trainerExtraBalance[monster.trainer] = safeAdd(trainerExtraBalance[monster.trainer], amount);
341         }
342         return amount;
343     }
344     
345     function collectAllReturnBalance(address _trainer) onlyModerators public returns(uint256 amount) {
346         uint64[] storage objIdList = trainerDex[_trainer];
347         for (uint i = 0; i < objIdList.length; i++) {
348             clearMonsterReturnBalance(objIdList[i]);
349         }
350         return trainerExtraBalance[_trainer];
351     }
352     
353     function transferMonster(address _from, address _to, uint64 _monsterId) onlyModerators public returns(ResultCode) {
354         MonsterObj storage monster = monsterWorld[_monsterId];
355         if (monster.trainer != _from) {
356             return ResultCode.ERROR_NOT_TRAINER;
357         }
358         
359         clearMonsterReturnBalance(_monsterId);
360         
361         removeMonsterIdMapping(_from, _monsterId);
362         addMonsterIdMapping(_to, _monsterId);
363         return ResultCode.SUCCESS;
364     }
365     
366     function addExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256) {
367         trainerExtraBalance[_trainer] = safeAdd(trainerExtraBalance[_trainer], _amount);
368         return trainerExtraBalance[_trainer];
369     }
370     
371     function deductExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256) {
372         trainerExtraBalance[_trainer] = safeSubtract(trainerExtraBalance[_trainer], _amount);
373         return trainerExtraBalance[_trainer];
374     }
375     
376     function setExtraBalance(address _trainer, uint256 _amount) onlyModerators public {
377         trainerExtraBalance[_trainer] = _amount;
378     }
379     
380     
381     // public
382     function () payable public {
383         addExtraBalance(msg.sender, msg.value);
384     }
385 
386     // read access
387     function getSizeArrayType(ArrayType _type, uint64 _id) constant public returns(uint) {
388         uint8[] storage array = monsterWorld[_id].statBases;
389         if (_type == ArrayType.CLASS_TYPE) {
390             array = monsterClass[uint32(_id)].types;
391         } else if (_type == ArrayType.STAT_STEP) {
392             array = monsterClass[uint32(_id)].statSteps;
393         } else if (_type == ArrayType.STAT_START) {
394             array = monsterClass[uint32(_id)].statStarts;
395         } else if (_type == ArrayType.OBJ_SKILL) {
396             array = monsterWorld[_id].skills;
397         }
398         return array.length;
399     }
400     
401     function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8) {
402         uint8[] storage array = monsterWorld[_id].statBases;
403         if (_type == ArrayType.CLASS_TYPE) {
404             array = monsterClass[uint32(_id)].types;
405         } else if (_type == ArrayType.STAT_STEP) {
406             array = monsterClass[uint32(_id)].statSteps;
407         } else if (_type == ArrayType.STAT_START) {
408             array = monsterClass[uint32(_id)].statStarts;
409         } else if (_type == ArrayType.OBJ_SKILL) {
410             array = monsterWorld[_id].skills;
411         }
412         if (_index >= array.length)
413             return 0;
414         return array[_index];
415     }
416     
417     
418     function getMonsterClass(uint32 _classId) constant public returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable) {
419         MonsterClass storage class = monsterClass[_classId];
420         classId = class.classId;
421         price = class.price;
422         returnPrice = class.returnPrice;
423         total = class.total;
424         catchable = class.catchable;
425     }
426     
427     function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime) {
428         MonsterObj storage monster = monsterWorld[_objId];
429         objId = monster.monsterId;
430         classId = monster.classId;
431         trainer = monster.trainer;
432         exp = monster.exp;
433         createIndex = monster.createIndex;
434         lastClaimIndex = monster.lastClaimIndex;
435         createTime = monster.createTime;
436     }
437     
438     function getMonsterName(uint64 _objId) constant public returns(string name) {
439         return monsterWorld[_objId].name;
440     }
441 
442     function getExtraBalance(address _trainer) constant public returns(uint256) {
443         return trainerExtraBalance[_trainer];
444     }
445     
446     function getMonsterDexSize(address _trainer) constant public returns(uint) {
447         return trainerDex[_trainer].length;
448     }
449     
450     function getMonsterObjId(address _trainer, uint index) constant public returns(uint64) {
451         if (index >= trainerDex[_trainer].length)
452             return 0;
453         return trainerDex[_trainer][index];
454     }
455     
456     function getExpectedBalance(address _trainer) constant public returns(uint256) {
457         uint64[] storage objIdList = trainerDex[_trainer];
458         uint256 monsterBalance = 0;
459         for (uint i = 0; i < objIdList.length; i++) {
460             MonsterObj memory monster = monsterWorld[objIdList[i]];
461             MonsterClass storage class = monsterClass[monster.classId];
462             uint32 gap = uint32(safeSubtract(class.total, monster.lastClaimIndex));
463             monsterBalance += safeMult(gap, class.returnPrice);
464         }
465         return monsterBalance;
466     }
467     
468     function getMonsterReturn(uint64 _objId) constant public returns(uint256 current, uint256 total) {
469         MonsterObj memory monster = monsterWorld[_objId];
470         MonsterClass storage class = monsterClass[monster.classId];
471         uint32 totalGap = uint32(safeSubtract(class.total, monster.createIndex));
472         uint32 currentGap = uint32(safeSubtract(class.total, monster.lastClaimIndex));
473         return (safeMult(currentGap, class.returnPrice), safeMult(totalGap, class.returnPrice));
474     }
475 
476 }