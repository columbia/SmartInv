1 // File: contracts/Ownable.sol
2 
3 pragma solidity 0.5.0;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11 
12     address private _owner;
13     address private _pendingOwner;
14 
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16     
17     /**
18      * @dev The constructor sets the original owner of the contract to the sender account.
19      */
20     constructor() public {
21         setOwner(msg.sender);
22     }
23 
24     /**
25      * @dev Modifier throws if called by any account other than the pendingOwner.
26      */
27     modifier onlyPendingOwner() {
28         require(msg.sender == _pendingOwner, "msg.sender should be onlyPendingOwner");
29         _;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(msg.sender == _owner, "msg.sender should be owner");
37         _;
38     }
39 
40     /**
41      * @dev Tells the address of the pendingOwner
42      * @return The address of the pendingOwner
43      */
44     function pendingOwner() public view returns (address) {
45         return _pendingOwner;
46     }
47     
48     /**
49      * @dev Tells the address of the owner
50      * @return the address of the owner
51      */
52     function owner() public view returns (address ) {
53         return _owner;
54     }
55     
56     /**
57     * @dev Sets a new owner address
58     * @param _newOwner The newOwner to set
59     */
60     function setOwner(address _newOwner) internal {
61         _owner = _newOwner;
62     }
63 
64     /**
65      * @dev Allows the current owner to set the pendingOwner address.
66      * @param _newOwner The address to transfer ownership to.
67      */
68     function transferOwnership(address _newOwner) public onlyOwner {
69         _pendingOwner = _newOwner;
70     }
71 
72     /**
73      * @dev Allows the pendingOwner address to finalize the transfer.
74      */
75     function claimOwnership() public onlyPendingOwner {
76         emit OwnershipTransferred(_owner, _pendingOwner);
77         _owner = _pendingOwner;
78         _pendingOwner = address(0); 
79     }
80     
81 }
82 
83 // File: contracts/Operable.sol
84 
85 pragma solidity 0.5.0;
86 
87 
88 contract Operable is Ownable {
89 
90     address private _operator; 
91 
92     event OperatorChanged(address indexed previousOperator, address indexed newOperator);
93 
94     /**
95      * @dev Tells the address of the operator
96      * @return the address of the operator
97      */
98     function operator() external view returns (address) {
99         return _operator;
100     }
101     
102     /**
103      * @dev Only the operator can operate store
104      */
105     modifier onlyOperator() {
106         require(msg.sender == _operator, "msg.sender should be operator");
107         _;
108     }
109 
110     /**
111      * @dev update the storgeOperator
112      * @param _newOperator The newOperator to update  
113      */
114     function updateOperator(address _newOperator) public onlyOwner {
115         require(_newOperator != address(0), "Cannot change the newOperator to the zero address");
116         emit OperatorChanged(_operator, _newOperator);
117         _operator = _newOperator;
118     }
119 
120 }
121 
122 // File: contracts/utils/SafeMath.sol
123 
124 pragma solidity 0.5.0;
125 
126 /**
127  * @title SafeMath
128  * @dev Unsigned math operations with safety checks that revert on error
129  */
130 library SafeMath {
131     /**
132      * @dev Multiplies two unsigned integers, reverts on overflow.
133      */
134     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
136         // benefit is lost if 'b' is also tested.
137         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
138         if (a == 0) {
139             return 0;
140         }
141 
142         uint256 c = a * b;
143         require(c / a == b);
144 
145         return c;
146     }
147 
148     /**
149      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
150      */
151     function div(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Solidity only automatically asserts when dividing by 0
153         require(b > 0);
154         uint256 c = a / b;
155         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
156 
157         return c;
158     }
159 
160     /**
161      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
162      */
163     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164         require(b <= a);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Adds two unsigned integers, reverts on overflow.
172      */
173     function add(uint256 a, uint256 b) internal pure returns (uint256) {
174         uint256 c = a + b;
175         require(c >= a);
176 
177         return c;
178     }
179 
180     /**
181      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
182      * reverts when dividing by zero.
183      */
184     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b != 0);
186         return a % b;
187     }
188 }
189 
190 // File: contracts/TokenStore.sol
191 
192 pragma solidity 0.5.0;
193 
194 
195 
196 contract TokenStore is Operable {
197 
198     using SafeMath for uint256;
199 
200     uint256 public totalSupply;
201     
202     string  public name = "PingAnToken";
203     string  public symbol = "PAT";
204     uint8 public decimals = 18;
205 
206     mapping (address => uint256) public balances;
207     mapping (address => mapping (address => uint256)) public allowed;
208 
209     function changeTokenName(string memory _name, string memory _symbol) public onlyOperator {
210         name = _name;
211         symbol = _symbol;
212     }
213 
214     function addBalance(address _holder, uint256 _value) public onlyOperator {
215         balances[_holder] = balances[_holder].add(_value);
216     }
217 
218     function subBalance(address _holder, uint256 _value) public onlyOperator {
219         balances[_holder] = balances[_holder].sub(_value);
220     }
221 
222     function setBalance(address _holder, uint256 _value) public onlyOperator {
223         balances[_holder] = _value;
224     }
225 
226     function addAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
227         allowed[_holder][_spender] = allowed[_holder][_spender].add(_value);
228     }
229 
230     function subAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
231         allowed[_holder][_spender] = allowed[_holder][_spender].sub(_value);
232     }
233 
234     function setAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
235         allowed[_holder][_spender] = _value;
236     }
237 
238     function addTotalSupply(uint256 _value) public onlyOperator {
239         totalSupply = totalSupply.add(_value);
240     }
241 
242     function subTotalSupply(uint256 _value) public onlyOperator {
243         totalSupply = totalSupply.sub(_value);
244     }
245 
246     function setTotalSupply(uint256 _value) public onlyOperator {
247         totalSupply = _value;
248     }
249 
250 }
251 
252 // File: contracts/ERC20Interface.sol
253 
254 pragma solidity 0.5.0;
255 
256 
257 interface ERC20Interface {  
258 
259     function totalSupply() external view returns (uint256);
260 
261     function balanceOf(address holder) external view returns (uint256);
262 
263     function allowance(address holder, address spender) external view returns (uint256);
264 
265     function transfer(address to, uint256 value) external returns (bool);
266 
267     function approve(address spender, uint256 value) external returns (bool);
268 
269     function transferFrom(address from, address to, uint256 value) external returns (bool);
270 
271     event Transfer(address indexed from, address indexed to, uint256 value);
272 
273     event Approval(address indexed holder, address indexed spender, uint256 value);
274 
275 }
276 
277 // File: contracts/ERC20StandardToken.sol
278 
279 pragma solidity 0.5.0;
280 
281 
282 
283 
284 contract ERC20StandardToken is ERC20Interface, Ownable {
285 
286 
287     TokenStore public tokenStore;
288     
289     event TokenStoreSet(address indexed previousTokenStore, address indexed newTokenStore);
290     event ChangeTokenName(string newName, string newSymbol);
291 
292     /**
293      * @dev ownership of the TokenStore contract
294      * @param _newTokenStore The address to of the TokenStore to set.
295      */
296     function setTokenStore(address _newTokenStore) public onlyOwner returns (bool) {
297         emit TokenStoreSet(address(tokenStore), _newTokenStore);
298         tokenStore = TokenStore(_newTokenStore);
299         return true;
300     }
301     
302     function changeTokenName(string memory _name, string memory _symbol) public onlyOwner {
303         tokenStore.changeTokenName(_name, _symbol);
304         emit ChangeTokenName(_name, _symbol);
305     }
306 
307     function totalSupply() public view returns (uint256) {
308         return tokenStore.totalSupply();
309     }
310 
311     function balanceOf(address _holder) public view returns (uint256) {
312         return tokenStore.balances(_holder);
313     }
314 
315     function allowance(address _holder, address _spender) public view returns (uint256) {
316         return tokenStore.allowed(_holder, _spender);
317     }
318     
319     function name() public view returns (string memory) {
320         return tokenStore.name();
321     }
322     
323     function symbol() public view returns (string memory) {
324         return tokenStore.symbol();
325     }
326     
327     function decimals() public view returns (uint8) {
328         return tokenStore.decimals();
329     }
330     
331     /**
332      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
333      * Beware that changing an allowance with this method brings the risk that someone may use both the old
334      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
335      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
336      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
337      * @param _spender The address which will spend the funds.
338      * @param _value The amount of tokens to be spent.
339      */
340     function approve(
341         address _spender,
342         uint256 _value
343     ) public returns (bool success) {
344         require (_spender != address(0), "Cannot approve to the zero address");       
345         tokenStore.setAllowance(msg.sender, _spender, _value);
346         emit Approval(msg.sender, _spender, _value);
347         return true;
348     }
349     
350     /**
351      * @dev Increase the amount of tokens that an holder allowed to a spender.
352      *
353      * approve should be called when allowed[_spender] == 0. To increment
354      * allowed value is better to use this function to avoid 2 calls (and wait until
355      * the first transaction is mined)
356      * From MonolithDAO Token.sol
357      * @param _spender The address which will spend the funds.
358      * @param _addedValue The amount of tokens to increase the allowance by.
359      */
360     function increaseApproval(
361         address _spender,
362         uint256 _addedValue
363     ) public returns (bool success) {
364         require (_spender != address(0), "Cannot increaseApproval to the zero address");      
365         tokenStore.addAllowance(msg.sender, _spender, _addedValue);
366         emit Approval(msg.sender, _spender, tokenStore.allowed(msg.sender, _spender));
367         return true;
368     }
369     
370     /**
371      * @dev Decrease the amount of tokens that an holder allowed to a spender.
372      *
373      * approve should be called when allowed[_spender] == 0. To decrement
374      * allowed value is better to use this function to avoid 2 calls (and wait until
375      * the first transaction is mined)
376      * From MonolithDAO Token.sol
377      * @param _spender The address which will spend the funds.
378      * @param _subtractedValue The amount of tokens to decrease the allowance by.
379      */
380     function decreaseApproval(
381         address _spender,
382         uint256 _subtractedValue 
383     ) public returns (bool success) {
384         require (_spender != address(0), "Cannot decreaseApproval to the zero address");       
385         tokenStore.subAllowance(msg.sender, _spender, _subtractedValue);
386         emit Approval(msg.sender, _spender, tokenStore.allowed(msg.sender, _spender));
387         return true;
388     }
389 
390     /**
391      * @dev Transfer tokens from one address to another
392      * @param _from address The address which you want to send tokens from
393      * @param _to address The address which you want to transfer to
394      * @param _value uint256 the amount of tokens to be transferred
395      */
396     function transferFrom(
397         address _from, 
398         address _to, 
399         uint256 _value
400     ) public returns (bool success) {
401         require(_to != address(0), "Cannot transfer to zero address"); 
402         tokenStore.subAllowance(_from, msg.sender, _value);          
403         tokenStore.subBalance(_from, _value);
404         tokenStore.addBalance(_to, _value);
405         emit Transfer(_from, _to, _value);
406         return true;
407     } 
408 
409     /**
410      * @dev Transfer token for a specified address
411      * @param _to The address to transfer to.
412      * @param _value The amount to be transferred.
413      */
414     function transfer(
415         address _to, 
416         uint256 _value
417     ) public returns (bool success) {
418         require (_to != address(0), "Cannot transfer to zero address");    
419         tokenStore.subBalance(msg.sender, _value);
420         tokenStore.addBalance(_to, _value);
421         emit Transfer(msg.sender, _to, _value);
422         return true;
423     }
424 
425 }
426 
427 // File: contracts/PausableToken.sol
428 
429 pragma solidity 0.5.0;
430 
431 
432 
433 contract PausableToken is ERC20StandardToken {
434 
435     address private _pauser;
436     bool public paused = false;
437 
438     event Pause();
439     event Unpause();
440     event PauserChanged(address indexed previousPauser, address indexed newPauser);
441     
442     /**
443      * @dev Tells the address of the pauser
444      * @return The address of the pauser
445      */
446     function pauser() public view returns (address) {
447         return _pauser;
448     }
449     
450     /**
451      * @dev Modifier to make a function callable only when the contract is not paused.
452      */
453     modifier whenNotPaused() {
454         require(!paused, "state shouldn't be paused");
455         _;
456     }
457 
458     /**
459      * @dev throws if called by any account other than the pauser
460      */
461     modifier onlyPauser() {
462         require(msg.sender == _pauser, "msg.sender should be pauser");
463         _;
464     }
465 
466     /**
467      * @dev called by the owner to pause, triggers stopped state
468      */
469     function pause() public onlyPauser {
470         paused = true;
471         emit Pause();
472     }
473 
474     /**
475      * @dev called by the owner to unpause, returns to normal state
476      */
477     function unpause() public onlyPauser {
478         paused = false;
479         emit Unpause();
480     }
481 
482     /**
483      * @dev update the pauser role
484      * @param _newPauser The newPauser to update
485      */
486     function updatePauser(address _newPauser) public onlyOwner {
487         require(_newPauser != address(0), "Cannot update the newPauser to the zero address");
488         emit PauserChanged(_pauser, _newPauser);
489         _pauser = _newPauser;
490     }
491 
492     function approve(
493         address _spender,
494         uint256 _value
495     ) public whenNotPaused returns (bool success) {
496         return super.approve(_spender, _value);
497     }
498 
499     function increaseApproval(
500         address _spender,
501         uint256 _addedValue
502     ) public whenNotPaused returns (bool success) {
503         return super.increaseApproval(_spender, _addedValue);
504     } 
505 
506     function decreaseApproval(
507         address _spender,
508         uint256 _subtractedValue 
509     ) public whenNotPaused returns (bool success) {
510         return super.decreaseApproval(_spender, _subtractedValue);
511     }
512 
513     function transferFrom(
514         address _from, 
515         address _to, 
516         uint256 _value
517     ) public whenNotPaused returns (bool success) {
518         return super.transferFrom(_from, _to, _value);
519     } 
520 
521     function transfer(
522         address _to, 
523         uint256 _value
524     ) public whenNotPaused returns (bool success) {
525         return super.transfer(_to, _value);
526     }
527 
528 }
529 
530 // File: contracts/BlacklistStore.sol
531 
532 pragma solidity 0.5.0;
533 
534 
535 contract BlacklistStore is Operable {
536 
537     mapping (address => uint256) public blacklisted;
538 
539     /**
540      * @dev Checks if account is blacklisted
541      * @param _account The address to check
542      * @param _status The address status    
543      */
544     function setBlacklist(address _account, uint256 _status) public onlyOperator {
545         blacklisted[_account] = _status;
546     }
547 
548 }
549 
550 // File: contracts/BlacklistableToken.sol
551 
552 pragma solidity 0.5.0;
553 
554 
555 
556 /**
557  * @title BlacklistableToken
558  * @dev Allows accounts to be blacklisted by a "blacklister" role
559  */
560 contract BlacklistableToken is PausableToken {
561 
562     BlacklistStore public blacklistStore;
563 
564     address private _blacklister;
565 
566     event BlacklisterChanged(address indexed previousBlacklister, address indexed newBlacklister);
567     event BlacklistStoreSet(address indexed previousBlacklistStore, address indexed newblacklistStore);
568     event Blacklist(address indexed account, uint256 _status);
569 
570 
571     /**
572      * @dev Throws if argument account is blacklisted
573      * @param _account The address to check
574      */
575     modifier notBlacklisted(address _account) {
576         require(blacklistStore.blacklisted(_account) == 0, "Account in the blacklist");
577         _;
578     }
579 
580     /**
581      * @dev Throws if called by any account other than the blacklister
582      */
583     modifier onlyBlacklister() {
584         require(msg.sender == _blacklister, "msg.sener should be blacklister");
585         _;
586     }
587 
588     /**
589      * @dev Tells the address of the blacklister
590      * @return The address of the blacklister
591      */
592     function blacklister() public view returns (address) {
593         return _blacklister;
594     }
595     
596     /**
597      * @dev Set the blacklistStore
598      * @param _newblacklistStore The blacklistStore address to set
599      */
600     function setBlacklistStore(address _newblacklistStore) public onlyOwner returns (bool) {
601         emit BlacklistStoreSet(address(blacklistStore), _newblacklistStore);
602         blacklistStore = BlacklistStore(_newblacklistStore);
603         return true;
604     }
605     
606     /**
607      * @dev Update the blacklister 
608      * @param _newBlacklister The newBlacklister to update
609      */
610     function updateBlacklister(address _newBlacklister) public onlyOwner {
611         require(_newBlacklister != address(0), "Cannot update the blacklister to the zero address");
612         emit BlacklisterChanged(_blacklister, _newBlacklister);
613         _blacklister = _newBlacklister;
614     }
615 
616     /**
617      * @dev Checks if account is blacklisted
618      * @param _account The address status to query
619      * @return the address status 
620      */
621     function queryBlacklist(address _account) public view returns (uint256) {
622         return blacklistStore.blacklisted(_account);
623     }
624 
625     /**
626      * @dev Adds account to blacklist
627      * @param _account The address to blacklist
628      * @param _status The address status to change
629      */
630     function changeBlacklist(address _account, uint256 _status) public onlyBlacklister {
631         blacklistStore.setBlacklist(_account, _status);
632         emit Blacklist(_account, _status);
633     }
634 
635     function approve(
636         address _spender,
637         uint256 _value
638     ) public notBlacklisted(msg.sender) notBlacklisted(_spender) returns (bool success) {
639         return super.approve(_spender, _value);
640     }
641     
642     function increaseApproval(
643         address _spender,
644         uint256 _addedValue
645     ) public notBlacklisted(msg.sender) notBlacklisted(_spender) returns (bool success) {
646         return super.increaseApproval(_spender, _addedValue);
647     } 
648 
649     function decreaseApproval(
650         address _spender,
651         uint256 _subtractedValue 
652     ) public notBlacklisted(msg.sender) notBlacklisted(_spender) returns (bool success) {
653         return super.decreaseApproval(_spender, _subtractedValue);
654     }
655 
656     function transferFrom(
657         address _from, 
658         address _to, 
659         uint256 _value
660     ) public notBlacklisted(_from) notBlacklisted(_to) notBlacklisted(msg.sender) returns (bool success) {
661         return super.transferFrom(_from, _to, _value);
662     } 
663 
664     function transfer(
665         address _to, 
666         uint256 _value
667     ) public notBlacklisted(msg.sender) notBlacklisted(_to) returns (bool success) {
668         return super.transfer(_to, _value);
669     }
670 
671 }
672 
673 // File: contracts/BurnableToken.sol
674 
675 pragma solidity 0.5.0;
676 
677 
678 contract BurnableToken is BlacklistableToken {
679 
680     event Burn(address indexed burner, uint256 value);
681     
682     /**
683      * @dev holder can burn some of its own tokens
684      * amount is less than or equal to the minter's account balance
685      * @param _value uint256 the amount of tokens to be burned
686     */
687     function burn(
688         uint256 _value
689     ) public whenNotPaused notBlacklisted(msg.sender) returns (bool success) {   
690         tokenStore.subBalance(msg.sender, _value);
691         tokenStore.subTotalSupply(_value);
692         emit Burn(msg.sender, _value);
693         emit Transfer(msg.sender, address(0), _value);
694         return true;
695     }
696 
697 }
698 
699 // File: contracts/MintableToken.sol
700 
701 pragma solidity 0.5.0;
702 
703 
704 
705 contract MintableToken is BlacklistableToken {
706 
707     event MinterChanged(address indexed previousMinter, address indexed newMinter);
708     event Mint(address indexed minter, address indexed to, uint256 value);
709 
710     address private _minter;
711 
712     modifier onlyMinter() {
713         require(msg.sender == _minter, "msg.sender should be minter");
714         _;
715     }
716 
717     /**
718      * @dev Tells the address of the blacklister
719      * @return The address of the blacklister
720      */
721     function minter() public view returns (address) {
722         return _minter;
723     }
724  
725     /**
726      * @dev update the minter
727      * @param _newMinter The newMinter to update
728      */
729     function updateMinter(address _newMinter) public onlyOwner {
730         require(_newMinter != address(0), "Cannot update the newPauser to the zero address");
731         emit MinterChanged(_minter, _newMinter);
732         _minter = _newMinter;
733     }
734 
735     /**
736      * @dev Function to mint tokens
737      * @param _to The address that will receive the minted tokens.
738      * @param _value The amount of tokens to mint. Must be less than or equal to the minterAllowance of the caller.
739      * @return A boolean that indicates if the operation was successful.
740      */
741     function mint(
742         address _to, 
743         uint256 _value
744     ) public onlyMinter whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_to) returns (bool) {
745         require(_to != address(0), "Cannot mint to zero address");
746         tokenStore.addTotalSupply(_value);
747         tokenStore.addBalance(_to, _value);  
748         emit Mint(msg.sender, _to, _value);
749         emit Transfer(address(0), _to, _value);
750         return true;
751     }
752 
753 }
754 
755 // File: contracts/PingAnToken.sol
756 
757 pragma solidity 0.5.0;
758 
759 
760 
761 
762 contract PingAnToken is BurnableToken, MintableToken {
763 
764 
765     /**
766      * contract only can initialized once 
767      */
768     bool private initialized = true;
769 
770     /**
771      * @dev sets 0 initials tokens, the owner.
772      * this serves as the constructor for the proxy but compiles to the
773      * memory model of the Implementation contract.
774      * @param _owner The owner to initials
775      */
776     function initialize(address _owner) public {
777         require(!initialized, "already initialized");
778         require(_owner != address(0), "Cannot initialize the owner to zero address");
779         setOwner(_owner);
780         initialized = true;
781     }
782 
783 }