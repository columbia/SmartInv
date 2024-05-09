1 pragma solidity ^0.4.24;
2 
3 /*
4     Copyright 2016, Jordi Baylina
5     This program is free software: you can redistribute it and/or modify
6     it under the terms of the GNU General Public License as published by
7     the Free Software Foundation, either version 3 of the License, or
8     (at your option) any later version.
9     This program is distributed in the hope that it will be useful,
10     but WITHOUT ANY WARRANTY; without even the implied warranty of
11     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
12     GNU General Public License for more details.
13     You should have received a copy of the GNU General Public License
14     along with this program.  If not, see <http://www.gnu.org/licenses/>.
15  */
16 
17 /// @title MiniMeToken Contract
18 /// @author Jordi Baylina
19 /// @dev This token contract's goal is to make it easy for anyone to clone this
20 ///  token using the token distribution at a given block, this will allow DAO's
21 ///  and DApps to upgrade their features in a decentralized manner without
22 ///  affecting the original token
23 /// @dev It is ERC20 compliant, but still needs to under go further testing.
24 
25 /// @dev The token controller contract must implement these functions
26 interface ITokenController {
27     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
28     /// @param _owner The address that sent the ether to create tokens
29     /// @return True if the ether is accepted, false if it throws
30     function proxyPayment(address _owner) external payable returns(bool);
31 
32     /// @notice Notifies the controller about a token transfer allowing the
33     ///  controller to react if desired
34     /// @param _from The origin of the transfer
35     /// @param _to The destination of the transfer
36     /// @param _amount The amount of the transfer
37     /// @return False if the controller does not authorize the transfer
38     function onTransfer(address _from, address _to, uint _amount) external returns(bool);
39 
40     /// @notice Notifies the controller about an approval allowing the
41     ///  controller to react if desired
42     /// @param _owner The address that calls `approve()`
43     /// @param _spender The spender in the `approve()` call
44     /// @param _amount The amount in the `approve()` call
45     /// @return False if the controller does not authorize the approval
46     function onApprove(address _owner, address _spender, uint _amount) external returns(bool);
47 }
48 
49 contract Controlled {
50     /// @notice The address of the controller is the only address that can call
51     ///  a function with this modifier
52     modifier onlyController {
53         require(msg.sender == controller);
54         _;
55     }
56 
57     address public controller;
58 
59     function Controlled()  public { controller = msg.sender;}
60 
61     /// @notice Changes the controller of the contract
62     /// @param _newController The new controller of the contract
63     function changeController(address _newController) onlyController  public {
64         controller = _newController;
65     }
66 }
67 
68 contract ApproveAndCallFallBack {
69     function receiveApproval(
70         address from,
71         uint256 _amount,
72         address _token,
73         bytes _data
74     ) public;
75 }
76 
77 /// @dev The actual token contract, the default controller is the msg.sender
78 ///  that deploys the contract, so usually this token will be deployed by a
79 ///  token controller contract, which Giveth will call a "Campaign"
80 contract MiniMeToken is Controlled {
81 
82     string public name;                //The Token's name: e.g. DigixDAO Tokens
83     uint8 public decimals;             //Number of decimals of the smallest unit
84     string public symbol;              //An identifier: e.g. REP
85     string public version = "MMT_0.1"; //An arbitrary versioning scheme
86 
87 
88     /// @dev `Checkpoint` is the structure that attaches a block number to a
89     ///  given value, the block number attached is the one that last changed the
90     ///  value
91     struct Checkpoint {
92 
93         // `fromBlock` is the block number that the value was generated from
94         uint128 fromBlock;
95 
96         // `value` is the amount of tokens at a specific block number
97         uint128 value;
98     }
99 
100     // `parentToken` is the Token address that was cloned to produce this token;
101     //  it will be 0x0 for a token that was not cloned
102     MiniMeToken public parentToken;
103 
104     // `parentSnapShotBlock` is the block number from the Parent Token that was
105     //  used to determine the initial distribution of the Clone Token
106     uint public parentSnapShotBlock;
107 
108     // `creationBlock` is the block number that the Clone Token was created
109     uint public creationBlock;
110 
111     // `balances` is the map that tracks the balance of each address, in this
112     //  contract when the balance changes the block number that the change
113     //  occurred is also included in the map
114     mapping (address => Checkpoint[]) balances;
115 
116     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
117     mapping (address => mapping (address => uint256)) allowed;
118 
119     // Tracks the history of the `totalSupply` of the token
120     Checkpoint[] totalSupplyHistory;
121 
122     // Flag that determines if the token is transferable or not.
123     bool public transfersEnabled;
124 
125     // The factory used to create new clone tokens
126     MiniMeTokenFactory public tokenFactory;
127 
128 ////////////////
129 // Constructor
130 ////////////////
131 
132     /// @notice Constructor to create a MiniMeToken
133     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
134     ///  will create the Clone token contracts, the token factory needs to be
135     ///  deployed first
136     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
137     ///  new token
138     /// @param _parentSnapShotBlock Block of the parent token that will
139     ///  determine the initial distribution of the clone token, set to 0 if it
140     ///  is a new token
141     /// @param _tokenName Name of the new token
142     /// @param _decimalUnits Number of decimals of the new token
143     /// @param _tokenSymbol Token Symbol for the new token
144     /// @param _transfersEnabled If true, tokens will be able to be transferred
145     function MiniMeToken(
146         MiniMeTokenFactory _tokenFactory,
147         MiniMeToken _parentToken,
148         uint _parentSnapShotBlock,
149         string _tokenName,
150         uint8 _decimalUnits,
151         string _tokenSymbol,
152         bool _transfersEnabled
153     )  public
154     {
155         tokenFactory = _tokenFactory;
156         name = _tokenName;                                 // Set the name
157         decimals = _decimalUnits;                          // Set the decimals
158         symbol = _tokenSymbol;                             // Set the symbol
159         parentToken = _parentToken;
160         parentSnapShotBlock = _parentSnapShotBlock;
161         transfersEnabled = _transfersEnabled;
162         creationBlock = block.number;
163     }
164 
165 
166 ///////////////////
167 // ERC20 Methods
168 ///////////////////
169 
170     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
171     /// @param _to The address of the recipient
172     /// @param _amount The amount of tokens to be transferred
173     /// @return Whether the transfer was successful or not
174     function transfer(address _to, uint256 _amount) public returns (bool success) {
175         require(transfersEnabled);
176         return doTransfer(msg.sender, _to, _amount);
177     }
178 
179     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
180     ///  is approved by `_from`
181     /// @param _from The address holding the tokens being transferred
182     /// @param _to The address of the recipient
183     /// @param _amount The amount of tokens to be transferred
184     /// @return True if the transfer was successful
185     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
186 
187         // The controller of this contract can move tokens around at will,
188         //  this is important to recognize! Confirm that you trust the
189         //  controller of this contract, which in most situations should be
190         //  another open source smart contract or 0x0
191         if (msg.sender != controller) {
192             require(transfersEnabled);
193 
194             // The standard ERC 20 transferFrom functionality
195             if (allowed[_from][msg.sender] < _amount)
196                 return false;
197             allowed[_from][msg.sender] -= _amount;
198         }
199         return doTransfer(_from, _to, _amount);
200     }
201 
202     /// @dev This is the actual transfer function in the token contract, it can
203     ///  only be called by other functions in this contract.
204     /// @param _from The address holding the tokens being transferred
205     /// @param _to The address of the recipient
206     /// @param _amount The amount of tokens to be transferred
207     /// @return True if the transfer was successful
208     function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
209         if (_amount == 0) {
210             return true;
211         }
212         require(parentSnapShotBlock < block.number);
213         // Do not allow transfer to 0x0 or the token contract itself
214         require((_to != 0) && (_to != address(this)));
215         // If the amount being transfered is more than the balance of the
216         //  account the transfer returns false
217         var previousBalanceFrom = balanceOfAt(_from, block.number);
218         if (previousBalanceFrom < _amount) {
219             return false;
220         }
221         // Alerts the token controller of the transfer
222         if (isContract(controller)) {
223             // Adding the ` == true` makes the linter shut up so...
224             require(ITokenController(controller).onTransfer(_from, _to, _amount) == true);
225         }
226         // First update the balance array with the new value for the address
227         //  sending the tokens
228         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
229         // Then update the balance array with the new value for the address
230         //  receiving the tokens
231         var previousBalanceTo = balanceOfAt(_to, block.number);
232         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
233         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
234         // An event to make the transfer easy to find on the blockchain
235         Transfer(_from, _to, _amount);
236         return true;
237     }
238 
239     /// @param _owner The address that's balance is being requested
240     /// @return The balance of `_owner` at the current block
241     function balanceOf(address _owner) public constant returns (uint256 balance) {
242         return balanceOfAt(_owner, block.number);
243     }
244 
245     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
246     ///  its behalf. This is a modified version of the ERC20 approve function
247     ///  to be a little bit safer
248     /// @param _spender The address of the account able to transfer the tokens
249     /// @param _amount The amount of tokens to be approved for transfer
250     /// @return True if the approval was successful
251     function approve(address _spender, uint256 _amount) public returns (bool success) {
252         require(transfersEnabled);
253 
254         // To change the approve amount you first have to reduce the addresses`
255         //  allowance to zero by calling `approve(_spender,0)` if it is not
256         //  already 0 to mitigate the race condition described here:
257         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
258         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
259 
260         // Alerts the token controller of the approve function call
261         if (isContract(controller)) {
262             // Adding the ` == true` makes the linter shut up so...
263             require(ITokenController(controller).onApprove(msg.sender, _spender, _amount) == true);
264         }
265 
266         allowed[msg.sender][_spender] = _amount;
267         Approval(msg.sender, _spender, _amount);
268         return true;
269     }
270 
271     /// @dev This function makes it easy to read the `allowed[]` map
272     /// @param _owner The address of the account that owns the token
273     /// @param _spender The address of the account able to transfer the tokens
274     /// @return Amount of remaining tokens of _owner that _spender is allowed
275     ///  to spend
276     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
277         return allowed[_owner][_spender];
278     }
279 
280     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
281     ///  its behalf, and then a function is triggered in the contract that is
282     ///  being approved, `_spender`. This allows users to use their tokens to
283     ///  interact with contracts in one function call instead of two
284     /// @param _spender The address of the contract able to transfer the tokens
285     /// @param _amount The amount of tokens to be approved for transfer
286     /// @return True if the function call was successful
287     function approveAndCall(ApproveAndCallFallBack _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
288         require(approve(_spender, _amount));
289 
290         _spender.receiveApproval(
291             msg.sender,
292             _amount,
293             this,
294             _extraData
295         );
296 
297         return true;
298     }
299 
300     /// @dev This function makes it easy to get the total number of tokens
301     /// @return The total number of tokens
302     function totalSupply() public constant returns (uint) {
303         return totalSupplyAt(block.number);
304     }
305 
306 
307 ////////////////
308 // Query balance and totalSupply in History
309 ////////////////
310 
311     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
312     /// @param _owner The address from which the balance will be retrieved
313     /// @param _blockNumber The block number when the balance is queried
314     /// @return The balance at `_blockNumber`
315     function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
316 
317         // These next few lines are used when the balance of the token is
318         //  requested before a check point was ever created for this token, it
319         //  requires that the `parentToken.balanceOfAt` be queried at the
320         //  genesis block for that token as this contains initial balance of
321         //  this token
322         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
323             if (address(parentToken) != 0) {
324                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
325             } else {
326                 // Has no parent
327                 return 0;
328             }
329 
330         // This will return the expected balance during normal situations
331         } else {
332             return getValueAt(balances[_owner], _blockNumber);
333         }
334     }
335 
336     /// @notice Total amount of tokens at a specific `_blockNumber`.
337     /// @param _blockNumber The block number when the totalSupply is queried
338     /// @return The total amount of tokens at `_blockNumber`
339     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
340 
341         // These next few lines are used when the totalSupply of the token is
342         //  requested before a check point was ever created for this token, it
343         //  requires that the `parentToken.totalSupplyAt` be queried at the
344         //  genesis block for this token as that contains totalSupply of this
345         //  token at this block number.
346         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
347             if (address(parentToken) != 0) {
348                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
349             } else {
350                 return 0;
351             }
352 
353         // This will return the expected totalSupply during normal situations
354         } else {
355             return getValueAt(totalSupplyHistory, _blockNumber);
356         }
357     }
358 
359 ////////////////
360 // Clone Token Method
361 ////////////////
362 
363     /// @notice Creates a new clone token with the initial distribution being
364     ///  this token at `_snapshotBlock`
365     /// @param _cloneTokenName Name of the clone token
366     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
367     /// @param _cloneTokenSymbol Symbol of the clone token
368     /// @param _snapshotBlock Block when the distribution of the parent token is
369     ///  copied to set the initial distribution of the new clone token;
370     ///  if the block is zero than the actual block, the current block is used
371     /// @param _transfersEnabled True if transfers are allowed in the clone
372     /// @return The address of the new MiniMeToken Contract
373     function createCloneToken(
374         string _cloneTokenName,
375         uint8 _cloneDecimalUnits,
376         string _cloneTokenSymbol,
377         uint _snapshotBlock,
378         bool _transfersEnabled
379     ) public returns(MiniMeToken)
380     {
381         uint256 snapshot = _snapshotBlock == 0 ? block.number - 1 : _snapshotBlock;
382 
383         MiniMeToken cloneToken = tokenFactory.createCloneToken(
384             this,
385             snapshot,
386             _cloneTokenName,
387             _cloneDecimalUnits,
388             _cloneTokenSymbol,
389             _transfersEnabled
390         );
391 
392         cloneToken.changeController(msg.sender);
393 
394         // An event to make the token easy to find on the blockchain
395         NewCloneToken(address(cloneToken), snapshot);
396         return cloneToken;
397     }
398 
399 ////////////////
400 // Generate and destroy tokens
401 ////////////////
402 
403     /// @notice Generates `_amount` tokens that are assigned to `_owner`
404     /// @param _owner The address that will be assigned the new tokens
405     /// @param _amount The quantity of tokens generated
406     /// @return True if the tokens are generated correctly
407     function generateTokens(address _owner, uint _amount) onlyController public returns (bool) {
408         uint curTotalSupply = totalSupply();
409         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
410         uint previousBalanceTo = balanceOf(_owner);
411         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
412         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
413         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
414         Transfer(0, _owner, _amount);
415         return true;
416     }
417 
418 
419     /// @notice Burns `_amount` tokens from `_owner`
420     /// @param _owner The address that will lose the tokens
421     /// @param _amount The quantity of tokens to burn
422     /// @return True if the tokens are burned correctly
423     function destroyTokens(address _owner, uint _amount) onlyController public returns (bool) {
424         uint curTotalSupply = totalSupply();
425         require(curTotalSupply >= _amount);
426         uint previousBalanceFrom = balanceOf(_owner);
427         require(previousBalanceFrom >= _amount);
428         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
429         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
430         Transfer(_owner, 0, _amount);
431         return true;
432     }
433 
434 ////////////////
435 // Enable tokens transfers
436 ////////////////
437 
438 
439     /// @notice Enables token holders to transfer their tokens freely if true
440     /// @param _transfersEnabled True if transfers are allowed in the clone
441     function enableTransfers(bool _transfersEnabled) onlyController public {
442         transfersEnabled = _transfersEnabled;
443     }
444 
445 ////////////////
446 // Internal helper functions to query and set a value in a snapshot array
447 ////////////////
448 
449     /// @dev `getValueAt` retrieves the number of tokens at a given block number
450     /// @param checkpoints The history of values being queried
451     /// @param _block The block number to retrieve the value at
452     /// @return The number of tokens being queried
453     function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
454         if (checkpoints.length == 0)
455             return 0;
456 
457         // Shortcut for the actual value
458         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
459             return checkpoints[checkpoints.length-1].value;
460         if (_block < checkpoints[0].fromBlock)
461             return 0;
462 
463         // Binary search of the value in the array
464         uint min = 0;
465         uint max = checkpoints.length-1;
466         while (max > min) {
467             uint mid = (max + min + 1) / 2;
468             if (checkpoints[mid].fromBlock<=_block) {
469                 min = mid;
470             } else {
471                 max = mid-1;
472             }
473         }
474         return checkpoints[min].value;
475     }
476 
477     /// @dev `updateValueAtNow` used to update the `balances` map and the
478     ///  `totalSupplyHistory`
479     /// @param checkpoints The history of data being updated
480     /// @param _value The new number of tokens
481     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
482         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
483             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
484             newCheckPoint.fromBlock = uint128(block.number);
485             newCheckPoint.value = uint128(_value);
486         } else {
487             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length - 1];
488             oldCheckPoint.value = uint128(_value);
489         }
490     }
491 
492     /// @dev Internal function to determine if an address is a contract
493     /// @param _addr The address being queried
494     /// @return True if `_addr` is a contract
495     function isContract(address _addr) constant internal returns(bool) {
496         uint size;
497         if (_addr == 0)
498             return false;
499 
500         assembly {
501             size := extcodesize(_addr)
502         }
503 
504         return size>0;
505     }
506 
507     /// @dev Helper function to return a min betwen the two uints
508     function min(uint a, uint b) pure internal returns (uint) {
509         return a < b ? a : b;
510     }
511 
512     /// @notice The fallback function: If the contract's controller has not been
513     ///  set to 0, then the `proxyPayment` method is called which relays the
514     ///  ether and creates tokens as described in the token controller contract
515     function () external payable {
516         require(isContract(controller));
517         // Adding the ` == true` makes the linter shut up so...
518         require(ITokenController(controller).proxyPayment.value(msg.value)(msg.sender) == true);
519     }
520 
521 //////////
522 // Safety Methods
523 //////////
524 
525     /// @notice This method can be used by the controller to extract mistakenly
526     ///  sent tokens to this contract.
527     /// @param _token The address of the token contract that you want to recover
528     ///  set to 0 in case you want to extract ether.
529     function claimTokens(address _token) onlyController public {
530         if (_token == 0x0) {
531             controller.transfer(this.balance);
532             return;
533         }
534 
535         MiniMeToken token = MiniMeToken(_token);
536         uint balance = token.balanceOf(this);
537         token.transfer(controller, balance);
538         ClaimedTokens(_token, controller, balance);
539     }
540 
541 ////////////////
542 // Events
543 ////////////////
544     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
545     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
546     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
547     event Approval(
548         address indexed _owner,
549         address indexed _spender,
550         uint256 _amount
551         );
552 
553 }
554 
555 
556 ////////////////
557 // MiniMeTokenFactory
558 ////////////////
559 
560 /// @dev This contract is used to generate clone contracts from a contract.
561 ///  In solidity this is the way to create a contract from a contract of the
562 ///  same class
563 contract MiniMeTokenFactory {
564 
565     /// @notice Update the DApp by creating a new token with new functionalities
566     ///  the msg.sender becomes the controller of this clone token
567     /// @param _parentToken Address of the token being cloned
568     /// @param _snapshotBlock Block of the parent token that will
569     ///  determine the initial distribution of the clone token
570     /// @param _tokenName Name of the new token
571     /// @param _decimalUnits Number of decimals of the new token
572     /// @param _tokenSymbol Token Symbol for the new token
573     /// @param _transfersEnabled If true, tokens will be able to be transferred
574     /// @return The address of the new token contract
575     function createCloneToken(
576         MiniMeToken _parentToken,
577         uint _snapshotBlock,
578         string _tokenName,
579         uint8 _decimalUnits,
580         string _tokenSymbol,
581         bool _transfersEnabled
582     ) public returns (MiniMeToken)
583     {
584         MiniMeToken newToken = new MiniMeToken(
585             this,
586             _parentToken,
587             _snapshotBlock,
588             _tokenName,
589             _decimalUnits,
590             _tokenSymbol,
591             _transfersEnabled
592         );
593 
594         newToken.changeController(msg.sender);
595         return newToken;
596     }
597 }