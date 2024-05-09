1 pragma solidity ^0.4.18;
2 
3 /*
4     Copyright 2017, Jordi Baylina
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
20 /// @title MyEtherWallet Campaign Contract
21 /// @author Jordi Baylina and Arthur Lunn
22 /// @dev This contract controls the issuance of tokens for the MiniMe Token
23 ///  Contract. This version specifically acts as a Campaign manager for raising
24 ///  funds for non-profit causes, but it can be customized for any variety of
25 ///  purposes.
26 
27 /// @dev Basic contract to allow a contract to be controlled by a `controller`
28 contract Controlled {
29 
30     /// @notice The address of the controller is the only address that can call
31     ///  a function with this modifier
32     modifier onlyController { require(msg.sender == controller); _; }
33 
34     address public controller;
35 
36     function Controlled() public { controller = msg.sender;}
37 
38     /// @notice Changes the controller of the contract
39     /// @param _newController The new controller of the contract
40     function changeController(address _newController) public onlyController {
41         controller = _newController;
42     }
43 }
44 
45 ////////////////////////////////////////////////////////////////////////////////
46 
47 /// @dev The token controller contract must implement these functions
48 contract TokenController {
49 
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
73 ////////////////////////////////////////////////////////////////////////////////
74 
75 /// @dev A simple contract to allow data to be properly attached in the 
76 ///  `approveAndCall()`
77 contract ApproveAndCallFallBack {
78     function receiveApproval(
79         address from,
80         uint256 _amount,
81         address _token,
82         bytes _data
83     ) public;
84 }
85 
86 ////////////////////////////////////////////////////////////////////////////////
87 
88 /// @dev The actual token contract, the default controller is the msg.sender
89 ///  that deploys the contract, so usually this token will be deployed by a
90 ///  token controller contract, which Giveth will call a "Campaign"
91 contract MiniMeToken is Controlled {
92 
93     string public name;                //The Token's name: e.g. DigixDAO Tokens
94     uint8 public decimals;             //Number of decimals of the smallest unit
95     string public symbol;              //An identifier: e.g. REP
96     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
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
156     function MiniMeToken(
157         address _tokenFactory,
158         address _parentToken,
159         uint _parentSnapShotBlock,
160         string _tokenName,
161         uint8 _decimalUnits,
162         string _tokenSymbol,
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
180     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
181     /// @param _to The address of the recipient
182     /// @param _amount The amount of tokens to be transferred
183     /// @return Whether the transfer was successful or not
184     function transfer(address _to, uint256 _amount) public returns (bool success) {
185         require(transfersEnabled);
186         return doTransfer(msg.sender, _to, _amount);
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
206             if (allowed[_from][msg.sender] < _amount) return false;
207             allowed[_from][msg.sender] -= _amount;
208         }
209         return doTransfer(_from, _to, _amount);
210     }
211 
212     /// @dev This is the actual transfer function in the token contract, it can
213     ///  only be called by other functions in this contract.
214     /// @param _from The address holding the tokens being transferred
215     /// @param _to The address of the recipient
216     /// @param _amount The amount of tokens to be transferred
217     /// @return True if the transfer was successful
218     function doTransfer(address _from, address _to, uint _amount
219     ) internal returns(bool) {
220 
221            if (_amount == 0) {
222                return true;
223            }
224 
225            require(parentSnapShotBlock < block.number);
226 
227            // Do not allow transfer to 0x0 or the token contract itself
228            require((_to != 0) && (_to != address(this)));
229 
230            // If the amount being transfered is more than the balance of the
231            //  account the transfer returns false
232            var previousBalanceFrom = balanceOfAt(_from, block.number);
233            if (previousBalanceFrom < _amount) {
234                return false;
235            }
236 
237            // Alerts the token controller of the transfer
238            if (isContract(controller)) {
239                require(TokenController(controller).onTransfer(_from, _to, _amount));
240            }
241 
242            // First update the balance array with the new value for the address
243            //  sending the tokens
244            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
245 
246            // Then update the balance array with the new value for the address
247            //  receiving the tokens
248            var previousBalanceTo = balanceOfAt(_to, block.number);
249            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
250            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
251 
252            // An event to make the transfer easy to find on the blockchain
253            Transfer(_from, _to, _amount);
254 
255            return true;
256     }
257 
258     /// @param _owner The address that's balance is being requested
259     /// @return The balance of `_owner` at the current block
260     function balanceOf(address _owner) public constant returns (uint256 balance) {
261         return balanceOfAt(_owner, block.number);
262     }
263 
264     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
265     ///  its behalf. This is a modified version of the ERC20 approve function
266     ///  to be a little bit safer
267     /// @param _spender The address of the account able to transfer the tokens
268     /// @param _amount The amount of tokens to be approved for transfer
269     /// @return True if the approval was successful
270     function approve(address _spender, uint256 _amount) public returns (bool success) {
271         require(transfersEnabled);
272 
273         // To change the approve amount you first have to reduce the addresses`
274         //  allowance to zero by calling `approve(_spender,0)` if it is not
275         //  already 0 to mitigate the race condition described here:
276         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
278 
279         // Alerts the token controller of the approve function call
280         if (isContract(controller)) {
281             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
282         }
283 
284         allowed[msg.sender][_spender] = _amount;
285         Approval(msg.sender, _spender, _amount);
286         return true;
287     }
288 
289     /// @dev This function makes it easy to read the `allowed[]` map
290     /// @param _owner The address of the account that owns the token
291     /// @param _spender The address of the account able to transfer the tokens
292     /// @return Amount of remaining tokens of _owner that _spender is allowed
293     ///  to spend
294     function allowance(address _owner, address _spender
295     ) public constant returns (uint256 remaining) {
296         return allowed[_owner][_spender];
297     }
298 
299     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
300     ///  its behalf, and then a function is triggered in the contract that is
301     ///  being approved, `_spender`. This allows users to use their tokens to
302     ///  interact with contracts in one function call instead of two
303     /// @param _spender The address of the contract able to transfer the tokens
304     /// @param _amount The amount of tokens to be approved for transfer
305     /// @return True if the function call was successful
306     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
307     ) public returns (bool success) {
308         require(approve(_spender, _amount));
309 
310         ApproveAndCallFallBack(_spender).receiveApproval(
311             msg.sender,
312             _amount,
313             this,
314             _extraData
315         );
316 
317         return true;
318     }
319 
320     /// @dev This function makes it easy to get the total number of tokens
321     /// @return The total number of tokens
322     function totalSupply() public constant returns (uint) {
323         return totalSupplyAt(block.number);
324     }
325 
326 
327 ////////////////
328 // Query balance and totalSupply in History
329 ////////////////
330 
331     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
332     /// @param _owner The address from which the balance will be retrieved
333     /// @param _blockNumber The block number when the balance is queried
334     /// @return The balance at `_blockNumber`
335     function balanceOfAt(address _owner, uint _blockNumber) public constant
336         returns (uint) {
337 
338         // These next few lines are used when the balance of the token is
339         //  requested before a check point was ever created for this token, it
340         //  requires that the `parentToken.balanceOfAt` be queried at the
341         //  genesis block for that token as this contains initial balance of
342         //  this token
343         if ((balances[_owner].length == 0)
344             || (balances[_owner][0].fromBlock > _blockNumber)) {
345             if (address(parentToken) != 0) {
346                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
347             } else {
348                 // Has no parent
349                 return 0;
350             }
351 
352         // This will return the expected balance during normal situations
353         } else {
354             return getValueAt(balances[_owner], _blockNumber);
355         }
356     }
357 
358     /// @notice Total amount of tokens at a specific `_blockNumber`.
359     /// @param _blockNumber The block number when the totalSupply is queried
360     /// @return The total amount of tokens at `_blockNumber`
361     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
362 
363         // These next few lines are used when the totalSupply of the token is
364         //  requested before a check point was ever created for this token, it
365         //  requires that the `parentToken.totalSupplyAt` be queried at the
366         //  genesis block for this token as that contains totalSupply of this
367         //  token at this block number.
368         if ((totalSupplyHistory.length == 0)
369             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
370             if (address(parentToken) != 0) {
371                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
372             } else {
373                 return 0;
374             }
375 
376         // This will return the expected totalSupply during normal situations
377         } else {
378             return getValueAt(totalSupplyHistory, _blockNumber);
379         }
380     }
381 
382 ////////////////
383 // Clone Token Method
384 ////////////////
385 
386     /// @notice Creates a new clone token with the initial distribution being
387     ///  this token at `_snapshotBlock`
388     /// @param _cloneTokenName Name of the clone token
389     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
390     /// @param _cloneTokenSymbol Symbol of the clone token
391     /// @param _snapshotBlock Block when the distribution of the parent token is
392     ///  copied to set the initial distribution of the new clone token;
393     ///  if the block is zero than the actual block, the current block is used
394     /// @param _transfersEnabled True if transfers are allowed in the clone
395     /// @return The address of the new MiniMeToken Contract
396     function createCloneToken(
397         string _cloneTokenName,
398         uint8 _cloneDecimalUnits,
399         string _cloneTokenSymbol,
400         uint _snapshotBlock,
401         bool _transfersEnabled
402         ) public returns(address) {
403         if (_snapshotBlock == 0) _snapshotBlock = block.number;
404         MiniMeToken cloneToken = tokenFactory.createCloneToken(
405             this,
406             _snapshotBlock,
407             _cloneTokenName,
408             _cloneDecimalUnits,
409             _cloneTokenSymbol,
410             _transfersEnabled
411             );
412 
413         cloneToken.changeController(msg.sender);
414 
415         // An event to make the token easy to find on the blockchain
416         NewCloneToken(address(cloneToken), _snapshotBlock);
417         return address(cloneToken);
418     }
419 
420 ////////////////
421 // Generate and destroy tokens
422 ////////////////
423 
424     /// @notice Generates `_amount` tokens that are assigned to `_owner`
425     /// @param _owner The address that will be assigned the new tokens
426     /// @param _amount The quantity of tokens generated
427     /// @return True if the tokens are generated correctly
428     function generateTokens(address _owner, uint _amount
429     ) public onlyController returns (bool) {
430         uint curTotalSupply = totalSupply();
431         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
432         uint previousBalanceTo = balanceOf(_owner);
433         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
434         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
435         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
436         Transfer(0, _owner, _amount);
437         return true;
438     }
439 
440 
441     /// @notice Burns `_amount` tokens from `_owner`
442     /// @param _owner The address that will lose the tokens
443     /// @param _amount The quantity of tokens to burn
444     /// @return True if the tokens are burned correctly
445     function destroyTokens(address _owner, uint _amount
446     ) onlyController public returns (bool) {
447         uint curTotalSupply = totalSupply();
448         require(curTotalSupply >= _amount);
449         uint previousBalanceFrom = balanceOf(_owner);
450         require(previousBalanceFrom >= _amount);
451         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
452         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
453         Transfer(_owner, 0, _amount);
454         return true;
455     }
456 
457 ////////////////
458 // Enable tokens transfers
459 ////////////////
460 
461 
462     /// @notice Enables token holders to transfer their tokens freely if true
463     /// @param _transfersEnabled True if transfers are allowed in the clone
464     function enableTransfers(bool _transfersEnabled) public onlyController {
465         transfersEnabled = _transfersEnabled;
466     }
467 
468 ////////////////
469 // Internal helper functions to query and set a value in a snapshot array
470 ////////////////
471 
472     /// @dev `getValueAt` retrieves the number of tokens at a given block number
473     /// @param checkpoints The history of values being queried
474     /// @param _block The block number to retrieve the value at
475     /// @return The number of tokens being queried
476     function getValueAt(Checkpoint[] storage checkpoints, uint _block
477     ) constant internal returns (uint) {
478         if (checkpoints.length == 0) return 0;
479 
480         // Shortcut for the actual value
481         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
482             return checkpoints[checkpoints.length-1].value;
483         if (_block < checkpoints[0].fromBlock) return 0;
484 
485         // Binary search of the value in the array
486         uint min = 0;
487         uint max = checkpoints.length-1;
488         while (max > min) {
489             uint mid = (max + min + 1)/ 2;
490             if (checkpoints[mid].fromBlock<=_block) {
491                 min = mid;
492             } else {
493                 max = mid-1;
494             }
495         }
496         return checkpoints[min].value;
497     }
498 
499     /// @dev `updateValueAtNow` used to update the `balances` map and the
500     ///  `totalSupplyHistory`
501     /// @param checkpoints The history of data being updated
502     /// @param _value The new number of tokens
503     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
504     ) internal  {
505         if ((checkpoints.length == 0)
506         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
507                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
508                newCheckPoint.fromBlock =  uint128(block.number);
509                newCheckPoint.value = uint128(_value);
510            } else {
511                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
512                oldCheckPoint.value = uint128(_value);
513            }
514     }
515 
516     /// @dev Internal function to determine if an address is a contract
517     /// @param _addr The address being queried
518     /// @return True if `_addr` is a contract
519     function isContract(address _addr) constant internal returns(bool) {
520         uint size;
521         if (_addr == 0) return false;
522         assembly {
523             size := extcodesize(_addr)
524         }
525         return size>0;
526     }
527 
528     /// @dev Helper function to return a min betwen the two uints
529     function min(uint a, uint b) pure internal returns (uint) {
530         return a < b ? a : b;
531     }
532 
533     /// @notice The fallback function: If the contract's controller has not been
534     ///  set to 0, then the `proxyPayment` method is called which relays the
535     ///  ether and creates tokens as described in the token controller contract
536     function () public payable {
537         require(isContract(controller));
538         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
539     }
540 
541 //////////
542 // Safety Methods
543 //////////
544 
545     /// @notice This method can be used by the controller to extract mistakenly
546     ///  sent tokens to this contract.
547     /// @param _token The address of the token contract that you want to recover
548     ///  set to 0 in case you want to extract ether.
549     function claimTokens(address _token) public onlyController {
550         if (_token == 0x0) {
551             controller.transfer(this.balance);
552             return;
553         }
554 
555         MiniMeToken token = MiniMeToken(_token);
556         uint balance = token.balanceOf(this);
557         token.transfer(controller, balance);
558         ClaimedTokens(_token, controller, balance);
559     }
560 
561 ////////////////
562 // Events
563 ////////////////
564     event ClaimedTokens(
565         address indexed _token,
566         address indexed _controller, 
567         uint _amount
568         );
569     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
570     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
571     event Approval(
572         address indexed _owner,
573         address indexed _spender,
574         uint256 _amount
575         );
576 }
577 
578 ////////////////////////////////////////////////////////////////////////////////
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
622 ////////////////////////////////////////////////////////////////////////////////
623 
624 /**
625  * @title ERC20
626  * @dev A standard interface for tokens.
627  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
628  */
629 contract ERC20 {
630   
631     /// @dev Returns the total token supply
632     function totalSupply() public constant returns (uint256 supply);
633 
634     /// @dev Returns the account balance of the account with address _owner
635     function balanceOf(address _owner) public constant returns (uint256 balance);
636 
637     /// @dev Transfers _value number of tokens to address _to
638     function transfer(address _to, uint256 _value) public returns (bool success);
639 
640     /// @dev Transfers _value number of tokens from address _from to address _to
641     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
642 
643     /// @dev Allows _spender to withdraw from the msg.sender's account up to the _value amount
644     function approve(address _spender, uint256 _value) public returns (bool success);
645 
646     /// @dev Returns the amount which _spender is still allowed to withdraw from _owner
647     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
648 
649     event Transfer(address indexed _from, address indexed _to, uint256 _value);
650     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
651 
652 }
653 
654 ////////////////////////////////////////////////////////////////////////////////
655 /////// The Campaign Contracts
656 ////////////////////////////////////////////////////////////////////////////////
657 
658 /// @title Owned
659 /// @author Adrià Massanet <adria@codecontext.io>
660 /// @notice The Owned contract has an owner address, and provides basic 
661 ///  authorization control functions, this simplifies & the implementation of
662 ///  user permissions; this contract has three work flows for a change in
663 ///  ownership, the first requires the new owner to validate that they have the
664 ///  ability to accept ownership, the second allows the ownership to be
665 ///  directly transfered without requiring acceptance, and the third allows for
666 ///  the ownership to be removed to allow for decentralization 
667 contract Owned {
668 
669     address public owner;
670     address public newOwnerCandidate;
671 
672     event OwnershipRequested(address indexed by, address indexed to);
673     event OwnershipTransferred(address indexed from, address indexed to);
674     event OwnershipRemoved();
675 
676     /// @dev The constructor sets the `msg.sender` as the`owner` of the contract
677     function Owned() {
678         owner = msg.sender;
679     }
680 
681     /// @dev `owner` is the only address that can call a function with this
682     /// modifier
683     modifier onlyOwner() {
684         require (msg.sender == owner);
685         _;
686     }
687     
688     /// @dev In this 1st option for ownership transfer `proposeOwnership()` must
689     ///  be called first by the current `owner` then `acceptOwnership()` must be
690     ///  called by the `newOwnerCandidate`
691     /// @notice `onlyOwner` Proposes to transfer control of the contract to a
692     ///  new owner
693     /// @param _newOwnerCandidate The address being proposed as the new owner
694     function proposeOwnership(address _newOwnerCandidate) onlyOwner {
695         newOwnerCandidate = _newOwnerCandidate;
696         OwnershipRequested(msg.sender, newOwnerCandidate);
697     }
698 
699     /// @notice Can only be called by the `newOwnerCandidate`, accepts the
700     ///  transfer of ownership
701     function acceptOwnership() {
702         require(msg.sender == newOwnerCandidate);
703 
704         address oldOwner = owner;
705         owner = newOwnerCandidate;
706         newOwnerCandidate = 0x0;
707 
708         OwnershipTransferred(oldOwner, owner);
709     }
710 
711     /// @dev In this 2nd option for ownership transfer `changeOwnership()` can
712     ///  be called and it will immediately assign ownership to the `newOwner`
713     /// @notice `owner` can step down and assign some other address to this role
714     /// @param _newOwner The address of the new owner
715     function changeOwnership(address _newOwner) onlyOwner {
716         require(_newOwner != 0x0);
717 
718         address oldOwner = owner;
719         owner = _newOwner;
720         newOwnerCandidate = 0x0;
721 
722         OwnershipTransferred(oldOwner, owner);
723     }
724 
725     /// @dev In this 3rd option for ownership transfer `removeOwnership()` can
726     ///  be called and it will immediately assign ownership to the 0x0 address;
727     ///  it requires a 0xdece be input as a parameter to prevent accidental use
728     /// @notice Decentralizes the contract, this operation cannot be undone 
729     /// @param _dac `0xdac` has to be entered for this function to work
730     function removeOwnership(uint _dac) onlyOwner {
731         require(_dac == 0xdac);
732         owner = 0x0;
733         newOwnerCandidate = 0x0;
734         OwnershipRemoved();     
735     }
736 }
737 
738 ////////////////////////////////////////////////////////////////////////////////
739 
740 
741 /// @dev `Escapable` is a base level contract built off of the `Owned`
742 ///  contract; it creates an escape hatch function that can be called in an
743 ///  emergency that will allow designated addresses to send any ether or tokens
744 ///  held in the contract to an `escapeHatchDestination` as long as they were
745 ///  not blacklisted
746 contract Escapable is Owned {
747     address public escapeHatchCaller;
748     address public escapeHatchDestination;
749     mapping (address=>bool) private escapeBlacklist; // Token contract addresses
750 
751     /// @notice The Constructor assigns the `escapeHatchDestination` and the
752     ///  `escapeHatchCaller`
753     /// @param _escapeHatchCaller The address of a trusted account or contract
754     ///  to call `escapeHatch()` to send the ether in this contract to the
755     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
756     ///  cannot move funds out of `escapeHatchDestination`
757     /// @param _escapeHatchDestination The address of a safe location (usu a
758     ///  Multisig) to send the ether held in this contract; if a neutral address
759     ///  is required, the WHG Multisig is an option:
760     ///  0x8Ff920020c8AD673661c8117f2855C384758C572 
761     function Escapable(address _escapeHatchCaller, address _escapeHatchDestination) {
762         escapeHatchCaller = _escapeHatchCaller;
763         escapeHatchDestination = _escapeHatchDestination;
764     }
765 
766     /// @dev The addresses preassigned as `escapeHatchCaller` or `owner`
767     ///  are the only addresses that can call a function with this modifier
768     modifier onlyEscapeHatchCallerOrOwner {
769         require ((msg.sender == escapeHatchCaller)||(msg.sender == owner));
770         _;
771     }
772 
773     /// @notice Creates the blacklist of tokens that are not able to be taken
774     ///  out of the contract; can only be done at the deployment, and the logic
775     ///  to add to the blacklist will be in the constructor of a child contract
776     /// @param _token the token contract address that is to be blacklisted 
777     function blacklistEscapeToken(address _token) internal {
778         escapeBlacklist[_token] = true;
779         EscapeHatchBlackistedToken(_token);
780     }
781 
782     /// @notice Checks to see if `_token` is in the blacklist of tokens
783     /// @param _token the token address being queried
784     /// @return False if `_token` is in the blacklist and can't be taken out of
785     ///  the contract via the `escapeHatch()`
786     function isTokenEscapable(address _token) constant public returns (bool) {
787         return !escapeBlacklist[_token];
788     }
789 
790     /// @notice The `escapeHatch()` should only be called as a last resort if a
791     /// security issue is uncovered or something unexpected happened
792     /// @param _token to transfer, use 0x0 for ether
793     function escapeHatch(address _token) public onlyEscapeHatchCallerOrOwner {   
794         require(escapeBlacklist[_token]==false);
795 
796         uint256 balance;
797 
798         /// @dev Logic for ether
799         if (_token == 0x0) {
800             balance = this.balance;
801             escapeHatchDestination.transfer(balance);
802             EscapeHatchCalled(_token, balance);
803             return;
804         }
805         /// @dev Logic for tokens
806         ERC20 token = ERC20(_token);
807         balance = token.balanceOf(this);
808         token.transfer(escapeHatchDestination, balance);
809         EscapeHatchCalled(_token, balance);
810     }
811 
812     /// @notice Changes the address assigned to call `escapeHatch()`
813     /// @param _newEscapeHatchCaller The address of a trusted account or
814     ///  contract to call `escapeHatch()` to send the value in this contract to
815     ///  the `escapeHatchDestination`; it would be ideal that `escapeHatchCaller`
816     ///  cannot move funds out of `escapeHatchDestination`
817     function changeHatchEscapeCaller(address _newEscapeHatchCaller) onlyEscapeHatchCallerOrOwner {
818         escapeHatchCaller = _newEscapeHatchCaller;
819     }
820 
821     event EscapeHatchBlackistedToken(address token);
822     event EscapeHatchCalled(address token, uint amount);
823 }
824 
825 ////////////////////////////////////////////////////////////////////////////////
826 
827 /// @dev This is designed to control the issuance of a MiniMe Token for a
828 ///  non-profit Campaign. This contract effectively dictates the terms of the
829 ///  funding round.
830 contract GivethCampaign is TokenController, Owned, Escapable {
831 
832     uint public startFundingTime;       // In UNIX Time Format
833     uint public endFundingTime;         // In UNIX Time Format
834     uint public maximumFunding;         // In wei
835     uint public totalCollected;         // In wei
836     MiniMeToken public tokenContract;   // The new token for this Campaign
837     address public vaultAddress;        // The address to hold the funds donated
838 
839     /// @notice 'GivethCampaign()' initiates the Campaign by setting its funding
840     ///  parameters; there are several checks to make sure the parameters are 
841     ///  acceptable
842     /// @param _startFundingTime The UNIX time that the Campaign will be able to
843     ///  start receiving funds
844     /// @param _endFundingTime The UNIX time that the Campaign will stop being
845     ///  able to receive funds
846     /// @param _maximumFunding In wei, the Maximum amount that the Campaign can
847     ///  receive (currently the max is set at 10,000 ETH for the beta)
848     /// @param _vaultAddress The address that will store the donated funds
849     /// @param _tokenAddress The token contract address this contract controls
850     function GivethCampaign(
851         address _escapeHatchCaller,
852         address _escapeHatchDestination,        
853         uint _startFundingTime,
854         uint _endFundingTime,
855         uint _maximumFunding,
856         address _vaultAddress,
857         address _tokenAddress
858     ) Escapable(_escapeHatchCaller, _escapeHatchDestination) {
859         require(_endFundingTime > now);                // Cannot end in the past
860         require(_endFundingTime > _startFundingTime);
861         require(_maximumFunding <= 1000000 ether);    // The Beta is limited
862         require(_vaultAddress != 0);                // To prevent burning ETH
863         startFundingTime = _startFundingTime;
864         endFundingTime = _endFundingTime;
865         maximumFunding = _maximumFunding;
866         tokenContract = MiniMeToken(_tokenAddress);// The deployed Token Contract
867         vaultAddress = _vaultAddress;
868     }
869 
870     /// @notice `finalizeFunding()` ends the Campaign by setting the controller
871     ///  to 0, thereby ending the issuance of new tokens and stopping the
872     ///  Campaign from receiving more ether; can only be called after the end of
873     ///  the funding period.
874     function finalizeFunding() {
875         require (now >= endFundingTime);
876         tokenContract.changeController(0);
877     }
878 
879     /// @notice `onlyOwner` changes the location that ether is sent
880     /// @param _newVaultAddress The address that will receive the ether sent to
881     ///  the Campaign
882     function setVault(address _newVaultAddress) onlyOwner {
883         vaultAddress = _newVaultAddress;
884     }
885 
886     /// @dev The fallback function is called when ether is sent to the contract,
887     ///  it calls `doPayment()` with the address that sent the ether as the
888     ///  `_owner`; `payable` is a required solidity modifier for functions to 
889     ///  receive ether, without this modifier functions will throw when ether is
890     ///  sent to them
891     function ()  payable {
892         doPayment(msg.sender);
893     }
894 
895     /// @dev `doPayment()` is an internal function that sends the ether this
896     ///  contract receives to the `vault` and creates tokens in the address of
897     ///  the `_owner` as long as the Campaign is still accepting funds
898     /// @param _owner The address that will hold the newly created tokens
899     function doPayment(address _owner) internal {
900 
901         // First check that the Campaign is allowed to receive this donation
902         require(now>=startFundingTime);
903         require(now<=endFundingTime);               // Extra check
904         require(tokenContract.controller() != 0);   // Extra check
905         require(msg.value != 0);
906         require(totalCollected + msg.value <= maximumFunding);
907 
908         //Track how much the Campaign has collected
909         totalCollected += msg.value;
910 
911         //Send the ether to the vault
912         require(vaultAddress.send(msg.value));
913 
914         // Creates an equal amount of tokens as ether sent; the new tokens are
915         //  created in the `_owner` address
916         require(tokenContract.generateTokens(_owner, msg.value));
917 
918         return;
919     }
920 
921 /////////////////
922 // TokenController interface
923 /////////////////
924 
925     /// @notice `proxyPayment()` allows the caller to send ether to the Campaign
926     ///  and have the tokens created in an address of their choosing
927     /// @param _owner The address that will hold the newly created tokens
928     function proxyPayment(address _owner) payable returns(bool) {
929         doPayment(_owner);
930         return true;
931     }
932 
933     /// @notice Notifies the controller about a transfer, for this Campaign all
934     ///  transfers are allowed by default and no extra notifications are needed
935     /// @param _from The origin of the transfer
936     /// @param _to The destination of the transfer
937     /// @param _amount The amount of the transfer
938     /// @return False if the controller does not authorize the transfer
939     function onTransfer(address _from, address _to, uint _amount) returns(bool) {
940         return true;
941     }
942 
943     /// @notice Notifies the controller about an approval, for this Campaign all
944     ///  approvals are allowed by default and no extra notifications are needed
945     /// @param _owner The address that calls `approve()`
946     /// @param _spender The spender in the `approve()` call
947     /// @param _amount The amount in the `approve()` call
948     /// @return False if the controller does not authorize the approval
949     function onApprove(address _owner, address _spender, uint _amount)
950         returns(bool)
951     {
952         return true;
953     }
954 }