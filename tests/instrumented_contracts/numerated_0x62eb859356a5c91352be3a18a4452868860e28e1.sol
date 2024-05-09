1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25   
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32  
33     return c;
34   }
35   
36   /**
37   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     require(b <= a);
41     uint256 c = a - b;
42 
43     return c;
44   }
45   
46   /**
47   * @dev Adds two numbers, reverts on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     require(c >= a);
52 
53     return c;
54   }
55 }
56 
57 library FrozenChecker {
58   using SafeMath for uint256;
59   
60   /**
61    * Rule for each address
62    */
63   struct Rule {
64     uint256 timeT;
65     uint8 initPercent;
66     uint256[] periods;
67     uint8[] percents;
68   }
69   
70   function check(Rule storage self, uint256 totalFrozenValue) internal view returns(uint256) {
71     if (totalFrozenValue == uint256(0)) {
72       return 0;
73     }
74     if (self.timeT == uint256(0) || self.timeT > now) {
75       return totalFrozenValue.sub(totalFrozenValue.mul(self.initPercent).div(100));
76     }
77     for (uint256 i = 0; i < self.periods.length.sub(1); i = i.add(1)) {
78       if (now >= self.timeT.add(self.periods[i]) && now < self.timeT.add(self.periods[i.add(1)])) {
79         return totalFrozenValue.sub(totalFrozenValue.mul(self.percents[i]).div(100));
80       }
81     }
82     if (now >= self.timeT.add(self.periods[self.periods.length.sub(1)])) {
83       return totalFrozenValue.sub(totalFrozenValue.mul(self.percents[self.periods.length.sub(1)]).div(100));
84     }
85   }
86 }
87 
88 library FrozenValidator {
89     
90   using SafeMath for uint256;
91   using FrozenChecker for FrozenChecker.Rule;
92 
93   struct Validator {
94     mapping(address => IndexValue) data;
95     KeyFlag[] keys;
96     uint256 size;
97   }
98 
99   struct IndexValue {
100     uint256 keyIndex; 
101     FrozenChecker.Rule rule;
102     mapping (address => uint256) frozenBalances;
103   }
104 
105   struct KeyFlag { 
106     address key; 
107     bool deleted; 
108   }
109 
110   function addRule(Validator storage self, address key, uint8 initPercent, uint256[] periods, uint8[] percents) internal returns (bool replaced) {
111     require(key != address(0));
112     require(periods.length == percents.length);
113     require(periods.length > 0);
114     require(periods[0] == uint256(0));
115     require(initPercent <= percents[0]);
116     for (uint256 i = 1; i < periods.length; i = i.add(1)) {
117       require(periods[i.sub(1)] < periods[i]);
118       require(percents[i.sub(1)] <= percents[i]);
119     }
120     require(percents[percents.length.sub(1)] == 100);
121     FrozenChecker.Rule memory rule = FrozenChecker.Rule(0, initPercent, periods, percents);
122     uint256 keyIndex = self.data[key].keyIndex;
123     self.data[key].rule = rule;
124     if (keyIndex > 0) {
125       return false;
126     } else {
127       keyIndex = self.keys.length++;
128       self.data[key].keyIndex = keyIndex.add(1);
129       self.keys[keyIndex].key = key;
130       self.size++;
131       return true;
132     }
133   }
134 
135   function removeRule(Validator storage self, address key) internal returns (bool success) {
136     uint256 keyIndex = self.data[key].keyIndex;
137     if (keyIndex == 0) {
138       return false;
139     }
140     delete self.data[key];
141     self.keys[keyIndex.sub(1)].deleted = true;
142     self.size--;
143     return true;
144   }
145 
146   function containRule(Validator storage self, address key) internal view returns (bool) {
147     return self.data[key].keyIndex > 0;
148   }
149 
150   function addTimeT(Validator storage self, address addr, uint256 timeT) internal returns (bool) {
151     require(timeT > now);
152     self.data[addr].rule.timeT = timeT;
153     return true;
154   }
155 
156   function addFrozenBalance(Validator storage self, address from, address to, uint256 value) internal returns (uint256) {
157     self.data[from].frozenBalances[to] = self.data[from].frozenBalances[to].add(value);
158     return self.data[from].frozenBalances[to];
159   }
160 
161   function validate(Validator storage self, address addr) internal returns (uint256) {
162     uint256 frozenTotal = 0;
163     for (uint256 i = iterateStart(self); iterateValid(self, i); i = iterateNext(self, i)) {
164       address ruleaddr = iterateGet(self, i);
165       FrozenChecker.Rule storage rule = self.data[ruleaddr].rule;
166       frozenTotal = frozenTotal.add(rule.check(self.data[ruleaddr].frozenBalances[addr]));
167     }
168     return frozenTotal;
169   }
170 
171   function iterateStart(Validator storage self) internal view returns (uint256 keyIndex) {
172     return iterateNext(self, uint256(-1));
173   }
174 
175   function iterateValid(Validator storage self, uint256 keyIndex) internal view returns (bool) {
176     return keyIndex < self.keys.length;
177   }
178 
179   function iterateNext(Validator storage self, uint256 keyIndex) internal view returns (uint256) {
180     keyIndex++;
181     while (keyIndex < self.keys.length && self.keys[keyIndex].deleted) {
182       keyIndex++;
183     }
184     return keyIndex;
185   }
186 
187   function iterateGet(Validator storage self, uint256 keyIndex) internal view returns (address) {
188     return self.keys[keyIndex].key;
189   }
190 }
191 
192 
193 /**
194  * @title Ownable
195  * @dev The Ownable contract has an owner address, and provides basic authorization control
196  * functions, this simplifies the implementation of "user permissions".
197  */
198 contract Ownable {
199   address public owner;
200 
201 
202   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
203 
204 
205   /**
206    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
207    * account.
208    */
209   constructor() public {
210     owner = msg.sender;
211   }
212 
213 
214   /**
215    * @dev Throws if called by any account other than the owner.
216    */
217   modifier onlyOwner() {
218     require(msg.sender == owner);
219     _;
220   }
221 
222 
223   /**
224    * @dev Allows the current owner to transfer control of the contract to a newOwner.
225    * @param newOwner The address to transfer ownership to.
226    */
227   function transferOwnership(address newOwner) public onlyOwner {
228     require(newOwner != address(0));
229     OwnershipTransferred(owner, newOwner);
230     owner = newOwner;
231   }
232 
233 }
234 
235 /**
236  * @title Pausable
237  * @dev Base contract which allows children to implement an emergency stop mechanism.
238  */
239 contract Pausable is Ownable {
240   event PausePublic(bool newState);
241   event PauseOwnerAdmin(bool newState);
242 
243   bool public pausedPublic = true;
244   bool public pausedOwnerAdmin = false;
245 
246   address public admin;
247 
248   /**
249    * @dev Modifier to make a function callable based on pause states.
250    */
251   modifier whenNotPaused() {
252     if(pausedPublic) {
253       if(!pausedOwnerAdmin) {
254         require(msg.sender == admin || msg.sender == owner);
255       } else {
256         revert();
257       }
258     }
259     _;
260   }
261 
262   /**
263    * @dev called by the owner to set new pause flags
264    * pausedPublic can't be false while pausedOwnerAdmin is true
265    */
266   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
267     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
268 
269     pausedPublic = newPausedPublic;
270     pausedOwnerAdmin = newPausedOwnerAdmin;
271 
272     PausePublic(newPausedPublic);
273     PauseOwnerAdmin(newPausedOwnerAdmin);
274   }
275 }
276 
277 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
278 
279 contract SEROToken is Pausable {
280   using SafeMath for uint256;
281   using FrozenValidator for FrozenValidator.Validator;
282   
283   string public name;
284   string public symbol;
285   uint8 public decimals = 9;
286   uint256 public totalSupply;
287   
288   // Create array of all balances
289   mapping (address => uint256) internal balances;
290   mapping (address => mapping (address => uint256)) internal allowed;
291   
292   // Create array of freeze account
293   mapping (address => bool) frozenAccount;       // Indefinite frozen account
294   mapping (address => uint256) frozenTimestamp;  // Timelimit frozen account
295   
296   // Freeze account using rule
297   FrozenValidator.Validator validator;
298   
299   event Approval(address indexed owner, address indexed spender, uint256 value);
300   event Transfer(address indexed from, address indexed to, uint256 value);
301   event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
302   
303   constructor(string tokenName, string tokenSymbol, uint256 totalTokenSupply ) public {
304      
305     name = tokenName;
306     symbol = tokenSymbol;
307     totalSupply = totalTokenSupply * 10 ** uint256(decimals);
308     admin = msg.sender;
309     balances[msg.sender] = totalSupply;
310     emit Transfer(0x0, msg.sender, totalSupply);
311   }
312   
313   
314   // Change admin
315   function changeAdmin(address newAdmin) public onlyOwner returns (bool)  {
316     // require(msg.sender == admin);
317     require(newAdmin != address(0));
318     // uint256 balAdmin = balances[admin];
319     // balances[newAdmin] = balances[newAdmin].add(balAdmin);
320     // balances[admin] = 0;
321     admin = newAdmin;
322     emit AdminTransferred(admin, newAdmin);
323     return true;
324   }
325   
326   // Get account frozen timestamp
327   function getFrozenTimestamp(address _target) public view returns (uint256) {
328     return frozenTimestamp[_target];
329   }
330   
331   // Check if the account is freezed indefinitely 
332   function getFrozenAccount(address _target) public view returns (bool) {
333     return frozenAccount[_target];
334   }
335   
336   // Indefinite freeze account or unfreeze account(set _freeze to true)
337   function freeze(address _target, bool _freeze) public returns (bool) {
338     require(msg.sender == admin);
339     require(_target != admin);
340     frozenAccount[_target] = _freeze;
341     return true;
342   }
343   
344   // Timelimit freeze account or unfreeze account(set _timestamp to 0x0)
345   function freezeWithTimestamp(address _target, uint256 _timestamp) public returns (bool) {
346     require(msg.sender == admin);
347     require(_target != admin);
348     frozenTimestamp[_target] = _timestamp;
349     return true;
350   }
351   
352   // Batch indefinite freeze account or unfreeze account
353   function multiFreeze(address[] _targets, bool[] _freezes) public returns (bool) {
354     require(msg.sender == admin);
355     require(_targets.length == _freezes.length);
356     uint256 len = _targets.length;
357     require(len > 0);
358     for (uint256 i = 0; i < len; i = i.add(1)) {
359       address _target = _targets[i];
360       require(_target != admin);
361       bool _freeze = _freezes[i];
362       frozenAccount[_target] = _freeze;
363     }
364     return true;
365   }
366   
367   // Batch timelimit freeze account or unfreeze account
368   function multiFreezeWithTimestamp(address[] _targets, uint256[] _timestamps) public returns (bool) {
369     require(msg.sender == admin);
370     require(_targets.length == _timestamps.length);
371     uint256 len = _targets.length;
372     require(len > 0);
373     for (uint256 i = 0; i < len; i = i.add(1)) {
374       address _target = _targets[i];
375       require(_target != admin);
376       uint256 _timestamp = _timestamps[i];
377       frozenTimestamp[_target] = _timestamp;
378     }
379     return true;
380   }
381   
382   /* Freeze or unfreeze account using rules */
383   
384   function addRule(address addr, uint8 initPercent, uint256[] periods, uint8[] percents) public returns (bool) {
385     require(msg.sender == admin);
386     return validator.addRule(addr, initPercent, periods, percents);
387   }
388 
389   function addTimeT(address addr, uint256 timeT) public returns (bool) {
390     require(msg.sender == admin);
391     return validator.addTimeT(addr, timeT);
392   }
393   
394   function removeRule(address addr) public returns (bool) {
395     require(msg.sender == admin);
396     return validator.removeRule(addr);
397   }
398   
399   function validate(address addr) public view returns (uint256) {
400     require(msg.sender == admin);
401     return validator.validate(addr);
402   }
403 
404     
405   function queryRule(address addr) public view returns (uint256,uint8,uint256[],uint8[]) {
406     require(msg.sender == admin);
407     return (validator.data[addr].rule.timeT,validator.data[addr].rule.initPercent,validator.data[addr].rule.periods,validator.data[addr].rule.percents);
408   }
409   
410   /* ERC20 interface */
411   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
412     _transfer(_to, _value);
413     return true;
414   }
415   
416   function _transfer(address _to, uint256 _value) internal whenNotPaused {
417     require(_to != 0x0);
418     require(!frozenAccount[msg.sender]);
419     require(now > frozenTimestamp[msg.sender]);
420     require(balances[msg.sender].sub(_value) >= validator.validate(msg.sender));
421 
422     if (validator.containRule(msg.sender) && msg.sender != _to) {
423         validator.addFrozenBalance(msg.sender, _to, _value);
424     }
425     balances[msg.sender] = balances[msg.sender].sub(_value);
426     balances[_to] = balances[_to].add(_value);
427 
428     emit Transfer(msg.sender, _to, _value);
429   }
430  
431   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
432     require(_to != 0x0);
433     require(!frozenAccount[_from]);
434     require(now > frozenTimestamp[_from]);
435     require(_value <= balances[_from].sub(validator.validate(_from)));
436     require(_value <= allowed[_from][msg.sender]);
437 
438     if (validator.containRule(_from) && _from != _to) {
439       validator.addFrozenBalance(_from, _to, _value);
440     }
441 
442     balances[_from] = balances[_from].sub(_value);
443     balances[_to] = balances[_to].add(_value);
444     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
445 
446     emit Transfer(_from, _to, _value);
447     return true;
448   }
449   
450   function multiTransfer(address[] _tos, uint256[] _values) public whenNotPaused returns (bool) {
451     require(!frozenAccount[msg.sender]);
452     require(now > frozenTimestamp[msg.sender]);
453     require(_tos.length == _values.length);
454     uint256 len = _tos.length;
455     require(len > 0);
456     uint256 amount = 0;
457     for (uint256 i = 0; i < len; i = i.add(1)) {
458       amount = amount.add(_values[i]);
459     }
460     require(amount <= balances[msg.sender].sub(validator.validate(msg.sender)));
461     for (uint256 j = 0; j < len; j = j.add(1)) {
462       address _to = _tos[j];
463       require(_to != 0x0);
464       if (validator.containRule(msg.sender) && msg.sender != _to) {
465         validator.addFrozenBalance(msg.sender, _to, _values[j]);
466       }
467       balances[_to] = balances[_to].add(_values[j]);
468       balances[msg.sender] = balances[msg.sender].sub(_values[j]);
469       emit Transfer(msg.sender, _to, _values[j]);
470     }
471     return true;
472   }
473   
474   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
475     allowed[msg.sender][_spender] = _value;
476 
477     emit Approval(msg.sender, _spender, _value);
478     return true;
479   }
480   
481   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public whenNotPaused returns (bool success) {
482 
483     require(_spender != 0x0);
484     require(!frozenAccount[msg.sender]);
485     require(now > frozenTimestamp[msg.sender]);
486     require(_value <= balances[msg.sender].sub(validator.validate(msg.sender)));
487 
488     if (validator.containRule(msg.sender) && msg.sender != _spender) {
489       validator.addFrozenBalance(msg.sender, _spender, _value);
490     }
491 
492     tokenRecipient spender = tokenRecipient(_spender);
493     if (approve(_spender, _value)) {
494       spender.receiveApproval(msg.sender, _value, this, _extraData);
495       return true;
496     }
497   }
498   
499   function allowance(address _owner, address _spender) public view returns (uint256) {
500     return allowed[_owner][_spender];
501   }
502   
503   function balanceOf(address _owner) public view returns (uint256) {
504     return balances[_owner]; //.sub(validator.validate(_owner));
505   }
506   
507   function kill() public {
508     require(msg.sender == admin);
509     selfdestruct(admin);
510   }
511 }