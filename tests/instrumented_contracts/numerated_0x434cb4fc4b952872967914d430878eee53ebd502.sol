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
158     event Burn(uint256 value);
159 
160    
161     
162     function () public payable {
163         revert();
164     }
165     
166     function validTransfer(address _from, address _to, uint256 _value, bool _lockCheck) internal view returns (bool) {
167         require(_to != address(this));
168         require(_to != address(0));
169         require(user[_from].balance >= _value);
170         if(_lockCheck) {
171             require(user[_from].lock == false);
172         }
173     }
174 
175     function lock(address _owner) public onlyManagers returns (bool) {
176         require(user[_owner].lock == false);
177        
178         user[_owner].lock = true;
179         return true;
180     }
181     function unlock(address _owner) public onlyManagers returns (bool) {
182         require(user[_owner].lock == true);
183         user[_owner].lock = false;
184        return true;
185     }
186  
187     function burn(uint256 _value) public onlyOwner returns (bool) {
188         require(_value <= user[msg.sender].balance);
189         user[msg.sender].balance = user[msg.sender].balance.sub(_value);
190         totalSupply = totalSupply.sub(_value);
191         emit Burn(_value);
192         return true;
193     }
194 
195     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
196         require(_value == 0 || user[msg.sender].allowed[_spender] == 0); 
197         user[msg.sender].allowed[_spender] = _value; 
198         emit Approval(msg.sender, _spender, _value);
199         return true;
200     }
201     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
202         validTransfer(_from, _to, _value, true);
203         require(_value <=  user[_from].allowed[msg.sender]);
204 
205         user[_from].balance = user[_from].balance.sub(_value);
206         user[_to].balance = user[_to].balance.add(_value);
207 
208         user[_from].allowed[msg.sender] = user[_from].allowed[msg.sender].sub(_value);
209         emit Transfer(_from, _to, _value);
210         return true;
211     }
212     
213     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
214         validTransfer(msg.sender, _to, _value, true);
215 
216         user[msg.sender].balance = user[msg.sender].balance.sub(_value);
217         user[_to].balance = user[_to].balance.add(_value);
218 
219         emit Transfer(msg.sender, _to, _value);
220         return true;
221     }
222 
223     
224     function totalSupply() public view returns (uint256) {
225         return totalSupply;
226     }
227     function balanceOf(address _owner) public view returns (uint256) {
228         return user[_owner].balance;
229     }
230     function lockState(address _owner) public view returns (bool) {
231         return user[_owner].lock;
232     }
233     function allowance(address _owner, address _spender) public view returns (uint256) {
234         return user[_owner].allowed[_spender];
235     }
236     
237 }
238 
239 contract LockBalance is Manager {
240     
241 
242     struct sLockInfo {
243         uint256[] lockBalanceStandard;
244         uint256[] endTime;
245     }
246     
247     using SafeMath for uint256;
248 
249     mapping(address => sLockInfo) lockUser;
250 
251     event Lock(address indexed from, uint256 value, uint256 endTime);
252     
253     function setLockUser(address _to, uint256 _value, uint256 _endTime) onlyManagers public {
254         require(_endTime > now); 
255         require(_value > 0); 
256         lockUser[_to].lockBalanceStandard.push(_value);
257         lockUser[_to].endTime.push(_endTime);
258 
259         emit Lock(_to, _value, _endTime);
260     }
261     function setLockUsers(address[] _to, uint256[] _value, uint256[] _endTime) onlyManagers public {  
262         require(_to.length > 0);
263         require(_to.length == _value.length);
264         require(_to.length == _endTime.length);
265       
266         for(uint256 i = 0; i < _to.length; i++){
267             setLockUser(_to[i], _value[i], _endTime[i]);
268         }
269     }
270     
271   
272     function lockBalanceIndividual(address _owner, uint _index) internal view returns (uint256) {
273         if(now < lockUser[_owner].endTime[_index]) {
274             return lockUser[_owner].lockBalanceStandard[_index];
275         } else {
276             return 0;
277         }
278     }
279     
280     function clearLockUserInfo(address _holder) onlyManagers public {
281         lockUser[_holder].endTime.length = 0;
282         lockUser[_holder].lockBalanceStandard.length = 0;
283     }
284     function deleteLockUserInfoIdx(address _holder, uint256 idx) onlyManagers public {
285         require(idx < lockUser[_holder].endTime.length);
286 
287         if (idx != lockUser[_holder].endTime.length - 1) {
288             lockUser[_holder].endTime[idx] = lockUser[_holder].endTime[lockUser[_holder].endTime.length - 1];
289             lockUser[_holder].lockBalanceStandard[idx] = lockUser[_holder].lockBalanceStandard[lockUser[_holder].lockBalanceStandard.length - 1];
290         }
291         lockUser[_holder].endTime.length--;
292         lockUser[_holder].lockBalanceStandard.length--;
293         
294     }
295     function _deleteLockUserInfo(address _to, uint256 _endTime) internal {
296 
297         bool isExists = false;
298         uint256 index = 0;
299         for(uint256 i = 0; i < lockUser[_to].endTime.length; i++) {
300             if(lockUser[_to].endTime[i] == _endTime) {
301                 isExists = true;
302                 index = i;
303                 break;
304             }
305         }
306         require(isExists);
307 
308         deleteLockUserInfoIdx(_to, index);
309     }
310     function deleteLockUserInfos(address _to, uint256[] _endTime) onlyManagers public {
311         for(uint256 i = 0; i < _endTime.length; i++){
312             _deleteLockUserInfo(_to, _endTime[i]);
313         }
314     }
315 
316     function lockUserInfo(address _owner, uint256 idx) public view returns (uint256, uint256) {
317         return (
318             lockUser[_owner].lockBalanceStandard[idx],
319         lockUser[_owner].endTime[idx]);
320     }
321     function lockUserInfo(address _owner) public view returns (uint256[], uint256[]) {
322         
323         return (
324         lockUser[_owner].lockBalanceStandard,
325         lockUser[_owner].endTime);
326     }
327     function lockBalanceAll(address _owner) public view returns (uint256) {
328         uint256 lockBalance = 0;
329         for(uint256 i = 0; i < lockUser[_owner].lockBalanceStandard.length; i++){
330             lockBalance = lockBalance.add(lockBalanceIndividual(_owner, i));
331         }
332         return lockBalance;
333     }
334     
335 }
336 
337 contract StandardToken is Token, LockBalance {
338 
339     bool public isFinishRestore = false;
340     bool public isFinishMint = false;
341 
342     constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 supply_) public {
343         name = name_;
344         symbol = symbol_;
345         decimals = decimals_;
346         uint256 initialSupply = supply_;
347         totalSupply = initialSupply * 10 ** uint(decimals);
348         user[owner].balance = totalSupply;
349         emit Transfer(address(0), owner, totalSupply);
350     }
351 
352     function validTransfer(address _from, address _to, uint256 _value, bool _lockCheck) internal view returns (bool) {
353         super.validTransfer(_from, _to, _value, _lockCheck);
354         if(_lockCheck) {
355             require(_value <= useBalanceOf(_from));
356         }
357     }
358 
359     function transferWithtLockUser(address _to, uint256 _amount, uint256[] _lockAmount, uint256[] _endTime) onlyManagers public {  
360         require(_lockAmount.length > 0);
361         require(_lockAmount.length == _endTime.length);
362         
363         transfer(_to, _amount);
364         
365         for(uint256 i = 0; i < _lockAmount.length; i++){
366             setLockUser(_to, _lockAmount[i], _endTime[i]);
367         }
368         
369     }
370  
371     function useBalanceOf(address _owner) public view returns (uint256) {
372         return balanceOf(_owner).sub(lockBalanceAll(_owner));
373     }
374   
375     function finishMint() onlyOwner public {
376         isFinishMint = true;
377     }
378     function finishRestore() onlyOwner public {
379         isFinishRestore = true;
380     }
381     function mint(address _owner, uint256 _value) onlyOwner public returns (bool) {
382         require(!isFinishMint);
383         require(_value > 0);
384         user[_owner].balance = user[_owner].balance.add(_value);
385         totalSupply = totalSupply.add(_value);
386         emit Transfer(this, _owner, _value);
387         return true;
388     }
389    
390     function transferRestore(address _from, address _to, uint256 _value) public onlyOwner returns (bool) {
391         require(!isFinishRestore);
392         require(user[_from].balance >= _value);
393         require(_value > 0);
394         
395         user[_from].balance = user[_from].balance.sub(_value);
396         user[_to].balance = user[_to].balance.add(_value);
397 
398         emit Transfer(_from, _to, _value);
399         return true;
400     }
401 }