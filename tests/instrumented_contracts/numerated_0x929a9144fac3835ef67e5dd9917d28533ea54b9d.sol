1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-21
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 
8 // Bitfinex LEO Token 2019
9 // Based on Giveth's MiniMe Token framework
10 
11 contract Ownable {
12 
13   address public owner;
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17   constructor() public {
18     owner = msg.sender;
19   }
20 
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   function transferOwnership(address newOwner) public onlyOwner {
27     require(newOwner != address(0));
28     emit OwnershipTransferred(owner, newOwner);
29     owner = newOwner;
30   }
31 
32 }
33 
34 
35 // Modified 2019, Will Harborne
36 
37 /*
38     Copyright 2016, Jordi Baylina
39 
40     This program is free software: you can redistribute it and/or modify
41     it under the terms of the GNU General Public License as published by
42     the Free Software Foundation, either version 3 of the License, or
43     (at your option) any later version.
44 
45     This program is distributed in the hope that it will be useful,
46     but WITHOUT ANY WARRANTY; without even the implied warranty of
47     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
48     GNU General Public License for more details.
49 
50     You should have received a copy of the GNU General Public License
51     along with this program.  If not, see <http://www.gnu.org/licenses/>.
52  */
53 
54 /// @title MiniMeToken Contract
55 /// @author Jordi Baylina
56 /// @dev This token contract's goal is to make it easy for anyone to clone this
57 ///  token using the token distribution at a given block, this will allow DAO's
58 ///  and DApps to upgrade their features in a decentralized manner without
59 ///  affecting the original token
60 /// @dev It is ERC20 compliant, but still needs to under go further testing.
61 
62 contract Controlled {
63 
64     event ControlTransferred(address indexed previousControler, address indexed newController);
65 
66     /// @notice The address of the controller is the only address that can call
67     ///  a function with this modifier
68     modifier onlyController { require(msg.sender == controller); _; }
69 
70     address public controller;
71 
72     constructor() public { controller = msg.sender;}
73 
74     /// @notice Changes the controller of the contract
75     /// @param _newController The new controller of the contract
76     function changeController(address _newController) public onlyController {
77         emit ControlTransferred(controller, _newController);
78         controller = _newController;
79     }
80 }
81 
82 contract TokenController {
83     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
84     /// @param _owner The address that sent the ether to create tokens
85     /// @return True if the ether is accepted, false if it throws
86     function proxyPayment(address _owner) public payable returns(bool);
87 
88     /// @notice Notifies the controller about a token transfer allowing the
89     ///  controller to react if desired
90     /// @param _from The origin of the transfer
91     /// @param _to The destination of the transfer
92     /// @param _amount The amount of the transfer
93     /// @return False if the controller does not authorize the transfer
94     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
95 
96     /// @notice Notifies the controller about an approval allowing the
97     ///  controller to react if desired
98     /// @param _owner The address that calls `approve()`
99     /// @param _spender The spender in the `approve()` call
100     /// @param _amount The amount in the `approve()` call
101     /// @return False if the controller does not authorize the approval
102     function onApprove(address _owner, address _spender, uint _amount) public
103         returns(bool);
104 
105 }
106 
107 
108 contract ApproveAndCallFallBack {
109     function receiveApproval(address from, uint256 _amount, address _token, bytes memory _data) public;
110 }
111 
112 /// @dev The actual token contract, the default controller is the msg.sender
113 ///  that deploys the contract, so usually this token will be deployed by a
114 ///  token controller contract, which Giveth will call a "Campaign"
115 /// @dev The actual token contract, the default controller is the msg.sender
116 ///  that deploys the contract, so usually this token will be deployed by a
117 ///  token controller contract, which Giveth will call a "Campaign"
118 contract MiniMeToken is Controlled {
119 
120     string public name;                //The Token's name: e.g. DigixDAO Tokens
121     uint8 public decimals;             //Number of decimals of the smallest unit
122     string public symbol;              //An identifier: e.g. REP
123     string public version = '3.0.0'; //An arbitrary versioning scheme
124 
125 
126     /// @dev `Checkpoint` is the structure that attaches a block number to a
127     ///  given value, the block number attached is the one that last changed the
128     ///  value
129     struct  Checkpoint {
130 
131         // `fromBlock` is the block number that the value was generated from
132         uint256 fromBlock;
133 
134         // `value` is the amount of tokens at a specific block number
135         uint256 value;
136     }
137 
138     // `parentToken` is the Token address that was cloned to produce this token;
139     //  it will be 0x0 for a token that was not cloned
140     MiniMeToken public parentToken;
141 
142     // `parentSnapShotBlock` is the block number from the Parent Token that was
143     //  used to determine the initial distribution of the Clone Token
144     uint public parentSnapShotBlock;
145 
146     // `creationBlock` is the block number that the Clone Token was created
147     uint public creationBlock;
148 
149     // `balances` is the map that tracks the balance of each address, in this
150     //  contract when the balance changes the block number that the change
151     //  occurred is also included in the map
152     mapping (address => Checkpoint[]) balances;
153 
154     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
155     mapping (address => mapping (address => uint256)) allowed;
156 
157     // Tracks the history of the `totalSupply` of the token
158     Checkpoint[] totalSupplyHistory;
159 
160     // Flag that determines if the token is transferable or not.
161     bool public transfersEnabled;
162 
163     // The factory used to create new clone tokens
164     MiniMeTokenFactory public tokenFactory;
165 
166 ////////////////
167 // Constructor
168 ////////////////
169 
170     /// @notice Constructor to create a MiniMeToken
171     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
172     ///  will create the Clone token contracts, the token factory needs to be
173     ///  deployed first
174     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
175     ///  new token
176     /// @param _parentSnapShotBlock Block of the parent token that will
177     ///  determine the initial distribution of the clone token, set to 0 if it
178     ///  is a new token
179     /// @param _tokenName Name of the new token
180     /// @param _decimalUnits Number of decimals of the new token
181     /// @param _tokenSymbol Token Symbol for the new token
182     /// @param _transfersEnabled If true, tokens will be able to be transferred
183     constructor(
184         address _tokenFactory,
185         address payable _parentToken,
186         uint _parentSnapShotBlock,
187         string memory _tokenName,
188         uint8 _decimalUnits,
189         string memory _tokenSymbol,
190         bool _transfersEnabled
191     ) public {
192         tokenFactory = MiniMeTokenFactory(_tokenFactory);
193         name = _tokenName;                                 // Set the name
194         decimals = _decimalUnits;                          // Set the decimals
195         symbol = _tokenSymbol;                             // Set the symbol
196         parentToken = MiniMeToken(_parentToken);
197         parentSnapShotBlock = _parentSnapShotBlock;
198         transfersEnabled = _transfersEnabled;
199         creationBlock = block.number;
200     }
201 
202 
203 ///////////////////
204 // ERC20 Methods
205 ///////////////////
206 
207     uint constant MAX_UINT = 2**256 - 1;
208 
209     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
210     /// @param _to The address of the recipient
211     /// @param _amount The amount of tokens to be transferred
212     /// @return Whether the transfer was successful or not
213     function transfer(address _to, uint256 _amount) public returns (bool success) {
214         require(transfersEnabled);
215         doTransfer(msg.sender, _to, _amount);
216         return true;
217     }
218 
219     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
220     ///  is approved by `_from`
221     /// @param _from The address holding the tokens being transferred
222     /// @param _to The address of the recipient
223     /// @param _amount The amount of tokens to be transferred
224     /// @return True if the transfer was successful
225     function transferFrom(address _from, address _to, uint256 _amount
226     ) public returns (bool success) {
227 
228         // The controller of this contract can move tokens around at will,
229         //  this is important to recognize! Confirm that you trust the
230         //  controller of this contract, which in most situations should be
231         //  another open source smart contract or 0x0
232         if (msg.sender != controller) {
233             require(transfersEnabled);
234 
235             // The standard ERC 20 transferFrom functionality
236             if (allowed[_from][msg.sender] < MAX_UINT) {
237                 require(allowed[_from][msg.sender] >= _amount);
238                 allowed[_from][msg.sender] -= _amount;
239             }
240         }
241         doTransfer(_from, _to, _amount);
242         return true;
243     }
244 
245     /// @dev This is the actual transfer function in the token contract, it can
246     ///  only be called by other functions in this contract.
247     /// @param _from The address holding the tokens being transferred
248     /// @param _to The address of the recipient
249     /// @param _amount The amount of tokens to be transferred
250     /// @return True if the transfer was successful
251     function doTransfer(address _from, address _to, uint _amount
252     ) internal {
253 
254            if (_amount == 0) {
255                emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
256                return;
257            }
258 
259            require(parentSnapShotBlock < block.number);
260 
261            // Do not allow transfer to 0x0 or the token contract itself
262            require((_to != address(0)) && (_to != address(this)));
263 
264            // If the amount being transfered is more than the balance of the
265            //  account the transfer throws
266            uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
267 
268            require(previousBalanceFrom >= _amount);
269 
270            // Alerts the token controller of the transfer
271            if (isContract(controller)) {
272                require(TokenController(controller).onTransfer(_from, _to, _amount));
273            }
274 
275            // First update the balance array with the new value for the address
276            //  sending the tokens
277            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
278 
279            // Then update the balance array with the new value for the address
280            //  receiving the tokens
281            uint256 previousBalanceTo = balanceOfAt(_to, block.number);
282            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
283            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
284 
285            // An event to make the transfer easy to find on the blockchain
286            emit Transfer(_from, _to, _amount);
287 
288     }
289 
290     /// @param _owner The address that's balance is being requested
291     /// @return The balance of `_owner` at the current block
292     function balanceOf(address _owner) public view returns (uint256 balance) {
293         return balanceOfAt(_owner, block.number);
294     }
295 
296     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
297     ///  its behalf. This is a modified version of the ERC20 approve function
298     ///  to be a little bit safer
299     /// @param _spender The address of the account able to transfer the tokens
300     /// @param _amount The amount of tokens to be approved for transfer
301     /// @return True if the approval was successful
302     function approve(address _spender, uint256 _amount) public returns (bool success) {
303         require(transfersEnabled);
304 
305         // To change the approve amount you first have to reduce the addresses`
306         //  allowance to zero by calling `approve(_spender,0)` if it is not
307         //  already 0 to mitigate the race condition described here:
308         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
309         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
310 
311         // Alerts the token controller of the approve function call
312         if (isContract(controller)) {
313             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
314         }
315 
316         allowed[msg.sender][_spender] = _amount;
317         emit Approval(msg.sender, _spender, _amount);
318         return true;
319     }
320 
321     /// @dev This function makes it easy to read the `allowed[]` map
322     /// @param _owner The address of the account that owns the token
323     /// @param _spender The address of the account able to transfer the tokens
324     /// @return Amount of remaining tokens of _owner that _spender is allowed
325     ///  to spend
326     function allowance(address _owner, address _spender
327     ) public view returns (uint256 remaining) {
328         return allowed[_owner][_spender];
329     }
330 
331     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
332     ///  its behalf, and then a function is triggered in the contract that is
333     ///  being approved, `_spender`. This allows users to use their tokens to
334     ///  interact with contracts in one function call instead of two
335     /// @param _spender The address of the contract able to transfer the tokens
336     /// @param _amount The amount of tokens to be approved for transfer
337     /// @return True if the function call was successful
338     function approveAndCall(address _spender, uint256 _amount, bytes memory _extraData
339     ) public returns (bool success) {
340         require(approve(_spender, _amount));
341 
342         ApproveAndCallFallBack(_spender).receiveApproval(
343             msg.sender,
344             _amount,
345             address(this),
346             _extraData
347         );
348 
349         return true;
350     }
351 
352     /// @dev This function makes it easy to get the total number of tokens
353     /// @return The total number of tokens
354     function totalSupply() public view returns (uint) {
355         return totalSupplyAt(block.number);
356     }
357 
358 
359 ////////////////
360 // Query balance and totalSupply in History
361 ////////////////
362 
363     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
364     /// @param _owner The address from which the balance will be retrieved
365     /// @param _blockNumber The block number when the balance is queried
366     /// @return The balance at `_blockNumber`
367     function balanceOfAt(address _owner, uint _blockNumber) public view
368         returns (uint) {
369 
370         // These next few lines are used when the balance of the token is
371         //  requested before a check point was ever created for this token, it
372         //  requires that the `parentToken.balanceOfAt` be queried at the
373         //  genesis block for that token as this contains initial balance of
374         //  this token
375         if ((balances[_owner].length == 0)
376             || (balances[_owner][0].fromBlock > _blockNumber)) {
377             if (address(parentToken) != address(0)) {
378                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
379             } else {
380                 // Has no parent
381                 return 0;
382             }
383 
384         // This will return the expected balance during normal situations
385         } else {
386             return getValueAt(balances[_owner], _blockNumber);
387         }
388     }
389 
390     /// @notice Total amount of tokens at a specific `_blockNumber`.
391     /// @param _blockNumber The block number when the totalSupply is queried
392     /// @return The total amount of tokens at `_blockNumber`
393     function totalSupplyAt(uint _blockNumber) public view returns(uint) {
394 
395         // These next few lines are used when the totalSupply of the token is
396         //  requested before a check point was ever created for this token, it
397         //  requires that the `parentToken.totalSupplyAt` be queried at the
398         //  genesis block for this token as that contains totalSupply of this
399         //  token at this block number.
400         if ((totalSupplyHistory.length == 0)
401             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
402             if (address(parentToken) != address(0)) {
403                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
404             } else {
405                 return 0;
406             }
407 
408         // This will return the expected totalSupply during normal situations
409         } else {
410             return getValueAt(totalSupplyHistory, _blockNumber);
411         }
412     }
413 
414 ////////////////
415 // Clone Token Method
416 ////////////////
417 
418     /// @notice Creates a new clone token with the initial distribution being
419     ///  this token at `_snapshotBlock`
420     /// @param _cloneTokenName Name of the clone token
421     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
422     /// @param _cloneTokenSymbol Symbol of the clone token
423     /// @param _snapshotBlock Block when the distribution of the parent token is
424     ///  copied to set the initial distribution of the new clone token;
425     ///  if the block is zero than the actual block, the current block is used
426     /// @param _transfersEnabled True if transfers are allowed in the clone
427     /// @return The address of the new MiniMeToken Contract
428     function createCloneToken(
429         string memory _cloneTokenName,
430         uint8 _cloneDecimalUnits,
431         string memory _cloneTokenSymbol,
432         uint _snapshotBlock,
433         bool _transfersEnabled
434         ) public returns(address) {
435         if (_snapshotBlock == 0) _snapshotBlock = block.number;
436         MiniMeToken cloneToken = tokenFactory.createCloneToken(
437             address(this),
438             _snapshotBlock,
439             _cloneTokenName,
440             _cloneDecimalUnits,
441             _cloneTokenSymbol,
442             _transfersEnabled
443             );
444 
445         cloneToken.changeController(msg.sender);
446 
447         // An event to make the token easy to find on the blockchain
448         emit NewCloneToken(address(cloneToken), _snapshotBlock);
449         return address(cloneToken);
450     }
451 
452 ////////////////
453 // Generate and destroy tokens
454 ////////////////
455 
456     /// @notice Generates `_amount` tokens that are assigned to `_owner`
457     /// @param _owner The address that will be assigned the new tokens
458     /// @param _amount The quantity of tokens generated
459     /// @return True if the tokens are generated correctly
460     function generateTokens(address _owner, uint _amount
461     ) public onlyController returns (bool) {
462         uint curTotalSupply = totalSupply();
463         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
464         uint previousBalanceTo = balanceOf(_owner);
465         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
466         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
467         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
468         emit Transfer(address(0), _owner, _amount);
469         return true;
470     }
471 
472 
473     /// @notice Burns `_amount` tokens from `_owner`
474     /// @param _owner The address that will lose the tokens
475     /// @param _amount The quantity of tokens to burn
476     /// @return True if the tokens are burned correctly
477     function destroyTokens(address _owner, uint _amount
478     ) onlyController public returns (bool) {
479         uint curTotalSupply = totalSupply();
480         require(curTotalSupply >= _amount);
481         uint previousBalanceFrom = balanceOf(_owner);
482         require(previousBalanceFrom >= _amount);
483         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
484         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
485         emit Transfer(_owner, address(0), _amount);
486         return true;
487     }
488 
489 ////////////////
490 // Enable tokens transfers
491 ////////////////
492 
493 
494     /// @notice Enables token holders to transfer their tokens freely if true
495     /// @param _transfersEnabled True if transfers are allowed in the clone
496     function enableTransfers(bool _transfersEnabled) public onlyController {
497         transfersEnabled = _transfersEnabled;
498     }
499 
500 ////////////////
501 // Internal helper functions to query and set a value in a snapshot array
502 ////////////////
503 
504     /// @dev `getValueAt` retrieves the number of tokens at a given block number
505     /// @param checkpoints The history of values being queried
506     /// @param _block The block number to retrieve the value at
507     /// @return The number of tokens being queried
508     function getValueAt(Checkpoint[] storage checkpoints, uint _block
509     ) view internal returns (uint) {
510         if (checkpoints.length == 0) return 0;
511 
512         // Shortcut for the actual value
513         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
514             return checkpoints[checkpoints.length-1].value;
515         if (_block < checkpoints[0].fromBlock) return 0;
516 
517         // Binary search of the value in the array
518         uint min = 0;
519         uint max = checkpoints.length-1;
520         uint mid = 0;
521         while (max > min) {
522             mid = (max + min + 1)/ 2;
523             if (checkpoints[mid].fromBlock<=_block) {
524                 min = mid;
525             } else {
526                 max = mid-1;
527             }
528         }
529         return checkpoints[min].value;
530     }
531 
532     /// @dev `updateValueAtNow` used to update the `balances` map and the
533     ///  `totalSupplyHistory`
534     /// @param checkpoints The history of data being updated
535     /// @param _value The new number of tokens
536     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
537     ) internal  {
538         if ((checkpoints.length == 0)
539         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
540                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
541                newCheckPoint.fromBlock =  uint256(block.number);
542                newCheckPoint.value = uint256(_value);
543            } else {
544                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
545                oldCheckPoint.value = uint256(_value);
546            }
547     }
548 
549     /// @dev Internal function to determine if an address is a contract
550     /// @param _addr The address being queried
551     /// @return True if `_addr` is a contract
552     function isContract(address _addr) view internal returns(bool) {
553         uint size;
554         if (_addr == address(0)) return false;
555         assembly {
556             size := extcodesize(_addr)
557         }
558         return size>0;
559     }
560 
561     /// @dev Helper function to return a min betwen the two uints
562     function min(uint a, uint b) pure internal returns (uint) {
563         return a < b ? a : b;
564     }
565 
566     /// @notice The fallback function: If the contract's controller has not been
567     ///  set to 0, then the `proxyPayment` method is called which relays the
568     ///  ether and creates tokens as described in the token controller contract
569     function () external payable {
570         require(isContract(controller));
571         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
572     }
573 
574 
575 ////////////////
576 // Events
577 ////////////////
578     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
579     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
580     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
581     event Approval(
582         address indexed _owner,
583         address indexed _spender,
584         uint256 _amount
585         );
586 
587 }
588 
589 
590 ////////////////
591 // MiniMeTokenFactory
592 ////////////////
593 
594 /// @dev This contract is used to generate clone contracts from a contract.
595 ///  In solidity this is the way to create a contract from a contract of the
596 ///  same class
597 contract MiniMeTokenFactory {
598 
599     /// @notice Update the DApp by creating a new token with new functionalities
600     ///  the msg.sender becomes the controller of this clone token
601     /// @param _parentToken Address of the token being cloned
602     /// @param _snapshotBlock Block of the parent token that will
603     ///  determine the initial distribution of the clone token
604     /// @param _tokenName Name of the new token
605     /// @param _decimalUnits Number of decimals of the new token
606     /// @param _tokenSymbol Token Symbol for the new token
607     /// @param _transfersEnabled If true, tokens will be able to be transferred
608     /// @return The address of the new token contract
609     function createCloneToken(
610         address payable _parentToken,
611         uint _snapshotBlock,
612         string memory _tokenName,
613         uint8 _decimalUnits,
614         string memory _tokenSymbol,
615         bool _transfersEnabled
616     ) public returns (MiniMeToken) {
617         MiniMeToken newToken = new MiniMeToken(
618             address(this),
619             _parentToken,
620             _snapshotBlock,
621             _tokenName,
622             _decimalUnits,
623             _tokenSymbol,
624             _transfersEnabled
625             );
626 
627         newToken.changeController(msg.sender);
628         return newToken;
629     }
630   }
631 
632 
633 contract BUY is MiniMeToken {
634 
635   constructor(
636     address _tokenFactory,
637     address initialOwner
638   ) public MiniMeToken(
639     _tokenFactory,
640     address(0),             // no parent token
641     0,                      // no snapshot block number from parent
642     "BUY Token",   // Token name
643     18,                     // Decimals
644     "BUY",                  // Symbol
645     true                    // Enable transfers
646     ) {
647         generateTokens(initialOwner, 1000000000000000000000000000);
648     }
649 
650 }
651 
652 
653 contract LEOController is TokenController, Ownable {
654 
655     BUY public tokenContract;   // The new token for this Campaign
656 
657     /// @param _tokenAddress Address of the token contract this contract controls
658 
659     constructor(
660         address payable _tokenAddress
661     ) public {
662         tokenContract = BUY(_tokenAddress);         // The Deployed Token Contract
663     }
664 
665 
666 /////////////////
667 // TokenController interface
668 /////////////////
669 
670     /// @notice Notifies the controller about a transfer.
671     /// Transfers can only happen to whitelisted addresses
672     /// @param _from The origin of the transfer
673     /// @param _to The destination of the transfer
674     /// @param _amount The amount of the transfer
675     /// @return False if the controller does not authorize the transfer
676     function onTransfer(address _from, address _to, uint _amount) public returns(bool) {
677         return true;
678     }
679 
680     /// @notice Notifies the controller about an approval, for this Campaign all
681     ///  approvals are allowed by default and no extra notifications are needed
682     /// @param _owner The address that calls `approve()`
683     /// @param _spender The spender in the `approve()` call
684     /// @param _amount The amount in the `approve()` call
685     /// @return False if the controller does not authorize the approval
686     function onApprove(address _owner, address _spender, uint _amount) public
687         returns(bool)
688     {
689         return true;
690     }
691 
692     function proxyPayment(address _owner) public payable returns(bool allowed) {
693         allowed = false;
694     }
695 
696     /// @notice `onlyOwner` can upgrade the controller contract
697     /// @param _newControllerAddress The address that will have the token control logic
698     function upgradeController(address _newControllerAddress) public onlyOwner {
699         tokenContract.changeController(_newControllerAddress);
700         emit UpgradedController(_newControllerAddress);
701     }
702 
703     function burnTokens(uint _amount) public onlyOwner returns (bool) {
704         tokenContract.destroyTokens(owner, _amount);
705     }
706 
707     function issueTokens(uint _amount) public onlyOwner returns (bool) {
708         tokenContract.generateTokens(owner, _amount);
709     }
710 
711 
712 //////////
713 // Safety Methods
714 //////////
715 
716     /// @notice This method can be used by the owner to extract mistakenly
717     ///  sent tokens to this contract.
718     /// @param _token The address of the token contract that you want to recover
719     function claimLostTokens(address payable _token) public onlyOwner {
720 
721         BUY token = BUY(_token);
722         uint balance = token.balanceOf(address(this));
723         token.transfer(owner, balance);
724         emit ClaimedTokens(_token, owner, balance);
725     }
726 
727 ////////////////
728 // Events
729 ////////////////
730     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
731 
732     event UpgradedController (address newAddress);
733 
734 }