1 pragma solidity 0.4.19;
2 
3 /// @dev The token controller contract must implement these functions
4 contract TokenController {
5     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
6     /// @param _owner The address that sent the ether to create tokens
7     /// @return True if the ether is accepted, false if it throws
8     function proxyPayment(address _owner) public payable returns(bool);
9 
10     /// @notice Notifies the controller about a token transfer allowing the
11     ///  controller to react if desired
12     /// @param _from The origin of the transfer
13     /// @param _to The destination of the transfer
14     /// @param _amount The amount of the transfer
15     /// @return False if the controller does not authorize the transfer
16     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
17 
18     /// @notice Notifies the controller about an approval allowing the
19     ///  controller to react if desired
20     /// @param _owner The address that calls `approve()`
21     /// @param _spender The spender in the `approve()` call
22     /// @param _amount The amount in the `approve()` call
23     /// @return False if the controller does not authorize the approval
24     function onApprove(address _owner, address _spender, uint _amount) public
25         returns(bool);
26 }
27 
28 contract Controlled {
29     /// @notice The address of the controller is the only address that can call
30     ///  a function with this modifier
31     modifier onlyController { require(msg.sender == controller); _; }
32 
33     address public controller;
34 
35     function Controlled() public { controller = msg.sender;}
36 
37     /// @notice Changes the controller of the contract
38     /// @param _newController The new controller of the contract
39     function changeController(address _newController) public onlyController {
40         controller = _newController;
41     }
42 }
43 
44 /*
45     Copyright 2016, Jordi Baylina
46 
47     This program is free software: you can redistribute it and/or modify
48     it under the terms of the GNU General Public License as published by
49     the Free Software Foundation, either version 3 of the License, or
50     (at your option) any later version.
51 
52     This program is distributed in the hope that it will be useful,
53     but WITHOUT ANY WARRANTY; without even the implied warranty of
54     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
55     GNU General Public License for more details.
56 
57     You should have received a copy of the GNU General Public License
58     along with this program.  If not, see <http://www.gnu.org/licenses/>.
59  */
60 
61 /// @title MiniMeToken Contract
62 /// @author Jordi Baylina
63 /// @dev This token contract's goal is to make it easy for anyone to clone this
64 ///  token using the token distribution at a given block, this will allow DAO's
65 ///  and DApps to upgrade their features in a decentralized manner without
66 ///  affecting the original token
67 /// @dev It is ERC20 compliant, but still needs to under go further testing.
68 
69 contract ApproveAndCallFallBack {
70     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
71 }
72 
73 /// @dev The actual token contract, the default controller is the msg.sender
74 ///  that deploys the contract, so usually this token will be deployed by a
75 ///  token controller contract, which Giveth will call a "Campaign"
76 contract MiniMeToken is Controlled {
77 
78     string public name;                //The Token's name: e.g. DigixDAO Tokens
79     uint8 public decimals;             //Number of decimals of the smallest unit
80     string public symbol;              //An identifier: e.g. REP
81     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
82 
83 
84     /// @dev `Checkpoint` is the structure that attaches a block number to a
85     ///  given value, the block number attached is the one that last changed the
86     ///  value
87     struct  Checkpoint {
88 
89         // `fromBlock` is the block number that the value was generated from
90         uint128 fromBlock;
91 
92         // `value` is the amount of tokens at a specific block number
93         uint128 value;
94     }
95 
96     // `parentToken` is the Token address that was cloned to produce this token;
97     //  it will be 0x0 for a token that was not cloned
98     MiniMeToken public parentToken;
99 
100     // `parentSnapShotBlock` is the block number from the Parent Token that was
101     //  used to determine the initial distribution of the Clone Token
102     uint public parentSnapShotBlock;
103 
104     // `creationBlock` is the block number that the Clone Token was created
105     uint public creationBlock;
106 
107     // `balances` is the map that tracks the balance of each address, in this
108     //  contract when the balance changes the block number that the change
109     //  occurred is also included in the map
110     mapping (address => Checkpoint[]) balances;
111 
112     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
113     mapping (address => mapping (address => uint256)) allowed;
114 
115     // Tracks the history of the `totalSupply` of the token
116     Checkpoint[] totalSupplyHistory;
117 
118     // Flag that determines if the token is transferable or not.
119     bool public transfersEnabled;
120 
121     // The factory used to create new clone tokens
122     MiniMeTokenFactory public tokenFactory;
123 
124 ////////////////
125 // Constructor
126 ////////////////
127 
128     /// @notice Constructor to create a MiniMeToken
129     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
130     ///  will create the Clone token contracts, the token factory needs to be
131     ///  deployed first
132     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
133     ///  new token
134     /// @param _parentSnapShotBlock Block of the parent token that will
135     ///  determine the initial distribution of the clone token, set to 0 if it
136     ///  is a new token
137     /// @param _tokenName Name of the new token
138     /// @param _decimalUnits Number of decimals of the new token
139     /// @param _tokenSymbol Token Symbol for the new token
140     /// @param _transfersEnabled If true, tokens will be able to be transferred
141     function MiniMeToken(
142         address _tokenFactory,
143         address _parentToken,
144         uint _parentSnapShotBlock,
145         string _tokenName,
146         uint8 _decimalUnits,
147         string _tokenSymbol,
148         bool _transfersEnabled
149     ) public {
150         tokenFactory = MiniMeTokenFactory(_tokenFactory);
151         name = _tokenName;                                 // Set the name
152         decimals = _decimalUnits;                          // Set the decimals
153         symbol = _tokenSymbol;                             // Set the symbol
154         parentToken = MiniMeToken(_parentToken);
155         parentSnapShotBlock = _parentSnapShotBlock;
156         transfersEnabled = _transfersEnabled;
157         creationBlock = block.number;
158     }
159 
160 
161 ///////////////////
162 // ERC20 Methods
163 ///////////////////
164 
165     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
166     /// @param _to The address of the recipient
167     /// @param _amount The amount of tokens to be transferred
168     /// @return Whether the transfer was successful or not
169     function transfer(address _to, uint256 _amount) public returns (bool success) {
170         require(transfersEnabled);
171         doTransfer(msg.sender, _to, _amount);
172         return true;
173     }
174 
175     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
176     ///  is approved by `_from`
177     /// @param _from The address holding the tokens being transferred
178     /// @param _to The address of the recipient
179     /// @param _amount The amount of tokens to be transferred
180     /// @return True if the transfer was successful
181     function transferFrom(address _from, address _to, uint256 _amount
182     ) public returns (bool success) {
183 
184         // The controller of this contract can move tokens around at will,
185         //  this is important to recognize! Confirm that you trust the
186         //  controller of this contract, which in most situations should be
187         //  another open source smart contract or 0x0
188         if (msg.sender != controller) {
189             require(transfersEnabled);
190 
191             // The standard ERC 20 transferFrom functionality
192             require(allowed[_from][msg.sender] >= _amount);
193             allowed[_from][msg.sender] -= _amount;
194         }
195         doTransfer(_from, _to, _amount);
196         return true;
197     }
198 
199     /// @dev This is the actual transfer function in the token contract, it can
200     ///  only be called by other functions in this contract.
201     /// @param _from The address holding the tokens being transferred
202     /// @param _to The address of the recipient
203     /// @param _amount The amount of tokens to be transferred
204     /// @return True if the transfer was successful
205     function doTransfer(address _from, address _to, uint _amount
206     ) internal {
207 
208            if (_amount == 0) {
209                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
210                return;
211            }
212 
213            require(parentSnapShotBlock < block.number);
214 
215            // Do not allow transfer to 0x0 or the token contract itself
216            require((_to != 0) && (_to != address(this)));
217 
218            // If the amount being transfered is more than the balance of the
219            //  account the transfer throws
220            var previousBalanceFrom = balanceOfAt(_from, block.number);
221 
222            require(previousBalanceFrom >= _amount);
223 
224            // Alerts the token controller of the transfer
225            if (isContract(controller)) {
226                require(TokenController(controller).onTransfer(_from, _to, _amount));
227            }
228 
229            // First update the balance array with the new value for the address
230            //  sending the tokens
231            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
232 
233            // Then update the balance array with the new value for the address
234            //  receiving the tokens
235            var previousBalanceTo = balanceOfAt(_to, block.number);
236            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
237            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
238 
239            // An event to make the transfer easy to find on the blockchain
240            Transfer(_from, _to, _amount);
241 
242     }
243 
244     /// @param _owner The address that's balance is being requested
245     /// @return The balance of `_owner` at the current block
246     function balanceOf(address _owner) public constant returns (uint256 balance) {
247         return balanceOfAt(_owner, block.number);
248     }
249 
250     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
251     ///  its behalf. This is a modified version of the ERC20 approve function
252     ///  to be a little bit safer
253     /// @param _spender The address of the account able to transfer the tokens
254     /// @param _amount The amount of tokens to be approved for transfer
255     /// @return True if the approval was successful
256     function approve(address _spender, uint256 _amount) public returns (bool success) {
257         require(transfersEnabled);
258 
259         // To change the approve amount you first have to reduce the addresses`
260         //  allowance to zero by calling `approve(_spender,0)` if it is not
261         //  already 0 to mitigate the race condition described here:
262         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
264 
265         // Alerts the token controller of the approve function call
266         if (isContract(controller)) {
267             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
268         }
269 
270         allowed[msg.sender][_spender] = _amount;
271         Approval(msg.sender, _spender, _amount);
272         return true;
273     }
274 
275     /// @dev This function makes it easy to read the `allowed[]` map
276     /// @param _owner The address of the account that owns the token
277     /// @param _spender The address of the account able to transfer the tokens
278     /// @return Amount of remaining tokens of _owner that _spender is allowed
279     ///  to spend
280     function allowance(address _owner, address _spender
281     ) public constant returns (uint256 remaining) {
282         return allowed[_owner][_spender];
283     }
284 
285     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
286     ///  its behalf, and then a function is triggered in the contract that is
287     ///  being approved, `_spender`. This allows users to use their tokens to
288     ///  interact with contracts in one function call instead of two
289     /// @param _spender The address of the contract able to transfer the tokens
290     /// @param _amount The amount of tokens to be approved for transfer
291     /// @return True if the function call was successful
292     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
293     ) public returns (bool success) {
294         require(approve(_spender, _amount));
295 
296         ApproveAndCallFallBack(_spender).receiveApproval(
297             msg.sender,
298             _amount,
299             this,
300             _extraData
301         );
302 
303         return true;
304     }
305 
306     /// @dev This function makes it easy to get the total number of tokens
307     /// @return The total number of tokens
308     function totalSupply() public constant returns (uint) {
309         return totalSupplyAt(block.number);
310     }
311 
312 
313 ////////////////
314 // Query balance and totalSupply in History
315 ////////////////
316 
317     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
318     /// @param _owner The address from which the balance will be retrieved
319     /// @param _blockNumber The block number when the balance is queried
320     /// @return The balance at `_blockNumber`
321     function balanceOfAt(address _owner, uint _blockNumber) public constant
322         returns (uint) {
323 
324         // These next few lines are used when the balance of the token is
325         //  requested before a check point was ever created for this token, it
326         //  requires that the `parentToken.balanceOfAt` be queried at the
327         //  genesis block for that token as this contains initial balance of
328         //  this token
329         if ((balances[_owner].length == 0)
330             || (balances[_owner][0].fromBlock > _blockNumber)) {
331             if (address(parentToken) != 0) {
332                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
333             } else {
334                 // Has no parent
335                 return 0;
336             }
337 
338         // This will return the expected balance during normal situations
339         } else {
340             return getValueAt(balances[_owner], _blockNumber);
341         }
342     }
343 
344     /// @notice Total amount of tokens at a specific `_blockNumber`.
345     /// @param _blockNumber The block number when the totalSupply is queried
346     /// @return The total amount of tokens at `_blockNumber`
347     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
348 
349         // These next few lines are used when the totalSupply of the token is
350         //  requested before a check point was ever created for this token, it
351         //  requires that the `parentToken.totalSupplyAt` be queried at the
352         //  genesis block for this token as that contains totalSupply of this
353         //  token at this block number.
354         if ((totalSupplyHistory.length == 0)
355             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
356             if (address(parentToken) != 0) {
357                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
358             } else {
359                 return 0;
360             }
361 
362         // This will return the expected totalSupply during normal situations
363         } else {
364             return getValueAt(totalSupplyHistory, _blockNumber);
365         }
366     }
367 
368 ////////////////
369 // Clone Token Method
370 ////////////////
371 
372     /// @notice Creates a new clone token with the initial distribution being
373     ///  this token at `_snapshotBlock`
374     /// @param _cloneTokenName Name of the clone token
375     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
376     /// @param _cloneTokenSymbol Symbol of the clone token
377     /// @param _snapshotBlock Block when the distribution of the parent token is
378     ///  copied to set the initial distribution of the new clone token;
379     ///  if the block is zero than the actual block, the current block is used
380     /// @param _transfersEnabled True if transfers are allowed in the clone
381     /// @return The address of the new MiniMeToken Contract
382     function createCloneToken(
383         string _cloneTokenName,
384         uint8 _cloneDecimalUnits,
385         string _cloneTokenSymbol,
386         uint _snapshotBlock,
387         bool _transfersEnabled
388         ) public returns(address) {
389         if (_snapshotBlock == 0) _snapshotBlock = block.number;
390         MiniMeToken cloneToken = tokenFactory.createCloneToken(
391             this,
392             _snapshotBlock,
393             _cloneTokenName,
394             _cloneDecimalUnits,
395             _cloneTokenSymbol,
396             _transfersEnabled
397             );
398 
399         cloneToken.changeController(msg.sender);
400 
401         // An event to make the token easy to find on the blockchain
402         NewCloneToken(address(cloneToken), _snapshotBlock);
403         return address(cloneToken);
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
414     function generateTokens(address _owner, uint _amount
415     ) public onlyController returns (bool) {
416         uint curTotalSupply = totalSupply();
417         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
418         uint previousBalanceTo = balanceOf(_owner);
419         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
420         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
421         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
422         Transfer(0, _owner, _amount);
423         return true;
424     }
425 
426 
427     /// @notice Burns `_amount` tokens from `_owner`
428     /// @param _owner The address that will lose the tokens
429     /// @param _amount The quantity of tokens to burn
430     /// @return True if the tokens are burned correctly
431     function destroyTokens(address _owner, uint _amount
432     ) onlyController public returns (bool) {
433         uint curTotalSupply = totalSupply();
434         require(curTotalSupply >= _amount);
435         uint previousBalanceFrom = balanceOf(_owner);
436         require(previousBalanceFrom >= _amount);
437         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
438         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
439         Transfer(_owner, 0, _amount);
440         return true;
441     }
442 
443 ////////////////
444 // Enable tokens transfers
445 ////////////////
446 
447 
448     /// @notice Enables token holders to transfer their tokens freely if true
449     /// @param _transfersEnabled True if transfers are allowed in the clone
450     function enableTransfers(bool _transfersEnabled) public onlyController {
451         transfersEnabled = _transfersEnabled;
452     }
453 
454 ////////////////
455 // Internal helper functions to query and set a value in a snapshot array
456 ////////////////
457 
458     /// @dev `getValueAt` retrieves the number of tokens at a given block number
459     /// @param checkpoints The history of values being queried
460     /// @param _block The block number to retrieve the value at
461     /// @return The number of tokens being queried
462     function getValueAt(Checkpoint[] storage checkpoints, uint _block
463     ) constant internal returns (uint) {
464         if (checkpoints.length == 0) return 0;
465 
466         // Shortcut for the actual value
467         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
468             return checkpoints[checkpoints.length-1].value;
469         if (_block < checkpoints[0].fromBlock) return 0;
470 
471         // Binary search of the value in the array
472         uint min = 0;
473         uint max = checkpoints.length-1;
474         while (max > min) {
475             uint mid = (max + min + 1)/ 2;
476             if (checkpoints[mid].fromBlock<=_block) {
477                 min = mid;
478             } else {
479                 max = mid-1;
480             }
481         }
482         return checkpoints[min].value;
483     }
484 
485     /// @dev `updateValueAtNow` used to update the `balances` map and the
486     ///  `totalSupplyHistory`
487     /// @param checkpoints The history of data being updated
488     /// @param _value The new number of tokens
489     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
490     ) internal  {
491         if ((checkpoints.length == 0)
492         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
493                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
494                newCheckPoint.fromBlock =  uint128(block.number);
495                newCheckPoint.value = uint128(_value);
496            } else {
497                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
498                oldCheckPoint.value = uint128(_value);
499            }
500     }
501 
502     /// @dev Internal function to determine if an address is a contract
503     /// @param _addr The address being queried
504     /// @return True if `_addr` is a contract
505     function isContract(address _addr) constant internal returns(bool) {
506         uint size;
507         if (_addr == 0) return false;
508         assembly {
509             size := extcodesize(_addr)
510         }
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
522     function () public payable {
523         require(isContract(controller));
524         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
525     }
526 
527 //////////
528 // Safety Methods
529 //////////
530 
531     /// @notice This method can be used by the controller to extract mistakenly
532     ///  sent tokens to this contract.
533     /// @param _token The address of the token contract that you want to recover
534     ///  set to 0 in case you want to extract ether.
535     function claimTokens(address _token) public onlyController {
536         if (_token == 0x0) {
537             controller.transfer(address(this).balance);
538             return;
539         }
540 
541         MiniMeToken token = MiniMeToken(_token);
542         uint balance = token.balanceOf(this);
543         token.transfer(controller, balance);
544         ClaimedTokens(_token, controller, balance);
545     }
546 
547 ////////////////
548 // Events
549 ////////////////
550     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
551     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
552     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
553     event Approval(
554         address indexed _owner,
555         address indexed _spender,
556         uint256 _amount
557         );
558 
559 }
560 
561 
562 ////////////////
563 // MiniMeTokenFactory
564 ////////////////
565 
566 /// @dev This contract is used to generate clone contracts from a contract.
567 ///  In solidity this is the way to create a contract from a contract of the
568 ///  same class
569 contract MiniMeTokenFactory {
570 
571     /// @notice Update the DApp by creating a new token with new functionalities
572     ///  the msg.sender becomes the controller of this clone token
573     /// @param _parentToken Address of the token being cloned
574     /// @param _snapshotBlock Block of the parent token that will
575     ///  determine the initial distribution of the clone token
576     /// @param _tokenName Name of the new token
577     /// @param _decimalUnits Number of decimals of the new token
578     /// @param _tokenSymbol Token Symbol for the new token
579     /// @param _transfersEnabled If true, tokens will be able to be transferred
580     /// @return The address of the new token contract
581     function createCloneToken(
582         address _parentToken,
583         uint _snapshotBlock,
584         string _tokenName,
585         uint8 _decimalUnits,
586         string _tokenSymbol,
587         bool _transfersEnabled
588     ) public returns (MiniMeToken) {
589         MiniMeToken newToken = new MiniMeToken(
590             this,
591             _parentToken,
592             _snapshotBlock,
593             _tokenName,
594             _decimalUnits,
595             _tokenSymbol,
596             _transfersEnabled
597             );
598 
599         newToken.changeController(msg.sender);
600         return newToken;
601     }
602 }
603 
604 contract Token is MiniMeToken {
605     // @dev Token constructor just parametrizes the MiniMeIrrevocableVestedToken constructor
606     function Token(address _tokenFactory)
607     MiniMeToken(
608         _tokenFactory,
609         0x0,            // no parent token
610         0,              // no snapshot block number from parent
611         "GBT",          // Token name
612         8,             // Decimals
613         "GBT",          // Symbol
614         true            // Enable transfers
615     ) public {}
616 }