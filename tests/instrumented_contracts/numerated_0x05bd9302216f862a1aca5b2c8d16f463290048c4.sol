1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity 0.4.19;
4 
5 contract ERC20Token {
6     /* This is a slight change to the ERC20 base standard.
7     function totalSupply() constant returns (uint256 supply);
8     is replaced with:
9     uint256 public totalSupply;
10     This automatically creates a getter function for the totalSupply.
11     This is moved to the base contract since public getter functions are not
12     currently recognised as an implementation of the matching abstract
13     function by the compiler.
14     */
15     /// total amount of tokens
16     uint256 public totalSupply;
17 
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) public constant returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) public returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
34 
35     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of tokens to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) public returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 
51 
52 
53 
54 /*
55     Copyright 2016, Jordi Baylina
56 
57     This program is free software: you can redistribute it and/or modify
58     it under the terms of the GNU General Public License as published by
59     the Free Software Foundation, either version 3 of the License, or
60     (at your option) any later version.
61 
62     This program is distributed in the hope that it will be useful,
63     but WITHOUT ANY WARRANTY; without even the implied warranty of
64     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
65     GNU General Public License for more details.
66 
67     You should have received a copy of the GNU General Public License
68     along with this program.  If not, see <http://www.gnu.org/licenses/>.
69  */
70 
71 /// @title MiniMeToken Contract
72 /// @author Jordi Baylina
73 /// @dev This token contract's goal is to make it easy for anyone to clone this
74 ///  token using the token distribution at a given block, this will allow DAO's
75 ///  and DApps to upgrade their features in a decentralized manner without
76 ///  affecting the original token
77 /// @dev It is ERC20 compliant, but still needs to under go further testing.
78 
79 
80 
81 contract Controlled {
82     /// @notice The address of the controller is the only address that can call
83     ///  a function with this modifier
84     modifier onlyController { require(msg.sender == controller); _; }
85 
86     address public controller;
87 
88     function Controlled() public { controller = msg.sender;}
89 
90     /// @notice Changes the controller of the contract
91     /// @param _newController The new controller of the contract
92     function changeController(address _newController) public onlyController {
93         controller = _newController;
94     }
95 }
96 
97 
98 /// @dev The token controller contract must implement these functions
99 contract TokenController {
100     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
101     /// @param _owner The address that sent the ether to create tokens
102     /// @return True if the ether is accepted, false if it throws
103     function proxyPayment(address _owner) public payable returns(bool);
104 
105     /// @notice Notifies the controller about a token transfer allowing the
106     ///  controller to react if desired
107     /// @param _from The origin of the transfer
108     /// @param _to The destination of the transfer
109     /// @param _amount The amount of the transfer
110     /// @return False if the controller does not authorize the transfer
111     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
112 
113     /// @notice Notifies the controller about an approval allowing the
114     ///  controller to react if desired
115     /// @param _owner The address that calls `approve()`
116     /// @param _spender The spender in the `approve()` call
117     /// @param _amount The amount in the `approve()` call
118     /// @return False if the controller does not authorize the approval
119     function onApprove(address _owner, address _spender, uint _amount) public
120         returns(bool);
121 }
122 
123 contract ApproveAndCallFallBack {
124     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
125 }
126 
127 /// @dev The actual token contract, the default controller is the msg.sender
128 ///  that deploys the contract, so usually this token will be deployed by a
129 ///  token controller contract, which Giveth will call a "Campaign"
130 contract MiniMeToken is Controlled {
131 
132     string public name;                //The Token's name: e.g. DigixDAO Tokens
133     uint8 public decimals;             //Number of decimals of the smallest unit
134     string public symbol;              //An identifier: e.g. REP
135     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
136 
137 
138     /// @dev `Checkpoint` is the structure that attaches a block number to a
139     ///  given value, the block number attached is the one that last changed the
140     ///  value
141     struct  Checkpoint {
142 
143         // `fromBlock` is the block number that the value was generated from
144         uint128 fromBlock;
145 
146         // `value` is the amount of tokens at a specific block number
147         uint128 value;
148     }
149 
150     // `parentToken` is the Token address that was cloned to produce this token;
151     //  it will be 0x0 for a token that was not cloned
152     MiniMeToken public parentToken;
153 
154     // `parentSnapShotBlock` is the block number from the Parent Token that was
155     //  used to determine the initial distribution of the Clone Token
156     uint public parentSnapShotBlock;
157 
158     // `creationBlock` is the block number that the Clone Token was created
159     uint public creationBlock;
160 
161     // `balances` is the map that tracks the balance of each address, in this
162     //  contract when the balance changes the block number that the change
163     //  occurred is also included in the map
164     mapping (address => Checkpoint[]) balances;
165 
166     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
167     mapping (address => mapping (address => uint256)) allowed;
168 
169     // Tracks the history of the `totalSupply` of the token
170     Checkpoint[] totalSupplyHistory;
171 
172     // Flag that determines if the token is transferable or not.
173     bool public transfersEnabled;
174 
175     // The factory used to create new clone tokens
176     MiniMeTokenFactory public tokenFactory;
177 
178 ////////////////
179 // Constructor
180 ////////////////
181 
182     /// @notice Constructor to create a MiniMeToken
183     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
184     ///  will create the Clone token contracts, the token factory needs to be
185     ///  deployed first
186     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
187     ///  new token
188     /// @param _parentSnapShotBlock Block of the parent token that will
189     ///  determine the initial distribution of the clone token, set to 0 if it
190     ///  is a new token
191     /// @param _tokenName Name of the new token
192     /// @param _decimalUnits Number of decimals of the new token
193     /// @param _tokenSymbol Token Symbol for the new token
194     /// @param _transfersEnabled If true, tokens will be able to be transferred
195     function MiniMeToken(
196         address _tokenFactory,
197         address _parentToken,
198         uint _parentSnapShotBlock,
199         string _tokenName,
200         uint8 _decimalUnits,
201         string _tokenSymbol,
202         bool _transfersEnabled
203     ) public {
204         tokenFactory = MiniMeTokenFactory(_tokenFactory);
205         name = _tokenName;                                 // Set the name
206         decimals = _decimalUnits;                          // Set the decimals
207         symbol = _tokenSymbol;                             // Set the symbol
208         parentToken = MiniMeToken(_parentToken);
209         parentSnapShotBlock = _parentSnapShotBlock;
210         transfersEnabled = _transfersEnabled;
211         creationBlock = block.number;
212     }
213 
214 
215 ///////////////////
216 // ERC20 Methods
217 ///////////////////
218 
219     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
220     /// @param _to The address of the recipient
221     /// @param _amount The amount of tokens to be transferred
222     /// @return Whether the transfer was successful or not
223     function transfer(address _to, uint256 _amount) public returns (bool success) {
224         require(transfersEnabled);
225         doTransfer(msg.sender, _to, _amount);
226         return true;
227     }
228 
229     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
230     ///  is approved by `_from`
231     /// @param _from The address holding the tokens being transferred
232     /// @param _to The address of the recipient
233     /// @param _amount The amount of tokens to be transferred
234     /// @return True if the transfer was successful
235     function transferFrom(address _from, address _to, uint256 _amount
236     ) public returns (bool success) {
237 
238         // The controller of this contract can move tokens around at will,
239         //  this is important to recognize! Confirm that you trust the
240         //  controller of this contract, which in most situations should be
241         //  another open source smart contract or 0x0
242         if (msg.sender != controller) {
243             require(transfersEnabled);
244 
245             // The standard ERC 20 transferFrom functionality
246             require(allowed[_from][msg.sender] >= _amount);
247             allowed[_from][msg.sender] -= _amount;
248         }
249         doTransfer(_from, _to, _amount);
250         return true;
251     }
252 
253     /// @dev This is the actual transfer function in the token contract, it can
254     ///  only be called by other functions in this contract.
255     /// @param _from The address holding the tokens being transferred
256     /// @param _to The address of the recipient
257     /// @param _amount The amount of tokens to be transferred
258     /// @return True if the transfer was successful
259     function doTransfer(address _from, address _to, uint _amount
260     ) internal {
261 
262            if (_amount == 0) {
263                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
264                return;
265            }
266 
267            require(parentSnapShotBlock < block.number);
268 
269            // Do not allow transfer to 0x0 or the token contract itself
270            require((_to != 0) && (_to != address(this)));
271 
272            // If the amount being transfered is more than the balance of the
273            //  account the transfer throws
274            var previousBalanceFrom = balanceOfAt(_from, block.number);
275 
276            require(previousBalanceFrom >= _amount);
277 
278            // Alerts the token controller of the transfer
279            if (isContract(controller)) {
280                require(TokenController(controller).onTransfer(_from, _to, _amount));
281            }
282 
283            // First update the balance array with the new value for the address
284            //  sending the tokens
285            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
286 
287            // Then update the balance array with the new value for the address
288            //  receiving the tokens
289            var previousBalanceTo = balanceOfAt(_to, block.number);
290            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
291            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
292 
293            // An event to make the transfer easy to find on the blockchain
294            Transfer(_from, _to, _amount);
295 
296     }
297 
298     /// @param _owner The address that's balance is being requested
299     /// @return The balance of `_owner` at the current block
300     function balanceOf(address _owner) public constant returns (uint256 balance) {
301         return balanceOfAt(_owner, block.number);
302     }
303 
304     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
305     ///  its behalf. This is a modified version of the ERC20 approve function
306     ///  to be a little bit safer
307     /// @param _spender The address of the account able to transfer the tokens
308     /// @param _amount The amount of tokens to be approved for transfer
309     /// @return True if the approval was successful
310     function approve(address _spender, uint256 _amount) public returns (bool success) {
311         require(transfersEnabled);
312 
313         // To change the approve amount you first have to reduce the addresses`
314         //  allowance to zero by calling `approve(_spender,0)` if it is not
315         //  already 0 to mitigate the race condition described here:
316         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
317         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
318 
319         // Alerts the token controller of the approve function call
320         if (isContract(controller)) {
321             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
322         }
323 
324         allowed[msg.sender][_spender] = _amount;
325         Approval(msg.sender, _spender, _amount);
326         return true;
327     }
328 
329     /// @dev This function makes it easy to read the `allowed[]` map
330     /// @param _owner The address of the account that owns the token
331     /// @param _spender The address of the account able to transfer the tokens
332     /// @return Amount of remaining tokens of _owner that _spender is allowed
333     ///  to spend
334     function allowance(address _owner, address _spender
335     ) public constant returns (uint256 remaining) {
336         return allowed[_owner][_spender];
337     }
338 
339     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
340     ///  its behalf, and then a function is triggered in the contract that is
341     ///  being approved, `_spender`. This allows users to use their tokens to
342     ///  interact with contracts in one function call instead of two
343     /// @param _spender The address of the contract able to transfer the tokens
344     /// @param _amount The amount of tokens to be approved for transfer
345     /// @return True if the function call was successful
346     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
347     ) public returns (bool success) {
348         require(approve(_spender, _amount));
349 
350         ApproveAndCallFallBack(_spender).receiveApproval(
351             msg.sender,
352             _amount,
353             this,
354             _extraData
355         );
356 
357         return true;
358     }
359 
360     /// @dev This function makes it easy to get the total number of tokens
361     /// @return The total number of tokens
362     function totalSupply() public constant returns (uint) {
363         return totalSupplyAt(block.number);
364     }
365 
366 
367 ////////////////
368 // Query balance and totalSupply in History
369 ////////////////
370 
371     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
372     /// @param _owner The address from which the balance will be retrieved
373     /// @param _blockNumber The block number when the balance is queried
374     /// @return The balance at `_blockNumber`
375     function balanceOfAt(address _owner, uint _blockNumber) public constant
376         returns (uint) {
377 
378         // These next few lines are used when the balance of the token is
379         //  requested before a check point was ever created for this token, it
380         //  requires that the `parentToken.balanceOfAt` be queried at the
381         //  genesis block for that token as this contains initial balance of
382         //  this token
383         if ((balances[_owner].length == 0)
384             || (balances[_owner][0].fromBlock > _blockNumber)) {
385             if (address(parentToken) != 0) {
386                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
387             } else {
388                 // Has no parent
389                 return 0;
390             }
391 
392         // This will return the expected balance during normal situations
393         } else {
394             return getValueAt(balances[_owner], _blockNumber);
395         }
396     }
397 
398     /// @notice Total amount of tokens at a specific `_blockNumber`.
399     /// @param _blockNumber The block number when the totalSupply is queried
400     /// @return The total amount of tokens at `_blockNumber`
401     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
402 
403         // These next few lines are used when the totalSupply of the token is
404         //  requested before a check point was ever created for this token, it
405         //  requires that the `parentToken.totalSupplyAt` be queried at the
406         //  genesis block for this token as that contains totalSupply of this
407         //  token at this block number.
408         if ((totalSupplyHistory.length == 0)
409             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
410             if (address(parentToken) != 0) {
411                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
412             } else {
413                 return 0;
414             }
415 
416         // This will return the expected totalSupply during normal situations
417         } else {
418             return getValueAt(totalSupplyHistory, _blockNumber);
419         }
420     }
421 
422 ////////////////
423 // Clone Token Method
424 ////////////////
425 
426     /// @notice Creates a new clone token with the initial distribution being
427     ///  this token at `_snapshotBlock`
428     /// @param _cloneTokenName Name of the clone token
429     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
430     /// @param _cloneTokenSymbol Symbol of the clone token
431     /// @param _snapshotBlock Block when the distribution of the parent token is
432     ///  copied to set the initial distribution of the new clone token;
433     ///  if the block is zero than the actual block, the current block is used
434     /// @param _transfersEnabled True if transfers are allowed in the clone
435     /// @return The address of the new MiniMeToken Contract
436     function createCloneToken(
437         string _cloneTokenName,
438         uint8 _cloneDecimalUnits,
439         string _cloneTokenSymbol,
440         uint _snapshotBlock,
441         bool _transfersEnabled
442         ) public returns(address) {
443         if (_snapshotBlock == 0) _snapshotBlock = block.number;
444         MiniMeToken cloneToken = tokenFactory.createCloneToken(
445             this,
446             _snapshotBlock,
447             _cloneTokenName,
448             _cloneDecimalUnits,
449             _cloneTokenSymbol,
450             _transfersEnabled
451             );
452 
453         cloneToken.changeController(msg.sender);
454 
455         // An event to make the token easy to find on the blockchain
456         NewCloneToken(address(cloneToken), _snapshotBlock);
457         return address(cloneToken);
458     }
459 
460 ////////////////
461 // Generate and destroy tokens
462 ////////////////
463 
464     /// @notice Generates `_amount` tokens that are assigned to `_owner`
465     /// @param _owner The address that will be assigned the new tokens
466     /// @param _amount The quantity of tokens generated
467     /// @return True if the tokens are generated correctly
468     function generateTokens(address _owner, uint _amount
469     ) public onlyController returns (bool) {
470         uint curTotalSupply = totalSupply();
471         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
472         uint previousBalanceTo = balanceOf(_owner);
473         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
474         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
475         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
476         Transfer(0, _owner, _amount);
477         return true;
478     }
479 
480 
481     /// @notice Burns `_amount` tokens from `_owner`
482     /// @param _owner The address that will lose the tokens
483     /// @param _amount The quantity of tokens to burn
484     /// @return True if the tokens are burned correctly
485     function destroyTokens(address _owner, uint _amount
486     ) onlyController public returns (bool) {
487         uint curTotalSupply = totalSupply();
488         require(curTotalSupply >= _amount);
489         uint previousBalanceFrom = balanceOf(_owner);
490         require(previousBalanceFrom >= _amount);
491         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
492         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
493         Transfer(_owner, 0, _amount);
494         return true;
495     }
496 
497 ////////////////
498 // Enable tokens transfers
499 ////////////////
500 
501 
502     /// @notice Enables token holders to transfer their tokens freely if true
503     /// @param _transfersEnabled True if transfers are allowed in the clone
504     function enableTransfers(bool _transfersEnabled) public onlyController {
505         transfersEnabled = _transfersEnabled;
506     }
507 
508 ////////////////
509 // Internal helper functions to query and set a value in a snapshot array
510 ////////////////
511 
512     /// @dev `getValueAt` retrieves the number of tokens at a given block number
513     /// @param checkpoints The history of values being queried
514     /// @param _block The block number to retrieve the value at
515     /// @return The number of tokens being queried
516     function getValueAt(Checkpoint[] storage checkpoints, uint _block
517     ) constant internal returns (uint) {
518         if (checkpoints.length == 0) return 0;
519 
520         // Shortcut for the actual value
521         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
522             return checkpoints[checkpoints.length-1].value;
523         if (_block < checkpoints[0].fromBlock) return 0;
524 
525         // Binary search of the value in the array
526         uint min = 0;
527         uint max = checkpoints.length-1;
528         while (max > min) {
529             uint mid = (max + min + 1)/ 2;
530             if (checkpoints[mid].fromBlock<=_block) {
531                 min = mid;
532             } else {
533                 max = mid-1;
534             }
535         }
536         return checkpoints[min].value;
537     }
538 
539     /// @dev `updateValueAtNow` used to update the `balances` map and the
540     ///  `totalSupplyHistory`
541     /// @param checkpoints The history of data being updated
542     /// @param _value The new number of tokens
543     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
544     ) internal  {
545         if ((checkpoints.length == 0)
546         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
547                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
548                newCheckPoint.fromBlock =  uint128(block.number);
549                newCheckPoint.value = uint128(_value);
550            } else {
551                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
552                oldCheckPoint.value = uint128(_value);
553            }
554     }
555 
556     /// @dev Internal function to determine if an address is a contract
557     /// @param _addr The address being queried
558     /// @return True if `_addr` is a contract
559     function isContract(address _addr) constant internal returns(bool) {
560         uint size;
561         if (_addr == 0) return false;
562         assembly {
563             size := extcodesize(_addr)
564         }
565         return size>0;
566     }
567 
568     /// @dev Helper function to return a min betwen the two uints
569     function min(uint a, uint b) pure internal returns (uint) {
570         return a < b ? a : b;
571     }
572 
573     /// @notice The fallback function: If the contract's controller has not been
574     ///  set to 0, then the `proxyPayment` method is called which relays the
575     ///  ether and creates tokens as described in the token controller contract
576     function () public payable {
577         require(isContract(controller));
578         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
579     }
580 
581 //////////
582 // Safety Methods
583 //////////
584 
585     /// @notice This method can be used by the controller to extract mistakenly
586     ///  sent tokens to this contract.
587     /// @param _token The address of the token contract that you want to recover
588     ///  set to 0 in case you want to extract ether.
589     function claimTokens(address _token) public onlyController {
590         if (_token == 0x0) {
591             controller.transfer(address(this).balance);
592             return;
593         }
594 
595         MiniMeToken token = MiniMeToken(_token);
596         uint balance = token.balanceOf(this);
597         token.transfer(controller, balance);
598         ClaimedTokens(_token, controller, balance);
599     }
600 
601 ////////////////
602 // Events
603 ////////////////
604     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
605     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
606     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
607     event Approval(
608         address indexed _owner,
609         address indexed _spender,
610         uint256 _amount
611         );
612 
613 }
614 
615 
616 ////////////////
617 // MiniMeTokenFactory
618 ////////////////
619 
620 /// @dev This contract is used to generate clone contracts from a contract.
621 ///  In solidity this is the way to create a contract from a contract of the
622 ///  same class
623 contract MiniMeTokenFactory {
624 
625     /// @notice Update the DApp by creating a new token with new functionalities
626     ///  the msg.sender becomes the controller of this clone token
627     /// @param _parentToken Address of the token being cloned
628     /// @param _snapshotBlock Block of the parent token that will
629     ///  determine the initial distribution of the clone token
630     /// @param _tokenName Name of the new token
631     /// @param _decimalUnits Number of decimals of the new token
632     /// @param _tokenSymbol Token Symbol for the new token
633     /// @param _transfersEnabled If true, tokens will be able to be transferred
634     /// @return The address of the new token contract
635     function createCloneToken(
636         address _parentToken,
637         uint _snapshotBlock,
638         string _tokenName,
639         uint8 _decimalUnits,
640         string _tokenSymbol,
641         bool _transfersEnabled
642     ) public returns (MiniMeToken) {
643         MiniMeToken newToken = new MiniMeToken(
644             this,
645             _parentToken,
646             _snapshotBlock,
647             _tokenName,
648             _decimalUnits,
649             _tokenSymbol,
650             _transfersEnabled
651             );
652 
653         newToken.changeController(msg.sender);
654         return newToken;
655     }
656 }
657 
658 
659 
660 
661 
662 
663 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
664 ///  later changed
665 contract Owned {
666 
667     /// @dev `owner` is the only address that can call a function with this
668     /// modifier
669     modifier onlyOwner() {
670         require(msg.sender == owner);
671         _;
672     }
673 
674     address public owner;
675 
676     /// @notice The Constructor assigns the message sender to be `owner`
677     function Owned() public {
678         owner = msg.sender;
679     }
680 
681     address public newOwner;
682 
683     /// @notice `owner` can step down and assign some other address to this role
684     /// @param _newOwner The address of the new owner. 0x0 can be used to create
685     ///  an unowned neutral vault, however that cannot be undone
686     function changeOwner(address _newOwner) public onlyOwner {
687         newOwner = _newOwner;
688     }
689 
690 
691     function acceptOwnership() public {
692         if (msg.sender == newOwner) {
693             owner = newOwner;
694         }
695     }
696 }
697 
698 
699 
700 
701 
702 
703 contract TokenContribution is Owned, TokenController {
704     using SafeMath for uint256;
705 
706     uint256 constant public maxSupply = 1000000000 * 10**8;
707 
708     // Half of the max supply. 50% for ico
709     uint256 constant public saleLimit = 500000000 * 10**8;
710 
711     uint256 constant public maxGasPrice = 50000000000;
712 
713     uint256 constant public maxCallFrequency = 100;
714 
715     MiniMeToken public token;
716 
717     address public destTokensTeam;
718     address public destTokensReserve;
719     address public destTokensBounties;
720     address public destTokensAirdrop;
721     address public destTokensAdvisors;
722     address public destTokensEarlyInvestors;
723 
724     uint256 public totalTokensGenerated;
725 
726     uint256 public finalizedBlock;
727     uint256 public finalizedTime;
728 
729     uint256 public generatedTokensSale;
730 
731     mapping(address => uint256) public lastCallBlock;
732 
733     modifier initialized() {
734         require(address(token) != 0x0);
735         _;
736     }
737 
738     function TokenContribution() public {
739     }
740 
741     /// @notice The owner of this contract can change the controller of the token
742     ///  Please, be sure that the owner is a trusted agent or 0x0 address.
743     /// @param _newController The address of the new controller
744     function changeController(address _newController) public onlyOwner {
745         token.changeController(_newController);
746         ControllerChanged(_newController);
747     }
748 
749 
750     /// @notice This method should be called by the owner before the contribution
751     ///  period starts This initializes most of the parameters
752     function initialize(
753         address _token,
754         address _destTokensReserve,
755         address _destTokensTeam,
756         address _destTokensBounties,
757         address _destTokensAirdrop,
758         address _destTokensAdvisors,
759         address _destTokensEarlyInvestors
760     ) public onlyOwner {
761         // Initialize only once
762         require(address(token) == 0x0);
763 
764         token = MiniMeToken(_token);
765         require(token.totalSupply() == 0);
766         require(token.controller() == address(this));
767         require(token.decimals() == 8);
768 
769         require(_destTokensReserve != 0x0);
770         destTokensReserve = _destTokensReserve;
771 
772         require(_destTokensTeam != 0x0);
773         destTokensTeam = _destTokensTeam;
774 
775         require(_destTokensBounties != 0x0);
776         destTokensBounties = _destTokensBounties;
777 
778         require(_destTokensAirdrop != 0x0);
779         destTokensAirdrop = _destTokensAirdrop;
780 
781         require(_destTokensAdvisors != 0x0);
782         destTokensAdvisors = _destTokensAdvisors;
783 
784         require(_destTokensEarlyInvestors != 0x0);
785         destTokensEarlyInvestors= _destTokensEarlyInvestors;
786     }
787 
788     //////////
789     // MiniMe Controller functions
790     //////////
791 
792     function proxyPayment(address) public payable returns (bool) {
793         return false;
794     }
795 
796     function onTransfer(address _from, address, uint256) public returns (bool) {
797         return transferable(_from);
798     }
799     
800     function onApprove(address _from, address, uint256) public returns (bool) {
801         return transferable(_from);
802     }
803 
804     function transferable(address _from) internal view returns (bool) {
805         // Allow the exchanger to work from the beginning
806         if (finalizedTime == 0) return false;
807 
808         return (getTime() > finalizedTime) || (_from == owner);
809     }
810 
811     function generate(address _th, uint256 _amount) public onlyOwner {
812         require(generatedTokensSale.add(_amount) <= saleLimit);
813         require(_amount > 0);
814 
815         generatedTokensSale = generatedTokensSale.add(_amount);
816         token.generateTokens(_th, _amount);
817 
818         NewSale(_th, _amount);
819     }
820 
821     // NOTE on Percentage format
822     // Right now, Solidity does not support decimal numbers. (This will change very soon)
823     //  So in this contract we use a representation of a percentage that consist in
824     //  expressing the percentage in "x per 10**18"
825     // This format has a precision of 16 digits for a percent.
826     // Examples:
827     //  3%   =   3*(10**16)
828     //  100% = 100*(10**16) = 10**18
829     //
830     // To get a percentage of a value we do it by first multiplying it by the percentage in  (x per 10^18)
831     //  and then divide it by 10**18
832     //
833     //              Y * X(in x per 10**18)
834     //  X% of Y = -------------------------
835     //               100(in x per 10**18)
836     //
837 
838 
839     /// @notice This method will can be called by the owner before the contribution period
840     ///  end or by anybody after the `endBlock`. This method finalizes the contribution period
841     ///  by creating the remaining tokens and transferring the controller to the configured
842     ///  controller.
843     function finalize() public initialized onlyOwner {
844         require(finalizedBlock == 0);
845 
846         finalizedBlock = getBlockNumber();
847         finalizedTime = now;
848 
849         // Percentage to sale
850         // uint256 percentageToCommunity = percent(50);
851 
852         uint256 percentageToTeam = percent(18);
853 
854         uint256 percentageToReserve = percent(8);
855 
856         uint256 percentageToBounties = percent(13);
857 
858         uint256 percentageToAirdrop = percent(2);
859 
860         uint256 percentageToAdvisors = percent(7);
861 
862         uint256 percentageToEarlyInvestors = percent(2);
863 
864         //
865         //                    percentageToBounties
866         //  bountiesTokens = ----------------------- * maxSupply
867         //                      percentage(100)
868         //
869         assert(token.generateTokens(
870                 destTokensBounties,
871                 maxSupply.mul(percentageToBounties).div(percent(100))));
872 
873         //
874         //                    percentageToReserve
875         //  reserveTokens = ----------------------- * maxSupply
876         //                      percentage(100)
877         //
878         assert(token.generateTokens(
879                 destTokensReserve,
880                 maxSupply.mul(percentageToReserve).div(percent(100))));
881 
882         //
883         //                   percentageToTeam
884         //  teamTokens = ----------------------- * maxSupply
885         //                   percentage(100)
886         //
887         assert(token.generateTokens(
888                 destTokensTeam,
889                 maxSupply.mul(percentageToTeam).div(percent(100))));
890 
891         //
892         //                   percentageToAirdrop
893         //  airdropTokens = ----------------------- * maxSupply
894         //                   percentage(100)
895         //
896         assert(token.generateTokens(
897                 destTokensAirdrop,
898                 maxSupply.mul(percentageToAirdrop).div(percent(100))));
899 
900         //
901         //                      percentageToAdvisors
902         //  advisorsTokens = ----------------------- * maxSupply
903         //                      percentage(100)
904         //
905         assert(token.generateTokens(
906                 destTokensAdvisors,
907                 maxSupply.mul(percentageToAdvisors).div(percent(100))));
908 
909         //
910         //                      percentageToEarlyInvestors
911         //  advisorsTokens = ------------------------------ * maxSupply
912         //                          percentage(100)
913         //
914         assert(token.generateTokens(
915                 destTokensEarlyInvestors,
916                 maxSupply.mul(percentageToEarlyInvestors).div(percent(100))));
917 
918         Finalized();
919     }
920 
921     function percent(uint256 p) internal pure returns (uint256) {
922         return p.mul(10 ** 16);
923     }
924 
925     /// @dev Internal function to determine if an address is a contract
926     /// @param _addr The address being queried
927     /// @return True if `_addr` is a contract
928     function isContract(address _addr) internal view returns (bool) {
929         if (_addr == 0) return false;
930         uint256 size;
931         assembly {
932             size := extcodesize(_addr)
933         }
934         return (size > 0);
935     }
936 
937 
938     //////////
939     // Constant functions
940     //////////
941 
942     /// @return Total tokens issued in weis.
943     function tokensIssued() public view returns (uint256) {
944         return token.totalSupply();
945     }
946 
947 
948     //////////
949     // Testing specific methods
950     //////////
951 
952     /// @notice This function is overridden by the test Mocks.
953     function getBlockNumber() internal view returns (uint256) {
954         return block.number;
955     }
956 
957     /// @notice This function is overrided by the test Mocks.
958     function getTime() internal view returns (uint256) {
959         return now;
960     }
961 
962 
963     //////////
964     // Safety Methods
965     //////////
966 
967     /// @notice This method can be used by the controller to extract mistakenly
968     ///  sent tokens to this contract.
969     /// @param _token The address of the token contract that you want to recover
970     ///  set to 0 in case you want to extract ether.
971     function claimTokens(address _token) public onlyOwner {
972         if (token.controller() == address(this)) {
973             token.claimTokens(_token);
974         }
975         if (_token == 0x0) {
976             owner.transfer(address(this).balance);
977             return;
978         }
979 
980         ERC20Token erc20token = ERC20Token(_token);
981         uint256 balance = erc20token.balanceOf(this);
982         erc20token.transfer(owner, balance);
983         ClaimedTokens(_token, owner, balance);
984     }
985 
986     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
987 
988     event ControllerChanged(address indexed _newController);
989 
990     event NewSale(address indexed _th, uint256 _amount);
991 
992     event Finalized();
993 }
994 
995 
996 
997 
998 /**
999  * Math operations with safety checks
1000  */
1001 library SafeMath {
1002   function mul(uint a, uint b) internal pure returns (uint) {
1003     uint c = a * b;
1004     assert(a == 0 || c / a == b);
1005     return c;
1006   }
1007 
1008   function div(uint a, uint b) internal pure returns (uint) {
1009     // assert(b > 0); // Solidity automatically throws when dividing by 0
1010     uint c = a / b;
1011     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1012     return c;
1013   }
1014 
1015   function sub(uint a, uint b) internal pure returns (uint) {
1016     assert(b <= a);
1017     return a - b;
1018   }
1019 
1020   function add(uint a, uint b) internal pure returns (uint) {
1021     uint c = a + b;
1022     assert(c >= a);
1023     return c;
1024   }
1025 
1026   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
1027     return a >= b ? a : b;
1028   }
1029 
1030   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
1031     return a < b ? a : b;
1032   }
1033 
1034   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
1035     return a >= b ? a : b;
1036   }
1037 
1038   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
1039     return a < b ? a : b;
1040   }
1041 
1042   function percent(uint a, uint b) internal pure returns (uint) {
1043     return b * a / 100;
1044   }
1045 }
1046 
1047 
1048 
1049 
1050 contract ReserveTokensHolder is Owned {
1051     using SafeMath for uint256;
1052 
1053     uint256 public collectedTokens;
1054     TokenContribution public crowdsale;
1055     MiniMeToken public miniMeToken;
1056 
1057     function ReserveTokensHolder(address _owner, address _crowdsale, address _miniMeToken) public {
1058         owner = _owner;
1059         crowdsale = TokenContribution(_crowdsale);
1060         miniMeToken = MiniMeToken(_miniMeToken);
1061     }
1062 
1063     /// @notice The owner will call this method to extract the tokens
1064     function collectTokens() public onlyOwner {
1065         uint256 balance = miniMeToken.balanceOf(address(this));
1066         uint256 total = collectedTokens.add(balance);
1067 
1068         uint256 finalizedTime = crowdsale.finalizedTime();
1069 
1070         require(finalizedTime > 0 && getTime() > finalizedTime.add(months(18)));
1071 
1072         uint256 canExtract = 0;
1073         if (getTime() <= finalizedTime.add(months(36))) {
1074             require(collectedTokens < total.percent(50));
1075             canExtract = total.percent(50);
1076         } else {
1077             require(collectedTokens < total);
1078             canExtract = total;
1079         }
1080 
1081         canExtract = canExtract.sub(collectedTokens);
1082 
1083         if (canExtract > balance) {
1084             canExtract = balance;
1085         }
1086 
1087         collectedTokens = collectedTokens.add(canExtract);
1088         miniMeToken.transfer(owner, canExtract);
1089 
1090         TokensWithdrawn(owner, canExtract);
1091     }
1092 
1093     function months(uint256 m) internal pure returns (uint256) {
1094         return m.mul(30 days);
1095     }
1096 
1097     function getTime() internal view returns (uint256) {
1098         return now;
1099     }
1100 
1101 
1102     //////////
1103     // Safety Methods
1104     //////////
1105 
1106     /// @notice This method can be used by the controller to extract mistakenly
1107     ///  sent tokens to this contract.
1108     /// @param _token The address of the token contract that you want to recover
1109     ///  set to 0 in case you want to extract ether.
1110     function claimTokens(address _token) public onlyOwner {
1111         require(_token != address(miniMeToken));
1112         if (_token == 0x0) {
1113             owner.transfer(address(this).balance);
1114             return;
1115         }
1116 
1117         ERC20Token token = ERC20Token(_token);
1118         uint256 balance = token.balanceOf(this);
1119         token.transfer(owner, balance);
1120         ClaimedTokens(_token, owner, balance);
1121     }
1122 
1123     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
1124     event TokensWithdrawn(address indexed _holder, uint256 _amount);
1125 }