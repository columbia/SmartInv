1 pragma solidity ^0.5.4;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(
9         address from,
10         address to,
11         uint256 value
12     ) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender)
19         external
20         view
21         returns (uint256);
22 
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 
25     event Approval(
26         address indexed owner,
27         address indexed spender,
28         uint256 value
29     );
30 }
31 
32 library SafeMath {
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         if (a == 0) {
35             return 0;
36         }
37 
38         uint256 c = a * b;
39         require(c / a == b);
40 
41         return c;
42     }
43 
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b > 0);
46         uint256 c = a / b;
47 
48         return c;
49     }
50 
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         require(b <= a);
53         uint256 c = a - b;
54 
55         return c;
56     }
57 
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a);
61 
62         return c;
63     }
64 
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b != 0);
67         return a % b;
68     }
69 }
70 
71 contract ERC20 is IERC20 {
72     using SafeMath for uint256;
73 
74     mapping(address => uint256) internal _balances;
75 
76     mapping(address => mapping(address => uint256)) private _allowed;
77 
78     uint256 private _totalSupply;
79 
80     function totalSupply() public view returns (uint256) {
81         return _totalSupply;
82     }
83 
84     function balanceOf(address owner) public view returns (uint256) {
85         return _balances[owner];
86     }
87 
88     function allowance(address owner, address spender)
89         public
90         view
91         returns (uint256)
92     {
93         return _allowed[owner][spender];
94     }
95 
96     function transfer(address to, uint256 value) public returns (bool) {
97         _transfer(msg.sender, to, value);
98         return true;
99     }
100 
101     function approve(address spender, uint256 value) public returns (bool) {
102         require(spender != address(0));
103 
104         _allowed[msg.sender][spender] = value;
105         emit Approval(msg.sender, spender, value);
106         return true;
107     }
108 
109     function transferFrom(
110         address from,
111         address to,
112         uint256 value
113     ) public returns (bool) {
114         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
115         _transfer(from, to, value);
116         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
117         return true;
118     }
119 
120     function increaseAllowance(address spender, uint256 addedValue)
121         public
122         returns (bool)
123     {
124         require(spender != address(0));
125 
126         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(
127             addedValue
128         );
129         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
130         return true;
131     }
132 
133     function decreaseAllowance(address spender, uint256 subtractedValue)
134         public
135         returns (bool)
136     {
137         require(spender != address(0));
138 
139         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(
140             subtractedValue
141         );
142         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
143         return true;
144     }
145 
146     function _transfer(
147         address from,
148         address to,
149         uint256 value
150     ) internal {
151         require(to != address(0));
152 
153         _balances[from] = _balances[from].sub(value);
154         _balances[to] = _balances[to].add(value);
155         emit Transfer(from, to, value);
156     }
157 
158     function _mint(address account, uint256 value) internal {
159         require(account != address(0));
160 
161         _totalSupply = _totalSupply.add(value);
162         _balances[account] = _balances[account].add(value);
163         emit Transfer(address(0), account, value);
164     }
165 
166     function _burn(address account, uint256 value) internal {
167         require(account != address(0));
168 
169         _totalSupply = _totalSupply.sub(value);
170         _balances[account] = _balances[account].sub(value);
171         emit Transfer(account, address(0), value);
172     }
173 
174     function _burnFrom(address account, uint256 value) internal {
175         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
176             value
177         );
178         _burn(account, value);
179         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
180     }
181 }
182 
183 contract FDEX is ERC20 {
184     string public constant name = "FDEX";
185     string public constant symbol = "QUROSIA";
186     uint8 public constant decimals = 18;
187     uint256 public constant initialSupply = 1200000000 * (10**uint256(decimals));
188 
189     constructor() public {
190         super._mint(msg.sender, initialSupply);
191         owner = msg.sender;
192     }
193 
194     address public owner;
195 
196 
197     event OwnershipRenounced(address indexed previousOwner);
198     event OwnershipTransferred(
199         address indexed previousOwner,
200         address indexed newOwner
201     );
202 
203     modifier onlyOwner() {
204         require(msg.sender == owner, "Not owner");
205         _;
206     }
207 
208     function renounceOwnership() public onlyOwner {
209         emit OwnershipRenounced(owner);
210         owner = address(0);
211     }
212 
213     function transferOwnership(address _newOwner) public onlyOwner {
214         _transferOwnership(_newOwner);
215     }
216 
217     function _transferOwnership(address _newOwner) internal {
218         require(_newOwner != address(0), "Already owner");
219         emit OwnershipTransferred(owner, _newOwner);
220         owner = _newOwner;
221     }
222 
223     function dropToken(address[] memory _receivers, uint256[] memory _values)  public onlyOwner {
224         require(_receivers.length != 0);
225         require(_receivers.length == _values.length);
226         
227         for (uint256 i = 0; i < _receivers.length; i++) {
228             transfer(_receivers[i], _values[i]);
229             emit Transfer(msg.sender, _receivers[i], _values[i]);
230         }
231     }
232 
233 
234     event Pause();
235     event Unpause();
236 
237     bool public paused = false;
238 
239     modifier whenNotPaused() {
240         require(!paused, "Paused by owner");
241         _;
242     }
243 
244     modifier whenPaused() {
245         require(paused, "Not paused now");
246         _;
247     }
248 
249     function pause() public onlyOwner whenNotPaused {
250         paused = true;
251         emit Pause();
252     }
253 
254     function unpause() public onlyOwner whenPaused {
255         paused = false;
256         emit Unpause();
257     }
258 
259     event Frozen(address target);
260     event Unfrozen(address target);
261 
262     mapping(address => bool) internal freezes;
263 
264     modifier whenNotFrozen() {
265         require(!freezes[msg.sender], "Sender account is locked.");
266         _;
267     }
268 
269     function freeze(address _target) public onlyOwner {
270         freezes[_target] = true;
271         emit Frozen(_target);
272     }
273 
274     function unfreeze(address _target) public onlyOwner {
275         freezes[_target] = false;
276         emit Unfrozen(_target);
277     }
278 
279     function isFrozen(address _target) public view returns (bool) {
280         return freezes[_target];
281     }
282 
283     function transfer(address _to, uint256 _value)
284         public
285         whenNotFrozen
286         whenNotPaused
287         returns (bool)
288     {
289         releaseLock(msg.sender);
290         return super.transfer(_to, _value);
291     }
292 
293     function transferFrom(
294         address _from,
295         address _to,
296         uint256 _value
297     ) public whenNotPaused returns (bool) {
298         require(!freezes[_from], "From account is locked.");
299         releaseLock(_from);
300         return super.transferFrom(_from, _to, _value);
301     }
302 
303     event Mint(address indexed to, uint256 amount);
304 
305     function mint(address _to, uint256 _amount)
306         public
307         onlyOwner
308         returns (bool)
309     {
310         super._mint(_to, _amount);
311         emit Mint(_to, _amount);
312         return true;
313     }
314 
315     event Burn(address indexed burner, uint256 value);
316 
317     function burn(address _who, uint256 _value) public onlyOwner {
318         require(_value <= super.balanceOf(_who), "Balance is too small.");
319 
320         _burn(_who, _value);
321         emit Burn(_who, _value);
322     }
323 
324     struct LockInfo {
325         uint256 releaseTime;
326         uint256 balance;
327     }
328     mapping(address => LockInfo[]) internal lockInfo;
329 
330     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
331     event Unlock(address indexed holder, uint256 value);
332 
333     function balanceOf(address _holder) public view returns (uint256 balance) {
334         uint256 lockedBalance = 0;
335         for (uint256 i = 0; i < lockInfo[_holder].length; i++) {
336             lockedBalance = lockedBalance.add(lockInfo[_holder][i].balance);
337         }
338         return super.balanceOf(_holder).add(lockedBalance);
339     }
340 
341     function releaseLock(address _holder) internal {
342         for (uint256 i = 0; i < lockInfo[_holder].length; i++) {
343             if (lockInfo[_holder][i].releaseTime <= now) {
344                 _balances[_holder] = _balances[_holder].add(
345                     lockInfo[_holder][i].balance
346                 );
347                 emit Unlock(_holder, lockInfo[_holder][i].balance);
348                 lockInfo[_holder][i].balance = 0;
349 
350                 if (i != lockInfo[_holder].length - 1) {
351                     lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder]
352                         .length - 1];
353                     i--;
354                 }
355                 lockInfo[_holder].length--;
356             }
357         }
358     }
359 
360     function lockCount(address _holder) public view returns (uint256) {
361         return lockInfo[_holder].length;
362     }
363 
364     function lockState(address _holder, uint256 _idx)
365         public
366         view
367         returns (uint256, uint256)
368     {
369         return (
370             lockInfo[_holder][_idx].releaseTime,
371             lockInfo[_holder][_idx].balance
372         );
373     }
374 
375     function lock(
376         address _holder,
377         uint256 _amount,
378         uint256 _releaseTime
379     ) public onlyOwner {
380         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
381         _balances[_holder] = _balances[_holder].sub(_amount);
382         lockInfo[_holder].push(LockInfo(_releaseTime, _amount));
383         emit Lock(_holder, _amount, _releaseTime);
384     }
385 
386     function lockAfter(
387         address _holder,
388         uint256 _amount,
389         uint256 _afterTime
390     ) public onlyOwner {
391         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
392         _balances[_holder] = _balances[_holder].sub(_amount);
393         lockInfo[_holder].push(LockInfo(now + _afterTime, _amount));
394         emit Lock(_holder, _amount, now + _afterTime);
395     }
396 
397     function unlock(address _holder, uint256 i) public onlyOwner {
398         require(i < lockInfo[_holder].length, "No lock information.");
399 
400         _balances[_holder] = _balances[_holder].add(
401             lockInfo[_holder][i].balance
402         );
403         emit Unlock(_holder, lockInfo[_holder][i].balance);
404         lockInfo[_holder][i].balance = 0;
405 
406         if (i != lockInfo[_holder].length - 1) {
407             lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length -
408                 1];
409         }
410         lockInfo[_holder].length--;
411     }
412 
413     function transferWithLock(
414         address _to,
415         uint256 _value,
416         uint256 _releaseTime
417     ) public onlyOwner returns (bool) {
418         require(_to != address(0), "wrong address");
419         require(_value <= super.balanceOf(owner), "Not enough balance");
420 
421         _balances[owner] = _balances[owner].sub(_value);
422         lockInfo[_to].push(LockInfo(_releaseTime, _value));
423         emit Transfer(owner, _to, _value);
424         emit Lock(_to, _value, _releaseTime);
425 
426         return true;
427     }
428 
429     function transferWithLockAfter(
430         address _to,
431         uint256 _value,
432         uint256 _afterTime
433     ) public onlyOwner returns (bool) {
434         require(_to != address(0), "wrong address");
435         require(_value <= super.balanceOf(owner), "Not enough balance");
436 
437         _balances[owner] = _balances[owner].sub(_value);
438         lockInfo[_to].push(LockInfo(now + _afterTime, _value));
439         emit Transfer(owner, _to, _value);
440         emit Lock(_to, _value, now + _afterTime);
441 
442         return true;
443     }
444 
445     function currentTime() public view returns (uint256) {
446         return now;
447     }
448 
449     function afterTime(uint256 _value) public view returns (uint256) {
450         return now + _value;
451     }
452 }