1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 pragma solidity ^0.5.2;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37      * @dev Multiplies two unsigned integers, reverts on overflow.
38      */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55      */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76      * @dev Adds two unsigned integers, reverts on overflow.
77      */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87      * reverts when dividing by zero.
88      */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity ^0.5.2;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://eips.ethereum.org/EIPS/eip-20
106  * Originally based on code by FirstBlood:
107  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  *
109  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
110  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
111  * compliant implementations may not do it.
112  */
113 contract ERC20 is IERC20 {
114     using SafeMath for uint256;
115 
116     mapping (address => uint256) private _balances;
117 
118     mapping (address => mapping (address => uint256)) private _allowed;
119 
120     uint256 private _totalSupply;
121 
122     /**
123      * @dev Total number of tokens in existence
124      */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130      * @dev Gets the balance of the specified address.
131      * @param owner The address to query the balance of.
132      * @return A uint256 representing the amount owned by the passed address.
133      */
134     function balanceOf(address owner) public view returns (uint256) {
135         return _balances[owner];
136     }
137 
138     /**
139      * @dev Function to check the amount of tokens that an owner allowed to a spender.
140      * @param owner address The address which owns the funds.
141      * @param spender address The address which will spend the funds.
142      * @return A uint256 specifying the amount of tokens still available for the spender.
143      */
144     function allowance(address owner, address spender) public view returns (uint256) {
145         return _allowed[owner][spender];
146     }
147 
148     /**
149      * @dev Transfer token to a specified address
150      * @param to The address to transfer to.
151      * @param value The amount to be transferred.
152      */
153     function transfer(address to, uint256 value) public returns (bool) {
154         _transfer(msg.sender, to, value);
155         return true;
156     }
157 
158     /**
159      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param spender The address which will spend the funds.
165      * @param value The amount of tokens to be spent.
166      */
167     function approve(address spender, uint256 value) public returns (bool) {
168         _approve(msg.sender, spender, value);
169         return true;
170     }
171 
172     /**
173      * @dev Transfer tokens from one address to another.
174      * Note that while this function emits an Approval event, this is not required as per the specification,
175      * and other compliant implementations may not emit the event.
176      * @param from address The address which you want to send tokens from
177      * @param to address The address which you want to transfer to
178      * @param value uint256 the amount of tokens to be transferred
179      */
180     function transferFrom(address from, address to, uint256 value) public returns (bool) {
181         _transfer(from, to, value);
182         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
183         return true;
184     }
185 
186     /**
187      * @dev Increase the amount of tokens that an owner allowed to a spender.
188      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * Emits an Approval event.
193      * @param spender The address which will spend the funds.
194      * @param addedValue The amount of tokens to increase the allowance by.
195      */
196     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
197         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
198         return true;
199     }
200 
201     /**
202      * @dev Decrease the amount of tokens that an owner allowed to a spender.
203      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * Emits an Approval event.
208      * @param spender The address which will spend the funds.
209      * @param subtractedValue The amount of tokens to decrease the allowance by.
210      */
211     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
212         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
213         return true;
214     }
215 
216     /**
217      * @dev Transfer token for a specified addresses
218      * @param from The address to transfer from.
219      * @param to The address to transfer to.
220      * @param value The amount to be transferred.
221      */
222     function _transfer(address from, address to, uint256 value) internal {
223         require(to != address(0));
224 
225         _balances[from] = _balances[from].sub(value);
226         _balances[to] = _balances[to].add(value);
227         emit Transfer(from, to, value);
228     }
229 
230     /**
231      * @dev Internal function that mints an amount of the token and assigns it to
232      * an account. This encapsulates the modification of balances such that the
233      * proper events are emitted.
234      * @param account The account that will receive the created tokens.
235      * @param value The amount that will be created.
236      */
237     function _mint(address account, uint256 value) internal {
238         require(account != address(0));
239 
240         _totalSupply = _totalSupply.add(value);
241         _balances[account] = _balances[account].add(value);
242         emit Transfer(address(0), account, value);
243     }
244 
245     /**
246      * @dev Internal function that burns an amount of the token of a given
247      * account.
248      * @param account The account whose tokens will be burnt.
249      * @param value The amount that will be burnt.
250      */
251     function _burn(address account, uint256 value) internal {
252         require(account != address(0));
253 
254         _totalSupply = _totalSupply.sub(value);
255         _balances[account] = _balances[account].sub(value);
256         emit Transfer(account, address(0), value);
257     }
258 
259     /**
260      * @dev Approve an address to spend another addresses' tokens.
261      * @param owner The address that owns the tokens.
262      * @param spender The address that will spend the tokens.
263      * @param value The number of tokens that can be spent.
264      */
265     function _approve(address owner, address spender, uint256 value) internal {
266         require(spender != address(0));
267         require(owner != address(0));
268 
269         _allowed[owner][spender] = value;
270         emit Approval(owner, spender, value);
271     }
272 
273     /**
274      * @dev Internal function that burns an amount of the token of a given
275      * account, deducting from the sender's allowance for said account. Uses the
276      * internal burn function.
277      * Emits an Approval event (reflecting the reduced allowance).
278      * @param account The account whose tokens will be burnt.
279      * @param value The amount that will be burnt.
280      */
281     function _burnFrom(address account, uint256 value) internal {
282         _burn(account, value);
283         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
284     }
285 }
286 
287 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
288 
289 pragma solidity ^0.5.2;
290 
291 
292 /**
293  * @title ERC20Detailed token
294  * @dev The decimals are only for visualization purposes.
295  * All the operations are done using the smallest and indivisible token unit,
296  * just as on Ethereum all the operations are done in wei.
297  */
298 contract ERC20Detailed is IERC20 {
299     string private _name;
300     string private _symbol;
301     uint8 private _decimals;
302 
303     constructor (string memory name, string memory symbol, uint8 decimals) public {
304         _name = name;
305         _symbol = symbol;
306         _decimals = decimals;
307     }
308 
309     /**
310      * @return the name of the token.
311      */
312     function name() public view returns (string memory) {
313         return _name;
314     }
315 
316     /**
317      * @return the symbol of the token.
318      */
319     function symbol() public view returns (string memory) {
320         return _symbol;
321     }
322 
323     /**
324      * @return the number of decimals of the token.
325      */
326     function decimals() public view returns (uint8) {
327         return _decimals;
328     }
329 }
330 
331 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
332 
333 pragma solidity ^0.5.2;
334 
335 /**
336  * @title Ownable
337  * @dev The Ownable contract has an owner address, and provides basic authorization control
338  * functions, this simplifies the implementation of "user permissions".
339  */
340 contract Ownable {
341     address private _owner;
342 
343     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
344 
345     /**
346      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
347      * account.
348      */
349     constructor () internal {
350         _owner = msg.sender;
351         emit OwnershipTransferred(address(0), _owner);
352     }
353 
354     /**
355      * @return the address of the owner.
356      */
357     function owner() public view returns (address) {
358         return _owner;
359     }
360 
361     /**
362      * @dev Throws if called by any account other than the owner.
363      */
364     modifier onlyOwner() {
365         require(isOwner());
366         _;
367     }
368 
369     /**
370      * @return true if `msg.sender` is the owner of the contract.
371      */
372     function isOwner() public view returns (bool) {
373         return msg.sender == _owner;
374     }
375 
376     /**
377      * @dev Allows the current owner to relinquish control of the contract.
378      * It will not be possible to call the functions with the `onlyOwner`
379      * modifier anymore.
380      * @notice Renouncing ownership will leave the contract without an owner,
381      * thereby removing any functionality that is only available to the owner.
382      */
383     function renounceOwnership() public onlyOwner {
384         emit OwnershipTransferred(_owner, address(0));
385         _owner = address(0);
386     }
387 
388     /**
389      * @dev Allows the current owner to transfer control of the contract to a newOwner.
390      * @param newOwner The address to transfer ownership to.
391      */
392     function transferOwnership(address newOwner) public onlyOwner {
393         _transferOwnership(newOwner);
394     }
395 
396     /**
397      * @dev Transfers control of the contract to a newOwner.
398      * @param newOwner The address to transfer ownership to.
399      */
400     function _transferOwnership(address newOwner) internal {
401         require(newOwner != address(0));
402         emit OwnershipTransferred(_owner, newOwner);
403         _owner = newOwner;
404     }
405 }
406 
407 // File: contracts/QTF.sol
408 
409 pragma solidity 0.5.9;
410 
411 
412 
413 
414 contract QTF is ERC20, ERC20Detailed, Ownable {
415     string private _name = "Quantfury Token";
416     string private _symbol = "QTF";
417     uint8 private _decimals = 8;
418     //global transfer lock
419     bool private _lockTransfer = false;
420 
421     //list of locked transfer holders
422     mapping(address => bool) private _lockedList;
423 
424     modifier onlyPersonalUnlocked() {
425         require(_lockedList[msg.sender]==false); //individual transfer lock
426         _;
427     }
428 
429     modifier onlyGlobalUnlocked() {
430         require(_lockTransfer==false); //global transfer lock
431         _;
432     }
433 
434     constructor() ERC20Detailed(_name, _symbol, _decimals)
435     public
436     {
437         _mint(address(msg.sender), 100000000*(10**uint256(_decimals)));
438     }
439 
440     /**
441      * @dev Show holder status of address
442      * @param holder The address to query the balance of.
443      * @return A boolean that indicates if the operation was successful.
444      */
445     function getPersonalLockStatus(address holder)
446     public
447     view
448     returns (bool)
449     {
450         return _lockedList[holder];
451     }
452 
453     /**
454      * @dev Show global status
455      * @return A boolean that indicates are transfers available or not.
456      */
457     function getGlobalLockStatus()
458     public
459     view
460     returns (bool)
461     {
462         return _lockTransfer;
463     }
464 
465     /**
466      * @dev Transfer token to a specified address
467      * @param to The address to transfer to.
468      * @param value The amount to be transferred.
469      * @return A boolean that indicates if the operation was successful.
470      */
471     function transfer(address to, uint256 value)
472     onlyPersonalUnlocked
473     onlyGlobalUnlocked
474     public
475     returns (bool)
476     {
477         return super.transfer(to, value);
478     }
479 
480     /**
481      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
482      * Beware that changing an allowance with this method brings the risk that someone may use both the old
483      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
484      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
485      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
486      * @param spender The address which will spend the funds.
487      * @param value The amount of tokens to be spent.
488      */
489     function approve(address spender, uint256 value)
490     onlyPersonalUnlocked
491     onlyGlobalUnlocked
492     public
493     returns (bool)
494     {
495         return super.approve(spender, value);
496     }
497 
498     /**
499      * @dev Increase the amount of tokens that an owner allowed to a spender.
500      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
501      * allowed value is better to use this function to avoid 2 calls (and wait until
502      * the first transaction is mined)
503      * From MonolithDAO Token.sol
504      * Emits an Approval event.
505      * @param spender The address which will spend the funds.
506      * @param addedValue The amount of tokens to increase the allowance by.
507      */
508     function increaseAllowance(address spender, uint256 addedValue)
509     onlyPersonalUnlocked
510     onlyGlobalUnlocked
511     public
512     returns (bool)
513     {
514         return super.increaseAllowance(spender, addedValue);
515     }
516 
517     /**
518      * @dev Decrease the amount of tokens that an owner allowed to a spender.
519      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
520      * allowed value is better to use this function to avoid 2 calls (and wait until
521      * the first transaction is mined)
522      * From MonolithDAO Token.sol
523      * Emits an Approval event.
524      * @param spender The address which will spend the funds.
525      * @param subtractedValue The amount of tokens to decrease the allowance by.
526      */
527     function decreaseAllowance(address spender, uint256 subtractedValue)
528     onlyPersonalUnlocked
529     onlyGlobalUnlocked
530     public
531     returns (bool)
532     {
533         return super.decreaseAllowance(spender, subtractedValue);
534     }
535 
536     /**
537      * @dev Transfer tokens from one address to another.
538      * @param from address The address which you want to send tokens from
539      * @param to address The address which you want to transfer to
540      * @param value uint256 the amount of tokens to be transferred
541      */
542     function transferFrom(address from, address to, uint256 value)
543     onlyPersonalUnlocked
544     onlyGlobalUnlocked
545     public
546     returns (bool)
547     {
548         return super.transferFrom(from, to, value);
549     }
550 
551     /**
552      * @dev Transfer tokens from one address to another for client.
553      * @param from address The address which you want to send tokens from
554      * @param to address The address which you want to transfer to
555      * @param value uint256 the amount of tokens to be transferred
556      */
557     function sendFromTo(address from, address to, uint256 value)
558     onlyOwner
559     public
560     returns (bool)
561     {
562         super._transfer(from, to, value);
563         return true;
564     }
565 
566     /**
567      * @dev Function to set status to holder
568      * @param holder The address that will be locked in holder list.
569      * @return A boolean that indicates if the operation was successful.
570      */
571     function setPersonalLockStatus(address holder, bool status)
572     onlyOwner
573     public
574     returns (bool)
575     {
576         _lockedList[holder] = status;
577         emit LockPersonal(msg.sender, holder, now, status);
578         return true;
579     }
580 
581     /**
582      * @dev Function to lock/unlock all transfers
583      * @param status The boolean variable that will be locked any transfers.
584      * @return A boolean that indicates if the operation was successful.
585      */
586     function setGlobalLockStatus(bool status)
587     onlyOwner
588     public
589     returns (bool)
590     {
591         _lockTransfer = status;
592         emit LockGlobal(msg.sender, now, status);
593         return true;
594     }
595 
596 
597     /**
598      * @dev Function to recover token that was sent
599      * @param _token The address of token contract from with was sent.
600      * @param receiver The address of receiver of token.
601      */
602     function recoverSentTokens(address _token, address receiver)
603     onlyOwner
604     public  {
605         IERC20 token = IERC20(_token);
606         token.transfer(receiver, token.balanceOf(address(this)));
607     }
608 
609     event LockPersonal(address indexed changedByAddress, address holder, uint256 time, bool status);
610     event LockGlobal(address indexed changedByAddress, uint256 time, bool status);
611 }