1 pragma solidity ^0.5.0;
2 
3 // File: openzeppelin-solidity/contracts/access/Roles.sol
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
12     }
13 
14     /**
15      * @dev give an account access to this role
16      */
17     function add(Role storage role, address account) internal {
18         require(account != address(0));
19         require(!has(role, account));
20 
21         role.bearer[account] = true;
22     }
23 
24     /**
25      * @dev remove an account's access to this role
26      */
27     function remove(Role storage role, address account) internal {
28         require(account != address(0));
29         require(has(role, account));
30 
31         role.bearer[account] = false;
32     }
33 
34     /**
35      * @dev check if an account has this role
36      * @return bool
37      */
38     function has(Role storage role, address account) internal view returns (bool) {
39         require(account != address(0));
40         return role.bearer[account];
41     }
42 }
43 
44 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
45 
46 contract PauserRole {
47     using Roles for Roles.Role;
48 
49     event PauserAdded(address indexed account);
50     event PauserRemoved(address indexed account);
51 
52     Roles.Role private _pausers;
53 
54     constructor () internal {
55         _addPauser(msg.sender);
56     }
57 
58     modifier onlyPauser() {
59         require(isPauser(msg.sender));
60         _;
61     }
62 
63     function isPauser(address account) public view returns (bool) {
64         return _pausers.has(account);
65     }
66 
67     function addPauser(address account) public onlyPauser {
68         _addPauser(account);
69     }
70 
71     function renouncePauser() public {
72         _removePauser(msg.sender);
73     }
74 
75     function _addPauser(address account) internal {
76         _pausers.add(account);
77         emit PauserAdded(account);
78     }
79 
80     function _removePauser(address account) internal {
81         _pausers.remove(account);
82         emit PauserRemoved(account);
83     }
84 }
85 
86 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
87 
88 /**
89  * @title Pausable
90  * @dev Base contract which allows children to implement an emergency stop mechanism.
91  */
92 contract Pausable is PauserRole {
93     event Paused(address account);
94     event Unpaused(address account);
95 
96     bool private _paused;
97 
98     constructor () internal {
99         _paused = false;
100     }
101 
102     /**
103      * @return true if the contract is paused, false otherwise.
104      */
105     function paused() public view returns (bool) {
106         return _paused;
107     }
108 
109     /**
110      * @dev Modifier to make a function callable only when the contract is not paused.
111      */
112     modifier whenNotPaused() {
113         require(!_paused);
114         _;
115     }
116 
117     /**
118      * @dev Modifier to make a function callable only when the contract is paused.
119      */
120     modifier whenPaused() {
121         require(_paused);
122         _;
123     }
124 
125     /**
126      * @dev called by the owner to pause, triggers stopped state
127      */
128     function pause() public onlyPauser whenNotPaused {
129         _paused = true;
130         emit Paused(msg.sender);
131     }
132 
133     /**
134      * @dev called by the owner to unpause, returns to normal state
135      */
136     function unpause() public onlyPauser whenPaused {
137         _paused = false;
138         emit Unpaused(msg.sender);
139     }
140 }
141 
142 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
143 
144 /**
145  * @title Ownable
146  * @dev The Ownable contract has an owner address, and provides basic authorization control
147  * functions, this simplifies the implementation of "user permissions".
148  */
149 contract Ownable {
150     address private _owner;
151 
152     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
153 
154     /**
155      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
156      * account.
157      */
158     constructor () internal {
159         _owner = msg.sender;
160         emit OwnershipTransferred(address(0), _owner);
161     }
162 
163     /**
164      * @return the address of the owner.
165      */
166     function owner() public view returns (address) {
167         return _owner;
168     }
169 
170     /**
171      * @dev Throws if called by any account other than the owner.
172      */
173     modifier onlyOwner() {
174         require(isOwner());
175         _;
176     }
177 
178     /**
179      * @return true if `msg.sender` is the owner of the contract.
180      */
181     function isOwner() public view returns (bool) {
182         return msg.sender == _owner;
183     }
184 
185     /**
186      * @dev Allows the current owner to relinquish control of the contract.
187      * @notice Renouncing to ownership will leave the contract without an owner.
188      * It will not be possible to call the functions with the `onlyOwner`
189      * modifier anymore.
190      */
191     function renounceOwnership() public onlyOwner {
192         emit OwnershipTransferred(_owner, address(0));
193         _owner = address(0);
194     }
195 
196     /**
197      * @dev Allows the current owner to transfer control of the contract to a newOwner.
198      * @param newOwner The address to transfer ownership to.
199      */
200     function transferOwnership(address newOwner) public onlyOwner {
201         _transferOwnership(newOwner);
202     }
203 
204     /**
205      * @dev Transfers control of the contract to a newOwner.
206      * @param newOwner The address to transfer ownership to.
207      */
208     function _transferOwnership(address newOwner) internal {
209         require(newOwner != address(0));
210         emit OwnershipTransferred(_owner, newOwner);
211         _owner = newOwner;
212     }
213 }
214 
215 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
216 
217 /**
218  * @title SafeMath
219  * @dev Unsigned math operations with safety checks that revert on error
220  */
221 library SafeMath {
222     /**
223     * @dev Multiplies two unsigned integers, reverts on overflow.
224     */
225     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
227         // benefit is lost if 'b' is also tested.
228         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
229         if (a == 0) {
230             return 0;
231         }
232 
233         uint256 c = a * b;
234         require(c / a == b);
235 
236         return c;
237     }
238 
239     /**
240     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
241     */
242     function div(uint256 a, uint256 b) internal pure returns (uint256) {
243         // Solidity only automatically asserts when dividing by 0
244         require(b > 0);
245         uint256 c = a / b;
246         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
247 
248         return c;
249     }
250 
251     /**
252     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
253     */
254     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
255         require(b <= a);
256         uint256 c = a - b;
257 
258         return c;
259     }
260 
261     /**
262     * @dev Adds two unsigned integers, reverts on overflow.
263     */
264     function add(uint256 a, uint256 b) internal pure returns (uint256) {
265         uint256 c = a + b;
266         require(c >= a);
267 
268         return c;
269     }
270 
271     /**
272     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
273     * reverts when dividing by zero.
274     */
275     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
276         require(b != 0);
277         return a % b;
278     }
279 }
280 
281 // File: contracts/AlkionToken.sol
282 
283 /**
284  * @title Alkion Token
285  * Note they can later distribute these tokens as they wish using `transfer` and other
286  * `ERC20` functions.
287  */
288 contract AlkionToken is Pausable, Ownable {
289   	using SafeMath for uint256;
290   	
291 	string internal constant ALREADY_LOCKED = 'Tokens already locked';
292 	string internal constant NOT_LOCKED = 'No tokens locked';
293 	string internal constant AMOUNT_ZERO = 'Amount can not be 0';
294 	string internal constant NOT_OWNER = 'You are not owner';
295 	string internal constant NOT_ADMIN = 'You are not admin';
296 	string internal constant NOT_ENOUGH_TOKEN = 'Not enough token';
297 	string internal constant NOT_ENOUGH_ALLOWED = 'Not enough allowed';
298 	string internal constant INVALID_TARGET_ADDRESS = 'Invalid target address';
299 	string internal constant UNABLE_DEPOSIT = 'Unable to deposit';
300 
301 	string 	public constant name 		= "Alkion Token";
302 	string 	public constant symbol 		= "ALK";
303 	uint8 	public constant decimals 	= 18;
304   
305 	uint256 internal constant INITIAL_SUPPLY = 50000000000 * (10 ** uint256(decimals));
306 	    
307     mapping (address => uint256) internal _balances;
308 
309     mapping (address => mapping (address => uint256)) internal _allowed;
310 
311     uint256 internal _totalSupply;
312     
313     event Transfer(address indexed from, address indexed to, uint256 value);
314     event Approval(address indexed owner, address indexed spender, uint256 value);    		
315 	
316 	// -----
317 	
318 	mapping(address => bytes32[]) internal lockReason;
319 	
320 	uint256 internal sellingTime = 99999999999999;
321 
322     struct lockToken {
323         uint256 amount;
324         uint256 validity;
325         bool claimed;
326     }
327     
328     mapping(address => mapping(bytes32 => lockToken)) internal locked;
329         
330     event Locked(
331         address indexed _of,
332         bytes32 indexed _reason,
333         uint256 _amount,
334         uint256 _validity
335     );
336 
337     event Unlocked(
338         address indexed _of,
339         bytes32 indexed _reason,
340         uint256 _amount
341     );
342     
343     // --
344     
345 	modifier onlyOwner() {
346 		require(isOwner(), NOT_OWNER);
347 		_;
348 	}
349 	
350 	// --
351   
352 	constructor() 
353 		public 
354 	{	
355 		_mint(msg.sender, INITIAL_SUPPLY);	
356 	}
357 		
358 	function startSelling(uint256 _time)
359 		onlyOwner
360 		public 
361 	{
362 		require(_time != 0);
363 		sellingTime = _time;
364 	}
365 	
366 	function whenSelling()
367 		public
368 		view
369 		returns (uint256) 	
370 	{
371 		if(!isOwner()) return 0;
372 		return sellingTime;
373 	}
374 	
375     function totalSupply() 
376     	public 
377     	view 
378     	returns (uint256) 
379     {
380         return _totalSupply;
381     }
382 
383     function balanceOf(address owner) 
384     	public 
385     	view 
386     	returns (uint256 amount) 
387     {
388         amount = _balances[owner];
389         for (uint256 i = 0; i < lockReason[owner].length; i++) {
390             amount = amount.add(tokensLocked(owner, lockReason[owner][i]));
391         }        
392     }
393     
394     function lockedBalanceOf(address _of)
395         public
396         view
397         returns (uint256 amount)
398     {
399         for (uint256 i = 0; i < lockReason[_of].length; i++) {
400             amount = amount.add(tokensLocked(_of, lockReason[_of][i]));
401         }
402     }    
403 
404     function allowance(address owner, address spender) 
405     	public 
406     	view 
407     	returns (uint256) 
408     {
409         return _allowed[owner][spender];
410     }	
411 	
412 	function approve(address spender, uint256 value)
413 		whenNotPaused 
414 		public 
415 		returns (bool) 
416 	{
417         require(spender != address(0));
418         _allowed[msg.sender][spender] = value;
419         emit Approval(msg.sender, spender, value);
420         return true;		
421 	}
422 		
423 	function transferFrom(address from, address to, uint256 value)
424 		whenNotPaused 
425 		public 
426 		returns (bool) 
427 	{
428         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
429         _transfer(from, to, value);
430         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
431         return true;		
432 	}	
433 
434 	function transfer(address to, uint256 value)
435 		whenNotPaused
436 		public
437 		returns (bool) 
438 	{
439         _transfer(msg.sender, to, value);
440         return true;		
441 	}
442 	
443     function transferWithLock(address _from, address _to, bytes32 _reason, uint256 _amount, uint256 _time)
444     	whenNotPaused
445     	onlyOwner
446         public
447         returns (bool)
448     {	        
449 	    require(_amount <= _balances[_from], NOT_ENOUGH_TOKEN);
450 	    require(_to != address(0), INVALID_TARGET_ADDRESS);
451         require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);	            
452         require(_amount != 0, AMOUNT_ZERO);
453             
454         uint256 validUntil = _time; 
455 
456         if (locked[_to][_reason].amount == 0)
457             lockReason[_to].push(_reason);
458 	
459 	    _balances[_from] = _balances[_from].sub(_amount);
460         locked[_to][_reason] = lockToken(_amount, validUntil, false);
461         
462         emit Locked(_to, _reason, _amount, validUntil);
463         return true;
464     }
465     
466     function transferCancelWithLock(address _from, address _to, bytes32 _reason)
467         whenNotPaused
468         onlyOwner
469         public
470         returns (bool)
471     {
472     	uint256 l = tokensLocked(_from, _reason);
473 		require(l > 0, NOT_LOCKED);
474 		
475 		locked[_from][_reason].claimed = true;
476 		_balances[_to] = _balances[_to].add(l);
477 		return true;
478     }
479     
480     function tokensLocked(address _of, bytes32 _reason)
481         public
482         view
483         returns (uint256 amount)
484     {
485         if (!locked[_of][_reason].claimed)
486             amount = locked[_of][_reason].amount;
487     }    
488     
489     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
490         public
491         view
492         returns (uint256 amount)
493     {
494         uint256 t = sellingTime.add(locked[_of][_reason].validity);
495         if (t > _time)
496             amount = locked[_of][_reason].amount;        
497 	}
498         
499     function extendLock(address _to, bytes32 _reason, uint256 _time)
500     	whenNotPaused
501     	onlyOwner
502         public
503         returns (bool)
504     {
505         require(tokensLocked(_to, _reason) > 0, NOT_LOCKED);
506 
507         locked[_to][_reason].validity = locked[_to][_reason].validity.add(_time);
508 
509         emit Locked(_to, _reason, locked[_to][_reason].amount, locked[_to][_reason].validity);
510         return true;
511     } 
512     
513     function tokensUnlockable(address _of, bytes32 _reason)
514         public
515         view
516         returns (uint256 amount)
517     {
518 		uint256 t = sellingTime.add(locked[_of][_reason].validity);
519         if (t <= now && !locked[_of][_reason].claimed)
520             amount = locked[_of][_reason].amount;		        
521     }
522     
523     function unlock(address _of)
524     	whenNotPaused
525     	onlyOwner
526         public
527         returns (uint256 unlockableTokens)
528     {	
529         uint256 lockedTokens;
530 
531         for (uint256 i = 0; i < lockReason[_of].length; i++) {
532             lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);
533             if (lockedTokens > 0) {
534                 unlockableTokens = unlockableTokens.add(lockedTokens);
535                 locked[_of][lockReason[_of][i]].claimed = true;
536                 emit Unlocked(_of, lockReason[_of][i], lockedTokens);
537             }
538         }
539         
540         if (unlockableTokens > 0) {
541 			_balances[_of] = _balances[_of].add(unlockableTokens);
542         }
543     }
544     
545     function countLockedReasons(address _of)
546 		public
547 		view
548 		returns (uint256)    
549     {
550     	return lockReason[_of].length;
551     }
552     
553 	function lockedReason(address _of, uint256 _idx)
554 		public
555 		view
556 		returns (bytes32)
557 	{
558 		if(_idx >= lockReason[_of].length) 
559 			return bytes32(0);
560 		return lockReason[_of][_idx];
561 	}
562 	
563     function lockedTime(address _of, bytes32 _reason)
564         public
565         view
566         returns (uint256 validity)
567     {
568     	validity = 0;
569         if (!locked[_of][_reason].claimed)
570             validity = locked[_of][_reason].validity;
571     }
572     
573     function burn(uint256 value)
574     	whenNotPaused 
575     	public 
576     {
577         _burn(msg.sender, value);
578     }
579 
580     function burnFrom(address from, uint256 value)
581     	whenNotPaused     
582     	public 
583     {
584         _burnFrom(from, value);
585     }
586     
587     function _mint(address account, uint256 value) 
588     	internal 
589     {
590         require(account != address(0));
591 
592         _totalSupply = _totalSupply.add(value);
593         _balances[account] = _balances[account].add(value);
594         emit Transfer(address(0), account, value);
595     }
596         
597     function _transfer(address from, address to, uint256 value) 
598     	internal 
599     {   
600     	require(value != 0, AMOUNT_ZERO); 
601 	    require(value <= _balances[from], NOT_ENOUGH_TOKEN);
602 	    require(to != address(0), INVALID_TARGET_ADDRESS);	            
603         
604         uint256 lockedBalance = lockedBalanceOf(to);
605         require(lockedBalance == 0, UNABLE_DEPOSIT);
606 
607         _balances[from] = _balances[from].sub(value);
608         _balances[to] = _balances[to].add(value);
609         emit Transfer(from, to, value);
610     }    
611     
612     function _burn(address account, uint256 value) 
613     	internal 
614     {
615         require(account != address(0), INVALID_TARGET_ADDRESS);
616         require(value <= _balances[account], NOT_ENOUGH_TOKEN);
617 
618         _totalSupply = _totalSupply.sub(value);
619         _balances[account] = _balances[account].sub(value);
620         emit Transfer(account, address(0), value);
621     }
622 
623     function _burnFrom(address account, uint256 value) 
624     	internal 
625     {
626     	require(value <= _allowed[account][msg.sender], NOT_ENOUGH_ALLOWED);
627         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
628         _burn(account, value);
629         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
630     }            	
631 }