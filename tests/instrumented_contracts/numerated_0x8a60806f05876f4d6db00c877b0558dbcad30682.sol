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
153 contract EtheremonProcessor is EtheremonEnum, BasicAccessControl, SafeMath {
154     
155     uint8 public STAT_COUNT = 6;
156     uint8 public STAT_MAX = 32;
157     
158     struct MonsterClassAcc {
159         uint32 classId;
160         uint256 price;
161         uint256 returnPrice;
162         uint32 total;
163         bool catchable;
164     }
165 
166     struct MonsterObjAcc {
167         uint64 monsterId;
168         uint32 classId;
169         address trainer;
170         string name;
171         uint32 exp;
172         uint32 createIndex;
173         uint32 lastClaimIndex;
174         uint createTime;
175     }
176     
177     // data contract
178     address public dataContract;
179     
180     function EtheremonProcessor(address _dataContract) public {
181         dataContract = _dataContract;
182     }
183 
184     // internal
185     modifier requireDataContract {
186         require(dataContract != 0x0);
187         _;
188     }
189     
190 
191     // event
192     event EventCatchMonster(address indexed trainer, ResultCode result, uint64 objId);
193     event EventCashOut(address indexed trainer, ResultCode result, uint256 amount);
194     event EventWithdrawEther(address indexed sendTo, ResultCode result, uint256 amount);
195  
196      // admin
197     function withdrawEther(address _sendTo, uint _amount) onlyOwner public returns(ResultCode) {
198         if (_amount > this.balance) {
199             EventWithdrawEther(_sendTo, ResultCode.ERROR_INVALID_AMOUNT, 0);
200             return ResultCode.ERROR_INVALID_AMOUNT;
201         }
202         
203         _sendTo.transfer(_amount);
204         EventWithdrawEther(_sendTo, ResultCode.SUCCESS, _amount);
205         return ResultCode.SUCCESS;
206     }
207     
208     function setDataContract(address _dataContract) onlyModerators public {
209         dataContract = _dataContract;
210     }
211     
212     function addMonsterClassBasic(uint32 _classId, uint8 _type, uint256 _price, uint256 _returnPrice,
213         uint8 _ss1, uint8 _ss2, uint8 _ss3, uint8 _ss4, uint8 _ss5, uint8 _ss6) onlyModerators public {
214             
215         EtheremonDataBase data = EtheremonDataBase(dataContract);
216         data.setMonsterClass(_classId, _price, _returnPrice, true);
217         data.addElementToArrayType(ArrayType.CLASS_TYPE, uint64(_classId), _type);
218         
219         // add stat step
220         data.addElementToArrayType(ArrayType.STAT_START, uint64(_classId), _ss1);
221         data.addElementToArrayType(ArrayType.STAT_START, uint64(_classId), _ss2);
222         data.addElementToArrayType(ArrayType.STAT_START, uint64(_classId), _ss3);
223         data.addElementToArrayType(ArrayType.STAT_START, uint64(_classId), _ss4);
224         data.addElementToArrayType(ArrayType.STAT_START, uint64(_classId), _ss5);
225         data.addElementToArrayType(ArrayType.STAT_START, uint64(_classId), _ss6);
226         
227     }
228     
229     function addMonsterClassExtend(uint32 _classId, uint8 _type2, uint8 _type3, 
230         uint8 _st1, uint8 _st2, uint8 _st3, uint8 _st4, uint8 _st5, uint8 _st6 ) onlyModerators public {
231         
232         EtheremonDataBase data = EtheremonDataBase(dataContract);
233         if (_type2 > 0) {
234             data.addElementToArrayType(ArrayType.CLASS_TYPE, uint64(_classId), _type2);
235         }
236         if (_type3 > 0) {
237             data.addElementToArrayType(ArrayType.CLASS_TYPE, uint64(_classId), _type3);
238         }
239         
240         // add stat base
241         data.addElementToArrayType(ArrayType.STAT_STEP, uint64(_classId), _st1);
242         data.addElementToArrayType(ArrayType.STAT_STEP, uint64(_classId), _st2);
243         data.addElementToArrayType(ArrayType.STAT_STEP, uint64(_classId), _st3);
244         data.addElementToArrayType(ArrayType.STAT_STEP, uint64(_classId), _st4);
245         data.addElementToArrayType(ArrayType.STAT_STEP, uint64(_classId), _st5);
246         data.addElementToArrayType(ArrayType.STAT_STEP, uint64(_classId), _st6);
247         
248     }
249     
250     // helper
251     function getRandom(uint8 maxRan, uint8 index) constant public returns(uint8) {
252         uint256 genNum = uint256(block.blockhash(block.number-1));
253         for (uint8 i = 0; i < index && i < 6; i ++) {
254             genNum /= 256;
255         }
256         return uint8(genNum % maxRan);
257     }
258     
259     function () payable public {
260         EtheremonDataBase data = EtheremonDataBase(dataContract);
261         data.addExtraBalance(msg.sender, msg.value);
262     }
263     
264     // public
265     
266     function catchMonster(uint32 _classId, string _name) requireDataContract public payable returns(ResultCode) {
267         EtheremonDataBase data = EtheremonDataBase(dataContract);
268         MonsterClassAcc memory class;
269         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
270         
271         if (class.classId == 0 || class.catchable == false) {
272             EventCatchMonster(msg.sender, ResultCode.ERROR_CLASS_NOT_FOUND, 0);
273             return ResultCode.ERROR_CLASS_NOT_FOUND;
274         }
275         
276         uint256 totalBalance = safeAdd(msg.value, data.getExtraBalance(msg.sender));
277         uint256 payPrice = class.price;
278         if (payPrice > totalBalance) {
279             data.addExtraBalance(msg.sender, msg.value);
280             EventCatchMonster(msg.sender, ResultCode.ERROR_LOW_BALANCE, 0);
281             return ResultCode.ERROR_LOW_BALANCE;
282         }
283         
284         // deduct the balance
285         data.setExtraBalance(msg.sender, safeSubtract(totalBalance, payPrice));
286         
287         // add monster
288         uint64 objId = data.addMonsterObj(_classId, msg.sender, _name);
289         // generate base stat
290         for (uint i=0; i < STAT_COUNT; i+= 1) {
291             uint8 value = getRandom(STAT_MAX, uint8(i)) + data.getElementInArrayType(ArrayType.STAT_START, uint64(_classId), i);
292             data.addElementToArrayType(ArrayType.STAT_BASE, objId, value);
293         }
294 
295         // calculate the price
296         uint256 distributedPrice = safeMult(class.returnPrice, class.total + 2);
297         if (payPrice < distributedPrice) {
298             payPrice = distributedPrice;
299             // update price
300             data.setMonsterClass(_classId, distributedPrice, class.returnPrice, true);
301         }
302         
303         EventCatchMonster(msg.sender, ResultCode.SUCCESS, objId);
304         return ResultCode.SUCCESS;
305     }
306     
307     function cashOut(uint256 _amount) requireDataContract public returns(ResultCode) {
308         EtheremonDataBase data = EtheremonDataBase(dataContract);
309         
310         uint256 totalAmount = data.collectAllReturnBalance(msg.sender);
311         // default to cash out all
312         if (_amount == 0) {
313             _amount = totalAmount;
314         }
315         if (_amount > totalAmount) {
316             EventCashOut(msg.sender, ResultCode.ERROR_LOW_BALANCE, 0);
317             return ResultCode.ERROR_LOW_BALANCE;
318         }
319         
320         // check contract has enough money
321         if (this.balance < _amount) {
322             EventCashOut(msg.sender, ResultCode.ERROR_NOT_ENOUGH_MONEY, 0);
323             return ResultCode.ERROR_NOT_ENOUGH_MONEY;
324         }
325         
326         if (_amount > 0) {
327             data.deductExtraBalance(msg.sender, _amount);
328             if (!msg.sender.send(_amount)) {
329                 data.addExtraBalance(msg.sender, _amount);
330                 EventCashOut(msg.sender, ResultCode.ERROR_SEND_FAIL, 0);
331                 return ResultCode.ERROR_SEND_FAIL;
332             }
333         }
334         
335         EventCashOut(msg.sender, ResultCode.SUCCESS, _amount);
336         return ResultCode.SUCCESS;
337     }
338     
339     function getTrainerBalance(address _trainer) constant public returns(uint256) {
340         EtheremonDataBase data = EtheremonDataBase(dataContract);
341         return data.getExpectedBalance(_trainer);
342     }
343     
344     function getMonsterClassBasic(uint32 _classId) constant public returns(uint256, uint256, uint256, bool) {
345         EtheremonDataBase data = EtheremonDataBase(dataContract);
346         MonsterClassAcc memory class;
347         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
348         return (class.price, class.returnPrice, class.total, class.catchable);
349     }
350 
351     function getLevel(uint32 exp) pure internal returns (uint8) {
352         uint8 level = 1;
353         uint8 requirement = 100;
354         while(level < 100 && exp > requirement) {
355             exp -= requirement;
356             level += 1;
357             requirement = requirement * 12 / 10 + 5;
358         }
359         return level;
360     }
361 
362     function getMonsterLevel(uint64 _objId) constant public returns(uint8) {
363         EtheremonDataBase data = EtheremonDataBase(dataContract);
364         MonsterObjAcc memory obj;
365         uint32 _ = 0;
366         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
367      
368         return getLevel(obj.exp);
369     }
370     
371     function getMonsterCP(uint64 _objId) constant public returns(uint64) {
372         EtheremonDataBase data = EtheremonDataBase(dataContract);
373         MonsterObjAcc memory obj;
374         uint32 _ = 0;
375         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
376      
377         uint baseSize = data.getSizeArrayType(ArrayType.STAT_BASE, obj.monsterId);
378         if (baseSize == 0)
379             return 0;
380         
381         uint256 total = 0;
382         for(uint i=0; i < baseSize; i+=1) {
383             total += data.getElementInArrayType(ArrayType.STAT_BASE, obj.monsterId, i);
384             total += safeMult(data.getElementInArrayType(ArrayType.STAT_STEP, uint64(obj.classId), i), getLevel(obj.exp));
385         }
386         
387         return uint64(total/baseSize);
388     }
389 }