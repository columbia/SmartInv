1 pragma solidity ^0.5.0;
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
28 contract Controlled {
29     /// @notice The address of the controller is the only address that can call
30     ///  a function with this modifier
31     modifier onlyController { require(msg.sender == controller); _; }
32 
33     address public controller;
34 
35     constructor() public { controller = msg.sender;}
36 
37     /// @notice Changes the controller of the contract
38     /// @param _newController The new controller of the contract
39     function changeController(address _newController) public onlyController {
40         controller = _newController;
41     }
42 }
43 
44 contract TokenController {
45     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
46     /// @param _owner The address that sent the ether to create tokens
47     /// @return True if the ether is accepted, false if it throws
48     function proxyPayment(address _owner) public payable returns(bool);
49 
50     /// @notice Notifies the controller about a token transfer allowing the
51     ///  controller to react if desired
52     /// @param _from The origin of the transfer
53     /// @param _to The destination of the transfer
54     /// @param _amount The amount of the transfer
55     /// @return False if the controller does not authorize the transfer
56     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
57 
58     /// @notice Notifies the controller about an approval allowing the
59     ///  controller to react if desired
60     /// @param _owner The address that calls `approve()`
61     /// @param _spender The spender in the `approve()` call
62     /// @param _amount The amount in the `approve()` call
63     /// @return False if the controller does not authorize the approval
64     function onApprove(address _owner, address _spender, uint _amount) public
65         returns(bool);
66 
67     /// @notice Notifies the controller about a token burn
68     /// @param _owner The address of the burner
69     /// @param _amount The amount to burn
70     /// @return False if the controller does not authorize the burn
71     function onBurn(address payable _owner, uint _amount) public returns(bool);
72 }
73 
74 
75 contract ApproveAndCallFallBack {
76     function receiveApproval(address from, uint256 _amount, address _token, bytes memory _data) public;
77 }
78 
79 /// @dev The actual token contract, the default controller is the msg.sender
80 ///  that deploys the contract, so usually this token will be deployed by a
81 ///  token controller contract, which Giveth will call a "Campaign"
82 /// @dev The actual token contract, the default controller is the msg.sender
83 ///  that deploys the contract, so usually this token will be deployed by a
84 ///  token controller contract, which Giveth will call a "Campaign"
85 contract MiniMeToken is Controlled {
86 
87     string public name;                //The Token's name: e.g. DigixDAO Tokens
88     uint8 public decimals;             //Number of decimals of the smallest unit
89     string public symbol;              //An identifier: e.g. REP
90     string public version = 'EFX_0.1'; //An arbitrary versioning scheme
91 
92 
93     /// @dev `Checkpoint` is the structure that attaches a block number to a
94     ///  given value, the block number attached is the one that last changed the
95     ///  value
96     struct  Checkpoint {
97 
98         // `fromBlock` is the block number that the value was generated from
99         uint128 fromBlock;
100 
101         // `value` is the amount of tokens at a specific block number
102         uint128 value;
103     }
104 
105     // `parentToken` is the Token address that was cloned to produce this token;
106     //  it will be 0x0 for a token that was not cloned
107     MiniMeToken public parentToken;
108 
109     // `parentSnapShotBlock` is the block number from the Parent Token that was
110     //  used to determine the initial distribution of the Clone Token
111     uint public parentSnapShotBlock;
112 
113     // `creationBlock` is the block number that the Clone Token was created
114     uint public creationBlock;
115 
116     // `balances` is the map that tracks the balance of each address, in this
117     //  contract when the balance changes the block number that the change
118     //  occurred is also included in the map
119     mapping (address => Checkpoint[]) balances;
120 
121     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
122     mapping (address => mapping (address => uint256)) allowed;
123 
124     // Tracks the history of the `totalSupply` of the token
125     Checkpoint[] totalSupplyHistory;
126 
127     // Flag that determines if the token is transferable or not.
128     bool public transfersEnabled;
129 
130     // Tracks the history of the `pledgedFees` belonging to token holders
131     Checkpoint[] totalPledgedFeesHistory; // in wei
132 
133     // The factory used to create new clone tokens
134     MiniMeTokenFactory public tokenFactory;
135 
136 ////////////////
137 // Constructor
138 ////////////////
139 
140     /// @notice Constructor to create a MiniMeToken
141     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
142     ///  will create the Clone token contracts, the token factory needs to be
143     ///  deployed first
144     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
145     ///  new token
146     /// @param _parentSnapShotBlock Block of the parent token that will
147     ///  determine the initial distribution of the clone token, set to 0 if it
148     ///  is a new token
149     /// @param _tokenName Name of the new token
150     /// @param _decimalUnits Number of decimals of the new token
151     /// @param _tokenSymbol Token Symbol for the new token
152     /// @param _transfersEnabled If true, tokens will be able to be transferred
153     constructor(
154         address _tokenFactory,
155         address payable _parentToken,
156         uint _parentSnapShotBlock,
157         string memory _tokenName,
158         uint8 _decimalUnits,
159         string memory _tokenSymbol,
160         bool _transfersEnabled
161     ) public {
162         tokenFactory = MiniMeTokenFactory(_tokenFactory);
163         name = _tokenName;                                 // Set the name
164         decimals = _decimalUnits;                          // Set the decimals
165         symbol = _tokenSymbol;                             // Set the symbol
166         parentToken = MiniMeToken(_parentToken);
167         parentSnapShotBlock = _parentSnapShotBlock;
168         transfersEnabled = _transfersEnabled;
169         creationBlock = block.number;
170     }
171 
172 
173 ///////////////////
174 // ERC20 Methods
175 ///////////////////
176 
177     uint constant MAX_UINT = 2**256 - 1;
178 
179     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
180     /// @param _to The address of the recipient
181     /// @param _amount The amount of tokens to be transferred
182     /// @return Whether the transfer was successful or not
183     function transfer(address _to, uint256 _amount) public returns (bool success) {
184         require(transfersEnabled);
185         doTransfer(msg.sender, _to, _amount);
186         return true;
187     }
188 
189     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
190     ///  is approved by `_from`
191     /// @param _from The address holding the tokens being transferred
192     /// @param _to The address of the recipient
193     /// @param _amount The amount of tokens to be transferred
194     /// @return True if the transfer was successful
195     function transferFrom(address _from, address _to, uint256 _amount
196     ) public returns (bool success) {
197 
198         // The controller of this contract can move tokens around at will,
199         //  this is important to recognize! Confirm that you trust the
200         //  controller of this contract, which in most situations should be
201         //  another open source smart contract or 0x0
202         if (msg.sender != controller) {
203             require(transfersEnabled);
204 
205             // The standard ERC 20 transferFrom functionality
206             if (allowed[_from][msg.sender] < MAX_UINT) {
207                 require(allowed[_from][msg.sender] >= _amount);
208                 allowed[_from][msg.sender] -= _amount;
209             }
210         }
211         doTransfer(_from, _to, _amount);
212         return true;
213     }
214 
215     /// @dev This is the actual transfer function in the token contract, it can
216     ///  only be called by other functions in this contract.
217     /// @param _from The address holding the tokens being transferred
218     /// @param _to The address of the recipient
219     /// @param _amount The amount of tokens to be transferred
220     /// @return True if the transfer was successful
221     function doTransfer(address _from, address _to, uint _amount
222     ) internal {
223 
224            if (_amount == 0) {
225                emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
226                return;
227            }
228 
229            require(parentSnapShotBlock < block.number);
230 
231            // Do not allow transfer to 0x0 or the token contract itself
232            require((_to != address(0)) && (_to != address(this)));
233 
234            // If the amount being transfered is more than the balance of the
235            //  account the transfer throws
236            uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
237 
238            require(previousBalanceFrom >= _amount);
239 
240            // Alerts the token controller of the transfer
241            if (isContract(controller)) {
242                require(TokenController(controller).onTransfer(_from, _to, _amount));
243            }
244 
245            // First update the balance array with the new value for the address
246            //  sending the tokens
247            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
248 
249            // Then update the balance array with the new value for the address
250            //  receiving the tokens
251            uint256 previousBalanceTo = balanceOfAt(_to, block.number);
252            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
253            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
254 
255            // An event to make the transfer easy to find on the blockchain
256            emit Transfer(_from, _to, _amount);
257 
258     }
259 
260     /// @param _owner The address that's balance is being requested
261     /// @return The balance of `_owner` at the current block
262     function balanceOf(address _owner) public view returns (uint256 balance) {
263         return balanceOfAt(_owner, block.number);
264     }
265 
266     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
267     ///  its behalf. This is a modified version of the ERC20 approve function
268     ///  to be a little bit safer
269     /// @param _spender The address of the account able to transfer the tokens
270     /// @param _amount The amount of tokens to be approved for transfer
271     /// @return True if the approval was successful
272     function approve(address _spender, uint256 _amount) public returns (bool success) {
273         require(transfersEnabled);
274 
275         // To change the approve amount you first have to reduce the addresses`
276         //  allowance to zero by calling `approve(_spender,0)` if it is not
277         //  already 0 to mitigate the race condition described here:
278         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
279         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
280 
281         // Alerts the token controller of the approve function call
282         if (isContract(controller)) {
283             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
284         }
285 
286         allowed[msg.sender][_spender] = _amount;
287         emit Approval(msg.sender, _spender, _amount);
288         return true;
289     }
290 
291     /// @dev This function makes it easy to read the `allowed[]` map
292     /// @param _owner The address of the account that owns the token
293     /// @param _spender The address of the account able to transfer the tokens
294     /// @return Amount of remaining tokens of _owner that _spender is allowed
295     ///  to spend
296     function allowance(address _owner, address _spender
297     ) public view returns (uint256 remaining) {
298         return allowed[_owner][_spender];
299     }
300 
301     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
302     ///  its behalf, and then a function is triggered in the contract that is
303     ///  being approved, `_spender`. This allows users to use their tokens to
304     ///  interact with contracts in one function call instead of two
305     /// @param _spender The address of the contract able to transfer the tokens
306     /// @param _amount The amount of tokens to be approved for transfer
307     /// @return True if the function call was successful
308     function approveAndCall(address _spender, uint256 _amount, bytes memory _extraData
309     ) public returns (bool success) {
310         require(approve(_spender, _amount));
311 
312         ApproveAndCallFallBack(_spender).receiveApproval(
313             msg.sender,
314             _amount,
315             address(this),
316             _extraData
317         );
318 
319         return true;
320     }
321 
322     /// @dev This function makes it easy to get the total number of tokens
323     /// @return The total number of tokens
324     function totalSupply() public view returns (uint) {
325         return totalSupplyAt(block.number);
326     }
327 
328 
329 ////////////////
330 // Query balance and totalSupply in History
331 ////////////////
332 
333     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
334     /// @param _owner The address from which the balance will be retrieved
335     /// @param _blockNumber The block number when the balance is queried
336     /// @return The balance at `_blockNumber`
337     function balanceOfAt(address _owner, uint _blockNumber) public view
338         returns (uint) {
339 
340         // These next few lines are used when the balance of the token is
341         //  requested before a check point was ever created for this token, it
342         //  requires that the `parentToken.balanceOfAt` be queried at the
343         //  genesis block for that token as this contains initial balance of
344         //  this token
345         if ((balances[_owner].length == 0)
346             || (balances[_owner][0].fromBlock > _blockNumber)) {
347             if (address(parentToken) != address(0)) {
348                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
349             } else {
350                 // Has no parent
351                 return 0;
352             }
353 
354         // This will return the expected balance during normal situations
355         } else {
356             return getValueAt(balances[_owner], _blockNumber);
357         }
358     }
359 
360     /// @notice Total amount of tokens at a specific `_blockNumber`.
361     /// @param _blockNumber The block number when the totalSupply is queried
362     /// @return The total amount of tokens at `_blockNumber`
363     function totalSupplyAt(uint _blockNumber) public view returns(uint) {
364 
365         // These next few lines are used when the totalSupply of the token is
366         //  requested before a check point was ever created for this token, it
367         //  requires that the `parentToken.totalSupplyAt` be queried at the
368         //  genesis block for this token as that contains totalSupply of this
369         //  token at this block number.
370         if ((totalSupplyHistory.length == 0)
371             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
372             if (address(parentToken) != address(0)) {
373                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
374             } else {
375                 return 0;
376             }
377 
378         // This will return the expected totalSupply during normal situations
379         } else {
380             return getValueAt(totalSupplyHistory, _blockNumber);
381         }
382     }
383 
384 ////////////////
385 // Query pledgedFees // in wei
386 ////////////////
387 
388    /// @dev This function makes it easy to get the total pledged fees
389    /// @return The total number of fees belonging to token holders
390    function totalPledgedFees() public view returns (uint) {
391        return totalPledgedFeesAt(block.number);
392    }
393 
394    /// @notice Total amount of fees at a specific `_blockNumber`.
395    /// @param _blockNumber The block number when the totalPledgedFees is queried
396    /// @return The total amount of pledged fees at `_blockNumber`
397    function totalPledgedFeesAt(uint _blockNumber) public view returns(uint) {
398 
399        // These next few lines are used when the totalPledgedFees of the token is
400        //  requested before a check point was ever created for this token, it
401        //  requires that the `parentToken.totalPledgedFeesAt` be queried at the
402        //  genesis block for this token as that contains totalPledgedFees of this
403        //  token at this block number.
404        if ((totalPledgedFeesHistory.length == 0)
405            || (totalPledgedFeesHistory[0].fromBlock > _blockNumber)) {
406            if (address(parentToken) != address(0)) {
407                return parentToken.totalPledgedFeesAt(min(_blockNumber, parentSnapShotBlock));
408            } else {
409                return 0;
410            }
411 
412        // This will return the expected totalPledgedFees during normal situations
413        } else {
414            return getValueAt(totalPledgedFeesHistory, _blockNumber);
415        }
416    }
417 
418 ////////////////
419 // Pledge Fees To Token Holders or Reduce Pledged Fees // in wei
420 ////////////////
421 
422    /// @notice Pledges fees to the token holders, later to be claimed by burning
423    /// @param _value The amount sent to the vault by controller, reserved for token holders
424    function pledgeFees(uint _value) public onlyController returns (bool) {
425        uint curTotalFees = totalPledgedFees();
426        require(curTotalFees + _value >= curTotalFees); // Check for overflow
427        updateValueAtNow(totalPledgedFeesHistory, curTotalFees + _value);
428        return true;
429    }
430 
431    /// @notice Reduces pledged fees to the token holders, i.e. during upgrade or token burning
432    /// @param _value The amount of pledged fees which are being distributed to token holders, reducing liability
433    function reducePledgedFees(uint _value) public onlyController returns (bool) {
434        uint curTotalFees = totalPledgedFees();
435        require(curTotalFees >= _value);
436        updateValueAtNow(totalPledgedFeesHistory, curTotalFees - _value);
437        return true;
438    }
439 
440 ////////////////
441 // Clone Token Method
442 ////////////////
443 
444     /// @notice Creates a new clone token with the initial distribution being
445     ///  this token at `_snapshotBlock`
446     /// @param _cloneTokenName Name of the clone token
447     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
448     /// @param _cloneTokenSymbol Symbol of the clone token
449     /// @param _snapshotBlock Block when the distribution of the parent token is
450     ///  copied to set the initial distribution of the new clone token;
451     ///  if the block is zero than the actual block, the current block is used
452     /// @param _transfersEnabled True if transfers are allowed in the clone
453     /// @return The address of the new MiniMeToken Contract
454     function createCloneToken(
455         string memory _cloneTokenName,
456         uint8 _cloneDecimalUnits,
457         string memory _cloneTokenSymbol,
458         uint _snapshotBlock,
459         bool _transfersEnabled
460         ) public returns(address) {
461         if (_snapshotBlock == 0) _snapshotBlock = block.number;
462         MiniMeToken cloneToken = tokenFactory.createCloneToken(
463             address(this),
464             _snapshotBlock,
465             _cloneTokenName,
466             _cloneDecimalUnits,
467             _cloneTokenSymbol,
468             _transfersEnabled
469             );
470 
471         cloneToken.changeController(msg.sender);
472 
473         // An event to make the token easy to find on the blockchain
474         emit NewCloneToken(address(cloneToken), _snapshotBlock);
475         return address(cloneToken);
476     }
477 
478 ////////////////
479 // Generate and destroy tokens
480 ////////////////
481 
482     /// @notice Generates `_amount` tokens that are assigned to `_owner`
483     /// @param _owner The address that will be assigned the new tokens
484     /// @param _amount The quantity of tokens generated
485     /// @return True if the tokens are generated correctly
486     function generateTokens(address _owner, uint _amount
487     ) public onlyController returns (bool) {
488         uint curTotalSupply = totalSupply();
489         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
490         uint previousBalanceTo = balanceOf(_owner);
491         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
492         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
493         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
494         emit Transfer(address(0), _owner, _amount);
495         return true;
496     }
497 
498 
499     /// @notice Burns `_amount` tokens from `_owner`
500     /// @param _owner The address that will lose the tokens
501     /// @param _amount The quantity of tokens to burn
502     /// @return True if the tokens are burned correctly
503     function destroyTokens(address _owner, uint _amount
504     ) onlyController public returns (bool) {
505         uint curTotalSupply = totalSupply();
506         require(curTotalSupply >= _amount);
507         uint previousBalanceFrom = balanceOf(_owner);
508         require(previousBalanceFrom >= _amount);
509         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
510         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
511         emit Transfer(_owner, address(0), _amount);
512         return true;
513     }
514 
515 ////////////////
516 // Enable tokens transfers
517 ////////////////
518 
519 
520     /// @notice Enables token holders to transfer their tokens freely if true
521     /// @param _transfersEnabled True if transfers are allowed in the clone
522     function enableTransfers(bool _transfersEnabled) public onlyController {
523         transfersEnabled = _transfersEnabled;
524     }
525 
526 ////////////////
527 // Internal helper functions to query and set a value in a snapshot array
528 ////////////////
529 
530     /// @dev `getValueAt` retrieves the number of tokens at a given block number
531     /// @param checkpoints The history of values being queried
532     /// @param _block The block number to retrieve the value at
533     /// @return The number of tokens being queried
534     function getValueAt(Checkpoint[] storage checkpoints, uint _block
535     ) view internal returns (uint) {
536         if (checkpoints.length == 0) return 0;
537 
538         // Shortcut for the actual value
539         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
540             return checkpoints[checkpoints.length-1].value;
541         if (_block < checkpoints[0].fromBlock) return 0;
542 
543         // Binary search of the value in the array
544         uint min = 0;
545         uint max = checkpoints.length-1;
546         while (max > min) {
547             uint mid = (max + min + 1)/ 2;
548             if (checkpoints[mid].fromBlock<=_block) {
549                 min = mid;
550             } else {
551                 max = mid-1;
552             }
553         }
554         return checkpoints[min].value;
555     }
556 
557     /// @dev `updateValueAtNow` used to update the `balances` map and the
558     ///  `totalSupplyHistory`
559     /// @param checkpoints The history of data being updated
560     /// @param _value The new number of tokens
561     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
562     ) internal  {
563         if ((checkpoints.length == 0)
564         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
565                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
566                newCheckPoint.fromBlock =  uint128(block.number);
567                newCheckPoint.value = uint128(_value);
568            } else {
569                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
570                oldCheckPoint.value = uint128(_value);
571            }
572     }
573 
574     /// @dev Internal function to determine if an address is a contract
575     /// @param _addr The address being queried
576     /// @return True if `_addr` is a contract
577     function isContract(address _addr) view internal returns(bool) {
578         uint size;
579         if (_addr == address(0)) return false;
580         assembly {
581             size := extcodesize(_addr)
582         }
583         return size>0;
584     }
585 
586     /// @dev Helper function to return a min betwen the two uints
587     function min(uint a, uint b) pure internal returns (uint) {
588         return a < b ? a : b;
589     }
590 
591     /// @notice The fallback function: If the contract's controller has not been
592     ///  set to 0, then the `proxyPayment` method is called which relays the
593     ///  ether and creates tokens as described in the token controller contract
594     function () external payable {
595         require(isContract(controller));
596         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
597     }
598 
599 
600 ////////////////
601 // Events
602 ////////////////
603     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
604     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
605     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
606     event Approval(
607         address indexed _owner,
608         address indexed _spender,
609         uint256 _amount
610         );
611 
612 }
613 
614 
615 ////////////////
616 // MiniMeTokenFactory
617 ////////////////
618 
619 /// @dev This contract is used to generate clone contracts from a contract.
620 ///  In solidity this is the way to create a contract from a contract of the
621 ///  same class
622 contract MiniMeTokenFactory {
623 
624     /// @notice Update the DApp by creating a new token with new functionalities
625     ///  the msg.sender becomes the controller of this clone token
626     /// @param _parentToken Address of the token being cloned
627     /// @param _snapshotBlock Block of the parent token that will
628     ///  determine the initial distribution of the clone token
629     /// @param _tokenName Name of the new token
630     /// @param _decimalUnits Number of decimals of the new token
631     /// @param _tokenSymbol Token Symbol for the new token
632     /// @param _transfersEnabled If true, tokens will be able to be transferred
633     /// @return The address of the new token contract
634     function createCloneToken(
635         address payable _parentToken,
636         uint _snapshotBlock,
637         string memory _tokenName,
638         uint8 _decimalUnits,
639         string memory _tokenSymbol,
640         bool _transfersEnabled
641     ) public returns (MiniMeToken) {
642         MiniMeToken newToken = new MiniMeToken(
643             address(this),
644             _parentToken,
645             _snapshotBlock,
646             _tokenName,
647             _decimalUnits,
648             _tokenSymbol,
649             _transfersEnabled
650             );
651 
652         newToken.changeController(msg.sender);
653         return newToken;
654     }
655   }
656 
657 
658 /*
659     Copyright 2017, Will Harborne (Ethfinex)
660 */
661 
662 contract DestructibleMiniMeToken is MiniMeToken {
663 
664     address payable public terminator;
665 
666     constructor(
667         address _tokenFactory,
668         address payable _parentToken,
669         uint _parentSnapShotBlock,
670         string memory _tokenName,
671         uint8 _decimalUnits,
672         string memory _tokenSymbol,
673         bool _transfersEnabled,
674         address payable _terminator
675     ) public MiniMeToken(
676         _tokenFactory,
677         _parentToken,
678         _parentSnapShotBlock,
679         _tokenName,
680         _decimalUnits,
681         _tokenSymbol,
682         _transfersEnabled
683     ) {
684         terminator = _terminator;
685     }
686 
687     function recycle() public {
688         require(msg.sender == terminator);
689         selfdestruct(terminator);
690     }
691 }
692 
693 
694 contract DestructibleMiniMeTokenFactory {
695 
696     /// @notice Update the DApp by creating a new token with new functionalities
697     ///  the msg.sender becomes the controller of this clone token
698     /// @param _parentToken Address of the token being cloned
699     /// @param _snapshotBlock Block of the parent token that will
700     ///  determine the initial distribution of the clone token
701     /// @param _tokenName Name of the new token
702     /// @param _decimalUnits Number of decimals of the new token
703     /// @param _tokenSymbol Token Symbol for the new token
704     /// @param _transfersEnabled If true, tokens will be able to be transferred
705     /// @return The address of the new token contract
706     function createDestructibleCloneToken(
707         address payable _parentToken,
708         uint _snapshotBlock,
709         string memory _tokenName,
710         uint8 _decimalUnits,
711         string memory _tokenSymbol,
712         bool _transfersEnabled
713     ) public returns (DestructibleMiniMeToken) {
714         DestructibleMiniMeToken newToken = new DestructibleMiniMeToken(
715             address(this),
716             _parentToken,
717             _snapshotBlock,
718             _tokenName,
719             _decimalUnits,
720             _tokenSymbol,
721             _transfersEnabled,
722             msg.sender
723         );
724 
725         newToken.changeController(msg.sender);
726         return newToken;
727     }
728 }
729 
730 
731 contract Ownable {
732 
733   address public owner;
734 
735   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
736 
737   constructor() public {
738     owner = msg.sender;
739   }
740 
741   modifier onlyOwner() {
742     require(msg.sender == owner);
743     _;
744   }
745 
746   function transferOwnership(address newOwner) public onlyOwner {
747     require(newOwner != address(0));
748     emit OwnershipTransferred(owner, newOwner);
749     owner = newOwner;
750   }
751 
752 }
753 
754 /*
755     Copyright 2018, Will Harborne @ Ethfinex
756     This contract is deployed as a short term solution to replace the broken contract at
757     0xc88b6573cC09FD48FFaD73a9E09A0B3A93F095Be
758 */
759 
760 /// @title OneTimeListingManager Contract
761 /// @author Will Harborne @ Ethfinex
762 contract OneTimeListingManager is Ownable {
763 
764     address public constant NECTAR_TOKEN = 0xCc80C051057B774cD75067Dc48f8987C4Eb97A5e;
765     address public constant REPLACED_EVT = 0x9EdCf4f838Ed4f2A05085Bd3d67ADFdE5620d940;
766     address public constant TOKEN_FACTORY = 0x8936131A81F29205EeDDec486f401A8A0aFAb15A;
767     uint public constant MAX_CANDIDATES = 20;
768 
769     struct TokenProposal {
770         address[] consideredTokens;
771         uint startBlock;
772         uint startTime;
773         uint duration;
774         DestructibleMiniMeToken votingToken;
775         uint[] yesVotes;
776         // criteria values
777         // 0. only first one win the vote;
778         // 1. top N (number in extraData) win the vote;
779         // 2. All over N (number in extra data) votes win the vote;
780         uint criteria;
781         uint extraData;
782         bool concluded;
783         mapping(address => mapping(address => uint256)) votesForToken;
784     }
785 
786     TokenProposal[] public tokenBatches;
787 
788     DestructibleMiniMeTokenFactory public tokenFactory;
789     address payable public nectarToken;
790     mapping(address => bool) public admins;
791 
792     mapping(address => bool) public isWinner;
793     mapping(address => uint256) public winningVotes;
794     mapping(address => uint) public proposalWhenTokenWon;
795 
796     modifier onlyAdmins() {
797         require(isAdmin(msg.sender));
798         _;
799     }
800 
801     constructor(address _tokenFactory, address payable _nectarToken) public {
802         tokenFactory = DestructibleMiniMeTokenFactory(_tokenFactory);
803         nectarToken = _nectarToken;
804         admins[msg.sender] = true;
805     }
806 
807     /// @notice Admins are able to approve proposal that someone submitted
808     /// @param _tokens the list of tokens in consideration during this period
809     /// @param _duration number of days for vote token to exist. Second half is for voting.
810     /// @param _criteria number that determines how winner is selected
811     /// @param _extraData extra data for criteria parameter
812     function startTokenVotes(address[] memory _tokens, uint _duration, uint _criteria, uint _extraData) public onlyAdmins {
813         require(_tokens.length <= MAX_CANDIDATES);
814 
815         if (_criteria == 1) {
816             // in other case all tokens would be winners
817             require(_extraData < _tokens.length);
818         }
819 
820         uint _proposalId = tokenBatches.length;
821         if (_proposalId > 0) {
822           endTokenVote(_proposalId - 1);
823         }
824         tokenBatches.length++;
825         TokenProposal storage p = tokenBatches[_proposalId];
826         p.duration = _duration * (1 days);
827 
828         p.consideredTokens = _tokens;
829         p.yesVotes = new uint[](_tokens.length);
830 
831         p.votingToken = tokenFactory.createDestructibleCloneToken(
832                 nectarToken,
833                 getBlockNumber(),
834                 appendUintToString("EfxTokenVotes-", _proposalId),
835                 MiniMeToken(nectarToken).decimals(),
836                 appendUintToString("EVT-", _proposalId),
837                 true);
838 
839         p.startTime = 1553596261; // Hardcoded to match old token
840         p.startBlock = getBlockNumber();
841         p.criteria = _criteria;
842         p.extraData = _extraData;
843         p.concluded = false;
844 
845         emit NewTokens(_proposalId);
846     }
847 
848 
849     /// @notice Anyone can end the vote if it has completed
850     function endTokenVote(uint _proposalId) public returns(bool) {
851 
852         require(_proposalId <= tokenBatches.length);
853 
854         TokenProposal storage op = tokenBatches[_proposalId];
855         require(op.startTime + op.duration < now);
856         if (op.concluded) {
857           return true;
858         }
859 
860         uint[] memory _previousWinnerMap = getWinnerIndices(_proposalId);
861         for (uint i=0; i < _previousWinnerMap.length; i++) {
862             isWinner[op.consideredTokens[_previousWinnerMap[i]]] = true;
863             winningVotes[op.consideredTokens[_previousWinnerMap[i]]] = op.yesVotes[_previousWinnerMap[i]];
864             proposalWhenTokenWon[op.consideredTokens[_previousWinnerMap[i]]] = _proposalId;
865         }
866 
867         DestructibleMiniMeToken(op.votingToken).recycle();
868         op.concluded = true;
869         return true;
870     }
871 
872     /// @notice Vote for specific token with yes
873     /// @param _proposalId is the proposal's position in tokenBatches array
874     /// @param _tokenIndex is the position from 0-11 in the token array of the chosen token
875     function vote(uint _proposalId, uint _tokenIndex, uint _amount) public {
876         // voting only on the most recent set of proposed tokens
877         require(tokenBatches.length > 0);
878         require(_proposalId == tokenBatches.length - 1);
879         require(_tokenIndex < 12);
880 
881         TokenProposal storage p = tokenBatches[_proposalId];
882 
883         require(now > p.startTime + (p.duration / 2));
884         require(now < p.startTime + p.duration);
885 
886         uint amount = DestructibleMiniMeToken(p.votingToken).balanceOf(msg.sender);
887         require(amount >= _amount);
888 
889         uint weightedAmount = _amount * 2;
890 
891         require(DestructibleMiniMeToken(p.votingToken).transferFrom(msg.sender, address(this), _amount));
892 
893         tokenBatches[_proposalId].yesVotes[_tokenIndex] += weightedAmount;
894         p.votesForToken[tokenBatches[_proposalId].consideredTokens[_tokenIndex]][msg.sender] += weightedAmount;
895 
896         emit Vote(_proposalId, msg.sender, tokenBatches[_proposalId].consideredTokens[_tokenIndex], weightedAmount);
897     }
898 
899     function getWinnerIndices(uint _proposalId) public view returns(uint[] memory winners) {
900         require(_proposalId < tokenBatches.length);
901 
902         TokenProposal memory p = tokenBatches[_proposalId];
903 
904         // there is only one winner in criteria 0
905         if (p.criteria == 0) {
906             winners = new uint[](1);
907             uint max = 0;
908 
909             for (uint i=0; i < p.consideredTokens.length; i++) {
910                 if (p.yesVotes[i] > p.yesVotes[max]) {
911                     max = i;
912                 }
913             }
914 
915             winners[0] = max;
916         }
917 
918         // there is N winners in criteria 1
919         if (p.criteria == 1) {
920             uint[] memory indexesWithMostVotes = new uint[](p.extraData);
921             winners = new uint[](p.extraData);
922 
923             // for each token we check if he has more votes than last one,
924             // if it has we put it in array and always keep array sorted
925             for (uint i = 0; i < p.consideredTokens.length; i++) {
926                 uint last = p.extraData - 1;
927                 if (p.yesVotes[i] > p.yesVotes[indexesWithMostVotes[last]]) {
928                     indexesWithMostVotes[last] = i;
929 
930                     for (uint j=last; j > 0; j--) {
931                         if (p.yesVotes[indexesWithMostVotes[j]] > p.yesVotes[indexesWithMostVotes[j-1]]) {
932                             uint help = indexesWithMostVotes[j];
933                             indexesWithMostVotes[j] = indexesWithMostVotes[j-1];
934                             indexesWithMostVotes[j-1] = help;
935                         }
936                     }
937                 }
938             }
939 
940             for (uint i = 0; i < p.extraData; i++) {
941                 winners[i] = indexesWithMostVotes[i];
942             }
943         }
944 
945         // everybody who has over N votes are winners in criteria 2
946         if (p.criteria == 2) {
947             uint numOfTokens = 0;
948             for (uint i = 0; i < p.consideredTokens.length; i++) {
949                 if (p.yesVotes[i] > p.extraData) {
950                     numOfTokens++;
951                 }
952             }
953 
954             winners = new uint[](numOfTokens);
955             uint count = 0;
956             for (uint i = 0; i < p.consideredTokens.length; i++) {
957                 if (p.yesVotes[i] > p.extraData) {
958                     winners[count] = i;
959                     count++;
960                 }
961             }
962         }
963     }
964 
965     function getWinners() public view returns(address[] memory) {
966         if(tokenBatches.length == 0) {
967             return new address[](0);
968         }
969 
970         uint[] memory winnerIndices = getWinnerIndices(tokenBatches.length - 1);
971 
972         TokenProposal memory p = tokenBatches[tokenBatches.length - 1];
973 
974         address[] memory winners = new address[](winnerIndices.length);
975         for (uint i = 0; i < winnerIndices.length; i++) {
976             winners[i] = p.consideredTokens[winnerIndices[i]];
977         }
978     }
979 
980     function getUserVotesForWinner(address _token, address _voter) external view returns(uint256) {
981       uint roundWhenWon = proposalWhenTokenWon[_token];
982       return tokenBatches[roundWhenWon].votesForToken[_token][_voter];
983     }
984 
985     /// @notice Get number of proposals so you can know which is the last one
986     function numberOfProposals() public view returns(uint) {
987         return tokenBatches.length;
988     }
989 
990     /// @notice Any admin is able to add new admin
991     /// @param _newAdmin Address of new admin
992     function addAdmin(address _newAdmin) public onlyAdmins {
993         admins[_newAdmin] = true;
994     }
995 
996     /// @notice Only owner is able to remove admin
997     /// @param _admin Address of current admin
998     function removeAdmin(address _admin) public onlyOwner {
999         admins[_admin] = false;
1000     }
1001 
1002     /// @notice Get data about specific proposal
1003     /// @param _proposalId Id of proposal
1004     function proposal(uint _proposalId) public view returns(
1005         uint _startBlock,
1006         uint _startTime,
1007         uint _duration,
1008         bool _active,
1009         bool _finalized,
1010         uint[] memory _votes,
1011         address[] memory _tokens,
1012         address _votingToken,
1013         bool _hasBalance
1014     ) {
1015         require(_proposalId < tokenBatches.length);
1016 
1017         TokenProposal memory p = tokenBatches[_proposalId];
1018         _startBlock = p.startBlock;
1019         _startTime = p.startTime;
1020         _duration = p.duration;
1021         _finalized = (_startTime+_duration < now);
1022         _active = !_finalized && (p.startBlock < getBlockNumber());
1023         _votes = p.yesVotes;
1024         _tokens = p.consideredTokens;
1025         _votingToken = address(p.votingToken);
1026         _hasBalance = (_votingToken == address(0)) ? false : (DestructibleMiniMeToken(p.votingToken).balanceOf(msg.sender) > 0);
1027     }
1028 
1029     function isAdmin(address _admin) public view returns(bool) {
1030         return admins[_admin];
1031     }
1032 
1033     function proxyPayment(address ) public payable returns(bool) {
1034         return false;
1035     }
1036 
1037     function onTransfer(address, address, uint ) public pure returns(bool) {
1038         return true;
1039     }
1040 
1041     function onApprove(address, address, uint ) public pure returns(bool) {
1042         return true;
1043     }
1044 
1045     function getBlockNumber() internal view returns (uint) {
1046         return block.number;
1047     }
1048 
1049     function appendUintToString(string memory inStr, uint _i) internal pure returns (string memory _str) {
1050     if (_i == 0) {
1051         return string(abi.encodePacked(inStr, "0"));
1052     }
1053     uint j = _i;
1054     uint len;
1055     while (j != 0) {
1056         len++;
1057         j /= 10;
1058     }
1059     bytes memory bstr = new bytes(len);
1060     uint k = len - 1;
1061     while (_i != 0) {
1062         bstr[k--] = byte(uint8(48 + _i % 10));
1063         _i /= 10;
1064     }
1065 
1066     return string(abi.encodePacked(inStr, string(bstr)));
1067     }
1068 
1069     event Vote(uint indexed idProposal, address indexed _voter, address chosenToken, uint amount);
1070     event NewTokens(uint indexed idProposal);
1071 }