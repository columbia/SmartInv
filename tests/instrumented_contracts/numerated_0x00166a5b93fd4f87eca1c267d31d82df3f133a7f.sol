1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4 
5     function mulZ(uint256 a, uint256 b) internal pure returns (uint256) {
6 
7         if (a == 0) {
8             return 0;
9         }
10 
11         uint256 c = a * b;
12         require(c / a == b);
13 
14         return c;
15     }
16 
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         require(b <= a);
20         uint256 c = a - b;
21 
22         return c;
23     }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         require(b > 0);
27         uint256 c = a / b;
28 
29         return c;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a);
35 
36         return c;
37     }
38 
39 
40     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b != 0);
42         return a % b;
43     }
44 }
45 
46 library Roles {
47     struct Role {
48         mapping (address => bool) bearer;
49     }
50 
51 
52     function add(Role storage role, address account) internal {
53         require(account != address(0));
54         require(!has(role, account));
55 
56         role.bearer[account] = true;
57     }
58 
59 
60     function remove(Role storage role, address account) internal {
61         require(account != address(0));
62         require(has(role, account));
63 
64         role.bearer[account] = false;
65     }
66 
67 
68     function has(Role storage role, address account) internal view returns (bool) {
69         require(account != address(0));
70         return role.bearer[account];
71     }
72 }
73 
74 contract Ownable {
75     address public owner;
76     address public newOwner;
77 
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     constructor() public {
81         owner = msg.sender;
82         newOwner = address(0);
83     }
84 
85     modifier onlyOwner() {
86         require(msg.sender == owner);
87         _;
88     }
89     modifier onlyNewOwner() {
90         require(msg.sender != address(0));
91         require(msg.sender == newOwner);
92         _;
93     }
94     
95     function isOwner(address account) public view returns (bool) {
96         if( account == owner ){
97             return true;
98         }
99         else {
100             return false;
101         }
102     }
103 
104 
105 
106     function acceptOwnership() public onlyNewOwner returns(bool) {
107         emit OwnershipTransferred(owner, newOwner);        
108         owner = newOwner;
109         newOwner = address(0);
110     }
111 
112         function transferOwnership(address _newOwner) public onlyOwner {
113         require(_newOwner != address(0));
114         newOwner = _newOwner;
115     }
116 }
117 
118 contract PauserRole is Ownable{
119     using Roles for Roles.Role;
120 
121     event PauserAdded(address indexed account);
122     event PauserRemoved(address indexed account);
123 
124     Roles.Role private _pausers;
125 
126     constructor () internal {
127         _addPauser(msg.sender);
128     }
129 
130     modifier onlyPauser() {
131         require(isPauser(msg.sender)|| isOwner(msg.sender));
132         _;
133     }
134 
135  
136 
137     function addPauser(address account) public onlyPauser {
138         _addPauser(account);
139     }
140     
141     function removePauser(address account) public onlyOwner {
142         _removePauser(account);
143     }
144 
145     function renouncePauser() public {
146         _removePauser(msg.sender);
147     }
148 
149     function _addPauser(address account) internal {
150         _pausers.add(account);
151         emit PauserAdded(account);
152     }
153    function isPauser(address account) public view returns (bool) {
154         return _pausers.has(account);
155     }
156     
157     function _removePauser(address account) internal {
158         _pausers.remove(account);
159         emit PauserRemoved(account);
160     }
161 }
162 
163 contract Pausable is PauserRole {
164     event Paused(address account);
165     event Unpaused(address account);
166 
167     bool private _paused;
168 
169     constructor () internal {
170         _paused = false;
171     }
172 
173     /**
174      * @return true if the contract is paused, false otherwise.
175      */
176     function paused() public view returns (bool) {
177         return _paused;
178     }
179 
180 
181     modifier whenNotPaused() {
182         require(!_paused);
183         _;
184     }
185 
186 
187     modifier whenPaused() {
188         require(_paused);
189         _;
190     }
191 
192 
193     function pause() public onlyPauser whenNotPaused {
194         _paused = true;
195         emit Paused(msg.sender);
196     }
197 
198 
199     function unpause() public onlyPauser whenPaused {
200         _paused = false;
201         emit Unpaused(msg.sender);
202     }
203 }
204 
205 interface IERC20 {
206 
207 
208     function totalSupply() external view returns (uint256);
209     
210     function transfer(address to, uint256 value) external returns (bool);
211 
212     function balanceOf(address who) external view returns (uint256);
213 
214     function approve(address spender, uint256 value) external returns (bool);
215 
216     function transferFrom(address from, address to, uint256 value) external returns (bool);
217 
218     function allowance(address owner, address spender) external view returns (uint256);
219 
220     event Transfer(address indexed from, address indexed to, uint256 value);
221 
222     event Approval(address indexed owner, address indexed spender, uint256 value);
223 }
224 
225 contract ERC20 is IERC20 {
226     using SafeMath for uint256;
227 
228     mapping (address => uint256) internal _balances;
229 
230     mapping (address => mapping (address => uint256)) internal _allowed;
231 
232     uint256 private _totalSupply;
233 
234 
235     function totalSupply() public view returns (uint256) {
236         return _totalSupply;
237     }
238 
239 
240     function balanceOf(address owner) public view returns (uint256) {
241         return _balances[owner];
242     }
243 
244  
245     function allowance(address owner, address spender) public view returns (uint256) {
246         return _allowed[owner][spender];
247     }
248 
249 
250     function transfer(address to, uint256 value) public returns (bool) {
251         _transfer(msg.sender, to, value);
252         return true;
253     }
254 
255 
256     function approve(address spender, uint256 value) public returns (bool) {
257         require(spender != address(0));
258 
259         _allowed[msg.sender][spender] = value;
260         emit Approval(msg.sender, spender, value);
261         return true;
262     }
263 
264 
265     function transferFrom(address from, address to, uint256 value) public returns (bool) {
266         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
267         _transfer(from, to, value);
268         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
269         return true;
270     }
271 
272 
273     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
274         require(spender != address(0));
275 
276         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
277         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
278         return true;
279     }
280 
281     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
282         require(spender != address(0));
283 
284         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
285         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
286         return true;
287     }
288 
289 
290     function _transfer(address from, address to, uint256 value) internal {
291         require(to != address(0));
292 
293         _balances[from] = _balances[from].sub(value);
294         _balances[to] = _balances[to].add(value);
295         emit Transfer(from, to, value);
296     }
297 
298 
299     function _mint(address account, uint256 value) internal {
300         require(account != address(0));
301 
302         _totalSupply = _totalSupply.add(value);
303         _balances[account] = _balances[account].add(value);
304         emit Transfer(address(0), account, value);
305     }
306 
307 
308     function _burn(address account, uint256 value) internal {
309         require(account != address(0));
310 
311         _totalSupply = _totalSupply.sub(value);
312         _balances[account] = _balances[account].sub(value);
313         emit Transfer(account, address(0), value);
314     }
315 
316 
317     function _burnFrom(address account, uint256 value) internal {
318         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
319         _burn(account, value);
320         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
321     }
322 }
323 
324 
325 
326 contract ERC20Pausable is ERC20, Pausable {
327     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
328         return super.transfer(to, value);
329     }
330 
331     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
332         return super.transferFrom(from, to, value);
333     }
334     
335 
336 }
337 
338 contract ERC20Detailed is IERC20 {
339     string private _name;
340     string private _symbol;
341     uint8 private _decimals;
342 
343     constructor (string memory name, string memory symbol, uint8 decimals) public {
344         _name = name;
345         _symbol = symbol;
346         _decimals = decimals;
347     }
348 
349 
350     function name() public view returns (string memory) {
351         return _name;
352     }
353 
354  
355     function symbol() public view returns (string memory) {
356         return _symbol;
357     }
358 
359 
360     function decimals() public view returns (uint8) {
361         return _decimals;
362     }
363 }
364 
365 contract ICB is ERC20Detailed, ERC20Pausable {
366     
367     struct LockInfo {
368         uint256 _releaseTime;
369         uint256 _amount;
370     }
371     
372     address public implementation;
373 
374     mapping (address => LockInfo[]) public timelockList;
375 	mapping (address => bool) public frozenAccount;
376     
377     event Freeze(address indexed holder);
378     event Unfreeze(address indexed holder);
379     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
380     event Unlock(address indexed holder, uint256 value);
381 
382     modifier notFrozen(address _holder) {
383         require(!frozenAccount[_holder]);
384         _;
385     }
386     
387     constructor() ERC20Detailed("Incube Chain", "ICB",18) public  {
388         
389         _mint(msg.sender, 30000000000 * (10 ** 18));
390     }
391     
392     function balanceOf(address owner) public view returns (uint256) {
393         
394         uint256 totalBalance = super.balanceOf(owner);
395         if( timelockList[owner].length >0 ){
396             for(uint i=0; i<timelockList[owner].length;i++){
397                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
398             }
399         }
400         
401         return totalBalance;
402     }
403     
404     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
405         if (timelockList[msg.sender].length > 0 ) {
406             _autoUnlock(msg.sender);            
407         }
408         return super.transfer(to, value);
409     }
410 
411     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
412         if (timelockList[from].length > 0) {
413             _autoUnlock(from);            
414         }
415         return super.transferFrom(from, to, value);
416     }
417     
418     function freezeAccount(address holder) public onlyPauser returns (bool) {
419         require(!frozenAccount[holder]);
420         frozenAccount[holder] = true;
421         emit Freeze(holder);
422         return true;
423     }
424 
425     function unfreezeAccount(address holder) public onlyPauser returns (bool) {
426         require(frozenAccount[holder]);
427         frozenAccount[holder] = false;
428         emit Unfreeze(holder);
429         return true;
430     }
431     
432     function lock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
433         require(_balances[holder] >= value,"There is not enough balances of holder.");
434         _lock(holder,value,releaseTime);
435         
436         
437         return true;
438     }
439     
440     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
441         _transfer(msg.sender, holder, value);
442         _lock(holder,value,releaseTime);
443         return true;
444     }
445     
446     function unlock(address holder, uint256 idx) public onlyPauser returns (bool) {
447         require( timelockList[holder].length > idx, "There is not lock info.");
448         _unlock(holder,idx);
449         return true;
450     }
451     
452     /**
453      * @dev Upgrades the implementation address
454      * @param _newImplementation address of the new implementation
455      */
456     function upgradeTo(address _newImplementation) public onlyOwner {
457         require(implementation != _newImplementation);
458         _setImplementation(_newImplementation);
459     }
460     
461     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
462         _balances[holder] = _balances[holder].sub(value);
463         timelockList[holder].push( LockInfo(releaseTime, value) );
464         
465         emit Lock(holder, value, releaseTime);
466         return true;
467     }
468     
469     function _unlock(address holder, uint256 idx) internal returns(bool) {
470         LockInfo storage lockinfo = timelockList[holder][idx];
471         uint256 releaseAmount = lockinfo._amount;
472 
473         delete timelockList[holder][idx];
474         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
475         timelockList[holder].length -=1;
476         
477         emit Unlock(holder, releaseAmount);
478         _balances[holder] = _balances[holder].add(releaseAmount);
479         
480         return true;
481     }
482     
483     function _autoUnlock(address holder) internal returns(bool) {
484         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
485             if (timelockList[holder][idx]._releaseTime <= now) {
486                 if( _unlock(holder, idx) ) {
487                     idx -=1;
488                 }
489             }
490         }
491         return true;
492     }
493     
494 
495     function _setImplementation(address _newImp) internal {
496         implementation = _newImp;
497     }
498     
499 
500     function () payable external {
501         address impl = implementation;
502         require(impl != address(0));
503         assembly {
504             let ptr := mload(0x40)
505             calldatacopy(ptr, 0, calldatasize)
506             let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
507             let size := returndatasize
508             returndatacopy(ptr, 0, size)
509             
510             switch result
511             case 0 { revert(ptr, size) }
512             default { return(ptr, size) }
513         }
514     }
515 }