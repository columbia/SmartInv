1 pragma solidity ^ 0.4.23;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 
7 
8 library SafeMath {
9     /**
10      * @dev Multiplies two numbers, throws on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20     /**
21      * @dev Integer division of two numbers, truncating the quotient.
22      */
23     function div(uint256 a, uint256 b) internal pure returns(uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return c;
28     }
29     /**
30      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31      */
32     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36     /**
37      * @dev Adds two numbers, throws on overflow.
38      */
39     function add(uint256 a, uint256 b) internal pure returns(uint256) {
40         uint256 c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 
46 contract Ownable {
47     address public owner;
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49     /**
50      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51      * account.
52      */
53     constructor() public {
54         owner = msg.sender;
55     }
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63     /**
64      * @dev Allows the current owner to transfer control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function transferOwnership(address newOwner) public onlyOwner {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71     }
72 }
73 
74 
75 contract Pausable is Ownable {
76     event Pause();
77     event Unpause();
78     bool public paused = false;
79     /**
80      * @dev Modifier to make a function callable only when the contract is not paused.
81      */
82     modifier whenNotPaused() {
83         require(!paused);
84         _;
85     }
86     /**
87      * @dev Modifier to make a function callable only when the contract is paused.
88      */
89     modifier whenPaused() {
90         require(paused);
91         _;
92     }
93     /**
94      * @dev called by the owner to pause, triggers stopped state
95      */
96     function pause() onlyOwner whenNotPaused public {
97         paused = true;
98         emit Pause();
99     }
100     /**
101      * @dev called by the owner to unpause, returns to normal state
102      */
103     function unpause() onlyOwner whenPaused public {
104         paused = false;
105         emit Unpause();
106     }
107 }
108 
109 
110 contract Controlled is Pausable {
111     /// @notice The address of the controller is the only address that can call
112     ///  a function with this modifier
113     modifier onlyController {
114         require(msg.sender == controller);
115         _;
116     }
117     modifier onlyControllerorOwner {
118         require((msg.sender == controller) || (msg.sender == owner));
119         _;
120     }
121     address public controller;
122     constructor() public {
123         controller = msg.sender;
124     }
125     /// @notice Changes the controller of the contract
126     /// @param _newController The new controller of the contract
127     function changeController(address _newController) public onlyControllerorOwner {
128         controller = _newController;
129     }
130 }
131 contract TokenController {
132     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
133     /// @param _owner The address that sent the ether to create tokens
134     /// @return True if the ether is accepted, false if it throws
135     function proxyPayment(address _owner) public payable returns(bool);
136     /// @notice Notifies the controller about a token transfer allowing the
137     ///  controller to react if desired
138     /// @param _from The origin of the transfer
139     /// @param _to The destination of the transfer
140     /// @param _amount The amount of the transfer
141     /// @return False if the controller does not authorize the transfer
142     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
143     /// @notice Notifies the controller about an approval allowing the
144     ///  controller to react if desired
145     /// @param _owner The address that calls `approve()`
146     /// @param _spender The spender in the `approve()` call
147     /// @param _amount The amount in the `approve()` call
148     /// @return False if the controller does not authorize the approval
149     function onApprove(address _owner, address _spender, uint _amount) public
150     returns(bool);
151 }
152 /// @dev The actual token contract, the default controller is the msg.sender
153 ///  that deploys the contract, so usually this token will be deployed by a
154 ///  token controller contract, which Giveth will call a "Campaign"
155 contract MiniMeToken is Controlled {
156     using SafeMath
157     for uint256;
158     string public name; //The Token's name: e.g. DigixDAO Tokens
159     uint8 public decimals; //Number of decimals of the smallest unit
160     string public symbol; //An identifier: e.g. REP
161     string public version = 'V 1.0'; //An arbitrary versioning scheme
162     /// @dev `Checkpoint` is the structure that attaches a block number to a
163     ///  given value, the block number attached is the one that last changed the
164     ///  value
165     struct Checkpoint {
166         // `fromBlock` is the block number that the value was generated from
167         uint128 fromBlock;
168         // `value` is the amount of tokens at a specific block number
169         uint128 value;
170     }
171     // `parentToken` is the Token address that was cloned to produce this token;
172     //  it will be 0x0 for a token that was not cloned
173     MiniMeToken public parentToken;
174     // `parentSnapShotBlock` is the block number from the Parent Token that was
175     //  used to determine the initial distribution of the Clone Token
176     uint public parentSnapShotBlock;
177     // `creationBlock` is the block number that the Clone Token was created
178     uint public creationBlock;
179     // `balances` is the map that tracks the balance of each address, in this
180     //  contract when the balance changes the block number that the change
181     //  occurred is also included in the map
182     mapping(address => Checkpoint[]) balances;
183     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
184     mapping(address => mapping(address => uint256)) allowed;
185     // Tracks the history of the `totalSupply` of the token
186     Checkpoint[] totalSupplyHistory;
187     // Flag that determines if the token is transferable or not.
188     bool public transfersEnabled;
189     // The factory used to create new clone tokens
190     MiniMeTokenFactory public tokenFactory;
191     ////////////////
192     // Constructor
193     ////////////////
194     /// @notice Constructor to create a MiniMeToken
195     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
196     ///  will create the Clone token contracts, the token factory needs to be
197     ///  deployed first
198     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
199     ///  new token
200     /// @param _parentSnapShotBlock Block of the parent token that will
201     ///  determine the initial distribution of the clone token, set to 0 if it
202     ///  is a new token
203     /// @param _tokenName Name of the new token
204     /// @param _decimalUnits Number of decimals of the new token
205     /// @param _tokenSymbol Token Symbol for the new token
206     /// @param _transfersEnabled If true, tokens will be able to be transferred
207     constructor(
208         address _tokenFactory,
209         address _parentToken,
210         uint _parentSnapShotBlock,
211         string _tokenName,
212         uint8 _decimalUnits,
213         string _tokenSymbol,
214         bool _transfersEnabled
215     ) public {
216         tokenFactory = MiniMeTokenFactory(_tokenFactory);
217         name = _tokenName; // Set the name
218         decimals = _decimalUnits; // Set the decimals
219         symbol = _tokenSymbol; // Set the symbol
220         parentToken = MiniMeToken(_parentToken);
221         parentSnapShotBlock = _parentSnapShotBlock;
222         transfersEnabled = _transfersEnabled;
223         creationBlock = block.number;
224     }
225     ///////////////////
226     // ERC20 Methods
227     ///////////////////
228     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
229     /// @param _to The address of the recipient
230     /// @param _amount The amount of tokens to be transferred
231     /// @return Whether the transfer was successful or not
232     function transfer(address _to, uint256 _amount) public returns(bool success) {
233         require(transfersEnabled);
234         doTransfer(msg.sender, _to, _amount);
235         return true;
236     }
237     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
238     ///  is approved by `_from`
239     /// @param _from The address holding the tokens being transferred
240     /// @param _to The address of the recipient
241     /// @param _amount The amount of tokens to be transferred
242     /// @return True if the transfer was successful
243     function transferFrom(address _from, address _to, uint256 _amount) public returns(bool success) {
244         // The controller of this contract can move tokens around at will,
245         //  this is important to recognize! Confirm that you trust the
246         //  controller of this contract, which in most situations should be
247         //  another open source smart contract or 0x0
248         if (msg.sender != controller) {
249             require(transfersEnabled);
250             // The standard ERC 20 transferFrom functionality
251             require(allowed[_from][msg.sender] >= _amount);
252             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
253         }
254         doTransfer(_from, _to, _amount);
255         return true;
256     }
257     /// @dev This is the actual transfer function in the token contract, it can
258     ///  only be called by other functions in this contract.
259     /// @param _from The address holding the tokens being transferred
260     /// @param _to The address of the recipient
261     /// @param _amount The amount of tokens to be transferred
262     /// @return True if the transfer was successful
263     function doTransfer(address _from, address _to, uint _amount) internal {
264         if (_amount == 0) {
265             emit Transfer(_from, _to, _amount); // Follow the spec to louch the event when transfer 0
266             return;
267         }
268         // Do not allow transfer to 0x0 or the token contract itself
269         require((_to != 0) && (_to != address(this)));
270         // If the amount being transfered is more than the balance of the
271         //  account the transfer throws
272         uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
273         require(previousBalanceFrom >= _amount);
274         //  sending the tokens
275         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
276         // Then update the balance array with the new value for the address
277         //  receiving the tokens
278         uint256 previousBalanceTo = balanceOfAt(_to, block.number);
279         require(previousBalanceTo.add(_amount) >= previousBalanceTo); // Check for overflow
280         updateValueAtNow(balances[_to], previousBalanceTo.add(_amount));
281         // An event to make the transfer easy to find on the blockchain
282         emit Transfer(_from, _to, _amount);
283     }
284     /// @param _owner The address that's balance is being requested
285     /// @return The balance of `_owner` at the current block
286     function balanceOf(address _owner) public constant returns(uint256 balance) {
287         return balanceOfAt(_owner, block.number);
288     }
289     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
290     ///  its behalf. This is a modified version of the ERC20 approve function
291     ///  to be a little bit safer
292     /// @param _spender The address of the account able to transfer the tokens
293     /// @param _amount The amount of tokens to be approved for transfer
294     /// @return True if the approval was successful
295     function approve(address _spender, uint256 _amount) public returns(bool success) {
296         require(transfersEnabled);
297         // To change the approve amount you first have to reduce the addresses`
298         //  allowance to zero by calling `approve(_spender,0)` if it is not
299         //  already 0 to mitigate the race condition described here:
300         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
301         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
302         //  Alerts the token controller of the approve function call
303         if (isContract(controller)) {
304             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
305         }
306         allowed[msg.sender][_spender] = _amount;
307         emit Approval(msg.sender, _spender, _amount);
308         return true;
309     }
310     /// @dev This function makes it easy to read the `allowed[]` map
311     /// @param _owner The address of the account that owns the token
312     /// @param _spender The address of the account able to transfer the tokens
313     /// @return Amount of remaining tokens of _owner that _spender is allowed
314     ///  to spend
315     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
316         return allowed[_owner][_spender];
317     }
318     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
319     ///  its behalf, and then a function is triggered in the contract that is
320     ///  being approved, `_spender`. This allows users to use their tokens to
321     ///  interact with contracts in one function call instead of two
322     /// @param _spender The address of the contract able to transfer the tokens
323     /// @param _amount The amount of tokens to be approved for transfer
324     /// @return True if the function call was successful
325     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns(bool success) {
326         require(approve(_spender, _amount));
327         ApproveAndCallFallBack(_spender).receiveApproval(
328             msg.sender,
329             _amount,
330             this,
331             _extraData
332         );
333         return true;
334     }
335     /// @dev This function makes it easy to get the total number of tokens
336     /// @return The total number of tokens
337     function totalSupply() public constant returns(uint) {
338         return totalSupplyAt(block.number);
339     }
340     ////////////////
341     // Query balance and totalSupply in History
342     ////////////////
343     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
344     /// @param _owner The address from which the balance will be retrieved
345     /// @param _blockNumber The block number when the balance is queried
346     /// @return The balance at `_blockNumber`
347     function balanceOfAt(address _owner, uint _blockNumber) public constant
348     returns(uint) {
349         // These next few lines are used when the balance of the token is
350         //  requested before a check point was ever created for this token, it
351         //  requires that the `parentToken.balanceOfAt` be queried at the
352         //  genesis block for that token as this contains initial balance of
353         //  this token
354         if ((balances[_owner].length == 0) ||
355             (balances[_owner][0].fromBlock > _blockNumber)) {
356             if (address(parentToken) != 0) {
357                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
358             } else {
359                 // Has no parent
360                 return 0;
361             }
362             // This will return the expected balance during normal situations
363         } else {
364             return getValueAt(balances[_owner], _blockNumber);
365         }
366     }
367     /// @notice Total amount of tokens at a specific `_blockNumber`.
368     /// @param _blockNumber The block number when the totalSupply is queried
369     /// @return The total amount of tokens at `_blockNumber`
370     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
371         // These next few lines are used when the totalSupply of the token is
372         //  requested before a check point was ever created for this token, it
373         //  requires that the `parentToken.totalSupplyAt` be queried at the
374         //  genesis block for this token as that contains totalSupply of this
375         //  token at this block number.
376         if ((totalSupplyHistory.length == 0) ||
377             (totalSupplyHistory[0].fromBlock > _blockNumber)) {
378             if (address(parentToken) != 0) {
379                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
380             } else {
381                 return 0;
382             }
383             // This will return the expected totalSupply during normal situations
384         } else {
385             return getValueAt(totalSupplyHistory, _blockNumber);
386         }
387     }
388     ////////////////
389     // Generate and destroy tokens
390     ////////////////
391     /// @notice Generates `_amount` tokens that are assigned to `_owner`
392     /// @param _owner The address that will be assigned the new tokens
393     /// @param _amount The quantity of tokens generated
394     /// @return True if the tokens are generated correctly
395     function generateTokens(address _owner, uint _amount) public onlyControllerorOwner whenNotPaused returns(bool) {
396         uint curTotalSupply = totalSupply();
397         require(curTotalSupply.add(_amount) >= curTotalSupply); // Check for overflow
398         uint previousBalanceTo = balanceOf(_owner);
399         require(previousBalanceTo.add(_amount) >= previousBalanceTo); // Check for overflow
400         updateValueAtNow(totalSupplyHistory, curTotalSupply.add(_amount));
401         updateValueAtNow(balances[_owner], previousBalanceTo.add(_amount));
402         emit Transfer(0, _owner, _amount);
403         return true;
404     }
405     /// @notice Burns `_amount` tokens from `_owner`
406     /// @param _owner The address that will lose the tokens
407     /// @param _amount The quantity of tokens to burn
408     /// @return True if the tokens are burned correctly
409     function destroyTokens(address _owner, uint _amount) onlyControllerorOwner public returns(bool) {
410         uint curTotalSupply = totalSupply();
411         require(curTotalSupply >= _amount);
412         uint previousBalanceFrom = balanceOf(_owner);
413         require(previousBalanceFrom >= _amount);
414         updateValueAtNow(totalSupplyHistory, curTotalSupply.sub(_amount));
415         updateValueAtNow(balances[_owner], previousBalanceFrom.sub(_amount));
416         emit Transfer(_owner, 0, _amount);
417         return true;
418     }
419     ////////////////
420     // Enable tokens transfers
421     ////////////////
422     /// @notice Enables token holders to transfer their tokens freely if true
423     /// @param _transfersEnabled True if transfers are allowed in the clone
424     function enableTransfers(bool _transfersEnabled) public onlyControllerorOwner {
425         transfersEnabled = _transfersEnabled;
426     }
427     ////////////////
428     // Internal helper functions to query and set a value in a snapshot array
429     ////////////////
430     /// @dev `getValueAt` retrieves the number of tokens at a given block number
431     /// @param checkpoints The history of values being queried
432     /// @param _block The block number to retrieve the value at
433     /// @return The number of tokens being queried
434     function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns(uint) {
435         if (checkpoints.length == 0) return 0;
436         // Shortcut for the actual value
437         if (_block >= checkpoints[checkpoints.length.sub(1)].fromBlock)
438             return checkpoints[checkpoints.length.sub(1)].value;
439         if (_block < checkpoints[0].fromBlock) return 0;
440         // Binary search of the value in the array
441         uint min = 0;
442         uint max = checkpoints.length.sub(1);
443         while (max > min) {
444             uint mid = (max.add(min).add(1)).div(2);
445             if (checkpoints[mid].fromBlock <= _block) {
446                 min = mid;
447             } else {
448                 max = mid.sub(1);
449             }
450         }
451         return checkpoints[min].value;
452     }
453     /// @dev `updateValueAtNow` used to update the `balances` map and the
454     ///  `totalSupplyHistory`
455     /// @param checkpoints The history of data being updated
456     /// @param _value The new number of tokens
457     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
458         if ((checkpoints.length == 0) ||
459             (checkpoints[checkpoints.length.sub(1)].fromBlock < block.number)) {
460             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
461             newCheckPoint.fromBlock = uint128(block.number);
462             newCheckPoint.value = uint128(_value);
463         } else {
464             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length.sub(1)];
465             oldCheckPoint.value = uint128(_value);
466         }
467     }
468     /// @dev Internal function to determine if an address is a contract
469     /// @param _addr The address being queried
470     /// @return True if `_addr` is a contract
471     function isContract(address _addr) constant internal returns(bool) {
472         uint size;
473         if (_addr == 0) return false;
474         assembly {
475             size: = extcodesize(_addr)
476         }
477         return size > 0;
478     }
479     /// @dev Helper function to return a min betwen the two uints
480     function min(uint a, uint b) pure internal returns(uint) {
481         return a < b ? a : b;
482     }
483     /// @notice The fallback function: If the contract's controller has not been
484     ///  set to 0, then the `proxyPayment` method is called which relays the
485     ///  ether and creates tokens as described in the token controller contract
486     function() public payable {
487         /*require(isContract(controller));
488         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));*/
489         revert();
490     }
491     //////////
492     // Safety Methods
493     //////////
494     /// @notice This method can be used by the controller to extract mistakenly
495     ///  sent tokens to this contract.
496     /// @param _token The address of the token contract that you want to recover
497     ///  set to 0 in case you want to extract ether.
498     function claimTokens(address _token) public onlyControllerorOwner {
499         if (_token == 0x0) {
500             controller.transfer(address(this).balance);
501             return;
502         }
503         MiniMeToken token = MiniMeToken(_token);
504         uint balance = token.balanceOf(this);
505         token.transfer(controller, balance);
506         emit ClaimedTokens(_token, controller, balance);
507     }
508     ////////////////
509     // Events
510     ////////////////
511     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
512     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
513     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
514     event Approval(
515         address indexed _owner,
516         address indexed _spender,
517         uint256 _amount
518     );
519 }
520 /**
521  * @title ERC20Basic
522  * @dev Simpler version of ERC20 interface
523  * @dev see https://github.com/ethereum/EIPs/issues/179
524  */
525 contract ERC20Basic {
526     function totalSupply() public view returns(uint256);
527 
528     function balanceOf(address who) public view returns(uint256);
529 
530     function transfer(address to, uint256 value) public returns(bool);
531     event Transfer(address indexed from, address indexed to, uint256 value);
532 }
533 contract ApproveAndCallFallBack {
534     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
535 }
536 
537 contract EmaToken is MiniMeToken {
538     constructor(address tokenfactory, address parenttoken, uint parentsnapshot, string tokenname, uint8 dec, string tokensymbol, bool transfersenabled)
539     MiniMeToken(tokenfactory, parenttoken, parentsnapshot, tokenname, dec, tokensymbol, transfersenabled) public {}
540 }
541 /**
542  * @title ERC20 interface
543  * @dev see https://github.com/ethereum/EIPs/issues/20
544  */
545 contract ERC20 is ERC20Basic {
546     function allowance(address owner, address spender) public view returns(uint256);
547 
548     function transferFrom(address from, address to, uint256 value) public returns(bool);
549 
550     function approve(address spender, uint256 value) public returns(bool);
551     event Approval(address indexed owner, address indexed spender, uint256 value);
552 }
553 
554 /**
555  * @title Crowdsale
556  * @dev Crowdsale is a base contract for managing a token crowdsale,
557  * allowing investors to purchase tokens with ether. This contract implements
558  * such functionality in its most fundamental form and can be extended to provide additional
559  * functionality and/or custom behavior.
560  * The external interface represents the basic interface for purchasing tokens, and conform
561  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
562  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
563  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
564  * behavior.
565  */
566 
567 ////////////////
568 // MiniMeTokenFactory
569 ////////////////
570 /// @dev This contract is used to generate clone contracts from a contract.
571 ///  In solidity this is the way to create a contract from a contract of the
572 ///  same class
573 contract MiniMeTokenFactory {
574     /// @notice Update the DApp by creating a new token with new functionalities
575     ///  the msg.sender becomes the controller of this clone token
576     /// @param _parentToken Address of the token being cloned
577     /// @param _snapshotBlock Block of the parent token that will
578     ///  determine the initial distribution of the clone token
579     /// @param _tokenName Name of the new token
580     /// @param _decimalUnits Number of decimals of the new token
581     /// @param _tokenSymbol Token Symbol for the new token
582     /// @param _transfersEnabled If true, tokens will be able to be transferred
583     /// @return The address of the new token contract
584     function createCloneToken(
585         address _parentToken,
586         uint _snapshotBlock,
587         string _tokenName,
588         uint8 _decimalUnits,
589         string _tokenSymbol,
590         bool _transfersEnabled
591     ) public returns(MiniMeToken) {
592         MiniMeToken newToken = new MiniMeToken(
593             this,
594             _parentToken,
595             _snapshotBlock,
596             _tokenName,
597             _decimalUnits,
598             _tokenSymbol,
599             _transfersEnabled
600         );
601         newToken.changeController(msg.sender);
602         return newToken;
603     }
604 }
605 
606 contract transferBounties is Ownable {
607     // The token being sold
608     MiniMeToken public token;
609     using SafeMath
610     for uint256;
611     constructor(MiniMeToken tokenx) public {
612         token = tokenx; 
613         owner = msg.sender; 
614     }
615 
616     function tranferPresaleTokens(address investor, uint256 ammount) public onlyOwner {
617      
618         token.transferFrom(this, investor, ammount);
619     }
620      function tranferPresaleTokensBulk(address[] _investors, uint256[] ammount) public onlyOwner{
621         uint256 i = 0;
622         for(i;i<_investors.length;i++){
623          token.transferFrom(this, _investors[i], ammount[i]);
624             
625         }
626     }
627     
628     function changeOwner(address newOwner) public onlyOwner {
629         owner = newOwner; 
630     }
631 }