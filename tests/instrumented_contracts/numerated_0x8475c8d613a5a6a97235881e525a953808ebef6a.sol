1 pragma solidity ^0.4.24;
2 /**
3  * @title Roles
4  * @dev Library for managing addresses assigned to a Role.
5  */
6 library Roles {
7   struct Role {
8     mapping (address => bool) bearer;
9   }
10   /**
11    * @dev give an account access to this role
12    */
13   function add(Role storage role, address account) internal {
14     require(account != address(0));
15     require(!has(role, account));
16     role.bearer[account] = true;
17   }
18   /**
19    * @dev remove an account's access to this role
20    */
21   function remove(Role storage role, address account) internal {
22     require(account != address(0));
23     require(has(role, account));
24     role.bearer[account] = false;
25   }
26   /**
27    * @dev check if an account has this role
28    * @return bool
29    */
30   function has(Role storage role, address account)
31     internal
32     view
33     returns (bool)
34   {
35     require(account != address(0));
36     return role.bearer[account];
37   }
38 }
39 contract PauserRole {
40   using Roles for Roles.Role;
41   event PauserAdded(address indexed account);
42   event PauserRemoved(address indexed account);
43   Roles.Role private pausers;
44   constructor() internal {
45     _addPauser(msg.sender);
46   }
47   modifier onlyPauser() {
48     require(isPauser(msg.sender));
49     _;
50   }
51   function isPauser(address account) public view returns (bool) {
52     return pausers.has(account);
53   }
54   function addPauser(address account) public onlyPauser {
55     _addPauser(account);
56   }
57   function renouncePauser() public {
58     _removePauser(msg.sender);
59   }
60   function _addPauser(address account) internal {
61     pausers.add(account);
62     emit PauserAdded(account);
63   }
64   function _removePauser(address account) internal {
65     pausers.remove(account);
66     emit PauserRemoved(account);
67   }
68 }
69 contract CapperRole {
70   using Roles for Roles.Role;
71   event CapperAdded(address indexed account);
72   event CapperRemoved(address indexed account);
73   Roles.Role private cappers;
74   constructor() internal {
75     _addCapper(msg.sender);
76   }
77   modifier onlyCapper() {
78     require(isCapper(msg.sender));
79     _;
80   }
81   function isCapper(address account) public view returns (bool) {
82     return cappers.has(account);
83   }
84   function addCapper(address account) public onlyCapper {
85     _addCapper(account);
86   }
87   function renounceCapper() public {
88     _removeCapper(msg.sender);
89   }
90   function _addCapper(address account) internal {
91     cappers.add(account);
92     emit CapperAdded(account);
93   }
94   function _removeCapper(address account) internal {
95     cappers.remove(account);
96     emit CapperRemoved(account);
97   }
98 }
99 contract MinterRole {
100   using Roles for Roles.Role;
101   event MinterAdded(address indexed account);
102   event MinterRemoved(address indexed account);
103   Roles.Role private minters;
104   constructor() internal {
105     _addMinter(msg.sender);
106   }
107   modifier onlyMinter() {
108     require(isMinter(msg.sender));
109     _;
110   }
111   function isMinter(address account) public view returns (bool) {
112     return minters.has(account);
113   }
114   function addMinter(address account) public onlyMinter {
115     _addMinter(account);
116   }
117   function renounceMinter() public {
118     _removeMinter(msg.sender);
119   }
120   function _addMinter(address account) internal {
121     minters.add(account);
122     emit MinterAdded(account);
123   }
124   function _removeMinter(address account) internal {
125     minters.remove(account);
126     emit MinterRemoved(account);
127   }
128 }
129 /**
130  * @title ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/20
132  */
133 interface IERC20 {
134   function totalSupply() external view returns (uint256);
135   function balanceOf(address who) external view returns (uint256);
136   function allowance(address owner, address spender)
137     external view returns (uint256);
138   function transfer(address to, uint256 value) external returns (bool);
139   function approve(address spender, uint256 value)
140     external returns (bool);
141   function transferFrom(address from, address to, uint256 value)
142     external returns (bool);
143   event Transfer(
144     address indexed from,
145     address indexed to,
146     uint256 value
147   );
148   event Approval(
149     address indexed owner,
150     address indexed spender,
151     uint256 value
152   );
153 }
154 /**
155  * @title SafeMath
156  * @dev Math operations with safety checks that revert on error
157  */
158 library SafeMath {
159   /**
160   * @dev Multiplies two numbers, reverts on overflow.
161   */
162   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
164     // benefit is lost if 'b' is also tested.
165     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
166     if (a == 0) {
167       return 0;
168     }
169     uint256 c = a * b;
170     require(c / a == b);
171     return c;
172   }
173   /**
174   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
175   */
176   function div(uint256 a, uint256 b) internal pure returns (uint256) {
177     require(b > 0); // Solidity only automatically asserts when dividing by 0
178     uint256 c = a / b;
179     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
180     return c;
181   }
182   /**
183   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
184   */
185   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
186     require(b <= a);
187     uint256 c = a - b;
188     return c;
189   }
190   /**
191   * @dev Adds two numbers, reverts on overflow.
192   */
193   function add(uint256 a, uint256 b) internal pure returns (uint256) {
194     uint256 c = a + b;
195     require(c >= a);
196     return c;
197   }
198   /**
199   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
200   * reverts when dividing by zero.
201   */
202   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
203     require(b != 0);
204     return a % b;
205   }
206 }
207 contract ERC20 is IERC20, MinterRole {
208   using SafeMath for uint256;
209   mapping (address => uint256) private _balances;
210   mapping (address => mapping (address => uint256)) private _allowed;
211   mapping(address => bool) mastercardUsers;
212   mapping(address => bool) SGCUsers;
213   bool public walletLock;
214   bool public publicLock;
215   uint256 private _totalSupply;
216   /**
217   * @dev Total number of coins in existence
218   */
219   function totalSupply() public view returns (uint256) {
220     return _totalSupply;
221   }
222   /**
223   * @dev Total number of coins in existence
224   */
225   function walletLock() public view returns (bool) {
226     return walletLock;
227   }
228   /**
229   * @dev Gets the balance of the specified address.
230   * @param owner The address to query the balance of.
231   * @return An uint256 representing the amount owned by the passed address.
232   */
233   function balanceOf(address owner) public view returns (uint256) {
234     return _balances[owner];
235   }
236   /**
237    * @dev Function to check the amount of coins that an owner allowed to a spender.
238    * @param owner address The address which owns the funds.
239    * @param spender address The address which will spend the funds.
240    * @return A uint256 specifying the amount of coins still available for the spender.
241    */
242   function allowance(
243     address owner,
244     address spender
245    )
246     public
247     view
248     returns (uint256)
249   {
250     return _allowed[owner][spender];
251   }
252   /**
253   * @dev Transfer coin for a specified address
254   * @param to The address to transfer to.
255   * @param value The amount to be transferred.
256   */
257   function transfer(address to, uint256 value) public returns (bool) {
258     _transfer(msg.sender, to, value);
259     return true;
260   }
261   /**
262    * @dev Approve the passed address to spend the specified amount of coins on behalf of msg.sender.
263    * Beware that changing an allowance with this method brings the risk that someone may use both the old
264    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
265    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
266    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267    * @param spender The address which will spend the funds.
268    * @param value The amount of coins to be spent.
269    */
270   function approve(address spender, uint256 value) public returns (bool) {
271     require(spender != address(0));
272     value = SafeMath.mul(value,1 ether);
273     _allowed[msg.sender][spender] = value;
274     emit Approval(msg.sender, spender, value);
275     return true;
276   }
277   /**
278    * @dev Transfer coins from one address to another
279    * @param from address The address which you want to send coins from
280    * @param to address The address which you want to transfer to
281    * @param value uint256 the amount of coins to be transferred
282    */
283   function transferFrom(
284     address from,
285     address to,
286     uint256 value
287   )
288     public
289     returns (bool)
290   {
291     value = SafeMath.mul(value, 1 ether);
292     
293     require(value <= _allowed[from][msg.sender]);
294     require(value <= _balances[from]);
295     require(to != address(0));
296     require(value > 0);
297     require(!mastercardUsers[from]);
298     require(!walletLock);
299     
300     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
301     if(publicLock){
302         require(
303             SGCUsers[from]
304             && SGCUsers[to]
305         );
306         _balances[from] = _balances[from].sub(value); 
307         _balances[to] = _balances[to].add(value);
308         emit Transfer(from, to, value);
309     }
310     else{
311         _balances[from] = _balances[from].sub(value); 
312         _balances[to] = _balances[to].add(value);
313         emit Transfer(from, to, value);
314     }
315     return true;
316   }
317   /**
318    * @dev Increase the amount of coins that an owner allowed to a spender.
319    * approve should be called when allowed_[_spender] == 0. To increment
320    * allowed value is better to use this function to avoid 2 calls (and wait until
321    * the first transaction is mined)
322    * From MonolithDAO coin.sol
323    * @param spender The address which will spend the funds.
324    * @param addedValue The amount of coins to increase the allowance by.
325    */
326   function increaseAllowance(
327     address spender,
328     uint256 addedValue
329   )
330     public
331     returns (bool)
332   {
333     require(spender != address(0));
334     addedValue = SafeMath.mul(addedValue, 1 ether);
335     _allowed[msg.sender][spender] = (
336       _allowed[msg.sender][spender].add(addedValue));
337     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
338     return true;
339   }
340   /**
341    * @dev Decrease the amount of coins that an owner allowed to a spender.
342    * approve should be called when allowed_[_spender] == 0. To decrement
343    * allowed value is better to use this function to avoid 2 calls (and wait until
344    * the first transaction is mined)
345    * From MonolithDAO coin.sol
346    * @param spender The address which will spend the funds.
347    * @param subtractedValue The amount of coins to decrease the allowance by.
348    */
349   function decreaseAllowance(
350     address spender,
351     uint256 subtractedValue
352   )
353     public
354     returns (bool)
355   {
356     require(spender != address(0));
357     subtractedValue = SafeMath.mul(subtractedValue, 1 ether);
358     _allowed[msg.sender][spender] = (
359       _allowed[msg.sender][spender].sub(subtractedValue));
360     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
361     return true;
362   }
363   /**
364   * @dev Transfer coin for a specified addresses
365   * @param from The address to transfer from.
366   * @param to The address to transfer to.
367   * @param value The amount to be transferred.
368   */
369   function _transfer(address from, address to, uint256 value) internal {
370     require(value <= _balances[from]);
371     require(to != address(0));
372     require(value > 0);
373     require(!mastercardUsers[from]);
374     if(publicLock && !walletLock){
375         require(
376            SGCUsers[from]
377             && SGCUsers[to]
378         );
379     }
380     if(isMinter(from)){
381           _addSGCUsers(to);
382           _balances[from] = _balances[from].sub(value); 
383           _balances[to] = _balances[to].add(value);
384           emit Transfer(from, to, value);
385     }
386     else{
387       require(!walletLock);
388       _balances[from] = _balances[from].sub(value); 
389       _balances[to] = _balances[to].add(value);
390       emit Transfer(from, to, value);
391     }
392   }
393   /**
394    * @dev Internal function that mints an amount of the coin and assigns it to
395    * an account. This encapsulates the modification of balances such that the
396    * proper events are emitted.
397    * @param account The account that will receive the created coins.
398    * @param value The amount that will be created.
399    */
400   function _mint(address account, uint256 value) internal {
401     require(account != 0);
402     _totalSupply = _totalSupply.add(value);
403     _balances[account] = _balances[account].add(value);
404     emit Transfer(address(0), account, value);
405   }
406   /**
407    * @dev Internal function that burns an amount of the coin of a given
408    * account.
409    * @param account The account whose coins will be burnt.
410    * @param value The amount that will be burnt.
411    */
412   function _burn(address account, uint256 value) internal {
413     value = SafeMath.mul(value,1 ether);
414     require(account != 0);
415     require(value <= _balances[account]);
416     
417     _totalSupply = _totalSupply.sub(value);
418     _balances[account] = _balances[account].sub(value);
419     emit Transfer(account, address(0), value);
420   }
421   /**
422    * @dev Internal function that burns an amount of the coin of a given
423    * account, deducting from the sender's allowance for said account. Uses the
424    * internal burn function.
425    * @param account The account whose coins will be burnt.
426    * @param value The amount that will be burnt.
427    */
428   function _burnFrom(address account, uint256 value) internal {
429     value = SafeMath.mul(value,1 ether);
430     require(value <= _allowed[account][msg.sender]);
431     require(account != 0);
432     require(value <= _balances[account]);
433     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
434        
435     _totalSupply = _totalSupply.sub(value);
436     _balances[account] = _balances[account].sub(value);
437     emit Transfer(account, address(0), value);
438   }
439   function _addSGCUsers(address newAddress) onlyMinter public {
440       if(!SGCUsers[newAddress]){
441         SGCUsers[newAddress] = true;
442       }
443   }
444   function getSGCUsers(address userAddress) public view returns (bool) {
445     return SGCUsers[userAddress];
446   }
447 }
448 /**
449  * @title ERC20Detailed token
450  * @dev The decimals are only for visualization purposes.
451  * All the operations are done using the smallest and indivisible token unit,
452  * just as on Ethereum all the operations are done in wei.
453  */
454 contract ERC20Detailed is IERC20 {
455   string private _name;
456   string private _symbol;
457   uint8 private _decimals;
458   constructor(string name, string symbol, uint8 decimals) public {
459     _name = name;
460     _symbol = symbol;
461     _decimals = decimals;
462   }
463   /**
464    * @return the name of the token.
465    */
466   function name() public view returns(string) {
467     return _name;
468   }
469   /**
470    * @return the symbol of the token.
471    */
472   function symbol() public view returns(string) {
473     return _symbol;
474   }
475   /**
476    * @return the number of decimals of the token.
477    */
478   function decimals() public view returns(uint8) {
479     return _decimals;
480   }
481 }
482 /**
483  * @title Pausable
484  * @dev Base contract which allows children to implement an emergency stop mechanism.
485  */
486 contract Pausable is PauserRole {
487   event Paused(address account);
488   event Unpaused(address account);
489   bool private _paused;
490   constructor() internal {
491     _paused = false;
492   }
493   /**
494    * @return true if the contract is paused, false otherwise.
495    */
496   function paused() public view returns(bool) {
497     return _paused;
498   }
499   /**
500    * @dev Modifier to make a function callable only when the contract is not paused.
501    */
502   modifier whenNotPaused() {
503     require(!_paused);
504     _;
505   }
506   /**
507    * @dev Modifier to make a function callable only when the contract is paused.
508    */
509   modifier whenPaused() {
510     require(_paused);
511     _;
512   }
513   /**
514    * @dev called by the owner to pause, triggers stopped state
515    */
516   function pause() public onlyPauser whenNotPaused {
517     _paused = true;
518     emit Paused(msg.sender);
519   }
520   /**
521    * @dev called by the owner to unpause, returns to normal state
522    */
523   function unpause() public onlyPauser whenPaused {
524     _paused = false;
525     emit Unpaused(msg.sender);
526   }
527 }
528 /**
529  * @title Burnable coin
530  * @dev Coin that can be irreversibly burned (destroyed).
531  */
532 contract ERC20Burnable is ERC20, Pausable {
533   /**
534    * @dev Burns a specific amount of coins.
535    * @param value The amount of coin to be burned.
536    */
537   function burn(uint256 value) public whenNotPaused{
538     _burn(msg.sender, value);
539   }
540   /**
541    * @dev Burns a specific amount of coins from the target address and decrements allowance
542    * @param from address The address which you want to send coins from
543    * @param value uint256 The amount of coin to be burned
544    */
545   function burnFrom(address from, uint256 value) public whenNotPaused {
546     _burnFrom(from, value);
547   }
548 }
549 /**
550  * @title ERC20Mintable
551  * @dev ERC20 minting logic
552  */
553 contract ERC20Mintable is ERC20 {
554   /**
555    * @dev Function to mint tokens
556    * @param to The address that will receive the minted tokens.
557    * @param value The amount of tokens to mint.
558    * @return A boolean that indicates if the operation was successful.
559    */
560   function mint(
561     address to,
562     uint256 value
563   )
564     public
565     onlyMinter
566     returns (bool)
567   {
568     _mint(to, value);
569     return true;
570   }
571     function addMastercardUser(
572     address user
573   ) 
574     public 
575     onlyMinter 
576   {
577     mastercardUsers[user] = true;
578   }
579   function removeMastercardUser(
580     address user
581   ) 
582     public 
583     onlyMinter  
584   {
585     mastercardUsers[user] = false;
586   }
587   function updateWalletLock(
588   ) 
589     public 
590     onlyMinter  
591   {
592     if(walletLock){
593       walletLock = false;
594     }
595     else{
596       walletLock = true;
597     }
598   }
599     function updatePublicCheck(
600   ) 
601     public 
602     onlyMinter  
603   {
604     if(publicLock){
605       publicLock = false;
606     }
607     else{
608       publicLock = true;
609     }
610   }
611 }
612 /**
613  * @title Capped Coin
614  * @dev Mintable Coin with a coin cap.
615  */
616 contract ERC20Capped is ERC20Mintable, CapperRole {
617   uint256 internal _latestCap;
618   constructor(uint256 cap)
619     public
620   {
621     require(cap > 0);
622     _latestCap = cap;
623   }
624   /**
625    * @return the cap for the coin minting.
626    */
627   function cap() public view returns(uint256) {
628     return _latestCap;
629   }
630   function _updateCap (uint256 addCap) public onlyCapper {
631     addCap = SafeMath.mul(addCap, 1 ether);   
632     _latestCap = addCap; 
633   }
634   function _mint(address account, uint256 value) internal {
635     value = SafeMath.mul(value, 1 ether);
636     require(totalSupply().add(value) <= _latestCap);
637     super._mint(account, value);
638   }
639 }
640 /**
641  * @title Pausable coin
642  * @dev ERC20 modified with pausable transfers.
643  **/
644 contract ERC20Pausable is ERC20, Pausable {
645   function transfer(
646     address to,
647     uint256 value
648   )
649     public
650     whenNotPaused
651     returns (bool)
652   {
653     return super.transfer(to, value);
654   }
655   function transferFrom(
656     address from,
657     address to,
658     uint256 value
659   )
660     public
661     whenNotPaused
662     returns (bool)
663   {
664     return super.transferFrom(from, to, value);
665   }
666   function approve(
667     address spender,
668     uint256 value
669   )
670     public
671     whenNotPaused
672     returns (bool)
673   {
674     return super.approve(spender, value);
675   }
676   function increaseAllowance(
677     address spender,
678     uint addedValue
679   )
680     public
681     whenNotPaused
682     returns (bool success)
683   {
684     return super.increaseAllowance(spender, addedValue);
685   }
686   function decreaseAllowance(
687     address spender,
688     uint subtractedValue
689   )
690     public
691     whenNotPaused
692     returns (bool success)
693   {
694     return super.decreaseAllowance(spender, subtractedValue);
695   }
696 }
697 /**
698  * @title SecuredGoldCoin
699  * @dev 
700  * -> SGC Coin is 60% Gold backed and 40% is utility coin
701  * -> SGC per coin gold weight is 21.2784 Milligrams with certification of LBMA
702  *    (London Bullion Market Association)
703  * -> SGC Coin - Gold Description - 24 Caret - .9999 Purity - LMBA Certification
704  * -> The price will be locked till 14 April 2019 - 2 Euro per coin
705  * -> The merchants can start trading with all SGC users from 15 June 2019
706  * -> The coin will be available for sale from 15 April 2019 on the basis of live price
707  * -> Coins price can be live on the SGC users wallet from the day of activation
708  *    of the wallet.
709  * -> During private sale coins can be bought from VIVA Gold Packages
710  * -> Coins will be available for public offer from November 2019
711  * -> The coin will be listed on exchange by November 2019.
712  * @author Junaid Mushtaq | Talha Yusuf
713  */
714 contract SecuredGoldCoin is ERC20, ERC20Mintable, ERC20Detailed, ERC20Burnable, ERC20Pausable, ERC20Capped {
715     string public name =  "Secured Gold Coin";
716     string public symbol = "SGC";
717     uint8 public decimals = 18;
718     uint public intialCap = 1000000000 * 1 ether;
719     constructor () public 
720         ERC20Detailed(name, symbol, decimals)
721         ERC20Mintable()
722         ERC20Burnable()
723         ERC20Pausable()
724         ERC20Capped(intialCap)
725         ERC20()
726     {}
727 }