1 pragma solidity ^0.5.0;
2 
3 
4 // Bitfinex LEO Token 2019
5 // Based on Giveth's MiniMe Token framework
6 
7 contract Ownable {
8 
9   address public owner;
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   constructor() public {
14     owner = msg.sender;
15   }
16 
17   modifier onlyOwner() {
18     require(msg.sender == owner);
19     _;
20   }
21 
22   function transferOwnership(address newOwner) public onlyOwner {
23     require(newOwner != address(0));
24     emit OwnershipTransferred(owner, newOwner);
25     owner = newOwner;
26   }
27 
28 }
29 
30 
31 // Modified 2019, Will Harborne
32 
33 /*
34     Copyright 2016, Jordi Baylina
35 
36     This program is free software: you can redistribute it and/or modify
37     it under the terms of the GNU General Public License as published by
38     the Free Software Foundation, either version 3 of the License, or
39     (at your option) any later version.
40 
41     This program is distributed in the hope that it will be useful,
42     but WITHOUT ANY WARRANTY; without even the implied warranty of
43     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
44     GNU General Public License for more details.
45 
46     You should have received a copy of the GNU General Public License
47     along with this program.  If not, see <http://www.gnu.org/licenses/>.
48  */
49 
50 /// @title MiniMeToken Contract
51 /// @author Jordi Baylina
52 /// @dev This token contract's goal is to make it easy for anyone to clone this
53 ///  token using the token distribution at a given block, this will allow DAO's
54 ///  and DApps to upgrade their features in a decentralized manner without
55 ///  affecting the original token
56 /// @dev It is ERC20 compliant, but still needs to under go further testing.
57 
58 contract Controlled {
59 
60     event ControlTransferred(address indexed previousControler, address indexed newController);
61 
62     /// @notice The address of the controller is the only address that can call
63     ///  a function with this modifier
64     modifier onlyController { require(msg.sender == controller); _; }
65 
66     address public controller;
67 
68     constructor() public { controller = msg.sender;}
69 
70     /// @notice Changes the controller of the contract
71     /// @param _newController The new controller of the contract
72     function changeController(address _newController) public onlyController {
73         emit ControlTransferred(controller, _newController);
74         controller = _newController;
75     }
76 }
77 
78 contract TokenController {
79     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
80     /// @param _owner The address that sent the ether to create tokens
81     /// @return True if the ether is accepted, false if it throws
82     function proxyPayment(address _owner) public payable returns(bool);
83 
84     /// @notice Notifies the controller about a token transfer allowing the
85     ///  controller to react if desired
86     /// @param _from The origin of the transfer
87     /// @param _to The destination of the transfer
88     /// @param _amount The amount of the transfer
89     /// @return False if the controller does not authorize the transfer
90     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
91 
92     /// @notice Notifies the controller about an approval allowing the
93     ///  controller to react if desired
94     /// @param _owner The address that calls `approve()`
95     /// @param _spender The spender in the `approve()` call
96     /// @param _amount The amount in the `approve()` call
97     /// @return False if the controller does not authorize the approval
98     function onApprove(address _owner, address _spender, uint _amount) public
99         returns(bool);
100 
101 }
102 
103 
104 contract ApproveAndCallFallBack {
105     function receiveApproval(address from, uint256 _amount, address _token, bytes memory _data) public;
106 }
107 
108 /// @dev The actual token contract, the default controller is the msg.sender
109 ///  that deploys the contract, so usually this token will be deployed by a
110 ///  token controller contract, which Giveth will call a "Campaign"
111 /// @dev The actual token contract, the default controller is the msg.sender
112 ///  that deploys the contract, so usually this token will be deployed by a
113 ///  token controller contract, which Giveth will call a "Campaign"
114 contract MiniMeToken is Controlled {
115 
116     string public name;                //The Token's name: e.g. DigixDAO Tokens
117     uint8 public decimals;             //Number of decimals of the smallest unit
118     string public symbol;              //An identifier: e.g. REP
119     string public version = '3.0.0'; //An arbitrary versioning scheme
120 
121 
122     /// @dev `Checkpoint` is the structure that attaches a block number to a
123     ///  given value, the block number attached is the one that last changed the
124     ///  value
125     struct  Checkpoint {
126 
127         // `fromBlock` is the block number that the value was generated from
128         uint256 fromBlock;
129 
130         // `value` is the amount of tokens at a specific block number
131         uint256 value;
132     }
133 
134     // `parentToken` is the Token address that was cloned to produce this token;
135     //  it will be 0x0 for a token that was not cloned
136     MiniMeToken public parentToken;
137 
138     // `parentSnapShotBlock` is the block number from the Parent Token that was
139     //  used to determine the initial distribution of the Clone Token
140     uint public parentSnapShotBlock;
141 
142     // `creationBlock` is the block number that the Clone Token was created
143     uint public creationBlock;
144 
145     // `balances` is the map that tracks the balance of each address, in this
146     //  contract when the balance changes the block number that the change
147     //  occurred is also included in the map
148     mapping (address => Checkpoint[]) balances;
149 
150     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
151     mapping (address => mapping (address => uint256)) allowed;
152 
153     // Tracks the history of the `totalSupply` of the token
154     Checkpoint[] totalSupplyHistory;
155 
156     // Flag that determines if the token is transferable or not.
157     bool public transfersEnabled;
158 
159     // The factory used to create new clone tokens
160     MiniMeTokenFactory public tokenFactory;
161 
162 ////////////////
163 // Constructor
164 ////////////////
165 
166     /// @notice Constructor to create a MiniMeToken
167     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
168     ///  will create the Clone token contracts, the token factory needs to be
169     ///  deployed first
170     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
171     ///  new token
172     /// @param _parentSnapShotBlock Block of the parent token that will
173     ///  determine the initial distribution of the clone token, set to 0 if it
174     ///  is a new token
175     /// @param _tokenName Name of the new token
176     /// @param _decimalUnits Number of decimals of the new token
177     /// @param _tokenSymbol Token Symbol for the new token
178     /// @param _transfersEnabled If true, tokens will be able to be transferred
179     constructor(
180         address _tokenFactory,
181         address payable _parentToken,
182         uint _parentSnapShotBlock,
183         string memory _tokenName,
184         uint8 _decimalUnits,
185         string memory _tokenSymbol,
186         bool _transfersEnabled
187     ) public {
188         tokenFactory = MiniMeTokenFactory(_tokenFactory);
189         name = _tokenName;                                 // Set the name
190         decimals = _decimalUnits;                          // Set the decimals
191         symbol = _tokenSymbol;                             // Set the symbol
192         parentToken = MiniMeToken(_parentToken);
193         parentSnapShotBlock = _parentSnapShotBlock;
194         transfersEnabled = _transfersEnabled;
195         creationBlock = block.number;
196     }
197 
198 
199 ///////////////////
200 // ERC20 Methods
201 ///////////////////
202 
203     uint constant MAX_UINT = 2**256 - 1;
204 
205     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
206     /// @param _to The address of the recipient
207     /// @param _amount The amount of tokens to be transferred
208     /// @return Whether the transfer was successful or not
209     function transfer(address _to, uint256 _amount) public returns (bool success) {
210         require(transfersEnabled);
211         doTransfer(msg.sender, _to, _amount);
212         return true;
213     }
214 
215     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
216     ///  is approved by `_from`
217     /// @param _from The address holding the tokens being transferred
218     /// @param _to The address of the recipient
219     /// @param _amount The amount of tokens to be transferred
220     /// @return True if the transfer was successful
221     function transferFrom(address _from, address _to, uint256 _amount
222     ) public returns (bool success) {
223 
224         // The controller of this contract can move tokens around at will,
225         //  this is important to recognize! Confirm that you trust the
226         //  controller of this contract, which in most situations should be
227         //  another open source smart contract or 0x0
228         if (msg.sender != controller) {
229             require(transfersEnabled);
230 
231             // The standard ERC 20 transferFrom functionality
232             if (allowed[_from][msg.sender] < MAX_UINT) {
233                 require(allowed[_from][msg.sender] >= _amount);
234                 allowed[_from][msg.sender] -= _amount;
235             }
236         }
237         doTransfer(_from, _to, _amount);
238         return true;
239     }
240 
241     /// @dev This is the actual transfer function in the token contract, it can
242     ///  only be called by other functions in this contract.
243     /// @param _from The address holding the tokens being transferred
244     /// @param _to The address of the recipient
245     /// @param _amount The amount of tokens to be transferred
246     /// @return True if the transfer was successful
247     function doTransfer(address _from, address _to, uint _amount
248     ) internal {
249 
250            if (_amount == 0) {
251                emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
252                return;
253            }
254 
255            require(parentSnapShotBlock < block.number);
256 
257            // Do not allow transfer to 0x0 or the token contract itself
258            require((_to != address(0)) && (_to != address(this)));
259 
260            // If the amount being transfered is more than the balance of the
261            //  account the transfer throws
262            uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
263 
264            require(previousBalanceFrom >= _amount);
265 
266            // Alerts the token controller of the transfer
267            if (isContract(controller)) {
268                require(TokenController(controller).onTransfer(_from, _to, _amount));
269            }
270 
271            // First update the balance array with the new value for the address
272            //  sending the tokens
273            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
274 
275            // Then update the balance array with the new value for the address
276            //  receiving the tokens
277            uint256 previousBalanceTo = balanceOfAt(_to, block.number);
278            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
279            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
280 
281            // An event to make the transfer easy to find on the blockchain
282            emit Transfer(_from, _to, _amount);
283 
284     }
285 
286     /// @param _owner The address that's balance is being requested
287     /// @return The balance of `_owner` at the current block
288     function balanceOf(address _owner) public view returns (uint256 balance) {
289         return balanceOfAt(_owner, block.number);
290     }
291 
292     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
293     ///  its behalf. This is a modified version of the ERC20 approve function
294     ///  to be a little bit safer
295     /// @param _spender The address of the account able to transfer the tokens
296     /// @param _amount The amount of tokens to be approved for transfer
297     /// @return True if the approval was successful
298     function approve(address _spender, uint256 _amount) public returns (bool success) {
299         require(transfersEnabled);
300 
301         // To change the approve amount you first have to reduce the addresses`
302         //  allowance to zero by calling `approve(_spender,0)` if it is not
303         //  already 0 to mitigate the race condition described here:
304         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
305         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
306 
307         // Alerts the token controller of the approve function call
308         if (isContract(controller)) {
309             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
310         }
311 
312         allowed[msg.sender][_spender] = _amount;
313         emit Approval(msg.sender, _spender, _amount);
314         return true;
315     }
316 
317     /// @dev This function makes it easy to read the `allowed[]` map
318     /// @param _owner The address of the account that owns the token
319     /// @param _spender The address of the account able to transfer the tokens
320     /// @return Amount of remaining tokens of _owner that _spender is allowed
321     ///  to spend
322     function allowance(address _owner, address _spender
323     ) public view returns (uint256 remaining) {
324         return allowed[_owner][_spender];
325     }
326 
327     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
328     ///  its behalf, and then a function is triggered in the contract that is
329     ///  being approved, `_spender`. This allows users to use their tokens to
330     ///  interact with contracts in one function call instead of two
331     /// @param _spender The address of the contract able to transfer the tokens
332     /// @param _amount The amount of tokens to be approved for transfer
333     /// @return True if the function call was successful
334     function approveAndCall(address _spender, uint256 _amount, bytes memory _extraData
335     ) public returns (bool success) {
336         require(approve(_spender, _amount));
337 
338         ApproveAndCallFallBack(_spender).receiveApproval(
339             msg.sender,
340             _amount,
341             address(this),
342             _extraData
343         );
344 
345         return true;
346     }
347 
348     /// @dev This function makes it easy to get the total number of tokens
349     /// @return The total number of tokens
350     function totalSupply() public view returns (uint) {
351         return totalSupplyAt(block.number);
352     }
353 
354 
355 ////////////////
356 // Query balance and totalSupply in History
357 ////////////////
358 
359     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
360     /// @param _owner The address from which the balance will be retrieved
361     /// @param _blockNumber The block number when the balance is queried
362     /// @return The balance at `_blockNumber`
363     function balanceOfAt(address _owner, uint _blockNumber) public view
364         returns (uint) {
365 
366         // These next few lines are used when the balance of the token is
367         //  requested before a check point was ever created for this token, it
368         //  requires that the `parentToken.balanceOfAt` be queried at the
369         //  genesis block for that token as this contains initial balance of
370         //  this token
371         if ((balances[_owner].length == 0)
372             || (balances[_owner][0].fromBlock > _blockNumber)) {
373             if (address(parentToken) != address(0)) {
374                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
375             } else {
376                 // Has no parent
377                 return 0;
378             }
379 
380         // This will return the expected balance during normal situations
381         } else {
382             return getValueAt(balances[_owner], _blockNumber);
383         }
384     }
385 
386     /// @notice Total amount of tokens at a specific `_blockNumber`.
387     /// @param _blockNumber The block number when the totalSupply is queried
388     /// @return The total amount of tokens at `_blockNumber`
389     function totalSupplyAt(uint _blockNumber) public view returns(uint) {
390 
391         // These next few lines are used when the totalSupply of the token is
392         //  requested before a check point was ever created for this token, it
393         //  requires that the `parentToken.totalSupplyAt` be queried at the
394         //  genesis block for this token as that contains totalSupply of this
395         //  token at this block number.
396         if ((totalSupplyHistory.length == 0)
397             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
398             if (address(parentToken) != address(0)) {
399                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
400             } else {
401                 return 0;
402             }
403 
404         // This will return the expected totalSupply during normal situations
405         } else {
406             return getValueAt(totalSupplyHistory, _blockNumber);
407         }
408     }
409 
410 ////////////////
411 // Clone Token Method
412 ////////////////
413 
414     /// @notice Creates a new clone token with the initial distribution being
415     ///  this token at `_snapshotBlock`
416     /// @param _cloneTokenName Name of the clone token
417     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
418     /// @param _cloneTokenSymbol Symbol of the clone token
419     /// @param _snapshotBlock Block when the distribution of the parent token is
420     ///  copied to set the initial distribution of the new clone token;
421     ///  if the block is zero than the actual block, the current block is used
422     /// @param _transfersEnabled True if transfers are allowed in the clone
423     /// @return The address of the new MiniMeToken Contract
424     function createCloneToken(
425         string memory _cloneTokenName,
426         uint8 _cloneDecimalUnits,
427         string memory _cloneTokenSymbol,
428         uint _snapshotBlock,
429         bool _transfersEnabled
430         ) public returns(address) {
431         if (_snapshotBlock == 0) _snapshotBlock = block.number;
432         MiniMeToken cloneToken = tokenFactory.createCloneToken(
433             address(this),
434             _snapshotBlock,
435             _cloneTokenName,
436             _cloneDecimalUnits,
437             _cloneTokenSymbol,
438             _transfersEnabled
439             );
440 
441         cloneToken.changeController(msg.sender);
442 
443         // An event to make the token easy to find on the blockchain
444         emit NewCloneToken(address(cloneToken), _snapshotBlock);
445         return address(cloneToken);
446     }
447 
448 ////////////////
449 // Generate and destroy tokens
450 ////////////////
451 
452     /// @notice Generates `_amount` tokens that are assigned to `_owner`
453     /// @param _owner The address that will be assigned the new tokens
454     /// @param _amount The quantity of tokens generated
455     /// @return True if the tokens are generated correctly
456     function generateTokens(address _owner, uint _amount
457     ) public onlyController returns (bool) {
458         uint curTotalSupply = totalSupply();
459         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
460         uint previousBalanceTo = balanceOf(_owner);
461         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
462         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
463         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
464         emit Transfer(address(0), _owner, _amount);
465         return true;
466     }
467 
468 
469     /// @notice Burns `_amount` tokens from `_owner`
470     /// @param _owner The address that will lose the tokens
471     /// @param _amount The quantity of tokens to burn
472     /// @return True if the tokens are burned correctly
473     function destroyTokens(address _owner, uint _amount
474     ) onlyController public returns (bool) {
475         uint curTotalSupply = totalSupply();
476         require(curTotalSupply >= _amount);
477         uint previousBalanceFrom = balanceOf(_owner);
478         require(previousBalanceFrom >= _amount);
479         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
480         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
481         emit Transfer(_owner, address(0), _amount);
482         return true;
483     }
484 
485 ////////////////
486 // Enable tokens transfers
487 ////////////////
488 
489 
490     /// @notice Enables token holders to transfer their tokens freely if true
491     /// @param _transfersEnabled True if transfers are allowed in the clone
492     function enableTransfers(bool _transfersEnabled) public onlyController {
493         transfersEnabled = _transfersEnabled;
494     }
495 
496 ////////////////
497 // Internal helper functions to query and set a value in a snapshot array
498 ////////////////
499 
500     /// @dev `getValueAt` retrieves the number of tokens at a given block number
501     /// @param checkpoints The history of values being queried
502     /// @param _block The block number to retrieve the value at
503     /// @return The number of tokens being queried
504     function getValueAt(Checkpoint[] storage checkpoints, uint _block
505     ) view internal returns (uint) {
506         if (checkpoints.length == 0) return 0;
507 
508         // Shortcut for the actual value
509         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
510             return checkpoints[checkpoints.length-1].value;
511         if (_block < checkpoints[0].fromBlock) return 0;
512 
513         // Binary search of the value in the array
514         uint min = 0;
515         uint max = checkpoints.length-1;
516         uint mid = 0;
517         while (max > min) {
518             mid = (max + min + 1)/ 2;
519             if (checkpoints[mid].fromBlock<=_block) {
520                 min = mid;
521             } else {
522                 max = mid-1;
523             }
524         }
525         return checkpoints[min].value;
526     }
527 
528     /// @dev `updateValueAtNow` used to update the `balances` map and the
529     ///  `totalSupplyHistory`
530     /// @param checkpoints The history of data being updated
531     /// @param _value The new number of tokens
532     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
533     ) internal  {
534         if ((checkpoints.length == 0)
535         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
536                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
537                newCheckPoint.fromBlock =  uint256(block.number);
538                newCheckPoint.value = uint256(_value);
539            } else {
540                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
541                oldCheckPoint.value = uint256(_value);
542            }
543     }
544 
545     /// @dev Internal function to determine if an address is a contract
546     /// @param _addr The address being queried
547     /// @return True if `_addr` is a contract
548     function isContract(address _addr) view internal returns(bool) {
549         uint size;
550         if (_addr == address(0)) return false;
551         assembly {
552             size := extcodesize(_addr)
553         }
554         return size>0;
555     }
556 
557     /// @dev Helper function to return a min betwen the two uints
558     function min(uint a, uint b) pure internal returns (uint) {
559         return a < b ? a : b;
560     }
561 
562     /// @notice The fallback function: If the contract's controller has not been
563     ///  set to 0, then the `proxyPayment` method is called which relays the
564     ///  ether and creates tokens as described in the token controller contract
565     function () external payable {
566         require(isContract(controller));
567         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
568     }
569 
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
606         address payable _parentToken,
607         uint _snapshotBlock,
608         string memory _tokenName,
609         uint8 _decimalUnits,
610         string memory _tokenSymbol,
611         bool _transfersEnabled
612     ) public returns (MiniMeToken) {
613         MiniMeToken newToken = new MiniMeToken(
614             address(this),
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
626   }
627 
628 
629 contract LEO is MiniMeToken {
630 
631   constructor(
632     address _tokenFactory,
633     address initialOwner
634   ) public MiniMeToken(
635     _tokenFactory,
636     address(0),             // no parent token
637     0,                      // no snapshot block number from parent
638     "Bitfinex LEO Token",   // Token name
639     18,                     // Decimals
640     "LEO",                  // Symbol
641     true                    // Enable transfers
642     ) {
643         generateTokens(initialOwner, 660000000000000000000000000);
644     }
645 
646 }
647 
648 
649 contract LEOController is TokenController, Ownable {
650 
651     LEO public tokenContract;   // The new token for this Campaign
652 
653     /// @param _tokenAddress Address of the token contract this contract controls
654 
655     constructor(
656         address payable _tokenAddress
657     ) public {
658         tokenContract = LEO(_tokenAddress);         // The Deployed Token Contract
659     }
660 
661 
662 /////////////////
663 // TokenController interface
664 /////////////////
665 
666     /// @notice Notifies the controller about a transfer.
667     /// Transfers can only happen to whitelisted addresses
668     /// @param _from The origin of the transfer
669     /// @param _to The destination of the transfer
670     /// @param _amount The amount of the transfer
671     /// @return False if the controller does not authorize the transfer
672     function onTransfer(address _from, address _to, uint _amount) public returns(bool) {
673         return true;
674     }
675 
676     /// @notice Notifies the controller about an approval, for this Campaign all
677     ///  approvals are allowed by default and no extra notifications are needed
678     /// @param _owner The address that calls `approve()`
679     /// @param _spender The spender in the `approve()` call
680     /// @param _amount The amount in the `approve()` call
681     /// @return False if the controller does not authorize the approval
682     function onApprove(address _owner, address _spender, uint _amount) public
683         returns(bool)
684     {
685         return true;
686     }
687 
688     function proxyPayment(address _owner) public payable returns(bool allowed) {
689         allowed = false;
690     }
691 
692     /// @notice `onlyOwner` can upgrade the controller contract
693     /// @param _newControllerAddress The address that will have the token control logic
694     function upgradeController(address _newControllerAddress) public onlyOwner {
695         tokenContract.changeController(_newControllerAddress);
696         emit UpgradedController(_newControllerAddress);
697     }
698 
699     function burnTokens(uint _amount) public onlyOwner returns (bool) {
700         tokenContract.destroyTokens(owner, _amount);
701     }
702 
703     function issueTokens(uint _amount) public onlyOwner returns (bool) {
704         tokenContract.generateTokens(owner, _amount);
705     }
706 
707 
708 //////////
709 // Safety Methods
710 //////////
711 
712     /// @notice This method can be used by the owner to extract mistakenly
713     ///  sent tokens to this contract.
714     /// @param _token The address of the token contract that you want to recover
715     function claimLostTokens(address payable _token) public onlyOwner {
716 
717         LEO token = LEO(_token);
718         uint balance = token.balanceOf(address(this));
719         token.transfer(owner, balance);
720         emit ClaimedTokens(_token, owner, balance);
721     }
722 
723 ////////////////
724 // Events
725 ////////////////
726     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
727 
728     event UpgradedController (address newAddress);
729 
730 }