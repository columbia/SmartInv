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
47 contract Pausable is Ownable {
48     event Pause();
49     event Unpause();
50 
51     bool public paused = false;
52 
53     modifier whenNotPaused() {
54         require(!paused);
55         _;
56     }
57 
58     modifier whenPaused() {
59         require(paused);
60         _;
61     }
62 
63     function pause() onlyOwner whenNotPaused public {
64         paused = true;
65         emit Pause();
66     }
67 
68     function unpause() onlyOwner whenPaused public {
69         paused = false;
70         emit Unpause();
71     }
72 }
73 
74 contract ERC20 {
75     function balanceOf(address who) public view returns (uint256);
76     function allowance(address owner, address spender) public view returns (uint256);
77     function transfer(address to, uint256 value) public returns (bool);
78     function approve(address spender, uint256 value) public returns (bool);
79     function transferFrom(address from, address to, uint256 value) public returns (bool);
80 
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 contract Token is ERC20, Pausable {
86 
87     struct sUserInfo {
88         uint256 balance;
89         bool lock;
90         mapping(address => uint256) allowed;
91     }
92     
93     using SafeMath for uint256;
94 
95     string public name;
96     string public symbol;
97     uint256 public decimals;
98     uint256 public totalSupply;
99 
100     bool public restoreFinished = false;
101 
102     mapping(address => sUserInfo) user;
103 
104     event Mint(uint256 value);
105     event Burn(uint256 value);
106     event RestoreFinished();
107     
108     modifier canRestore() {
109         require(!restoreFinished);
110         _;
111     }
112     
113     function () external payable {
114         revert();
115     }
116     
117     function validTransfer(address _from, address _to, uint256 _value, bool _lockCheck) internal {
118         require(_to != address(this));
119         require(_to != address(0));
120         require(user[_from].balance >= _value);
121         if(_lockCheck) {
122             require(user[_from].lock == false);
123         }
124     }
125 
126     function lock(address _owner) public onlyOwner returns (bool) {
127         require(user[_owner].lock == false);
128         user[_owner].lock = true;
129         return true;
130     }
131     function unlock(address _owner) public onlyOwner returns (bool) {
132         require(user[_owner].lock == true);
133         user[_owner].lock = false;
134        return true;
135     }
136  
137     function burn(address _to, uint256 _value) public onlyOwner returns (bool) {
138         require(_value <= user[_to].balance);
139         user[_to].balance = user[_to].balance.sub(_value);
140         totalSupply = totalSupply.sub(_value);
141         emit Burn(_value);
142         return true;
143     }
144    
145     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
146         validTransfer(msg.sender, _to, _value, false);
147        
148         user[msg.sender].balance = user[msg.sender].balance.sub(_value);
149         user[_to].balance = user[_to].balance.add(_value);
150        
151         emit Transfer(msg.sender, _to, _value);
152         return true;
153     }
154 
155     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
156         require(_value > 0);
157         user[msg.sender].allowed[_spender] = _value; 
158         emit Approval(msg.sender, _spender, _value);
159         return true;
160     }
161     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
162         validTransfer(_from, _to, _value, true);
163         require(_value <=  user[_from].allowed[msg.sender]);
164 
165         user[_from].balance = user[_from].balance.sub(_value);
166         user[_to].balance = user[_to].balance.add(_value);
167 
168         user[_from].allowed[msg.sender] = user[_from].allowed[msg.sender].sub(_value);
169         emit Transfer(_from, _to, _value);
170         return true;
171     }
172     
173     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
174         validTransfer(msg.sender, _to, _value, true);
175 
176         user[msg.sender].balance = user[msg.sender].balance.sub(_value);
177         user[_to].balance = user[_to].balance.add(_value);
178 
179         emit Transfer(msg.sender, _to, _value);
180         return true;
181     }
182     
183     function transferRestore(address _from, address _to, uint256 _value) public onlyOwner canRestore returns (bool) {
184         validTransfer(_from, _to, _value, false);
185        
186         user[_from].balance = user[_from].balance.sub(_value);
187         user[_to].balance = user[_to].balance.add(_value);
188        
189         emit Transfer(_from, _to, _value);
190         return true;
191     }
192     
193     function finishRestore() public onlyOwner returns (bool) {
194         restoreFinished = true;
195         emit RestoreFinished();
196         return true;
197     }
198     
199     
200     function balanceOf(address _owner) public view returns (uint256) {
201         return user[_owner].balance;
202     }
203     function lockState(address _owner) public view returns (bool) {
204         return user[_owner].lock;
205     }
206     function allowance(address _owner, address _spender) public view returns (uint256) {
207         return user[_owner].allowed[_spender];
208     }
209     
210 }
211 
212 contract LockBalance is Ownable {
213     
214     enum eLockType {None, Individual, GroupA, GroupB, GroupC, GroupD, GroupE, GroupF, GroupG, GroupH, GroupI, GroupJ}
215     struct sGroupLockDate {
216         uint256[] lockTime;
217         uint256[] lockPercent;
218     }
219     struct sLockInfo {
220         uint256[] lockType;
221         uint256[] lockBalanceStandard;
222         uint256[] startTime;
223         uint256[] endTime;
224     }
225     
226     using SafeMath for uint256;
227 
228     mapping(uint => sGroupLockDate) groupLockDate;
229     
230     mapping(address => sLockInfo) lockUser;
231 
232     event Lock(address indexed from, uint256 value, uint256 endTime);
233     
234     function setLockUser(address _to, eLockType _lockType, uint256 _value, uint256 _endTime) internal {
235         lockUser[_to].lockType.push(uint256(_lockType));
236         lockUser[_to].lockBalanceStandard.push(_value);
237         lockUser[_to].startTime.push(now);
238         lockUser[_to].endTime.push(_endTime);
239 
240         emit Lock(_to, _value, _endTime);
241     }
242 
243     function lockBalanceGroup(address _owner, uint _index) internal view returns (uint256) {
244         uint256 percent = 0;
245         uint256 key = uint256(lockUser[_owner].lockType[_index]);
246 
247         uint256 time = 99999999999;
248         for(uint256 i = 0 ; i < groupLockDate[key].lockTime.length; i++) {
249             if(now < groupLockDate[key].lockTime[i]) {
250                 if(groupLockDate[key].lockTime[i] < time) {
251                     time = groupLockDate[key].lockTime[i];
252                     percent = groupLockDate[key].lockPercent[i];    
253                 }
254             }
255         }
256         
257         if(percent == 0){
258             return 0;
259         } else {
260             return lockUser[_owner].lockBalanceStandard[_index].mul(uint256(percent)).div(100);
261         }
262     }
263 
264     function lockBalanceIndividual(address _owner, uint _index) internal view returns (uint256) {
265         if(now < lockUser[_owner].endTime[_index]) {
266             return lockUser[_owner].lockBalanceStandard[_index];
267         } else {
268             return 0;
269         }
270     }
271     
272     function clearLockUser(address _owner, uint _index) onlyOwner public {
273         require(lockUser[_owner].endTime.length >_index);
274         lockUser[_owner].endTime[_index] = 0;
275     }
276         
277     function addLockDate(eLockType _lockType, uint256 _second, uint256 _percent) onlyOwner public {
278         require(_percent > 0 && _percent <= 100);
279         sGroupLockDate storage lockInfo = groupLockDate[uint256(_lockType)];
280         bool isExists = false;
281         for(uint256 i = 0; i < lockInfo.lockTime.length; i++) {
282             if(lockInfo.lockTime[i] == _second) {
283                 revert();
284                 break;
285             }
286         }
287         
288         if(isExists) {
289            revert();
290         } else {
291             lockInfo.lockTime.push(_second);
292             lockInfo.lockPercent.push(_percent);
293         }
294     }
295     
296     function deleteLockDate(eLockType _lockType, uint256 _lockTime) onlyOwner public {
297         sGroupLockDate storage lockDate = groupLockDate[uint256(_lockType)];
298         
299         bool isExists = false;
300         uint256 index = 0;
301         for(uint256 i = 0; i < lockDate.lockTime.length; i++) {
302             if(lockDate.lockTime[i] == _lockTime) {
303                 isExists = true;
304                 index = i;
305                 break;
306             }
307         }
308         
309         if(isExists) {
310             for(uint256 k = index; k < lockDate.lockTime.length - 1; k++){
311                 lockDate.lockTime[k] = lockDate.lockTime[k + 1];
312                 lockDate.lockPercent[k] = lockDate.lockPercent[k + 1];
313             }
314             delete lockDate.lockTime[lockDate.lockTime.length - 1];
315             lockDate.lockTime.length--;
316             delete lockDate.lockPercent[lockDate.lockPercent.length - 1];
317             lockDate.lockPercent.length--;
318         } else {
319             revert();
320         }
321         
322     }
323 
324 
325     function lockTypeInfoGroup(eLockType _type) public view returns (uint256[] memory , uint256[] memory ) {
326         uint256 key = uint256(_type);
327         return (groupLockDate[key].lockTime, groupLockDate[key].lockPercent);
328     }
329     function lockUserInfo(address _owner) public view returns (uint256[] memory , uint256[] memory , uint256[] memory , uint256[] memory , uint256[] memory ) {
330         
331         uint256[] memory balance = new uint256[](lockUser[_owner].lockType.length);
332         for(uint256 i = 0; i < lockUser[_owner].lockType.length; i++){
333             if(lockUser[_owner].lockType[i] == uint256(eLockType.Individual)) {
334                 balance[i] = balance[i].add(lockBalanceIndividual(_owner, i));
335             } else if(lockUser[_owner].lockType[i] != uint256(eLockType.None)) {
336                 balance[i] = balance[i].add(lockBalanceGroup(_owner, i));
337             }
338         }
339         
340         return (lockUser[_owner].lockType,
341         lockUser[_owner].lockBalanceStandard,
342         balance,
343         lockUser[_owner].startTime,
344         lockUser[_owner].endTime);
345     }
346     function lockBalanceAll(address _owner) public view returns (uint256) {
347         uint256 lockBalance = 0;
348         for(uint256 i = 0; i < lockUser[_owner].lockType.length; i++){
349             if(lockUser[_owner].lockType[i] == uint256(eLockType.Individual)) {
350                 lockBalance = lockBalance.add(lockBalanceIndividual(_owner, i));
351             } else if(lockUser[_owner].lockType[i] != uint256(eLockType.None)) {
352                 lockBalance = lockBalance.add(lockBalanceGroup(_owner, i));
353             }
354         }
355         return lockBalance;
356     }
357     
358 }
359 
360 contract daviumcoin is Token, LockBalance {
361 
362     constructor() public {
363         name = "DAVIUM";
364         symbol = "DTX";
365         decimals = 18;
366         uint256 initialSupply = 100000000;
367         totalSupply = initialSupply * 10 ** uint(decimals);
368         user[owner].balance = totalSupply;
369         emit Transfer(address(0), owner, totalSupply);
370     }
371 
372     function validTransfer(address _from, address _to, uint256 _value, bool _lockCheck) internal {
373         super.validTransfer(_from, _to, _value, _lockCheck);
374         if(_lockCheck) {
375             require(_value <= useBalanceOf(_from));
376         }
377     }
378 
379     function setLockUsers(eLockType _type, address[] memory _to, uint256[] memory _value, uint256[] memory  _endTime) onlyOwner public {  
380         require(_to.length > 0);
381         require(_to.length == _value.length);
382         require(_to.length == _endTime.length);
383         require(_type != eLockType.None);
384         
385         for(uint256 i = 0; i < _to.length; i++){
386             require(_value[i] <= useBalanceOf(_to[i]));
387             setLockUser(_to[i], _type, _value[i], _endTime[i]);
388         }
389     }
390     
391     function useBalanceOf(address _owner) public view returns (uint256) {
392         return balanceOf(_owner).sub(lockBalanceAll(_owner));
393     }
394     
395 }