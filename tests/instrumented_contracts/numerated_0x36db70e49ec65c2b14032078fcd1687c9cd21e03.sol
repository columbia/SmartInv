1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     emit Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     emit Unpause();
88   }
89 }
90 
91 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
103     if (a == 0) {
104       return 0;
105     }
106     c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     // uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return a / b;
119   }
120 
121   /**
122   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
133     c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
140 
141 /**
142  * @title ERC20Basic
143  * @dev Simpler version of ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/179
145  */
146 contract ERC20Basic {
147   function totalSupply() public view returns (uint256);
148   function balanceOf(address who) public view returns (uint256);
149   function transfer(address to, uint256 value) public returns (bool);
150   event Transfer(address indexed from, address indexed to, uint256 value);
151 }
152 
153 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
154 
155 /**
156  * @title Basic token
157  * @dev Basic version of StandardToken, with no allowances.
158  */
159 contract BasicToken is ERC20Basic {
160   using SafeMath for uint256;
161 
162   mapping(address => uint256) balances;
163 
164   uint256 totalSupply_;
165 
166   /**
167   * @dev total number of tokens in existence
168   */
169   function totalSupply() public view returns (uint256) {
170     return totalSupply_;
171   }
172 
173   /**
174   * @dev transfer token for a specified address
175   * @param _to The address to transfer to.
176   * @param _value The amount to be transferred.
177   */
178   function transfer(address _to, uint256 _value) public returns (bool) {
179     require(_to != address(0));
180     require(_value <= balances[msg.sender]);
181 
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     emit Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189   * @dev Gets the balance of the specified address.
190   * @param _owner The address to query the the balance of.
191   * @return An uint256 representing the amount owned by the passed address.
192   */
193   function balanceOf(address _owner) public view returns (uint256) {
194     return balances[_owner];
195   }
196 
197 }
198 
199 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
200 
201 /**
202  * @title ERC20 interface
203  * @dev see https://github.com/ethereum/EIPs/issues/20
204  */
205 contract ERC20 is ERC20Basic {
206   function allowance(address owner, address spender) public view returns (uint256);
207   function transferFrom(address from, address to, uint256 value) public returns (bool);
208   function approve(address spender, uint256 value) public returns (bool);
209   event Approval(address indexed owner, address indexed spender, uint256 value);
210 }
211 
212 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
213 
214 /**
215  * @title Standard ERC20 token
216  *
217  * @dev Implementation of the basic standard token.
218  * @dev https://github.com/ethereum/EIPs/issues/20
219  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
220  */
221 contract StandardToken is ERC20, BasicToken {
222 
223   mapping (address => mapping (address => uint256)) internal allowed;
224 
225 
226   /**
227    * @dev Transfer tokens from one address to another
228    * @param _from address The address which you want to send tokens from
229    * @param _to address The address which you want to transfer to
230    * @param _value uint256 the amount of tokens to be transferred
231    */
232   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
233     require(_to != address(0));
234     require(_value <= balances[_from]);
235     require(_value <= allowed[_from][msg.sender]);
236 
237     balances[_from] = balances[_from].sub(_value);
238     balances[_to] = balances[_to].add(_value);
239     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
240     emit Transfer(_from, _to, _value);
241     return true;
242   }
243 
244   /**
245    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
246    *
247    * Beware that changing an allowance with this method brings the risk that someone may use both the old
248    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
249    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
250    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
251    * @param _spender The address which will spend the funds.
252    * @param _value The amount of tokens to be spent.
253    */
254   function approve(address _spender, uint256 _value) public returns (bool) {
255     allowed[msg.sender][_spender] = _value;
256     emit Approval(msg.sender, _spender, _value);
257     return true;
258   }
259 
260   /**
261    * @dev Function to check the amount of tokens that an owner allowed to a spender.
262    * @param _owner address The address which owns the funds.
263    * @param _spender address The address which will spend the funds.
264    * @return A uint256 specifying the amount of tokens still available for the spender.
265    */
266   function allowance(address _owner, address _spender) public view returns (uint256) {
267     return allowed[_owner][_spender];
268   }
269 
270   /**
271    * @dev Increase the amount of tokens that an owner allowed to a spender.
272    *
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
281     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
282     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283     return true;
284   }
285 
286   /**
287    * @dev Decrease the amount of tokens that an owner allowed to a spender.
288    *
289    * approve should be called when allowed[_spender] == 0. To decrement
290    * allowed value is better to use this function to avoid 2 calls (and wait until
291    * the first transaction is mined)
292    * From MonolithDAO Token.sol
293    * @param _spender The address which will spend the funds.
294    * @param _subtractedValue The amount of tokens to decrease the allowance by.
295    */
296   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
297     uint oldValue = allowed[msg.sender][_spender];
298     if (_subtractedValue > oldValue) {
299       allowed[msg.sender][_spender] = 0;
300     } else {
301       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302     }
303     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307 }
308 
309 // File: contracts/OwnedPausableToken.sol
310 
311 /**
312  * @title Pausable token that allows transfers by owner while paused
313  * @dev StandardToken modified with pausable transfers.
314  **/
315 contract OwnedPausableToken is StandardToken, Pausable {
316 
317   /**
318    * @dev Modifier to make a function callable only when the contract is not paused or the caller is the owner
319    */
320   modifier whenNotPausedOrIsOwner() {
321     require(!paused || msg.sender == owner);
322     _;
323   }
324 
325   function transfer(address _to, uint256 _value) public whenNotPausedOrIsOwner returns (bool) {
326     return super.transfer(_to, _value);
327   }
328 
329   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
330     return super.transferFrom(_from, _to, _value);
331   }
332 
333   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
334     return super.approve(_spender, _value);
335   }
336 
337   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
338     return super.increaseApproval(_spender, _addedValue);
339   }
340 
341   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
342     return super.decreaseApproval(_spender, _subtractedValue);
343   }
344 }
345 
346 // File: contracts/interfaces/IDAVToken.sol
347 
348 contract IDAVToken is ERC20 {
349 
350   function name() public view returns (string) {}
351   function symbol() public view returns (string) {}
352   function decimals() public view returns (uint8) {}
353   function increaseApproval(address _spender, uint _addedValue) public returns (bool success);
354   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success);
355 
356   function owner() public view returns (address) {}
357   function transferOwnership(address newOwner) public;
358 
359   function burn(uint256 _value) public;
360 
361   function pauseCutoffTime() public view returns (uint256) {}
362   function paused() public view returns (bool) {}
363   function pause() public;
364   function unpause() public;
365   function setPauseCutoffTime(uint256 _pauseCutoffTime) public;
366 
367 }
368 
369 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
370 
371 /**
372  * @title Burnable Token
373  * @dev Token that can be irreversibly burned (destroyed).
374  */
375 contract BurnableToken is BasicToken {
376 
377   event Burn(address indexed burner, uint256 value);
378 
379   /**
380    * @dev Burns a specific amount of tokens.
381    * @param _value The amount of token to be burned.
382    */
383   function burn(uint256 _value) public {
384     _burn(msg.sender, _value);
385   }
386 
387   function _burn(address _who, uint256 _value) internal {
388     require(_value <= balances[_who]);
389     // no need to require value <= totalSupply, since that would imply the
390     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
391 
392     balances[_who] = balances[_who].sub(_value);
393     totalSupply_ = totalSupply_.sub(_value);
394     emit Burn(_who, _value);
395     emit Transfer(_who, address(0), _value);
396   }
397 }
398 
399 // File: contracts/DAVToken.sol
400 
401 /**
402  * @title DAV Token
403  * @dev ERC20 token
404  */
405 contract DAVToken is IDAVToken, BurnableToken, OwnedPausableToken {
406 
407   // Token constants
408   string public name = 'DAV Token';
409   string public symbol = 'DAV';
410   uint8 public decimals = 18;
411 
412   // Time after which pause can no longer be called
413   uint256 public pauseCutoffTime;
414 
415   /**
416    * @notice DAVToken constructor
417    * Runs once on initial contract creation. Sets initial supply and balances.
418    */
419   constructor(uint256 _initialSupply) public {
420     totalSupply_ = _initialSupply;
421     balances[msg.sender] = totalSupply_;
422   }
423 
424   /**
425    * Set the cutoff time after which the token can no longer be paused
426    * Cannot be in the past. Can only be set once.
427    *
428    * @param _pauseCutoffTime Time for pause cutoff.
429    */
430   function setPauseCutoffTime(uint256 _pauseCutoffTime) onlyOwner public {
431     // Make sure time is not in the past
432     // solium-disable-next-line security/no-block-members
433     require(_pauseCutoffTime >= block.timestamp);
434     // Make sure cutoff time hasn't been set already
435     require(pauseCutoffTime == 0);
436     // Set the cutoff time
437     pauseCutoffTime = _pauseCutoffTime;
438   }
439 
440   /**
441    * @dev called by the owner to pause, triggers stopped state
442    */
443   function pause() onlyOwner whenNotPaused public {
444     // Make sure pause cut off time isn't set or if it is, it's in the future
445     // solium-disable-next-line security/no-block-members
446     require(pauseCutoffTime == 0 || pauseCutoffTime >= block.timestamp);
447     paused = true;
448     emit Pause();
449   }
450 
451 }
452 
453 // File: contracts/Identity.sol
454 
455 /**
456  * @title Identity
457  */
458 contract Identity {
459 
460   struct DAVIdentity {
461     address wallet;
462   }
463 
464   mapping (address => DAVIdentity) private identities;
465 
466   DAVToken private token;
467 
468   // Prefix to added to messages signed by web3
469   bytes28 private constant ETH_SIGNED_MESSAGE_PREFIX = '\x19Ethereum Signed Message:\n32';
470   bytes25 private constant DAV_REGISTRATION_REQUEST = 'DAV Identity Registration';
471 
472   /**
473    * @dev Constructor
474    *
475    * @param _davTokenContract address of the DAVToken contract
476    */
477   function Identity(DAVToken _davTokenContract) public {
478     token = _davTokenContract;
479   }
480 
481   function register(address _id, uint8 _v, bytes32 _r, bytes32 _s) public {
482     // Make sure id isn't registered already
483     require(
484       identities[_id].wallet == 0x0
485     );
486     // Generate message hash
487     bytes32 prefixedHash = keccak256(ETH_SIGNED_MESSAGE_PREFIX, keccak256(DAV_REGISTRATION_REQUEST));
488     // Verify message signature
489     require(
490       ecrecover(prefixedHash, _v, _r, _s) == _id
491     );
492 
493     // Register in identities mapping
494     identities[_id] = DAVIdentity({
495       wallet: msg.sender
496     });
497   }
498 
499   function registerSimple() public {
500     // Make sure id isn't registered already
501     require(
502       identities[msg.sender].wallet == 0x0
503     );
504 
505     // Register in identities mapping
506     identities[msg.sender] = DAVIdentity({
507       wallet: msg.sender
508     });
509   }
510 
511   function getBalance(address _id) public view returns (uint256 balance) {
512     return token.balanceOf(identities[_id].wallet);
513   }
514 
515   function verifyOwnership(address _id, address _wallet) public view returns (bool verified) {
516     return identities[_id].wallet == _wallet;
517   }
518 
519   // Check identity registration status
520   function isRegistered(address _id) public view returns (bool) {
521     return identities[_id].wallet != 0x0;
522   }
523 
524   // Get identity wallet
525   function getIdentityWallet(address _id) public view returns (address) {
526     return identities[_id].wallet;
527   }
528 }
529 
530 // File: contracts/BasicMission.sol
531 
532 /**
533  * @title BasicMission
534  * @dev The most basic contract for conducting Missions.
535  *
536  * This contract represents the very basic interface of a mission contract.
537  * In the real world, there is very little reason to use this and not one of the
538  * contracts that extend it. Consider this an interface, more than an implementation.
539  */
540 contract BasicMission {
541 
542   uint256 private nonce;
543 
544   struct Mission {
545     address seller;
546     address buyer;
547     uint256 cost;
548     uint256 balance;
549     bool isSigned;
550     mapping (uint8 => bool) resolvers;
551   }
552 
553   mapping (bytes32 => Mission) private missions;
554 
555   event Create(
556     bytes32 id,
557     address sellerId,
558     address buyerId
559   );
560 
561   event Signed(
562     bytes32 id
563   );
564 
565   DAVToken private token;
566   Identity private identity;
567 
568   /**
569    * @dev Constructor
570    *
571    * @param _identityContract address of the Identity contract
572    * @param _davTokenContract address of the DAVToken contract
573    */
574   function BasicMission(Identity _identityContract, DAVToken _davTokenContract) public {
575     identity = _identityContract;
576     token = _davTokenContract;
577   }
578 
579   /**
580    * @notice Create a new mission
581    * @param _sellerId The DAV Identity of the person providing the service
582    * @param _buyerId The DAV Identity of the person ordering the service
583    * @param _cost The total cost of the mission to be paid by buyer
584    */
585   function create(bytes32 _missionId, address _sellerId, address _buyerId, uint256 _cost) public {
586     // Verify that message sender controls the buyer's wallet
587     require(
588       identity.verifyOwnership(_buyerId, msg.sender)
589     );
590 
591     // Verify buyer's balance is sufficient
592     require(
593       identity.getBalance(_buyerId) >= _cost
594     );
595 
596     // Make sure id isn't registered already
597     require(
598       missions[_missionId].buyer == 0x0
599     );
600 
601     // Transfer tokens to the mission contract
602     token.transferFrom(msg.sender, this, _cost);
603 
604     // Create mission
605     missions[_missionId] = Mission({
606       seller: _sellerId,
607       buyer: _buyerId,
608       cost: _cost,
609       balance: _cost,
610       isSigned: false
611     });
612 
613     // Event
614     emit Create(_missionId, _sellerId, _buyerId);
615   }
616 
617   /**
618   * @notice Fund a mission
619   * @param _missionId The id of the mission
620   * @param _buyerId The DAV Identity of the person ordering the service
621   */
622   function fulfilled(bytes32 _missionId, address _buyerId) public {
623     // Verify that message sender controls the seller's wallet
624     require(
625       identity.verifyOwnership(_buyerId, msg.sender)
626     );
627     
628     require(
629       missions[_missionId].isSigned == false
630     );
631 
632     require(
633       missions[_missionId].balance == missions[_missionId].cost
634     );
635     
636     
637     // designate mission as signed
638     missions[_missionId].isSigned = true;
639     missions[_missionId].balance = 0;
640     token.approve(this, missions[_missionId].cost);
641     token.transferFrom(this, identity.getIdentityWallet(missions[_missionId].seller), missions[_missionId].cost);
642 
643     // Event
644     emit Signed(_missionId);
645   }
646 
647 }