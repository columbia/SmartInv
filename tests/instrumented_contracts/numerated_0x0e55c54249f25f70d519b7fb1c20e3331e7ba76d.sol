1 pragma solidity ^0.4.18;
2 
3 
4 /*
5     Copyright 2016, Jordi Baylina
6 
7     This program is free software: you can redistribute it and/or modify
8     it under the terms of the GNU General Public License as published by
9     the Free Software Foundation, either version 3 of the License, or
10     (at your option) any later version.
11 
12     This program is distributed in the hope that it will be useful,
13     but WITHOUT ANY WARRANTY; without even the implied warranty of
14     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15     GNU General Public License for more details.
16 
17     You should have received a copy of the GNU General Public License
18     along with this program.  If not, see <http://www.gnu.org/licenses/>.
19  */
20 
21 /// @title MiniMeToken Contract
22 /// @author Jordi Baylina
23 /// @dev This token contract's goal is to make it easy for anyone to clone this
24 ///  token using the token distribution at a given block, this will allow DAO's
25 ///  and DApps to upgrade their features in a decentralized manner without
26 ///  affecting the original token
27 /// @dev It is ERC20 compliant, but still needs to under go further testing.
28 
29 /// CHANGE LOG: Will Harborne (Ethfinex)  - 07/10/2017
30 /// `transferFrom` edited to allow infinite approvals
31 /// New function `pledgeFees` for Controller to update balance owned by token holders
32 /// New getter functions `totalPledgedFeesAt` and `totalPledgedFees`
33 /// New Checkpoint[] totalPledgedFeesHistory;
34 /// Addition of onBurn function to Controller, called when user tries to burn tokens
35 /// Version 'MMT_0.2' bumped to 'EFX_0.1'
36 
37 /// @dev The token controller contract must implement these functions
38 contract TokenController {
39     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
40     /// @param _owner The address that sent the ether to create tokens
41     /// @return True if the ether is accepted, false if it throws
42     function proxyPayment(address _owner) public payable returns(bool);
43 
44     /// @notice Notifies the controller about a token transfer allowing the
45     ///  controller to react if desired
46     /// @param _from The origin of the transfer
47     /// @param _to The destination of the transfer
48     /// @param _amount The amount of the transfer
49     /// @return False if the controller does not authorize the transfer
50     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
51 
52     /// @notice Notifies the controller about an approval allowing the
53     ///  controller to react if desired
54     /// @param _owner The address that calls `approve()`
55     /// @param _spender The spender in the `approve()` call
56     /// @param _amount The amount in the `approve()` call
57     /// @return False if the controller does not authorize the approval
58     function onApprove(address _owner, address _spender, uint _amount) public
59         returns(bool);
60 
61     /// @notice Notifies the controller about a token burn
62     /// @param _owner The address of the burner
63     /// @param _amount The amount to burn
64     /// @return False if the controller does not authorize the burn
65     function onBurn(address _owner, uint _amount) public returns(bool);
66 }
67 
68 contract Controlled {
69     /// @notice The address of the controller is the only address that can call
70     ///  a function with this modifier
71     modifier onlyController { require(msg.sender == controller); _; }
72 
73     address public controller;
74 
75     function Controlled() public { controller = msg.sender;}
76 
77     /// @notice Changes the controller of the contract
78     /// @param _newController The new controller of the contract
79     function changeController(address _newController) public onlyController {
80         controller = _newController;
81     }
82 }
83 
84 contract ApproveAndCallFallBack {
85     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
86 }
87 
88 /// @dev The actual token contract, the default controller is the msg.sender
89 ///  that deploys the contract, so usually this token will be deployed by a
90 ///  token controller contract, which Giveth will call a "Campaign"
91 contract MiniMeToken is Controlled {
92 
93     string public name;                //The Token's name: e.g. DigixDAO Tokens
94     uint8 public decimals;             //Number of decimals of the smallest unit
95     string public symbol;              //An identifier: e.g. REP
96     string public version = 'EFX_0.1'; //An arbitrary versioning scheme
97 
98 
99     /// @dev `Checkpoint` is the structure that attaches a block number to a
100     ///  given value, the block number attached is the one that last changed the
101     ///  value
102     struct  Checkpoint {
103 
104         // `fromBlock` is the block number that the value was generated from
105         uint128 fromBlock;
106 
107         // `value` is the amount of tokens at a specific block number
108         uint128 value;
109     }
110 
111     // `parentToken` is the Token address that was cloned to produce this token;
112     //  it will be 0x0 for a token that was not cloned
113     MiniMeToken public parentToken;
114 
115     // `parentSnapShotBlock` is the block number from the Parent Token that was
116     //  used to determine the initial distribution of the Clone Token
117     uint public parentSnapShotBlock;
118 
119     // `creationBlock` is the block number that the Clone Token was created
120     uint public creationBlock;
121 
122     // `balances` is the map that tracks the balance of each address, in this
123     //  contract when the balance changes the block number that the change
124     //  occurred is also included in the map
125     mapping (address => Checkpoint[]) balances;
126 
127     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
128     mapping (address => mapping (address => uint256)) allowed;
129 
130     // Tracks the history of the `totalSupply` of the token
131     Checkpoint[] totalSupplyHistory;
132 
133     // Flag that determines if the token is transferable or not.
134     bool public transfersEnabled;
135 
136     // Tracks the history of the `pledgedFees` belonging to token holders
137     Checkpoint[] totalPledgedFeesHistory; // in wei
138 
139     // The factory used to create new clone tokens
140     MiniMeTokenFactory public tokenFactory;
141 
142 ////////////////
143 // Constructor
144 ////////////////
145 
146     /// @notice Constructor to create a MiniMeToken
147     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
148     ///  will create the Clone token contracts, the token factory needs to be
149     ///  deployed first
150     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
151     ///  new token
152     /// @param _parentSnapShotBlock Block of the parent token that will
153     ///  determine the initial distribution of the clone token, set to 0 if it
154     ///  is a new token
155     /// @param _tokenName Name of the new token
156     /// @param _decimalUnits Number of decimals of the new token
157     /// @param _tokenSymbol Token Symbol for the new token
158     /// @param _transfersEnabled If true, tokens will be able to be transferred
159     function MiniMeToken(
160         address _tokenFactory,
161         address _parentToken,
162         uint _parentSnapShotBlock,
163         string _tokenName,
164         uint8 _decimalUnits,
165         string _tokenSymbol,
166         bool _transfersEnabled
167     ) public {
168         tokenFactory = MiniMeTokenFactory(_tokenFactory);
169         name = _tokenName;                                 // Set the name
170         decimals = _decimalUnits;                          // Set the decimals
171         symbol = _tokenSymbol;                             // Set the symbol
172         parentToken = MiniMeToken(_parentToken);
173         parentSnapShotBlock = _parentSnapShotBlock;
174         transfersEnabled = _transfersEnabled;
175         creationBlock = block.number;
176     }
177 
178 
179 ///////////////////
180 // ERC20 Methods
181 ///////////////////
182 
183     uint constant MAX_UINT = 2**256 - 1;
184 
185     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
186     /// @param _to The address of the recipient
187     /// @param _amount The amount of tokens to be transferred
188     /// @return Whether the transfer was successful or not
189     function transfer(address _to, uint256 _amount) public returns (bool success) {
190         require(transfersEnabled);
191         doTransfer(msg.sender, _to, _amount);
192         return true;
193     }
194 
195     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
196     ///  is approved by `_from`
197     /// @param _from The address holding the tokens being transferred
198     /// @param _to The address of the recipient
199     /// @param _amount The amount of tokens to be transferred
200     /// @return True if the transfer was successful
201     function transferFrom(address _from, address _to, uint256 _amount
202     ) public returns (bool success) {
203 
204         // The controller of this contract can move tokens around at will,
205         //  this is important to recognize! Confirm that you trust the
206         //  controller of this contract, which in most situations should be
207         //  another open source smart contract or 0x0
208         if (msg.sender != controller) {
209             require(transfersEnabled);
210 
211             // The standard ERC 20 transferFrom functionality
212             if (allowed[_from][msg.sender] < MAX_UINT) {
213                 require(allowed[_from][msg.sender] >= _amount);
214                 allowed[_from][msg.sender] -= _amount;
215             }
216         }
217         doTransfer(_from, _to, _amount);
218         return true;
219     }
220 
221     /// @dev This is the actual transfer function in the token contract, it can
222     ///  only be called by other functions in this contract.
223     /// @param _from The address holding the tokens being transferred
224     /// @param _to The address of the recipient
225     /// @param _amount The amount of tokens to be transferred
226     /// @return True if the transfer was successful
227     function doTransfer(address _from, address _to, uint _amount
228     ) internal {
229 
230            if (_amount == 0) {
231                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
232                return;
233            }
234 
235            require(parentSnapShotBlock < block.number);
236 
237            // Do not allow transfer to 0x0 or the token contract itself
238            require((_to != 0) && (_to != address(this)));
239 
240            // If the amount being transfered is more than the balance of the
241            //  account the transfer throws
242            var previousBalanceFrom = balanceOfAt(_from, block.number);
243 
244            require(previousBalanceFrom >= _amount);
245 
246            // Alerts the token controller of the transfer
247            if (isContract(controller)) {
248                require(TokenController(controller).onTransfer(_from, _to, _amount));
249            }
250 
251            // First update the balance array with the new value for the address
252            //  sending the tokens
253            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
254 
255            // Then update the balance array with the new value for the address
256            //  receiving the tokens
257            var previousBalanceTo = balanceOfAt(_to, block.number);
258            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
259            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
260 
261            // An event to make the transfer easy to find on the blockchain
262            Transfer(_from, _to, _amount);
263 
264     }
265 
266     /// @param _owner The address that's balance is being requested
267     /// @return The balance of `_owner` at the current block
268     function balanceOf(address _owner) public constant returns (uint256 balance) {
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
303     ) public constant returns (uint256 remaining) {
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
330     function totalSupply() public constant returns (uint) {
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
343     function balanceOfAt(address _owner, uint _blockNumber) public constant
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
369     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
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
391 // Query pledgedFees // in wei
392 ////////////////
393 
394    /// @dev This function makes it easy to get the total pledged fees
395    /// @return The total number of fees belonging to token holders
396    function totalPledgedFees() public constant returns (uint) {
397        return totalPledgedFeesAt(block.number);
398    }
399 
400    /// @notice Total amount of fees at a specific `_blockNumber`.
401    /// @param _blockNumber The block number when the totalPledgedFees is queried
402    /// @return The total amount of pledged fees at `_blockNumber`
403    function totalPledgedFeesAt(uint _blockNumber) public constant returns(uint) {
404 
405        // These next few lines are used when the totalPledgedFees of the token is
406        //  requested before a check point was ever created for this token, it
407        //  requires that the `parentToken.totalPledgedFeesAt` be queried at the
408        //  genesis block for this token as that contains totalPledgedFees of this
409        //  token at this block number.
410        if ((totalPledgedFeesHistory.length == 0)
411            || (totalPledgedFeesHistory[0].fromBlock > _blockNumber)) {
412            if (address(parentToken) != 0) {
413                return parentToken.totalPledgedFeesAt(min(_blockNumber, parentSnapShotBlock));
414            } else {
415                return 0;
416            }
417 
418        // This will return the expected totalPledgedFees during normal situations
419        } else {
420            return getValueAt(totalPledgedFeesHistory, _blockNumber);
421        }
422    }
423 
424 ////////////////
425 // Pledge Fees To Token Holders or Reduce Pledged Fees // in wei
426 ////////////////
427 
428    /// @notice Pledges fees to the token holders, later to be claimed by burning
429    /// @param _value The amount sent to the vault by controller, reserved for token holders
430    function pledgeFees(uint _value) public onlyController returns (bool) {
431        uint curTotalFees = totalPledgedFees();
432        require(curTotalFees + _value >= curTotalFees); // Check for overflow
433        updateValueAtNow(totalPledgedFeesHistory, curTotalFees + _value);
434        return true;
435    }
436 
437    /// @notice Reduces pledged fees to the token holders, i.e. during upgrade or token burning
438    /// @param _value The amount of pledged fees which are being distributed to token holders, reducing liability
439    function reducePledgedFees(uint _value) public onlyController returns (bool) {
440        uint curTotalFees = totalPledgedFees();
441        require(curTotalFees >= _value);
442        updateValueAtNow(totalPledgedFeesHistory, curTotalFees - _value);
443        return true;
444    }
445 
446 ////////////////
447 // Clone Token Method
448 ////////////////
449 
450     /// @notice Creates a new clone token with the initial distribution being
451     ///  this token at `_snapshotBlock`
452     /// @param _cloneTokenName Name of the clone token
453     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
454     /// @param _cloneTokenSymbol Symbol of the clone token
455     /// @param _snapshotBlock Block when the distribution of the parent token is
456     ///  copied to set the initial distribution of the new clone token;
457     ///  if the block is zero than the actual block, the current block is used
458     /// @param _transfersEnabled True if transfers are allowed in the clone
459     /// @return The address of the new MiniMeToken Contract
460     function createCloneToken(
461         string _cloneTokenName,
462         uint8 _cloneDecimalUnits,
463         string _cloneTokenSymbol,
464         uint _snapshotBlock,
465         bool _transfersEnabled
466         ) public returns(address) {
467         if (_snapshotBlock == 0) _snapshotBlock = block.number;
468         MiniMeToken cloneToken = tokenFactory.createCloneToken(
469             this,
470             _snapshotBlock,
471             _cloneTokenName,
472             _cloneDecimalUnits,
473             _cloneTokenSymbol,
474             _transfersEnabled
475             );
476 
477         cloneToken.changeController(msg.sender);
478 
479         // An event to make the token easy to find on the blockchain
480         NewCloneToken(address(cloneToken), _snapshotBlock);
481         return address(cloneToken);
482     }
483 
484 ////////////////
485 // Generate and destroy tokens
486 ////////////////
487 
488     /// @notice Generates `_amount` tokens that are assigned to `_owner`
489     /// @param _owner The address that will be assigned the new tokens
490     /// @param _amount The quantity of tokens generated
491     /// @return True if the tokens are generated correctly
492     function generateTokens(address _owner, uint _amount
493     ) public onlyController returns (bool) {
494         uint curTotalSupply = totalSupply();
495         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
496         uint previousBalanceTo = balanceOf(_owner);
497         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
498         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
499         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
500         Transfer(0, _owner, _amount);
501         return true;
502     }
503 
504 
505     /// @notice Burns `_amount` tokens from `_owner`
506     /// @param _owner The address that will lose the tokens
507     /// @param _amount The quantity of tokens to burn
508     /// @return True if the tokens are burned correctly
509     function destroyTokens(address _owner, uint _amount
510     ) onlyController public returns (bool) {
511         uint curTotalSupply = totalSupply();
512         require(curTotalSupply >= _amount);
513         uint previousBalanceFrom = balanceOf(_owner);
514         require(previousBalanceFrom >= _amount);
515         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
516         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
517         Transfer(_owner, 0, _amount);
518         return true;
519     }
520 
521 ////////////////
522 // Enable tokens transfers
523 ////////////////
524 
525 
526     /// @notice Enables token holders to transfer their tokens freely if true
527     /// @param _transfersEnabled True if transfers are allowed in the clone
528     function enableTransfers(bool _transfersEnabled) public onlyController {
529         transfersEnabled = _transfersEnabled;
530     }
531 
532 ////////////////
533 // Internal helper functions to query and set a value in a snapshot array
534 ////////////////
535 
536     /// @dev `getValueAt` retrieves the number of tokens at a given block number
537     /// @param checkpoints The history of values being queried
538     /// @param _block The block number to retrieve the value at
539     /// @return The number of tokens being queried
540     function getValueAt(Checkpoint[] storage checkpoints, uint _block
541     ) constant internal returns (uint) {
542         if (checkpoints.length == 0) return 0;
543 
544         // Shortcut for the actual value
545         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
546             return checkpoints[checkpoints.length-1].value;
547         if (_block < checkpoints[0].fromBlock) return 0;
548 
549         // Binary search of the value in the array
550         uint min = 0;
551         uint max = checkpoints.length-1;
552         while (max > min) {
553             uint mid = (max + min + 1)/ 2;
554             if (checkpoints[mid].fromBlock<=_block) {
555                 min = mid;
556             } else {
557                 max = mid-1;
558             }
559         }
560         return checkpoints[min].value;
561     }
562 
563     /// @dev `updateValueAtNow` used to update the `balances` map and the
564     ///  `totalSupplyHistory`
565     /// @param checkpoints The history of data being updated
566     /// @param _value The new number of tokens
567     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
568     ) internal  {
569         if ((checkpoints.length == 0)
570         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
571                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
572                newCheckPoint.fromBlock =  uint128(block.number);
573                newCheckPoint.value = uint128(_value);
574            } else {
575                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
576                oldCheckPoint.value = uint128(_value);
577            }
578     }
579 
580     /// @dev Internal function to determine if an address is a contract
581     /// @param _addr The address being queried
582     /// @return True if `_addr` is a contract
583     function isContract(address _addr) constant internal returns(bool) {
584         uint size;
585         if (_addr == 0) return false;
586         assembly {
587             size := extcodesize(_addr)
588         }
589         return size>0;
590     }
591 
592     /// @dev Helper function to return a min betwen the two uints
593     function min(uint a, uint b) pure internal returns (uint) {
594         return a < b ? a : b;
595     }
596 
597     /// @notice The fallback function: If the contract's controller has not been
598     ///  set to 0, then the `proxyPayment` method is called which relays the
599     ///  ether and creates tokens as described in the token controller contract
600     function () public payable {
601         require(isContract(controller));
602         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
603     }
604 
605 //////////
606 // Safety Methods
607 //////////
608 
609     /// @notice This method can be used by the controller to extract mistakenly
610     ///  sent tokens to this contract.
611     /// @param _token The address of the token contract that you want to recover
612     ///  set to 0 in case you want to extract ether.
613     function claimTokens(address _token) public onlyController {
614         if (_token == 0x0) {
615             controller.transfer(this.balance);
616             return;
617         }
618 
619         MiniMeToken token = MiniMeToken(_token);
620         uint balance = token.balanceOf(this);
621         token.transfer(controller, balance);
622         ClaimedTokens(_token, controller, balance);
623     }
624 
625 ////////////////
626 // Events
627 ////////////////
628     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
629     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
630     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
631     event Approval(
632         address indexed _owner,
633         address indexed _spender,
634         uint256 _amount
635         );
636 
637 }
638 
639 
640 ////////////////
641 // MiniMeTokenFactory
642 ////////////////
643 
644 /// @dev This contract is used to generate clone contracts from a contract.
645 ///  In solidity this is the way to create a contract from a contract of the
646 ///  same class
647 contract MiniMeTokenFactory {
648 
649     /// @notice Update the DApp by creating a new token with new functionalities
650     ///  the msg.sender becomes the controller of this clone token
651     /// @param _parentToken Address of the token being cloned
652     /// @param _snapshotBlock Block of the parent token that will
653     ///  determine the initial distribution of the clone token
654     /// @param _tokenName Name of the new token
655     /// @param _decimalUnits Number of decimals of the new token
656     /// @param _tokenSymbol Token Symbol for the new token
657     /// @param _transfersEnabled If true, tokens will be able to be transferred
658     /// @return The address of the new token contract
659     function createCloneToken(
660         address _parentToken,
661         uint _snapshotBlock,
662         string _tokenName,
663         uint8 _decimalUnits,
664         string _tokenSymbol,
665         bool _transfersEnabled
666     ) public returns (MiniMeToken) {
667         MiniMeToken newToken = new MiniMeToken(
668             this,
669             _parentToken,
670             _snapshotBlock,
671             _tokenName,
672             _decimalUnits,
673             _tokenSymbol,
674             _transfersEnabled
675             );
676 
677         newToken.changeController(msg.sender);
678         return newToken;
679     }
680 }
681 
682 
683 /*
684     Copyright 2017, Will Harborne (Ethfinex)
685 */
686 
687 contract NEC is MiniMeToken {
688 
689   function NEC(
690     address _tokenFactory,
691     address efxVaultWallet
692   ) public MiniMeToken(
693     _tokenFactory,
694     0x0,                    // no parent token
695     0,                      // no snapshot block number from parent
696     "Ethfinex Nectar Token", // Token name
697     18,                     // Decimals
698     "NEC",                  // Symbol
699     true                    // Enable transfers
700     ) {
701         generateTokens(efxVaultWallet, 1000000000000000000000000000);
702         enableBurning(false);
703     }
704 
705     // Flag that determines if the token can be burned for rewards or not
706     bool public burningEnabled;
707 
708 
709 ////////////////
710 // Enable token burning by users
711 ////////////////
712 
713     function enableBurning(bool _burningEnabled) public onlyController {
714         burningEnabled = _burningEnabled;
715     }
716 
717     function burnAndRetrieve(uint256 _tokensToBurn) public returns (bool success) {
718         require(burningEnabled);
719 
720         var previousBalanceFrom = balanceOfAt(msg.sender, block.number);
721         if (previousBalanceFrom < _tokensToBurn) {
722             return false;
723         }
724 
725         // Alerts the token controller of the burn function call
726         // If enabled, controller will distribute fees and destroy tokens
727         // Or any other logic chosen by controller
728         if (isContract(controller)) {
729             require(TokenController(controller).onBurn(msg.sender, _tokensToBurn));
730         }
731 
732         Burned(msg.sender, _tokensToBurn);
733         return true;
734     }
735 
736     event Burned(address indexed who, uint256 _amount);
737 
738 }
739 
740 
741 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
742 ///  later changed
743 contract Owned {
744     /// @dev `owner` is the only address that can call a function with this
745     /// modifier
746     modifier onlyOwner { require (msg.sender == owner); _; }
747 
748     address public owner;
749 
750     /// @notice The Constructor assigns the message sender to be `owner`
751     function Owned() public { owner = msg.sender;}
752 
753     /// @notice `owner` can step down and assign some other address to this role
754     /// @param _newOwner The address of the new owner. 0x0 can be used to create
755     ///  an unowned neutral vault, however that cannot be undone
756     function changeOwner(address _newOwner) public onlyOwner {
757         owner = _newOwner;
758     }
759 }
760 
761 /*
762     Copyright 2017, Will Harborne (Ethfinex)
763 */
764 
765 
766 /// @title Whitelist contract - Only addresses which are registered as part of the market maker loyalty scheme can be whitelisted to earn and own Nectar tokens
767 contract Whitelist is Owned {
768 
769   function Whitelist() {
770     admins[msg.sender] = true;
771   }
772 
773   bool public listActive = true;
774 
775   // Only users who are on the whitelist
776   function isRegistered(address _user) public constant returns (bool) {
777     if (!listActive) {
778       return true;
779     } else {
780       return isOnList[_user];
781     }
782   }
783 
784   // Can add people to the whitelist
785   function isAdmin(address _admin) public view returns(bool) {
786     return admins[_admin];
787   }
788 
789   /// @notice The owner is able to add new admin
790   /// @param _newAdmin Address of new admin
791   function addAdmin(address _newAdmin) public onlyOwner {
792     admins[_newAdmin] = true;
793   }
794 
795   /// @notice Only owner is able to remove admin
796   /// @param _admin Address of current admin
797   function removeAdmin(address _admin) public onlyOwner {
798     admins[_admin] = false;
799   }
800 
801   // Only authorised sources/contracts can contribute fees on behalf of makers to earn tokens
802   modifier authorised () {
803     require(isAuthorisedMaker[msg.sender]);
804     _;
805   }
806 
807   modifier onlyAdmins() {
808     require(isAdmin(msg.sender));
809     _;
810   }
811 
812   // These admins are able to add new users to the whitelist
813   mapping (address => bool) public admins;
814 
815   // This is the whitelist of users who are registered to be able to own the tokens
816   mapping (address => bool) public isOnList;
817 
818   // This is a more select list of a few contracts or addresses which can contribute fees on behalf of makers, to generate tokens
819   mapping (address => bool) public isAuthorisedMaker;
820 
821 
822   /// @dev register
823   /// @param newUsers - Array of users to add to the whitelist
824   function register(address[] newUsers) public onlyAdmins {
825     for (uint i = 0; i < newUsers.length; i++) {
826       isOnList[newUsers[i]] = true;
827     }
828   }
829 
830   /// @dev deregister
831   /// @param bannedUsers - Array of users to remove from the whitelist
832   function deregister(address[] bannedUsers) public onlyAdmins {
833     for (uint i = 0; i < bannedUsers.length; i++) {
834       isOnList[bannedUsers[i]] = false;
835     }
836   }
837 
838   /// @dev authoriseMaker
839   /// @param maker - Source to add to authorised contributors
840   function authoriseMaker(address maker) public onlyOwner {
841       isAuthorisedMaker[maker] = true;
842       // Also add any authorised Maker to the whitelist
843       address[] memory makers = new address[](1);
844       makers[0] = maker;
845       register(makers);
846   }
847 
848   /// @dev deauthoriseMaker
849   /// @param maker - Source to remove from authorised contributors
850   function deauthoriseMaker(address maker) public onlyOwner {
851       isAuthorisedMaker[maker] = false;
852   }
853 
854   function activateWhitelist(bool newSetting) public onlyOwner {
855       listActive = newSetting;
856   }
857 
858   /////// Getters to allow the same whitelist to be used also by other contracts (including upgraded Controllers) ///////
859 
860   function getRegistrationStatus(address _user) constant external returns (bool) {
861     return isOnList[_user];
862   }
863 
864   function getAuthorisationStatus(address _maker) constant external returns (bool) {
865     return isAuthorisedMaker[_maker];
866   }
867 
868   function getOwner() external constant returns (address) {
869     return owner;
870   }
871 
872 
873 }
874 
875 
876 /**
877  * @title SafeMath
878  * @dev Math operations with safety checks that throw on error
879  */
880 library SafeMath {
881   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
882     if (a == 0) {
883       return 0;
884     }
885     uint256 c = a * b;
886     assert(c / a == b);
887     return c;
888   }
889 
890   function div(uint256 a, uint256 b) internal pure returns (uint256) {
891     // assert(b > 0); // Solidity automatically throws when dividing by 0
892     uint256 c = a / b;
893     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
894     return c;
895   }
896 
897   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
898     assert(b <= a);
899     return a - b;
900   }
901 
902   function add(uint256 a, uint256 b) internal pure returns (uint256) {
903     uint256 c = a + b;
904     assert(c >= a);
905     return c;
906   }
907 }
908 
909 
910 /*
911     Copyright 2018, Will Harborne (Ethfinex)
912     v2.0.0
913 */
914 
915 contract NectarController is TokenController, Whitelist {
916     using SafeMath for uint256;
917 
918     NEC public tokenContract;   // The new token for this Campaign
919     address public vaultAddress;        // The address to hold the funds donated
920 
921     uint public periodLength = 30;       // Contribution windows length in days
922     uint public startTime = 1518523865;  // Time of window 1 opening
923 
924     mapping (uint => uint) public windowFinalBlock;  // Final block before initialisation of new window
925 
926 
927     /// @dev There are several checks to make sure the parameters are acceptable
928     /// @param _vaultAddress The address that will store the donated funds
929     /// @param _tokenAddress Address of the token contract this contract controls
930 
931     function NectarController(
932         address _vaultAddress,
933         address _tokenAddress
934     ) public {
935         require(_vaultAddress != 0);                // To prevent burning ETH
936         tokenContract = NEC(_tokenAddress); // The Deployed Token Contract
937         vaultAddress = _vaultAddress;
938         windowFinalBlock[0] = 5082733;
939         windowFinalBlock[1] = 5260326;
940     }
941 
942     /// @dev The fallback function is called when ether is sent to the contract, it
943     /// simply calls `doTakerPayment()` . No tokens are created when takers contribute.
944     /// `_owner`. Payable is a required solidity modifier for functions to receive
945     /// ether, without this modifier functions will throw if ether is sent to them
946 
947     function ()  public payable {
948         doTakerPayment();
949     }
950 
951     function contributeForMakers(address _owner) public payable authorised {
952         doMakerPayment(_owner);
953     }
954 
955 /////////////////
956 // TokenController interface
957 /////////////////
958 
959     /// @notice `proxyPayment()` allows the caller to send ether to the Campaign
960     /// but does not create tokens. This functions the same as the fallback function.
961     /// @param _owner Does not do anything, but preserved because of MiniMe standard function.
962     function proxyPayment(address _owner) public payable returns(bool) {
963         doTakerPayment();
964         return true;
965     }
966 
967     /// @notice `proxyAccountingCreation()` allows owner to create tokens without sending ether via the contract
968     /// Creates tokens, pledging an amount of eth to token holders but not sending it through the contract to the vault
969     /// @param _owner The person who will have the created tokens
970     function proxyAccountingCreation(address _owner, uint _pledgedAmount, uint _tokensToCreate) public onlyOwner returns(bool) {
971         // Ethfinex is a hybrid decentralised exchange
972         // This function is only for use to create tokens on behalf of users of the centralised side of Ethfinex
973         // Because there are several different fee tiers (depending on trading volume) token creation rates may not always be proportional to fees contributed.
974         // For example if a user is trading with a 0.025% fee as opposed to the standard 0.1% the tokensToCreate the pledged fees will be lower than through using the standard contributeForMakers function
975         // Tokens to create must be calculated off-chain using the issuance equation and current parameters of this contract, multiplied depending on user's fee tier
976         doProxyAccounting(_owner, _pledgedAmount, _tokensToCreate);
977         return true;
978     }
979 
980 
981     /// @notice Notifies the controller about a transfer.
982     /// Transfers can only happen to whitelisted addresses
983     /// @param _from The origin of the transfer
984     /// @param _to The destination of the transfer
985     /// @param _amount The amount of the transfer
986     /// @return False if the controller does not authorize the transfer
987     function onTransfer(address _from, address _to, uint _amount) public returns(bool) {
988         if (isRegistered(_to) && isRegistered(_from)) {
989           return true;
990         } else {
991           return false;
992         }
993     }
994 
995     /// @notice Notifies the controller about an approval, for this Campaign all
996     ///  approvals are allowed by default and no extra notifications are needed
997     /// @param _owner The address that calls `approve()`
998     /// @param _spender The spender in the `approve()` call
999     /// @param _amount The amount in the `approve()` call
1000     /// @return False if the controller does not authorize the approval
1001     function onApprove(address _owner, address _spender, uint _amount) public
1002         returns(bool)
1003     {
1004         if (isRegistered(_owner)) {
1005           return true;
1006         } else {
1007           return false;
1008         }
1009     }
1010 
1011     /// @notice Notifies the controller about a burn attempt. Initially all burns are disabled.
1012     /// Upgraded Controllers in the future will allow token holders to claim the pledged ETH
1013     /// @param _owner The address that calls `burn()`
1014     /// @param _tokensToBurn The amount in the `burn()` call
1015     /// @return False if the controller does not authorize the approval
1016     function onBurn(address _owner, uint _tokensToBurn) public
1017         returns(bool)
1018     {
1019         // This plugin can only be called by the token contract
1020         require(msg.sender == address(tokenContract));
1021 
1022         uint256 feeTotal = tokenContract.totalPledgedFees();
1023         uint256 totalTokens = tokenContract.totalSupply();
1024         uint256 feeValueOfTokens = (feeTotal.mul(_tokensToBurn)).div(totalTokens);
1025 
1026         // Destroy the owners tokens prior to sending them the associated fees
1027         require (tokenContract.destroyTokens(_owner, _tokensToBurn));
1028         require (address(this).balance >= feeValueOfTokens);
1029         require (_owner.send(feeValueOfTokens));
1030 
1031         emit LogClaim(_owner, feeValueOfTokens);
1032         return true;
1033     }
1034 
1035 /////////////////
1036 // Maker and taker fee payments handling
1037 /////////////////
1038 
1039 
1040     /// @dev `doMakerPayment()` is an internal function that sends the ether that this
1041     ///  contract receives to the `vault` and creates tokens in the address of the
1042     ///  `_owner`who the fee contribution was sent by
1043     /// @param _owner The address that will hold the newly created tokens
1044     function doMakerPayment(address _owner) internal {
1045 
1046         require ((tokenContract.controller() != 0) && (msg.value != 0) );
1047         tokenContract.pledgeFees(msg.value);
1048         require (vaultAddress.send(msg.value));
1049 
1050         // Set the block number which will be used to calculate issuance rate during
1051         // this window if it has not already been set
1052         if(windowFinalBlock[currentWindow()-1] == 0) {
1053             windowFinalBlock[currentWindow()-1] = block.number -1;
1054         }
1055 
1056         uint256 newIssuance = getFeeToTokenConversion(msg.value);
1057         require (tokenContract.generateTokens(_owner, newIssuance));
1058 
1059         emit LogContributions (_owner, msg.value, true);
1060         return;
1061     }
1062 
1063     /// @dev `doTakerPayment()` is an internal function that sends the ether that this
1064     ///  contract receives to the `vault`, creating no tokens
1065     function doTakerPayment() internal {
1066 
1067         require ((tokenContract.controller() != 0) && (msg.value != 0) );
1068         tokenContract.pledgeFees(msg.value);
1069         require (vaultAddress.send(msg.value));
1070 
1071         emit LogContributions (msg.sender, msg.value, false);
1072         return;
1073     }
1074 
1075     /// @dev `doProxyAccounting()` is an internal function that creates tokens
1076     /// for fees pledged by the owner
1077     function doProxyAccounting(address _owner, uint _pledgedAmount, uint _tokensToCreate) internal {
1078 
1079         require ((tokenContract.controller() != 0));
1080         if(windowFinalBlock[currentWindow()-1] == 0) {
1081             windowFinalBlock[currentWindow()-1] = block.number -1;
1082         }
1083         tokenContract.pledgeFees(_pledgedAmount);
1084 
1085         if(_tokensToCreate > 0) {
1086             uint256 newIssuance = getFeeToTokenConversion(_pledgedAmount);
1087             require (tokenContract.generateTokens(_owner, _tokensToCreate));
1088         }
1089 
1090         emit LogContributions (msg.sender, _pledgedAmount, true);
1091         return;
1092     }
1093 
1094     /// @notice `onlyOwner` changes the location that ether is sent
1095     /// @param _newVaultAddress The address that will store the fees collected
1096     function setVault(address _newVaultAddress) public onlyOwner {
1097         vaultAddress = _newVaultAddress;
1098     }
1099 
1100     /// @notice `onlyOwner` can upgrade the controller contract
1101     /// @param _newControllerAddress The address that will have the token control logic
1102     function upgradeController(address _newControllerAddress) public onlyOwner {
1103         tokenContract.changeController(_newControllerAddress);
1104         emit UpgradedController(_newControllerAddress);
1105     }
1106 
1107 /////////////////
1108 // Issuance reward related functions - upgraded by changing controller
1109 /////////////////
1110 
1111     /// @dev getFeeToTokenConversion (v2) - Controller could be changed in the future to update this function
1112     /// @param _contributed - The value of fees contributed during the window
1113     function getFeeToTokenConversion(uint256 _contributed) public view returns (uint256) {
1114 
1115         uint calculationBlock = windowFinalBlock[currentWindow()-1];
1116         uint256 previousSupply = tokenContract.totalSupplyAt(calculationBlock);
1117         uint256 initialSupply = tokenContract.totalSupplyAt(windowFinalBlock[0]);
1118         // Rate = 1000 * (2-totalSupply/InitialSupply)^2
1119         // This imposes a max possible supply of 2 billion
1120         if (previousSupply >= 2 * initialSupply) {
1121             return 0;
1122         }
1123         uint256 newTokens = _contributed.mul(1000).mul(bigInt(2)-(bigInt(previousSupply).div(initialSupply))).mul(bigInt(2)-(bigInt(previousSupply).div(initialSupply))).div(bigInt(1).mul(bigInt(1)));
1124         return newTokens;
1125     }
1126 
1127     function bigInt(uint256 input) internal pure returns (uint256) {
1128       return input.mul(10 ** 10);
1129     }
1130 
1131     function currentWindow() public constant returns (uint) {
1132        return windowAt(block.timestamp);
1133     }
1134 
1135     function windowAt(uint timestamp) public constant returns (uint) {
1136       return timestamp < startTime
1137           ? 0
1138           : timestamp.sub(startTime).div(periodLength * 1 days) + 1;
1139     }
1140 
1141     /// @dev topUpBalance - This is only used to increase this.balance in the case this controller is used to allow burning
1142     function topUpBalance() public payable {
1143         // Pledged fees could be sent here and used to payout users who burn their tokens
1144         emit LogFeeTopUp(msg.value);
1145     }
1146 
1147     /// @dev evacuateToVault - This is only used to evacuate remaining to ether from this contract to the vault address
1148     function evacuateToVault() public onlyOwner{
1149         vaultAddress.transfer(address(this).balance);
1150         emit LogFeeEvacuation(address(this).balance);
1151     }
1152 
1153     /// @dev enableBurning - Allows the owner to activate burning on the underlying token contract
1154     function enableBurning(bool _burningEnabled) public onlyOwner{
1155         tokenContract.enableBurning(_burningEnabled);
1156     }
1157 
1158 
1159 //////////
1160 // Safety Methods
1161 //////////
1162 
1163     /// @notice This method can be used by the owner to extract mistakenly
1164     ///  sent tokens to this contract.
1165     /// @param _token The address of the token contract that you want to recover
1166     function claimTokens(address _token) public onlyOwner {
1167 
1168         NEC token = NEC(_token);
1169         uint balance = token.balanceOf(this);
1170         token.transfer(owner, balance);
1171         emit ClaimedTokens(_token, owner, balance);
1172     }
1173 
1174 ////////////////
1175 // Events
1176 ////////////////
1177     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
1178 
1179     event LogFeeTopUp(uint _amount);
1180     event LogFeeEvacuation(uint _amount);
1181     event LogContributions (address _user, uint _amount, bool _maker);
1182     event LogClaim (address _user, uint _amount);
1183 
1184     event UpgradedController (address newAddress);
1185 
1186 }