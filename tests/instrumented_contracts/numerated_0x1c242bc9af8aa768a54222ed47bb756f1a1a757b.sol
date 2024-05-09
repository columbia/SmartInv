1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (_a == 0) {
17             return 0;
18         }
19 
20         uint256 c = _a * _b;
21         assert(c / _a == _b);
22 
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers, truncating the quotient.
28     */
29     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30         // assert(_b > 0); // Solidity automatically throws when dividing by 0
31         uint256 c = _a / _b;
32         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41         assert(_b <= _a);
42         uint256 c = _a - _b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, throws on overflow.
49     */
50     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51         uint256 c = _a + _b;
52         assert(c >= _a);
53 
54         return c;
55     }
56 }
57 
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65     address public owner;
66 
67     event OwnershipRenounced(address indexed previousOwner);
68     event OwnershipTransferred(
69         address indexed previousOwner,
70         address indexed newOwner
71     );
72 
73     /**
74     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75     * account.
76     */
77     constructor() public {
78         owner = msg.sender;
79     }
80 
81     /**
82     * @dev Throws if called by any account other than the owner.
83     */
84     modifier onlyOwner() {
85         require(msg.sender == owner);
86         _;
87     }
88 
89     /**
90     * @dev Allows the current owner to relinquish control of the contract.
91     * @notice Renouncing to ownership will leave the contract without an owner.
92     * It will not be possible to call the functions with the `onlyOwner`
93     * modifier anymore.
94     */
95     function renounceOwnership() public onlyOwner {
96         emit OwnershipRenounced(owner);
97         owner = address(0);
98     }
99 
100     /**
101     * @dev Allows the current owner to transfer control of the contract to a newOwner.
102     * @param _newOwner The address to transfer ownership to.
103     */
104     function transferOwnership(address _newOwner) public onlyOwner {
105         _transferOwnership(_newOwner);
106     }
107 
108     /**
109     * @dev Transfers control of the contract to a newOwner.
110     * @param _newOwner The address to transfer ownership to.
111     */
112     function _transferOwnership(address _newOwner) internal {
113         require(_newOwner != address(0));
114         emit OwnershipTransferred(owner, _newOwner);
115         owner = _newOwner;
116     }
117 }
118 
119 
120 /**
121  * @title Pausable
122  * @dev Base contract which allows children to implement an emergency stop mechanism.
123  */
124 contract Pausable is Ownable {
125     event Pause();
126     event Unpause();
127 
128     bool public paused = false;
129 
130     /**
131     * @dev Modifier to make a function callable only when the contract is not paused.
132     */
133     modifier whenNotPaused() {
134         require(!paused);
135         _;
136     }
137 
138     /**
139     * @dev Modifier to make a function callable only when the contract is paused.
140     */
141     modifier whenPaused() {
142         require(paused);
143         _;
144     }
145 
146     /**
147     * @dev called by the owner to pause, triggers stopped state
148     */
149     function pause() public onlyOwner whenNotPaused {
150         paused = true;
151         emit Pause();
152     }
153 
154     /**
155     * @dev called by the owner to unpause, returns to normal state
156     */
157     function unpause() public onlyOwner whenPaused {
158         paused = false;
159         emit Unpause();
160     }
161 }
162 
163 
164 /**
165 * @title ERC20 interface
166 * @dev see https://github.com/ethereum/EIPs/issues/20
167 */
168 contract ERC20 {
169     function totalSupply() public view returns (uint256);
170 
171     function balanceOf(address _who) public view returns (uint256);
172 
173     function allowance(address _owner, address _spender)
174         public view returns (uint256);
175 
176     function transfer(address _to, uint256 _value) public returns (bool);
177 
178     function approve(address _spender, uint256 _value)
179         public returns (bool);
180 
181     function transferFrom(address _from, address _to, uint256 _value)
182         public returns (bool);
183 
184     event Transfer(
185         address indexed from,
186         address indexed to,
187         uint256 value
188     );
189 
190     event Approval(
191         address indexed owner,
192         address indexed spender,
193         uint256 value
194     );
195 }
196 
197 /**
198 * @title Standard ERC20 token
199 *
200 * @dev Implementation of the basic standard token.
201 * https://github.com/ethereum/EIPs/issues/20
202 * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
203 */
204 contract StandardToken is ERC20 {
205     using SafeMath for uint256;
206 
207     mapping(address => uint256) balances;
208 
209     mapping (address => mapping (address => uint256)) internal allowed;
210 
211     uint256 totalSupply_;
212 
213     /**
214     * @dev Total number of tokens in existence
215     */
216     function totalSupply() public view returns (uint256) {
217         return totalSupply_;
218     }
219 
220     /**
221     * @dev Gets the balance of the specified address.
222     * @param _owner The address to query the the balance of.
223     * @return An uint256 representing the amount owned by the passed address.
224     */
225     function balanceOf(address _owner) public view returns (uint256) {
226         return balances[_owner];
227     }
228 
229     /**
230     * @dev Function to check the amount of tokens that an owner allowed to a spender.
231     * @param _owner address The address which owns the funds.
232     * @param _spender address The address which will spend the funds.
233     * @return A uint256 specifying the amount of tokens still available for the spender.
234     */
235     function allowance(
236         address _owner,
237         address _spender
238     )
239         public
240         view
241         returns (uint256)
242     {
243         return allowed[_owner][_spender];
244     }
245 
246     /**
247     * @dev Transfer token for a specified address
248     * @param _to The address to transfer to.
249     * @param _value The amount to be transferred.
250     */
251     function transfer(address _to, uint256 _value) public returns (bool) {
252         require(_value <= balances[msg.sender]);
253         require(_to != address(0));
254 
255         balances[msg.sender] = balances[msg.sender].sub(_value);
256         balances[_to] = balances[_to].add(_value);
257         emit Transfer(msg.sender, _to, _value);
258         return true;
259     }
260 
261     /**
262     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
263     * Beware that changing an allowance with this method brings the risk that someone may use both the old
264     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
265     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
266     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267     * @param _spender The address which will spend the funds.
268     * @param _value The amount of tokens to be spent.
269     */
270     function approve(address _spender, uint256 _value) public returns (bool) {
271         allowed[msg.sender][_spender] = _value;
272         emit Approval(msg.sender, _spender, _value);
273         return true;
274     }
275 
276     /**
277     * @dev Transfer tokens from one address to another
278     * @param _from address The address which you want to send tokens from
279     * @param _to address The address which you want to transfer to
280     * @param _value uint256 the amount of tokens to be transferred
281     */
282     function transferFrom(
283         address _from,
284         address _to,
285         uint256 _value
286     )
287         public
288         returns (bool)
289     {
290         require(_value <= balances[_from]);
291         require(_value <= allowed[_from][msg.sender]);
292         require(_to != address(0));
293 
294         balances[_from] = balances[_from].sub(_value);
295         balances[_to] = balances[_to].add(_value);
296         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
297         emit Transfer(_from, _to, _value);
298         return true;
299     }
300 
301     /**
302     * @dev Increase the amount of tokens that an owner allowed to a spender.
303     * approve should be called when allowed[_spender] == 0. To increment
304     * allowed value is better to use this function to avoid 2 calls (and wait until
305     * the first transaction is mined)
306     * From MonolithDAO Token.sol
307     * @param _spender The address which will spend the funds.
308     * @param _addedValue The amount of tokens to increase the allowance by.
309     */
310     function increaseApproval(
311         address _spender,
312         uint256 _addedValue
313     )
314         public
315         returns (bool)
316     {
317         allowed[msg.sender][_spender] = (
318         allowed[msg.sender][_spender].add(_addedValue));
319         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
320         return true;
321     }
322 
323     /**
324     * @dev Decrease the amount of tokens that an owner allowed to a spender.
325     * approve should be called when allowed[_spender] == 0. To decrement
326     * allowed value is better to use this function to avoid 2 calls (and wait until
327     * the first transaction is mined)
328     * From MonolithDAO Token.sol
329     * @param _spender The address which will spend the funds.
330     * @param _subtractedValue The amount of tokens to decrease the allowance by.
331     */
332     function decreaseApproval(
333         address _spender,
334         uint256 _subtractedValue
335     )
336         public
337         returns (bool)
338     {
339         uint256 oldValue = allowed[msg.sender][_spender];
340         if (_subtractedValue >= oldValue) {
341             allowed[msg.sender][_spender] = 0;
342         } else {
343             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
344         }
345         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
346         return true;
347     }
348 
349 }
350 
351 
352 /**
353 * @title Pausable token
354 * @dev StandardToken modified with pausable transfers.
355 **/
356 contract PausableERC20Token is StandardToken, Pausable {
357 
358     function transfer(
359         address _to,
360         uint256 _value
361     )
362         public
363         whenNotPaused
364         returns (bool)
365     {
366         return super.transfer(_to, _value);
367     }
368 
369     function transferFrom(
370         address _from,
371         address _to,
372         uint256 _value
373     )
374         public
375         whenNotPaused
376         returns (bool)
377     {
378         return super.transferFrom(_from, _to, _value);
379     }
380 
381     function approve(
382         address _spender,
383         uint256 _value
384     )
385         public
386         whenNotPaused
387         returns (bool)
388     {
389         return super.approve(_spender, _value);
390     }
391 
392     function increaseApproval(
393         address _spender,
394         uint _addedValue
395     )
396         public
397         whenNotPaused
398         returns (bool success)
399     {
400         return super.increaseApproval(_spender, _addedValue);
401     }
402 
403     function decreaseApproval(
404         address _spender,
405         uint _subtractedValue
406     )
407         public
408         whenNotPaused
409         returns (bool success)
410     {
411         return super.decreaseApproval(_spender, _subtractedValue);
412     }
413 }
414 
415 
416 /**
417 * @title Burnable Pausable Token
418 * @dev Pausable Token that can be irreversibly burned (destroyed).
419 */
420 contract BurnablePausableERC20Token is PausableERC20Token {
421 
422     mapping (address => mapping (address => uint256)) internal allowedBurn;
423 
424     event Burn(address indexed burner, uint256 value);
425 
426     event ApprovalBurn(
427         address indexed owner,
428         address indexed spender,
429         uint256 value
430     );
431 
432     function allowanceBurn(
433         address _owner,
434         address _spender
435     )
436         public
437         view
438         returns (uint256)
439     {
440         return allowedBurn[_owner][_spender];
441     }
442 
443     function approveBurn(address _spender, uint256 _value) public returns (bool) {
444         allowedBurn[msg.sender][_spender] = _value;
445         emit ApprovalBurn(msg.sender, _spender, _value);
446         return true;
447     }
448 
449     /**
450     * @dev Burns a specific amount of tokens.
451     * @param _value The amount of token to be burned.
452     */
453     function burn(
454         uint256 _value
455     ) 
456         public
457         whenNotPaused
458     {
459         _burn(msg.sender, _value);
460     }
461 
462     /**
463     * @dev Burns a specific amount of tokens from the target address and decrements allowance
464     * @param _from address The address which you want to send tokens from
465     * @param _value uint256 The amount of token to be burned
466     */
467     function burnFrom(
468         address _from, 
469         uint256 _value
470     ) 
471         public 
472         whenNotPaused
473     {
474         require(_value <= allowedBurn[_from][msg.sender]);
475         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
476         // this function needs to emit an event with the updated approval.
477         allowedBurn[_from][msg.sender] = allowedBurn[_from][msg.sender].sub(_value);
478         _burn(_from, _value);
479     }
480 
481     function _burn(
482         address _who, 
483         uint256 _value
484     ) 
485         internal 
486         whenNotPaused
487     {
488         require(_value <= balances[_who]);
489         // no need to require value <= totalSupply, since that would imply the
490         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
491 
492         balances[_who] = balances[_who].sub(_value);
493         totalSupply_ = totalSupply_.sub(_value);
494         emit Burn(_who, _value);
495         emit Transfer(_who, address(0), _value);
496     }
497 
498     function increaseBurnApproval(
499         address _spender,
500         uint256 _addedValue
501     )
502         public
503         returns (bool)
504     {
505         allowedBurn[msg.sender][_spender] = (
506         allowedBurn[msg.sender][_spender].add(_addedValue));
507         emit ApprovalBurn(msg.sender, _spender, allowedBurn[msg.sender][_spender]);
508         return true;
509     }
510 
511     function decreaseBurnApproval(
512         address _spender,
513         uint256 _subtractedValue
514     )
515         public
516         returns (bool)
517     {
518         uint256 oldValue = allowedBurn[msg.sender][_spender];
519         if (_subtractedValue >= oldValue) {
520             allowedBurn[msg.sender][_spender] = 0;
521         } else {
522             allowedBurn[msg.sender][_spender] = oldValue.sub(_subtractedValue);
523         }
524         emit ApprovalBurn(msg.sender, _spender, allowedBurn[msg.sender][_spender]);
525         return true;
526     }
527 }
528 
529 contract FreezableBurnablePausableERC20Token is BurnablePausableERC20Token {
530     mapping (address => bool) public frozenAccount;
531     event FrozenFunds(address target, bool frozen);
532 
533     function freezeAccount(
534         address target,
535         bool freeze
536     )
537         public
538         onlyOwner
539     {
540         frozenAccount[target] = freeze;
541         emit FrozenFunds(target, freeze);
542     }
543 
544     function transfer(
545         address _to,
546         uint256 _value
547     )
548         public
549         whenNotPaused
550         returns (bool)
551     {
552         require(!frozenAccount[msg.sender], "Sender account freezed");
553         require(!frozenAccount[_to], "Receiver account freezed");
554 
555         return super.transfer(_to, _value);
556     }
557 
558     function transferFrom(
559         address _from,
560         address _to,
561         uint256 _value
562     )
563         public
564         whenNotPaused
565         returns (bool)
566     {
567         require(!frozenAccount[msg.sender], "Sender account freezed");
568         require(!frozenAccount[_from], "From account freezed");
569         require(!frozenAccount[_to], "Receiver account freezed");
570 
571         return super.transferFrom(_from, _to, _value);
572     }
573 
574     function burn(
575         uint256 _value
576     ) 
577         public
578         whenNotPaused
579     {
580         require(!frozenAccount[msg.sender], "Sender account freezed");
581 
582         return super.burn(_value);
583     }
584 
585     function burnFrom(
586         address _from, 
587         uint256 _value
588     ) 
589         public 
590         whenNotPaused
591     {
592         require(!frozenAccount[msg.sender], "Sender account freezed");
593         require(!frozenAccount[_from], "From account freezed");
594 
595         return super.burnFrom(_from, _value);
596     }
597 }
598 
599 
600 /**
601 * @title Lockable, Freezable, Burnable, Pausable, ERC20
602 * @dev Token that can be locked, and will be released in steps.
603 */
604 contract LockableFreezableBurnablePausableERC20Token is FreezableBurnablePausableERC20Token {
605     struct LockAtt {
606     uint256 initLockAmount;    //初始锁仓金额
607     uint256 lockAmount;        //剩余锁仓金额
608     uint256 startLockTime;     //开始锁仓的时间
609     uint256 cliff;             //初次释放之前的锁定时长
610     uint256 interval;          //两次释放之前的间隔
611     uint256 releaseCount;      //总释放次数
612     bool revocable;            //是否可回收
613     address revocAddress;      //回收地址
614     }
615     mapping (address => LockAtt) public lockAtts;
616 
617     event RefreshedLockStatus(address _account);
618     //刷新锁仓状态
619     function refreshLockStatus(address _account) public whenNotPaused returns (bool)
620     { 
621         if(lockAtts[_account].lockAmount <= 0)
622             return false;
623 
624         require(lockAtts[_account].interval > 0, "Interval error");
625 
626         uint256 initlockamount = lockAtts[_account].initLockAmount;
627         uint256 startlocktime = lockAtts[_account].startLockTime;
628         uint256 cliff = lockAtts[_account].cliff;
629         uint256 interval = lockAtts[_account].interval;
630         uint256 releasecount = lockAtts[_account].releaseCount;
631 
632         uint256 releaseamount = 0;
633 	if(block.timestamp < startlocktime + cliff)
634 	    return false;
635 
636         uint256 exceedtime = block.timestamp-startlocktime-cliff;
637         if(exceedtime >= 0)
638         {
639             releaseamount = (exceedtime/interval+1)*initlockamount/releasecount;
640             uint256 lockamount = initlockamount - releaseamount;
641             if(lockamount<0)
642                 lockamount=0;
643             if(lockamount>initlockamount)
644                 lockamount=initlockamount;
645             lockAtts[_account].lockAmount = lockamount;
646         }
647 
648         emit RefreshedLockStatus(_account);
649         return true;
650     }
651 
652     event LockTransfered(address _from, address _to, uint256 _value, uint256 _cliff, uint256 _interval, uint _releaseCount);
653     //锁仓转账
654     function lockTransfer(address _to, uint256 _value, uint256 _cliff, uint256 _interval, uint _releaseCount) 
655     public whenNotPaused returns (bool)
656     {
657         require(!frozenAccount[msg.sender], "Sender account freezed");
658         require(!frozenAccount[_to], "Receiver account freezed");
659         require(balances[_to] == 0, "Revceiver not a new account");    //新地址才可以接受锁仓转入
660         require(_cliff>0, "Cliff error"); 
661         require(_interval>0, "Interval error"); 
662         require(_releaseCount>0, "Release count error"); 
663 
664         refreshLockStatus(msg.sender);
665         uint256 balance = balances[msg.sender];
666         uint256 lockbalance = lockAtts[msg.sender].lockAmount;
667         require(_value <= balance && _value <= balance.sub(lockbalance), "Unlocked balance insufficient");
668         require(_to != address(0));
669 
670         LockAtt memory lockatt = LockAtt(_value, _value, block.timestamp, _cliff, _interval, _releaseCount, false, msg.sender);
671         lockAtts[_to] = lockatt;    //设置接收地址的锁仓参数
672 
673         balances[msg.sender] = balances[msg.sender].sub(_value);
674         balances[_to] = balances[_to].add(_value);
675         emit LockTransfered(msg.sender, _to, _value, _cliff, _interval, _releaseCount);
676         return true; 
677     } 
678 
679     event SetRevocable(bool _revocable);
680     //同意收回
681     function setRevocable(bool _revocable) public whenNotPaused 
682     {
683         require(!frozenAccount[msg.sender], "Account freezed");
684 
685         lockAtts[msg.sender].revocable = _revocable;
686         emit SetRevocable(_revocable);
687     }
688 
689     event Revoced(address _account);
690     //收回
691     function revoc(address _account) public whenNotPaused returns (uint256)
692     {
693         require(!frozenAccount[msg.sender], "Account freezed");
694         require(!frozenAccount[_account], "Sender account freezed");
695         require(lockAtts[_account].revocable, "Account not revocable");        //该账户是否可回收
696         require(lockAtts[_account].revocAddress == msg.sender, "No permission to revoc");    //回收地址是否为sender
697         refreshLockStatus(_account);
698         uint256 balance = balances[_account];
699         uint256 lockbalance = lockAtts[_account].lockAmount;
700         require(balance >= balance.sub(lockbalance), "Unlocked balance insufficient");
701     
702         //转账
703         balances[msg.sender] = balances[msg.sender].add(lockbalance);
704         balances[_account] = balances[_account].sub(lockbalance); 
705 
706 	//被回收账户的锁仓状态要清0，否则已释放的部分也无法操作
707         lockAtts[_account].lockAmount = 0;
708         lockAtts[_account].initLockAmount = 0;
709 
710 
711         emit Revoced(_account);
712         return lockbalance;
713     }
714 
715     //重写普通转账、销毁等函数，判断锁定金额
716 
717     function transfer(
718         address _to,
719         uint256 _value
720     )
721         public
722         whenNotPaused
723         returns (bool)
724     { 
725         refreshLockStatus(msg.sender);
726         uint256 balance = balances[msg.sender];
727         uint256 lockbalance = lockAtts[msg.sender].lockAmount;
728         require(_value <= balance && _value <= balance.sub(lockbalance), "Unlocked balance insufficient");
729 
730         return super.transfer(_to, _value);
731     }
732 
733     function transferFrom(
734         address _from,
735         address _to,
736         uint256 _value
737     )
738         public
739         whenNotPaused
740         returns (bool)
741     { 
742         refreshLockStatus(_from);
743         uint256 balance = balances[_from];
744         uint256 lockbalance = lockAtts[_from].lockAmount;
745         require(_value <= balance && _value <= balance.sub(lockbalance), "Unlocked balance insufficient");
746 
747         return super.transferFrom(_from, _to, _value);
748     }
749 
750     function burn(
751         uint256 _value
752     ) 
753         public
754         whenNotPaused
755     {  
756         refreshLockStatus(msg.sender);
757         uint256 balance = balances[msg.sender];
758         uint256 lockbalance = lockAtts[msg.sender].lockAmount;
759         require(_value <= balance && _value <= balance.sub(lockbalance), "Unlocked balance insufficient");
760 
761         return super.burn(_value);
762     }
763 
764     function burnFrom(
765         address _from, 
766         uint256 _value
767     ) 
768         public 
769         whenNotPaused
770     {  
771         refreshLockStatus(_from);
772         uint256 balance = balances[_from];
773         uint256 lockbalance = lockAtts[_from].lockAmount;
774         require(_value <= balance && _value <= balance.sub(lockbalance), "Unlocked balance insufficient");
775 
776         return super.burnFrom(_from, _value);
777     }
778 
779  
780 }
781 
782 
783 /**
784 * @title AWNC
785 * @dev Token that is ERC20 compatible, Pausable, Burnable, Ownable, Lockable with SafeMath.
786 */
787 contract AWNC is LockableFreezableBurnablePausableERC20Token {
788 
789     /** Token Setting: You are free to change any of these
790     * @param name string The name of your token (can be not unique)
791     * @param symbol string The symbol of your token (can be not unique, can be more than three characters)
792     * @param decimals uint8 The accuracy decimals of your token (conventionally be 18)
793     * Read this to choose decimals: https://ethereum.stackexchange.com/questions/38704/why-most-erc-20-tokens-have-18-decimals
794     * @param INITIAL_SUPPLY uint256 The total supply of your token. Example default to be "10000". Change as you wish.
795     **/
796     string public constant name = "Action Wellness Chain";
797     string public constant symbol = "AWNC";
798     uint8 public constant decimals = 18;
799 
800     uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
801 
802     /**
803     * @dev Constructor that gives msg.sender all of existing tokens.
804     * Literally put all the issued money in your pocket
805     */
806     constructor() public {
807         totalSupply_ = INITIAL_SUPPLY;
808         balances[msg.sender] = INITIAL_SUPPLY;
809         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
810     }
811 }