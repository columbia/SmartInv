1 /**
2  *Submitted for verification at Etherscan.io on 2019-10-02
3 */
4 
5 pragma solidity ^0.5.8;
6 
7 
8 /**
9  * @title SafeMath
10  * @dev Unsigned math operations with safety checks that revert on error
11  */
12 library SafeMath {
13     /**
14     * @dev Multiplies two unsigned integers, reverts on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b > 0);
31         uint256 c = a / b;
32         return c;
33     }
34 
35     /**
36     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b <= a);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     /**
45     * @dev Adds two unsigned integers, reverts on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a);
50         return c;
51     }
52 
53     /**
54     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55     * reverts when dividing by zero.
56     */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 contract Ownable
64 {
65     bool private stopped;
66     
67     address public _owner;
68     address public _admin;
69     address private proposedOwner;
70     mapping(address => bool) private _allowed;
71 
72     event Stopped();
73     event Started();
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75     event Allowed(address indexed _address);
76     event RemoveAllowed(address indexed _address);
77 
78     constructor () internal
79     {
80         stopped = false;
81         _owner = msg.sender;
82         emit OwnershipTransferred(address(0), _owner);
83     }
84 
85     function owner() public view returns (address)
86     {
87         return _owner;
88     }
89 
90     modifier onlyOwner()
91     {
92         require(isOwner());
93         _;
94     }
95 
96     modifier onlyAllowed()
97     {
98         require(isAllowed() || isOwner());
99         _;
100     }
101 
102     modifier onlyWhenNotStopped()
103     {
104         require(!isStopped());
105         _;
106     }
107 
108     function isOwner() public view returns (bool)
109     {
110         return msg.sender == _owner;
111     }
112 
113     function isAllowed() public view returns (bool)
114     {
115         return _allowed[msg.sender];
116     }
117 
118     function allow(address _target) external onlyOwner returns (bool)
119     {
120         _allowed[_target] = true;
121         emit Allowed(_target);
122         return true;
123     }
124 
125     function removeAllowed(address _target) external onlyOwner returns (bool)
126     {
127         _allowed[_target] = false;
128         emit RemoveAllowed(_target);
129         return true;
130     }
131 
132     function isStopped() public view returns (bool)
133     {
134         if(isOwner() || isAllowed())
135         {
136             return false;
137         }
138         else
139         {
140             return stopped;
141         }
142     }
143 
144     function stop() public onlyOwner
145     {
146         _stop();
147     }
148 
149     function start() public onlyOwner
150     {
151         _start();
152     }
153 
154     function proposeOwner(address _proposedOwner) public onlyOwner
155     {
156         require(msg.sender != _proposedOwner);
157         proposedOwner = _proposedOwner;
158     }
159 
160     function claimOwnership() public
161     {
162         require(msg.sender == proposedOwner);
163 
164         emit OwnershipTransferred(_owner, proposedOwner);
165 
166         _owner = proposedOwner;
167         proposedOwner = address(0);
168     }
169 
170     function _stop() internal
171     {
172         emit Stopped();
173         stopped = true;
174     }
175 
176     function _start() internal
177     {
178         emit Started();
179         stopped = false;
180     }
181 }
182 
183 contract BaseToken is Ownable
184 {
185     using SafeMath for uint256;
186 
187     uint256 constant internal E18 = 1000000000000000000;
188     uint256 constant public decimals = 18;
189     uint256 public totalSupply;
190 
191     struct Lock {
192         uint256 amount;
193         uint256 expiresAt;
194     }
195 
196     mapping (address => uint256) public balances;
197     mapping (address => mapping ( address => uint256 )) public approvals;
198     mapping (address => Lock[]) public lockup;
199     mapping(address => bool) public lockedAddresses;
200 
201     
202     event Transfer(address indexed from, address indexed to, uint256 value);
203     event Approval(address indexed owner, address indexed spender, uint256 value);
204 
205     event Locked(address _who,uint256 _index);
206     event UnlockedAll(address _who);
207     event UnlockedIndex(address _who, uint256 _index);
208     
209     event Burn(address indexed from, uint256 indexed value);
210     
211     constructor() public
212     {
213         balances[msg.sender] = totalSupply;
214     }
215 
216     modifier transferParamsValidation(address _from, address _to, uint256 _value)
217     {
218         require(_from != address(0));
219         require(_to != address(0));
220         require(_value > 0);
221         require(balances[_from] >= _value);
222         require(!isLocked(_from, _value));
223         _;
224     }
225     
226     modifier canTransfer(address _sender, uint256 _value) {
227     require(!lockedAddresses[_sender]);
228     require(_sender != address(0));
229     
230 
231     _;
232     }
233 
234     function balanceOf(address _who) view public returns (uint256)
235     {
236         return balances[_who];
237     }
238 
239     function lockedBalanceOf(address _who) view public returns (uint256)
240     {
241         require(_who != address(0));
242 
243         uint256 lockedBalance = 0;
244         if(lockup[_who].length > 0)
245         {
246             Lock[] storage locks = lockup[_who];
247 
248             uint256 length = locks.length;
249             for (uint i = 0; i < length; i++)
250             {
251                 if (now < locks[i].expiresAt)
252                 {
253                     lockedBalance = lockedBalance.add(locks[i].amount);
254                 }
255             }
256         }
257 
258         return lockedBalance;
259     }
260 
261     function allowance(address _owner, address _spender) view external returns (uint256)
262     {
263         return approvals[_owner][_spender];
264     }
265 
266     function isLocked(address _who, uint256 _value) view public returns(bool)
267     {
268         uint256 lockedBalance = lockedBalanceOf(_who);
269         uint256 balance = balanceOf(_who);
270 
271         if(lockedBalance <= 0)
272         {
273             return false;
274         }
275         else
276         {
277             return !(balance > lockedBalance && balance.sub(lockedBalance) >= _value);
278         }
279     }
280 
281     function transfer(address _to, uint256 _value) external onlyWhenNotStopped canTransfer(msg.sender, _value) transferParamsValidation(msg.sender, _to, _value) returns (bool)
282     {
283         
284         _transfer(msg.sender, _to, _value);
285 
286         return true;
287     }
288 
289     function transferFrom(address _from, address _to, uint256 _value) external onlyWhenNotStopped transferParamsValidation(_from, _to, _value) returns (bool)
290     {
291         require(approvals[_from][msg.sender] >= _value);
292 
293         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
294 
295         _transfer(_from, _to, _value);
296 
297         return true;
298     }
299     
300     // transferWithLock is only for airdrop or marketing purpose
301 
302     function transferWithLock(address _to, uint256 _value, uint256 _time) onlyOwner transferParamsValidation(msg.sender, _to, _value) external returns (bool)
303     {
304         require(_time > now);
305 
306         _lock(_to, _value, _time);
307         _transfer(msg.sender, _to, _value);
308 
309         return true;
310     }
311     
312     // lockAddress is only for security accident prevention
313     
314     function lockAddress(address _addr, bool _locked) onlyOwner external
315     {
316         lockedAddresses[_addr] = _locked;
317     }
318 
319     // approve is for transfer authentication
320     function approve(address _spender, uint256 _value) external onlyWhenNotStopped returns (bool)
321     {
322         require(_spender != address(0));
323         require(balances[msg.sender] >= _value);
324         require(msg.sender != _spender);
325 
326         approvals[msg.sender][_spender] = _value;
327 
328         emit Approval(msg.sender, _spender, _value);
329 
330         return true;
331     }
332 
333     
334     function unlock(address _who, uint256 _index) onlyOwner external returns (bool)
335     {
336         uint256 length = lockup[_who].length;
337         require(length > _index);
338 
339         lockup[_who][_index] = lockup[_who][length - 1];
340         lockup[_who].length--;
341 
342         emit UnlockedIndex(_who, _index);
343 
344         return true;
345     }
346 
347     function unlockAll(address _who) onlyOwner external returns (bool)
348     {
349         require(lockup[_who].length > 0);
350 
351         delete lockup[_who];
352         emit UnlockedAll(_who);
353 
354         return true;
355     }
356     
357     // burn is for incubator fund or security accident prevention
358 
359     function burn(uint256 _value) external
360     {
361         require(balances[msg.sender] >= _value);
362         require(_value > 0);
363 
364         balances[msg.sender] = balances[msg.sender].sub(_value);
365 
366         totalSupply = totalSupply.sub(_value);
367 
368         emit Burn(msg.sender, _value);
369     }
370     
371     
372 
373     function _mint(address account, uint256 _value) internal 
374     {
375         require(account != address(0));
376 
377         totalSupply = totalSupply.add(_value);
378         balances[account] = balances[account].add(_value);
379         emit Transfer(address(0), account, _value);
380     }
381 
382    
383     function _transfer(address _from, address _to, uint256 _value) internal
384     {
385         balances[_from] = balances[_from].sub(_value);
386         balances[_to] = balances[_to].add(_value);
387         
388         
389         emit Transfer(_from, _to, _value);
390     }
391 
392     function _lock(address _who, uint256 _value, uint256 _dateTime) onlyOwner internal
393     {
394         lockup[_who].push(Lock(_value, _dateTime));
395 
396         emit Locked(_who, lockup[_who].length - 1);
397     }
398 
399     // destruction is for token upgrade
400     function destruction() onlyOwner public
401     {
402         selfdestruct(msg.sender);
403     }
404     
405     
406 }
407 
408 /**
409  * @title Roles
410  * @dev Library for managing addresses assigned to a Role.
411  */
412 library Roles {
413     struct Role {
414         mapping (address => bool) bearer;
415     }
416 
417     /**
418      * @dev give an account access to this role
419      */
420     function add(Role storage role, address account) internal {
421         require(account != address(0));
422         require(!has(role, account));
423 
424         role.bearer[account] = true;
425     }
426 
427     /**
428      * @dev remove an account's access to this role
429      */
430     function remove(Role storage role, address account) internal {
431         require(account != address(0));
432         require(has(role, account));
433 
434         role.bearer[account] = false;
435     }
436 
437     /**
438      * @dev check if an account has this role
439      * @return bool
440      */
441     function has(Role storage role, address account) internal view returns (bool) {
442         require(account != address(0));
443         return role.bearer[account];
444     }
445 }
446 
447 contract MinterRole {
448     using Roles for Roles.Role;
449 
450     event MinterAdded(address indexed account);
451     event MinterRemoved(address indexed account);
452 
453     Roles.Role private _minters;
454 
455     constructor () internal {
456         _addMinter(msg.sender);
457     }
458 
459     modifier onlyMinter() {
460         require(isMinter(msg.sender));
461         _;
462     }
463 
464     function isMinter(address account) public view returns (bool) {
465         return _minters.has(account);
466     }
467 
468     function addMinter(address account) public onlyMinter {
469         _addMinter(account);
470     }
471 
472     function renounceMinter() public {
473         _removeMinter(msg.sender);
474     }
475 
476     function _addMinter(address account) internal {
477         _minters.add(account);
478         emit MinterAdded(account);
479     }
480 
481     function _removeMinter(address account) internal {
482         _minters.remove(account);
483         emit MinterRemoved(account);
484     }
485 }
486 
487 /**
488  * @title ERC20Mintable
489  * @dev ERC20 minting logic
490  */
491 contract ERC20Mintable is BaseToken, MinterRole {
492     /**
493      * @dev Function to mint tokens
494      * @param to The address that will receive the minted tokens.
495      * @param value The amount of tokens to mint.
496      * @return A boolean that indicates if the operation was successful.
497      */
498      
499     // mint is only for THENODE's daily MPoS mining (250000 THE)
500     function mint(address to, uint256 value) public onlyMinter returns (bool) {
501         _mint(to, value);
502         return true;
503     }
504 }
505 
506 
507 contract THECASH is BaseToken, ERC20Mintable
508 {
509     using SafeMath for uint256;
510 
511     string constant public name    = 'THECASH';
512     string constant public symbol  = 'TCH';
513     string constant public version = '1.0.0';
514 
515 
516     constructor() public
517     {
518         totalSupply = 2000000 * E18;
519         balances[msg.sender] = totalSupply;
520     }
521 
522 }