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
47 
48 contract Manager is Ownable {
49     
50     address[] managers;
51 
52     modifier onlyManagers() {
53         bool exist = false;
54         if(owner == msg.sender) {
55             exist = true;
56         } else {
57             uint index = 0;
58             (exist, index) = existManager(msg.sender);
59         }
60         require(exist);
61         _;
62     }
63     
64     function getManagers() public view returns (address[] memory){
65         return managers;
66     }
67     
68     function existManager(address _to) private view returns (bool, uint) {
69         for (uint i = 0 ; i < managers.length; i++) {
70             if (managers[i] == _to) {
71                 return (true, i);
72             }
73         }
74         return (false, 0);
75     }
76     function addManager(address _to) onlyOwner public {
77         bool exist = false;
78         uint index = 0;
79         (exist, index) = existManager(_to);
80         
81         require(!exist);
82         
83         managers.push(_to);
84     }
85     function deleteManager(address _to) onlyOwner public {
86         bool exist = false;
87         uint index = 0;
88         (exist, index) = existManager(_to);
89         
90         require(exist);
91    
92         uint lastElementIndex = managers.length - 1; 
93         managers[index] = managers[lastElementIndex];
94 
95         delete managers[managers.length - 1];
96         managers.length--;
97     }
98 
99 }
100 
101 contract Pausable is Manager {
102     event Pause();
103     event Unpause();
104 
105     bool public paused = false;
106 
107     modifier whenNotPaused() {
108         require(!paused);
109         _;
110     }
111 
112     modifier whenPaused() {
113         require(paused);
114         _;
115     }
116 
117     function pause() onlyManagers whenNotPaused public {
118         paused = true;
119         emit Pause();
120     }
121 
122     function unpause() onlyManagers whenPaused public {
123         paused = false;
124         emit Unpause();
125     }
126 }
127 
128 contract ERC20 {
129     function totalSupply() public view returns (uint256);
130     function balanceOf(address who) public view returns (uint256);
131     function allowance(address owner, address spender) public view returns (uint256);
132     function transfer(address to, uint256 value) public returns (bool);
133     function approve(address spender, uint256 value) public returns (bool);
134     function transferFrom(address from, address to, uint256 value) public returns (bool);
135 
136     event Approval(address indexed owner, address indexed spender, uint256 value);
137     event Transfer(address indexed from, address indexed to, uint256 value);
138 }
139 
140 contract Token is ERC20, Pausable {
141 
142     struct sUserInfo {
143         uint256 balance;
144         bool lock;
145         mapping(address => uint256) allowed;
146     }
147     
148     using SafeMath for uint256;
149 
150     string public name;
151     string public symbol;
152     uint8 public decimals;
153     uint256 public totalSupply;
154 
155   
156 
157     mapping(address => sUserInfo) user;
158 
159     event Mint(uint256 value);
160     event Burn(uint256 value);
161 
162    
163     
164     function () public payable {
165         revert();
166     }
167     
168     function validTransfer(address _from, address _to, uint256 _value, bool _lockCheck) internal view returns (bool) {
169         require(_to != address(this));
170         require(_to != address(0));
171         require(user[_from].balance >= _value);
172         if(_lockCheck) {
173             require(user[_from].lock == false);
174             require(user[_to].lock == false); 
175             require(user[msg.sender].lock == false); 
176         }
177     }
178 
179     function lock(address _owner) public onlyManagers returns (bool) {
180         require(user[_owner].lock == false);
181         user[_owner].lock = true;
182         return true;
183     }
184     function unlock(address _owner) public onlyManagers returns (bool) {
185         require(user[_owner].lock == true);
186         user[_owner].lock = false;
187        return true;
188     }
189  
190     function burn(uint256 _value) public onlyOwner returns (bool) {
191         require(_value <= user[msg.sender].balance);
192         user[msg.sender].balance = user[msg.sender].balance.sub(_value);
193         totalSupply = totalSupply.sub(_value);
194         emit Burn(_value);
195         return true;
196     }
197    
198     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
199         require(_value == 0 || user[msg.sender].allowed[_spender] == 0); 
200         user[msg.sender].allowed[_spender] = _value; 
201         emit Approval(msg.sender, _spender, _value);
202         return true;
203     }
204     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
205         validTransfer(_from, _to, _value, true);
206         require(_value <=  user[_from].allowed[msg.sender]);
207 
208         user[_from].balance = user[_from].balance.sub(_value);
209         user[_to].balance = user[_to].balance.add(_value);
210 
211         user[_from].allowed[msg.sender] = user[_from].allowed[msg.sender].sub(_value);
212         emit Transfer(_from, _to, _value);
213         return true;
214     }
215     
216     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
217         validTransfer(msg.sender, _to, _value, true);
218 
219         user[msg.sender].balance = user[msg.sender].balance.sub(_value);
220         user[_to].balance = user[_to].balance.add(_value);
221 
222         emit Transfer(msg.sender, _to, _value);
223         return true;
224     }
225 
226     
227     function totalSupply() public view returns (uint256) {
228         return totalSupply;
229     }
230     function balanceOf(address _owner) public view returns (uint256) {
231         return user[_owner].balance;
232     }
233     function lockState(address _owner) public view returns (bool) {
234         return user[_owner].lock;
235     }
236     function allowance(address _owner, address _spender) public view returns (uint256) {
237         return user[_owner].allowed[_spender];
238     }
239     
240 }
241 
242 contract LockBalance is Manager {
243     
244     enum eLockType {None, Individual, GroupA, GroupB}
245     struct sGroupLockDate {
246         uint256[] lockTime;
247         uint256[] lockPercent;
248     }
249     struct sLockInfo {
250         uint256[] lockType;
251         uint256[] lockBalanceStandard;
252         uint256[] startTime;
253         uint256[] endTime;
254     }
255     
256     using SafeMath for uint256;
257 
258     mapping(uint => sGroupLockDate) groupLockDate;
259     
260     mapping(address => sLockInfo) lockUser;
261 
262     event Lock(address indexed from, uint256 value, uint256 endTime);
263     
264     function setLockUser(address _to, eLockType _lockType, uint256 _value, uint256 _endTime) internal {
265         require(_endTime > now); 
266         require(_value > 0); 
267         lockUser[_to].lockType.push(uint256(_lockType));
268         lockUser[_to].lockBalanceStandard.push(_value);
269         lockUser[_to].startTime.push(now);
270         lockUser[_to].endTime.push(_endTime);
271 
272         emit Lock(_to, _value, _endTime);
273     }
274 
275     function lockBalanceGroup(address _owner, uint _index) internal view returns (uint256) {
276         uint256 percent = 0;
277         uint256 key = uint256(lockUser[_owner].lockType[_index]);
278 
279         uint256 time = 99999999999;
280         for(uint256 i = 0 ; i < groupLockDate[key].lockTime.length; i++) {
281             if(now < groupLockDate[key].lockTime[i]) {
282                 if(groupLockDate[key].lockTime[i] < time) {
283                     time = groupLockDate[key].lockTime[i];
284                     percent = groupLockDate[key].lockPercent[i];    
285                 }
286             }
287         }
288         
289         if(percent == 0){
290             return 0;
291         } else {
292             return lockUser[_owner].lockBalanceStandard[_index].div(100).mul(uint256(percent));
293         }
294     }
295 
296     function lockBalanceIndividual(address _owner, uint _index) internal view returns (uint256) {
297         if(now < lockUser[_owner].endTime[_index]) {
298             return lockUser[_owner].lockBalanceStandard[_index];
299         } else {
300             return 0;
301         }
302     }
303         
304     function addLockDate(eLockType _lockType, uint256 _second, uint256 _percent) onlyManagers public {
305         sGroupLockDate storage lockInfo = groupLockDate[uint256(_lockType)];
306         bool isExists = false;
307         for(uint256 i = 0; i < lockInfo.lockTime.length; i++) {
308             if(lockInfo.lockTime[i] == _second) {
309                 revert();
310                 break;
311             }
312         }
313         
314         if(isExists) {
315            revert();
316         } else {
317             lockInfo.lockTime.push(_second);
318             lockInfo.lockPercent.push(_percent);
319         }
320     }
321     
322     function deleteLockDate(eLockType _lockType, uint256 _lockTime) onlyManagers public {
323         sGroupLockDate storage lockDate = groupLockDate[uint256(_lockType)];
324         
325         bool isExists = false;
326         uint256 index = 0;
327         for(uint256 i = 0; i < lockDate.lockTime.length; i++) {
328             if(lockDate.lockTime[i] == _lockTime) {
329                 isExists = true;
330                 index = i;
331                 break;
332             }
333         }
334         
335         if(isExists) {
336             for(uint256 k = index; k < lockDate.lockTime.length - 1; k++){
337                 lockDate.lockTime[k] = lockDate.lockTime[k + 1];
338                 lockDate.lockPercent[k] = lockDate.lockPercent[k + 1];
339             }
340             delete lockDate.lockTime[lockDate.lockTime.length - 1];
341             lockDate.lockTime.length--;
342             delete lockDate.lockPercent[lockDate.lockPercent.length - 1];
343             lockDate.lockPercent.length--;
344         } else {
345             revert();
346         }
347         
348     }
349 
350 
351     function lockTypeInfoGroup(eLockType _type) public view returns (uint256[], uint256[]) {
352         uint256 key = uint256(_type);
353         return (groupLockDate[key].lockTime, groupLockDate[key].lockPercent);
354     }
355     function lockUserInfo(address _owner) public view returns (uint256[], uint256[], uint256[], uint256[], uint256[]) {
356         
357         uint256[] memory balance = new uint256[](lockUser[_owner].lockType.length);
358         for(uint256 i = 0; i < lockUser[_owner].lockType.length; i++){
359             if(lockUser[_owner].lockType[i] == uint256(eLockType.Individual)) {
360                 balance[i] = balance[i].add(lockBalanceIndividual(_owner, i));
361             } else if(lockUser[_owner].lockType[i] != uint256(eLockType.None)) {
362                 balance[i] = balance[i].add(lockBalanceGroup(_owner, i));
363             }
364         }
365         
366         return (lockUser[_owner].lockType,
367         lockUser[_owner].lockBalanceStandard,
368         balance,
369         lockUser[_owner].startTime,
370         lockUser[_owner].endTime);
371     }
372     function lockBalanceAll(address _owner) public view returns (uint256) {
373         uint256 lockBalance = 0;
374         for(uint256 i = 0; i < lockUser[_owner].lockType.length; i++){
375             if(lockUser[_owner].lockType[i] == uint256(eLockType.Individual)) {
376                 lockBalance = lockBalance.add(lockBalanceIndividual(_owner, i));
377             } else if(lockUser[_owner].lockType[i] != uint256(eLockType.None)) {
378                 lockBalance = lockBalance.add(lockBalanceGroup(_owner, i));
379             }
380         }
381         return lockBalance;
382     }
383     
384 }
385 
386 contract GoldminingMembers is Token, LockBalance {
387 
388     constructor() public {
389         name = "Gold mining Members";
390         symbol = "GMM";
391         decimals = 18;
392         uint256 initialSupply = 1000000000;//1,000,000,000
393         totalSupply = initialSupply * 10 ** uint(decimals);
394         user[owner].balance = totalSupply;
395         emit Transfer(address(0), owner, totalSupply);
396     }
397 
398 
399     bool public SetLockUserForbidden = false; 
400     
401     event LockUserStage(); 
402  
403     function controlSetLockUser(bool _stage) public onlyOwner { 
404         SetLockUserForbidden = _stage; 
405         emit LockUserStage(); 
406     }     
407   
408     function validTransfer(address _from, address _to, uint256 _value, bool _lockCheck) internal view returns (bool) {
409         super.validTransfer(_from, _to, _value, _lockCheck);
410         if(_lockCheck) {
411             require(_value <= useBalanceOf(_from));
412         }
413     }
414 
415     function setLockUsers(eLockType _type, address[] _to, uint256[] _value, uint256[] _endTime) onlyManagers public {  
416         require(!SetLockUserForbidden); 
417         require(_to.length > 0);
418         require(_to.length == _value.length);
419         require(_to.length == _endTime.length);
420         require(_type != eLockType.None);
421         
422         for(uint256 i = 0; i < _to.length; i++){
423             require(_value[i] <= useBalanceOf(_to[i]));
424             setLockUser(_to[i], _type, _value[i], _endTime[i]);
425         }
426     }
427     
428     function useBalanceOf(address _owner) public view returns (uint256) {
429         return balanceOf(_owner).sub(lockBalanceAll(_owner));
430     }
431     
432 }