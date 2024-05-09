1 pragma solidity 0.4.24;
2 
3 contract Controlled {
4     /// @notice The address of the controller is the only address that can call
5     ///  a function with this modifier
6     modifier onlyController { require(msg.sender == controller); _; }
7 
8     address public controller;
9 
10     function Controlled() public { controller = msg.sender;}
11 
12     /// @notice Changes the controller of the contract
13     /// @param _newController The new controller of the contract
14     function changeController(address _newController) public onlyController {
15         controller = _newController;
16     }
17 }
18 
19 contract TokenController {
20     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
21     /// @param _owner The address that sent the ether to create tokens
22     /// @return True if the ether is accepted, false if it throws
23     function proxyPayment(address _owner) public payable returns(bool);
24 
25     /// @notice Notifies the controller about a token transfer allowing the
26     ///  controller to react if desired
27     /// @param _from The origin of the transfer
28     /// @param _to The destination of the transfer
29     /// @param _amount The amount of the transfer
30     /// @return False if the controller does not authorize the transfer
31     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
32 
33     /// @notice Notifies the controller about an approval allowing the
34     ///  controller to react if desired
35     /// @param _owner The address that calls `approve()`
36     /// @param _spender The spender in the `approve()` call
37     /// @param _amount The amount in the `approve()` call
38     /// @return False if the controller does not authorize the approval
39     function onApprove(address _owner, address _spender, uint _amount) public
40         returns(bool);
41 
42     /// @notice Notifies the controller about a token burn
43     /// @param _owner The address of the burner
44     /// @param _amount The amount to burn
45     /// @return False if the controller does not authorize the burn
46     function onBurn(address _owner, uint _amount) public returns(bool);
47 }
48 /*
49     Copyright 2017, Will Harborne (Ethfinex)
50 */
51 contract ApproveAndCallFallBack {
52     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
53 }
54 
55 /// @dev The actual token contract, the default controller is the msg.sender
56 ///  that deploys the contract, so usually this token will be deployed by a
57 ///  token controller contract, which Giveth will call a "Campaign"
58 /// @dev The actual token contract, the default controller is the msg.sender
59 ///  that deploys the contract, so usually this token will be deployed by a
60 ///  token controller contract, which Giveth will call a "Campaign"
61 contract MiniMeToken is Controlled {
62 
63     string public name;                //The Token's name: e.g. DigixDAO Tokens
64     uint8 public decimals;             //Number of decimals of the smallest unit
65     string public symbol;              //An identifier: e.g. REP
66     string public version = 'EFX_0.1'; //An arbitrary versioning scheme
67 
68 
69     /// @dev `Checkpoint` is the structure that attaches a block number to a
70     ///  given value, the block number attached is the one that last changed the
71     ///  value
72     struct  Checkpoint {
73 
74         // `fromBlock` is the block number that the value was generated from
75         uint128 fromBlock;
76 
77         // `value` is the amount of tokens at a specific block number
78         uint128 value;
79     }
80 
81     // `parentToken` is the Token address that was cloned to produce this token;
82     //  it will be 0x0 for a token that was not cloned
83     MiniMeToken public parentToken;
84 
85     // `parentSnapShotBlock` is the block number from the Parent Token that was
86     //  used to determine the initial distribution of the Clone Token
87     uint public parentSnapShotBlock;
88 
89     // `creationBlock` is the block number that the Clone Token was created
90     uint public creationBlock;
91 
92     // `balances` is the map that tracks the balance of each address, in this
93     //  contract when the balance changes the block number that the change
94     //  occurred is also included in the map
95     mapping (address => Checkpoint[]) balances;
96 
97     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
98     mapping (address => mapping (address => uint256)) allowed;
99 
100     // Tracks the history of the `totalSupply` of the token
101     Checkpoint[] totalSupplyHistory;
102 
103     // Flag that determines if the token is transferable or not.
104     bool public transfersEnabled;
105 
106     // Tracks the history of the `pledgedFees` belonging to token holders
107     Checkpoint[] totalPledgedFeesHistory; // in wei
108 
109     // The factory used to create new clone tokens
110     MiniMeTokenFactory public tokenFactory;
111 
112 ////////////////
113 // Constructor
114 ////////////////
115 
116     /// @notice Constructor to create a MiniMeToken
117     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
118     ///  will create the Clone token contracts, the token factory needs to be
119     ///  deployed first
120     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
121     ///  new token
122     /// @param _parentSnapShotBlock Block of the parent token that will
123     ///  determine the initial distribution of the clone token, set to 0 if it
124     ///  is a new token
125     /// @param _tokenName Name of the new token
126     /// @param _decimalUnits Number of decimals of the new token
127     /// @param _tokenSymbol Token Symbol for the new token
128     /// @param _transfersEnabled If true, tokens will be able to be transferred
129     function MiniMeToken(
130         address _tokenFactory,
131         address _parentToken,
132         uint _parentSnapShotBlock,
133         string _tokenName,
134         uint8 _decimalUnits,
135         string _tokenSymbol,
136         bool _transfersEnabled
137     ) public {
138         tokenFactory = MiniMeTokenFactory(_tokenFactory);
139         name = _tokenName;                                 // Set the name
140         decimals = _decimalUnits;                          // Set the decimals
141         symbol = _tokenSymbol;                             // Set the symbol
142         parentToken = MiniMeToken(_parentToken);
143         parentSnapShotBlock = _parentSnapShotBlock;
144         transfersEnabled = _transfersEnabled;
145         creationBlock = block.number;
146     }
147 
148 
149 ///////////////////
150 // ERC20 Methods
151 ///////////////////
152 
153     uint constant MAX_UINT = 2**256 - 1;
154 
155     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
156     /// @param _to The address of the recipient
157     /// @param _amount The amount of tokens to be transferred
158     /// @return Whether the transfer was successful or not
159     function transfer(address _to, uint256 _amount) public returns (bool success) {
160         require(transfersEnabled);
161         doTransfer(msg.sender, _to, _amount);
162         return true;
163     }
164 
165     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
166     ///  is approved by `_from`
167     /// @param _from The address holding the tokens being transferred
168     /// @param _to The address of the recipient
169     /// @param _amount The amount of tokens to be transferred
170     /// @return True if the transfer was successful
171     function transferFrom(address _from, address _to, uint256 _amount
172     ) public returns (bool success) {
173 
174         // The controller of this contract can move tokens around at will,
175         //  this is important to recognize! Confirm that you trust the
176         //  controller of this contract, which in most situations should be
177         //  another open source smart contract or 0x0
178         if (msg.sender != controller) {
179             require(transfersEnabled);
180 
181             // The standard ERC 20 transferFrom functionality
182             if (allowed[_from][msg.sender] < MAX_UINT) {
183                 require(allowed[_from][msg.sender] >= _amount);
184                 allowed[_from][msg.sender] -= _amount;
185             }
186         }
187         doTransfer(_from, _to, _amount);
188         return true;
189     }
190 
191     /// @dev This is the actual transfer function in the token contract, it can
192     ///  only be called by other functions in this contract.
193     /// @param _from The address holding the tokens being transferred
194     /// @param _to The address of the recipient
195     /// @param _amount The amount of tokens to be transferred
196     /// @return True if the transfer was successful
197     function doTransfer(address _from, address _to, uint _amount
198     ) internal {
199 
200            if (_amount == 0) {
201                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
202                return;
203            }
204 
205            require(parentSnapShotBlock < block.number);
206 
207            // Do not allow transfer to 0x0 or the token contract itself
208            require((_to != 0) && (_to != address(this)));
209 
210            // If the amount being transfered is more than the balance of the
211            //  account the transfer throws
212            var previousBalanceFrom = balanceOfAt(_from, block.number);
213 
214            require(previousBalanceFrom >= _amount);
215 
216            // Alerts the token controller of the transfer
217            if (isContract(controller)) {
218                require(TokenController(controller).onTransfer(_from, _to, _amount));
219            }
220 
221            // First update the balance array with the new value for the address
222            //  sending the tokens
223            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
224 
225            // Then update the balance array with the new value for the address
226            //  receiving the tokens
227            var previousBalanceTo = balanceOfAt(_to, block.number);
228            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
229            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
230 
231            // An event to make the transfer easy to find on the blockchain
232            Transfer(_from, _to, _amount);
233 
234     }
235 
236     /// @param _owner The address that's balance is being requested
237     /// @return The balance of `_owner` at the current block
238     function balanceOf(address _owner) public constant returns (uint256 balance) {
239         return balanceOfAt(_owner, block.number);
240     }
241 
242     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
243     ///  its behalf. This is a modified version of the ERC20 approve function
244     ///  to be a little bit safer
245     /// @param _spender The address of the account able to transfer the tokens
246     /// @param _amount The amount of tokens to be approved for transfer
247     /// @return True if the approval was successful
248     function approve(address _spender, uint256 _amount) public returns (bool success) {
249         require(transfersEnabled);
250 
251         // To change the approve amount you first have to reduce the addresses`
252         //  allowance to zero by calling `approve(_spender,0)` if it is not
253         //  already 0 to mitigate the race condition described here:
254         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
256 
257         // Alerts the token controller of the approve function call
258         if (isContract(controller)) {
259             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
260         }
261 
262         allowed[msg.sender][_spender] = _amount;
263         Approval(msg.sender, _spender, _amount);
264         return true;
265     }
266 
267     /// @dev This function makes it easy to read the `allowed[]` map
268     /// @param _owner The address of the account that owns the token
269     /// @param _spender The address of the account able to transfer the tokens
270     /// @return Amount of remaining tokens of _owner that _spender is allowed
271     ///  to spend
272     function allowance(address _owner, address _spender
273     ) public constant returns (uint256 remaining) {
274         return allowed[_owner][_spender];
275     }
276 
277     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
278     ///  its behalf, and then a function is triggered in the contract that is
279     ///  being approved, `_spender`. This allows users to use their tokens to
280     ///  interact with contracts in one function call instead of two
281     /// @param _spender The address of the contract able to transfer the tokens
282     /// @param _amount The amount of tokens to be approved for transfer
283     /// @return True if the function call was successful
284     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
285     ) public returns (bool success) {
286         require(approve(_spender, _amount));
287 
288         ApproveAndCallFallBack(_spender).receiveApproval(
289             msg.sender,
290             _amount,
291             this,
292             _extraData
293         );
294 
295         return true;
296     }
297 
298     /// @dev This function makes it easy to get the total number of tokens
299     /// @return The total number of tokens
300     function totalSupply() public constant returns (uint) {
301         return totalSupplyAt(block.number);
302     }
303 
304 
305 ////////////////
306 // Query balance and totalSupply in History
307 ////////////////
308 
309     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
310     /// @param _owner The address from which the balance will be retrieved
311     /// @param _blockNumber The block number when the balance is queried
312     /// @return The balance at `_blockNumber`
313     function balanceOfAt(address _owner, uint _blockNumber) public constant
314         returns (uint) {
315 
316         // These next few lines are used when the balance of the token is
317         //  requested before a check point was ever created for this token, it
318         //  requires that the `parentToken.balanceOfAt` be queried at the
319         //  genesis block for that token as this contains initial balance of
320         //  this token
321         if ((balances[_owner].length == 0)
322             || (balances[_owner][0].fromBlock > _blockNumber)) {
323             if (address(parentToken) != 0) {
324                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
325             } else {
326                 // Has no parent
327                 return 0;
328             }
329 
330         // This will return the expected balance during normal situations
331         } else {
332             return getValueAt(balances[_owner], _blockNumber);
333         }
334     }
335 
336     /// @notice Total amount of tokens at a specific `_blockNumber`.
337     /// @param _blockNumber The block number when the totalSupply is queried
338     /// @return The total amount of tokens at `_blockNumber`
339     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
340 
341         // These next few lines are used when the totalSupply of the token is
342         //  requested before a check point was ever created for this token, it
343         //  requires that the `parentToken.totalSupplyAt` be queried at the
344         //  genesis block for this token as that contains totalSupply of this
345         //  token at this block number.
346         if ((totalSupplyHistory.length == 0)
347             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
348             if (address(parentToken) != 0) {
349                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
350             } else {
351                 return 0;
352             }
353 
354         // This will return the expected totalSupply during normal situations
355         } else {
356             return getValueAt(totalSupplyHistory, _blockNumber);
357         }
358     }
359 
360 ////////////////
361 // Query pledgedFees // in wei
362 ////////////////
363 
364    /// @dev This function makes it easy to get the total pledged fees
365    /// @return The total number of fees belonging to token holders
366    function totalPledgedFees() public constant returns (uint) {
367        return totalPledgedFeesAt(block.number);
368    }
369 
370    /// @notice Total amount of fees at a specific `_blockNumber`.
371    /// @param _blockNumber The block number when the totalPledgedFees is queried
372    /// @return The total amount of pledged fees at `_blockNumber`
373    function totalPledgedFeesAt(uint _blockNumber) public constant returns(uint) {
374 
375        // These next few lines are used when the totalPledgedFees of the token is
376        //  requested before a check point was ever created for this token, it
377        //  requires that the `parentToken.totalPledgedFeesAt` be queried at the
378        //  genesis block for this token as that contains totalPledgedFees of this
379        //  token at this block number.
380        if ((totalPledgedFeesHistory.length == 0)
381            || (totalPledgedFeesHistory[0].fromBlock > _blockNumber)) {
382            if (address(parentToken) != 0) {
383                return parentToken.totalPledgedFeesAt(min(_blockNumber, parentSnapShotBlock));
384            } else {
385                return 0;
386            }
387 
388        // This will return the expected totalPledgedFees during normal situations
389        } else {
390            return getValueAt(totalPledgedFeesHistory, _blockNumber);
391        }
392    }
393 
394 ////////////////
395 // Pledge Fees To Token Holders or Reduce Pledged Fees // in wei
396 ////////////////
397 
398    /// @notice Pledges fees to the token holders, later to be claimed by burning
399    /// @param _value The amount sent to the vault by controller, reserved for token holders
400    function pledgeFees(uint _value) public onlyController returns (bool) {
401        uint curTotalFees = totalPledgedFees();
402        require(curTotalFees + _value >= curTotalFees); // Check for overflow
403        updateValueAtNow(totalPledgedFeesHistory, curTotalFees + _value);
404        return true;
405    }
406 
407    /// @notice Reduces pledged fees to the token holders, i.e. during upgrade or token burning
408    /// @param _value The amount of pledged fees which are being distributed to token holders, reducing liability
409    function reducePledgedFees(uint _value) public onlyController returns (bool) {
410        uint curTotalFees = totalPledgedFees();
411        require(curTotalFees >= _value);
412        updateValueAtNow(totalPledgedFeesHistory, curTotalFees - _value);
413        return true;
414    }
415 
416 ////////////////
417 // Clone Token Method
418 ////////////////
419 
420     /// @notice Creates a new clone token with the initial distribution being
421     ///  this token at `_snapshotBlock`
422     /// @param _cloneTokenName Name of the clone token
423     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
424     /// @param _cloneTokenSymbol Symbol of the clone token
425     /// @param _snapshotBlock Block when the distribution of the parent token is
426     ///  copied to set the initial distribution of the new clone token;
427     ///  if the block is zero than the actual block, the current block is used
428     /// @param _transfersEnabled True if transfers are allowed in the clone
429     /// @return The address of the new MiniMeToken Contract
430     function createCloneToken(
431         string _cloneTokenName,
432         uint8 _cloneDecimalUnits,
433         string _cloneTokenSymbol,
434         uint _snapshotBlock,
435         bool _transfersEnabled
436         ) public returns(address) {
437         if (_snapshotBlock == 0) _snapshotBlock = block.number;
438         MiniMeToken cloneToken = tokenFactory.createCloneToken(
439             this,
440             _snapshotBlock,
441             _cloneTokenName,
442             _cloneDecimalUnits,
443             _cloneTokenSymbol,
444             _transfersEnabled
445             );
446 
447         cloneToken.changeController(msg.sender);
448 
449         // An event to make the token easy to find on the blockchain
450         NewCloneToken(address(cloneToken), _snapshotBlock);
451         return address(cloneToken);
452     }
453 
454 ////////////////
455 // Generate and destroy tokens
456 ////////////////
457 
458     /// @notice Generates `_amount` tokens that are assigned to `_owner`
459     /// @param _owner The address that will be assigned the new tokens
460     /// @param _amount The quantity of tokens generated
461     /// @return True if the tokens are generated correctly
462     function generateTokens(address _owner, uint _amount
463     ) public onlyController returns (bool) {
464         uint curTotalSupply = totalSupply();
465         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
466         uint previousBalanceTo = balanceOf(_owner);
467         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
468         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
469         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
470         Transfer(0, _owner, _amount);
471         return true;
472     }
473 
474 
475     /// @notice Burns `_amount` tokens from `_owner`
476     /// @param _owner The address that will lose the tokens
477     /// @param _amount The quantity of tokens to burn
478     /// @return True if the tokens are burned correctly
479     function destroyTokens(address _owner, uint _amount
480     ) onlyController public returns (bool) {
481         uint curTotalSupply = totalSupply();
482         require(curTotalSupply >= _amount);
483         uint previousBalanceFrom = balanceOf(_owner);
484         require(previousBalanceFrom >= _amount);
485         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
486         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
487         Transfer(_owner, 0, _amount);
488         return true;
489     }
490 
491 ////////////////
492 // Enable tokens transfers
493 ////////////////
494 
495 
496     /// @notice Enables token holders to transfer their tokens freely if true
497     /// @param _transfersEnabled True if transfers are allowed in the clone
498     function enableTransfers(bool _transfersEnabled) public onlyController {
499         transfersEnabled = _transfersEnabled;
500     }
501 
502 ////////////////
503 // Internal helper functions to query and set a value in a snapshot array
504 ////////////////
505 
506     /// @dev `getValueAt` retrieves the number of tokens at a given block number
507     /// @param checkpoints The history of values being queried
508     /// @param _block The block number to retrieve the value at
509     /// @return The number of tokens being queried
510     function getValueAt(Checkpoint[] storage checkpoints, uint _block
511     ) constant internal returns (uint) {
512         if (checkpoints.length == 0) return 0;
513 
514         // Shortcut for the actual value
515         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
516             return checkpoints[checkpoints.length-1].value;
517         if (_block < checkpoints[0].fromBlock) return 0;
518 
519         // Binary search of the value in the array
520         uint min = 0;
521         uint max = checkpoints.length-1;
522         while (max > min) {
523             uint mid = (max + min + 1)/ 2;
524             if (checkpoints[mid].fromBlock<=_block) {
525                 min = mid;
526             } else {
527                 max = mid-1;
528             }
529         }
530         return checkpoints[min].value;
531     }
532 
533     /// @dev `updateValueAtNow` used to update the `balances` map and the
534     ///  `totalSupplyHistory`
535     /// @param checkpoints The history of data being updated
536     /// @param _value The new number of tokens
537     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
538     ) internal  {
539         if ((checkpoints.length == 0)
540         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
541                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
542                newCheckPoint.fromBlock =  uint128(block.number);
543                newCheckPoint.value = uint128(_value);
544            } else {
545                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
546                oldCheckPoint.value = uint128(_value);
547            }
548     }
549 
550     /// @dev Internal function to determine if an address is a contract
551     /// @param _addr The address being queried
552     /// @return True if `_addr` is a contract
553     function isContract(address _addr) constant internal returns(bool) {
554         uint size;
555         if (_addr == 0) return false;
556         assembly {
557             size := extcodesize(_addr)
558         }
559         return size>0;
560     }
561 
562     /// @dev Helper function to return a min betwen the two uints
563     function min(uint a, uint b) pure internal returns (uint) {
564         return a < b ? a : b;
565     }
566 
567     /// @notice The fallback function: If the contract's controller has not been
568     ///  set to 0, then the `proxyPayment` method is called which relays the
569     ///  ether and creates tokens as described in the token controller contract
570     function () public payable {
571         require(isContract(controller));
572         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
573     }
574 
575 //////////
576 // Safety Methods
577 //////////
578 
579     /// @notice This method can be used by the controller to extract mistakenly
580     ///  sent tokens to this contract.
581     /// @param _token The address of the token contract that you want to recover
582     ///  set to 0 in case you want to extract ether.
583     function claimTokens(address _token) public onlyController {
584         if (_token == 0x0) {
585             controller.transfer(this.balance);
586             return;
587         }
588 
589         MiniMeToken token = MiniMeToken(_token);
590         uint balance = token.balanceOf(this);
591         token.transfer(controller, balance);
592         ClaimedTokens(_token, controller, balance);
593     }
594 
595 ////////////////
596 // Events
597 ////////////////
598     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
599     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
600     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
601     event Approval(
602         address indexed _owner,
603         address indexed _spender,
604         uint256 _amount
605         );
606 
607 }
608 
609 
610 ////////////////
611 // MiniMeTokenFactory
612 ////////////////
613 
614 /// @dev This contract is used to generate clone contracts from a contract.
615 ///  In solidity this is the way to create a contract from a contract of the
616 ///  same class
617 contract MiniMeTokenFactory {
618 
619     /// @notice Update the DApp by creating a new token with new functionalities
620     ///  the msg.sender becomes the controller of this clone token
621     /// @param _parentToken Address of the token being cloned
622     /// @param _snapshotBlock Block of the parent token that will
623     ///  determine the initial distribution of the clone token
624     /// @param _tokenName Name of the new token
625     /// @param _decimalUnits Number of decimals of the new token
626     /// @param _tokenSymbol Token Symbol for the new token
627     /// @param _transfersEnabled If true, tokens will be able to be transferred
628     /// @return The address of the new token contract
629     function createCloneToken(
630         address _parentToken,
631         uint _snapshotBlock,
632         string _tokenName,
633         uint8 _decimalUnits,
634         string _tokenSymbol,
635         bool _transfersEnabled
636     ) public returns (MiniMeToken) {
637         MiniMeToken newToken = new MiniMeToken(
638             this,
639             _parentToken,
640             _snapshotBlock,
641             _tokenName,
642             _decimalUnits,
643             _tokenSymbol,
644             _transfersEnabled
645             );
646 
647         newToken.changeController(msg.sender);
648         return newToken;
649     }
650 }
651 
652 contract DestructibleMiniMeToken is MiniMeToken {
653 
654     address public terminator;
655 
656     constructor(
657         address _tokenFactory,
658         address _parentToken,
659         uint _parentSnapShotBlock,
660         string _tokenName,
661         uint8 _decimalUnits,
662         string _tokenSymbol,
663         bool _transfersEnabled,
664         address _terminator
665     ) public MiniMeToken(
666         _tokenFactory,
667         _parentToken,
668         _parentSnapShotBlock,
669         _tokenName,
670         _decimalUnits,
671         _tokenSymbol,
672         _transfersEnabled
673     ) {
674         terminator = _terminator;
675     }
676 
677     function recycle() public {
678         require(msg.sender == terminator);
679         selfdestruct(terminator);
680     }
681 }
682 
683 contract DestructibleMiniMeTokenFactory {
684 
685     /// @notice Update the DApp by creating a new token with new functionalities
686     ///  the msg.sender becomes the controller of this clone token
687     /// @param _parentToken Address of the token being cloned
688     /// @param _snapshotBlock Block of the parent token that will
689     ///  determine the initial distribution of the clone token
690     /// @param _tokenName Name of the new token
691     /// @param _decimalUnits Number of decimals of the new token
692     /// @param _tokenSymbol Token Symbol for the new token
693     /// @param _transfersEnabled If true, tokens will be able to be transferred
694     /// @return The address of the new token contract
695     function createDestructibleCloneToken(
696         address _parentToken,
697         uint _snapshotBlock,
698         string _tokenName,
699         uint8 _decimalUnits,
700         string _tokenSymbol,
701         bool _transfersEnabled
702     ) public returns (DestructibleMiniMeToken) {
703         DestructibleMiniMeToken newToken = new DestructibleMiniMeToken(
704             this,
705             _parentToken,
706             _snapshotBlock,
707             _tokenName,
708             _decimalUnits,
709             _tokenSymbol,
710             _transfersEnabled,
711             msg.sender
712         );
713 
714         newToken.changeController(msg.sender);
715         return newToken;
716     }
717 }
718 
719 contract Ownable {
720   
721   address public owner;
722 
723   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
724 
725   function Ownable() public {
726     owner = msg.sender;
727   }
728 
729   modifier onlyOwner() {
730     require(msg.sender == owner);
731     _;
732   }
733 
734   function transferOwnership(address newOwner) public onlyOwner {
735     require(newOwner != address(0));
736     emit OwnershipTransferred(owner, newOwner);
737     owner = newOwner;
738   }
739 
740 }
741 
742 /*
743     Copyright 2018, Will Harborne @ Ethfinex
744 */
745 
746 /// @title ProposalManager Contract
747 /// @author Will Harborne @ Ethfinex
748 contract TokenListingManagerAdvanced is Ownable {
749 
750     address public constant NECTAR_TOKEN = 0xCc80C051057B774cD75067Dc48f8987C4Eb97A5e;
751     address public constant TOKEN_FACTORY = 0x6EB97237B8bc26E8057793200207bB0a2A83C347;
752     uint public constant MAX_CANDIDATES = 50;
753 
754     struct TokenProposal {
755         uint startBlock;
756         uint startTime;
757         uint duration;
758         address votingToken;
759         // criteria values
760         // 0. only first one win the vote;
761         // 1. top N (number in extraData) win the vote;
762         // 2. All over N (number in extra data) votes win the vote;
763         uint criteria;
764         uint extraData;
765     }
766 
767     struct Delegate {
768         address user;
769         bytes32 storageHash;
770         bool exists;
771     }
772 
773     TokenProposal[] public tokenBatches;
774     Delegate[] public allDelegates;
775     mapping(address => uint) addressToDelegate;
776 
777     uint[] public yesVotes;
778     address[] public consideredTokens;
779 
780     DestructibleMiniMeTokenFactory public tokenFactory;
781     address public nectarToken;
782     mapping(address => bool) public admins;
783     mapping(address => bool) public isWinner;
784     mapping(address => bool) public tokenExists;
785     mapping(address => uint) public lastVote;
786 
787     mapping(address => address[]) public myVotes;
788     mapping(address => address) public myDelegate;
789     mapping(address => bool) public isDelegate;
790 
791     mapping(uint => mapping(address => uint256)) public votesSpentThisRound;
792 
793     modifier onlyAdmins() {
794         require(isAdmin(msg.sender));
795         _;
796     }
797 
798     constructor(address _tokenFactory, address _nectarToken) public {
799         tokenFactory = DestructibleMiniMeTokenFactory(_tokenFactory);
800         nectarToken = _nectarToken;
801         admins[msg.sender] = true;
802         isDelegate[address(0)] = true;
803     }
804 
805     /// @notice Admins are able to approve proposal that someone submitted
806     /// @param _tokens the list of tokens in consideration during this period
807     /// @param _duration number of days for voting
808     /// @param _criteria number that determines how winner is selected
809     /// @param _extraData extra data for criteria parameter
810     /// @param _previousWinners addresses that won previous proposal
811     function startTokenVotes(address[] _tokens, uint _duration, uint _criteria, uint _extraData, address[] _previousWinners) public onlyAdmins {
812         require(_tokens.length <= MAX_CANDIDATES);
813 
814         for (uint i=0; i < _previousWinners.length; i++) {
815             isWinner[_previousWinners[i]] = true;
816         }
817 
818         if (_criteria == 1) {
819             // in other case all tokens would be winners
820             require(_extraData < consideredTokens.length);
821         }
822 
823         uint _proposalId = tokenBatches.length;
824         if (_proposalId > 0) {
825             TokenProposal memory op = tokenBatches[_proposalId - 1];
826             DestructibleMiniMeToken(op.votingToken).recycle();
827         }
828         tokenBatches.length++;
829         TokenProposal storage p = tokenBatches[_proposalId];
830         p.duration = _duration * (1 days);
831 
832         for (i = 0; i < _tokens.length; i++) {
833             require(!tokenExists[_tokens[i]]);
834 
835             consideredTokens.push(_tokens[i]);
836             yesVotes.push(0);
837             lastVote[_tokens[i]] = _proposalId;
838             tokenExists[_tokens[i]] = true;
839         }
840 
841         p.votingToken = tokenFactory.createDestructibleCloneToken(
842                 nectarToken,
843                 getBlockNumber(),
844                 appendUintToString("EfxTokenVotes-", _proposalId),
845                 MiniMeToken(nectarToken).decimals(),
846                 appendUintToString("EVT-", _proposalId),
847                 true);
848 
849         p.startTime = now;
850         p.startBlock = getBlockNumber();
851         p.criteria = _criteria;
852         p.extraData = _extraData;
853 
854         emit NewTokens(_proposalId);
855     }
856 
857     /// @notice Vote for specific token with yes
858     /// @param _tokenIndex is the position from 0-9 in the token array of the chosen token
859     /// @param _amount number of votes you give for this token
860     function vote(uint _tokenIndex, uint _amount) public {
861         require(myDelegate[msg.sender] == address(0));
862         require(!isWinner[consideredTokens[_tokenIndex]]);
863 
864         // voting only on the most recent set of proposed tokens
865         require(tokenBatches.length > 0);
866         uint _proposalId = tokenBatches.length - 1;
867 
868         require(isActive(_proposalId));
869 
870         TokenProposal memory p = tokenBatches[_proposalId];
871 
872         if (lastVote[consideredTokens[_tokenIndex]] < _proposalId) {
873             // if voting for this token for first time in current proposal, we need to deduce votes
874             // we deduce number of yes votes for diff of current proposal and lastVote time multiplied by 2
875             yesVotes[_tokenIndex] /= 2*(_proposalId - lastVote[consideredTokens[_tokenIndex]]);
876             lastVote[consideredTokens[_tokenIndex]] = _proposalId;
877         }
878 
879         uint balance = DestructibleMiniMeToken(p.votingToken).balanceOf(msg.sender);
880 
881         // user is able to have someone in myVotes if he unregistered and some people didn't undelegated him after that
882         if (isDelegate[msg.sender]) {
883             for (uint i=0; i < myVotes[msg.sender].length; i++) {
884                 address user = myVotes[msg.sender][i];
885                 balance += DestructibleMiniMeToken(p.votingToken).balanceOf(user);
886             }
887         }
888 
889         require(_amount <= balance);
890         require(votesSpentThisRound[_proposalId][msg.sender] + _amount <= balance);
891 
892         yesVotes[_tokenIndex] += _amount;
893         // set the info that the user voted in this round
894         votesSpentThisRound[_proposalId][msg.sender] += _amount;
895 
896         emit Vote(_proposalId, msg.sender, consideredTokens[_tokenIndex], _amount);
897     }
898 
899     function unregisterAsDelegate() public {
900         require(isDelegate[msg.sender]);
901 
902         address lastDelegate = allDelegates[allDelegates.length - 1].user;
903         uint currDelegatePos = addressToDelegate[msg.sender];
904         // set last delegate to new pos
905         addressToDelegate[lastDelegate] = currDelegatePos;
906         allDelegates[currDelegatePos] = allDelegates[allDelegates.length - 1];
907 
908         // delete this delegate
909         delete allDelegates[allDelegates.length - 1];
910         allDelegates.length--;
911 
912         // set bool to false
913         isDelegate[msg.sender] = false;
914     }
915 
916     function registerAsDelegate(bytes32 _storageHash) public {
917         // can't register as delegate if already gave vote
918         require(!gaveVote(msg.sender));
919         // can't register as delegate if you have delegate (undelegate first)
920         require(myDelegate[msg.sender] == address(0));
921         // can't call this method if you are already delegate
922         require(!isDelegate[msg.sender]);
923 
924         isDelegate[msg.sender] = true;
925         allDelegates.push(Delegate({
926             user: msg.sender,
927             storageHash: _storageHash,
928             exists: true
929         }));
930 
931         addressToDelegate[msg.sender] = allDelegates.length-1;
932     }
933 
934     function undelegateVote() public {
935         // can't undelegate if I already gave vote in this round
936         require(!gaveVote(msg.sender));
937         // I must have delegate if I want to undelegate
938         require(myDelegate[msg.sender] != address(0));
939 
940         address delegate = myDelegate[msg.sender];
941 
942         for (uint i=0; i < myVotes[delegate].length; i++) {
943             if (myVotes[delegate][i] == msg.sender) {
944                 myVotes[delegate][i] = myVotes[delegate][myVotes[delegate].length-1];
945 
946                 delete myVotes[delegate][myVotes[delegate].length-1];
947                 myVotes[delegate].length--;
948 
949                 break;
950             }
951         }
952 
953         myDelegate[msg.sender] = address(0);
954     }
955 
956     /// @notice Delegate vote to other address
957     /// @param _to address who will be able to vote instead of you
958     function delegateVote(address _to) public {
959         // not possible to delegate if I already voted
960         require(!gaveVote(msg.sender));
961         // can't set delegate if I am delegate
962         require(!isDelegate[msg.sender]);
963         // I can only set delegate to someone who is registered delegate
964         require(isDelegate[_to]);
965         // I can't have delegate if I'm setting one (call undelegate first)
966         require(myDelegate[msg.sender] == address(0));
967 
968         myDelegate[msg.sender] = _to;
969         myVotes[_to].push(msg.sender);
970     }
971 
972     function delegateCount() public view returns(uint) {
973         return allDelegates.length;
974     }
975 
976     function getWinners() public view returns(address[] winners) {
977         require(tokenBatches.length > 0);
978         uint _proposalId = tokenBatches.length - 1;
979 
980         TokenProposal memory p = tokenBatches[_proposalId];
981 
982         // there is only one winner in criteria 0
983         if (p.criteria == 0) {
984             winners = new address[](1);
985             uint max = 0;
986 
987             for (uint i=0; i < consideredTokens.length; i++) {
988                 if (isWinner[consideredTokens[i]]) {
989                     continue;
990                 }
991 
992                 if (isWinner[consideredTokens[max]]) {
993                     max = i;
994                 }
995 
996                 if (getCurrentVotes(i) > getCurrentVotes(max)) {
997                     max = i;
998                 }
999             }
1000 
1001             winners[0] = consideredTokens[max];
1002         }
1003 
1004         // there is N winners in criteria 1
1005         if (p.criteria == 1) {
1006             uint count = 0;
1007             uint[] memory indexesWithMostVotes = new uint[](p.extraData);
1008             winners = new address[](p.extraData);
1009 
1010             // for each token we check if he has more votes than last one,
1011             // if it has we put it in array and always keep array sorted
1012             for (i = 0; i < consideredTokens.length; i++) {
1013                 if (isWinner[consideredTokens[i]]) {
1014                     continue;
1015                 }
1016                 if (count < p.extraData) {
1017                     indexesWithMostVotes[count] = i;
1018                     count++;
1019                     continue;
1020                 }
1021 
1022                 // so we just do it once, sort all in descending order
1023                 if (count == p.extraData) {
1024                     for (j = 0; j < indexesWithMostVotes.length; j++) {
1025                         for (uint k = j+1; k < indexesWithMostVotes.length; k++) {
1026                             if (getCurrentVotes(indexesWithMostVotes[j]) < getCurrentVotes(indexesWithMostVotes[k])) {
1027                                 uint help = indexesWithMostVotes[j];
1028                                 indexesWithMostVotes[j] = indexesWithMostVotes[k];
1029                                 indexesWithMostVotes[k] = help;
1030                             }
1031                         }
1032                     }
1033                 }
1034 
1035                 uint last = p.extraData - 1;
1036                 if (getCurrentVotes(i) > getCurrentVotes(indexesWithMostVotes[last])) {
1037                     indexesWithMostVotes[last] = i;
1038 
1039                     for (uint j=last; j > 0; j--) {
1040                         if (getCurrentVotes(indexesWithMostVotes[j]) > getCurrentVotes(indexesWithMostVotes[j-1])) {
1041                             help = indexesWithMostVotes[j];
1042                             indexesWithMostVotes[j] = indexesWithMostVotes[j-1];
1043                             indexesWithMostVotes[j-1] = help;
1044                         }
1045                     }
1046                 }
1047             }
1048 
1049             for (i = 0; i < p.extraData; i++) {
1050                 winners[i] = consideredTokens[indexesWithMostVotes[i]];
1051             }
1052         }
1053 
1054         // everybody who has over N votes are winners in criteria 2
1055         if (p.criteria == 2) {
1056             uint numOfTokens = 0;
1057             for (i = 0; i < consideredTokens.length; i++) {
1058                 if (isWinner[consideredTokens[i]]) {
1059                     continue;
1060                 }
1061                 if (getCurrentVotes(i) > p.extraData) {
1062                     numOfTokens++;
1063                 }
1064             }
1065 
1066             winners = new address[](numOfTokens);
1067             count = 0;
1068             for (i = 0; i < consideredTokens.length; i++) {
1069                 if (isWinner[consideredTokens[i]]) {
1070                     continue;
1071                 }
1072                 if (getCurrentVotes(i) > p.extraData) {
1073                     winners[count] = consideredTokens[i];
1074                     count++;
1075                 }
1076             }
1077         }
1078     }
1079 
1080     /// @notice Get number of proposals so you can know which is the last one
1081     function numberOfProposals() public view returns(uint) {
1082         return tokenBatches.length;
1083     }
1084 
1085     /// @notice Any admin is able to add new admin
1086     /// @param _newAdmin Address of new admin
1087     function addAdmin(address _newAdmin) public onlyAdmins {
1088         admins[_newAdmin] = true;
1089     }
1090 
1091     /// @notice Only owner is able to remove admin
1092     /// @param _admin Address of current admin
1093     function removeAdmin(address _admin) public onlyOwner {
1094         admins[_admin] = false;
1095     }
1096 
1097     /// @notice Get data about specific proposal
1098     /// @param _proposalId Id of proposal
1099     function proposal(uint _proposalId) public view returns(
1100         uint _startBlock,
1101         uint _startTime,
1102         uint _duration,
1103         bool _active,
1104         bool _finalized,
1105         uint[] _votes,
1106         address[] _tokens,
1107         address _votingToken,
1108         bool _hasBalance
1109     ) {
1110         require(_proposalId < tokenBatches.length);
1111 
1112         TokenProposal memory p = tokenBatches[_proposalId];
1113         _startBlock = p.startBlock;
1114         _startTime = p.startTime;
1115         _duration = p.duration;
1116         _finalized = (_startTime+_duration < now);
1117         _active = isActive(_proposalId);
1118         _votes = getVotes();
1119         _tokens = getConsideredTokens();
1120         _votingToken = p.votingToken;
1121         _hasBalance = (p.votingToken == 0x0) ? false : (DestructibleMiniMeToken(p.votingToken).balanceOf(msg.sender) > 0);
1122     }
1123 
1124     function getConsideredTokens() public view returns(address[] tokens) {
1125         tokens = new address[](consideredTokens.length);
1126 
1127         for (uint i = 0; i < consideredTokens.length; i++) {
1128             if (!isWinner[consideredTokens[i]]) {
1129                 tokens[i] = consideredTokens[i];
1130             } else {
1131                 tokens[i] = address(0);
1132             }
1133         }
1134     }
1135 
1136     function getVotes() public view returns(uint[] votes) {
1137         votes = new uint[](consideredTokens.length);
1138 
1139         for (uint i = 0; i < consideredTokens.length; i++) {
1140             votes[i] = getCurrentVotes(i);
1141         }
1142     }
1143 
1144     function getCurrentVotes(uint index) public view returns(uint) {
1145         require(tokenBatches.length > 0);
1146 
1147         uint _proposalId = tokenBatches.length - 1;
1148         uint vote = yesVotes[index];
1149         if (_proposalId > lastVote[consideredTokens[index]]) {
1150             vote = yesVotes[index] / (2 * (_proposalId - lastVote[consideredTokens[index]]));
1151         }
1152 
1153         return vote;
1154     }
1155 
1156     function isAdmin(address _admin) public view returns(bool) {
1157         return admins[_admin];
1158     }
1159 
1160     function proxyPayment(address ) public payable returns(bool) {
1161         return false;
1162     }
1163 
1164     // only users that didn't gave vote in current round can transfer tokens
1165     function onTransfer(address _from, address _to, uint _amount) public view returns(bool) {
1166         return !gaveVote(_from);
1167     }
1168 
1169     function onApprove(address, address, uint ) public pure returns(bool) {
1170         return true;
1171     }
1172 
1173     function gaveVote(address _user) public view returns(bool) {
1174         if (tokenBatches.length == 0) return false;
1175 
1176         uint _proposalId = tokenBatches.length - 1;
1177 
1178         if (votesSpentThisRound[_proposalId][myDelegate[_user]] + votesSpentThisRound[_proposalId][_user] > 0 ) {
1179             return true;
1180         } else {
1181             return false;
1182         }
1183     }
1184 
1185     function getBlockNumber() internal constant returns (uint) {
1186         return block.number;
1187     }
1188 
1189     function isActive(uint id) internal view returns (bool) {
1190         TokenProposal memory p = tokenBatches[id];
1191         bool _finalized = (p.startTime + p.duration < now);
1192         return !_finalized && (p.startBlock < getBlockNumber());
1193     }
1194 
1195     function appendUintToString(string inStr, uint v) private pure returns (string str) {
1196         uint maxlength = 100;
1197         bytes memory reversed = new bytes(maxlength);
1198         uint i = 0;
1199         if (v == 0) {
1200             reversed[i++] = byte(48);
1201         } else {
1202             while (v != 0) {
1203                 uint remainder = v % 10;
1204                 v = v / 10;
1205                 reversed[i++] = byte(48 + remainder);
1206             }
1207         }
1208         bytes memory inStrb = bytes(inStr);
1209         bytes memory s = new bytes(inStrb.length + i);
1210         uint j;
1211         for (j = 0; j < inStrb.length; j++) {
1212             s[j] = inStrb[j];
1213         }
1214         for (j = 0; j < i; j++) {
1215             s[j + inStrb.length] = reversed[i - 1 - j];
1216         }
1217         str = string(s);
1218     }
1219 
1220     event Vote(uint indexed idProposal, address indexed _voter, address chosenToken, uint amount);
1221     event NewTokens(uint indexed idProposal);
1222 }