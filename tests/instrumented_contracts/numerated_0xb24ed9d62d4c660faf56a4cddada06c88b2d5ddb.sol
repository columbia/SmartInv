1 pragma solidity 0.4.21;
2 
3 /* 
4 Nectar Community Governance Proposals Contract, deployed 18/03/18 
5 */
6 
7 /*
8     Copyright 2016, Jordi Baylina
9 
10     This program is free software: you can redistribute it and/or modify
11     it under the terms of the GNU General Public License as published by
12     the Free Software Foundation, either version 3 of the License, or
13     (at your option) any later version.
14 
15     This program is distributed in the hope that it will be useful,
16     but WITHOUT ANY WARRANTY; without even the implied warranty of
17     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
18     GNU General Public License for more details.
19 
20     You should have received a copy of the GNU General Public License
21     along with this program.  If not, see <http://www.gnu.org/licenses/>.
22  */
23 
24 /// @title MiniMeToken Contract
25 /// @author Jordi Baylina
26 /// @dev This token contract's goal is to make it easy for anyone to clone this
27 ///  token using the token distribution at a given block, this will allow DAO's
28 ///  and DApps to upgrade their features in a decentralized manner without
29 ///  affecting the original token
30 /// @dev It is ERC20 compliant, but still needs to under go further testing.
31 
32 contract Controlled {
33     /// @notice The address of the controller is the only address that can call
34     ///  a function with this modifier
35     modifier onlyController { require(msg.sender == controller); _; }
36 
37     address public controller;
38 
39     function Controlled() public { controller = msg.sender;}
40 
41     /// @notice Changes the controller of the contract
42     /// @param _newController The new controller of the contract
43     function changeController(address _newController) public onlyController {
44         controller = _newController;
45     }
46 }
47 
48 /// @dev The token controller contract must implement these functions
49 contract TokenController {
50     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
51     /// @param _owner The address that sent the ether to create tokens
52     /// @return True if the ether is accepted, false if it throws
53     function proxyPayment(address _owner) public payable returns(bool);
54 
55     /// @notice Notifies the controller about a token transfer allowing the
56     ///  controller to react if desired
57     /// @param _from The origin of the transfer
58     /// @param _to The destination of the transfer
59     /// @param _amount The amount of the transfer
60     /// @return False if the controller does not authorize the transfer
61     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
62 
63     /// @notice Notifies the controller about an approval allowing the
64     ///  controller to react if desired
65     /// @param _owner The address that calls `approve()`
66     /// @param _spender The spender in the `approve()` call
67     /// @param _amount The amount in the `approve()` call
68     /// @return False if the controller does not authorize the approval
69     function onApprove(address _owner, address _spender, uint _amount) public
70         returns(bool);
71 }
72 
73 contract ApproveAndCallFallBack {
74     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
75 }
76 
77 /// @dev The actual token contract, the default controller is the msg.sender
78 ///  that deploys the contract, so usually this token will be deployed by a
79 ///  token controller contract, which Giveth will call a "Campaign"
80 contract MiniMeToken is Controlled {
81 
82     string public name;                //The Token's name: e.g. DigixDAO Tokens
83     uint8 public decimals;             //Number of decimals of the smallest unit
84     string public symbol;              //An identifier: e.g. REP
85     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
86 
87 
88     /// @dev `Checkpoint` is the structure that attaches a block number to a
89     ///  given value, the block number attached is the one that last changed the
90     ///  value
91     struct  Checkpoint {
92 
93         // `fromBlock` is the block number that the value was generated from
94         uint128 fromBlock;
95 
96         // `value` is the amount of tokens at a specific block number
97         uint128 value;
98     }
99 
100     // `parentToken` is the Token address that was cloned to produce this token;
101     //  it will be 0x0 for a token that was not cloned
102     MiniMeToken public parentToken;
103 
104     // `parentSnapShotBlock` is the block number from the Parent Token that was
105     //  used to determine the initial distribution of the Clone Token
106     uint public parentSnapShotBlock;
107 
108     // `creationBlock` is the block number that the Clone Token was created
109     uint public creationBlock;
110 
111     // `balances` is the map that tracks the balance of each address, in this
112     //  contract when the balance changes the block number that the change
113     //  occurred is also included in the map
114     mapping (address => Checkpoint[]) balances;
115 
116     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
117     mapping (address => mapping (address => uint256)) allowed;
118 
119     // Tracks the history of the `totalSupply` of the token
120     Checkpoint[] totalSupplyHistory;
121 
122     // Flag that determines if the token is transferable or not.
123     bool public transfersEnabled;
124 
125     // The factory used to create new clone tokens
126     MiniMeTokenFactory public tokenFactory;
127 
128 ////////////////
129 // Constructor
130 ////////////////
131 
132     /// @notice Constructor to create a MiniMeToken
133     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
134     ///  will create the Clone token contracts, the token factory needs to be
135     ///  deployed first
136     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
137     ///  new token
138     /// @param _parentSnapShotBlock Block of the parent token that will
139     ///  determine the initial distribution of the clone token, set to 0 if it
140     ///  is a new token
141     /// @param _tokenName Name of the new token
142     /// @param _decimalUnits Number of decimals of the new token
143     /// @param _tokenSymbol Token Symbol for the new token
144     /// @param _transfersEnabled If true, tokens will be able to be transferred
145     function MiniMeToken(
146         address _tokenFactory,
147         address _parentToken,
148         uint _parentSnapShotBlock,
149         string _tokenName,
150         uint8 _decimalUnits,
151         string _tokenSymbol,
152         bool _transfersEnabled
153     ) public {
154         tokenFactory = MiniMeTokenFactory(_tokenFactory);
155         name = _tokenName;                                 // Set the name
156         decimals = _decimalUnits;                          // Set the decimals
157         symbol = _tokenSymbol;                             // Set the symbol
158         parentToken = MiniMeToken(_parentToken);
159         parentSnapShotBlock = _parentSnapShotBlock;
160         transfersEnabled = _transfersEnabled;
161         creationBlock = block.number;
162     }
163 
164 
165 ///////////////////
166 // ERC20 Methods
167 ///////////////////
168 
169     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
170     /// @param _to The address of the recipient
171     /// @param _amount The amount of tokens to be transferred
172     /// @return Whether the transfer was successful or not
173     function transfer(address _to, uint256 _amount) public returns (bool success) {
174         require(transfersEnabled);
175         doTransfer(msg.sender, _to, _amount);
176         return true;
177     }
178 
179     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
180     ///  is approved by `_from`
181     /// @param _from The address holding the tokens being transferred
182     /// @param _to The address of the recipient
183     /// @param _amount The amount of tokens to be transferred
184     /// @return True if the transfer was successful
185     function transferFrom(address _from, address _to, uint256 _amount
186     ) public returns (bool success) {
187 
188         // The controller of this contract can move tokens around at will,
189         //  this is important to recognize! Confirm that you trust the
190         //  controller of this contract, which in most situations should be
191         //  another open source smart contract or 0x0
192         if (msg.sender != controller) {
193             require(transfersEnabled);
194 
195             // The standard ERC 20 transferFrom functionality
196             require(allowed[_from][msg.sender] >= _amount);
197             allowed[_from][msg.sender] -= _amount;
198         }
199         doTransfer(_from, _to, _amount);
200         return true;
201     }
202 
203     /// @dev This is the actual transfer function in the token contract, it can
204     ///  only be called by other functions in this contract.
205     /// @param _from The address holding the tokens being transferred
206     /// @param _to The address of the recipient
207     /// @param _amount The amount of tokens to be transferred
208     /// @return True if the transfer was successful
209     function doTransfer(address _from, address _to, uint _amount
210     ) internal {
211 
212            if (_amount == 0) {
213                emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
214                return;
215            }
216 
217            require(parentSnapShotBlock < block.number);
218 
219            // Do not allow transfer to 0x0 or the token contract itself
220            require((_to != 0) && (_to != address(this)));
221 
222            // If the amount being transfered is more than the balance of the
223            //  account the transfer throws
224            uint previousBalanceFrom = balanceOfAt(_from, block.number);
225 
226            require(previousBalanceFrom >= _amount);
227 
228            // Alerts the token controller of the transfer
229            if (isContract(controller)) {
230                require(TokenController(controller).onTransfer(_from, _to, _amount));
231            }
232 
233            // First update the balance array with the new value for the address
234            //  sending the tokens
235            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
236 
237            // Then update the balance array with the new value for the address
238            //  receiving the tokens
239            uint previousBalanceTo = balanceOfAt(_to, block.number);
240            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
241            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
242 
243            // An event to make the transfer easy to find on the blockchain
244            emit Transfer(_from, _to, _amount);
245 
246     }
247 
248     /// @param _owner The address that's balance is being requested
249     /// @return The balance of `_owner` at the current block
250     function balanceOf(address _owner) public constant returns (uint256 balance) {
251         return balanceOfAt(_owner, block.number);
252     }
253 
254     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
255     ///  its behalf. This is a modified version of the ERC20 approve function
256     ///  to be a little bit safer
257     /// @param _spender The address of the account able to transfer the tokens
258     /// @param _amount The amount of tokens to be approved for transfer
259     /// @return True if the approval was successful
260     function approve(address _spender, uint256 _amount) public returns (bool success) {
261         require(transfersEnabled);
262 
263         // To change the approve amount you first have to reduce the addresses`
264         //  allowance to zero by calling `approve(_spender,0)` if it is not
265         //  already 0 to mitigate the race condition described here:
266         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
268 
269         // Alerts the token controller of the approve function call
270         if (isContract(controller)) {
271             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
272         }
273 
274         allowed[msg.sender][_spender] = _amount;
275         emit Approval(msg.sender, _spender, _amount);
276         return true;
277     }
278 
279     /// @dev This function makes it easy to read the `allowed[]` map
280     /// @param _owner The address of the account that owns the token
281     /// @param _spender The address of the account able to transfer the tokens
282     /// @return Amount of remaining tokens of _owner that _spender is allowed
283     ///  to spend
284     function allowance(address _owner, address _spender
285     ) public constant returns (uint256 remaining) {
286         return allowed[_owner][_spender];
287     }
288 
289     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
290     ///  its behalf, and then a function is triggered in the contract that is
291     ///  being approved, `_spender`. This allows users to use their tokens to
292     ///  interact with contracts in one function call instead of two
293     /// @param _spender The address of the contract able to transfer the tokens
294     /// @param _amount The amount of tokens to be approved for transfer
295     /// @return True if the function call was successful
296     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
297     ) public returns (bool success) {
298         require(approve(_spender, _amount));
299 
300         ApproveAndCallFallBack(_spender).receiveApproval(
301             msg.sender,
302             _amount,
303             this,
304             _extraData
305         );
306 
307         return true;
308     }
309 
310     /// @dev This function makes it easy to get the total number of tokens
311     /// @return The total number of tokens
312     function totalSupply() public constant returns (uint) {
313         return totalSupplyAt(block.number);
314     }
315 
316 
317 ////////////////
318 // Query balance and totalSupply in History
319 ////////////////
320 
321     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
322     /// @param _owner The address from which the balance will be retrieved
323     /// @param _blockNumber The block number when the balance is queried
324     /// @return The balance at `_blockNumber`
325     function balanceOfAt(address _owner, uint _blockNumber) public constant
326         returns (uint) {
327 
328         // These next few lines are used when the balance of the token is
329         //  requested before a check point was ever created for this token, it
330         //  requires that the `parentToken.balanceOfAt` be queried at the
331         //  genesis block for that token as this contains initial balance of
332         //  this token
333         if ((balances[_owner].length == 0)
334             || (balances[_owner][0].fromBlock > _blockNumber)) {
335             if (address(parentToken) != 0) {
336                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
337             } else {
338                 // Has no parent
339                 return 0;
340             }
341 
342         // This will return the expected balance during normal situations
343         } else {
344             return getValueAt(balances[_owner], _blockNumber);
345         }
346     }
347 
348     /// @notice Total amount of tokens at a specific `_blockNumber`.
349     /// @param _blockNumber The block number when the totalSupply is queried
350     /// @return The total amount of tokens at `_blockNumber`
351     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
352 
353         // These next few lines are used when the totalSupply of the token is
354         //  requested before a check point was ever created for this token, it
355         //  requires that the `parentToken.totalSupplyAt` be queried at the
356         //  genesis block for this token as that contains totalSupply of this
357         //  token at this block number.
358         if ((totalSupplyHistory.length == 0)
359             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
360             if (address(parentToken) != 0) {
361                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
362             } else {
363                 return 0;
364             }
365 
366         // This will return the expected totalSupply during normal situations
367         } else {
368             return getValueAt(totalSupplyHistory, _blockNumber);
369         }
370     }
371 
372 ////////////////
373 // Clone Token Method
374 ////////////////
375 
376     /// @notice Creates a new clone token with the initial distribution being
377     ///  this token at `_snapshotBlock`
378     /// @param _cloneTokenName Name of the clone token
379     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
380     /// @param _cloneTokenSymbol Symbol of the clone token
381     /// @param _snapshotBlock Block when the distribution of the parent token is
382     ///  copied to set the initial distribution of the new clone token;
383     ///  if the block is zero than the actual block, the current block is used
384     /// @param _transfersEnabled True if transfers are allowed in the clone
385     /// @return The address of the new MiniMeToken Contract
386     function createCloneToken(
387         string _cloneTokenName,
388         uint8 _cloneDecimalUnits,
389         string _cloneTokenSymbol,
390         uint _snapshotBlock,
391         bool _transfersEnabled
392         ) public returns(address) {
393         if (_snapshotBlock == 0) _snapshotBlock = block.number;
394         MiniMeToken cloneToken = tokenFactory.createCloneToken(
395             this,
396             _snapshotBlock,
397             _cloneTokenName,
398             _cloneDecimalUnits,
399             _cloneTokenSymbol,
400             _transfersEnabled
401             );
402 
403         cloneToken.changeController(msg.sender);
404 
405         // An event to make the token easy to find on the blockchain
406         emit NewCloneToken(address(cloneToken), _snapshotBlock);
407         return address(cloneToken);
408     }
409 
410 ////////////////
411 // Generate and destroy tokens
412 ////////////////
413 
414     /// @notice Generates `_amount` tokens that are assigned to `_owner`
415     /// @param _owner The address that will be assigned the new tokens
416     /// @param _amount The quantity of tokens generated
417     /// @return True if the tokens are generated correctly
418     function generateTokens(address _owner, uint _amount
419     ) public onlyController returns (bool) {
420         uint curTotalSupply = totalSupply();
421         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
422         uint previousBalanceTo = balanceOf(_owner);
423         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
424         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
425         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
426         emit Transfer(0, _owner, _amount);
427         return true;
428     }
429 
430 
431     /// @notice Burns `_amount` tokens from `_owner`
432     /// @param _owner The address that will lose the tokens
433     /// @param _amount The quantity of tokens to burn
434     /// @return True if the tokens are burned correctly
435     function destroyTokens(address _owner, uint _amount
436     ) onlyController public returns (bool) {
437         uint curTotalSupply = totalSupply();
438         require(curTotalSupply >= _amount);
439         uint previousBalanceFrom = balanceOf(_owner);
440         require(previousBalanceFrom >= _amount);
441         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
442         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
443         emit Transfer(_owner, 0, _amount);
444         return true;
445     }
446 
447 ////////////////
448 // Enable tokens transfers
449 ////////////////
450 
451 
452     /// @notice Enables token holders to transfer their tokens freely if true
453     /// @param _transfersEnabled True if transfers are allowed in the clone
454     function enableTransfers(bool _transfersEnabled) public onlyController {
455         transfersEnabled = _transfersEnabled;
456     }
457 
458 ////////////////
459 // Internal helper functions to query and set a value in a snapshot array
460 ////////////////
461 
462     /// @dev `getValueAt` retrieves the number of tokens at a given block number
463     /// @param checkpoints The history of values being queried
464     /// @param _block The block number to retrieve the value at
465     /// @return The number of tokens being queried
466     function getValueAt(Checkpoint[] storage checkpoints, uint _block
467     ) constant internal returns (uint) {
468         if (checkpoints.length == 0) return 0;
469 
470         // Shortcut for the actual value
471         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
472             return checkpoints[checkpoints.length-1].value;
473         if (_block < checkpoints[0].fromBlock) return 0;
474 
475         // Binary search of the value in the array
476         uint min = 0;
477         uint max = checkpoints.length-1;
478         while (max > min) {
479             uint mid = (max + min + 1)/ 2;
480             if (checkpoints[mid].fromBlock<=_block) {
481                 min = mid;
482             } else {
483                 max = mid-1;
484             }
485         }
486         return checkpoints[min].value;
487     }
488 
489     /// @dev `updateValueAtNow` used to update the `balances` map and the
490     ///  `totalSupplyHistory`
491     /// @param checkpoints The history of data being updated
492     /// @param _value The new number of tokens
493     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
494     ) internal  {
495         if ((checkpoints.length == 0)
496         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
497                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
498                newCheckPoint.fromBlock =  uint128(block.number);
499                newCheckPoint.value = uint128(_value);
500            } else {
501                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
502                oldCheckPoint.value = uint128(_value);
503            }
504     }
505 
506     /// @dev Internal function to determine if an address is a contract
507     /// @param _addr The address being queried
508     /// @return True if `_addr` is a contract
509     function isContract(address _addr) constant internal returns(bool) {
510         uint size;
511         if (_addr == 0) return false;
512         assembly {
513             size := extcodesize(_addr)
514         }
515         return size>0;
516     }
517 
518     /// @dev Helper function to return a min betwen the two uints
519     function min(uint a, uint b) pure internal returns (uint) {
520         return a < b ? a : b;
521     }
522 
523     /// @notice The fallback function: If the contract's controller has not been
524     ///  set to 0, then the `proxyPayment` method is called which relays the
525     ///  ether and creates tokens as described in the token controller contract
526     function () public payable {
527         require(isContract(controller));
528         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
529     }
530 
531 //////////
532 // Safety Methods
533 //////////
534 
535     /// @notice This method can be used by the controller to extract mistakenly
536     ///  sent tokens to this contract.
537     /// @param _token The address of the token contract that you want to recover
538     ///  set to 0 in case you want to extract ether.
539     function claimTokens(address _token) public onlyController {
540         if (_token == 0x0) {
541             controller.transfer(address(this).balance);
542             return;
543         }
544 
545         MiniMeToken token = MiniMeToken(_token);
546         uint balance = token.balanceOf(this);
547         token.transfer(controller, balance);
548         emit ClaimedTokens(_token, controller, balance);
549     }
550 
551 ////////////////
552 // Events
553 ////////////////
554     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
555     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
556     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
557     event Approval(
558         address indexed _owner,
559         address indexed _spender,
560         uint256 _amount
561         );
562 
563 }
564 
565 
566 ////////////////
567 // MiniMeTokenFactory
568 ////////////////
569 
570 /// @dev This contract is used to generate clone contracts from a contract.
571 ///  In solidity this is the way to create a contract from a contract of the
572 ///  same class
573 contract MiniMeTokenFactory {
574 
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
592     ) public returns (MiniMeToken) {
593         MiniMeToken newToken = new MiniMeToken(
594             this,
595             _parentToken,
596             _snapshotBlock,
597             _tokenName,
598             _decimalUnits,
599             _tokenSymbol,
600             _transfersEnabled
601             );
602 
603         newToken.changeController(msg.sender);
604         return newToken;
605     }
606 }
607 
608 contract Ownable {
609   
610   address public owner;
611 
612   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
613 
614   function Ownable() public {
615     owner = msg.sender;
616   }
617 
618   modifier onlyOwner() {
619     require(msg.sender == owner);
620     _;
621   }
622 
623   function transferOwnership(address newOwner) public onlyOwner {
624     require(newOwner != address(0));
625     emit OwnershipTransferred(owner, newOwner);
626     owner = newOwner;
627   }
628 
629 }
630 
631 
632 /*
633     Copyright 2018, Nikola Klipa @ Decenter
634 */
635 
636 /// @title ProposalManager Contract
637 /// @author Nikola Klipa @ Decenter
638 contract ProposalManager is Ownable {
639 
640     address constant NECTAR_TOKEN = 0xCc80C051057B774cD75067Dc48f8987C4Eb97A5e;
641     address constant TOKEN_FACTORY = 0x003ea7f54b6Dcf6cEE86986EdC18143A35F15505;
642     uint constant MIN_PROPOSAL_DURATION = 7;
643     uint constant MAX_PROPOSAL_DURATION = 45;
644 
645     struct Proposal {
646         address proposer;
647         uint startBlock;
648         uint startTime;
649         uint duration;
650         address token;
651         bytes32 storageHash;
652         bool approved;
653         uint yesVotes;
654         uint noVotes;
655         bool denied;
656     }
657 
658     Proposal[] proposals;
659 
660     MiniMeTokenFactory public tokenFactory;
661     address nectarToken;
662     mapping(address => bool) admins;
663 
664     modifier onlyAdmins() { 
665         require(isAdmin(msg.sender));
666         _; 
667     }
668 
669     function ProposalManager() public {
670         tokenFactory = MiniMeTokenFactory(TOKEN_FACTORY);
671         nectarToken = NECTAR_TOKEN;
672         admins[msg.sender] = true;
673     }
674 
675     /// @notice Add new proposal and put it in list to be approved
676     /// @param _duration Duration of proposal in days after it is approved
677     /// @param _storageHash Hash to text of proposal
678     /// @return Created proposal id
679     function addProposal(
680         uint _duration, // number of days
681         bytes32 _storageHash) public returns (uint _proposalId)
682     {
683         require(_duration >= MIN_PROPOSAL_DURATION);
684         require(_duration <= MAX_PROPOSAL_DURATION);
685 
686         uint amount = MiniMeToken(nectarToken).balanceOf(msg.sender);
687         require(amount > 0); // user can't submit proposal if doesn't own any tokens
688 
689         _proposalId = proposals.length;
690         proposals.length++;
691 
692         Proposal storage p = proposals[_proposalId];
693         p.storageHash = _storageHash;
694         p.duration = _duration * (1 days);
695         p.proposer = msg.sender;
696         
697         emit NewProposal(_proposalId, _duration, _storageHash);
698     }
699 
700     /// @notice Admins are able to approve proposal that someone submitted
701     /// @param _proposalId Id of proposal that admin approves
702     function approveProposal(uint _proposalId) public onlyAdmins {
703         require(proposals.length > _proposalId);
704         require(!proposals[_proposalId].denied);
705 
706         Proposal storage p = proposals[_proposalId];
707 
708         // if not checked, admin is able to restart proposal
709         require(!p.approved);
710 
711         p.token = tokenFactory.createCloneToken(
712                 nectarToken,
713                 getBlockNumber(),
714                 appendUintToString("NectarProposal-", _proposalId),
715                 MiniMeToken(nectarToken).decimals(),
716                 appendUintToString("NP-", _proposalId),
717                 true);
718 
719         p.approved = true;
720         p.startTime = now;
721         p.startBlock = getBlockNumber();
722 
723         emit Approved(_proposalId);
724     }
725 
726     /// @notice Vote for specific proposal with yes or no
727     /// @param _proposalId Id of proposal that we user is voting for
728     /// @param _yes True if user is voting for yes and false if no
729     function vote(uint _proposalId, bool _yes) public {
730         require(_proposalId < proposals.length);
731         require(checkIfCurrentlyActive(_proposalId));
732         
733         Proposal memory p = proposals[_proposalId];
734 
735         uint amount = MiniMeToken(p.token).balanceOf(msg.sender);      
736         require(amount > 0);
737 
738         require(MiniMeToken(p.token).transferFrom(msg.sender, address(this), amount));
739 
740         if (_yes) {
741             proposals[_proposalId].yesVotes += amount;    
742         }else {
743             proposals[_proposalId].noVotes += amount;
744         }
745         
746         emit Vote(_proposalId, msg.sender, _yes, amount);
747     }
748 
749     /// @notice Any admin is able to add new admin
750     /// @param _newAdmin Address of new admin
751     function addAdmin(address _newAdmin) public onlyAdmins {
752         admins[_newAdmin] = true;
753     }
754 
755     /// @notice Only owner is able to remove admin
756     /// @param _admin Address of current admin
757     function removeAdmin(address _admin) public onlyOwner {
758         admins[_admin] = false;
759     }
760 
761     /// @notice Get data about specific proposal
762     /// @param _proposalId Id of proposal 
763     function proposal(uint _proposalId) public view returns(
764         address _proposer,
765         uint _startBlock,
766         uint _startTime,
767         uint _duration,
768         bytes32 _storageHash,
769         bool _active,
770         bool _finalized,
771         uint _totalYes,
772         uint _totalNo,
773         address _token,
774         bool _approved,
775         bool _denied,
776         bool _hasBalance
777     ) {
778         require(_proposalId < proposals.length);
779 
780         Proposal memory p = proposals[_proposalId];
781         _proposer = p.proposer;
782         _startBlock = p.startBlock;
783         _startTime = p.startTime;
784         _duration = p.duration;
785         _storageHash = p.storageHash;
786         _finalized = (_startTime+_duration < now);
787         _active = !_finalized && (p.startBlock < getBlockNumber()) && p.approved;
788         _totalYes = p.yesVotes;
789         _totalNo = p.noVotes;
790         _token = p.token;
791         _approved = p.approved;
792         _denied = p.denied;
793         _hasBalance = (p.token == 0x0) ? false : (MiniMeToken(p.token).balanceOf(msg.sender) > 0);
794     }
795 
796     function denyProposal(uint _proposalId) public onlyAdmins {
797         require(!proposals[_proposalId].approved);
798 
799         proposals[_proposalId].denied = true;
800     }
801 
802     /// @notice Get all not approved proposals
803     /// @dev looping two times through array so we can make array with exact count
804     ///       because of Solidity limitation to make dynamic array in memory
805     function getNotApprovedProposals() public view returns(uint[]) {
806         uint count = 0;
807         for (uint i=0; i<proposals.length; i++) {
808             if (!proposals[i].approved && !proposals[i].denied) {
809                 count++;
810             }
811         }
812 
813         uint[] memory notApprovedProposals = new uint[](count);
814         count = 0;
815         for (i=0; i<proposals.length; i++) {
816             if (!proposals[i].approved && !proposals[i].denied) {
817                 notApprovedProposals[count] = i;
818                 count++;
819             }
820         }
821 
822         return notApprovedProposals;
823     }
824 
825     /// @notice Get all approved proposals
826     /// @dev looping two times through array so we can make array with exact count
827     ///       because of Solidity limitation to make dynamic array in memory
828     function getApprovedProposals() public view returns(uint[]) {
829         uint count = 0;
830         for (uint i=0; i<proposals.length; i++) {
831             if (proposals[i].approved && !proposals[i].denied) {
832                 count++;
833             }
834         }
835 
836         uint[] memory approvedProposals = new uint[](count);
837         count = 0;
838         for (i=0; i<proposals.length; i++) {
839             if (proposals[i].approved && !proposals[i].denied) {
840                 approvedProposals[count] = i;
841                 count++;
842             }
843         }
844 
845         return approvedProposals;
846     }
847 
848     /// @notice Get all active proposals
849     /// @dev looping two times through array so we can make array with exact count
850     ///       because of Solidity limitation to make dynamic array in memory
851     function getActiveProposals() public view returns(uint[]) {
852         uint count = 0;
853         for (uint i=0; i<proposals.length; i++) {
854             if (checkIfCurrentlyActive(i)) {
855                 count++;
856             }
857         }
858 
859         uint[] memory activeProposals = new uint[](count);
860         count = 0;
861         for (i=0; i<proposals.length; i++) {
862             if (checkIfCurrentlyActive(i)) {
863                 activeProposals[count] = i;
864                 count++;
865             }
866         }
867 
868         return activeProposals;
869     }
870 
871     function appendUintToString(string inStr, uint v) private pure returns (string str) {
872         uint maxlength = 100;
873         bytes memory reversed = new bytes(maxlength);
874         uint i = 0;
875         if (v==0) {
876             reversed[i++] = byte(48);  
877         } else { 
878             while (v != 0) {
879                 uint remainder = v % 10;
880                 v = v / 10;
881                 reversed[i++] = byte(48 + remainder);
882             }
883         }
884         bytes memory inStrb = bytes(inStr);
885         bytes memory s = new bytes(inStrb.length + i);
886         uint j;
887         for (j = 0; j < inStrb.length; j++) {
888             s[j] = inStrb[j];
889         }
890         for (j = 0; j < i; j++) {
891             s[j + inStrb.length] = reversed[i - 1 - j];
892         }
893         str = string(s);
894     }
895 
896     function nProposals() public view returns(uint) {
897         return proposals.length;
898     }
899 
900     function isAdmin(address _admin) public view returns(bool) {
901         return admins[_admin];
902     }
903 
904     function checkIfCurrentlyActive(uint _proposalId) private view returns(bool) {
905         Proposal memory p = proposals[_proposalId];
906         return (p.startTime + p.duration > now && p.startTime < now && p.approved && !p.denied);    
907     }  
908     
909     function proxyPayment(address ) public payable returns(bool) {
910         return false;
911     }
912 
913     function onTransfer(address , address , uint ) public pure returns(bool) {
914         return true;
915     }
916 
917     function onApprove(address , address , uint ) public pure returns(bool) {
918         return true;
919     }
920 
921     function getBlockNumber() internal constant returns (uint) {
922         return block.number;
923     }
924 
925     event Vote(uint indexed idProposal, address indexed _voter, bool yes, uint amount);
926     event Approved(uint indexed idProposal);
927     event NewProposal(uint indexed idProposal, uint duration, bytes32 storageHash);
928 }