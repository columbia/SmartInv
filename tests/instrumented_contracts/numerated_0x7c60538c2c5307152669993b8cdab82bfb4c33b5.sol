1 // File: contracts/token/Controlled.sol
2 
3 pragma solidity ^0.4.25;
4 
5 contract Controlled {
6     /// @notice The address of the controller is the only address that can call
7     ///  a function with this modifier
8     modifier onlyController { require(msg.sender == controller); _; }
9 
10     address public controller;
11 
12     constructor() public { controller = msg.sender;}
13 
14     /// @notice Changes the controller of the contract
15     /// @param _newController The new controller of the contract
16     function changeController(address _newController) public onlyController {
17         controller = _newController;
18     }
19 }
20 
21 // File: contracts/token/TokenController.sol
22 
23 pragma solidity ^0.4.25;
24 
25 /// @dev The token controller contract must implement these functions
26 contract TokenController {
27     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
28     /// @param _owner The address that sent the ether to create tokens
29     /// @return True if the ether is accepted, false if it throws
30     function proxyPayment(address _owner) public payable returns(bool);
31 
32     /// @notice Notifies the controller about a token transfer allowing the
33     ///  controller to react if desired
34     /// @param _from The origin of the transfer
35     /// @param _to The destination of the transfer
36     /// @param _amount The amount of the transfer
37     /// @return False if the controller does not authorize the transfer
38     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
39 
40     /// @notice Notifies the controller about an approval allowing the
41     ///  controller to react if desired
42     /// @param _owner The address that calls `approve()`
43     /// @param _spender The spender in the `approve()` call
44     /// @param _amount The amount in the `approve()` call
45     /// @return False if the controller does not authorize the approval
46     function onApprove(address _owner, address _spender, uint _amount) public
47         returns(bool);
48 }
49 
50 // File: contracts/token/MiniMeToken.sol
51 
52 pragma solidity ^0.4.25;
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
81 contract ApproveAndCallFallBack {
82     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
83 }
84 
85 /// @dev The actual token contract, the default controller is the msg.sender
86 ///  that deploys the contract, so usually this token will be deployed by a
87 ///  token controller contract, which Giveth will call a "Campaign"
88 contract MiniMeToken is Controlled {
89 
90     string public name;                //The Token's name: e.g. DigixDAO Tokens
91     uint8 public decimals;             //Number of decimals of the smallest unit
92     string public symbol;              //An identifier: e.g. REP
93     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
94 
95 
96     /// @dev `Checkpoint` is the structure that attaches a block number to a
97     ///  given value, the block number attached is the one that last changed the
98     ///  value
99     struct  Checkpoint {
100 
101         // `fromBlock` is the block number that the value was generated from
102         uint128 fromBlock;
103 
104         // `value` is the amount of tokens at a specific block number
105         uint128 value;
106     }
107 
108     // `parentToken` is the Token address that was cloned to produce this token;
109     //  it will be 0x0 for a token that was not cloned
110     MiniMeToken public parentToken;
111 
112     // `parentSnapShotBlock` is the block number from the Parent Token that was
113     //  used to determine the initial distribution of the Clone Token
114     uint public parentSnapShotBlock;
115 
116     // `creationBlock` is the block number that the Clone Token was created
117     uint public creationBlock;
118 
119     // `balances` is the map that tracks the balance of each address, in this
120     //  contract when the balance changes the block number that the change
121     //  occurred is also included in the map
122     mapping (address => Checkpoint[]) balances;
123 
124     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
125     mapping (address => mapping (address => uint256)) allowed;
126 
127     // Tracks the history of the `totalSupply` of the token
128     Checkpoint[] totalSupplyHistory;
129 
130     // Flag that determines if the token is transferable or not.
131     bool public transfersEnabled;
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
153     function MiniMeToken(
154         address _tokenFactory,
155         address _parentToken,
156         uint _parentSnapShotBlock,
157         string _tokenName,
158         uint8 _decimalUnits,
159         string _tokenSymbol,
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
177     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
178     /// @param _to The address of the recipient
179     /// @param _amount The amount of tokens to be transferred
180     /// @return Whether the transfer was successful or not
181     function transfer(address _to, uint256 _amount) public returns (bool success) {
182         require(transfersEnabled);
183         return doTransfer(msg.sender, _to, _amount);
184     }
185 
186     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
187     ///  is approved by `_from`
188     /// @param _from The address holding the tokens being transferred
189     /// @param _to The address of the recipient
190     /// @param _amount The amount of tokens to be transferred
191     /// @return True if the transfer was successful
192     function transferFrom(address _from, address _to, uint256 _amount
193     ) public returns (bool success) {
194 
195         // The controller of this contract can move tokens around at will,
196         //  this is important to recognize! Confirm that you trust the
197         //  controller of this contract, which in most situations should be
198         //  another open source smart contract or 0x0
199         if (msg.sender != controller) {
200             require(transfersEnabled);
201 
202             // The standard ERC 20 transferFrom functionality
203             require (allowed[_from][msg.sender] >= _amount);
204             allowed[_from][msg.sender] -= _amount;
205         }
206         return doTransfer(_from, _to, _amount);
207     }
208 
209     /// @dev This is the actual transfer function in the token contract, it can
210     ///  only be called by other functions in this contract.
211     /// @param _from The address holding the tokens being transferred
212     /// @param _to The address of the recipient
213     /// @param _amount The amount of tokens to be transferred
214     /// @return True if the transfer was successful
215     function doTransfer(address _from, address _to, uint _amount
216     ) internal returns(bool) {
217 
218            if (_amount == 0) {
219                return true;
220            }
221 
222            require(parentSnapShotBlock < block.number);
223 
224            // Do not allow transfer to 0x0 or the token contract itself
225            require((_to != 0) && (_to != address(this)));
226 
227            // If the amount being transfered is more than the balance of the
228            //  account the transfer returns false
229            uint previousBalanceFrom = balanceOfAt(_from, block.number);
230            require(previousBalanceFrom >= _amount);
231            //if (previousBalanceFrom < _amount) {
232            //    return false;
233            //}
234 
235            // Alerts the token controller of the transfer
236            if (isContract(controller)) {
237                require(TokenController(controller).onTransfer(_from, _to, _amount));
238            }
239 
240            // First update the balance array with the new value for the address
241            //  sending the tokens
242            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
243 
244            // Then update the balance array with the new value for the address
245            //  receiving the tokens
246            uint previousBalanceTo = balanceOfAt(_to, block.number);
247            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
248            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
249 
250            // An event to make the transfer easy to find on the blockchain
251            emit Transfer(_from, _to, _amount);
252 
253            return true;
254     }
255 
256     /// @param _owner The address that's balance is being requested
257     /// @return The balance of `_owner` at the current block
258     function balanceOf(address _owner) public constant returns (uint256 balance) {
259         return balanceOfAt(_owner, block.number);
260     }
261 
262     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
263     ///  its behalf. This is a modified version of the ERC20 approve function
264     ///  to be a little bit safer
265     /// @param _spender The address of the account able to transfer the tokens
266     /// @param _amount The amount of tokens to be approved for transfer
267     /// @return True if the approval was successful
268     function approve(address _spender, uint256 _amount) public returns (bool success) {
269         require(transfersEnabled);
270 
271         // To change the approve amount you first have to reduce the addresses`
272         //  allowance to zero by calling `approve(_spender,0)` if it is not
273         //  already 0 to mitigate the race condition described here:
274         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
276 
277         // Alerts the token controller of the approve function call
278         if (isContract(controller)) {
279             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
280         }
281 
282         allowed[msg.sender][_spender] = _amount;
283         emit Approval(msg.sender, _spender, _amount);
284         return true;
285     }
286 
287     /// @dev This function makes it easy to read the `allowed[]` map
288     /// @param _owner The address of the account that owns the token
289     /// @param _spender The address of the account able to transfer the tokens
290     /// @return Amount of remaining tokens of _owner that _spender is allowed
291     ///  to spend
292     function allowance(address _owner, address _spender
293     ) public constant returns (uint256 remaining) {
294         return allowed[_owner][_spender];
295     }
296 
297     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
298     ///  its behalf, and then a function is triggered in the contract that is
299     ///  being approved, `_spender`. This allows users to use their tokens to
300     ///  interact with contracts in one function call instead of two
301     /// @param _spender The address of the contract able to transfer the tokens
302     /// @param _amount The amount of tokens to be approved for transfer
303     /// @return True if the function call was successful
304     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
305     ) public returns (bool success) {
306         require(approve(_spender, _amount));
307 
308         ApproveAndCallFallBack(_spender).receiveApproval(
309             msg.sender,
310             _amount,
311             this,
312             _extraData
313         );
314 
315         return true;
316     }
317 
318     /// @dev This function makes it easy to get the total number of tokens
319     /// @return The total number of tokens
320     function totalSupply() public constant returns (uint) {
321         return totalSupplyAt(block.number);
322     }
323 
324 
325 ////////////////
326 // Query balance and totalSupply in History
327 ////////////////
328 
329     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
330     /// @param _owner The address from which the balance will be retrieved
331     /// @param _blockNumber The block number when the balance is queried
332     /// @return The balance at `_blockNumber`
333     function balanceOfAt(address _owner, uint _blockNumber) public constant
334         returns (uint) {
335 
336         // These next few lines are used when the balance of the token is
337         //  requested before a check point was ever created for this token, it
338         //  requires that the `parentToken.balanceOfAt` be queried at the
339         //  genesis block for that token as this contains initial balance of
340         //  this token
341         if ((balances[_owner].length == 0)
342             || (balances[_owner][0].fromBlock > _blockNumber)) {
343             if (address(parentToken) != 0) {
344                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
345             } else {
346                 // Has no parent
347                 return 0;
348             }
349 
350         // This will return the expected balance during normal situations
351         } else {
352             return getValueAt(balances[_owner], _blockNumber);
353         }
354     }
355 
356     /// @notice Total amount of tokens at a specific `_blockNumber`.
357     /// @param _blockNumber The block number when the totalSupply is queried
358     /// @return The total amount of tokens at `_blockNumber`
359     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
360 
361         // These next few lines are used when the totalSupply of the token is
362         //  requested before a check point was ever created for this token, it
363         //  requires that the `parentToken.totalSupplyAt` be queried at the
364         //  genesis block for this token as that contains totalSupply of this
365         //  token at this block number.
366         if ((totalSupplyHistory.length == 0)
367             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
368             if (address(parentToken) != 0) {
369                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
370             } else {
371                 return 0;
372             }
373 
374         // This will return the expected totalSupply during normal situations
375         } else {
376             return getValueAt(totalSupplyHistory, _blockNumber);
377         }
378     }
379 
380 ////////////////
381 // Clone Token Method
382 ////////////////
383 
384     /// @notice Creates a new clone token with the initial distribution being
385     ///  this token at `_snapshotBlock`
386     /// @param _cloneTokenName Name of the clone token
387     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
388     /// @param _cloneTokenSymbol Symbol of the clone token
389     /// @param _snapshotBlock Block when the distribution of the parent token is
390     ///  copied to set the initial distribution of the new clone token;
391     ///  if the block is zero than the actual block, the current block is used
392     /// @param _transfersEnabled True if transfers are allowed in the clone
393     /// @return The address of the new MiniMeToken Contract
394     function createCloneToken(
395         string _cloneTokenName,
396         uint8 _cloneDecimalUnits,
397         string _cloneTokenSymbol,
398         uint _snapshotBlock,
399         bool _transfersEnabled
400         ) public returns(address) {
401         if (_snapshotBlock == 0) _snapshotBlock = block.number;
402         MiniMeToken cloneToken = tokenFactory.createCloneToken(
403             this,
404             _snapshotBlock,
405             _cloneTokenName,
406             _cloneDecimalUnits,
407             _cloneTokenSymbol,
408             _transfersEnabled
409             );
410 
411         cloneToken.changeController(msg.sender);
412 
413         // An event to make the token easy to find on the blockchain
414         emit NewCloneToken(address(cloneToken), _snapshotBlock);
415         return address(cloneToken);
416     }
417 
418 ////////////////
419 // Generate and destroy tokens
420 ////////////////
421 
422     /// @notice Generates `_amount` tokens that are assigned to `_owner`
423     /// @param _owner The address that will be assigned the new tokens
424     /// @param _amount The quantity of tokens generated
425     /// @return True if the tokens are generated correctly
426     function generateTokens(address _owner, uint _amount
427     ) public onlyController returns (bool) {
428         uint curTotalSupply = totalSupply();
429         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
430         uint previousBalanceTo = balanceOf(_owner);
431         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
432         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
433         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
434         emit Transfer(0, _owner, _amount);
435         return true;
436     }
437 
438     /// @notice Burns `_amount` tokens from `_owner`
439     /// @param _owner The address that will lose the tokens
440     /// @param _amount The quantity of tokens to burn
441     /// @return True if the tokens are burned correctly
442     function destroyTokens(address _owner, uint _amount
443     ) onlyController public returns (bool) {
444         uint curTotalSupply = totalSupply();
445         require(curTotalSupply >= _amount);
446         uint previousBalanceFrom = balanceOf(_owner);
447         require(previousBalanceFrom >= _amount);
448         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
449         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
450         emit Transfer(_owner, 0, _amount);
451         return true;
452     }
453 
454 ////////////////
455 // Enable tokens transfers
456 ////////////////
457 
458 
459     /// @notice Enables token holders to transfer their tokens freely if true
460     /// @param _transfersEnabled True if transfers are allowed in the clone
461     function enableTransfers(bool _transfersEnabled) public onlyController {
462         transfersEnabled = _transfersEnabled;
463     }
464 
465 ////////////////
466 // Internal helper functions to query and set a value in a snapshot array
467 ////////////////
468 
469     /// @dev `getValueAt` retrieves the number of tokens at a given block number
470     /// @param checkpoints The history of values being queried
471     /// @param _block The block number to retrieve the value at
472     /// @return The number of tokens being queried
473     function getValueAt(Checkpoint[] storage checkpoints, uint _block
474     ) constant internal returns (uint) {
475         if (checkpoints.length == 0) return 0;
476 
477         // Shortcut for the actual value
478         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
479             return checkpoints[checkpoints.length-1].value;
480         if (_block < checkpoints[0].fromBlock) return 0;
481 
482         // Binary search of the value in the array
483         uint min = 0;
484         uint max = checkpoints.length-1;
485         while (max > min) {
486             uint mid = (max + min + 1)/ 2;
487             if (checkpoints[mid].fromBlock<=_block) {
488                 min = mid;
489             } else {
490                 max = mid-1;
491             }
492         }
493         return checkpoints[min].value;
494     }
495 
496     /// @dev `updateValueAtNow` used to update the `balances` map and the
497     ///  `totalSupplyHistory`
498     /// @param checkpoints The history of data being updated
499     /// @param _value The new number of tokens
500     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
501     ) internal  {
502         if ((checkpoints.length == 0)
503         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
504                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
505                newCheckPoint.fromBlock =  uint128(block.number);
506                newCheckPoint.value = uint128(_value);
507            } else {
508                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
509                oldCheckPoint.value = uint128(_value);
510            }
511     }
512 
513     /// @dev Internal function to determine if an address is a contract
514     /// @param _addr The address being queried
515     /// @return True if `_addr` is a contract
516     function isContract(address _addr) constant internal returns(bool) {
517         uint size;
518         if (_addr == 0) return false;
519         assembly {
520             size := extcodesize(_addr)
521         }
522         return size>0;
523     }
524 
525     /// @dev Helper function to return a min betwen the two uints
526     function min(uint a, uint b) pure internal returns (uint) {
527         return a < b ? a : b;
528     }
529 
530     /// @notice The fallback function: If the contract's controller has not been
531     ///  set to 0, then the `proxyPayment` method is called which relays the
532     ///  ether and creates tokens as described in the token controller contract
533     function () public payable {
534         require(isContract(controller));
535         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
536     }
537 
538 //////////
539 // Safety Methods
540 //////////
541 
542     /// @notice This method can be used by the controller to extract mistakenly
543     ///  sent tokens to this contract.
544     /// @param _token The address of the token contract that you want to recover
545     ///  set to 0 in case you want to extract ether.
546     function claimTokens(address _token) public onlyController {
547         if (_token == 0x0) {
548             controller.transfer( address(this).balance);
549             return;
550         }
551 
552         MiniMeToken token = MiniMeToken(_token);
553         uint balance = token.balanceOf(this);
554         token.transfer(controller, balance);
555         emit ClaimedTokens(_token, controller, balance);
556     }
557 
558 ////////////////
559 // Events
560 ////////////////
561     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
562     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
563     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
564     event Approval(
565         address indexed _owner,
566         address indexed _spender,
567         uint256 _amount
568         );
569 
570 }
571 
572 
573 ////////////////
574 // MiniMeTokenFactory
575 ////////////////
576 
577 /// @dev This contract is used to generate clone contracts from a contract.
578 ///  In solidity this is the way to create a contract from a contract of the
579 ///  same class
580 contract MiniMeTokenFactory {
581 
582     /// @notice Update the DApp by creating a new token with new functionalities
583     ///  the msg.sender becomes the controller of this clone token
584     /// @param _parentToken Address of the token being cloned
585     /// @param _snapshotBlock Block of the parent token that will
586     ///  determine the initial distribution of the clone token
587     /// @param _tokenName Name of the new token
588     /// @param _decimalUnits Number of decimals of the new token
589     /// @param _tokenSymbol Token Symbol for the new token
590     /// @param _transfersEnabled If true, tokens will be able to be transferred
591     /// @return The address of the new token contract
592     function createCloneToken(
593         address _parentToken,
594         uint _snapshotBlock,
595         string _tokenName,
596         uint8 _decimalUnits,
597         string _tokenSymbol,
598         bool _transfersEnabled
599     ) public returns (MiniMeToken) {
600         MiniMeToken newToken = new MiniMeToken(
601             this,
602             _parentToken,
603             _snapshotBlock,
604             _tokenName,
605             _decimalUnits,
606             _tokenSymbol,
607             _transfersEnabled
608             );
609 
610         newToken.changeController(msg.sender);
611         return newToken;
612     }
613 }
614 
615 // File: contracts/BISK.sol
616 
617 pragma solidity ^0.4.25;
618 
619 
620 contract BISK is MiniMeToken {
621     mapping (address => bool) public blacklisted;
622     bool public generateFinished;
623 
624     constructor (address _tokenFactory)
625         MiniMeToken(
626               _tokenFactory,
627               0x0,               // no parent token
628               0,                 // no snapshot block number from parent
629               "Bisket",		       // Token name
630               18,                // Decimals
631               "BSK",            // Symbol
632               false              // Enable transfers
633           ) public {
634     }
635 
636     function generateTokens(address _holder, uint _amount) public onlyController returns (bool) {
637         require(generateFinished == false);
638         return super.generateTokens(_holder, _amount);
639     }
640 
641     function initTokens(address[] _tos, uint[] _amts, bool _finish, bool _enableTransfer) public onlyController returns (bool) {
642       require(generateFinished == false);
643       require(_tos.length == _amts.length);
644 
645       for(uint i=0; i<_tos.length; i++) {
646         require(_tos[i] != 0x0);
647         require(_amts[i] > 0);
648 
649         super.generateTokens(_tos[i], _amts[i]);
650       }
651 
652       if(_finish == true) {
653         finishGenerating();
654       }
655       if(_enableTransfer == true) {
656         enableTransfers(true);
657       }
658 
659       return true;
660     }
661 
662     function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
663         require(blacklisted[_from] == false);
664         return super.doTransfer(_from, _to, _amount);
665     }
666 
667     function finishGenerating() public onlyController returns (bool) {
668         generateFinished = true;
669         return true;
670     }
671 
672     function blacklistAccount(address tokenOwner) public onlyController returns (bool success) {
673         blacklisted[tokenOwner] = true;
674         return true;
675     }
676 
677     function unBlacklistAccount(address tokenOwner) public onlyController returns (bool success) {
678         blacklisted[tokenOwner] = false;
679         return true;
680     }
681 
682     function destruct(address to) public onlyController returns(bool) {
683         selfdestruct(to);
684         return true;
685     }
686 
687     /// @notice This method can be used by the controller to extract mistakenly
688     ///  sent tokens to this contract.
689     /// @param _token The address of the token contract that you want to recover
690     ///  set to 0 in case you want to extract ether.
691     function claimTokens(address _token) public onlyController {
692         if (_token == 0x0) {
693             controller.transfer( address(this).balance);
694             return;
695         }
696 
697         MiniMeToken token = MiniMeToken(_token);
698         uint balance = token.balanceOf(address(this));
699         token.transfer(controller, balance);
700 
701         emit ClaimedTokens(_token, controller, balance);
702     }
703 
704     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
705 }