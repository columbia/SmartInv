1 /**
2 * Commit sha: 1d5251fc88eee5024ff318d95bc9f4c5de130430
3 * GitHub repository: https://github.com/aragon/minime
4 * Tool used for the deploy: https://github.com/aragon/aragon-network-deploy
5 **/
6 
7 // File: ../minime/contracts/ITokenController.sol
8 
9 pragma solidity ^0.4.24;
10 
11 /// @dev The token controller contract must implement these functions
12 
13 
14 interface ITokenController {
15     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
16     /// @param _owner The address that sent the ether to create tokens
17     /// @return True if the ether is accepted, false if it throws
18     function proxyPayment(address _owner) external payable returns(bool);
19 
20     /// @notice Notifies the controller about a token transfer allowing the
21     ///  controller to react if desired
22     /// @param _from The origin of the transfer
23     /// @param _to The destination of the transfer
24     /// @param _amount The amount of the transfer
25     /// @return False if the controller does not authorize the transfer
26     function onTransfer(address _from, address _to, uint _amount) external returns(bool);
27 
28     /// @notice Notifies the controller about an approval allowing the
29     ///  controller to react if desired
30     /// @param _owner The address that calls `approve()`
31     /// @param _spender The spender in the `approve()` call
32     /// @param _amount The amount in the `approve()` call
33     /// @return False if the controller does not authorize the approval
34     function onApprove(address _owner, address _spender, uint _amount) external returns(bool);
35 }
36 
37 // File: ../minime/contracts/MiniMeToken.sol
38 
39 pragma solidity ^0.4.24;
40 
41 /*
42     Copyright 2016, Jordi Baylina
43     This program is free software: you can redistribute it and/or modify
44     it under the terms of the GNU General Public License as published by
45     the Free Software Foundation, either version 3 of the License, or
46     (at your option) any later version.
47     This program is distributed in the hope that it will be useful,
48     but WITHOUT ANY WARRANTY; without even the implied warranty of
49     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
50     GNU General Public License for more details.
51     You should have received a copy of the GNU General Public License
52     along with this program.  If not, see <http://www.gnu.org/licenses/>.
53  */
54 
55 /// @title MiniMeToken Contract
56 /// @author Jordi Baylina
57 /// @dev This token contract's goal is to make it easy for anyone to clone this
58 ///  token using the token distribution at a given block, this will allow DAO's
59 ///  and DApps to upgrade their features in a decentralized manner without
60 ///  affecting the original token
61 /// @dev It is ERC20 compliant, but still needs to under go further testing.
62 
63 
64 contract Controlled {
65     /// @notice The address of the controller is the only address that can call
66     ///  a function with this modifier
67     modifier onlyController {
68         require(msg.sender == controller);
69         _;
70     }
71 
72     address public controller;
73 
74     function Controlled()  public { controller = msg.sender;}
75 
76     /// @notice Changes the controller of the contract
77     /// @param _newController The new controller of the contract
78     function changeController(address _newController) onlyController  public {
79         controller = _newController;
80     }
81 }
82 
83 contract ApproveAndCallFallBack {
84     function receiveApproval(
85         address from,
86         uint256 _amount,
87         address _token,
88         bytes _data
89     ) public;
90 }
91 
92 /// @dev The actual token contract, the default controller is the msg.sender
93 ///  that deploys the contract, so usually this token will be deployed by a
94 ///  token controller contract, which Giveth will call a "Campaign"
95 contract MiniMeToken is Controlled {
96 
97     string public name;                //The Token's name: e.g. DigixDAO Tokens
98     uint8 public decimals;             //Number of decimals of the smallest unit
99     string public symbol;              //An identifier: e.g. REP
100     string public version = "MMT_0.1"; //An arbitrary versioning scheme
101 
102 
103     /// @dev `Checkpoint` is the structure that attaches a block number to a
104     ///  given value, the block number attached is the one that last changed the
105     ///  value
106     struct Checkpoint {
107 
108         // `fromBlock` is the block number that the value was generated from
109         uint128 fromBlock;
110 
111         // `value` is the amount of tokens at a specific block number
112         uint128 value;
113     }
114 
115     // `parentToken` is the Token address that was cloned to produce this token;
116     //  it will be 0x0 for a token that was not cloned
117     MiniMeToken public parentToken;
118 
119     // `parentSnapShotBlock` is the block number from the Parent Token that was
120     //  used to determine the initial distribution of the Clone Token
121     uint public parentSnapShotBlock;
122 
123     // `creationBlock` is the block number that the Clone Token was created
124     uint public creationBlock;
125 
126     // `balances` is the map that tracks the balance of each address, in this
127     //  contract when the balance changes the block number that the change
128     //  occurred is also included in the map
129     mapping (address => Checkpoint[]) balances;
130 
131     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
132     mapping (address => mapping (address => uint256)) allowed;
133 
134     // Tracks the history of the `totalSupply` of the token
135     Checkpoint[] totalSupplyHistory;
136 
137     // Flag that determines if the token is transferable or not.
138     bool public transfersEnabled;
139 
140     // The factory used to create new clone tokens
141     MiniMeTokenFactory public tokenFactory;
142 
143 ////////////////
144 // Constructor
145 ////////////////
146 
147     /// @notice Constructor to create a MiniMeToken
148     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
149     ///  will create the Clone token contracts, the token factory needs to be
150     ///  deployed first
151     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
152     ///  new token
153     /// @param _parentSnapShotBlock Block of the parent token that will
154     ///  determine the initial distribution of the clone token, set to 0 if it
155     ///  is a new token
156     /// @param _tokenName Name of the new token
157     /// @param _decimalUnits Number of decimals of the new token
158     /// @param _tokenSymbol Token Symbol for the new token
159     /// @param _transfersEnabled If true, tokens will be able to be transferred
160     function MiniMeToken(
161         MiniMeTokenFactory _tokenFactory,
162         MiniMeToken _parentToken,
163         uint _parentSnapShotBlock,
164         string _tokenName,
165         uint8 _decimalUnits,
166         string _tokenSymbol,
167         bool _transfersEnabled
168     )  public
169     {
170         tokenFactory = _tokenFactory;
171         name = _tokenName;                                 // Set the name
172         decimals = _decimalUnits;                          // Set the decimals
173         symbol = _tokenSymbol;                             // Set the symbol
174         parentToken = _parentToken;
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
191         return doTransfer(msg.sender, _to, _amount);
192     }
193 
194     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
195     ///  is approved by `_from`
196     /// @param _from The address holding the tokens being transferred
197     /// @param _to The address of the recipient
198     /// @param _amount The amount of tokens to be transferred
199     /// @return True if the transfer was successful
200     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
201 
202         // The controller of this contract can move tokens around at will,
203         //  this is important to recognize! Confirm that you trust the
204         //  controller of this contract, which in most situations should be
205         //  another open source smart contract or 0x0
206         if (msg.sender != controller) {
207             require(transfersEnabled);
208 
209             // The standard ERC 20 transferFrom functionality
210             if (allowed[_from][msg.sender] < _amount)
211                 return false;
212             allowed[_from][msg.sender] -= _amount;
213         }
214         return doTransfer(_from, _to, _amount);
215     }
216 
217     /// @dev This is the actual transfer function in the token contract, it can
218     ///  only be called by other functions in this contract.
219     /// @param _from The address holding the tokens being transferred
220     /// @param _to The address of the recipient
221     /// @param _amount The amount of tokens to be transferred
222     /// @return True if the transfer was successful
223     function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
224         if (_amount == 0) {
225             return true;
226         }
227         require(parentSnapShotBlock < block.number);
228         // Do not allow transfer to 0x0 or the token contract itself
229         require((_to != 0) && (_to != address(this)));
230         // If the amount being transfered is more than the balance of the
231         //  account the transfer returns false
232         var previousBalanceFrom = balanceOfAt(_from, block.number);
233         if (previousBalanceFrom < _amount) {
234             return false;
235         }
236         // Alerts the token controller of the transfer
237         if (isContract(controller)) {
238             // Adding the ` == true` makes the linter shut up so...
239             require(ITokenController(controller).onTransfer(_from, _to, _amount) == true);
240         }
241         // First update the balance array with the new value for the address
242         //  sending the tokens
243         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
244         // Then update the balance array with the new value for the address
245         //  receiving the tokens
246         var previousBalanceTo = balanceOfAt(_to, block.number);
247         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
248         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
249         // An event to make the transfer easy to find on the blockchain
250         Transfer(_from, _to, _amount);
251         return true;
252     }
253 
254     /// @param _owner The address that's balance is being requested
255     /// @return The balance of `_owner` at the current block
256     function balanceOf(address _owner) public constant returns (uint256 balance) {
257         return balanceOfAt(_owner, block.number);
258     }
259 
260     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
261     ///  its behalf. This is a modified version of the ERC20 approve function
262     ///  to be a little bit safer
263     /// @param _spender The address of the account able to transfer the tokens
264     /// @param _amount The amount of tokens to be approved for transfer
265     /// @return True if the approval was successful
266     function approve(address _spender, uint256 _amount) public returns (bool success) {
267         require(transfersEnabled);
268 
269         // To change the approve amount you first have to reduce the addresses`
270         //  allowance to zero by calling `approve(_spender,0)` if it is not
271         //  already 0 to mitigate the race condition described here:
272         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
273         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
274 
275         // Alerts the token controller of the approve function call
276         if (isContract(controller)) {
277             // Adding the ` == true` makes the linter shut up so...
278             require(ITokenController(controller).onApprove(msg.sender, _spender, _amount) == true);
279         }
280 
281         allowed[msg.sender][_spender] = _amount;
282         Approval(msg.sender, _spender, _amount);
283         return true;
284     }
285 
286     /// @dev This function makes it easy to read the `allowed[]` map
287     /// @param _owner The address of the account that owns the token
288     /// @param _spender The address of the account able to transfer the tokens
289     /// @return Amount of remaining tokens of _owner that _spender is allowed
290     ///  to spend
291     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
292         return allowed[_owner][_spender];
293     }
294 
295     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
296     ///  its behalf, and then a function is triggered in the contract that is
297     ///  being approved, `_spender`. This allows users to use their tokens to
298     ///  interact with contracts in one function call instead of two
299     /// @param _spender The address of the contract able to transfer the tokens
300     /// @param _amount The amount of tokens to be approved for transfer
301     /// @return True if the function call was successful
302     function approveAndCall(ApproveAndCallFallBack _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
303         require(approve(_spender, _amount));
304 
305         _spender.receiveApproval(
306             msg.sender,
307             _amount,
308             this,
309             _extraData
310         );
311 
312         return true;
313     }
314 
315     /// @dev This function makes it easy to get the total number of tokens
316     /// @return The total number of tokens
317     function totalSupply() public constant returns (uint) {
318         return totalSupplyAt(block.number);
319     }
320 
321 
322 ////////////////
323 // Query balance and totalSupply in History
324 ////////////////
325 
326     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
327     /// @param _owner The address from which the balance will be retrieved
328     /// @param _blockNumber The block number when the balance is queried
329     /// @return The balance at `_blockNumber`
330     function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
331 
332         // These next few lines are used when the balance of the token is
333         //  requested before a check point was ever created for this token, it
334         //  requires that the `parentToken.balanceOfAt` be queried at the
335         //  genesis block for that token as this contains initial balance of
336         //  this token
337         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
338             if (address(parentToken) != 0) {
339                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
340             } else {
341                 // Has no parent
342                 return 0;
343             }
344 
345         // This will return the expected balance during normal situations
346         } else {
347             return getValueAt(balances[_owner], _blockNumber);
348         }
349     }
350 
351     /// @notice Total amount of tokens at a specific `_blockNumber`.
352     /// @param _blockNumber The block number when the totalSupply is queried
353     /// @return The total amount of tokens at `_blockNumber`
354     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
355 
356         // These next few lines are used when the totalSupply of the token is
357         //  requested before a check point was ever created for this token, it
358         //  requires that the `parentToken.totalSupplyAt` be queried at the
359         //  genesis block for this token as that contains totalSupply of this
360         //  token at this block number.
361         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
362             if (address(parentToken) != 0) {
363                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
364             } else {
365                 return 0;
366             }
367 
368         // This will return the expected totalSupply during normal situations
369         } else {
370             return getValueAt(totalSupplyHistory, _blockNumber);
371         }
372     }
373 
374 ////////////////
375 // Clone Token Method
376 ////////////////
377 
378     /// @notice Creates a new clone token with the initial distribution being
379     ///  this token at `_snapshotBlock`
380     /// @param _cloneTokenName Name of the clone token
381     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
382     /// @param _cloneTokenSymbol Symbol of the clone token
383     /// @param _snapshotBlock Block when the distribution of the parent token is
384     ///  copied to set the initial distribution of the new clone token;
385     ///  if the block is zero than the actual block, the current block is used
386     /// @param _transfersEnabled True if transfers are allowed in the clone
387     /// @return The address of the new MiniMeToken Contract
388     function createCloneToken(
389         string _cloneTokenName,
390         uint8 _cloneDecimalUnits,
391         string _cloneTokenSymbol,
392         uint _snapshotBlock,
393         bool _transfersEnabled
394     ) public returns(MiniMeToken)
395     {
396         uint256 snapshot = _snapshotBlock == 0 ? block.number - 1 : _snapshotBlock;
397 
398         MiniMeToken cloneToken = tokenFactory.createCloneToken(
399             this,
400             snapshot,
401             _cloneTokenName,
402             _cloneDecimalUnits,
403             _cloneTokenSymbol,
404             _transfersEnabled
405         );
406 
407         cloneToken.changeController(msg.sender);
408 
409         // An event to make the token easy to find on the blockchain
410         NewCloneToken(address(cloneToken), snapshot);
411         return cloneToken;
412     }
413 
414 ////////////////
415 // Generate and destroy tokens
416 ////////////////
417 
418     /// @notice Generates `_amount` tokens that are assigned to `_owner`
419     /// @param _owner The address that will be assigned the new tokens
420     /// @param _amount The quantity of tokens generated
421     /// @return True if the tokens are generated correctly
422     function generateTokens(address _owner, uint _amount) onlyController public returns (bool) {
423         uint curTotalSupply = totalSupply();
424         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
425         uint previousBalanceTo = balanceOf(_owner);
426         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
427         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
428         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
429         Transfer(0, _owner, _amount);
430         return true;
431     }
432 
433 
434     /// @notice Burns `_amount` tokens from `_owner`
435     /// @param _owner The address that will lose the tokens
436     /// @param _amount The quantity of tokens to burn
437     /// @return True if the tokens are burned correctly
438     function destroyTokens(address _owner, uint _amount) onlyController public returns (bool) {
439         uint curTotalSupply = totalSupply();
440         require(curTotalSupply >= _amount);
441         uint previousBalanceFrom = balanceOf(_owner);
442         require(previousBalanceFrom >= _amount);
443         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
444         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
445         Transfer(_owner, 0, _amount);
446         return true;
447     }
448 
449 ////////////////
450 // Enable tokens transfers
451 ////////////////
452 
453 
454     /// @notice Enables token holders to transfer their tokens freely if true
455     /// @param _transfersEnabled True if transfers are allowed in the clone
456     function enableTransfers(bool _transfersEnabled) onlyController public {
457         transfersEnabled = _transfersEnabled;
458     }
459 
460 ////////////////
461 // Internal helper functions to query and set a value in a snapshot array
462 ////////////////
463 
464     /// @dev `getValueAt` retrieves the number of tokens at a given block number
465     /// @param checkpoints The history of values being queried
466     /// @param _block The block number to retrieve the value at
467     /// @return The number of tokens being queried
468     function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
469         if (checkpoints.length == 0)
470             return 0;
471 
472         // Shortcut for the actual value
473         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
474             return checkpoints[checkpoints.length-1].value;
475         if (_block < checkpoints[0].fromBlock)
476             return 0;
477 
478         // Binary search of the value in the array
479         uint min = 0;
480         uint max = checkpoints.length-1;
481         while (max > min) {
482             uint mid = (max + min + 1) / 2;
483             if (checkpoints[mid].fromBlock<=_block) {
484                 min = mid;
485             } else {
486                 max = mid-1;
487             }
488         }
489         return checkpoints[min].value;
490     }
491 
492     /// @dev `updateValueAtNow` used to update the `balances` map and the
493     ///  `totalSupplyHistory`
494     /// @param checkpoints The history of data being updated
495     /// @param _value The new number of tokens
496     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
497         require(_value <= uint128(-1));
498 
499         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
500             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
501             newCheckPoint.fromBlock = uint128(block.number);
502             newCheckPoint.value = uint128(_value);
503         } else {
504             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length - 1];
505             oldCheckPoint.value = uint128(_value);
506         }
507     }
508 
509     /// @dev Internal function to determine if an address is a contract
510     /// @param _addr The address being queried
511     /// @return True if `_addr` is a contract
512     function isContract(address _addr) constant internal returns(bool) {
513         uint size;
514         if (_addr == 0)
515             return false;
516 
517         assembly {
518             size := extcodesize(_addr)
519         }
520 
521         return size>0;
522     }
523 
524     /// @dev Helper function to return a min betwen the two uints
525     function min(uint a, uint b) pure internal returns (uint) {
526         return a < b ? a : b;
527     }
528 
529     /// @notice The fallback function: If the contract's controller has not been
530     ///  set to 0, then the `proxyPayment` method is called which relays the
531     ///  ether and creates tokens as described in the token controller contract
532     function () external payable {
533         require(isContract(controller));
534         // Adding the ` == true` makes the linter shut up so...
535         require(ITokenController(controller).proxyPayment.value(msg.value)(msg.sender) == true);
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
546     function claimTokens(address _token) onlyController public {
547         if (_token == 0x0) {
548             controller.transfer(this.balance);
549             return;
550         }
551 
552         MiniMeToken token = MiniMeToken(_token);
553         uint balance = token.balanceOf(this);
554         token.transfer(controller, balance);
555         ClaimedTokens(_token, controller, balance);
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
581     event NewFactoryCloneToken(address indexed _cloneToken, address indexed _parentToken, uint _snapshotBlock);
582 
583     /// @notice Update the DApp by creating a new token with new functionalities
584     ///  the msg.sender becomes the controller of this clone token
585     /// @param _parentToken Address of the token being cloned
586     /// @param _snapshotBlock Block of the parent token that will
587     ///  determine the initial distribution of the clone token
588     /// @param _tokenName Name of the new token
589     /// @param _decimalUnits Number of decimals of the new token
590     /// @param _tokenSymbol Token Symbol for the new token
591     /// @param _transfersEnabled If true, tokens will be able to be transferred
592     /// @return The address of the new token contract
593     function createCloneToken(
594         MiniMeToken _parentToken,
595         uint _snapshotBlock,
596         string _tokenName,
597         uint8 _decimalUnits,
598         string _tokenSymbol,
599         bool _transfersEnabled
600     ) public returns (MiniMeToken)
601     {
602         MiniMeToken newToken = new MiniMeToken(
603             this,
604             _parentToken,
605             _snapshotBlock,
606             _tokenName,
607             _decimalUnits,
608             _tokenSymbol,
609             _transfersEnabled
610         );
611 
612         newToken.changeController(msg.sender);
613         NewFactoryCloneToken(address(newToken), address(_parentToken), _snapshotBlock);
614         return newToken;
615     }
616 }
