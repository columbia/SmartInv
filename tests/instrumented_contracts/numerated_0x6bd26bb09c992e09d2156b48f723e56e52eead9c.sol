1 pragma solidity ^0.4.17;
2 
3 
4 /// @title MiniMeToken Contract
5 /// @author Jordi Baylina
6 /// @dev This token contract's goal is to make it easy for anyone to clone this
7 ///  token using the token distribution at a given block, this will allow DAO's
8 ///  and DApps to upgrade their features in a decentralized manner without
9 ///  affecting the original token
10 /// @dev It is ERC20 compliant, but still needs to under go further testing.
11 
12 contract Controlled {
13     /// @notice The address of the controller is the only address that can call
14     ///  a function with this modifier
15     modifier onlyController { require(msg.sender == controller); _; }
16 
17     address public controller;
18 
19     function Controlled() public { controller = msg.sender;}
20 
21     /// @notice Changes the controller of the contract
22     /// @param _newController The new controller of the contract
23     function changeController(address _newController) public onlyController {
24         controller = _newController;
25     }
26 }
27 /**
28  * @title ERC20
29  * @dev ERC20 interface
30  */
31 contract ERC20 {
32     function balanceOf(address who) public view returns (uint256);
33     function transfer(address to, uint256 value) public returns (bool);
34     function allowance(address owner, address spender) public view returns (uint256);
35     function transferFrom(address from, address to, uint256 value) public returns (bool);
36     function approve(address spender, uint256 value) public returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 /**
42  * @title MiniMe interface
43  * @dev see https://github.com/ethereum/EIPs/issues/20
44  */
45 contract ERC20MiniMe is ERC20, Controlled {
46     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool);
47     function totalSupply() public view returns (uint);
48     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint);
49     function totalSupplyAt(uint _blockNumber) public view returns(uint);
50     function createCloneToken(string _cloneTokenName, uint8 _cloneDecimalUnits, string _cloneTokenSymbol, uint _snapshotBlock, bool _transfersEnabled) public returns(address);
51     function generateTokens(address _owner, uint _amount) public returns (bool);
52     function destroyTokens(address _owner, uint _amount)  public returns (bool);
53     function enableTransfers(bool _transfersEnabled) public;
54     function isContract(address _addr) internal view returns(bool);
55     function claimTokens(address _token) public;
56     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
57     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
58 }
59 
60 /// @dev The token controller contract must implement these functions
61 contract TokenController {
62     ERC20MiniMe public ethealToken;
63     address public SALE; // address where sale tokens are located
64 
65     /// @notice needed for hodler handling
66     function addHodlerStake(address _beneficiary, uint _stake) public;
67     function setHodlerStake(address _beneficiary, uint256 _stake) public;
68     function setHodlerTime(uint256 _time) public;
69 
70 
71     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
72     /// @param _owner The address that sent the ether to create tokens
73     /// @return True if the ether is accepted, false if it throws
74     function proxyPayment(address _owner) public payable returns(bool);
75 
76     /// @notice Notifies the controller about a token transfer allowing the
77     ///  controller to react if desired
78     /// @param _from The origin of the transfer
79     /// @param _to The destination of the transfer
80     /// @param _amount The amount of the transfer
81     /// @return False if the controller does not authorize the transfer
82     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
83 
84     /// @notice Notifies the controller about an approval allowing the
85     ///  controller to react if desired
86     /// @param _owner The address that calls `approve()`
87     /// @param _spender The spender in the `approve()` call
88     /// @param _amount The amount in the `approve()` call
89     /// @return False if the controller does not authorize the approval
90     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
91 }
92 
93 contract ApproveAndCallFallBack {
94     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
95 }
96 
97 /// @dev The actual token contract, the default controller is the msg.sender
98 ///  that deploys the contract, so usually this token will be deployed by a
99 ///  token controller contract, which Giveth will call a "Campaign"
100 contract MiniMeToken is Controlled {
101 
102     string public name;                //The Token's name: e.g. DigixDAO Tokens
103     uint8 public decimals;             //Number of decimals of the smallest unit
104     string public symbol;              //An identifier: e.g. REP
105     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
106 
107 
108     /// @dev `Checkpoint` is the structure that attaches a block number to a
109     ///  given value, the block number attached is the one that last changed the
110     ///  value
111     struct  Checkpoint {
112 
113         // `fromBlock` is the block number that the value was generated from
114         uint128 fromBlock;
115 
116         // `value` is the amount of tokens at a specific block number
117         uint128 value;
118     }
119 
120     // `parentToken` is the Token address that was cloned to produce this token;
121     //  it will be 0x0 for a token that was not cloned
122     MiniMeToken public parentToken;
123 
124     // `parentSnapShotBlock` is the block number from the Parent Token that was
125     //  used to determine the initial distribution of the Clone Token
126     uint public parentSnapShotBlock;
127 
128     // `creationBlock` is the block number that the Clone Token was created
129     uint public creationBlock;
130 
131     // `balances` is the map that tracks the balance of each address, in this
132     //  contract when the balance changes the block number that the change
133     //  occurred is also included in the map
134     mapping (address => Checkpoint[]) balances;
135 
136     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
137     mapping (address => mapping (address => uint256)) allowed;
138 
139     // Tracks the history of the `totalSupply` of the token
140     Checkpoint[] totalSupplyHistory;
141 
142     // Flag that determines if the token is transferable or not.
143     bool public transfersEnabled;
144 
145     // The factory used to create new clone tokens
146     MiniMeTokenFactory public tokenFactory;
147 
148 ////////////////
149 // Constructor
150 ////////////////
151 
152     /// @notice Constructor to create a MiniMeToken
153     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
154     ///  will create the Clone token contracts, the token factory needs to be
155     ///  deployed first
156     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
157     ///  new token
158     /// @param _parentSnapShotBlock Block of the parent token that will
159     ///  determine the initial distribution of the clone token, set to 0 if it
160     ///  is a new token
161     /// @param _tokenName Name of the new token
162     /// @param _decimalUnits Number of decimals of the new token
163     /// @param _tokenSymbol Token Symbol for the new token
164     /// @param _transfersEnabled If true, tokens will be able to be transferred
165     function MiniMeToken(
166         address _tokenFactory,
167         address _parentToken,
168         uint _parentSnapShotBlock,
169         string _tokenName,
170         uint8 _decimalUnits,
171         string _tokenSymbol,
172         bool _transfersEnabled
173     ) public {
174         tokenFactory = MiniMeTokenFactory(_tokenFactory);
175         name = _tokenName;                                 // Set the name
176         decimals = _decimalUnits;                          // Set the decimals
177         symbol = _tokenSymbol;                             // Set the symbol
178         parentToken = MiniMeToken(_parentToken);
179         parentSnapShotBlock = _parentSnapShotBlock;
180         transfersEnabled = _transfersEnabled;
181         creationBlock = block.number;
182     }
183 
184 
185 ///////////////////
186 // ERC20 Methods
187 ///////////////////
188 
189     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
190     /// @param _to The address of the recipient
191     /// @param _amount The amount of tokens to be transferred
192     /// @return Whether the transfer was successful or not
193     function transfer(address _to, uint256 _amount) public returns (bool success) {
194         require(transfersEnabled);
195         doTransfer(msg.sender, _to, _amount);
196         return true;
197     }
198 
199     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
200     ///  is approved by `_from`
201     /// @param _from The address holding the tokens being transferred
202     /// @param _to The address of the recipient
203     /// @param _amount The amount of tokens to be transferred
204     /// @return True if the transfer was successful
205     function transferFrom(address _from, address _to, uint256 _amount
206     ) public returns (bool success) {
207 
208         // The controller of this contract can move tokens around at will,
209         //  this is important to recognize! Confirm that you trust the
210         //  controller of this contract, which in most situations should be
211         //  another open source smart contract or 0x0
212         if (msg.sender != controller) {
213             require(transfersEnabled);
214 
215             // The standard ERC 20 transferFrom functionality
216             require(allowed[_from][msg.sender] >= _amount);
217             allowed[_from][msg.sender] -= _amount;
218         }
219         doTransfer(_from, _to, _amount);
220         return true;
221     }
222 
223     /// @dev This is the actual transfer function in the token contract, it can
224     ///  only be called by other functions in this contract.
225     /// @param _from The address holding the tokens being transferred
226     /// @param _to The address of the recipient
227     /// @param _amount The amount of tokens to be transferred
228     /// @return True if the transfer was successful
229     function doTransfer(address _from, address _to, uint _amount
230     ) internal {
231 
232            if (_amount == 0) {
233                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
234                return;
235            }
236 
237            require(parentSnapShotBlock < block.number);
238 
239            // Do not allow transfer to 0x0 or the token contract itself
240            require((_to != 0) && (_to != address(this)));
241 
242            // Alerts the token controller of the transfer
243            if (isContract(controller)) {
244                require(TokenController(controller).onTransfer(_from, _to, _amount));
245            }
246 
247            // If the amount being transfered is more than the balance of the
248            //  account the transfer throws
249            var previousBalanceFrom = balanceOfAt(_from, block.number);
250 
251            require(previousBalanceFrom >= _amount);
252 
253            // First update the balance array with the new value for the address
254            //  sending the tokens
255            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
256 
257            // Then update the balance array with the new value for the address
258            //  receiving the tokens
259            var previousBalanceTo = balanceOfAt(_to, block.number);
260            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
261            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
262 
263            // An event to make the transfer easy to find on the blockchain
264            Transfer(_from, _to, _amount);
265 
266     }
267 
268     /// @param _owner The address that's balance is being requested
269     /// @return The balance of `_owner` at the current block
270     function balanceOf(address _owner) public constant returns (uint256 balance) {
271         return balanceOfAt(_owner, block.number);
272     }
273 
274     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
275     ///  its behalf. This is a modified version of the ERC20 approve function
276     ///  to be a little bit safer
277     /// @param _spender The address of the account able to transfer the tokens
278     /// @param _amount The amount of tokens to be approved for transfer
279     /// @return True if the approval was successful
280     function approve(address _spender, uint256 _amount) public returns (bool success) {
281         require(transfersEnabled);
282 
283         // To change the approve amount you first have to reduce the addresses`
284         //  allowance to zero by calling `approve(_spender,0)` if it is not
285         //  already 0 to mitigate the race condition described here:
286         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
287         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
288 
289         // Alerts the token controller of the approve function call
290         if (isContract(controller)) {
291             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
292         }
293 
294         allowed[msg.sender][_spender] = _amount;
295         Approval(msg.sender, _spender, _amount);
296         return true;
297     }
298 
299     /// @dev This function makes it easy to read the `allowed[]` map
300     /// @param _owner The address of the account that owns the token
301     /// @param _spender The address of the account able to transfer the tokens
302     /// @return Amount of remaining tokens of _owner that _spender is allowed
303     ///  to spend
304     function allowance(address _owner, address _spender
305     ) public constant returns (uint256 remaining) {
306         return allowed[_owner][_spender];
307     }
308 
309     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
310     ///  its behalf, and then a function is triggered in the contract that is
311     ///  being approved, `_spender`. This allows users to use their tokens to
312     ///  interact with contracts in one function call instead of two
313     /// @param _spender The address of the contract able to transfer the tokens
314     /// @param _amount The amount of tokens to be approved for transfer
315     /// @return True if the function call was successful
316     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
317     ) public returns (bool success) {
318         require(approve(_spender, _amount));
319 
320         ApproveAndCallFallBack(_spender).receiveApproval(
321             msg.sender,
322             _amount,
323             this,
324             _extraData
325         );
326 
327         return true;
328     }
329 
330     /// @dev This function makes it easy to get the total number of tokens
331     /// @return The total number of tokens
332     function totalSupply() public constant returns (uint) {
333         return totalSupplyAt(block.number);
334     }
335 
336 
337 ////////////////
338 // Query balance and totalSupply in History
339 ////////////////
340 
341     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
342     /// @param _owner The address from which the balance will be retrieved
343     /// @param _blockNumber The block number when the balance is queried
344     /// @return The balance at `_blockNumber`
345     function balanceOfAt(address _owner, uint _blockNumber) public constant
346         returns (uint) {
347 
348         // These next few lines are used when the balance of the token is
349         //  requested before a check point was ever created for this token, it
350         //  requires that the `parentToken.balanceOfAt` be queried at the
351         //  genesis block for that token as this contains initial balance of
352         //  this token
353         if ((balances[_owner].length == 0)
354             || (balances[_owner][0].fromBlock > _blockNumber)) {
355             if (address(parentToken) != 0) {
356                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
357             } else {
358                 // Has no parent
359                 return 0;
360             }
361 
362         // This will return the expected balance during normal situations
363         } else {
364             return getValueAt(balances[_owner], _blockNumber);
365         }
366     }
367 
368     /// @notice Total amount of tokens at a specific `_blockNumber`.
369     /// @param _blockNumber The block number when the totalSupply is queried
370     /// @return The total amount of tokens at `_blockNumber`
371     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
372 
373         // These next few lines are used when the totalSupply of the token is
374         //  requested before a check point was ever created for this token, it
375         //  requires that the `parentToken.totalSupplyAt` be queried at the
376         //  genesis block for this token as that contains totalSupply of this
377         //  token at this block number.
378         if ((totalSupplyHistory.length == 0)
379             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
380             if (address(parentToken) != 0) {
381                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
382             } else {
383                 return 0;
384             }
385 
386         // This will return the expected totalSupply during normal situations
387         } else {
388             return getValueAt(totalSupplyHistory, _blockNumber);
389         }
390     }
391 
392 ////////////////
393 // Clone Token Method
394 ////////////////
395 
396     /// @notice Creates a new clone token with the initial distribution being
397     ///  this token at `_snapshotBlock`
398     /// @param _cloneTokenName Name of the clone token
399     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
400     /// @param _cloneTokenSymbol Symbol of the clone token
401     /// @param _snapshotBlock Block when the distribution of the parent token is
402     ///  copied to set the initial distribution of the new clone token;
403     ///  if the block is zero than the actual block, the current block is used
404     /// @param _transfersEnabled True if transfers are allowed in the clone
405     /// @return The address of the new MiniMeToken Contract
406     function createCloneToken(
407         string _cloneTokenName,
408         uint8 _cloneDecimalUnits,
409         string _cloneTokenSymbol,
410         uint _snapshotBlock,
411         bool _transfersEnabled
412         ) public returns(address) {
413         if (_snapshotBlock == 0) _snapshotBlock = block.number;
414         MiniMeToken cloneToken = tokenFactory.createCloneToken(
415             this,
416             _snapshotBlock,
417             _cloneTokenName,
418             _cloneDecimalUnits,
419             _cloneTokenSymbol,
420             _transfersEnabled
421             );
422 
423         cloneToken.changeController(msg.sender);
424 
425         // An event to make the token easy to find on the blockchain
426         NewCloneToken(address(cloneToken), _snapshotBlock);
427         return address(cloneToken);
428     }
429 
430 ////////////////
431 // Generate and destroy tokens
432 ////////////////
433 
434     /// @notice Generates `_amount` tokens that are assigned to `_owner`
435     /// @param _owner The address that will be assigned the new tokens
436     /// @param _amount The quantity of tokens generated
437     /// @return True if the tokens are generated correctly
438     function generateTokens(address _owner, uint _amount
439     ) public onlyController returns (bool) {
440         uint curTotalSupply = totalSupply();
441         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
442         uint previousBalanceTo = balanceOf(_owner);
443         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
444         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
445         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
446         Transfer(0, _owner, _amount);
447         return true;
448     }
449 
450 
451     /// @notice Burns `_amount` tokens from `_owner`
452     /// @param _owner The address that will lose the tokens
453     /// @param _amount The quantity of tokens to burn
454     /// @return True if the tokens are burned correctly
455     function destroyTokens(address _owner, uint _amount
456     ) onlyController public returns (bool) {
457         uint curTotalSupply = totalSupply();
458         require(curTotalSupply >= _amount);
459         uint previousBalanceFrom = balanceOf(_owner);
460         require(previousBalanceFrom >= _amount);
461         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
462         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
463         Transfer(_owner, 0, _amount);
464         return true;
465     }
466 
467 ////////////////
468 // Enable tokens transfers
469 ////////////////
470 
471 
472     /// @notice Enables token holders to transfer their tokens freely if true
473     /// @param _transfersEnabled True if transfers are allowed in the clone
474     function enableTransfers(bool _transfersEnabled) public onlyController {
475         transfersEnabled = _transfersEnabled;
476     }
477 
478 ////////////////
479 // Internal helper functions to query and set a value in a snapshot array
480 ////////////////
481 
482     /// @dev `getValueAt` retrieves the number of tokens at a given block number
483     /// @param checkpoints The history of values being queried
484     /// @param _block The block number to retrieve the value at
485     /// @return The number of tokens being queried
486     function getValueAt(Checkpoint[] storage checkpoints, uint _block
487     ) constant internal returns (uint) {
488         if (checkpoints.length == 0) return 0;
489 
490         // Shortcut for the actual value
491         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
492             return checkpoints[checkpoints.length-1].value;
493         if (_block < checkpoints[0].fromBlock) return 0;
494 
495         // Binary search of the value in the array
496         uint min = 0;
497         uint max = checkpoints.length-1;
498         while (max > min) {
499             uint mid = (max + min + 1)/ 2;
500             if (checkpoints[mid].fromBlock<=_block) {
501                 min = mid;
502             } else {
503                 max = mid-1;
504             }
505         }
506         return checkpoints[min].value;
507     }
508 
509     /// @dev `updateValueAtNow` used to update the `balances` map and the
510     ///  `totalSupplyHistory`
511     /// @param checkpoints The history of data being updated
512     /// @param _value The new number of tokens
513     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
514     ) internal  {
515         if ((checkpoints.length == 0)
516         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
517                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
518                newCheckPoint.fromBlock =  uint128(block.number);
519                newCheckPoint.value = uint128(_value);
520            } else {
521                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
522                oldCheckPoint.value = uint128(_value);
523            }
524     }
525 
526     /// @dev Internal function to determine if an address is a contract
527     /// @param _addr The address being queried
528     /// @return True if `_addr` is a contract
529     function isContract(address _addr) constant internal returns(bool) {
530         uint size;
531         if (_addr == 0) return false;
532         assembly {
533             size := extcodesize(_addr)
534         }
535         return size>0;
536     }
537 
538     /// @dev Helper function to return a min betwen the two uints
539     function min(uint a, uint b) pure internal returns (uint) {
540         return a < b ? a : b;
541     }
542 
543     /// @notice The fallback function: If the contract's controller has not been
544     ///  set to 0, then the `proxyPayment` method is called which relays the
545     ///  ether and creates tokens as described in the token controller contract
546     function () public payable {
547         require(isContract(controller));
548         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
549     }
550 
551 //////////
552 // Safety Methods
553 //////////
554 
555     /// @notice This method can be used by the controller to extract mistakenly
556     ///  sent tokens to this contract.
557     /// @param _token The address of the token contract that you want to recover
558     ///  set to 0 in case you want to extract ether.
559     function claimTokens(address _token) public onlyController {
560         if (_token == 0x0) {
561             controller.transfer(this.balance);
562             return;
563         }
564 
565         MiniMeToken token = MiniMeToken(_token);
566         uint balance = token.balanceOf(this);
567         token.transfer(controller, balance);
568         ClaimedTokens(_token, controller, balance);
569     }
570 
571 ////////////////
572 // Events
573 ////////////////
574     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
575     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
576     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
577     event Approval(
578         address indexed _owner,
579         address indexed _spender,
580         uint256 _amount
581         );
582 
583 }
584 
585 
586 ////////////////
587 // MiniMeTokenFactory
588 ////////////////
589 
590 /// @dev This contract is used to generate clone contracts from a contract.
591 ///  In solidity this is the way to create a contract from a contract of the
592 ///  same class
593 contract MiniMeTokenFactory {
594 
595     /// @notice Update the DApp by creating a new token with new functionalities
596     ///  the msg.sender becomes the controller of this clone token
597     /// @param _parentToken Address of the token being cloned
598     /// @param _snapshotBlock Block of the parent token that will
599     ///  determine the initial distribution of the clone token
600     /// @param _tokenName Name of the new token
601     /// @param _decimalUnits Number of decimals of the new token
602     /// @param _tokenSymbol Token Symbol for the new token
603     /// @param _transfersEnabled If true, tokens will be able to be transferred
604     /// @return The address of the new token contract
605     function createCloneToken(
606         address _parentToken,
607         uint _snapshotBlock,
608         string _tokenName,
609         uint8 _decimalUnits,
610         string _tokenSymbol,
611         bool _transfersEnabled
612     ) public returns (MiniMeToken) {
613         MiniMeToken newToken = new MiniMeToken(
614             this,
615             _parentToken,
616             _snapshotBlock,
617             _tokenName,
618             _decimalUnits,
619             _tokenSymbol,
620             _transfersEnabled
621             );
622 
623         newToken.changeController(msg.sender);
624         return newToken;
625     }
626 }
627 
628 
629 /**
630  * @title EthealToken
631  * @dev Basic MiniMe token
632  */
633 contract EthealTokenV2 is MiniMeToken {
634     function EthealTokenV2(address _tokenFactory, address _parentToken, uint _parentSnapShotBlock, bool _transfersEnabled) 
635         MiniMeToken(
636             _tokenFactory,
637             _parentToken,                // no parent token
638             _parentSnapShotBlock,        // no snapshot block number from parent
639             "Etheal Token",     // Token name
640             18,                 // Decimals
641             "HEAL",             // Symbol
642             _transfersEnabled   // Enable transfers
643         )
644     {
645 
646     }
647 }