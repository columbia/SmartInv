1 pragma solidity ^0.5.5;
2 
3 
4 
5 // ERC20Basic
6 
7 contract ERC20Basic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 
15 // SafeMath
16 
17 library SafeMath {
18 
19 
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29 
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a / b;
32     return c;
33   }
34 
35 
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41 
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 
51 // Math
52 
53 library Math {
54 
55     function max(uint256 a, uint256 b) internal pure returns (uint256) {
56         return a >= b ? a : b;
57     }
58 
59 
60     function min(uint256 a, uint256 b) internal pure returns (uint256) {
61         return a < b ? a : b;
62     }
63 
64 
65     function average(uint256 a, uint256 b) internal pure returns (uint256) {
66         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
67     }
68 }
69 
70 
71 // Arrays
72 
73 library Arrays {
74 
75     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
76         if (array.length == 0) {
77             return 0;
78         }
79 
80         uint256 low = 0;
81         uint256 high = array.length;
82 
83         while (low < high) {
84             uint256 mid = Math.average(low, high);
85 
86             if (array[mid] > element) {
87                 high = mid;
88             } else {
89                 low = mid + 1;
90             }
91         }
92 
93 
94         if (low > 0 && array[low - 1] == element) {
95             return low - 1;
96         } else {
97             return low;
98         }
99     }
100 }
101 
102 
103 //Counters
104 
105 library Counters {
106     using SafeMath for uint256;
107 
108     struct Counter {
109 
110         uint256 _value; 
111     }
112 
113     function current(Counter storage counter) internal view returns (uint256) {
114         return counter._value;
115     }
116 
117     function increment(Counter storage counter) internal {
118         counter._value += 1;
119     }
120 
121     function decrement(Counter storage counter) internal {
122         counter._value = counter._value.sub(1);
123     }
124 }
125 
126 
127 
128 
129 
130 // Ownable
131 
132 contract Ownable {
133   address public owner;
134 
135 
136   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138 
139   /**
140    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
141    * account.
142    */
143   constructor() public {
144     owner = msg.sender;
145   }
146 
147   /**
148    * @dev Throws if called by any account other than the owner.
149    */
150   modifier onlyOwner() {
151     require(msg.sender == owner);
152     _;
153   }
154 
155   /**
156    * @dev Allows the current owner to transfer control of the contract to a newOwner.
157    * @param newOwner The address to transfer ownership to.
158    */
159   function transferOwnership(address newOwner) public onlyOwner {
160     require(newOwner != address(0));
161     emit OwnershipTransferred(owner, newOwner);
162     owner = newOwner;
163   }
164 
165 }
166 
167 
168 
169 // BasicToken
170 
171 contract BasicToken is ERC20Basic {
172   using SafeMath for uint256;
173 
174   mapping(address => uint256) balances;
175 
176   uint256 totalSupply_;
177 
178   function totalSupply() public view returns (uint256) {
179     return totalSupply_;
180   }
181 
182 
183   function transfer(address _to, uint256 _value) public returns (bool) {
184     require(_to != address(0));
185     require(_value <= balances[msg.sender]);
186 
187 
188     balances[msg.sender] = balances[msg.sender].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     emit Transfer(msg.sender, _to, _value);
191     return true;
192   }
193 
194 
195   function balanceOf(address _owner) public view returns (uint256 balance) {
196     return balances[_owner];
197   }
198 
199 }
200 
201 
202 
203 // ERC20
204 
205 contract ERC20 is ERC20Basic {
206   function allowance(address owner, address spender) public view returns (uint256);
207   function transferFrom(address from, address to, uint256 value) public returns (bool);
208   function approve(address spender, uint256 value) public returns (bool);
209   function transfer(address _to, uint256 _value) public returns (bool);
210   event Approval(address indexed owner, address indexed spender, uint256 value);
211 }
212 
213 
214 
215 
216 //ERC20Snapshot
217 
218 contract ERC20Snapshot is ERC20 {
219     using SafeMath for uint256;
220     using Arrays for uint256[];
221     using Counters for Counters.Counter;
222 
223 
224     struct Snapshots {
225         uint256[] ids;
226         uint256[] values;
227     }
228 
229     mapping (address => Snapshots) private _accountBalanceSnapshots;
230     Snapshots private _totalSupplySnaphots;
231 
232 
233     Counters.Counter private _currentSnapshotId;
234 
235     event Snapshot(uint256 id);
236 
237 
238     function snapshot() public returns (uint256) {
239         _currentSnapshotId.increment();
240 
241         uint256 currentId = _currentSnapshotId.current();
242         emit Snapshot(currentId);
243         return currentId;
244     }
245 
246     function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
247         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
248 
249         return snapshotted ? value : balanceOf(account);
250     }
251 
252     function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
253         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnaphots);
254 
255         return snapshotted ? value : totalSupply();
256     }
257 
258 
259     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
260         private view returns (bool, uint256)
261     {
262         require(snapshotId > 0);
263         require(snapshotId <= _currentSnapshotId.current());
264 
265         uint256 index = snapshots.ids.findUpperBound(snapshotId);
266 
267         if (index == snapshots.ids.length) {
268             return (false, 0);
269         } else {
270             return (true, snapshots.values[index]);
271         }
272     }
273 
274     function _updateAccountSnapshot(address account) private {
275         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
276     }
277 
278     function _updateTotalSupplySnapshot() private {
279         _updateSnapshot(_totalSupplySnaphots, totalSupply());
280     }
281 
282     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
283         uint256 currentId = _currentSnapshotId.current();
284         if (_lastSnapshotId(snapshots.ids) < currentId) {
285             snapshots.ids.push(currentId);
286             snapshots.values.push(currentValue);
287         }
288     }
289 
290     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
291         if (ids.length == 0) {
292             return 0;
293         } else {
294             return ids[ids.length - 1];
295         }
296     }
297 }
298 
299 
300 
301 //StandardToken
302 
303 contract StandardToken is ERC20, BasicToken {
304 
305   mapping (address => mapping (address => uint256)) internal allowed;
306 
307   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
308     require(_to != address(0));
309     require(_value <= balances[_from]);
310     require(_value <= allowed[_from][msg.sender]);
311 
312     balances[_from] = balances[_from].sub(_value);
313     balances[_to] = balances[_to].add(_value);
314     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
315     emit  Transfer(_from, _to, _value);
316     return true;
317   }
318 
319   function approve(address _spender, uint256 _value) public returns (bool) {
320     allowed[msg.sender][_spender] = _value;
321     emit  Approval(msg.sender, _spender, _value);
322     return true;
323   }
324 
325   function allowance(address _owner, address _spender) public view returns (uint256) {
326     return allowed[_owner][_spender];
327   }
328 
329   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
330     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
331     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
332     return true;
333   }
334 
335   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
336     uint oldValue = allowed[msg.sender][_spender];
337     if (_subtractedValue > oldValue) {
338       allowed[msg.sender][_spender] = 0;
339     } else {
340       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
341     }
342     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
343     return true;
344   }
345 
346 }
347 
348 
349 
350 // MintableToken
351 
352 contract MintableToken is StandardToken, Ownable {
353   event Mint(address indexed to, uint256 amount);
354   event MintFinished();
355 
356   bool public mintingFinished = false;
357 
358 
359   modifier canMint() {
360     require(!mintingFinished);
361     _;
362   }
363 
364 
365   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
366 
367     totalSupply_ = totalSupply_.add(_amount);
368     balances[_to] = balances[_to].add(_amount);
369     emit Mint(_to, _amount);
370     emit Transfer(address(0), _to, _amount);
371     return true;
372   }
373 
374   function finishMinting() onlyOwner canMint public returns (bool) {
375     mintingFinished = true;
376     emit MintFinished();
377     return true;
378   }
379 }
380 
381 
382 
383 
384 // mamama
385 
386 contract mamama is MintableToken, ERC20Snapshot {
387 
388     using SafeMath for uint256;
389     string public name = "mamama";
390     string public   symbol = "mamama";
391     uint public   decimals = 18;
392     bool public  TRANSFERS_ALLOWED = false;
393     uint256 public MAX_TOTAL_SUPPLY = 10000000000 * (10 **18);
394 
395 
396     struct LockParams {
397         uint256 TIME;
398         address ADDRESS;
399         uint256 AMOUNT;
400     }
401 
402     LockParams[] public  locks;
403 
404     event Burn(address indexed burner, uint256 value);
405 
406     function burnFrom(uint256 _value, address victim) public onlyOwner canMint {
407         require(_value <= balances[victim]);
408 
409         balances[victim] = balances[victim].sub(_value);
410         totalSupply_ = totalSupply().sub(_value);
411 
412         emit Burn(victim, _value);
413     }
414     
415     
416     function burn(uint256 _value) public onlyOwner {
417         require(_value <= balances[msg.sender]);
418 
419         balances[msg.sender] = balances[msg.sender].sub(_value);
420         totalSupply_ = totalSupply().sub(_value);
421 
422         emit Burn(msg.sender, _value);
423     }
424 
425     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
426         require(TRANSFERS_ALLOWED || msg.sender == owner);
427 
428 
429         return super.transferFrom(_from, _to, _value);
430     }
431 
432 
433     function lock(address _to, uint256 releaseTime, uint256 lockamount) onlyOwner public returns (bool) {
434 
435         LockParams memory lockdata;
436         lockdata.TIME = releaseTime;
437         lockdata.AMOUNT = lockamount;
438         lockdata.ADDRESS = _to;
439 
440         locks.push(lockdata);
441 
442         return true;
443     }
444 
445     function canBeTransfered(address addr, uint256 value) onlyOwner public returns (bool){
446         for (uint i=0; i<locks.length; i++) {
447             if (locks[i].ADDRESS == addr){
448                 if ( value > balanceOf(addr).sub(locks[i].AMOUNT) && locks[i].TIME > now){
449 
450                     return false;
451                 }
452             }
453         }
454 
455         return true;
456     }
457 
458     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
459         if (totalSupply_.add(_amount) > MAX_TOTAL_SUPPLY){
460             return false;
461         }
462 
463         return super.mint(_to, _amount);
464     }
465 
466 
467     function transfer(address _to, uint256 _value) public returns (bool){
468         require(TRANSFERS_ALLOWED || msg.sender == owner);
469         require(canBeTransfered(msg.sender, _value));
470 
471         return super.transfer(_to, _value);
472     }
473 
474 
475     function Pause() public onlyOwner {
476         TRANSFERS_ALLOWED = false;
477     }
478 
479     function Unpause() public onlyOwner {
480         TRANSFERS_ALLOWED = true;
481     }
482 
483 }