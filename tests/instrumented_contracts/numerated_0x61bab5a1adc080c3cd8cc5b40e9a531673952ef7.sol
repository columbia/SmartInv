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
287 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
288 
289 pragma solidity ^0.5.2;
290 
291 /**
292  * @title Ownable
293  * @dev The Ownable contract has an owner address, and provides basic authorization control
294  * functions, this simplifies the implementation of "user permissions".
295  */
296 contract Ownable {
297     address private _owner;
298 
299     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
300 
301     /**
302      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
303      * account.
304      */
305     constructor () internal {
306         _owner = msg.sender;
307         emit OwnershipTransferred(address(0), _owner);
308     }
309 
310     /**
311      * @return the address of the owner.
312      */
313     function owner() public view returns (address) {
314         return _owner;
315     }
316 
317     /**
318      * @dev Throws if called by any account other than the owner.
319      */
320     modifier onlyOwner() {
321         require(isOwner());
322         _;
323     }
324 
325     /**
326      * @return true if `msg.sender` is the owner of the contract.
327      */
328     function isOwner() public view returns (bool) {
329         return msg.sender == _owner;
330     }
331 
332     /**
333      * @dev Allows the current owner to relinquish control of the contract.
334      * It will not be possible to call the functions with the `onlyOwner`
335      * modifier anymore.
336      * @notice Renouncing ownership will leave the contract without an owner,
337      * thereby removing any functionality that is only available to the owner.
338      */
339     function renounceOwnership() public onlyOwner {
340         emit OwnershipTransferred(_owner, address(0));
341         _owner = address(0);
342     }
343 
344     /**
345      * @dev Allows the current owner to transfer control of the contract to a newOwner.
346      * @param newOwner The address to transfer ownership to.
347      */
348     function transferOwnership(address newOwner) public onlyOwner {
349         _transferOwnership(newOwner);
350     }
351 
352     /**
353      * @dev Transfers control of the contract to a newOwner.
354      * @param newOwner The address to transfer ownership to.
355      */
356     function _transferOwnership(address newOwner) internal {
357         require(newOwner != address(0));
358         emit OwnershipTransferred(_owner, newOwner);
359         _owner = newOwner;
360     }
361 }
362 
363 // File: contracts/ERC1132.sol
364 
365 pragma solidity 0.5.2;
366 
367 /**
368  * @title ERC1132 interface
369  * @dev see https://github.com/ethereum/EIPs/issues/1132
370  */
371 
372 contract ERC1132 {
373     /**
374      * @dev Reasons why a user's tokens have been locked
375      */
376     mapping(address => bytes32[]) public lockReason;
377 
378     /**
379      * @dev locked token structure
380      */
381     struct lockToken {
382         uint256 amount;
383         uint256 validity;
384         bool claimed;
385     }
386 
387     /**
388      * @dev Holds number & validity of tokens locked for a given reason for
389      *      a specified address
390      */
391     mapping(address => mapping(bytes32 => lockToken)) public locked;
392 
393     /**
394      * @dev Records data of all the tokens Locked
395      */
396     event Locked(
397         address indexed _of,
398         bytes32 indexed _reason,
399         uint256 _amount,
400         uint256 _validity
401     );
402 
403     /**
404      * @dev Records data of all the tokens unlocked
405      */
406     event Unlocked(
407         address indexed _of,
408         bytes32 indexed _reason,
409         uint256 _amount
410     );
411 
412     /**
413      * @dev Locks a specified amount of tokens against an address,
414      *      for a specified reason and time
415      * @param _reason The reason to lock tokens
416      * @param _amount Number of tokens to be locked
417      * @param _time Lock time in seconds
418      */
419     function lock(bytes32 _reason, uint256 _amount, uint256 _time)
420         public returns (bool);
421 
422     /**
423      * @dev Returns tokens locked for a specified address for a
424      *      specified reason
425      *
426      * @param _of The address whose tokens are locked
427      * @param _reason The reason to query the lock tokens for
428      */
429     function tokensLocked(address _of, bytes32 _reason)
430         public view returns (uint256 amount);
431 
432     /**
433      * @dev Returns tokens locked for a specified address for a
434      *      specified reason at a specific time
435      *
436      * @param _of The address whose tokens are locked
437      * @param _reason The reason to query the lock tokens for
438      * @param _time The timestamp to query the lock tokens for
439      */
440     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
441         public view returns (uint256 amount);
442 
443     /**
444      * @dev Returns total tokens held by an address (locked + transferable)
445      * @param _of The address to query the total balance of
446      */
447     function totalBalanceOf(address _of)
448         public view returns (uint256 amount);
449 
450     /**
451      * @dev Extends lock for a specified reason and time
452      * @param _reason The reason to lock tokens
453      * @param _time Lock extension time in seconds
454      */
455     function extendLock(bytes32 _reason, uint256 _time)
456         public returns (bool);
457 
458     /**
459      * @dev Increase number of tokens locked for a specified reason
460      * @param _reason The reason to lock tokens
461      * @param _amount Number of tokens to be increased
462      */
463     function increaseLockAmount(bytes32 _reason, uint256 _amount)
464         public returns (bool);
465 
466     /**
467      * @dev Returns unlockable tokens for a specified address for a specified reason
468      * @param _of The address to query the the unlockable token count of
469      * @param _reason The reason to query the unlockable tokens for
470      */
471     function tokensUnlockable(address _of, bytes32 _reason)
472         public view returns (uint256 amount);
473 
474     /**
475      * @dev Unlocks the unlockable tokens of a specified address
476      * @param _of Address of user, claiming back unlockable tokens
477      */
478     function unlock(address _of)
479         public returns (uint256 unlockableTokens);
480 
481     /**
482      * @dev Gets the unlockable tokens of a specified address
483      * @param _of The address to query the the unlockable token count of
484      */
485     function getUnlockableTokens(address _of)
486         public view returns (uint256 unlockableTokens);
487 
488 }
489 
490 // File: contracts/CoinButler.sol
491 
492 pragma solidity 0.5.2;
493 
494 
495 
496 
497 contract CoinButler is ERC1132, ERC20, Ownable {
498    /**
499     * @dev Error messages for require statements
500     */
501     string internal constant ALREADY_LOCKED = 'Tokens already locked';
502     string internal constant NOT_LOCKED = 'No tokens locked';
503     string internal constant AMOUNT_ZERO = 'Amount can not be 0';
504 
505     string public constant symbol = "CBT";
506     string public constant name = "CoinButler token";
507     uint8 public constant decimals = 18;
508     uint256 public constant TOTAL_SUPPLY = 2*(10**9)*(10**uint256(decimals));
509 
510    /**
511     * @dev constructor to mint initial tokens
512     * Shall update to _mint once openzepplin updates their npm package.
513     */
514     constructor() public {
515             _mint(msg.sender, TOTAL_SUPPLY);
516         }
517 
518     /**
519      * @dev Locks a specified amount of tokens against an address,
520      *      for a specified reason and time
521      * @param _reason The reason to lock tokens
522      * @param _amount Number of tokens to be locked
523      * @param _time Lock time in seconds
524      */
525     function lock(bytes32 _reason, uint256 _amount, uint256 _time)
526         public
527         returns (bool)
528     {
529         uint256 validUntil = now.add(_time); //solhint-disable-line
530 
531         // If tokens are already locked, then functions extendLock or
532         // increaseLockAmount should be used to make any changes
533         require(tokensLocked(msg.sender, _reason) == 0, ALREADY_LOCKED);
534         require(_amount != 0, AMOUNT_ZERO);
535 
536         if (locked[msg.sender][_reason].amount == 0)
537             lockReason[msg.sender].push(_reason);
538 
539         transfer(address(this), _amount);
540 
541         locked[msg.sender][_reason] = lockToken(_amount, validUntil, false);
542 
543         emit Locked(msg.sender, _reason, _amount, validUntil);
544         return true;
545     }
546 
547     /**
548      * @dev Transfers and Locks a specified amount of tokens,
549      *      for a specified reason and time
550      * @param _to adress to which tokens are to be transfered
551      * @param _reason The reason to lock tokens
552      * @param _amount Number of tokens to be transfered and locked
553      * @param _time Lock time in seconds
554      */
555     function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time)
556         public
557         returns (bool)
558     {
559         uint256 validUntil = now.add(_time); //solhint-disable-line
560 
561         require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);
562         require(_amount != 0, AMOUNT_ZERO);
563 
564         if (locked[_to][_reason].amount == 0)
565             lockReason[_to].push(_reason);
566 
567         transfer(address(this), _amount);
568 
569         locked[_to][_reason] = lockToken(_amount, validUntil, false);
570 
571         emit Locked(_to, _reason, _amount, validUntil);
572         return true;
573     }
574 
575     /**
576      * @dev Returns tokens locked for a specified address for a
577      *      specified reason
578      *
579      * @param _of The address whose tokens are locked
580      * @param _reason The reason to query the lock tokens for
581      */
582     function tokensLocked(address _of, bytes32 _reason)
583         public
584         view
585         returns (uint256 amount)
586     {
587         if (!locked[_of][_reason].claimed)
588             amount = locked[_of][_reason].amount;
589     }
590 
591     /**
592      * @dev Returns tokens locked for a specified address for a
593      *      specified reason at a specific time
594      *
595      * @param _of The address whose tokens are locked
596      * @param _reason The reason to query the lock tokens for
597      * @param _time The timestamp to query the lock tokens for
598      */
599     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
600         public
601         view
602         returns (uint256 amount)
603     {
604         if (locked[_of][_reason].validity > _time)
605             amount = locked[_of][_reason].amount;
606     }
607 
608     /**
609      * @dev Returns total tokens held by an address (locked + transferable)
610      * @param _of The address to query the total balance of
611      */
612     function totalBalanceOf(address _of)
613         public
614         view
615         returns (uint256 amount)
616     {
617         amount = balanceOf(_of);
618 
619         for (uint256 i = 0; i < lockReason[_of].length; i++) {
620             amount = amount.add(tokensLocked(_of, lockReason[_of][i]));
621         }
622     }
623 
624     /**
625      * @dev Extends lock for a specified reason and time
626      * @param _reason The reason to lock tokens
627      * @param _time Lock extension time in seconds
628      */
629     function extendLock(bytes32 _reason, uint256 _time)
630         public
631         returns (bool)
632     {
633         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
634 
635         locked[msg.sender][_reason].validity = locked[msg.sender][_reason].validity.add(_time);
636 
637         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
638         return true;
639     }
640 
641     /**
642      * @dev Increase number of tokens locked for a specified reason
643      * @param _reason The reason to lock tokens
644      * @param _amount Number of tokens to be increased
645      */
646     function increaseLockAmount(bytes32 _reason, uint256 _amount)
647         public
648         returns (bool)
649     {
650         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
651         transfer(address(this), _amount);
652 
653         locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);
654 
655         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
656         return true;
657     }
658 
659     /**
660      * @dev Returns unlockable tokens for a specified address for a specified reason
661      * @param _of The address to query the the unlockable token count of
662      * @param _reason The reason to query the unlockable tokens for
663      */
664     function tokensUnlockable(address _of, bytes32 _reason)
665         public
666         view
667         returns (uint256 amount)
668     {
669         if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) //solhint-disable-line
670             amount = locked[_of][_reason].amount;
671     }
672 
673     /**
674      * @dev Unlocks the unlockable tokens of a specified address
675      * @param _of Address of user, claiming back unlockable tokens
676      */
677     function unlock(address _of)
678         public
679         returns (uint256 unlockableTokens)
680     {
681         uint256 lockedTokens;
682 
683         for (uint256 i = 0; i < lockReason[_of].length; i++) {
684             lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);
685             if (lockedTokens > 0) {
686                 unlockableTokens = unlockableTokens.add(lockedTokens);
687                 locked[_of][lockReason[_of][i]].claimed = true;
688                 emit Unlocked(_of, lockReason[_of][i], lockedTokens);
689             }
690         }
691 
692         if (unlockableTokens > 0)
693             this.transfer(_of, unlockableTokens);
694     }
695 
696     /**
697      * @dev Gets the unlockable tokens of a specified address
698      * @param _of The address to query the the unlockable token count of
699      */
700     function getUnlockableTokens(address _of)
701         public
702         view
703         returns (uint256 unlockableTokens)
704     {
705         for (uint256 i = 0; i < lockReason[_of].length; i++) {
706             unlockableTokens = unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));
707         }
708     }
709 
710     function recoverERC20(uint256 tokenAmount) public onlyOwner {
711         this.transfer(owner(), tokenAmount);
712     }
713 }