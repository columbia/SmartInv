1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 contract ERC20 {
35   /// @notice Send `_amount` tokens to `_to` from `msg.sender`
36   /// @param _to The address of the recipient
37   /// @param _amount The amount of tokens to be transferred
38   /// @return Whether the transfer was successful or not
39   function transfer(address _to, uint256 _amount) returns (bool success);
40 
41   /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
42   ///  is approved by `_from`
43   /// @param _from The address holding the tokens being transferred
44   /// @param _to The address of the recipient
45   /// @param _amount The amount of tokens to be transferred
46   /// @return True if the transfer was successful
47   function transferFrom(address _from, address _to, uint256 _amount
48   ) returns (bool success);
49 
50   /// @param _owner The address that's balance is being requested
51   /// @return The balance of `_owner` at the current block
52   function balanceOf(address _owner) constant returns (uint256 balance);
53 
54   /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
55   ///  its behalf. This is a modified version of the ERC20 approve function
56   ///  to be a little bit safer
57   /// @param _spender The address of the account able to transfer the tokens
58   /// @param _amount The amount of tokens to be approved for transfer
59   /// @return True if the approval was successful
60   function approve(address _spender, uint256 _amount) returns (bool success);
61 
62   /// @dev This function makes it easy to read the `allowed[]` map
63   /// @param _owner The address of the account that owns the token
64   /// @param _spender The address of the account able to transfer the tokens
65   /// @return Amount of remaining tokens of _owner that _spender is allowed
66   ///  to spend
67   function allowance(address _owner, address _spender
68   ) constant returns (uint256 remaining);
69 
70   /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
71   ///  its behalf, and then a function is triggered in the contract that is
72   ///  being approved, `_spender`. This allows users to use their tokens to
73   ///  interact with contracts in one function call instead of two
74   /// @param _spender The address of the contract able to transfer the tokens
75   /// @param _amount The amount of tokens to be approved for transfer
76   /// @return True if the function call was successful
77   function approveAndCall(address _spender, uint256 _amount, bytes _extraData
78   ) returns (bool success);
79 
80   /// @dev This function makes it easy to get the total number of tokens
81   /// @return The total number of tokens
82   function totalSupply() constant returns (uint);
83 }
84 
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
104 /// @author Jordi Baylina
105 /// @dev This token contract's goal is to make it easy for anyone to clone this
106 ///  token using the token distribution at a given block, this will allow DAO's
107 ///  and DApps to upgrade their features in a decentralized manner without
108 ///  affecting the original token
109 /// @dev It is ERC20 compliant, but still needs to under go further testing.
110 
111 
112 /// @dev The token controller contract must implement these functions
113 contract TokenController {
114     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
115     /// @param _owner The address that sent the ether to create tokens
116     /// @return True if the ether is accepted, false if it throws
117     function proxyPayment(address _owner) payable returns(bool);
118 
119     /// @notice Notifies the controller about a token transfer allowing the
120     ///  controller to react if desired
121     /// @param _from The origin of the transfer
122     /// @param _to The destination of the transfer
123     /// @param _amount The amount of the transfer
124     /// @return False if the controller does not authorize the transfer
125     function onTransfer(address _from, address _to, uint _amount) returns(bool);
126 
127     /// @notice Notifies the controller about an approval allowing the
128     ///  controller to react if desired
129     /// @param _owner The address that calls `approve()`
130     /// @param _spender The spender in the `approve()` call
131     /// @param _amount The amount in the `approve()` call
132     /// @return False if the controller does not authorize the approval
133     function onApprove(address _owner, address _spender, uint _amount)
134         returns(bool);
135 }
136 
137 contract Controlled {
138     /// @notice The address of the controller is the only address that can call
139     ///  a function with this modifier
140     modifier onlyController { require(msg.sender == controller); _; }
141 
142     address public controller;
143 
144     function Controlled() { controller = msg.sender;}
145 
146     /// @notice Changes the controller of the contract
147     /// @param _newController The new controller of the contract
148     function changeController(address _newController) onlyController {
149         controller = _newController;
150     }
151 }
152 
153 contract ApproveAndCallFallBack {
154     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
155 }
156 
157 /// @dev The actual token contract, the default controller is the msg.sender
158 ///  that deploys the contract, so usually this token will be deployed by a
159 ///  token controller contract, which Giveth will call a "Campaign"
160 contract MiniMeToken is Controlled {
161 
162     string public name;                //The Token's name: e.g. DigixDAO Tokens
163     uint8 public decimals;             //Number of decimals of the smallest unit
164     string public symbol;              //An identifier: e.g. REP
165     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
166 
167 
168     /// @dev `Checkpoint` is the structure that attaches a block number to a
169     ///  given value, the block number attached is the one that last changed the
170     ///  value
171     struct  Checkpoint {
172 
173         // `fromBlock` is the block number that the value was generated from
174         uint128 fromBlock;
175 
176         // `value` is the amount of tokens at a specific block number
177         uint128 value;
178     }
179 
180     // `parentToken` is the Token address that was cloned to produce this token;
181     //  it will be 0x0 for a token that was not cloned
182     MiniMeToken public parentToken;
183 
184     // `parentSnapShotBlock` is the block number from the Parent Token that was
185     //  used to determine the initial distribution of the Clone Token
186     uint public parentSnapShotBlock;
187 
188     // `creationBlock` is the block number that the Clone Token was created
189     uint public creationBlock;
190 
191     // `balances` is the map that tracks the balance of each address, in this
192     //  contract when the balance changes the block number that the change
193     //  occurred is also included in the map
194     mapping (address => Checkpoint[]) balances;
195 
196     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
197     mapping (address => mapping (address => uint256)) allowed;
198 
199     // Tracks the history of the `totalSupply` of the token
200     Checkpoint[] totalSupplyHistory;
201 
202     // Flag that determines if the token is transferable or not.
203     bool public transfersEnabled;
204 
205     // The factory used to create new clone tokens
206     MiniMeTokenFactory public tokenFactory;
207 
208 ////////////////
209 // Constructor
210 ////////////////
211 
212     /// @notice Constructor to create a MiniMeToken
213     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
214     ///  will create the Clone token contracts, the token factory needs to be
215     ///  deployed first
216     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
217     ///  new token
218     /// @param _parentSnapShotBlock Block of the parent token that will
219     ///  determine the initial distribution of the clone token, set to 0 if it
220     ///  is a new token
221     /// @param _tokenName Name of the new token
222     /// @param _decimalUnits Number of decimals of the new token
223     /// @param _tokenSymbol Token Symbol for the new token
224     /// @param _transfersEnabled If true, tokens will be able to be transferred
225     function MiniMeToken(
226         address _tokenFactory,
227         address _parentToken,
228         uint _parentSnapShotBlock,
229         string _tokenName,
230         uint8 _decimalUnits,
231         string _tokenSymbol,
232         bool _transfersEnabled
233     ) {
234         tokenFactory = MiniMeTokenFactory(_tokenFactory);
235         name = _tokenName;                                 // Set the name
236         decimals = _decimalUnits;                          // Set the decimals
237         symbol = _tokenSymbol;                             // Set the symbol
238         parentToken = MiniMeToken(_parentToken);
239         parentSnapShotBlock = _parentSnapShotBlock;
240         transfersEnabled = _transfersEnabled;
241         creationBlock = block.number;
242     }
243 
244 
245 ///////////////////
246 // ERC20 Methods
247 ///////////////////
248 
249     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
250     /// @param _to The address of the recipient
251     /// @param _amount The amount of tokens to be transferred
252     /// @return Whether the transfer was successful or not
253     function transfer(address _to, uint256 _amount) returns (bool success) {
254         require(transfersEnabled);
255         return doTransfer(msg.sender, _to, _amount);
256     }
257 
258     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
259     ///  is approved by `_from`
260     /// @param _from The address holding the tokens being transferred
261     /// @param _to The address of the recipient
262     /// @param _amount The amount of tokens to be transferred
263     /// @return True if the transfer was successful
264     function transferFrom(address _from, address _to, uint256 _amount
265     ) returns (bool success) {
266 
267         // The controller of this contract can move tokens around at will,
268         //  this is important to recognize! Confirm that you trust the
269         //  controller of this contract, which in most situations should be
270         //  another open source smart contract or 0x0
271         if (msg.sender != controller) {
272             require(transfersEnabled);
273 
274             // The standard ERC 20 transferFrom functionality
275             if (allowed[_from][msg.sender] < _amount) return false;
276             allowed[_from][msg.sender] -= _amount;
277         }
278         return doTransfer(_from, _to, _amount);
279     }
280 
281     /// @dev This is the actual transfer function in the token contract, it can
282     ///  only be called by other functions in this contract.
283     /// @param _from The address holding the tokens being transferred
284     /// @param _to The address of the recipient
285     /// @param _amount The amount of tokens to be transferred
286     /// @return True if the transfer was successful
287     function doTransfer(address _from, address _to, uint _amount
288     ) internal returns(bool) {
289 
290            if (_amount == 0) {
291                return true;
292            }
293 
294            require(parentSnapShotBlock < block.number);
295 
296            // Do not allow transfer to 0x0 or the token contract itself
297            require((_to != 0) && (_to != address(this)));
298 
299            // If the amount being transfered is more than the balance of the
300            //  account the transfer returns false
301            var previousBalanceFrom = balanceOfAt(_from, block.number);
302            if (previousBalanceFrom < _amount) {
303                return false;
304            }
305 
306            // Alerts the token controller of the transfer
307            if (isContract(controller)) {
308                require(TokenController(controller).onTransfer(_from, _to, _amount));
309            }
310 
311            // First update the balance array with the new value for the address
312            //  sending the tokens
313            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
314 
315            // Then update the balance array with the new value for the address
316            //  receiving the tokens
317            var previousBalanceTo = balanceOfAt(_to, block.number);
318            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
319            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
320 
321            // An event to make the transfer easy to find on the blockchain
322            Transfer(_from, _to, _amount);
323 
324            return true;
325     }
326 
327     /// @param _owner The address that's balance is being requested
328     /// @return The balance of `_owner` at the current block
329     function balanceOf(address _owner) constant returns (uint256 balance) {
330         return balanceOfAt(_owner, block.number);
331     }
332 
333     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
334     ///  its behalf. This is a modified version of the ERC20 approve function
335     ///  to be a little bit safer
336     /// @param _spender The address of the account able to transfer the tokens
337     /// @param _amount The amount of tokens to be approved for transfer
338     /// @return True if the approval was successful
339     function approve(address _spender, uint256 _amount) returns (bool success) {
340         require(transfersEnabled);
341 
342         // To change the approve amount you first have to reduce the addresses`
343         //  allowance to zero by calling `approve(_spender,0)` if it is not
344         //  already 0 to mitigate the race condition described here:
345         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
346         // Recommended by Bokky Poobah to remove this check
347         // require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
348 
349         // Alerts the token controller of the approve function call
350         if (isContract(controller)) {
351             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
352         }
353 
354         allowed[msg.sender][_spender] = _amount;
355         Approval(msg.sender, _spender, _amount);
356         return true;
357     }
358 
359     /// @dev This function makes it easy to read the `allowed[]` map
360     /// @param _owner The address of the account that owns the token
361     /// @param _spender The address of the account able to transfer the tokens
362     /// @return Amount of remaining tokens of _owner that _spender is allowed
363     ///  to spend
364     function allowance(address _owner, address _spender
365     ) constant returns (uint256 remaining) {
366         return allowed[_owner][_spender];
367     }
368 
369     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
370     ///  its behalf, and then a function is triggered in the contract that is
371     ///  being approved, `_spender`. This allows users to use their tokens to
372     ///  interact with contracts in one function call instead of two
373     /// @param _spender The address of the contract able to transfer the tokens
374     /// @param _amount The amount of tokens to be approved for transfer
375     /// @return True if the function call was successful
376     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
377     ) returns (bool success) {
378         require(approve(_spender, _amount));
379 
380         ApproveAndCallFallBack(_spender).receiveApproval(
381             msg.sender,
382             _amount,
383             this,
384             _extraData
385         );
386 
387         return true;
388     }
389 
390     /// @dev This function makes it easy to get the total number of tokens
391     /// @return The total number of tokens
392     function totalSupply() constant returns (uint) {
393         return totalSupplyAt(block.number);
394     }
395 
396 
397 ////////////////
398 // Query balance and totalSupply in History
399 ////////////////
400 
401     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
402     /// @param _owner The address from which the balance will be retrieved
403     /// @param _blockNumber The block number when the balance is queried
404     /// @return The balance at `_blockNumber`
405     function balanceOfAt(address _owner, uint _blockNumber) constant
406         returns (uint) {
407 
408         // These next few lines are used when the balance of the token is
409         //  requested before a check point was ever created for this token, it
410         //  requires that the `parentToken.balanceOfAt` be queried at the
411         //  genesis block for that token as this contains initial balance of
412         //  this token
413         if ((balances[_owner].length == 0)
414             || (balances[_owner][0].fromBlock > _blockNumber)) {
415             if (address(parentToken) != 0) {
416                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
417             } else {
418                 // Has no parent
419                 return 0;
420             }
421 
422         // This will return the expected balance during normal situations
423         } else {
424             return getValueAt(balances[_owner], _blockNumber);
425         }
426     }
427 
428     /// @notice Total amount of tokens at a specific `_blockNumber`.
429     /// @param _blockNumber The block number when the totalSupply is queried
430     /// @return The total amount of tokens at `_blockNumber`
431     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
432 
433         // These next few lines are used when the totalSupply of the token is
434         //  requested before a check point was ever created for this token, it
435         //  requires that the `parentToken.totalSupplyAt` be queried at the
436         //  genesis block for this token as that contains totalSupply of this
437         //  token at this block number.
438         if ((totalSupplyHistory.length == 0)
439             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
440             if (address(parentToken) != 0) {
441                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
442             } else {
443                 return 0;
444             }
445 
446         // This will return the expected totalSupply during normal situations
447         } else {
448             return getValueAt(totalSupplyHistory, _blockNumber);
449         }
450     }
451 
452 ////////////////
453 // Clone Token Method
454 ////////////////
455 
456     /// @notice Creates a new clone token with the initial distribution being
457     ///  this token at `_snapshotBlock`
458     /// @param _cloneTokenName Name of the clone token
459     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
460     /// @param _cloneTokenSymbol Symbol of the clone token
461     /// @param _snapshotBlock Block when the distribution of the parent token is
462     ///  copied to set the initial distribution of the new clone token;
463     ///  if the block is zero than the actual block, the current block is used
464     /// @param _transfersEnabled True if transfers are allowed in the clone
465     /// @return The address of the new MiniMeToken Contract
466     function createCloneToken(
467         string _cloneTokenName,
468         uint8 _cloneDecimalUnits,
469         string _cloneTokenSymbol,
470         uint _snapshotBlock,
471         bool _transfersEnabled
472         ) returns(address) {
473         if (_snapshotBlock == 0) _snapshotBlock = block.number;
474         MiniMeToken cloneToken = tokenFactory.createCloneToken(
475             this,
476             _snapshotBlock,
477             _cloneTokenName,
478             _cloneDecimalUnits,
479             _cloneTokenSymbol,
480             _transfersEnabled
481             );
482 
483         cloneToken.changeController(msg.sender);
484 
485         // An event to make the token easy to find on the blockchain
486         NewCloneToken(address(cloneToken), _snapshotBlock);
487         return address(cloneToken);
488     }
489 
490 ////////////////
491 // Generate and destroy tokens
492 ////////////////
493 
494     /// @notice Generates `_amount` tokens that are assigned to `_owner`
495     /// @param _owner The address that will be assigned the new tokens
496     /// @param _amount The quantity of tokens generated
497     /// @return True if the tokens are generated correctly
498     function generateTokens(address _owner, uint _amount
499     ) onlyController returns (bool) {
500         uint curTotalSupply = totalSupply();
501         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
502         uint previousBalanceTo = balanceOf(_owner);
503         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
504         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
505         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
506         Transfer(0, _owner, _amount);
507         return true;
508     }
509 
510 
511     /// @notice Burns `_amount` tokens from `_owner`
512     /// @param _owner The address that will lose the tokens
513     /// @param _amount The quantity of tokens to burn
514     /// @return True if the tokens are burned correctly
515     function destroyTokens(address _owner, uint _amount
516     ) onlyController returns (bool) {
517         uint curTotalSupply = totalSupply();
518         require(curTotalSupply >= _amount);
519         uint previousBalanceFrom = balanceOf(_owner);
520         require(previousBalanceFrom >= _amount);
521         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
522         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
523         Transfer(_owner, 0, _amount);
524         return true;
525     }
526 
527 ////////////////
528 // Enable tokens transfers
529 ////////////////
530 
531 
532     /// @notice Enables token holders to transfer their tokens freely if true
533     /// @param _transfersEnabled True if transfers are allowed in the clone
534     function enableTransfers(bool _transfersEnabled) onlyController {
535         transfersEnabled = _transfersEnabled;
536     }
537 
538 ////////////////
539 // Internal helper functions to query and set a value in a snapshot array
540 ////////////////
541 
542     /// @dev `getValueAt` retrieves the number of tokens at a given block number
543     /// @param checkpoints The history of values being queried
544     /// @param _block The block number to retrieve the value at
545     /// @return The number of tokens being queried
546     function getValueAt(Checkpoint[] storage checkpoints, uint _block
547     ) constant internal returns (uint) {
548         if (checkpoints.length == 0) return 0;
549 
550         // Shortcut for the actual value
551         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
552             return checkpoints[checkpoints.length-1].value;
553         if (_block < checkpoints[0].fromBlock) return 0;
554 
555         // Binary search of the value in the array
556         uint min = 0;
557         uint max = checkpoints.length-1;
558         while (max > min) {
559             uint mid = (max + min + 1)/ 2;
560             if (checkpoints[mid].fromBlock<=_block) {
561                 min = mid;
562             } else {
563                 max = mid-1;
564             }
565         }
566         return checkpoints[min].value;
567     }
568 
569     /// @dev `updateValueAtNow` used to update the `balances` map and the
570     ///  `totalSupplyHistory`
571     /// @param checkpoints The history of data being updated
572     /// @param _value The new number of tokens
573     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
574     ) internal  {
575         if ((checkpoints.length == 0)
576         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
577                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
578                newCheckPoint.fromBlock =  uint128(block.number);
579                newCheckPoint.value = uint128(_value);
580            } else {
581                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
582                oldCheckPoint.value = uint128(_value);
583            }
584     }
585 
586     /// @dev Internal function to determine if an address is a contract
587     /// @param _addr The address being queried
588     /// @return True if `_addr` is a contract
589     function isContract(address _addr) constant internal returns(bool) {
590         uint size;
591         if (_addr == 0) return false;
592         assembly {
593             size := extcodesize(_addr)
594         }
595         return size>0;
596     }
597 
598     /// @dev Helper function to return a min betwen the two uints
599     function min(uint a, uint b) internal returns (uint) {
600         return a < b ? a : b;
601     }
602 
603     /// @notice The fallback function: If the contract's controller has not been
604     ///  set to 0, then the `proxyPayment` method is called which relays the
605     ///  ether and creates tokens as described in the token controller contract
606     function ()  payable {
607         require(isContract(controller));
608         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
609     }
610 
611 //////////
612 // Safety Methods
613 //////////
614 
615     /// @notice This method can be used by the controller to extract mistakenly
616     ///  sent tokens to this contract.
617     /// @param _token The address of the token contract that you want to recover
618     ///  set to 0 in case you want to extract ether.
619     function claimTokens(address _token) onlyController {
620         if (_token == 0x0) {
621             controller.transfer(this.balance);
622             return;
623         }
624 
625         MiniMeToken token = MiniMeToken(_token);
626         uint balance = token.balanceOf(this);
627         token.transfer(controller, balance);
628         ClaimedTokens(_token, controller, balance);
629     }
630 
631 ////////////////
632 // Events
633 ////////////////
634     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
635     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
636     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
637     event Approval(
638         address indexed _owner,
639         address indexed _spender,
640         uint256 _amount
641         );
642 
643 }
644 
645 
646 ////////////////
647 // MiniMeTokenFactory
648 ////////////////
649 
650 /// @dev This contract is used to generate clone contracts from a contract.
651 ///  In solidity this is the way to create a contract from a contract of the
652 ///  same class
653 contract MiniMeTokenFactory {
654 
655     /// @notice Update the DApp by creating a new token with new functionalities
656     ///  the msg.sender becomes the controller of this clone token
657     /// @param _parentToken Address of the token being cloned
658     /// @param _snapshotBlock Block of the parent token that will
659     ///  determine the initial distribution of the clone token
660     /// @param _tokenName Name of the new token
661     /// @param _decimalUnits Number of decimals of the new token
662     /// @param _tokenSymbol Token Symbol for the new token
663     /// @param _transfersEnabled If true, tokens will be able to be transferred
664     /// @return The address of the new token contract
665     function createCloneToken(
666         address _parentToken,
667         uint _snapshotBlock,
668         string _tokenName,
669         uint8 _decimalUnits,
670         string _tokenSymbol,
671         bool _transfersEnabled
672     ) returns (MiniMeToken) {
673         MiniMeToken newToken = new MiniMeToken(
674             this,
675             _parentToken,
676             _snapshotBlock,
677             _tokenName,
678             _decimalUnits,
679             _tokenSymbol,
680             _transfersEnabled
681             );
682 
683         newToken.changeController(msg.sender);
684         return newToken;
685     }
686 }
687 
688 /**
689  * @title Aigang Contribution contract
690  *
691  *  By contributing ETH to this smart contract you agree to the following terms and conditions:
692  *  https://github.com/AigangNetwork/aigang-crowdsale-contracts/Aigang-T&Cs(171020_clean).docx
693  *
694  */
695 
696 contract Contribution is Controlled, TokenController {
697   using SafeMath for uint256;
698 
699   MiniMeToken public aix;
700   bool public transferable;
701   address public contributionWallet;
702   address public remainderHolder;
703   address public devHolder;
704   address public communityHolder;
705   address public exchanger;
706 
707   address public collector;
708   uint256 public collectorWeiCap;
709   uint256 public collectorWeiCollected;
710 
711   uint256 public totalWeiCap;             // Total Wei to be collected
712   uint256 public totalWeiCollected;       // How much Wei has been collected
713   uint256 public weiPreCollected;
714   uint256 public notCollectedAmountAfter24Hours;
715   uint256 public twentyPercentWithBonus;
716   uint256 public thirtyPercentWithBonus;
717 
718   uint256 public minimumPerTransaction = 0.01 ether;
719 
720   uint256 public numWhitelistedInvestors;
721   mapping (address => bool) public canPurchase;
722   mapping (address => uint256) public individualWeiCollected;
723 
724   uint256 public startTime;
725   uint256 public endTime;
726 
727   uint256 public initializedTime;
728   uint256 public finalizedTime;
729 
730   uint256 public initializedBlock;
731   uint256 public finalizedBlock;
732 
733   bool public paused;
734 
735   modifier initialized() {
736     require(initializedBlock != 0);
737     _;
738   }
739 
740   modifier contributionOpen() {
741     // collector can start depositing 2 days prior
742     if (msg.sender == collector) {
743       require(getBlockTimestamp().add(2 days) >= startTime);
744     } else {
745       require(getBlockTimestamp() >= startTime);
746     }
747     require(getBlockTimestamp() <= endTime);
748     require(finalizedTime == 0);
749     _;
750   }
751 
752   modifier notPaused() {
753     require(!paused);
754     _;
755   }
756 
757   function Contribution(address _aix) {
758     require(_aix != 0x0);
759     aix = MiniMeToken(_aix);
760   }
761 
762   function initialize(
763       address _apt,
764       address _exchanger,
765       address _contributionWallet,
766       address _remainderHolder,
767       address _devHolder,
768       address _communityHolder,
769       address _collector,
770       uint256 _collectorWeiCap,
771       uint256 _totalWeiCap,
772       uint256 _startTime,
773       uint256 _endTime
774   ) public onlyController {
775     // Initialize only once
776     require(initializedBlock == 0);
777     require(initializedTime == 0);
778     assert(aix.totalSupply() == 0);
779     assert(aix.controller() == address(this));
780     assert(aix.decimals() == 18);  // Same amount of decimals as ETH
781 
782     require(_contributionWallet != 0x0);
783     contributionWallet = _contributionWallet;
784 
785     require(_remainderHolder != 0x0);
786     remainderHolder = _remainderHolder;
787 
788     require(_devHolder != 0x0);
789     devHolder = _devHolder;
790 
791     require(_communityHolder != 0x0);
792     communityHolder = _communityHolder;
793 
794     require(_collector != 0x0);
795     collector = _collector;
796 
797     require(_collectorWeiCap > 0);
798     require(_collectorWeiCap <= _totalWeiCap);
799     collectorWeiCap = _collectorWeiCap;
800 
801     assert(_startTime >= getBlockTimestamp());
802     require(_startTime < _endTime);
803     startTime = _startTime;
804     endTime = _endTime;
805 
806     require(_totalWeiCap > 0);
807     totalWeiCap = _totalWeiCap;
808 
809     initializedBlock = getBlockNumber();
810     initializedTime = getBlockTimestamp();
811 
812     require(_apt != 0x0);
813     require(_exchanger != 0x0);
814 
815     weiPreCollected = MiniMeToken(_apt).totalSupplyAt(initializedBlock);
816 
817     // Exchangerate from apt to aix 2500 considering 25% bonus.
818     require(aix.generateTokens(_exchanger, weiPreCollected.mul(2500)));
819     exchanger = _exchanger;
820 
821     Initialized(initializedBlock);
822   }
823 
824   /// @notice interface for founders to blacklist investors
825   /// @param _investors array of investors
826   function blacklistAddresses(address[] _investors) public onlyController {
827     for (uint256 i = 0; i < _investors.length; i++) {
828       blacklist(_investors[i]);
829     }
830   }
831 
832   /// @notice interface for founders to whitelist investors
833   /// @param _investors array of investors
834   function whitelistAddresses(address[] _investors) public onlyController {
835     for (uint256 i = 0; i < _investors.length; i++) {
836       whitelist(_investors[i]);
837     }
838   }
839 
840   function whitelist(address investor) public onlyController {
841     if (canPurchase[investor]) return;
842     numWhitelistedInvestors++;
843     canPurchase[investor] = true;
844   }
845 
846   function blacklist(address investor) public onlyController {
847     if (!canPurchase[investor]) return;
848     numWhitelistedInvestors--;
849     canPurchase[investor] = false;
850   }
851 
852   // ETH-AIX exchange rate
853   function exchangeRate() constant public initialized returns (uint256) {
854     if (getBlockTimestamp() <= startTime + 1 hours) {
855       // 15% Bonus
856       return 2300;
857     }
858 
859     if (getBlockTimestamp() <= startTime + 2 hours) {
860       // 10% Bonus
861       return 2200;
862     }
863 
864     if (getBlockTimestamp() <= startTime + 1 days) {
865       return 2000;
866     }
867 
868     uint256 collectedAfter24Hours = notCollectedAmountAfter24Hours.sub(weiToCollect());
869 
870     if (collectedAfter24Hours <= twentyPercentWithBonus) {
871       // 15% Bonus
872       return 2300;
873     }
874 
875     if (collectedAfter24Hours <= twentyPercentWithBonus + thirtyPercentWithBonus) {
876       // 10% Bonus
877       return 2200;
878     }
879 
880     return 2000;
881   }
882 
883   function tokensToGenerate(uint256 toFund) constant public returns (uint256) {
884     // collector gets 15% bonus
885     if (msg.sender == collector) {
886       return toFund.mul(2300);
887     }
888 
889     return toFund.mul(exchangeRate());
890   }
891 
892   /// @notice If anybody sends Ether directly to this contract, consider he is
893   /// getting AIXs.
894   function () public payable notPaused {
895     proxyPayment(msg.sender);
896   }
897 
898   //////////
899   // TokenController functions
900   //////////
901 
902   /// @notice This method will generally be called by the AIX token contract to
903   ///  acquire AIXs. Or directly from third parties that want to acquire AIXs in
904   ///  behalf of a token holder.
905   /// @param _th AIX holder where the AIXs will be minted.
906   function proxyPayment(address _th) public payable notPaused initialized contributionOpen returns (bool) {
907     require(_th != 0x0);
908     doBuy(_th);
909     return true;
910   }
911 
912   function onTransfer(address _from, address, uint256) public returns (bool) {
913     if (_from == exchanger) {
914       return true;
915     }
916     return transferable;
917   }
918 
919   function onApprove(address _from, address, uint256) public returns (bool) {
920     if (_from == exchanger) {
921       return true;
922     }
923     return transferable;
924   }
925 
926   function allowTransfers(bool _transferable) onlyController {
927     transferable = _transferable;
928   }
929 
930   function doBuy(address _th) internal {
931     // whitelisting only during the first day
932     if (getBlockTimestamp() <= startTime + 1 days) {
933       require(canPurchase[_th] || msg.sender == collector);
934     } else if (notCollectedAmountAfter24Hours == 0) {
935       notCollectedAmountAfter24Hours = weiToCollect();
936       twentyPercentWithBonus = notCollectedAmountAfter24Hours.mul(20).div(100);
937       thirtyPercentWithBonus = notCollectedAmountAfter24Hours.mul(30).div(100);
938     }
939 
940     require(msg.value >= minimumPerTransaction);
941     uint256 toFund = msg.value;
942     uint256 toCollect = weiToCollectByInvestor(_th);
943 
944     if (toCollect > 0) {
945       // Check total supply cap reached, sell the all remaining tokens
946       if (toFund > toCollect) {
947         toFund = toCollect;
948       }
949       uint256 tokensGenerated = tokensToGenerate(toFund);
950       require(tokensGenerated > 0);
951       require(aix.generateTokens(_th, tokensGenerated));
952 
953       contributionWallet.transfer(toFund);
954       individualWeiCollected[_th] = individualWeiCollected[_th].add(toFund);
955       totalWeiCollected = totalWeiCollected.add(toFund);
956       NewSale(_th, toFund, tokensGenerated);
957     } else {
958       toFund = 0;
959     }
960 
961     uint256 toReturn = msg.value.sub(toFund);
962     if (toReturn > 0) {
963       _th.transfer(toReturn);
964     }
965   }
966 
967   /// @notice This method will can be called by the controller before the contribution period
968   ///  end or by anybody after the `endTime`. This method finalizes the contribution period
969   ///  by creating the remaining tokens and transferring the controller to the configured
970   ///  controller.
971   function finalize() public initialized {
972     require(finalizedBlock == 0);
973     require(finalizedTime == 0);
974     require(getBlockTimestamp() >= startTime);
975     require(msg.sender == controller || getBlockTimestamp() > endTime || weiToCollect() == 0);
976 
977     // remainder will be minted and locked for 1 year.
978     // This was decided to be removed.
979     // aix.generateTokens(remainderHolder, weiToCollect().mul(2000));
980 
981     // AIX generated so far is 51% of total
982     uint256 tokenCap = aix.totalSupply().mul(100).div(51);
983     // dev Wallet will have 20% of the total Tokens and will be able to retrieve quarterly.
984     aix.generateTokens(devHolder, tokenCap.mul(20).div(100));
985     // community Wallet will have access to 29% of the total Tokens.
986     aix.generateTokens(communityHolder, tokenCap.mul(29).div(100));
987 
988     finalizedBlock = getBlockNumber();
989     finalizedTime = getBlockTimestamp();
990 
991     Finalized(finalizedBlock);
992   }
993 
994   //////////
995   // Constant functions
996   //////////
997 
998   /// @return Total eth that still available for collection in weis.
999   function weiToCollect() public constant returns(uint256) {
1000     return totalWeiCap > totalWeiCollected ? totalWeiCap.sub(totalWeiCollected) : 0;
1001   }
1002 
1003   /// @return Total eth that still available for collection in weis.
1004   function weiToCollectByInvestor(address investor) public constant returns(uint256) {
1005     uint256 cap;
1006     uint256 collected;
1007     // adding 1 day as a placeholder for X hours.
1008     // This should change into a variable or coded into the contract.
1009     if (investor == collector) {
1010       cap = collectorWeiCap;
1011       collected = individualWeiCollected[investor];
1012     } else if (getBlockTimestamp() <= startTime + 1 days) {
1013       cap = totalWeiCap.div(numWhitelistedInvestors);
1014       collected = individualWeiCollected[investor];
1015     } else {
1016       cap = totalWeiCap;
1017       collected = totalWeiCollected;
1018     }
1019     return cap > collected ? cap.sub(collected) : 0;
1020   }
1021 
1022   //////////
1023   // Testing specific methods
1024   //////////
1025 
1026   /// @notice This function is overridden by the test Mocks.
1027   function getBlockNumber() internal constant returns (uint256) {
1028     return block.number;
1029   }
1030 
1031   function getBlockTimestamp() internal constant returns (uint256) {
1032     return block.timestamp;
1033   }
1034 
1035   //////////
1036   // Safety Methods
1037   //////////
1038 
1039   /// @notice This method can be used by the controller to extract mistakenly
1040   ///  sent tokens to this contract.
1041   /// @param _token The address of the token contract that you want to recover
1042   ///  set to 0 in case you want to extract ether.
1043   function claimTokens(address _token) public onlyController {
1044     if (aix.controller() == address(this)) {
1045       aix.claimTokens(_token);
1046     }
1047 
1048     if (_token == 0x0) {
1049       controller.transfer(this.balance);
1050       return;
1051     }
1052 
1053     ERC20 token = ERC20(_token);
1054     uint256 balance = token.balanceOf(this);
1055     token.transfer(controller, balance);
1056     ClaimedTokens(_token, controller, balance);
1057   }
1058 
1059   /// @notice Pauses the contribution if there is any issue
1060   function pauseContribution(bool _paused) onlyController {
1061     paused = _paused;
1062   }
1063 
1064   event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
1065   event NewSale(address indexed _th, uint256 _amount, uint256 _tokens);
1066   event Initialized(uint _now);
1067   event Finalized(uint _now);
1068 }
1069 
1070 /*
1071   Copyright 2017, Klaus Hott (BlockChainLabs.nz)
1072   Copyright 2017, Jordi Baylina (Giveth)
1073 
1074   This program is free software: you can redistribute it and/or modify
1075   it under the terms of the GNU General Public License as published by
1076   the Free Software Foundation, either version 3 of the License, or
1077   (at your option) any later version.
1078 
1079   This program is distributed in the hope that it will be useful,
1080   but WITHOUT ANY WARRANTY; without even the implied warranty of
1081   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1082   GNU General Public License for more details.
1083 
1084   You should have received a copy of the GNU General Public License
1085   along with this program.  If not, see <http://www.gnu.org/licenses/>.
1086 */
1087 
1088 /// @title Exchanger Contract
1089 /// @author Klaus Hott
1090 /// @dev This contract will be used to distribute AIX between APT holders.
1091 ///  APT token is not transferable, and we just keep an accounting between all tokens
1092 ///  deposited and the tokens collected.
1093 
1094 contract Exchanger is Controlled {
1095   using SafeMath for uint256;
1096 
1097   mapping (address => uint256) public collected;
1098   uint256 public totalCollected;
1099   MiniMeToken public apt;
1100   MiniMeToken public aix;
1101   Contribution public contribution;
1102 
1103   function Exchanger(address _apt, address _aix, address _contribution) {
1104     apt = MiniMeToken(_apt);
1105     aix = MiniMeToken(_aix);
1106     contribution = Contribution(_contribution);
1107   }
1108 
1109   function () public {
1110     collect();
1111   }
1112 
1113   /// @notice This method should be called by the APT holders to collect their
1114   ///  corresponding AIXs
1115   function collect() public {
1116     // APT sholder could collect AIX right after contribution started
1117     assert(getBlockTimestamp() > contribution.startTime());
1118 
1119     uint256 pre_sale_fixed_at = contribution.initializedBlock();
1120 
1121     // Get current APT ballance at contributions initialization-
1122     uint256 balance = apt.balanceOfAt(msg.sender, pre_sale_fixed_at);
1123 
1124     // total of aix to be distributed.
1125     uint256 total = totalCollected.add(aix.balanceOf(address(this)));
1126 
1127     // First calculate how much correspond to him
1128     uint256 amount = total.mul(balance).div(apt.totalSupplyAt(pre_sale_fixed_at));
1129 
1130     // And then subtract the amount already collected
1131     amount = amount.sub(collected[msg.sender]);
1132 
1133     // Notify the user that there are no tokens to exchange
1134     require(amount > 0);
1135 
1136     totalCollected = totalCollected.add(amount);
1137     collected[msg.sender] = collected[msg.sender].add(amount);
1138 
1139     assert(aix.transfer(msg.sender, amount));
1140 
1141     TokensCollected(msg.sender, amount);
1142   }
1143 
1144   //////////
1145   // Testing specific methods
1146   //////////
1147 
1148   /// @notice This function is overridden by the test Mocks.
1149   function getBlockNumber() internal constant returns (uint256) {
1150     return block.number;
1151   }
1152 
1153   /// @notice This function is overridden by the test Mocks.
1154   function getBlockTimestamp() internal constant returns (uint256) {
1155     return block.timestamp;
1156   }
1157 
1158   //////////
1159   // Safety Method
1160   //////////
1161 
1162   /// @notice This method can be used by the controller to extract mistakenly
1163   ///  sent tokens to this contract.
1164   /// @param _token The address of the token contract that you want to recover
1165   ///  set to 0 in case you want to extract ether.
1166   function claimTokens(address _token) public onlyController {
1167     assert(_token != address(aix));
1168     if (_token == 0x0) {
1169       controller.transfer(this.balance);
1170       return;
1171     }
1172 
1173     ERC20 token = ERC20(_token);
1174     uint256 balance = token.balanceOf(this);
1175     token.transfer(controller, balance);
1176     ClaimedTokens(_token, controller, balance);
1177   }
1178 
1179   event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
1180   event TokensCollected(address indexed _holder, uint256 _amount);
1181 }