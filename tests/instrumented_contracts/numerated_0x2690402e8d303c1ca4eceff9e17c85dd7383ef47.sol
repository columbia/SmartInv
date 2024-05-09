1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a / b;
18         return c;
19     }
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  * This code is taken from openZeppelin without any changes.
36  */
37 contract Ownable {
38     address public owner;
39 
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43 
44     /**
45      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46      * account.
47      */
48     function Ownable() public {
49         owner = msg.sender;
50     }
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     /**
61      * @dev Allows the current owner to transfer control of the contract to a newOwner.
62      * @param newOwner The address to transfer ownership to.
63      */
64     function transferOwnership(address newOwner) public onlyOwner {
65         require(newOwner != address(0));
66         emit OwnershipTransferred(owner, newOwner);
67         owner = newOwner;
68     }
69 
70 }
71 
72 /**
73  * @title Pausable
74  * @dev Base contract which allows children to implement an emergency stop mechanism.
75  */
76 contract Pausable is Ownable {
77 
78     mapping (address => bool) public unpausedWallet;
79 
80     event Pause();
81     event Unpause();
82 
83     bool public paused = true;
84 
85 
86     /**
87      * @dev Modifier to make a function callable only when the contract is not paused.
88      */
89     modifier whenNotPaused(address _to) {
90         require(!paused||unpausedWallet[msg.sender]||unpausedWallet[_to]);
91         _;
92     }
93 
94     // Add a wallet ignoring the "Exchange pause". Available to the owner of the contract.
95     function setUnpausedWallet(address _wallet, bool mode) public {
96         require(owner == msg.sender || msg.sender == Crowdsale(owner).wallets(uint8(Crowdsale.Roles.manager)));
97         unpausedWallet[_wallet] = mode;
98     }
99 
100     /**
101      * @dev called by the owner to pause, triggers stopped state
102      */
103     function setPause(bool mode) public onlyOwner {
104         if (!paused && mode) {
105             paused = true;
106             emit Pause();
107         }
108         if (paused && !mode) {
109             paused = false;
110             emit Unpause();
111         }
112     }
113 
114 }
115 
116 /**
117  * @title ERC20Basic
118  * @dev Simpler version of ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/179
120  * This code is taken from openZeppelin without any changes.
121  */
122 contract ERC20Basic {
123     function totalSupply() public view returns (uint256);
124     function balanceOf(address who) public view returns (uint256);
125     function transfer(address to, uint256 value) public returns (bool);
126     event Transfer(address indexed from, address indexed to, uint256 value);
127 }
128 
129 /**
130  * @title ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/20
132  * This code is taken from openZeppelin without any changes.
133  */
134 contract ERC20 is ERC20Basic {
135     function allowance(address owner, address spender) public view returns (uint256);
136     function transferFrom(address from, address to, uint256 value) public returns (bool);
137     function approve(address spender, uint256 value) public returns (bool);
138     event Approval(address indexed owner, address indexed spender, uint256 value);
139 }
140 
141 /**
142  * @title Basic token
143  * @dev Basic version of StandardToken, with no allowances.
144  * This code is taken from openZeppelin without any changes.
145  */
146 contract BasicToken is ERC20Basic {
147     using SafeMath for uint256;
148 
149     mapping(address => uint256) balances;
150 
151     uint256 totalSupply_;
152 
153     /**
154     * @dev total number of tokens in existence
155     */
156     function totalSupply() public view returns (uint256) {
157         return totalSupply_;
158     }
159 
160     /**
161     * @dev transfer token for a specified address
162     * @param _to The address to transfer to.
163     * @param _value The amount to be transferred.
164     */
165     function transfer(address _to, uint256 _value) public returns (bool) {
166         require(_to != address(0));
167         require(_value <= balances[msg.sender]);
168 
169         // SafeMath.sub will throw if there is not enough balance.
170         balances[msg.sender] = balances[msg.sender].sub(_value);
171         balances[_to] = balances[_to].add(_value);
172         emit Transfer(msg.sender, _to, _value);
173         return true;
174     }
175 
176     /**
177     * @dev Gets the balance of the specified address.
178     * @param _owner The address to query the the balance of.
179     * @return An uint256 representing the amount owned by the passed address.
180     */
181     function balanceOf(address _owner) public view returns (uint256 balance) {
182         return balances[_owner];
183     }
184 
185 }
186 
187 /**
188 * @title Standard ERC20 token
189 *
190 * @dev Implementation of the basic standard token.
191 * @dev https://github.com/ethereum/EIPs/issues/20
192 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
193 * This code is taken from openZeppelin without any changes.
194 */
195 contract StandardToken is ERC20, BasicToken {
196 
197     mapping (address => mapping (address => uint256)) internal allowed;
198 
199 
200     /**
201      * @dev Transfer tokens from one address to another
202      * @param _from address The address which you want to send tokens from
203      * @param _to address The address which you want to transfer to
204      * @param _value uint256 the amount of tokens to be transferred
205      */
206     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
207         require(_to != address(0));
208         require(_value <= balances[_from]);
209         require(_value <= allowed[_from][msg.sender]);
210 
211         balances[_from] = balances[_from].sub(_value);
212         balances[_to] = balances[_to].add(_value);
213         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
214         emit Transfer(_from, _to, _value);
215         return true;
216     }
217 
218     /**
219      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
220      *
221      * Beware that changing an allowance with this method brings the risk that someone may use both the old
222      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
223      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
224      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225      * @param _spender The address which will spend the funds.
226      * @param _value The amount of tokens to be spent.
227      */
228     function approve(address _spender, uint256 _value) public returns (bool) {
229         allowed[msg.sender][_spender] = _value;
230         emit Approval(msg.sender, _spender, _value);
231         return true;
232     }
233 
234     /**
235      * @dev Function to check the amount of tokens that an owner allowed to a spender.
236      * @param _owner address The address which owns the funds.
237      * @param _spender address The address which will spend the funds.
238      * @return A uint256 specifying the amount of tokens still available for the spender.
239      */
240     function allowance(address _owner, address _spender) public view returns (uint256) {
241         return allowed[_owner][_spender];
242     }
243 
244     /**
245      * @dev Increase the amount of tokens that an owner allowed to a spender.
246      *
247      * approve should be called when allowed[_spender] == 0. To increment
248      * allowed value is better to use this function to avoid 2 calls (and wait until
249      * the first transaction is mined)
250      * From MonolithDAO Token.sol
251      * @param _spender The address which will spend the funds.
252      * @param _addedValue The amount of tokens to increase the allowance by.
253      */
254     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
255         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
256         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257         return true;
258     }
259 
260     /**
261      * @dev Decrease the amount of tokens that an owner allowed to a spender.
262      *
263      * approve should be called when allowed[_spender] == 0. To decrement
264      * allowed value is better to use this function to avoid 2 calls (and wait until
265      * the first transaction is mined)
266      * From MonolithDAO Token.sol
267      * @param _spender The address which will spend the funds.
268      * @param _subtractedValue The amount of tokens to decrease the allowance by.
269      */
270     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
271         uint oldValue = allowed[msg.sender][_spender];
272         if (_subtractedValue > oldValue) {
273             allowed[msg.sender][_spender] = 0;
274         } else {
275             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
276         }
277         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278         return true;
279     }
280 
281 }
282 
283 /**
284  * @title Pausable token
285  * @dev StandardToken modified with pausable transfers.
286  **/
287 contract PausableToken is StandardToken, Pausable {
288 
289     mapping (address => bool) public grantedToSetUnpausedWallet;
290 
291     function transfer(address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {
292         return super.transfer(_to, _value);
293     }
294 
295     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {
296         return super.transferFrom(_from, _to, _value);
297     }
298 
299     function grantToSetUnpausedWallet(address _to, bool permission) public {
300         require(owner == msg.sender || msg.sender == Crowdsale(owner).wallets(uint8(Crowdsale.Roles.manager)));
301         grantedToSetUnpausedWallet[_to] = permission;
302     }
303 
304     // Add a wallet ignoring the "Exchange pause". Available to the owner of the contract.
305     function setUnpausedWallet(address _wallet, bool mode) public {
306         require(owner == msg.sender || grantedToSetUnpausedWallet[msg.sender] || msg.sender == Crowdsale(owner).wallets(uint8(Crowdsale.Roles.manager)));
307         unpausedWallet[_wallet] = mode;
308     }
309 }
310 
311 contract FreezingToken is PausableToken {
312     struct freeze {
313     uint256 amount;
314     uint256 when;
315     }
316 
317 
318     mapping (address => freeze) freezedTokens;
319 
320 
321     // @ Do I have to use the function      no
322     // @ When it is possible to call        any time
323     // @ When it is launched automatically  -
324     // @ Who can call the function          any
325     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount){
326         freeze storage _freeze = freezedTokens[_beneficiary];
327         if(_freeze.when < now) return 0;
328         return _freeze.amount;
329     }
330 
331     // @ Do I have to use the function      no
332     // @ When it is possible to call        any time
333     // @ When it is launched automatically  -
334     // @ Who can call the function          any
335     function defrostDate(address _beneficiary) public view returns (uint256 Date) {
336         freeze storage _freeze = freezedTokens[_beneficiary];
337         if(_freeze.when < now) return 0;
338         return _freeze.when;
339     }
340 
341 
342     // ***CHECK***SCENARIO***
343     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public onlyOwner {
344         freeze storage _freeze = freezedTokens[_beneficiary];
345         _freeze.amount = _amount;
346         _freeze.when = _when;
347     }
348 
349     function transferAndFreeze(address _to, uint256 _value, uint256 _when) external {
350         require(unpausedWallet[msg.sender]);
351         if(_when > 0){
352             freeze storage _freeze = freezedTokens[_to];
353             _freeze.amount = _freeze.amount.add(_value);
354             _freeze.when = (_freeze.when > _when)? _freeze.when: _when;
355         }
356         transfer(_to,_value);
357     }
358 
359     function transfer(address _to, uint256 _value) public returns (bool) {
360         require(balanceOf(msg.sender) >= freezedTokenOf(msg.sender).add(_value));
361         return super.transfer(_to,_value);
362     }
363 
364     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
365         require(balanceOf(_from) >= freezedTokenOf(_from).add(_value));
366         return super.transferFrom( _from,_to,_value);
367     }
368 
369 
370 
371 }
372 
373 /**
374  * @title Mintable token
375  * @dev Simple ERC20 Token example, with mintable token creation
376  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
377  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
378  * This code is taken from openZeppelin without any changes.
379  */
380 contract MintableToken is StandardToken, Ownable {
381     event Mint(address indexed to, uint256 amount);
382     event MintFinished();
383 
384     /**
385      * @dev Function to mint tokens
386      * @param _to The address that will receive the minted tokens.
387      * @param _amount The amount of tokens to mint.
388      * @return A boolean that indicates if the operation was successful.
389      */
390     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
391         totalSupply_ = totalSupply_.add(_amount);
392         balances[_to] = balances[_to].add(_amount);
393         emit Mint(_to, _amount);
394         emit Transfer(address(0), _to, _amount);
395         return true;
396     }
397 }
398 
399 contract MigrationAgent
400 {
401     function migrateFrom(address _from, uint256 _value) public;
402 }
403 
404 contract MigratableToken is BasicToken,Ownable {
405 
406     uint256 public totalMigrated;
407     address public migrationAgent;
408 
409     event Migrate(address indexed _from, address indexed _to, uint256 _value);
410 
411     function setMigrationAgent(address _migrationAgent) public onlyOwner {
412         require(migrationAgent == 0x0);
413         migrationAgent = _migrationAgent;
414     }
415 
416     function migrateInternal(address _holder) internal {
417         require(migrationAgent != 0x0);
418 
419         uint256 value = balances[_holder];
420         balances[_holder] = 0;
421 
422         totalSupply_ = totalSupply_.sub(value);
423         totalMigrated = totalMigrated.add(value);
424 
425         MigrationAgent(migrationAgent).migrateFrom(_holder, value);
426         emit Migrate(_holder,migrationAgent,value);
427     }
428 
429     function migrateAll(address[] _holders) public onlyOwner {
430         for(uint i = 0; i < _holders.length; i++){
431             migrateInternal(_holders[i]);
432         }
433     }
434 
435     // Reissue your tokens.
436     function migrate() public
437     {
438         require(balances[msg.sender] > 0);
439         migrateInternal(msg.sender);
440     }
441 
442 }
443 
444 contract BurnableToken is BasicToken, Ownable {
445 
446     event Burn(address indexed burner, uint256 value);
447 
448     /**
449      * @dev Burns a specific amount of tokens.
450      * @param _value The amount of token to be burned.
451      */
452     function burn(address _beneficiary, uint256 _value) public onlyOwner {
453         require(_value <= balances[_beneficiary]);
454         // no need to require value <= totalSupply, since that would imply the
455         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
456 
457         balances[_beneficiary] = balances[_beneficiary].sub(_value);
458         totalSupply_ = totalSupply_.sub(_value);
459         emit Burn(_beneficiary, _value);
460         emit Transfer(_beneficiary, address(0), _value);
461     }
462 }
463 
464 contract UnburnableListToken is BurnableToken {
465 
466     mapping (address => bool) public grantedToSetUnburnableWallet;
467     mapping (address => bool) public unburnableWallet;
468 
469     function grantToSetUnburnableWallet(address _to, bool permission) public {
470         require(owner == msg.sender || msg.sender == Crowdsale(owner).wallets(uint8(Crowdsale.Roles.manager)));
471         grantedToSetUnburnableWallet[_to] = permission;
472     }
473 
474     // Add a wallet to unburnable list. After adding wallet can not be removed from list. Available to the owner of the contract.
475     function setUnburnableWallet(address _wallet) public {
476         require(owner == msg.sender || grantedToSetUnburnableWallet[msg.sender] || msg.sender == Crowdsale(owner).wallets(uint8(Crowdsale.Roles.manager)));
477         unburnableWallet[_wallet] = true;
478     }
479 
480     /**
481      * @dev Burns a specific amount of tokens.
482      * @param _value The amount of token to be burned.
483      */
484     function burn(address _beneficiary, uint256 _value) public onlyOwner {
485         require(!unburnableWallet[_beneficiary]);
486 
487         return super.burn(_beneficiary, _value);
488     }
489 }
490 
491 /*
492 * Contract that is working with ERC223 tokens
493 */
494 contract ERC223ReceivingContract {
495     function tokenFallback(address _from, uint _value, bytes _data) public;
496 }
497 
498 // (A2)
499 // Contract token
500 contract Token is FreezingToken, MintableToken, MigratableToken, UnburnableListToken {
501     string public constant name = "TOSS";
502 
503     string public constant symbol = "PROOF OF TOSS";
504 
505     uint8 public constant decimals = 18;
506 
507     mapping (address => mapping (address => bool)) public grantedToAllowBlocking; // Address of smart contract that can allow other contracts to block tokens
508     mapping (address => mapping (address => bool)) public allowedToBlocking; // Address of smart contract that can block tokens
509     mapping (address => mapping (address => uint256)) public blocked; // Blocked tokens per blocker
510 
511     event TokenOperationEvent(string operation, address indexed from, address indexed to, uint256 value, address indexed _contract);
512 
513 
514     modifier contractOnly(address _to) {
515         uint256 codeLength;
516 
517         assembly {
518         // Retrieve the size of the code on target address, this needs assembly .
519         codeLength := extcodesize(_to)
520         }
521 
522         require(codeLength > 0);
523 
524         _;
525     }
526 
527     /**
528     * @dev Transfer the specified amount of tokens to the specified address.
529     * Invokes the `tokenFallback` function if the recipient is a contract.
530     * The token transfer fails if the recipient is a contract
531     * but does not implement the `tokenFallback` function
532     * or the fallback function to receive funds.
533     *
534     * @param _to Receiver address.
535     * @param _value Amount of tokens that will be transferred.
536     * @param _data Transaction metadata.
537     */
538 
539     function transferToContract(address _to, uint256 _value, bytes _data) public contractOnly(_to) returns (bool) {
540         // Standard function transfer similar to ERC20 transfer with no _data .
541         // Added due to backwards compatibility reasons .
542 
543 
544         super.transfer(_to, _value);
545 
546         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
547         receiver.tokenFallback(msg.sender, _value, _data);
548 
549         return true;
550     }
551 
552     // @brief Allow another contract to allow another contract to block tokens. Can be revoked
553     // @param _spender another contract address
554     // @param _value amount of approved tokens
555     function grantToAllowBlocking(address _contract, bool permission) contractOnly(_contract) public {
556 
557 
558         grantedToAllowBlocking[msg.sender][_contract] = permission;
559 
560         emit TokenOperationEvent('grant_allow_blocking', msg.sender, _contract, 0, 0);
561     }
562 
563     // @brief Allow another contract to block tokens. Can't be revoked
564     // @param _owner tokens owner
565     // @param _contract another contract address
566     function allowBlocking(address _owner, address _contract) contractOnly(_contract) public {
567 
568 
569         require(_contract != msg.sender && _contract != owner);
570 
571         require(grantedToAllowBlocking[_owner][msg.sender]);
572 
573         allowedToBlocking[_owner][_contract] = true;
574 
575         emit TokenOperationEvent('allow_blocking', _owner, _contract, 0, msg.sender);
576     }
577 
578     // @brief Blocks tokens
579     // @param _blocking The address of tokens which are being blocked
580     // @param _value The blocked token count
581     function blockTokens(address _blocking, uint256 _value) whenNotPaused(_blocking) public {
582         require(allowedToBlocking[_blocking][msg.sender]);
583 
584         require(balanceOf(_blocking) >= freezedTokenOf(_blocking).add(_value) && _value > 0);
585 
586         balances[_blocking] = balances[_blocking].sub(_value);
587         blocked[_blocking][msg.sender] = blocked[_blocking][msg.sender].add(_value);
588 
589         emit Transfer(_blocking, address(0), _value);
590         emit TokenOperationEvent('block', _blocking, 0, _value, msg.sender);
591     }
592 
593     // @brief Unblocks tokens and sends them to the given address (to _unblockTo)
594     // @param _blocking The address of tokens which are blocked
595     // @param _unblockTo The address to send to the blocked tokens after unblocking
596     // @param _value The blocked token count to unblock
597     function unblockTokens(address _blocking, address _unblockTo, uint256 _value) whenNotPaused(_unblockTo) public {
598         require(allowedToBlocking[_blocking][msg.sender]);
599         require(blocked[_blocking][msg.sender] >= _value && _value > 0);
600 
601         blocked[_blocking][msg.sender] = blocked[_blocking][msg.sender].sub(_value);
602         balances[_unblockTo] = balances[_unblockTo].add(_value);
603 
604         emit Transfer(address(0), _blocking, _value);
605 
606         if (_blocking != _unblockTo) {
607             emit Transfer(_blocking, _unblockTo, _value);
608         }
609 
610         emit TokenOperationEvent('unblock', _blocking, _unblockTo, _value, msg.sender);
611     }
612 }
613 
614 // (A3)
615 // Contract for freezing of investors' funds. Hence, investors will be able to withdraw money if the
616 // round does not attain the softcap. From here the wallet of the beneficiary will receive all the
617 // money (namely, the beneficiary, not the manager's wallet).
618 contract RefundVault is Ownable {
619     using SafeMath for uint256;
620 
621     enum State { Active, Refunding, Closed }
622 
623     uint8 round;
624 
625     mapping (uint8 => mapping (address => uint256)) public deposited;
626 
627     State public state;
628 
629     event Closed();
630     event RefundsEnabled();
631     event Refunded(address indexed beneficiary, uint256 weiAmount);
632     event Deposited(address indexed beneficiary, uint256 weiAmount);
633 
634     function RefundVault() public {
635         state = State.Active;
636     }
637 
638     // Depositing funds on behalf of an TokenSale investor. Available to the owner of the contract (Crowdsale Contract).
639     function deposit(address investor) onlyOwner public payable {
640         require(state == State.Active);
641         deposited[round][investor] = deposited[round][investor].add(msg.value);
642         emit Deposited(investor,msg.value);
643     }
644 
645     // Move the collected funds to a specified address. Available to the owner of the contract.
646     function close(address _wallet1, address _wallet2, uint256 _feesValue) onlyOwner public {
647         require(state == State.Active);
648         require(_wallet1 != 0x0);
649         state = State.Closed;
650         emit Closed();
651         if(_wallet2 != 0x0)
652         _wallet2.transfer(_feesValue);
653         _wallet1.transfer(address(this).balance);
654     }
655 
656     // Allow refund to investors. Available to the owner of the contract.
657     function enableRefunds() onlyOwner public {
658         require(state == State.Active);
659         state = State.Refunding;
660         emit RefundsEnabled();
661     }
662 
663     // Return the funds to a specified investor. In case of failure of the round, the investor
664     // should call this method of this contract (RefundVault) or call the method claimRefund of Crowdsale
665     // contract. This function should be called either by the investor himself, or the company
666     // (or anyone) can call this function in the loop to return funds to all investors en masse.
667     function refund(address investor) public {
668         require(state == State.Refunding);
669         uint256 depositedValue = deposited[round][investor];
670         require(depositedValue > 0);
671         deposited[round][investor] = 0;
672         investor.transfer(depositedValue);
673         emit Refunded(investor, depositedValue);
674     }
675 
676     function restart() external onlyOwner {
677         require(state == State.Closed);
678         round++;
679         state = State.Active;
680 
681     }
682 
683     // Destruction of the contract with return of funds to the specified address. Available to
684     // the owner of the contract.
685     function del(address _wallet) external onlyOwner {
686         selfdestruct(_wallet);
687     }
688 }
689 
690 // The contract for freezing tokens for the players and investors..
691 contract PeriodicAllocation is Ownable {
692     using SafeMath for uint256;
693 
694     struct Share {
695         uint256 proportion;
696         uint256 periods;
697         uint256 periodLength;
698     }
699 
700     // How many days to freeze from the moment of finalizing ICO
701     uint256 public unlockStart;
702     uint256 public totalShare;
703 
704     mapping(address => Share) public shares;
705     mapping(address => uint256) public unlocked;
706 
707     ERC20Basic public token;
708 
709     function PeriodicAllocation(ERC20Basic _token) public {
710         token = _token;
711     }
712 
713     function setUnlockStart(uint256 _unlockStart) onlyOwner external {
714         require(unlockStart == 0);
715         require(_unlockStart >= now);
716 
717         unlockStart = _unlockStart;
718     }
719 
720     function addShare(address _beneficiary, uint256 _proportion, uint256 _periods, uint256 _periodLength) onlyOwner external {
721         shares[_beneficiary] = Share(shares[_beneficiary].proportion.add(_proportion),_periods,_periodLength);
722         totalShare = totalShare.add(_proportion);
723     }
724 
725     // If the time of freezing expired will return the funds to the owner.
726     function unlockFor(address _owner) public {
727         require(unlockStart > 0);
728         require(now >= (unlockStart.add(shares[_owner].periodLength)));
729         uint256 share = shares[_owner].proportion;
730         uint256 periodsSinceUnlockStart = (now.sub(unlockStart)).div(shares[_owner].periodLength);
731 
732         if (periodsSinceUnlockStart < shares[_owner].periods) {
733             share = share.div(shares[_owner].periods).mul(periodsSinceUnlockStart);
734         }
735 
736         share = share.sub(unlocked[_owner]);
737 
738         if (share > 0) {
739             uint256 unlockedToken = token.balanceOf(this).mul(share).div(totalShare);
740             totalShare = totalShare.sub(share);
741             unlocked[_owner] += share;
742             token.transfer(_owner,unlockedToken);
743         }
744     }
745 }
746 
747 contract AllocationQueue is Ownable {
748     using SafeMath for uint256;
749 
750     // address => date => tokens
751     mapping(address => mapping(uint256 => uint256)) public queue;
752     uint256 public totalShare;
753 
754     ERC20Basic public token;
755 
756     uint constant DAY_IN_SECONDS = 86400;
757     uint constant YEAR_IN_SECONDS = 31536000;
758     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
759 
760     uint16 constant ORIGIN_YEAR = 1970;
761     uint constant LEAP_YEARS_BEFORE_ORIGIN_YEAR = 477;
762 
763     function AllocationQueue(ERC20Basic _token) public {
764         token = _token;
765     }
766 
767     function isLeapYear(uint16 year) internal pure returns (bool) {
768         if (year % 4 != 0) {
769             return false;
770         }
771         if (year % 100 != 0) {
772             return true;
773         }
774         if (year % 400 != 0) {
775             return false;
776         }
777         return true;
778     }
779 
780     function groupDates(uint256 _date) internal view returns (uint256) {
781         uint secondsAccountedFor = 0;
782 
783         // Year
784         uint year = ORIGIN_YEAR + _date / YEAR_IN_SECONDS;
785         uint numLeapYears = ((year - 1) / 4 - (year - 1) / 100 + (year - 1) / 400) - LEAP_YEARS_BEFORE_ORIGIN_YEAR; // leapYearsBefore(year) - LEAP_YEARS_BEFORE_ORIGIN_YEAR
786 
787         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
788         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
789 
790         while (secondsAccountedFor > _date) {
791             if (isLeapYear(uint16(year - 1))) {
792                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
793             }
794             else {
795                 secondsAccountedFor -= YEAR_IN_SECONDS;
796             }
797             year -= 1;
798         }
799 
800         // Month
801         uint8 month;
802 
803         uint seconds31 = 31 * DAY_IN_SECONDS;
804         uint seconds30 = 30 * DAY_IN_SECONDS;
805         uint secondsFeb = (isLeapYear(uint16(year)) ? 29 : 28) * DAY_IN_SECONDS;
806 
807         if (secondsAccountedFor + seconds31 > _date) {
808             month = 1;
809         } else if (secondsAccountedFor + seconds31 + secondsFeb > _date) {
810             month = 2;
811         } else if (secondsAccountedFor + 2 * seconds31 + secondsFeb > _date) {
812             month = 3;
813         } else if (secondsAccountedFor + 2 * seconds31 + seconds30 + secondsFeb > _date) {
814             month = 4;
815         } else if (secondsAccountedFor + 3 * seconds31 + seconds30 + secondsFeb > _date) {
816             month = 5;
817         } else if (secondsAccountedFor + 3 * seconds31 + 2 * seconds30 + secondsFeb > _date) {
818             month = 6;
819         } else if (secondsAccountedFor + 4 * seconds31 + 2 * seconds30 + secondsFeb > _date) {
820             month = 7;
821         } else if (secondsAccountedFor + 5 * seconds31 + 2 * seconds30 + secondsFeb > _date) {
822             month = 8;
823         } else if (secondsAccountedFor + 5 * seconds31 + 3 * seconds30 + secondsFeb > _date) {
824             month = 9;
825         } else if (secondsAccountedFor + 6 * seconds31 + 3 * seconds30 + secondsFeb > _date) {
826             month = 10;
827         } else if (secondsAccountedFor + 6 * seconds31 + 4 * seconds30 + secondsFeb > _date) {
828             month = 11;
829         } else {
830             month = 12;
831         }
832 
833         return uint256(year) * 100 + uint256(month);
834     }
835 
836     function addShare(address _beneficiary, uint256 _tokens, uint256 _freezeTime) onlyOwner external {
837         require(_beneficiary != 0x0);
838         require(token.balanceOf(this) == totalShare.add(_tokens));
839 
840         uint256 currentDate = groupDates(now);
841         uint256 unfreezeDate = groupDates(now.add(_freezeTime));
842 
843         require(unfreezeDate > currentDate);
844 
845         queue[_beneficiary][unfreezeDate] = queue[_beneficiary][unfreezeDate].add(_tokens);
846         totalShare = totalShare.add(_tokens);
847     }
848 
849     function unlockFor(address _owner, uint256 _date) public {
850         uint256 date = groupDates(_date);
851 
852         require(date <= groupDates(now));
853 
854         uint256 share = queue[_owner][date];
855 
856         queue[_owner][date] = 0;
857 
858         if (share > 0) {
859             token.transfer(_owner,share);
860             totalShare = totalShare.sub(share);
861         }
862     }
863 
864     // Available to unlock funds for the date. Constant.
865     function getShare(address _owner, uint256 _date) public view returns(uint256){
866         uint256 date = groupDates(_date);
867 
868         return queue[_owner][date];
869     }
870 }
871 
872 contract Creator{
873     Token public token = new Token();
874     RefundVault public refund = new RefundVault();
875 
876     function createToken() external returns (Token) {
877         token.transferOwnership(msg.sender);
878         return token;
879     }
880 
881     function createPeriodicAllocation(Token _token) external returns (PeriodicAllocation) {
882         PeriodicAllocation allocation = new PeriodicAllocation(_token);
883         allocation.transferOwnership(msg.sender);
884         return allocation;
885     }
886 
887     function createAllocationQueue(Token _token) external returns (AllocationQueue) {
888         AllocationQueue allocation = new AllocationQueue(_token);
889         allocation.transferOwnership(msg.sender);
890         return allocation;
891     }
892 
893     function createRefund() external returns (RefundVault) {
894         refund.transferOwnership(msg.sender);
895         return refund;
896     }
897 
898 }
899 
900 // Project: toss.pro
901 // Developed by AXIOMAdev.com and CryptoB2B.io
902 // Copying in whole or in part is prohibited
903 
904 // (A1)
905 // The main contract for the sale and management of rounds.
906 // 0000000000000000000000000000000000000000000000000000000000000000
907 contract Crowdsale{
908 
909     uint256 constant USER_UNPAUSE_TOKEN_TIMEOUT =  60 days;
910     uint256 constant FORCED_REFUND_TIMEOUT1     = 400 days;
911     uint256 constant FORCED_REFUND_TIMEOUT2     = 600 days;
912     uint256 constant ROUND_PROLONGATE           =   0 days;
913     uint256 constant BURN_TOKENS_TIME           =  90 days;
914 
915     using SafeMath for uint256;
916 
917     enum TokenSaleType {round1, round2}
918     TokenSaleType public TokenSale = TokenSaleType.round2;
919 
920     //              0             1         2        3        4        5       6       7        8     9     10        11       12
921     enum Roles {beneficiary, accountant, manager, observer, bounty, advisers, team, founders, fund, fees, players, airdrop, referrals}
922 
923     Creator public creator;
924     bool creator2;
925     bool isBegin=false;
926     Token public token;
927     RefundVault public vault;
928     PeriodicAllocation public allocation;
929     AllocationQueue public allocationQueue;
930 
931     bool public isFinalized;
932     bool public isInitialized;
933     bool public isPausedCrowdsale;
934     bool public chargeBonuses;
935 
936     // Initially, all next 7+ roles/wallets are given to the Manager. The Manager is an employee of the company
937     // with knowledge of IT, who publishes the contract and sets it up. However, money and tokens require
938     // a Beneficiary and other roles (Accountant, Team, etc.). The Manager will not have the right
939     // to receive them. To enable this, the Manager must either enter specific wallets here, or perform
940     // this via method changeWallet. In the finalization methods it is written which wallet and
941     // what percentage of tokens are received.
942     address[13] public wallets = [
943 
944     // Beneficiary
945     // Receives all the money (when finalizing Round1 & Round2)
946     0x4e82764a0be4E0859e87cD47eF348e8D892C2567,
947 
948     // Accountant
949     // Receives all the tokens for non-ETH investors (when finalizing Round1 & Round2)
950     0xD29f0aE1621F4Be48C4DF438038E38af546DA498,
951 
952     // Manager
953     // All rights except the rights to receive tokens or money. Has the right to change any other
954     // wallets (Beneficiary, Accountant, ...), but only if the round has not started. Once the
955     // round is initialized, the Manager has lost all rights to change the wallets.
956     // If the TokenSale is conducted by one person, then nothing needs to be changed. Permit all 7 roles
957     // point to a single wallet.
958     msg.sender,
959 
960     // Observer
961     // Has only the right to call paymentsInOtherCurrency (please read the document)
962     0x27609c2e3d9810FdFCe157F2c1d87b717d0b0C10,
963 
964     // Bounty - 1% freeze 2 month
965     0xd7AC0393e2B29D8aC6221CF69c27171aba6278c4,
966 
967     // Advisers 4% freeze 1 month
968     0x765f60E314766Bc25eb2a9F66991Fe867D42A449,
969 
970     // Team, 7%, freeze 50% 6 month, 50% 12 month
971     0xF9f0c53c07803a2670a354F3de88482393ABdBac,
972 
973     // Founders, 11% freeze 50% 6 month, 50% 12 month
974     0x4816b3bA11477e42A81FffA8a4e376e4D1a7f007,
975 
976     // Fund, 12% freeze 50% 2 month, 50% 12 month
977     0xe3C02072f8145DabCd7E7fe769ba1E3e73688ECc,
978 
979     // Fees, 7% money
980     0xEB29e654AFF7658394C9d413dDC66711ADD44F59,
981 
982     // Players and investors, 7% freezed. Unfreeze 1% per month after ICO finished
983     0x6faEc0c1ff412Fd041aB30081Cae677B362bd3c1,
984 
985     // Airdrop, 4% freeze 2 month
986     0x7AA186f397dB8aE1FB80897e4669c1Ea126BA788,
987 
988     // Referrals, 4% no freeze
989     0xAC26988d1573FC6626069578E6A5a4264F76f0C5
990 
991     ];
992 
993 
994 
995     struct Bonus {
996     uint256 value;
997     uint256 procent;
998     }
999 
1000     struct Profit {
1001     uint256 percent;
1002     uint256 duration;
1003     }
1004 
1005     Bonus[] public bonuses;
1006     Profit[] public profits;
1007 
1008 
1009     uint256 public startTime= 1547197200;
1010     uint256 public stopTime= 0;
1011 
1012     // How many tokens (excluding the bonus) are transferred to the investor in exchange for 1 ETH
1013     // **QUINTILLIONS** 10^18 for human, *10**18 for Solidity, 1e18 for MyEtherWallet (MEW).
1014     // Example: if 1ETH = 40.5 Token ==> use 40500 finney
1015     uint256 public rate = 25000 ether;
1016 
1017     // ETH/USD rate in US$
1018     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: ETH/USD=$1000 ==> use 1000*10**18 (Solidity) or 1000 ether or 1000e18 (MEW)
1019     uint256 public exchange  = 150 ether; // not in use
1020 
1021     // If the round does not attain this value before the closing date, the round is recognized as a
1022     // failure and investors take the money back (the founders will not interfere in any way).
1023     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: softcap=15ETH ==> use 15*10**18 (Solidity) or 15e18 (MEW)
1024     uint256 public softCap = 16133 ether;
1025 
1026     // The maximum possible amount of income
1027     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: hardcap=123.45ETH ==> use 123450*10**15 (Solidity) or 12345e15 (MEW)
1028     uint256 public hardCap = 63333 ether;
1029 
1030     // If the last payment is slightly higher than the hardcap, then the usual contracts do
1031     // not accept it, because it goes beyond the hardcap. However it is more reasonable to accept the
1032     // last payment, very slightly raising the hardcap. The value indicates by how many ETH the
1033     // last payment can exceed the hardcap to allow it to be paid. Immediately after this payment, the
1034     // round closes. The funders should write here a small number, not more than 1% of the CAP.
1035     // Can be equal to zero, to cancel.
1036     // **QUINTILLIONS** 10^18 / *10**18 / 1e18
1037     uint256 public overLimit = 20 ether;
1038 
1039     // The minimum possible payment from an investor in ETH. Payments below this value will be rejected.
1040     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: minPay=0.1ETH ==> use 100*10**15 (Solidity) or 100e15 (MEW)
1041     uint256 public minPay = 71 finney;
1042 
1043     uint256 public maxAllProfit = 30;
1044 
1045     uint256 public ethWeiRaised;
1046     uint256 public nonEthWeiRaised;
1047     uint256 public weiRound1;
1048     uint256 public tokenReserved;
1049 
1050     uint256 public totalSaledToken;
1051 
1052     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
1053 
1054     event Finalized();
1055     event Initialized();
1056 
1057     function Crowdsale(Creator _creator) public
1058     {
1059         creator2=true;
1060         creator=_creator;
1061     }
1062 
1063     function onlyAdmin(bool forObserver) internal view {
1064         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender ||
1065         forObserver==true && wallets[uint8(Roles.observer)] == msg.sender);
1066     }
1067 
1068     // Setting of basic parameters, analog of class constructor
1069     // @ Do I have to use the function      see your scenario
1070     // @ When it is possible to call        before Round 1/2
1071     // @ When it is launched automatically  -
1072     // @ Who can call the function          admins
1073     function begin() internal
1074     {
1075         if (isBegin) return;
1076         isBegin=true;
1077 
1078         token = creator.createToken();
1079         allocation = creator.createPeriodicAllocation(token);
1080         allocationQueue = creator.createAllocationQueue(token);
1081 
1082         if (creator2) {
1083             vault = creator.createRefund();
1084         }
1085 
1086         token.setUnpausedWallet(wallets[uint8(Roles.accountant)], true);
1087         token.setUnpausedWallet(wallets[uint8(Roles.manager)], true);
1088         token.setUnpausedWallet(wallets[uint8(Roles.bounty)], true);
1089         token.setUnpausedWallet(wallets[uint8(Roles.advisers)], true);
1090         token.setUnpausedWallet(wallets[uint8(Roles.observer)], true);
1091         token.setUnpausedWallet(wallets[uint8(Roles.players)], true);
1092         token.setUnpausedWallet(wallets[uint8(Roles.airdrop)], true);
1093         token.setUnpausedWallet(wallets[uint8(Roles.fund)], true);
1094         token.setUnpausedWallet(wallets[uint8(Roles.founders)], true);
1095         token.setUnpausedWallet(wallets[uint8(Roles.referrals)], true);
1096 
1097         token.setUnpausedWallet(allocation, true);
1098         token.setUnpausedWallet(allocationQueue, true);
1099 
1100         bonuses.push(Bonus(71 ether, 30));
1101 
1102         profits.push(Profit(15,2 days));
1103         profits.push(Profit(10,2 days));
1104         profits.push(Profit(5,4 days));
1105 
1106     }
1107 
1108 
1109 
1110     // Issue of tokens for the zero round, it is usually called: private pre-sale (Round 0)
1111     // @ Do I have to use the function      may be
1112     // @ When it is possible to call        before Round 1/2 and untill crowdsale end
1113     // @ When it is launched automatically  -
1114     // @ Who can call the function          admins
1115     function privateMint(uint256 _amount) public {
1116         onlyAdmin(false);
1117         require(stopTime == 0);
1118 
1119         uint256 weiAmount = _amount.mul(1 ether).div(rate);
1120         bool withinCap = weiAmount <= hardCap.sub(weiRaised()).add(overLimit);
1121 
1122         require(withinCap);
1123 
1124         begin();
1125 
1126         // update state
1127         ethWeiRaised = ethWeiRaised.add(weiAmount);
1128 
1129         token.mint(wallets[uint8(Roles.accountant)],_amount);
1130         systemWalletsMint(_amount);
1131     }
1132 
1133     // info
1134     function totalSupply() external view returns (uint256){
1135         return token.totalSupply();
1136     }
1137 
1138     // Returns the name of the current round in plain text. Constant.
1139     function getTokenSaleType() external view returns(string){
1140         return (TokenSale == TokenSaleType.round1)?'round1':'round2';
1141     }
1142 
1143     // Transfers the funds of the investor to the contract of return of funds. Internal.
1144     function forwardFunds() internal {
1145         if(address(vault) != 0x0){
1146             vault.deposit.value(msg.value)(msg.sender);
1147         }else {
1148             if(address(this).balance > 0){
1149                 wallets[uint8(Roles.beneficiary)].transfer(address(this).balance);
1150             }
1151         }
1152 
1153     }
1154 
1155     // Check for the possibility of buying tokens. Inside. Constant.
1156     function validPurchase() internal view returns (bool) {
1157 
1158         // The round started and did not end
1159         bool withinPeriod = (now > startTime && stopTime == 0);
1160 
1161         // Rate is greater than or equal to the minimum
1162         bool nonZeroPurchase = msg.value >= minPay;
1163 
1164         // hardCap is not reached, and in the event of a transaction, it will not be exceeded by more than OverLimit
1165         bool withinCap = msg.value <= hardCap.sub(weiRaised()).add(overLimit);
1166 
1167         // round is initialized and no "Pause of trading" is set
1168         return withinPeriod && nonZeroPurchase && withinCap && isInitialized && !isPausedCrowdsale;
1169     }
1170 
1171     // Check for the ability to finalize the round. Constant.
1172     function hasEnded() public view returns (bool) {
1173 
1174         bool capReached = weiRaised() >= hardCap;
1175 
1176         return (stopTime > 0 || capReached) && isInitialized;
1177     }
1178 
1179     // Finalize. Only available to the Manager and the Beneficiary. If the round failed, then
1180     // anyone can call the finalization to unlock the return of funds to investors
1181     // You must call a function to finalize each round (after the Round1 & after the Round2)
1182     // @ Do I have to use the function      yes
1183     // @ When it is possible to call        after end of Round1 & Round2
1184     // @ When it is launched automatically  no
1185     // @ Who can call the function          admins or anybody (if round is failed)
1186     function finalize() public {
1187 
1188         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender || !goalReached());
1189         require(!isFinalized);
1190         require(hasEnded() || ((wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender) && goalReached()));
1191 
1192         isFinalized = true;
1193         finalization();
1194         emit Finalized();
1195     }
1196 
1197     // The logic of finalization. Internal
1198     // @ Do I have to use the function      no
1199     // @ When it is possible to call        -
1200     // @ When it is launched automatically  after end of round
1201     // @ Who can call the function          -
1202     function finalization() internal {
1203 
1204         if (stopTime == 0) {
1205             stopTime = now;
1206         }
1207 
1208         //uint256 feesValue;
1209         // If the goal of the achievement
1210         if (goalReached()) {
1211 
1212             if(address(vault) != 0x0){
1213                 // Send ether to Beneficiary
1214                 vault.close(wallets[uint8(Roles.beneficiary)], wallets[uint8(Roles.fees)], ethWeiRaised.mul(7).div(100)); //7% for fees
1215             }
1216 
1217             // if there is anything to give
1218             if (tokenReserved > 0) {
1219 
1220                 token.mint(wallets[uint8(Roles.accountant)],tokenReserved);
1221 
1222                 // Reset the counter
1223                 tokenReserved = 0;
1224             }
1225 
1226             // If the finalization is Round 1
1227             if (TokenSale == TokenSaleType.round1) {
1228 
1229                 // Reset settings
1230                 isInitialized = false;
1231                 isFinalized = false;
1232 
1233                 // Switch to the second round (to Round2)
1234                 TokenSale = TokenSaleType.round2;
1235 
1236                 // Reset the collection counter
1237                 weiRound1 = weiRaised();
1238                 ethWeiRaised = 0;
1239                 nonEthWeiRaised = 0;
1240 
1241 
1242 
1243             }
1244             else // If the second round is finalized
1245             {
1246 
1247                 // Permission to collect tokens to those who can pick them up
1248                 chargeBonuses = true;
1249 
1250                 totalSaledToken = token.totalSupply();
1251 
1252             }
1253 
1254         }
1255         else if (address(vault) != 0x0) // If they failed round
1256         {
1257             // Allow investors to withdraw their funds
1258 
1259             vault.enableRefunds();
1260         }
1261     }
1262 
1263     // The Manager freezes the tokens for the Team.
1264     // You must call a function to finalize Round 2 (only after the Round2)
1265     // @ Do I have to use the function      yes
1266     // @ When it is possible to call        Round2
1267     // @ When it is launched automatically  -
1268     // @ Who can call the function          admins
1269     function finalize2() public {
1270 
1271         onlyAdmin(false);
1272         require(chargeBonuses);
1273         chargeBonuses = false;
1274 
1275         allocation.addShare(wallets[uint8(Roles.players)], 7, 7, 30 days); // Freeze 7%. Unfreeze 1% per month after ICO finished
1276 
1277         allocation.setUnlockStart(now);
1278     }
1279 
1280 
1281 
1282     // Initializing the round. Available to the manager. After calling the function,
1283     // the Manager loses all rights: Manager can not change the settings (setup), change
1284     // wallets, prevent the beginning of the round, etc. You must call a function after setup
1285     // for the initial round (before the Round1 and before the Round2)
1286     // @ Do I have to use the function      yes
1287     // @ When it is possible to call        before each round
1288     // @ When it is launched automatically  -
1289     // @ Who can call the function          admins
1290     function initialize() public {
1291 
1292         onlyAdmin(false);
1293         // If not yet initialized
1294         require(!isInitialized);
1295         begin();
1296 
1297 
1298         // And the specified start time has not yet come
1299         // If initialization return an error, check the start date!
1300         require(now <= startTime);
1301 
1302         initialization();
1303 
1304         emit Initialized();
1305 
1306         isInitialized = true;
1307     }
1308 
1309     function initialization() internal {
1310         if (address(vault) != 0x0 && vault.state() != RefundVault.State.Active){
1311             vault.restart();
1312         }
1313     }
1314 
1315     // Manually stops the round. Available to the manager.
1316     // @ Do I have to use the function      yes
1317     // @ When it is possible to call        after each round
1318     // @ When it is launched automatically  -
1319     // @ Who can call the function          admins
1320     function stop() public {
1321         onlyAdmin(false);
1322 
1323         require(stopTime == 0 && now > startTime);
1324 
1325         stopTime = now;
1326     }
1327 
1328     // At the request of the investor, we raise the funds (if the round has failed because of the hardcap)
1329     // @ Do I have to use the function      no
1330     // @ When it is possible to call        if round is failed (softcap not reached)
1331     // @ When it is launched automatically  -
1332     // @ Who can call the function          all investors
1333     function claimRefund() external {
1334         require(address(vault) != 0x0);
1335         vault.refund(msg.sender);
1336     }
1337 
1338     // We check whether we collected the necessary minimum funds. Constant.
1339     function goalReached() public view returns (bool) {
1340         return weiRaised() >= softCap;
1341     }
1342 
1343 
1344     // Customize. The arguments are described in the constructor above.
1345     // @ Do I have to use the function      yes
1346     // @ When it is possible to call        before each round
1347     // @ When it is launched automatically  -
1348     // @ Who can call the function          admins
1349     function setup(uint256 _startTime, uint256 _softCap, uint256 _hardCap,
1350     uint256 _rate, uint256 _exchange,
1351     uint256 _maxAllProfit, uint256 _overLimit, uint256 _minPay,
1352     uint256[] _durationTB , uint256[] _percentTB, uint256[] _valueVB, uint256[] _percentVB) public
1353     {
1354 
1355         onlyAdmin(false);
1356         require(!isInitialized);
1357 
1358         begin();
1359 
1360         // Date and time are correct
1361         require(now <= _startTime);
1362         startTime = _startTime;
1363 
1364         // The parameters are correct
1365         require(_softCap <= _hardCap);
1366         softCap = _softCap;
1367         hardCap = _hardCap;
1368 
1369         require(_rate > 0);
1370         rate = _rate;
1371 
1372         overLimit = _overLimit;
1373         minPay = _minPay;
1374         exchange = _exchange;
1375         maxAllProfit = _maxAllProfit;
1376 
1377         require(_valueVB.length == _percentVB.length);
1378         bonuses.length = _valueVB.length;
1379         for(uint256 i = 0; i < _valueVB.length; i++){
1380             bonuses[i] = Bonus(_valueVB[i],_percentVB[i]);
1381         }
1382 
1383         require(_percentTB.length == _durationTB.length);
1384         profits.length = _percentTB.length;
1385         for( i = 0; i < _percentTB.length; i++){
1386             profits[i] = Profit(_percentTB[i],_durationTB[i]);
1387         }
1388 
1389     }
1390 
1391     // Collected funds for the current round. Constant.
1392     function weiRaised() public constant returns(uint256){
1393         return ethWeiRaised.add(nonEthWeiRaised);
1394     }
1395 
1396     // Returns the amount of fees for both phases. Constant.
1397     function weiTotalRaised() external constant returns(uint256){
1398         return weiRound1.add(weiRaised());
1399     }
1400 
1401     // Returns the percentage of the bonus on the current date. Constant.
1402     function getProfitPercent() public constant returns (uint256){
1403         return getProfitPercentForData(now);
1404     }
1405 
1406     // Returns the percentage of the bonus on the given date. Constant.
1407     function getProfitPercentForData(uint256 _timeNow) public constant returns (uint256){
1408         uint256 allDuration;
1409         for(uint8 i = 0; i < profits.length; i++){
1410             allDuration = allDuration.add(profits[i].duration);
1411             if(_timeNow < startTime.add(allDuration)){
1412                 return profits[i].percent;
1413             }
1414         }
1415         return 0;
1416     }
1417 
1418     function getBonuses(uint256 _value) public constant returns (uint256,uint256){
1419         if(bonuses.length == 0 || bonuses[0].value > _value){
1420             return (0,0);
1421         }
1422         uint16 i = 1;
1423         for(i; i < bonuses.length; i++){
1424             if(bonuses[i].value > _value){
1425                 break;
1426             }
1427         }
1428         return (bonuses[i-1].value,bonuses[i-1].procent);
1429     }
1430 
1431     // Remove the "Pause of exchange". Available to the manager at any time. If the
1432     // manager refuses to remove the pause, then 30-120 days after the successful
1433     // completion of the TokenSale, anyone can remove a pause and allow the exchange to continue.
1434     // The manager does not interfere and will not be able to delay the term.
1435     // He can only cancel the pause before the appointed time.
1436     // ***CHECK***SCENARIO***
1437     // @ Do I have to use the function      YES YES YES
1438     // @ When it is possible to call        after end of Token Sale  (or any time - not necessary)
1439     // @ When it is launched automatically  -
1440     // @ Who can call the function          admins or anybody
1441     function tokenUnpause() external {
1442 
1443         require(wallets[uint8(Roles.manager)] == msg.sender
1444         || (stopTime != 0 && now > stopTime.add(USER_UNPAUSE_TOKEN_TIMEOUT) && TokenSale == TokenSaleType.round2 && isFinalized && goalReached()));
1445         token.setPause(false);
1446     }
1447 
1448     // Enable the "Pause of exchange". Available to the manager until the TokenSale is completed.
1449     // The manager cannot turn on the pause, for example, 3 years after the end of the TokenSale.
1450     // ***CHECK***SCENARIO***
1451     // @ Do I have to use the function      no
1452     // @ When it is possible to call        while Round2 not ended
1453     // @ When it is launched automatically  Round0
1454     // @ Who can call the function          admins
1455     function tokenPause() public {
1456         onlyAdmin(false);
1457         require(!isFinalized);
1458         token.setPause(true);
1459     }
1460 
1461     // Pause of sale. Available to the manager.
1462     // @ Do I have to use the function      no
1463     // @ When it is possible to call        during active rounds
1464     // @ When it is launched automatically  -
1465     // @ Who can call the function          admins
1466     function setCrowdsalePause(bool mode) public {
1467         onlyAdmin(false);
1468         isPausedCrowdsale = mode;
1469     }
1470 
1471     // For example - After 5 years of the project's existence, all of us suddenly decided collectively
1472     // (company + investors) that it would be more profitable for everyone to switch to another smart
1473     // contract responsible for tokens. The company then prepares a new token, investors
1474     // disassemble, study, discuss, etc. After a general agreement, the manager allows any investor:
1475     //      - to burn the tokens of the previous contract
1476     //      - generate new tokens for a new contract
1477     // It is understood that after a general solution through this function all investors
1478     // will collectively (and voluntarily) move to a new token.
1479     // @ Do I have to use the function      no
1480     // @ When it is possible to call        only after Token Sale!
1481     // @ When it is launched automatically  -
1482     // @ Who can call the function          admins
1483     function moveTokens(address _migrationAgent) public {
1484         onlyAdmin(false);
1485         token.setMigrationAgent(_migrationAgent);
1486     }
1487 
1488     // @ Do I have to use the function      no
1489     // @ When it is possible to call        only after Token Sale!
1490     // @ When it is launched automatically  -
1491     // @ Who can call the function          admins
1492     function migrateAll(address[] _holders) public {
1493         onlyAdmin(false);
1494         token.migrateAll(_holders);
1495     }
1496 
1497     // Change the address for the specified role.
1498     // Available to any wallet owner except the observer.
1499     // Available to the manager until the round is initialized.
1500     // The Observer's wallet or his own manager can change at any time.
1501     // @ Do I have to use the function      no
1502     // @ When it is possible to call        depend...
1503     // @ When it is launched automatically  -
1504     // @ Who can call the function          staff (all 7+ roles)
1505     function changeWallet(Roles _role, address _wallet) external
1506     {
1507         require(
1508         (msg.sender == wallets[uint8(_role)] && _role != Roles.observer)
1509         ||
1510         (msg.sender == wallets[uint8(Roles.manager)] && (!isInitialized || _role == Roles.observer) && _role != Roles.fees )
1511         );
1512 
1513         wallets[uint8(_role)] = _wallet;
1514     }
1515 
1516 
1517     // The beneficiary at any time can take rights in all roles and prescribe his wallet in all the
1518     // rollers. Thus, he will become the recipient of tokens for the role of Accountant,
1519     // Team, etc. Works at any time.
1520     // @ Do I have to use the function      no
1521     // @ When it is possible to call        any time
1522     // @ When it is launched automatically  -
1523     // @ Who can call the function          only Beneficiary
1524     function resetAllWallets() external{
1525         address _beneficiary = wallets[uint8(Roles.beneficiary)];
1526         require(msg.sender == _beneficiary);
1527         for(uint8 i = 0; i < wallets.length; i++){
1528             if(uint8(Roles.fees) == i || uint8(Roles.team) == i)
1529                 continue;
1530 
1531             wallets[i] = _beneficiary;
1532         }
1533         token.setUnpausedWallet(_beneficiary, true);
1534     }
1535 
1536 
1537     // Burn the investor tokens, if provided by the Token Sale scenario. Limited time available - BURN_TOKENS_TIME
1538     // ***CHECK***SCENARIO***
1539     // @ Do I have to use the function      no
1540     // @ When it is possible to call        any time
1541     // @ When it is launched automatically  -
1542     // @ Who can call the function          admin
1543     function massBurnTokens(address[] _beneficiary, uint256[] _value) external {
1544         onlyAdmin(false);
1545         require(stopTime == 0 || stopTime.add(BURN_TOKENS_TIME) > now);
1546         require(_beneficiary.length == _value.length);
1547         for(uint16 i; i<_beneficiary.length; i++) {
1548             token.burn(_beneficiary[i],_value[i]);
1549         }
1550     }
1551 
1552     // If a little more than a year has elapsed (Round2 start date + 400 days), a smart contract
1553     // will allow you to send all the money to the Beneficiary, if any money is present. This is
1554     // possible if you mistakenly launch the Round2 for 30 years (not 30 days), investors will transfer
1555     // money there and you will not be able to pick them up within a reasonable time. It is also
1556     // possible that in our checked script someone will make unforeseen mistakes, spoiling the
1557     // finalization. Without finalization, money cannot be returned. This is a rescue option to
1558     // get around this problem, but available only after a year (400 days).
1559 
1560     // Another reason - the TokenSale was a failure, but not all ETH investors took their money during the year after.
1561     // Some investors may have lost a wallet key, for example.
1562 
1563     // The method works equally with the Round1 and Round2. When the Round1 starts, the time for unlocking
1564     // the distructVault begins. If the TokenSale is then started, then the term starts anew from the first day of the TokenSale.
1565 
1566     // Next, act independently, in accordance with obligations to investors.
1567 
1568     // Within 400 days (FORCED_REFUND_TIMEOUT1) of the start of the Round, if it fails only investors can take money. After
1569     // the deadline this can also include the company as well as investors, depending on who is the first to use the method.
1570     // @ Do I have to use the function      no
1571     // @ When it is possible to call        -
1572     // @ When it is launched automatically  -
1573     // @ Who can call the function          beneficiary & manager
1574     function distructVault() public {
1575         require(address(vault) != 0x0);
1576         require(stopTime != 0 && !goalReached());
1577 
1578         if (wallets[uint8(Roles.beneficiary)] == msg.sender && (now > startTime.add(FORCED_REFUND_TIMEOUT1))) {
1579             vault.del(wallets[uint8(Roles.beneficiary)]);
1580         }
1581         if (wallets[uint8(Roles.manager)] == msg.sender && (now > startTime.add(FORCED_REFUND_TIMEOUT2))) {
1582             vault.del(wallets[uint8(Roles.manager)]);
1583         }
1584     }
1585 
1586 
1587     // We accept payments other than Ethereum (ETH) and other currencies, for example, Bitcoin (BTC).
1588     // Perhaps other types of cryptocurrency - see the original terms in the white paper and on the TokenSale website.
1589 
1590     // We release tokens on Ethereum. During the Round1 and Round2 with a smart contract, you directly transfer
1591     // the tokens there and immediately, with the same transaction, receive tokens in your wallet.
1592 
1593     // When paying in any other currency, for example in BTC, we accept your money via one common wallet.
1594     // Our manager fixes the amount received for the bitcoin wallet and calls the method of the smart
1595     // contract paymentsInOtherCurrency to inform him how much foreign currency has been received - on a daily basis.
1596     // The smart contract pins the number of accepted ETH directly and the number of BTC. Smart contract
1597     // monitors softcap and hardcap, so as not to go beyond this framework.
1598 
1599     // In theory, it is possible that when approaching hardcap, we will receive a transfer (one or several
1600     // transfers) to the wallet of BTC, that together with previously received money will exceed the hardcap in total.
1601     // In this case, we will refund all the amounts above, in order not to exceed the hardcap.
1602 
1603     // Collection of money in BTC will be carried out via one common wallet. The wallet's address will be published
1604     // everywhere (in a white paper, on the TokenSale website, on Telegram, on Bitcointalk, in this code, etc.)
1605     // Anyone interested can check that the administrator of the smart contract writes down exactly the amount
1606     // in ETH (in equivalent for BTC) there. In theory, the ability to bypass a smart contract to accept money in
1607     // BTC and not register them in ETH creates a possibility for manipulation by the company. Thanks to
1608     // paymentsInOtherCurrency however, this threat is leveled.
1609 
1610     // Any user can check the amounts in BTC and the variable of the smart contract that accounts for this
1611     // (paymentsInOtherCurrency method). Any user can easily check the incoming transactions in a smart contract
1612     // on a daily basis. Any hypothetical tricks on the part of the company can be exposed and panic during the TokenSale,
1613     // simply pointing out the incompatibility of paymentsInOtherCurrency (ie, the amount of ETH + BTC collection)
1614     // and the actual transactions in BTC. The company strictly adheres to the described principles of openness.
1615 
1616     // The company administrator is required to synchronize paymentsInOtherCurrency every working day (but you
1617     // cannot synchronize if there are no new BTC payments). In the case of unforeseen problems, such as
1618     // brakes on the Ethereum network, this operation may be difficult. You should only worry if the
1619     // administrator does not synchronize the amount for more than 96 hours in a row, and the BTC wallet
1620     // receives significant amounts.
1621 
1622     // This scenario ensures that for the sum of all fees in all currencies this value does not exceed hardcap.
1623 
1624     // Addresses for other currencies:
1625     // BTC Address: 3NKfzN4kShB7zpWTe2vzFDY4NuYa1SqdEV
1626 
1627     // ** QUINTILLIONS ** 10^18 / 1**18 / 1e18
1628 
1629     // @ Do I have to use the function      no
1630     // @ When it is possible to call        during active rounds
1631     // @ When it is launched automatically  every day from cryptob2b token software
1632     // @ Who can call the function          admins + observer
1633     function paymentsInOtherCurrency(uint256 _token, uint256 _value) public {
1634         //require(wallets[uint8(Roles.observer)] == msg.sender || wallets[uint8(Roles.manager)] == msg.sender);
1635         onlyAdmin(true);
1636         bool withinPeriod = (now >= startTime && stopTime == 0);
1637 
1638         bool withinCap = _value.add(ethWeiRaised) <= hardCap.add(overLimit);
1639         require(withinPeriod && withinCap && isInitialized);
1640 
1641         nonEthWeiRaised = _value;
1642         tokenReserved = _token;
1643 
1644     }
1645 
1646     function queueMint(address _beneficiary, uint256 _value, uint256 _freezeTime) internal {
1647         token.mint(address(allocationQueue), _value);
1648         allocationQueue.addShare(_beneficiary, _value, _freezeTime);
1649     }
1650 
1651     function systemWalletsMint(uint256 tokens) internal {
1652         // 4% – tokens for Airdrop, freeze 2 month
1653         queueMint(wallets[uint8(Roles.airdrop)], tokens.mul(4).div(50), 60 days);
1654 
1655         // 7% - tokens for Players and Investors
1656         token.mint(address(allocation), tokens.mul(7).div(50));
1657 
1658         // 4% - tokens to Advisers wallet, freeze 1 month
1659         queueMint(wallets[uint8(Roles.advisers)], tokens.mul(4).div(50), 30 days);
1660 
1661         // 7% - tokens to Team wallet, freeze 50% 6 month, 50% 12 month
1662         queueMint(wallets[uint8(Roles.team)], tokens.mul(7).div(2).div(50), 6 * 30 days);
1663         queueMint(wallets[uint8(Roles.team)], tokens.mul(7).div(2).div(50), 365 days);
1664 
1665         // 1% - tokens to Bounty wallet, freeze 2 month
1666         queueMint(wallets[uint8(Roles.bounty)], tokens.mul(1).div(50), 60 days);
1667 
1668         // 11% - tokens to Founders wallet, freeze 50% 6 month, 50% 12 month
1669         queueMint(wallets[uint8(Roles.founders)], tokens.mul(11).div(2).div(50), 6 * 30 days);
1670         queueMint(wallets[uint8(Roles.founders)], tokens.mul(11).div(2).div(50), 365 days);
1671 
1672         // 12% - tokens to Fund wallet, freeze 50% 2 month, 50% 12 month
1673         queueMint(wallets[uint8(Roles.fund)], tokens.mul(12).div(2).div(50), 2 * 30 days);
1674         queueMint(wallets[uint8(Roles.fund)], tokens.mul(12).div(2).div(50), 365 days);
1675 
1676         // 4% - tokens for Referrals
1677         token.mint(wallets[uint8(Roles.referrals)], tokens.mul(4).div(50));
1678     }
1679 
1680     // The function for obtaining smart contract funds in ETH. If all the checks are true, the token is
1681     // transferred to the buyer, taking into account the current bonus.
1682     function buyTokens(address beneficiary) public payable {
1683         require(beneficiary != 0x0);
1684         require(validPurchase());
1685 
1686         uint256 weiAmount = msg.value;
1687 
1688         uint256 ProfitProcent = getProfitPercent();
1689 
1690         uint256 value;
1691         uint256 percent;
1692 
1693         (value, percent) = getBonuses(weiAmount);
1694 
1695         Bonus memory curBonus = Bonus(value, percent);
1696 
1697         uint256 bonus = curBonus.procent;
1698 
1699         // --------------------------------------------------------------------------------------------
1700         // *** Scenario 1 - select max from all bonuses + check maxAllProfit
1701         uint256 totalProfit = (ProfitProcent < bonus) ? bonus : ProfitProcent;
1702 
1703         // --------------------------------------------------------------------------------------------
1704         totalProfit = (totalProfit > maxAllProfit) ? maxAllProfit : totalProfit;
1705 
1706         // calculate token amount to be created
1707         uint256 tokens = weiAmount.mul(rate).mul(totalProfit.add(100)).div(100 ether);
1708 
1709         // update state
1710         ethWeiRaised = ethWeiRaised.add(weiAmount);
1711 
1712         token.mint(beneficiary, tokens);
1713 
1714         systemWalletsMint(tokens);
1715 
1716         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
1717 
1718         forwardFunds();
1719     }
1720 
1721     // buyTokens alias
1722     function () public payable {
1723         buyTokens(msg.sender);
1724     }
1725 
1726 
1727 
1728 }