1 pragma solidity ^0.4.11;
2 
3 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
4 ///  later changed
5 contract Owned {
6 
7     /// @dev `owner` is the only address that can call a function with this
8     /// modifier
9     modifier onlyOwner() {
10         if(msg.sender != owner) throw;
11         _;
12     }
13 
14     address public owner;
15 
16     /// @notice The Constructor assigns the message sender to be `owner`
17     function Owned() {
18         owner = msg.sender;
19     }
20 
21     address public newOwner;
22 
23     /// @notice `owner` can step down and assign some other address to this role
24     /// @param _newOwner The address of the new owner. 0x0 can be used to create
25     ///  an unowned neutral vault, however that cannot be undone
26     function changeOwner(address _newOwner) onlyOwner {
27         newOwner = _newOwner;
28     }
29 
30 
31     function acceptOwnership() {
32         if (msg.sender == newOwner) {
33             owner = newOwner;
34         }
35     }
36 }
37 
38 // Abstract contract for the full ERC 20 Token standard
39 // https://github.com/ethereum/EIPs/issues/20
40 
41 contract ERC20Token {
42     /* This is a slight change to the ERC20 base standard.
43     function totalSupply() constant returns (uint256 supply);
44     is replaced with:
45     uint256 public totalSupply;
46     This automatically creates a getter function for the totalSupply.
47     This is moved to the base contract since public getter functions are not
48     currently recognised as an implementation of the matching abstract
49     function by the compiler.
50     */
51     /// total amount of tokens
52     uint256 public totalSupply;
53 
54     /// @param _owner The address from which the balance will be retrieved
55     /// @return The balance
56     function balanceOf(address _owner) constant returns (uint256 balance);
57 
58     /// @notice send `_value` token to `_to` from `msg.sender`
59     /// @param _to The address of the recipient
60     /// @param _value The amount of token to be transferred
61     /// @return Whether the transfer was successful or not
62     function transfer(address _to, uint256 _value) returns (bool success);
63 
64     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
65     /// @param _from The address of the sender
66     /// @param _to The address of the recipient
67     /// @param _value The amount of token to be transferred
68     /// @return Whether the transfer was successful or not
69     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
70 
71     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
72     /// @param _spender The address of the account able to transfer the tokens
73     /// @param _value The amount of tokens to be approved for transfer
74     /// @return Whether the approval was successful or not
75     function approve(address _spender, uint256 _value) returns (bool success);
76 
77     /// @param _owner The address of the account owning tokens
78     /// @param _spender The address of the account able to transfer the tokens
79     /// @return Amount of remaining tokens allowed to spent
80     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84 }
85 
86 /*
87     Copyright 2016, Jordi Baylina
88 
89     This program is free software: you can redistribute it and/or modify
90     it under the terms of the GNU General Public License as published by
91     the Free Software Foundation, either version 3 of the License, or
92     (at your option) any later version.
93 
94     This program is distributed in the hope that it will be useful,
95     but WITHOUT ANY WARRANTY; without even the implied warranty of
96     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
97     GNU General Public License for more details.
98 
99     You should have received a copy of the GNU General Public License
100     along with this program.  If not, see <http://www.gnu.org/licenses/>.
101  */
102 
103 /// @title MiniMeToken Contract
104 
105 /// @author Jordi Baylina
106 /// @dev This token contract's goal is to make it easy for anyone to clone this
107 ///  token using the token distribution at a given block, this will allow DAO's
108 ///  and DApps to upgrade their features in a decentralized manner without
109 ///  affecting the original token
110 /// @dev It is ERC20 compliant, but still needs to under go further testing.
111 
112 
113 /// @dev The token controller contract must implement these functions
114 contract TokenController {
115     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
116     /// @param _owner The address that sent the ether to create tokens
117     /// @return True if the ether is accepted, false if it throws
118     function proxyPayment(address _owner) payable returns(bool);
119 
120     /// @notice Notifies the controller about a token transfer allowing the
121     ///  controller to react if desired
122     /// @param _from The origin of the transfer
123     /// @param _to The destination of the transfer
124     /// @param _amount The amount of the transfer
125     /// @return False if the controller does not authorize the transfer
126     function onTransfer(address _from, address _to, uint _amount) returns(bool);
127 
128     /// @notice Notifies the controller about an approval allowing the
129     ///  controller to react if desired
130     /// @param _owner The address that calls `approve()`
131     /// @param _spender The spender in the `approve()` call
132     /// @param _amount The amount in the `approve()` call
133     /// @return False if the controller does not authorize the approval
134     function onApprove(address _owner, address _spender, uint _amount)
135         returns(bool);
136 }
137 
138 contract Controlled {
139     /// @notice The address of the controller is the only address that can call
140     ///  a function with this modifier
141     modifier onlyController { if (msg.sender != controller) throw; _; }
142 
143     address public controller;
144 
145     function Controlled() { controller = msg.sender;}
146 
147     /// @notice Changes the controller of the contract
148     /// @param _newController The new controller of the contract
149     function changeController(address _newController) onlyController {
150         controller = _newController;
151     }
152 }
153 
154 contract ApproveAndCallFallBack {
155     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
156 }
157 
158 /// @dev The actual token contract, the default controller is the msg.sender
159 ///  that deploys the contract, so usually this token will be deployed by a
160 ///  token controller contract, which Giveth will call a "Campaign"
161 contract MiniMeToken is Controlled {
162 
163     string public name;                //The Token's name: e.g. DigixDAO Tokens
164     uint8 public decimals;             //Number of decimals of the smallest unit
165     string public symbol;              //An identifier: e.g. REP
166     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
167 
168 
169     /// @dev `Checkpoint` is the structure that attaches a block number to a
170     ///  given value, the block number attached is the one that last changed the
171     ///  value
172     struct  Checkpoint {
173 
174         // `fromBlock` is the block number that the value was generated from
175         uint128 fromBlock;
176 
177         // `value` is the amount of tokens at a specific block number
178         uint128 value;
179     }
180 
181     // `parentToken` is the Token address that was cloned to produce this token;
182     //  it will be 0x0 for a token that was not cloned
183     MiniMeToken public parentToken;
184 
185     // `parentSnapShotBlock` is the block number from the Parent Token that was
186     //  used to determine the initial distribution of the Clone Token
187     uint public parentSnapShotBlock;
188 
189     // `creationBlock` is the block number that the Clone Token was created
190     uint public creationBlock;
191 
192     // `balances` is the map that tracks the balance of each address, in this
193     //  contract when the balance changes the block number that the change
194     //  occurred is also included in the map
195     mapping (address => Checkpoint[]) balances;
196 
197     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
198     mapping (address => mapping (address => uint256)) allowed;
199 
200     // Tracks the history of the `totalSupply` of the token
201     Checkpoint[] totalSupplyHistory;
202 
203     // Flag that determines if the token is transferable or not.
204     bool public transfersEnabled;
205 
206     // The factory used to create new clone tokens
207     MiniMeTokenFactory public tokenFactory;
208 
209 ////////////////
210 // Constructor
211 ////////////////
212 
213     /// @notice Constructor to create a MiniMeToken
214     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
215     ///  will create the Clone token contracts, the token factory needs to be
216     ///  deployed first
217     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
218     ///  new token
219     /// @param _parentSnapShotBlock Block of the parent token that will
220     ///  determine the initial distribution of the clone token, set to 0 if it
221     ///  is a new token
222     /// @param _tokenName Name of the new token
223     /// @param _decimalUnits Number of decimals of the new token
224     /// @param _tokenSymbol Token Symbol for the new token
225     /// @param _transfersEnabled If true, tokens will be able to be transferred
226     function MiniMeToken(
227         address _tokenFactory,
228         address _parentToken,
229         uint _parentSnapShotBlock,
230         string _tokenName,
231         uint8 _decimalUnits,
232         string _tokenSymbol,
233         bool _transfersEnabled
234     ) {
235         tokenFactory = MiniMeTokenFactory(_tokenFactory);
236         name = _tokenName;                                 // Set the name
237         decimals = _decimalUnits;                          // Set the decimals
238         symbol = _tokenSymbol;                             // Set the symbol
239         parentToken = MiniMeToken(_parentToken);
240         parentSnapShotBlock = _parentSnapShotBlock;
241         transfersEnabled = _transfersEnabled;
242         creationBlock = getBlockNumber();
243     }
244 
245 
246 ///////////////////
247 // ERC20 Methods
248 ///////////////////
249 
250     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
251     /// @param _to The address of the recipient
252     /// @param _amount The amount of tokens to be transferred
253     /// @return Whether the transfer was successful or not
254     function transfer(address _to, uint256 _amount) returns (bool success) {
255         if (!transfersEnabled) throw;
256         return doTransfer(msg.sender, _to, _amount);
257     }
258 
259     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
260     ///  is approved by `_from`
261     /// @param _from The address holding the tokens being transferred
262     /// @param _to The address of the recipient
263     /// @param _amount The amount of tokens to be transferred
264     /// @return True if the transfer was successful
265     function transferFrom(address _from, address _to, uint256 _amount
266     ) returns (bool success) {
267 
268         // The controller of this contract can move tokens around at will,
269         //  this is important to recognize! Confirm that you trust the
270         //  controller of this contract, which in most situations should be
271         //  another open source smart contract or 0x0
272         if (msg.sender != controller) {
273             if (!transfersEnabled) throw;
274 
275             // The standard ERC 20 transferFrom functionality
276             if (allowed[_from][msg.sender] < _amount) return false;
277             allowed[_from][msg.sender] -= _amount;
278         }
279         return doTransfer(_from, _to, _amount);
280     }
281 
282     /// @dev This is the actual transfer function in the token contract, it can
283     ///  only be called by other functions in this contract.
284     /// @param _from The address holding the tokens being transferred
285     /// @param _to The address of the recipient
286     /// @param _amount The amount of tokens to be transferred
287     /// @return True if the transfer was successful
288     function doTransfer(address _from, address _to, uint _amount
289     ) internal returns(bool) {
290 
291            if (_amount == 0) {
292                return true;
293            }
294 
295            if (parentSnapShotBlock >= getBlockNumber()) throw;
296 
297            // Do not allow transfer to 0x0 or the token contract itself
298            if ((_to == 0) || (_to == address(this))) throw;
299 
300            // If the amount being transfered is more than the balance of the
301            //  account the transfer returns false
302            var previousBalanceFrom = balanceOfAt(_from, getBlockNumber());
303            if (previousBalanceFrom < _amount) {
304                return false;
305            }
306 
307            // Alerts the token controller of the transfer
308            if (isContract(controller)) {
309                if (!TokenController(controller).onTransfer(_from, _to, _amount))
310                throw;
311            }
312 
313            // First update the balance array with the new value for the address
314            //  sending the tokens
315            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
316 
317            // Then update the balance array with the new value for the address
318            //  receiving the tokens
319            var previousBalanceTo = balanceOfAt(_to, getBlockNumber());
320            if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
321            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
322 
323            // An event to make the transfer easy to find on the blockchain
324            Transfer(_from, _to, _amount);
325 
326            return true;
327     }
328 
329     /// @param _owner The address that's balance is being requested
330     /// @return The balance of `_owner` at the current block
331     function balanceOf(address _owner) constant returns (uint256 balance) {
332         return balanceOfAt(_owner, getBlockNumber());
333     }
334 
335     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
336     ///  its behalf. This is a modified version of the ERC20 approve function
337     ///  to be a little bit safer
338     /// @param _spender The address of the account able to transfer the tokens
339     /// @param _amount The amount of tokens to be approved for transfer
340     /// @return True if the approval was successful
341     function approve(address _spender, uint256 _amount) returns (bool success) {
342         if (!transfersEnabled) throw;
343 
344         // To change the approve amount you first have to reduce the addresses`
345         //  allowance to zero by calling `approve(_spender,0)` if it is not
346         //  already 0 to mitigate the race condition described here:
347         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
348         if ((_amount!=0) && (allowed[msg.sender][_spender] !=0)) throw;
349 
350         // Alerts the token controller of the approve function call
351         if (isContract(controller)) {
352             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
353                 throw;
354         }
355 
356         allowed[msg.sender][_spender] = _amount;
357         Approval(msg.sender, _spender, _amount);
358         return true;
359     }
360 
361     /// @dev This function makes it easy to read the `allowed[]` map
362     /// @param _owner The address of the account that owns the token
363     /// @param _spender The address of the account able to transfer the tokens
364     /// @return Amount of remaining tokens of _owner that _spender is allowed
365     ///  to spend
366     function allowance(address _owner, address _spender
367     ) constant returns (uint256 remaining) {
368         return allowed[_owner][_spender];
369     }
370 
371     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
372     ///  its behalf, and then a function is triggered in the contract that is
373     ///  being approved, `_spender`. This allows users to use their tokens to
374     ///  interact with contracts in one function call instead of two
375     /// @param _spender The address of the contract able to transfer the tokens
376     /// @param _amount The amount of tokens to be approved for transfer
377     /// @return True if the function call was successful
378     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
379     ) returns (bool success) {
380         if (!approve(_spender, _amount)) throw;
381 
382         ApproveAndCallFallBack(_spender).receiveApproval(
383             msg.sender,
384             _amount,
385             this,
386             _extraData
387         );
388 
389         return true;
390     }
391 
392     /// @dev This function makes it easy to get the total number of tokens
393     /// @return The total number of tokens
394     function totalSupply() constant returns (uint) {
395         return totalSupplyAt(getBlockNumber());
396     }
397 
398 
399 ////////////////
400 // Query balance and totalSupply in History
401 ////////////////
402 
403     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
404     /// @param _owner The address from which the balance will be retrieved
405     /// @param _blockNumber The block number when the balance is queried
406     /// @return The balance at `_blockNumber`
407     function balanceOfAt(address _owner, uint _blockNumber) constant
408         returns (uint) {
409 
410         // These next few lines are used when the balance of the token is
411         //  requested before a check point was ever created for this token, it
412         //  requires that the `parentToken.balanceOfAt` be queried at the
413         //  genesis block for that token as this contains initial balance of
414         //  this token
415         if ((balances[_owner].length == 0)
416             || (balances[_owner][0].fromBlock > _blockNumber)) {
417             if (address(parentToken) != 0) {
418                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
419             } else {
420                 // Has no parent
421                 return 0;
422             }
423 
424         // This will return the expected balance during normal situations
425         } else {
426             return getValueAt(balances[_owner], _blockNumber);
427         }
428     }
429 
430     /// @notice Total amount of tokens at a specific `_blockNumber`.
431     /// @param _blockNumber The block number when the totalSupply is queried
432     /// @return The total amount of tokens at `_blockNumber`
433     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
434 
435         // These next few lines are used when the totalSupply of the token is
436         //  requested before a check point was ever created for this token, it
437         //  requires that the `parentToken.totalSupplyAt` be queried at the
438         //  genesis block for this token as that contains totalSupply of this
439         //  token at this block number.
440         if ((totalSupplyHistory.length == 0)
441             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
442             if (address(parentToken) != 0) {
443                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
444             } else {
445                 return 0;
446             }
447 
448         // This will return the expected totalSupply during normal situations
449         } else {
450             return getValueAt(totalSupplyHistory, _blockNumber);
451         }
452     }
453 
454 ////////////////
455 // Clone Token Method
456 ////////////////
457 
458     /// @notice Creates a new clone token with the initial distribution being
459     ///  this token at `_snapshotBlock`
460     /// @param _cloneTokenName Name of the clone token
461     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
462     /// @param _cloneTokenSymbol Symbol of the clone token
463     /// @param _snapshotBlock Block when the distribution of the parent token is
464     ///  copied to set the initial distribution of the new clone token;
465     ///  if the block is zero than the actual block, the current block is used
466     /// @param _transfersEnabled True if transfers are allowed in the clone
467     /// @return The address of the new MiniMeToken Contract
468     function createCloneToken(
469         string _cloneTokenName,
470         uint8 _cloneDecimalUnits,
471         string _cloneTokenSymbol,
472         uint _snapshotBlock,
473         bool _transfersEnabled
474         ) returns(address) {
475         if (_snapshotBlock == 0) _snapshotBlock = getBlockNumber();
476         MiniMeToken cloneToken = tokenFactory.createCloneToken(
477             this,
478             _snapshotBlock,
479             _cloneTokenName,
480             _cloneDecimalUnits,
481             _cloneTokenSymbol,
482             _transfersEnabled
483             );
484 
485         cloneToken.changeController(msg.sender);
486 
487         // An event to make the token easy to find on the blockchain
488         NewCloneToken(address(cloneToken), _snapshotBlock);
489         return address(cloneToken);
490     }
491 
492 ////////////////
493 // Generate and destroy tokens
494 ////////////////
495 
496     /// @notice Generates `_amount` tokens that are assigned to `_owner`
497     /// @param _owner The address that will be assigned the new tokens
498     /// @param _amount The quantity of tokens generated
499     /// @return True if the tokens are generated correctly
500     function generateTokens(address _owner, uint _amount
501     ) onlyController returns (bool) {
502         uint curTotalSupply = getValueAt(totalSupplyHistory, getBlockNumber());
503         if (curTotalSupply + _amount < curTotalSupply) throw; // Check for overflow
504         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
505         var previousBalanceTo = balanceOf(_owner);
506         if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
507         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
508         Transfer(0, _owner, _amount);
509         return true;
510     }
511 
512 
513     /// @notice Burns `_amount` tokens from `_owner`
514     /// @param _owner The address that will lose the tokens
515     /// @param _amount The quantity of tokens to burn
516     /// @return True if the tokens are burned correctly
517     function destroyTokens(address _owner, uint _amount
518     ) onlyController returns (bool) {
519         uint curTotalSupply = getValueAt(totalSupplyHistory, getBlockNumber());
520         if (curTotalSupply < _amount) throw;
521         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
522         var previousBalanceFrom = balanceOf(_owner);
523         if (previousBalanceFrom < _amount) throw;
524         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
525         Transfer(_owner, 0, _amount);
526         return true;
527     }
528 
529 ////////////////
530 // Enable tokens transfers
531 ////////////////
532 
533 
534     /// @notice Enables token holders to transfer their tokens freely if true
535     /// @param _transfersEnabled True if transfers are allowed in the clone
536     function enableTransfers(bool _transfersEnabled) onlyController {
537         transfersEnabled = _transfersEnabled;
538     }
539 
540 ////////////////
541 // Internal helper functions to query and set a value in a snapshot array
542 ////////////////
543 
544     /// @dev `getValueAt` retrieves the number of tokens at a given block number
545     /// @param checkpoints The history of values being queried
546     /// @param _block The block number to retrieve the value at
547     /// @return The number of tokens being queried
548     function getValueAt(Checkpoint[] storage checkpoints, uint _block
549     ) constant internal returns (uint) {
550         if (checkpoints.length == 0) return 0;
551 
552         // Shortcut for the actual value
553         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
554             return checkpoints[checkpoints.length-1].value;
555         if (_block < checkpoints[0].fromBlock) return 0;
556 
557         // Binary search of the value in the array
558         uint min = 0;
559         uint max = checkpoints.length-1;
560         while (max > min) {
561             uint mid = (max + min + 1)/ 2;
562             if (checkpoints[mid].fromBlock<=_block) {
563                 min = mid;
564             } else {
565                 max = mid-1;
566             }
567         }
568         return checkpoints[min].value;
569     }
570 
571     /// @dev `updateValueAtNow` used to update the `balances` map and the
572     ///  `totalSupplyHistory`
573     /// @param checkpoints The history of data being updated
574     /// @param _value The new number of tokens
575     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
576     ) internal  {
577         if ((checkpoints.length == 0)
578         || (checkpoints[checkpoints.length -1].fromBlock < getBlockNumber())) {
579                Checkpoint newCheckPoint = checkpoints[ checkpoints.length++ ];
580                newCheckPoint.fromBlock =  uint128(getBlockNumber());
581                newCheckPoint.value = uint128(_value);
582            } else {
583                Checkpoint oldCheckPoint = checkpoints[checkpoints.length-1];
584                oldCheckPoint.value = uint128(_value);
585            }
586     }
587 
588     /// @dev Internal function to determine if an address is a contract
589     /// @param _addr The address being queried
590     /// @return True if `_addr` is a contract
591     function isContract(address _addr) constant internal returns(bool) {
592         uint size;
593         if (_addr == 0) return false;
594         assembly {
595             size := extcodesize(_addr)
596         }
597         return size>0;
598     }
599 
600     /// @dev Helper function to return a min betwen the two uints
601     function min(uint a, uint b) internal returns (uint) {
602         return a < b ? a : b;
603     }
604 
605     /// @notice The fallback function: If the contract's controller has not been
606     ///  set to 0, then the `proxyPayment` method is called which relays the
607     ///  ether and creates tokens as described in the token controller contract
608     function ()  payable {
609         if (isContract(controller)) {
610             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
611                 throw;
612         } else {
613             throw;
614         }
615     }
616 
617 
618 //////////
619 // Testing specific methods
620 //////////
621 
622     /// @notice This function is overridden by the test Mocks.
623     function getBlockNumber() internal constant returns (uint256) {
624         return block.number;
625     }
626 
627 //////////
628 // Safety Methods
629 //////////
630 
631     /// @notice This method can be used by the controller to extract mistakenly
632     ///  sent tokens to this contract.
633     /// @param _token The address of the token contract that you want to recover
634     ///  set to 0 in case you want to extract ether.
635     function claimTokens(address _token) onlyController {
636         if (_token == 0x0) {
637             controller.transfer(this.balance);
638             return;
639         }
640 
641         ERC20Token token = ERC20Token(_token);
642         uint balance = token.balanceOf(this);
643         token.transfer(controller, balance);
644         ClaimedTokens(_token, controller, balance);
645     }
646 
647 ////////////////
648 // Events
649 ////////////////
650 
651     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
652     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
653     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
654     event Approval(
655         address indexed _owner,
656         address indexed _spender,
657         uint256 _amount
658         );
659 
660 }
661 
662 
663 ////////////////
664 // MiniMeTokenFactory
665 ////////////////
666 
667 /// @dev This contract is used to generate clone contracts from a contract.
668 ///  In solidity this is the way to create a contract from a contract of the
669 ///  same class
670 contract MiniMeTokenFactory {
671 
672     /// @notice Update the DApp by creating a new token with new functionalities
673     ///  the msg.sender becomes the controller of this clone token
674     /// @param _parentToken Address of the token being cloned
675     /// @param _snapshotBlock Block of the parent token that will
676     ///  determine the initial distribution of the clone token
677     /// @param _tokenName Name of the new token
678     /// @param _decimalUnits Number of decimals of the new token
679     /// @param _tokenSymbol Token Symbol for the new token
680     /// @param _transfersEnabled If true, tokens will be able to be transferred
681     /// @return The address of the new token contract
682     function createCloneToken(
683         address _parentToken,
684         uint _snapshotBlock,
685         string _tokenName,
686         uint8 _decimalUnits,
687         string _tokenSymbol,
688         bool _transfersEnabled
689     ) returns (MiniMeToken) {
690         MiniMeToken newToken = new MiniMeToken(
691             this,
692             _parentToken,
693             _snapshotBlock,
694             _tokenName,
695             _decimalUnits,
696             _tokenSymbol,
697             _transfersEnabled
698             );
699 
700         newToken.changeController(msg.sender);
701         return newToken;
702     }
703 }
704 
705 /**
706  * Math operations with safety checks
707  */
708 library SafeMath {
709   function mul(uint a, uint b) internal returns (uint) {
710     uint c = a * b;
711     assert(a == 0 || c / a == b);
712     return c;
713   }
714 
715   function div(uint a, uint b) internal returns (uint) {
716     // assert(b > 0); // Solidity automatically throws when dividing by 0
717     uint c = a / b;
718     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
719     return c;
720   }
721 
722   function sub(uint a, uint b) internal returns (uint) {
723     assert(b <= a);
724     return a - b;
725   }
726 
727   function add(uint a, uint b) internal returns (uint) {
728     uint c = a + b;
729     assert(c >= a);
730     return c;
731   }
732 
733   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
734     return a >= b ? a : b;
735   }
736 
737   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
738     return a < b ? a : b;
739   }
740 
741   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
742     return a >= b ? a : b;
743   }
744 
745   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
746     return a < b ? a : b;
747   }
748 }
749 
750 contract ATTContribution is Owned, TokenController {
751     using SafeMath for uint256;
752 
753     uint256 constant public exchangeRate = 600;   // will be set before the token sale.
754     uint256 constant public maxGasPrice = 50000000000;  // 50GWei
755 
756     uint256 public maxFirstRoundTokenLimit = 20000000 ether; // ATT have same precision with ETH
757 
758     uint256 public maxIssueTokenLimit = 70000000 ether; // ATT have same precision with ETH
759 
760     MiniMeToken public  ATT;            // The ATT token itself
761 
762     address public attController;
763 
764     address public destEthFoundation;
765     address public destTokensAngel;
766 
767     uint256 public startTime;
768     uint256 public endTime;
769 
770     uint256 public totalNormalTokenGenerated;
771     uint256 public totalNormalEtherCollected;
772 
773     uint256 public totalIssueTokenGenerated;
774 
775     uint256 public finalizedBlock;
776     uint256 public finalizedTime;
777 
778     bool public paused;
779 
780     modifier initialized() {
781         require(address(ATT) != 0x0);
782         _;
783     }
784 
785     modifier contributionOpen() {
786         require(time() >= startTime &&
787               time() <= endTime &&
788               finalizedBlock == 0 &&
789               address(ATT) != 0x0);
790         _;
791     }
792 
793     modifier notPaused() {
794         require(!paused);
795         _;
796     }
797 
798     function ATTContribution() {
799         paused = false;
800     }
801 
802 
803     /// @notice This method should be called by the owner before the contribution
804     ///  period starts This initializes most of the parameters
805     /// @param _att Address of the ATT token contract
806     /// @param _attController Token controller for the ATT that will be transferred after
807     ///  the contribution finalizes.
808     /// @param _startTime Time when the contribution period starts
809     /// @param _endTime The time that the contribution period ends
810     /// @param _destEthFoundation Destination address where the contribution ether is sent
811     /// @param _destTokensAngel Address where the tokens for the angels are sent
812     function initialize(
813         address _att,
814         address _attController,
815         uint _startTime,
816         uint _endTime,
817         address _destEthFoundation,
818         address _destTokensAngel
819     ) public onlyOwner {
820       // Initialize only once
821       require(address(ATT) == 0x0);
822 
823       ATT = MiniMeToken(_att);
824       require(ATT.totalSupply() == 0);
825       require(ATT.controller() == address(this));
826       require(ATT.decimals() == 18);  // Same amount of decimals as ETH
827 
828       startTime = _startTime;
829       endTime = _endTime;
830 
831       assert(startTime < endTime);
832 
833       require(_attController != 0x0);
834       attController = _attController;
835 
836       require(_destEthFoundation != 0x0);
837       destEthFoundation = _destEthFoundation;
838 
839       require(_destTokensAngel != 0x0);
840       destTokensAngel = _destTokensAngel;
841   }
842 
843   /// @notice If anybody sends Ether directly to this contract, consider he is
844   ///  getting ATTs.
845   function () public payable notPaused {
846       proxyPayment(msg.sender);
847   }
848 
849 
850   //////////
851   // MiniMe Controller functions
852   //////////
853 
854   /// @notice This method will generally be called by the ATT token contract to
855   ///  acquire ATTs. Or directly from third parties that want to acquire ATTs in
856   ///  behalf of a token holder.
857   /// @param _th ATT holder where the ATTs will be minted.
858   function proxyPayment(address _th) public payable notPaused initialized contributionOpen returns (bool) {
859       require(_th != 0x0);
860 
861       buyNormal(_th);
862 
863       return true;
864   }
865 
866   function onTransfer(address, address, uint256) public returns (bool) {
867       return false;
868   }
869 
870   function onApprove(address, address, uint256) public returns (bool) {
871       return false;
872   }
873 
874   function buyNormal(address _th) internal {
875       require(tx.gasprice <= maxGasPrice);
876       
877       // Antispam mechanism
878       // TODO: Is this checking useful?
879       address caller;
880       if (msg.sender == address(ATT)) {
881           caller = _th;
882       } else {
883           caller = msg.sender;
884       }
885 
886       // Do not allow contracts to game the system
887       require(!isContract(caller));
888 
889       doBuy(_th, msg.value);
890   }
891 
892   function doBuy(address _th, uint256 _toFund) internal {
893       require(tx.gasprice <= maxGasPrice);
894 
895       assert(msg.value >= _toFund);  // Not needed, but double check.
896       assert(totalNormalTokenGenerated < maxFirstRoundTokenLimit);
897 
898       uint256 endOfFirstWeek = startTime.add(1 weeks);
899       uint256 endOfSecondWeek = startTime.add(2 weeks);
900       uint256 finalExchangeRate = exchangeRate;
901       if (now < endOfFirstWeek)
902       {
903           // 10% Bonus in first week
904           finalExchangeRate = exchangeRate.mul(110).div(100);
905       } else if (now < endOfSecondWeek)
906       {
907           // 5% Bonus in second week
908           finalExchangeRate = exchangeRate.mul(105).div(100);
909       }
910 
911       if (_toFund > 0) {
912           uint256 tokensGenerating = _toFund.mul(finalExchangeRate);
913 
914           uint256 tokensToBeGenerated = totalNormalTokenGenerated.add(tokensGenerating);
915           if (tokensToBeGenerated > maxFirstRoundTokenLimit)
916           {
917               tokensGenerating = maxFirstRoundTokenLimit - totalNormalTokenGenerated;
918               _toFund = tokensGenerating.div(finalExchangeRate);
919           }
920 
921           assert(ATT.generateTokens(_th, tokensGenerating));
922           destEthFoundation.transfer(_toFund);
923 
924           totalNormalTokenGenerated = totalNormalTokenGenerated.add(tokensGenerating);
925 
926           totalNormalEtherCollected = totalNormalEtherCollected.add(_toFund);
927 
928           NewSale(_th, _toFund, tokensGenerating);
929       }
930 
931       uint256 toReturn = msg.value.sub(_toFund);
932       if (toReturn > 0) {
933           // TODO: If the call comes from the Token controller,
934           // then we return it to the token Holder.
935           // Otherwise we return to the sender.
936           if (msg.sender == address(ATT)) {
937               _th.transfer(toReturn);
938           } else {
939               msg.sender.transfer(toReturn);
940           }
941       }
942   }
943 
944   function issueTokenToGuaranteedAddress(address _th, uint256 _amount, bytes data) onlyOwner initialized notPaused contributionOpen {
945       require(totalIssueTokenGenerated.add(_amount) <= maxIssueTokenLimit);
946 
947       assert(ATT.generateTokens(_th, _amount));
948 
949       totalIssueTokenGenerated = totalIssueTokenGenerated.add(_amount);
950 
951       NewIssue(_th, _amount, data);
952   }
953 
954   function adjustLimitBetweenIssueAndNormal(uint256 _amount, bool _isAddToNormal) onlyOwner initialized contributionOpen {
955       if(_isAddToNormal)
956       {
957           require(totalIssueTokenGenerated.add(_amount) <= maxIssueTokenLimit);
958           maxIssueTokenLimit = maxIssueTokenLimit.sub(_amount);
959           maxFirstRoundTokenLimit = maxFirstRoundTokenLimit.add(_amount);
960       } else {
961           require(totalNormalTokenGenerated.add(_amount) <= maxFirstRoundTokenLimit);
962           maxFirstRoundTokenLimit = maxFirstRoundTokenLimit.sub(_amount);
963           maxIssueTokenLimit = maxIssueTokenLimit.add(_amount);
964       }
965   }
966 
967   // NOTE on Percentage format
968   // Right now, Solidity does not support decimal numbers. (This will change very soon)
969   //  So in this contract we use a representation of a percentage that consist in
970   //  expressing the percentage in "x per 10**18"
971   // This format has a precision of 16 digits for a percent.
972   // Examples:
973   //  3%   =   3*(10**16)
974   //  100% = 100*(10**16) = 10**18
975   //
976   // To get a percentage of a value we do it by first multiplying it by the percentage in  (x per 10^18)
977   //  and then divide it by 10**18
978   //
979   //              Y * X(in x per 10**18)
980   //  X% of Y = -------------------------
981   //               100(in x per 10**18)
982   //
983 
984 
985   /// @notice This method will can be called by the owner before the contribution period
986   ///  end or by anybody after the `endBlock`. This method finalizes the contribution period
987   ///  by creating the remaining tokens and transferring the controller to the configured
988   ///  controller.
989   function finalize() public onlyOwner initialized {
990       require(time() >= startTime);
991       // require(msg.sender == owner || time() > endTime);
992       require(finalizedBlock == 0);
993 
994       finalizedBlock = getBlockNumber();
995       finalizedTime = now;
996 
997       uint256 tokensToSecondRound = 90000000 ether;
998 
999       uint256 tokensToReserve = 90000000 ether;
1000 
1001       uint256 tokensToAngelAndOther = 30000000 ether;
1002 
1003       // totalTokenGenerated should equal to ATT.totalSupply()
1004 
1005       // If tokens in first round is not sold out, they will be added to second round and frozen together
1006       tokensToSecondRound = tokensToSecondRound.add(maxFirstRoundTokenLimit).sub(totalNormalTokenGenerated);
1007       
1008       tokensToSecondRound = tokensToSecondRound.add(maxIssueTokenLimit).sub(totalIssueTokenGenerated);
1009 
1010       uint256 totalTokens = 300000000 ether;
1011 
1012       require(totalTokens == ATT.totalSupply().add(tokensToSecondRound).add(tokensToReserve).add(tokensToAngelAndOther));
1013 
1014       assert(ATT.generateTokens(0xb1, tokensToSecondRound));
1015 
1016       assert(ATT.generateTokens(0xb2, tokensToReserve));
1017 
1018       assert(ATT.generateTokens(destTokensAngel, tokensToAngelAndOther));
1019 
1020       // totalTokens should equal to ATT.totalSupply()
1021 
1022       ATT.changeController(attController);
1023 
1024       Finalized();
1025   }
1026 
1027   function percent(uint256 p) internal returns (uint256) {
1028       return p.mul(10**16);
1029   }
1030   
1031   /// @dev Internal function to determine if an address is a contract
1032   /// @param _addr The address being queried
1033   /// @return True if `_addr` is a contract
1034   function isContract(address _addr) constant internal returns (bool) {
1035       if (_addr == 0) return false;
1036       uint256 size;
1037       assembly {
1038           size := extcodesize(_addr)
1039       }
1040       return (size > 0);
1041   }
1042 
1043   function time() constant returns (uint) {
1044       return block.timestamp;
1045   }
1046 
1047   //////////
1048   // Constant functions
1049   //////////
1050 
1051   /// @return Total tokens issued in weis.
1052   function tokensIssued() public constant returns (uint256) {
1053       return ATT.totalSupply();
1054   }
1055 
1056   //////////
1057   // Testing specific methods
1058   //////////
1059 
1060   /// @notice This function is overridden by the test Mocks.
1061   function getBlockNumber() internal constant returns (uint256) {
1062       return block.number;
1063   }
1064 
1065   //////////
1066   // Safety Methods
1067   //////////
1068 
1069   /// @notice This method can be used by the controller to extract mistakenly
1070   ///  sent tokens to this contract.
1071   /// @param _token The address of the token contract that you want to recover
1072   ///  set to 0 in case you want to extract ether.
1073   function claimTokens(address _token) public onlyOwner {
1074       if (ATT.controller() == address(this)) {
1075           ATT.claimTokens(_token);
1076       }
1077       if (_token == 0x0) {
1078           owner.transfer(this.balance);
1079           return;
1080       }
1081 
1082       ERC20Token token = ERC20Token(_token);
1083       uint256 balance = token.balanceOf(this);
1084       token.transfer(owner, balance);
1085       ClaimedTokens(_token, owner, balance);
1086   }
1087 
1088   /// @notice Pauses the contribution if there is any issue
1089   function pauseContribution() onlyOwner {
1090       paused = true;
1091   }
1092 
1093   /// @notice Resumes the contribution
1094   function resumeContribution() onlyOwner {
1095       paused = false;
1096   }
1097 
1098   event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
1099   event NewSale(address indexed _th, uint256 _amount, uint256 _tokens);
1100   event NewIssue(address indexed _th, uint256 _amount, bytes data);
1101   event Finalized();
1102 }