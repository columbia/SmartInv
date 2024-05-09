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
117 // junil@cy2code.com
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
212 // junil@cy2code.com
213 // ----------------------------------------------------------------------------
214 contract RestrictAmount is OwnableToken {
215     mapping(address => uint256) public keepAmount;
216 
217     event LockAmount(address indexed addr, uint256 indexed amount);
218     event DecLockAmount(address indexed addr, uint256 indexed amount);
219     event UnlockAmount(address indexed addr);
220 
221     function lockAmount(address _address, uint256 _amount) external onlyOperator returns (bool) {
222         keepAmount[_address] = _amount;
223 
224         if (_amount > 0) emit LockAmount(_address, _amount);
225         else emit UnlockAmount(_address);
226     }
227 
228     function decLockAmount(address _address, uint256 _amount) external onlyOperator returns (bool) {
229         uint256 amount = _amount;
230         if (amount > keepAmount[_address]) {
231             amount = keepAmount[_address];
232         }
233 
234         keepAmount[_address] = keepAmount[_address].sub(amount);
235         emit DecLockAmount(_address, _amount);
236     }
237 }
238 
239 // ----------------------------------------------------------------------------
240 // junil@cy2code.com
241 // ----------------------------------------------------------------------------
242 contract LockAccount is OwnableToken {
243     enum LOCK_STATE { unlock, lock, timeLock }
244 
245     struct lockInfo {
246         LOCK_STATE lock;
247         string reason;
248         uint256 time;
249     }
250 
251     mapping(address => lockInfo) lockAccount;
252 
253     event LockAddr(address indexed addr, string indexed reason, uint256 time);
254     event UnlockAddr(address indexed addr);
255     
256     modifier checkLockAccount {
257         if (   lockAccount[msg.sender].lock == LOCK_STATE.timeLock
258             && lockAccount[msg.sender].time <= now ) {
259             lockAccount[msg.sender].time = 0;
260             lockAccount[msg.sender].reason = "";
261             lockAccount[msg.sender].lock = LOCK_STATE.unlock;        
262             emit UnlockAddr(msg.sender);
263         }
264 
265         require(   lockAccount[msg.sender].lock != LOCK_STATE.lock
266                 && lockAccount[msg.sender].lock != LOCK_STATE.timeLock);
267         _;
268     }
269     
270     function lockAddr(address _address, string _reason, uint256 _untilTime) public onlyOperator returns (bool) {
271         require(_address != address(0));
272         require(_address != owner);
273         require(_untilTime == 0 || _untilTime > now);
274 
275         if (_untilTime == 0) {
276             lockAccount[_address].lock = LOCK_STATE.lock;
277         }
278         else {
279             lockAccount[_address].lock = LOCK_STATE.timeLock;
280         }
281         
282         lockAccount[_address].reason = _reason;
283         lockAccount[_address].time = _untilTime;
284         emit LockAddr(_address, _reason, _untilTime);
285         return true;
286     }
287     
288     function unlockAddr(address _address) public onlyOwner returns (bool) {
289         lockAccount[_address].time = 0;
290         lockAccount[_address].reason = "";
291         lockAccount[_address].lock = LOCK_STATE.unlock;        
292         emit UnlockAddr(_address);
293         return true;
294     } 
295 
296     function getLockInfo(address _address) public returns (LOCK_STATE, string, uint256) {
297         if (
298                lockAccount[_address].lock == LOCK_STATE.timeLock
299             && lockAccount[_address].time <= now ) {
300             lockAccount[_address].time = 0;
301             lockAccount[_address].reason = "";
302             lockAccount[_address].lock = LOCK_STATE.unlock;        
303         }
304 
305         return (  lockAccount[_address].lock
306                 , lockAccount[_address].reason
307                 , lockAccount[_address].time );
308     }
309 }
310 
311 // ----------------------------------------------------------------------------
312 // junil@cy2code.com
313 // ----------------------------------------------------------------------------
314 contract TransferFromOperator is RestrictAmount, LockAccount {
315     function transferToMany(address[] _to, uint256[] _value) onlyOperator checkLockAccount external returns (bool) {
316         require(_to.length == _value.length);
317 
318         uint256 i;
319         uint256 totValue = 0;
320         for (i = 0; i < _to.length; i++) {
321             require(_to[i] != address(0));
322             totValue = totValue.add(_value[i]);
323         }
324         require(balances[msg.sender].sub(keepAmount[msg.sender]) >= totValue);
325 
326         for (i = 0; i < _to.length; i++) {
327             balances[msg.sender] = balances[msg.sender].sub(_value[i]);
328             balances[_to[i]] = balances[_to[i]].add(_value[i]);
329             emit Transfer(msg.sender, _to[i], _value[i]);
330         }
331 
332         return true;
333     }
334 
335     function transferFromOperator(address _to, uint256 _value) onlyOperator checkLockAccount public returns (bool) {
336         require(_to != address(0));
337         require(balances[msg.sender].sub(keepAmount[msg.sender]) >= _value);
338 
339         balances[msg.sender] = balances[msg.sender].sub(_value);
340         balances[_to] = balances[_to].add(_value);
341         emit Transfer(msg.sender, _to, _value);
342         return true;
343     }
344 }
345 
346 // ----------------------------------------------------------------------------
347 //
348 // ----------------------------------------------------------------------------
349 contract Pausable is OwnableToken {
350     bool public paused = false;
351 
352     event Pause();
353     event Unpause();
354 
355     modifier whenNotPaused() {
356         require(!paused); 
357         _; 
358     }
359     
360     modifier whenPaused() {
361         require(paused); 
362         _; 
363     }
364 
365     function pause() external onlyOwner whenNotPaused {
366         paused = true;
367         emit Pause();
368     }
369 
370     function unpause() external onlyOwner whenPaused {
371         paused = false;
372         emit Unpause();
373     }
374 }
375 
376 // ----------------------------------------------------------------------------
377 //
378 // ----------------------------------------------------------------------------
379 contract ControlledToken is Pausable, TransferFromOperator
380 {
381     function transfer(address _to, uint256 _value) public whenNotPaused checkLockAccount returns (bool) {
382         require(balances[msg.sender].sub(keepAmount[msg.sender]) >= _value);
383         return super.transfer(_to, _value);
384     }
385 
386     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused checkLockAccount returns (bool) {
387         require(balances[_from].sub(keepAmount[_from]) >= _value);
388         return super.transferFrom(_from, _to, _value);
389     }
390 
391     function approve(address _spender, uint256 _value) public whenNotPaused checkLockAccount onlyOperator returns (bool) {
392         return super.approve(_spender, _value);
393     }
394 
395     function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused checkLockAccount onlyOperator returns (bool) {
396         return super.increaseApproval(_spender, _addedValue);
397     }
398 
399     function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused checkLockAccount onlyOperator returns (bool) {
400         return super.decreaseApproval(_spender, _subtractedValue);
401     }
402 }
403 
404 // ----------------------------------------------------------------------------
405 //
406 // ----------------------------------------------------------------------------
407 contract Burnable is OwnableToken {
408     event Burn(address indexed burner, uint256 value);
409 
410     function burn(uint256 _value) onlyOwner public {
411         require(_value <= balances[owner]);
412 
413         balances[owner] = balances[owner].sub(_value);
414         totalSupply_ = totalSupply_.sub(_value);
415         emit Transfer(owner, address(0), _value);
416         emit Burn(msg.sender, _value);
417     }
418 }
419 
420 // ----------------------------------------------------------------------------
421 // https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
422 // ----------------------------------------------------------------------------
423 contract Mintable is OwnableToken {
424     bool public mintingFinished = false;
425 
426     event Mint(address indexed to, uint256 value);
427     event MintFinished();
428 
429     modifier canMint() {
430         require(!mintingFinished); 
431         _; 
432     }
433 
434     function mint(address _to, uint256 _value) onlyOwner canMint public returns (bool) {
435         require(_to != address(0));
436 
437         totalSupply_ = totalSupply_.add(_value);
438         balances[_to] = balances[_to].add(_value);
439         emit Transfer(address(0), _to, _value);
440         emit Mint(_to, _value);
441         return true;
442     }
443 
444     function finishMinting() onlyOwner canMint public returns (bool) {
445         mintingFinished = true;
446         emit MintFinished();
447         return true;
448     }
449 }
450 
451 // ----------------------------------------------------------------------------
452 //
453 // ----------------------------------------------------------------------------
454 contract ManageSupplyToken is Mintable, Burnable {
455     /* ... */
456 }
457 
458 // ----------------------------------------------------------------------------
459 // junil@cy2code.com
460 // ----------------------------------------------------------------------------
461 contract PPCToken is ControlledToken, ManageSupplyToken {
462     uint256 private constant INIT_SUPPLY = 1900000000;
463     string public name = "PHILLIPS PAY COIN";
464     string public symbol = "PPC";
465     uint256 public decimals = 1;
466     uint256 public initSupply = INIT_SUPPLY * (10 ** uint(decimals));
467 
468     constructor() payable public {
469         totalSupply_ = initSupply;
470         balances[msg.sender] = totalSupply_;
471         emit Transfer(0x0, msg.sender, totalSupply_);
472     }
473 }