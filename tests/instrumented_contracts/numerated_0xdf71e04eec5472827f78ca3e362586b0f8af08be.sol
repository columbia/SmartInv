1 pragma solidity ^0.4.18;
2 
3 /*
4     Copyright 2016, Jordi Baylina
5 
6     This program is free software: you can redistribute it and/or modify
7     it under the terms of the GNU General Public License as published by
8     the Free Software Foundation, either version 3 of the License, or
9     (at your option) any later version.
10 
11     This program is distributed in the hope that it will be useful,
12     but WITHOUT ANY WARRANTY; without even the implied warranty of
13     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14     GNU General Public License for more details.
15 
16     You should have received a copy of the GNU General Public License
17     along with this program.  If not, see <http://www.gnu.org/licenses/>.
18  */
19 
20 /// @title MiniMeToken Contract
21 /// @author Jordi Baylina
22 /// @dev This token contract's goal is to make it easy for anyone to clone this
23 ///  token using the token distribution at a given block, this will allow DAO's
24 ///  and DApps to upgrade their features in a decentralized manner without
25 ///  affecting the original token
26 /// @dev It is ERC20 compliant, but still needs to under go further testing.
27 
28 contract Owned {
29     /// @dev `owner` is the only address that can call a function with this
30     /// modifier
31     modifier onlyOwner { require (msg.sender == owner); _; }
32 
33     address public owner;
34 
35     /// @notice The Constructor assigns the message sender to be `owner`
36     function Owned() { owner = msg.sender;}
37 
38     /// @notice `owner` can step down and assign some other address to this role
39     /// @param _newOwner The address of the new owner. 0x0 can be used to create
40     ///  an unowned neutral vault, however that cannot be undone
41     function changeOwner(address _newOwner) onlyOwner {
42         owner = _newOwner;
43     }
44 }
45 
46 contract Controlled is Owned {
47     /// @notice The address of the controller is the only address that can call
48     ///  a function with this modifier
49     modifier onlyController { require(msg.sender == controller || msg.sender == owner); _; }
50 
51     address public controller;
52 
53     function Controlled() public { controller = msg.sender;}
54 
55     /// @notice Changes the controller of the contract - only the Controller or Owner can execute this operation
56     /// @param _newController The new controller of the contract
57     function changeController(address _newController) public onlyController {
58         controller = _newController;
59     }
60 }
61 
62 
63 /// @dev The token controller contract must implement these functions
64 contract TokenController {
65     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
66     /// @param _owner The address that sent the ether to create tokens
67     /// @return True if the ether is accepted, false if it throws
68     function proxyPayment(address _owner) public payable returns(bool);
69 
70     /// @notice Notifies the controller about a token transfer allowing the
71     ///  controller to react if desired
72     /// @param _from The origin of the transfer
73     /// @param _to The destination of the transfer
74     /// @param _amount The amount of the transfer
75     /// @return False if the controller does not authorize the transfer
76     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
77 
78     /// @notice Notifies the controller about an approval allowing the
79     ///  controller to react if desired
80     /// @param _owner The address that calls `approve()`
81     /// @param _spender The spender in the `approve()` call
82     /// @param _amount The amount in the `approve()` call
83     /// @return False if the controller does not authorize the approval
84     function onApprove(address _owner, address _spender, uint _amount) public
85         returns(bool);
86 }
87 
88 
89 contract ApproveAndCallFallBack {
90     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
91 }
92 
93 /// @dev The actual token contract, the default controller is the msg.sender
94 ///  that deploys the contract, so usually this token will be deployed by a
95 ///  token controller contract, which Giveth will call a "Campaign"
96 contract MiniMeToken is Controlled {
97 
98     string public name;                //The Token's name: e.g. DigixDAO Tokens
99     uint8 public decimals;             //Number of decimals of the smallest unit
100     string public symbol;              //An identifier: e.g. REP
101     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
102 
103 
104     /// @dev `Checkpoint` is the structure that attaches a block number to a
105     ///  given value, the block number attached is the one that last changed the
106     ///  value
107     struct  Checkpoint {
108 
109         // `fromBlock` is the block number that the value was generated from
110         uint128 fromBlock;
111 
112         // `value` is the amount of tokens at a specific block number
113         uint128 value;
114     }
115 
116     // `parentToken` is the Token address that was cloned to produce this token;
117     //  it will be 0x0 for a token that was not cloned
118     MiniMeToken public parentToken;
119 
120     // `parentSnapShotBlock` is the block number from the Parent Token that was
121     //  used to determine the initial distribution of the Clone Token
122     uint public parentSnapShotBlock;
123 
124     // `creationBlock` is the block number that the Clone Token was created
125     uint public creationBlock;
126 
127     // `balances` is the map that tracks the balance of each address, in this
128     //  contract when the balance changes the block number that the change
129     //  occurred is also included in the map
130     mapping (address => Checkpoint[]) balances;
131 
132     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
133     mapping (address => mapping (address => uint256)) allowed;
134 
135     // Tracks the history of the `totalSupply` of the token
136     Checkpoint[] totalSupplyHistory;
137 
138     // Flag that determines if the token is transferable or not.
139     bool public transfersEnabled;
140 
141     // The factory used to create new clone tokens
142     MiniMeTokenFactory public tokenFactory;
143 
144 ////////////////
145 // Constructor
146 ////////////////
147 
148     /// @notice Constructor to create a MiniMeToken
149     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
150     ///  will create the Clone token contracts, the token factory needs to be
151     ///  deployed first
152     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
153     ///  new token
154     /// @param _parentSnapShotBlock Block of the parent token that will
155     ///  determine the initial distribution of the clone token, set to 0 if it
156     ///  is a new token
157     /// @param _tokenName Name of the new token
158     /// @param _decimalUnits Number of decimals of the new token
159     /// @param _tokenSymbol Token Symbol for the new token
160     /// @param _transfersEnabled If true, tokens will be able to be transferred
161     function MiniMeToken(
162         address _tokenFactory,
163         address _parentToken,
164         uint _parentSnapShotBlock,
165         string _tokenName,
166         uint8 _decimalUnits,
167         string _tokenSymbol,
168         bool _transfersEnabled
169     ) public {
170         tokenFactory = MiniMeTokenFactory(_tokenFactory);
171         name = _tokenName;                                 // Set the name
172         decimals = _decimalUnits;                          // Set the decimals
173         symbol = _tokenSymbol;                             // Set the symbol
174         parentToken = MiniMeToken(_parentToken);
175         parentSnapShotBlock = _parentSnapShotBlock;
176         transfersEnabled = _transfersEnabled;
177         creationBlock = block.number;
178     }
179 
180 
181 ///////////////////
182 // ERC20 Methods
183 ///////////////////
184 
185     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
186     /// @param _to The address of the recipient
187     /// @param _amount The amount of tokens to be transferred
188     /// @return Whether the transfer was successful or not
189     function transfer(address _to, uint256 _amount) public returns (bool success) {
190         require(transfersEnabled);
191         doTransfer(msg.sender, _to, _amount);
192         return true;
193     }
194 
195     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
196     ///  is approved by `_from`
197     /// @param _from The address holding the tokens being transferred
198     /// @param _to The address of the recipient
199     /// @param _amount The amount of tokens to be transferred
200     /// @return True if the transfer was successful
201     function transferFrom(address _from, address _to, uint256 _amount
202     ) public returns (bool success) {
203 
204         // The controller of this contract can move tokens around at will,
205         //  this is important to recognize! Confirm that you trust the
206         //  controller of this contract, which in most situations should be
207         //  another open source smart contract or 0x0
208         if (msg.sender != controller) {
209             require(transfersEnabled);
210 
211             // The standard ERC 20 transferFrom functionality
212             require(allowed[_from][msg.sender] >= _amount);
213             allowed[_from][msg.sender] -= _amount;
214         }
215         doTransfer(_from, _to, _amount);
216         return true;
217     }
218 
219     /// @dev This is the actual transfer function in the token contract, it can
220     ///  only be called by other functions in this contract.
221     /// @param _from The address holding the tokens being transferred
222     /// @param _to The address of the recipient
223     /// @param _amount The amount of tokens to be transferred
224     /// @return True if the transfer was successful
225     function doTransfer(address _from, address _to, uint _amount
226     ) internal {
227 
228            if (_amount == 0) {
229                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
230                return;
231            }
232 
233            require(parentSnapShotBlock < block.number);
234 
235            // Do not allow transfer to 0x0 or the token contract itself
236            require((_to != 0) && (_to != address(this)));
237 
238            // If the amount being transfered is more than the balance of the
239            //  account the transfer throws
240            var previousBalanceFrom = balanceOfAt(_from, block.number);
241 
242            require(previousBalanceFrom >= _amount);
243 
244            // Alerts the token controller of the transfer
245            if (isContract(controller)) {
246                require(TokenController(controller).onTransfer(_from, _to, _amount));
247            }
248 
249            // First update the balance array with the new value for the address
250            //  sending the tokens
251            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
252 
253            // Then update the balance array with the new value for the address
254            //  receiving the tokens
255            var previousBalanceTo = balanceOfAt(_to, block.number);
256            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
257            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
258 
259            // An event to make the transfer easy to find on the blockchain
260            Transfer(_from, _to, _amount);
261 
262     }
263 
264     /// @param _owner The address that's balance is being requested
265     /// @return The balance of `_owner` at the current block
266     function balanceOf(address _owner) public constant returns (uint256 balance) {
267         return balanceOfAt(_owner, block.number);
268     }
269 
270     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
271     ///  its behalf. This is a modified version of the ERC20 approve function
272     ///  to be a little bit safer
273     /// @param _spender The address of the account able to transfer the tokens
274     /// @param _amount The amount of tokens to be approved for transfer
275     /// @return True if the approval was successful
276     function approve(address _spender, uint256 _amount) public returns (bool success) {
277         require(transfersEnabled);
278 
279         // To change the approve amount you first have to reduce the addresses`
280         //  allowance to zero by calling `approve(_spender,0)` if it is not
281         //  already 0 to mitigate the race condition described here:
282         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
283         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
284 
285         // Alerts the token controller of the approve function call
286         if (isContract(controller)) {
287             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
288         }
289 
290         allowed[msg.sender][_spender] = _amount;
291         Approval(msg.sender, _spender, _amount);
292         return true;
293     }
294 
295     /// @dev This function makes it easy to read the `allowed[]` map
296     /// @param _owner The address of the account that owns the token
297     /// @param _spender The address of the account able to transfer the tokens
298     /// @return Amount of remaining tokens of _owner that _spender is allowed
299     ///  to spend
300     function allowance(address _owner, address _spender
301     ) public constant returns (uint256 remaining) {
302         return allowed[_owner][_spender];
303     }
304 
305     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
306     ///  its behalf, and then a function is triggered in the contract that is
307     ///  being approved, `_spender`. This allows users to use their tokens to
308     ///  interact with contracts in one function call instead of two
309     /// @param _spender The address of the contract able to transfer the tokens
310     /// @param _amount The amount of tokens to be approved for transfer
311     /// @return True if the function call was successful
312     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
313     ) public returns (bool success) {
314         require(approve(_spender, _amount));
315 
316         ApproveAndCallFallBack(_spender).receiveApproval(
317             msg.sender,
318             _amount,
319             this,
320             _extraData
321         );
322 
323         return true;
324     }
325 
326     /// @dev This function makes it easy to get the total number of tokens
327     /// @return The total number of tokens
328     function totalSupply() public constant returns (uint) {
329         return totalSupplyAt(block.number);
330     }
331 
332 
333 ////////////////
334 // Query balance and totalSupply in History
335 ////////////////
336 
337     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
338     /// @param _owner The address from which the balance will be retrieved
339     /// @param _blockNumber The block number when the balance is queried
340     /// @return The balance at `_blockNumber`
341     function balanceOfAt(address _owner, uint _blockNumber) public constant
342         returns (uint) {
343 
344         // These next few lines are used when the balance of the token is
345         //  requested before a check point was ever created for this token, it
346         //  requires that the `parentToken.balanceOfAt` be queried at the
347         //  genesis block for that token as this contains initial balance of
348         //  this token
349         if ((balances[_owner].length == 0)
350             || (balances[_owner][0].fromBlock > _blockNumber)) {
351             if (address(parentToken) != 0) {
352                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
353             } else {
354                 // Has no parent
355                 return 0;
356             }
357 
358         // This will return the expected balance during normal situations
359         } else {
360             return getValueAt(balances[_owner], _blockNumber);
361         }
362     }
363 
364     /// @notice Total amount of tokens at a specific `_blockNumber`.
365     /// @param _blockNumber The block number when the totalSupply is queried
366     /// @return The total amount of tokens at `_blockNumber`
367     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
368 
369         // These next few lines are used when the totalSupply of the token is
370         //  requested before a check point was ever created for this token, it
371         //  requires that the `parentToken.totalSupplyAt` be queried at the
372         //  genesis block for this token as that contains totalSupply of this
373         //  token at this block number.
374         if ((totalSupplyHistory.length == 0)
375             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
376             if (address(parentToken) != 0) {
377                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
378             } else {
379                 return 0;
380             }
381 
382         // This will return the expected totalSupply during normal situations
383         } else {
384             return getValueAt(totalSupplyHistory, _blockNumber);
385         }
386     }
387 
388 ////////////////
389 // Clone Token Method
390 ////////////////
391 
392     /// @notice Creates a new clone token with the initial distribution being
393     ///  this token at `_snapshotBlock`
394     /// @param _cloneTokenName Name of the clone token
395     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
396     /// @param _cloneTokenSymbol Symbol of the clone token
397     /// @param _snapshotBlock Block when the distribution of the parent token is
398     ///  copied to set the initial distribution of the new clone token;
399     ///  if the block is zero than the actual block, the current block is used
400     /// @param _transfersEnabled True if transfers are allowed in the clone
401     /// @return The address of the new MiniMeToken Contract
402     function createCloneToken(
403         string _cloneTokenName,
404         uint8 _cloneDecimalUnits,
405         string _cloneTokenSymbol,
406         uint _snapshotBlock,
407         bool _transfersEnabled
408         ) public returns(address) {
409         if (_snapshotBlock == 0) _snapshotBlock = block.number;
410         MiniMeToken cloneToken = tokenFactory.createCloneToken(
411             this,
412             _snapshotBlock,
413             _cloneTokenName,
414             _cloneDecimalUnits,
415             _cloneTokenSymbol,
416             _transfersEnabled
417             );
418 
419         cloneToken.changeController(msg.sender);
420 
421         // An event to make the token easy to find on the blockchain
422         NewCloneToken(address(cloneToken), _snapshotBlock);
423         return address(cloneToken);
424     }
425 
426 ////////////////
427 // Generate and destroy tokens
428 ////////////////
429 
430     /// @notice Generates `_amount` tokens that are assigned to `_owner`
431     /// @param _owner The address that will be assigned the new tokens
432     /// @param _amount The quantity of tokens generated
433     /// @return True if the tokens are generated correctly
434     function generateTokens(address _owner, uint _amount
435     ) public onlyController returns (bool) {
436         uint curTotalSupply = totalSupply();
437         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
438         uint previousBalanceTo = balanceOf(_owner);
439         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
440         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
441         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
442         Transfer(0, _owner, _amount);
443         return true;
444     }
445 
446 
447     /// @notice Burns `_amount` tokens from `_owner`
448     /// @param _owner The address that will lose the tokens
449     /// @param _amount The quantity of tokens to burn
450     /// @return True if the tokens are burned correctly
451     function destroyTokens(address _owner, uint _amount
452     ) onlyController public returns (bool) {
453         uint curTotalSupply = totalSupply();
454         require(curTotalSupply >= _amount);
455         uint previousBalanceFrom = balanceOf(_owner);
456         require(previousBalanceFrom >= _amount);
457         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
458         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
459         Transfer(_owner, 0, _amount);
460         return true;
461     }
462 
463 ////////////////
464 // Enable tokens transfers
465 ////////////////
466 
467 
468     /// @notice Enables token holders to transfer their tokens freely if true
469     /// @param _transfersEnabled True if transfers are allowed in the clone
470     function enableTransfers(bool _transfersEnabled) public onlyController {
471         transfersEnabled = _transfersEnabled;
472     }
473 
474 ////////////////
475 // Internal helper functions to query and set a value in a snapshot array
476 ////////////////
477 
478     /// @dev `getValueAt` retrieves the number of tokens at a given block number
479     /// @param checkpoints The history of values being queried
480     /// @param _block The block number to retrieve the value at
481     /// @return The number of tokens being queried
482     function getValueAt(Checkpoint[] storage checkpoints, uint _block
483     ) constant internal returns (uint) {
484         if (checkpoints.length == 0) return 0;
485 
486         // Shortcut for the actual value
487         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
488             return checkpoints[checkpoints.length-1].value;
489         if (_block < checkpoints[0].fromBlock) return 0;
490 
491         // Binary search of the value in the array
492         uint min = 0;
493         uint max = checkpoints.length-1;
494         while (max > min) {
495             uint mid = (max + min + 1)/ 2;
496             if (checkpoints[mid].fromBlock<=_block) {
497                 min = mid;
498             } else {
499                 max = mid-1;
500             }
501         }
502         return checkpoints[min].value;
503     }
504 
505     /// @dev `updateValueAtNow` used to update the `balances` map and the
506     ///  `totalSupplyHistory`
507     /// @param checkpoints The history of data being updated
508     /// @param _value The new number of tokens
509     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
510     ) internal  {
511         if ((checkpoints.length == 0)
512         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
513                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
514                newCheckPoint.fromBlock =  uint128(block.number);
515                newCheckPoint.value = uint128(_value);
516            } else {
517                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
518                oldCheckPoint.value = uint128(_value);
519            }
520     }
521 
522     /// @dev Internal function to determine if an address is a contract
523     /// @param _addr The address being queried
524     /// @return True if `_addr` is a contract
525     function isContract(address _addr) constant internal returns(bool) {
526         uint size;
527         if (_addr == 0) return false;
528         assembly {
529             size := extcodesize(_addr)
530         }
531         return size>0;
532     }
533 
534     /// @dev Helper function to return a min betwen the two uints
535     function min(uint a, uint b) pure internal returns (uint) {
536         return a < b ? a : b;
537     }
538 
539     /// @notice The fallback function: If the contract's controller has not been
540     ///  set to 0, then the `proxyPayment` method is called which relays the
541     ///  ether and creates tokens as described in the token controller contract
542     function () public payable {
543         require(isContract(controller));
544         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
545     }
546 
547 //////////
548 // Safety Methods
549 //////////
550 
551     /// @notice This method can be used by the controller to extract mistakenly
552     ///  sent tokens to this contract.
553     /// @param _token The address of the token contract that you want to recover
554     ///  set to 0 in case you want to extract ether.
555     function claimTokens(address _token) public onlyController {
556         if (_token == 0x0) {
557             controller.transfer(this.balance);
558             return;
559         }
560 
561         MiniMeToken token = MiniMeToken(_token);
562         uint balance = token.balanceOf(this);
563         token.transfer(controller, balance);
564         ClaimedTokens(_token, controller, balance);
565     }
566 
567 ////////////////
568 // Events
569 ////////////////
570     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
571     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
572     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
573     event Approval(
574         address indexed _owner,
575         address indexed _spender,
576         uint256 _amount
577         );
578 
579 }
580 
581 
582 ////////////////
583 // MiniMeTokenFactory
584 ////////////////
585 
586 /// @dev This contract is used to generate clone contracts from a contract.
587 ///  In solidity this is the way to create a contract from a contract of the
588 ///  same class
589 contract MiniMeTokenFactory {
590 
591     /// @notice Update the DApp by creating a new token with new functionalities
592     ///  the msg.sender becomes the controller of this clone token
593     /// @param _parentToken Address of the token being cloned
594     /// @param _snapshotBlock Block of the parent token that will
595     ///  determine the initial distribution of the clone token
596     /// @param _tokenName Name of the new token
597     /// @param _decimalUnits Number of decimals of the new token
598     /// @param _tokenSymbol Token Symbol for the new token
599     /// @param _transfersEnabled If true, tokens will be able to be transferred
600     /// @return The address of the new token contract
601     function createCloneToken(
602         address _parentToken,
603         uint _snapshotBlock,
604         string _tokenName,
605         uint8 _decimalUnits,
606         string _tokenSymbol,
607         bool _transfersEnabled
608     ) public returns (MiniMeToken) {
609         MiniMeToken newToken = new MiniMeToken(
610             this,
611             _parentToken,
612             _snapshotBlock,
613             _tokenName,
614             _decimalUnits,
615             _tokenSymbol,
616             _transfersEnabled
617             );
618 
619         newToken.changeController(msg.sender);
620         return newToken;
621     }
622 }
623 
624 
625 contract INT is MiniMeToken {
626     // @dev INT constructor hard-codes parameters sent to MiniMeToken constructor
627     function INT(
628     address _tokenFactory
629   ) MiniMeToken(
630     _tokenFactory,
631     0x0,                    // no parent token
632     0,                      // no snapshot block number from parent
633     "Intellikon Token",     // Token name
634     18,                     // Decimals
635     "INT",                  // Symbol
636     false                    // Enable transfers
637     ) {}
638 }