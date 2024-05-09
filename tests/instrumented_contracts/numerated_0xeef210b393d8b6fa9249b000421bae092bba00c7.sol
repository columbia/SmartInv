1 // File: contracts/LifeL.sol
2 
3 pragma solidity ^0.5.0;
4 
5 library SafeMath {
6     /**
7     * @dev Multiplies two unsigned integers, reverts on overflow.
8     */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
11         // benefit is lost if 'b' is also tested.
12         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13         if (a == 0) {
14             return 0;
15         }
16 
17         uint256 c = a * b;
18         require(c / a == b);
19 
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // Solidity only automatically asserts when dividing by 0
28         require(b > 0);
29         uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31 
32         return c;
33     }
34 
35     /**
36     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b <= a);
40         uint256 c = a - b;
41 
42         return c;
43     }
44 
45     /**
46     * @dev Adds two unsigned integers, reverts on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a);
51 
52         return c;
53     }
54 
55     /**
56     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
57     * reverts when dividing by zero.
58     */
59     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b != 0);
61         return a % b;
62     }
63 }
64 
65 library Roles {
66     struct Role {
67         mapping (address => bool) bearer;
68     }
69 
70     /**
71      * @dev give an account access to this role
72      */
73     function add(Role storage role, address account) internal {
74         require(account != address(0));
75         require(!has(role, account));
76 
77         role.bearer[account] = true;
78     }
79 
80     /**
81      * @dev remove an account's access to this role
82      */
83     function remove(Role storage role, address account) internal {
84         require(account != address(0));
85         require(has(role, account));
86 
87         role.bearer[account] = false;
88     }
89 
90     /**
91      * @dev check if an account has this role
92      * @return bool
93      */
94     function has(Role storage role, address account) internal view returns (bool) {
95         require(account != address(0));
96         return role.bearer[account];
97     }
98 }
99 
100 contract Ownable {
101     address public owner;
102     address public newOwner;
103 
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106     constructor() public {
107         owner = msg.sender;
108         newOwner = address(0);
109     }
110 
111     modifier onlyOwner() {
112         require(msg.sender == owner);
113         _;
114     }
115     modifier onlyNewOwner() {
116         require(msg.sender != address(0));
117         require(msg.sender == newOwner);
118         _;
119     }
120     
121     function isOwner(address account) public view returns (bool) {
122         if( account == owner ){
123             return true;
124         }
125         else {
126             return false;
127         }
128     }
129 
130     function transferOwnership(address _newOwner) public onlyOwner {
131         require(_newOwner != address(0));
132         newOwner = _newOwner;
133     }
134 
135     function acceptOwnership() public onlyNewOwner returns(bool) {
136         emit OwnershipTransferred(owner, newOwner);        
137         owner = newOwner;
138         newOwner = address(0);
139     }
140 }
141 
142 contract PauserRole is Ownable{
143     using Roles for Roles.Role;
144 
145     event PauserAdded(address indexed account);
146     event PauserRemoved(address indexed account);
147 
148     Roles.Role private _pausers;
149 
150     constructor () internal {
151         _addPauser(msg.sender);
152     }
153 
154     modifier onlyPauser() {
155         require(isPauser(msg.sender)|| isOwner(msg.sender));
156         _;
157     }
158 
159     function isPauser(address account) public view returns (bool) {
160         return _pausers.has(account);
161     }
162 
163     function addPauser(address account) public onlyOwner {
164         _addPauser(account);
165     }
166     
167     function removePauser(address account) public onlyOwner {
168         _removePauser(account);
169     }
170 
171     function renouncePauser() public {
172         _removePauser(msg.sender);
173     }
174 
175     function _addPauser(address account) internal {
176         _pausers.add(account);
177         emit PauserAdded(account);
178     }
179 
180     function _removePauser(address account) internal {
181         _pausers.remove(account);
182         emit PauserRemoved(account);
183     }
184 }
185 
186 contract Pausable is PauserRole {
187     event Paused(address account);
188     event Unpaused(address account);
189 
190     bool private _paused;
191 
192     constructor () internal {
193         _paused = false;
194     }
195 
196     /**
197      * @return true if the contract is paused, false otherwise.
198      */
199     function paused() public view returns (bool) {
200         return _paused;
201     }
202 
203     /**
204      * @dev Modifier to make a function callable only when the contract is not paused.
205      */
206     modifier whenNotPaused() {
207         require(!_paused);
208         _;
209     }
210 
211     /**
212      * @dev Modifier to make a function callable only when the contract is paused.
213      */
214     modifier whenPaused() {
215         require(_paused);
216         _;
217     }
218 
219     /**
220      * @dev called by the owner to pause, triggers stopped state
221      */
222     function pause() public onlyPauser whenNotPaused {
223         _paused = true;
224         emit Paused(msg.sender);
225     }
226 
227     /**
228      * @dev called by the owner to unpause, returns to normal state
229      */
230     function unpause() public onlyPauser whenPaused {
231         _paused = false;
232         emit Unpaused(msg.sender);
233     }
234 }
235 
236 interface IERC20 {
237     function transfer(address to, uint256 value) external returns (bool);
238 
239     function approve(address spender, uint256 value) external returns (bool);
240 
241     function transferFrom(address from, address to, uint256 value) external returns (bool);
242 
243     function totalSupply() external view returns (uint256);
244 
245     function balanceOf(address who) external view returns (uint256);
246 
247     function allowance(address owner, address spender) external view returns (uint256);
248 
249     event Transfer(address indexed from, address indexed to, uint256 value);
250 
251     event Approval(address indexed owner, address indexed spender, uint256 value);
252 }
253 
254 contract ERC20 is IERC20 {
255     using SafeMath for uint256;
256 
257     mapping (address => uint256) internal _balances;
258 
259     mapping (address => mapping (address => uint256)) internal _allowed;
260 
261     uint256 private _totalSupply;
262 
263     /**
264     * @dev Total number of tokens in existence
265     */
266     function totalSupply() public view returns (uint256) {
267         return _totalSupply;
268     }
269 
270     /**
271     * @dev Gets the balance of the specified address.
272     * @param owner The address to query the balance of.
273     * @return An uint256 representing the amount owned by the passed address.
274     */
275     function balanceOf(address owner) public view returns (uint256) {
276         return _balances[owner];
277     }
278 
279     /**
280      * @dev Function to check the amount of tokens that an owner allowed to a spender.
281      * @param owner address The address which owns the funds.
282      * @param spender address The address which will spend the funds.
283      * @return A uint256 specifying the amount of tokens still available for the spender.
284      */
285     function allowance(address owner, address spender) public view returns (uint256) {
286         return _allowed[owner][spender];
287     }
288 
289     /**
290     * @dev Transfer token for a specified address
291     * @param to The address to transfer to.
292     * @param value The amount to be transferred.
293     */
294     function transfer(address to, uint256 value) public returns (bool) {
295         _transfer(msg.sender, to, value);
296         return true;
297     }
298 
299     /**
300      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
301      * Beware that changing an allowance with this method brings the risk that someone may use both the old
302      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
303      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
304      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
305      * @param spender The address which will spend the funds.
306      * @param value The amount of tokens to be spent.
307      */
308     function approve(address spender, uint256 value) public returns (bool) {
309         require(spender != address(0));
310 
311         _allowed[msg.sender][spender] = value;
312         emit Approval(msg.sender, spender, value);
313         return true;
314     }
315 
316     /**
317      * @dev Transfer tokens from one address to another.
318      * Note that while this function emits an Approval event, this is not required as per the specification,
319      * and other compliant implementations may not emit the event.
320      * @param from address The address which you want to send tokens from
321      * @param to address The address which you want to transfer to
322      * @param value uint256 the amount of tokens to be transferred
323      */
324     function transferFrom(address from, address to, uint256 value) public returns (bool) {
325         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
326         _transfer(from, to, value);
327         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
328         return true;
329     }
330 
331     /**
332      * @dev Increase the amount of tokens that an owner allowed to a spender.
333      * approve should be called when allowed_[_spender] == 0. To increment
334      * allowed value is better to use this function to avoid 2 calls (and wait until
335      * the first transaction is mined)
336      * From MonolithDAO Token.sol
337      * Emits an Approval event.
338      * @param spender The address which will spend the funds.
339      * @param addedValue The amount of tokens to increase the allowance by.
340      */
341     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
342         require(spender != address(0));
343 
344         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
345         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
346         return true;
347     }
348 
349     /**
350      * @dev Decrease the amount of tokens that an owner allowed to a spender.
351      * approve should be called when allowed_[_spender] == 0. To decrement
352      * allowed value is better to use this function to avoid 2 calls (and wait until
353      * the first transaction is mined)
354      * From MonolithDAO Token.sol
355      * Emits an Approval event.
356      * @param spender The address which will spend the funds.
357      * @param subtractedValue The amount of tokens to decrease the allowance by.
358      */
359     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
360         require(spender != address(0));
361 
362         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
363         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
364         return true;
365     }
366 
367     /**
368     * @dev Transfer token for a specified addresses
369     * @param from The address to transfer from.
370     * @param to The address to transfer to.
371     * @param value The amount to be transferred.
372     */
373     function _transfer(address from, address to, uint256 value) internal {
374         require(to != address(0));
375 
376         _balances[from] = _balances[from].sub(value);
377         _balances[to] = _balances[to].add(value);
378         emit Transfer(from, to, value);
379     }
380 
381     /**
382      * @dev Internal function that mints an amount of the token and assigns it to
383      * an account. This encapsulates the modification of balances such that the
384      * proper events are emitted.
385      * @param account The account that will receive the created tokens.
386      * @param value The amount that will be created.
387      */
388     function _mint(address account, uint256 value) internal {
389         require(account != address(0));
390 
391         _totalSupply = _totalSupply.add(value);
392         _balances[account] = _balances[account].add(value);
393         emit Transfer(address(0), account, value);
394     }
395 
396     /**
397      * @dev Internal function that burns an amount of the token of a given
398      * account.
399      * @param account The account whose tokens will be burnt.
400      * @param value The amount that will be burnt.
401      */
402     function _burn(address account, uint256 value) internal {
403         require(account != address(0));
404 
405         _totalSupply = _totalSupply.sub(value);
406         _balances[account] = _balances[account].sub(value);
407         emit Transfer(account, address(0), value);
408     }
409 
410     /**
411      * @dev Internal function that burns an amount of the token of a given
412      * account, deducting from the sender's allowance for said account. Uses the
413      * internal burn function.
414      * Emits an Approval event (reflecting the reduced allowance).
415      * @param account The account whose tokens will be burnt.
416      * @param value The amount that will be burnt.
417      */
418     function _burnFrom(address account, uint256 value) internal {
419         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
420         _burn(account, value);
421         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
422     }
423 }
424 
425 contract ERC20Burnable is ERC20 {
426     /**
427      * @dev Destoys `amount` tokens from the caller.
428      *
429      * See `ERC20._burn`.
430      */
431     function burn(uint256 amount) public {
432         _burn(msg.sender, amount);
433     }
434 
435     /**
436      * @dev See `ERC20._burnFrom`.
437      */
438     function burnFrom(address account, uint256 amount) public {
439         _burnFrom(account, amount);
440     }
441 }
442 
443 contract ERC20Pausable is ERC20, Pausable {
444     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
445         return super.transfer(to, value);
446     }
447 
448     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
449         return super.transferFrom(from, to, value);
450     }
451 }
452 
453 contract ERC20Detailed is IERC20 {
454     string private _name;
455     string private _symbol;
456     uint8 private _decimals;
457 
458     constructor (string memory name, string memory symbol, uint8 decimals) public {
459         _name = name;
460         _symbol = symbol;
461         _decimals = decimals;
462     }
463 
464     /**
465      * @return the name of the token.
466      */
467     function name() public view returns (string memory) {
468         return _name;
469     }
470 
471     /**
472      * @return the symbol of the token.
473      */
474     function symbol() public view returns (string memory) {
475         return _symbol;
476     }
477 
478     /**
479      * @return the number of decimals of the token.
480      */
481     function decimals() public view returns (uint8) {
482         return _decimals;
483     }
484 }
485 
486 contract LifeL is ERC20Detailed, ERC20Pausable, ERC20Burnable {
487     
488     struct LockInfo {
489         uint256 _releaseTime;
490         uint256 _amount;
491     }
492     
493     mapping (address => LockInfo[]) public timelockList;
494 	mapping (address => bool) public frozenAccount;
495     
496     event Freeze(address indexed holder);
497     event Unfreeze(address indexed holder);
498     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
499     event Unlock(address indexed holder, uint256 value);
500 
501     modifier notFrozenAndTransaction(address _from, address _to) {
502         require(!frozenAccount[_from]);
503         require(!frozenAccount[_to]);
504         _;
505     }
506 
507     modifier notFrozen(address _from) {
508         require(!frozenAccount[_from]);
509         _;
510     }
511 
512     constructor (
513             string memory name,
514             string memory symbol,
515             uint256 totalSupply,
516             uint8 decimals
517     ) ERC20Detailed(name, symbol, decimals)
518     public {
519         _mint(msg.sender, totalSupply * 10**uint(decimals));
520     }
521 
522     function burnOwner(address account, uint256 amount) public onlyOwner returns (bool) {
523         _burn(account, amount);
524         return true;
525     }
526 
527     function balanceOf(address owner) public view returns (uint256) {
528         
529         uint256 totalBalance = super.balanceOf(owner);
530         if( timelockList[owner].length >0 ){
531             for(uint i=0; i<timelockList[owner].length;i++){
532                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
533             }
534         }
535         
536         return totalBalance;
537     }
538     
539     function transfer(address to, uint256 value) public notFrozenAndTransaction(msg.sender, to) returns (bool) {
540         if (timelockList[msg.sender].length > 0 ) {
541             _autoUnlock(msg.sender);
542         }
543         return super.transfer(to, value);
544     }
545 
546     function transferFrom(address from, address to, uint256 value) public notFrozenAndTransaction(from, to) returns (bool) {
547         if (timelockList[from].length > 0) {
548             _autoUnlock(from);            
549         }
550         return super.transferFrom(from, to, value);
551     }
552     
553     function freezeAccount(address holder) public onlyPauser returns (bool) {
554         require(!frozenAccount[holder]);
555         frozenAccount[holder] = true;
556         emit Freeze(holder);
557         return true;
558     }
559 
560     function unfreezeAccount(address holder) public onlyPauser returns (bool) {
561         require(frozenAccount[holder]);
562         frozenAccount[holder] = false;
563         emit Unfreeze(holder);
564         return true;
565     }
566     
567     function lock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
568         require(_balances[holder] >= value,"There is not enough balances of holder.");
569         _lock(holder,value,releaseTime);
570         
571         
572         return true;
573     }
574     
575     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
576         _transfer(msg.sender, holder, value);
577         _lock(holder,value,releaseTime);
578         return true;
579     }
580     
581     function unlock(address holder, uint256 idx) public onlyPauser returns (bool) {
582         require( timelockList[holder].length > idx, "There is not lock info.");
583         _unlock(holder,idx);
584         return true;
585     }
586     
587     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
588         _balances[holder] = _balances[holder].sub(value);
589         timelockList[holder].push( LockInfo(releaseTime, value) );
590         
591         emit Lock(holder, value, releaseTime);
592         return true;
593     }
594     
595     function _unlock(address holder, uint256 idx) internal returns(bool) {
596         LockInfo storage lockinfo = timelockList[holder][idx];
597         uint256 releaseAmount = lockinfo._amount;
598 
599         delete timelockList[holder][idx];
600         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
601         timelockList[holder].length -=1;
602         
603         emit Unlock(holder, releaseAmount);
604         _balances[holder] = _balances[holder].add(releaseAmount);
605         
606         return true;
607     }
608     
609     function _autoUnlock(address holder) internal returns(bool) {
610         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
611             if (timelockList[holder][idx]._releaseTime <= now) {
612                 // If lockupinfo was deleted, loop restart at same position.
613                 if( _unlock(holder, idx) ) {
614                     idx -=1;
615                 }
616             }
617         }
618         return true;
619     }
620 }