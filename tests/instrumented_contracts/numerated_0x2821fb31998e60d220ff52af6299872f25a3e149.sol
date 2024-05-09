1 pragma solidity ^ 0.4 .23;
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
45 /**
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Ownable {
50     address public owner;
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52     /**
53      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54      * account.
55      */
56     constructor() public {
57         owner = msg.sender;
58     }
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(msg.sender == owner);
64         _;
65     }
66     /**
67      * @dev Allows the current owner to transfer control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function transferOwnership(address newOwner) public onlyOwner {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74     }
75 }
76 
77 
78 contract Pausable is Ownable {
79     event Pause();
80     event Unpause();
81     bool public paused = false;
82     /**
83      * @dev Modifier to make a function callable only when the contract is not paused.
84      */
85     modifier whenNotPaused() {
86         require(!paused);
87         _;
88     }
89     /**
90      * @dev Modifier to make a function callable only when the contract is paused.
91      */
92     modifier whenPaused() {
93         require(paused);
94         _;
95     }
96     /**
97      * @dev called by the owner to pause, triggers stopped state
98      */
99     function pause() onlyOwner whenNotPaused public {
100         paused = true;
101         emit Pause();
102     }
103     /**
104      * @dev called by the owner to unpause, returns to normal state
105      */
106     function unpause() onlyOwner whenPaused public {
107         paused = false;
108         emit Unpause();
109     }
110 }
111 contract Controlled is Pausable {
112     /// @notice The address of the controller is the only address that can call
113     ///  a function with this modifier
114     modifier onlyController {
115         require(msg.sender == controller);
116         _;
117     }
118     modifier onlyControllerorOwner {
119         require((msg.sender == controller) || (msg.sender == owner));
120         _;
121     }
122     address public controller;
123     constructor() public {
124         controller = msg.sender;
125     }
126     /// @notice Changes the controller of the contract
127     /// @param _newController The new controller of the contract
128     function changeController(address _newController) public onlyControllerorOwner {
129         controller = _newController;
130     }
131 }
132 contract TokenController {
133     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
134     /// @param _owner The address that sent the ether to create tokens
135     /// @return True if the ether is accepted, false if it throws
136     function proxyPayment(address _owner) public payable returns(bool);
137     /// @notice Notifies the controller about a token transfer allowing the
138     ///  controller to react if desired
139     /// @param _from The origin of the transfer
140     /// @param _to The destination of the transfer
141     /// @param _amount The amount of the transfer
142     /// @return False if the controller does not authorize the transfer
143     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
144     /// @notice Notifies the controller about an approval allowing the
145     ///  controller to react if desired
146     /// @param _owner The address that calls `approve()`
147     /// @param _spender The spender in the `approve()` call
148     /// @param _amount The amount in the `approve()` call
149     /// @return False if the controller does not authorize the approval
150     function onApprove(address _owner, address _spender, uint _amount) public
151     returns(bool);
152 }
153 /// @dev The actual token contract, the default controller is the msg.sender
154 ///  that deploys the contract, so usually this token will be deployed by a
155 ///  token controller contract, which Giveth will call a "Campaign"
156 contract MiniMeToken is Controlled {
157     using SafeMath
158     for uint256;
159     string public name; //The Token's name: e.g. DigixDAO Tokens
160     uint8 public decimals; //Number of decimals of the smallest unit
161     string public symbol; //An identifier: e.g. REP
162     string public version = 'V 1.0'; //An arbitrary versioning scheme
163     /// @dev `Checkpoint` is the structure that attaches a block number to a
164     ///  given value, the block number attached is the one that last changed the
165     ///  value
166     struct Checkpoint {
167         // `fromBlock` is the block number that the value was generated from
168         uint128 fromBlock;
169         // `value` is the amount of tokens at a specific block number
170         uint128 value;
171     }
172     // `parentToken` is the Token address that was cloned to produce this token;
173     //  it will be 0x0 for a token that was not cloned
174     MiniMeToken public parentToken;
175     // `parentSnapShotBlock` is the block number from the Parent Token that was
176     //  used to determine the initial distribution of the Clone Token
177     uint public parentSnapShotBlock;
178     // `creationBlock` is the block number that the Clone Token was created
179     uint public creationBlock;
180     // `balances` is the map that tracks the balance of each address, in this
181     //  contract when the balance changes the block number that the change
182     //  occurred is also included in the map
183     mapping(address => Checkpoint[]) balances;
184     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
185     mapping(address => mapping(address => uint256)) allowed;
186     // Tracks the history of the `totalSupply` of the token
187     Checkpoint[] totalSupplyHistory;
188     // Flag that determines if the token is transferable or not.
189     bool public transfersEnabled;
190     // The factory used to create new clone tokens
191     MiniMeTokenFactory public tokenFactory;
192     ////////////////
193     // Constructor
194     ////////////////
195     /// @notice Constructor to create a MiniMeToken
196     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
197     ///  will create the Clone token contracts, the token factory needs to be
198     ///  deployed first
199     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
200     ///  new token
201     /// @param _parentSnapShotBlock Block of the parent token that will
202     ///  determine the initial distribution of the clone token, set to 0 if it
203     ///  is a new token
204     /// @param _tokenName Name of the new token
205     /// @param _decimalUnits Number of decimals of the new token
206     /// @param _tokenSymbol Token Symbol for the new token
207     /// @param _transfersEnabled If true, tokens will be able to be transferred
208     constructor(
209         address _tokenFactory,
210         address _parentToken,
211         uint _parentSnapShotBlock,
212         string _tokenName,
213         uint8 _decimalUnits,
214         string _tokenSymbol,
215         bool _transfersEnabled
216     ) public {
217         tokenFactory = MiniMeTokenFactory(_tokenFactory);
218         name = _tokenName; // Set the name
219         decimals = _decimalUnits; // Set the decimals
220         symbol = _tokenSymbol; // Set the symbol
221         parentToken = MiniMeToken(_parentToken);
222         parentSnapShotBlock = _parentSnapShotBlock;
223         transfersEnabled = _transfersEnabled;
224         creationBlock = block.number;
225     }
226     ///////////////////
227     // ERC20 Methods
228     ///////////////////
229     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
230     /// @param _to The address of the recipient
231     /// @param _amount The amount of tokens to be transferred
232     /// @return Whether the transfer was successful or not
233     function transfer(address _to, uint256 _amount) public returns(bool success) {
234         require(transfersEnabled);
235         doTransfer(msg.sender, _to, _amount);
236         return true;
237     }
238     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
239     ///  is approved by `_from`
240     /// @param _from The address holding the tokens being transferred
241     /// @param _to The address of the recipient
242     /// @param _amount The amount of tokens to be transferred
243     /// @return True if the transfer was successful
244     function transferFrom(address _from, address _to, uint256 _amount) public returns(bool success) {
245         // The controller of this contract can move tokens around at will,
246         //  this is important to recognize! Confirm that you trust the
247         //  controller of this contract, which in most situations should be
248         //  another open source smart contract or 0x0
249         if (msg.sender != controller) {
250             require(transfersEnabled);
251             // The standard ERC 20 transferFrom functionality
252             require(allowed[_from][msg.sender] >= _amount);
253             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
254         }
255         doTransfer(_from, _to, _amount);
256         return true;
257     }
258     /// @dev This is the actual transfer function in the token contract, it can
259     ///  only be called by other functions in this contract.
260     /// @param _from The address holding the tokens being transferred
261     /// @param _to The address of the recipient
262     /// @param _amount The amount of tokens to be transferred
263     /// @return True if the transfer was successful
264     function doTransfer(address _from, address _to, uint _amount) internal {
265         if (_amount == 0) {
266             emit Transfer(_from, _to, _amount); // Follow the spec to louch the event when transfer 0
267             return;
268         }
269         // Do not allow transfer to 0x0 or the token contract itself
270         require((_to != 0) && (_to != address(this)));
271         // If the amount being transfered is more than the balance of the
272         //  account the transfer throws
273         uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
274         require(previousBalanceFrom >= _amount);
275         //  sending the tokens
276         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
277         // Then update the balance array with the new value for the address
278         //  receiving the tokens
279         uint256 previousBalanceTo = balanceOfAt(_to, block.number);
280         require(previousBalanceTo.add(_amount) >= previousBalanceTo); // Check for overflow
281         updateValueAtNow(balances[_to], previousBalanceTo.add(_amount));
282         // An event to make the transfer easy to find on the blockchain
283         emit Transfer(_from, _to, _amount);
284     }
285     /// @param _owner The address that's balance is being requested
286     /// @return The balance of `_owner` at the current block
287     function balanceOf(address _owner) public constant returns(uint256 balance) {
288         return balanceOfAt(_owner, block.number);
289     }
290     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
291     ///  its behalf. This is a modified version of the ERC20 approve function
292     ///  to be a little bit safer
293     /// @param _spender The address of the account able to transfer the tokens
294     /// @param _amount The amount of tokens to be approved for transfer
295     /// @return True if the approval was successful
296     function approve(address _spender, uint256 _amount) public returns(bool success) {
297         require(transfersEnabled);
298         // To change the approve amount you first have to reduce the addresses`
299         //  allowance to zero by calling `approve(_spender,0)` if it is not
300         //  already 0 to mitigate the race condition described here:
301         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
302         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
303         //  Alerts the token controller of the approve function call
304         if (isContract(controller)) {
305             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
306         }
307         allowed[msg.sender][_spender] = _amount;
308         emit Approval(msg.sender, _spender, _amount);
309         return true;
310     }
311     /// @dev This function makes it easy to read the `allowed[]` map
312     /// @param _owner The address of the account that owns the token
313     /// @param _spender The address of the account able to transfer the tokens
314     /// @return Amount of remaining tokens of _owner that _spender is allowed
315     ///  to spend
316     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
317         return allowed[_owner][_spender];
318     }
319     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
320     ///  its behalf, and then a function is triggered in the contract that is
321     ///  being approved, `_spender`. This allows users to use their tokens to
322     ///  interact with contracts in one function call instead of two
323     /// @param _spender The address of the contract able to transfer the tokens
324     /// @param _amount The amount of tokens to be approved for transfer
325     /// @return True if the function call was successful
326     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns(bool success) {
327         require(approve(_spender, _amount));
328         ApproveAndCallFallBack(_spender).receiveApproval(
329             msg.sender,
330             _amount,
331             this,
332             _extraData
333         );
334         return true;
335     }
336     /// @dev This function makes it easy to get the total number of tokens
337     /// @return The total number of tokens
338     function totalSupply() public constant returns(uint) {
339         return totalSupplyAt(block.number);
340     }
341     ////////////////
342     // Query balance and totalSupply in History
343     ////////////////
344     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
345     /// @param _owner The address from which the balance will be retrieved
346     /// @param _blockNumber The block number when the balance is queried
347     /// @return The balance at `_blockNumber`
348     function balanceOfAt(address _owner, uint _blockNumber) public constant
349     returns(uint) {
350         // These next few lines are used when the balance of the token is
351         //  requested before a check point was ever created for this token, it
352         //  requires that the `parentToken.balanceOfAt` be queried at the
353         //  genesis block for that token as this contains initial balance of
354         //  this token
355         if ((balances[_owner].length == 0) ||
356             (balances[_owner][0].fromBlock > _blockNumber)) {
357             if (address(parentToken) != 0) {
358                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
359             } else {
360                 // Has no parent
361                 return 0;
362             }
363             // This will return the expected balance during normal situations
364         } else {
365             return getValueAt(balances[_owner], _blockNumber);
366         }
367     }
368     /// @notice Total amount of tokens at a specific `_blockNumber`.
369     /// @param _blockNumber The block number when the totalSupply is queried
370     /// @return The total amount of tokens at `_blockNumber`
371     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
372         // These next few lines are used when the totalSupply of the token is
373         //  requested before a check point was ever created for this token, it
374         //  requires that the `parentToken.totalSupplyAt` be queried at the
375         //  genesis block for this token as that contains totalSupply of this
376         //  token at this block number.
377         if ((totalSupplyHistory.length == 0) ||
378             (totalSupplyHistory[0].fromBlock > _blockNumber)) {
379             if (address(parentToken) != 0) {
380                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
381             } else {
382                 return 0;
383             }
384             // This will return the expected totalSupply during normal situations
385         } else {
386             return getValueAt(totalSupplyHistory, _blockNumber);
387         }
388     }
389     ////////////////
390     // Generate and destroy tokens
391     ////////////////
392     /// @notice Generates `_amount` tokens that are assigned to `_owner`
393     /// @param _owner The address that will be assigned the new tokens
394     /// @param _amount The quantity of tokens generated
395     /// @return True if the tokens are generated correctly
396     function generateTokens(address _owner, uint _amount) public onlyControllerorOwner whenNotPaused returns(bool) {
397         uint curTotalSupply = totalSupply();
398         require(curTotalSupply.add(_amount) >= curTotalSupply); // Check for overflow
399         uint previousBalanceTo = balanceOf(_owner);
400         require(previousBalanceTo.add(_amount) >= previousBalanceTo); // Check for overflow
401         updateValueAtNow(totalSupplyHistory, curTotalSupply.add(_amount));
402         updateValueAtNow(balances[_owner], previousBalanceTo.add(_amount));
403         emit Transfer(0, _owner, _amount);
404         return true;
405     }
406     /// @notice Burns `_amount` tokens from `_owner`
407     /// @param _owner The address that will lose the tokens
408     /// @param _amount The quantity of tokens to burn
409     /// @return True if the tokens are burned correctly
410     function destroyTokens(address _owner, uint _amount) onlyControllerorOwner public returns(bool) {
411         uint curTotalSupply = totalSupply();
412         require(curTotalSupply >= _amount);
413         uint previousBalanceFrom = balanceOf(_owner);
414         require(previousBalanceFrom >= _amount);
415         updateValueAtNow(totalSupplyHistory, curTotalSupply.sub(_amount));
416         updateValueAtNow(balances[_owner], previousBalanceFrom.sub(_amount));
417         emit Transfer(_owner, 0, _amount);
418         return true;
419     }
420     ////////////////
421     // Enable tokens transfers
422     ////////////////
423     /// @notice Enables token holders to transfer their tokens freely if true
424     /// @param _transfersEnabled True if transfers are allowed in the clone
425     function enableTransfers(bool _transfersEnabled) public onlyControllerorOwner {
426         transfersEnabled = _transfersEnabled;
427     }
428     ////////////////
429     // Internal helper functions to query and set a value in a snapshot array
430     ////////////////
431     /// @dev `getValueAt` retrieves the number of tokens at a given block number
432     /// @param checkpoints The history of values being queried
433     /// @param _block The block number to retrieve the value at
434     /// @return The number of tokens being queried
435     function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns(uint) {
436         if (checkpoints.length == 0) return 0;
437         // Shortcut for the actual value
438         if (_block >= checkpoints[checkpoints.length.sub(1)].fromBlock)
439             return checkpoints[checkpoints.length.sub(1)].value;
440         if (_block < checkpoints[0].fromBlock) return 0;
441         // Binary search of the value in the array
442         uint min = 0;
443         uint max = checkpoints.length.sub(1);
444         while (max > min) {
445             uint mid = (max.add(min).add(1)).div(2);
446             if (checkpoints[mid].fromBlock <= _block) {
447                 min = mid;
448             } else {
449                 max = mid.sub(1);
450             }
451         }
452         return checkpoints[min].value;
453     }
454     /// @dev `updateValueAtNow` used to update the `balances` map and the
455     ///  `totalSupplyHistory`
456     /// @param checkpoints The history of data being updated
457     /// @param _value The new number of tokens
458     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
459         if ((checkpoints.length == 0) ||
460             (checkpoints[checkpoints.length.sub(1)].fromBlock < block.number)) {
461             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
462             newCheckPoint.fromBlock = uint128(block.number);
463             newCheckPoint.value = uint128(_value);
464         } else {
465             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length.sub(1)];
466             oldCheckPoint.value = uint128(_value);
467         }
468     }
469     /// @dev Internal function to determine if an address is a contract
470     /// @param _addr The address being queried
471     /// @return True if `_addr` is a contract
472     function isContract(address _addr) constant internal returns(bool) {
473         uint size;
474         if (_addr == 0) return false;
475         assembly {
476             size: = extcodesize(_addr)
477         }
478         return size > 0;
479     }
480     /// @dev Helper function to return a min betwen the two uints
481     function min(uint a, uint b) pure internal returns(uint) {
482         return a < b ? a : b;
483     }
484     /// @notice The fallback function: If the contract's controller has not been
485     ///  set to 0, then the `proxyPayment` method is called which relays the
486     ///  ether and creates tokens as described in the token controller contract
487     function() public payable {
488         /*require(isContract(controller));
489         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));*/
490         revert();
491     }
492     //////////
493     // Safety Methods
494     //////////
495     /// @notice This method can be used by the controller to extract mistakenly
496     ///  sent tokens to this contract.
497     /// @param _token The address of the token contract that you want to recover
498     ///  set to 0 in case you want to extract ether.
499     function claimTokens(address _token) public onlyControllerorOwner {
500         if (_token == 0x0) {
501             controller.transfer(address(this).balance);
502             return;
503         }
504         MiniMeToken token = MiniMeToken(_token);
505         uint balance = token.balanceOf(this);
506         token.transfer(controller, balance);
507         emit ClaimedTokens(_token, controller, balance);
508     }
509     ////////////////
510     // Events
511     ////////////////
512     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
513     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
514     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
515     event Approval(
516         address indexed _owner,
517         address indexed _spender,
518         uint256 _amount
519     );
520 }
521 /**
522  * @title ERC20Basic
523  * @dev Simpler version of ERC20 interface
524  * @dev see https://github.com/ethereum/EIPs/issues/179
525  */
526 contract ERC20Basic {
527     function totalSupply() public view returns(uint256);
528 
529     function balanceOf(address who) public view returns(uint256);
530 
531     function transfer(address to, uint256 value) public returns(bool);
532     event Transfer(address indexed from, address indexed to, uint256 value);
533 }
534 contract ApproveAndCallFallBack {
535     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
536 }
537 
538 contract EmaToken is MiniMeToken {
539     constructor(address tokenfactory, address parenttoken, uint parentsnapshot, string tokenname, uint8 dec, string tokensymbol, bool transfersenabled)
540     MiniMeToken(tokenfactory, parenttoken, parentsnapshot, tokenname, dec, tokensymbol, transfersenabled) public {}
541 }
542 /**
543  * @title ERC20 interface
544  * @dev see https://github.com/ethereum/EIPs/issues/20
545  */
546 contract ERC20 is ERC20Basic {
547     function allowance(address owner, address spender) public view returns(uint256);
548 
549     function transferFrom(address from, address to, uint256 value) public returns(bool);
550 
551     function approve(address spender, uint256 value) public returns(bool);
552     event Approval(address indexed owner, address indexed spender, uint256 value);
553 }
554 
555 /**
556  * @title Crowdsale
557  * @dev Crowdsale is a base contract for managing a token crowdsale,
558  * allowing investors to purchase tokens with ether. This contract implements
559  * such functionality in its most fundamental form and can be extended to provide additional
560  * functionality and/or custom behavior.
561  * The external interface represents the basic interface for purchasing tokens, and conform
562  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
563  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
564  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
565  * behavior.
566  */
567 
568 ////////////////
569 // MiniMeTokenFactory
570 ////////////////
571 /// @dev This contract is used to generate clone contracts from a contract.
572 ///  In solidity this is the way to create a contract from a contract of the
573 ///  same class
574 contract MiniMeTokenFactory {
575     /// @notice Update the DApp by creating a new token with new functionalities
576     ///  the msg.sender becomes the controller of this clone token
577     /// @param _parentToken Address of the token being cloned
578     /// @param _snapshotBlock Block of the parent token that will
579     ///  determine the initial distribution of the clone token
580     /// @param _tokenName Name of the new token
581     /// @param _decimalUnits Number of decimals of the new token
582     /// @param _tokenSymbol Token Symbol for the new token
583     /// @param _transfersEnabled If true, tokens will be able to be transferred
584     /// @return The address of the new token contract
585     function createCloneToken(
586         address _parentToken,
587         uint _snapshotBlock,
588         string _tokenName,
589         uint8 _decimalUnits,
590         string _tokenSymbol,
591         bool _transfersEnabled
592     ) public returns(MiniMeToken) {
593         MiniMeToken newToken = new MiniMeToken(
594             this,
595             _parentToken,
596             _snapshotBlock,
597             _tokenName,
598             _decimalUnits,
599             _tokenSymbol,
600             _transfersEnabled
601         );
602         newToken.changeController(msg.sender);
603         return newToken;
604     }
605 }
606 
607 contract Crowdsale is Pausable {
608     using SafeMath
609     for uint256;
610     // The token being sold
611     MiniMeToken public token;
612     // Address where funds are collected
613     address public wallet;
614     // How many token units a buyer gets per wei
615     uint256 public rate = 6120;
616     // Amount of tokens sold
617     uint256 public tokensSold;
618     uint256 public allCrowdSaleTokens = 255000000000000000000000000; //255M tokens available for crowdsale
619     /**
620      * Event for token purchase logging
621      * @param purchaser who paid for the tokens
622      * @param beneficiary who got the tokens
623      * @param value weis paid for purchase
624      * @param amount amount of tokens purchased
625      */
626     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
627     event buyx(address buyer, address contractAddr, uint256 amount);
628     constructor(address _wallet, MiniMeToken _token) public {
629         require(_wallet != address(0));
630         require(_token != address(0));
631         wallet = _wallet;
632         token = _token;
633     }
634 
635     function setCrowdsale(address _wallet, MiniMeToken _token) internal {
636         require(_wallet != address(0));
637         require(_token != address(0));
638         wallet = _wallet;
639         token = _token;
640     }
641     // -----------------------------------------
642     // Crowdsale external interface
643     // -----------------------------------------
644     /**
645      *  fallback function ***DO NOT OVERRIDE***
646      */
647     function() external whenNotPaused payable {
648         emit buyx(msg.sender, this, _getTokenAmount(msg.value));
649         buyTokens(msg.sender);
650     }
651     /**
652      * @dev low level token purchase ***DO NOT OVERRIDE***
653      * @param _beneficiary Address performing the token purchase
654      */
655     function buyTokens(address _beneficiary) public whenNotPaused payable {
656         if ((msg.value >= 500000000000000000000) && (msg.value < 1000000000000000000000)) {
657             rate = 7140;
658         } else if (msg.value >= 1000000000000000000000) {
659             rate = 7650;
660         } else if (tokensSold <= 21420000000000000000000000) {
661 
662             rate = 6120;
663         } else if ((tokensSold > 21420000000000000000000000) && (tokensSold <= 42304500000000000000000000)) {
664 
665             rate = 5967;
666         } else if ((tokensSold > 42304500000000000000000000) && (tokensSold <= 73095750000000000000000000)) {
667 
668             rate = 5865;
669         } else if ((tokensSold > 73095750000000000000000000) && (tokensSold <= 112365750000000000000000000)) {
670 
671             rate = 5610;
672         } else if ((tokensSold > 112365750000000000000000000) && (tokensSold <= 159222000000000000000000000)) {
673 
674             rate = 5355;
675         } else if (tokensSold > 159222000000000000000000000) {
676 
677             rate = 5100;
678         }
679         uint256 weiAmount = msg.value;
680         uint256 tokens = _getTokenAmount(weiAmount);
681         _processPurchase(_beneficiary, tokens);
682         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
683         _updatePurchasingState(_beneficiary, weiAmount);
684         _forwardFunds();
685         _postValidatePurchase(_beneficiary, weiAmount);
686         tokensSold = allCrowdSaleTokens.sub(token.balanceOf(this));
687     }
688     // -----------------------------------------
689     // Internal interface (extensible)
690     // -----------------------------------------
691     /**
692      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
693      * @param _beneficiary Address performing the token purchase
694      * @param _weiAmount Value in wei involved in the purchase
695      */
696     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
697         require(_beneficiary != address(0));
698         require(_weiAmount != 0);
699     }
700     /**
701      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
702      * @param _beneficiary Address performing the token purchase
703      * @param _weiAmount Value in wei involved in the purchase
704      */
705     function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
706         // optional override
707     }
708     /**
709      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
710      * @param _beneficiary Address performing the token purchase
711      * @param _tokenAmount Number of tokens to be emitted
712      */
713     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
714         token.transfer(_beneficiary, _tokenAmount);
715     }
716     /**
717      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
718      * @param _beneficiary Address receiving the tokens
719      * @param _tokenAmount Number of tokens to be purchased
720      */
721     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
722         _deliverTokens(_beneficiary, _tokenAmount);
723     }
724     /**
725      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
726      * @param _beneficiary Address receiving the tokens
727      * @param _weiAmount Value in wei involved in the purchase
728      */
729     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
730         // optional override
731     }
732     /**
733      * @dev Override to extend the way in which ether is converted to tokens.
734      * @param _weiAmount Value in wei to be converted into tokens
735      * @return Number of tokens that can be purchased with the specified _weiAmount
736      */
737     function _getTokenAmount(uint256 _weiAmount) internal returns(uint256) {
738 
739         return _weiAmount.mul(rate);
740     }
741     /**
742      * @dev Determines how ETH is stored/forwarded on purchases.
743      */
744     function _forwardFunds() internal {
745         wallet.transfer(msg.value);
746     }
747 }
748 contract EmaCrowdSale is Crowdsale {
749     using SafeMath
750     for uint256;
751     constructor(address wallet, MiniMeToken token) Crowdsale(wallet, token) public {
752         setCrowdsale(wallet, token);
753     }
754 
755     function tranferPresaleTokens(address investor, uint256 ammount) public onlyOwner {
756         tokensSold = tokensSold.add(ammount);
757         token.transferFrom(this, investor, ammount);
758     }
759 
760     function setTokenTransferState(bool state) public onlyOwner {
761         token.changeController(this);
762         token.enableTransfers(state);
763     }
764 
765     function claim(address claimToken) public onlyOwner {
766         token.changeController(this);
767         token.claimTokens(claimToken);
768     }
769 
770     function() external payable whenNotPaused {
771         emit buyx(msg.sender, this, _getTokenAmount(msg.value));
772         buyTokens(msg.sender);
773     }
774 }