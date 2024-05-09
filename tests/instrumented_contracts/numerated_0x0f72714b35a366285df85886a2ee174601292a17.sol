1 pragma solidity ^0.4.25;
2 
3 // File: contracts/openzeppelin/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: contracts/openzeppelin/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address _owner, address _spender)
25     public view returns (uint256);
26 
27   function transferFrom(address _from, address _to, uint256 _value)
28     public returns (bool);
29 
30   function approve(address _spender, uint256 _value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: contracts/openzeppelin/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
50     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (_a == 0) {
54       return 0;
55     }
56 
57     c = _a * _b;
58     require(c / _a == _b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
66     // Solidity only automatically asserts when dividing by 0
67     require(_b > 0);
68     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
69     return _a / _b;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
76     require(_b <= _a);
77     return _a - _b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
84     c = _a + _b;
85     require(c >= _a);
86     return c;
87   }
88 }
89 
90 // File: contracts/Ownable.sol
91 
92 /**
93  * @title Ownable
94  * @dev The Ownable contract from https://github.com/zeppelinos/labs/blob/master/upgradeability_ownership/contracts/ownership/Ownable.sol
95  * branch: master commit: 3887ab77b8adafba4a26ace002f3a684c1a3388b modified to:
96  * 1) Add emit prefix to OwnershipTransferred event (7/13/18)
97  * 2) Replace constructor with constructor syntax (7/13/18)
98  * 3) consolidate OwnableStorage into this contract
99  */
100 contract Ownable {
101 
102   // Owner of the contract
103   address private _owner;
104 
105   /**
106   * @dev Event to show ownership has been transferred
107   * @param previousOwner representing the address of the previous owner
108   * @param newOwner representing the address of the new owner
109   */
110   event OwnershipTransferred(address previousOwner, address newOwner);
111 
112   /**
113   * @dev The constructor sets the original owner of the contract to the sender account.
114   */
115   constructor() public {
116     setOwner(msg.sender);
117   }
118 
119   /**
120  * @dev Tells the address of the owner
121  * @return the address of the owner
122  */
123   function owner() public view returns (address) {
124     return _owner;
125   }
126 
127   /**
128    * @dev Sets a new owner address
129    */
130   function setOwner(address newOwner) internal {
131     _owner = newOwner;
132   }
133 
134   /**
135   * @dev Throws if called by any account other than the owner.
136   */
137   modifier onlyOwner() {
138     require(msg.sender == owner());
139     _;
140   }
141 
142   /**
143    * @dev Allows the current owner to transfer control of the contract to a newOwner.
144    * @param newOwner The address to transfer ownership to.
145    */
146   function transferOwnership(address newOwner) public onlyOwner {
147     require(newOwner != address(0));
148     emit OwnershipTransferred(owner(), newOwner);
149     setOwner(newOwner);
150   }
151 }
152 
153 // File: contracts/Blacklistable.sol
154 
155 /**
156  * @title Blacklistable Token
157  * @dev Allows accounts to be blacklisted by a "blacklister" role
158 */
159 contract Blacklistable is Ownable {
160 
161   address public blacklister;
162   mapping(address => bool) internal blacklisted;
163 
164   event Blacklisted(address indexed _account);
165   event UnBlacklisted(address indexed _account);
166   event BlacklisterChanged(address indexed newBlacklister);
167 
168   /**
169    * @dev Throws if called by any account other than the blacklister
170   */
171   modifier onlyBlacklister() {
172     require(msg.sender == blacklister);
173     _;
174   }
175 
176   /**
177    * @dev Throws if argument account is blacklisted
178    * @param _account The address to check
179   */
180   modifier notBlacklisted(address _account) {
181     require(blacklisted[_account] == false);
182     _;
183   }
184 
185   /**
186    * @dev Checks if account is blacklisted
187    * @param _account The address to check
188   */
189   function isBlacklisted(address _account) public view returns (bool) {
190     return blacklisted[_account];
191   }
192 
193   /**
194    * @dev Adds account to blacklist
195    * @param _account The address to blacklist
196   */
197   function blacklist(address _account) public onlyBlacklister {
198     blacklisted[_account] = true;
199     emit Blacklisted(_account);
200   }
201 
202   /**
203    * @dev Removes account from blacklist
204    * @param _account The address to remove from the blacklist
205   */
206   function unBlacklist(address _account) public onlyBlacklister {
207     blacklisted[_account] = false;
208     emit UnBlacklisted(_account);
209   }
210 
211   function updateBlacklister(address _newBlacklister) public onlyOwner {
212     require(_newBlacklister != address(0));
213     blacklister = _newBlacklister;
214     emit BlacklisterChanged(blacklister);
215   }
216 }
217 
218 // File: contracts/Pausable.sol
219 
220 /**
221  * @title Pausable
222  * @dev Base contract which allows children to implement an emergency stop mechanism.
223  * Based on openzeppelin tag v1.10.0 commit: feb665136c0dae9912e08397c1a21c4af3651ef3
224  * Modifications:
225  * 1) Added pauser role, switched pause/unpause to be onlyPauser (6/14/2018)
226  * 2) Removed whenNotPause/whenPaused from pause/unpause (6/14/2018)
227  * 3) Removed whenPaused (6/14/2018)
228  * 4) Switches ownable library to use zeppelinos (7/12/18)
229  * 5) Remove constructor (7/13/18)
230  */
231 contract Pausable is Ownable {
232   event Pause();
233   event Unpause();
234   event PauserChanged(address indexed newAddress);
235 
236 
237   address public pauser;
238   bool public paused = false;
239 
240   /**
241    * @dev Modifier to make a function callable only when the contract is not paused.
242    */
243   modifier whenNotPaused() {
244     require(!paused);
245     _;
246   }
247 
248   /**
249    * @dev throws if called by any account other than the pauser
250    */
251   modifier onlyPauser() {
252     require(msg.sender == pauser);
253     _;
254   }
255 
256   /**
257    * @dev called by the owner to pause, triggers stopped state
258    */
259   function pause() public onlyPauser {
260     paused = true;
261     emit Pause();
262   }
263 
264   /**
265    * @dev called by the owner to unpause, returns to normal state
266    */
267   function unpause() public onlyPauser {
268     paused = false;
269     emit Unpause();
270   }
271 
272   /**
273    * @dev update the pauser role
274    */
275   function updatePauser(address _newPauser) public onlyOwner {
276     require(_newPauser != address(0));
277     pauser = _newPauser;
278     emit PauserChanged(pauser);
279   }
280 
281 }
282 
283 // File: contracts/sheets/DelegateContract.sol
284 
285 contract DelegateContract is Ownable {
286   address delegate_;
287 
288   event LogicContractChanged(address indexed newAddress);
289 
290   /**
291   * @dev Throws if called by any account other than the owner.
292   */
293   modifier onlyFromAccept() {
294     require(msg.sender == delegate_);
295     _;
296   }
297 
298   function setLogicContractAddress(address _addr) public onlyOwner {
299     delegate_ = _addr;
300     emit LogicContractChanged(_addr);
301   }
302 
303   function isDelegate(address _addr) public view returns(bool) {
304     return _addr == delegate_;
305   }
306 }
307 
308 // File: contracts/sheets/AllowanceSheet.sol
309 
310 // A wrapper around the allowanceOf mapping.
311 contract AllowanceSheet is DelegateContract {
312   using SafeMath for uint256;
313 
314   mapping (address => mapping (address => uint256)) public allowanceOf;
315 
316   function subAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyFromAccept {
317     allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].sub(_value);
318   }
319 
320   function setAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyFromAccept {
321     allowanceOf[_tokenHolder][_spender] = _value;
322   }
323 }
324 
325 // File: contracts/sheets/BalanceSheet.sol
326 
327 // A wrapper around the balanceOf mapping.
328 contract BalanceSheet is DelegateContract, AllowanceSheet {
329   using SafeMath for uint256;
330 
331   uint256 internal totalSupply_ = 0;
332 
333   mapping (address => uint256) public balanceOf;
334 
335   function addBalance(address _addr, uint256 _value) public onlyFromAccept {
336     balanceOf[_addr] = balanceOf[_addr].add(_value);
337   }
338 
339   function subBalance(address _addr, uint256 _value) public onlyFromAccept {
340     balanceOf[_addr] = balanceOf[_addr].sub(_value);
341   }
342 
343   function increaseSupply(uint256 _amount) public onlyFromAccept {
344     totalSupply_ = totalSupply_.add(_amount);
345   }
346 
347   function decreaseSupply(uint256 _amount) public onlyFromAccept {
348     totalSupply_ = totalSupply_.sub(_amount);
349   }
350 
351   function totalSupply() public view returns (uint256) {
352     return totalSupply_;
353   }
354 }
355 
356 // File: contracts\MarsTokenV1.sol
357 
358 /**
359  * @title MarsToken
360  * @dev ERC20 Token backed by fiat reserves
361  */
362 contract MarsTokenV1 is Ownable, ERC20, Pausable, Blacklistable {
363   using SafeMath for uint256;
364 
365   string public name;
366   string public symbol;
367   uint8 public decimals;
368   string public currency;
369   address public masterMinter;
370 
371   //mapping(address => uint256) internal balances;
372   //mapping(address => mapping(address => uint256)) internal allowed;
373   //uint256 internal totalSupply_ = 0;
374   mapping(address => bool) internal minters;
375   mapping(address => uint256) internal minterAllowed;
376 
377   event Mint(address indexed minter, address indexed to, uint256 amount);
378   event Burn(address indexed burner, uint256 amount);
379   event MinterConfigured(address indexed minter, uint256 minterAllowedAmount);
380   event MinterRemoved(address indexed oldMinter);
381   event MasterMinterChanged(address indexed newMasterMinter);
382   event DestroyedBlackFunds(address indexed _account, uint256 _balance);
383 
384   BalanceSheet public balances;
385   event BalanceSheetSet(address indexed sheet);
386 
387   /**
388   * @dev ownership of the balancesheet contract
389   * @param _sheet The address to of the balancesheet.
390   */
391   function setBalanceSheet(address _sheet) public onlyOwner returns (bool) {
392     balances = BalanceSheet(_sheet);
393     emit BalanceSheetSet(_sheet);
394     return true;
395   }
396 
397   constructor(
398     string _name,
399     string _symbol,
400     string _currency,
401     uint8 _decimals,
402     address _masterMinter,
403     address _pauser,
404     address _blacklister
405   ) public {
406     require(_masterMinter != address(0));
407     require(_pauser != address(0));
408     require(_blacklister != address(0));
409 
410     name = _name;
411     symbol = _symbol;
412     currency = _currency;
413     decimals = _decimals;
414     masterMinter = _masterMinter;
415     pauser = _pauser;
416     blacklister = _blacklister;
417     setOwner(msg.sender);
418   }
419 
420   /**
421   * @dev Throws if called by any account other than a minter
422   */
423   modifier onlyMinters() {
424     require(minters[msg.sender] == true);
425     _;
426   }
427 
428   /**
429   * @dev Function to mint tokens
430   * @param _to The address that will receive the minted tokens.
431   * @param _amount The amount of tokens to mint. Must be less than or equal to the minterAllowance of the caller.
432   * @return A boolean that indicates if the operation was successful.
433   */
434   function mint(address _to, uint256 _amount) public whenNotPaused onlyMinters notBlacklisted(msg.sender) notBlacklisted(_to) returns (bool) {
435     require(_to != address(0));
436     require(_amount > 0);
437 
438     uint256 mintingAllowedAmount = minterAllowed[msg.sender];
439     require(_amount <= mintingAllowedAmount);
440 
441     //totalSupply_ = totalSupply_.add(_amount);
442     balances.increaseSupply(_amount);
443     //balances[_to] = balances[_to].add(_amount);
444     balances.addBalance(_to, _amount);
445     minterAllowed[msg.sender] = mintingAllowedAmount.sub(_amount);
446     emit Mint(msg.sender, _to, _amount);
447     emit Transfer(0x0, _to, _amount);
448     return true;
449   }
450 
451   /**
452   * @dev Throws if called by any account other than the masterMinter
453   */
454   modifier onlyMasterMinter() {
455     require(msg.sender == masterMinter);
456     _;
457   }
458 
459   /**
460   * @dev Get minter allowance for an account
461   * @param minter The address of the minter
462   */
463   function minterAllowance(address minter) public view returns (uint256) {
464     return minterAllowed[minter];
465   }
466 
467   /**
468   * @dev Checks if account is a minter
469   * @param account The address to check
470   */
471   function isMinter(address account) public view returns (bool) {
472     return minters[account];
473   }
474 
475   /**
476   * @dev Get allowed amount for an account
477   * @param owner address The account owner
478   * @param spender address The account spender
479   */
480   function allowance(address owner, address spender) public view returns (uint256) {
481     //return allowed[owner][spender];
482     return balances.allowanceOf(owner,spender);
483   }
484 
485   /**
486   * @dev Get totalSupply of token
487   */
488   function totalSupply() public view returns (uint256) {
489     return balances.totalSupply();
490   }
491 
492   /**
493   * @dev Get token balance of an account
494   * @param account address The account
495   */
496   function balanceOf(address account) public view returns (uint256) {
497     //return balances[account];
498     return balances.balanceOf(account);
499   }
500 
501   /**
502   * @dev Adds blacklisted check to approve
503   * @return True if the operation was successful.
504   */
505   function approve(address _spender, uint256 _value) public whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_spender) returns (bool) {
506     require(_spender != address(0));
507     //allowed[msg.sender][_spender] = _value;
508     balances.setAllowance(msg.sender, _spender, _value);
509     emit Approval(msg.sender, _spender, _value);
510     return true;
511   }
512 
513   /**
514   * @dev Transfer tokens from one address to another.
515   * @param _from address The address which you want to send tokens from
516   * @param _to address The address which you want to transfer to
517   * @param _value uint256 the amount of tokens to be transferred
518   * @return bool success
519   */
520   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notBlacklisted(_to) notBlacklisted(msg.sender) notBlacklisted(_from) returns (bool) {
521     require(_to != address(0));
522     require(_value <= balances.balanceOf(_from));
523     require(_value <= balances.allowanceOf(_from, msg.sender));
524 
525     //allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
526     balances.subAllowance(_from, msg.sender, _value);
527     //balances[_from] = balances[_from].sub(_value);
528     balances.subBalance(_from, _value);
529     //balances[_to] = balances[_to].add(_value);
530     balances.addBalance(_to, _value);
531     emit Transfer(_from, _to, _value);
532     return true;
533   }
534 
535   /**
536   * @dev transfer token for a specified address
537   * @param _to The address to transfer to.
538   * @param _value The amount to be transferred.
539   * @return bool success
540   */
541   function transfer(address _to, uint256 _value) public whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_to) returns (bool) {
542     require(_to != address(0));
543     require(_value <= balances.balanceOf(msg.sender));
544 
545     //balances[msg.sender] = balances[msg.sender].sub(_value);
546     balances.subBalance(msg.sender, _value);
547     //balances[_to] = balances[_to].add(_value);
548     balances.addBalance(_to, _value);
549     emit Transfer(msg.sender, _to, _value);
550     return true;
551   }
552 
553   /**
554   * @dev Function to add/update a new minter
555   * @param minter The address of the minter
556   * @param minterAllowedAmount The minting amount allowed for the minter
557   * @return True if the operation was successful.
558   */
559   function configureMinter(address minter, uint256 minterAllowedAmount) public whenNotPaused onlyMasterMinter notBlacklisted(minter) returns (bool) {
560     minters[minter] = true;
561     minterAllowed[minter] = minterAllowedAmount;
562     emit MinterConfigured(minter, minterAllowedAmount);
563     return true;
564   }
565 
566   /**
567   * @dev Function to remove a minter
568   * @param minter The address of the minter to remove
569   * @return True if the operation was successful.
570   */
571   function removeMinter(address minter) public onlyMasterMinter returns (bool) {
572     minters[minter] = false;
573     minterAllowed[minter] = 0;
574     emit MinterRemoved(minter);
575     return true;
576   }
577 
578   /**
579   * @dev allows a minter to burn some of its own tokens
580   * Validates that caller is a minter and that sender is not blacklisted
581   * amount is less than or equal to the minter's account balance
582   * @param _amount uint256 the amount of tokens to be burned
583   */
584   function burn(uint256 _amount) public whenNotPaused onlyMinters notBlacklisted(msg.sender) {
585     uint256 balance = balances.balanceOf(msg.sender);
586     require(_amount > 0);
587     require(balance >= _amount);
588 
589     //totalSupply_ = totalSupply_.sub(_amount);
590     balances.decreaseSupply(_amount);
591     //balances[msg.sender] = balance.sub(_amount);
592     balances.subBalance(msg.sender, _amount);
593     emit Burn(msg.sender, _amount);
594     emit Transfer(msg.sender, address(0), _amount);
595   }
596 
597   function updateMasterMinter(address _newMasterMinter) public onlyOwner {
598     require(_newMasterMinter != address(0));
599     masterMinter = _newMasterMinter;
600     emit MasterMinterChanged(masterMinter);
601   }
602 
603   /**
604    * @dev Destroy funds of account from blacklist
605    * @param _account The address to destory funds
606   */
607   function destroyBlackFunds(address _account) public onlyOwner {
608     require(blacklisted[_account]);
609     uint256 _balance = balances.balanceOf(_account);
610     balances.subBalance(_account, _balance);
611     balances.decreaseSupply(_balance);
612     emit DestroyedBlackFunds(_account, _balance);
613     emit Transfer(_account, address(0), _balance);
614   }
615 
616 }