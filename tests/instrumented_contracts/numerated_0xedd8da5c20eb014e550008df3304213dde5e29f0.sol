1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
8         assert(a >= b);
9         return a - b;
10     }
11 
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         assert(c >= a);
15         return c;
16     }
17 }
18 
19 // ----------------------------------------------------------------------------
20 // https://github.com/ethereum/EIPs/issues/179
21 // ----------------------------------------------------------------------------
22 contract ERC20Basic {
23     function totalSupply() public view returns (uint256);
24     function balanceOf(address who) public view returns (uint256);
25     function transfer(address to, uint256 value) public returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 }
28 
29 // ----------------------------------------------------------------------------
30 // https://github.com/ethereum/EIPs/issues/20
31 // ----------------------------------------------------------------------------
32 contract ERC20 is ERC20Basic {
33     function allowance(address owner, address spender) public view returns (uint256);
34     function transferFrom(address from, address to, uint256 value) public returns (bool);
35     function approve(address spender, uint256 value) public returns (bool); 
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 // ----------------------------------------------------------------------------
40 //
41 // ----------------------------------------------------------------------------
42 contract BasicToken is ERC20Basic {
43     using SafeMath for uint256;
44 
45     uint256 totalSupply_;
46     mapping(address => uint256) balances;
47 
48     function totalSupply() public view returns (uint256) {
49         return totalSupply_;
50     }
51 
52     function transfer(address _to, uint256 _value) public returns (bool) {
53         require(_to != address(0));
54         require(_value <= balances[msg.sender]);
55 
56         balances[msg.sender] = balances[msg.sender].sub(_value);
57         balances[_to] = balances[_to].add(_value);
58         emit Transfer(msg.sender, _to, _value);
59         return true;
60     }
61 
62     function balanceOf(address _owner) public view returns (uint256) {
63         return balances[_owner];
64     }
65 }
66 
67 // ----------------------------------------------------------------------------
68 // https://github.com/ethereum/EIPs/issues/20
69 // ----------------------------------------------------------------------------
70 contract StandardToken is ERC20, BasicToken {
71     mapping(address => mapping(address => uint256)) internal allowed;
72 
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
74         require(_to != address(0));
75         require(_value <= balances[_from]);
76         require(_value <= allowed[_from][msg.sender]);
77 
78         balances[_from] = balances[_from].sub(_value);
79         balances[_to] = balances[_to].add(_value);
80         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
81         emit Transfer(_from, _to, _value);
82         return true;
83     }
84 
85     function approve(address _spender, uint256 _value) public returns (bool) {
86         allowed[msg.sender][_spender] = _value;
87         emit Approval(msg.sender, _spender, _value);
88         return true;
89     }
90 
91     function allowance(address _owner, address _spender) public view returns (uint256) {
92         return allowed[_owner][_spender];
93     }
94 
95     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
96         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
97         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
98         return true;
99     }
100 
101     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
102         uint256 oldValue = allowed[msg.sender][_spender];
103 
104         if (_subtractedValue > oldValue) {
105             allowed[msg.sender][_spender] = 0;
106         } 
107         else {
108             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
109         }
110 
111         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112         return true;
113     }
114 }
115 
116 // ----------------------------------------------------------------------------
117 // 
118 // ----------------------------------------------------------------------------
119 contract OwnableToken is StandardToken {
120     uint256 public constant OPERATOR_MAX_COUNT = 10;
121     uint256 public operatorCount;
122 
123     address public owner;
124     address[OPERATOR_MAX_COUNT] public operator;
125     mapping(address => string) operatorName;
126 
127     event ChangeOwner(address indexed prevOwner, address indexed newOwner);
128     event AddOperator(address indexed Operator, string name);
129     event RemoveOperator(address indexed Operator);
130 
131     constructor() public {
132         owner = msg.sender;
133         operatorCount = 0;
134 
135         for (uint256 i = 0; i < OPERATOR_MAX_COUNT; i++) {
136             operator[i] = address(0);
137         }
138     }
139 
140     modifier onlyOwner() {
141         require(msg.sender == owner); 
142         _; 
143     }
144     
145     modifier onlyOperator() {
146         require(msg.sender == owner || checkOperator(msg.sender) == true);
147         _;
148     }
149     
150     function checkOperator(address _operator) private view returns (bool) {
151         for (uint256 i = 0; i < OPERATOR_MAX_COUNT; i++) {
152             if (_operator == operator[i]) {
153                 return true;
154             }
155         }
156 
157         revert();
158     }
159 
160     function changeOwner(address _newOwner) external onlyOwner returns (bool) {
161         require(_newOwner != address(0));
162         
163         emit ChangeOwner(owner, _newOwner);
164         owner = _newOwner;
165         return true;
166     }
167 
168     function addOperator(address _newOperator, string _name) external onlyOwner returns (bool) {
169         require(_newOperator != address(0));
170 
171         for (uint256 i = 0; i < OPERATOR_MAX_COUNT; i++) {
172             if (_newOperator == operator[i]) {
173                 revert();
174             }
175         }        
176         
177         for (i = 0; i < OPERATOR_MAX_COUNT; i++) {
178             if (operator[i] == address(0)) {
179                 operator[i] = _newOperator;
180                 operatorName[operator[i]] = _name;
181                 operatorCount++;
182 
183                 emit AddOperator(_newOperator, _name);
184                 return true;
185             }
186         }
187 
188         revert();
189     }
190 
191     function removeOperator(address _operator) external onlyOwner returns (bool) {
192         for (uint256 i = 0; i < OPERATOR_MAX_COUNT; i++) {
193             if (_operator == operator[i]) {
194                 operatorName[operator[i]] = "";
195                 operator[i] = address(0);
196                 operatorCount--;
197 
198                 emit RemoveOperator(_operator);
199                 return true;
200             }
201         }        
202 
203         revert();
204     }
205 
206     function getOperatorName(address _operator) external onlyOwner view returns (string) {
207         return operatorName[_operator];
208     }
209 }
210 
211 // ----------------------------------------------------------------------------
212 // 
213 // ----------------------------------------------------------------------------
214 contract RestrictAmount is OwnableToken {
215     mapping(address => uint) public keepAmount;
216 
217     event LockAmount(address indexed addr, uint256 indexed amount);
218     event UnlockAmount(address indexed addr);
219 
220     function lockAmount(address _address, uint256 _amount) external onlyOperator returns (bool) {
221         uint256 tmp;
222         tmp = _amount;
223         if (balances[_address] < _amount) {
224             tmp = balances[_address];
225         }
226 
227         keepAmount[_address] = tmp;
228         emit LockAmount(_address, tmp);
229     }
230 
231     function unlockAmount(address _address) external onlyOperator returns (bool) {
232         require(keepAmount[_address] > 0);
233         keepAmount[_address] = 0;
234         emit UnlockAmount(_address);
235     }
236 }
237 
238 // ----------------------------------------------------------------------------
239 // 
240 // ----------------------------------------------------------------------------
241 contract LockAccount is OwnableToken {
242     enum LockState { Unlock, Lock, TimeLock }
243 
244     struct LockInfo {
245         LockState lock;
246         string reason;
247         uint256 time;
248     }
249 
250     mapping(address => LockInfo) lockAccount;
251 
252     event LockAddr(address indexed addr, string indexed reason, uint256 time);
253     event UnlockAddr(address indexed addr);
254     
255     modifier checkLockAccount {
256         if (   lockAccount[msg.sender].lock == LockState.TimeLock
257             && lockAccount[msg.sender].time <= now ) {
258             lockAccount[msg.sender].time = 0;
259             lockAccount[msg.sender].reason = "";
260             lockAccount[msg.sender].lock = LockState.Unlock;        
261             emit UnlockAddr(msg.sender);
262         }
263 
264         require(   lockAccount[msg.sender].lock != LockState.Lock
265                 && lockAccount[msg.sender].lock != LockState.TimeLock);
266         _;
267     }
268     
269     function lockAddr(address _address, string _reason, uint256 _untilTime) public onlyOperator returns (bool) {
270         require(_address != address(0));
271         require(_address != owner);
272         require(_untilTime == 0 || _untilTime > now);
273 
274         if (_untilTime == 0) {
275             lockAccount[_address].lock = LockState.Lock;
276         }
277         else {
278             lockAccount[_address].lock = LockState.TimeLock;
279         }
280         
281         lockAccount[_address].reason = _reason;
282         lockAccount[_address].time = _untilTime;
283         emit LockAddr(_address, _reason, _untilTime);
284         return true;
285     }
286     
287     function unlockAddr(address _address) public onlyOwner returns (bool) {
288         lockAccount[_address].time = 0;
289         lockAccount[_address].reason = "";
290         lockAccount[_address].lock = LockState.Unlock;        
291         emit UnlockAddr(_address);
292         return true;
293     } 
294 
295     function getLockInfo(address _address) public view returns (LockState, string, uint256) {
296         LockInfo memory info = lockAccount[_address];
297         return (info.lock, info.reason, info.time);
298     }
299 }
300 
301 // ----------------------------------------------------------------------------
302 // 
303 // ----------------------------------------------------------------------------
304 contract OperatorTransfer is RestrictAmount, LockAccount {
305     /*
306     function transferToMany(address[] _to, uint256[] _value) onlyOperator checkLockAccount external returns (bool) {
307         require(_to.length == _value.length);
308 
309         uint256 i;
310         uint256 totValue = 0;
311         for (i = 0; i < _to.length; i++) {
312             require(_to[i] != address(0));
313             totValue = totValue.add(_value[i]);
314         }
315         require(balances[msg.sender].sub(keepAmount[msg.sender]) >= totValue);
316 
317         for (i = 0; i < _to.length; i++) {
318             balances[msg.sender] = balances[msg.sender].sub(_value[i]);
319             balances[_to[i]] = balances[_to[i]].add(_value[i]);
320             emit Transfer(msg.sender, _to[i], _value[i]);
321         }
322 
323         return true;
324     }
325 
326     function operatorTransfer(address _to, uint256 _value) onlyOperator checkLockAccount public returns (bool) {
327         require(_to != address(0));
328         require(balances[msg.sender].sub(keepAmount[msg.sender]) >= _value);
329 
330         balances[msg.sender] = balances[msg.sender].sub(_value);
331         balances[_to] = balances[_to].add(_value);
332         emit Transfer(msg.sender, _to, _value);
333         return true;
334     }
335     */
336 }
337 
338 // ----------------------------------------------------------------------------
339 //
340 // ----------------------------------------------------------------------------
341 contract Pausable is OwnableToken {
342     bool public paused = false;
343 
344     event Pause();
345     event Unpause();
346 
347     modifier whenNotPaused() {
348         require(!paused); 
349         _; 
350     }
351     
352     modifier whenPaused() {
353         require(paused); 
354         _; 
355     }
356 
357     function pause() external onlyOwner whenNotPaused {
358         paused = true;
359         emit Pause();
360     }
361 
362     function unpause() external onlyOwner whenPaused {
363         paused = false;
364         emit Unpause();
365     }
366 }
367 
368 // ----------------------------------------------------------------------------
369 //
370 // ----------------------------------------------------------------------------
371 contract ControlledToken is Pausable, OperatorTransfer
372 {
373     function transfer(address _to, uint256 _value) public whenNotPaused checkLockAccount returns (bool) {
374         require(balances[msg.sender].sub(keepAmount[msg.sender]) >= _value);
375         return super.transfer(_to, _value);
376     }
377 
378     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused checkLockAccount returns (bool) {
379         require(balances[_from].sub(keepAmount[_from]) >= _value);
380         return super.transferFrom(_from, _to, _value);
381     }
382 
383     function approve(address _spender, uint256 _value) public whenNotPaused checkLockAccount onlyOperator returns (bool) {
384         return super.approve(_spender, _value);
385     }
386 
387     function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused checkLockAccount onlyOperator returns (bool) {
388         return super.increaseApproval(_spender, _addedValue);
389     }
390 
391     function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused checkLockAccount onlyOperator returns (bool) {
392         return super.decreaseApproval(_spender, _subtractedValue);
393     }
394 }
395 
396 // ----------------------------------------------------------------------------
397 //
398 // ----------------------------------------------------------------------------
399 contract Burnable is OwnableToken {
400     event Burn(address indexed burner, uint256 value);
401 
402     function burn(uint256 _value) onlyOwner public {
403         require(_value <= balances[owner]);
404 
405         balances[owner] = balances[owner].sub(_value);
406         totalSupply_ = totalSupply_.sub(_value);
407         emit Transfer(owner, address(0), _value);
408         emit Burn(msg.sender, _value);
409     }
410 }
411 
412 // ----------------------------------------------------------------------------
413 // 
414 // ----------------------------------------------------------------------------
415 contract Mintable is OwnableToken {
416     bool public mintingFinished = false;
417 
418     event Mint(address indexed to, uint256 value);
419     event MintFinished();
420 
421     modifier canMint() {
422         require(!mintingFinished); 
423         _; 
424     }
425 
426     function mint(address _to, uint256 _value) onlyOwner canMint public returns (bool) {
427         require(_to != address(0));
428 
429         totalSupply_ = totalSupply_.add(_value);
430         balances[_to] = balances[_to].add(_value);
431         emit Transfer(address(0), _to, _value);
432         emit Mint(_to, _value);
433         return true;
434     }
435 
436     function finishMinting() onlyOwner canMint public returns (bool) {
437         mintingFinished = true;
438         emit MintFinished();
439         return true;
440     }
441 }
442 
443 // ----------------------------------------------------------------------------
444 //
445 // ----------------------------------------------------------------------------
446 contract ManageSupplyToken is Mintable, Burnable {
447     /* ... */
448 }
449 
450 // ----------------------------------------------------------------------------
451 // 
452 // ----------------------------------------------------------------------------
453 contract MARSToken is ControlledToken, ManageSupplyToken {
454 
455     string public name = "MARS Context Network";
456     string public symbol = "MARS";
457     uint256 public decimals = 8;
458     uint256 public initSupply = 12000000000;
459 
460     constructor() public {
461         totalSupply_ = initSupply * (10 ** uint(decimals));
462         balances[msg.sender] = totalSupply_;
463         emit Transfer(0x0, msg.sender, totalSupply_);
464     }
465 }