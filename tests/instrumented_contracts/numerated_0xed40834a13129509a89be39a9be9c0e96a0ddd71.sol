1 pragma solidity ^0.4.18;
2 
3 
4 contract Controlled {
5     /// @notice The address of the controller is the only address that can call
6     ///  a function with this modifier
7     modifier onlyController { require(msg.sender == controller); _; }
8 
9     address public controller;
10 
11     function Controlled() public { controller = msg.sender;}
12 
13     /// @notice Changes the controller of the contract
14     /// @param _newController The new controller of the contract
15     function changeController(address _newController) public onlyController {
16         controller = _newController;
17     }
18 }
19 
20 /// @dev The token controller contract must implement these functions
21 contract TokenController {
22     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
23     /// @param _owner The address that sent the ether to create tokens
24     /// @return True if the ether is accepted, false if it throws
25     function proxyPayment(address _owner) public payable returns(bool);
26 
27     /// @notice Notifies the controller about a token transfer allowing the
28     ///  controller to react if desired
29     /// @param _from The origin of the transfer
30     /// @param _to The destination of the transfer
31     /// @param _amount The amount of the transfer
32     /// @return False if the controller does not authorize the transfer
33     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
34 
35     /// @notice Notifies the controller about an approval allowing the
36     ///  controller to react if desired
37     /// @param _owner The address that calls `approve()`
38     /// @param _spender The spender in the `approve()` call
39     /// @param _amount The amount in the `approve()` call
40     /// @return False if the controller does not authorize the approval
41     function onApprove(address _owner, address _spender, uint _amount) public
42         returns(bool);
43 }
44 
45 /*
46     Copyright 2016, Jordi Baylina
47 
48     This program is free software: you can redistribute it and/or modify
49     it under the terms of the GNU General Public License as published by
50     the Free Software Foundation, either version 3 of the License, or
51     (at your option) any later version.
52 
53     This program is distributed in the hope that it will be useful,
54     but WITHOUT ANY WARRANTY; without even the implied warranty of
55     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
56     GNU General Public License for more details.
57 
58     You should have received a copy of the GNU General Public License
59     along with this program.  If not, see <http://www.gnu.org/licenses/>.
60  */
61 /// @title MiniMeToken Contract
62 /// @author Jordi Baylina
63 /// @dev This token contract's goal is to make it easy for anyone to clone this
64 ///  token using the token distribution at a given block, this will allow DAO's
65 ///  and DApps to upgrade their features in a decentralized manner without
66 ///  affecting the original token
67 /// @dev It is ERC20 compliant, but still needs to under go further testing.
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
81     string public name; //The Token's name: e.g. DigixDAO Tokens
82     uint8 public decimals; //Number of decimals of the smallest unit
83     string public symbol; //An identifier: e.g. REP
84     string public version = "MMT_0.2"; //An arbitrary versioning scheme
85 
86     /// @dev `Checkpoint` is the structure that attaches a block number to a
87     ///  given value, the block number attached is the one that last changed the
88     ///  value
89     struct Checkpoint {
90         // `fromBlock` is the block number that the value was generated from
91         uint128 fromBlock;
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
102     uint256 public parentSnapShotBlock;
103 
104     // `creationBlock` is the block number that the Clone Token was created
105     uint256 public creationBlock;
106 
107     // `balances` is the map that tracks the balance of each address, in this
108     //  contract when the balance changes the block number that the change
109     //  occurred is also included in the map
110     mapping(address => Checkpoint[]) balances;
111 
112     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
113     mapping(address => mapping(address => uint256)) allowed;
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
124     ////////////////
125     // Constructor
126     ////////////////
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
141     /// @param _tokenSupply the total supply of the mini me token
142     function MiniMeToken(
143         address _tokenFactory,
144         address _parentToken,
145         uint256 _parentSnapShotBlock,
146         string _tokenName,
147         uint8 _decimalUnits,
148         string _tokenSymbol,
149         bool _transfersEnabled,
150         uint256 _tokenSupply,
151         bool _generateInitialSupply
152     ) public {
153         tokenFactory = MiniMeTokenFactory(_tokenFactory);
154         name = _tokenName; // Set the name
155         decimals = _decimalUnits; // Set the decimals
156         symbol = _tokenSymbol; // Set the symbol
157         parentToken = MiniMeToken(_parentToken);
158         parentSnapShotBlock = _parentSnapShotBlock;
159         transfersEnabled = _transfersEnabled;
160         creationBlock = block.number;
161 
162         //we don't want to generate tokens on the fly
163         //fixed supply
164         if (_generateInitialSupply) {
165             generateTokens(msg.sender, _tokenSupply);
166         }
167     }
168 
169     ///////////////////
170     // ERC20 Methods
171     ///////////////////
172 
173     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
174     /// @param _to The address of the recipient
175     /// @param _amount The amount of tokens to be transferred
176     /// @return Whether the transfer was successful or not
177     function transfer(address _to, uint256 _amount)
178         public
179         returns (bool success)
180     {
181         require(transfersEnabled);
182         doTransfer(msg.sender, _to, _amount);
183         return true;
184     }
185 
186     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
187     ///  is approved by `_from`
188     /// @param _from The address holding the tokens being transferred
189     /// @param _to The address of the recipient
190     /// @param _amount The amount of tokens to be transferred
191     /// @return True if the transfer was successful
192     function transferFrom(
193         address _from,
194         address _to,
195         uint256 _amount
196     ) public returns (bool success) {
197         // The controller of this contract can move tokens around at will,
198         //  this is important to recognize! Confirm that you trust the
199         //  controller of this contract, which in most situations should be
200         //  another open source smart contract or 0x0
201         if (msg.sender != controller) {
202             require(transfersEnabled);
203 
204             // The standard ERC 20 transferFrom functionality
205             require(allowed[_from][msg.sender] >= _amount);
206             allowed[_from][msg.sender] -= _amount;
207         }
208         doTransfer(_from, _to, _amount);
209         return true;
210     }
211 
212     /// @dev This is the actual transfer function in the token contract, it can
213     ///  only be called by other functions in this contract.
214     /// @param _from The address holding the tokens being transferred
215     /// @param _to The address of the recipient
216     /// @param _amount The amount of tokens to be transferred
217     /// @return True if the transfer was successful
218     function doTransfer(
219         address _from,
220         address _to,
221         uint256 _amount
222     ) internal {
223         if (_amount == 0) {
224             Transfer(_from, _to, _amount); // Follow the spec to louch the event when transfer 0
225             return;
226         }
227 
228         require(parentSnapShotBlock < block.number);
229 
230         // Do not allow transfer to 0x0 or the token contract itself
231         require((_to != 0) && (_to != address(this)));
232 
233         // If the amount being transfered is more than the balance of the
234         //  account the transfer throws
235         var previousBalanceFrom = balanceOfAt(_from, block.number);
236 
237         require(previousBalanceFrom >= _amount);
238 
239         // Alerts the token controller of the transfer
240         if (isContract(controller)) {
241             require(
242                 TokenController(controller).onTransfer(_from, _to, _amount)
243             );
244         }
245 
246         // First update the balance array with the new value for the address
247         //  sending the tokens
248         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
249 
250         // Then update the balance array with the new value for the address
251         //  receiving the tokens
252         var previousBalanceTo = balanceOfAt(_to, block.number);
253         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
254         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
255 
256         // An event to make the transfer easy to find on the blockchain
257         Transfer(_from, _to, _amount);
258     }
259 
260     /// @param _owner The address that's balance is being requested
261     /// @return The balance of `_owner` at the current block
262     function balanceOf(address _owner)
263         public
264         constant
265         returns (uint256 balance)
266     {
267         return balanceOfAt(_owner, block.number);
268     }
269 
270     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
271     ///  its behalf. This is a modified version of the ERC20 approve function
272     ///  to be a little bit safer
273     /// @param _spender The address of the account able to transfer the tokens
274     /// @param _amount The amount of tokens to be approved for transfer
275     /// @return True if the approval was successful
276     function approve(address _spender, uint256 _amount)
277         public
278         returns (bool success)
279     {
280         require(transfersEnabled);
281 
282         // To change the approve amount you first have to reduce the addresses`
283         //  allowance to zero by calling `approve(_spender,0)` if it is not
284         //  already 0 to mitigate the race condition described here:
285         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
286         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
287 
288         // Alerts the token controller of the approve function call
289         if (isContract(controller)) {
290             require(
291                 TokenController(controller).onApprove(
292                     msg.sender,
293                     _spender,
294                     _amount
295                 )
296             );
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
309     function allowance(address _owner, address _spender)
310         public
311         constant
312         returns (uint256 remaining)
313     {
314         return allowed[_owner][_spender];
315     }
316 
317     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
318     ///  its behalf, and then a function is triggered in the contract that is
319     ///  being approved, `_spender`. This allows users to use their tokens to
320     ///  interact with contracts in one function call instead of two
321     /// @param _spender The address of the contract able to transfer the tokens
322     /// @param _amount The amount of tokens to be approved for transfer
323     /// @return True if the function call was successful
324     function approveAndCall(
325         address _spender,
326         uint256 _amount,
327         bytes _extraData
328     ) public returns (bool success) {
329         require(approve(_spender, _amount));
330 
331         ApproveAndCallFallBack(_spender).receiveApproval(
332             msg.sender,
333             _amount,
334             this,
335             _extraData
336         );
337 
338         return true;
339     }
340 
341     /// @dev This function makes it easy to get the total number of tokens
342     /// @return The total number of tokens
343     function totalSupply() public constant returns (uint256) {
344         return totalSupplyAt(block.number);
345     }
346 
347     ////////////////
348     // Query balance and totalSupply in History
349     ////////////////
350 
351     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
352     /// @param _owner The address from which the balance will be retrieved
353     /// @param _blockNumber The block number when the balance is queried
354     /// @return The balance at `_blockNumber`
355     function balanceOfAt(address _owner, uint256 _blockNumber)
356         public
357         constant
358         returns (uint256)
359     {
360         // These next few lines are used when the balance of the token is
361         //  requested before a check point was ever created for this token, it
362         //  requires that the `parentToken.balanceOfAt` be queried at the
363         //  genesis block for that token as this contains initial balance of
364         //  this token
365         if (
366             (balances[_owner].length == 0) ||
367             (balances[_owner][0].fromBlock > _blockNumber)
368         ) {
369             if (address(parentToken) != 0) {
370                 return
371                     parentToken.balanceOfAt(
372                         _owner,
373                         min(_blockNumber, parentSnapShotBlock)
374                     );
375             } else {
376                 // Has no parent
377                 return 0;
378             }
379 
380             // This will return the expected balance during normal situations
381         } else {
382             return getValueAt(balances[_owner], _blockNumber);
383         }
384     }
385 
386     /// @notice Total amount of tokens at a specific `_blockNumber`.
387     /// @param _blockNumber The block number when the totalSupply is queried
388     /// @return The total amount of tokens at `_blockNumber`
389     function totalSupplyAt(uint256 _blockNumber)
390         public
391         constant
392         returns (uint256)
393     {
394         // These next few lines are used when the totalSupply of the token is
395         //  requested before a check point was ever created for this token, it
396         //  requires that the `parentToken.totalSupplyAt` be queried at the
397         //  genesis block for this token as that contains totalSupply of this
398         //  token at this block number.
399         if (
400             (totalSupplyHistory.length == 0) ||
401             (totalSupplyHistory[0].fromBlock > _blockNumber)
402         ) {
403             if (address(parentToken) != 0) {
404                 return
405                     parentToken.totalSupplyAt(
406                         min(_blockNumber, parentSnapShotBlock)
407                     );
408             } else {
409                 return 0;
410             }
411 
412             // This will return the expected totalSupply during normal situations
413         } else {
414             return getValueAt(totalSupplyHistory, _blockNumber);
415         }
416     }
417 
418     ////////////////
419     // Clone Token Method
420     ////////////////
421 
422     /// @notice Creates a new clone token with the initial distribution being
423     ///  this token at `_snapshotBlock`
424     /// @param _cloneTokenName Name of the clone token
425     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
426     /// @param _cloneTokenSymbol Symbol of the clone token
427     /// @param _snapshotBlock Block when the distribution of the parent token is
428     ///  copied to set the initial distribution of the new clone token;
429     ///  if the block is zero than the actual block, the current block is used
430     /// @param _transfersEnabled True if transfers are allowed in the clone
431     /// @param _totalSupply the total supply of the mini me clone
432     /// @return The address of the new MiniMeToken Contract
433     function createCloneToken(
434         string _cloneTokenName,
435         uint8 _cloneDecimalUnits,
436         string _cloneTokenSymbol,
437         uint256 _snapshotBlock,
438         bool _transfersEnabled,
439         uint256 _totalSupply
440     ) public returns (address) {
441         if (_snapshotBlock == 0) _snapshotBlock = block.number;
442         MiniMeToken cloneToken =
443             tokenFactory.createCloneToken(
444                 this,
445                 _snapshotBlock,
446                 _cloneTokenName,
447                 _cloneDecimalUnits,
448                 _cloneTokenSymbol,
449                 _transfersEnabled,
450                 _totalSupply
451             );
452 
453         cloneToken.changeController(msg.sender);
454 
455         // An event to make the token easy to find on the blockchain
456         NewCloneToken(address(cloneToken), _snapshotBlock);
457         return address(cloneToken);
458     }
459 
460     ////////////////
461     // Generate and destroy tokens
462     ////////////////
463 
464     /// @notice Generates `_amount` tokens that are assigned to `_owner`
465     /// @param _owner The address that will be assigned the new tokens
466     /// @param _amount The quantity of tokens generated
467     /// @return True if the tokens are generated correctly
468     function generateTokens(address _owner, uint256 _amount)
469         private
470         onlyController
471         returns (bool)
472     {
473         uint256 curTotalSupply = totalSupply();
474         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
475         uint256 previousBalanceTo = balanceOf(_owner);
476         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
477         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
478         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
479         Transfer(0, _owner, _amount);
480         return true;
481     }
482 
483     /// @notice Burns `_amount` tokens from `_owner`
484     /// @param _owner The address that will lose the tokens
485     /// @param _amount The quantity of tokens to burn
486     /// @return True if the tokens are burned correctly
487     function destroyTokens(address _owner, uint256 _amount)
488         private
489         onlyController
490         returns (bool)
491     {
492         uint256 curTotalSupply = totalSupply();
493         require(curTotalSupply >= _amount);
494         uint256 previousBalanceFrom = balanceOf(_owner);
495         require(previousBalanceFrom >= _amount);
496         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
497         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
498         Transfer(_owner, 0, _amount);
499         return true;
500     }
501 
502     ////////////////
503     // Enable tokens transfers
504     ////////////////
505 
506     /// @notice Enables token holders to transfer their tokens freely if true
507     /// @param _transfersEnabled True if transfers are allowed in the clone
508     function enableTransfers(bool _transfersEnabled) public onlyController {
509         transfersEnabled = _transfersEnabled;
510     }
511 
512     ////////////////
513     // Internal helper functions to query and set a value in a snapshot array
514     ////////////////
515 
516     /// @dev `getValueAt` retrieves the number of tokens at a given block number
517     /// @param checkpoints The history of values being queried
518     /// @param _block The block number to retrieve the value at
519     /// @return The number of tokens being queried
520     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block)
521         internal
522         constant
523         returns (uint256)
524     {
525         if (checkpoints.length == 0) return 0;
526 
527         // Shortcut for the actual value
528         if (_block >= checkpoints[checkpoints.length - 1].fromBlock)
529             return checkpoints[checkpoints.length - 1].value;
530         if (_block < checkpoints[0].fromBlock) return 0;
531 
532         // Binary search of the value in the array
533         uint256 min = 0;
534         uint256 max = checkpoints.length - 1;
535         while (max > min) {
536             uint256 mid = (max + min + 1) / 2;
537             if (checkpoints[mid].fromBlock <= _block) {
538                 min = mid;
539             } else {
540                 max = mid - 1;
541             }
542         }
543         return checkpoints[min].value;
544     }
545 
546     /// @dev `updateValueAtNow` used to update the `balances` map and the
547     ///  `totalSupplyHistory`
548     /// @param checkpoints The history of data being updated
549     /// @param _value The new number of tokens
550     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value)
551         internal
552     {
553         if (
554             (checkpoints.length == 0) ||
555             (checkpoints[checkpoints.length - 1].fromBlock < block.number)
556         ) {
557             Checkpoint storage newCheckPoint =
558                 checkpoints[checkpoints.length++];
559             newCheckPoint.fromBlock = uint128(block.number);
560             newCheckPoint.value = uint128(_value);
561         } else {
562             Checkpoint storage oldCheckPoint =
563                 checkpoints[checkpoints.length - 1];
564             oldCheckPoint.value = uint128(_value);
565         }
566     }
567 
568     /// @dev Internal function to determine if an address is a contract
569     /// @param _addr The address being queried
570     /// @return True if `_addr` is a contract
571     function isContract(address _addr) internal constant returns (bool) {
572         uint256 size;
573         if (_addr == 0) return false;
574         assembly {
575             size := extcodesize(_addr)
576         }
577         return size > 0;
578     }
579 
580     /// @dev Helper function to return a min betwen the two uints
581     function min(uint256 a, uint256 b) internal pure returns (uint256) {
582         return a < b ? a : b;
583     }
584 
585     /// @notice The fallback function: If the contract's controller has not been
586     ///  set to 0, then the `proxyPayment` method is called which relays the
587     ///  ether and creates tokens as described in the token controller contract
588     function() public payable {
589         require(isContract(controller));
590         require(
591             TokenController(controller).proxyPayment.value(msg.value)(
592                 msg.sender
593             )
594         );
595     }
596 
597     //////////
598     // Safety Methods
599     //////////
600 
601     /// @notice This method can be used by the controller to extract mistakenly
602     ///  sent tokens to this contract.
603     /// @param _token The address of the token contract that you want to recover
604     ///  set to 0 in case you want to extract ether.
605     function claimTokens(address _token) public onlyController {
606         if (_token == 0x0) {
607             controller.transfer(this.balance);
608             return;
609         }
610 
611         MiniMeToken token = MiniMeToken(_token);
612         uint256 balance = token.balanceOf(this);
613         token.transfer(controller, balance);
614         ClaimedTokens(_token, controller, balance);
615     }
616 
617     ////////////////
618     // Events
619     ////////////////
620     event ClaimedTokens(
621         address indexed _token,
622         address indexed _controller,
623         uint256 _amount
624     );
625     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
626     event NewCloneToken(address indexed _cloneToken, uint256 _snapshotBlock);
627     event Approval(
628         address indexed _owner,
629         address indexed _spender,
630         uint256 _amount
631     );
632 }
633 
634 ////////////////
635 // MiniMeTokenFactory
636 ////////////////
637 /// @dev This contract is used to generate clone contracts from a contract.
638 ///  In solidity this is the way to create a contract from a contract of the
639 ///  same class
640 contract MiniMeTokenFactory {
641     /// @notice Update the DApp by creating a new token with new functionalities
642     ///  the msg.sender becomes the controller of this clone token
643     /// @param _parentToken Address of the token being cloned
644     /// @param _snapshotBlock Block of the parent token that will
645     ///  determine the initial distribution of the clone token
646     /// @param _tokenName Name of the new token
647     /// @param _decimalUnits Number of decimals of the new token
648     /// @param _tokenSymbol Token Symbol for the new token
649     /// @param _transfersEnabled If true, tokens will be able to be transferred
650     /// @param _tokenSupply the total supply of the mini me token
651     /// @return The address of the new token contract
652     function createCloneToken(
653         address _parentToken,
654         uint256 _snapshotBlock,
655         string _tokenName,
656         uint8 _decimalUnits,
657         string _tokenSymbol,
658         bool _transfersEnabled,
659         uint256 _tokenSupply
660     ) public returns (MiniMeToken) {
661         MiniMeToken newToken =
662             new MiniMeToken(
663                 this,
664                 _parentToken,
665                 _snapshotBlock,
666                 _tokenName,
667                 _decimalUnits,
668                 _tokenSymbol,
669                 _transfersEnabled,
670                 _tokenSupply, 
671                 false
672             );
673 
674         newToken.changeController(msg.sender);
675         return newToken;
676     }
677 }