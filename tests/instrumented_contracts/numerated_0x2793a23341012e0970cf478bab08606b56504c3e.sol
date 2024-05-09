1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 
54 
55 
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 
117 contract Administratable is Ownable {
118   using SafeMath for uint256;
119 
120   address[] public adminsForIndex;
121   address[] public superAdminsForIndex;
122   mapping (address => bool) public admins;
123   mapping (address => bool) public superAdmins;
124   mapping (address => bool) private processedAdmin;
125   mapping (address => bool) private processedSuperAdmin;
126 
127   event AddAdmin(address indexed admin);
128   event RemoveAdmin(address indexed admin);
129   event AddSuperAdmin(address indexed admin);
130   event RemoveSuperAdmin(address indexed admin);
131 
132   modifier onlyAdmins {
133     require (msg.sender == owner || superAdmins[msg.sender] || admins[msg.sender]);
134     _;
135   }
136 
137   modifier onlySuperAdmins {
138     require (msg.sender == owner || superAdmins[msg.sender]);
139     _;
140   }
141 
142   function totalSuperAdminsMapping() public view returns (uint256) {
143     return superAdminsForIndex.length;
144   }
145 
146   function addSuperAdmin(address admin) public onlySuperAdmins {
147     require(admin != address(0));
148     superAdmins[admin] = true;
149     if (!processedSuperAdmin[admin]) {
150       superAdminsForIndex.push(admin);
151       processedSuperAdmin[admin] = true;
152     }
153 
154     emit AddSuperAdmin(admin);
155   }
156 
157   function removeSuperAdmin(address admin) public onlySuperAdmins {
158     require(admin != address(0));
159     superAdmins[admin] = false;
160 
161     emit RemoveSuperAdmin(admin);
162   }
163 
164   function totalAdminsMapping() public view returns (uint256) {
165     return adminsForIndex.length;
166   }
167 
168   function addAdmin(address admin) public onlySuperAdmins {
169     require(admin != address(0));
170     admins[admin] = true;
171     if (!processedAdmin[admin]) {
172       adminsForIndex.push(admin);
173       processedAdmin[admin] = true;
174     }
175 
176     emit AddAdmin(admin);
177   }
178 
179   function removeAdmin(address admin) public onlySuperAdmins {
180     require(admin != address(0));
181     admins[admin] = false;
182 
183     emit RemoveAdmin(admin);
184   }
185 }
186 
187 
188 /**
189  * @title Pausable
190  * @dev Base contract which allows children to implement an emergency stop mechanism.
191  */
192 contract Pausable is Ownable {
193   event Pause();
194   event Unpause();
195 
196   bool public paused = false;
197 
198 
199   /**
200    * @dev Modifier to make a function callable only when the contract is not paused.
201    */
202   modifier whenNotPaused() {
203     require(!paused);
204     _;
205   }
206 
207   /**
208    * @dev Modifier to make a function callable only when the contract is paused.
209    */
210   modifier whenPaused() {
211     require(paused);
212     _;
213   }
214 
215   /**
216    * @dev called by the owner to pause, triggers stopped state
217    */
218   function pause() onlyOwner whenNotPaused public {
219     paused = true;
220     emit Pause();
221   }
222 
223   /**
224    * @dev called by the owner to unpause, returns to normal state
225    */
226   function unpause() onlyOwner whenPaused public {
227     paused = false;
228     emit Unpause();
229   }
230 }
231 
232 
233 /**
234  * @title EternalStorage
235  * @dev An Administratable contract that can be used as a storage where the variables
236  * are stored in a set of mappings indexed by hash names.
237  */
238 contract EternalStorage is Administratable {
239 
240   struct Storage {
241     mapping(bytes32 => bool) _bool;
242     mapping(bytes32 => int) _int;
243     mapping(bytes32 => uint256) _uint;
244     mapping(bytes32 => string) _string;
245     mapping(bytes32 => address) _address;
246     mapping(bytes32 => bytes) _bytes;
247   }
248 
249   Storage internal s;
250 
251   /**
252    * @dev Allows admins to set a value for a boolean variable.
253    * @param h The keccak256 hash of the variable name
254    * @param v The value to be stored
255    */
256   function setBoolean(bytes32 h, bool v) public onlyAdmins {
257     s._bool[h] = v;
258   }
259 
260   /**
261    * @dev Allows admins to set a value for a int variable.
262    * @param h The keccak256 hash of the variable name
263    * @param v The value to be stored
264    */
265   function setInt(bytes32 h, int v) public onlyAdmins {
266     s._int[h] = v;
267   }
268 
269   /**
270    * @dev Allows admins to set a value for a boolean variable.
271    * @param h The keccak256 hash of the variable name
272    * @param v The value to be stored
273    */
274   function setUint(bytes32 h, uint256 v) public onlyAdmins {
275     s._uint[h] = v;
276   }
277 
278   /**
279    * @dev Allows admins to set a value for a address variable.
280    * @param h The keccak256 hash of the variable name
281    * @param v The value to be stored
282    */
283   function setAddress(bytes32 h, address v) public onlyAdmins {
284     s._address[h] = v;
285   }
286 
287   /**
288    * @dev Allows admins to set a value for a string variable.
289    * @param h The keccak256 hash of the variable name
290    * @param v The value to be stored
291    */
292   function setString(bytes32 h, string v) public onlyAdmins {
293     s._string[h] = v;
294   }
295 
296   /**
297    * @dev Allows the owner to set a value for a bytes variable.
298    * @param h The keccak256 hash of the variable name
299    * @param v The value to be stored
300    */
301   function setBytes(bytes32 h, bytes v) public onlyAdmins {
302     s._bytes[h] = v;
303   }
304 
305   /**
306    * @dev Get the value stored of a boolean variable by the hash name
307    * @param h The keccak256 hash of the variable name
308    */
309   function getBoolean(bytes32 h) public view returns (bool){
310     return s._bool[h];
311   }
312 
313   /**
314    * @dev Get the value stored of a int variable by the hash name
315    * @param h The keccak256 hash of the variable name
316    */
317   function getInt(bytes32 h) public view returns (int){
318     return s._int[h];
319   }
320 
321   /**
322    * @dev Get the value stored of a uint variable by the hash name
323    * @param h The keccak256 hash of the variable name
324    */
325   function getUint(bytes32 h) public view returns (uint256){
326     return s._uint[h];
327   }
328 
329   /**
330    * @dev Get the value stored of a address variable by the hash name
331    * @param h The keccak256 hash of the variable name
332    */
333   function getAddress(bytes32 h) public view returns (address){
334     return s._address[h];
335   }
336 
337   /**
338    * @dev Get the value stored of a string variable by the hash name
339    * @param h The keccak256 hash of the variable name
340    */
341   function getString(bytes32 h) public view returns (string){
342     return s._string[h];
343   }
344 
345   /**
346    * @dev Get the value stored of a bytes variable by the hash name
347    * @param h The keccak256 hash of the variable name
348    */
349   function getBytes(bytes32 h) public view returns (bytes){
350     return s._bytes[h];
351   }
352 }
353 
354 
355 library TokenLib {
356   using SafeMath for uint256;
357 
358   event Transfer(address indexed _from, address indexed _to, uint256 _value);
359   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
360 
361   /* struct TokenStorage { address storage} */
362 
363   function transfer(address _storage, address _to, uint256 _value) public returns (bool) {
364     require(_to != address(0));
365     uint256 senderBalance = EternalStorage(_storage).getUint(keccak256(abi.encodePacked('balance', msg.sender)));
366     require(_value <= senderBalance);
367 
368     uint256 receiverBalance = balanceOf(_storage, _to);
369     EternalStorage(_storage).setUint(keccak256(abi.encodePacked('balance', msg.sender)), senderBalance.sub(_value));
370     EternalStorage(_storage).setUint(keccak256(abi.encodePacked('balance', _to)), receiverBalance.add(_value));
371     emit Transfer(msg.sender, _to, _value);
372 
373     return true;
374   }
375 
376   function mint(address _storage, address _to, uint256 _value) public {
377     EternalStorage(_storage).setUint(keccak256(abi.encodePacked('balance', _to)), _value);
378     EternalStorage(_storage).setUint(keccak256(abi.encodePacked('totalSupply')), _value);
379   }
380 
381   function setTotalSupply(address _storage, uint256 _totalSupply) public {
382     EternalStorage(_storage).setUint(keccak256(abi.encodePacked('totalSupply')), _totalSupply);
383   }
384 
385   function totalSupply(address _storage) public view returns (uint256) {
386     return EternalStorage(_storage).getUint(keccak256(abi.encodePacked('totalSupply')));
387   }
388 
389 
390   function balanceOf(address _storage, address _owner) public view returns (uint256 balance) {
391     return EternalStorage(_storage).getUint(keccak256(abi.encodePacked('balance', _owner)));
392   }
393 
394   function getAllowance(address _storage, address _owner, address _spender) public view returns (uint256) {
395     return EternalStorage(_storage).getUint(keccak256(abi.encodePacked('allowance', _owner, _spender)));
396   }
397 
398   function setAllowance(address _storage, address _owner, address _spender, uint256 _allowance) public {
399     EternalStorage(_storage).setUint(keccak256(abi.encodePacked('allowance', _owner, _spender)), _allowance);
400   }
401 
402   function allowance(address _storage, address _owner, address _spender) public view  returns (uint256) {
403     return getAllowance(_storage, _owner, _spender);
404   }
405 
406   function transferFrom(address _storage, address _from, address _to, uint256 _value) public  returns (bool) {
407     require(_to != address(0));
408     require(_from != msg.sender);
409     require(_value > 0);
410     uint256 senderBalance = balanceOf(_storage, _from);
411     require(senderBalance >= _value);
412 
413     uint256 allowanceValue = allowance(_storage, _from, msg.sender);
414     require(allowanceValue >= _value);
415 
416     uint256 receiverBalance = balanceOf(_storage, _to);
417     EternalStorage(_storage).setUint(keccak256(abi.encodePacked('balance', _from)), senderBalance.sub(_value));
418     EternalStorage(_storage).setUint(keccak256(abi.encodePacked('balance', _to)), receiverBalance.add(_value));
419 
420     setAllowance(_storage, _from, msg.sender, allowanceValue.sub(_value));
421     emit Transfer(_from, _to, _value);
422 
423     return true;
424   }
425 
426   function approve(address _storage, address _spender, uint256 _value) public returns (bool) {
427     require(_spender != address(0));
428     require(msg.sender != _spender);
429 
430     setAllowance(_storage, msg.sender, _spender, _value);
431 
432     emit Approval(msg.sender, _spender, _value);
433     return true;
434   }
435 
436   function increaseApproval(address _storage, address _spender, uint256 _addedValue) public returns (bool) {
437     return approve(_storage, _spender, getAllowance(_storage, msg.sender, _spender).add(_addedValue));
438   }
439 
440   function decreaseApproval(address _storage, address _spender, uint256 _subtractedValue) public returns (bool) {
441     uint256 oldValue = getAllowance(_storage, msg.sender, _spender);
442 
443     if (_subtractedValue > oldValue) {
444       return approve(_storage, _spender, 0);
445     } else {
446       return approve(_storage, _spender, oldValue.sub(_subtractedValue));
447     }
448   }
449 }
450 
451 
452 
453 
454 
455 
456 /**
457  * @title ERC20Basic
458  * @dev Simpler version of ERC20 interface
459  * @dev see https://github.com/ethereum/EIPs/issues/179
460  */
461 contract ERC20Basic {
462   function totalSupply() public view returns (uint256);
463   function balanceOf(address who) public view returns (uint256);
464   function transfer(address to, uint256 value) public returns (bool);
465   event Transfer(address indexed from, address indexed to, uint256 value);
466 }
467 
468 
469 
470 /**
471  * @title ERC20 interface
472  * @dev see https://github.com/ethereum/EIPs/issues/20
473  */
474 contract ERC20 is ERC20Basic {
475   function allowance(address owner, address spender)
476     public view returns (uint256);
477 
478   function transferFrom(address from, address to, uint256 value)
479     public returns (bool);
480 
481   function approve(address spender, uint256 value) public returns (bool);
482   event Approval(
483     address indexed owner,
484     address indexed spender,
485     uint256 value
486   );
487 }
488 
489 contract UpgradableToken is ERC20, Ownable {
490   address public predecessor;
491   address public successor;
492   string public version;
493 
494   event UpgradedTo(address indexed successor);
495   event UpgradedFrom(address indexed predecessor);
496 
497   modifier unlessUpgraded() {
498     require (msg.sender == successor || successor == address(0));
499     _;
500   }
501 
502   modifier isUpgraded() {
503     require (successor != address(0));
504     _;
505   }
506 
507   modifier hasPredecessor() {
508     require (predecessor != address(0));
509     _;
510   }
511 
512   function isDeprecated() public view returns (bool) {
513     return successor != address(0);
514   }
515 
516   constructor(string _version) public {
517       version = _version;
518   }
519 
520   function upgradeTo(address _successor) public onlyOwner unlessUpgraded returns (bool){
521     require(_successor != address(0));
522 
523     uint remainingContractBalance = balanceOf(this);
524 
525     if (remainingContractBalance > 0) {
526       this.transfer(_successor, remainingContractBalance);
527     }
528     successor = _successor;
529     emit UpgradedTo(_successor);
530     return true;
531   }
532 
533   function upgradedFrom(address _predecessor) public onlyOwner returns (bool) {
534     require(_predecessor != address(0));
535 
536     predecessor = _predecessor;
537 
538     emit UpgradedFrom(_predecessor);
539 
540     return true;
541   }
542 }
543 
544 
545 
546 contract Token is Ownable {
547   event UpgradedTo(address indexed implementation);
548 
549   address internal _implementation;
550 
551   function implementation() public view returns (address) {
552     return _implementation;
553   }
554 
555   function upgradeTo(address impl) public onlyOwner {
556     require(_implementation != impl);
557     _implementation = impl;
558     emit UpgradedTo(impl);
559   }
560 
561   function () payable public {
562     address _impl = implementation();
563     require(_impl != address(0));
564     bytes memory data = msg.data;
565 
566     assembly {
567       let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
568       let size := returndatasize
569       let ptr := mload(0x40)
570       returndatacopy(ptr, 0, size)
571       switch result
572       case 0 { revert(ptr, size) }
573       default { return(ptr, size) }
574     }
575   }
576 }
577 
578 
579 /**
580  * @title DetailedERC20 token
581  * @dev The decimals are only for visualization purposes.
582  * All the operations are done using the smallest and indivisible token unit,
583  * just as on Ethereum all the operations are done in wei.
584  */
585 contract DetailedERC20 is ERC20 {
586   string public name;
587   string public symbol;
588   uint8 public decimals;
589 
590   constructor(string _name, string _symbol, uint8 _decimals) public {
591     name = _name;
592     symbol = _symbol;
593     decimals = _decimals;
594   }
595 }
596 
597 
598 
599 contract TokenDelegate is UpgradableToken, DetailedERC20, Pausable {
600     using TokenLib for address;
601 
602     address tokenStorage;
603 
604     constructor(string _name, string _symbol, uint8 _decimals, address _storage, string _version)
605         DetailedERC20(_name, _symbol, _decimals) UpgradableToken(_version) public {
606         setStorage(_storage);
607     }
608 
609     function setTotalSupply(uint256 _totalSupply) public onlyOwner {
610         tokenStorage.setTotalSupply(_totalSupply);
611     }
612 
613     function setStorage(address _storage) public onlyOwner unlessUpgraded whenNotPaused {
614         tokenStorage = _storage;
615     }
616 
617     function totalSupply() public view returns (uint){
618         return tokenStorage.totalSupply();
619     }
620 
621     function mint(address _to, uint _value) public onlyOwner unlessUpgraded whenNotPaused {
622         tokenStorage.mint(_to, _value);
623     }
624 
625     function balanceOf(address _owner) public view returns (uint256) {
626         return tokenStorage.balanceOf(_owner);
627     }
628 
629     function transfer(address _to, uint _value) public unlessUpgraded whenNotPaused returns(bool) {
630         return tokenStorage.transfer(_to, _value);
631     }
632 
633     function approve(address _to, uint _value) public unlessUpgraded whenNotPaused returns(bool) {
634         return tokenStorage.approve(_to, _value);
635     }
636 
637     function allowance(address _owner, address _spender) public view returns (uint256) {
638         return tokenStorage.allowance(_owner, _spender);
639     }
640 
641     function transferFrom(address _from, address _to, uint256 _value) public unlessUpgraded whenNotPaused returns (bool) {
642         return tokenStorage.transferFrom(_from, _to, _value);
643     }
644 
645     function increaseApproval(address _spender, uint256 _addedValue) public unlessUpgraded whenNotPaused returns (bool) {
646         return tokenStorage.increaseApproval(_spender, _addedValue);
647     }
648 
649     function decreaseApproval(address _spender, uint256 _subtractedValue) public unlessUpgraded whenNotPaused returns (bool) {
650         return tokenStorage.decreaseApproval(_spender, _subtractedValue);
651     }
652 }