1 /**
2  *Submitted for verification at Etherscan.io on 2018-10-28
3 */
4 
5 pragma solidity ^0.4.24;
6 // File: @aragon/apps-shared-minime/contracts/ITokenController.sol
7 /// @dev The token controller contract must implement these functions
8 
9 
10 interface ITokenController {
11     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
12     /// @param _owner The address that sent the ether to create tokens
13     /// @return True if the ether is accepted, false if it throws
14     function proxyPayment(address _owner) external payable returns(bool);
15 
16     /// @notice Notifies the controller about a token transfer allowing the
17     ///  controller to react if desired
18     /// @param _from The origin of the transfer
19     /// @param _to The destination of the transfer
20     /// @param _amount The amount of the transfer
21     /// @return False if the controller does not authorize the transfer
22     function onTransfer(address _from, address _to, uint _amount) external returns(bool);
23 
24     /// @notice Notifies the controller about an approval allowing the
25     ///  controller to react if desired
26     /// @param _owner The address that calls `approve()`
27     /// @param _spender The spender in the `approve()` call
28     /// @param _amount The amount in the `approve()` call
29     /// @return False if the controller does not authorize the approval
30     function onApprove(address _owner, address _spender, uint _amount) external returns(bool);
31 }
32 // File: @aragon/apps-shared-minime/contracts/MiniMeToken.sol
33 /*
34     Copyright 2016, Jordi Baylina
35     This program is free software: you can redistribute it and/or modify
36     it under the terms of the GNU General Public License as published by
37     the Free Software Foundation, either version 3 of the License, or
38     (at your option) any later version.
39     This program is distributed in the hope that it will be useful,
40     but WITHOUT ANY WARRANTY; without even the implied warranty of
41     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
42     GNU General Public License for more details.
43     You should have received a copy of the GNU General Public License
44     along with this program.  If not, see <http://www.gnu.org/licenses/>.
45  */
46 
47 /// @title MiniMeToken Contract
48 /// @author Jordi Baylina
49 /// @dev This token contract's goal is to make it easy for anyone to clone this
50 ///  token using the token distribution at a given block, this will allow DAO's
51 ///  and DApps to upgrade their features in a decentralized manner without
52 ///  affecting the original token
53 /// @dev It is ERC20 compliant, but still needs to under go further testing.
54 
55 
56 contract Controlled {
57     /// @notice The address of the controller is the only address that can call
58     ///  a function with this modifier
59     modifier onlyController {
60         require(msg.sender == controller);
61         _;
62     }
63 
64     address public controller;
65 
66     function Controlled()  public { controller = msg.sender;}
67 
68     /// @notice Changes the controller of the contract
69     /// @param _newController The new controller of the contract
70     function changeController(address _newController) onlyController  public {
71         controller = _newController;
72     }
73 }
74 
75 contract ApproveAndCallFallBack {
76     function receiveApproval(
77         address from,
78         uint256 _amount,
79         address _token,
80         bytes _data
81     ) public;
82 }
83 
84 /// @dev The actual token contract, the default controller is the msg.sender
85 ///  that deploys the contract, so usually this token will be deployed by a
86 ///  token controller contract, which Giveth will call a "Campaign"
87 contract MiniMeToken is Controlled {
88 
89     string public name;                //The Token's name: e.g. DigixDAO Tokens
90     uint8 public decimals;             //Number of decimals of the smallest unit
91     string public symbol;              //An identifier: e.g. REP
92     string public version = "MMT_0.1"; //An arbitrary versioning scheme
93 
94 
95     /// @dev `Checkpoint` is the structure that attaches a block number to a
96     ///  given value, the block number attached is the one that last changed the
97     ///  value
98     struct Checkpoint {
99 
100         // `fromBlock` is the block number that the value was generated from
101         uint128 fromBlock;
102 
103         // `value` is the amount of tokens at a specific block number
104         uint128 value;
105     }
106 
107     // `parentToken` is the Token address that was cloned to produce this token;
108     //  it will be 0x0 for a token that was not cloned
109     MiniMeToken public parentToken;
110 
111     // `parentSnapShotBlock` is the block number from the Parent Token that was
112     //  used to determine the initial distribution of the Clone Token
113     uint public parentSnapShotBlock;
114 
115     // `creationBlock` is the block number that the Clone Token was created
116     uint public creationBlock;
117 
118     // `balances` is the map that tracks the balance of each address, in this
119     //  contract when the balance changes the block number that the change
120     //  occurred is also included in the map
121     mapping (address => Checkpoint[]) balances;
122 
123     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
124     mapping (address => mapping (address => uint256)) allowed;
125 
126     // Tracks the history of the `totalSupply` of the token
127     Checkpoint[] totalSupplyHistory;
128 
129     // Flag that determines if the token is transferable or not.
130     bool public transfersEnabled;
131 
132     // The factory used to create new clone tokens
133     MiniMeTokenFactory public tokenFactory;
134 
135 ////////////////
136 // Constructor
137 ////////////////
138 
139     /// @notice Constructor to create a MiniMeToken
140     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
141     ///  will create the Clone token contracts, the token factory needs to be
142     ///  deployed first
143     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
144     ///  new token
145     /// @param _parentSnapShotBlock Block of the parent token that will
146     ///  determine the initial distribution of the clone token, set to 0 if it
147     ///  is a new token
148     /// @param _tokenName Name of the new token
149     /// @param _decimalUnits Number of decimals of the new token
150     /// @param _tokenSymbol Token Symbol for the new token
151     /// @param _transfersEnabled If true, tokens will be able to be transferred
152     function MiniMeToken(
153         MiniMeTokenFactory _tokenFactory,
154         MiniMeToken _parentToken,
155         uint _parentSnapShotBlock,
156         string _tokenName,
157         uint8 _decimalUnits,
158         string _tokenSymbol,
159         bool _transfersEnabled
160     )  public
161     {
162         tokenFactory = _tokenFactory;
163         name = _tokenName;                                 // Set the name
164         decimals = _decimalUnits;                          // Set the decimals
165         symbol = _tokenSymbol;                             // Set the symbol
166         parentToken = _parentToken;
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
192     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
193 
194         // The controller of this contract can move tokens around at will,
195         //  this is important to recognize! Confirm that you trust the
196         //  controller of this contract, which in most situations should be
197         //  another open source smart contract or 0x0
198         if (msg.sender != controller) {
199             require(transfersEnabled);
200 
201             // The standard ERC 20 transferFrom functionality
202             if (allowed[_from][msg.sender] < _amount)
203                 return false;
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
215     function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
216         if (_amount == 0) {
217             return true;
218         }
219         require(parentSnapShotBlock < block.number);
220         // Do not allow transfer to 0x0 or the token contract itself
221         require((_to != 0) && (_to != address(this)));
222         // If the amount being transfered is more than the balance of the
223         //  account the transfer returns false
224         var previousBalanceFrom = balanceOfAt(_from, block.number);
225         if (previousBalanceFrom < _amount) {
226             return false;
227         }
228         // Alerts the token controller of the transfer
229         if (isContract(controller)) {
230             // Adding the ` == true` makes the linter shut up so...
231             require(ITokenController(controller).onTransfer(_from, _to, _amount) == true);
232         }
233         // First update the balance array with the new value for the address
234         //  sending the tokens
235         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
236         // Then update the balance array with the new value for the address
237         //  receiving the tokens
238         var previousBalanceTo = balanceOfAt(_to, block.number);
239         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
240         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
241         // An event to make the transfer easy to find on the blockchain
242         Transfer(_from, _to, _amount);
243         return true;
244     }
245 
246     /// @param _owner The address that's balance is being requested
247     /// @return The balance of `_owner` at the current block
248     function balanceOf(address _owner) public constant returns (uint256 balance) {
249         return balanceOfAt(_owner, block.number);
250     }
251 
252     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
253     ///  its behalf. This is a modified version of the ERC20 approve function
254     ///  to be a little bit safer
255     /// @param _spender The address of the account able to transfer the tokens
256     /// @param _amount The amount of tokens to be approved for transfer
257     /// @return True if the approval was successful
258     function approve(address _spender, uint256 _amount) public returns (bool success) {
259         require(transfersEnabled);
260 
261         // To change the approve amount you first have to reduce the addresses`
262         //  allowance to zero by calling `approve(_spender,0)` if it is not
263         //  already 0 to mitigate the race condition described here:
264         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
265         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
266 
267         // Alerts the token controller of the approve function call
268         if (isContract(controller)) {
269             // Adding the ` == true` makes the linter shut up so...
270             require(ITokenController(controller).onApprove(msg.sender, _spender, _amount) == true);
271         }
272 
273         allowed[msg.sender][_spender] = _amount;
274         Approval(msg.sender, _spender, _amount);
275         return true;
276     }
277 
278     /// @dev This function makes it easy to read the `allowed[]` map
279     /// @param _owner The address of the account that owns the token
280     /// @param _spender The address of the account able to transfer the tokens
281     /// @return Amount of remaining tokens of _owner that _spender is allowed
282     ///  to spend
283     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
284         return allowed[_owner][_spender];
285     }
286 
287     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
288     ///  its behalf, and then a function is triggered in the contract that is
289     ///  being approved, `_spender`. This allows users to use their tokens to
290     ///  interact with contracts in one function call instead of two
291     /// @param _spender The address of the contract able to transfer the tokens
292     /// @param _amount The amount of tokens to be approved for transfer
293     /// @return True if the function call was successful
294     function approveAndCall(ApproveAndCallFallBack _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
295         require(approve(_spender, _amount));
296 
297         _spender.receiveApproval(
298             msg.sender,
299             _amount,
300             this,
301             _extraData
302         );
303 
304         return true;
305     }
306 
307     /// @dev This function makes it easy to get the total number of tokens
308     /// @return The total number of tokens
309     function totalSupply() public constant returns (uint) {
310         return totalSupplyAt(block.number);
311     }
312 
313 
314 ////////////////
315 // Query balance and totalSupply in History
316 ////////////////
317 
318     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
319     /// @param _owner The address from which the balance will be retrieved
320     /// @param _blockNumber The block number when the balance is queried
321     /// @return The balance at `_blockNumber`
322     function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
323 
324         // These next few lines are used when the balance of the token is
325         //  requested before a check point was ever created for this token, it
326         //  requires that the `parentToken.balanceOfAt` be queried at the
327         //  genesis block for that token as this contains initial balance of
328         //  this token
329         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
330             if (address(parentToken) != 0) {
331                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
332             } else {
333                 // Has no parent
334                 return 0;
335             }
336 
337         // This will return the expected balance during normal situations
338         } else {
339             return getValueAt(balances[_owner], _blockNumber);
340         }
341     }
342 
343     /// @notice Total amount of tokens at a specific `_blockNumber`.
344     /// @param _blockNumber The block number when the totalSupply is queried
345     /// @return The total amount of tokens at `_blockNumber`
346     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
347 
348         // These next few lines are used when the totalSupply of the token is
349         //  requested before a check point was ever created for this token, it
350         //  requires that the `parentToken.totalSupplyAt` be queried at the
351         //  genesis block for this token as that contains totalSupply of this
352         //  token at this block number.
353         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
354             if (address(parentToken) != 0) {
355                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
356             } else {
357                 return 0;
358             }
359 
360         // This will return the expected totalSupply during normal situations
361         } else {
362             return getValueAt(totalSupplyHistory, _blockNumber);
363         }
364     }
365 
366 ////////////////
367 // Clone Token Method
368 ////////////////
369 
370     /// @notice Creates a new clone token with the initial distribution being
371     ///  this token at `_snapshotBlock`
372     /// @param _cloneTokenName Name of the clone token
373     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
374     /// @param _cloneTokenSymbol Symbol of the clone token
375     /// @param _snapshotBlock Block when the distribution of the parent token is
376     ///  copied to set the initial distribution of the new clone token;
377     ///  if the block is zero than the actual block, the current block is used
378     /// @param _transfersEnabled True if transfers are allowed in the clone
379     /// @return The address of the new MiniMeToken Contract
380     function createCloneToken(
381         string _cloneTokenName,
382         uint8 _cloneDecimalUnits,
383         string _cloneTokenSymbol,
384         uint _snapshotBlock,
385         bool _transfersEnabled
386     ) public returns(MiniMeToken)
387     {
388         uint256 snapshot = _snapshotBlock == 0 ? block.number - 1 : _snapshotBlock;
389 
390         MiniMeToken cloneToken = tokenFactory.createCloneToken(
391             this,
392             snapshot,
393             _cloneTokenName,
394             _cloneDecimalUnits,
395             _cloneTokenSymbol,
396             _transfersEnabled
397         );
398 
399         cloneToken.changeController(msg.sender);
400 
401         // An event to make the token easy to find on the blockchain
402         NewCloneToken(address(cloneToken), snapshot);
403         return cloneToken;
404     }
405 
406 ////////////////
407 // Generate and destroy tokens
408 ////////////////
409 
410     /// @notice Generates `_amount` tokens that are assigned to `_owner`
411     /// @param _owner The address that will be assigned the new tokens
412     /// @param _amount The quantity of tokens generated
413     /// @return True if the tokens are generated correctly
414     function generateTokens(address _owner, uint _amount) onlyController public returns (bool) {
415         uint curTotalSupply = totalSupply();
416         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
417         uint previousBalanceTo = balanceOf(_owner);
418         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
419         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
420         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
421         Transfer(0, _owner, _amount);
422         return true;
423     }
424 
425 
426     /// @notice Burns `_amount` tokens from `_owner`
427     /// @param _owner The address that will lose the tokens
428     /// @param _amount The quantity of tokens to burn
429     /// @return True if the tokens are burned correctly
430     function destroyTokens(address _owner, uint _amount) onlyController public returns (bool) {
431         uint curTotalSupply = totalSupply();
432         require(curTotalSupply >= _amount);
433         uint previousBalanceFrom = balanceOf(_owner);
434         require(previousBalanceFrom >= _amount);
435         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
436         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
437         Transfer(_owner, 0, _amount);
438         return true;
439     }
440 
441 ////////////////
442 // Enable tokens transfers
443 ////////////////
444 
445 
446     /// @notice Enables token holders to transfer their tokens freely if true
447     /// @param _transfersEnabled True if transfers are allowed in the clone
448     function enableTransfers(bool _transfersEnabled) onlyController public {
449         transfersEnabled = _transfersEnabled;
450     }
451 
452 ////////////////
453 // Internal helper functions to query and set a value in a snapshot array
454 ////////////////
455 
456     /// @dev `getValueAt` retrieves the number of tokens at a given block number
457     /// @param checkpoints The history of values being queried
458     /// @param _block The block number to retrieve the value at
459     /// @return The number of tokens being queried
460     function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
461         if (checkpoints.length == 0)
462             return 0;
463 
464         // Shortcut for the actual value
465         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
466             return checkpoints[checkpoints.length-1].value;
467         if (_block < checkpoints[0].fromBlock)
468             return 0;
469 
470         // Binary search of the value in the array
471         uint min = 0;
472         uint max = checkpoints.length-1;
473         while (max > min) {
474             uint mid = (max + min + 1) / 2;
475             if (checkpoints[mid].fromBlock<=_block) {
476                 min = mid;
477             } else {
478                 max = mid-1;
479             }
480         }
481         return checkpoints[min].value;
482     }
483 
484     /// @dev `updateValueAtNow` used to update the `balances` map and the
485     ///  `totalSupplyHistory`
486     /// @param checkpoints The history of data being updated
487     /// @param _value The new number of tokens
488     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
489         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
490             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
491             newCheckPoint.fromBlock = uint128(block.number);
492             newCheckPoint.value = uint128(_value);
493         } else {
494             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length - 1];
495             oldCheckPoint.value = uint128(_value);
496         }
497     }
498 
499     /// @dev Internal function to determine if an address is a contract
500     /// @param _addr The address being queried
501     /// @return True if `_addr` is a contract
502     function isContract(address _addr) constant internal returns(bool) {
503         uint size;
504         if (_addr == 0)
505             return false;
506 
507         assembly {
508             size := extcodesize(_addr)
509         }
510 
511         return size>0;
512     }
513 
514     /// @dev Helper function to return a min betwen the two uints
515     function min(uint a, uint b) pure internal returns (uint) {
516         return a < b ? a : b;
517     }
518 
519     /// @notice The fallback function: If the contract's controller has not been
520     ///  set to 0, then the `proxyPayment` method is called which relays the
521     ///  ether and creates tokens as described in the token controller contract
522     function () external payable {
523         require(isContract(controller));
524         // Adding the ` == true` makes the linter shut up so...
525         require(ITokenController(controller).proxyPayment.value(msg.value)(msg.sender) == true);
526     }
527 
528 //////////
529 // Safety Methods
530 //////////
531 
532     /// @notice This method can be used by the controller to extract mistakenly
533     ///  sent tokens to this contract.
534     /// @param _token The address of the token contract that you want to recover
535     ///  set to 0 in case you want to extract ether.
536     function claimTokens(address _token) onlyController public {
537         if (_token == 0x0) {
538             controller.transfer(this.balance);
539             return;
540         }
541 
542         MiniMeToken token = MiniMeToken(_token);
543         uint balance = token.balanceOf(this);
544         token.transfer(controller, balance);
545         ClaimedTokens(_token, controller, balance);
546     }
547 
548 ////////////////
549 // Events
550 ////////////////
551     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
552     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
553     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
554     event Approval(
555         address indexed _owner,
556         address indexed _spender,
557         uint256 _amount
558         );
559 
560 }
561 
562 
563 ////////////////
564 // MiniMeTokenFactory
565 ////////////////
566 
567 /// @dev This contract is used to generate clone contracts from a contract.
568 ///  In solidity this is the way to create a contract from a contract of the
569 ///  same class
570 contract MiniMeTokenFactory {
571 
572     /// @notice Update the DApp by creating a new token with new functionalities
573     ///  the msg.sender becomes the controller of this clone token
574     /// @param _parentToken Address of the token being cloned
575     /// @param _snapshotBlock Block of the parent token that will
576     ///  determine the initial distribution of the clone token
577     /// @param _tokenName Name of the new token
578     /// @param _decimalUnits Number of decimals of the new token
579     /// @param _tokenSymbol Token Symbol for the new token
580     /// @param _transfersEnabled If true, tokens will be able to be transferred
581     /// @return The address of the new token contract
582     function createCloneToken(
583         MiniMeToken _parentToken,
584         uint _snapshotBlock,
585         string _tokenName,
586         uint8 _decimalUnits,
587         string _tokenSymbol,
588         bool _transfersEnabled
589     ) public returns (MiniMeToken)
590     {
591         MiniMeToken newToken = new MiniMeToken(
592             this,
593             _parentToken,
594             _snapshotBlock,
595             _tokenName,
596             _decimalUnits,
597             _tokenSymbol,
598             _transfersEnabled
599         );
600 
601         newToken.changeController(msg.sender);
602         return newToken;
603     }
604 }