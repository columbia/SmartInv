1 pragma solidity ^0.4.24;
2 
3 // File: SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: FrozenChecker.sol
56 
57 /**
58  * @title FrozenChecker
59  * @dev Check account by frozen rules
60  */
61 library FrozenChecker {
62 
63     using SafeMath for uint256;
64 
65     /**
66      * Rule for each address
67      */
68     struct Rule {
69         uint256 timeT;
70         uint8 initPercent;
71         uint256[] periods;
72         uint8[] percents;
73     }
74 
75     function check(Rule storage self, uint256 totalFrozenValue) internal view returns (uint256) {
76         if (totalFrozenValue == uint256(0)) {
77             return 0;
78         }
79         //uint8 temp = self.initPercent;
80         if (self.timeT == uint256(0) || self.timeT > now) {
81             return totalFrozenValue.sub(totalFrozenValue.mul(self.initPercent).div(100));
82         }
83         for (uint256 i = 0; i < self.periods.length.sub(1); i = i.add(1)) {
84             if (now >= self.timeT.add(self.periods[i]) && now < self.timeT.add(self.periods[i.add(1)])) {
85                 return totalFrozenValue.sub(totalFrozenValue.mul(self.percents[i]).div(100));
86             }
87         }
88         if (now >= self.timeT.add(self.periods[self.periods.length.sub(1)])) {
89             return totalFrozenValue.sub(totalFrozenValue.mul(self.percents[self.periods.length.sub(1)]).div(100));
90         }
91     }
92 
93 }
94 
95 // File: FrozenValidator.sol
96 
97 library FrozenValidator {
98     
99     using SafeMath for uint256;
100     using FrozenChecker for FrozenChecker.Rule;
101 
102     struct Validator {
103         mapping(address => IndexValue) data;
104         KeyFlag[] keys;
105         uint256 size;
106     }
107 
108     struct IndexValue {
109         uint256 keyIndex; 
110         FrozenChecker.Rule rule;
111         mapping (address => uint256) frozenBalances;
112     }
113 
114     struct KeyFlag { 
115         address key; 
116         bool deleted; 
117     }
118 
119     function addRule(Validator storage self, address key, uint8 initPercent, uint256[] periods, uint8[] percents) internal returns (bool replaced) {
120         //require(self.size <= 10);
121         require(key != address(0));
122         require(periods.length == percents.length);
123         require(periods.length > 0);
124         require(periods[0] == uint256(0));
125         require(initPercent <= percents[0]);
126         for (uint256 i = 1; i < periods.length; i = i.add(1)) {
127             require(periods[i.sub(1)] < periods[i]);
128             require(percents[i.sub(1)] <= percents[i]);
129         }
130         require(percents[percents.length.sub(1)] == 100);
131         FrozenChecker.Rule memory rule = FrozenChecker.Rule(0, initPercent, periods, percents);
132         uint256 keyIndex = self.data[key].keyIndex;
133         self.data[key].rule = rule;
134         if (keyIndex > 0) {
135             return true;
136         } else {
137             keyIndex = self.keys.length++;
138             self.data[key].keyIndex = keyIndex.add(1);
139             self.keys[keyIndex].key = key;
140             self.size++;
141             return false;
142         }
143     }
144 
145     function removeRule(Validator storage self, address key) internal returns (bool success) {
146         uint256 keyIndex = self.data[key].keyIndex;
147         if (keyIndex == 0) {
148             return false;
149         }
150         delete self.data[key];
151         self.keys[keyIndex.sub(1)].deleted = true;
152         self.size--;
153         return true;
154     }
155 
156     function containRule(Validator storage self, address key) internal view returns (bool) {
157         return self.data[key].keyIndex > 0;
158     }
159 
160     function addTimeT(Validator storage self, address addr, uint256 timeT) internal returns (bool) {
161         require(timeT > now);
162         self.data[addr].rule.timeT = timeT;
163         return true;
164     }
165 
166     function addFrozenBalance(Validator storage self, address from, address to, uint256 value) internal returns (uint256) {
167         self.data[from].frozenBalances[to] = self.data[from].frozenBalances[to].add(value);
168         return self.data[from].frozenBalances[to];
169     }
170 
171     function validate(Validator storage self, address addr) internal view returns (uint256) {
172         uint256 frozenTotal = 0;
173         for (uint256 i = iterateStart(self); iterateValid(self, i); i = iterateNext(self, i)) {
174             address ruleaddr = iterateGet(self, i);
175             FrozenChecker.Rule storage rule = self.data[ruleaddr].rule;
176             frozenTotal = frozenTotal.add(rule.check(self.data[ruleaddr].frozenBalances[addr]));
177         }
178         return frozenTotal;
179     }
180 
181 
182     function iterateStart(Validator storage self) internal view returns (uint256 keyIndex) {
183         return iterateNext(self, uint256(-1));
184     }
185 
186     function iterateValid(Validator storage self, uint256 keyIndex) internal view returns (bool) {
187         return keyIndex < self.keys.length;
188     }
189 
190     function iterateNext(Validator storage self, uint256 keyIndex) internal view returns (uint256) {
191         keyIndex++;
192         while (keyIndex < self.keys.length && self.keys[keyIndex].deleted) {
193             keyIndex++;
194         }
195         return keyIndex;
196     }
197 
198     function iterateGet(Validator storage self, uint256 keyIndex) internal view returns (address) {
199         return self.keys[keyIndex].key;
200     }
201 }
202 
203 // File: YottaCoin.sol
204 
205 contract YottaCoin {
206 
207     using SafeMath for uint256;
208     using FrozenValidator for FrozenValidator.Validator;
209 
210     mapping (address => uint256) internal balances;
211     mapping (address => mapping (address => uint256)) internal allowed;
212 
213     //--------------------------------  Basic Info  -------------------------------------//
214 
215     string public name;
216     string public symbol;
217     uint8 public decimals;
218     uint256 public totalSupply;
219 
220     //--------------------------------  Basic Info  -------------------------------------//
221 
222 
223     //--------------------------------  Admin Info  -------------------------------------//
224 
225     address internal admin;  //Admin address
226 
227     /**
228      * @dev Change admin address
229      * @param newAdmin New admin address
230      */
231     function changeAdmin(address newAdmin) public returns (bool)  {
232         require(msg.sender == admin);
233         require(newAdmin != address(0));
234         uint256 balAdmin = balances[admin];
235         balances[newAdmin] = balances[newAdmin].add(balAdmin);
236         balances[admin] = 0;
237         admin = newAdmin;
238         emit Transfer(admin, newAdmin, balAdmin);
239         return true;
240     }
241 
242     //--------------------------------  Admin Info  -------------------------------------//
243 
244 
245     //--------------------------  Events & Constructor  ------------------------------//
246     
247     event Approval(address indexed owner, address indexed spender, uint256 value);
248     event Transfer(address indexed from, address indexed to, uint256 value);
249 
250     // constructor
251     constructor(string tokenName, string tokenSymbol, uint8 tokenDecimals, uint256 totalTokenSupply ) public {
252         name = tokenName;
253         symbol = tokenSymbol;
254         decimals = tokenDecimals;
255         totalSupply = totalTokenSupply;
256         admin = msg.sender;
257         balances[msg.sender] = totalTokenSupply;
258         emit Transfer(0x0, msg.sender, totalTokenSupply);
259 
260     }
261 
262     //--------------------------  Events & Constructor  ------------------------------//
263 
264 
265 
266     //------------------------------ Account lock  -----------------------------------//
267 
268     // 同一个账户满足任意冻结条件均被冻结
269     mapping (address => bool) frozenAccount; //无限期冻结的账户
270     mapping (address => uint256) frozenTimestamp; // 有限期冻结的账户
271 
272     /**
273      * 查询账户是否存在锁定时间戳
274      */
275     function getFrozenTimestamp(address _target) public view returns (uint256) {
276         return frozenTimestamp[_target];
277     }
278 
279     /**
280      * 查询账户是否被锁定
281      */
282     function getFrozenAccount(address _target) public view returns (bool) {
283         return frozenAccount[_target];
284     }
285 
286     /**
287      * 锁定账户
288      */
289     function freeze(address _target, bool _freeze) public returns (bool) {
290         require(msg.sender == admin);
291         require(_target != admin);
292         frozenAccount[_target] = _freeze;
293         return true;
294     }
295 
296     /**
297      * 通过时间戳锁定账户
298      */
299     function freezeWithTimestamp(address _target, uint256 _timestamp) public returns (bool) {
300         require(msg.sender == admin);
301         require(_target != admin);
302         frozenTimestamp[_target] = _timestamp;
303         return true;
304     }
305 
306     /**
307      * 批量锁定账户
308      */
309     function multiFreeze(address[] _targets, bool[] _freezes) public returns (bool) {
310         require(msg.sender == admin);
311         require(_targets.length == _freezes.length);
312         uint256 len = _targets.length;
313         require(len > 0);
314         for (uint256 i = 0; i < len; i = i.add(1)) {
315             address _target = _targets[i];
316             require(_target != admin);
317             bool _freeze = _freezes[i];
318             frozenAccount[_target] = _freeze;
319         }
320         return true;
321     }
322 
323     /**
324      * 批量通过时间戳锁定账户
325      */
326     function multiFreezeWithTimestamp(address[] _targets, uint256[] _timestamps) public returns (bool) {
327         require(msg.sender == admin);
328         require(_targets.length == _timestamps.length);
329         uint256 len = _targets.length;
330         require(len > 0);
331         for (uint256 i = 0; i < len; i = i.add(1)) {
332             address _target = _targets[i];
333             require(_target != admin);
334             uint256 _timestamp = _timestamps[i];
335             frozenTimestamp[_target] = _timestamp;
336         }
337         return true;
338     }
339 
340     //------------------------------  Account lock  -----------------------------------//
341 
342 
343 
344 
345     //--------------------------      Frozen rules      ------------------------------//
346 
347     FrozenValidator.Validator validator;
348 
349     function addRule(address addr, uint8 initPercent, uint256[] periods, uint8[] percents) public returns (bool) {
350         require(msg.sender == admin);
351         return validator.addRule(addr, initPercent, periods, percents);
352     }
353 
354     function addTimeT(address addr, uint256 timeT) public returns (bool) {
355         require(msg.sender == admin);
356         return validator.addTimeT(addr, timeT);
357     }
358 
359     function removeRule(address addr) public returns (bool) {
360         require(msg.sender == admin);
361         return validator.removeRule(addr);
362     }
363 
364     //--------------------------      Frozen rules      ------------------------------//
365 
366 
367 
368 
369     //-------------------------  Standard ERC20 Interfaces  --------------------------//
370 
371     function multiTransfer(address[] _tos, uint256[] _values) public returns (bool) {
372         require(!frozenAccount[msg.sender]);
373         require(now > frozenTimestamp[msg.sender]);
374         require(_tos.length == _values.length);
375         uint256 len = _tos.length;
376         require(len > 0);
377         uint256 amount = 0;
378         for (uint256 i = 0; i < len; i = i.add(1)) {
379             amount = amount.add(_values[i]);
380         }
381         require(amount <= balances[msg.sender].sub(validator.validate(msg.sender)));
382         for (uint256 j = 0; j < len; j = j.add(1)) {
383             address _to = _tos[j];
384             if (validator.containRule(msg.sender) && msg.sender != _to) {
385                 validator.addFrozenBalance(msg.sender, _to, _values[j]);
386             }
387             balances[_to] = balances[_to].add(_values[j]);
388             balances[msg.sender] = balances[msg.sender].sub(_values[j]);
389             emit Transfer(msg.sender, _to, _values[j]);
390         }
391         return true;
392     }
393 
394     function transfer(address _to, uint256 _value) public returns (bool) {
395         transferfix(_to, _value);
396         return true;
397     }
398 
399     function transferfix(address _to, uint256 _value) public {
400         require(!frozenAccount[msg.sender]);
401         require(now > frozenTimestamp[msg.sender]);
402         require(balances[msg.sender].sub(_value) >= validator.validate(msg.sender));
403 
404         if (validator.containRule(msg.sender) && msg.sender != _to) {
405             validator.addFrozenBalance(msg.sender, _to, _value);
406         }
407         balances[msg.sender] = balances[msg.sender].sub(_value);
408         balances[_to] = balances[_to].add(_value);
409 
410         emit Transfer(msg.sender, _to, _value);
411     }
412 
413     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
414         require(!frozenAccount[_from]);
415         require(now > frozenTimestamp[_from]);
416         require(_value <= balances[_from].sub(validator.validate(_from)));
417         require(_value <= allowed[_from][msg.sender]);
418 
419         if (validator.containRule(_from) && _from != _to) {
420             validator.addFrozenBalance(_from, _to, _value);
421         }
422 
423         balances[_from] = balances[_from].sub(_value);
424         balances[_to] = balances[_to].add(_value);
425         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
426 
427         emit Transfer(_from, _to, _value);
428         return true;
429     }
430 
431     function approve(address _spender, uint256 _value) public returns (bool) {
432         allowed[msg.sender][_spender] = _value;
433 
434         emit Approval(msg.sender, _spender, _value);
435         return true;
436     }
437 
438     function allowance(address _owner, address _spender) public view returns (uint256) {
439         return allowed[_owner][_spender];
440     }
441 
442     /**
443      * @dev Gets the balance of the specified address.
444      * @param _owner The address to query the the balance of.
445      * @return An uint256 representing the amount owned by the passed address.
446      */
447     function balanceOf(address _owner) public view returns (uint256) {
448         return balances[_owner]; //.sub(validator.validate(_owner));
449     }
450 
451     //-------------------------  Standard ERC20 Interfaces  --------------------------//
452 
453     function kill() public {
454         require(msg.sender == admin);
455         selfdestruct(admin);
456     }
457 
458 }