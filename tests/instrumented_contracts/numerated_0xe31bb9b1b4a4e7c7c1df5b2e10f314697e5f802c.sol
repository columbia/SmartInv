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
51 /// @title TeamTokensHolder Contract
52 /// @dev Unlock 40% after 12 months
53 // Unlock 40% after 12 months
54 // Unlock 20% after 12 months
55 
56 
57 
58 /*
59     Copyright 2016, Jordi Baylina
60 
61     This program is free software: you can redistribute it and/or modify
62     it under the terms of the GNU General Public License as published by
63     the Free Software Foundation, either version 3 of the License, or
64     (at your option) any later version.
65 
66     This program is distributed in the hope that it will be useful,
67     but WITHOUT ANY WARRANTY; without even the implied warranty of
68     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
69     GNU General Public License for more details.
70 
71     You should have received a copy of the GNU General Public License
72     along with this program.  If not, see <http://www.gnu.org/licenses/>.
73  */
74 
75 /// @title MiniMeToken Contract
76 /// @author Jordi Baylina
77 /// @dev This token contract's goal is to make it easy for anyone to clone this
78 ///  token using the token distribution at a given block, this will allow DAO's
79 ///  and DApps to upgrade their features in a decentralized manner without
80 ///  affecting the original token
81 /// @dev It is ERC20 compliant, but still needs to under go further testing.
82 
83 
84 
85 contract Controlled {
86     /// @notice The address of the controller is the only address that can call
87     ///  a function with this modifier
88     modifier onlyController { require(msg.sender == controller); _; }
89 
90     address public controller;
91 
92     function Controlled() public { controller = msg.sender;}
93 
94     /// @notice Changes the controller of the contract
95     /// @param _newController The new controller of the contract
96     function changeController(address _newController) public onlyController {
97         controller = _newController;
98     }
99 }
100 
101 
102 /// @dev The token controller contract must implement these functions
103 contract TokenController {
104     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
105     /// @param _owner The address that sent the ether to create tokens
106     /// @return True if the ether is accepted, false if it throws
107     function proxyPayment(address _owner) public payable returns(bool);
108 
109     /// @notice Notifies the controller about a token transfer allowing the
110     ///  controller to react if desired
111     /// @param _from The origin of the transfer
112     /// @param _to The destination of the transfer
113     /// @param _amount The amount of the transfer
114     /// @return False if the controller does not authorize the transfer
115     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
116 
117     /// @notice Notifies the controller about an approval allowing the
118     ///  controller to react if desired
119     /// @param _owner The address that calls `approve()`
120     /// @param _spender The spender in the `approve()` call
121     /// @param _amount The amount in the `approve()` call
122     /// @return False if the controller does not authorize the approval
123     function onApprove(address _owner, address _spender, uint _amount) public
124         returns(bool);
125 }
126 
127 contract ApproveAndCallFallBack {
128     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
129 }
130 
131 /// @dev The actual token contract, the default controller is the msg.sender
132 ///  that deploys the contract, so usually this token will be deployed by a
133 ///  token controller contract, which Giveth will call a "Campaign"
134 contract MiniMeToken is Controlled {
135 
136     string public name;                //The Token's name: e.g. DigixDAO Tokens
137     uint8 public decimals;             //Number of decimals of the smallest unit
138     string public symbol;              //An identifier: e.g. REP
139     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
140 
141 
142     /// @dev `Checkpoint` is the structure that attaches a block number to a
143     ///  given value, the block number attached is the one that last changed the
144     ///  value
145     struct  Checkpoint {
146 
147         // `fromBlock` is the block number that the value was generated from
148         uint128 fromBlock;
149 
150         // `value` is the amount of tokens at a specific block number
151         uint128 value;
152     }
153 
154     // `parentToken` is the Token address that was cloned to produce this token;
155     //  it will be 0x0 for a token that was not cloned
156     MiniMeToken public parentToken;
157 
158     // `parentSnapShotBlock` is the block number from the Parent Token that was
159     //  used to determine the initial distribution of the Clone Token
160     uint public parentSnapShotBlock;
161 
162     // `creationBlock` is the block number that the Clone Token was created
163     uint public creationBlock;
164 
165     // `balances` is the map that tracks the balance of each address, in this
166     //  contract when the balance changes the block number that the change
167     //  occurred is also included in the map
168     mapping (address => Checkpoint[]) balances;
169 
170     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
171     mapping (address => mapping (address => uint256)) allowed;
172 
173     // Tracks the history of the `totalSupply` of the token
174     Checkpoint[] totalSupplyHistory;
175 
176     // Flag that determines if the token is transferable or not.
177     bool public transfersEnabled;
178 
179     // The factory used to create new clone tokens
180     MiniMeTokenFactory public tokenFactory;
181 
182 ////////////////
183 // Constructor
184 ////////////////
185 
186     /// @notice Constructor to create a MiniMeToken
187     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
188     ///  will create the Clone token contracts, the token factory needs to be
189     ///  deployed first
190     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
191     ///  new token
192     /// @param _parentSnapShotBlock Block of the parent token that will
193     ///  determine the initial distribution of the clone token, set to 0 if it
194     ///  is a new token
195     /// @param _tokenName Name of the new token
196     /// @param _decimalUnits Number of decimals of the new token
197     /// @param _tokenSymbol Token Symbol for the new token
198     /// @param _transfersEnabled If true, tokens will be able to be transferred
199     function MiniMeToken(
200         address _tokenFactory,
201         address _parentToken,
202         uint _parentSnapShotBlock,
203         string _tokenName,
204         uint8 _decimalUnits,
205         string _tokenSymbol,
206         bool _transfersEnabled
207     ) public {
208         tokenFactory = MiniMeTokenFactory(_tokenFactory);
209         name = _tokenName;                                 // Set the name
210         decimals = _decimalUnits;                          // Set the decimals
211         symbol = _tokenSymbol;                             // Set the symbol
212         parentToken = MiniMeToken(_parentToken);
213         parentSnapShotBlock = _parentSnapShotBlock;
214         transfersEnabled = _transfersEnabled;
215         creationBlock = block.number;
216     }
217 
218 
219 ///////////////////
220 // ERC20 Methods
221 ///////////////////
222 
223     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
224     /// @param _to The address of the recipient
225     /// @param _amount The amount of tokens to be transferred
226     /// @return Whether the transfer was successful or not
227     function transfer(address _to, uint256 _amount) public returns (bool success) {
228         require(transfersEnabled);
229         doTransfer(msg.sender, _to, _amount);
230         return true;
231     }
232 
233     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
234     ///  is approved by `_from`
235     /// @param _from The address holding the tokens being transferred
236     /// @param _to The address of the recipient
237     /// @param _amount The amount of tokens to be transferred
238     /// @return True if the transfer was successful
239     function transferFrom(address _from, address _to, uint256 _amount
240     ) public returns (bool success) {
241 
242         // The controller of this contract can move tokens around at will,
243         //  this is important to recognize! Confirm that you trust the
244         //  controller of this contract, which in most situations should be
245         //  another open source smart contract or 0x0
246         if (msg.sender != controller) {
247             require(transfersEnabled);
248 
249             // The standard ERC 20 transferFrom functionality
250             require(allowed[_from][msg.sender] >= _amount);
251             allowed[_from][msg.sender] -= _amount;
252         }
253         doTransfer(_from, _to, _amount);
254         return true;
255     }
256 
257     /// @dev This is the actual transfer function in the token contract, it can
258     ///  only be called by other functions in this contract.
259     /// @param _from The address holding the tokens being transferred
260     /// @param _to The address of the recipient
261     /// @param _amount The amount of tokens to be transferred
262     /// @return True if the transfer was successful
263     function doTransfer(address _from, address _to, uint _amount
264     ) internal {
265 
266            if (_amount == 0) {
267                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
268                return;
269            }
270 
271            require(parentSnapShotBlock < block.number);
272 
273            // Do not allow transfer to 0x0 or the token contract itself
274            require((_to != 0) && (_to != address(this)));
275 
276            // If the amount being transfered is more than the balance of the
277            //  account the transfer throws
278            var previousBalanceFrom = balanceOfAt(_from, block.number);
279 
280            require(previousBalanceFrom >= _amount);
281 
282            // Alerts the token controller of the transfer
283            if (isContract(controller)) {
284                require(TokenController(controller).onTransfer(_from, _to, _amount));
285            }
286 
287            // First update the balance array with the new value for the address
288            //  sending the tokens
289            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
290 
291            // Then update the balance array with the new value for the address
292            //  receiving the tokens
293            var previousBalanceTo = balanceOfAt(_to, block.number);
294            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
295            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
296 
297            // An event to make the transfer easy to find on the blockchain
298            Transfer(_from, _to, _amount);
299 
300     }
301 
302     /// @param _owner The address that's balance is being requested
303     /// @return The balance of `_owner` at the current block
304     function balanceOf(address _owner) public constant returns (uint256 balance) {
305         return balanceOfAt(_owner, block.number);
306     }
307 
308     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
309     ///  its behalf. This is a modified version of the ERC20 approve function
310     ///  to be a little bit safer
311     /// @param _spender The address of the account able to transfer the tokens
312     /// @param _amount The amount of tokens to be approved for transfer
313     /// @return True if the approval was successful
314     function approve(address _spender, uint256 _amount) public returns (bool success) {
315         require(transfersEnabled);
316 
317         // To change the approve amount you first have to reduce the addresses`
318         //  allowance to zero by calling `approve(_spender,0)` if it is not
319         //  already 0 to mitigate the race condition described here:
320         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
321         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
322 
323         // Alerts the token controller of the approve function call
324         if (isContract(controller)) {
325             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
326         }
327 
328         allowed[msg.sender][_spender] = _amount;
329         Approval(msg.sender, _spender, _amount);
330         return true;
331     }
332 
333     /// @dev This function makes it easy to read the `allowed[]` map
334     /// @param _owner The address of the account that owns the token
335     /// @param _spender The address of the account able to transfer the tokens
336     /// @return Amount of remaining tokens of _owner that _spender is allowed
337     ///  to spend
338     function allowance(address _owner, address _spender
339     ) public constant returns (uint256 remaining) {
340         return allowed[_owner][_spender];
341     }
342 
343     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
344     ///  its behalf, and then a function is triggered in the contract that is
345     ///  being approved, `_spender`. This allows users to use their tokens to
346     ///  interact with contracts in one function call instead of two
347     /// @param _spender The address of the contract able to transfer the tokens
348     /// @param _amount The amount of tokens to be approved for transfer
349     /// @return True if the function call was successful
350     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
351     ) public returns (bool success) {
352         require(approve(_spender, _amount));
353 
354         ApproveAndCallFallBack(_spender).receiveApproval(
355             msg.sender,
356             _amount,
357             this,
358             _extraData
359         );
360 
361         return true;
362     }
363 
364     /// @dev This function makes it easy to get the total number of tokens
365     /// @return The total number of tokens
366     function totalSupply() public constant returns (uint) {
367         return totalSupplyAt(block.number);
368     }
369 
370 
371 ////////////////
372 // Query balance and totalSupply in History
373 ////////////////
374 
375     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
376     /// @param _owner The address from which the balance will be retrieved
377     /// @param _blockNumber The block number when the balance is queried
378     /// @return The balance at `_blockNumber`
379     function balanceOfAt(address _owner, uint _blockNumber) public constant
380         returns (uint) {
381 
382         // These next few lines are used when the balance of the token is
383         //  requested before a check point was ever created for this token, it
384         //  requires that the `parentToken.balanceOfAt` be queried at the
385         //  genesis block for that token as this contains initial balance of
386         //  this token
387         if ((balances[_owner].length == 0)
388             || (balances[_owner][0].fromBlock > _blockNumber)) {
389             if (address(parentToken) != 0) {
390                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
391             } else {
392                 // Has no parent
393                 return 0;
394             }
395 
396         // This will return the expected balance during normal situations
397         } else {
398             return getValueAt(balances[_owner], _blockNumber);
399         }
400     }
401 
402     /// @notice Total amount of tokens at a specific `_blockNumber`.
403     /// @param _blockNumber The block number when the totalSupply is queried
404     /// @return The total amount of tokens at `_blockNumber`
405     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
406 
407         // These next few lines are used when the totalSupply of the token is
408         //  requested before a check point was ever created for this token, it
409         //  requires that the `parentToken.totalSupplyAt` be queried at the
410         //  genesis block for this token as that contains totalSupply of this
411         //  token at this block number.
412         if ((totalSupplyHistory.length == 0)
413             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
414             if (address(parentToken) != 0) {
415                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
416             } else {
417                 return 0;
418             }
419 
420         // This will return the expected totalSupply during normal situations
421         } else {
422             return getValueAt(totalSupplyHistory, _blockNumber);
423         }
424     }
425 
426 ////////////////
427 // Clone Token Method
428 ////////////////
429 
430     /// @notice Creates a new clone token with the initial distribution being
431     ///  this token at `_snapshotBlock`
432     /// @param _cloneTokenName Name of the clone token
433     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
434     /// @param _cloneTokenSymbol Symbol of the clone token
435     /// @param _snapshotBlock Block when the distribution of the parent token is
436     ///  copied to set the initial distribution of the new clone token;
437     ///  if the block is zero than the actual block, the current block is used
438     /// @param _transfersEnabled True if transfers are allowed in the clone
439     /// @return The address of the new MiniMeToken Contract
440     function createCloneToken(
441         string _cloneTokenName,
442         uint8 _cloneDecimalUnits,
443         string _cloneTokenSymbol,
444         uint _snapshotBlock,
445         bool _transfersEnabled
446         ) public returns(address) {
447         if (_snapshotBlock == 0) _snapshotBlock = block.number;
448         MiniMeToken cloneToken = tokenFactory.createCloneToken(
449             this,
450             _snapshotBlock,
451             _cloneTokenName,
452             _cloneDecimalUnits,
453             _cloneTokenSymbol,
454             _transfersEnabled
455             );
456 
457         cloneToken.changeController(msg.sender);
458 
459         // An event to make the token easy to find on the blockchain
460         NewCloneToken(address(cloneToken), _snapshotBlock);
461         return address(cloneToken);
462     }
463 
464 ////////////////
465 // Generate and destroy tokens
466 ////////////////
467 
468     /// @notice Generates `_amount` tokens that are assigned to `_owner`
469     /// @param _owner The address that will be assigned the new tokens
470     /// @param _amount The quantity of tokens generated
471     /// @return True if the tokens are generated correctly
472     function generateTokens(address _owner, uint _amount
473     ) public onlyController returns (bool) {
474         uint curTotalSupply = totalSupply();
475         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
476         uint previousBalanceTo = balanceOf(_owner);
477         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
478         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
479         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
480         Transfer(0, _owner, _amount);
481         return true;
482     }
483 
484 
485     /// @notice Burns `_amount` tokens from `_owner`
486     /// @param _owner The address that will lose the tokens
487     /// @param _amount The quantity of tokens to burn
488     /// @return True if the tokens are burned correctly
489     function destroyTokens(address _owner, uint _amount
490     ) onlyController public returns (bool) {
491         uint curTotalSupply = totalSupply();
492         require(curTotalSupply >= _amount);
493         uint previousBalanceFrom = balanceOf(_owner);
494         require(previousBalanceFrom >= _amount);
495         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
496         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
497         Transfer(_owner, 0, _amount);
498         return true;
499     }
500 
501 ////////////////
502 // Enable tokens transfers
503 ////////////////
504 
505 
506     /// @notice Enables token holders to transfer their tokens freely if true
507     /// @param _transfersEnabled True if transfers are allowed in the clone
508     function enableTransfers(bool _transfersEnabled) public onlyController {
509         transfersEnabled = _transfersEnabled;
510     }
511 
512 ////////////////
513 // Internal helper functions to query and set a value in a snapshot array
514 ////////////////
515 
516     /// @dev `getValueAt` retrieves the number of tokens at a given block number
517     /// @param checkpoints The history of values being queried
518     /// @param _block The block number to retrieve the value at
519     /// @return The number of tokens being queried
520     function getValueAt(Checkpoint[] storage checkpoints, uint _block
521     ) constant internal returns (uint) {
522         if (checkpoints.length == 0) return 0;
523 
524         // Shortcut for the actual value
525         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
526             return checkpoints[checkpoints.length-1].value;
527         if (_block < checkpoints[0].fromBlock) return 0;
528 
529         // Binary search of the value in the array
530         uint min = 0;
531         uint max = checkpoints.length-1;
532         while (max > min) {
533             uint mid = (max + min + 1)/ 2;
534             if (checkpoints[mid].fromBlock<=_block) {
535                 min = mid;
536             } else {
537                 max = mid-1;
538             }
539         }
540         return checkpoints[min].value;
541     }
542 
543     /// @dev `updateValueAtNow` used to update the `balances` map and the
544     ///  `totalSupplyHistory`
545     /// @param checkpoints The history of data being updated
546     /// @param _value The new number of tokens
547     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
548     ) internal  {
549         if ((checkpoints.length == 0)
550         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
551                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
552                newCheckPoint.fromBlock =  uint128(block.number);
553                newCheckPoint.value = uint128(_value);
554            } else {
555                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
556                oldCheckPoint.value = uint128(_value);
557            }
558     }
559 
560     /// @dev Internal function to determine if an address is a contract
561     /// @param _addr The address being queried
562     /// @return True if `_addr` is a contract
563     function isContract(address _addr) constant internal returns(bool) {
564         uint size;
565         if (_addr == 0) return false;
566         assembly {
567             size := extcodesize(_addr)
568         }
569         return size>0;
570     }
571 
572     /// @dev Helper function to return a min betwen the two uints
573     function min(uint a, uint b) pure internal returns (uint) {
574         return a < b ? a : b;
575     }
576 
577     /// @notice The fallback function: If the contract's controller has not been
578     ///  set to 0, then the `proxyPayment` method is called which relays the
579     ///  ether and creates tokens as described in the token controller contract
580     function () public payable {
581         require(isContract(controller));
582         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
583     }
584 
585 //////////
586 // Safety Methods
587 //////////
588 
589     /// @notice This method can be used by the controller to extract mistakenly
590     ///  sent tokens to this contract.
591     /// @param _token The address of the token contract that you want to recover
592     ///  set to 0 in case you want to extract ether.
593     function claimTokens(address _token) public onlyController {
594         if (_token == 0x0) {
595             controller.transfer(address(this).balance);
596             return;
597         }
598 
599         MiniMeToken token = MiniMeToken(_token);
600         uint balance = token.balanceOf(this);
601         token.transfer(controller, balance);
602         ClaimedTokens(_token, controller, balance);
603     }
604 
605 ////////////////
606 // Events
607 ////////////////
608     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
609     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
610     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
611     event Approval(
612         address indexed _owner,
613         address indexed _spender,
614         uint256 _amount
615         );
616 
617 }
618 
619 
620 ////////////////
621 // MiniMeTokenFactory
622 ////////////////
623 
624 /// @dev This contract is used to generate clone contracts from a contract.
625 ///  In solidity this is the way to create a contract from a contract of the
626 ///  same class
627 contract MiniMeTokenFactory {
628 
629     /// @notice Update the DApp by creating a new token with new functionalities
630     ///  the msg.sender becomes the controller of this clone token
631     /// @param _parentToken Address of the token being cloned
632     /// @param _snapshotBlock Block of the parent token that will
633     ///  determine the initial distribution of the clone token
634     /// @param _tokenName Name of the new token
635     /// @param _decimalUnits Number of decimals of the new token
636     /// @param _tokenSymbol Token Symbol for the new token
637     /// @param _transfersEnabled If true, tokens will be able to be transferred
638     /// @return The address of the new token contract
639     function createCloneToken(
640         address _parentToken,
641         uint _snapshotBlock,
642         string _tokenName,
643         uint8 _decimalUnits,
644         string _tokenSymbol,
645         bool _transfersEnabled
646     ) public returns (MiniMeToken) {
647         MiniMeToken newToken = new MiniMeToken(
648             this,
649             _parentToken,
650             _snapshotBlock,
651             _tokenName,
652             _decimalUnits,
653             _tokenSymbol,
654             _transfersEnabled
655             );
656 
657         newToken.changeController(msg.sender);
658         return newToken;
659     }
660 }
661 
662 
663 
664 
665 
666 
667 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
668 ///  later changed
669 contract Owned {
670 
671     /// @dev `owner` is the only address that can call a function with this
672     /// modifier
673     modifier onlyOwner() {
674         require(msg.sender == owner);
675         _;
676     }
677 
678     address public owner;
679 
680     /// @notice The Constructor assigns the message sender to be `owner`
681     function Owned() public {
682         owner = msg.sender;
683     }
684 
685     address public newOwner;
686 
687     /// @notice `owner` can step down and assign some other address to this role
688     /// @param _newOwner The address of the new owner. 0x0 can be used to create
689     ///  an unowned neutral vault, however that cannot be undone
690     function changeOwner(address _newOwner) public onlyOwner {
691         newOwner = _newOwner;
692     }
693 
694 
695     function acceptOwnership() public {
696         if (msg.sender == newOwner) {
697             owner = newOwner;
698         }
699     }
700 }
701 
702 
703 
704 
705 
706 
707 contract TokenContribution is Owned, TokenController {
708     using SafeMath for uint256;
709 
710     uint256 constant public maxSupply = 1000000000 * 10**8;
711 
712     // Half of the max supply. 50% for ico
713     uint256 constant public saleLimit = 500000000 * 10**8;
714 
715     uint256 constant public maxGasPrice = 50000000000;
716 
717     uint256 constant public maxCallFrequency = 100;
718 
719     MiniMeToken public token;
720 
721     address public destTokensTeam;
722     address public destTokensReserve;
723     address public destTokensBounties;
724     address public destTokensAirdrop;
725     address public destTokensAdvisors;
726     address public destTokensEarlyInvestors;
727 
728     uint256 public totalTokensGenerated;
729 
730     uint256 public finalizedBlock;
731     uint256 public finalizedTime;
732 
733     uint256 public generatedTokensSale;
734 
735     mapping(address => uint256) public lastCallBlock;
736 
737     modifier initialized() {
738         require(address(token) != 0x0);
739         _;
740     }
741 
742     function TokenContribution() public {
743     }
744 
745     /// @notice The owner of this contract can change the controller of the token
746     ///  Please, be sure that the owner is a trusted agent or 0x0 address.
747     /// @param _newController The address of the new controller
748     function changeController(address _newController) public onlyOwner {
749         token.changeController(_newController);
750         ControllerChanged(_newController);
751     }
752 
753 
754     /// @notice This method should be called by the owner before the contribution
755     ///  period starts This initializes most of the parameters
756     function initialize(
757         address _token,
758         address _destTokensReserve,
759         address _destTokensTeam,
760         address _destTokensBounties,
761         address _destTokensAirdrop,
762         address _destTokensAdvisors,
763         address _destTokensEarlyInvestors
764     ) public onlyOwner {
765         // Initialize only once
766         require(address(token) == 0x0);
767 
768         token = MiniMeToken(_token);
769         require(token.totalSupply() == 0);
770         require(token.controller() == address(this));
771         require(token.decimals() == 8);
772 
773         require(_destTokensReserve != 0x0);
774         destTokensReserve = _destTokensReserve;
775 
776         require(_destTokensTeam != 0x0);
777         destTokensTeam = _destTokensTeam;
778 
779         require(_destTokensBounties != 0x0);
780         destTokensBounties = _destTokensBounties;
781 
782         require(_destTokensAirdrop != 0x0);
783         destTokensAirdrop = _destTokensAirdrop;
784 
785         require(_destTokensAdvisors != 0x0);
786         destTokensAdvisors = _destTokensAdvisors;
787 
788         require(_destTokensEarlyInvestors != 0x0);
789         destTokensEarlyInvestors= _destTokensEarlyInvestors;
790     }
791 
792     //////////
793     // MiniMe Controller functions
794     //////////
795 
796     function proxyPayment(address) public payable returns (bool) {
797         return false;
798     }
799 
800     function onTransfer(address _from, address, uint256) public returns (bool) {
801         return transferable(_from);
802     }
803     
804     function onApprove(address _from, address, uint256) public returns (bool) {
805         return transferable(_from);
806     }
807 
808     function transferable(address _from) internal view returns (bool) {
809         // Allow the exchanger to work from the beginning
810         if (finalizedTime == 0) return false;
811 
812         return (getTime() > finalizedTime) || (_from == owner);
813     }
814 
815     function generate(address _th, uint256 _amount) public onlyOwner {
816         require(generatedTokensSale.add(_amount) <= saleLimit);
817         require(_amount > 0);
818 
819         generatedTokensSale = generatedTokensSale.add(_amount);
820         token.generateTokens(_th, _amount);
821 
822         NewSale(_th, _amount);
823     }
824 
825     // NOTE on Percentage format
826     // Right now, Solidity does not support decimal numbers. (This will change very soon)
827     //  So in this contract we use a representation of a percentage that consist in
828     //  expressing the percentage in "x per 10**18"
829     // This format has a precision of 16 digits for a percent.
830     // Examples:
831     //  3%   =   3*(10**16)
832     //  100% = 100*(10**16) = 10**18
833     //
834     // To get a percentage of a value we do it by first multiplying it by the percentage in  (x per 10^18)
835     //  and then divide it by 10**18
836     //
837     //              Y * X(in x per 10**18)
838     //  X% of Y = -------------------------
839     //               100(in x per 10**18)
840     //
841 
842 
843     /// @notice This method will can be called by the owner before the contribution period
844     ///  end or by anybody after the `endBlock`. This method finalizes the contribution period
845     ///  by creating the remaining tokens and transferring the controller to the configured
846     ///  controller.
847     function finalize() public initialized onlyOwner {
848         require(finalizedBlock == 0);
849 
850         finalizedBlock = getBlockNumber();
851         finalizedTime = now;
852 
853         // Percentage to sale
854         // uint256 percentageToCommunity = percent(50);
855 
856         uint256 percentageToTeam = percent(18);
857 
858         uint256 percentageToReserve = percent(8);
859 
860         uint256 percentageToBounties = percent(13);
861 
862         uint256 percentageToAirdrop = percent(2);
863 
864         uint256 percentageToAdvisors = percent(7);
865 
866         uint256 percentageToEarlyInvestors = percent(2);
867 
868         //
869         //                    percentageToBounties
870         //  bountiesTokens = ----------------------- * maxSupply
871         //                      percentage(100)
872         //
873         assert(token.generateTokens(
874                 destTokensBounties,
875                 maxSupply.mul(percentageToBounties).div(percent(100))));
876 
877         //
878         //                    percentageToReserve
879         //  reserveTokens = ----------------------- * maxSupply
880         //                      percentage(100)
881         //
882         assert(token.generateTokens(
883                 destTokensReserve,
884                 maxSupply.mul(percentageToReserve).div(percent(100))));
885 
886         //
887         //                   percentageToTeam
888         //  teamTokens = ----------------------- * maxSupply
889         //                   percentage(100)
890         //
891         assert(token.generateTokens(
892                 destTokensTeam,
893                 maxSupply.mul(percentageToTeam).div(percent(100))));
894 
895         //
896         //                   percentageToAirdrop
897         //  airdropTokens = ----------------------- * maxSupply
898         //                   percentage(100)
899         //
900         assert(token.generateTokens(
901                 destTokensAirdrop,
902                 maxSupply.mul(percentageToAirdrop).div(percent(100))));
903 
904         //
905         //                      percentageToAdvisors
906         //  advisorsTokens = ----------------------- * maxSupply
907         //                      percentage(100)
908         //
909         assert(token.generateTokens(
910                 destTokensAdvisors,
911                 maxSupply.mul(percentageToAdvisors).div(percent(100))));
912 
913         //
914         //                      percentageToEarlyInvestors
915         //  advisorsTokens = ------------------------------ * maxSupply
916         //                          percentage(100)
917         //
918         assert(token.generateTokens(
919                 destTokensEarlyInvestors,
920                 maxSupply.mul(percentageToEarlyInvestors).div(percent(100))));
921 
922         Finalized();
923     }
924 
925     function percent(uint256 p) internal pure returns (uint256) {
926         return p.mul(10 ** 16);
927     }
928 
929     /// @dev Internal function to determine if an address is a contract
930     /// @param _addr The address being queried
931     /// @return True if `_addr` is a contract
932     function isContract(address _addr) internal view returns (bool) {
933         if (_addr == 0) return false;
934         uint256 size;
935         assembly {
936             size := extcodesize(_addr)
937         }
938         return (size > 0);
939     }
940 
941 
942     //////////
943     // Constant functions
944     //////////
945 
946     /// @return Total tokens issued in weis.
947     function tokensIssued() public view returns (uint256) {
948         return token.totalSupply();
949     }
950 
951 
952     //////////
953     // Testing specific methods
954     //////////
955 
956     /// @notice This function is overridden by the test Mocks.
957     function getBlockNumber() internal view returns (uint256) {
958         return block.number;
959     }
960 
961     /// @notice This function is overrided by the test Mocks.
962     function getTime() internal view returns (uint256) {
963         return now;
964     }
965 
966 
967     //////////
968     // Safety Methods
969     //////////
970 
971     /// @notice This method can be used by the controller to extract mistakenly
972     ///  sent tokens to this contract.
973     /// @param _token The address of the token contract that you want to recover
974     ///  set to 0 in case you want to extract ether.
975     function claimTokens(address _token) public onlyOwner {
976         if (token.controller() == address(this)) {
977             token.claimTokens(_token);
978         }
979         if (_token == 0x0) {
980             owner.transfer(address(this).balance);
981             return;
982         }
983 
984         ERC20Token erc20token = ERC20Token(_token);
985         uint256 balance = erc20token.balanceOf(this);
986         erc20token.transfer(owner, balance);
987         ClaimedTokens(_token, owner, balance);
988     }
989 
990     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
991 
992     event ControllerChanged(address indexed _newController);
993 
994     event NewSale(address indexed _th, uint256 _amount);
995 
996     event Finalized();
997 }
998 
999 
1000 
1001 
1002 /**
1003  * Math operations with safety checks
1004  */
1005 library SafeMath {
1006   function mul(uint a, uint b) internal pure returns (uint) {
1007     uint c = a * b;
1008     assert(a == 0 || c / a == b);
1009     return c;
1010   }
1011 
1012   function div(uint a, uint b) internal pure returns (uint) {
1013     // assert(b > 0); // Solidity automatically throws when dividing by 0
1014     uint c = a / b;
1015     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1016     return c;
1017   }
1018 
1019   function sub(uint a, uint b) internal pure returns (uint) {
1020     assert(b <= a);
1021     return a - b;
1022   }
1023 
1024   function add(uint a, uint b) internal pure returns (uint) {
1025     uint c = a + b;
1026     assert(c >= a);
1027     return c;
1028   }
1029 
1030   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
1031     return a >= b ? a : b;
1032   }
1033 
1034   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
1035     return a < b ? a : b;
1036   }
1037 
1038   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
1039     return a >= b ? a : b;
1040   }
1041 
1042   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
1043     return a < b ? a : b;
1044   }
1045 
1046   function percent(uint a, uint b) internal pure returns (uint) {
1047     return b * a / 100;
1048   }
1049 }
1050 
1051 
1052 
1053 
1054 contract TeamTokensHolder is Owned {
1055     using SafeMath for uint256;
1056 
1057     uint256 public collectedTokens;
1058     TokenContribution public crowdsale;
1059     MiniMeToken public miniMeToken;
1060 
1061     function TeamTokensHolder(address _owner, address _crowdsale, address _token) public {
1062         owner = _owner;
1063         crowdsale = TokenContribution(_crowdsale);
1064         miniMeToken = MiniMeToken(_token);
1065     }
1066 
1067     /// @notice The owner will call this method to extract the tokens
1068     function collectTokens() public onlyOwner {
1069         uint256 balance = miniMeToken.balanceOf(address(this));
1070         uint256 total = collectedTokens.add(balance);
1071 
1072         uint256 finalizedTime = crowdsale.finalizedTime();
1073 
1074         require(finalizedTime > 0 && getTime() > finalizedTime.add(months(12)));
1075 
1076         uint256 canExtract = 0;
1077         if (getTime() <= finalizedTime.add(months(24))) {
1078             require(collectedTokens < total.percent(40));
1079             canExtract = total.percent(40);
1080         } else if (getTime() > finalizedTime.add(months(24)) && getTime() <= finalizedTime.add(months(36))) {
1081             require(collectedTokens < total.percent(80));
1082             canExtract = total.percent(80);
1083         } else {
1084             canExtract = total;
1085         }
1086 
1087         canExtract = canExtract.sub(collectedTokens);
1088 
1089         if (canExtract > balance) {
1090             canExtract = balance;
1091         }
1092 
1093         collectedTokens = collectedTokens.add(canExtract);
1094         miniMeToken.transfer(owner, canExtract);
1095 
1096         TokensWithdrawn(owner, canExtract);
1097     }
1098 
1099     function months(uint256 m) internal pure returns (uint256) {
1100         return m.mul(30 days);
1101     }
1102 
1103     function getTime() internal view returns (uint256) {
1104         return now;
1105     }
1106 
1107 
1108     //////////
1109     // Safety Methods
1110     //////////
1111 
1112     /// @notice This method can be used by the controller to extract mistakenly
1113     ///  sent tokens to this contract.
1114     /// @param _token The address of the token contract that you want to recover
1115     ///  set to 0 in case you want to extract ether.
1116     function claimTokens(address _token) public onlyOwner {
1117         require(_token != address(miniMeToken));
1118         if (_token == 0x0) {
1119             owner.transfer(address(this).balance);
1120             return;
1121         }
1122 
1123         ERC20Token token = ERC20Token(_token);
1124         uint256 balance = token.balanceOf(this);
1125         token.transfer(owner, balance);
1126         ClaimedTokens(_token, owner, balance);
1127     }
1128 
1129     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
1130     event TokensWithdrawn(address indexed _holder, uint256 _amount);
1131 }