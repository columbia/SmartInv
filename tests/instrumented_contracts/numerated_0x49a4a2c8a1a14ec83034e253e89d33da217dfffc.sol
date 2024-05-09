1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 
66 /// @dev The token controller contract must implement these functions
67 contract TokenController {
68     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
69     /// @param _owner The address that sent the ether to create tokens
70     /// @return True if the ether is accepted, false if it throws
71     function proxyPayment(address _owner) public payable returns(bool);
72 
73     /// @notice Notifies the controller about a token transfer allowing the
74     ///  controller to react if desired
75     /// @param _from The origin of the transfer
76     /// @param _to The destination of the transfer
77     /// @param _amount The amount of the transfer
78     /// @return False if the controller does not authorize the transfer
79     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
80 
81     /// @notice Notifies the controller about an approval allowing the
82     ///  controller to react if desired
83     /// @param _owner The address that calls `approve()`
84     /// @param _spender The spender in the `approve()` call
85     /// @param _amount The amount in the `approve()` call
86     /// @return False if the controller does not authorize the approval
87     function onApprove(address _owner, address _spender, uint _amount) public
88         returns(bool);
89 }
90 
91 /*
92     Copyright 2016, Jordi Baylina
93 
94     This program is free software: you can redistribute it and/or modify
95     it under the terms of the GNU General Public License as published by
96     the Free Software Foundation, either version 3 of the License, or
97     (at your option) any later version.
98 
99     This program is distributed in the hope that it will be useful,
100     but WITHOUT ANY WARRANTY; without even the implied warranty of
101     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
102     GNU General Public License for more details.
103 
104     You should have received a copy of the GNU General Public License
105     along with this program.  If not, see <http://www.gnu.org/licenses/>.
106  */
107 
108 /// @title MiniMeToken Contract
109 /// @author Jordi Baylina
110 /// @dev This token contract's goal is to make it easy for anyone to clone this
111 ///  token using the token distribution at a given block, this will allow DAO's
112 ///  and DApps to upgrade their features in a decentralized manner without
113 ///  affecting the original token
114 /// @dev It is ERC20 compliant, but still needs to under go further testing.
115 
116 contract ApproveAndCallFallBack {
117     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
118 }
119 
120 /// @dev The actual token contract, the default owner is the msg.sender
121 ///  that deploys the contract, so usually this token will be deployed by a
122 ///  token owner contract, which Giveth will call a "Campaign"
123 contract MiniMeToken is Ownable {
124 
125     string public name;                //The Token's name: e.g. DigixDAO Tokens
126     uint8 public decimals;             //Number of decimals of the smallest unit
127     string public symbol;              //An identifier: e.g. REP
128     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
129 
130 
131     /// @dev `Checkpoint` is the structure that attaches a block number to a
132     ///  given value, the block number attached is the one that last changed the
133     ///  value
134     struct  Checkpoint {
135 
136         // `fromBlock` is the block number that the value was generated from
137         uint128 fromBlock;
138 
139         // `value` is the amount of tokens at a specific block number
140         uint128 value;
141     }
142 
143     // `parentToken` is the Token address that was cloned to produce this token;
144     //  it will be 0x0 for a token that was not cloned
145     MiniMeToken public parentToken;
146 
147     // `parentSnapShotBlock` is the block number from the Parent Token that was
148     //  used to determine the initial distribution of the Clone Token
149     uint public parentSnapShotBlock;
150 
151     // `creationBlock` is the block number that the Clone Token was created
152     uint public creationBlock;
153 
154     // `balances` is the map that tracks the balance of each address, in this
155     //  contract when the balance changes the block number that the change
156     //  occurred is also included in the map
157     mapping (address => Checkpoint[]) balances;
158 
159     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
160     mapping (address => mapping (address => uint256)) allowed;
161 
162     // Tracks the history of the `totalSupply` of the token
163     Checkpoint[] totalSupplyHistory;
164 
165     // Flag that determines if the token is transferable or not.
166     bool public transfersEnabled;
167 
168     // The factory used to create new clone tokens
169     MiniMeTokenFactory public tokenFactory;
170 
171 ////////////////
172 // Constructor
173 ////////////////
174 
175     /// @notice Constructor to create a MiniMeToken
176     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
177     ///  will create the Clone token contracts, the token factory needs to be
178     ///  deployed first
179     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
180     ///  new token
181     /// @param _parentSnapShotBlock Block of the parent token that will
182     ///  determine the initial distribution of the clone token, set to 0 if it
183     ///  is a new token
184     /// @param _tokenName Name of the new token
185     /// @param _decimalUnits Number of decimals of the new token
186     /// @param _tokenSymbol Token Symbol for the new token
187     /// @param _transfersEnabled If true, tokens will be able to be transferred
188     constructor(
189         address _tokenFactory,
190         address _parentToken,
191         uint _parentSnapShotBlock,
192         string _tokenName,
193         uint8 _decimalUnits,
194         string _tokenSymbol,
195         bool _transfersEnabled
196     ) public {
197         tokenFactory = MiniMeTokenFactory(_tokenFactory);
198         name = _tokenName;                                 // Set the name
199         decimals = _decimalUnits;                          // Set the decimals
200         symbol = _tokenSymbol;                             // Set the symbol
201         parentToken = MiniMeToken(_parentToken);
202         parentSnapShotBlock = _parentSnapShotBlock;
203         transfersEnabled = _transfersEnabled;
204         creationBlock = block.number;
205     }
206 
207 
208 ///////////////////
209 // ERC20 Methods
210 ///////////////////
211 
212     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
213     /// @param _to The address of the recipient
214     /// @param _amount The amount of tokens to be transferred
215     /// @return Whether the transfer was successful or not
216     function transfer(address _to, uint256 _amount) public returns (bool success) {
217         require(transfersEnabled);
218         doTransfer(msg.sender, _to, _amount);
219         return true;
220     }
221 
222     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
223     ///  is approved by `_from`
224     /// @param _from The address holding the tokens being transferred
225     /// @param _to The address of the recipient
226     /// @param _amount The amount of tokens to be transferred
227     /// @return True if the transfer was successful
228     function transferFrom(address _from, address _to, uint256 _amount
229     ) public returns (bool success) {
230 
231         // The owner of this contract can move tokens around at will,
232         //  this is important to recognize! Confirm that you trust the
233         //  owner of this contract, which in most situations should be
234         //  another open source smart contract or 0x0
235         if (msg.sender != owner) {
236             require(transfersEnabled);
237 
238             // The standard ERC 20 transferFrom functionality
239             require(allowed[_from][msg.sender] >= _amount);
240             allowed[_from][msg.sender] -= _amount;
241         }
242         doTransfer(_from, _to, _amount);
243         return true;
244     }
245 
246     /// @dev This is the actual transfer function in the token contract, it can
247     ///  only be called by other functions in this contract.
248     /// @param _from The address holding the tokens being transferred
249     /// @param _to The address of the recipient
250     /// @param _amount The amount of tokens to be transferred
251     /// @return True if the transfer was successful
252     function doTransfer(address _from, address _to, uint _amount
253     ) internal {
254 
255            if (_amount == 0) {
256                emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
257                return;
258            }
259 
260            require(parentSnapShotBlock < block.number);
261 
262            // Do not allow transfer to 0x0 or the token contract itself
263            require((_to != 0) && (_to != address(this)));
264 
265            // If the amount being transfered is more than the balance of the
266            //  account the transfer throws
267            uint previousBalanceFrom = balanceOfAt(_from, block.number);
268 
269            require(previousBalanceFrom >= _amount);
270 
271            // Alerts the token owner of the transfer
272            if (isContract(owner)) {
273                require(TokenController(owner).onTransfer(_from, _to, _amount));
274            }
275 
276            // First update the balance array with the new value for the address
277            //  sending the tokens
278            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
279 
280            // Then update the balance array with the new value for the address
281            //  receiving the tokens
282            uint previousBalanceTo = balanceOfAt(_to, block.number);
283            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
284            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
285 
286            // An event to make the transfer easy to find on the blockchain
287            emit Transfer(_from, _to, _amount);
288 
289     }
290 
291     /// @param _owner The address that's balance is being requested
292     /// @return The balance of `_owner` at the current block
293     function balanceOf(address _owner) public constant returns (uint256 balance) {
294         return balanceOfAt(_owner, block.number);
295     }
296 
297     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
298     ///  its behalf. This is a modified version of the ERC20 approve function
299     ///  to be a little bit safer
300     /// @param _spender The address of the account able to transfer the tokens
301     /// @param _amount The amount of tokens to be approved for transfer
302     /// @return True if the approval was successful
303     function approve(address _spender, uint256 _amount) public returns (bool success) {
304         require(transfersEnabled);
305 
306         // To change the approve amount you first have to reduce the addresses`
307         //  allowance to zero by calling `approve(_spender,0)` if it is not
308         //  already 0 to mitigate the race condition described here:
309         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
310         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
311 
312         // Alerts the token owner of the approve function call
313         if (isContract(owner)) {
314             require(TokenController(owner).onApprove(msg.sender, _spender, _amount));
315         }
316 
317         allowed[msg.sender][_spender] = _amount;
318         emit Approval(msg.sender, _spender, _amount);
319         return true;
320     }
321 
322     /// @dev This function makes it easy to read the `allowed[]` map
323     /// @param _owner The address of the account that owns the token
324     /// @param _spender The address of the account able to transfer the tokens
325     /// @return Amount of remaining tokens of _owner that _spender is allowed
326     ///  to spend
327     function allowance(address _owner, address _spender
328     ) public constant returns (uint256 remaining) {
329         return allowed[_owner][_spender];
330     }
331 
332     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
333     ///  its behalf, and then a function is triggered in the contract that is
334     ///  being approved, `_spender`. This allows users to use their tokens to
335     ///  interact with contracts in one function call instead of two
336     /// @param _spender The address of the contract able to transfer the tokens
337     /// @param _amount The amount of tokens to be approved for transfer
338     /// @return True if the function call was successful
339     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
340     ) public returns (bool success) {
341         require(approve(_spender, _amount));
342 
343         ApproveAndCallFallBack(_spender).receiveApproval(
344             msg.sender,
345             _amount,
346             this,
347             _extraData
348         );
349 
350         return true;
351     }
352 
353     /// @dev This function makes it easy to get the total number of tokens
354     /// @return The total number of tokens
355     function totalSupply() public constant returns (uint) {
356         return totalSupplyAt(block.number);
357     }
358 
359 
360 ////////////////
361 // Query balance and totalSupply in History
362 ////////////////
363 
364     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
365     /// @param _owner The address from which the balance will be retrieved
366     /// @param _blockNumber The block number when the balance is queried
367     /// @return The balance at `_blockNumber`
368     function balanceOfAt(address _owner, uint _blockNumber) public constant
369         returns (uint) {
370 
371         // These next few lines are used when the balance of the token is
372         //  requested before a check point was ever created for this token, it
373         //  requires that the `parentToken.balanceOfAt` be queried at the
374         //  genesis block for that token as this contains initial balance of
375         //  this token
376         if ((balances[_owner].length == 0)
377             || (balances[_owner][0].fromBlock > _blockNumber)) {
378             if (address(parentToken) != 0) {
379                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
380             } else {
381                 // Has no parent
382                 return 0;
383             }
384 
385         // This will return the expected balance during normal situations
386         } else {
387             return getValueAt(balances[_owner], _blockNumber);
388         }
389     }
390 
391     /// @notice Total amount of tokens at a specific `_blockNumber`.
392     /// @param _blockNumber The block number when the totalSupply is queried
393     /// @return The total amount of tokens at `_blockNumber`
394     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
395 
396         // These next few lines are used when the totalSupply of the token is
397         //  requested before a check point was ever created for this token, it
398         //  requires that the `parentToken.totalSupplyAt` be queried at the
399         //  genesis block for this token as that contains totalSupply of this
400         //  token at this block number.
401         if ((totalSupplyHistory.length == 0)
402             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
403             if (address(parentToken) != 0) {
404                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
405             } else {
406                 return 0;
407             }
408 
409         // This will return the expected totalSupply during normal situations
410         } else {
411             return getValueAt(totalSupplyHistory, _blockNumber);
412         }
413     }
414 
415 ////////////////
416 // Clone Token Method
417 ////////////////
418 
419     /// @notice Creates a new clone token with the initial distribution being
420     ///  this token at `_snapshotBlock`
421     /// @param _cloneTokenName Name of the clone token
422     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
423     /// @param _cloneTokenSymbol Symbol of the clone token
424     /// @param _snapshotBlock Block when the distribution of the parent token is
425     ///  copied to set the initial distribution of the new clone token;
426     ///  if the block is zero than the actual block, the current block is used
427     /// @param _transfersEnabled True if transfers are allowed in the clone
428     /// @return The address of the new MiniMeToken Contract
429     function createCloneToken(
430         string _cloneTokenName,
431         uint8 _cloneDecimalUnits,
432         string _cloneTokenSymbol,
433         uint _snapshotBlock,
434         bool _transfersEnabled
435         ) public returns(address) {
436         if (_snapshotBlock == 0) _snapshotBlock = block.number;
437         MiniMeToken cloneToken = tokenFactory.createCloneToken(
438             this,
439             _snapshotBlock,
440             _cloneTokenName,
441             _cloneDecimalUnits,
442             _cloneTokenSymbol,
443             _transfersEnabled
444             );
445 
446         cloneToken.transferOwnership(msg.sender);
447 
448         // An event to make the token easy to find on the blockchain
449         emit NewCloneToken(address(cloneToken), _snapshotBlock);
450         return address(cloneToken);
451     }
452 
453 ////////////////
454 // Generate and destroy tokens
455 ////////////////
456 
457     /// @notice Generates `_amount` tokens that are assigned to `_owner`
458     /// @param _owner The address that will be assigned the new tokens
459     /// @param _amount The quantity of tokens generated
460     /// @return True if the tokens are generated correctly
461     function generateTokens(address _owner, uint _amount
462     ) public onlyOwner returns (bool) {
463         uint curTotalSupply = totalSupply();
464         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
465         uint previousBalanceTo = balanceOf(_owner);
466         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
467         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
468         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
469         emit Transfer(0, _owner, _amount);
470         return true;
471     }
472 
473 
474     /// @notice Burns `_amount` tokens from `_owner`
475     /// @param _owner The address that will lose the tokens
476     /// @param _amount The quantity of tokens to burn
477     /// @return True if the tokens are burned correctly
478     function destroyTokens(address _owner, uint _amount
479     ) onlyOwner public returns (bool) {
480         uint curTotalSupply = totalSupply();
481         require(curTotalSupply >= _amount);
482         uint previousBalanceFrom = balanceOf(_owner);
483         require(previousBalanceFrom >= _amount);
484         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
485         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
486         emit Transfer(_owner, 0, _amount);
487         return true;
488     }
489 
490 ////////////////
491 // Enable tokens transfers
492 ////////////////
493 
494 
495     /// @notice Enables token holders to transfer their tokens freely if true
496     /// @param _transfersEnabled True if transfers are allowed in the clone
497     function enableTransfers(bool _transfersEnabled) public onlyOwner {
498         transfersEnabled = _transfersEnabled;
499     }
500 
501 ////////////////
502 // Internal helper functions to query and set a value in a snapshot array
503 ////////////////
504 
505     /// @dev `getValueAt` retrieves the number of tokens at a given block number
506     /// @param checkpoints The history of values being queried
507     /// @param _block The block number to retrieve the value at
508     /// @return The number of tokens being queried
509     function getValueAt(Checkpoint[] storage checkpoints, uint _block
510     ) constant internal returns (uint) {
511         if (checkpoints.length == 0) return 0;
512 
513         // Shortcut for the actual value
514         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
515             return checkpoints[checkpoints.length-1].value;
516         if (_block < checkpoints[0].fromBlock) return 0;
517 
518         // Binary search of the value in the array
519         uint min = 0;
520         uint max = checkpoints.length-1;
521         while (max > min) {
522             uint mid = (max + min + 1)/ 2;
523             if (checkpoints[mid].fromBlock<=_block) {
524                 min = mid;
525             } else {
526                 max = mid-1;
527             }
528         }
529         return checkpoints[min].value;
530     }
531 
532     /// @dev `updateValueAtNow` used to update the `balances` map and the
533     ///  `totalSupplyHistory`
534     /// @param checkpoints The history of data being updated
535     /// @param _value The new number of tokens
536     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
537     ) internal  {
538         if ((checkpoints.length == 0)
539         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
540                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
541                newCheckPoint.fromBlock =  uint128(block.number);
542                newCheckPoint.value = uint128(_value);
543            } else {
544                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
545                oldCheckPoint.value = uint128(_value);
546            }
547     }
548 
549     /// @dev Internal function to determine if an address is a contract
550     /// @param _addr The address being queried
551     /// @return True if `_addr` is a contract
552     function isContract(address _addr) constant internal returns(bool) {
553         uint size;
554         if (_addr == 0) return false;
555         assembly {
556             size := extcodesize(_addr)
557         }
558         return size>0;
559     }
560 
561     /// @dev Helper function to return a min betwen the two uints
562     function min(uint a, uint b) pure internal returns (uint) {
563         return a < b ? a : b;
564     }
565 
566     /// @notice The fallback function: If the contract's owner has not been
567     ///  set to 0, then the `proxyPayment` method is called which relays the
568     ///  ether and creates tokens as described in the token owner contract
569     function () public payable {
570         require(isContract(owner));
571         require(TokenController(owner).proxyPayment.value(msg.value)(msg.sender));
572     }
573 
574 //////////
575 // Safety Methods
576 //////////
577 
578     /// @notice This method can be used by the owner to extract mistakenly
579     ///  sent tokens to this contract.
580     /// @param _token The address of the token contract that you want to recover
581     ///  set to 0 in case you want to extract ether.
582     function claimTokens(address _token) public onlyOwner {
583         if (_token == 0x0) {
584             owner.transfer(address(this).balance);
585             return;
586         }
587 
588         MiniMeToken token = MiniMeToken(_token);
589         uint balance = token.balanceOf(this);
590         token.transfer(owner, balance);
591         emit ClaimedTokens(_token, owner, balance);
592     }
593 
594 ////////////////
595 // Events
596 ////////////////
597     event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
598     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
599     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
600     event Approval(
601         address indexed _owner,
602         address indexed _spender,
603         uint256 _amount
604         );
605 
606 }
607 
608 
609 ////////////////
610 // MiniMeTokenFactory
611 ////////////////
612 
613 /// @dev This contract is used to generate clone contracts from a contract.
614 ///  In solidity this is the way to create a contract from a contract of the
615 ///  same class
616 contract MiniMeTokenFactory {
617     event CreatedToken(string symbol, address addr);
618 
619     /// @notice Update the DApp by creating a new token with new functionalities
620     ///  the msg.sender becomes the owner of this clone token
621     /// @param _parentToken Address of the token being cloned
622     /// @param _snapshotBlock Block of the parent token that will
623     ///  determine the initial distribution of the clone token
624     /// @param _tokenName Name of the new token
625     /// @param _decimalUnits Number of decimals of the new token
626     /// @param _tokenSymbol Token Symbol for the new token
627     /// @param _transfersEnabled If true, tokens will be able to be transferred
628     /// @return The address of the new token contract
629     function createCloneToken(
630         address _parentToken,
631         uint _snapshotBlock,
632         string _tokenName,
633         uint8 _decimalUnits,
634         string _tokenSymbol,
635         bool _transfersEnabled
636     ) public returns (MiniMeToken) {
637         MiniMeToken newToken = new MiniMeToken(
638             this,
639             _parentToken,
640             _snapshotBlock,
641             _tokenName,
642             _decimalUnits,
643             _tokenSymbol,
644             _transfersEnabled
645             );
646 
647         newToken.transferOwnership(msg.sender);
648         emit CreatedToken(_tokenSymbol, address(newToken));
649         return newToken;
650     }
651 }