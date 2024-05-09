1 pragma solidity ^0.5.0;
2 
3 // Ethfinex Voting Manager - relaunch 25 April 2019
4 
5 /*
6     Copyright 2016, Jordi Baylina
7 
8     This program is free software: you can redistribute it and/or modify
9     it under the terms of the GNU General Public License as published by
10     the Free Software Foundation, either version 3 of the License, or
11     (at your option) any later version.
12 
13     This program is distributed in the hope that it will be useful,
14     but WITHOUT ANY WARRANTY; without even the implied warranty of
15     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
16     GNU General Public License for more details.
17 
18     You should have received a copy of the GNU General Public License
19     along with this program.  If not, see <http://www.gnu.org/licenses/>.
20  */
21 
22 /// @title MiniMeToken Contract
23 /// @author Jordi Baylina
24 /// @dev This token contract's goal is to make it easy for anyone to clone this
25 ///  token using the token distribution at a given block, this will allow DAO's
26 ///  and DApps to upgrade their features in a decentralized manner without
27 ///  affecting the original token
28 /// @dev It is ERC20 compliant, but still needs to under go further testing.
29 
30 contract Controlled {
31     /// @notice The address of the controller is the only address that can call
32     ///  a function with this modifier
33     modifier onlyController { require(msg.sender == controller); _; }
34 
35     address public controller;
36 
37     constructor() public { controller = msg.sender;}
38 
39     /// @notice Changes the controller of the contract
40     /// @param _newController The new controller of the contract
41     function changeController(address _newController) public onlyController {
42         controller = _newController;
43     }
44 }
45 
46 
47 contract TokenController {
48     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
49     /// @param _owner The address that sent the ether to create tokens
50     /// @return True if the ether is accepted, false if it throws
51     function proxyPayment(address _owner) public payable returns(bool);
52 
53     /// @notice Notifies the controller about a token transfer allowing the
54     ///  controller to react if desired
55     /// @param _from The origin of the transfer
56     /// @param _to The destination of the transfer
57     /// @param _amount The amount of the transfer
58     /// @return False if the controller does not authorize the transfer
59     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
60 
61     /// @notice Notifies the controller about an approval allowing the
62     ///  controller to react if desired
63     /// @param _owner The address that calls `approve()`
64     /// @param _spender The spender in the `approve()` call
65     /// @param _amount The amount in the `approve()` call
66     /// @return False if the controller does not authorize the approval
67     function onApprove(address _owner, address _spender, uint _amount) public
68         returns(bool);
69 
70     /// @notice Notifies the controller about a token burn
71     /// @param _owner The address of the burner
72     /// @param _amount The amount to burn
73     /// @return False if the controller does not authorize the burn
74     function onBurn(address payable _owner, uint _amount) public returns(bool);
75 }
76 
77 
78 contract ApproveAndCallFallBack {
79     function receiveApproval(address from, uint256 _amount, address _token, bytes memory _data) public;
80 }
81 
82 /// @dev The actual token contract, the default controller is the msg.sender
83 ///  that deploys the contract, so usually this token will be deployed by a
84 ///  token controller contract, which Giveth will call a "Campaign"
85 /// @dev The actual token contract, the default controller is the msg.sender
86 ///  that deploys the contract, so usually this token will be deployed by a
87 ///  token controller contract, which Giveth will call a "Campaign"
88 contract MiniMeToken is Controlled {
89 
90     string public name;                //The Token's name: e.g. DigixDAO Tokens
91     uint8 public decimals;             //Number of decimals of the smallest unit
92     string public symbol;              //An identifier: e.g. REP
93     string public version = 'EFX_0.1'; //An arbitrary versioning scheme
94 
95 
96     /// @dev `Checkpoint` is the structure that attaches a block number to a
97     ///  given value, the block number attached is the one that last changed the
98     ///  value
99     struct  Checkpoint {
100 
101         // `fromBlock` is the block number that the value was generated from
102         uint128 fromBlock;
103 
104         // `value` is the amount of tokens at a specific block number
105         uint128 value;
106     }
107 
108     // `parentToken` is the Token address that was cloned to produce this token;
109     //  it will be 0x0 for a token that was not cloned
110     MiniMeToken public parentToken;
111 
112     // `parentSnapShotBlock` is the block number from the Parent Token that was
113     //  used to determine the initial distribution of the Clone Token
114     uint public parentSnapShotBlock;
115 
116     // `creationBlock` is the block number that the Clone Token was created
117     uint public creationBlock;
118 
119     // `balances` is the map that tracks the balance of each address, in this
120     //  contract when the balance changes the block number that the change
121     //  occurred is also included in the map
122     mapping (address => Checkpoint[]) balances;
123 
124     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
125     mapping (address => mapping (address => uint256)) allowed;
126 
127     // Tracks the history of the `totalSupply` of the token
128     Checkpoint[] totalSupplyHistory;
129 
130     // Flag that determines if the token is transferable or not.
131     bool public transfersEnabled;
132 
133     // Tracks the history of the `pledgedFees` belonging to token holders
134     Checkpoint[] totalPledgedFeesHistory; // in wei
135 
136     // The factory used to create new clone tokens
137     MiniMeTokenFactory public tokenFactory;
138 
139 ////////////////
140 // Constructor
141 ////////////////
142 
143     /// @notice Constructor to create a MiniMeToken
144     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
145     ///  will create the Clone token contracts, the token factory needs to be
146     ///  deployed first
147     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
148     ///  new token
149     /// @param _parentSnapShotBlock Block of the parent token that will
150     ///  determine the initial distribution of the clone token, set to 0 if it
151     ///  is a new token
152     /// @param _tokenName Name of the new token
153     /// @param _decimalUnits Number of decimals of the new token
154     /// @param _tokenSymbol Token Symbol for the new token
155     /// @param _transfersEnabled If true, tokens will be able to be transferred
156     constructor(
157         address _tokenFactory,
158         address payable _parentToken,
159         uint _parentSnapShotBlock,
160         string memory _tokenName,
161         uint8 _decimalUnits,
162         string memory _tokenSymbol,
163         bool _transfersEnabled
164     ) public {
165         tokenFactory = MiniMeTokenFactory(_tokenFactory);
166         name = _tokenName;                                 // Set the name
167         decimals = _decimalUnits;                          // Set the decimals
168         symbol = _tokenSymbol;                             // Set the symbol
169         parentToken = MiniMeToken(_parentToken);
170         parentSnapShotBlock = _parentSnapShotBlock;
171         transfersEnabled = _transfersEnabled;
172         creationBlock = block.number;
173     }
174 
175 
176 ///////////////////
177 // ERC20 Methods
178 ///////////////////
179 
180     uint constant MAX_UINT = 2**256 - 1;
181 
182     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
183     /// @param _to The address of the recipient
184     /// @param _amount The amount of tokens to be transferred
185     /// @return Whether the transfer was successful or not
186     function transfer(address _to, uint256 _amount) public returns (bool success) {
187         require(transfersEnabled);
188         doTransfer(msg.sender, _to, _amount);
189         return true;
190     }
191 
192     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
193     ///  is approved by `_from`
194     /// @param _from The address holding the tokens being transferred
195     /// @param _to The address of the recipient
196     /// @param _amount The amount of tokens to be transferred
197     /// @return True if the transfer was successful
198     function transferFrom(address _from, address _to, uint256 _amount
199     ) public returns (bool success) {
200 
201         // The controller of this contract can move tokens around at will,
202         //  this is important to recognize! Confirm that you trust the
203         //  controller of this contract, which in most situations should be
204         //  another open source smart contract or 0x0
205         if (msg.sender != controller) {
206             require(transfersEnabled);
207 
208             // The standard ERC 20 transferFrom functionality
209             if (allowed[_from][msg.sender] < MAX_UINT) {
210                 require(allowed[_from][msg.sender] >= _amount);
211                 allowed[_from][msg.sender] -= _amount;
212             }
213         }
214         doTransfer(_from, _to, _amount);
215         return true;
216     }
217 
218     /// @dev This is the actual transfer function in the token contract, it can
219     ///  only be called by other functions in this contract.
220     /// @param _from The address holding the tokens being transferred
221     /// @param _to The address of the recipient
222     /// @param _amount The amount of tokens to be transferred
223     /// @return True if the transfer was successful
224     function doTransfer(address _from, address _to, uint _amount
225     ) internal {
226 
227            if (_amount == 0) {
228                emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
229                return;
230            }
231 
232            require(parentSnapShotBlock < block.number);
233 
234            // Do not allow transfer to 0x0 or the token contract itself
235            require((_to != address(0)) && (_to != address(this)));
236 
237            // If the amount being transfered is more than the balance of the
238            //  account the transfer throws
239            uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
240 
241            require(previousBalanceFrom >= _amount);
242 
243            // Alerts the token controller of the transfer
244            if (isContract(controller)) {
245                require(TokenController(controller).onTransfer(_from, _to, _amount));
246            }
247 
248            // First update the balance array with the new value for the address
249            //  sending the tokens
250            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
251 
252            // Then update the balance array with the new value for the address
253            //  receiving the tokens
254            uint256 previousBalanceTo = balanceOfAt(_to, block.number);
255            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
256            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
257 
258            // An event to make the transfer easy to find on the blockchain
259            emit Transfer(_from, _to, _amount);
260 
261     }
262 
263     /// @param _owner The address that's balance is being requested
264     /// @return The balance of `_owner` at the current block
265     function balanceOf(address _owner) public view returns (uint256 balance) {
266         return balanceOfAt(_owner, block.number);
267     }
268 
269     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
270     ///  its behalf. This is a modified version of the ERC20 approve function
271     ///  to be a little bit safer
272     /// @param _spender The address of the account able to transfer the tokens
273     /// @param _amount The amount of tokens to be approved for transfer
274     /// @return True if the approval was successful
275     function approve(address _spender, uint256 _amount) public returns (bool success) {
276         require(transfersEnabled);
277 
278         // To change the approve amount you first have to reduce the addresses`
279         //  allowance to zero by calling `approve(_spender,0)` if it is not
280         //  already 0 to mitigate the race condition described here:
281         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
282         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
283 
284         // Alerts the token controller of the approve function call
285         if (isContract(controller)) {
286             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
287         }
288 
289         allowed[msg.sender][_spender] = _amount;
290         emit Approval(msg.sender, _spender, _amount);
291         return true;
292     }
293 
294     /// @dev This function makes it easy to read the `allowed[]` map
295     /// @param _owner The address of the account that owns the token
296     /// @param _spender The address of the account able to transfer the tokens
297     /// @return Amount of remaining tokens of _owner that _spender is allowed
298     ///  to spend
299     function allowance(address _owner, address _spender
300     ) public view returns (uint256 remaining) {
301         return allowed[_owner][_spender];
302     }
303 
304     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
305     ///  its behalf, and then a function is triggered in the contract that is
306     ///  being approved, `_spender`. This allows users to use their tokens to
307     ///  interact with contracts in one function call instead of two
308     /// @param _spender The address of the contract able to transfer the tokens
309     /// @param _amount The amount of tokens to be approved for transfer
310     /// @return True if the function call was successful
311     function approveAndCall(address _spender, uint256 _amount, bytes memory _extraData
312     ) public returns (bool success) {
313         require(approve(_spender, _amount));
314 
315         ApproveAndCallFallBack(_spender).receiveApproval(
316             msg.sender,
317             _amount,
318             address(this),
319             _extraData
320         );
321 
322         return true;
323     }
324 
325     /// @dev This function makes it easy to get the total number of tokens
326     /// @return The total number of tokens
327     function totalSupply() public view returns (uint) {
328         return totalSupplyAt(block.number);
329     }
330 
331 
332 ////////////////
333 // Query balance and totalSupply in History
334 ////////////////
335 
336     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
337     /// @param _owner The address from which the balance will be retrieved
338     /// @param _blockNumber The block number when the balance is queried
339     /// @return The balance at `_blockNumber`
340     function balanceOfAt(address _owner, uint _blockNumber) public view
341         returns (uint) {
342 
343         // These next few lines are used when the balance of the token is
344         //  requested before a check point was ever created for this token, it
345         //  requires that the `parentToken.balanceOfAt` be queried at the
346         //  genesis block for that token as this contains initial balance of
347         //  this token
348         if ((balances[_owner].length == 0)
349             || (balances[_owner][0].fromBlock > _blockNumber)) {
350             if (address(parentToken) != address(0)) {
351                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
352             } else {
353                 // Has no parent
354                 return 0;
355             }
356 
357         // This will return the expected balance during normal situations
358         } else {
359             return getValueAt(balances[_owner], _blockNumber);
360         }
361     }
362 
363     /// @notice Total amount of tokens at a specific `_blockNumber`.
364     /// @param _blockNumber The block number when the totalSupply is queried
365     /// @return The total amount of tokens at `_blockNumber`
366     function totalSupplyAt(uint _blockNumber) public view returns(uint) {
367 
368         // These next few lines are used when the totalSupply of the token is
369         //  requested before a check point was ever created for this token, it
370         //  requires that the `parentToken.totalSupplyAt` be queried at the
371         //  genesis block for this token as that contains totalSupply of this
372         //  token at this block number.
373         if ((totalSupplyHistory.length == 0)
374             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
375             if (address(parentToken) != address(0)) {
376                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
377             } else {
378                 return 0;
379             }
380 
381         // This will return the expected totalSupply during normal situations
382         } else {
383             return getValueAt(totalSupplyHistory, _blockNumber);
384         }
385     }
386 
387 ////////////////
388 // Query pledgedFees // in wei
389 ////////////////
390 
391    /// @dev This function makes it easy to get the total pledged fees
392    /// @return The total number of fees belonging to token holders
393    function totalPledgedFees() public view returns (uint) {
394        return totalPledgedFeesAt(block.number);
395    }
396 
397    /// @notice Total amount of fees at a specific `_blockNumber`.
398    /// @param _blockNumber The block number when the totalPledgedFees is queried
399    /// @return The total amount of pledged fees at `_blockNumber`
400    function totalPledgedFeesAt(uint _blockNumber) public view returns(uint) {
401 
402        // These next few lines are used when the totalPledgedFees of the token is
403        //  requested before a check point was ever created for this token, it
404        //  requires that the `parentToken.totalPledgedFeesAt` be queried at the
405        //  genesis block for this token as that contains totalPledgedFees of this
406        //  token at this block number.
407        if ((totalPledgedFeesHistory.length == 0)
408            || (totalPledgedFeesHistory[0].fromBlock > _blockNumber)) {
409            if (address(parentToken) != address(0)) {
410                return parentToken.totalPledgedFeesAt(min(_blockNumber, parentSnapShotBlock));
411            } else {
412                return 0;
413            }
414 
415        // This will return the expected totalPledgedFees during normal situations
416        } else {
417            return getValueAt(totalPledgedFeesHistory, _blockNumber);
418        }
419    }
420 
421 ////////////////
422 // Pledge Fees To Token Holders or Reduce Pledged Fees // in wei
423 ////////////////
424 
425    /// @notice Pledges fees to the token holders, later to be claimed by burning
426    /// @param _value The amount sent to the vault by controller, reserved for token holders
427    function pledgeFees(uint _value) public onlyController returns (bool) {
428        uint curTotalFees = totalPledgedFees();
429        require(curTotalFees + _value >= curTotalFees); // Check for overflow
430        updateValueAtNow(totalPledgedFeesHistory, curTotalFees + _value);
431        return true;
432    }
433 
434    /// @notice Reduces pledged fees to the token holders, i.e. during upgrade or token burning
435    /// @param _value The amount of pledged fees which are being distributed to token holders, reducing liability
436    function reducePledgedFees(uint _value) public onlyController returns (bool) {
437        uint curTotalFees = totalPledgedFees();
438        require(curTotalFees >= _value);
439        updateValueAtNow(totalPledgedFeesHistory, curTotalFees - _value);
440        return true;
441    }
442 
443 ////////////////
444 // Clone Token Method
445 ////////////////
446 
447     /// @notice Creates a new clone token with the initial distribution being
448     ///  this token at `_snapshotBlock`
449     /// @param _cloneTokenName Name of the clone token
450     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
451     /// @param _cloneTokenSymbol Symbol of the clone token
452     /// @param _snapshotBlock Block when the distribution of the parent token is
453     ///  copied to set the initial distribution of the new clone token;
454     ///  if the block is zero than the actual block, the current block is used
455     /// @param _transfersEnabled True if transfers are allowed in the clone
456     /// @return The address of the new MiniMeToken Contract
457     function createCloneToken(
458         string memory _cloneTokenName,
459         uint8 _cloneDecimalUnits,
460         string memory _cloneTokenSymbol,
461         uint _snapshotBlock,
462         bool _transfersEnabled
463         ) public returns(address) {
464         if (_snapshotBlock == 0) _snapshotBlock = block.number;
465         MiniMeToken cloneToken = tokenFactory.createCloneToken(
466             address(this),
467             _snapshotBlock,
468             _cloneTokenName,
469             _cloneDecimalUnits,
470             _cloneTokenSymbol,
471             _transfersEnabled
472             );
473 
474         cloneToken.changeController(msg.sender);
475 
476         // An event to make the token easy to find on the blockchain
477         emit NewCloneToken(address(cloneToken), _snapshotBlock);
478         return address(cloneToken);
479     }
480 
481 ////////////////
482 // Generate and destroy tokens
483 ////////////////
484 
485     /// @notice Generates `_amount` tokens that are assigned to `_owner`
486     /// @param _owner The address that will be assigned the new tokens
487     /// @param _amount The quantity of tokens generated
488     /// @return True if the tokens are generated correctly
489     function generateTokens(address _owner, uint _amount
490     ) public onlyController returns (bool) {
491         uint curTotalSupply = totalSupply();
492         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
493         uint previousBalanceTo = balanceOf(_owner);
494         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
495         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
496         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
497         emit Transfer(address(0), _owner, _amount);
498         return true;
499     }
500 
501 
502     /// @notice Burns `_amount` tokens from `_owner`
503     /// @param _owner The address that will lose the tokens
504     /// @param _amount The quantity of tokens to burn
505     /// @return True if the tokens are burned correctly
506     function destroyTokens(address _owner, uint _amount
507     ) onlyController public returns (bool) {
508         uint curTotalSupply = totalSupply();
509         require(curTotalSupply >= _amount);
510         uint previousBalanceFrom = balanceOf(_owner);
511         require(previousBalanceFrom >= _amount);
512         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
513         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
514         emit Transfer(_owner, address(0), _amount);
515         return true;
516     }
517 
518 ////////////////
519 // Enable tokens transfers
520 ////////////////
521 
522 
523     /// @notice Enables token holders to transfer their tokens freely if true
524     /// @param _transfersEnabled True if transfers are allowed in the clone
525     function enableTransfers(bool _transfersEnabled) public onlyController {
526         transfersEnabled = _transfersEnabled;
527     }
528 
529 ////////////////
530 // Internal helper functions to query and set a value in a snapshot array
531 ////////////////
532 
533     /// @dev `getValueAt` retrieves the number of tokens at a given block number
534     /// @param checkpoints The history of values being queried
535     /// @param _block The block number to retrieve the value at
536     /// @return The number of tokens being queried
537     function getValueAt(Checkpoint[] storage checkpoints, uint _block
538     ) view internal returns (uint) {
539         if (checkpoints.length == 0) return 0;
540 
541         // Shortcut for the actual value
542         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
543             return checkpoints[checkpoints.length-1].value;
544         if (_block < checkpoints[0].fromBlock) return 0;
545 
546         // Binary search of the value in the array
547         uint min = 0;
548         uint max = checkpoints.length-1;
549         while (max > min) {
550             uint mid = (max + min + 1)/ 2;
551             if (checkpoints[mid].fromBlock<=_block) {
552                 min = mid;
553             } else {
554                 max = mid-1;
555             }
556         }
557         return checkpoints[min].value;
558     }
559 
560     /// @dev `updateValueAtNow` used to update the `balances` map and the
561     ///  `totalSupplyHistory`
562     /// @param checkpoints The history of data being updated
563     /// @param _value The new number of tokens
564     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
565     ) internal  {
566         if ((checkpoints.length == 0)
567         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
568                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
569                newCheckPoint.fromBlock =  uint128(block.number);
570                newCheckPoint.value = uint128(_value);
571            } else {
572                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
573                oldCheckPoint.value = uint128(_value);
574            }
575     }
576 
577     /// @dev Internal function to determine if an address is a contract
578     /// @param _addr The address being queried
579     /// @return True if `_addr` is a contract
580     function isContract(address _addr) view internal returns(bool) {
581         uint size;
582         if (_addr == address(0)) return false;
583         assembly {
584             size := extcodesize(_addr)
585         }
586         return size>0;
587     }
588 
589     /// @dev Helper function to return a min betwen the two uints
590     function min(uint a, uint b) pure internal returns (uint) {
591         return a < b ? a : b;
592     }
593 
594     /// @notice The fallback function: If the contract's controller has not been
595     ///  set to 0, then the `proxyPayment` method is called which relays the
596     ///  ether and creates tokens as described in the token controller contract
597     function () external payable {
598         require(isContract(controller));
599         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
600     }
601 
602 
603 ////////////////
604 // Events
605 ////////////////
606     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
607     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
608     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
609     event Approval(
610         address indexed _owner,
611         address indexed _spender,
612         uint256 _amount
613         );
614 
615 }
616 
617 
618 ////////////////
619 // MiniMeTokenFactory
620 ////////////////
621 
622 /// @dev This contract is used to generate clone contracts from a contract.
623 ///  In solidity this is the way to create a contract from a contract of the
624 ///  same class
625 contract MiniMeTokenFactory {
626 
627     /// @notice Update the DApp by creating a new token with new functionalities
628     ///  the msg.sender becomes the controller of this clone token
629     /// @param _parentToken Address of the token being cloned
630     /// @param _snapshotBlock Block of the parent token that will
631     ///  determine the initial distribution of the clone token
632     /// @param _tokenName Name of the new token
633     /// @param _decimalUnits Number of decimals of the new token
634     /// @param _tokenSymbol Token Symbol for the new token
635     /// @param _transfersEnabled If true, tokens will be able to be transferred
636     /// @return The address of the new token contract
637     function createCloneToken(
638         address payable _parentToken,
639         uint _snapshotBlock,
640         string memory _tokenName,
641         uint8 _decimalUnits,
642         string memory _tokenSymbol,
643         bool _transfersEnabled
644     ) public returns (MiniMeToken) {
645         MiniMeToken newToken = new MiniMeToken(
646             address(this),
647             _parentToken,
648             _snapshotBlock,
649             _tokenName,
650             _decimalUnits,
651             _tokenSymbol,
652             _transfersEnabled
653             );
654 
655         newToken.changeController(msg.sender);
656         return newToken;
657     }
658   }
659 
660 
661 
662 /*
663     Copyright 2017, Will Harborne (Ethfinex)
664 */
665 
666 contract DestructibleMiniMeToken is MiniMeToken {
667 
668     address payable public terminator;
669 
670     constructor(
671         address _tokenFactory,
672         address payable _parentToken,
673         uint _parentSnapShotBlock,
674         string memory _tokenName,
675         uint8 _decimalUnits,
676         string memory _tokenSymbol,
677         bool _transfersEnabled,
678         address payable _terminator
679     ) public MiniMeToken(
680         _tokenFactory,
681         _parentToken,
682         _parentSnapShotBlock,
683         _tokenName,
684         _decimalUnits,
685         _tokenSymbol,
686         _transfersEnabled
687     ) {
688         terminator = _terminator;
689     }
690 
691     function recycle() public {
692         require(msg.sender == terminator);
693         selfdestruct(terminator);
694     }
695 }
696 
697 
698 
699 contract DestructibleMiniMeTokenFactory {
700 
701     /// @notice Update the DApp by creating a new token with new functionalities
702     ///  the msg.sender becomes the controller of this clone token
703     /// @param _parentToken Address of the token being cloned
704     /// @param _snapshotBlock Block of the parent token that will
705     ///  determine the initial distribution of the clone token
706     /// @param _tokenName Name of the new token
707     /// @param _decimalUnits Number of decimals of the new token
708     /// @param _tokenSymbol Token Symbol for the new token
709     /// @param _transfersEnabled If true, tokens will be able to be transferred
710     /// @return The address of the new token contract
711     function createDestructibleCloneToken(
712         address payable _parentToken,
713         uint _snapshotBlock,
714         string memory _tokenName,
715         uint8 _decimalUnits,
716         string memory _tokenSymbol,
717         bool _transfersEnabled
718     ) public returns (DestructibleMiniMeToken) {
719         DestructibleMiniMeToken newToken = new DestructibleMiniMeToken(
720             address(this),
721             _parentToken,
722             _snapshotBlock,
723             _tokenName,
724             _decimalUnits,
725             _tokenSymbol,
726             _transfersEnabled,
727             msg.sender
728         );
729 
730         newToken.changeController(msg.sender);
731         return newToken;
732     }
733 }
734 
735 
736 contract Ownable {
737 
738   address public owner;
739 
740   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
741 
742   constructor() public {
743     owner = msg.sender;
744   }
745 
746   modifier onlyOwner() {
747     require(msg.sender == owner);
748     _;
749   }
750 
751   function transferOwnership(address newOwner) public onlyOwner {
752     require(newOwner != address(0));
753     emit OwnershipTransferred(owner, newOwner);
754     owner = newOwner;
755   }
756 
757 }
758 
759 /*
760     Copyright 2018, Will Harborne @ Ethfinex
761 */
762 
763 /// @title TokenListingManager Contract
764 /// @author Will Harborne @ Ethfinex
765 contract TokenListingManager is Ownable {
766 
767     address public constant NECTAR_TOKEN = 0xCc80C051057B774cD75067Dc48f8987C4Eb97A5e;
768     address public constant TOKEN_FACTORY = 0x8936131A81F29205EeDDec486f401A8A0aFAb15A;
769     uint public constant MAX_CANDIDATES = 20;
770 
771     struct TokenProposal {
772         address[] consideredTokens;
773         uint startBlock;
774         uint startTime;
775         uint duration;
776         DestructibleMiniMeToken votingToken;
777         uint[] yesVotes;
778         // criteria values
779         // 0. only first one win the vote;
780         // 1. top N (number in extraData) win the vote;
781         // 2. All over N (number in extra data) votes win the vote;
782         uint criteria;
783         uint extraData;
784         bool concluded;
785         mapping(address => mapping(address => uint256)) votesForToken;
786     }
787 
788     TokenProposal[] public tokenBatches;
789 
790     DestructibleMiniMeTokenFactory public tokenFactory;
791     address payable public nectarToken;
792     mapping(address => bool) public admins;
793 
794     mapping(address => bool) public isWinner;
795     mapping(address => uint256) public winningVotes;
796     mapping(address => uint) public proposalWhenTokenWon;
797 
798     modifier onlyAdmins() {
799         require(isAdmin(msg.sender));
800         _;
801     }
802 
803     constructor(address _tokenFactory, address payable _nectarToken) public {
804         tokenFactory = DestructibleMiniMeTokenFactory(_tokenFactory);
805         nectarToken = _nectarToken;
806         admins[msg.sender] = true;
807     }
808 
809     /// @notice Admins are able to approve proposal that someone submitted
810     /// @param _tokens the list of tokens in consideration during this period
811     /// @param _duration number of days for vote token to exist. Second half is for voting.
812     /// @param _criteria number that determines how winner is selected
813     /// @param _extraData extra data for criteria parameter
814     function startTokenVotes(address[] memory _tokens, uint _duration, uint _criteria, uint _extraData) public onlyAdmins {
815         require(_tokens.length <= MAX_CANDIDATES);
816 
817         if (_criteria == 1) {
818             // in other case all tokens would be winners
819             require(_extraData < _tokens.length);
820         }
821 
822         uint _proposalId = tokenBatches.length;
823         if (_proposalId > 0) {
824           endTokenVote(_proposalId - 1);
825         }
826         tokenBatches.length++;
827         TokenProposal storage p = tokenBatches[_proposalId];
828         p.duration = _duration * (1 days);
829 
830         p.consideredTokens = _tokens;
831         p.yesVotes = new uint[](_tokens.length);
832 
833         p.votingToken = tokenFactory.createDestructibleCloneToken(
834                 nectarToken,
835                 getBlockNumber(),
836                 appendUintToString("EfxTokenVotes-", _proposalId),
837                 MiniMeToken(nectarToken).decimals(),
838                 appendUintToString("EVT-", _proposalId),
839                 true);
840 
841         p.startTime = now;
842         p.startBlock = getBlockNumber();
843         p.criteria = _criteria;
844         p.extraData = _extraData;
845         p.concluded = false;
846 
847         emit NewTokens(_proposalId);
848     }
849 
850 
851     /// @notice Anyone can end the vote if it has completed
852     function endTokenVote(uint _proposalId) public returns(bool) {
853 
854         require(_proposalId <= tokenBatches.length);
855 
856         TokenProposal storage op = tokenBatches[_proposalId];
857         require(op.startTime + op.duration < now);
858         if (op.concluded) {
859           return true;
860         }
861 
862         uint[] memory _previousWinnerMap = getWinnerIndices(_proposalId);
863         for (uint i=0; i < _previousWinnerMap.length; i++) {
864             isWinner[op.consideredTokens[_previousWinnerMap[i]]] = true;
865             winningVotes[op.consideredTokens[_previousWinnerMap[i]]] = op.yesVotes[_previousWinnerMap[i]];
866             proposalWhenTokenWon[op.consideredTokens[_previousWinnerMap[i]]] = _proposalId;
867         }
868 
869         DestructibleMiniMeToken(op.votingToken).recycle();
870         op.concluded = true;
871         return true;
872     }
873 
874     /// @notice Vote for specific token with yes
875     /// @param _proposalId is the proposal's position in tokenBatches array
876     /// @param _tokenIndex is the position from 0-11 in the token array of the chosen token
877     function vote(uint _proposalId, uint _tokenIndex, uint _amount) public {
878         // voting only on the most recent set of proposed tokens
879         require(tokenBatches.length > 0);
880         require(_proposalId == tokenBatches.length - 1);
881         require(_tokenIndex < 12);
882 
883         TokenProposal storage p = tokenBatches[_proposalId];
884 
885         require(now > p.startTime + (p.duration / 2));
886         require(now < p.startTime + p.duration);
887 
888         uint amount = DestructibleMiniMeToken(p.votingToken).balanceOf(msg.sender);
889         require(amount >= _amount);
890 
891         uint weightedAmount = getFactor(_amount);
892 
893         require(DestructibleMiniMeToken(p.votingToken).transferFrom(msg.sender, address(this), _amount));
894 
895         tokenBatches[_proposalId].yesVotes[_tokenIndex] += weightedAmount;
896         p.votesForToken[tokenBatches[_proposalId].consideredTokens[_tokenIndex]][msg.sender] += weightedAmount;
897 
898         emit Vote(_proposalId, msg.sender, tokenBatches[_proposalId].consideredTokens[_tokenIndex], weightedAmount);
899     }
900 
901     function getFactor(uint _amount) view public returns (uint weighted) {
902       require(tokenBatches.length > 0);
903       uint currentRound = tokenBatches.length - 1;
904       TokenProposal memory p = tokenBatches[currentRound];
905       if ((now - p.startTime) < (p.duration / 2)) {
906           weighted = 2 * _amount;
907       } else {
908           weighted = 2 * _amount - ((now - ((p.duration / 2) + p.startTime)) * _amount / (p.duration / 2));
909       }
910     }
911 
912     function getWinnerIndices(uint _proposalId) public view returns(uint[] memory winners) {
913         require(_proposalId < tokenBatches.length);
914 
915         TokenProposal memory p = tokenBatches[_proposalId];
916 
917         // there is only one winner in criteria 0
918         if (p.criteria == 0) {
919             winners = new uint[](1);
920             uint max = 0;
921 
922             for (uint i=0; i < p.consideredTokens.length; i++) {
923                 if (p.yesVotes[i] > p.yesVotes[max]) {
924                     max = i;
925                 }
926             }
927 
928             winners[0] = max;
929         }
930 
931         // there is N winners in criteria 1
932         if (p.criteria == 1) {
933             uint[] memory indexesWithMostVotes = new uint[](p.extraData);
934             winners = new uint[](p.extraData);
935 
936             // for each token we check if he has more votes than last one,
937             // if it has we put it in array and always keep array sorted
938             for (uint i = 0; i < p.consideredTokens.length; i++) {
939                 uint last = p.extraData - 1;
940                 if (p.yesVotes[i] > p.yesVotes[indexesWithMostVotes[last]]) {
941                     indexesWithMostVotes[last] = i;
942 
943                     for (uint j=last; j > 0; j--) {
944                         if (p.yesVotes[indexesWithMostVotes[j]] > p.yesVotes[indexesWithMostVotes[j-1]]) {
945                             uint help = indexesWithMostVotes[j];
946                             indexesWithMostVotes[j] = indexesWithMostVotes[j-1];
947                             indexesWithMostVotes[j-1] = help;
948                         }
949                     }
950                 }
951             }
952 
953             for (uint i = 0; i < p.extraData; i++) {
954                 winners[i] = indexesWithMostVotes[i];
955             }
956         }
957 
958         // everybody who has over N votes are winners in criteria 2
959         if (p.criteria == 2) {
960             uint numOfTokens = 0;
961             for (uint i = 0; i < p.consideredTokens.length; i++) {
962                 if (p.yesVotes[i] > p.extraData) {
963                     numOfTokens++;
964                 }
965             }
966 
967             winners = new uint[](numOfTokens);
968             uint count = 0;
969             for (uint i = 0; i < p.consideredTokens.length; i++) {
970                 if (p.yesVotes[i] > p.extraData) {
971                     winners[count] = i;
972                     count++;
973                 }
974             }
975         }
976     }
977 
978     function getUserVotesForWinner(address _token, address _voter) external view returns(uint256) {
979       uint roundWhenWon = proposalWhenTokenWon[_token];
980       return tokenBatches[roundWhenWon].votesForToken[_token][_voter];
981     }
982 
983     /// @notice Get number of proposals so you can know which is the last one
984     function numberOfProposals() public view returns(uint) {
985         return tokenBatches.length;
986     }
987 
988     /// @notice Any admin is able to add new admin
989     /// @param _newAdmin Address of new admin
990     function addAdmin(address _newAdmin) public onlyAdmins {
991         admins[_newAdmin] = true;
992     }
993 
994     /// @notice Only owner is able to remove admin
995     /// @param _admin Address of current admin
996     function removeAdmin(address _admin) public onlyOwner {
997         admins[_admin] = false;
998     }
999 
1000     /// @notice Get data about specific proposal
1001     /// @param _proposalId Id of proposal
1002     function proposal(uint _proposalId) public view returns(
1003         uint _startBlock,
1004         uint _startTime,
1005         uint _duration,
1006         bool _active,
1007         bool _finalized,
1008         uint[] memory _votes,
1009         address[] memory _tokens,
1010         address _votingToken,
1011         bool _hasBalance
1012     ) {
1013         require(_proposalId < tokenBatches.length);
1014 
1015         TokenProposal memory p = tokenBatches[_proposalId];
1016         _startBlock = p.startBlock;
1017         _startTime = p.startTime;
1018         _duration = p.duration;
1019         _finalized = (_startTime+_duration < now);
1020         _active = !_finalized && (p.startBlock < getBlockNumber());
1021         _votes = p.yesVotes;
1022         _tokens = p.consideredTokens;
1023         _votingToken = address(p.votingToken);
1024         _hasBalance = (_votingToken == address(0)) ? false : (DestructibleMiniMeToken(p.votingToken).balanceOf(msg.sender) > 0);
1025     }
1026 
1027     function isAdmin(address _admin) public view returns(bool) {
1028         return admins[_admin];
1029     }
1030 
1031     function proxyPayment(address ) public payable returns(bool) {
1032         return false;
1033     }
1034 
1035     function onTransfer(address, address, uint ) public pure returns(bool) {
1036         return true;
1037     }
1038 
1039     function onApprove(address, address, uint ) public pure returns(bool) {
1040         return true;
1041     }
1042 
1043     function getBlockNumber() internal view returns (uint) {
1044         return block.number;
1045     }
1046 
1047     function appendUintToString(string memory inStr, uint _i) internal pure returns (string memory _str) {
1048     if (_i == 0) {
1049         return string(abi.encodePacked(inStr, "0"));
1050     }
1051     uint j = _i;
1052     uint len;
1053     while (j != 0) {
1054         len++;
1055         j /= 10;
1056     }
1057     bytes memory bstr = new bytes(len);
1058     uint k = len - 1;
1059     while (_i != 0) {
1060         bstr[k--] = byte(uint8(48 + _i % 10));
1061         _i /= 10;
1062     }
1063 
1064     return string(abi.encodePacked(inStr, string(bstr)));
1065     }
1066 
1067     event Vote(uint indexed idProposal, address indexed _voter, address chosenToken, uint amount);
1068     event NewTokens(uint indexed idProposal);
1069 }