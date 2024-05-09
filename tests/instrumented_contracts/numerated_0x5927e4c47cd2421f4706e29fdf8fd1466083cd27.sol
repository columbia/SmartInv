1 pragma solidity ^0.6.0;
2 
3 /**
4  * @title ERC20Basic
5  */
6 interface ERC20Basic {
7     function totalSupply() external view returns (uint256);
8     function balanceOf(address who) external view returns (uint256);
9     function transfer(address to, uint256 value) external returns (bool);
10     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint256);
12     function approve(address spender, uint256 value) external returns (bool);
13     
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 /**
19  * @dev Wrappers over Solidity's arithmetic operations with added overflow
20  * checks.
21  *
22  * Arithmetic operations in Solidity wrap on overflow. This can easily result
23  * in bugs, because programmers usually assume that an overflow raises an
24  * error, which is the standard behavior in high level programming languages.
25  * `SafeMath` restores this intuition by reverting the transaction when an
26  * operation overflows.
27  *
28  * Using this library instead of the unchecked operations eliminates an entire
29  * class of bugs, so it's recommended to use it always.
30  */
31 library SafeMath {
32     /**
33      * @dev Returns the addition of two unsigned integers, reverting on
34      * overflow.
35      *
36      * Counterpart to Solidity's `+` operator.
37      *
38      * Requirements:
39      *
40      * - Addition cannot overflow.
41      */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         require(c >= a, "SafeMath: addition overflow");
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      *
57      * - Subtraction cannot overflow.
58      */
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         return sub(a, b, "SafeMath: subtraction overflow");
61     }
62 
63     /**
64      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
65      * overflow (when the result is negative).
66      *
67      * Counterpart to Solidity's `-` operator.
68      *
69      * Requirements:
70      *
71      * - Subtraction cannot overflow.
72      */
73     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         require(b <= a, errorMessage);
75         uint256 c = a - b;
76 
77         return c;
78     }
79 
80     /**
81      * @dev Returns the multiplication of two unsigned integers, reverting on
82      * overflow.
83      *
84      * Counterpart to Solidity's `*` operator.
85      *
86      * Requirements:
87      *
88      * - Multiplication cannot overflow.
89      */
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92         // benefit is lost if 'b' is also tested.
93         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
94         if (a == 0) {
95             return 0;
96         }
97 
98         uint256 c = a * b;
99         require(c / a == b, "SafeMath: multiplication overflow");
100 
101         return c;
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      *
114      * - The divisor cannot be zero.
115      */
116     function div(uint256 a, uint256 b) internal pure returns (uint256) {
117         return div(a, b, "SafeMath: division by zero");
118     }
119 
120     /**
121      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
122      * division by zero. The result is rounded towards zero.
123      *
124      * Counterpart to Solidity's `/` operator. Note: this function uses a
125      * `revert` opcode (which leaves remaining gas untouched) while Solidity
126      * uses an invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      *
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b > 0, errorMessage);
134         uint256 c = a / b;
135         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * Reverts when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return mod(a, b, "SafeMath: modulo by zero");
154     }
155 
156     /**
157      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
158      * Reverts with custom message when dividing by zero.
159      *
160      * Counterpart to Solidity's `%` operator. This function uses a `revert`
161      * opcode (which leaves remaining gas untouched) while Solidity uses an
162      * invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      *
166      * - The divisor cannot be zero.
167      */
168     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b != 0, errorMessage);
170         return a % b;
171     }
172 }
173 
174 /**
175  * @title Ownable
176  * @dev The Ownable contract has an owner address, and provides basic authorization control
177  * functions, this simplifies the implementation of "user permissions".
178  */
179 contract Ownable {
180     address owner;
181 
182     event OwnershipRenounced(address indexed previousOwner);
183     event OwnershipTransferred(
184         address indexed previousOwner,
185         address indexed newOwner
186     );
187 
188     /**
189     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
190     * account.
191     */
192     constructor() public {
193         owner = msg.sender;
194     }
195 
196     /**
197     * @dev Throws if called by any account other than the owner.
198     */
199     modifier onlyOwner() {
200         require(msg.sender == owner);
201         _;
202     }
203 
204     /**
205     * @dev Allows the current owner to relinquish control of the contract.
206     */
207     function renounceOwnership() public onlyOwner {
208         emit OwnershipRenounced(owner);
209         owner = address(0);
210     }
211 
212     /**
213     * @dev Allows the current owner to transfer control of the contract to a newOwner.
214     * @param _newOwner The address to transfer ownership to.
215     */
216     function transferOwnership(address _newOwner) public onlyOwner {
217         _transferOwnership(_newOwner);
218     }
219 
220     /**
221     * @dev Transfers control of the contract to a newOwner.
222     * @param _newOwner The address to transfer ownership to.
223     */
224     function _transferOwnership(address _newOwner) internal {
225         require(_newOwner != address(0), "transferring to a zero address");
226         emit OwnershipTransferred(owner, _newOwner);
227         owner = _newOwner;
228     }
229 
230 }
231 
232 /**
233  * @title Pausable
234  * @dev Base contract which allows children to implement an emergency stop mechanism.
235  */
236 contract Pausable is Ownable {
237     event Pause();
238     event Unpause();
239 
240     bool public paused = false;
241 
242 
243     /**
244     * @dev Modifier to make a function callable only when the contract is not paused.
245     */
246     modifier whenNotPaused() {
247         require(!paused);
248         _;
249     }
250 
251     /**
252     * @dev Modifier to make a function callable only when the contract is paused.
253     */
254     modifier whenPaused() {
255         require(paused);
256         _;
257     }
258 
259     /**
260     * @dev called by the owner to pause, triggers stopped state
261     */
262     function pause() public onlyOwner whenNotPaused {
263         paused = true;
264         emit Pause();
265     }
266 
267     /**
268     * @dev called by the owner to unpause, returns to normal state
269     */
270     function unpause() public onlyOwner whenPaused {
271         paused = false;
272         emit Unpause();
273     }
274 }
275 
276 
277 /**
278  * @title ERC20 Pausable token
279  */
280 contract PausableToken is ERC20Basic, Pausable {
281     using SafeMath for uint256;
282 
283     mapping(address => uint256) internal balances;
284     mapping (address => mapping (address => uint256)) internal allowed;
285 
286     uint256  internal totalSupply_;
287 
288     /**
289     * @dev total number of tokens in existence
290     */
291     function totalSupply() public override view returns (uint256) {
292         return totalSupply_;
293     }
294 
295     /**
296     * @dev transfer token for a specified address
297     * @param _to The address to transfer to.
298     * @param _value The amount to be transferred.
299     */
300     function transfer(address _to, uint256 _value) public override virtual returns (bool) {
301         require(_to != address(0), "trasferring to zero address");
302         require(_value <= balances[msg.sender], "transfer amount exceeds available balance");
303         require(!paused, "token transfer while paused");
304         balances[msg.sender] = balances[msg.sender].sub(_value);
305         balances[_to] = balances[_to].add(_value);
306         emit Transfer(msg.sender, _to, _value);
307         return true;
308     }
309 
310     /**
311     * @dev Gets the balance of the specified address.
312     * @param _owner The address to query the the balance of.
313     * @return An uint256 representing the amount owned by the passed address.
314     */
315     function balanceOf(address _owner) public override view returns (uint256) {
316         return balances[_owner];
317     }
318 
319     /**
320     * @dev Transfer tokens from one address to another based on allowance
321     * @param _from address The address which you want to send tokens from
322     * @param _to address The address which you want to transfer to
323     * @param _value uint256 the amount of tokens to be transferred
324     */
325     function transferFrom(address _from, address _to, uint256 _value) public override virtual returns (bool) {
326         require(_from != address(0), "from must not be zero address"); 
327         require(_to != address(0), "to must not be zero address"); 
328         require(!paused, "token transfer while paused");
329         require(_value <= allowed[_from][msg.sender], "tranfer amount exceeds allowance");
330         require(_value <= balances[_from], "transfer amount exceeds available balance");
331         balances[_from] = balances[_from].sub(_value);
332         balances[_to] = balances[_to].add(_value);
333         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
334         emit Transfer(_from, _to, _value);
335         return true;
336     }
337 
338     /**
339     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
340     * Because approve/tranferFrom method is susceptible of multiple withdrawal attack,
341     * please be careful when using approve additional amount of tokens.
342     * Before approving additional allowances to a certain address, 
343     * it is desired to check the changes of allowance of the address due to previous transferFrom activities.
344     * @param _spender The address which will spend the funds.
345     * @param _value The amount of tokens to be spent.
346     */
347     function approve(address _spender, uint256 _value) public override returns (bool) {
348         require(_spender != address(0), "approving to a zero address");
349         allowed[msg.sender][_spender] = _value;
350         emit Approval(msg.sender, _spender, _value);
351         return true;
352     }
353 
354     /**
355     * @dev Function to check the amount of tokens that an owner allowed to a spender.
356     * @param _owner address The address which owns the funds.
357     * @param _spender address The address which will spend the funds.
358     * @return A uint256 specifying the amount of tokens still available for the spender.
359     */
360     function allowance(address _owner, address _spender) public override view returns (uint256) {
361         return allowed[_owner][_spender];
362     }
363 
364     /**
365     * @dev Increase the amount of tokens that an owner allowed to a spender.
366     * @param _spender The address which will spend the funds.
367     * @param _addedValue The amount of tokens to increase the allowance by.
368     */
369     function increaseApproval(
370         address _spender,
371         uint _addedValue
372     )
373         public 
374         returns (bool)
375     {
376         require(_spender != address(0), "approving to zero address");
377         allowed[msg.sender][_spender] = (
378             allowed[msg.sender][_spender].add(_addedValue));
379         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
380         return true;
381     }
382 
383     /**
384     * @dev Decrease the amount of tokens that an owner allowed to a spender.
385     * @param _spender The address which will spend the funds.
386     * @param _subtractedValue The amount of tokens to decrease the allowance by.
387     */
388     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool)
389     {
390         require(_spender != address(0), "spender must not be a zero address");
391         uint oldValue = allowed[msg.sender][_spender];
392         if (_subtractedValue > oldValue) {
393             allowed[msg.sender][_spender] = 0;
394         } else {
395             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
396         }
397         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
398         return true;
399     }
400 
401 }
402 
403 /**
404 * @title Mintable token
405 */
406 contract MintableToken is PausableToken {
407     event Mint(address indexed to, uint256 amount);
408     event MintFinished();
409 
410     bool private mintingFinished = false;
411 
412     modifier canMint() {
413         require(!mintingFinished, "minting is finished");
414         _;
415     }
416 
417     /**
418     * @dev Function to mint tokens
419     * @param _to The address that will receive the minted tokens.
420     * @param _amount The amount of tokens to mint.
421     * @return A boolean that indicates if the operation was successful.
422     */
423     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool)
424     {
425         require(_to != address(0), "minting to zero address");
426         totalSupply_ = totalSupply_.add(_amount);
427         balances[_to] = balances[_to].add(_amount);
428         emit Mint(_to, _amount);
429         emit Transfer(address(0), _to, _amount);
430         return true;
431     }
432 
433     /**
434     * @dev Function to stop minting new tokens.
435     * @return True if the operation was successful.
436     */
437     function finishMinting() public onlyOwner canMint returns (bool) {
438         mintingFinished = true;
439         emit MintFinished();
440         return true;
441     }
442 }
443 
444 
445 contract FreezableMintableToken is MintableToken {
446 
447     mapping (address => bool) private frozenAccounts;
448 
449     // total frozen balance per address
450     mapping (address => uint256) private frozenBalance;
451 
452     event FrozenAccount(address target, bool frozen);
453     event TokensFrozen(address indexed account, uint amount);
454     event TokensUnfrozen(address indexed account, uint amount);
455 
456     /**
457      * @dev Freeze the specified address.
458      * @param target The address to freeze.
459      * @param freeze A boolean that indicates if this address is frozen or not.
460      */
461     function freezeAccount(address target, bool freeze) public onlyOwner {
462         frozenAccounts[target] = freeze;
463         emit FrozenAccount(target, freeze);
464     }
465 
466     /**
467      * @dev Gets the balance of frozen tokens at the specified address.
468      */
469     function frozenBalanceOf(address _owner) public view returns (uint256 balance) {
470         return frozenBalance[_owner];
471     }
472 
473     /**
474      * @dev Gets the balance of the specified address which are not frozen and thus transferrable.
475      * @param _owner The address to query the the balance of.
476      * @return balance An uint256 representing the amount owned by the passed address.
477      */
478     function usableBalanceOf(address _owner) public view returns (uint256 balance) {
479         return (balances[_owner].sub(frozenBalance[_owner]));
480     }
481 
482     /**
483      * @dev Send the specified amount of token to the specified address and freeze it.
484      * @param _to Address to which token will be frozen.
485      * @param _amount Amount of token to freeze.
486      */
487     function freezeTo(address _to, uint _amount) public onlyOwner {
488         require(_to != address(0), "freezing a zero address");
489         require(_amount <= balances[msg.sender], "amount exceeds balance");
490 
491         balances[msg.sender] = balances[msg.sender].sub(_amount);
492         balances[_to] = balances[_to].add(_amount);
493         frozenBalance[_to] = frozenBalance[_to].add(_amount);
494 
495         emit Transfer(msg.sender, _to, _amount);
496         emit TokensFrozen(_to, _amount);
497     }
498 
499     /**
500      * @dev Unfreeze freezing tokens at the specified address.
501      * @param _from Address from which frozen tokens are to be released.
502      * @param _amount Amount of frozen tokens to release.
503      */
504     function unfreezeFrom(address _from, uint _amount) public onlyOwner {
505         require(_from != address(0), "unfreezing from zero address");
506         require(_amount <= frozenBalance[_from], "amount exceeds frozen balance");
507 
508         frozenBalance[_from] = frozenBalance[_from].sub(_amount);
509         emit TokensUnfrozen(_from, _amount);
510     }
511 
512 
513     /**
514      * @dev Mint the specified amount of token to the specified address and freeze it.
515      * @param _to Address to which token will be frozen.
516      * @param _amount Amount of token to mint and freeze.
517      * @return A boolean that indicates if the operation was successful.
518      */
519     function mintAndFreeze(address _to, uint _amount) public onlyOwner canMint returns (bool) {
520         totalSupply_ = totalSupply_.add(_amount);
521         balances[_to] = balances[_to].add(_amount);
522         frozenBalance[_to] = frozenBalance[_to].add(_amount);
523 
524         emit Mint(_to, _amount);
525         emit TokensFrozen(_to, _amount);  
526         emit Transfer(address(0), _to, _amount);
527         return true;
528     }  
529     
530     function transfer(address _to, uint256 _value) public override virtual returns (bool) {
531         require(!frozenAccounts[msg.sender], "account is frozen");
532         require(_value <= (balances[msg.sender].sub(frozenBalance[msg.sender])), 
533             "amount exceeds usable balance");
534         super.transfer(_to, _value);
535     }
536 
537     function transferFrom(address _from, address _to, uint256 _value) public override virtual returns (bool) {
538         require(!frozenAccounts[msg.sender], "account is frozen");
539         require(_value <= (balances[_from].sub(frozenBalance[_from])), 
540             "amount to transfer exceeds usable balance");
541         super.transferFrom(_from, _to, _value);
542     }
543 
544 }
545 
546 /**
547  * @title BurnableFreezableMintableToken Token
548  * @dev Token that can be irreversibly burned (destroyed).
549  */
550 contract BurnableFreezableMintableToken is FreezableMintableToken {
551     mapping (address => bool) private blocklistedAccounts;
552 
553     event Burn(address indexed owner, uint256 value);
554 
555     event AccountBlocked(address user);
556     event AccountUnblocked(address user);
557     event BlockedFundsDestroyed(address blockedListedUser, uint destroyedAmount);
558 
559     function transfer(address _to, uint256 _value) public override returns (bool) {
560         require(!blocklistedAccounts[msg.sender], "account is blocklisted");
561         super.transfer(_to, _value);
562     }
563 
564     function transferFrom(address _from, address _to, uint256 _value) public override returns (bool) {
565         require(!blocklistedAccounts[_from], "account is blocklisted");
566         super.transferFrom(_from, _to, _value);
567     }
568     
569     function isBlocklisted(address _maker) public view returns (bool) {
570         return blocklistedAccounts[_maker];
571     } 
572     
573     function blockAccount(address _evilUser) public onlyOwner returns (bool) {
574         require(_evilUser != address(0), "address to block must not be zero address");
575         blocklistedAccounts[_evilUser] = true;
576         emit AccountBlocked(_evilUser);
577         return true;
578     }
579 
580     function unblockAccount(address _clearedUser) public onlyOwner returns (bool) {
581         blocklistedAccounts[_clearedUser] = false;
582         emit AccountUnblocked(_clearedUser);
583         return true;
584     }
585 
586     function destroyBlockedFunds(address _blockListedUser) public onlyOwner returns (bool) {
587         require(blocklistedAccounts[_blockListedUser], "account must be blocklisted");
588         uint dirtyFunds = balanceOf(_blockListedUser);
589         _burn(_blockListedUser, dirtyFunds);
590         emit BlockedFundsDestroyed(_blockListedUser, dirtyFunds);
591         return true;
592     }
593 
594   /**
595    * @dev Burns a specific amount of tokens.
596    * @param _value The amount of token to be burned.
597    */
598     function burn(address _owner, uint256 _value) public onlyOwner {
599         _burn(_owner, _value);
600     }
601   
602     function _burn(address _who, uint256 _value) internal {
603         require(_who != address(0));
604         require(_value <= balances[_who]);
605         balances[_who] = balances[_who].sub(_value);
606         totalSupply_ = totalSupply_.sub(_value);
607         emit Burn(_who, _value);
608         emit Transfer(_who, address(0), _value);
609     }
610 }
611 
612 contract MainToken is BurnableFreezableMintableToken {
613 
614     uint8 constant private DECIMALS = 18;
615     uint constant private INITIAL_SUPPLY = 98000000000 * (10 ** uint(DECIMALS));
616     string constant private NAME = "AllmediCoin";
617     string constant private SYMBOL = "AMDC";
618 
619     constructor() public {
620         address mintAddress = msg.sender;
621         mint(mintAddress, INITIAL_SUPPLY);
622     }
623   
624     function name() public view returns (string memory _name) {
625         return NAME;
626     }
627 
628     function symbol() public view returns (string memory _symbol) {
629         return SYMBOL;
630     }
631 
632     function decimals() public view returns (uint8 _decimals) {
633         return DECIMALS;
634     }
635     
636 }