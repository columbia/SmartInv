1 pragma solidity 0.4.25;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 
37 /**
38  * @title ERC20Detailed token
39  * @dev The decimals are only for visualization purposes.
40  * All the operations are done using the smallest and indivisible token unit,
41  * just as on Ethereum all the operations are done in wei.
42  */
43 contract ERC20Detailed is IERC20 {
44     string private _name;
45     string private _symbol;
46     uint8 private _decimals;
47 
48     constructor(string name, string symbol, uint8 decimals) public {
49         _name = name;
50         _symbol = symbol;
51         _decimals = decimals;
52     }
53 
54     /**
55     * @return the name of the token.
56     */
57     function name() public view returns(string) {
58         return _name;
59     }
60 
61     /**
62     * @return the symbol of the token.
63     */
64     function symbol() public view returns(string) {
65         return _symbol;
66     }
67 
68     /**
69     * @return the number of decimals of the token.
70     */
71     function decimals() public view returns(uint8) {
72         return _decimals;
73     }
74 }
75 
76 
77 /**
78  * @title SafeMath
79  * @dev Math operations with safety checks that revert on error
80  */
81 library SafeMath {
82 
83   /**
84   * @dev Multiplies two numbers, reverts on overflow.
85   */
86   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88     // benefit is lost if 'b' is also tested.
89     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
90     if (a == 0) {
91       return 0;
92     }
93 
94     uint256 c = a * b;
95     require(c / a == b);
96 
97     return c;
98   }
99 
100   /**
101   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
102   */
103   function div(uint256 a, uint256 b) internal pure returns (uint256) {
104     require(b > 0); // Solidity only automatically asserts when dividing by 0
105     uint256 c = a / b;
106     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107 
108     return c;
109   }
110 
111   /**
112   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
113   */
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     require(b <= a);
116     uint256 c = a - b;
117 
118     return c;
119   }
120 
121   /**
122   * @dev Adds two numbers, reverts on overflow.
123   */
124   function add(uint256 a, uint256 b) internal pure returns (uint256) {
125     uint256 c = a + b;
126     require(c >= a);
127 
128     return c;
129   }
130 
131   /**
132   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
133   * reverts when dividing by zero.
134   */
135   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136     require(b != 0);
137     return a % b;
138   }
139 }
140 
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
147  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  */
149 contract ERC20 is IERC20 {
150   using SafeMath for uint256;
151 
152   mapping (address => uint256) private _balances;
153 
154   mapping (address => mapping (address => uint256)) private _allowed;
155 
156   uint256 private _totalSupply;
157 
158   /**
159   * @dev Total number of tokens in existence
160   */
161   function totalSupply() public view returns (uint256) {
162     return _totalSupply;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param owner The address to query the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address owner) public view returns (uint256) {
171     return _balances[owner];
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param owner address The address which owns the funds.
177    * @param spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(
181     address owner,
182     address spender
183    )
184     public
185     view
186     returns (uint256)
187   {
188     return _allowed[owner][spender];
189   }
190 
191   /**
192   * @dev Transfer token for a specified address
193   * @param to The address to transfer to.
194   * @param value The amount to be transferred.
195   */
196   function transfer(address to, uint256 value) public returns (bool) {
197     _transfer(msg.sender, to, value);
198     return true;
199   }
200 
201   /**
202    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
203    * Beware that changing an allowance with this method brings the risk that someone may use both the old
204    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
205    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
206    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207    * @param spender The address which will spend the funds.
208    * @param value The amount of tokens to be spent.
209    */
210   function approve(address spender, uint256 value) public returns (bool) {
211     require(spender != address(0));
212 
213     _allowed[msg.sender][spender] = value;
214     emit Approval(msg.sender, spender, value);
215     return true;
216   }
217 
218   /**
219    * @dev Transfer tokens from one address to another
220    * @param from address The address which you want to send tokens from
221    * @param to address The address which you want to transfer to
222    * @param value uint256 the amount of tokens to be transferred
223    */
224   function transferFrom(
225     address from,
226     address to,
227     uint256 value
228   )
229     public
230     returns (bool)
231   {
232     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
233     _transfer(from, to, value);
234     return true;
235   }
236 
237   /**
238    * @dev Increase the amount of tokens that an owner allowed to a spender.
239    * approve should be called when allowed_[_spender] == 0. To increment
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param spender The address which will spend the funds.
244    * @param addedValue The amount of tokens to increase the allowance by.
245    */
246   function increaseAllowance(
247     address spender,
248     uint256 addedValue
249   )
250     public
251     returns (bool)
252   {
253     require(spender != address(0));
254 
255     _allowed[msg.sender][spender] = (
256       _allowed[msg.sender][spender].add(addedValue));
257     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
258     return true;
259   }
260 
261   /**
262    * @dev Decrease the amount of tokens that an owner allowed to a spender.
263    * approve should be called when allowed_[_spender] == 0. To decrement
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param spender The address which will spend the funds.
268    * @param subtractedValue The amount of tokens to decrease the allowance by.
269    */
270   function decreaseAllowance(
271     address spender,
272     uint256 subtractedValue
273   )
274     public
275     returns (bool)
276   {
277     require(spender != address(0));
278 
279     _allowed[msg.sender][spender] = (
280       _allowed[msg.sender][spender].sub(subtractedValue));
281     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
282     return true;
283   }
284 
285   /**
286   * @dev Transfer token for a specified addresses
287   * @param from The address to transfer from.
288   * @param to The address to transfer to.
289   * @param value The amount to be transferred.
290   */
291   function _transfer(address from, address to, uint256 value) internal {
292     require(to != address(0));
293 
294     _balances[from] = _balances[from].sub(value);
295     _balances[to] = _balances[to].add(value);
296     emit Transfer(from, to, value);
297   }
298 
299   /**
300    * @dev Internal function that mints an amount of the token and assigns it to
301    * an account. This encapsulates the modification of balances such that the
302    * proper events are emitted.
303    * @param account The account that will receive the created tokens.
304    * @param value The amount that will be created.
305    */
306   function _mint(address account, uint256 value) internal {
307     require(account != address(0));
308 
309     _totalSupply = _totalSupply.add(value);
310     _balances[account] = _balances[account].add(value);
311     emit Transfer(address(0), account, value);
312   }
313 
314   /**
315    * @dev Internal function that burns an amount of the token of a given
316    * account.
317    * @param account The account whose tokens will be burnt.
318    * @param value The amount that will be burnt.
319    */
320   function _burn(address account, uint256 value) internal {
321     require(account != address(0));
322 
323     _totalSupply = _totalSupply.sub(value);
324     _balances[account] = _balances[account].sub(value);
325     emit Transfer(account, address(0), value);
326   }
327 
328   /**
329    * @dev Internal function that burns an amount of the token of a given
330    * account, deducting from the sender's allowance for said account. Uses the
331    * internal burn function.
332    * @param account The account whose tokens will be burnt.
333    * @param value The amount that will be burnt.
334    */
335   function _burnFrom(address account, uint256 value) internal {
336     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
337     // this function needs to emit an event with the updated approval.
338     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
339       value);
340     _burn(account, value);
341   }
342 }
343 
344 
345 /**
346  * @title Roles
347  * @dev Library for managing addresses assigned to a Role.
348  */
349 library Roles {
350   struct Role {
351     mapping (address => bool) bearer;
352   }
353 
354   /**
355    * @dev give an account access to this role
356    */
357   function add(Role storage role, address account) internal {
358     require(account != address(0));
359     require(!has(role, account));
360 
361     role.bearer[account] = true;
362   }
363 
364   /**
365    * @dev remove an account's access to this role
366    */
367   function remove(Role storage role, address account) internal {
368     require(account != address(0));
369     require(has(role, account));
370 
371     role.bearer[account] = false;
372   }
373 
374   /**
375    * @dev check if an account has this role
376    * @return bool
377    */
378   function has(Role storage role, address account)
379     internal
380     view
381     returns (bool)
382   {
383     require(account != address(0));
384     return role.bearer[account];
385   }
386 }
387 
388 
389 contract PauserRole {
390   using Roles for Roles.Role;
391 
392   event PauserAdded(address indexed account);
393   event PauserRemoved(address indexed account);
394 
395   Roles.Role private _pausers;
396 
397   constructor() internal {
398     _addPauser(msg.sender);
399   }
400 
401   modifier onlyPauser() {
402     require(isPauser(msg.sender));
403     _;
404   }
405 
406   function isPauser(address account) public view returns (bool) {
407     return _pausers.has(account);
408   }
409 
410   function addPauser(address account) public onlyPauser {
411     _addPauser(account);
412   }
413 
414   function renouncePauser() public {
415     _removePauser(msg.sender);
416   }
417 
418   function _addPauser(address account) internal {
419     _pausers.add(account);
420     emit PauserAdded(account);
421   }
422 
423   function _removePauser(address account) internal {
424     _pausers.remove(account);
425     emit PauserRemoved(account);
426   }
427 }
428 
429 
430 /**
431  * @title Pausable
432  * @dev Base contract which allows children to implement an emergency stop mechanism.
433  */
434 contract Pausable is PauserRole {
435     event Paused(address account);
436     event Unpaused(address account);
437 
438     bool private _paused;
439 
440     constructor() internal {
441         _paused = false;
442     }
443 
444     /**
445     * @return true if the contract is paused, false otherwise.
446     */
447     function paused() public view returns(bool) {
448         return _paused;
449     }
450 
451     /**
452     * @dev Modifier to make a function callable only when the contract is not paused.
453     */
454     modifier whenNotPaused() {
455         require(!_paused);
456         _;
457     }
458 
459     /**
460     * @dev Modifier to make a function callable only when the contract is paused.
461     */
462     modifier whenPaused() {
463         require(_paused);
464         _;
465     }
466 
467     /**
468     * @dev called by the owner to pause, triggers stopped state
469     */
470     function pause() public onlyPauser whenNotPaused {
471         _paused = true;
472         emit Paused(msg.sender);
473     }
474 
475     /**
476     * @dev called by the owner to unpause, returns to normal state
477     */
478     function unpause() public onlyPauser whenPaused {
479         _paused = false;
480         emit Unpaused(msg.sender);
481     }
482 }
483 
484 
485 /**
486  * @title Pausable token
487  * @dev ERC20 modified with pausable transfers.
488  **/
489 contract ERC20Pausable is ERC20, Pausable {
490 
491   function transfer(
492     address to,
493     uint256 value
494   )
495     public
496     whenNotPaused
497     returns (bool)
498   {
499     return super.transfer(to, value);
500   }
501 
502   function transferFrom(
503     address from,
504     address to,
505     uint256 value
506   )
507     public
508     whenNotPaused
509     returns (bool)
510   {
511     return super.transferFrom(from, to, value);
512   }
513 
514   function approve(
515     address spender,
516     uint256 value
517   )
518     public
519     whenNotPaused
520     returns (bool)
521   {
522     return super.approve(spender, value);
523   }
524 
525   function increaseAllowance(
526     address spender,
527     uint addedValue
528   )
529     public
530     whenNotPaused
531     returns (bool success)
532   {
533     return super.increaseAllowance(spender, addedValue);
534   }
535 
536   function decreaseAllowance(
537     address spender,
538     uint subtractedValue
539   )
540     public
541     whenNotPaused
542     returns (bool success)
543   {
544     return super.decreaseAllowance(spender, subtractedValue);
545   }
546 }
547 
548 
549 contract MinterRole {
550   using Roles for Roles.Role;
551 
552   event MinterAdded(address indexed account);
553   event MinterRemoved(address indexed account);
554 
555   Roles.Role private _minters;
556 
557   constructor() internal {
558     _addMinter(msg.sender);
559   }
560 
561   modifier onlyMinter() {
562     require(isMinter(msg.sender));
563     _;
564   }
565 
566   function isMinter(address account) public view returns (bool) {
567     return _minters.has(account);
568   }
569 
570   function addMinter(address account) public onlyMinter {
571     _addMinter(account);
572   }
573 
574   function renounceMinter() public {
575     _removeMinter(msg.sender);
576   }
577 
578   function _addMinter(address account) internal {
579     _minters.add(account);
580     emit MinterAdded(account);
581   }
582 
583   function _removeMinter(address account) internal {
584     _minters.remove(account);
585     emit MinterRemoved(account);
586   }
587 }
588 
589 
590 /**
591  * @title ERC20Mintable
592  * @dev ERC20 minting logic
593  */
594 contract ERC20Mintable is ERC20, MinterRole {
595   /**
596    * @dev Function to mint tokens
597    * @param to The address that will receive the minted tokens.
598    * @param value The amount of tokens to mint.
599    * @return A boolean that indicates if the operation was successful.
600    */
601   function mint(
602     address to,
603     uint256 value
604   )
605     public
606     onlyMinter
607     returns (bool)
608   {
609     _mint(to, value);
610     return true;
611   }
612 }
613 
614 
615 /**
616  * @title Capped token
617  * @dev Mintable token with a token cap.
618  */
619 contract ERC20Capped is ERC20Mintable {
620 
621   uint256 private _cap;
622 
623   constructor(uint256 cap)
624     public
625   {
626     require(cap > 0);
627     _cap = cap;
628   }
629 
630   /**
631    * @return the cap for the token minting.
632    */
633   function cap() public view returns(uint256) {
634     return _cap;
635   }
636 
637   function _mint(address account, uint256 value) internal {
638     require(totalSupply().add(value) <= _cap);
639     super._mint(account, value);
640   }
641 }
642 
643 
644 /**
645  * @title Ownable
646  * @dev The Ownable contract has an owner address, and provides basic authorization control
647  * functions, this simplifies the implementation of "user permissions".
648  */
649 contract Ownable {
650   address private _owner;
651 
652   event OwnershipTransferred(
653     address indexed previousOwner,
654     address indexed newOwner
655   );
656 
657   /**
658    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
659    * account.
660    */
661   constructor() internal {
662     _owner = msg.sender;
663     emit OwnershipTransferred(address(0), _owner);
664   }
665 
666   /**
667    * @return the address of the owner.
668    */
669   function owner() public view returns(address) {
670     return _owner;
671   }
672 
673   /**
674    * @dev Throws if called by any account other than the owner.
675    */
676   modifier onlyOwner() {
677     require(isOwner());
678     _;
679   }
680 
681   /**
682    * @return true if `msg.sender` is the owner of the contract.
683    */
684   function isOwner() public view returns(bool) {
685     return msg.sender == _owner;
686   }
687 
688   /**
689    * @dev Allows the current owner to relinquish control of the contract.
690    * @notice Renouncing to ownership will leave the contract without an owner.
691    * It will not be possible to call the functions with the `onlyOwner`
692    * modifier anymore.
693    */
694   function renounceOwnership() public onlyOwner {
695     emit OwnershipTransferred(_owner, address(0));
696     _owner = address(0);
697   }
698 
699   /**
700    * @dev Allows the current owner to transfer control of the contract to a newOwner.
701    * @param newOwner The address to transfer ownership to.
702    */
703   function transferOwnership(address newOwner) public onlyOwner {
704     _transferOwnership(newOwner);
705   }
706 
707   /**
708    * @dev Transfers control of the contract to a newOwner.
709    * @param newOwner The address to transfer ownership to.
710    */
711   function _transferOwnership(address newOwner) internal {
712     require(newOwner != address(0));
713     emit OwnershipTransferred(_owner, newOwner);
714     _owner = newOwner;
715   }
716 }
717 
718 
719 /**
720  * @title Standard ERC20 token, with capped minting and pause functionality.
721  *
722  */
723 contract BambooToken is 
724     ERC20Detailed, 
725     ERC20Capped, /* is ERC20Mintable */
726     ERC20Pausable,
727     Ownable {
728 
729         /**
730          * @dev Constructor for the Bamboo Token.
731          * @param name the name of the token.
732          * @param symbol the symbol of the token.
733          * @param decimals the number of decimals of the token.
734          * @param cap the token cap (maximum possible tokens).
735          */
736     constructor(
737         string name, 
738         string symbol, 
739         uint8 decimals, 
740         uint256 cap)
741         ERC20Detailed(name, symbol, decimals)
742         ERC20Capped(cap) public {
743             // Pause contract (tokens are initially non-transferable)
744             pause();
745     }
746 
747   /**
748    * @dev Function to mint tokens for multiple addresses at a time.
749    * @param addresses the array of addresses that will receive the minted tokens.
750    * @param values the array of the amount of tokens to mint for each address.
751    */
752     function multiMint (address[] addresses, uint256[] values) public onlyMinter {
753         require(addresses.length > 0);
754         require(addresses.length == values.length);
755 
756         for (uint256 i = 0; i < addresses.length; i++) {
757             mint(addresses[i], values[i]);
758         }
759     }
760 
761 }