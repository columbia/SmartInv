1 // pragma solidity ^0.5.2;
2 pragma solidity ^0.4.24;
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 
28 contract Ownable {
29     address public owner;
30 
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32     
33     constructor() public {
34         owner = msg.sender;
35     }
36     modifier onlyOwner() {
37         require(msg.sender == owner);
38         _;
39     }
40     function transferOwnership(address newOwner) public onlyOwner {
41         require(newOwner != address(0));
42         emit OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 
46 }
47 
48 contract Pausable is Ownable {
49     event Pause();
50     event Unpause();
51 
52     bool public paused = false;
53 
54     modifier whenNotPaused() {
55         require(!paused);
56         _;
57     }
58 
59     modifier whenPaused() {
60         require(paused);
61         _;
62     }
63 
64     function pause() onlyOwner whenNotPaused public {
65         paused = true;
66         emit Pause();
67     }
68 
69     function unpause() onlyOwner whenPaused public {
70         paused = false;
71         emit Unpause();
72     }
73 }
74 
75 contract ERC20 {
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
114     function () external payable {
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
142         emit Burn(_value);
143         return true;
144     }
145    
146     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
147         validTransfer(msg.sender, _to, _value, false);
148        
149         user[msg.sender].balance = user[msg.sender].balance.sub(_value);
150         user[_to].balance = user[_to].balance.add(_value);
151        
152         emit Transfer(msg.sender, _to, _value);
153         return true;
154     }
155 
156     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
157         require(_value > 0);
158         user[msg.sender].allowed[_spender] = _value; 
159         emit Approval(msg.sender, _spender, _value);
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
170         emit Transfer(_from, _to, _value);
171         return true;
172     }
173     
174     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
175         validTransfer(msg.sender, _to, _value, true);
176 
177         user[msg.sender].balance = user[msg.sender].balance.sub(_value);
178         user[_to].balance = user[_to].balance.add(_value);
179 
180         emit Transfer(msg.sender, _to, _value);
181         return true;
182     }
183     
184     function transferRestore(address _from, address _to, uint256 _value) public onlyOwner canRestore returns (bool) {
185         validTransfer(_from, _to, _value, false);
186        
187         user[_from].balance = user[_from].balance.sub(_value);
188         user[_to].balance = user[_to].balance.add(_value);
189        
190         emit Transfer(_from, _to, _value);
191         return true;
192     }
193     
194     function finishRestore() public onlyOwner returns (bool) {
195         restoreFinished = true;
196         emit RestoreFinished();
197         return true;
198     }
199     
200     
201     function balanceOf(address _owner) public view returns (uint256) {
202         return user[_owner].balance;
203     }
204     function lockState(address _owner) public view returns (bool) {
205         return user[_owner].lock;
206     }
207     function allowance(address _owner, address _spender) public view returns (uint256) {
208         return user[_owner].allowed[_spender];
209     }
210     
211 }
212 
213 contract LockBalance is Ownable {
214     
215     enum eLockType {None, Individual, GroupA, GroupB, GroupC, GroupD, GroupE, GroupF, GroupG, GroupH, GroupI, GroupJ}
216     struct sGroupLockDate {
217         uint256[] lockTime;
218         uint256[] lockPercent;
219     }
220     struct sLockInfo {
221         uint256[] lockType;
222         uint256[] lockBalanceStandard;
223         uint256[] startTime;
224         uint256[] endTime;
225     }
226     
227     using SafeMath for uint256;
228 
229     mapping(uint => sGroupLockDate) groupLockDate;
230     
231     mapping(address => sLockInfo) lockUser;
232 
233     event Lock(address indexed from, uint256 value, uint256 endTime);
234     
235     function setLockUser(address _to, eLockType _lockType, uint256 _value, uint256 _endTime) internal {
236         lockUser[_to].lockType.push(uint256(_lockType));
237         lockUser[_to].lockBalanceStandard.push(_value);
238         lockUser[_to].startTime.push(now);
239         lockUser[_to].endTime.push(_endTime);
240 
241         emit Lock(_to, _value, _endTime);
242     }
243 
244     function lockBalanceGroup(address _owner, uint _index) internal view returns (uint256) {
245         uint256 percent = 0;
246         uint256 key = uint256(lockUser[_owner].lockType[_index]);
247 
248         uint256 time = 99999999999;
249         for(uint256 i = 0 ; i < groupLockDate[key].lockTime.length; i++) {
250             if(now < groupLockDate[key].lockTime[i]) {
251                 if(groupLockDate[key].lockTime[i] < time) {
252                     time = groupLockDate[key].lockTime[i];
253                     percent = groupLockDate[key].lockPercent[i];    
254                 }
255             }
256         }
257         
258         if(percent == 0){
259             return 0;
260         } else {
261             return lockUser[_owner].lockBalanceStandard[_index].mul(uint256(percent)).div(100);
262         }
263     }
264 
265     function lockBalanceIndividual(address _owner, uint _index) internal view returns (uint256) {
266         if(now < lockUser[_owner].endTime[_index]) {
267             return lockUser[_owner].lockBalanceStandard[_index];
268         } else {
269             return 0;
270         }
271     }
272     
273     function clearLockUser(address _owner, uint _index) onlyOwner public {
274         require(lockUser[_owner].endTime.length >_index);
275         lockUser[_owner].endTime[_index] = 0;
276     }
277         
278     function addLockDate(eLockType _lockType, uint256 _second, uint256 _percent) onlyOwner public {
279         require(_percent > 0 && _percent <= 100);
280         sGroupLockDate storage lockInfo = groupLockDate[uint256(_lockType)];
281         bool isExists = false;
282         for(uint256 i = 0; i < lockInfo.lockTime.length; i++) {
283             if(lockInfo.lockTime[i] == _second) {
284                 revert();
285                 break;
286             }
287         }
288         
289         if(isExists) {
290            revert();
291         } else {
292             lockInfo.lockTime.push(_second);
293             lockInfo.lockPercent.push(_percent);
294         }
295     }
296     
297     function deleteLockDate(eLockType _lockType, uint256 _lockTime) onlyOwner public {
298         sGroupLockDate storage lockDate = groupLockDate[uint256(_lockType)];
299         
300         bool isExists = false;
301         uint256 index = 0;
302         for(uint256 i = 0; i < lockDate.lockTime.length; i++) {
303             if(lockDate.lockTime[i] == _lockTime) {
304                 isExists = true;
305                 index = i;
306                 break;
307             }
308         }
309         
310         if(isExists) {
311             for(uint256 k = index; k < lockDate.lockTime.length - 1; k++){
312                 lockDate.lockTime[k] = lockDate.lockTime[k + 1];
313                 lockDate.lockPercent[k] = lockDate.lockPercent[k + 1];
314             }
315             delete lockDate.lockTime[lockDate.lockTime.length - 1];
316             lockDate.lockTime.length--;
317             delete lockDate.lockPercent[lockDate.lockPercent.length - 1];
318             lockDate.lockPercent.length--;
319         } else {
320             revert();
321         }
322         
323     }
324 
325 
326     function lockTypeInfoGroup(eLockType _type) public view returns (uint256[] memory , uint256[] memory ) {
327         uint256 key = uint256(_type);
328         return (groupLockDate[key].lockTime, groupLockDate[key].lockPercent);
329     }
330     function lockUserInfo(address _owner) public view returns (uint256[] memory , uint256[] memory , uint256[] memory , uint256[] memory , uint256[] memory ) {
331         
332         uint256[] memory balance = new uint256[](lockUser[_owner].lockType.length);
333         for(uint256 i = 0; i < lockUser[_owner].lockType.length; i++){
334             if(lockUser[_owner].lockType[i] == uint256(eLockType.Individual)) {
335                 balance[i] = balance[i].add(lockBalanceIndividual(_owner, i));
336             } else if(lockUser[_owner].lockType[i] != uint256(eLockType.None)) {
337                 balance[i] = balance[i].add(lockBalanceGroup(_owner, i));
338             }
339         }
340         
341         return (lockUser[_owner].lockType,
342         lockUser[_owner].lockBalanceStandard,
343         balance,
344         lockUser[_owner].startTime,
345         lockUser[_owner].endTime);
346     }
347     function lockBalanceAll(address _owner) public view returns (uint256) {
348         uint256 lockBalance = 0;
349         for(uint256 i = 0; i < lockUser[_owner].lockType.length; i++){
350             if(lockUser[_owner].lockType[i] == uint256(eLockType.Individual)) {
351                 lockBalance = lockBalance.add(lockBalanceIndividual(_owner, i));
352             } else if(lockUser[_owner].lockType[i] != uint256(eLockType.None)) {
353                 lockBalance = lockBalance.add(lockBalanceGroup(_owner, i));
354             }
355         }
356         return lockBalance;
357     }
358     
359 }
360 
361 contract FabotCoin is Token, LockBalance {
362 
363     constructor() public {
364         name = "FABOT";
365         symbol = "FC";
366         decimals = 18;
367         uint256 initialSupply = 4000000000;
368         totalSupply = initialSupply * 10 ** uint(decimals);
369         user[owner].balance = totalSupply;
370         emit Transfer(address(0), owner, totalSupply);
371     }
372 
373     function validTransfer(address _from, address _to, uint256 _value, bool _lockCheck) internal {
374         super.validTransfer(_from, _to, _value, _lockCheck);
375         if(_lockCheck) {
376             require(_value <= useBalanceOf(_from));
377         }
378     }
379 
380     function setLockUsers(eLockType _type, address[] memory _to, uint256[] memory _value, uint256[] memory  _endTime) onlyOwner public {  
381         require(_to.length > 0);
382         require(_to.length == _value.length);
383         require(_to.length == _endTime.length);
384         require(_type != eLockType.None);
385         
386         for(uint256 i = 0; i < _to.length; i++){
387             require(_value[i] <= useBalanceOf(_to[i]));
388             setLockUser(_to[i], _type, _value[i], _endTime[i]);
389         }
390     }
391     
392     function useBalanceOf(address _owner) public view returns (uint256) {
393         return balanceOf(_owner).sub(lockBalanceAll(_owner));
394     }
395     
396 }