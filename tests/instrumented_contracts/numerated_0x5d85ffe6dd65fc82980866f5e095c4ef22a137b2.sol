1 pragma solidity ^0.5.2;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
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
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35      * @dev Multiplies two unsigned integers, reverts on overflow.
36      */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53      */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65      */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74      * @dev Adds two unsigned integers, reverts on overflow.
75      */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85      * reverts when dividing by zero.
86      */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * https://eips.ethereum.org/EIPS/eip-20
100  * Originally based on code by FirstBlood:
101  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  *
103  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
104  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
105  * compliant implementations may not do it.
106  */
107 contract ERC20 is IERC20 {
108     using SafeMath for uint256;
109 
110     mapping (address => uint256) private _balances;
111 
112     mapping (address => mapping (address => uint256)) private _allowed;
113 
114     uint256 private _totalSupply;
115 
116     /**
117      * @dev Total number of tokens in existence
118      */
119     function totalSupply() public view returns (uint256) {
120         return _totalSupply;
121     }
122 
123     /**
124      * @dev Gets the balance of the specified address.
125      * @param owner The address to query the balance of.
126      * @return A uint256 representing the amount owned by the passed address.
127      */
128     function balanceOf(address owner) public view returns (uint256) {
129         return _balances[owner];
130     }
131 
132     /**
133      * @dev Function to check the amount of tokens that an owner allowed to a spender.
134      * @param owner address The address which owns the funds.
135      * @param spender address The address which will spend the funds.
136      * @return A uint256 specifying the amount of tokens still available for the spender.
137      */
138     function allowance(address owner, address spender) public view returns (uint256) {
139         return _allowed[owner][spender];
140     }
141 
142     /**
143      * @dev Transfer token to a specified address
144      * @param to The address to transfer to.
145      * @param value The amount to be transferred.
146      */
147     function transfer(address to, uint256 value) public returns (bool) {
148         _transfer(msg.sender, to, value);
149         return true;
150     }
151 
152     /**
153      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154      * Beware that changing an allowance with this method brings the risk that someone may use both the old
155      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      * @param spender The address which will spend the funds.
159      * @param value The amount of tokens to be spent.
160      */
161     function approve(address spender, uint256 value) public returns (bool) {
162         _approve(msg.sender, spender, value);
163         return true;
164     }
165 
166     /**
167      * @dev Transfer tokens from one address to another.
168      * Note that while this function emits an Approval event, this is not required as per the specification,
169      * and other compliant implementations may not emit the event.
170      * @param from address The address which you want to send tokens from
171      * @param to address The address which you want to transfer to
172      * @param value uint256 the amount of tokens to be transferred
173      */
174     function transferFrom(address from, address to, uint256 value) public returns (bool) {
175         _transfer(from, to, value);
176         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
177         return true;
178     }
179 
180     /**
181      * @dev Increase the amount of tokens that an owner allowed to a spender.
182      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
183      * allowed value is better to use this function to avoid 2 calls (and wait until
184      * the first transaction is mined)
185      * From MonolithDAO Token.sol
186      * Emits an Approval event.
187      * @param spender The address which will spend the funds.
188      * @param addedValue The amount of tokens to increase the allowance by.
189      */
190     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
191         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
192         return true;
193     }
194 
195     /**
196      * @dev Decrease the amount of tokens that an owner allowed to a spender.
197      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
198      * allowed value is better to use this function to avoid 2 calls (and wait until
199      * the first transaction is mined)
200      * From MonolithDAO Token.sol
201      * Emits an Approval event.
202      * @param spender The address which will spend the funds.
203      * @param subtractedValue The amount of tokens to decrease the allowance by.
204      */
205     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
206         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
207         return true;
208     }
209 
210     /**
211      * @dev Transfer token for a specified addresses
212      * @param from The address to transfer from.
213      * @param to The address to transfer to.
214      * @param value The amount to be transferred.
215      */
216     function _transfer(address from, address to, uint256 value) internal {
217         require(to != address(0));
218 
219         _balances[from] = _balances[from].sub(value);
220         _balances[to] = _balances[to].add(value);
221         emit Transfer(from, to, value);
222     }
223 
224     /**
225      * @dev Internal function that mints an amount of the token and assigns it to
226      * an account. This encapsulates the modification of balances such that the
227      * proper events are emitted.
228      * @param account The account that will receive the created tokens.
229      * @param value The amount that will be created.
230      */
231     function _mint(address account, uint256 value) internal {
232         require(account != address(0));
233 
234         _totalSupply = _totalSupply.add(value);
235         _balances[account] = _balances[account].add(value);
236         emit Transfer(address(0), account, value);
237     }
238 
239     /**
240      * @dev Internal function that burns an amount of the token of a given
241      * account.
242      * @param account The account whose tokens will be burnt.
243      * @param value The amount that will be burnt.
244      */
245     function _burn(address account, uint256 value) internal {
246         require(account != address(0));
247 
248         _totalSupply = _totalSupply.sub(value);
249         _balances[account] = _balances[account].sub(value);
250         emit Transfer(account, address(0), value);
251     }
252 
253     /**
254      * @dev Approve an address to spend another addresses' tokens.
255      * @param owner The address that owns the tokens.
256      * @param spender The address that will spend the tokens.
257      * @param value The number of tokens that can be spent.
258      */
259     function _approve(address owner, address spender, uint256 value) internal {
260         require(spender != address(0));
261         require(owner != address(0));
262 
263         _allowed[owner][spender] = value;
264         emit Approval(owner, spender, value);
265     }
266 
267     /**
268      * @dev Internal function that burns an amount of the token of a given
269      * account, deducting from the sender's allowance for said account. Uses the
270      * internal burn function.
271      * Emits an Approval event (reflecting the reduced allowance).
272      * @param account The account whose tokens will be burnt.
273      * @param value The amount that will be burnt.
274      */
275     function _burnFrom(address account, uint256 value) internal {
276         _burn(account, value);
277         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
278     }
279 }
280 
281 // File: contracts/ERC1132/IERC1132.sol
282 
283 /**
284  * @title ERC1132 interface
285  * @dev see https://github.com/ethereum/EIPs/issues/1132
286  */
287 interface IERC1132 {
288   /**
289    * @dev Records data of all the tokens Locked
290    */
291   event Locked(
292     address indexed _of,
293     bytes32 indexed _reason,
294     uint256 _amount,
295     uint256 _validity
296   );
297 
298   /**
299    * @dev Records data of all the tokens unlocked
300    */
301   event Unlocked(
302     address indexed _of,
303     bytes32 indexed _reason,
304     uint256 _amount
305   );
306   
307   /**
308    * @dev Locks a specified amount of tokens against an address,
309    *   for a specified reason and time
310    * @param _reason The reason to lock tokens
311    * @param _amount Number of tokens to be locked
312    * @param _time Lock time in seconds
313    */
314   function lock(bytes32 _reason, uint256 _amount, uint256 _time)
315     external returns (bool);
316  
317   /**
318    * @dev Returns tokens locked for a specified address for a
319    *   specified reason
320    *
321    * @param _of The address whose tokens are locked
322    * @param _reason The reason to query the lock tokens for
323    */
324   function tokensLocked(address _of, bytes32 _reason)
325     external view returns (uint256 amount);
326   
327   /**
328    * @dev Returns tokens locked for a specified address for a
329    *   specified reason at a specific time
330    *
331    * @param _of The address whose tokens are locked
332    * @param _reason The reason to query the lock tokens for
333    * @param _time The timestamp to query the lock tokens for
334    */
335   function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
336     external view returns (uint256 amount);
337   
338   /**
339    * @dev Returns total tokens held by an address (locked + transferable)
340    * @param _of The address to query the total balance of
341    */
342   function totalBalanceOf(address _of)
343     external view returns (uint256 amount);
344   
345   /**
346    * @dev Extends lock for a specified reason and time
347    * @param _reason The reason to lock tokens
348    * @param _time Lock extension time in seconds
349    */
350   function extendLock(bytes32 _reason, uint256 _time)
351     external returns (bool);
352   
353   /**
354    * @dev Increase number of tokens locked for a specified reason
355    * @param _reason The reason to lock tokens
356    * @param _amount Number of tokens to be increased
357    */
358   function increaseLockAmount(bytes32 _reason, uint256 _amount)
359     external returns (bool);
360 
361   /**
362    * @dev Returns unlockable tokens for a specified address for a specified reason
363    * @param _of The address to query the the unlockable token count of
364    * @param _reason The reason to query the unlockable tokens for
365    */
366   function tokensUnlockable(address _of, bytes32 _reason)
367     external view returns (uint256 amount);
368  
369   /**
370    * @dev Unlocks the unlockable tokens of a specified address
371    * @param _of Address of user, claiming back unlockable tokens
372    */
373   function unlock(address _of)
374     external returns (uint256 unlockableTokens);
375 
376   /**
377    * @dev Gets the unlockable tokens of a specified address
378    * @param _of The address to query the the unlockable token count of
379    */
380   function getUnlockableTokens(address _of)
381     external view returns (uint256 unlockableTokens);
382 
383 }
384 
385 // File: contracts/ERC1132/ERC1132.sol
386 
387 /**
388  * @title Standard ERC1132 implementation
389  * @dev See https://github.com/OpenZeppelin/openzeppelin-solidity/pull/1298
390  */
391 contract ERC1132 is ERC20,  IERC1132 {
392   /**
393    * @dev Error messages for require statements
394    */
395   string internal constant ALREADY_LOCKED = "Tokens already locked";
396   string internal constant NOT_LOCKED = "No tokens locked";
397   string internal constant AMOUNT_ZERO = "Amount can not be 0";
398 
399   /**
400    * @dev Reasons why a user's tokens have been locked
401    */
402   mapping(address => bytes32[]) public lockReason;
403 
404   /**
405    * @dev locked token structure
406    */
407   struct LockToken {
408     uint256 amount;
409     uint256 validity;
410     bool claimed;
411   }
412 
413   /**
414    * @dev Holds number & validity of tokens locked for a given reason for
415    *   a specified address
416    */
417   mapping(address => mapping(bytes32 => LockToken)) public locked;
418 
419   /**
420    * @dev Locks a specified amount of tokens against an address,
421    *   for a specified reason and time
422    * @param _reason The reason to lock tokens
423    * @param _amount Number of tokens to be locked
424    * @param _time Lock time in seconds
425    */
426   function lock(bytes32 _reason, uint256 _amount, uint256 _time)
427     public
428     returns (bool)
429   {
430     // solium-disable-next-line security/no-block-members
431     uint256 validUntil = now.add(_time); //solhint-disable-line
432 
433     // If tokens are already locked, then functions extendLock or
434     // increaseLockAmount should be used to make any changes
435     require(tokensLocked(msg.sender, _reason) == 0, ALREADY_LOCKED);
436     require(_amount != 0, AMOUNT_ZERO);
437 
438     if (locked[msg.sender][_reason].amount == 0)
439       lockReason[msg.sender].push(_reason);
440 
441     transfer(address(this), _amount);
442 
443     locked[msg.sender][_reason] = LockToken(_amount, validUntil, false);
444 
445     emit Locked(
446       msg.sender,
447       _reason, 
448       _amount, 
449       validUntil
450     );
451     return true;
452   }
453   
454   /**
455    * @dev Transfers and Locks a specified amount of tokens,
456    *   for a specified reason and time
457    * @param _to adress to which tokens are to be transfered
458    * @param _reason The reason to lock tokens
459    * @param _amount Number of tokens to be transfered and locked
460    * @param _time Lock time in seconds
461    */
462   function transferWithLock(
463     address _to, 
464     bytes32 _reason, 
465     uint256 _amount, 
466     uint256 _time
467   )
468     public
469     returns (bool)
470   {
471     // solium-disable-next-line security/no-block-members
472     uint256 validUntil = now.add(_time); //solhint-disable-line
473 
474     require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);
475     require(_amount != 0, AMOUNT_ZERO);
476 
477     if (locked[_to][_reason].amount == 0)
478       lockReason[_to].push(_reason);
479 
480     transfer(address(this), _amount);
481 
482     locked[_to][_reason] = LockToken(_amount, validUntil, false);
483     
484     emit Locked(
485       _to, 
486       _reason, 
487       _amount, 
488       validUntil
489     );
490     return true;
491   }
492 
493   /**
494    * @dev Returns tokens locked for a specified address for a
495    *   specified reason
496    *
497    * @param _of The address whose tokens are locked
498    * @param _reason The reason to query the lock tokens for
499    */
500   function tokensLocked(address _of, bytes32 _reason)
501     public
502     view
503     returns (uint256 amount)
504   {
505     if (!locked[_of][_reason].claimed)
506       amount = locked[_of][_reason].amount;
507   }
508   
509   /**
510    * @dev Returns tokens locked for a specified address for a
511    *   specified reason at a specific time
512    *
513    * @param _of The address whose tokens are locked
514    * @param _reason The reason to query the lock tokens for
515    * @param _time The timestamp to query the lock tokens for
516    */
517   function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
518     public
519     view
520     returns (uint256 amount)
521   {
522     if (locked[_of][_reason].validity > _time)
523       amount = locked[_of][_reason].amount;
524   }
525 
526   /**
527    * @dev Returns total tokens held by an address (locked + transferable)
528    * @param _of The address to query the total balance of
529    */
530   function totalBalanceOf(address _of)
531     public
532     view
533     returns (uint256 amount)
534   {
535     amount = balanceOf(_of);
536 
537     for (uint256 i = 0; i < lockReason[_of].length; i++) {
538       amount = amount.add(tokensLocked(_of, lockReason[_of][i]));
539     }  
540   }  
541   
542   /**
543    * @dev Extends lock for a specified reason and time
544    * @param _reason The reason to lock tokens
545    * @param _time Lock extension time in seconds
546    */
547   function extendLock(bytes32 _reason, uint256 _time)
548     public
549     returns (bool)
550   {
551     require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
552 
553     locked[msg.sender][_reason].validity += _time;
554 
555     emit Locked(
556       msg.sender, _reason, 
557       locked[msg.sender][_reason].amount, 
558       locked[msg.sender][_reason].validity
559     );
560     return true;
561   }
562   
563   /**
564    * @dev Increase number of tokens locked for a specified reason
565    * @param _reason The reason to lock tokens
566    * @param _amount Number of tokens to be increased
567    */
568   function increaseLockAmount(bytes32 _reason, uint256 _amount)
569     public
570     returns (bool)
571   {
572     require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
573     transfer(address(this), _amount);
574 
575     locked[msg.sender][_reason].amount += _amount;
576 
577     emit Locked(
578       msg.sender, _reason, 
579       locked[msg.sender][_reason].amount,
580       locked[msg.sender][_reason].validity
581     );
582     return true;
583   }
584 
585   /**
586    * @dev Returns unlockable tokens for a specified address for a specified reason
587    * @param _of The address to query the the unlockable token count of
588    * @param _reason The reason to query the unlockable tokens for
589    */
590   function tokensUnlockable(address _of, bytes32 _reason)
591     public
592     view
593     returns (uint256 amount)
594   {
595     // solium-disable-next-line security/no-block-members
596     if (locked[_of][_reason].validity <= now && 
597       !locked[_of][_reason].claimed) 
598       amount = locked[_of][_reason].amount;
599   }
600 
601   /**
602    * @dev Unlocks the unlockable tokens of a specified address
603    * @param _of Address of user, claiming back unlockable tokens
604    */
605   function unlock(address _of)
606     public
607     returns (uint256 unlockableTokens)
608   {
609     uint256 lockedTokens;
610 
611     for (uint256 i = 0; i < lockReason[_of].length; i++) {
612       lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);
613       if (lockedTokens > 0) {
614         unlockableTokens = unlockableTokens.add(lockedTokens);
615         locked[_of][lockReason[_of][i]].claimed = true;
616         emit Unlocked(_of, lockReason[_of][i], lockedTokens);
617       }
618     } 
619 
620     if (unlockableTokens > 0)
621       this.transfer(_of, unlockableTokens);
622   }
623 
624   /**
625    * @dev Gets the unlockable tokens of a specified address
626    * @param _of The address to query the the unlockable token count of
627    */
628   function getUnlockableTokens(address _of)
629     public
630     view
631     returns (uint256 unlockableTokens)
632   {
633     for (uint256 i = 0; i < lockReason[_of].length; i++) {
634       unlockableTokens = unlockableTokens.add(
635         tokensUnlockable(_of, lockReason[_of][i])
636       );
637     } 
638   }
639 }
640 
641 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
642 
643 /**
644  * @title ERC20Detailed token
645  * @dev The decimals are only for visualization purposes.
646  * All the operations are done using the smallest and indivisible token unit,
647  * just as on Ethereum all the operations are done in wei.
648  */
649 contract ERC20Detailed is IERC20 {
650     string private _name;
651     string private _symbol;
652     uint8 private _decimals;
653 
654     constructor (string memory name, string memory symbol, uint8 decimals) public {
655         _name = name;
656         _symbol = symbol;
657         _decimals = decimals;
658     }
659 
660     /**
661      * @return the name of the token.
662      */
663     function name() public view returns (string memory) {
664         return _name;
665     }
666 
667     /**
668      * @return the symbol of the token.
669      */
670     function symbol() public view returns (string memory) {
671         return _symbol;
672     }
673 
674     /**
675      * @return the number of decimals of the token.
676      */
677     function decimals() public view returns (uint8) {
678         return _decimals;
679     }
680 }
681 
682 // File: openzeppelin-solidity/contracts/access/Roles.sol
683 
684 /**
685  * @title Roles
686  * @dev Library for managing addresses assigned to a Role.
687  */
688 library Roles {
689     struct Role {
690         mapping (address => bool) bearer;
691     }
692 
693     /**
694      * @dev give an account access to this role
695      */
696     function add(Role storage role, address account) internal {
697         require(account != address(0));
698         require(!has(role, account));
699 
700         role.bearer[account] = true;
701     }
702 
703     /**
704      * @dev remove an account's access to this role
705      */
706     function remove(Role storage role, address account) internal {
707         require(account != address(0));
708         require(has(role, account));
709 
710         role.bearer[account] = false;
711     }
712 
713     /**
714      * @dev check if an account has this role
715      * @return bool
716      */
717     function has(Role storage role, address account) internal view returns (bool) {
718         require(account != address(0));
719         return role.bearer[account];
720     }
721 }
722 
723 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
724 
725 contract MinterRole {
726     using Roles for Roles.Role;
727 
728     event MinterAdded(address indexed account);
729     event MinterRemoved(address indexed account);
730 
731     Roles.Role private _minters;
732 
733     constructor () internal {
734         _addMinter(msg.sender);
735     }
736 
737     modifier onlyMinter() {
738         require(isMinter(msg.sender));
739         _;
740     }
741 
742     function isMinter(address account) public view returns (bool) {
743         return _minters.has(account);
744     }
745 
746     function addMinter(address account) public onlyMinter {
747         _addMinter(account);
748     }
749 
750     function renounceMinter() public {
751         _removeMinter(msg.sender);
752     }
753 
754     function _addMinter(address account) internal {
755         _minters.add(account);
756         emit MinterAdded(account);
757     }
758 
759     function _removeMinter(address account) internal {
760         _minters.remove(account);
761         emit MinterRemoved(account);
762     }
763 }
764 
765 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
766 
767 /**
768  * @title ERC20Mintable
769  * @dev ERC20 minting logic
770  */
771 contract ERC20Mintable is ERC20, MinterRole {
772     /**
773      * @dev Function to mint tokens
774      * @param to The address that will receive the minted tokens.
775      * @param value The amount of tokens to mint.
776      * @return A boolean that indicates if the operation was successful.
777      */
778     function mint(address to, uint256 value) public onlyMinter returns (bool) {
779         _mint(to, value);
780         return true;
781     }
782 }
783 
784 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
785 
786 /**
787  * @title Burnable Token
788  * @dev Token that can be irreversibly burned (destroyed).
789  */
790 contract ERC20Burnable is ERC20 {
791     /**
792      * @dev Burns a specific amount of tokens.
793      * @param value The amount of token to be burned.
794      */
795     function burn(uint256 value) public {
796         _burn(msg.sender, value);
797     }
798 
799     /**
800      * @dev Burns a specific amount of tokens from the target address and decrements allowance
801      * @param from address The account whose tokens will be burned.
802      * @param value uint256 The amount of token to be burned.
803      */
804     function burnFrom(address from, uint256 value) public {
805         _burnFrom(from, value);
806     }
807 }
808 
809 // File: contracts/RebornDollar.sol
810 
811 contract RebornDollar is ERC1132, ERC20Detailed, ERC20Mintable, ERC20Burnable {
812   string public constant NAME = "Reborn Dollar";
813   string public constant SYMBOL = "REBD";
814   uint8 public constant DECIMALS = 18;
815 
816   uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(DECIMALS));
817 
818   constructor()
819     ERC20Burnable()
820     ERC20Mintable()
821     ERC20Detailed(NAME, SYMBOL, DECIMALS)
822     ERC20()
823     public
824   {
825     _mint(msg.sender, INITIAL_SUPPLY);
826   }
827 }