1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, reverts on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b > 0); // Solidity only automatically asserts when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 
68 /**
69  * @title Ownable
70  * @dev The Ownable contract has an owner address, and provides basic authorization control
71  * functions, this simplifies the implementation of "user permissions".
72  */
73 contract Ownable {
74     address public owner;
75 
76     event OwnershipRenounced(address indexed previousOwner);
77     event OwnershipTransferred(
78         address indexed previousOwner,
79         address indexed newOwner
80     );
81 
82     /**
83     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
84     * account.
85     */
86     constructor() public {
87         owner = msg.sender;
88     }
89 
90     /**
91     * @return the address of the owner.
92     */
93     function owner() public view returns(address) {
94         return owner;
95     }
96 
97     /**
98     * @dev Throws if called by any account other than the owner.
99     */
100     modifier onlyOwner() {
101         require(isOwner());
102         _;
103     }
104 
105     /**
106     * @return true if `msg.sender` is the owner of the contract.
107     */
108     function isOwner() public view returns(bool) {
109         return msg.sender == owner;
110     }
111 
112     /**
113     * @dev Allows the current owner to relinquish control of the contract.
114     * @notice Renouncing to ownership will leave the contract without an owner.
115     * It will not be possible to call the functions with the `onlyOwner`
116     * modifier anymore.
117     */
118     function renounceOwnership() public onlyOwner {
119         emit OwnershipRenounced(owner);
120         owner = address(0);
121     }
122 
123     /**
124     * @dev Allows the current owner to transfer control of the contract to a newOwner.
125     * @param newOwner The address to transfer ownership to.
126     */
127     function transferOwnership(address newOwner) public onlyOwner {
128         _transferOwnership(newOwner);
129     }
130 
131     /**
132     * @dev Transfers control of the contract to a newOwner.
133     * @param newOwner The address to transfer ownership to.
134     */
135     function _transferOwnership(address newOwner) internal {
136         require(newOwner != address(0));
137         emit OwnershipTransferred(owner, newOwner);
138         owner = newOwner;
139     }
140 }
141 
142 
143 /**
144  * @title Roles
145  * @dev Library for managing addresses assigned to a Role.
146  */
147 library Roles {
148     struct Role {
149         mapping (address => bool) bearer;
150     }
151 
152     /**
153     * @dev give an account access to this role
154     */
155     function add(Role storage role, address account) internal {
156         require(account != address(0));
157         role.bearer[account] = true;
158     }
159 
160     /**
161     * @dev remove an account's access to this role
162     */
163     function remove(Role storage role, address account) internal {
164         require(account != address(0));
165         role.bearer[account] = false;
166     }
167 
168     /**
169     * @dev check if an account has this role
170     * @return bool
171     */
172     function has(Role storage role, address account)
173         internal
174         view
175         returns (bool)
176     {
177         require(account != address(0));
178         return role.bearer[account];
179     }
180 }
181 
182 
183 contract MinterRole is Ownable {
184     using Roles for Roles.Role;
185 
186     event MinterAdded(address indexed account);
187     event MinterRemoved(address indexed account);
188 
189     Roles.Role private minters;
190 
191     constructor() public {
192         _addMinter(msg.sender);
193     }
194 
195     modifier onlyMinter() {
196         require(isMinter(msg.sender));
197         _;
198     }
199 
200     function isMinter(address account) public view returns (bool) {
201         return minters.has(account);
202     }
203 
204     function addMinter(address account) public onlyOwner {
205         _addMinter(account);
206     }
207 
208     function renounceMinter() public {
209         _removeMinter(msg.sender);
210     }
211 
212     function _addMinter(address account) internal {
213         minters.add(account);
214         emit MinterAdded(account);
215     }
216 
217     function _removeMinter(address account) internal {
218         minters.remove(account);
219         emit MinterRemoved(account);
220     }
221 }
222 
223 
224 contract PauserRole is Ownable{
225     using Roles for Roles.Role;
226 
227     event PauserAdded(address indexed account);
228     event PauserRemoved(address indexed account);
229 
230     Roles.Role private pausers;
231 
232     constructor() public {
233         _addPauser(msg.sender);
234     }
235 
236     modifier onlyPauser() {
237         require(isPauser(msg.sender));
238         _;
239     }
240 
241     function isPauser(address account) public view returns (bool) {
242         return pausers.has(account);
243     }
244 
245     function addPauser(address account) public onlyOwner {
246         _addPauser(account);
247     }
248 
249     function renouncePauser() public {
250         _removePauser(msg.sender);
251     }
252 
253     function _addPauser(address account) internal {
254         pausers.add(account);
255         emit PauserAdded(account);
256     }
257 
258     function _removePauser(address account) internal {
259         pausers.remove(account);
260         emit PauserRemoved(account);
261     }
262 }
263 
264 /**
265  * @title ERC20 interface
266  * @dev see https://github.com/ethereum/EIPs/issues/20
267  */
268 interface IERC20 {
269   function totalSupply() external view returns (uint256);
270 
271   function balanceOf(address who) external view returns (uint256);
272 
273   function allowance(address owner, address spender)
274     external view returns (uint256);
275 
276   function transfer(address to, uint256 value) external returns (bool);
277 
278   function approve(address spender, uint256 value)
279     external returns (bool);
280 
281   function transferFrom(address from, address to, uint256 value)
282     external returns (bool);
283 
284   event Transfer(
285     address indexed from,
286     address indexed to,
287     uint256 value
288   );
289 
290   event Approval(
291     address indexed owner,
292     address indexed spender,
293     uint256 value
294   );
295 }
296 
297 
298 /**
299  * @title Standard ERC20 token
300  *
301  * @dev Implementation of the basic standard token.
302  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
303  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
304  */
305 contract ERC20 is IERC20 {
306     using SafeMath for uint256;
307 
308     mapping (address => uint256) public balances;
309 
310     mapping (address => mapping (address => uint256)) public allowed;
311 
312     uint256 public totalSupply;
313 
314     /**
315     * @dev Total number of tokens in existence
316     */
317     function totalSupply() public view returns (uint256) {
318         return totalSupply;
319     }
320 
321     /**
322     * @dev Gets the balance of the specified address.
323     * @param owner The address to query the balance of.
324     * @return An uint256 representing the amount owned by the passed address.
325     */
326     function balanceOf(address owner) public view returns (uint256) {
327         return balances[owner];
328     }
329 
330     /**
331     * @dev Function to check the amount of tokens that an owner allowed to a spender.
332     * @param owner address The address which owns the funds.
333     * @param spender address The address which will spend the funds.
334     * @return A uint256 specifying the amount of tokens still available for the spender.
335     */
336     function allowance(
337         address owner,
338         address spender
339     )
340         public
341         view
342         returns (uint256)
343     {
344         return allowed[owner][spender];
345     }
346 
347     /**
348     * @dev Transfer token for a specified address
349     * @param to The address to transfer to.
350     * @param value The amount to be transferred.
351     */
352     function transfer(address to, uint256 value) public returns (bool) {
353         require(value <= balances[msg.sender]);
354         require(to != address(0));
355 
356         balances[msg.sender] = balances[msg.sender].sub(value);
357         balances[to] = balances[to].add(value);
358         emit Transfer(msg.sender, to, value);
359         return true;
360     }
361 
362     /**
363     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
364     * Beware that changing an allowance with this method brings the risk that someone may use both the old
365     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
366     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
367     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
368     * @param spender The address which will spend the funds.
369     * @param value The amount of tokens to be spent.
370     */
371     function approve(address spender, uint256 value) public returns (bool) {
372         require(spender != address(0));
373 
374         allowed[msg.sender][spender] = value;
375         emit Approval(msg.sender, spender, value);
376         return true;
377     }
378 
379     /**
380     * @dev Transfer tokens from one address to another
381     * @param from address The address which you want to send tokens from
382     * @param to address The address which you want to transfer to
383     * @param value uint256 the amount of tokens to be transferred
384     */
385     function transferFrom(
386         address from,
387         address to,
388         uint256 value
389     )
390         public
391         returns (bool)
392     {
393         require(value <= balances[from]);
394         require(value <= allowed[from][msg.sender]);
395         require(to != address(0));
396 
397         balances[from] = balances[from].sub(value);
398         balances[to] = balances[to].add(value);
399         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
400         emit Transfer(from, to, value);
401         return true;
402     }
403 
404     /**
405     * @dev Increase the amount of tokens that an owner allowed to a spender.
406     * approve should be called when allowed_[_spender] == 0. To increment
407     * allowed value is better to use this function to avoid 2 calls (and wait until
408     * the first transaction is mined)
409     * From MonolithDAO Token.sol
410     * @param spender The address which will spend the funds.
411     * @param addedValue The amount of tokens to increase the allowance by.
412     */
413     function increaseAllowance(
414         address spender,
415         uint256 addedValue
416     )
417         public
418         returns (bool)
419     {
420         require(spender != address(0));
421 
422         allowed[msg.sender][spender] = (
423         allowed[msg.sender][spender].add(addedValue));
424         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
425         return true;
426     }
427 
428     /**
429     * @dev Decrease the amount of tokens that an owner allowed to a spender.
430     * approve should be called when allowed_[_spender] == 0. To decrement
431     * allowed value is better to use this function to avoid 2 calls (and wait until
432     * the first transaction is mined)
433     * From MonolithDAO Token.sol
434     * @param spender The address which will spend the funds.
435     * @param subtractedValue The amount of tokens to decrease the allowance by.
436     */
437     function decreaseAllowance(
438         address spender,
439         uint256 subtractedValue
440     )
441         public
442         returns (bool)
443     {
444         require(spender != address(0));
445 
446         allowed[msg.sender][spender] = (
447         allowed[msg.sender][spender].sub(subtractedValue));
448         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
449         return true;
450     }
451 
452     /**
453     * @dev Internal function that mints an amount of the token and assigns it to
454     * an account. This encapsulates the modification of balances such that the
455     * proper events are emitted.
456     * @param account The account that will receive the created tokens.
457     * @param amount The amount that will be created.
458     */
459     function _mint(address account, uint256 amount) internal {
460         require(account != 0);
461         totalSupply = totalSupply.add(amount);
462         balances[account] = balances[account].add(amount);
463         emit Transfer(address(0), account, amount);
464     }
465 
466     /**
467     * @dev Internal function that burns an amount of the token of a given
468     * account.
469     * @param account The account whose tokens will be burnt.
470     * @param amount The amount that will be burnt.
471     */
472     function _burn(address account, uint256 amount) internal {
473         require(account != 0);
474         require(amount <= balances[account]);
475 
476         totalSupply = totalSupply.sub(amount);
477         balances[account] = balances[account].sub(amount);
478         emit Transfer(account, address(0), amount);
479     }
480 
481     /**
482     * @dev Internal function that burns an amount of the token of a given
483     * account, deducting from the sender's allowance for said account. Uses the
484     * internal burn function.
485     * @param account The account whose tokens will be burnt.
486     * @param amount The amount that will be burnt.
487     */
488     function _burnFrom(address account, uint256 amount) internal {
489         require(amount <= allowed[account][msg.sender]);
490 
491         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
492         // this function needs to emit an event with the updated approval.
493         allowed[account][msg.sender] = allowed[account][msg.sender].sub(
494         amount);
495         _burn(account, amount);
496     }
497 }
498 
499 
500 /**
501  * @title Pausable
502  * @dev Base contract which allows children to implement an emergency stop mechanism.
503  */
504 contract Pausable is PauserRole {
505     event Paused();
506     event Unpaused();
507 
508     bool private _paused = false;
509 
510     /**
511     * @return true if the contract is paused, false otherwise.
512     */
513     function paused() public view returns(bool) {
514         return _paused;
515     }
516 
517     /**
518     * @dev Modifier to make a function callable only when the contract is not paused.
519     */
520     modifier whenNotPaused() {
521         require(!_paused);
522         _;
523     }
524 
525     /**
526     * @dev Modifier to make a function callable only when the contract is paused.
527     */
528     modifier whenPaused() {
529         require(_paused);
530         _;
531     }
532 
533     /**
534     * @dev called by the owner to pause, triggers stopped state
535     */
536     function pause() public onlyPauser whenNotPaused {
537         _paused = true;
538         emit Paused();
539     }
540 
541     /**
542     * @dev called by the owner to unpause, returns to normal state
543     */
544     function unpause() public onlyPauser whenPaused {
545         _paused = false;
546         emit Unpaused();
547     }
548 }
549 
550 
551 
552 /**
553  * @title Pausable token
554  * @dev ERC20 modified with pausable transfers.
555  **/
556 contract ERC20Pausable is ERC20, Pausable {
557 
558     function transfer(
559         address to,
560         uint256 value
561     )
562         public
563         whenNotPaused
564         returns (bool)
565     {
566         return super.transfer(to, value);
567     }
568 
569     function transferFrom(
570         address from,
571         address to,
572         uint256 value
573     )
574         public
575         whenNotPaused
576         returns (bool)
577     {
578         return super.transferFrom(from, to, value);
579     }
580 
581     function approve(
582         address spender,
583         uint256 value
584     )
585         public
586         whenNotPaused
587         returns (bool)
588     {
589         return super.approve(spender, value);
590     }
591 
592     function increaseAllowance(
593         address spender,
594         uint addedValue
595     )
596         public
597         whenNotPaused
598         returns (bool success)
599     {
600         return super.increaseAllowance(spender, addedValue);
601     }
602 
603     function decreaseAllowance(
604         address spender,
605         uint subtractedValue
606     )
607         public
608         whenNotPaused
609         returns (bool success)
610     {
611         return super.decreaseAllowance(spender, subtractedValue);
612     }
613 }
614 
615 
616 
617 /**
618  * @title Burnable Token
619  * @dev Token that can be irreversibly burned (destroyed).
620  */
621 contract ERC20Burnable is ERC20 {
622 
623     /**
624     * @dev Burns a specific amount of tokens.
625     * @param value The amount of token to be burned.
626     */
627     function burn(uint256 value) public {
628         _burn(msg.sender, value);
629     }
630 
631     /**
632     * @dev Burns a specific amount of tokens from the target address and decrements allowance
633     * @param from address The address which you want to send tokens from
634     * @param value uint256 The amount of token to be burned
635     */
636     function burnFrom(address from, uint256 value) public {
637         _burnFrom(from, value);
638     }
639 
640     /**
641     * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
642     * an additional Burn event.
643     */
644     function _burn(address who, uint256 value) internal {
645         super._burn(who, value);
646     }
647 }
648 
649 
650 /**
651  * @title ERC20Mintable
652  * @dev ERC20 minting logic
653  */
654 contract ERC20CappedMintable is ERC20, MinterRole {
655 
656     uint256 private _cap;
657 
658     constructor(uint256 cap)
659         public
660     {
661         require(cap > 0,"Maximum supply has reached.");
662         _cap = cap;
663     }
664 
665     /**
666     * @return the cap for the token minting.
667     */
668     function cap() public view returns(uint256) {
669         return _cap;
670     }
671 
672   /**
673    * @dev Function to mint tokens
674    * @param to The address that will receive the minted tokens.
675    * @param amount The amount of tokens to mint.
676    * @return A boolean that indicates if the operation was successful.
677    */
678     function mint(
679         address to,
680         uint256 amount
681     )
682         public
683         onlyMinter
684         returns (bool)
685     {   
686         require(totalSupply.add(amount) <= _cap);
687         _mint(to, amount);
688         return true;
689     }
690 }
691 
692 /**
693  * Define interface for releasing the token transfer after a successful crowdsale.
694  */
695 contract ERC20Releasable is ERC20, Ownable {
696 
697     /* The finalizer contract that allows unlift the transfer limits on this token */
698     address public releaseAgent;
699 
700     /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
701     bool public released = false;
702 
703     /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
704     mapping (address => bool) public transferAgents;
705 
706     /**
707     * Limit token transfer until the crowdsale is over.
708     *
709     */
710     modifier canTransfer(address _sender) {
711 
712         if(!released) {
713             require(transferAgents[_sender]);
714         }
715         _;
716     }
717 
718     /**
719     * Set the contract that can call release and make the token transferable.
720     *
721     * Design choice. Allow reset the release agent to fix fat finger mistakes.
722     */
723     function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
724 
725       // We don't do interface check here as we might want to a normal wallet address to act as a release agent
726         releaseAgent = addr;
727     }
728 
729     /**
730     * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
731     */
732     function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
733         transferAgents[addr] = state;
734     }
735 
736     /**
737     * One way function to release the tokens to the wild.
738     *
739     * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
740     */
741     function releaseTokenTransfer() public onlyReleaseAgent {
742         released = true;
743     }
744 
745     /** The function can be called only before or after the tokens have been releasesd */
746     modifier inReleaseState(bool releaseState) {
747         require(releaseState == released);
748         _;
749     }
750 
751     /** The function can be called only by a whitelisted release agent. */
752     modifier onlyReleaseAgent() {
753         require(msg.sender == releaseAgent);
754         _;
755     }
756 
757     function transfer(
758         address to,
759         uint256 value
760     )
761         public
762         canTransfer(msg.sender)
763         returns (bool)
764     {
765         return super.transfer(to, value);
766     }
767 
768     function transferFrom(
769         address from,
770         address to,
771         uint256 value
772     )
773         public
774         canTransfer(from)
775         returns (bool)
776     {
777         return super.transferFrom(from, to, value);
778     }
779 
780 
781 
782     function approve(
783         address spender,
784         uint256 value
785     )
786         public
787         canTransfer(spender)
788         returns (bool)
789     {
790         return super.approve(spender, value);
791     }
792 
793     function increaseAllowance(
794         address spender,
795         uint addedValue
796     )
797         public
798         canTransfer(spender)
799         returns (bool success)
800     {
801         return super.increaseAllowance(spender, addedValue);
802     }
803 
804     function decreaseAllowance(
805         address spender,
806         uint subtractedValue
807     )
808         public
809         canTransfer(spender)
810         returns (bool success)
811     {
812         return super.decreaseAllowance(spender, subtractedValue);
813     }
814 
815 }
816 
817 
818 contract BXBCoin is ERC20Burnable, ERC20CappedMintable, ERC20Pausable, ERC20Releasable {
819     
820     string public name;
821     string public symbol;
822     uint8 public decimals;
823 
824     /**
825     * Construct the token.
826     *
827     * This token must be created through a team multisig wallet, so that it is owned by that wallet.
828     *
829     * @param _tokenName Token name
830     * @param _tokenSymbol Token symbol - should be all caps
831     * @param _initialSupply How many tokens we start with
832     * @param _tokenDecimals Number of decimal places
833     * @param _tokenCap Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
834     */
835     constructor (string _tokenName, string _tokenSymbol, uint _initialSupply, uint8 _tokenDecimals,uint256 _tokenCap)
836         ERC20CappedMintable(_tokenCap)
837         public
838     {
839         owner = msg.sender;
840         name = _tokenName;
841         symbol = _tokenSymbol;
842         totalSupply = _initialSupply;
843         decimals = _tokenDecimals;
844         balances[owner] = totalSupply;
845     }
846 
847     /**
848     * When token is released to be transferable, enforce no new tokens can be created.
849     */
850     function releaseTokenTransfer() public onlyReleaseAgent {
851         super.releaseTokenTransfer();
852     }
853 }