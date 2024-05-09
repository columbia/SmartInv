1 pragma solidity ^0.5.8;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Unsigned math operations with safety checks that revert on error
7  */
8 library SafeMath {
9     /**
10     * @dev Multiplies two unsigned integers, reverts on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16 
17         uint256 c = a * b;
18         require(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         require(b > 0);
27         uint256 c = a / b;
28         return c;
29     }
30 
31     /**
32     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         require(b <= a);
36         uint256 c = a - b;
37         return c;
38     }
39 
40     /**
41     * @dev Adds two unsigned integers, reverts on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a);
46         return c;
47     }
48 
49     /**
50     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
51     * reverts when dividing by zero.
52     */
53     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
54         require(b != 0);
55         return a % b;
56     }
57 }
58 
59 contract Ownable
60 {
61     bool private stopped;
62     
63     address public _owner;
64     address public _admin;
65     address private proposedOwner;
66     mapping(address => bool) private _allowed;
67 
68     event Stopped();
69     event Started();
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71     event Allowed(address indexed _address);
72     event RemoveAllowed(address indexed _address);
73 
74     constructor () internal
75     {
76         stopped = false;
77         _owner = msg.sender;
78         emit OwnershipTransferred(address(0), _owner);
79     }
80 
81     function owner() public view returns (address)
82     {
83         return _owner;
84     }
85 
86     modifier onlyOwner()
87     {
88         require(isOwner());
89         _;
90     }
91 
92     modifier onlyAllowed()
93     {
94         require(isAllowed() || isOwner());
95         _;
96     }
97 
98     modifier onlyWhenNotStopped()
99     {
100         require(!isStopped());
101         _;
102     }
103 
104     function isOwner() public view returns (bool)
105     {
106         return msg.sender == _owner;
107     }
108 
109     function isAllowed() public view returns (bool)
110     {
111         return _allowed[msg.sender];
112     }
113 
114     function allow(address _target) external onlyOwner returns (bool)
115     {
116         _allowed[_target] = true;
117         emit Allowed(_target);
118         return true;
119     }
120 
121     function removeAllowed(address _target) external onlyOwner returns (bool)
122     {
123         _allowed[_target] = false;
124         emit RemoveAllowed(_target);
125         return true;
126     }
127 
128     function isStopped() public view returns (bool)
129     {
130         if(isOwner() || isAllowed())
131         {
132             return false;
133         }
134         else
135         {
136             return stopped;
137         }
138     }
139 
140     function stop() public onlyOwner
141     {
142         _stop();
143     }
144 
145     function start() public onlyOwner
146     {
147         _start();
148     }
149 
150     function proposeOwner(address _proposedOwner) public onlyOwner
151     {
152         require(msg.sender != _proposedOwner);
153         proposedOwner = _proposedOwner;
154     }
155 
156     function claimOwnership() public
157     {
158         require(msg.sender == proposedOwner);
159 
160         emit OwnershipTransferred(_owner, proposedOwner);
161 
162         _owner = proposedOwner;
163         proposedOwner = address(0);
164     }
165 
166     function _stop() internal
167     {
168         emit Stopped();
169         stopped = true;
170     }
171 
172     function _start() internal
173     {
174         emit Started();
175         stopped = false;
176     }
177 }
178 
179 contract BaseToken is Ownable
180 {
181     using SafeMath for uint256;
182 
183     uint256 constant internal E18 = 1000000000000000000;
184     uint256 constant public decimals = 18;
185     uint256 public totalSupply;
186 
187     struct Lock {
188         uint256 amount;
189         uint256 expiresAt;
190     }
191 
192     mapping (address => uint256) public balances;
193     mapping (address => mapping ( address => uint256 )) public approvals;
194     mapping (address => Lock[]) public lockup;
195     mapping(address => bool) public lockedAddresses;
196 
197     
198     event Transfer(address indexed from, address indexed to, uint256 value);
199     event Approval(address indexed owner, address indexed spender, uint256 value);
200 
201     event Locked(address _who,uint256 _index);
202     event UnlockedAll(address _who);
203     event UnlockedIndex(address _who, uint256 _index);
204     
205     event Burn(address indexed from, uint256 indexed value);
206     
207     constructor() public
208     {
209         balances[msg.sender] = totalSupply;
210     }
211 
212     modifier transferParamsValidation(address _from, address _to, uint256 _value)
213     {
214         require(_from != address(0));
215         require(_to != address(0));
216         require(_value > 0);
217         require(balances[_from] >= _value);
218         require(!isLocked(_from, _value));
219         _;
220     }
221     
222     modifier canTransfer(address _sender, uint256 _value) {
223     require(!lockedAddresses[_sender]);
224     require(_sender != address(0));
225     
226 
227     _;
228     }
229 
230     function balanceOf(address _who) view public returns (uint256)
231     {
232         return balances[_who];
233     }
234 
235     function lockedBalanceOf(address _who) view public returns (uint256)
236     {
237         require(_who != address(0));
238 
239         uint256 lockedBalance = 0;
240         if(lockup[_who].length > 0)
241         {
242             Lock[] storage locks = lockup[_who];
243 
244             uint256 length = locks.length;
245             for (uint i = 0; i < length; i++)
246             {
247                 if (now < locks[i].expiresAt)
248                 {
249                     lockedBalance = lockedBalance.add(locks[i].amount);
250                 }
251             }
252         }
253 
254         return lockedBalance;
255     }
256 
257     function allowance(address _owner, address _spender) view external returns (uint256)
258     {
259         return approvals[_owner][_spender];
260     }
261 
262     function isLocked(address _who, uint256 _value) view public returns(bool)
263     {
264         uint256 lockedBalance = lockedBalanceOf(_who);
265         uint256 balance = balanceOf(_who);
266 
267         if(lockedBalance <= 0)
268         {
269             return false;
270         }
271         else
272         {
273             return !(balance > lockedBalance && balance.sub(lockedBalance) >= _value);
274         }
275     }
276 
277     function transfer(address _to, uint256 _value) external onlyWhenNotStopped canTransfer(msg.sender, _value) transferParamsValidation(msg.sender, _to, _value) returns (bool)
278     {
279         
280         _transfer(msg.sender, _to, _value);
281 
282         return true;
283     }
284 
285     function transferFrom(address _from, address _to, uint256 _value) external onlyWhenNotStopped transferParamsValidation(_from, _to, _value) returns (bool)
286     {
287         require(approvals[_from][msg.sender] >= _value);
288 
289         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
290 
291         _transfer(_from, _to, _value);
292 
293         return true;
294     }
295     
296     // transferWithLock is only for airdrop or marketing purpose
297 
298     function transferWithLock(address _to, uint256 _value, uint256 _time) onlyOwner transferParamsValidation(msg.sender, _to, _value) external returns (bool)
299     {
300         require(_time > now);
301 
302         _lock(_to, _value, _time);
303         _transfer(msg.sender, _to, _value);
304 
305         return true;
306     }
307     
308     // lockAddress is only for security accident prevention
309     
310     function lockAddress(address _addr, bool _locked) onlyOwner external
311     {
312         lockedAddresses[_addr] = _locked;
313     }
314 
315     // approve is for transfer authentication
316     function approve(address _spender, uint256 _value) external onlyWhenNotStopped returns (bool)
317     {
318         require(_spender != address(0));
319         require(balances[msg.sender] >= _value);
320         require(msg.sender != _spender);
321 
322         approvals[msg.sender][_spender] = _value;
323 
324         emit Approval(msg.sender, _spender, _value);
325 
326         return true;
327     }
328 
329     
330     function unlock(address _who, uint256 _index) onlyOwner external returns (bool)
331     {
332         uint256 length = lockup[_who].length;
333         require(length > _index);
334 
335         lockup[_who][_index] = lockup[_who][length - 1];
336         lockup[_who].length--;
337 
338         emit UnlockedIndex(_who, _index);
339 
340         return true;
341     }
342 
343     function unlockAll(address _who) onlyOwner external returns (bool)
344     {
345         require(lockup[_who].length > 0);
346 
347         delete lockup[_who];
348         emit UnlockedAll(_who);
349 
350         return true;
351     }
352     
353     // burn is for incubator fund or security accident prevention
354 
355     function burn(uint256 _value) external
356     {
357         require(balances[msg.sender] >= _value);
358         require(_value > 0);
359 
360         balances[msg.sender] = balances[msg.sender].sub(_value);
361 
362         totalSupply = totalSupply.sub(_value);
363 
364         emit Burn(msg.sender, _value);
365     }
366     
367     
368 
369     function _mint(address account, uint256 _value) internal 
370     {
371         require(account != address(0));
372 
373         totalSupply = totalSupply.add(_value);
374         balances[account] = balances[account].add(_value);
375         emit Transfer(address(0), account, _value);
376     }
377 
378    
379     function _transfer(address _from, address _to, uint256 _value) internal
380     {
381         balances[_from] = balances[_from].sub(_value);
382         balances[_to] = balances[_to].add(_value);
383         
384         
385         emit Transfer(_from, _to, _value);
386     }
387 
388     function _lock(address _who, uint256 _value, uint256 _dateTime) onlyOwner internal
389     {
390         lockup[_who].push(Lock(_value, _dateTime));
391 
392         emit Locked(_who, lockup[_who].length - 1);
393     }
394 
395     // destruction is for token upgrade
396     function destruction() onlyOwner public
397     {
398         selfdestruct(msg.sender);
399     }
400     
401     
402 }
403 
404 /**
405  * @title Roles
406  * @dev Library for managing addresses assigned to a Role.
407  */
408 library Roles {
409     struct Role {
410         mapping (address => bool) bearer;
411     }
412 
413     /**
414      * @dev give an account access to this role
415      */
416     function add(Role storage role, address account) internal {
417         require(account != address(0));
418         require(!has(role, account));
419 
420         role.bearer[account] = true;
421     }
422 
423     /**
424      * @dev remove an account's access to this role
425      */
426     function remove(Role storage role, address account) internal {
427         require(account != address(0));
428         require(has(role, account));
429 
430         role.bearer[account] = false;
431     }
432 
433     /**
434      * @dev check if an account has this role
435      * @return bool
436      */
437     function has(Role storage role, address account) internal view returns (bool) {
438         require(account != address(0));
439         return role.bearer[account];
440     }
441 }
442 
443 contract MinterRole {
444     using Roles for Roles.Role;
445 
446     event MinterAdded(address indexed account);
447     event MinterRemoved(address indexed account);
448 
449     Roles.Role private _minters;
450 
451     constructor () internal {
452         _addMinter(msg.sender);
453     }
454 
455     modifier onlyMinter() {
456         require(isMinter(msg.sender));
457         _;
458     }
459 
460     function isMinter(address account) public view returns (bool) {
461         return _minters.has(account);
462     }
463 
464     function addMinter(address account) public onlyMinter {
465         _addMinter(account);
466     }
467 
468     function renounceMinter() public {
469         _removeMinter(msg.sender);
470     }
471 
472     function _addMinter(address account) internal {
473         _minters.add(account);
474         emit MinterAdded(account);
475     }
476 
477     function _removeMinter(address account) internal {
478         _minters.remove(account);
479         emit MinterRemoved(account);
480     }
481 }
482 
483 /**
484  * @title ERC20Mintable
485  * @dev ERC20 minting logic
486  */
487 contract ERC20Mintable is BaseToken, MinterRole {
488     /**
489      * @dev Function to mint tokens
490      * @param to The address that will receive the minted tokens.
491      * @param value The amount of tokens to mint.
492      * @return A boolean that indicates if the operation was successful.
493      */
494      
495     // mint is only for THENODE's daily MPoS mining (250000 THE)
496     function mint(address to, uint256 value) public onlyMinter returns (bool) {
497         _mint(to, value);
498         return true;
499     }
500 }
501 
502 
503 contract THENODE is BaseToken, ERC20Mintable
504 {
505     using SafeMath for uint256;
506 
507     string constant public name    = 'THENODE';
508     string constant public symbol  = 'THE';
509     string constant public version = '1.0.0';
510 
511 
512     constructor() public
513     {
514         totalSupply = 25000000 * E18;
515         balances[msg.sender] = totalSupply;
516     }
517 
518 }