1 pragma solidity ^0.4.18;
2 
3 // FundRequest Token Sale
4 //
5 // @authors:
6 // Davy Van Roy <davy.van.roy@gmail.com>
7 // Quinten De Swaef <quinten.de.swaef@gmail.com>
8 //
9 // By sending ETH to this contract, you agree to the terms and conditions for participating in the FundRequest Token Sale:
10 // https://sale.fundrequest.io/assets/Terms-Conditions.pdf
11 //
12 // Security audit performed by LeastAuthority:
13 // https://github.com/FundRequest/audit-reports/raw/master/2018-02-06 - Least Authority - ICO Contracts Audit Report.pdf
14 
15 
16 contract ApproveAndCallFallBack {
17     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
18 }
19 
20 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
21 ///  later changed
22 contract Owned {
23     /// @dev `owner` is the only address that can call a function with this
24     /// modifier
25     modifier onlyOwner { require (msg.sender == owner); _; }
26 
27     address public owner;
28 
29     /// @notice The Constructor assigns the message sender to be `owner`
30     function Owned() public { owner = msg.sender;}
31 
32     /// @notice `owner` can step down and assign some other address to this role
33     /// @param _newOwner The address of the new owner. 0x0 can be used to create
34     ///  an unowned neutral vault, however that cannot be undone
35     function changeOwner(address _newOwner) public onlyOwner {
36         owner = _newOwner;
37     }
38 }
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a * b;
47     assert(a == 0 || c / a == b);
48     return c;
49   }
50 
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return c;
56   }
57 
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function add(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 
71 
72 
73 
74 
75 /**
76  * @title Pausable
77  * @dev Base contract which allows children to implement an emergency stop mechanism.
78  */
79 contract Pausable is Owned {
80   event Pause();
81   event Unpause();
82 
83   bool public paused = false;
84 
85 
86   /**
87    * @dev modifier to allow actions only when the contract IS paused
88    */
89   modifier whenNotPaused() {
90     require(!paused);
91     _;
92   }
93 
94   /**
95    * @dev modifier to allow actions only when the contract IS NOT paused
96    */
97   modifier whenPaused() {
98     require(paused);
99     _;
100   }
101 
102   /**
103    * @dev called by the owner to pause, triggers stopped state
104    */
105   function pause() public onlyOwner whenNotPaused {
106     paused = true;
107     Pause();
108   }
109 
110   /**
111    * @dev called by the owner to unpause, returns to normal state
112    */
113   function unpause() public onlyOwner whenPaused {
114     paused = false;
115     Unpause();
116   }
117 }
118 
119 
120 contract Controlled {
121     /// @notice The address of the controller is the only address that can call
122     ///  a function with this modifier
123     modifier onlyController { require(msg.sender == controller); _; }
124 
125     address public controller;
126 
127     function Controlled() public { controller = msg.sender;}
128 
129     /// @notice Changes the controller of the contract
130     /// @param _newController The new controller of the contract
131     function changeController(address _newController) public onlyController {
132         controller = _newController;
133     }
134 }
135 
136 
137 /// @dev This contract is used to generate clone contracts from a contract.
138 ///  In solidity this is the way to create a contract from a contract of the
139 ///  same class
140 contract MiniMeTokenFactory {
141 
142     /// @notice Update the DApp by creating a new token with new functionalities
143     ///  the msg.sender becomes the controller of this clone token
144     /// @param _parentToken Address of the token being cloned
145     /// @param _snapshotBlock Block of the parent token that will
146     ///  determine the initial distribution of the clone token
147     /// @param _tokenName Name of the new token
148     /// @param _decimalUnits Number of decimals of the new token
149     /// @param _tokenSymbol Token Symbol for the new token
150     /// @param _transfersEnabled If true, tokens will be able to be transferred
151     /// @return The address of the new token contract
152     function createCloneToken(
153     address _parentToken,
154     uint _snapshotBlock,
155     string _tokenName,
156     uint8 _decimalUnits,
157     string _tokenSymbol,
158     bool _transfersEnabled
159     ) public returns (MiniMeToken)
160     {
161         MiniMeToken newToken = new MiniMeToken(
162         this,
163         _parentToken,
164         _snapshotBlock,
165         _tokenName,
166         _decimalUnits,
167         _tokenSymbol,
168         _transfersEnabled
169         );
170 
171         newToken.changeController(msg.sender);
172         return newToken;
173     }
174 }
175 
176 
177 /*
178     Copyright 2016, Jordi Baylina
179 
180     This program is free software: you can redistribute it and/or modify
181     it under the terms of the GNU General Public License as published by
182     the Free Software Foundation, either version 3 of the License, or
183     (at your option) any later version.
184 
185     This program is distributed in the hope that it will be useful,
186     but WITHOUT ANY WARRANTY; without even the implied warranty of
187     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
188     GNU General Public License for more details.
189 
190     You should have received a copy of the GNU General Public License
191     along with this program.  If not, see <http://www.gnu.org/licenses/>.
192  */
193 
194 /// @title MiniMeToken Contract
195 /// @author Jordi Baylina
196 /// @dev This token contract's goal is to make it easy for anyone to clone this
197 ///  token using the token distribution at a given block, this will allow DAO's
198 ///  and DApps to upgrade their features in a decentralized manner without
199 ///  affecting the original token
200 /// @dev It is ERC20 compliant, but still needs to under go further testing.
201 /// @dev The actual token contract, the default controller is the msg.sender
202 ///  that deploys the contract, so usually this token will be deployed by a
203 ///  token controller contract, which Giveth will call a "Campaign"
204 contract MiniMeToken is Controlled {
205 
206     string public name;                //The Token's name: e.g. DigixDAO Tokens
207     uint8 public decimals;             //Number of decimals of the smallest unit
208     string public symbol;              //An identifier: e.g. REP
209     string public version = "1.0.0"; 
210 
211     /// @dev `Checkpoint` is the structure that attaches a block number to a
212     ///  given value, the block number attached is the one that last changed the
213     ///  value
214     struct Checkpoint {
215 
216         // `fromBlock` is the block number that the value was generated from
217         uint128 fromBlock;
218 
219         // `value` is the amount of tokens at a specific block number
220         uint128 value;
221     }
222 
223     // `parentToken` is the Token address that was cloned to produce this token;
224     //  it will be 0x0 for a token that was not cloned
225     MiniMeToken public parentToken;
226 
227     // `parentSnapShotBlock` is the block number from the Parent Token that was
228     //  used to determine the initial distribution of the Clone Token
229     uint public parentSnapShotBlock;
230 
231     // `creationBlock` is the block number that the Clone Token was created
232     uint public creationBlock;
233 
234     // `balances` is the map that tracks the balance of each address, in this
235     //  contract when the balance changes the block number that the change
236     //  occurred is also included in the map
237     mapping (address => Checkpoint[]) balances;
238 
239     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
240     mapping (address => mapping (address => uint256)) allowed;
241 
242     // Tracks the history of the `totalSupply` of the token
243     Checkpoint[] totalSupplyHistory;
244 
245     // Flag that determines if the token is transferable or not.
246     bool public transfersEnabled;
247 
248     // The factory used to create new clone tokens
249     MiniMeTokenFactory public tokenFactory;
250 
251 ////////////////
252 // Constructor
253 ////////////////
254 
255     /// @notice Constructor to create a MiniMeToken
256     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
257     ///  will create the Clone token contracts, the token factory needs to be
258     ///  deployed first
259     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
260     ///  new token
261     /// @param _parentSnapShotBlock Block of the parent token that will
262     ///  determine the initial distribution of the clone token, set to 0 if it
263     ///  is a new token
264     /// @param _tokenName Name of the new token
265     /// @param _decimalUnits Number of decimals of the new token
266     /// @param _tokenSymbol Token Symbol for the new token
267     /// @param _transfersEnabled If true, tokens will be able to be transferred
268     function MiniMeToken(
269         address _tokenFactory,
270         address _parentToken,
271         uint _parentSnapShotBlock,
272         string _tokenName,
273         uint8 _decimalUnits,
274         string _tokenSymbol,
275         bool _transfersEnabled
276     ) public 
277     {
278         tokenFactory = MiniMeTokenFactory(_tokenFactory);
279         name = _tokenName;                                 // Set the name
280         decimals = _decimalUnits;                          // Set the decimals
281         symbol = _tokenSymbol;                             // Set the symbol
282         parentToken = MiniMeToken(_parentToken);
283         parentSnapShotBlock = _parentSnapShotBlock;
284         transfersEnabled = _transfersEnabled;
285         creationBlock = block.number;
286     }
287 
288 
289 ///////////////////
290 // ERC20 Methods
291 ///////////////////
292 
293     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
294     /// @param _to The address of the recipient
295     /// @param _amount The amount of tokens to be transferred
296     /// @return Whether the transfer was successful or not
297     function transfer(address _to, uint256 _amount) public returns (bool success) {
298         require(transfersEnabled);
299         return doTransfer(msg.sender, _to, _amount);
300     }
301 
302     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
303     ///  is approved by `_from`
304     /// @param _from The address holding the tokens being transferred
305     /// @param _to The address of the recipient
306     /// @param _amount The amount of tokens to be transferred
307     /// @return True if the transfer was successful
308     function transferFrom(address _from, address _to, uint256 _amount) 
309         public returns (bool success) 
310         {
311         // The controller of this contract can move tokens around at will,
312         //  this is important to recognize! Confirm that you trust the
313         //  controller of this contract, which in most situations should be
314         //  another open source smart contract or 0x0
315         if (msg.sender != controller) {
316             require(transfersEnabled);
317 
318             // The standard ERC 20 transferFrom functionality
319             if (allowed[_from][msg.sender] < _amount) {
320                 return false;
321             }
322             allowed[_from][msg.sender] -= _amount;
323         }
324         return doTransfer(_from, _to, _amount);
325     }
326 
327     /// @dev This is the actual transfer function in the token contract, it can
328     ///  only be called by other functions in this contract.
329     /// @param _from The address holding the tokens being transferred
330     /// @param _to The address of the recipient
331     /// @param _amount The amount of tokens to be transferred
332     /// @return True if the transfer was successful
333     function doTransfer(address _from, address _to, uint _amount
334     ) internal returns(bool) 
335     {
336 
337            if (_amount == 0) {
338                return true;
339            }
340 
341            require(parentSnapShotBlock < block.number);
342 
343            // Do not allow transfer to 0x0 or the token contract itself
344            require((_to != 0) && (_to != address(this)));
345 
346            // If the amount being transfered is more than the balance of the
347            //  account the transfer returns false
348            var previousBalanceFrom = balanceOfAt(_from, block.number);
349            if (previousBalanceFrom < _amount) {
350                return false;
351            }
352 
353            // Alerts the token controller of the transfer
354            if (isContract(controller)) {
355                require(TokenController(controller).onTransfer(_from, _to, _amount));
356            }
357 
358            // First update the balance array with the new value for the address
359            //  sending the tokens
360            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
361 
362            // Then update the balance array with the new value for the address
363            //  receiving the tokens
364            var previousBalanceTo = balanceOfAt(_to, block.number);
365            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
366            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
367 
368            // An event to make the transfer easy to find on the blockchain
369            Transfer(_from, _to, _amount);
370 
371            return true;
372     }
373 
374     /// @param _owner The address that's balance is being requested
375     /// @return The balance of `_owner` at the current block
376     function balanceOf(address _owner) public constant returns (uint256 balance) {
377         return balanceOfAt(_owner, block.number);
378     }
379 
380     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
381     ///  its behalf. This is a modified version of the ERC20 approve function
382     ///  to be a little bit safer
383     /// @param _spender The address of the account able to transfer the tokens
384     /// @param _amount The amount of tokens to be approved for transfer
385     /// @return True if the approval was successful
386     function approve(address _spender, uint256 _amount) public returns (bool success) {
387         require(transfersEnabled);
388 
389         // To change the approve amount you first have to reduce the addresses`
390         //  allowance to zero by calling `approve(_spender,0)` if it is not
391         //  already 0 to mitigate the race condition described here:
392         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
393         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
394         return doApprove(_spender, _amount);
395     }
396 
397     function doApprove(address _spender, uint256 _amount) internal returns (bool success) {
398         require(transfersEnabled);
399         if (isContract(controller)) {
400             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
401         }
402         allowed[msg.sender][_spender] = _amount;
403         Approval(msg.sender, _spender, _amount);
404         return true;
405     }
406 
407     /// @dev This function makes it easy to read the `allowed[]` map
408     /// @param _owner The address of the account that owns the token
409     /// @param _spender The address of the account able to transfer the tokens
410     /// @return Amount of remaining tokens of _owner that _spender is allowed
411     ///  to spend
412     function allowance(address _owner, address _spender
413     ) public constant returns (uint256 remaining) 
414     {
415         return allowed[_owner][_spender];
416     }
417 
418     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
419     ///  its behalf, and then a function is triggered in the contract that is
420     ///  being approved, `_spender`. This allows users to use their tokens to
421     ///  interact with contracts in one function call instead of two
422     /// @param _spender The address of the contract able to transfer the tokens
423     /// @param _amount The amount of tokens to be approved for transfer
424     /// @return True if the function call was successful
425     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
426     ) public returns (bool success) 
427     {
428         require(approve(_spender, _amount));
429 
430         ApproveAndCallFallBack(_spender).receiveApproval(
431             msg.sender,
432             _amount,
433             this,
434             _extraData
435         );
436 
437         return true;
438     }
439 
440     /// @dev This function makes it easy to get the total number of tokens
441     /// @return The total number of tokens
442     function totalSupply() public constant returns (uint) {
443         return totalSupplyAt(block.number);
444     }
445 
446 
447 ////////////////
448 // Query balance and totalSupply in History
449 ////////////////
450 
451     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
452     /// @param _owner The address from which the balance will be retrieved
453     /// @param _blockNumber The block number when the balance is queried
454     /// @return The balance at `_blockNumber`
455     function balanceOfAt(address _owner, uint _blockNumber) public constant
456         returns (uint) 
457     {
458         // These next few lines are used when the balance of the token is
459         //  requested before a check point was ever created for this token, it
460         //  requires that the `parentToken.balanceOfAt` be queried at the
461         //  genesis block for that token as this contains initial balance of
462         //  this token
463         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
464             if (address(parentToken) != 0) {
465                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
466             } else {
467                 // Has no parent
468                 return 0;
469             }
470 
471         // This will return the expected balance during normal situations
472         } else {
473             return getValueAt(balances[_owner], _blockNumber);
474         }
475     }
476 
477     /// @notice Total amount of tokens at a specific `_blockNumber`.
478     /// @param _blockNumber The block number when the totalSupply is queried
479     /// @return The total amount of tokens at `_blockNumber`
480     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
481 
482         // These next few lines are used when the totalSupply of the token is
483         //  requested before a check point was ever created for this token, it
484         //  requires that the `parentToken.totalSupplyAt` be queried at the
485         //  genesis block for this token as that contains totalSupply of this
486         //  token at this block number.
487         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
488             if (address(parentToken) != 0) {
489                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
490             } else {
491                 return 0;
492             }
493 
494         // This will return the expected totalSupply during normal situations
495         } else {
496             return getValueAt(totalSupplyHistory, _blockNumber);
497         }
498     }
499 
500 ////////////////
501 // Clone Token Method
502 ////////////////
503 
504     /// @notice Creates a new clone token with the initial distribution being
505     ///  this token at `_snapshotBlock`
506     /// @param _cloneTokenName Name of the clone token
507     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
508     /// @param _cloneTokenSymbol Symbol of the clone token
509     /// @param _snapshotBlock Block when the distribution of the parent token is
510     ///  copied to set the initial distribution of the new clone token;
511     ///  if the block is zero than the actual block, the current block is used
512     /// @param _transfersEnabled True if transfers are allowed in the clone
513     /// @return The address of the new MiniMeToken Contract
514     function createCloneToken(
515         string _cloneTokenName,
516         uint8 _cloneDecimalUnits,
517         string _cloneTokenSymbol,
518         uint _snapshotBlock,
519         bool _transfersEnabled
520         ) public returns(address) 
521     {
522         if (_snapshotBlock == 0) {
523             _snapshotBlock = block.number;
524         }
525 
526         MiniMeToken cloneToken = tokenFactory.createCloneToken(
527             this,
528             _snapshotBlock,
529             _cloneTokenName,
530             _cloneDecimalUnits,
531             _cloneTokenSymbol,
532             _transfersEnabled
533             );
534 
535         cloneToken.changeController(msg.sender);
536 
537         // An event to make the token easy to find on the blockchain
538         NewCloneToken(address(cloneToken), _snapshotBlock);
539         return address(cloneToken);
540     }
541 
542 ////////////////
543 // Generate and destroy tokens
544 ////////////////
545 
546     /// @notice Generates `_amount` tokens that are assigned to `_owner`
547     /// @param _owner The address that will be assigned the new tokens
548     /// @param _amount The quantity of tokens generated
549     /// @return True if the tokens are generated correctly
550     function generateTokens(address _owner, uint _amount) 
551         public onlyController returns (bool) 
552     {
553         uint curTotalSupply = totalSupply();
554         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
555         uint previousBalanceTo = balanceOf(_owner);
556         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
557         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
558         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
559         Transfer(0, _owner, _amount);
560         return true;
561     }
562 
563 
564     /// @notice Burns `_amount` tokens from `_owner`
565     /// @param _owner The address that will lose the tokens
566     /// @param _amount The quantity of tokens to burn
567     /// @return True if the tokens are burned correctly
568     function destroyTokens(address _owner, uint _amount
569     ) onlyController public returns (bool) 
570     {
571         uint curTotalSupply = totalSupply();
572         require(curTotalSupply >= _amount);
573         uint previousBalanceFrom = balanceOf(_owner);
574         require(previousBalanceFrom >= _amount);
575         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
576         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
577         Transfer(_owner, 0, _amount);
578         return true;
579     }
580 
581 ////////////////
582 // Enable tokens transfers
583 ////////////////
584 
585 
586     /// @notice Enables token holders to transfer their tokens freely if true
587     /// @param _transfersEnabled True if transfers are allowed in the clone
588     function enableTransfers(bool _transfersEnabled) public onlyController {
589         transfersEnabled = _transfersEnabled;
590     }
591 
592 ////////////////
593 // Internal helper functions to query and set a value in a snapshot array
594 ////////////////
595 
596     /// @dev `getValueAt` retrieves the number of tokens at a given block number
597     /// @param checkpoints The history of values being queried
598     /// @param _block The block number to retrieve the value at
599     /// @return The number of tokens being queried
600     function getValueAt(Checkpoint[] storage checkpoints, uint _block) 
601         constant internal returns (uint) 
602     {
603         if (checkpoints.length == 0) {
604             return 0;
605         }
606 
607         // Shortcut for the actual value
608         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
609             return checkpoints[checkpoints.length-1].value;
610         }
611             
612         if (_block < checkpoints[0].fromBlock) {
613             return 0;
614         }
615 
616         // Binary search of the value in the array
617         uint min = 0;
618         uint max = checkpoints.length - 1;
619         while (max > min) {
620             uint mid = (max + min + 1) / 2;
621             if (checkpoints[mid].fromBlock<=_block) {
622                 min = mid;
623             } else {
624                 max = mid-1;
625             }
626         }
627         return checkpoints[min].value;
628     }
629 
630     /// @dev `updateValueAtNow` used to update the `balances` map and the
631     ///  `totalSupplyHistory`
632     /// @param checkpoints The history of data being updated
633     /// @param _value The new number of tokens
634     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
635     ) internal  
636     {
637         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length-1].fromBlock < block.number)) {
638                Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
639                newCheckPoint.fromBlock = uint128(block.number);
640                newCheckPoint.value = uint128(_value);
641            } else {
642                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
643                oldCheckPoint.value = uint128(_value);
644            }
645     }
646 
647     /// @dev Internal function to determine if an address is a contract
648     /// @param _addr The address being queried
649     /// @return True if `_addr` is a contract
650     function isContract(address _addr) constant internal returns(bool) {
651         uint size;
652         if (_addr == 0) {
653             return false;
654         }
655         assembly {
656             size := extcodesize(_addr)
657         }
658         return size>0;
659     }
660 
661     /// @dev Helper function to return a min betwen the two uints
662     function min(uint a, uint b) pure internal returns (uint) {
663         return a < b ? a : b;
664     }
665 
666     /// @notice The fallback function: If the contract's controller has not been
667     ///  set to 0, then the `proxyPayment` method is called which relays the
668     ///  ether and creates tokens as described in the token controller contract
669     function () public payable {
670         require(isContract(controller));
671         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
672     }
673 
674 //////////
675 // Safety Methods
676 //////////
677 
678     /// @notice This method can be used by the controller to extract mistakenly
679     ///  sent tokens to this contract.
680     /// @param _token The address of the token contract that you want to recover
681     ///  set to 0 in case you want to extract ether.
682     function claimTokens(address _token) public onlyController {
683         if (_token == 0x0) {
684             controller.transfer(this.balance);
685             return;
686         }
687 
688         MiniMeToken token = MiniMeToken(_token);
689         uint balance = token.balanceOf(this);
690         token.transfer(controller, balance);
691         ClaimedTokens(_token, controller, balance);
692     }
693 
694 ////////////////
695 // Events
696 ////////////////
697     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
698     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
699     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
700     event Approval(
701         address indexed _owner,
702         address indexed _spender,
703         uint256 _amount
704         );
705 
706 }
707 
708 
709 
710 /// @dev The token controller contract must implement these functions
711 contract TokenController {
712   /// @notice Called when `_owner` sends ether to the MiniMe Token contract
713   /// @param _owner The address that sent the ether to create tokens
714   /// @return True if the ether is accepted, false if it throws
715   function proxyPayment(address _owner) public payable returns(bool);
716 
717   /// @notice Notifies the controller about a token transfer allowing the
718   ///  controller to react if desired
719   /// @param _from The origin of the transfer
720   /// @param _to The destination of the transfer
721   /// @param _amount The amount of the transfer
722   /// @return False if the controller does not authorize the transfer
723   function onTransfer(address _from, address _to, uint _amount) public returns(bool);
724 
725   /// @notice Notifies the controller about an approval allowing the
726   ///  controller to react if desired
727   /// @param _owner The address that calls `approve()`
728   /// @param _spender The spender in the `approve()` call
729   /// @param _amount The amount in the `approve()` call
730   /// @return False if the controller does not authorize the approval
731   function onApprove(address _owner, address _spender, uint _amount)
732   public
733   returns(bool);
734 }
735 
736 
737 
738 contract FundRequestTokenGeneration is Pausable, TokenController {
739     using SafeMath for uint256;
740 
741     MiniMeToken public tokenContract;
742 
743     address public tokensaleWallet;
744 
745     address public founderWallet;
746 
747     uint public rate;
748 
749     mapping (address => uint) public deposits;
750 
751     mapping (address => Countries) public allowed;
752 
753     uint public maxCap;         // In wei
754     uint256 public totalCollected;         // In wei
755 
756     // personal caps and activations
757     bool public personalCapActive = true;
758 
759     uint256 public personalCap;
760 
761     //country whitelisting
762     enum Countries {NOT_WHITELISTED, CHINA, KOREA, USA, OTHER}
763     mapping (uint => bool) public allowedCountries;
764 
765     //events
766     event Paid(address indexed _beneficiary, uint256 _weiAmount, uint256 _tokenAmount, bool _personalCapActive);
767 
768     function FundRequestTokenGeneration(
769     address _tokenAddress,
770     address _founderWallet,
771     address _tokensaleWallet,
772     uint _rate,
773     uint _maxCap,
774     uint256 _personalCap) public
775     {
776         tokenContract = MiniMeToken(_tokenAddress);
777         tokensaleWallet = _tokensaleWallet;
778         founderWallet = _founderWallet;
779 
780         rate = _rate;
781         maxCap = _maxCap;
782         personalCap = _personalCap;
783 
784         allowedCountries[uint(Countries.CHINA)] = true;
785         allowedCountries[uint(Countries.KOREA)] = true;
786         allowedCountries[uint(Countries.USA)] = true;
787         allowedCountries[uint(Countries.OTHER)] = true;
788     }
789 
790     function() public payable whenNotPaused {
791         doPayment(msg.sender);
792     }
793 
794     /// @notice `proxyPayment()` allows the caller to send ether to the Campaign and
795     /// have the tokens created in an address of their choosing
796     /// @param _owner The address that will hold the newly created tokens
797 
798     function proxyPayment(address _owner) public payable whenNotPaused returns (bool) {
799         doPayment(_owner);
800         return true;
801     }
802 
803     function doPayment(address beneficiary) whenNotPaused internal {
804         require(validPurchase(beneficiary));
805         require(maxCapNotReached());
806         require(personalCapNotReached(beneficiary));
807         uint256 weiAmount = msg.value;
808         uint256 updatedWeiRaised = totalCollected.add(weiAmount);
809         uint256 tokensInWei = weiAmount.mul(rate);
810         totalCollected = updatedWeiRaised;
811         deposits[beneficiary] = deposits[beneficiary].add(msg.value);
812         distributeTokens(beneficiary, tokensInWei);
813         Paid(beneficiary, weiAmount, tokensInWei, personalCapActive);
814         forwardFunds();
815         return;
816     }
817 
818     function allocateTokens(address beneficiary, uint256 tokensSold) public onlyOwner {
819         distributeTokens(beneficiary, tokensSold);
820     }
821 
822     function finalizeTokenSale() public onlyOwner {
823         pause();
824         tokenContract.changeController(owner);
825     }
826 
827     function distributeTokens(address beneficiary, uint256 tokensSold) internal {
828         uint256 totalTokensInWei = tokensSold.mul(100).div(40);
829         require(tokenContract.generateTokens(beneficiary, tokensSold));
830         require(generateExtraTokens(totalTokensInWei, tokensaleWallet, 60));
831     }
832 
833     function validPurchase(address beneficiary) internal view returns (bool) {
834         require(tokenContract.controller() != 0);
835         require(msg.value >= 0.01 ether);
836 
837         Countries beneficiaryCountry = allowed[beneficiary];
838 
839         /* the country needs to > 0 (whitelisted) */
840         require(uint(beneficiaryCountry) > uint(Countries.NOT_WHITELISTED));
841 
842         /* country needs to be allowed */
843         require(allowedCountries[uint(beneficiaryCountry)] == true);
844         return true;
845     }
846 
847     function generateExtraTokens(uint256 _total, address _owner, uint _pct) internal returns (bool) {
848         uint256 tokensInWei = _total.div(100).mul(_pct);
849         require(tokenContract.generateTokens(_owner, tokensInWei));
850         return true;
851     }
852 
853     function allow(address beneficiary, Countries _country) public onlyOwner {
854         allowed[beneficiary] = _country;
855     }
856 
857     function allowMultiple(address[] _beneficiaries, Countries _country) public onlyOwner {
858         for (uint b = 0; b < _beneficiaries.length; b++) {
859             allow(_beneficiaries[b], _country);
860         }
861     }
862 
863     function allowCountry(Countries _country, bool _allowed) public onlyOwner {
864         require(uint(_country) > 0);
865         allowedCountries[uint(_country)] = _allowed;
866     }
867 
868     function maxCapNotReached() internal view returns (bool) {
869         return totalCollected.add(msg.value) <= maxCap;
870     }
871 
872     function personalCapNotReached(address _beneficiary) internal view returns (bool) {
873         if (personalCapActive) {
874             return deposits[_beneficiary].add(msg.value) <= personalCap;
875         }
876         else {
877             return true;
878         }
879     }
880 
881     function setMaxCap(uint _maxCap) public onlyOwner {
882         maxCap = _maxCap;
883     }
884 
885     /* setters for wallets */
886     function setTokensaleWallet(address _tokensaleWallet) public onlyOwner {
887         tokensaleWallet = _tokensaleWallet;
888     }
889 
890     function setFounderWallet(address _founderWallet) public onlyOwner {
891         founderWallet = _founderWallet;
892     }
893 
894 
895     function setPersonalCap(uint256 _capInWei) public onlyOwner {
896         personalCap = _capInWei;
897     }
898 
899     function setPersonalCapActive(bool _active) public onlyOwner {
900         personalCapActive = _active;
901     }
902 
903     function forwardFunds() internal {
904         founderWallet.transfer(msg.value);
905     }
906 
907     /* fix for accidental token sending */
908     function withdrawToken(address _token, uint256 _amount) public onlyOwner {
909         require(MiniMeToken(_token).transfer(owner, _amount));
910     }
911 
912     //incase something does a suicide and funds end up here, we need to be able to withdraw them
913     function withdraw(address _to) public onlyOwner {
914         _to.transfer(this.balance);
915     }
916 
917     function onTransfer(address _from, address _to, uint _amount) public returns (bool) {
918         return true;
919     }
920 
921     function onApprove(address _owner, address _spender, uint _amount) public returns (bool) {
922         return true;
923     }
924 }