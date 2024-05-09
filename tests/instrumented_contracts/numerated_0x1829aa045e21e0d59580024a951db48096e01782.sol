1 pragma solidity ^0.4.18;
2 
3 contract Blocked {
4   mapping (address => bool) blocked;
5 
6   event Blocked(address _addr);
7   event Unblocked(address _addr);
8 
9   function blockAddress(address _addr) public {
10     require(!blocked[_addr]);
11     blocked[_addr] = true;
12 
13     Blocked(_addr);
14   }
15 
16   function unblockAddress(address _addr) public {
17     require(blocked[_addr]);
18     blocked[_addr] = false;
19 
20     Unblocked(_addr);
21   }
22 }
23 
24 
25 
26 
27 /*
28     Copyright 2016, Jordi Baylina
29 
30     This program is free software: you can redistribute it and/or modify
31     it under the terms of the GNU General Public License as published by
32     the Free Software Foundation, either version 3 of the License, or
33     (at your option) any later version.
34 
35     This program is distributed in the hope that it will be useful,
36     but WITHOUT ANY WARRANTY; without even the implied warranty of
37     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
38     GNU General Public License for more details.
39 
40     You should have received a copy of the GNU General Public License
41     along with this program.  If not, see <http://www.gnu.org/licenses/>.
42  */
43 
44 /// @title MiniMeToken Contract
45 /// @author Jordi Baylina
46 /// @dev This token contract's goal is to make it easy for anyone to clone this
47 ///  token using the token distribution at a given block, this will allow DAO's
48 ///  and DApps to upgrade their features in a decentralized manner without
49 ///  affecting the original token
50 /// @dev It is ERC20 compliant, but still needs to under go further testing.
51 
52 
53 
54 contract Controlled {
55     /// @notice The address of the controller is the only address that can call
56     ///  a function with this modifier
57     modifier onlyController { require(msg.sender == controller); _; }
58 
59     address public controller;
60 
61     function Controlled() public { controller = msg.sender;}
62 
63     /// @notice Changes the controller of the contract
64     /// @param _newController The new controller of the contract
65     function changeController(address _newController) public onlyController {
66         controller = _newController;
67     }
68 }
69 
70 
71 
72 /// @dev The token controller contract must implement these functions
73 contract TokenController {
74     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
75     /// @param _owner The address that sent the ether to create tokens
76     /// @return True if the ether is accepted, false if it throws
77     function proxyPayment(address _owner) public payable returns(bool);
78 
79     /// @notice Notifies the controller about a token transfer allowing the
80     ///  controller to react if desired
81     /// @param _from The origin of the transfer
82     /// @param _to The destination of the transfer
83     /// @param _amount The amount of the transfer
84     /// @return False if the controller does not authorize the transfer
85     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
86 
87     /// @notice Notifies the controller about an approval allowing the
88     ///  controller to react if desired
89     /// @param _owner The address that calls `approve()`
90     /// @param _spender The spender in the `approve()` call
91     /// @param _amount The amount in the `approve()` call
92     /// @return False if the controller does not authorize the approval
93     function onApprove(address _owner, address _spender, uint _amount) public
94         returns(bool);
95 }
96 
97 
98 contract ApproveAndCallFallBack {
99     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
100 }
101 
102 /// @dev The actual token contract, the default controller is the msg.sender
103 ///  that deploys the contract, so usually this token will be deployed by a
104 ///  token controller contract, which Giveth will call a "Campaign"
105 contract MiniMeToken is Controlled {
106 
107     string public name;                //The Token's name: e.g. DigixDAO Tokens
108     uint8 public decimals;             //Number of decimals of the smallest unit
109     string public symbol;              //An identifier: e.g. REP
110     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
111 
112 
113     /// @dev `Checkpoint` is the structure that attaches a block number to a
114     ///  given value, the block number attached is the one that last changed the
115     ///  value
116     struct  Checkpoint {
117 
118         // `fromBlock` is the block number that the value was generated from
119         uint128 fromBlock;
120 
121         // `value` is the amount of tokens at a specific block number
122         uint128 value;
123     }
124 
125     // `parentToken` is the Token address that was cloned to produce this token;
126     //  it will be 0x0 for a token that was not cloned
127     MiniMeToken public parentToken;
128 
129     // `parentSnapShotBlock` is the block number from the Parent Token that was
130     //  used to determine the initial distribution of the Clone Token
131     uint public parentSnapShotBlock;
132 
133     // `creationBlock` is the block number that the Clone Token was created
134     uint public creationBlock;
135 
136     // `balances` is the map that tracks the balance of each address, in this
137     //  contract when the balance changes the block number that the change
138     //  occurred is also included in the map
139     mapping (address => Checkpoint[]) balances;
140 
141     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
142     mapping (address => mapping (address => uint256)) allowed;
143 
144     // Tracks the history of the `totalSupply` of the token
145     Checkpoint[] totalSupplyHistory;
146 
147     // Flag that determines if the token is transferable or not.
148     bool public transfersEnabled;
149 
150     // The factory used to create new clone tokens
151     MiniMeTokenFactory public tokenFactory;
152 
153 ////////////////
154 // Constructor
155 ////////////////
156 
157     /// @notice Constructor to create a MiniMeToken
158     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
159     ///  will create the Clone token contracts, the token factory needs to be
160     ///  deployed first
161     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
162     ///  new token
163     /// @param _parentSnapShotBlock Block of the parent token that will
164     ///  determine the initial distribution of the clone token, set to 0 if it
165     ///  is a new token
166     /// @param _tokenName Name of the new token
167     /// @param _decimalUnits Number of decimals of the new token
168     /// @param _tokenSymbol Token Symbol for the new token
169     /// @param _transfersEnabled If true, tokens will be able to be transferred
170     function MiniMeToken(
171         address _tokenFactory,
172         address _parentToken,
173         uint _parentSnapShotBlock,
174         string _tokenName,
175         uint8 _decimalUnits,
176         string _tokenSymbol,
177         bool _transfersEnabled
178     ) public {
179         tokenFactory = MiniMeTokenFactory(_tokenFactory);
180         name = _tokenName;                                 // Set the name
181         decimals = _decimalUnits;                          // Set the decimals
182         symbol = _tokenSymbol;                             // Set the symbol
183         parentToken = MiniMeToken(_parentToken);
184         parentSnapShotBlock = _parentSnapShotBlock;
185         transfersEnabled = _transfersEnabled;
186         creationBlock = block.number;
187     }
188 
189 
190 ///////////////////
191 // ERC20 Methods
192 ///////////////////
193 
194     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
195     /// @param _to The address of the recipient
196     /// @param _amount The amount of tokens to be transferred
197     /// @return Whether the transfer was successful or not
198     function transfer(address _to, uint256 _amount) public returns (bool success) {
199         require(transfersEnabled);
200         doTransfer(msg.sender, _to, _amount);
201         return true;
202     }
203 
204     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
205     ///  is approved by `_from`
206     /// @param _from The address holding the tokens being transferred
207     /// @param _to The address of the recipient
208     /// @param _amount The amount of tokens to be transferred
209     /// @return True if the transfer was successful
210     function transferFrom(address _from, address _to, uint256 _amount
211     ) public returns (bool success) {
212 
213         // The controller of this contract can move tokens around at will,
214         //  this is important to recognize! Confirm that you trust the
215         //  controller of this contract, which in most situations should be
216         //  another open source smart contract or 0x0
217         if (msg.sender != controller) {
218             require(transfersEnabled);
219 
220             // The standard ERC 20 transferFrom functionality
221             require(allowed[_from][msg.sender] >= _amount);
222             allowed[_from][msg.sender] -= _amount;
223         }
224         doTransfer(_from, _to, _amount);
225         return true;
226     }
227 
228     /// @dev This is the actual transfer function in the token contract, it can
229     ///  only be called by other functions in this contract.
230     /// @param _from The address holding the tokens being transferred
231     /// @param _to The address of the recipient
232     /// @param _amount The amount of tokens to be transferred
233     /// @return True if the transfer was successful
234     function doTransfer(address _from, address _to, uint _amount
235     ) internal {
236 
237            if (_amount == 0) {
238                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
239                return;
240            }
241 
242            require(parentSnapShotBlock < block.number);
243 
244            // Do not allow transfer to 0x0 or the token contract itself
245            require((_to != 0) && (_to != address(this)));
246 
247            // If the amount being transfered is more than the balance of the
248            //  account the transfer throws
249            var previousBalanceFrom = balanceOfAt(_from, block.number);
250 
251            require(previousBalanceFrom >= _amount);
252 
253            // Alerts the token controller of the transfer
254            if (isContract(controller)) {
255                require(TokenController(controller).onTransfer(_from, _to, _amount));
256            }
257 
258            // First update the balance array with the new value for the address
259            //  sending the tokens
260            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
261 
262            // Then update the balance array with the new value for the address
263            //  receiving the tokens
264            var previousBalanceTo = balanceOfAt(_to, block.number);
265            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
266            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
267 
268            // An event to make the transfer easy to find on the blockchain
269            Transfer(_from, _to, _amount);
270 
271     }
272 
273     /// @param _owner The address that's balance is being requested
274     /// @return The balance of `_owner` at the current block
275     function balanceOf(address _owner) public constant returns (uint256 balance) {
276         return balanceOfAt(_owner, block.number);
277     }
278 
279     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
280     ///  its behalf. This is a modified version of the ERC20 approve function
281     ///  to be a little bit safer
282     /// @param _spender The address of the account able to transfer the tokens
283     /// @param _amount The amount of tokens to be approved for transfer
284     /// @return True if the approval was successful
285     function approve(address _spender, uint256 _amount) public returns (bool success) {
286         require(transfersEnabled);
287 
288         // To change the approve amount you first have to reduce the addresses`
289         //  allowance to zero by calling `approve(_spender,0)` if it is not
290         //  already 0 to mitigate the race condition described here:
291         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
292         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
293 
294         // Alerts the token controller of the approve function call
295         if (isContract(controller)) {
296             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
297         }
298 
299         allowed[msg.sender][_spender] = _amount;
300         Approval(msg.sender, _spender, _amount);
301         return true;
302     }
303 
304     /// @dev This function makes it easy to read the `allowed[]` map
305     /// @param _owner The address of the account that owns the token
306     /// @param _spender The address of the account able to transfer the tokens
307     /// @return Amount of remaining tokens of _owner that _spender is allowed
308     ///  to spend
309     function allowance(address _owner, address _spender
310     ) public constant returns (uint256 remaining) {
311         return allowed[_owner][_spender];
312     }
313 
314     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
315     ///  its behalf, and then a function is triggered in the contract that is
316     ///  being approved, `_spender`. This allows users to use their tokens to
317     ///  interact with contracts in one function call instead of two
318     /// @param _spender The address of the contract able to transfer the tokens
319     /// @param _amount The amount of tokens to be approved for transfer
320     /// @return True if the function call was successful
321     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
322     ) public returns (bool success) {
323         require(approve(_spender, _amount));
324 
325         ApproveAndCallFallBack(_spender).receiveApproval(
326             msg.sender,
327             _amount,
328             this,
329             _extraData
330         );
331 
332         return true;
333     }
334 
335     /// @dev This function makes it easy to get the total number of tokens
336     /// @return The total number of tokens
337     function totalSupply() public constant returns (uint) {
338         return totalSupplyAt(block.number);
339     }
340 
341 
342 ////////////////
343 // Query balance and totalSupply in History
344 ////////////////
345 
346     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
347     /// @param _owner The address from which the balance will be retrieved
348     /// @param _blockNumber The block number when the balance is queried
349     /// @return The balance at `_blockNumber`
350     function balanceOfAt(address _owner, uint _blockNumber) public constant
351         returns (uint) {
352 
353         // These next few lines are used when the balance of the token is
354         //  requested before a check point was ever created for this token, it
355         //  requires that the `parentToken.balanceOfAt` be queried at the
356         //  genesis block for that token as this contains initial balance of
357         //  this token
358         if ((balances[_owner].length == 0)
359             || (balances[_owner][0].fromBlock > _blockNumber)) {
360             if (address(parentToken) != 0) {
361                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
362             } else {
363                 // Has no parent
364                 return 0;
365             }
366 
367         // This will return the expected balance during normal situations
368         } else {
369             return getValueAt(balances[_owner], _blockNumber);
370         }
371     }
372 
373     /// @notice Total amount of tokens at a specific `_blockNumber`.
374     /// @param _blockNumber The block number when the totalSupply is queried
375     /// @return The total amount of tokens at `_blockNumber`
376     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
377 
378         // These next few lines are used when the totalSupply of the token is
379         //  requested before a check point was ever created for this token, it
380         //  requires that the `parentToken.totalSupplyAt` be queried at the
381         //  genesis block for this token as that contains totalSupply of this
382         //  token at this block number.
383         if ((totalSupplyHistory.length == 0)
384             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
385             if (address(parentToken) != 0) {
386                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
387             } else {
388                 return 0;
389             }
390 
391         // This will return the expected totalSupply during normal situations
392         } else {
393             return getValueAt(totalSupplyHistory, _blockNumber);
394         }
395     }
396 
397 ////////////////
398 // Clone Token Method
399 ////////////////
400 
401     /// @notice Creates a new clone token with the initial distribution being
402     ///  this token at `_snapshotBlock`
403     /// @param _cloneTokenName Name of the clone token
404     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
405     /// @param _cloneTokenSymbol Symbol of the clone token
406     /// @param _snapshotBlock Block when the distribution of the parent token is
407     ///  copied to set the initial distribution of the new clone token;
408     ///  if the block is zero than the actual block, the current block is used
409     /// @param _transfersEnabled True if transfers are allowed in the clone
410     /// @return The address of the new MiniMeToken Contract
411     function createCloneToken(
412         string _cloneTokenName,
413         uint8 _cloneDecimalUnits,
414         string _cloneTokenSymbol,
415         uint _snapshotBlock,
416         bool _transfersEnabled
417         ) public returns(address) {
418         if (_snapshotBlock == 0) _snapshotBlock = block.number;
419         MiniMeToken cloneToken = tokenFactory.createCloneToken(
420             this,
421             _snapshotBlock,
422             _cloneTokenName,
423             _cloneDecimalUnits,
424             _cloneTokenSymbol,
425             _transfersEnabled
426             );
427 
428         cloneToken.changeController(msg.sender);
429 
430         // An event to make the token easy to find on the blockchain
431         NewCloneToken(address(cloneToken), _snapshotBlock);
432         return address(cloneToken);
433     }
434 
435 ////////////////
436 // Generate and destroy tokens
437 ////////////////
438 
439     /// @notice Generates `_amount` tokens that are assigned to `_owner`
440     /// @param _owner The address that will be assigned the new tokens
441     /// @param _amount The quantity of tokens generated
442     /// @return True if the tokens are generated correctly
443     function generateTokens(address _owner, uint _amount
444     ) public onlyController returns (bool) {
445         uint curTotalSupply = totalSupply();
446         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
447         uint previousBalanceTo = balanceOf(_owner);
448         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
449         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
450         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
451         Transfer(0, _owner, _amount);
452         return true;
453     }
454 
455 
456     /// @notice Burns `_amount` tokens from `_owner`
457     /// @param _owner The address that will lose the tokens
458     /// @param _amount The quantity of tokens to burn
459     /// @return True if the tokens are burned correctly
460     function destroyTokens(address _owner, uint _amount
461     ) onlyController public returns (bool) {
462         uint curTotalSupply = totalSupply();
463         require(curTotalSupply >= _amount);
464         uint previousBalanceFrom = balanceOf(_owner);
465         require(previousBalanceFrom >= _amount);
466         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
467         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
468         Transfer(_owner, 0, _amount);
469         return true;
470     }
471 
472 ////////////////
473 // Enable tokens transfers
474 ////////////////
475 
476 
477     /// @notice Enables token holders to transfer their tokens freely if true
478     /// @param _transfersEnabled True if transfers are allowed in the clone
479     function enableTransfers(bool _transfersEnabled) public onlyController {
480         transfersEnabled = _transfersEnabled;
481     }
482 
483 ////////////////
484 // Internal helper functions to query and set a value in a snapshot array
485 ////////////////
486 
487     /// @dev `getValueAt` retrieves the number of tokens at a given block number
488     /// @param checkpoints The history of values being queried
489     /// @param _block The block number to retrieve the value at
490     /// @return The number of tokens being queried
491     function getValueAt(Checkpoint[] storage checkpoints, uint _block
492     ) constant internal returns (uint) {
493         if (checkpoints.length == 0) return 0;
494 
495         // Shortcut for the actual value
496         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
497             return checkpoints[checkpoints.length-1].value;
498         if (_block < checkpoints[0].fromBlock) return 0;
499 
500         // Binary search of the value in the array
501         uint min = 0;
502         uint max = checkpoints.length-1;
503         while (max > min) {
504             uint mid = (max + min + 1)/ 2;
505             if (checkpoints[mid].fromBlock<=_block) {
506                 min = mid;
507             } else {
508                 max = mid-1;
509             }
510         }
511         return checkpoints[min].value;
512     }
513 
514     /// @dev `updateValueAtNow` used to update the `balances` map and the
515     ///  `totalSupplyHistory`
516     /// @param checkpoints The history of data being updated
517     /// @param _value The new number of tokens
518     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
519     ) internal  {
520         if ((checkpoints.length == 0)
521         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
522                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
523                newCheckPoint.fromBlock =  uint128(block.number);
524                newCheckPoint.value = uint128(_value);
525            } else {
526                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
527                oldCheckPoint.value = uint128(_value);
528            }
529     }
530 
531     /// @dev Internal function to determine if an address is a contract
532     /// @param _addr The address being queried
533     /// @return True if `_addr` is a contract
534     function isContract(address _addr) constant internal returns(bool) {
535         uint size;
536         if (_addr == 0) return false;
537         assembly {
538             size := extcodesize(_addr)
539         }
540         return size>0;
541     }
542 
543     /// @dev Helper function to return a min betwen the two uints
544     function min(uint a, uint b) pure internal returns (uint) {
545         return a < b ? a : b;
546     }
547 
548     /// @notice The fallback function: If the contract's controller has not been
549     ///  set to 0, then the `proxyPayment` method is called which relays the
550     ///  ether and creates tokens as described in the token controller contract
551     function () public payable {
552         require(isContract(controller));
553         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
554     }
555 
556 //////////
557 // Safety Methods
558 //////////
559 
560     /// @notice This method can be used by the controller to extract mistakenly
561     ///  sent tokens to this contract.
562     /// @param _token The address of the token contract that you want to recover
563     ///  set to 0 in case you want to extract ether.
564     function claimTokens(address _token) public onlyController {
565         if (_token == 0x0) {
566             controller.transfer(this.balance);
567             return;
568         }
569 
570         MiniMeToken token = MiniMeToken(_token);
571         uint balance = token.balanceOf(this);
572         token.transfer(controller, balance);
573         ClaimedTokens(_token, controller, balance);
574     }
575 
576 ////////////////
577 // Events
578 ////////////////
579     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
580     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
581     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
582     event Approval(
583         address indexed _owner,
584         address indexed _spender,
585         uint256 _amount
586         );
587 
588 }
589 
590 
591 ////////////////
592 // MiniMeTokenFactory
593 ////////////////
594 
595 /// @dev This contract is used to generate clone contracts from a contract.
596 ///  In solidity this is the way to create a contract from a contract of the
597 ///  same class
598 contract MiniMeTokenFactory {
599 
600     /// @notice Update the DApp by creating a new token with new functionalities
601     ///  the msg.sender becomes the controller of this clone token
602     /// @param _parentToken Address of the token being cloned
603     /// @param _snapshotBlock Block of the parent token that will
604     ///  determine the initial distribution of the clone token
605     /// @param _tokenName Name of the new token
606     /// @param _decimalUnits Number of decimals of the new token
607     /// @param _tokenSymbol Token Symbol for the new token
608     /// @param _transfersEnabled If true, tokens will be able to be transferred
609     /// @return The address of the new token contract
610     function createCloneToken(
611         address _parentToken,
612         uint _snapshotBlock,
613         string _tokenName,
614         uint8 _decimalUnits,
615         string _tokenSymbol,
616         bool _transfersEnabled
617     ) public returns (MiniMeToken) {
618         MiniMeToken newToken = new MiniMeToken(
619             this,
620             _parentToken,
621             _snapshotBlock,
622             _tokenName,
623             _decimalUnits,
624             _tokenSymbol,
625             _transfersEnabled
626             );
627 
628         newToken.changeController(msg.sender);
629         return newToken;
630     }
631 }
632 
633 
634 
635 /**
636  * @title FXT
637  * @dev FXT is ERC20 token contract, inheriting MiniMeToken
638  */
639 contract FXT is MiniMeToken, Blocked {
640   bool public sudoEnabled = true;
641 
642   modifier onlySudoEnabled() {
643     require(sudoEnabled);
644     _;
645   }
646 
647   modifier onlyNotBlocked(address _addr) {
648     require(!blocked[_addr]);
649     _;
650   }
651 
652   event SudoEnabled(bool _sudoEnabled);
653 
654   function FXT(address _tokenFactory) MiniMeToken(
655     _tokenFactory,
656     0x0,                  // no parent token
657     0,                    // no snapshot block number from parent
658     "FuzeX Token",        // Token name
659     18,                   // Decimals
660     "FXT",                // Symbol
661     false                 // Enable transfers
662   ) public {}
663 
664   /**
665    * @dev transfer FuzeX token to `_to` with amount of `_amount`.
666    * Only not blocked user can transfer.
667    */
668   function transfer(address _to, uint256 _amount) public onlyNotBlocked(msg.sender) returns (bool success) {
669     return super.transfer(_to, _amount);
670   }
671 
672   function transferFrom(address _from, address _to, uint256 _amount) public onlyNotBlocked(_from) returns (bool success) {
673     return super.transferFrom(_from, _to, _amount);
674   }
675 
676   // Below 4 functions is only activated by `sudoEnabled`
677   // TODO: 3 sudo levels
678 
679   function generateTokens(address _owner, uint _amount) public onlyController onlySudoEnabled returns (bool) {
680     return super.generateTokens(_owner, _amount);
681   }
682 
683   function destroyTokens(address _owner, uint _amount) public onlyController onlySudoEnabled returns (bool) {
684     return super.destroyTokens(_owner, _amount);
685   }
686 
687   function blockAddress(address _addr) public onlyController onlySudoEnabled {
688     super.blockAddress(_addr);
689   }
690 
691   function unblockAddress(address _addr) public onlyController onlySudoEnabled {
692     super.unblockAddress(_addr);
693   }
694 
695   function enableSudo(bool _sudoEnabled) public onlyController {
696     sudoEnabled = _sudoEnabled;
697     SudoEnabled(_sudoEnabled);
698   }
699 
700   // byList functions
701 
702   function generateTokensByList(address[] _owners, uint[] _amounts) public onlyController onlySudoEnabled returns (bool) {
703     require(_owners.length == _amounts.length);
704 
705     for(uint i = 0; i < _owners.length; i++) {
706       generateTokens(_owners[i], _amounts[i]);
707     }
708 
709     return true;
710   }
711 }