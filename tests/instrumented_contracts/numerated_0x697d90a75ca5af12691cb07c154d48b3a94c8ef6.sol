1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a / b;
14         return c;
15     }
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract Ownable {
28     address public owner;
29 
30     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31     
32     constructor() public {
33         owner = msg.sender;
34     }
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39     function transferOwnership(address newOwner) public onlyOwner {
40         require(newOwner != address(0));
41         emit OwnershipTransferred(owner, newOwner);
42         owner = newOwner;
43     }
44 
45 }
46 
47 contract Manager is Ownable {
48     
49     address[] managers;
50 
51     modifier onlyManagers() {
52         bool exist = false;
53         if(owner == msg.sender) {
54             exist = true;
55         } else {
56             uint index = 0;
57             (exist, index) = existManager(msg.sender);
58         }
59         require(exist);
60         _;
61     }
62     
63     function getManagers() public view returns (address[] memory){
64         return managers;
65     }
66     
67     function existManager(address _to) private view returns (bool, uint) {
68         for (uint i = 0 ; i < managers.length; i++) {
69             if (managers[i] == _to) {
70                 return (true, i);
71             }
72         }
73         return (false, 0);
74     }
75     function addManager(address _to) onlyOwner public {
76         bool exist = false;
77         uint index = 0;
78         (exist, index) = existManager(_to);
79         
80         require(!exist);
81         
82         managers.push(_to);
83     }
84     function deleteManager(address _to) onlyOwner public {
85         bool exist = false;
86         uint index = 0;
87         (exist, index) = existManager(_to);
88         
89         require(exist);
90    
91         uint lastElementIndex = managers.length - 1; 
92         managers[index] = managers[lastElementIndex];
93 
94         delete managers[managers.length - 1];
95         managers.length--;
96     }
97 
98 }
99 
100 contract Pausable is Manager {
101     event Pause();
102     event Unpause();
103 
104     bool public paused = false;
105 
106     modifier whenNotPaused() {
107         require(!paused);
108         _;
109     }
110 
111     modifier whenPaused() {
112         require(paused);
113         _;
114     }
115 
116     function pause() onlyManagers whenNotPaused public {
117         paused = true;
118         emit Pause();
119     }
120 
121     function unpause() onlyManagers whenPaused public {
122         paused = false;
123         emit Unpause();
124     }
125 }
126 
127 contract ProtectAddress is Ownable {
128     
129     address[] protect;
130 
131 
132     function getProtect() public view returns (address[] memory){
133         return protect;
134     }
135     function isProtect(address _to) public view returns (bool) {
136         for (uint i = 0 ; i < protect.length; i++) {
137             if (protect[i] == _to) {
138                 return true;
139             }
140         }
141         return false;
142     }
143     function isProtectIndex(address _to) internal view returns (bool, uint) {
144         for (uint i = 0 ; i < protect.length; i++) {
145             if (protect[i] == _to) {
146                 return (true, i);
147             }
148         }
149         return (false, 0);
150     }
151     function addProtect(address _to) onlyOwner public {
152         bool exist = false;
153         uint index = 0;
154         (exist, index) = isProtectIndex(_to);
155         
156         require(!exist);
157         
158         protect.push(_to);
159     }
160     function deleteProtect(address _to) onlyOwner public {
161         bool exist = false;
162         uint index = 0;
163         (exist, index) = isProtectIndex(_to);
164         
165         require(exist);
166    
167         uint lastElementIndex = protect.length - 1; 
168         protect[index] = protect[lastElementIndex];
169 
170         delete protect[protect.length - 1];
171         protect.length--;
172     }
173 
174 }
175 
176 contract ERC20 {
177     function totalSupply() public view returns (uint256);
178     function balanceOf(address who) public view returns (uint256);
179     function allowance(address owner, address spender) public view returns (uint256);
180     function transfer(address to, uint256 value) public returns (bool);
181     function approve(address spender, uint256 value) public returns (bool);
182     function transferFrom(address from, address to, uint256 value) public returns (bool);
183 
184     event Approval(address indexed owner, address indexed spender, uint256 value);
185     event Transfer(address indexed from, address indexed to, uint256 value);
186 }
187 
188 contract Token is ERC20, Pausable, ProtectAddress {
189 
190     struct sUserInfo {
191         uint256 balance;
192         bool lock;
193         mapping(address => uint256) allowed;
194     }
195     
196     using SafeMath for uint256;
197 
198     string public name;
199     string public symbol;
200     uint8 public decimals;
201     uint256 public totalSupply;
202 
203   
204 
205     mapping(address => sUserInfo) user;
206 
207     event Mint(uint256 value);
208     event Burn(uint256 value);
209 
210    
211     
212     function () public payable {
213         revert();
214     }
215     
216     function validTransfer(address _from, address _to, uint256 _value, bool _lockCheck) internal view returns (bool) {
217         require(_to != address(this));
218         require(_to != address(0));
219         require(user[_from].balance >= _value);
220         if(_lockCheck) {
221             require(user[_from].lock == false);
222         }
223     }
224 
225     function lock(address _owner) public onlyManagers returns (bool) {
226         require(user[_owner].lock == false);
227         require(!isProtect(_owner));
228         
229         user[_owner].lock = true;
230         return true;
231     }
232     function unlock(address _owner) public onlyManagers returns (bool) {
233         require(user[_owner].lock == true);
234         user[_owner].lock = false;
235        return true;
236     }
237  
238     function burn(uint256 _value) public onlyOwner returns (bool) {
239         require(_value <= user[msg.sender].balance);
240         user[msg.sender].balance = user[msg.sender].balance.sub(_value);
241         totalSupply = totalSupply.sub(_value);
242         emit Burn(_value);
243         return true;
244     }
245    
246     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
247         require(_value == 0 || user[msg.sender].allowed[_spender] == 0); 
248         user[msg.sender].allowed[_spender] = _value; 
249         emit Approval(msg.sender, _spender, _value);
250         return true;
251     }
252     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
253         validTransfer(_from, _to, _value, true);
254         require(_value <=  user[_from].allowed[msg.sender]);
255 
256         user[_from].balance = user[_from].balance.sub(_value);
257         user[_to].balance = user[_to].balance.add(_value);
258 
259         user[_from].allowed[msg.sender] = user[_from].allowed[msg.sender].sub(_value);
260         emit Transfer(_from, _to, _value);
261         return true;
262     }
263     
264     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
265         validTransfer(msg.sender, _to, _value, true);
266 
267         user[msg.sender].balance = user[msg.sender].balance.sub(_value);
268         user[_to].balance = user[_to].balance.add(_value);
269 
270         emit Transfer(msg.sender, _to, _value);
271         return true;
272     }
273 
274     
275     function totalSupply() public view returns (uint256) {
276         return totalSupply;
277     }
278     function balanceOf(address _owner) public view returns (uint256) {
279         return user[_owner].balance;
280     }
281     function lockState(address _owner) public view returns (bool) {
282         return user[_owner].lock;
283     }
284     function allowance(address _owner, address _spender) public view returns (uint256) {
285         return user[_owner].allowed[_spender];
286     }
287     
288 }
289 
290 contract LockBalance is Manager {
291     
292     enum eLockType {None, Individual, GroupA, GroupB}
293     struct sGroupLockDate {
294         uint256[] lockTime;
295         uint256[] lockPercent;
296     }
297     struct sLockInfo {
298         uint256[] lockType;
299         uint256[] lockBalanceStandard;
300         uint256[] startTime;
301         uint256[] endTime;
302     }
303     
304     using SafeMath for uint256;
305 
306     mapping(uint => sGroupLockDate) groupLockDate;
307     
308     mapping(address => sLockInfo) lockUser;
309 
310     event Lock(address indexed from, uint256 value, uint256 endTime);
311     
312     function setLockUser(address _to, eLockType _lockType, uint256 _value, uint256 _endTime) internal {
313         require(_endTime > now); 
314         require(_value > 0); 
315         lockUser[_to].lockType.push(uint256(_lockType));
316         lockUser[_to].lockBalanceStandard.push(_value);
317         lockUser[_to].startTime.push(now);
318         lockUser[_to].endTime.push(_endTime);
319 
320         emit Lock(_to, _value, _endTime);
321     }
322 
323     function lockBalanceGroup(address _owner, uint _index) internal view returns (uint256) {
324         uint256 percent = 0;
325         uint256 key = uint256(lockUser[_owner].lockType[_index]);
326 
327         uint256 time = 99999999999;
328         for(uint256 i = 0 ; i < groupLockDate[key].lockTime.length; i++) {
329             if(now < groupLockDate[key].lockTime[i]) {
330                 if(groupLockDate[key].lockTime[i] < time) {
331                     time = groupLockDate[key].lockTime[i];
332                     percent = groupLockDate[key].lockPercent[i];    
333                 }
334             }
335         }
336         
337         if(percent == 0){
338             return 0;
339         } else {
340             return lockUser[_owner].lockBalanceStandard[_index].div(100).mul(uint256(percent));
341         }
342     }
343 
344     function lockBalanceIndividual(address _owner, uint _index) internal view returns (uint256) {
345         if(now < lockUser[_owner].endTime[_index]) {
346             return lockUser[_owner].lockBalanceStandard[_index];
347         } else {
348             return 0;
349         }
350     }
351         
352     function addLockDate(eLockType _lockType, uint256 _second, uint256 _percent) onlyManagers public {
353         sGroupLockDate storage lockInfo = groupLockDate[uint256(_lockType)];
354         bool isExists = false;
355         for(uint256 i = 0; i < lockInfo.lockTime.length; i++) {
356             if(lockInfo.lockTime[i] == _second) {
357                 revert();
358                 break;
359             }
360         }
361         
362         if(isExists) {
363            revert();
364         } else {
365             lockInfo.lockTime.push(_second);
366             lockInfo.lockPercent.push(_percent);
367         }
368     }
369     
370     function deleteLockDate(eLockType _lockType, uint256 _lockTime) onlyManagers public {
371         sGroupLockDate storage lockDate = groupLockDate[uint256(_lockType)];
372         
373         bool isExists = false;
374         uint256 index = 0;
375         for(uint256 i = 0; i < lockDate.lockTime.length; i++) {
376             if(lockDate.lockTime[i] == _lockTime) {
377                 isExists = true;
378                 index = i;
379                 break;
380             }
381         }
382         
383         if(isExists) {
384             for(uint256 k = index; k < lockDate.lockTime.length - 1; k++){
385                 lockDate.lockTime[k] = lockDate.lockTime[k + 1];
386                 lockDate.lockPercent[k] = lockDate.lockPercent[k + 1];
387             }
388             delete lockDate.lockTime[lockDate.lockTime.length - 1];
389             lockDate.lockTime.length--;
390             delete lockDate.lockPercent[lockDate.lockPercent.length - 1];
391             lockDate.lockPercent.length--;
392         } else {
393             revert();
394         }
395         
396     }
397     function deleteLockUserInfo(address _to, eLockType _lockType, uint256 _startTime, uint256 _endTime) onlyManagers public {
398 
399         bool isExists = false;
400         uint256 index = 0;
401         for(uint256 i = 0; i < lockUser[_to].lockType.length; i++) {
402             if(lockUser[_to].lockType[i] == uint256(_lockType) &&
403                 lockUser[_to].startTime[i] == _startTime &&
404                 lockUser[_to].endTime[i] == _endTime) {
405                 isExists = true;
406                 index = i;
407                 break;
408             }
409         }
410         require(isExists);
411 
412         for(uint256 k = index; k < lockUser[_to].lockType.length - 1; k++){
413             lockUser[_to].lockType[k] = lockUser[_to].lockType[k + 1];
414             lockUser[_to].lockBalanceStandard[k] = lockUser[_to].lockBalanceStandard[k + 1];
415             lockUser[_to].startTime[k] = lockUser[_to].startTime[k + 1];
416             lockUser[_to].endTime[k] = lockUser[_to].endTime[k + 1];
417         }
418         
419         delete lockUser[_to].lockType[lockUser[_to].lockType.length - 1];
420         lockUser[_to].lockType.length--;
421         
422         delete lockUser[_to].lockBalanceStandard[lockUser[_to].lockBalanceStandard.length - 1];
423         lockUser[_to].lockBalanceStandard.length--;
424         
425         delete lockUser[_to].startTime[lockUser[_to].startTime.length - 1];
426         lockUser[_to].startTime.length--;
427         
428         delete lockUser[_to].endTime[lockUser[_to].endTime.length - 1];
429         lockUser[_to].endTime.length--;
430         
431     }
432 
433     function lockTypeInfoGroup(eLockType _type) public view returns (uint256[], uint256[]) {
434         uint256 key = uint256(_type);
435         return (groupLockDate[key].lockTime, groupLockDate[key].lockPercent);
436     }
437     function lockUserInfo(address _owner) public view returns (uint256[], uint256[], uint256[], uint256[], uint256[]) {
438         
439         uint256[] memory balance = new uint256[](lockUser[_owner].lockType.length);
440         for(uint256 i = 0; i < lockUser[_owner].lockType.length; i++){
441             if(lockUser[_owner].lockType[i] == uint256(eLockType.Individual)) {
442                 balance[i] = balance[i].add(lockBalanceIndividual(_owner, i));
443             } else if(lockUser[_owner].lockType[i] != uint256(eLockType.None)) {
444                 balance[i] = balance[i].add(lockBalanceGroup(_owner, i));
445             }
446         }
447         
448         return (lockUser[_owner].lockType,
449         lockUser[_owner].lockBalanceStandard,
450         balance,
451         lockUser[_owner].startTime,
452         lockUser[_owner].endTime);
453     }
454     function lockBalanceAll(address _owner) public view returns (uint256) {
455         uint256 lockBalance = 0;
456         for(uint256 i = 0; i < lockUser[_owner].lockType.length; i++){
457             if(lockUser[_owner].lockType[i] == uint256(eLockType.Individual)) {
458                 lockBalance = lockBalance.add(lockBalanceIndividual(_owner, i));
459             } else if(lockUser[_owner].lockType[i] != uint256(eLockType.None)) {
460                 lockBalance = lockBalance.add(lockBalanceGroup(_owner, i));
461             }
462         }
463         return lockBalance;
464     }
465     
466 }
467 
468 contract HALF is Token, LockBalance {
469 
470     constructor() public {
471         name = "HALF";
472         symbol = "HALF";
473         decimals = 18;
474         uint256 initialSupply = 1024000000;//1,024,000,000
475         totalSupply = initialSupply * 10 ** uint(decimals);
476         user[owner].balance = totalSupply;
477         emit Transfer(address(0), owner, totalSupply);
478     }
479 
480 
481     bool public finishRestore = false; 
482     
483     function isFinishRestore() public onlyOwner { 
484         finishRestore = true; 
485     }     
486   
487     function validTransfer(address _from, address _to, uint256 _value, bool _lockCheck) internal view returns (bool) {
488         super.validTransfer(_from, _to, _value, _lockCheck);
489         if(_lockCheck) {
490             require(_value <= useBalanceOf(_from));
491         }
492     }
493 
494     function setLockUsers(eLockType _type, address[] _to, uint256[] _value, uint256[] _endTime) onlyManagers public {  
495         require(_to.length > 0);
496         require(_to.length == _value.length);
497         require(_to.length == _endTime.length);
498         require(_type != eLockType.None);
499         
500         
501         for(uint256 i = 0; i < _to.length; i++){
502             require(!isProtect(_to[i]));
503             setLockUser(_to[i], _type, _value[i], _endTime[i]);
504         }
505     }
506     
507     function transferRestore(address _from, address _to, uint256 _value) public onlyOwner returns (bool) {
508         require(!finishRestore);
509         require(!isProtect(_from));
510         
511         require(_to != address(this));
512         require(_to != address(0));
513         require(user[_from].balance >= _value);
514         
515         user[_from].balance = user[_from].balance.sub(_value);
516         user[_to].balance = user[_to].balance.add(_value);
517 
518         emit Transfer(msg.sender, _to, _value);
519         return true;
520     }
521     function useBalanceOf(address _owner) public view returns (uint256) {
522         return balanceOf(_owner).sub(lockBalanceAll(_owner));
523     }
524   
525 
526 }