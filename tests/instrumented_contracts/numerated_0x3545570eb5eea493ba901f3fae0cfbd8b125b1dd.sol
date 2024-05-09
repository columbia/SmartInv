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
308     function addtokenLock(address _to, uint256 _value, uint256 _time) onlyOwner transferParamsValidation(msg.sender, _to, _value) external returns (bool)
309     {
310         require(_time > now);
311 
312         _lock(_to, _value, _time);
313 
314 
315         return true;
316     }
317     
318     // lockAddress is only for security accident prevention
319     
320     function lockAddress(address _addr, bool _locked) onlyOwner external
321     {
322         lockedAddresses[_addr] = _locked;
323     }
324 
325     // approve is for transfer authentication
326     function approve(address _spender, uint256 _value) external onlyWhenNotStopped returns (bool)
327     {
328         require(_spender != address(0));
329         require(balances[msg.sender] >= _value);
330         require(msg.sender != _spender);
331 
332         approvals[msg.sender][_spender] = _value;
333 
334         emit Approval(msg.sender, _spender, _value);
335 
336         return true;
337     }
338 
339     
340     function unlock(address _who, uint256 _index) onlyOwner external returns (bool)
341     {
342         uint256 length = lockup[_who].length;
343         require(length > _index);
344 
345         lockup[_who][_index] = lockup[_who][length - 1];
346         lockup[_who].length--;
347 
348         emit UnlockedIndex(_who, _index);
349 
350         return true;
351     }
352 
353     function unlockAll(address _who) onlyOwner external returns (bool)
354     {
355         require(lockup[_who].length > 0);
356 
357         delete lockup[_who];
358         emit UnlockedAll(_who);
359 
360         return true;
361     }
362     
363     // burn is for incubator fund or security accident prevention
364 
365     function burn(uint256 _value) external
366     {
367         require(balances[msg.sender] >= _value);
368         require(_value > 0);
369 
370         balances[msg.sender] = balances[msg.sender].sub(_value);
371 
372         totalSupply = totalSupply.sub(_value);
373 
374         emit Burn(msg.sender, _value);
375     }
376     
377     
378 
379     function _mint(address account, uint256 _value) internal 
380     {
381         require(account != address(0));
382 
383         totalSupply = totalSupply.add(_value);
384         balances[account] = balances[account].add(_value);
385         emit Transfer(address(0), account, _value);
386     }
387 
388    
389     function _transfer(address _from, address _to, uint256 _value) internal
390     {
391         balances[_from] = balances[_from].sub(_value);
392         balances[_to] = balances[_to].add(_value);
393         
394         
395         emit Transfer(_from, _to, _value);
396     }
397 
398     function _lock(address _who, uint256 _value, uint256 _dateTime) onlyOwner internal
399     {
400         lockup[_who].push(Lock(_value, _dateTime));
401 
402         emit Locked(_who, lockup[_who].length - 1);
403     }
404 
405     // destruction is for token upgrade
406     function destruction() onlyOwner public
407     {
408         selfdestruct(msg.sender);
409     }
410     
411     
412 }
413 
414 /**
415  * @title Roles
416  * @dev Library for managing addresses assigned to a Role.
417  */
418 library Roles {
419     struct Role {
420         mapping (address => bool) bearer;
421     }
422 
423     /**
424      * @dev give an account access to this role
425      */
426     function add(Role storage role, address account) internal {
427         require(account != address(0));
428         require(!has(role, account));
429 
430         role.bearer[account] = true;
431     }
432 
433     /**
434      * @dev remove an account's access to this role
435      */
436     function remove(Role storage role, address account) internal {
437         require(account != address(0));
438         require(has(role, account));
439 
440         role.bearer[account] = false;
441     }
442 
443     /**
444      * @dev check if an account has this role
445      * @return bool
446      */
447     function has(Role storage role, address account) internal view returns (bool) {
448         require(account != address(0));
449         return role.bearer[account];
450     }
451 }
452 
453 contract MinterRole {
454     using Roles for Roles.Role;
455 
456     event MinterAdded(address indexed account);
457     event MinterRemoved(address indexed account);
458 
459     Roles.Role private _minters;
460 
461     constructor () internal {
462         _addMinter(msg.sender);
463     }
464 
465     modifier onlyMinter() {
466         require(isMinter(msg.sender));
467         _;
468     }
469 
470     function isMinter(address account) public view returns (bool) {
471         return _minters.has(account);
472     }
473 
474     function addMinter(address account) public onlyMinter {
475         _addMinter(account);
476     }
477 
478     function renounceMinter() public {
479         _removeMinter(msg.sender);
480     }
481 
482     function _addMinter(address account) internal {
483         _minters.add(account);
484         emit MinterAdded(account);
485     }
486 
487     function _removeMinter(address account) internal {
488         _minters.remove(account);
489         emit MinterRemoved(account);
490     }
491 }
492 
493 /**
494  * @title ERC20Mintable
495  * @dev ERC20 minting logic
496  */
497 contract ERC20Mintable is BaseToken, MinterRole {
498     /**
499      * @dev Function to mint tokens
500      * @param to The address that will receive the minted tokens.
501      * @param value The amount of tokens to mint.
502      * @return A boolean that indicates if the operation was successful.
503      */
504      
505     
506     function mint(address to, uint256 value) public onlyMinter returns (bool) {
507         _mint(to, value);
508         return true;
509     }
510 }
511 
512 
513 contract CIU is BaseToken, ERC20Mintable
514 {
515     using SafeMath for uint256;
516 
517     string constant public name    = 'CircleInUs';
518     string constant public symbol  = 'CIU';
519     string constant public version = '1.0.0';
520 
521 
522     constructor() public
523     {
524         totalSupply = 7700000000 * E18;
525         balances[msg.sender] = totalSupply;
526     }
527 
528 }