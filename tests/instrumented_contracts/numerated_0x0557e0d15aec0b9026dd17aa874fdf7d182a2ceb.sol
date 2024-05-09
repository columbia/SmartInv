1 pragma solidity 0.4.26;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20Basic {
9     uint public _totalSupply;
10     function totalSupply() public constant returns (uint);
11     function balanceOf(address who) public constant returns (uint);
12     function transfer(address to, uint value) public;
13     event Transfer(address indexed from, address indexed to, uint value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21     function allowance(address owner, address spender) public constant returns (uint);
22     function transferFrom(address from, address to, uint value) public;
23     function approve(address spender, uint value) public;
24     event Approval(address indexed owner, address indexed spender, uint value);
25 }
26 
27 /**
28  * Utility library of inline functions on addresses
29  */
30 library Address {
31     /**
32      * Returns whether the target address is a contract
33      * @dev This function will return false if invoked during the constructor of a contract,
34      * as the code is not actually created until after the constructor finishes.
35      * @param account address of the account to check
36      * @return whether the target address is a contract
37      */
38     function isContract(address account) internal view returns (bool) {
39         uint256 size;
40         // XXX Currently there is no better way to check if there is a contract in an address
41         // than to check the size of the code at that address.
42         // See https://ethereum.stackexchange.com/a/14016/36603
43         // for more details about how this works.
44         // TODO Check this again before the Serenity release, because all addresses will be
45         // contracts then.
46         // solhint-disable-next-line no-inline-assembly
47         assembly { size := extcodesize(account) }
48         return size > 0;
49     }
50 }
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 library SafeMath {
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         if (a == 0) {
59             return 0;
60         }
61         uint256 c = a * b;
62         assert(c / a == b);
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         // assert(b > 0); // Solidity automatically throws when dividing by 0
68         uint256 c = a / b;
69         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70         return c;
71     }
72 
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         assert(b <= a);
75         return a - b;
76     }
77 
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         assert(c >= a);
81         return c;
82     }
83 }
84 
85 /**
86  * @title Proxy
87  * @dev Gives the possibility to delegate any call to a foreign implementation.
88  */
89 contract Proxy {
90     /**
91     * @dev Tells the address of the implementation where every call will be delegated.
92     * @return address of the implementation to which it will be delegated
93     */
94     function _implementation() internal view returns(address);
95 
96     /**
97     * @dev Fallback function.
98     * Implemented entirely in `_fallback`.
99     */
100     function _fallback() internal {
101         _delegate(_implementation());
102     }
103 
104     /**
105     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
106     * This function will return whatever the implementation call returns
107     */
108     function _delegate(address implementation) internal {
109         /*solium-disable-next-line security/no-inline-assembly*/
110         assembly {
111             // Copy msg.data. We take full control of memory in this inline assembly
112             // block because it will not return to Solidity code. We overwrite the
113             // Solidity scratch pad at memory position 0.
114             calldatacopy(0, 0, calldatasize)
115             // Call the implementation.
116             // out and outsize are 0 because we don't know the size yet.
117             let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
118             // Copy the returned data.
119             returndatacopy(0, 0, returndatasize)
120             switch result
121             // delegatecall returns 0 on error.
122             case 0 { revert(0, returndatasize) }
123             default { return(0, returndatasize) }
124         }
125     }
126 
127     function() external payable {
128         _fallback();
129     }
130 }
131 
132 /**
133  * @title UpgradeabilityProxy
134  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
135  */
136 contract UpgradeabilityProxy is Proxy {
137     // Version name of the current implementation
138     string internal __version;
139 
140     // Address of the current implementation
141     address internal __implementation;
142 
143     /**
144     * @dev This event will be emitted every time the implementation gets upgraded
145     * @param _newVersion representing the version name of the upgraded implementation
146     * @param _newImplementation representing the address of the upgraded implementation
147     */
148     event Upgraded(string _newVersion, address indexed _newImplementation);
149 
150     /**
151     * @dev Upgrades the implementation address
152     * @param _newVersion representing the version name of the new implementation to be set
153     * @param _newImplementation representing the address of the new implementation to be set
154     */
155     function _upgradeTo(string memory _newVersion, address _newImplementation) internal {
156         require(
157             __implementation != _newImplementation && _newImplementation != address(0),
158             "Old address is not allowed and implementation address should not be 0x"
159         );
160         require(Address.isContract(_newImplementation), "Cannot set a proxy implementation to a non-contract address");
161         require(bytes(_newVersion).length > 0, "Version should not be empty string");
162         require(keccak256(abi.encodePacked(__version)) != keccak256(abi.encodePacked(_newVersion)), "New version equals to current");
163         __version = _newVersion;
164         __implementation = _newImplementation;
165         emit Upgraded(_newVersion, _newImplementation);
166     }
167 
168 }
169 
170 /**
171  * @title Ownable
172  * @dev The Ownable contract has an owner address, and provides basic authorization control
173  * functions, this simplifies the implementation of "user permissions".
174  */
175 contract Ownable {
176     address public owner;
177     address public newOwner;
178     /**
179       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
180       * account.
181       */
182     constructor() public {  
183         owner = msg.sender;
184     }
185 
186     /**
187       * @dev Throws if called by any account other than the owner.
188       */
189     modifier onlyOwner() {
190         require(msg.sender == owner);
191         _;
192     }
193 
194     /**
195     * @dev Allows the current owner to transfer control of the contract to a newOwner.
196     * @param _newOwner The address to transfer ownership to.
197     */
198     function transferOwnership(address _newOwner) public onlyOwner {
199         require(_newOwner != address(0), "Address should not be 0x");
200         newOwner = _newOwner;
201     }
202     
203     function approveOwnership() public{
204         require(newOwner == msg.sender);
205         owner = newOwner;
206     }
207 
208 }
209 
210 
211 
212 /**
213  * @title Basic token
214  * @dev Basic version of StandardToken, with no allowances.
215  */
216 contract BasicToken is Ownable, ERC20Basic {
217     using SafeMath for uint;
218 
219     mapping(address => uint) public balances;
220 
221     /**
222     * @dev Fix for the ERC20 short address attack.
223     */
224     modifier onlyPayloadSize(uint size) {
225         require(!(msg.data.length < size + 4));
226         _;
227     }
228 
229     /**
230     * @dev transfer token for a specified address
231     * @param _to The address to transfer to.
232     * @param _value The amount to be transferred.
233     */
234     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
235 
236         balances[msg.sender] = balances[msg.sender].sub(_value);
237         balances[_to] = balances[_to].add(_value);
238         emit Transfer(msg.sender, _to, _value);
239     }
240 
241     /**
242     * @dev Gets the balance of the specified address.
243     * @param _owner The address to query the the balance of.
244     * @return An uint representing the amount owned by the passed address.
245     */
246     function balanceOf(address _owner) public constant returns (uint balance) {
247         return balances[_owner];
248     }
249 
250 }
251 
252 /**
253  * @title Standard ERC20 token
254  *
255  * @dev Implementation of the basic standard token.
256  * @dev https://github.com/ethereum/EIPs/issues/20
257  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
258  */
259 contract StandardToken is BasicToken, ERC20 {
260 
261     mapping (address => mapping (address => uint)) public allowed;
262 
263     uint public constant MAX_UINT = 2**256 - 1;
264 
265     /**
266     * @dev Transfer tokens from one address to another
267     * @param _from address The address which you want to send tokens from
268     * @param _to address The address which you want to transfer to
269     * @param _value uint the amount of tokens to be transferred
270     */
271     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
272         uint _allowance = allowed[_from][msg.sender];
273 
274         if (_allowance < MAX_UINT) {
275             allowed[_from][msg.sender] = _allowance.sub(_value);
276         }
277         
278         balances[_from] = balances[_from].sub(_value);
279         balances[_to] = balances[_to].add(_value);
280        
281         emit Transfer(_from, _to, _value);
282     }
283 
284     /**
285     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
286     * @param _spender The address which will spend the funds.
287     * @param _value The amount of tokens to be spent.
288     */
289     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
290 
291         // To change the approve amount you first have to reduce the addresses`
292         //  allowance to zero by calling `approve(_spender, 0)` if it is not
293         //  already 0 to mitigate the race condition described here:
294         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
295         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
296 
297         allowed[msg.sender][_spender] = _value;
298         emit Approval(msg.sender, _spender, _value);
299     }
300 
301     /**
302     * @dev Function to check the amount of tokens than an owner allowed to a spender.
303     * @param _owner address The address which owns the funds.
304     * @param _spender address The address which will spend the funds.
305     * @return A uint specifying the amount of tokens still available for the spender.
306     */
307     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
308         return allowed[_owner][_spender];
309     }
310 
311 }
312 
313 
314 /**
315  * @title Pausable
316  * @dev Base contract which allows children to implement an emergency stop mechanism.
317  */
318 contract Pausable is Ownable {
319   event Pause();
320   event Unpause();
321 
322   bool public paused = false;
323 
324 
325   /**
326    * @dev Modifier to make a function callable only when the contract is not paused.
327    */
328   modifier whenNotPaused() {
329     require(!paused);
330     _;
331   }
332 
333   /**
334    * @dev Modifier to make a function callable only when the contract is paused.
335    */
336   modifier whenPaused() {
337     require(paused);
338     _;
339   }
340 
341   /**
342    * @dev called by the owner to pause, triggers stopped state
343    */
344   function pause() onlyOwner whenNotPaused public {
345     paused = true;
346     emit Pause();
347   }
348 
349   /**
350    * @dev called by the owner to unpause, returns to normal state
351    */
352   function unpause() onlyOwner whenPaused public {
353     paused = false;
354     emit Unpause();
355   }
356 }
357 
358 contract BlackList is Ownable, BasicToken {
359 
360     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
361     function getBlackListStatus(address _maker) external constant returns (bool) {
362         return isBlackListed[_maker];
363     }
364 
365     mapping (address => bool) public isBlackListed;
366     
367     function addBlackList (address _evilUser) public onlyOwner {
368         isBlackListed[_evilUser] = true;
369         emit AddedBlackList(_evilUser);
370     }
371 
372     function removeBlackList (address _clearedUser) public onlyOwner {
373         isBlackListed[_clearedUser] = false;
374         emit RemovedBlackList(_clearedUser);
375     }
376 
377     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
378         require(isBlackListed[_blackListedUser]);
379         uint dirtyFunds = balanceOf(_blackListedUser);
380         balances[_blackListedUser] = 0;
381         _totalSupply -= dirtyFunds;
382         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
383     }
384 
385     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
386 
387     event AddedBlackList(address _user);
388 
389     event RemovedBlackList(address _user);
390 
391 }
392 
393 contract TetherToken is Pausable, StandardToken, BlackList, UpgradeabilityProxy{
394 
395     string public name;
396     string public symbol;
397     uint public decimals;
398     bool public deprecated;
399 
400     //  The contract can be initialized with a number of tokens
401     //  All the tokens are deposited to the owner address
402     //
403     // @param _balance Initial supply of the contract
404     // @param _name Token Name
405     // @param _symbol Token symbol
406     // @param _decimals Token decimals
407     constructor(uint _initialSupply, string _name, string _symbol, uint _decimals) public {
408         _totalSupply = _initialSupply;
409         name = _name;
410         symbol = _symbol;
411         decimals = _decimals;
412         balances[owner] = _initialSupply;
413         deprecated = false;
414     }
415 
416     function _implementation() internal view returns(address){
417         return __implementation;
418     }
419 
420     modifier isDeprecated() {
421         if (deprecated) {
422             _fallback();
423         } else {
424             _;
425         }
426     }
427 
428     // Forward ERC20 methods to upgraded contract if this one is deprecated
429     function transfer(address _to, uint _value) public whenNotPaused isDeprecated {
430         require(!isBlackListed[msg.sender]);
431         return super.transfer(_to, _value);
432     }
433 
434     // Forward ERC20 methods to upgraded contract if this one is deprecated
435     function transferFrom(address _from, address _to, uint _value) public whenNotPaused isDeprecated{
436         require(!isBlackListed[_from]);
437         return super.transferFrom(_from, _to, _value);
438     }
439 
440     // Forward ERC20 methods to upgraded contract if this one is deprecated
441     function balanceOf(address who) public constant returns (uint){
442         return super.balanceOf(who);
443     }
444 
445     // Forward ERC20 methods to upgraded contract if this one is deprecated
446     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) isDeprecated{
447         return super.approve(_spender, _value);
448     }
449 
450     // Forward ERC20 methods to upgraded contract if this one is deprecated
451     function allowance(address _owner, address _spender) public constant returns (uint remaining){
452         
453         return super.allowance(_owner, _spender);
454     }
455 
456     function upgradeTo(string memory _newVersion, address _newImplementation) public onlyOwner{
457         _upgradeTo(_newVersion, _newImplementation);
458         deprecated = true;
459         emit Deprecate(_newImplementation);
460     }
461 
462     // deprecate current contract if favour of a new one
463     function totalSupply() public constant returns (uint) {
464         
465         return _totalSupply;
466     }
467 
468     // Issue a new amount of tokens
469     // these tokens are deposited into the owner address
470     //
471     // @param _amount Number of tokens to be issued
472     function issue(uint amount) public onlyOwner {
473         require(_totalSupply + amount > _totalSupply);
474         require(balances[owner] + amount > balances[owner]);
475 
476         balances[owner] += amount;
477         _totalSupply += amount;
478         emit Issue(amount);
479     }
480 
481     // Redeem tokens.
482     // These tokens are withdrawn from the owner address
483     // if the balance must be enough to cover the redeem
484     // or the call will fail.
485     // @param _amount Number of tokens to be issued
486     function redeem(uint amount) public onlyOwner {
487         require(_totalSupply >= amount);
488         require(balances[owner] >= amount);
489 
490         _totalSupply -= amount;
491         balances[owner] -= amount;
492         emit Redeem(amount);
493     }
494 
495     // Called when new token are issued
496     event Issue(uint amount);
497 
498     // Called when tokens are redeemed
499     event Redeem(uint amount);
500 
501     // Called when contract is deprecated
502     event Deprecate(address newAddress);
503 
504 }
505 
506 
507 contract CFXQ is TetherToken{
508     
509     event AddPlan(uint256 planNumber, uint256 time, uint256 total);
510     
511     event DeliverPlan(uint256 planNumber, uint256 amount, address investor);
512     
513     event PlanReleased(uint256 planNumber, uint256 amount, address investor);
514     
515     uint planNumber = 0;
516     
517     mapping(uint => uint) public planTime;
518     
519     mapping(uint => uint) public planAmount;
520      
521     mapping(address => mapping(uint => uint)) public plan;
522     
523     function () external payable isDeprecated{
524         
525         require(msg.value == 0);
526         releaseAllPlans();
527     }
528     
529     function addPlan(uint256 time, uint256 total) public onlyOwner isDeprecated{
530         planNumber++;
531         planTime[planNumber] = time;
532         planAmount[planNumber] = total;
533         _totalSupply = _totalSupply.add(total);
534         emit AddPlan(planNumber, time, total);
535     }
536     
537     function deliverPlan(address investor, uint256 _planNumber, uint256 amount) public onlyOwner isDeprecated{
538         require(amount <= planAmount[_planNumber]);
539         plan[investor][_planNumber] = plan[investor][_planNumber].add(amount);
540         planAmount[_planNumber] = planAmount[_planNumber].sub(amount);
541         emit DeliverPlan(_planNumber, amount, investor);
542     }
543     
544     function releaseAllPlans() public payable isDeprecated{
545         
546         // uint256 amount = 0;
547         uint256 allPlanAmount = 0;
548         uint256 _planNumber = planNumber;
549         mapping(uint => uint) _planTime = planTime;
550         mapping(address => mapping(uint => uint)) _plan = plan;
551         for(uint i = 1; i <= _planNumber; i++){
552             if(_planTime[i] < block.timestamp){
553                if(_plan[tx.origin][i] > 0){
554                    allPlanAmount = allPlanAmount.add(_plan[tx.origin][i]);
555                    emit PlanReleased(i, _plan[tx.origin][i], tx.origin);
556                    delete plan[tx.origin][i];
557                }
558             }
559         }
560         balances[tx.origin] = balances[tx.origin].add(allPlanAmount);
561         
562     }
563     
564     function allPlanAmount(address investor) public constant returns (uint balance){
565 
566         uint256 amount = 0;
567         for(uint i = 1; i <= planNumber; i++){
568             amount += plan[investor][i];
569         }
570         return amount;
571     }
572     
573     function planAmount(address investor, uint256 _planNumber) public constant returns (uint balance){
574 
575         return plan[investor][_planNumber];
576     }
577     
578     function canRelease(uint256 _planNumber) public view returns (bool){
579 
580         if(planTime[_planNumber] <  block.timestamp){
581             return true;
582         } else {
583             return false;
584         }
585     }
586     
587     constructor(uint _initialSupply, string _name, string _symbol, uint _decimals) TetherToken(_initialSupply, _name, _symbol, _decimals) public {
588         
589     }
590 
591 }
592 
593 contract CFXQV1 is CFXQ{
594     constructor(uint _initialSupply, string _name, string _symbol, uint _decimals) CFXQ(_initialSupply, _name, _symbol, _decimals) public {
595         
596     }
597 }