1 pragma solidity ^0.4.24;
2 
3 // Safe Haven Token Sale
4 //
5 // @authors:
6 // Davy Van Roy <davy.van.roy@gmail.com>
7 // Quinten De Swaef <quinten.de.swaef@gmail.com>
8 // 
9 // Jurgen Schouppe <jurgen.soltronics@gmail.com>
10 // Andy Demeulemeester <andydemeulemeester@gmail.com>
11 //
12 // The SafeHaven contracts are based on our friends of Fundrequest Token and crowdsale contracts.
13 //
14 // By sending ETH to this contract, you agree to the terms and purchase agreement for participating in the Safe Haven Token Sale:
15 // https://safehaven.io/terms.php
16 // https://safehaven.io/purchase.php
17 // 
18 // Security audit performed by LeastAuthority:
19 // https://github.com/FundRequest/audit-reports/raw/master/2018-02-06 - Least Authority - ICO Contracts Audit Report.pdf
20 
21 contract Controlled {
22 
23     /// @notice The address of the controller is the only address that can call
24     ///  a function with this modifier
25     modifier onlyController {
26         require(msg.sender == controller);
27         _;
28     }
29 
30     address public controller;
31 
32     constructor() public {controller = msg.sender;}
33 
34     /// @notice Changes the controller of the contract
35     /// @param _newController The new controller of the contract
36     function changeController(address _newController) public onlyController {
37         controller = _newController;
38     }
39 }
40 
41 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
42 ///  later changed
43 contract Owned {
44 
45     /// @dev `owner` is the only address that can call a function with this
46     /// modifier
47     modifier onlyOwner {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     address public owner;
53 
54     /// @notice The Constructor assigns the message sender to be `owner`
55     constructor() public {owner = msg.sender;}
56 
57     /// @notice `owner` can step down and assign some other address to this role
58     /// @param _newOwner The address of the new owner. 0x0 can be used to create
59     ///  an unowned neutral vault, however that cannot be undone
60     function changeOwner(address _newOwner) public onlyOwner {
61         owner = _newOwner;
62     }
63 }
64 
65 
66 
67 /// @dev The token controller contract must implement these functions
68 contract TokenController {
69   /// @notice Called when `_owner` sends ether to the MiniMe Token contract
70   /// @param _owner The address that sent the ether to create tokens
71   /// @return True if the ether is accepted, false if it throws
72   function proxyPayment(address _owner) public payable returns(bool);
73 
74   /// @notice Notifies the controller about a token transfer allowing the
75   ///  controller to react if desired
76   /// @param _from The origin of the transfer
77   /// @param _to The destination of the transfer
78   /// @param _amount The amount of the transfer
79   /// @return False if the controller does not authorize the transfer
80   function onTransfer(address _from, address _to, uint _amount) public returns(bool);
81 
82   /// @notice Notifies the controller about an approval allowing the
83   ///  controller to react if desired
84   /// @param _owner The address that calls `approve()`
85   /// @param _spender The spender in the `approve()` call
86   /// @param _amount The amount in the `approve()` call
87   /// @return False if the controller does not authorize the approval
88   function onApprove(address _owner, address _spender, uint _amount)
89   public
90   returns(bool);
91 }
92 
93 
94 contract ApproveAndCallFallBack {
95   function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
96 }
97 
98 contract ERC20 {
99   function totalSupply() constant public returns (uint);
100 
101   function balanceOf(address who) constant public returns (uint256);
102 
103   function transfer(address to, uint256 value) public returns (bool);
104 
105   function allowance(address owner, address spender) public constant returns (uint256);
106 
107   function transferFrom(address from, address to, uint256 value) public returns (bool);
108 
109   function approve(address spender, uint256 value) public returns (bool);
110 
111   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
112 
113   event Transfer(address indexed _from, address indexed _to, uint256 _value);
114 }
115 
116 
117 /*
118     Copyright 2016, Jordi Baylina
119 
120     This program is free software: you can redistribute it and/or modify
121     it under the terms of the GNU General Public License as published by
122     the Free Software Foundation, either version 3 of the License, or
123     (at your option) any later version.
124 
125     This program is distributed in the hope that it will be useful,
126     but WITHOUT ANY WARRANTY; without even the implied warranty of
127     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
128     GNU General Public License for more details.
129 
130     You should have received a copy of the GNU General Public License
131     along with this program.  If not, see <http://www.gnu.org/licenses/>.
132  */
133 
134 /// @title MiniMeToken Contract
135 /// @author Jordi Baylina
136 /// @dev This token contract's goal is to make it easy for anyone to clone this
137 ///  token using the token distribution at a given block, this will allow DAO's
138 ///  and DApps to upgrade their features in a decentralized manner without
139 ///  affecting the original token
140 /// @dev It is ERC20 compliant, but still needs to under go further testing.
141 
142 
143 
144 /// @dev The actual token contract, the default controller is the msg.sender
145 ///  that deploys the contract, so usually this token will be deployed by a
146 ///  token controller contract, which Giveth will call a "Campaign"
147 contract MiniMeToken is Controlled {
148 
149     string public name;                //The Token's name: e.g. DigixDAO Tokens
150     uint8 public decimals;             //Number of decimals of the smallest unit
151     string public symbol;              //An identifier: e.g. REP
152     string public version = "1.0.0"; 
153 
154     /// @dev `Checkpoint` is the structure that attaches a block number to a
155     ///  given value, the block number attached is the one that last changed the
156     ///  value
157     struct Checkpoint {
158 
159         // `fromBlock` is the block number that the value was generated from
160         uint128 fromBlock;
161 
162         // `value` is the amount of tokens at a specific block number
163         uint128 value;
164     }
165 
166     // `parentToken` is the Token address that was cloned to produce this token;
167     //  it will be 0x0 for a token that was not cloned
168     MiniMeToken public parentToken;
169 
170     // `parentSnapShotBlock` is the block number from the Parent Token that was
171     //  used to determine the initial distribution of the Clone Token
172     uint public parentSnapShotBlock;
173 
174     // `creationBlock` is the block number that the Clone Token was created
175     uint public creationBlock;
176 
177     // `balances` is the map that tracks the balance of each address, in this
178     //  contract when the balance changes the block number that the change
179     //  occurred is also included in the map
180     mapping (address => Checkpoint[]) balances;
181 
182     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
183     mapping (address => mapping (address => uint256)) allowed;
184 
185     // Tracks the history of the `totalSupply` of the token
186     Checkpoint[] totalSupplyHistory;
187 
188     // Flag that determines if the token is transferable or not.
189     bool public transfersEnabled;
190 
191     // The factory used to create new clone tokens
192     MiniMeTokenFactory public tokenFactory;
193 
194 ////////////////
195 // Constructor
196 ////////////////
197 
198     /// @notice Constructor to create a MiniMeToken
199     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
200     ///  will create the Clone token contracts, the token factory needs to be
201     ///  deployed first
202     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
203     ///  new token
204     /// @param _parentSnapShotBlock Block of the parent token that will
205     ///  determine the initial distribution of the clone token, set to 0 if it
206     ///  is a new token
207     /// @param _tokenName Name of the new token
208     /// @param _decimalUnits Number of decimals of the new token
209     /// @param _tokenSymbol Token Symbol for the new token
210     /// @param _transfersEnabled If true, tokens will be able to be transferred
211     constructor(
212         address _tokenFactory,
213         address _parentToken,
214         uint _parentSnapShotBlock,
215         string _tokenName,
216         uint8 _decimalUnits,
217         string _tokenSymbol,
218         bool _transfersEnabled
219     ) public 
220     {
221         tokenFactory = MiniMeTokenFactory(_tokenFactory);
222         name = _tokenName;                                 // Set the name
223         decimals = _decimalUnits;                          // Set the decimals
224         symbol = _tokenSymbol;                             // Set the symbol
225         parentToken = MiniMeToken(_parentToken);
226         parentSnapShotBlock = _parentSnapShotBlock;
227         transfersEnabled = _transfersEnabled;
228         creationBlock = block.number;
229     }
230 
231 
232 ///////////////////
233 // ERC20 Methods
234 ///////////////////
235 
236     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
237     /// @param _to The address of the recipient
238     /// @param _amount The amount of tokens to be transferred
239     /// @return Whether the transfer was successful or not
240     function transfer(address _to, uint256 _amount) public returns (bool success) {
241         require(transfersEnabled);
242         return doTransfer(msg.sender, _to, _amount);
243     }
244 
245     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
246     ///  is approved by `_from`
247     /// @param _from The address holding the tokens being transferred
248     /// @param _to The address of the recipient
249     /// @param _amount The amount of tokens to be transferred
250     /// @return True if the transfer was successful
251     function transferFrom(address _from, address _to, uint256 _amount) 
252         public returns (bool success) 
253         {
254         // The controller of this contract can move tokens around at will,
255         //  this is important to recognize! Confirm that you trust the
256         //  controller of this contract, which in most situations should be
257         //  another open source smart contract or 0x0
258         if (msg.sender != controller) {
259             require(transfersEnabled);
260 
261             // The standard ERC 20 transferFrom functionality
262             if (allowed[_from][msg.sender] < _amount) {
263                 return false;
264             }
265             allowed[_from][msg.sender] -= _amount;
266         }
267         return doTransfer(_from, _to, _amount);
268     }
269 
270     /// @dev This is the actual transfer function in the token contract, it can
271     ///  only be called by other functions in this contract.
272     /// @param _from The address holding the tokens being transferred
273     /// @param _to The address of the recipient
274     /// @param _amount The amount of tokens to be transferred
275     /// @return True if the transfer was successful
276     function doTransfer(address _from, address _to, uint _amount
277     ) internal returns(bool) 
278     {
279 
280            if (_amount == 0) {
281                return true;
282            }
283 
284            require(parentSnapShotBlock < block.number);
285 
286            // Do not allow transfer to 0x0 or the token contract itself
287            require((_to != 0) && (_to != address(this)));
288 
289            // If the amount being transfered is more than the balance of the
290            //  account the transfer returns false
291            uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
292            if (previousBalanceFrom < _amount) {
293                return false;
294            }
295 
296            // Alerts the token controller of the transfer
297            if (isContract(controller)) {
298                require(TokenController(controller).onTransfer(_from, _to, _amount));
299            }
300 
301            // First update the balance array with the new value for the address
302            //  sending the tokens
303            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
304 
305            // Then update the balance array with the new value for the address
306            //  receiving the tokens
307            uint256 previousBalanceTo = balanceOfAt(_to, block.number);
308            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
309            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
310 
311            // An event to make the transfer easy to find on the blockchain
312            emit Transfer(_from, _to, _amount);
313 
314            return true;
315     }
316 
317     /// @param _owner The address that's balance is being requested
318     /// @return The balance of `_owner` at the current block
319     function balanceOf(address _owner) public constant returns (uint256 balance) {
320         return balanceOfAt(_owner, block.number);
321     }
322 
323     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
324     ///  its behalf. This is a modified version of the ERC20 approve function
325     ///  to be a little bit safer
326     /// @param _spender The address of the account able to transfer the tokens
327     /// @param _amount The amount of tokens to be approved for transfer
328     /// @return True if the approval was successful
329     function approve(address _spender, uint256 _amount) public returns (bool success) {
330         require(transfersEnabled);
331 
332         // To change the approve amount you first have to reduce the addresses`
333         //  allowance to zero by calling `approve(_spender,0)` if it is not
334         //  already 0 to mitigate the race condition described here:
335         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
336         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
337         return doApprove(_spender, _amount);
338     }
339 
340     function doApprove(address _spender, uint256 _amount) internal returns (bool success) {
341         require(transfersEnabled);
342         if (isContract(controller)) {
343             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
344         }
345         allowed[msg.sender][_spender] = _amount;
346         emit Approval(msg.sender, _spender, _amount);
347         return true;
348     }
349 
350     /// @dev This function makes it easy to read the `allowed[]` map
351     /// @param _owner The address of the account that owns the token
352     /// @param _spender The address of the account able to transfer the tokens
353     /// @return Amount of remaining tokens of _owner that _spender is allowed
354     ///  to spend
355     function allowance(address _owner, address _spender
356     ) public constant returns (uint256 remaining) 
357     {
358         return allowed[_owner][_spender];
359     }
360 
361     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
362     ///  its behalf, and then a function is triggered in the contract that is
363     ///  being approved, `_spender`. This allows users to use their tokens to
364     ///  interact with contracts in one function call instead of two
365     /// @param _spender The address of the contract able to transfer the tokens
366     /// @param _amount The amount of tokens to be approved for transfer
367     /// @return True if the function call was successful
368     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
369     ) public returns (bool success) 
370     {
371         require(approve(_spender, _amount));
372 
373         ApproveAndCallFallBack(_spender).receiveApproval(
374             msg.sender,
375             _amount,
376             this,
377             _extraData
378         );
379 
380         return true;
381     }
382 
383     /// @dev This function makes it easy to get the total number of tokens
384     /// @return The total number of tokens
385     function totalSupply() public constant returns (uint) {
386         return totalSupplyAt(block.number);
387     }
388 
389 
390 ////////////////
391 // Query balance and totalSupply in History
392 ////////////////
393 
394     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
395     /// @param _owner The address from which the balance will be retrieved
396     /// @param _blockNumber The block number when the balance is queried
397     /// @return The balance at `_blockNumber`
398     function balanceOfAt(address _owner, uint _blockNumber) public constant
399         returns (uint) 
400     {
401         // These next few lines are used when the balance of the token is
402         //  requested before a check point was ever created for this token, it
403         //  requires that the `parentToken.balanceOfAt` be queried at the
404         //  genesis block for that token as this contains initial balance of
405         //  this token
406         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
407             if (address(parentToken) != 0) {
408                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
409             } else {
410                 // Has no parent
411                 return 0;
412             }
413 
414         // This will return the expected balance during normal situations
415         } else {
416             return getValueAt(balances[_owner], _blockNumber);
417         }
418     }
419 
420     /// @notice Total amount of tokens at a specific `_blockNumber`.
421     /// @param _blockNumber The block number when the totalSupply is queried
422     /// @return The total amount of tokens at `_blockNumber`
423     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
424 
425         // These next few lines are used when the totalSupply of the token is
426         //  requested before a check point was ever created for this token, it
427         //  requires that the `parentToken.totalSupplyAt` be queried at the
428         //  genesis block for this token as that contains totalSupply of this
429         //  token at this block number.
430         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
431             if (address(parentToken) != 0) {
432                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
433             } else {
434                 return 0;
435             }
436 
437         // This will return the expected totalSupply during normal situations
438         } else {
439             return getValueAt(totalSupplyHistory, _blockNumber);
440         }
441     }
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
458         string _cloneTokenName,
459         uint8 _cloneDecimalUnits,
460         string _cloneTokenSymbol,
461         uint _snapshotBlock,
462         bool _transfersEnabled
463         ) public returns(address) 
464     {
465         if (_snapshotBlock == 0) {
466             _snapshotBlock = block.number;
467         }
468 
469         MiniMeToken cloneToken = tokenFactory.createCloneToken(
470             this,
471             _snapshotBlock,
472             _cloneTokenName,
473             _cloneDecimalUnits,
474             _cloneTokenSymbol,
475             _transfersEnabled
476             );
477 
478         cloneToken.changeController(msg.sender);
479 
480         // An event to make the token easy to find on the blockchain
481         emit NewCloneToken(address(cloneToken), _snapshotBlock);
482         return address(cloneToken);
483     }
484 
485 ////////////////
486 // Generate and destroy tokens
487 ////////////////
488 
489     /// @notice Generates `_amount` tokens that are assigned to `_owner`
490     /// @param _owner The address that will be assigned the new tokens
491     /// @param _amount The quantity of tokens generated
492     /// @return True if the tokens are generated correctly
493     function generateTokens(address _owner, uint _amount) 
494         public onlyController returns (bool) 
495     {
496         uint curTotalSupply = totalSupply();
497         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
498         uint previousBalanceTo = balanceOf(_owner);
499         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
500         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
501         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
502         emit Transfer(0, _owner, _amount);
503         return true;
504     }
505 
506 
507     /// @notice Burns `_amount` tokens from `_owner`
508     /// @param _owner The address that will lose the tokens
509     /// @param _amount The quantity of tokens to burn
510     /// @return True if the tokens are burned correctly
511     function destroyTokens(address _owner, uint _amount
512     ) onlyController public returns (bool) 
513     {
514         uint curTotalSupply = totalSupply();
515         require(curTotalSupply >= _amount);
516         uint previousBalanceFrom = balanceOf(_owner);
517         require(previousBalanceFrom >= _amount);
518         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
519         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
520         emit Transfer(_owner, 0, _amount);
521         return true;
522     }
523 
524 ////////////////
525 // Enable tokens transfers
526 ////////////////
527 
528 
529     /// @notice Enables token holders to transfer their tokens freely if true
530     /// @param _transfersEnabled True if transfers are allowed in the clone
531     function enableTransfers(bool _transfersEnabled) public onlyController {
532         transfersEnabled = _transfersEnabled;
533     }
534 
535 ////////////////
536 // Internal helper functions to query and set a value in a snapshot array
537 ////////////////
538 
539     /// @dev `getValueAt` retrieves the number of tokens at a given block number
540     /// @param checkpoints The history of values being queried
541     /// @param _block The block number to retrieve the value at
542     /// @return The number of tokens being queried
543     function getValueAt(Checkpoint[] storage checkpoints, uint _block) 
544         constant internal returns (uint) 
545     {
546         if (checkpoints.length == 0) {
547             return 0;
548         }
549 
550         // Shortcut for the actual value
551         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
552             return checkpoints[checkpoints.length-1].value;
553         }
554             
555         if (_block < checkpoints[0].fromBlock) {
556             return 0;
557         }
558 
559         // Binary search of the value in the array
560         uint min = 0;
561         uint max = checkpoints.length - 1;
562         while (max > min) {
563             uint mid = (max + min + 1) / 2;
564             if (checkpoints[mid].fromBlock<=_block) {
565                 min = mid;
566             } else {
567                 max = mid-1;
568             }
569         }
570         return checkpoints[min].value;
571     }
572 
573     /// @dev `updateValueAtNow` used to update the `balances` map and the
574     ///  `totalSupplyHistory`
575     /// @param checkpoints The history of data being updated
576     /// @param _value The new number of tokens
577     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
578     ) internal  
579     {
580         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length-1].fromBlock < block.number)) {
581                Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
582                newCheckPoint.fromBlock = uint128(block.number);
583                newCheckPoint.value = uint128(_value);
584            } else {
585                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
586                oldCheckPoint.value = uint128(_value);
587            }
588     }
589 
590     /// @dev Internal function to determine if an address is a contract
591     /// @param _addr The address being queried
592     /// @return True if `_addr` is a contract
593     function isContract(address _addr) constant internal returns(bool) {
594         uint size;
595         if (_addr == 0) {
596             return false;
597         }
598         assembly {
599             size := extcodesize(_addr)
600         }
601         return size>0;
602     }
603 
604     /// @dev Helper function to return a min betwen the two uints
605     function min(uint a, uint b) pure internal returns (uint) {
606         return a < b ? a : b;
607     }
608 
609     /// @notice The fallback function: If the contract's controller has not been
610     ///  set to 0, then the `proxyPayment` method is called which relays the
611     ///  ether and creates tokens as described in the token controller contract
612     function () public payable {
613         require(isContract(controller));
614         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
615     }
616 
617 //////////
618 // Safety Methods
619 //////////
620 
621     /// @notice This method can be used by the controller to extract mistakenly
622     ///  sent tokens to this contract.
623     /// @param _token The address of the token contract that you want to recover
624     ///  set to 0 in case you want to extract ether.
625     function claimTokens(address _token) public onlyController {
626         if (_token == 0x0) {
627             controller.transfer(address(this).balance);
628             return;
629         }
630 
631         MiniMeToken token = MiniMeToken(_token);
632         uint balance = token.balanceOf(this);
633         token.transfer(controller, balance);
634         emit ClaimedTokens(_token, controller, balance);
635     }
636 
637 ////////////////
638 // Events
639 ////////////////
640     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
641     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
642     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
643     event Approval(
644         address indexed _owner,
645         address indexed _spender,
646         uint256 _amount
647         );
648 
649 }
650 
651 
652 
653 contract SafeHavenToken is MiniMeToken {
654 
655   constructor(
656     address _tokenFactory,
657     address _parentToken, 
658     uint _parentSnapShotBlock, 
659     string _tokenName, 
660     uint8 _decimalUnits, 
661     string _tokenSymbol, 
662     bool _transfersEnabled) 
663     public 
664     MiniMeToken(
665       _tokenFactory,
666       _parentToken, 
667       _parentSnapShotBlock, 
668       _tokenName, 
669       _decimalUnits, 
670       _tokenSymbol, 
671       _transfersEnabled) 
672   {
673     //constructor
674   }
675 
676   function safeApprove(address _spender, uint256 _currentValue, uint256 _amount) public returns (bool success) {
677     require(allowed[msg.sender][_spender] == _currentValue);
678     return doApprove(_spender, _amount);
679   }
680 
681   function isSafeHavenToken() public pure returns (bool) {
682     return true;
683   }
684 }
685 
686 /// @dev This contract is used to generate clone contracts from a contract.
687 ///  In solidity this is the way to create a contract from a contract of the
688 ///  same class
689 contract MiniMeTokenFactory {
690 
691     /// @notice Update the DApp by creating a new token with new functionalities
692     ///  the msg.sender becomes the controller of this clone token
693     /// @param _parentToken Address of the token being cloned
694     /// @param _snapshotBlock Block of the parent token that will
695     ///  determine the initial distribution of the clone token
696     /// @param _tokenName Name of the new token
697     /// @param _decimalUnits Number of decimals of the new token
698     /// @param _tokenSymbol Token Symbol for the new token
699     /// @param _transfersEnabled If true, tokens will be able to be transferred
700     /// @return The address of the new token contract
701     function createCloneToken(
702         address _parentToken,
703         uint _snapshotBlock,
704         string _tokenName,
705         uint8 _decimalUnits,
706         string _tokenSymbol,
707         bool _transfersEnabled
708     ) public returns (MiniMeToken)
709     {
710         MiniMeToken newToken = new MiniMeToken(
711             this,
712             _parentToken,
713             _snapshotBlock,
714             _tokenName,
715             _decimalUnits,
716             _tokenSymbol,
717             _transfersEnabled
718         );
719 
720         newToken.changeController(msg.sender);
721         return newToken;
722     }
723 }