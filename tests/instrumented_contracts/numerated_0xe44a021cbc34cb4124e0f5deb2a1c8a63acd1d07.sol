1 pragma solidity 0.4.24;
2 
3 // File: ../../openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     function transfer(address to, uint256 value) external returns (bool);
17 
18     function approve(address spender, uint256 value) external returns (bool);
19 
20     function transferFrom(address from, address to, uint256 value) external returns (bool);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: ../../openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35     * @dev Multiplies two numbers, reverts on overflow.
36     */
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
52     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
53     */
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
64     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65     */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74     * @dev Adds two numbers, reverts on overflow.
75     */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
85     * reverts when dividing by zero.
86     */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 // File: ../../openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
100  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  *
102  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
103  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
104  * compliant implementations may not do it.
105  */
106 contract ERC20 is IERC20 {
107     using SafeMath for uint256;
108 
109     mapping (address => uint256) private _balances;
110 
111     mapping (address => mapping (address => uint256)) private _allowed;
112 
113     uint256 private _totalSupply;
114 
115     /**
116     * @dev Total number of tokens in existence
117     */
118     function totalSupply() public view returns (uint256) {
119         return _totalSupply;
120     }
121 
122     /**
123     * @dev Gets the balance of the specified address.
124     * @param owner The address to query the balance of.
125     * @return An uint256 representing the amount owned by the passed address.
126     */
127     function balanceOf(address owner) public view returns (uint256) {
128         return _balances[owner];
129     }
130 
131     /**
132      * @dev Function to check the amount of tokens that an owner allowed to a spender.
133      * @param owner address The address which owns the funds.
134      * @param spender address The address which will spend the funds.
135      * @return A uint256 specifying the amount of tokens still available for the spender.
136      */
137     function allowance(address owner, address spender) public view returns (uint256) {
138         return _allowed[owner][spender];
139     }
140 
141     /**
142     * @dev Transfer token for a specified address
143     * @param to The address to transfer to.
144     * @param value The amount to be transferred.
145     */
146     function transfer(address to, uint256 value) public returns (bool) {
147         _transfer(msg.sender, to, value);
148         return true;
149     }
150 
151     /**
152      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153      * Beware that changing an allowance with this method brings the risk that someone may use both the old
154      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      * @param spender The address which will spend the funds.
158      * @param value The amount of tokens to be spent.
159      */
160     function approve(address spender, uint256 value) public returns (bool) {
161         require(spender != address(0));
162 
163         _allowed[msg.sender][spender] = value;
164         emit Approval(msg.sender, spender, value);
165         return true;
166     }
167 
168     /**
169      * @dev Transfer tokens from one address to another.
170      * Note that while this function emits an Approval event, this is not required as per the specification,
171      * and other compliant implementations may not emit the event.
172      * @param from address The address which you want to send tokens from
173      * @param to address The address which you want to transfer to
174      * @param value uint256 the amount of tokens to be transferred
175      */
176     function transferFrom(address from, address to, uint256 value) public returns (bool) {
177         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
178         _transfer(from, to, value);
179         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
180         return true;
181     }
182 
183     /**
184      * @dev Increase the amount of tokens that an owner allowed to a spender.
185      * approve should be called when allowed_[_spender] == 0. To increment
186      * allowed value is better to use this function to avoid 2 calls (and wait until
187      * the first transaction is mined)
188      * From MonolithDAO Token.sol
189      * Emits an Approval event.
190      * @param spender The address which will spend the funds.
191      * @param addedValue The amount of tokens to increase the allowance by.
192      */
193     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
194         require(spender != address(0));
195 
196         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
197         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
198         return true;
199     }
200 
201     /**
202      * @dev Decrease the amount of tokens that an owner allowed to a spender.
203      * approve should be called when allowed_[_spender] == 0. To decrement
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * Emits an Approval event.
208      * @param spender The address which will spend the funds.
209      * @param subtractedValue The amount of tokens to decrease the allowance by.
210      */
211     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
212         require(spender != address(0));
213 
214         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
215         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
216         return true;
217     }
218 
219     /**
220     * @dev Transfer token for a specified addresses
221     * @param from The address to transfer from.
222     * @param to The address to transfer to.
223     * @param value The amount to be transferred.
224     */
225     function _transfer(address from, address to, uint256 value) internal {
226         require(to != address(0));
227 
228         _balances[from] = _balances[from].sub(value);
229         _balances[to] = _balances[to].add(value);
230         emit Transfer(from, to, value);
231     }
232 
233     /**
234      * @dev Internal function that mints an amount of the token and assigns it to
235      * an account. This encapsulates the modification of balances such that the
236      * proper events are emitted.
237      * @param account The account that will receive the created tokens.
238      * @param value The amount that will be created.
239      */
240     function _mint(address account, uint256 value) internal {
241         require(account != address(0));
242 
243         _totalSupply = _totalSupply.add(value);
244         _balances[account] = _balances[account].add(value);
245         emit Transfer(address(0), account, value);
246     }
247 
248     /**
249      * @dev Internal function that burns an amount of the token of a given
250      * account.
251      * @param account The account whose tokens will be burnt.
252      * @param value The amount that will be burnt.
253      */
254     function _burn(address account, uint256 value) internal {
255         require(account != address(0));
256 
257         _totalSupply = _totalSupply.sub(value);
258         _balances[account] = _balances[account].sub(value);
259         emit Transfer(account, address(0), value);
260     }
261 
262     /**
263      * @dev Internal function that burns an amount of the token of a given
264      * account, deducting from the sender's allowance for said account. Uses the
265      * internal burn function.
266      * Emits an Approval event (reflecting the reduced allowance).
267      * @param account The account whose tokens will be burnt.
268      * @param value The amount that will be burnt.
269      */
270     function _burnFrom(address account, uint256 value) internal {
271         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
272         _burn(account, value);
273         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
274     }
275 }
276 
277 // File: contracts/ERC1132.sol
278 
279 /**
280  * @title ERC1132 interface
281  * @dev see https://github.com/ethereum/EIPs/issues/1132
282  */
283 
284 contract ERC1132 {
285     /**
286      * @dev Reasons why a user's tokens have been locked
287      */
288     mapping(address => bytes32[]) public lockReason;
289 
290     /**
291      * @dev locked token structure
292      */
293     struct lockToken {
294         uint256 amount;
295         uint256 validity;
296         bool claimed;
297     }
298 
299     /**
300      * @dev Holds number & validity of tokens locked for a given reason for
301      *      a specified address
302      */
303     mapping(address => mapping(bytes32 => lockToken)) public locked;
304 
305     /**
306      * @dev Records data of all the tokens Locked
307      */
308     event Locked(
309         address indexed account,
310         bytes32 indexed reason,
311         uint256 amount,
312         uint256 validity
313     );
314 
315     /**
316      * @dev Records data of all the tokens unlocked
317      */
318     event Unlocked(
319         address indexed account,
320         bytes32 indexed reason,
321         uint256 amount
322     );
323 
324     /**
325      * @dev Locks a specified amount of tokens against an address,
326      *      for a specified reason and time
327      * @param reason The reason to lock tokens
328      * @param amount Number of tokens to be locked
329      * @param time Lock time in seconds
330      */
331     function lock(bytes32 reason, uint256 amount, uint256 time)
332         public returns (bool);
333 
334     /**
335      * @dev Returns tokens locked for a specified address for a
336      *      specified reason
337      *
338      * @param account The address whose tokens are locked
339      * @param reason The reason to query the lock tokens for
340      */
341     function tokensLocked(address account, bytes32 reason)
342         public view returns (uint256 amount);
343 
344     /**
345      * @dev Returns tokens locked for a specified address for a
346      *      specified reason at a specific time
347      *
348      * @param account The address whose tokens are locked
349      * @param reason The reason to query the lock tokens for
350      * @param time The timestamp to query the lock tokens for
351      */
352     function tokensLockedAtTime(address account, bytes32 reason, uint256 time)
353         public view returns (uint256 amount);
354 
355     /**
356      * @dev Returns total tokens held by an address (locked + transferable)
357      * @param who The address to query the total balance of
358      */
359     function totalBalanceOf(address who)
360         public view returns (uint256 amount);
361 
362     /**
363      * @dev Extends lock for a specified reason and time
364      * @param reason The reason to lock tokens
365      * @param time Lock extension time in seconds
366      */
367     function extendLock(bytes32 reason, uint256 time)
368         public returns (bool);
369 
370     /**
371      * @dev Increase number of tokens locked for a specified reason
372      * @param reason The reason to lock tokens
373      * @param amount Number of tokens to be increased
374      */
375     function increaseLockAmount(bytes32 reason, uint256 amount)
376         public returns (bool);
377 
378     /**
379      * @dev Returns unlockable tokens for a specified address for a specified reason
380      * @param who The address to query the the unlockable token count of
381      * @param reason The reason to query the unlockable tokens for
382      */
383     function tokensUnlockable(address who, bytes32 reason)
384         public view returns (uint256 amount);
385 
386     /**
387      * @dev Unlocks the unlockable tokens of a specified address
388      * @param account Address of user, claiming back unlockable tokens
389      */
390     function unlock(address account)
391         public returns (uint256 unlockableTokens);
392 
393     /**
394      * @dev Gets the unlockable tokens of a specified address
395      * @param account The address to query the the unlockable token count of
396      */
397     function getUnlockableTokens(address account)
398         public view returns (uint256 unlockableTokens);
399 
400 }
401 
402 // File: contracts/LockableToken.sol
403 
404 contract LockableToken is ERC1132, ERC20 {
405 
406    /**
407     * @dev Error messages for require statements
408     */
409     string internal constant ALREADY_LOCKED = "Tokens already locked";
410     string internal constant NOT_LOCKED = "No tokens locked";
411     string internal constant AMOUNT_ZERO = "Amount can not be 0";
412 
413    /**
414     * @dev constructor to mint initial tokens
415     * Shall update to _mint once openzepplin updates their npm package.
416     */
417     constructor(uint256 supply) public {
418         _mint(msg.sender, supply);
419     }
420 
421     /**
422      * @dev Locks a specified amount of tokens against an address,
423      *      for a specified reason and time
424      * @param reason The reason to lock tokens
425      * @param amount Number of tokens to be locked
426      * @param time Lock time in seconds
427      */
428     function lock(bytes32 reason, uint256 amount, uint256 time)
429         public
430         returns (bool)
431     {
432         uint256 validUntil = now.add(time); //solhint-disable-line
433 
434         // If tokens are already locked, then functions extendLock or
435         // increaseLockAmount should be used to make any changes
436         require(tokensLocked(msg.sender, reason) == 0, ALREADY_LOCKED);
437         require(amount != 0, AMOUNT_ZERO);
438 
439         if (locked[msg.sender][reason].amount == 0)
440             lockReason[msg.sender].push(reason);
441 
442         _transfer(msg.sender, address(this), amount);
443 
444         locked[msg.sender][reason] = lockToken(amount, validUntil, false);
445 
446         emit Locked(msg.sender, reason, amount, validUntil);
447         return true;
448     }
449 
450     /**
451      * @dev Transfers and Locks a specified amount of tokens,
452      *      for a specified reason and time
453      * @param to adress to which tokens are to be transfered
454      * @param reason The reason to lock tokens
455      * @param amount Number of tokens to be transfered and locked
456      * @param time Lock time in seconds
457      */
458     function transferWithLock(address to, bytes32 reason, uint256 amount, uint256 time)
459         public
460         returns (bool)
461     {
462         uint256 validUntil = now.add(time); //solhint-disable-line
463 
464         require(tokensLocked(to, reason) == 0, ALREADY_LOCKED);
465         require(amount != 0, AMOUNT_ZERO);
466 
467         if (locked[to][reason].amount == 0)
468             lockReason[to].push(reason);
469 
470         _transfer(msg.sender, address(this), amount);
471 
472         locked[to][reason] = lockToken(amount, validUntil, false);
473 
474         emit Locked(to, reason, amount, validUntil);
475         return true;
476     }
477 
478     /**
479      * @dev Returns tokens locked for a specified address for a
480      *      specified reason
481      *
482      * @param account The address whose tokens are locked
483      * @param reason The reason to query the lock tokens for
484      */
485     function tokensLocked(address account, bytes32 reason)
486         public
487         view
488         returns (uint256 amount)
489     {
490         if (!locked[account][reason].claimed)
491             amount = locked[account][reason].amount;
492     }
493 
494     /**
495      * @dev Returns tokens locked for a specified address for a
496      *      specified reason at a specific time
497      *
498      * @param account The address whose tokens are locked
499      * @param reason The reason to query the lock tokens for
500      * @param time The timestamp to query the lock tokens for
501      */
502     function tokensLockedAtTime(address account, bytes32 reason, uint256 time)
503         public
504         view
505         returns (uint256 amount)
506     {
507         if (locked[account][reason].validity > time)
508             amount = locked[account][reason].amount;
509     }
510 
511     /**
512      * @dev Returns total tokens held by an address (locked + transferable)
513      * @param who The address to query the total balance of
514      */
515     function totalBalanceOf(address who)
516         public
517         view
518         returns (uint256 amount)
519     {
520         amount = balanceOf(who);
521 
522         for (uint256 i = 0; i < lockReason[who].length; i++) {
523             amount = amount.add(tokensLocked(who, lockReason[who][i]));
524         }
525     }
526 
527     /**
528      * @dev Extends lock for a specified reason and time
529      * @param reason The reason to lock tokens
530      * @param time Lock extension time in seconds
531      */
532     function extendLock(bytes32 reason, uint256 time)
533         public
534         returns (bool)
535     {
536         require(tokensLocked(msg.sender, reason) > 0, NOT_LOCKED);
537 
538         locked[msg.sender][reason].validity = locked[msg.sender][reason].validity.add(time);
539 
540         emit Locked(msg.sender, reason, locked[msg.sender][reason].amount, locked[msg.sender][reason].validity);
541         return true;
542     }
543 
544     /**
545      * @dev Increase number of tokens locked for a specified reason
546      * @param reason The reason to lock tokens
547      * @param amount Number of tokens to be increased
548      */
549     function increaseLockAmount(bytes32 reason, uint256 amount)
550         public
551         returns (bool)
552     {
553         require(tokensLocked(msg.sender, reason) > 0, NOT_LOCKED);
554         _transfer(msg.sender, address(this), amount);
555 
556         locked[msg.sender][reason].amount = locked[msg.sender][reason].amount.add(amount);
557 
558         emit Locked(msg.sender, reason, locked[msg.sender][reason].amount, locked[msg.sender][reason].validity);
559         return true;
560     }
561 
562     /**
563      * @dev Returns unlockable tokens for a specified address for a specified reason
564      * @param who The address to query the the unlockable token count of
565      * @param reason The reason to query the unlockable tokens for
566      */
567     function tokensUnlockable(address who, bytes32 reason)
568         public
569         view
570         returns (uint256 amount)
571     {
572         if (locked[who][reason].validity <= now && !locked[who][reason].claimed) //solhint-disable-line
573             amount = locked[who][reason].amount;
574     }
575 
576     /**
577      * @dev Unlocks the unlockable tokens of a specified address
578      * @param account Address of user, claiming back unlockable tokens
579      */
580     function unlock(address account)
581         public
582         returns (uint256 unlockableTokens)
583     {
584         uint256 lockedTokens;
585 
586         for (uint256 i = 0; i < lockReason[account].length; i++) {
587             lockedTokens = tokensUnlockable(account, lockReason[account][i]);
588             if (lockedTokens > 0) {
589                 unlockableTokens = unlockableTokens.add(lockedTokens);
590                 locked[account][lockReason[account][i]].claimed = true;
591                 emit Unlocked(account, lockReason[account][i], lockedTokens);
592             }
593         }
594 
595         if (unlockableTokens > 0)
596             _transfer(address(this), account, unlockableTokens);
597     }
598 
599     /**
600      * @dev Gets the unlockable tokens of a specified address
601      * @param account The address to query the the unlockable token count of
602      */
603     function getUnlockableTokens(address account)
604         public
605         view
606         returns (uint256 unlockableTokens)
607     {
608         for (uint256 i = 0; i < lockReason[account].length; i++) {
609             unlockableTokens = unlockableTokens.add(tokensUnlockable(account, lockReason[account][i]));
610         }
611     }
612 }
613 
614 // File: ../../openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
615 
616 /**
617  * @title ERC20Detailed token
618  * @dev The decimals are only for visualization purposes.
619  * All the operations are done using the smallest and indivisible token unit,
620  * just as on Ethereum all the operations are done in wei.
621  */
622 contract ERC20Detailed is IERC20 {
623     string private _name;
624     string private _symbol;
625     uint8 private _decimals;
626 
627     constructor (string name, string symbol, uint8 decimals) public {
628         _name = name;
629         _symbol = symbol;
630         _decimals = decimals;
631     }
632 
633     /**
634      * @return the name of the token.
635      */
636     function name() public view returns (string) {
637         return _name;
638     }
639 
640     /**
641      * @return the symbol of the token.
642      */
643     function symbol() public view returns (string) {
644         return _symbol;
645     }
646 
647     /**
648      * @return the number of decimals of the token.
649      */
650     function decimals() public view returns (uint8) {
651         return _decimals;
652     }
653 }
654 
655 // File: contracts/BluenoteToken.sol
656 
657 contract BluenoteToken is LockableToken, ERC20Detailed {
658 
659 
660   /**
661    * @dev constructor to call constructors for LockableTocken and ERC20Detailed
662    *
663    */
664     constructor() public
665         ERC20Detailed("Bluenote World Token", "BNOW", 18)
666         LockableToken(12500000000000000000000000000) {
667         //
668     }
669 
670 
671 }