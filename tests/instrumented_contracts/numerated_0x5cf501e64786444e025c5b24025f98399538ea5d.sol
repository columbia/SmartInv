1 /**
2  *Submitted for verification at Etherscan.io on 2018-10-30
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 // File: SafeMath.sol
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15   /**
16   * @dev Multiplies two numbers, throws on overflow.
17   */
18   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
19     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
20     // benefit is lost if 'b' is also tested.
21     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
22     if (_a == 0) {
23       return 0;
24     }
25 
26     c = _a * _b;
27     assert(c / _a == _b);
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two numbers, truncating the quotient.
33   */
34   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     // assert(_b > 0); // Solidity automatically throws when dividing by 0
36     // uint256 c = _a / _b;
37     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
38     return _a / _b;
39   }
40 
41   /**
42   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43   */
44   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     assert(_b <= _a);
46     return _a - _b;
47   }
48 
49   /**
50   * @dev Adds two numbers, throws on overflow.
51   */
52   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
53     c = _a + _b;
54     assert(c >= _a);
55     return c;
56   }
57 }
58 
59 // File: FrozenChecker.sol
60 
61 /**
62  * @title FrozenChecker
63  * @dev Check account by frozen rules
64  */
65 library FrozenChecker {
66 
67     using SafeMath for uint256;
68 
69     /**
70      * Rule for each address
71      */
72     struct Rule {
73         uint256 timeT;
74         uint8 initPercent;
75         uint256[] periods;
76         uint8[] percents;
77     }
78 
79     function check(Rule storage self, uint256 totalFrozenValue) internal view returns (uint256) {
80         if (totalFrozenValue == uint256(0)) {
81             return 0;
82         }
83         //uint8 temp = self.initPercent;
84         if (self.timeT == uint256(0) || self.timeT > now) {
85             return totalFrozenValue.sub(totalFrozenValue.mul(self.initPercent).div(100));
86         }
87         for (uint256 i = 0; i < self.periods.length.sub(1); i = i.add(1)) {
88             if (now >= self.timeT.add(self.periods[i]) && now < self.timeT.add(self.periods[i.add(1)])) {
89                 return totalFrozenValue.sub(totalFrozenValue.mul(self.percents[i]).div(100));
90             }
91         }
92         if (now >= self.timeT.add(self.periods[self.periods.length.sub(1)])) {
93             return totalFrozenValue.sub(totalFrozenValue.mul(self.percents[self.periods.length.sub(1)]).div(100));
94         }
95     }
96 
97 }
98 
99 // File: FrozenValidator.sol
100 
101 library FrozenValidator {
102     
103     using SafeMath for uint256;
104     using FrozenChecker for FrozenChecker.Rule;
105 
106     struct Validator {
107         mapping(address => IndexValue) data;
108         KeyFlag[] keys;
109         uint256 size;
110     }
111 
112     struct IndexValue {
113         uint256 keyIndex; 
114         FrozenChecker.Rule rule;
115         mapping (address => uint256) frozenBalances;
116     }
117 
118     struct KeyFlag { 
119         address key; 
120         bool deleted; 
121     }
122 
123     function addRule(Validator storage self, address key, uint8 initPercent, uint256[] periods, uint8[] percents) internal returns (bool replaced) {
124         //require(self.size <= 10);
125         require(key != address(0));
126         require(periods.length == percents.length);
127         require(periods.length > 0);
128         require(periods[0] == uint256(0));
129         require(initPercent <= percents[0]);
130         for (uint256 i = 1; i < periods.length; i = i.add(1)) {
131             require(periods[i.sub(1)] < periods[i]);
132             require(percents[i.sub(1)] <= percents[i]);
133         }
134         require(percents[percents.length.sub(1)] == 100);
135         FrozenChecker.Rule memory rule = FrozenChecker.Rule(0, initPercent, periods, percents);
136         uint256 keyIndex = self.data[key].keyIndex;
137         self.data[key].rule = rule;
138         if (keyIndex > 0) {
139             return true;
140         } else {
141             keyIndex = self.keys.length++;
142             self.data[key].keyIndex = keyIndex.add(1);
143             self.keys[keyIndex].key = key;
144             self.size++;
145             return false;
146         }
147     }
148 
149     function removeRule(Validator storage self, address key) internal returns (bool success) {
150         uint256 keyIndex = self.data[key].keyIndex;
151         if (keyIndex == 0) {
152             return false;
153         }
154         delete self.data[key];
155         self.keys[keyIndex.sub(1)].deleted = true;
156         self.size--;
157         return true;
158     }
159 
160     function containRule(Validator storage self, address key) internal view returns (bool) {
161         return self.data[key].keyIndex > 0;
162     }
163 
164     function addTimeT(Validator storage self, address addr, uint256 timeT) internal returns (bool) {
165         require(timeT > now);
166         self.data[addr].rule.timeT = timeT;
167         return true;
168     }
169 
170     function addFrozenBalance(Validator storage self, address from, address to, uint256 value) internal returns (uint256) {
171         self.data[from].frozenBalances[to] = self.data[from].frozenBalances[to].add(value);
172         return self.data[from].frozenBalances[to];
173     }
174 
175     function validate(Validator storage self, address addr) internal view returns (uint256) {
176         uint256 frozenTotal = 0;
177         for (uint256 i = iterateStart(self); iterateValid(self, i); i = iterateNext(self, i)) {
178             address ruleaddr = iterateGet(self, i);
179             FrozenChecker.Rule storage rule = self.data[ruleaddr].rule;
180             frozenTotal = frozenTotal.add(rule.check(self.data[ruleaddr].frozenBalances[addr]));
181         }
182         return frozenTotal;
183     }
184 
185 
186     function iterateStart(Validator storage self) internal view returns (uint256 keyIndex) {
187         return iterateNext(self, uint256(-1));
188     }
189 
190     function iterateValid(Validator storage self, uint256 keyIndex) internal view returns (bool) {
191         return keyIndex < self.keys.length;
192     }
193 
194     function iterateNext(Validator storage self, uint256 keyIndex) internal view returns (uint256) {
195         keyIndex++;
196         while (keyIndex < self.keys.length && self.keys[keyIndex].deleted) {
197             keyIndex++;
198         }
199         return keyIndex;
200     }
201 
202     function iterateGet(Validator storage self, uint256 keyIndex) internal view returns (address) {
203         return self.keys[keyIndex].key;
204     }
205 }
206 
207 // File: YottaCoin.sol
208 
209 contract YottaCoin {
210 
211     using SafeMath for uint256;
212     using FrozenValidator for FrozenValidator.Validator;
213 
214     mapping (address => uint256) internal balances;
215     mapping (address => mapping (address => uint256)) internal allowed;
216 
217     //--------------------------------  Basic Info  -------------------------------------//
218 
219     string public name;
220     string public symbol;
221     uint8 public decimals;
222     uint256 public totalSupply;
223 
224     //--------------------------------  Basic Info  -------------------------------------//
225 
226 
227     //--------------------------------  Admin Info  -------------------------------------//
228 
229     address internal admin;  //Admin address
230 
231     /**
232      * @dev Change admin address
233      * @param newAdmin New admin address
234      */
235     function changeAdmin(address newAdmin) public returns (bool)  {
236         require(msg.sender == admin);
237         require(newAdmin != address(0));
238         uint256 balAdmin = balances[admin];
239         balances[newAdmin] = balances[newAdmin].add(balAdmin);
240         balances[admin] = 0;
241         admin = newAdmin;
242         emit Transfer(admin, newAdmin, balAdmin);
243         return true;
244     }
245 
246     //--------------------------------  Admin Info  -------------------------------------//
247 
248 
249     //--------------------------  Events & Constructor  ------------------------------//
250     
251     event Approval(address indexed owner, address indexed spender, uint256 value);
252     event Transfer(address indexed from, address indexed to, uint256 value);
253 
254     // constructor
255     constructor(string tokenName, string tokenSymbol, uint8 tokenDecimals, uint256 totalTokenSupply ) public {
256         name = tokenName;
257         symbol = tokenSymbol;
258         decimals = tokenDecimals;
259         totalSupply = totalTokenSupply;
260         admin = msg.sender;
261         balances[msg.sender] = totalTokenSupply;
262         emit Transfer(0x0, msg.sender, totalTokenSupply);
263 
264     }
265 
266     //--------------------------  Events & Constructor  ------------------------------//
267 
268 
269 
270     //------------------------------ Account lock  -----------------------------------//
271 
272     // 同一个账户满足任意冻结条件均被冻结
273     mapping (address => bool) frozenAccount; //无限期冻结的账户
274     mapping (address => uint256) frozenTimestamp; // 有限期冻结的账户
275 
276     /**
277      * 查询账户是否存在锁定时间戳
278      */
279     function getFrozenTimestamp(address _target) public view returns (uint256) {
280         return frozenTimestamp[_target];
281     }
282 
283     /**
284      * 查询账户是否被锁定
285      */
286     function getFrozenAccount(address _target) public view returns (bool) {
287         return frozenAccount[_target];
288     }
289 
290     /**
291      * 锁定账户
292      */
293     function freeze(address _target, bool _freeze) public returns (bool) {
294         require(msg.sender == admin);
295         require(_target != admin);
296         frozenAccount[_target] = _freeze;
297         return true;
298     }
299 
300     /**
301      * 通过时间戳锁定账户
302      */
303     function freezeWithTimestamp(address _target, uint256 _timestamp) public returns (bool) {
304         require(msg.sender == admin);
305         require(_target != admin);
306         frozenTimestamp[_target] = _timestamp;
307         return true;
308     }
309 
310     /**
311      * 批量锁定账户
312      */
313     function multiFreeze(address[] _targets, bool[] _freezes) public returns (bool) {
314         require(msg.sender == admin);
315         require(_targets.length == _freezes.length);
316         uint256 len = _targets.length;
317         require(len > 0);
318         for (uint256 i = 0; i < len; i = i.add(1)) {
319             address _target = _targets[i];
320             require(_target != admin);
321             bool _freeze = _freezes[i];
322             frozenAccount[_target] = _freeze;
323         }
324         return true;
325     }
326 
327     /**
328      * 批量通过时间戳锁定账户
329      */
330     function multiFreezeWithTimestamp(address[] _targets, uint256[] _timestamps) public returns (bool) {
331         require(msg.sender == admin);
332         require(_targets.length == _timestamps.length);
333         uint256 len = _targets.length;
334         require(len > 0);
335         for (uint256 i = 0; i < len; i = i.add(1)) {
336             address _target = _targets[i];
337             require(_target != admin);
338             uint256 _timestamp = _timestamps[i];
339             frozenTimestamp[_target] = _timestamp;
340         }
341         return true;
342     }
343 
344     //------------------------------  Account lock  -----------------------------------//
345 
346 
347 
348 
349     //--------------------------      Frozen rules      ------------------------------//
350 
351     FrozenValidator.Validator validator;
352 
353     function addRule(address addr, uint8 initPercent, uint256[] periods, uint8[] percents) public returns (bool) {
354         require(msg.sender == admin);
355         return validator.addRule(addr, initPercent, periods, percents);
356     }
357 
358     function addTimeT(address addr, uint256 timeT) public returns (bool) {
359         require(msg.sender == admin);
360         return validator.addTimeT(addr, timeT);
361     }
362 
363     function removeRule(address addr) public returns (bool) {
364         require(msg.sender == admin);
365         return validator.removeRule(addr);
366     }
367 
368     //--------------------------      Frozen rules      ------------------------------//
369 
370 
371 
372 
373     //-------------------------  Standard ERC20 Interfaces  --------------------------//
374 
375     function multiTransfer(address[] _tos, uint256[] _values) public returns (bool) {
376         require(!frozenAccount[msg.sender]);
377         require(now > frozenTimestamp[msg.sender]);
378         require(_tos.length == _values.length);
379         uint256 len = _tos.length;
380         require(len > 0);
381         uint256 amount = 0;
382         for (uint256 i = 0; i < len; i = i.add(1)) {
383             amount = amount.add(_values[i]);
384         }
385         require(amount <= balances[msg.sender].sub(validator.validate(msg.sender)));
386         for (uint256 j = 0; j < len; j = j.add(1)) {
387             address _to = _tos[j];
388             if (validator.containRule(msg.sender) && msg.sender != _to) {
389                 validator.addFrozenBalance(msg.sender, _to, _values[j]);
390             }
391             balances[_to] = balances[_to].add(_values[j]);
392             balances[msg.sender] = balances[msg.sender].sub(_values[j]);
393             emit Transfer(msg.sender, _to, _values[j]);
394         }
395         return true;
396     }
397 
398     function transfer(address _to, uint256 _value) public returns (bool) {
399         transferfix(_to, _value);
400         return true;
401     }
402 
403     function transferfix(address _to, uint256 _value) public {
404         require(!frozenAccount[msg.sender]);
405         require(now > frozenTimestamp[msg.sender]);
406         require(balances[msg.sender].sub(_value) >= validator.validate(msg.sender));
407 
408         if (validator.containRule(msg.sender) && msg.sender != _to) {
409             validator.addFrozenBalance(msg.sender, _to, _value);
410         }
411         balances[msg.sender] = balances[msg.sender].sub(_value);
412         balances[_to] = balances[_to].add(_value);
413 
414         emit Transfer(msg.sender, _to, _value);
415     }
416 
417     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
418         require(!frozenAccount[_from]);
419         require(now > frozenTimestamp[_from]);
420         require(_value <= balances[_from].sub(validator.validate(_from)));
421         require(_value <= allowed[_from][msg.sender]);
422 
423         if (validator.containRule(_from) && _from != _to) {
424             validator.addFrozenBalance(_from, _to, _value);
425         }
426 
427         balances[_from] = balances[_from].sub(_value);
428         balances[_to] = balances[_to].add(_value);
429         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
430 
431         emit Transfer(_from, _to, _value);
432         return true;
433     }
434 
435     function approve(address _spender, uint256 _value) public returns (bool) {
436         allowed[msg.sender][_spender] = _value;
437 
438         emit Approval(msg.sender, _spender, _value);
439         return true;
440     }
441 
442     function allowance(address _owner, address _spender) public view returns (uint256) {
443         return allowed[_owner][_spender];
444     }
445 
446     /**
447      * @dev Gets the balance of the specified address.
448      * @param _owner The address to query the the balance of.
449      * @return An uint256 representing the amount owned by the passed address.
450      */
451     function balanceOf(address _owner) public view returns (uint256) {
452         return balances[_owner]; //.sub(validator.validate(_owner));
453     }
454 
455     //-------------------------  Standard ERC20 Interfaces  --------------------------//
456 
457     function kill() public {
458         require(msg.sender == admin);
459         selfdestruct(admin);
460     }
461 
462 }