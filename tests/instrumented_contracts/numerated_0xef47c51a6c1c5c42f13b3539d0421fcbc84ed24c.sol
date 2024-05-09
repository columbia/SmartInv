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
53 /*
54     Copyright 2016, Jordi Baylina
55 
56     This program is free software: you can redistribute it and/or modify
57     it under the terms of the GNU General Public License as published by
58     the Free Software Foundation, either version 3 of the License, or
59     (at your option) any later version.
60 
61     This program is distributed in the hope that it will be useful,
62     but WITHOUT ANY WARRANTY; without even the implied warranty of
63     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
64     GNU General Public License for more details.
65 
66     You should have received a copy of the GNU General Public License
67     along with this program.  If not, see <http://www.gnu.org/licenses/>.
68  */
69 
70 /// @title MiniMeToken Contract
71 /// @author Jordi Baylina
72 /// @dev This token contract's goal is to make it easy for anyone to clone this
73 ///  token using the token distribution at a given block, this will allow DAO's
74 ///  and DApps to upgrade their features in a decentralized manner without
75 ///  affecting the original token
76 /// @dev It is ERC20 compliant, but still needs to under go further testing.
77 
78 
79 
80 contract Controlled {
81     /// @notice The address of the controller is the only address that can call
82     ///  a function with this modifier
83     modifier onlyController { require(msg.sender == controller); _; }
84 
85     address public controller;
86 
87     function Controlled() public { controller = msg.sender;}
88 
89     /// @notice Changes the controller of the contract
90     /// @param _newController The new controller of the contract
91     function changeController(address _newController) public onlyController {
92         controller = _newController;
93     }
94 }
95 
96 
97 /// @dev The token controller contract must implement these functions
98 contract TokenController {
99     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
100     /// @param _owner The address that sent the ether to create tokens
101     /// @return True if the ether is accepted, false if it throws
102     function proxyPayment(address _owner) public payable returns(bool);
103 
104     /// @notice Notifies the controller about a token transfer allowing the
105     ///  controller to react if desired
106     /// @param _from The origin of the transfer
107     /// @param _to The destination of the transfer
108     /// @param _amount The amount of the transfer
109     /// @return False if the controller does not authorize the transfer
110     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
111 
112     /// @notice Notifies the controller about an approval allowing the
113     ///  controller to react if desired
114     /// @param _owner The address that calls `approve()`
115     /// @param _spender The spender in the `approve()` call
116     /// @param _amount The amount in the `approve()` call
117     /// @return False if the controller does not authorize the approval
118     function onApprove(address _owner, address _spender, uint _amount) public
119         returns(bool);
120 }
121 
122 contract ApproveAndCallFallBack {
123     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
124 }
125 
126 /// @dev The actual token contract, the default controller is the msg.sender
127 ///  that deploys the contract, so usually this token will be deployed by a
128 ///  token controller contract, which Giveth will call a "Campaign"
129 contract MiniMeToken is Controlled {
130 
131     string public name;                //The Token's name: e.g. DigixDAO Tokens
132     uint8 public decimals;             //Number of decimals of the smallest unit
133     string public symbol;              //An identifier: e.g. REP
134     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
135 
136 
137     /// @dev `Checkpoint` is the structure that attaches a block number to a
138     ///  given value, the block number attached is the one that last changed the
139     ///  value
140     struct  Checkpoint {
141 
142         // `fromBlock` is the block number that the value was generated from
143         uint128 fromBlock;
144 
145         // `value` is the amount of tokens at a specific block number
146         uint128 value;
147     }
148 
149     // `parentToken` is the Token address that was cloned to produce this token;
150     //  it will be 0x0 for a token that was not cloned
151     MiniMeToken public parentToken;
152 
153     // `parentSnapShotBlock` is the block number from the Parent Token that was
154     //  used to determine the initial distribution of the Clone Token
155     uint public parentSnapShotBlock;
156 
157     // `creationBlock` is the block number that the Clone Token was created
158     uint public creationBlock;
159 
160     // `balances` is the map that tracks the balance of each address, in this
161     //  contract when the balance changes the block number that the change
162     //  occurred is also included in the map
163     mapping (address => Checkpoint[]) balances;
164 
165     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
166     mapping (address => mapping (address => uint256)) allowed;
167 
168     // Tracks the history of the `totalSupply` of the token
169     Checkpoint[] totalSupplyHistory;
170 
171     // Flag that determines if the token is transferable or not.
172     bool public transfersEnabled;
173 
174     // The factory used to create new clone tokens
175     MiniMeTokenFactory public tokenFactory;
176 
177 ////////////////
178 // Constructor
179 ////////////////
180 
181     /// @notice Constructor to create a MiniMeToken
182     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
183     ///  will create the Clone token contracts, the token factory needs to be
184     ///  deployed first
185     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
186     ///  new token
187     /// @param _parentSnapShotBlock Block of the parent token that will
188     ///  determine the initial distribution of the clone token, set to 0 if it
189     ///  is a new token
190     /// @param _tokenName Name of the new token
191     /// @param _decimalUnits Number of decimals of the new token
192     /// @param _tokenSymbol Token Symbol for the new token
193     /// @param _transfersEnabled If true, tokens will be able to be transferred
194     function MiniMeToken(
195         address _tokenFactory,
196         address _parentToken,
197         uint _parentSnapShotBlock,
198         string _tokenName,
199         uint8 _decimalUnits,
200         string _tokenSymbol,
201         bool _transfersEnabled
202     ) public {
203         tokenFactory = MiniMeTokenFactory(_tokenFactory);
204         name = _tokenName;                                 // Set the name
205         decimals = _decimalUnits;                          // Set the decimals
206         symbol = _tokenSymbol;                             // Set the symbol
207         parentToken = MiniMeToken(_parentToken);
208         parentSnapShotBlock = _parentSnapShotBlock;
209         transfersEnabled = _transfersEnabled;
210         creationBlock = block.number;
211     }
212 
213 
214 ///////////////////
215 // ERC20 Methods
216 ///////////////////
217 
218     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
219     /// @param _to The address of the recipient
220     /// @param _amount The amount of tokens to be transferred
221     /// @return Whether the transfer was successful or not
222     function transfer(address _to, uint256 _amount) public returns (bool success) {
223         require(transfersEnabled);
224         doTransfer(msg.sender, _to, _amount);
225         return true;
226     }
227 
228     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
229     ///  is approved by `_from`
230     /// @param _from The address holding the tokens being transferred
231     /// @param _to The address of the recipient
232     /// @param _amount The amount of tokens to be transferred
233     /// @return True if the transfer was successful
234     function transferFrom(address _from, address _to, uint256 _amount
235     ) public returns (bool success) {
236 
237         // The controller of this contract can move tokens around at will,
238         //  this is important to recognize! Confirm that you trust the
239         //  controller of this contract, which in most situations should be
240         //  another open source smart contract or 0x0
241         if (msg.sender != controller) {
242             require(transfersEnabled);
243 
244             // The standard ERC 20 transferFrom functionality
245             require(allowed[_from][msg.sender] >= _amount);
246             allowed[_from][msg.sender] -= _amount;
247         }
248         doTransfer(_from, _to, _amount);
249         return true;
250     }
251 
252     /// @dev This is the actual transfer function in the token contract, it can
253     ///  only be called by other functions in this contract.
254     /// @param _from The address holding the tokens being transferred
255     /// @param _to The address of the recipient
256     /// @param _amount The amount of tokens to be transferred
257     /// @return True if the transfer was successful
258     function doTransfer(address _from, address _to, uint _amount
259     ) internal {
260 
261            if (_amount == 0) {
262                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
263                return;
264            }
265 
266            require(parentSnapShotBlock < block.number);
267 
268            // Do not allow transfer to 0x0 or the token contract itself
269            require((_to != 0) && (_to != address(this)));
270 
271            // If the amount being transfered is more than the balance of the
272            //  account the transfer throws
273            var previousBalanceFrom = balanceOfAt(_from, block.number);
274 
275            require(previousBalanceFrom >= _amount);
276 
277            // Alerts the token controller of the transfer
278            if (isContract(controller)) {
279                require(TokenController(controller).onTransfer(_from, _to, _amount));
280            }
281 
282            // First update the balance array with the new value for the address
283            //  sending the tokens
284            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
285 
286            // Then update the balance array with the new value for the address
287            //  receiving the tokens
288            var previousBalanceTo = balanceOfAt(_to, block.number);
289            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
290            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
291 
292            // An event to make the transfer easy to find on the blockchain
293            Transfer(_from, _to, _amount);
294 
295     }
296 
297     /// @param _owner The address that's balance is being requested
298     /// @return The balance of `_owner` at the current block
299     function balanceOf(address _owner) public constant returns (uint256 balance) {
300         return balanceOfAt(_owner, block.number);
301     }
302 
303     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
304     ///  its behalf. This is a modified version of the ERC20 approve function
305     ///  to be a little bit safer
306     /// @param _spender The address of the account able to transfer the tokens
307     /// @param _amount The amount of tokens to be approved for transfer
308     /// @return True if the approval was successful
309     function approve(address _spender, uint256 _amount) public returns (bool success) {
310         require(transfersEnabled);
311 
312         // To change the approve amount you first have to reduce the addresses`
313         //  allowance to zero by calling `approve(_spender,0)` if it is not
314         //  already 0 to mitigate the race condition described here:
315         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
316         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
317 
318         // Alerts the token controller of the approve function call
319         if (isContract(controller)) {
320             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
321         }
322 
323         allowed[msg.sender][_spender] = _amount;
324         Approval(msg.sender, _spender, _amount);
325         return true;
326     }
327 
328     /// @dev This function makes it easy to read the `allowed[]` map
329     /// @param _owner The address of the account that owns the token
330     /// @param _spender The address of the account able to transfer the tokens
331     /// @return Amount of remaining tokens of _owner that _spender is allowed
332     ///  to spend
333     function allowance(address _owner, address _spender
334     ) public constant returns (uint256 remaining) {
335         return allowed[_owner][_spender];
336     }
337 
338     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
339     ///  its behalf, and then a function is triggered in the contract that is
340     ///  being approved, `_spender`. This allows users to use their tokens to
341     ///  interact with contracts in one function call instead of two
342     /// @param _spender The address of the contract able to transfer the tokens
343     /// @param _amount The amount of tokens to be approved for transfer
344     /// @return True if the function call was successful
345     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
346     ) public returns (bool success) {
347         require(approve(_spender, _amount));
348 
349         ApproveAndCallFallBack(_spender).receiveApproval(
350             msg.sender,
351             _amount,
352             this,
353             _extraData
354         );
355 
356         return true;
357     }
358 
359     /// @dev This function makes it easy to get the total number of tokens
360     /// @return The total number of tokens
361     function totalSupply() public constant returns (uint) {
362         return totalSupplyAt(block.number);
363     }
364 
365 
366 ////////////////
367 // Query balance and totalSupply in History
368 ////////////////
369 
370     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
371     /// @param _owner The address from which the balance will be retrieved
372     /// @param _blockNumber The block number when the balance is queried
373     /// @return The balance at `_blockNumber`
374     function balanceOfAt(address _owner, uint _blockNumber) public constant
375         returns (uint) {
376 
377         // These next few lines are used when the balance of the token is
378         //  requested before a check point was ever created for this token, it
379         //  requires that the `parentToken.balanceOfAt` be queried at the
380         //  genesis block for that token as this contains initial balance of
381         //  this token
382         if ((balances[_owner].length == 0)
383             || (balances[_owner][0].fromBlock > _blockNumber)) {
384             if (address(parentToken) != 0) {
385                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
386             } else {
387                 // Has no parent
388                 return 0;
389             }
390 
391         // This will return the expected balance during normal situations
392         } else {
393             return getValueAt(balances[_owner], _blockNumber);
394         }
395     }
396 
397     /// @notice Total amount of tokens at a specific `_blockNumber`.
398     /// @param _blockNumber The block number when the totalSupply is queried
399     /// @return The total amount of tokens at `_blockNumber`
400     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
401 
402         // These next few lines are used when the totalSupply of the token is
403         //  requested before a check point was ever created for this token, it
404         //  requires that the `parentToken.totalSupplyAt` be queried at the
405         //  genesis block for this token as that contains totalSupply of this
406         //  token at this block number.
407         if ((totalSupplyHistory.length == 0)
408             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
409             if (address(parentToken) != 0) {
410                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
411             } else {
412                 return 0;
413             }
414 
415         // This will return the expected totalSupply during normal situations
416         } else {
417             return getValueAt(totalSupplyHistory, _blockNumber);
418         }
419     }
420 
421 ////////////////
422 // Clone Token Method
423 ////////////////
424 
425     /// @notice Creates a new clone token with the initial distribution being
426     ///  this token at `_snapshotBlock`
427     /// @param _cloneTokenName Name of the clone token
428     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
429     /// @param _cloneTokenSymbol Symbol of the clone token
430     /// @param _snapshotBlock Block when the distribution of the parent token is
431     ///  copied to set the initial distribution of the new clone token;
432     ///  if the block is zero than the actual block, the current block is used
433     /// @param _transfersEnabled True if transfers are allowed in the clone
434     /// @return The address of the new MiniMeToken Contract
435     function createCloneToken(
436         string _cloneTokenName,
437         uint8 _cloneDecimalUnits,
438         string _cloneTokenSymbol,
439         uint _snapshotBlock,
440         bool _transfersEnabled
441         ) public returns(address) {
442         if (_snapshotBlock == 0) _snapshotBlock = block.number;
443         MiniMeToken cloneToken = tokenFactory.createCloneToken(
444             this,
445             _snapshotBlock,
446             _cloneTokenName,
447             _cloneDecimalUnits,
448             _cloneTokenSymbol,
449             _transfersEnabled
450             );
451 
452         cloneToken.changeController(msg.sender);
453 
454         // An event to make the token easy to find on the blockchain
455         NewCloneToken(address(cloneToken), _snapshotBlock);
456         return address(cloneToken);
457     }
458 
459 ////////////////
460 // Generate and destroy tokens
461 ////////////////
462 
463     /// @notice Generates `_amount` tokens that are assigned to `_owner`
464     /// @param _owner The address that will be assigned the new tokens
465     /// @param _amount The quantity of tokens generated
466     /// @return True if the tokens are generated correctly
467     function generateTokens(address _owner, uint _amount
468     ) public onlyController returns (bool) {
469         uint curTotalSupply = totalSupply();
470         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
471         uint previousBalanceTo = balanceOf(_owner);
472         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
473         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
474         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
475         Transfer(0, _owner, _amount);
476         return true;
477     }
478 
479 
480     /// @notice Burns `_amount` tokens from `_owner`
481     /// @param _owner The address that will lose the tokens
482     /// @param _amount The quantity of tokens to burn
483     /// @return True if the tokens are burned correctly
484     function destroyTokens(address _owner, uint _amount
485     ) onlyController public returns (bool) {
486         uint curTotalSupply = totalSupply();
487         require(curTotalSupply >= _amount);
488         uint previousBalanceFrom = balanceOf(_owner);
489         require(previousBalanceFrom >= _amount);
490         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
491         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
492         Transfer(_owner, 0, _amount);
493         return true;
494     }
495 
496 ////////////////
497 // Enable tokens transfers
498 ////////////////
499 
500 
501     /// @notice Enables token holders to transfer their tokens freely if true
502     /// @param _transfersEnabled True if transfers are allowed in the clone
503     function enableTransfers(bool _transfersEnabled) public onlyController {
504         transfersEnabled = _transfersEnabled;
505     }
506 
507 ////////////////
508 // Internal helper functions to query and set a value in a snapshot array
509 ////////////////
510 
511     /// @dev `getValueAt` retrieves the number of tokens at a given block number
512     /// @param checkpoints The history of values being queried
513     /// @param _block The block number to retrieve the value at
514     /// @return The number of tokens being queried
515     function getValueAt(Checkpoint[] storage checkpoints, uint _block
516     ) constant internal returns (uint) {
517         if (checkpoints.length == 0) return 0;
518 
519         // Shortcut for the actual value
520         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
521             return checkpoints[checkpoints.length-1].value;
522         if (_block < checkpoints[0].fromBlock) return 0;
523 
524         // Binary search of the value in the array
525         uint min = 0;
526         uint max = checkpoints.length-1;
527         while (max > min) {
528             uint mid = (max + min + 1)/ 2;
529             if (checkpoints[mid].fromBlock<=_block) {
530                 min = mid;
531             } else {
532                 max = mid-1;
533             }
534         }
535         return checkpoints[min].value;
536     }
537 
538     /// @dev `updateValueAtNow` used to update the `balances` map and the
539     ///  `totalSupplyHistory`
540     /// @param checkpoints The history of data being updated
541     /// @param _value The new number of tokens
542     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
543     ) internal  {
544         if ((checkpoints.length == 0)
545         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
546                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
547                newCheckPoint.fromBlock =  uint128(block.number);
548                newCheckPoint.value = uint128(_value);
549            } else {
550                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
551                oldCheckPoint.value = uint128(_value);
552            }
553     }
554 
555     /// @dev Internal function to determine if an address is a contract
556     /// @param _addr The address being queried
557     /// @return True if `_addr` is a contract
558     function isContract(address _addr) constant internal returns(bool) {
559         uint size;
560         if (_addr == 0) return false;
561         assembly {
562             size := extcodesize(_addr)
563         }
564         return size>0;
565     }
566 
567     /// @dev Helper function to return a min betwen the two uints
568     function min(uint a, uint b) pure internal returns (uint) {
569         return a < b ? a : b;
570     }
571 
572     /// @notice The fallback function: If the contract's controller has not been
573     ///  set to 0, then the `proxyPayment` method is called which relays the
574     ///  ether and creates tokens as described in the token controller contract
575     function () public payable {
576         require(isContract(controller));
577         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
578     }
579 
580 //////////
581 // Safety Methods
582 //////////
583 
584     /// @notice This method can be used by the controller to extract mistakenly
585     ///  sent tokens to this contract.
586     /// @param _token The address of the token contract that you want to recover
587     ///  set to 0 in case you want to extract ether.
588     function claimTokens(address _token) public onlyController {
589         if (_token == 0x0) {
590             controller.transfer(address(this).balance);
591             return;
592         }
593 
594         MiniMeToken token = MiniMeToken(_token);
595         uint balance = token.balanceOf(this);
596         token.transfer(controller, balance);
597         ClaimedTokens(_token, controller, balance);
598     }
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
635         address _parentToken,
636         uint _snapshotBlock,
637         string _tokenName,
638         uint8 _decimalUnits,
639         string _tokenSymbol,
640         bool _transfersEnabled
641     ) public returns (MiniMeToken) {
642         MiniMeToken newToken = new MiniMeToken(
643             this,
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
655 }
656 
657 
658 
659 
660 
661 
662 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
663 ///  later changed
664 contract Owned {
665 
666     /// @dev `owner` is the only address that can call a function with this
667     /// modifier
668     modifier onlyOwner() {
669         require(msg.sender == owner);
670         _;
671     }
672 
673     address public owner;
674 
675     /// @notice The Constructor assigns the message sender to be `owner`
676     function Owned() public {
677         owner = msg.sender;
678     }
679 
680     address public newOwner;
681 
682     /// @notice `owner` can step down and assign some other address to this role
683     /// @param _newOwner The address of the new owner. 0x0 can be used to create
684     ///  an unowned neutral vault, however that cannot be undone
685     function changeOwner(address _newOwner) public onlyOwner {
686         newOwner = _newOwner;
687     }
688 
689 
690     function acceptOwnership() public {
691         if (msg.sender == newOwner) {
692             owner = newOwner;
693         }
694     }
695 }
696 
697 
698 
699 
700 
701 
702 contract TokenContribution is Owned, TokenController {
703     using SafeMath for uint256;
704 
705     uint256 constant public maxSupply = 10000000 * 10**8;
706 
707     // Half of the max supply. 50% for ico
708     uint256 constant public saleLimit = 5000000 * 10**8;
709 
710     uint256 constant public maxGasPrice = 50000000000;
711 
712     uint256 constant public maxCallFrequency = 100;
713 
714     MiniMeToken public token;
715 
716     address public destTokensTeam;
717     address public destTokensReserve;
718     address public destTokensBounties;
719     address public destTokensAirdrop;
720     address public destTokensAdvisors;
721     address public destTokensEarlyInvestors;
722 
723     uint256 public totalTokensGenerated;
724 
725     uint256 public finalizedBlock;
726     uint256 public finalizedTime;
727 
728     uint256 public generatedTokensSale;
729 
730     mapping(address => uint256) public lastCallBlock;
731 
732     modifier initialized() {
733         require(address(token) != 0x0);
734         _;
735     }
736 
737     function TokenContribution() public {
738     }
739 
740     /// @notice The owner of this contract can change the controller of the token
741     ///  Please, be sure that the owner is a trusted agent or 0x0 address.
742     /// @param _newController The address of the new controller
743     function changeController(address _newController) public onlyOwner {
744         token.changeController(_newController);
745         ControllerChanged(_newController);
746     }
747 
748 
749     /// @notice This method should be called by the owner before the contribution
750     ///  period starts This initializes most of the parameters
751     function initialize(
752         address _token,
753         address _destTokensReserve,
754         address _destTokensTeam,
755         address _destTokensBounties,
756         address _destTokensAirdrop,
757         address _destTokensAdvisors,
758         address _destTokensEarlyInvestors
759     ) public onlyOwner {
760         // Initialize only once
761         require(address(token) == 0x0);
762 
763         token = MiniMeToken(_token);
764         require(token.totalSupply() == 0);
765         require(token.controller() == address(this));
766         require(token.decimals() == 8);
767 
768         require(_destTokensReserve != 0x0);
769         destTokensReserve = _destTokensReserve;
770 
771         require(_destTokensTeam != 0x0);
772         destTokensTeam = _destTokensTeam;
773 
774         require(_destTokensBounties != 0x0);
775         destTokensBounties = _destTokensBounties;
776 
777         require(_destTokensAirdrop != 0x0);
778         destTokensAirdrop = _destTokensAirdrop;
779 
780         require(_destTokensAdvisors != 0x0);
781         destTokensAdvisors = _destTokensAdvisors;
782 
783         require(_destTokensEarlyInvestors != 0x0);
784         destTokensEarlyInvestors= _destTokensEarlyInvestors;
785     }
786 
787     //////////
788     // MiniMe Controller functions
789     //////////
790 
791     function proxyPayment(address) public payable returns (bool) {
792         return false;
793     }
794 
795     function onTransfer(address _from, address, uint256) public returns (bool) {
796         return transferable(_from);
797     }
798     
799     function onApprove(address _from, address, uint256) public returns (bool) {
800         return transferable(_from);
801     }
802 
803     function transferable(address _from) internal view returns (bool) {
804         // Allow the exchanger to work from the beginning
805         if (finalizedTime == 0) return false;
806 
807         return (getTime() > finalizedTime) || (_from == owner);
808     }
809 
810     function generate(address _th, uint256 _amount) public onlyOwner {
811         require(generatedTokensSale.add(_amount) <= saleLimit);
812         require(_amount > 0);
813 
814         generatedTokensSale = generatedTokensSale.add(_amount);
815         token.generateTokens(_th, _amount);
816 
817         NewSale(_th, _amount);
818     }
819 
820     // NOTE on Percentage format
821     // Right now, Solidity does not support decimal numbers. (This will change very soon)
822     //  So in this contract we use a representation of a percentage that consist in
823     //  expressing the percentage in "x per 10**18"
824     // This format has a precision of 16 digits for a percent.
825     // Examples:
826     //  3%   =   3*(10**16)
827     //  100% = 100*(10**16) = 10**18
828     //
829     // To get a percentage of a value we do it by first multiplying it by the percentage in  (x per 10^18)
830     //  and then divide it by 10**18
831     //
832     //              Y * X(in x per 10**18)
833     //  X% of Y = -------------------------
834     //               100(in x per 10**18)
835     //
836 
837 
838     /// @notice This method will can be called by the owner before the contribution period
839     ///  end or by anybody after the `endBlock`. This method finalizes the contribution period
840     ///  by creating the remaining tokens and transferring the controller to the configured
841     ///  controller.
842     function finalize() public initialized onlyOwner {
843         require(finalizedBlock == 0);
844 
845         finalizedBlock = getBlockNumber();
846         finalizedTime = now;
847 
848         // Percentage to sale
849         // uint256 percentageToCommunity = percent(50);
850 
851         uint256 percentageToTeam = percent(18);
852 
853         uint256 percentageToReserve = percent(8);
854 
855         uint256 percentageToBounties = percent(13);
856 
857         uint256 percentageToAirdrop = percent(2);
858 
859         uint256 percentageToAdvisors = percent(7);
860 
861         uint256 percentageToEarlyInvestors = percent(2);
862 
863         //
864         //                    percentageToBounties
865         //  bountiesTokens = ----------------------- * maxSupply
866         //                      percentage(100)
867         //
868         assert(token.generateTokens(
869                 destTokensBounties,
870                 maxSupply.mul(percentageToBounties).div(percent(100))));
871 
872         //
873         //                    percentageToReserve
874         //  reserveTokens = ----------------------- * maxSupply
875         //                      percentage(100)
876         //
877         assert(token.generateTokens(
878                 destTokensReserve,
879                 maxSupply.mul(percentageToReserve).div(percent(100))));
880 
881         //
882         //                   percentageToTeam
883         //  teamTokens = ----------------------- * maxSupply
884         //                   percentage(100)
885         //
886         assert(token.generateTokens(
887                 destTokensTeam,
888                 maxSupply.mul(percentageToTeam).div(percent(100))));
889 
890         //
891         //                   percentageToAirdrop
892         //  airdropTokens = ----------------------- * maxSupply
893         //                   percentage(100)
894         //
895         assert(token.generateTokens(
896                 destTokensAirdrop,
897                 maxSupply.mul(percentageToAirdrop).div(percent(100))));
898 
899         //
900         //                      percentageToAdvisors
901         //  advisorsTokens = ----------------------- * maxSupply
902         //                      percentage(100)
903         //
904         assert(token.generateTokens(
905                 destTokensAdvisors,
906                 maxSupply.mul(percentageToAdvisors).div(percent(100))));
907 
908         //
909         //                      percentageToEarlyInvestors
910         //  advisorsTokens = ------------------------------ * maxSupply
911         //                          percentage(100)
912         //
913         assert(token.generateTokens(
914                 destTokensEarlyInvestors,
915                 maxSupply.mul(percentageToEarlyInvestors).div(percent(100))));
916 
917         Finalized();
918     }
919 
920     function percent(uint256 p) internal pure returns (uint256) {
921         return p.mul(10 ** 16);
922     }
923 
924     /// @dev Internal function to determine if an address is a contract
925     /// @param _addr The address being queried
926     /// @return True if `_addr` is a contract
927     function isContract(address _addr) internal view returns (bool) {
928         if (_addr == 0) return false;
929         uint256 size;
930         assembly {
931             size := extcodesize(_addr)
932         }
933         return (size > 0);
934     }
935 
936 
937     //////////
938     // Constant functions
939     //////////
940 
941     /// @return Total tokens issued in weis.
942     function tokensIssued() public view returns (uint256) {
943         return token.totalSupply();
944     }
945 
946 
947     //////////
948     // Testing specific methods
949     //////////
950 
951     /// @notice This function is overridden by the test Mocks.
952     function getBlockNumber() internal view returns (uint256) {
953         return block.number;
954     }
955 
956     /// @notice This function is overrided by the test Mocks.
957     function getTime() internal view returns (uint256) {
958         return now;
959     }
960 
961 
962     //////////
963     // Safety Methods
964     //////////
965 
966     /// @notice This method can be used by the controller to extract mistakenly
967     ///  sent tokens to this contract.
968     /// @param _token The address of the token contract that you want to recover
969     ///  set to 0 in case you want to extract ether.
970     function claimTokens(address _token) public onlyOwner {
971         if (token.controller() == address(this)) {
972             token.claimTokens(_token);
973         }
974         if (_token == 0x0) {
975             owner.transfer(address(this).balance);
976             return;
977         }
978 
979         ERC20Token erc20token = ERC20Token(_token);
980         uint256 balance = erc20token.balanceOf(this);
981         erc20token.transfer(owner, balance);
982         ClaimedTokens(_token, owner, balance);
983     }
984 
985     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
986 
987     event ControllerChanged(address indexed _newController);
988 
989     event NewSale(address indexed _th, uint256 _amount);
990 
991     event Finalized();
992 }
993 
994 
995 
996 
997 /**
998  * Math operations with safety checks
999  */
1000 library SafeMath {
1001   function mul(uint a, uint b) internal pure returns (uint) {
1002     uint c = a * b;
1003     assert(a == 0 || c / a == b);
1004     return c;
1005   }
1006 
1007   function div(uint a, uint b) internal pure returns (uint) {
1008     // assert(b > 0); // Solidity automatically throws when dividing by 0
1009     uint c = a / b;
1010     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1011     return c;
1012   }
1013 
1014   function sub(uint a, uint b) internal pure returns (uint) {
1015     assert(b <= a);
1016     return a - b;
1017   }
1018 
1019   function add(uint a, uint b) internal pure returns (uint) {
1020     uint c = a + b;
1021     assert(c >= a);
1022     return c;
1023   }
1024 
1025   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
1026     return a >= b ? a : b;
1027   }
1028 
1029   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
1030     return a < b ? a : b;
1031   }
1032 
1033   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
1034     return a >= b ? a : b;
1035   }
1036 
1037   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
1038     return a < b ? a : b;
1039   }
1040 
1041   function percent(uint a, uint b) internal pure returns (uint) {
1042     return b * a / 100;
1043   }
1044 }
1045 
1046 
1047 
1048 
1049 contract BountiesTokensHolder is Owned {
1050     using SafeMath for uint256;
1051 
1052     uint256 public collectedTokens;
1053     TokenContribution public contribution;
1054     MiniMeToken public miniMeToken;
1055 
1056     function BountiesTokensHolder(address _owner, address _contribution, address _miniMeToken) public {
1057         owner = _owner;
1058         contribution = TokenContribution(_contribution);
1059         miniMeToken = MiniMeToken(_miniMeToken);
1060     }
1061 
1062     /// @notice The owner will call this method to extract the tokens
1063     function collectTokens() public onlyOwner {
1064         uint256 finalizedTime = contribution.finalizedTime();
1065 
1066         require(finalizedTime > 0 && getTime() > finalizedTime);
1067 
1068         uint256 balance = miniMeToken.balanceOf(address(this));
1069 
1070         collectedTokens = balance;
1071         miniMeToken.transfer(owner, balance);
1072 
1073         TokensWithdrawn(owner, balance);
1074     }
1075 
1076     function months(uint256 m) internal pure returns (uint256) {
1077         return m.mul(30 days);
1078     }
1079 
1080     function getTime() internal view returns (uint256) {
1081         return now;
1082     }
1083 
1084 
1085     //////////
1086     // Safety Methods
1087     //////////
1088 
1089     /// @notice This method can be used by the controller to extract mistakenly
1090     ///  sent tokens to this contract.
1091     /// @param _token The address of the token contract that you want to recover
1092     ///  set to 0 in case you want to extract ether.
1093     function claimTokens(address _token) public onlyOwner {
1094         require(_token != address(miniMeToken));
1095         if (_token == 0x0) {
1096             owner.transfer(address(this).balance);
1097             return;
1098         }
1099 
1100         ERC20Token token = ERC20Token(_token);
1101         uint256 balance = token.balanceOf(this);
1102         token.transfer(owner, balance);
1103         ClaimedTokens(_token, owner, balance);
1104     }
1105 
1106     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
1107     event TokensWithdrawn(address indexed _holder, uint256 _amount);
1108 }