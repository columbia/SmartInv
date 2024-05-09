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
27 /// @dev Basic contract to indivate whether another contract is controlled
28 contract Controlled {
29     /// @notice The address of the controller is the only address that can call
30     ///  a function with this modifier
31     modifier onlyController { require(msg.sender == controller); _; }
32 
33     address public controller;
34 
35     function Controlled() public { controller = msg.sender;}
36 
37     /// @notice Changes the controller of the contract
38     /// @param _newController The new controller of the contract
39     function changeController(address _newController) public onlyController {
40         controller = _newController;
41     }
42 }
43 
44 /// @dev The token controller contract must implement these functions
45 contract TokenController {
46     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
47     /// @param _owner The address that sent the ether to create tokens
48     /// @return True if the ether is accepted, false if it throws
49     function proxyPayment(address _owner) public payable returns(bool);
50 
51     /// @notice Notifies the controller about a token transfer allowing the
52     ///  controller to react if desired
53     /// @param _from The origin of the transfer
54     /// @param _to The destination of the transfer
55     /// @param _amount The amount of the transfer
56     /// @return False if the controller does not authorize the transfer
57     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
58 
59     /// @notice Notifies the controller about an approval allowing the
60     ///  controller to react if desired
61     /// @param _owner The address that calls `approve()`
62     /// @param _spender The spender in the `approve()` call
63     /// @param _amount The amount in the `approve()` call
64     /// @return False if the controller does not authorize the approval
65     function onApprove(address _owner, address _spender, uint _amount) public
66         returns(bool);
67 }
68 
69 contract ApproveAndCallFallBack {
70     function receiveApproval(
71         address from,
72         uint256 _amount,
73         address _token,
74         bytes _data
75     ) public;
76 }
77 
78 /// @dev The actual token contract, the default controller is the msg.sender
79 ///  that deploys the contract, so usually this token will be deployed by a
80 ///  token controller contract, which Giveth will call a "Campaign"
81 contract MiniMeToken is Controlled {
82 
83     string public name;                //The Token's name: e.g. DigixDAO Tokens
84     uint8 public decimals;             //Number of decimals of the smallest unit
85     string public symbol;              //An identifier: e.g. REP
86     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
87 
88 
89     /// @dev `Checkpoint` is the structure that attaches a block number to a
90     ///  given value, the block number attached is the one that last changed the
91     ///  value
92     struct  Checkpoint {
93 
94         // `fromBlock` is the block number that the value was generated from
95         uint128 fromBlock;
96 
97         // `value` is the amount of tokens at a specific block number
98         uint128 value;
99     }
100 
101     // `parentToken` is the Token address that was cloned to produce this token;
102     //  it will be 0x0 for a token that was not cloned
103     MiniMeToken public parentToken;
104 
105     // `parentSnapShotBlock` is the block number from the Parent Token that was
106     //  used to determine the initial distribution of the Clone Token
107     uint public parentSnapShotBlock;
108 
109     // `creationBlock` is the block number that the Clone Token was created
110     uint public creationBlock;
111 
112     // `balances` is the map that tracks the balance of each address, in this
113     //  contract when the balance changes the block number that the change
114     //  occurred is also included in the map
115     mapping (address => Checkpoint[]) balances;
116 
117     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
118     mapping (address => mapping (address => uint256)) allowed;
119 
120     // Tracks the history of the `totalSupply` of the token
121     Checkpoint[] totalSupplyHistory;
122 
123     // Flag that determines if the token is transferable or not.
124     bool public transfersEnabled;
125 
126     // The factory used to create new clone tokens
127     MiniMeTokenFactory public tokenFactory;
128 
129 ////////////////
130 // Constructor
131 ////////////////
132 
133     /// @notice Constructor to create a MiniMeToken
134     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
135     ///  will create the Clone token contracts, the token factory needs to be
136     ///  deployed first
137     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
138     ///  new token
139     /// @param _parentSnapShotBlock Block of the parent token that will
140     ///  determine the initial distribution of the clone token, set to 0 if it
141     ///  is a new token
142     /// @param _tokenName Name of the new token
143     /// @param _decimalUnits Number of decimals of the new token
144     /// @param _tokenSymbol Token Symbol for the new token
145     /// @param _transfersEnabled If true, tokens will be able to be transferred
146     function MiniMeToken(
147         address _tokenFactory,
148         address _parentToken,
149         uint _parentSnapShotBlock,
150         string _tokenName,
151         uint8 _decimalUnits,
152         string _tokenSymbol,
153         bool _transfersEnabled
154     ) public {
155         tokenFactory = MiniMeTokenFactory(_tokenFactory);
156         name = _tokenName;                                 // Set the name
157         decimals = _decimalUnits;                          // Set the decimals
158         symbol = _tokenSymbol;                             // Set the symbol
159         parentToken = MiniMeToken(_parentToken);
160         parentSnapShotBlock = _parentSnapShotBlock;
161         transfersEnabled = _transfersEnabled;
162         creationBlock = block.number;
163     }
164 
165 
166 ///////////////////
167 // ERC20 Methods
168 ///////////////////
169 
170     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
171     /// @param _to The address of the recipient
172     /// @param _amount The amount of tokens to be transferred
173     /// @return Whether the transfer was successful or not
174     function transfer(address _to, uint256 _amount) public returns (bool success) {
175         require(transfersEnabled);
176         return doTransfer(msg.sender, _to, _amount);
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
196             if (allowed[_from][msg.sender] < _amount) return false;
197             allowed[_from][msg.sender] -= _amount;
198         }
199         return doTransfer(_from, _to, _amount);
200     }
201 
202     /// @dev This is the actual transfer function in the token contract, it can
203     ///  only be called by other functions in this contract.
204     /// @param _from The address holding the tokens being transferred
205     /// @param _to The address of the recipient
206     /// @param _amount The amount of tokens to be transferred
207     /// @return True if the transfer was successful
208     function doTransfer(address _from, address _to, uint _amount
209     ) internal returns(bool) {
210 
211            if (_amount == 0) {
212                return true;
213            }
214 
215            require(parentSnapShotBlock < block.number);
216 
217            // Do not allow transfer to 0x0 or the token contract itself
218            require((_to != 0) && (_to != address(this)));
219 
220            // If the amount being transfered is more than the balance of the
221            //  account the transfer returns false
222            var previousBalanceFrom = balanceOfAt(_from, block.number);
223            if (previousBalanceFrom < _amount) {
224                return false;
225            }
226 
227            // Alerts the token controller of the transfer
228            if (isContract(controller)) {
229                require(TokenController(controller).onTransfer(_from, _to, _amount));
230            }
231 
232            // First update the balance array with the new value for the address
233            //  sending the tokens
234            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
235 
236            // Then update the balance array with the new value for the address
237            //  receiving the tokens
238            var previousBalanceTo = balanceOfAt(_to, block.number);
239            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
240            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
241 
242            // An event to make the transfer easy to find on the blockchain
243            Transfer(_from, _to, _amount);
244 
245            return true;
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
275         Approval(msg.sender, _spender, _amount);
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
406         NewCloneToken(address(cloneToken), _snapshotBlock);
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
426         Transfer(0, _owner, _amount);
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
443         Transfer(_owner, 0, _amount);
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
541             controller.transfer(this.balance);
542             return;
543         }
544 
545         MiniMeToken token = MiniMeToken(_token);
546         uint balance = token.balanceOf(this);
547         token.transfer(controller, balance);
548         ClaimedTokens(_token, controller, balance);
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
608 /// @title Owned
609 /// @author Adrià Massanet <adria@codecontext.io>
610 /// @notice The Owned contract has an owner address, and provides basic 
611 ///  authorization control functions, this simplifies & the implementation of
612 ///  user permissions; this contract has three work flows for a change in
613 ///  ownership, the first requires the new owner to validate that they have the
614 ///  ability to accept ownership, the second allows the ownership to be
615 ///  directly transfered without requiring acceptance, and the third allows for
616 ///  the ownership to be removed to allow for decentralization 
617 contract Owned {
618 
619     address public owner;
620     address public newOwnerCandidate;
621 
622     event OwnershipRequested(address indexed by, address indexed to);
623     event OwnershipTransferred(address indexed from, address indexed to);
624     event OwnershipRemoved();
625 
626     /// @dev The constructor sets the `msg.sender` as the`owner` of the contract
627     function Owned() {
628         owner = msg.sender;
629     }
630 
631     /// @dev `owner` is the only address that can call a function with this
632     /// modifier
633     modifier onlyOwner() {
634         require (msg.sender == owner);
635         _;
636     }
637     
638     /// @dev In this 1st option for ownership transfer `proposeOwnership()` must
639     ///  be called first by the current `owner` then `acceptOwnership()` must be
640     ///  called by the `newOwnerCandidate`
641     /// @notice `onlyOwner` Proposes to transfer control of the contract to a
642     ///  new owner
643     /// @param _newOwnerCandidate The address being proposed as the new owner
644     function proposeOwnership(address _newOwnerCandidate) onlyOwner {
645         newOwnerCandidate = _newOwnerCandidate;
646         OwnershipRequested(msg.sender, newOwnerCandidate);
647     }
648 
649     /// @notice Can only be called by the `newOwnerCandidate`, accepts the
650     ///  transfer of ownership
651     function acceptOwnership() {
652         require(msg.sender == newOwnerCandidate);
653 
654         address oldOwner = owner;
655         owner = newOwnerCandidate;
656         newOwnerCandidate = 0x0;
657 
658         OwnershipTransferred(oldOwner, owner);
659     }
660 
661     /// @dev In this 2nd option for ownership transfer `changeOwnership()` can
662     ///  be called and it will immediately assign ownership to the `newOwner`
663     /// @notice `owner` can step down and assign some other address to this role
664     /// @param _newOwner The address of the new owner
665     function changeOwnership(address _newOwner) onlyOwner {
666         require(_newOwner != 0x0);
667 
668         address oldOwner = owner;
669         owner = _newOwner;
670         newOwnerCandidate = 0x0;
671 
672         OwnershipTransferred(oldOwner, owner);
673     }
674 
675     /// @dev In this 3rd option for ownership transfer `removeOwnership()` can
676     ///  be called and it will immediately assign ownership to the 0x0 address;
677     ///  it requires a 0xdece be input as a parameter to prevent accidental use
678     /// @notice Decentralizes the contract, this operation cannot be undone 
679     /// @param _dac `0xdac` has to be entered for this function to work
680     function removeOwnership(uint _dac) onlyOwner {
681         require(_dac == 0xdac);
682         owner = 0x0;
683         newOwnerCandidate = 0x0;
684         OwnershipRemoved();     
685     }
686 } 
687 
688 
689 /// @dev `Escapable` is a base level contract built off of the `Owned`
690 ///  contract; it creates an escape hatch function that can be called in an
691 ///  emergency that will allow designated addresses to send any ether or tokens
692 ///  held in the contract to an `escapeHatchDestination` as long as they were
693 ///  not blacklisted
694 contract Escapable is Owned {
695     address public escapeHatchCaller;
696     address public escapeHatchDestination;
697     mapping (address=>bool) private escapeBlacklist; // Token contract addresses
698 
699     /// @notice The Constructor assigns the `escapeHatchDestination` and the
700     ///  `escapeHatchCaller`
701     /// @param _escapeHatchCaller The address of a trusted account or contract
702     ///  to call `escapeHatch()` to send the ether in this contract to the
703     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
704     ///  cannot move funds out of `escapeHatchDestination`
705     /// @param _escapeHatchDestination The address of a safe location (usu a
706     ///  Multisig) to send the ether held in this contract; if a neutral address
707     ///  is required, the WHG Multisig is an option:
708     ///  <a title="See this address on the blockchain explorer" href="https://etherscan.io/address/0x8Ff920020c8AD673661c8117f2855C384758C572" class="ext-etheraddresslookup-link" target="_self">0x8Ff920020c8AD673661c8117f2855C384758C572</a>
709     function Escapable(address _escapeHatchCaller, address _escapeHatchDestination) {
710         escapeHatchCaller = _escapeHatchCaller;
711         escapeHatchDestination = _escapeHatchDestination;
712     }
713 
714     /// @dev The addresses preassigned as `escapeHatchCaller` or `owner`
715     ///  are the only addresses that can call a function with this modifier
716     modifier onlyEscapeHatchCallerOrOwner {
717         require ((msg.sender == escapeHatchCaller)||(msg.sender == owner));
718         _;
719     }
720 
721     /// @notice Creates the blacklist of tokens that are not able to be taken
722     ///  out of the contract; can only be done at the deployment, and the logic
723     ///  to add to the blacklist will be in the constructor of a child contract
724     /// @param _token the token contract address that is to be blacklisted 
725     function blacklistEscapeToken(address _token) internal {
726         escapeBlacklist[_token] = true;
727         EscapeHatchBlackistedToken(_token);
728     }
729 
730     /// @notice Checks to see if `_token` is in the blacklist of tokens
731     /// @param _token the token address being queried
732     /// @return False if `_token` is in the blacklist and can't be taken out of
733     ///  the contract via the `escapeHatch()`
734     function isTokenEscapable(address _token) constant public returns (bool) {
735         return !escapeBlacklist[_token];
736     }
737 
738     /// @notice The `escapeHatch()` should only be called as a last resort if a
739     /// security issue is uncovered or something unexpected happened
740     /// @param _token to transfer, use 0x0 for ether
741     function escapeHatch(address _token) public onlyEscapeHatchCallerOrOwner {   
742         require(escapeBlacklist[_token]==false);
743 
744         uint256 balance;
745 
746         /// @dev Logic for ether
747         if (_token == 0x0) {
748             balance = this.balance;
749             escapeHatchDestination.transfer(balance);
750             EscapeHatchCalled(_token, balance);
751             return;
752         }
753         /// @dev Logic for tokens
754         ERC20 token = ERC20(_token);
755         balance = token.balanceOf(this);
756         token.transfer(escapeHatchDestination, balance);
757         EscapeHatchCalled(_token, balance);
758     }
759 
760     /// @notice Changes the address assigned to call `escapeHatch()`
761     /// @param _newEscapeHatchCaller The address of a trusted account or
762     ///  contract to call `escapeHatch()` to send the value in this contract to
763     ///  the `escapeHatchDestination`; it would be ideal that `escapeHatchCaller`
764     ///  cannot move funds out of `escapeHatchDestination`
765     function changeHatchEscapeCaller(address _newEscapeHatchCaller) onlyEscapeHatchCallerOrOwner {
766         escapeHatchCaller = _newEscapeHatchCaller;
767     }
768 
769     event EscapeHatchBlackistedToken(address token);
770     event EscapeHatchCalled(address token, uint amount);
771 }
772 
773 /// @dev This is designed to control the issuance of a MiniMe Token for a
774 ///  non-profit Campaign. This contract effectively dictates the terms of the
775 ///  funding round.
776 contract GivethCampaign is TokenController, Owned, Escapable {
777 
778     uint public startFundingTime;       // In UNIX Time Format
779     uint public endFundingTime;         // In UNIX Time Format
780     uint public maximumFunding;         // In wei
781     uint public totalCollected;         // In wei
782     MiniMeToken public tokenContract;   // The new token for this Campaign
783     address public vaultAddress;        // The address to hold the funds donated
784 
785 /// @notice 'GivethCampaign()' initiates the Campaign by setting its funding
786 /// parameters
787 /// @dev There are several checks to make sure the parameters are acceptable
788 /// @param _startFundingTime The UNIX time that the Campaign will be able to
789 /// start receiving funds
790 /// @param _endFundingTime The UNIX time that the Campaign will stop being able
791 /// to receive funds
792 /// @param _maximumFunding In wei, the Maximum amount that the Campaign can
793 /// receive (currently the max is set at 10,000 ETH for the beta)
794 /// @param _vaultAddress The address that will store the donated funds
795 /// @param _tokenAddress Address of the token contract this contract controls
796     function GivethCampaign(
797         address _escapeHatchCaller,
798         address _escapeHatchDestination,        
799         uint _startFundingTime,
800         uint _endFundingTime,
801         uint _maximumFunding,
802         address _vaultAddress,
803         address _tokenAddress
804     ) Escapable(_escapeHatchCaller, _escapeHatchDestination) {
805         require(_endFundingTime > now);                // Cannot end in the past
806         require(_endFundingTime > _startFundingTime);
807         require(_maximumFunding <= 1000000 ether);        // The Beta is limited
808         require(_vaultAddress != 0);                     // To prevent burning ETH
809         startFundingTime = _startFundingTime;
810         endFundingTime = _endFundingTime;
811         maximumFunding = _maximumFunding;
812         tokenContract = MiniMeToken(_tokenAddress);// The deployed Token Contract
813         vaultAddress = _vaultAddress;
814     }
815 
816 /// @dev The fallback function is called when ether is sent to the contract, it
817 /// simply calls `doPayment()` with the address that sent the ether as the
818 /// `_owner`. Payable is a required solidity modifier for functions to receive
819 /// ether, without this modifier functions will throw if ether is sent to them
820     function ()  payable {
821         doPayment(msg.sender);
822     }
823 
824 /////////////////
825 // TokenController interface
826 /////////////////
827 
828 /// @notice `proxyPayment()` allows the caller to send ether to the Campaign and
829 /// have the tokens created in an address of their choosing
830 /// @param _owner The address that will hold the newly created tokens
831     function proxyPayment(address _owner) payable returns(bool) {
832         doPayment(_owner);
833         return true;
834     }
835 
836 /// @notice Notifies the controller about a transfer, for this Campaign all
837 ///  transfers are allowed by default and no extra notifications are needed
838 /// @param _from The origin of the transfer
839 /// @param _to The destination of the transfer
840 /// @param _amount The amount of the transfer
841 /// @return False if the controller does not authorize the transfer
842     function onTransfer(address _from, address _to, uint _amount) returns(bool) {
843         return true;
844     }
845 
846 /// @notice Notifies the controller about an approval, for this Campaign all
847 ///  approvals are allowed by default and no extra notifications are needed
848 /// @param _owner The address that calls `approve()`
849 /// @param _spender The spender in the `approve()` call
850 /// @param _amount The amount in the `approve()` call
851 /// @return False if the controller does not authorize the approval
852     function onApprove(address _owner, address _spender, uint _amount)
853         returns(bool)
854     {
855         return true;
856     }
857 
858 
859 /// @dev `doPayment()` is an internal function that sends the ether that this
860 ///  contract receives to the `vault` and creates tokens in the address of the
861 ///  `_owner` assuming the Campaign is still accepting funds
862 /// @param _owner The address that will hold the newly created tokens
863     function doPayment(address _owner) internal {
864 
865 // First check that the Campaign is allowed to receive this donation
866         require(now>=startFundingTime);
867         require(now<=endFundingTime);
868         require(tokenContract.controller() != 0);           // Extra check
869         require(msg.value != 0);
870         require(totalCollected + msg.value <= maximumFunding);
871 
872 //Track how much the Campaign has collected
873         totalCollected += msg.value;
874 
875 //Send the ether to the vault
876         require(vaultAddress.send(msg.value));
877 
878 // Creates an equal amount of tokens as ether sent. The new tokens are created
879 //  in the `_owner` address
880         require(tokenContract.generateTokens(_owner, msg.value));
881 
882         return;
883     }
884 
885 /// @notice `finalizeFunding()` ends the Campaign by calling setting the
886 ///  controller to 0, thereby ending the issuance of new tokens and stopping the
887 ///  Campaign from receiving more ether
888 /// @dev `finalizeFunding()` can only be called after the end of the funding period.
889     function finalizeFunding() {
890         require (now >= endFundingTime);
891         tokenContract.changeController(0);
892     }
893 
894 
895 /// @notice `onlyOwner` changes the location that ether is sent
896 /// @param _newVaultAddress The address that will receive the ether sent to this
897 ///  Campaign
898     function setVault(address _newVaultAddress) onlyOwner {
899         vaultAddress = _newVaultAddress;
900     }
901 
902 }
903 
904 /**
905  * @title ERC20
906  * @dev A standard interface for tokens.
907  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
908  */
909 contract ERC20 {
910   
911     /// @dev Returns the total token supply
912     function totalSupply() public constant returns (uint256 supply);
913 
914     /// @dev Returns the account balance of the account with address _owner
915     function balanceOf(address _owner) public constant returns (uint256 balance);
916 
917     /// @dev Transfers _value number of tokens to address _to
918     function transfer(address _to, uint256 _value) public returns (bool success);
919 
920     /// @dev Transfers _value number of tokens from address _from to address _to
921     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
922 
923     /// @dev Allows _spender to withdraw from the msg.sender's account up to the _value amount
924     function approve(address _spender, uint256 _value) public returns (bool success);
925 
926     /// @dev Returns the amount which _spender is still allowed to withdraw from _owner
927     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
928 
929     event Transfer(address indexed _from, address indexed _to, uint256 _value);
930     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
931 
932 }