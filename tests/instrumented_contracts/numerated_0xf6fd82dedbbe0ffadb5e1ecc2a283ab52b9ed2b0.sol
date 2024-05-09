1 pragma solidity ^0.4.17;
2 
3 /// @title MiniMeToken Contract
4 /// @author Jordi Baylina
5 /// @dev This token contract's goal is to make it easy for anyone to clone this
6 ///  token using the token distribution at a given block, this will allow DAO's
7 ///  and DApps to upgrade their features in a decentralized manner without
8 ///  affecting the original token
9 /// @dev It is ERC20 compliant, but still needs to under go further testing.
10 
11 contract Controlled {
12     /// @notice The address of the controller is the only address that can call
13     ///  a function with this modifier
14     modifier onlyController { require(msg.sender == controller); _; }
15 
16     address public controller;
17 
18     function Controlled() public { controller = msg.sender;}
19 
20     /// @notice Changes the controller of the contract
21     /// @param _newController The new controller of the contract
22     function changeController(address _newController) public onlyController {
23         controller = _newController;
24     }
25 }
26 /**
27  * @title ERC20
28  * @dev ERC20 interface
29  */
30 contract ERC20 {
31     function balanceOf(address who) public view returns (uint256);
32     function transfer(address to, uint256 value) public returns (bool);
33     function allowance(address owner, address spender) public view returns (uint256);
34     function transferFrom(address from, address to, uint256 value) public returns (bool);
35     function approve(address spender, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 /**
41  * @title MiniMe interface
42  * @dev see https://github.com/ethereum/EIPs/issues/20
43  */
44 contract ERC20MiniMe is ERC20, Controlled {
45     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool);
46     function totalSupply() public view returns (uint);
47     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint);
48     function totalSupplyAt(uint _blockNumber) public view returns(uint);
49     function createCloneToken(string _cloneTokenName, uint8 _cloneDecimalUnits, string _cloneTokenSymbol, uint _snapshotBlock, bool _transfersEnabled) public returns(address);
50     function generateTokens(address _owner, uint _amount) public returns (bool);
51     function destroyTokens(address _owner, uint _amount)  public returns (bool);
52     function enableTransfers(bool _transfersEnabled) public;
53     function isContract(address _addr) internal view returns(bool);
54     function claimTokens(address _token) public;
55     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
56     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
57 }
58 
59 /// @dev The token controller contract must implement these functions
60 contract TokenController {
61     ERC20MiniMe public ethealToken;
62     address public SALE; // address where sale tokens are located
63 
64     /// @notice needed for hodler handling
65     function addHodlerStake(address _beneficiary, uint _stake) public;
66     function setHodlerStake(address _beneficiary, uint256 _stake) public;
67     function setHodlerTime(uint256 _time) public;
68 
69 
70     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
71     /// @param _owner The address that sent the ether to create tokens
72     /// @return True if the ether is accepted, false if it throws
73     function proxyPayment(address _owner) public payable returns(bool);
74 
75     /// @notice Notifies the controller about a token transfer allowing the
76     ///  controller to react if desired
77     /// @param _from The origin of the transfer
78     /// @param _to The destination of the transfer
79     /// @param _amount The amount of the transfer
80     /// @return False if the controller does not authorize the transfer
81     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
82 
83     /// @notice Notifies the controller about an approval allowing the
84     ///  controller to react if desired
85     /// @param _owner The address that calls `approve()`
86     /// @param _spender The spender in the `approve()` call
87     /// @param _amount The amount in the `approve()` call
88     /// @return False if the controller does not authorize the approval
89     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
90 }
91 
92 contract ApproveAndCallFallBack {
93     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
94 }
95 
96 /// @dev The actual token contract, the default controller is the msg.sender
97 ///  that deploys the contract, so usually this token will be deployed by a
98 ///  token controller contract, which Giveth will call a "Campaign"
99 contract MiniMeToken is Controlled {
100 
101     string public name;                //The Token's name: e.g. DigixDAO Tokens
102     uint8 public decimals;             //Number of decimals of the smallest unit
103     string public symbol;              //An identifier: e.g. REP
104     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
105 
106 
107     /// @dev `Checkpoint` is the structure that attaches a block number to a
108     ///  given value, the block number attached is the one that last changed the
109     ///  value
110     struct Checkpoint {
111 
112         // `fromBlock` is the block number that the value was generated from
113         uint128 fromBlock;
114 
115         // `value` is the amount of tokens at a specific block number
116         uint128 value;
117     }
118 
119     // `parentToken` is the Token address that was cloned to produce this token;
120     //  it will be 0x0 for a token that was not cloned
121     MiniMeToken public parentToken;
122 
123     // `parentSnapShotBlock` is the block number from the Parent Token that was
124     //  used to determine the initial distribution of the Clone Token
125     uint public parentSnapShotBlock;
126 
127     // `creationBlock` is the block number that the Clone Token was created
128     uint public creationBlock;
129 
130     // `balances` is the map that tracks the balance of each address, in this
131     //  contract when the balance changes the block number that the change
132     //  occurred is also included in the map
133     mapping (address => Checkpoint[]) balances;
134 
135     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
136     mapping (address => mapping (address => uint256)) allowed;
137 
138     // Tracks the history of the `totalSupply` of the token
139     Checkpoint[] totalSupplyHistory;
140 
141     // Flag that determines if the token is transferable or not.
142     bool public transfersEnabled;
143 
144     // The factory used to create new clone tokens
145     MiniMeTokenFactory public tokenFactory;
146 
147 ////////////////
148 // Constructor
149 ////////////////
150 
151     /// @notice Constructor to create a MiniMeToken
152     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
153     ///  will create the Clone token contracts, the token factory needs to be
154     ///  deployed first
155     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
156     ///  new token
157     /// @param _parentSnapShotBlock Block of the parent token that will
158     ///  determine the initial distribution of the clone token, set to 0 if it
159     ///  is a new token
160     /// @param _tokenName Name of the new token
161     /// @param _decimalUnits Number of decimals of the new token
162     /// @param _tokenSymbol Token Symbol for the new token
163     /// @param _transfersEnabled If true, tokens will be able to be transferred
164     function MiniMeToken(
165         address _tokenFactory,
166         address _parentToken,
167         uint _parentSnapShotBlock,
168         string _tokenName,
169         uint8 _decimalUnits,
170         string _tokenSymbol,
171         bool _transfersEnabled
172     ) public {
173         tokenFactory = MiniMeTokenFactory(_tokenFactory);
174         name = _tokenName;                                 // Set the name
175         decimals = _decimalUnits;                          // Set the decimals
176         symbol = _tokenSymbol;                             // Set the symbol
177         parentToken = MiniMeToken(_parentToken);
178         parentSnapShotBlock = _parentSnapShotBlock;
179         transfersEnabled = _transfersEnabled;
180         creationBlock = block.number;
181     }
182 
183 
184 ///////////////////
185 // ERC20 Methods
186 ///////////////////
187 
188     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
189     /// @param _to The address of the recipient
190     /// @param _amount The amount of tokens to be transferred
191     /// @return Whether the transfer was successful or not
192     function transfer(address _to, uint256 _amount) public returns (bool success) {
193         require(transfersEnabled);
194         return doTransfer(msg.sender, _to, _amount);
195     }
196 
197     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
198     ///  is approved by `_from`
199     /// @param _from The address holding the tokens being transferred
200     /// @param _to The address of the recipient
201     /// @param _amount The amount of tokens to be transferred
202     /// @return True if the transfer was successful
203     function transferFrom(address _from, address _to, uint256 _amount
204     ) public returns (bool success) {
205 
206         // The controller of this contract can move tokens around at will,
207         //  this is important to recognize! Confirm that you trust the
208         //  controller of this contract, which in most situations should be
209         //  another open source smart contract or 0x0
210         if (msg.sender != controller) {
211             require(transfersEnabled);
212 
213             // The standard ERC 20 transferFrom functionality
214             if (allowed[_from][msg.sender] < _amount) return false;
215             allowed[_from][msg.sender] -= _amount;
216         }
217         return doTransfer(_from, _to, _amount);
218     }
219 
220     /// @dev This is the actual transfer function in the token contract, it can
221     ///  only be called by other functions in this contract.
222     /// @param _from The address holding the tokens being transferred
223     /// @param _to The address of the recipient
224     /// @param _amount The amount of tokens to be transferred
225     /// @return True if the transfer was successful
226     function doTransfer(address _from, address _to, uint _amount
227     ) internal returns(bool) {
228 
229            if (_amount == 0) {
230                return true;
231            }
232 
233            require(parentSnapShotBlock < block.number);
234 
235            // Do not allow transfer to 0x0 or the token contract itself
236            require((_to != 0) && (_to != address(this)));
237 
238            // If the amount being transfered is more than the balance of the
239            //  account the transfer returns false
240            var previousBalanceFrom = balanceOfAt(_from, block.number);
241            if (previousBalanceFrom < _amount) {
242                return false;
243            }
244 
245            // Alerts the token controller of the transfer
246            if (isContract(controller)) {
247                require(TokenController(controller).onTransfer(_from, _to, _amount));
248            }
249 
250            // First update the balance array with the new value for the address
251            //  sending the tokens
252            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
253 
254            // Then update the balance array with the new value for the address
255            //  receiving the tokens
256            var previousBalanceTo = balanceOfAt(_to, block.number);
257            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
258            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
259 
260            // An event to make the transfer easy to find on the blockchain
261            Transfer(_from, _to, _amount);
262 
263            return true;
264     }
265 
266     /// @param _owner The address that's balance is being requested
267     /// @return The balance of `_owner` at the current block
268     function balanceOf(address _owner) public view returns (uint256 balance) {
269         return balanceOfAt(_owner, block.number);
270     }
271 
272     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
273     ///  its behalf. This is a modified version of the ERC20 approve function
274     ///  to be a little bit safer
275     /// @param _spender The address of the account able to transfer the tokens
276     /// @param _amount The amount of tokens to be approved for transfer
277     /// @return True if the approval was successful
278     function approve(address _spender, uint256 _amount) public returns (bool success) {
279         require(transfersEnabled);
280 
281         // To change the approve amount you first have to reduce the addresses`
282         //  allowance to zero by calling `approve(_spender,0)` if it is not
283         //  already 0 to mitigate the race condition described here:
284         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
285         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
286 
287         // Alerts the token controller of the approve function call
288         if (isContract(controller)) {
289             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
290         }
291 
292         allowed[msg.sender][_spender] = _amount;
293         Approval(msg.sender, _spender, _amount);
294         return true;
295     }
296 
297     /// @dev This function makes it easy to read the `allowed[]` map
298     /// @param _owner The address of the account that owns the token
299     /// @param _spender The address of the account able to transfer the tokens
300     /// @return Amount of remaining tokens of _owner that _spender is allowed
301     ///  to spend
302     function allowance(address _owner, address _spender
303     ) public view returns (uint256 remaining) {
304         return allowed[_owner][_spender];
305     }
306 
307     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
308     ///  its behalf, and then a function is triggered in the contract that is
309     ///  being approved, `_spender`. This allows users to use their tokens to
310     ///  interact with contracts in one function call instead of two
311     /// @param _spender The address of the contract able to transfer the tokens
312     /// @param _amount The amount of tokens to be approved for transfer
313     /// @return True if the function call was successful
314     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
315     ) public returns (bool success) {
316         require(approve(_spender, _amount));
317 
318         ApproveAndCallFallBack(_spender).receiveApproval(
319             msg.sender,
320             _amount,
321             this,
322             _extraData
323         );
324 
325         return true;
326     }
327 
328     /// @dev This function makes it easy to get the total number of tokens
329     /// @return The total number of tokens
330     function totalSupply() public view returns (uint) {
331         return totalSupplyAt(block.number);
332     }
333 
334 
335 ////////////////
336 // Query balance and totalSupply in History
337 ////////////////
338 
339     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
340     /// @param _owner The address from which the balance will be retrieved
341     /// @param _blockNumber The block number when the balance is queried
342     /// @return The balance at `_blockNumber`
343     function balanceOfAt(address _owner, uint _blockNumber) public view
344         returns (uint) {
345 
346         // These next few lines are used when the balance of the token is
347         //  requested before a check point was ever created for this token, it
348         //  requires that the `parentToken.balanceOfAt` be queried at the
349         //  genesis block for that token as this contains initial balance of
350         //  this token
351         if ((balances[_owner].length == 0)
352             || (balances[_owner][0].fromBlock > _blockNumber)) {
353             if (address(parentToken) != 0) {
354                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
355             } else {
356                 // Has no parent
357                 return 0;
358             }
359 
360         // This will return the expected balance during normal situations
361         } else {
362             return getValueAt(balances[_owner], _blockNumber);
363         }
364     }
365 
366     /// @notice Total amount of tokens at a specific `_blockNumber`.
367     /// @param _blockNumber The block number when the totalSupply is queried
368     /// @return The total amount of tokens at `_blockNumber`
369     function totalSupplyAt(uint _blockNumber) public view returns(uint) {
370 
371         // These next few lines are used when the totalSupply of the token is
372         //  requested before a check point was ever created for this token, it
373         //  requires that the `parentToken.totalSupplyAt` be queried at the
374         //  genesis block for this token as that contains totalSupply of this
375         //  token at this block number.
376         if ((totalSupplyHistory.length == 0)
377             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
378             if (address(parentToken) != 0) {
379                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
380             } else {
381                 return 0;
382             }
383 
384         // This will return the expected totalSupply during normal situations
385         } else {
386             return getValueAt(totalSupplyHistory, _blockNumber);
387         }
388     }
389 
390 ////////////////
391 // Clone Token Method
392 ////////////////
393 
394     /// @notice Creates a new clone token with the initial distribution being
395     ///  this token at `_snapshotBlock`
396     /// @param _cloneTokenName Name of the clone token
397     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
398     /// @param _cloneTokenSymbol Symbol of the clone token
399     /// @param _snapshotBlock Block when the distribution of the parent token is
400     ///  copied to set the initial distribution of the new clone token;
401     ///  if the block is zero than the actual block, the current block is used
402     /// @param _transfersEnabled True if transfers are allowed in the clone
403     /// @return The address of the new MiniMeToken Contract
404     function createCloneToken(
405         string _cloneTokenName,
406         uint8 _cloneDecimalUnits,
407         string _cloneTokenSymbol,
408         uint _snapshotBlock,
409         bool _transfersEnabled
410     ) public returns(address) {
411         if (_snapshotBlock == 0) _snapshotBlock = block.number;
412         MiniMeToken cloneToken = tokenFactory.createCloneToken(
413             this,
414             _snapshotBlock,
415             _cloneTokenName,
416             _cloneDecimalUnits,
417             _cloneTokenSymbol,
418             _transfersEnabled
419             );
420 
421         cloneToken.changeController(msg.sender);
422 
423         // An event to make the token easy to find on the blockchain
424         NewCloneToken(address(cloneToken), _snapshotBlock);
425         return address(cloneToken);
426     }
427 
428 ////////////////
429 // Generate and destroy tokens
430 ////////////////
431 
432     /// @notice Generates `_amount` tokens that are assigned to `_owner`
433     /// @param _owner The address that will be assigned the new tokens
434     /// @param _amount The quantity of tokens generated
435     /// @return True if the tokens are generated correctly
436     function generateTokens(address _owner, uint _amount
437     ) public onlyController returns (bool) {
438         uint curTotalSupply = totalSupply();
439         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
440         uint previousBalanceTo = balanceOf(_owner);
441         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
442         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
443         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
444         Transfer(0, _owner, _amount);
445         return true;
446     }
447 
448 
449     /// @notice Burns `_amount` tokens from `_owner`
450     /// @param _owner The address that will lose the tokens
451     /// @param _amount The quantity of tokens to burn
452     /// @return True if the tokens are burned correctly
453     function destroyTokens(address _owner, uint _amount
454     ) onlyController public returns (bool) {
455         uint curTotalSupply = totalSupply();
456         require(curTotalSupply >= _amount);
457         uint previousBalanceFrom = balanceOf(_owner);
458         require(previousBalanceFrom >= _amount);
459         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
460         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
461         Transfer(_owner, 0, _amount);
462         return true;
463     }
464 
465 ////////////////
466 // Enable tokens transfers
467 ////////////////
468 
469 
470     /// @notice Enables token holders to transfer their tokens freely if true
471     /// @param _transfersEnabled True if transfers are allowed in the clone
472     function enableTransfers(bool _transfersEnabled) public onlyController {
473         transfersEnabled = _transfersEnabled;
474     }
475 
476 ////////////////
477 // Internal helper functions to query and set a value in a snapshot array
478 ////////////////
479 
480     /// @dev `getValueAt` retrieves the number of tokens at a given block number
481     /// @param checkpoints The history of values being queried
482     /// @param _block The block number to retrieve the value at
483     /// @return The number of tokens being queried
484     function getValueAt(Checkpoint[] storage checkpoints, uint _block
485     ) internal view returns (uint) {
486         if (checkpoints.length == 0) return 0;
487 
488         // Shortcut for the actual value
489         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
490             return checkpoints[checkpoints.length-1].value;
491         if (_block < checkpoints[0].fromBlock) return 0;
492 
493         // Binary search of the value in the array
494         uint min = 0;
495         uint max = checkpoints.length-1;
496         while (max > min) {
497             uint mid = (max + min + 1)/ 2;
498             if (checkpoints[mid].fromBlock<=_block) {
499                 min = mid;
500             } else {
501                 max = mid-1;
502             }
503         }
504         return checkpoints[min].value;
505     }
506 
507     /// @dev `updateValueAtNow` used to update the `balances` map and the
508     ///  `totalSupplyHistory`
509     /// @param checkpoints The history of data being updated
510     /// @param _value The new number of tokens
511     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
512     ) internal  {
513         if ((checkpoints.length == 0)
514         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
515                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
516                newCheckPoint.fromBlock =  uint128(block.number);
517                newCheckPoint.value = uint128(_value);
518            } else {
519                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
520                oldCheckPoint.value = uint128(_value);
521            }
522     }
523 
524     /// @dev Internal function to determine if an address is a contract
525     /// @param _addr The address being queried
526     /// @return True if `_addr` is a contract
527     function isContract(address _addr) internal view returns(bool) {
528         uint size;
529         if (_addr == 0) return false;
530         assembly {
531             size := extcodesize(_addr)
532         }
533         return size>0;
534     }
535 
536     /// @dev Helper function to return a min betwen the two uints
537     function min(uint a, uint b) pure internal returns (uint) {
538         return a < b ? a : b;
539     }
540 
541     /// @notice The fallback function: If the contract's controller has not been
542     ///  set to 0, then the `proxyPayment` method is called which relays the
543     ///  ether and creates tokens as described in the token controller contract
544     function () public payable {
545         require(isContract(controller));
546         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
547     }
548 
549 //////////
550 // Safety Methods
551 //////////
552 
553     /// @notice This method can be used by the controller to extract mistakenly
554     ///  sent tokens to this contract.
555     /// @param _token The address of the token contract that you want to recover
556     ///  set to 0 in case you want to extract ether.
557     function claimTokens(address _token) public onlyController {
558         if (_token == 0x0) {
559             controller.transfer(this.balance);
560             return;
561         }
562 
563         MiniMeToken token = MiniMeToken(_token);
564         uint balance = token.balanceOf(this);
565         token.transfer(controller, balance);
566         ClaimedTokens(_token, controller, balance);
567     }
568 
569 ////////////////
570 // Events
571 ////////////////
572     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
573     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
574     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
575     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
576 
577 }
578 
579 
580 ////////////////
581 // MiniMeTokenFactory
582 ////////////////
583 
584 /// @dev This contract is used to generate clone contracts from a contract.
585 ///  In solidity this is the way to create a contract from a contract of the
586 ///  same class
587 contract MiniMeTokenFactory {
588 
589     /// @notice Update the DApp by creating a new token with new functionalities
590     ///  the msg.sender becomes the controller of this clone token
591     /// @param _parentToken Address of the token being cloned
592     /// @param _snapshotBlock Block of the parent token that will
593     ///  determine the initial distribution of the clone token
594     /// @param _tokenName Name of the new token
595     /// @param _decimalUnits Number of decimals of the new token
596     /// @param _tokenSymbol Token Symbol for the new token
597     /// @param _transfersEnabled If true, tokens will be able to be transferred
598     /// @return The address of the new token contract
599     function createCloneToken(
600         address _parentToken,
601         uint _snapshotBlock,
602         string _tokenName,
603         uint8 _decimalUnits,
604         string _tokenSymbol,
605         bool _transfersEnabled
606     ) public returns (MiniMeToken) {
607         MiniMeToken newToken = new MiniMeToken(
608             this,
609             _parentToken,
610             _snapshotBlock,
611             _tokenName,
612             _decimalUnits,
613             _tokenSymbol,
614             _transfersEnabled
615             );
616 
617         newToken.changeController(msg.sender);
618         return newToken;
619     }
620 }
621 
622 /**
623  * @title EthealToken
624  * @dev Basic MiniMe token
625  */
626 contract EthealToken is MiniMeToken {
627     function EthealToken(address _controller, address _tokenFactory) 
628         MiniMeToken(
629             _tokenFactory,
630             0x0,                // no parent token
631             0,                  // no snapshot block number from parent
632             "Etheal Token",     // Token name
633             18,                 // Decimals
634             "HEAL",             // Symbol
635             true                // Enable transfers
636         )
637     {
638         changeController(_controller);
639     }
640 }