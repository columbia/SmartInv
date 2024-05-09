1 pragma solidity ^0.5.3;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /Users/daveappleton/Documents/akombalabs/RevenueShareToken/contracts/RevToken.sol
6 // flattened :  Friday, 22-Mar-19 10:26:32 UTC
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     /**
27      * @dev Multiplies two unsigned integers, reverts on overflow.
28      */
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
31         // benefit is lost if 'b' is also tested.
32         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b);
39 
40         return c;
41     }
42 
43     /**
44      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
45      */
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         // Solidity only automatically asserts when dividing by 0
48         require(b > 0);
49         uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51 
52         return c;
53     }
54 
55     /**
56      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
57      */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b <= a);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Adds two unsigned integers, reverts on overflow.
67      */
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a);
71 
72         return c;
73     }
74 
75     /**
76      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
77      * reverts when dividing by zero.
78      */
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b != 0);
81         return a % b;
82     }
83 }
84 
85 library Roles {
86     struct Role {
87         mapping (address => bool) bearer;
88     }
89 
90     /**
91      * @dev give an account access to this role
92      */
93     function add(Role storage role, address account) internal {
94         require(account != address(0));
95         require(!has(role, account));
96 
97         role.bearer[account] = true;
98     }
99 
100     /**
101      * @dev remove an account's access to this role
102      */
103     function remove(Role storage role, address account) internal {
104         require(account != address(0));
105         require(has(role, account));
106 
107         role.bearer[account] = false;
108     }
109 
110     /**
111      * @dev check if an account has this role
112      * @return bool
113      */
114     function has(Role storage role, address account) internal view returns (bool) {
115         require(account != address(0));
116         return role.bearer[account];
117     }
118 }
119 
120 contract Ownable {
121     address private _owner;
122 
123     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125     /**
126      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
127      * account.
128      */
129     constructor () internal {
130         _owner = msg.sender;
131         emit OwnershipTransferred(address(0), _owner);
132     }
133 
134     /**
135      * @return the address of the owner.
136      */
137     function owner() public view returns (address) {
138         return _owner;
139     }
140 
141     /**
142      * @dev Throws if called by any account other than the owner.
143      */
144     modifier onlyOwner() {
145         require(isOwner());
146         _;
147     }
148 
149     /**
150      * @return true if `msg.sender` is the owner of the contract.
151      */
152     function isOwner() public view returns (bool) {
153         return msg.sender == _owner;
154     }
155 
156     /**
157      * @dev Allows the current owner to relinquish control of the contract.
158      * It will not be possible to call the functions with the `onlyOwner`
159      * modifier anymore.
160      * @notice Renouncing ownership will leave the contract without an owner,
161      * thereby removing any functionality that is only available to the owner.
162      */
163     function renounceOwnership() public onlyOwner {
164         emit OwnershipTransferred(_owner, address(0));
165         _owner = address(0);
166     }
167 
168     /**
169      * @dev Allows the current owner to transfer control of the contract to a newOwner.
170      * @param newOwner The address to transfer ownership to.
171      */
172     function transferOwnership(address newOwner) public onlyOwner {
173         _transferOwnership(newOwner);
174     }
175 
176     /**
177      * @dev Transfers control of the contract to a newOwner.
178      * @param newOwner The address to transfer ownership to.
179      */
180     function _transferOwnership(address newOwner) internal {
181         require(newOwner != address(0));
182         emit OwnershipTransferred(_owner, newOwner);
183         _owner = newOwner;
184     }
185 }
186 
187 contract ERC20 is IERC20 {
188     using SafeMath for uint256;
189 
190     mapping (address => uint256) private _balances;
191 
192     mapping (address => mapping (address => uint256)) private _allowed;
193 
194     uint256 private _totalSupply;
195 
196     /**
197      * @dev Total number of tokens in existence
198      */
199     function totalSupply() public view returns (uint256) {
200         return _totalSupply;
201     }
202 
203     /**
204      * @dev Gets the balance of the specified address.
205      * @param owner The address to query the balance of.
206      * @return A uint256 representing the amount owned by the passed address.
207      */
208     function balanceOf(address owner) public view returns (uint256) {
209         return _balances[owner];
210     }
211 
212     /**
213      * @dev Function to check the amount of tokens that an owner allowed to a spender.
214      * @param owner address The address which owns the funds.
215      * @param spender address The address which will spend the funds.
216      * @return A uint256 specifying the amount of tokens still available for the spender.
217      */
218     function allowance(address owner, address spender) public view returns (uint256) {
219         return _allowed[owner][spender];
220     }
221 
222     /**
223      * @dev Transfer token to a specified address
224      * @param to The address to transfer to.
225      * @param value The amount to be transferred.
226      */
227     function transfer(address to, uint256 value) public returns (bool) {
228         _transfer(msg.sender, to, value);
229         return true;
230     }
231 
232     /**
233      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234      * Beware that changing an allowance with this method brings the risk that someone may use both the old
235      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238      * @param spender The address which will spend the funds.
239      * @param value The amount of tokens to be spent.
240      */
241     function approve(address spender, uint256 value) public returns (bool) {
242         _approve(msg.sender, spender, value);
243         return true;
244     }
245 
246     /**
247      * @dev Transfer tokens from one address to another.
248      * Note that while this function emits an Approval event, this is not required as per the specification,
249      * and other compliant implementations may not emit the event.
250      * @param from address The address which you want to send tokens from
251      * @param to address The address which you want to transfer to
252      * @param value uint256 the amount of tokens to be transferred
253      */
254     function transferFrom(address from, address to, uint256 value) public returns (bool) {
255         _transfer(from, to, value);
256         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
257         return true;
258     }
259 
260     /**
261      * @dev Increase the amount of tokens that an owner allowed to a spender.
262      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
263      * allowed value is better to use this function to avoid 2 calls (and wait until
264      * the first transaction is mined)
265      * From MonolithDAO Token.sol
266      * Emits an Approval event.
267      * @param spender The address which will spend the funds.
268      * @param addedValue The amount of tokens to increase the allowance by.
269      */
270     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
271         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
272         return true;
273     }
274 
275     /**
276      * @dev Decrease the amount of tokens that an owner allowed to a spender.
277      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
278      * allowed value is better to use this function to avoid 2 calls (and wait until
279      * the first transaction is mined)
280      * From MonolithDAO Token.sol
281      * Emits an Approval event.
282      * @param spender The address which will spend the funds.
283      * @param subtractedValue The amount of tokens to decrease the allowance by.
284      */
285     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
286         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
287         return true;
288     }
289 
290     /**
291      * @dev Transfer token for a specified addresses
292      * @param from The address to transfer from.
293      * @param to The address to transfer to.
294      * @param value The amount to be transferred.
295      */
296     function _transfer(address from, address to, uint256 value) internal {
297         require(to != address(0));
298 
299         _balances[from] = _balances[from].sub(value);
300         _balances[to] = _balances[to].add(value);
301         emit Transfer(from, to, value);
302     }
303 
304     /**
305      * @dev Internal function that mints an amount of the token and assigns it to
306      * an account. This encapsulates the modification of balances such that the
307      * proper events are emitted.
308      * @param account The account that will receive the created tokens.
309      * @param value The amount that will be created.
310      */
311     function _mint(address account, uint256 value) internal {
312         require(account != address(0));
313 
314         _totalSupply = _totalSupply.add(value);
315         _balances[account] = _balances[account].add(value);
316         emit Transfer(address(0), account, value);
317     }
318 
319     /**
320      * @dev Internal function that burns an amount of the token of a given
321      * account.
322      * @param account The account whose tokens will be burnt.
323      * @param value The amount that will be burnt.
324      */
325     function _burn(address account, uint256 value) internal {
326         require(account != address(0));
327 
328         _totalSupply = _totalSupply.sub(value);
329         _balances[account] = _balances[account].sub(value);
330         emit Transfer(account, address(0), value);
331     }
332 
333     /**
334      * @dev Approve an address to spend another addresses' tokens.
335      * @param owner The address that owns the tokens.
336      * @param spender The address that will spend the tokens.
337      * @param value The number of tokens that can be spent.
338      */
339     function _approve(address owner, address spender, uint256 value) internal {
340         require(spender != address(0));
341         require(owner != address(0));
342 
343         _allowed[owner][spender] = value;
344         emit Approval(owner, spender, value);
345     }
346 
347     /**
348      * @dev Internal function that burns an amount of the token of a given
349      * account, deducting from the sender's allowance for said account. Uses the
350      * internal burn function.
351      * Emits an Approval event (reflecting the reduced allowance).
352      * @param account The account whose tokens will be burnt.
353      * @param value The amount that will be burnt.
354      */
355     function _burnFrom(address account, uint256 value) internal {
356         _burn(account, value);
357         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
358     }
359 
360     function _sendBatchCS(address[] memory _recipients, uint[] memory _values) internal returns (bool) {
361         require(_recipients.length == _values.length, "Inconsistent array lengths");
362         uint senderBalance = _balances[msg.sender];
363         for (uint i = 0; i < _values.length; i++) {
364             uint value = _values[i];
365             address to = _recipients[i];
366             require(senderBalance >= value,"Not enough balance");        
367             senderBalance = senderBalance - value;
368             _balances[to] += value;
369             emit Transfer(msg.sender, to, value);
370         }
371         _balances[msg.sender] = senderBalance;
372         return true;
373     }
374 }
375 
376 contract PauserRole {
377     using Roles for Roles.Role;
378 
379     event PauserAdded(address indexed account);
380     event PauserRemoved(address indexed account);
381 
382     Roles.Role private _pausers;
383 
384     constructor () internal {
385         _addPauser(msg.sender);
386     }
387 
388     modifier onlyPauser() {
389         require(isPauser(msg.sender));
390         _;
391     }
392 
393     function isPauser(address account) public view returns (bool) {
394         return _pausers.has(account);
395     }
396 
397     function addPauser(address account) public onlyPauser {
398         _addPauser(account);
399     }
400 
401     function renouncePauser() public {
402         _removePauser(msg.sender);
403     }
404 
405     function _addPauser(address account) internal {
406         _pausers.add(account);
407         emit PauserAdded(account);
408     }
409 
410     function _removePauser(address account) internal {
411         _pausers.remove(account);
412         emit PauserRemoved(account);
413     }
414 }
415 
416 contract Pausable is PauserRole {
417     event Paused(address account);
418     event Unpaused(address account);
419 
420     bool private _paused;
421 
422     constructor () internal {
423         _paused = false;
424     }
425 
426     /**
427      * @return true if the contract is paused, false otherwise.
428      */
429     function paused() public view returns (bool) {
430         return _paused;
431     }
432 
433     /**
434      * @dev Modifier to make a function callable only when the contract is not paused.
435      */
436     modifier whenNotPaused() {
437         require(!_paused);
438         _;
439     }
440 
441     /**
442      * @dev Modifier to make a function callable only when the contract is paused.
443      */
444     modifier whenPaused() {
445         require(_paused);
446         _;
447     }
448 
449     /**
450      * @dev called by the owner to pause, triggers stopped state
451      */
452     function pause() public onlyPauser whenNotPaused {
453         _paused = true;
454         emit Paused(msg.sender);
455     }
456 
457     /**
458      * @dev called by the owner to unpause, returns to normal state
459      */
460     function unpause() public onlyPauser whenPaused {
461         _paused = false;
462         emit Unpaused(msg.sender);
463     }
464 }
465 
466 contract Batcher is Ownable{
467 
468     address public batcher;
469 
470     event NewBatcher(address newMinter);
471 
472     modifier ownerOrBatcher()  {
473         require ((msg.sender == batcher) || isOwner(),"not authorised");
474         _;
475     }
476 
477     function setBatcher (address newBatcher) external onlyOwner {
478         batcher = newBatcher;
479         emit NewBatcher(batcher);
480     }
481 
482 }
483 contract ERC20Pausable is ERC20, Pausable {
484     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
485         return super.transfer(to, value);
486     }
487 
488     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
489         return super.transferFrom(from, to, value);
490     }
491 
492     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
493         return super.approve(spender, value);
494     }
495 
496     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
497         return super.increaseAllowance(spender, addedValue);
498     }
499 
500     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
501         return super.decreaseAllowance(spender, subtractedValue);
502     }
503 }
504 
505 contract RevShare is ERC20Pausable, Ownable, Batcher {
506 
507     string  public name     = "HALO Revenue Share";
508     string  public symbol   = "HALO";
509     uint8   public decimals = 0;
510 
511     mapping(address => uint) public lastUpdated;
512     mapping(address => mapping(address=>uint)) public bookedRevenueDue;
513 
514     mapping(address=>uint)[]   public allocations;
515     mapping(address=>bool) public tokensShared;
516     address[]   public tokenList;
517 
518 
519     constructor(address owner_) public {
520         batcher = 0xB6f9E6D9354b0c04E0556A168a8Af07b2439865E;
521         transferOwnership(owner_);
522         _mint(owner_, 1000000);
523     }
524 
525     // call update BEFORE all transfers
526     function update(address whom) private {
527         // safety checks
528         if (lastUpdated[whom] >= allocations.length) return;
529         uint myBalance = balanceOf(whom);
530         if (myBalance == 0) return;
531         uint supply = totalSupply();
532         // get data struct handy
533         mapping(address=>uint) storage myRevenue = allocations[lastUpdated[whom]];
534         mapping(address=>uint) storage myRevenueBooked = bookedRevenueDue[whom];
535         for (uint i = 0; i < tokenList.length; i++) {
536             uint value = myRevenue[tokenList[i]].mul(myBalance).div(supply);
537             if (value != 0) {
538                 myRevenueBooked[tokenList[i]] = myRevenueBooked[tokenList[i]].add(value);
539             }
540         }
541         lastUpdated[whom] = allocations.length;
542     }
543 
544     function transfer(address to, uint value) public returns (bool) {
545         update(msg.sender);
546         update(to);
547         return super.transfer(to,value);
548     }
549 
550     function transferFrom(address from, address to, uint256 value) public returns (bool) {
551         update(from);
552         update(to);
553         return super.transferFrom(from,to,value);
554     }
555 
556     // this function expects an allowance to have been made to allow tokens to be claimed to contract
557     function addRevenueInTokens(ERC20 token, uint value) public onlyOwner {
558         allocations.length += 1;
559         require(token.transferFrom(msg.sender, address(this),value),"cannot slurp the tokens");
560         if (!tokensShared[address(token)]) {
561             tokensShared[address(token)] = true;
562             tokenList.push(address(token));
563         }
564         for (uint period = 0;period < allocations.length; period++) {
565             allocations[period][address(token)] = allocations[period][address(token)].add(value);
566         }
567     }
568 
569     function addRevenueInEther() public payable onlyOwner {
570         allocations.length += 1;
571         require(msg.value > 0,"nothing to do");
572         if (!tokensShared[address(0)]) {
573             tokensShared[address(0)] = true;
574             tokenList.push(address(0));
575         }
576         for (uint period = 0;period < allocations.length; period++) {
577             allocations[period][address(0)] = allocations[period][address(0)].add(msg.value);
578         }
579     }
580 
581     function claimMyEther() public {
582         claimEther(msg.sender);
583     }
584 
585     function claimEther(address payable toWhom) whenNotPaused public {
586         update(msg.sender);
587         uint value = bookedRevenueDue[msg.sender][address(0)];
588         bookedRevenueDue[msg.sender][address(0)] = 0;
589         toWhom.transfer(value);
590     }
591 
592     function claimMyToken(ERC20 token) whenNotPaused public {
593         claimToken(token,msg.sender);
594     }
595 
596     function claimToken(ERC20 token, address toWhom) public {
597         update(msg.sender);
598         uint value = bookedRevenueDue[msg.sender][address(token)];
599         bookedRevenueDue[msg.sender][address(token)] = 0;
600         require(token.transfer(toWhom,value),"Cannot send token");
601     }
602 
603     function sendBatchCS(address[] memory _recipients, uint[] memory _values) public ownerOrBatcher whenNotPaused returns (bool) {
604         return _sendBatchCS(_recipients, _values);
605     }
606 
607 }