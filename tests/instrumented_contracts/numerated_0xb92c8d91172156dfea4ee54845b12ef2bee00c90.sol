1 pragma solidity ^0.4.24;
2 // File: @aragon/apps-shared-minime/contracts/ITokenController.sol
3 /// @dev The token controller contract must implement these functions
4 
5 
6 interface ITokenController {
7     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
8     /// @param _owner The address that sent the ether to create tokens
9     /// @return True if the ether is accepted, false if it throws
10     function proxyPayment(address _owner) external payable returns(bool);
11 
12     /// @notice Notifies the controller about a token transfer allowing the
13     ///  controller to react if desired
14     /// @param _from The origin of the transfer
15     /// @param _to The destination of the transfer
16     /// @param _amount The amount of the transfer
17     /// @return False if the controller does not authorize the transfer
18     function onTransfer(address _from, address _to, uint _amount) external returns(bool);
19 
20     /// @notice Notifies the controller about an approval allowing the
21     ///  controller to react if desired
22     /// @param _owner The address that calls `approve()`
23     /// @param _spender The spender in the `approve()` call
24     /// @param _amount The amount in the `approve()` call
25     /// @return False if the controller does not authorize the approval
26     function onApprove(address _owner, address _spender, uint _amount) external returns(bool);
27 }
28 // File: @aragon/apps-shared-minime/contracts/MiniMeToken.sol
29 /*
30     Copyright 2016, Jordi Baylina
31     This program is free software: you can redistribute it and/or modify
32     it under the terms of the GNU General Public License as published by
33     the Free Software Foundation, either version 3 of the License, or
34     (at your option) any later version.
35     This program is distributed in the hope that it will be useful,
36     but WITHOUT ANY WARRANTY; without even the implied warranty of
37     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
38     GNU General Public License for more details.
39     You should have received a copy of the GNU General Public License
40     along with this program.  If not, see <http://www.gnu.org/licenses/>.
41  */
42 
43 /// @title MiniMeToken Contract
44 /// @author Jordi Baylina
45 /// @dev This token contract's goal is to make it easy for anyone to clone this
46 ///  token using the token distribution at a given block, this will allow DAO's
47 ///  and DApps to upgrade their features in a decentralized manner without
48 ///  affecting the original token
49 /// @dev It is ERC20 compliant, but still needs to under go further testing.
50 
51 
52 contract Controlled {
53     /// @notice The address of the controller is the only address that can call
54     ///  a function with this modifier
55     modifier onlyController {
56         require(msg.sender == controller);
57         _;
58     }
59 
60     address public controller;
61 
62     function Controlled()  public { controller = msg.sender;}
63 
64     /// @notice Changes the controller of the contract
65     /// @param _newController The new controller of the contract
66     function changeController(address _newController) onlyController  public {
67         controller = _newController;
68     }
69 }
70 
71 contract ApproveAndCallFallBack {
72     function receiveApproval(
73         address from,
74         uint256 _amount,
75         address _token,
76         bytes _data
77     ) public;
78 }
79 
80 /// @dev The actual token contract, the default controller is the msg.sender
81 ///  that deploys the contract, so usually this token will be deployed by a
82 ///  token controller contract, which Giveth will call a "Campaign"
83 contract MiniMeToken is Controlled {
84 
85     string public name;                //The Token's name: e.g. DigixDAO Tokens
86     uint8 public decimals;             //Number of decimals of the smallest unit
87     string public symbol;              //An identifier: e.g. REP
88     string public version = "MMT_0.1"; //An arbitrary versioning scheme
89 
90 
91     /// @dev `Checkpoint` is the structure that attaches a block number to a
92     ///  given value, the block number attached is the one that last changed the
93     ///  value
94     struct Checkpoint {
95 
96         // `fromBlock` is the block number that the value was generated from
97         uint128 fromBlock;
98 
99         // `value` is the amount of tokens at a specific block number
100         uint128 value;
101     }
102 
103     // `parentToken` is the Token address that was cloned to produce this token;
104     //  it will be 0x0 for a token that was not cloned
105     MiniMeToken public parentToken;
106 
107     // `parentSnapShotBlock` is the block number from the Parent Token that was
108     //  used to determine the initial distribution of the Clone Token
109     uint public parentSnapShotBlock;
110 
111     // `creationBlock` is the block number that the Clone Token was created
112     uint public creationBlock;
113 
114     // `balances` is the map that tracks the balance of each address, in this
115     //  contract when the balance changes the block number that the change
116     //  occurred is also included in the map
117     mapping (address => Checkpoint[]) balances;
118 
119     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
120     mapping (address => mapping (address => uint256)) allowed;
121 
122     // Tracks the history of the `totalSupply` of the token
123     Checkpoint[] totalSupplyHistory;
124 
125     // Flag that determines if the token is transferable or not.
126     bool public transfersEnabled;
127 
128     // The factory used to create new clone tokens
129     MiniMeTokenFactory public tokenFactory;
130 
131 ////////////////
132 // Constructor
133 ////////////////
134 
135     /// @notice Constructor to create a MiniMeToken
136     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
137     ///  will create the Clone token contracts, the token factory needs to be
138     ///  deployed first
139     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
140     ///  new token
141     /// @param _parentSnapShotBlock Block of the parent token that will
142     ///  determine the initial distribution of the clone token, set to 0 if it
143     ///  is a new token
144     /// @param _tokenName Name of the new token
145     /// @param _decimalUnits Number of decimals of the new token
146     /// @param _tokenSymbol Token Symbol for the new token
147     /// @param _transfersEnabled If true, tokens will be able to be transferred
148     function MiniMeToken(
149         MiniMeTokenFactory _tokenFactory,
150         MiniMeToken _parentToken,
151         uint _parentSnapShotBlock,
152         string _tokenName,
153         uint8 _decimalUnits,
154         string _tokenSymbol,
155         bool _transfersEnabled
156     )  public
157     {
158         tokenFactory = _tokenFactory;
159         name = _tokenName;                                 // Set the name
160         decimals = _decimalUnits;                          // Set the decimals
161         symbol = _tokenSymbol;                             // Set the symbol
162         parentToken = _parentToken;
163         parentSnapShotBlock = _parentSnapShotBlock;
164         transfersEnabled = _transfersEnabled;
165         creationBlock = block.number;
166     }
167 
168 
169 ///////////////////
170 // ERC20 Methods
171 ///////////////////
172 
173     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
174     /// @param _to The address of the recipient
175     /// @param _amount The amount of tokens to be transferred
176     /// @return Whether the transfer was successful or not
177     function transfer(address _to, uint256 _amount) public returns (bool success) {
178         require(transfersEnabled);
179         return doTransfer(msg.sender, _to, _amount);
180     }
181 
182     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
183     ///  is approved by `_from`
184     /// @param _from The address holding the tokens being transferred
185     /// @param _to The address of the recipient
186     /// @param _amount The amount of tokens to be transferred
187     /// @return True if the transfer was successful
188     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
189 
190         // The controller of this contract can move tokens around at will,
191         //  this is important to recognize! Confirm that you trust the
192         //  controller of this contract, which in most situations should be
193         //  another open source smart contract or 0x0
194         if (msg.sender != controller) {
195             require(transfersEnabled);
196 
197             // The standard ERC 20 transferFrom functionality
198             if (allowed[_from][msg.sender] < _amount)
199                 return false;
200             allowed[_from][msg.sender] -= _amount;
201         }
202         return doTransfer(_from, _to, _amount);
203     }
204 
205     /// @dev This is the actual transfer function in the token contract, it can
206     ///  only be called by other functions in this contract.
207     /// @param _from The address holding the tokens being transferred
208     /// @param _to The address of the recipient
209     /// @param _amount The amount of tokens to be transferred
210     /// @return True if the transfer was successful
211     function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
212         if (_amount == 0) {
213             return true;
214         }
215         require(parentSnapShotBlock < block.number);
216         // Do not allow transfer to 0x0 or the token contract itself
217         require((_to != 0) && (_to != address(this)));
218         // If the amount being transfered is more than the balance of the
219         //  account the transfer returns false
220         var previousBalanceFrom = balanceOfAt(_from, block.number);
221         if (previousBalanceFrom < _amount) {
222             return false;
223         }
224         // Alerts the token controller of the transfer
225         if (isContract(controller)) {
226             // Adding the ` == true` makes the linter shut up so...
227             require(ITokenController(controller).onTransfer(_from, _to, _amount) == true);
228         }
229         // First update the balance array with the new value for the address
230         //  sending the tokens
231         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
232         // Then update the balance array with the new value for the address
233         //  receiving the tokens
234         var previousBalanceTo = balanceOfAt(_to, block.number);
235         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
236         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
237         // An event to make the transfer easy to find on the blockchain
238         Transfer(_from, _to, _amount);
239         return true;
240     }
241 
242     /// @param _owner The address that's balance is being requested
243     /// @return The balance of `_owner` at the current block
244     function balanceOf(address _owner) public constant returns (uint256 balance) {
245         return balanceOfAt(_owner, block.number);
246     }
247 
248     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
249     ///  its behalf. This is a modified version of the ERC20 approve function
250     ///  to be a little bit safer
251     /// @param _spender The address of the account able to transfer the tokens
252     /// @param _amount The amount of tokens to be approved for transfer
253     /// @return True if the approval was successful
254     function approve(address _spender, uint256 _amount) public returns (bool success) {
255         require(transfersEnabled);
256 
257         // To change the approve amount you first have to reduce the addresses`
258         //  allowance to zero by calling `approve(_spender,0)` if it is not
259         //  already 0 to mitigate the race condition described here:
260         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
262 
263         // Alerts the token controller of the approve function call
264         if (isContract(controller)) {
265             // Adding the ` == true` makes the linter shut up so...
266             require(ITokenController(controller).onApprove(msg.sender, _spender, _amount) == true);
267         }
268 
269         allowed[msg.sender][_spender] = _amount;
270         Approval(msg.sender, _spender, _amount);
271         return true;
272     }
273 
274     /// @dev This function makes it easy to read the `allowed[]` map
275     /// @param _owner The address of the account that owns the token
276     /// @param _spender The address of the account able to transfer the tokens
277     /// @return Amount of remaining tokens of _owner that _spender is allowed
278     ///  to spend
279     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
280         return allowed[_owner][_spender];
281     }
282 
283     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
284     ///  its behalf, and then a function is triggered in the contract that is
285     ///  being approved, `_spender`. This allows users to use their tokens to
286     ///  interact with contracts in one function call instead of two
287     /// @param _spender The address of the contract able to transfer the tokens
288     /// @param _amount The amount of tokens to be approved for transfer
289     /// @return True if the function call was successful
290     function approveAndCall(ApproveAndCallFallBack _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
291         require(approve(_spender, _amount));
292 
293         _spender.receiveApproval(
294             msg.sender,
295             _amount,
296             this,
297             _extraData
298         );
299 
300         return true;
301     }
302 
303     /// @dev This function makes it easy to get the total number of tokens
304     /// @return The total number of tokens
305     function totalSupply() public constant returns (uint) {
306         return totalSupplyAt(block.number);
307     }
308 
309 
310 ////////////////
311 // Query balance and totalSupply in History
312 ////////////////
313 
314     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
315     /// @param _owner The address from which the balance will be retrieved
316     /// @param _blockNumber The block number when the balance is queried
317     /// @return The balance at `_blockNumber`
318     function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
319 
320         // These next few lines are used when the balance of the token is
321         //  requested before a check point was ever created for this token, it
322         //  requires that the `parentToken.balanceOfAt` be queried at the
323         //  genesis block for that token as this contains initial balance of
324         //  this token
325         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
326             if (address(parentToken) != 0) {
327                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
328             } else {
329                 // Has no parent
330                 return 0;
331             }
332 
333         // This will return the expected balance during normal situations
334         } else {
335             return getValueAt(balances[_owner], _blockNumber);
336         }
337     }
338 
339     /// @notice Total amount of tokens at a specific `_blockNumber`.
340     /// @param _blockNumber The block number when the totalSupply is queried
341     /// @return The total amount of tokens at `_blockNumber`
342     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
343 
344         // These next few lines are used when the totalSupply of the token is
345         //  requested before a check point was ever created for this token, it
346         //  requires that the `parentToken.totalSupplyAt` be queried at the
347         //  genesis block for this token as that contains totalSupply of this
348         //  token at this block number.
349         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
350             if (address(parentToken) != 0) {
351                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
352             } else {
353                 return 0;
354             }
355 
356         // This will return the expected totalSupply during normal situations
357         } else {
358             return getValueAt(totalSupplyHistory, _blockNumber);
359         }
360     }
361 
362 ////////////////
363 // Clone Token Method
364 ////////////////
365 
366     /// @notice Creates a new clone token with the initial distribution being
367     ///  this token at `_snapshotBlock`
368     /// @param _cloneTokenName Name of the clone token
369     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
370     /// @param _cloneTokenSymbol Symbol of the clone token
371     /// @param _snapshotBlock Block when the distribution of the parent token is
372     ///  copied to set the initial distribution of the new clone token;
373     ///  if the block is zero than the actual block, the current block is used
374     /// @param _transfersEnabled True if transfers are allowed in the clone
375     /// @return The address of the new MiniMeToken Contract
376     function createCloneToken(
377         string _cloneTokenName,
378         uint8 _cloneDecimalUnits,
379         string _cloneTokenSymbol,
380         uint _snapshotBlock,
381         bool _transfersEnabled
382     ) public returns(MiniMeToken)
383     {
384         uint256 snapshot = _snapshotBlock == 0 ? block.number - 1 : _snapshotBlock;
385 
386         MiniMeToken cloneToken = tokenFactory.createCloneToken(
387             this,
388             snapshot,
389             _cloneTokenName,
390             _cloneDecimalUnits,
391             _cloneTokenSymbol,
392             _transfersEnabled
393         );
394 
395         cloneToken.changeController(msg.sender);
396 
397         // An event to make the token easy to find on the blockchain
398         NewCloneToken(address(cloneToken), snapshot);
399         return cloneToken;
400     }
401 
402 ////////////////
403 // Generate and destroy tokens
404 ////////////////
405 
406     /// @notice Generates `_amount` tokens that are assigned to `_owner`
407     /// @param _owner The address that will be assigned the new tokens
408     /// @param _amount The quantity of tokens generated
409     /// @return True if the tokens are generated correctly
410     function generateTokens(address _owner, uint _amount) onlyController public returns (bool) {
411         uint curTotalSupply = totalSupply();
412         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
413         uint previousBalanceTo = balanceOf(_owner);
414         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
415         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
416         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
417         Transfer(0, _owner, _amount);
418         return true;
419     }
420 
421 
422     /// @notice Burns `_amount` tokens from `_owner`
423     /// @param _owner The address that will lose the tokens
424     /// @param _amount The quantity of tokens to burn
425     /// @return True if the tokens are burned correctly
426     function destroyTokens(address _owner, uint _amount) onlyController public returns (bool) {
427         uint curTotalSupply = totalSupply();
428         require(curTotalSupply >= _amount);
429         uint previousBalanceFrom = balanceOf(_owner);
430         require(previousBalanceFrom >= _amount);
431         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
432         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
433         Transfer(_owner, 0, _amount);
434         return true;
435     }
436 
437 ////////////////
438 // Enable tokens transfers
439 ////////////////
440 
441 
442     /// @notice Enables token holders to transfer their tokens freely if true
443     /// @param _transfersEnabled True if transfers are allowed in the clone
444     function enableTransfers(bool _transfersEnabled) onlyController public {
445         transfersEnabled = _transfersEnabled;
446     }
447 
448 ////////////////
449 // Internal helper functions to query and set a value in a snapshot array
450 ////////////////
451 
452     /// @dev `getValueAt` retrieves the number of tokens at a given block number
453     /// @param checkpoints The history of values being queried
454     /// @param _block The block number to retrieve the value at
455     /// @return The number of tokens being queried
456     function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
457         if (checkpoints.length == 0)
458             return 0;
459 
460         // Shortcut for the actual value
461         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
462             return checkpoints[checkpoints.length-1].value;
463         if (_block < checkpoints[0].fromBlock)
464             return 0;
465 
466         // Binary search of the value in the array
467         uint min = 0;
468         uint max = checkpoints.length-1;
469         while (max > min) {
470             uint mid = (max + min + 1) / 2;
471             if (checkpoints[mid].fromBlock<=_block) {
472                 min = mid;
473             } else {
474                 max = mid-1;
475             }
476         }
477         return checkpoints[min].value;
478     }
479 
480     /// @dev `updateValueAtNow` used to update the `balances` map and the
481     ///  `totalSupplyHistory`
482     /// @param checkpoints The history of data being updated
483     /// @param _value The new number of tokens
484     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
485         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
486             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
487             newCheckPoint.fromBlock = uint128(block.number);
488             newCheckPoint.value = uint128(_value);
489         } else {
490             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length - 1];
491             oldCheckPoint.value = uint128(_value);
492         }
493     }
494 
495     /// @dev Internal function to determine if an address is a contract
496     /// @param _addr The address being queried
497     /// @return True if `_addr` is a contract
498     function isContract(address _addr) constant internal returns(bool) {
499         uint size;
500         if (_addr == 0)
501             return false;
502 
503         assembly {
504             size := extcodesize(_addr)
505         }
506 
507         return size>0;
508     }
509 
510     /// @dev Helper function to return a min betwen the two uints
511     function min(uint a, uint b) pure internal returns (uint) {
512         return a < b ? a : b;
513     }
514 
515     /// @notice The fallback function: If the contract's controller has not been
516     ///  set to 0, then the `proxyPayment` method is called which relays the
517     ///  ether and creates tokens as described in the token controller contract
518     function () external payable {
519         require(isContract(controller));
520         // Adding the ` == true` makes the linter shut up so...
521         require(ITokenController(controller).proxyPayment.value(msg.value)(msg.sender) == true);
522     }
523 
524 //////////
525 // Safety Methods
526 //////////
527 
528     /// @notice This method can be used by the controller to extract mistakenly
529     ///  sent tokens to this contract.
530     /// @param _token The address of the token contract that you want to recover
531     ///  set to 0 in case you want to extract ether.
532     function claimTokens(address _token) onlyController public {
533         if (_token == 0x0) {
534             controller.transfer(this.balance);
535             return;
536         }
537 
538         MiniMeToken token = MiniMeToken(_token);
539         uint balance = token.balanceOf(this);
540         token.transfer(controller, balance);
541         ClaimedTokens(_token, controller, balance);
542     }
543 
544 ////////////////
545 // Events
546 ////////////////
547     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
548     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
549     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
550     event Approval(
551         address indexed _owner,
552         address indexed _spender,
553         uint256 _amount
554         );
555 
556 }
557 
558 
559 ////////////////
560 // MiniMeTokenFactory
561 ////////////////
562 
563 /// @dev This contract is used to generate clone contracts from a contract.
564 ///  In solidity this is the way to create a contract from a contract of the
565 ///  same class
566 contract MiniMeTokenFactory {
567 
568     /// @notice Update the DApp by creating a new token with new functionalities
569     ///  the msg.sender becomes the controller of this clone token
570     /// @param _parentToken Address of the token being cloned
571     /// @param _snapshotBlock Block of the parent token that will
572     ///  determine the initial distribution of the clone token
573     /// @param _tokenName Name of the new token
574     /// @param _decimalUnits Number of decimals of the new token
575     /// @param _tokenSymbol Token Symbol for the new token
576     /// @param _transfersEnabled If true, tokens will be able to be transferred
577     /// @return The address of the new token contract
578     function createCloneToken(
579         MiniMeToken _parentToken,
580         uint _snapshotBlock,
581         string _tokenName,
582         uint8 _decimalUnits,
583         string _tokenSymbol,
584         bool _transfersEnabled
585     ) public returns (MiniMeToken)
586     {
587         MiniMeToken newToken = new MiniMeToken(
588             this,
589             _parentToken,
590             _snapshotBlock,
591             _tokenName,
592             _decimalUnits,
593             _tokenSymbol,
594             _transfersEnabled
595         );
596 
597         newToken.changeController(msg.sender);
598         return newToken;
599     }
600 }