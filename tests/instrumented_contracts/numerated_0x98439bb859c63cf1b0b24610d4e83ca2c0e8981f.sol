1 pragma solidity ^0.5.4;
2 ///////////////////////////////////////////////
3 ////////Safe Life Tame simonKim//////////////
4 ///////////////////////////////////////////////
5 
6 interface IERC20 {
7     function transfer(address to, uint256 value) external returns (bool);
8 
9     function approve(address spender, uint256 value) external returns (bool);
10 
11     function transferFrom(address from, address to, uint256 value) external returns (bool);
12 
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address who) external view returns (uint256);
16 
17     function allowance(address owner, address spender) external view returns (uint256);
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 
25 library SafeMath {
26 
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
29         // benefit is lost if 'b' is also tested.
30         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b);
37 
38         return c;
39     }
40 
41 
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // Solidity only automatically asserts when dividing by 0
44         require(b > 0);
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 
48         return c;
49     }
50 
51 
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         require(b <= a);
54         uint256 c = a - b;
55 
56         return c;
57     }
58 
59 
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a);
63 
64         return c;
65     }
66 
67 
68     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b != 0);
70         return a % b;
71     }
72 }
73 
74 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
75 
76 
77 contract ERC20 is IERC20 {
78     using SafeMath for uint256;
79 
80     mapping (address => uint256) internal _balances;
81 
82     mapping (address => mapping (address => uint256)) private _allowed;
83 
84     uint256 private _totalSupply;
85 
86 
87     function totalSupply() public view returns (uint256) {
88         return _totalSupply;
89     }
90 
91 
92     function balanceOf(address owner) public view returns (uint256) {
93         return _balances[owner];
94     }
95 
96 
97     function allowance(address owner, address spender) public view returns (uint256) {
98         return _allowed[owner][spender];
99     }
100 
101 
102     function transfer(address to, uint256 value) public returns (bool) {
103         _transfer(msg.sender, to, value);
104         return true;
105     }
106 
107 
108     function approve(address spender, uint256 value) public returns (bool) {
109         require(spender != address(0));
110 
111         _allowed[msg.sender][spender] = value;
112         emit Approval(msg.sender, spender, value);
113         return true;
114     }
115 
116 
117     function transferFrom(address from, address to, uint256 value) public returns (bool) {
118         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
119         _transfer(from, to, value);
120         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
121         return true;
122     }
123 
124 
125     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
126         require(spender != address(0));
127 
128         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
129         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
130         return true;
131     }
132 
133 
134     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
135         require(spender != address(0));
136 
137         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
138         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
139         return true;
140     }
141 
142 
143     function _transfer(address from, address to, uint256 value) internal {
144         require(to != address(0));
145 
146         _balances[from] = _balances[from].sub(value);
147         _balances[to] = _balances[to].add(value);
148         emit Transfer(from, to, value);
149     }
150 
151 
152     function _mint(address account, uint256 value) internal {
153         require(account != address(0));
154 
155         _totalSupply = _totalSupply.add(value);
156         _balances[account] = _balances[account].add(value);
157         emit Transfer(address(0), account, value);
158     }
159 
160 
161     function _burn(address account, uint256 value) internal {
162         require(account != address(0));
163 
164         _totalSupply = _totalSupply.sub(value);
165         _balances[account] = _balances[account].sub(value);
166         emit Transfer(account, address(0), value);
167     }
168 
169 
170     function _burnFrom(address account, uint256 value) internal {
171         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
172         _burn(account, value);
173         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
174     }
175 }
176 
177 // File: contracts\mine.sol
178 
179 contract SafeLife is ERC20 {
180     string public constant name = "SafeLife"; // solium-disable-line uppercase
181     string public constant symbol = "SAFE"; // solium-disable-line uppercase
182     uint8 public constant decimals = 18; // solium-disable-line uppercase
183     uint256 public constant initialSupply = 500000000  * (10 ** uint256(decimals));
184 
185     constructor() public {
186         super._mint(msg.sender, initialSupply);
187         owner = msg.sender;
188     }
189 
190     //ownership
191     address public owner;
192 
193     event OwnershipRenounced(address indexed previousOwner);
194     event OwnershipTransferred(
195     address indexed previousOwner,
196     address indexed newOwner
197     );
198 
199     modifier onlyOwner() {
200         require(msg.sender == owner, "Not owner");
201         _;
202     }
203 
204 
205     function renounceOwnership() public onlyOwner {
206         emit OwnershipRenounced(owner);
207         owner = address(0);
208     }
209 
210 
211     function transferOwnership(address _newOwner) public onlyOwner {
212         _transferOwnership(_newOwner);
213     }
214 
215 
216     function _transferOwnership(address _newOwner) internal {
217         require(_newOwner != address(0), "Already owner");
218         emit OwnershipTransferred(owner, _newOwner);
219         owner = _newOwner;
220     }
221 
222     //pausable
223     event Pause();
224     event Unpause();
225 
226     bool public paused = false;
227 
228 
229     modifier whenNotPaused() {
230         require(!paused, "Paused by owner");
231         _;
232     }
233 
234 
235     modifier whenPaused() {
236         require(paused, "Not paused now");
237         _;
238     }
239 
240 
241     function pause() public onlyOwner whenNotPaused {
242         paused = true;
243         emit Pause();
244     }
245 
246 
247     function unpause() public onlyOwner whenPaused {
248         paused = false;
249         emit Unpause();
250     }
251 
252     //freezable
253     event Frozen(address target);
254     event Unfrozen(address target);
255 
256     mapping(address => bool) internal freezes;
257 
258     modifier whenNotFrozen() {
259         require(!freezes[msg.sender], "Sender account is locked.");
260         _;
261     }
262 
263     function freeze(address _target) public onlyOwner {
264         freezes[_target] = true;
265         emit Frozen(_target);
266     }
267 
268     function unfreeze(address _target) public onlyOwner {
269         freezes[_target] = false;
270         emit Unfrozen(_target);
271     }
272 
273     function isFrozen(address _target) public view returns (bool) {
274         return freezes[_target];
275     }
276 
277     function transfer(
278         address _to,
279         uint256 _value
280     )
281       public
282       whenNotFrozen
283       whenNotPaused
284       returns (bool)
285     {
286         releaseLock(msg.sender);
287         return super.transfer(_to, _value);
288     }
289 
290     function transferFrom(
291         address _from,
292         address _to,
293         uint256 _value
294     )
295       public
296       whenNotPaused
297       returns (bool)
298     {
299         require(!freezes[_from], "From account is locked.");
300         releaseLock(_from);
301         return super.transferFrom(_from, _to, _value);
302     }
303 
304     //mintable
305     event Mint(address indexed to, uint256 amount);
306 
307     function mint(
308         address _to,
309         uint256 _amount
310     )
311       public
312       onlyOwner
313       returns (bool)
314     {
315         super._mint(_to, _amount);
316         emit Mint(_to, _amount);
317         return true;
318     }
319 
320     //burnable
321     event Burn(address indexed burner, uint256 value);
322 
323     function burn(address _who, uint256 _value) public onlyOwner {
324         require(_value <= super.balanceOf(_who), "Balance is too small.");
325 
326         _burn(_who, _value);
327         emit Burn(_who, _value);
328     }
329 
330     //lockable
331     struct LockInfo {
332         uint256 releaseTime;
333         uint256 balance;
334     }
335     mapping(address => LockInfo[]) internal lockInfo;
336 
337     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
338     event Unlock(address indexed holder, uint256 value);
339 
340     function balanceOf(address _holder) public view returns (uint256 balance) {
341         uint256 lockedBalance = 0;
342         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
343             lockedBalance = lockedBalance.add(lockInfo[_holder][i].balance);
344         }
345         return super.balanceOf(_holder).add(lockedBalance);
346     }
347 
348     function releaseLock(address _holder) internal {
349 
350         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
351             if (lockInfo[_holder][i].releaseTime <= now) {
352                 _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
353                 emit Unlock(_holder, lockInfo[_holder][i].balance);
354                 lockInfo[_holder][i].balance = 0;
355 
356                 if (i != lockInfo[_holder].length - 1) {
357                     lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
358                     i--;
359                 }
360                 lockInfo[_holder].length--;
361 
362             }
363         }
364     }
365     function lockCount(address _holder) public view returns (uint256) {
366         return lockInfo[_holder].length;
367     }
368     function lockState(address _holder, uint256 _idx) public view returns (uint256, uint256) {
369         return (lockInfo[_holder][_idx].releaseTime, lockInfo[_holder][_idx].balance);
370     }
371 
372     function lock(address _holder, uint256 _amount, uint256 _releaseTime) public onlyOwner {
373         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
374         _balances[_holder] = _balances[_holder].sub(_amount);
375         lockInfo[_holder].push(
376             LockInfo(_releaseTime, _amount)
377         );
378         emit Lock(_holder, _amount, _releaseTime);
379     }
380 
381     function lockAfter(address _holder, uint256 _amount, uint256 _afterTime) public onlyOwner {
382         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
383         _balances[_holder] = _balances[_holder].sub(_amount);
384         lockInfo[_holder].push(
385             LockInfo(now + _afterTime, _amount)
386         );
387         emit Lock(_holder, _amount, now + _afterTime);
388     }
389 
390     function unlock(address _holder, uint256 i) public onlyOwner {
391         require(i < lockInfo[_holder].length, "No lock information.");
392 
393         _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
394         emit Unlock(_holder, lockInfo[_holder][i].balance);
395         lockInfo[_holder][i].balance = 0;
396 
397         if (i != lockInfo[_holder].length - 1) {
398             lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
399         }
400         lockInfo[_holder].length--;
401     }
402 
403     function transferWithLock(address _to, uint256 _value, uint256 _releaseTime) public onlyOwner returns (bool) {
404         require(_to != address(0), "wrong address");
405         require(_value <= super.balanceOf(owner), "Not enough balance");
406 
407         _balances[owner] = _balances[owner].sub(_value);
408         lockInfo[_to].push(
409             LockInfo(_releaseTime, _value)
410         );
411         emit Transfer(owner, _to, _value);
412         emit Lock(_to, _value, _releaseTime);
413 
414         return true;
415     }
416 
417     function transferWithLockAfter(address _to, uint256 _value, uint256 _afterTime) public onlyOwner returns (bool) {
418         require(_to != address(0), "wrong address");
419         require(_value <= super.balanceOf(owner), "Not enough balance");
420 
421         _balances[owner] = _balances[owner].sub(_value);
422         lockInfo[_to].push(
423             LockInfo(now + _afterTime, _value)
424         );
425         emit Transfer(owner, _to, _value);
426         emit Lock(_to, _value, now + _afterTime);
427 
428         return true;
429     }
430 
431     function currentTime() public view returns (uint256) {
432         return now;
433     }
434 
435     function afterTime(uint256 _value) public view returns (uint256) {
436         return now + _value;
437     }
438 }