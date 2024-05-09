1 pragma solidity ^0.4.18;
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
32     function Ownable() public {
33         owner = msg.sender;
34     }
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39     function transferOwnership(address newOwner) public onlyOwner {
40         require(newOwner != address(0));
41         OwnershipTransferred(owner, newOwner);
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
65         Pause();
66     }
67 
68     function unpause() onlyOwner whenPaused public {
69         paused = false;
70         Unpause();
71     }
72 }
73 
74 contract ERC20 {
75     function totalSupply() public view returns (uint256);
76     function balanceOf(address who) public view returns (uint256);
77     function allowance(address owner, address spender) public view returns (uint256);
78     function transfer(address to, uint256 value) public returns (bool);
79     function approve(address spender, uint256 value) public returns (bool);
80     function transferFrom(address from, address to, uint256 value) public returns (bool);
81 
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 }
85 
86 contract Token is ERC20, Pausable {
87 
88     struct sUserInfo {
89         uint256 balance;
90         bool lock;
91         mapping(address => uint256) allowed;
92     }
93     
94     using SafeMath for uint256;
95 
96     string public name;
97     string public symbol;
98     uint256 public decimals;
99     uint256 public totalSupply;
100 
101     bool public restoreFinished = false;
102 
103     mapping(address => sUserInfo) user;
104 
105     event Mint(uint256 value);
106     event Burn(uint256 value);
107     event RestoreFinished();
108     
109     modifier canRestore() {
110         require(!restoreFinished);
111         _;
112     }
113     
114     function () public payable {
115         revert();
116     }
117     
118     function validTransfer(address _from, address _to, uint256 _value, bool _lockCheck) internal {
119         require(_to != address(this));
120         require(_to != address(0));
121         require(user[_from].balance >= _value);
122         if(_lockCheck) {
123             require(user[_from].lock == false);
124         }
125     }
126 
127     function lock(address _owner) public onlyOwner returns (bool) {
128         require(user[_owner].lock == false);
129         user[_owner].lock = true;
130         return true;
131     }
132     function unlock(address _owner) public onlyOwner returns (bool) {
133         require(user[_owner].lock == true);
134         user[_owner].lock = false;
135        return true;
136     }
137  
138     function burn(address _to, uint256 _value) public onlyOwner returns (bool) {
139         require(_value <= user[_to].balance);
140         user[_to].balance = user[_to].balance.sub(_value);
141         totalSupply = totalSupply.sub(_value);
142         Burn(_value);
143         return true;
144     }
145    
146     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
147         validTransfer(msg.sender, _to, _value, false);
148        
149         user[msg.sender].balance = user[msg.sender].balance.sub(_value);
150         user[_to].balance = user[_to].balance.add(_value);
151        
152         Transfer(msg.sender, _to, _value);
153         return true;
154     }
155 
156     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
157         require(_value > 0);
158         user[msg.sender].allowed[_spender] = _value; 
159         Approval(msg.sender, _spender, _value);
160         return true;
161     }
162     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
163         validTransfer(_from, _to, _value, true);
164         require(_value <=  user[_from].allowed[msg.sender]);
165 
166         user[_from].balance = user[_from].balance.sub(_value);
167         user[_to].balance = user[_to].balance.add(_value);
168 
169         user[_from].allowed[msg.sender] = user[_from].allowed[msg.sender].sub(_value);
170         Transfer(_from, _to, _value);
171         return true;
172     }
173     
174     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
175         validTransfer(msg.sender, _to, _value, true);
176 
177         user[msg.sender].balance = user[msg.sender].balance.sub(_value);
178         user[_to].balance = user[_to].balance.add(_value);
179 
180         Transfer(msg.sender, _to, _value);
181         return true;
182     }
183     
184     function transferRestore(address _from, address _to, uint256 _value) public onlyOwner canRestore returns (bool) {
185         validTransfer(_from, _to, _value, false);
186        
187         user[_from].balance = user[_from].balance.sub(_value);
188         user[_to].balance = user[_to].balance.add(_value);
189        
190         Transfer(_from, _to, _value);
191         return true;
192     }
193     
194     function finishRestore() public onlyOwner returns (bool) {
195         restoreFinished = true;
196         RestoreFinished();
197         return true;
198     }
199     
200     
201     function totalSupply() public view returns (uint256) {
202         return totalSupply;
203     }
204     function balanceOf(address _owner) public view returns (uint256) {
205         return user[_owner].balance;
206     }
207     function lockState(address _owner) public view returns (bool) {
208         return user[_owner].lock;
209     }
210     function allowance(address _owner, address _spender) public view returns (uint256) {
211         return user[_owner].allowed[_spender];
212     }
213     
214 }
215 
216 contract LockBalance is Ownable {
217     
218     enum eLockType {None, Individual, GroupA, GroupB, GroupC, GroupD}
219     struct sGroupLockDate {
220         uint256[] lockTime;
221         uint256[] lockPercent;
222     }
223     struct sLockInfo {
224         uint256[] lockType;
225         uint256[] lockBalanceStandard;
226         uint256[] startTime;
227         uint256[] endTime;
228     }
229     
230     using SafeMath for uint256;
231 
232     mapping(uint => sGroupLockDate) groupLockDate;
233     
234     mapping(address => sLockInfo) lockUser;
235 
236     event Lock(address indexed from, uint256 value, uint256 endTime);
237     
238     function setLockUser(address _to, eLockType _lockType, uint256 _value, uint256 _endTime) internal {
239         lockUser[_to].lockType.push(uint256(_lockType));
240         lockUser[_to].lockBalanceStandard.push(_value);
241         lockUser[_to].startTime.push(now);
242         lockUser[_to].endTime.push(_endTime);
243 
244         Lock(_to, _value, _endTime);
245     }
246 
247     function lockBalanceGroup(address _owner, uint _index) internal view returns (uint256) {
248         uint256 percent = 0;
249         uint256 key = uint256(lockUser[_owner].lockType[_index]);
250 
251         uint256 time = 99999999999;
252         for(uint256 i = 0 ; i < groupLockDate[key].lockTime.length; i++) {
253             if(now < groupLockDate[key].lockTime[i]) {
254                 if(groupLockDate[key].lockTime[i] < time) {
255                     time = groupLockDate[key].lockTime[i];
256                     percent = groupLockDate[key].lockPercent[i];    
257                 }
258             }
259         }
260         
261         if(percent == 0){
262             return 0;
263         } else {
264             return lockUser[_owner].lockBalanceStandard[_index].div(100).mul(uint256(percent));
265         }
266     }
267 
268     function lockBalanceIndividual(address _owner, uint _index) internal view returns (uint256) {
269         if(now < lockUser[_owner].endTime[_index]) {
270             return lockUser[_owner].lockBalanceStandard[_index];
271         } else {
272             return 0;
273         }
274     }
275     
276     function clearLockUser(address _owner, uint _index) onlyOwner public {
277         require(lockUser[_owner].endTime.length >_index);
278         lockUser[_owner].endTime[_index] = 0;
279     }
280         
281     function addLockDate(eLockType _lockType, uint256 _second, uint256 _percent) onlyOwner public {
282         sGroupLockDate storage lockInfo = groupLockDate[uint256(_lockType)];
283         bool isExists = false;
284         for(uint256 i = 0; i < lockInfo.lockTime.length; i++) {
285             if(lockInfo.lockTime[i] == _second) {
286                 revert();
287                 break;
288             }
289         }
290         
291         if(isExists) {
292            revert();
293         } else {
294             lockInfo.lockTime.push(_second);
295             lockInfo.lockPercent.push(_percent);
296         }
297     }
298     
299     function deleteLockDate(eLockType _lockType, uint256 _lockTime) onlyOwner public {
300         sGroupLockDate storage lockDate = groupLockDate[uint256(_lockType)];
301         
302         bool isExists = false;
303         uint256 index = 0;
304         for(uint256 i = 0; i < lockDate.lockTime.length; i++) {
305             if(lockDate.lockTime[i] == _lockTime) {
306                 isExists = true;
307                 index = i;
308                 break;
309             }
310         }
311         
312         if(isExists) {
313             for(uint256 k = index; k < lockDate.lockTime.length - 1; k++){
314                 lockDate.lockTime[k] = lockDate.lockTime[k + 1];
315                 lockDate.lockPercent[k] = lockDate.lockPercent[k + 1];
316             }
317             delete lockDate.lockTime[lockDate.lockTime.length - 1];
318             lockDate.lockTime.length--;
319             delete lockDate.lockPercent[lockDate.lockPercent.length - 1];
320             lockDate.lockPercent.length--;
321         } else {
322             revert();
323         }
324         
325     }
326 
327 
328     function lockTypeInfoGroup(eLockType _type) public view returns (uint256[], uint256[]) {
329         uint256 key = uint256(_type);
330         return (groupLockDate[key].lockTime, groupLockDate[key].lockPercent);
331     }
332     function lockUserInfo(address _owner) public view returns (uint256[], uint256[], uint256[], uint256[], uint256[]) {
333         
334         uint256[] memory balance = new uint256[](lockUser[_owner].lockType.length);
335         for(uint256 i = 0; i < lockUser[_owner].lockType.length; i++){
336             if(lockUser[_owner].lockType[i] == uint256(eLockType.Individual)) {
337                 balance[i] = balance[i].add(lockBalanceIndividual(_owner, i));
338             } else if(lockUser[_owner].lockType[i] != uint256(eLockType.None)) {
339                 balance[i] = balance[i].add(lockBalanceGroup(_owner, i));
340             }
341         }
342         
343         return (lockUser[_owner].lockType,
344         lockUser[_owner].lockBalanceStandard,
345         balance,
346         lockUser[_owner].startTime,
347         lockUser[_owner].endTime);
348     }
349     function lockBalanceAll(address _owner) public view returns (uint256) {
350         uint256 lockBalance = 0;
351         for(uint256 i = 0; i < lockUser[_owner].lockType.length; i++){
352             if(lockUser[_owner].lockType[i] == uint256(eLockType.Individual)) {
353                 lockBalance = lockBalance.add(lockBalanceIndividual(_owner, i));
354             } else if(lockUser[_owner].lockType[i] != uint256(eLockType.None)) {
355                 lockBalance = lockBalance.add(lockBalanceGroup(_owner, i));
356             }
357         }
358         return lockBalance;
359     }
360     
361 }
362 
363 contract LikerCoin is Token, LockBalance {
364 
365     function LikerCoin() public {
366         name = "LIKER";
367         symbol = "LK";
368         decimals = 18;
369         uint256 initialSupply = 3000000000;
370         totalSupply = initialSupply * 10 ** uint(decimals);
371         user[owner].balance = totalSupply;
372         Transfer(address(0), owner, totalSupply);
373 
374         //addLockDate(eLockType.GroupA, 9999999999, 100);//2286-11-21
375 
376     }
377 
378     function validTransfer(address _from, address _to, uint256 _value, bool _lockCheck) internal {
379         super.validTransfer(_from, _to, _value, _lockCheck);
380         if(_lockCheck) {
381             require(_value <= useBalanceOf(_from));
382         }
383     }
384 
385     function setLockUsers(eLockType _type, address[] _to, uint256[] _value, uint256[] _endTime) onlyOwner public {  
386         require(_to.length > 0);
387         require(_to.length == _value.length);
388         require(_to.length == _endTime.length);
389         require(_type != eLockType.None);
390         
391         for(uint256 i = 0; i < _to.length; i++){
392             require(_value[i] <= useBalanceOf(_to[i]));
393             setLockUser(_to[i], _type, _value[i], _endTime[i]);
394         }
395     }
396     
397     function useBalanceOf(address _owner) public view returns (uint256) {
398         return balanceOf(_owner).sub(lockBalanceAll(_owner));
399     }
400     
401 }