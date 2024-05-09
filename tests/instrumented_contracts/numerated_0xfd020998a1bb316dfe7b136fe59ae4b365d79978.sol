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
127 contract ERC20 {
128     function totalSupply() public view returns (uint256);
129     function balanceOf(address who) public view returns (uint256);
130     function allowance(address owner, address spender) public view returns (uint256);
131     function transfer(address to, uint256 value) public returns (bool);
132     function approve(address spender, uint256 value) public returns (bool);
133     function transferFrom(address from, address to, uint256 value) public returns (bool);
134 
135     event Approval(address indexed owner, address indexed spender, uint256 value);
136     event Transfer(address indexed from, address indexed to, uint256 value);
137 }
138 
139 contract Token is ERC20, Pausable {
140 
141     struct sUserInfo {
142         uint256 balance;
143         bool lock;
144         mapping(address => uint256) allowed;
145     }
146     
147     using SafeMath for uint256;
148 
149     string public name;
150     string public symbol;
151     uint8 public decimals;
152     uint256 public totalSupply;
153 
154   
155 
156     mapping(address => sUserInfo) user;
157 
158     event Mint(uint256 value);
159     event Burn(uint256 value);
160 
161    
162     
163     function () public payable {
164         revert();
165     }
166     
167     function validTransfer(address _from, address _to, uint256 _value, bool _lockCheck) internal view returns (bool) {
168         require(_to != address(this));
169         require(_to != address(0));
170         require(user[_from].balance >= _value);
171         if(_lockCheck) {
172             require(user[_from].lock == false);
173         }
174     }
175 
176     function lock(address _owner) public onlyManagers returns (bool) {
177         require(user[_owner].lock == false);
178        
179         user[_owner].lock = true;
180         return true;
181     }
182     function unlock(address _owner) public onlyManagers returns (bool) {
183         require(user[_owner].lock == true);
184         user[_owner].lock = false;
185        return true;
186     }
187  
188     function burn(uint256 _value) public onlyOwner returns (bool) {
189         require(_value <= user[msg.sender].balance);
190         user[msg.sender].balance = user[msg.sender].balance.sub(_value);
191         totalSupply = totalSupply.sub(_value);
192         emit Burn(_value);
193         return true;
194     }
195 
196     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
197         require(_value == 0 || user[msg.sender].allowed[_spender] == 0); 
198         user[msg.sender].allowed[_spender] = _value; 
199         emit Approval(msg.sender, _spender, _value);
200         return true;
201     }
202     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
203         validTransfer(_from, _to, _value, true);
204         require(_value <=  user[_from].allowed[msg.sender]);
205 
206         user[_from].balance = user[_from].balance.sub(_value);
207         user[_to].balance = user[_to].balance.add(_value);
208 
209         user[_from].allowed[msg.sender] = user[_from].allowed[msg.sender].sub(_value);
210         emit Transfer(_from, _to, _value);
211         return true;
212     }
213     
214     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
215         validTransfer(msg.sender, _to, _value, true);
216 
217         user[msg.sender].balance = user[msg.sender].balance.sub(_value);
218         user[_to].balance = user[_to].balance.add(_value);
219 
220         emit Transfer(msg.sender, _to, _value);
221         return true;
222     }
223 
224     
225     function totalSupply() public view returns (uint256) {
226         return totalSupply;
227     }
228     function balanceOf(address _owner) public view returns (uint256) {
229         return user[_owner].balance;
230     }
231     function lockState(address _owner) public view returns (bool) {
232         return user[_owner].lock;
233     }
234     function allowance(address _owner, address _spender) public view returns (uint256) {
235         return user[_owner].allowed[_spender];
236     }
237     
238 }
239 
240 contract LockBalance is Manager {
241     
242 
243     struct sLockInfo {
244         uint256[] lockBalanceStandard;
245         uint256[] endTime;
246     }
247     
248     using SafeMath for uint256;
249 
250     mapping(address => sLockInfo) lockUser;
251  
252     event Lock(address indexed from, uint256 value, uint256 endTime);
253     
254     function setLockUser(address _to, uint256 _value, uint256 _endTime) onlyManagers public {
255         require(_endTime > now); 
256         require(_value > 0); 
257         lockUser[_to].lockBalanceStandard.push(_value);
258         lockUser[_to].endTime.push(_endTime);
259 
260         emit Lock(_to, _value, _endTime);
261     }
262     function setLockUsers(address[] _to, uint256[] _value, uint256[] _endTime) onlyManagers public {  
263         
264         for(uint256 i = 0; i < _to.length; i++){
265             if(lockUser[_to[i]].endTime.length != 0) {
266                 lockUser[_to[i]].endTime.length = 0;    
267             }
268             if(lockUser[_to[i]].lockBalanceStandard.length != 0) {
269                 lockUser[_to[i]].lockBalanceStandard.length = 0;
270             }
271         }
272         addLockUsers(_to, _value, _endTime);
273     }
274     
275     function addLockUsers(address[] _to, uint256[] _value, uint256[] _endTime) onlyManagers public {  
276         require(_to.length > 0);
277         require(_to.length == _value.length);
278         require(_to.length == _endTime.length);
279       
280         for(uint256 i = 0; i < _to.length; i++){
281             setLockUser(_to[i], _value[i], _endTime[i]);
282         }
283     }
284     
285   
286     function lockBalanceIndividual(address _owner, uint _index) internal view returns (uint256) {
287         if(now < lockUser[_owner].endTime[_index]) {
288             return lockUser[_owner].lockBalanceStandard[_index];
289         } else {
290             return 0;
291         }
292     }
293     
294     function clearLockUserInfo(address _holder) onlyManagers public {
295         lockUser[_holder].endTime.length = 0;
296         lockUser[_holder].lockBalanceStandard.length = 0;
297     }
298     function deleteLockUserInfoIdx(address _holder, uint256 idx) onlyManagers public {
299         require(idx < lockUser[_holder].endTime.length);
300 
301         if (idx != lockUser[_holder].endTime.length - 1) {
302             lockUser[_holder].endTime[idx] = lockUser[_holder].endTime[lockUser[_holder].endTime.length - 1];
303             lockUser[_holder].lockBalanceStandard[idx] = lockUser[_holder].lockBalanceStandard[lockUser[_holder].lockBalanceStandard.length - 1];
304         }
305         lockUser[_holder].endTime.length--;
306         lockUser[_holder].lockBalanceStandard.length--;
307         
308     }
309     function _deleteLockUserInfo(address _to, uint256 _endTime) internal {
310 
311         bool isExists = false;
312         uint256 index = 0;
313         for(uint256 i = 0; i < lockUser[_to].endTime.length; i++) {
314             if(lockUser[_to].endTime[i] == _endTime) {
315                 isExists = true;
316                 index = i;
317                 break;
318             }
319         }
320         require(isExists);
321 
322         deleteLockUserInfoIdx(_to, index);
323     }
324     function deleteLockUserInfos(address _to, uint256[] _endTime) onlyManagers public {
325         for(uint256 i = 0; i < _endTime.length; i++){
326             _deleteLockUserInfo(_to, _endTime[i]);
327         }
328     }
329 
330     function lockUserInfo(address _owner, uint256 idx) public view returns (uint256, uint256) {
331         return (
332             lockUser[_owner].lockBalanceStandard[idx],
333         lockUser[_owner].endTime[idx]);
334     }
335     function lockUserInfo(address _owner) public view returns (uint256[], uint256[]) {
336         
337         return (
338         lockUser[_owner].lockBalanceStandard,
339         lockUser[_owner].endTime);
340     }
341     function lockBalanceAll(address _owner) public view returns (uint256) {
342         uint256 lockBalance = 0;
343         for(uint256 i = 0; i < lockUser[_owner].lockBalanceStandard.length; i++){
344             lockBalance = lockBalance.add(lockBalanceIndividual(_owner, i));
345         }
346         return lockBalance;
347     }
348     
349 }
350 
351 contract GDGToken is Token, LockBalance {
352 
353     constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 supply_) public {
354         name = name_;
355         symbol = symbol_;
356         decimals = decimals_;
357         uint256 initialSupply = supply_;
358         totalSupply = initialSupply * 10 ** uint(decimals);
359         user[owner].balance = totalSupply;
360         emit Transfer(address(0), owner, totalSupply);
361     }
362 
363     bool public finishMint = false; 
364     bool public finishRestore = false; 
365     
366     function isFinishMint() public onlyOwner { 
367         finishMint = true; 
368     }
369     function isFinishRestore() public onlyOwner { 
370         finishRestore = true; 
371     }     
372   
373     function validTransfer(address _from, address _to, uint256 _value, bool _lockCheck) internal view returns (bool) {
374         super.validTransfer(_from, _to, _value, _lockCheck);
375         if(_lockCheck) {
376             require(_value <= useBalanceOf(_from));
377         }
378     }
379 
380     function transferWithtLockUser(address _to, uint256 _amount, uint256[] _lockAmount, uint256[] _endTime) onlyManagers public {  
381         require(_lockAmount.length > 0);
382         require(_lockAmount.length == _endTime.length);
383         
384         transfer(_to, _amount);
385         
386         for(uint256 i = 0; i < _lockAmount.length; i++){
387             setLockUser(_to, _lockAmount[i], _endTime[i]);
388         }
389         
390     }
391  
392     function mint(uint256 _value) public onlyOwner returns (bool) {
393         require(!finishMint);
394         require(_value > 0);
395         user[msg.sender].balance = user[msg.sender].balance.add(_value);
396         totalSupply = totalSupply.add(_value);
397         emit Transfer(address(0), msg.sender, _value);
398         return true;
399     }
400  
401     function transferRestore(address _from, address _to, uint256 _value) public onlyOwner returns (bool) {
402         require(!finishRestore);
403 
404         require(_to != address(this));
405         require(_to != address(0));
406         require(user[_from].balance >= _value);
407         
408         user[_from].balance = user[_from].balance.sub(_value);
409         user[_to].balance = user[_to].balance.add(_value);
410 
411         emit Transfer(_from, _to, _value);
412         return true;
413     }
414     function useBalanceOf(address _owner) public view returns (uint256) {
415         return balanceOf(_owner).sub(lockBalanceAll(_owner));
416     }
417   
418 
419 }