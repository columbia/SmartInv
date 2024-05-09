1 pragma solidity ^0.4.18;
2 
3 /*
4     Copyright 2016, Jordi Baylina
5 
6     This program is free software: you can redistribute it and/or modify
7     it under the terms of the GNU General Public License as published by
8     the Free Software Foundation, either version 3 of the License, or
9     (at your option) any later version.
10 
11     This program is distributed in the hope that it will be useful,
12     but WITHOUT ANY WARRANTY; without even the implied warranty of
13     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14     GNU General Public License for more details.
15 
16     You should have received a copy of the GNU General Public License
17     along with this program.  If not, see <http://www.gnu.org/licenses/>.
18  */
19 
20 /// @title MiniMeToken Contract
21 /// @author Jordi Baylina
22 /// @dev This token contract's goal is to make it easy for anyone to clone this
23 ///  token using the token distribution at a given block, this will allow DAO's
24 ///  and DApps to upgrade their features in a decentralized manner without
25 ///  affecting the original token
26 /// @dev It is ERC20 compliant, but still needs to under go further testing.
27 
28 /// CHANGE LOG: Will Harborne (Ethfinex)  - 07/10/2017
29 /// `transferFrom` edited to allow infinite approvals
30 /// New function `pledgeFees` for Controller to update balance owned by token holders
31 /// New getter functions `totalPledgedFeesAt` and `totalPledgedFees`
32 /// New Checkpoint[] totalPledgedFeesHistory;
33 /// Addition of onBurn function to Controller, called when user tries to burn tokens
34 /// Version 'MMT_0.2' bumped to 'EFX_0.1'
35 
36 /// @dev The token controller contract must implement these functions
37 contract TokenController {
38     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
39     /// @param _owner The address that sent the ether to create tokens
40     /// @return True if the ether is accepted, false if it throws
41     function proxyPayment(address _owner) public payable returns(bool);
42 
43     /// @notice Notifies the controller about a token transfer allowing the
44     ///  controller to react if desired
45     /// @param _from The origin of the transfer
46     /// @param _to The destination of the transfer
47     /// @param _amount The amount of the transfer
48     /// @return False if the controller does not authorize the transfer
49     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
50 
51     /// @notice Notifies the controller about an approval allowing the
52     ///  controller to react if desired
53     /// @param _owner The address that calls `approve()`
54     /// @param _spender The spender in the `approve()` call
55     /// @param _amount The amount in the `approve()` call
56     /// @return False if the controller does not authorize the approval
57     function onApprove(address _owner, address _spender, uint _amount) public
58         returns(bool);
59 
60     /// @notice Notifies the controller about a token burn
61     /// @param _owner The address of the burner
62     /// @param _amount The amount to burn
63     /// @return False if the controller does not authorize the burn
64     function onBurn(address _owner, uint _amount) public returns(bool);
65 }
66 
67 contract Controlled {
68     /// @notice The address of the controller is the only address that can call
69     ///  a function with this modifier
70     modifier onlyController { require(msg.sender == controller); _; }
71 
72     address public controller;
73 
74     function Controlled() public { controller = msg.sender;}
75 
76     /// @notice Changes the controller of the contract
77     /// @param _newController The new controller of the contract
78     function changeController(address _newController) public onlyController {
79         controller = _newController;
80     }
81 }
82 
83 contract ApproveAndCallFallBack {
84     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
85 }
86 
87 /// @dev The actual token contract, the default controller is the msg.sender
88 ///  that deploys the contract, so usually this token will be deployed by a
89 ///  token controller contract, which Giveth will call a "Campaign"
90 contract MiniMeToken is Controlled {
91 
92     string public name;                //The Token's name: e.g. DigixDAO Tokens
93     uint8 public decimals;             //Number of decimals of the smallest unit
94     string public symbol;              //An identifier: e.g. REP
95     string public version = 'EFX_0.1'; //An arbitrary versioning scheme
96 
97 
98     /// @dev `Checkpoint` is the structure that attaches a block number to a
99     ///  given value, the block number attached is the one that last changed the
100     ///  value
101     struct  Checkpoint {
102 
103         // `fromBlock` is the block number that the value was generated from
104         uint128 fromBlock;
105 
106         // `value` is the amount of tokens at a specific block number
107         uint128 value;
108     }
109 
110     // `parentToken` is the Token address that was cloned to produce this token;
111     //  it will be 0x0 for a token that was not cloned
112     MiniMeToken public parentToken;
113 
114     // `parentSnapShotBlock` is the block number from the Parent Token that was
115     //  used to determine the initial distribution of the Clone Token
116     uint public parentSnapShotBlock;
117 
118     // `creationBlock` is the block number that the Clone Token was created
119     uint public creationBlock;
120 
121     // `balances` is the map that tracks the balance of each address, in this
122     //  contract when the balance changes the block number that the change
123     //  occurred is also included in the map
124     mapping (address => Checkpoint[]) balances;
125 
126     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
127     mapping (address => mapping (address => uint256)) allowed;
128 
129     // Tracks the history of the `totalSupply` of the token
130     Checkpoint[] totalSupplyHistory;
131 
132     // Flag that determines if the token is transferable or not.
133     bool public transfersEnabled;
134 
135     // Tracks the history of the `pledgedFees` belonging to token holders
136     Checkpoint[] totalPledgedFeesHistory; // in wei
137 
138     // The factory used to create new clone tokens
139     MiniMeTokenFactory public tokenFactory;
140 
141 ////////////////
142 // Constructor
143 ////////////////
144 
145     /// @notice Constructor to create a MiniMeToken
146     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
147     ///  will create the Clone token contracts, the token factory needs to be
148     ///  deployed first
149     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
150     ///  new token
151     /// @param _parentSnapShotBlock Block of the parent token that will
152     ///  determine the initial distribution of the clone token, set to 0 if it
153     ///  is a new token
154     /// @param _tokenName Name of the new token
155     /// @param _decimalUnits Number of decimals of the new token
156     /// @param _tokenSymbol Token Symbol for the new token
157     /// @param _transfersEnabled If true, tokens will be able to be transferred
158     function MiniMeToken(
159         address _tokenFactory,
160         address _parentToken,
161         uint _parentSnapShotBlock,
162         string _tokenName,
163         uint8 _decimalUnits,
164         string _tokenSymbol,
165         bool _transfersEnabled
166     ) public {
167         tokenFactory = MiniMeTokenFactory(_tokenFactory);
168         name = _tokenName;                                 // Set the name
169         decimals = _decimalUnits;                          // Set the decimals
170         symbol = _tokenSymbol;                             // Set the symbol
171         parentToken = MiniMeToken(_parentToken);
172         parentSnapShotBlock = _parentSnapShotBlock;
173         transfersEnabled = _transfersEnabled;
174         creationBlock = block.number;
175     }
176 
177 
178 ///////////////////
179 // ERC20 Methods
180 ///////////////////
181 
182     uint constant MAX_UINT = 2**256 - 1;
183 
184     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
185     /// @param _to The address of the recipient
186     /// @param _amount The amount of tokens to be transferred
187     /// @return Whether the transfer was successful or not
188     function transfer(address _to, uint256 _amount) public returns (bool success) {
189         require(transfersEnabled);
190         doTransfer(msg.sender, _to, _amount);
191         return true;
192     }
193 
194     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
195     ///  is approved by `_from`
196     /// @param _from The address holding the tokens being transferred
197     /// @param _to The address of the recipient
198     /// @param _amount The amount of tokens to be transferred
199     /// @return True if the transfer was successful
200     function transferFrom(address _from, address _to, uint256 _amount
201     ) public returns (bool success) {
202 
203         // The controller of this contract can move tokens around at will,
204         //  this is important to recognize! Confirm that you trust the
205         //  controller of this contract, which in most situations should be
206         //  another open source smart contract or 0x0
207         if (msg.sender != controller) {
208             require(transfersEnabled);
209 
210             // The standard ERC 20 transferFrom functionality
211             if (allowed[_from][msg.sender] < MAX_UINT) {
212                 require(allowed[_from][msg.sender] >= _amount);
213                 allowed[_from][msg.sender] -= _amount;
214             }
215         }
216         doTransfer(_from, _to, _amount);
217         return true;
218     }
219 
220     /// @dev This is the actual transfer function in the token contract, it can
221     ///  only be called by other functions in this contract.
222     /// @param _from The address holding the tokens being transferred
223     /// @param _to The address of the recipient
224     /// @param _amount The amount of tokens to be transferred
225     /// @return True if the transfer was successful
226     function doTransfer(address _from, address _to, uint _amount
227     ) internal {
228 
229            if (_amount == 0) {
230                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
231                return;
232            }
233 
234            require(parentSnapShotBlock < block.number);
235 
236            // Do not allow transfer to 0x0 or the token contract itself
237            require((_to != 0) && (_to != address(this)));
238 
239            // If the amount being transfered is more than the balance of the
240            //  account the transfer throws
241            var previousBalanceFrom = balanceOfAt(_from, block.number);
242 
243            require(previousBalanceFrom >= _amount);
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
263     }
264 
265     /// @param _owner The address that's balance is being requested
266     /// @return The balance of `_owner` at the current block
267     function balanceOf(address _owner) public constant returns (uint256 balance) {
268         return balanceOfAt(_owner, block.number);
269     }
270 
271     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
272     ///  its behalf. This is a modified version of the ERC20 approve function
273     ///  to be a little bit safer
274     /// @param _spender The address of the account able to transfer the tokens
275     /// @param _amount The amount of tokens to be approved for transfer
276     /// @return True if the approval was successful
277     function approve(address _spender, uint256 _amount) public returns (bool success) {
278         require(transfersEnabled);
279 
280         // To change the approve amount you first have to reduce the addresses`
281         //  allowance to zero by calling `approve(_spender,0)` if it is not
282         //  already 0 to mitigate the race condition described here:
283         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
284         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
285 
286         // Alerts the token controller of the approve function call
287         if (isContract(controller)) {
288             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
289         }
290 
291         allowed[msg.sender][_spender] = _amount;
292         Approval(msg.sender, _spender, _amount);
293         return true;
294     }
295 
296     /// @dev This function makes it easy to read the `allowed[]` map
297     /// @param _owner The address of the account that owns the token
298     /// @param _spender The address of the account able to transfer the tokens
299     /// @return Amount of remaining tokens of _owner that _spender is allowed
300     ///  to spend
301     function allowance(address _owner, address _spender
302     ) public constant returns (uint256 remaining) {
303         return allowed[_owner][_spender];
304     }
305 
306     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
307     ///  its behalf, and then a function is triggered in the contract that is
308     ///  being approved, `_spender`. This allows users to use their tokens to
309     ///  interact with contracts in one function call instead of two
310     /// @param _spender The address of the contract able to transfer the tokens
311     /// @param _amount The amount of tokens to be approved for transfer
312     /// @return True if the function call was successful
313     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
314     ) public returns (bool success) {
315         require(approve(_spender, _amount));
316 
317         ApproveAndCallFallBack(_spender).receiveApproval(
318             msg.sender,
319             _amount,
320             this,
321             _extraData
322         );
323 
324         return true;
325     }
326 
327     /// @dev This function makes it easy to get the total number of tokens
328     /// @return The total number of tokens
329     function totalSupply() public constant returns (uint) {
330         return totalSupplyAt(block.number);
331     }
332 
333 
334 ////////////////
335 // Query balance and totalSupply in History
336 ////////////////
337 
338     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
339     /// @param _owner The address from which the balance will be retrieved
340     /// @param _blockNumber The block number when the balance is queried
341     /// @return The balance at `_blockNumber`
342     function balanceOfAt(address _owner, uint _blockNumber) public constant
343         returns (uint) {
344 
345         // These next few lines are used when the balance of the token is
346         //  requested before a check point was ever created for this token, it
347         //  requires that the `parentToken.balanceOfAt` be queried at the
348         //  genesis block for that token as this contains initial balance of
349         //  this token
350         if ((balances[_owner].length == 0)
351             || (balances[_owner][0].fromBlock > _blockNumber)) {
352             if (address(parentToken) != 0) {
353                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
354             } else {
355                 // Has no parent
356                 return 0;
357             }
358 
359         // This will return the expected balance during normal situations
360         } else {
361             return getValueAt(balances[_owner], _blockNumber);
362         }
363     }
364 
365     /// @notice Total amount of tokens at a specific `_blockNumber`.
366     /// @param _blockNumber The block number when the totalSupply is queried
367     /// @return The total amount of tokens at `_blockNumber`
368     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
369 
370         // These next few lines are used when the totalSupply of the token is
371         //  requested before a check point was ever created for this token, it
372         //  requires that the `parentToken.totalSupplyAt` be queried at the
373         //  genesis block for this token as that contains totalSupply of this
374         //  token at this block number.
375         if ((totalSupplyHistory.length == 0)
376             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
377             if (address(parentToken) != 0) {
378                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
379             } else {
380                 return 0;
381             }
382 
383         // This will return the expected totalSupply during normal situations
384         } else {
385             return getValueAt(totalSupplyHistory, _blockNumber);
386         }
387     }
388 
389 ////////////////
390 // Query pledgedFees // in wei
391 ////////////////
392 
393    /// @dev This function makes it easy to get the total pledged fees
394    /// @return The total number of fees belonging to token holders
395    function totalPledgedFees() public constant returns (uint) {
396        return totalPledgedFeesAt(block.number);
397    }
398 
399    /// @notice Total amount of fees at a specific `_blockNumber`.
400    /// @param _blockNumber The block number when the totalPledgedFees is queried
401    /// @return The total amount of pledged fees at `_blockNumber`
402    function totalPledgedFeesAt(uint _blockNumber) public constant returns(uint) {
403 
404        // These next few lines are used when the totalPledgedFees of the token is
405        //  requested before a check point was ever created for this token, it
406        //  requires that the `parentToken.totalPledgedFeesAt` be queried at the
407        //  genesis block for this token as that contains totalPledgedFees of this
408        //  token at this block number.
409        if ((totalPledgedFeesHistory.length == 0)
410            || (totalPledgedFeesHistory[0].fromBlock > _blockNumber)) {
411            if (address(parentToken) != 0) {
412                return parentToken.totalPledgedFeesAt(min(_blockNumber, parentSnapShotBlock));
413            } else {
414                return 0;
415            }
416 
417        // This will return the expected totalPledgedFees during normal situations
418        } else {
419            return getValueAt(totalPledgedFeesHistory, _blockNumber);
420        }
421    }
422 
423 ////////////////
424 // Pledge Fees To Token Holders or Reduce Pledged Fees // in wei
425 ////////////////
426 
427    /// @notice Pledges fees to the token holders, later to be claimed by burning
428    /// @param _value The amount sent to the vault by controller, reserved for token holders
429    function pledgeFees(uint _value) public onlyController returns (bool) {
430        uint curTotalFees = totalPledgedFees();
431        require(curTotalFees + _value >= curTotalFees); // Check for overflow
432        updateValueAtNow(totalPledgedFeesHistory, curTotalFees + _value);
433        return true;
434    }
435 
436    /// @notice Reduces pledged fees to the token holders, i.e. during upgrade or token burning
437    /// @param _value The amount of pledged fees which are being distributed to token holders, reducing liability
438    function reducePledgedFees(uint _value) public onlyController returns (bool) {
439        uint curTotalFees = totalPledgedFees();
440        require(curTotalFees >= _value);
441        updateValueAtNow(totalPledgedFeesHistory, curTotalFees - _value);
442        return true;
443    }
444 
445 ////////////////
446 // Clone Token Method
447 ////////////////
448 
449     /// @notice Creates a new clone token with the initial distribution being
450     ///  this token at `_snapshotBlock`
451     /// @param _cloneTokenName Name of the clone token
452     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
453     /// @param _cloneTokenSymbol Symbol of the clone token
454     /// @param _snapshotBlock Block when the distribution of the parent token is
455     ///  copied to set the initial distribution of the new clone token;
456     ///  if the block is zero than the actual block, the current block is used
457     /// @param _transfersEnabled True if transfers are allowed in the clone
458     /// @return The address of the new MiniMeToken Contract
459     function createCloneToken(
460         string _cloneTokenName,
461         uint8 _cloneDecimalUnits,
462         string _cloneTokenSymbol,
463         uint _snapshotBlock,
464         bool _transfersEnabled
465         ) public returns(address) {
466         if (_snapshotBlock == 0) _snapshotBlock = block.number;
467         MiniMeToken cloneToken = tokenFactory.createCloneToken(
468             this,
469             _snapshotBlock,
470             _cloneTokenName,
471             _cloneDecimalUnits,
472             _cloneTokenSymbol,
473             _transfersEnabled
474             );
475 
476         cloneToken.changeController(msg.sender);
477 
478         // An event to make the token easy to find on the blockchain
479         NewCloneToken(address(cloneToken), _snapshotBlock);
480         return address(cloneToken);
481     }
482 
483 ////////////////
484 // Generate and destroy tokens
485 ////////////////
486 
487     /// @notice Generates `_amount` tokens that are assigned to `_owner`
488     /// @param _owner The address that will be assigned the new tokens
489     /// @param _amount The quantity of tokens generated
490     /// @return True if the tokens are generated correctly
491     function generateTokens(address _owner, uint _amount
492     ) public onlyController returns (bool) {
493         uint curTotalSupply = totalSupply();
494         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
495         uint previousBalanceTo = balanceOf(_owner);
496         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
497         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
498         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
499         Transfer(0, _owner, _amount);
500         return true;
501     }
502 
503 
504     /// @notice Burns `_amount` tokens from `_owner`
505     /// @param _owner The address that will lose the tokens
506     /// @param _amount The quantity of tokens to burn
507     /// @return True if the tokens are burned correctly
508     function destroyTokens(address _owner, uint _amount
509     ) onlyController public returns (bool) {
510         uint curTotalSupply = totalSupply();
511         require(curTotalSupply >= _amount);
512         uint previousBalanceFrom = balanceOf(_owner);
513         require(previousBalanceFrom >= _amount);
514         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
515         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
516         Transfer(_owner, 0, _amount);
517         return true;
518     }
519 
520 ////////////////
521 // Enable tokens transfers
522 ////////////////
523 
524 
525     /// @notice Enables token holders to transfer their tokens freely if true
526     /// @param _transfersEnabled True if transfers are allowed in the clone
527     function enableTransfers(bool _transfersEnabled) public onlyController {
528         transfersEnabled = _transfersEnabled;
529     }
530 
531 ////////////////
532 // Internal helper functions to query and set a value in a snapshot array
533 ////////////////
534 
535     /// @dev `getValueAt` retrieves the number of tokens at a given block number
536     /// @param checkpoints The history of values being queried
537     /// @param _block The block number to retrieve the value at
538     /// @return The number of tokens being queried
539     function getValueAt(Checkpoint[] storage checkpoints, uint _block
540     ) constant internal returns (uint) {
541         if (checkpoints.length == 0) return 0;
542 
543         // Shortcut for the actual value
544         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
545             return checkpoints[checkpoints.length-1].value;
546         if (_block < checkpoints[0].fromBlock) return 0;
547 
548         // Binary search of the value in the array
549         uint min = 0;
550         uint max = checkpoints.length-1;
551         while (max > min) {
552             uint mid = (max + min + 1)/ 2;
553             if (checkpoints[mid].fromBlock<=_block) {
554                 min = mid;
555             } else {
556                 max = mid-1;
557             }
558         }
559         return checkpoints[min].value;
560     }
561 
562     /// @dev `updateValueAtNow` used to update the `balances` map and the
563     ///  `totalSupplyHistory`
564     /// @param checkpoints The history of data being updated
565     /// @param _value The new number of tokens
566     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
567     ) internal  {
568         if ((checkpoints.length == 0)
569         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
570                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
571                newCheckPoint.fromBlock =  uint128(block.number);
572                newCheckPoint.value = uint128(_value);
573            } else {
574                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
575                oldCheckPoint.value = uint128(_value);
576            }
577     }
578 
579     /// @dev Internal function to determine if an address is a contract
580     /// @param _addr The address being queried
581     /// @return True if `_addr` is a contract
582     function isContract(address _addr) constant internal returns(bool) {
583         uint size;
584         if (_addr == 0) return false;
585         assembly {
586             size := extcodesize(_addr)
587         }
588         return size>0;
589     }
590 
591     /// @dev Helper function to return a min betwen the two uints
592     function min(uint a, uint b) pure internal returns (uint) {
593         return a < b ? a : b;
594     }
595 
596     /// @notice The fallback function: If the contract's controller has not been
597     ///  set to 0, then the `proxyPayment` method is called which relays the
598     ///  ether and creates tokens as described in the token controller contract
599     function () public payable {
600         require(isContract(controller));
601         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
602     }
603 
604 //////////
605 // Safety Methods
606 //////////
607 
608     /// @notice This method can be used by the controller to extract mistakenly
609     ///  sent tokens to this contract.
610     /// @param _token The address of the token contract that you want to recover
611     ///  set to 0 in case you want to extract ether.
612     function claimTokens(address _token) public onlyController {
613         if (_token == 0x0) {
614             controller.transfer(this.balance);
615             return;
616         }
617 
618         MiniMeToken token = MiniMeToken(_token);
619         uint balance = token.balanceOf(this);
620         token.transfer(controller, balance);
621         ClaimedTokens(_token, controller, balance);
622     }
623 
624 ////////////////
625 // Events
626 ////////////////
627     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
628     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
629     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
630     event Approval(
631         address indexed _owner,
632         address indexed _spender,
633         uint256 _amount
634         );
635 
636 }
637 
638 
639 ////////////////
640 // MiniMeTokenFactory
641 ////////////////
642 
643 /// @dev This contract is used to generate clone contracts from a contract.
644 ///  In solidity this is the way to create a contract from a contract of the
645 ///  same class
646 contract MiniMeTokenFactory {
647 
648     /// @notice Update the DApp by creating a new token with new functionalities
649     ///  the msg.sender becomes the controller of this clone token
650     /// @param _parentToken Address of the token being cloned
651     /// @param _snapshotBlock Block of the parent token that will
652     ///  determine the initial distribution of the clone token
653     /// @param _tokenName Name of the new token
654     /// @param _decimalUnits Number of decimals of the new token
655     /// @param _tokenSymbol Token Symbol for the new token
656     /// @param _transfersEnabled If true, tokens will be able to be transferred
657     /// @return The address of the new token contract
658     function createCloneToken(
659         address _parentToken,
660         uint _snapshotBlock,
661         string _tokenName,
662         uint8 _decimalUnits,
663         string _tokenSymbol,
664         bool _transfersEnabled
665     ) public returns (MiniMeToken) {
666         MiniMeToken newToken = new MiniMeToken(
667             this,
668             _parentToken,
669             _snapshotBlock,
670             _tokenName,
671             _decimalUnits,
672             _tokenSymbol,
673             _transfersEnabled
674             );
675 
676         newToken.changeController(msg.sender);
677         return newToken;
678     }
679 }
680 
681 /*
682     Copyright 2017, Will Harborne (Ethfinex)
683 */
684 
685 contract NEC is MiniMeToken {
686 
687   function NEC(
688     address _tokenFactory,
689     address efxVaultWallet
690   ) public MiniMeToken(
691     _tokenFactory,
692     0x0,                    // no parent token
693     0,                      // no snapshot block number from parent
694     "Ethfinex Nectar Token", // Token name
695     18,                     // Decimals
696     "NEC",                  // Symbol
697     true                    // Enable transfers
698     ) {
699         generateTokens(efxVaultWallet, 1000000000000000000000000000);
700         enableBurning(false);
701     }
702 
703     // Flag that determines if the token can be burned for rewards or not
704     bool public burningEnabled;
705 
706 
707 ////////////////
708 // Enable token burning by users
709 ////////////////
710 
711     function enableBurning(bool _burningEnabled) public onlyController {
712         burningEnabled = _burningEnabled;
713     }
714 
715     function burnAndRetrieve(uint256 _tokensToBurn) public returns (bool success) {
716         require(burningEnabled);
717 
718         var previousBalanceFrom = balanceOfAt(msg.sender, block.number);
719         if (previousBalanceFrom < _tokensToBurn) {
720             return false;
721         }
722 
723         // Alerts the token controller of the burn function call
724         // If enabled, controller will distribute fees and destroy tokens
725         // Or any other logic chosen by controller
726         if (isContract(controller)) {
727             require(TokenController(controller).onBurn(msg.sender, _tokensToBurn));
728         }
729 
730         Burned(msg.sender, _tokensToBurn);
731         return true;
732     }
733 
734     event Burned(address indexed who, uint256 _amount);
735 
736 }