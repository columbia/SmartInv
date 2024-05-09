1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity ^0.7.0;
3 
4 // File: SafeMath.sol
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
16     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17     // benefit is lost if 'b' is also tested.
18     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19     if (_a == 0) {
20       return 0;
21     }
22 
23     c = _a * _b;
24     assert(c / _a == _b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
32     // assert(_b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = _a / _b;
34     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
35     return _a / _b;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     assert(_b <= _a);
43     return _a - _b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
50     c = _a + _b;
51     assert(c >= _a);
52     return c;
53   }
54 }
55 
56 // File: FrozenChecker.sol
57 
58 /**
59  * @title FrozenChecker
60  * @dev Check account by frozen rules
61  */
62 library FrozenChecker {
63 
64     using SafeMath for uint256;
65 
66     /**
67      * Rule for each address
68      */
69     struct Rule {
70         uint256 timeT;
71         uint8 initPercent;
72         uint256[] periods;
73         uint8[] percents;
74     }
75 
76     function check(Rule storage self, uint256 totalFrozenValue) internal view returns (uint256) {
77         if (totalFrozenValue == uint256(0)) {
78             return 0;
79         }
80         //uint8 temp = self.initPercent;
81         if (self.timeT == uint256(0) || self.timeT > block.timestamp) {
82             return totalFrozenValue.sub(totalFrozenValue.mul(self.initPercent).div(100));
83         }
84         for (uint256 i = 0; i < self.periods.length.sub(1); i = i.add(1)) {
85             if (block.timestamp >= self.timeT.add(self.periods[i]) && block.timestamp < self.timeT.add(self.periods[i.add(1)])) {
86                 return totalFrozenValue.sub(totalFrozenValue.mul(self.percents[i]).div(100));
87             }
88         }
89         if (block.timestamp >= self.timeT.add(self.periods[self.periods.length.sub(1)])) {
90             return totalFrozenValue.sub(totalFrozenValue.mul(self.percents[self.periods.length.sub(1)]).div(100));
91         }
92     }
93 
94 }
95 
96 // File: FrozenValidator.sol
97 
98 library FrozenValidator {
99     
100     using SafeMath for uint256;
101     using FrozenChecker for FrozenChecker.Rule;
102 
103     struct Validator {
104         mapping(address => IndexValue) data;
105         KeyFlag[] keys;
106         uint256 size;
107     }
108 
109     struct IndexValue {
110         uint256 keyIndex; 
111         FrozenChecker.Rule rule;
112         mapping (address => uint256) frozenBalances;
113     }
114 
115     struct KeyFlag { 
116         address key; 
117         bool deleted; 
118     }
119 
120     function addRule(Validator storage self, address key, uint8 initPercent, uint256[] memory periods, uint8[] memory percents) internal returns (bool replaced) {
121         //require(self.size <= 10);
122         require(key != address(0));
123         require(periods.length == percents.length);
124         require(periods.length > 0);
125         require(periods[0] == uint256(0));
126         require(initPercent <= percents[0]);
127         for (uint256 i = 1; i < periods.length; i = i.add(1)) {
128             require(periods[i.sub(1)] < periods[i]);
129             require(percents[i.sub(1)] <= percents[i]);
130         }
131         require(percents[percents.length.sub(1)] == 100);
132         FrozenChecker.Rule memory rule = FrozenChecker.Rule(0, initPercent, periods, percents);
133         uint256 keyIndex = self.data[key].keyIndex;
134         self.data[key].rule = rule;
135         if (keyIndex > 0) {
136             return true;
137         } else {
138             //keyIndex = self.keys.length++;
139             keyIndex = self.keys.length;
140             self.keys.push();
141             self.data[key].keyIndex = keyIndex.add(1);
142             self.keys[keyIndex].key = key;
143             self.size++;
144             return false;
145         }
146     }
147 
148     function removeRule(Validator storage self, address key) internal returns (bool success) {
149         uint256 keyIndex = self.data[key].keyIndex;
150         if (keyIndex == 0) {
151             return false;
152         }
153         delete self.data[key];
154         self.keys[keyIndex.sub(1)].deleted = true;
155         self.size--;
156         return true;
157     }
158 
159     function containRule(Validator storage self, address key) internal view returns (bool) {
160         return self.data[key].keyIndex > 0;
161     }
162 
163     function addTimeT(Validator storage self, address addr, uint256 timeT) internal returns (bool) {
164         require(timeT > block.timestamp);
165         self.data[addr].rule.timeT = timeT;
166         return true;
167     }
168 
169     function addFrozenBalance(Validator storage self, address from, address to, uint256 value) internal returns (uint256) {
170         self.data[from].frozenBalances[to] = self.data[from].frozenBalances[to].add(value);
171         return self.data[from].frozenBalances[to];
172     }
173 
174     function validate(Validator storage self, address addr) internal view returns (uint256) {
175         uint256 frozenTotal = 0;
176         for (uint256 i = iterateStart(self); iterateValid(self, i); i = iterateNext(self, i)) {
177             address ruleaddr = iterateGet(self, i);
178             FrozenChecker.Rule storage rule = self.data[ruleaddr].rule;
179             frozenTotal = frozenTotal.add(rule.check(self.data[ruleaddr].frozenBalances[addr]));
180         }
181         return frozenTotal;
182     }
183 
184 
185     function iterateStart(Validator storage self) internal view returns (uint256 keyIndex) {
186         return iterateNext(self, uint256(-1));
187     }
188 
189     function iterateValid(Validator storage self, uint256 keyIndex) internal view returns (bool) {
190         return keyIndex < self.keys.length;
191     }
192 
193     function iterateNext(Validator storage self, uint256 keyIndex) internal view returns (uint256) {
194         keyIndex++;
195         while (keyIndex < self.keys.length && self.keys[keyIndex].deleted) {
196             keyIndex++;
197         }
198         return keyIndex;
199     }
200 
201     function iterateGet(Validator storage self, uint256 keyIndex) internal view returns (address) {
202         return self.keys[keyIndex].key;
203     }
204 }
205 
206 // File: YottaCoin.sol
207 
208 contract YottaCoin {
209 
210     using SafeMath for uint256;
211     using FrozenValidator for FrozenValidator.Validator;
212 
213     mapping (address => uint256) internal balances;
214     mapping (address => mapping (address => uint256)) internal allowed;
215 
216     //--------------------------------  Basic Info  -------------------------------------//
217 
218     string public name;
219     string public symbol;
220     uint8 public decimals;
221     uint256 public totalSupply;
222 
223     //--------------------------------  Basic Info  -------------------------------------//
224 
225 
226     //--------------------------------  Admin Info  -------------------------------------//
227 
228     address payable public admin;  //Admin address
229 
230     /**
231      * @dev Change admin address
232      * @param newAdmin New admin address
233      */
234     function changeAdmin(address payable newAdmin) public returns (bool)  {
235         require(msg.sender == admin);
236         require(newAdmin != address(0));
237         uint256 balAdmin = balances[admin];
238         balances[newAdmin] = balances[newAdmin].add(balAdmin);
239         balances[admin] = 0;
240         admin = newAdmin;
241         emit Transfer(admin, newAdmin, balAdmin);
242         return true;
243     }
244 
245     //--------------------------------  Admin Info  -------------------------------------//
246 
247 
248     //--------------------------  Events & Constructor  ------------------------------//
249     
250     event Approval(address indexed owner, address indexed spender, uint256 value);
251     event Transfer(address indexed from, address indexed to, uint256 value);
252     event Mint(address indexed target, uint256 value);
253     event Burn(address indexed target, uint256 value);
254 
255     // constructor
256     constructor(string memory tokenName, string memory tokenSymbol, uint8 tokenDecimals) {
257         name = tokenName;
258         symbol = tokenSymbol;
259         decimals = tokenDecimals;
260         totalSupply = 0;
261         admin = msg.sender;
262         // balances[msg.sender] = 0;
263         // emit Transfer(address(0x0), msg.sender, totalTokenSupply);
264     }
265 
266     //--------------------------  Events & Constructor  ------------------------------//
267     
268     
269     //-------------------------------  Mint & Burn  ----------------------------------//
270     
271     function mint(address target, uint256 value) public returns (bool) {
272         require(msg.sender == admin);
273         require(!frozenAccount[target]);
274         require(block.timestamp > frozenTimestamp[target]);
275         balances[target] = balances[target].add(value);
276         totalSupply = totalSupply.add(value);
277         emit Mint(target, value);
278         emit Transfer(address(0), target, value);
279         return true;
280     }
281     
282     function burn(address target, uint256 value) public returns (bool) {
283         require(msg.sender == admin);
284         require(!frozenAccount[target]);
285         require(block.timestamp > frozenTimestamp[target]);
286         require(totalSupply>=value);
287         require(balances[target].sub(value)>=validator.validate(target));
288         balances[target] = balances[target].sub(value);
289         totalSupply = totalSupply.sub(value);
290         emit Burn(target, value);
291         emit Transfer(target, address(0), value);
292         return true;
293     }
294 
295     //-------------------------------  Mint & Burn  ----------------------------------//
296     
297 
298     //------------------------------ Account lock  -----------------------------------//
299 
300     // 同一个账户满足任意冻结条件均被冻结
301     mapping (address => bool) frozenAccount; //无限期冻结的账户
302     mapping (address => uint256) frozenTimestamp; // 有限期冻结的账户
303 
304     /**
305      * 查询账户是否存在锁定时间戳
306      */
307     function getFrozenTimestamp(address _target) public view returns (uint256) {
308         return frozenTimestamp[_target];
309     }
310 
311     /**
312      * 查询账户是否被锁定
313      */
314     function getFrozenAccount(address _target) public view returns (bool) {
315         return frozenAccount[_target];
316     }
317 
318     /**
319      * 锁定账户
320      */
321     function freeze(address _target, bool _freeze) public returns (bool) {
322         require(msg.sender == admin);
323         require(_target != admin);
324         frozenAccount[_target] = _freeze;
325         return true;
326     }
327 
328     /**
329      * 通过时间戳锁定账户
330      */
331     function freezeWithTimestamp(address _target, uint256 _timestamp) public returns (bool) {
332         require(msg.sender == admin);
333         require(_target != admin);
334         frozenTimestamp[_target] = _timestamp;
335         return true;
336     }
337 
338     /**
339      * 批量锁定账户
340      */
341     function multiFreeze(address[] memory _targets, bool[] memory _freezes) public returns (bool) {
342         require(msg.sender == admin);
343         require(_targets.length == _freezes.length);
344         uint256 len = _targets.length;
345         require(len > 0);
346         for (uint256 i = 0; i < len; i = i.add(1)) {
347             address _target = _targets[i];
348             require(_target != admin);
349             bool _freeze = _freezes[i];
350             frozenAccount[_target] = _freeze;
351         }
352         return true;
353     }
354 
355     /**
356      * 批量通过时间戳锁定账户
357      */
358     function multiFreezeWithTimestamp(address[] memory _targets, uint256[] memory _timestamps) public returns (bool) {
359         require(msg.sender == admin);
360         require(_targets.length == _timestamps.length);
361         uint256 len = _targets.length;
362         require(len > 0);
363         for (uint256 i = 0; i < len; i = i.add(1)) {
364             address _target = _targets[i];
365             require(_target != admin);
366             uint256 _timestamp = _timestamps[i];
367             frozenTimestamp[_target] = _timestamp;
368         }
369         return true;
370     }
371 
372     //------------------------------  Account lock  -----------------------------------//
373 
374 
375 
376 
377     //--------------------------      Frozen rules      ------------------------------//
378 
379     FrozenValidator.Validator validator;
380 
381     function addRule(address addr, uint8 initPercent, uint256[] memory periods, uint8[] memory percents) public returns (bool) {
382         require(msg.sender == admin);
383         return validator.addRule(addr, initPercent, periods, percents);
384     }
385 
386     function addTimeT(address addr, uint256 timeT) public returns (bool) {
387         require(msg.sender == admin);
388         return validator.addTimeT(addr, timeT);
389     }
390 
391     function removeRule(address addr) public returns (bool) {
392         require(msg.sender == admin);
393         return validator.removeRule(addr);
394     }
395 
396     //--------------------------      Frozen rules      ------------------------------//
397 
398 
399 
400 
401     //-------------------------  Standard ERC20 Interfaces  --------------------------//
402 
403     function multiTransfer(address[] memory _tos, uint256[] memory _values) public returns (bool) {
404         require(!frozenAccount[msg.sender]);
405         require(block.timestamp > frozenTimestamp[msg.sender]);
406         require(_tos.length == _values.length);
407         uint256 len = _tos.length;
408         require(len > 0);
409         uint256 amount = 0;
410         for (uint256 i = 0; i < len; i = i.add(1)) {
411             amount = amount.add(_values[i]);
412         }
413         require(amount <= balances[msg.sender].sub(validator.validate(msg.sender)));
414         for (uint256 j = 0; j < len; j = j.add(1)) {
415             address _to = _tos[j];
416             if (validator.containRule(msg.sender) && msg.sender != _to) {
417                 validator.addFrozenBalance(msg.sender, _to, _values[j]);
418             }
419             balances[_to] = balances[_to].add(_values[j]);
420             balances[msg.sender] = balances[msg.sender].sub(_values[j]);
421             emit Transfer(msg.sender, _to, _values[j]);
422         }
423         return true;
424     }
425 
426     function transfer(address _to, uint256 _value) public returns (bool) {
427         transferfix(_to, _value);
428         return true;
429     }
430 
431     function transferfix(address _to, uint256 _value) public {
432         require(!frozenAccount[msg.sender]);
433         require(block.timestamp > frozenTimestamp[msg.sender]);
434         require(balances[msg.sender].sub(_value) >= validator.validate(msg.sender));
435 
436         if (validator.containRule(msg.sender) && msg.sender != _to) {
437             validator.addFrozenBalance(msg.sender, _to, _value);
438         }
439         balances[msg.sender] = balances[msg.sender].sub(_value);
440         balances[_to] = balances[_to].add(_value);
441 
442         emit Transfer(msg.sender, _to, _value);
443     }
444 
445     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
446         require(!frozenAccount[_from]);
447         require(block.timestamp > frozenTimestamp[_from]);
448         require(_value <= balances[_from].sub(validator.validate(_from)));
449         require(_value <= allowed[_from][msg.sender]);
450 
451         if (validator.containRule(_from) && _from != _to) {
452             validator.addFrozenBalance(_from, _to, _value);
453         }
454 
455         balances[_from] = balances[_from].sub(_value);
456         balances[_to] = balances[_to].add(_value);
457         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
458 
459         emit Transfer(_from, _to, _value);
460         return true;
461     }
462 
463     function approve(address _spender, uint256 _value) public returns (bool) {
464         allowed[msg.sender][_spender] = _value;
465 
466         emit Approval(msg.sender, _spender, _value);
467         return true;
468     }
469 
470     function allowance(address _owner, address _spender) public view returns (uint256) {
471         return allowed[_owner][_spender];
472     }
473 
474     /**
475      * @dev Gets the balance of the specified address.
476      * @param _owner The address to query the the balance of.
477      * @return An uint256 representing the amount owned by the passed address.
478      */
479     function balanceOf(address _owner) public view returns (uint256) {
480         return balances[_owner]; //.sub(validator.validate(_owner));
481     }
482 
483     //-------------------------  Standard ERC20 Interfaces  --------------------------//
484     
485     function lockedBalanceOf(address _target) public view returns (uint256) {
486         return validator.validate(_target);
487     }
488 
489     function kill() public {
490         require(msg.sender == admin);
491         selfdestruct(admin);
492     }
493 
494 }