1 pragma solidity ^0.4.11;
2 
3 /*
4     Copyright 2017, Klaus Hott
5     Copyright 2016, Jordi Baylina
6 
7     This program is free software: you can redistribute it and/or modify
8     it under the terms of the GNU General Public License as published by
9     the Free Software Foundation, either version 3 of the License, or
10     (at your option) any later version.
11 
12     This program is distributed in the hope that it will be useful,
13     but WITHOUT ANY WARRANTY; without even the implied warranty of
14     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15     GNU General Public License for more details.
16 
17     You should have received a copy of the GNU General Public License
18     along with this program.  If not, see <http://www.gnu.org/licenses/>.
19  */
20 
21 /// @title MiniMeToken Contract
22 /// @author Jordi Baylina
23 /// @dev This token contract's goal is to make it easy for anyone to clone this
24 ///  token using the token distribution at a given block, this will allow DAO's
25 ///  and DApps to upgrade their features in a decentralized manner without
26 ///  affecting the original token
27 /// @dev It is ERC20 compliant, but still needs to under go further testing.
28 
29 contract ERC20 {
30   /// @notice Send `_amount` tokens to `_to` from `msg.sender`
31   /// @param _to The address of the recipient
32   /// @param _amount The amount of tokens to be transferred
33   /// @return Whether the transfer was successful or not
34   function transfer(address _to, uint256 _amount) returns (bool success);
35 
36   /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
37   ///  is approved by `_from`
38   /// @param _from The address holding the tokens being transferred
39   /// @param _to The address of the recipient
40   /// @param _amount The amount of tokens to be transferred
41   /// @return True if the transfer was successful
42   function transferFrom(address _from, address _to, uint256 _amount
43   ) returns (bool success);
44 
45   /// @param _owner The address that's balance is being requested
46   /// @return The balance of `_owner` at the current block
47   function balanceOf(address _owner) constant returns (uint256 balance);
48 
49   /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
50   ///  its behalf. This is a modified version of the ERC20 approve function
51   ///  to be a little bit safer
52   /// @param _spender The address of the account able to transfer the tokens
53   /// @param _amount The amount of tokens to be approved for transfer
54   /// @return True if the approval was successful
55   function approve(address _spender, uint256 _amount) returns (bool success);
56 
57   /// @dev This function makes it easy to read the `allowed[]` map
58   /// @param _owner The address of the account that owns the token
59   /// @param _spender The address of the account able to transfer the tokens
60   /// @return Amount of remaining tokens of _owner that _spender is allowed
61   ///  to spend
62   function allowance(address _owner, address _spender
63   ) constant returns (uint256 remaining);
64 
65   /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
66   ///  its behalf, and then a function is triggered in the contract that is
67   ///  being approved, `_spender`. This allows users to use their tokens to
68   ///  interact with contracts in one function call instead of two
69   /// @param _spender The address of the contract able to transfer the tokens
70   /// @param _amount The amount of tokens to be approved for transfer
71   /// @return True if the function call was successful
72   function approveAndCall(address _spender, uint256 _amount, bytes _extraData
73   ) returns (bool success);
74 
75   /// @dev This function makes it easy to get the total number of tokens
76   /// @return The total number of tokens
77   function totalSupply() constant returns (uint);
78 }
79 
80 
81 /// @dev The token controller contract must implement these functions
82 contract TokenController {
83     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
84     /// @param _owner The address that sent the ether to create tokens
85     /// @return True if the ether is accepted, false if it throws
86     function proxyPayment(address _owner) payable returns(bool);
87 
88     /// @notice Notifies the controller about a token transfer allowing the
89     ///  controller to react if desired
90     /// @param _from The origin of the transfer
91     /// @param _to The destination of the transfer
92     /// @param _amount The amount of the transfer
93     /// @return False if the controller does not authorize the transfer
94     function onTransfer(address _from, address _to, uint _amount) returns(bool);
95 
96     /// @notice Notifies the controller about an approval allowing the
97     ///  controller to react if desired
98     /// @param _owner The address that calls `approve()`
99     /// @param _spender The spender in the `approve()` call
100     /// @param _amount The amount in the `approve()` call
101     /// @return False if the controller does not authorize the approval
102     function onApprove(address _owner, address _spender, uint _amount)
103         returns(bool);
104 }
105 
106 contract Controlled {
107     /// @notice The address of the controller is the only address that can call
108     ///  a function with this modifier
109     modifier onlyController { if (msg.sender != controller) throw; _; }
110 
111     address public controller;
112 
113     function Controlled() { controller = msg.sender;}
114 
115     /// @notice Changes the controller of the contract
116     /// @param _newController The new controller of the contract
117     function changeController(address _newController) onlyController {
118         controller = _newController;
119     }
120 }
121 
122 contract ApproveAndCallFallBack {
123     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
124 }
125 
126 /// @dev The actual token contract, the default controller is the msg.sender
127 ///  that deploys the contract, so usually this token will be deployed by a
128 ///  token controller contract, which Giveth will call a "Campaign"
129 contract MiniMeToken is Controlled {
130 
131     string public name;                //The Token's name: e.g. DigixDAO Tokens
132     uint8 public decimals;             //Number of decimals of the smallest unit
133     string public symbol;              //An identifier: e.g. REP
134     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
135 
136 
137     /// @dev `Checkpoint` is the structure that attaches a block number to a
138     ///  given value, the block number attached is the one that last changed the
139     ///  value
140     struct  Checkpoint {
141 
142         // `fromBlock` is the block number that the value was generated from
143         uint128 fromBlock;
144 
145         // `value` is the amount of tokens at a specific block number
146         uint128 value;
147     }
148 
149     // `parentToken` is the Token address that was cloned to produce this token;
150     //  it will be 0x0 for a token that was not cloned
151     MiniMeToken public parentToken;
152 
153     // `parentSnapShotBlock` is the block number from the Parent Token that was
154     //  used to determine the initial distribution of the Clone Token
155     uint public parentSnapShotBlock;
156 
157     // `creationBlock` is the block number that the Clone Token was created
158     uint public creationBlock;
159 
160     // `balances` is the map that tracks the balance of each address, in this
161     //  contract when the balance changes the block number that the change
162     //  occurred is also included in the map
163     mapping (address => Checkpoint[]) balances;
164 
165     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
166     mapping (address => mapping (address => uint256)) allowed;
167 
168     // Tracks the history of the `totalSupply` of the token
169     Checkpoint[] totalSupplyHistory;
170 
171     // Flag that determines if the token is transferable or not.
172     bool public transfersEnabled;
173 
174     // The factory used to create new clone tokens
175     MiniMeTokenFactory public tokenFactory;
176 
177 ////////////////
178 // Constructor
179 ////////////////
180 
181     /// @notice Constructor to create a MiniMeToken
182     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
183     ///  will create the Clone token contracts, the token factory needs to be
184     ///  deployed first
185     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
186     ///  new token
187     /// @param _parentSnapShotBlock Block of the parent token that will
188     ///  determine the initial distribution of the clone token, set to 0 if it
189     ///  is a new token
190     /// @param _tokenName Name of the new token
191     /// @param _decimalUnits Number of decimals of the new token
192     /// @param _tokenSymbol Token Symbol for the new token
193     /// @param _transfersEnabled If true, tokens will be able to be transferred
194     function MiniMeToken(
195         address _tokenFactory,
196         address _parentToken,
197         uint _parentSnapShotBlock,
198         string _tokenName,
199         uint8 _decimalUnits,
200         string _tokenSymbol,
201         bool _transfersEnabled
202     ) {
203         tokenFactory = MiniMeTokenFactory(_tokenFactory);
204         name = _tokenName;                                 // Set the name
205         decimals = _decimalUnits;                          // Set the decimals
206         symbol = _tokenSymbol;                             // Set the symbol
207         parentToken = MiniMeToken(_parentToken);
208         parentSnapShotBlock = _parentSnapShotBlock;
209         transfersEnabled = _transfersEnabled;
210         creationBlock = block.number;
211     }
212 
213 
214 ///////////////////
215 // ERC20 Methods
216 ///////////////////
217 
218     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
219     /// @param _to The address of the recipient
220     /// @param _amount The amount of tokens to be transferred
221     /// @return Whether the transfer was successful or not
222     function transfer(address _to, uint256 _amount) returns (bool success) {
223         if (!transfersEnabled) throw;
224         return doTransfer(msg.sender, _to, _amount);
225     }
226 
227     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
228     ///  is approved by `_from`
229     /// @param _from The address holding the tokens being transferred
230     /// @param _to The address of the recipient
231     /// @param _amount The amount of tokens to be transferred
232     /// @return True if the transfer was successful
233     function transferFrom(address _from, address _to, uint256 _amount
234     ) returns (bool success) {
235 
236         // The controller of this contract can move tokens around at will,
237         //  this is important to recognize! Confirm that you trust the
238         //  controller of this contract, which in most situations should be
239         //  another open source smart contract or 0x0
240         if (msg.sender != controller) {
241             if (!transfersEnabled) throw;
242 
243             // The standard ERC 20 transferFrom functionality
244             if (allowed[_from][msg.sender] < _amount) return false;
245             allowed[_from][msg.sender] -= _amount;
246         }
247         return doTransfer(_from, _to, _amount);
248     }
249 
250     /// @dev This is the actual transfer function in the token contract, it can
251     ///  only be called by other functions in this contract.
252     /// @param _from The address holding the tokens being transferred
253     /// @param _to The address of the recipient
254     /// @param _amount The amount of tokens to be transferred
255     /// @return True if the transfer was successful
256     function doTransfer(address _from, address _to, uint _amount
257     ) internal returns(bool) {
258 
259            if (_amount == 0) {
260                return true;
261            }
262 
263            if (parentSnapShotBlock >= block.number) throw;
264 
265            // Do not allow transfer to 0x0 or the token contract itself
266            if ((_to == 0) || (_to == address(this))) throw;
267 
268            // If the amount being transfered is more than the balance of the
269            //  account the transfer returns false
270            var previousBalanceFrom = balanceOfAt(_from, block.number);
271            if (previousBalanceFrom < _amount) {
272                return false;
273            }
274 
275            // Alerts the token controller of the transfer
276            if (isContract(controller)) {
277                if (!TokenController(controller).onTransfer(_from, _to, _amount))
278                throw;
279            }
280 
281            // First update the balance array with the new value for the address
282            //  sending the tokens
283            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
284 
285            // Then update the balance array with the new value for the address
286            //  receiving the tokens
287            var previousBalanceTo = balanceOfAt(_to, block.number);
288            if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
289            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
290 
291            // An event to make the transfer easy to find on the blockchain
292            Transfer(_from, _to, _amount);
293 
294            return true;
295     }
296 
297     /// @param _owner The address that's balance is being requested
298     /// @return The balance of `_owner` at the current block
299     function balanceOf(address _owner) constant returns (uint256 balance) {
300         return balanceOfAt(_owner, block.number);
301     }
302 
303     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
304     ///  its behalf. This is a modified version of the ERC20 approve function
305     ///  to be a little bit safer
306     /// @param _spender The address of the account able to transfer the tokens
307     /// @param _amount The amount of tokens to be approved for transfer
308     /// @return True if the approval was successful
309     function approve(address _spender, uint256 _amount) returns (bool success) {
310         if (!transfersEnabled) throw;
311 
312         // To change the approve amount you first have to reduce the addresses`
313         //  allowance to zero by calling `approve(_spender,0)` if it is not
314         //  already 0 to mitigate the race condition described here:
315         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
316         if ((_amount!=0) && (allowed[msg.sender][_spender] !=0)) throw;
317 
318         // Alerts the token controller of the approve function call
319         if (isContract(controller)) {
320             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
321                 throw;
322         }
323 
324         allowed[msg.sender][_spender] = _amount;
325         Approval(msg.sender, _spender, _amount);
326         return true;
327     }
328 
329     /// @dev This function makes it easy to read the `allowed[]` map
330     /// @param _owner The address of the account that owns the token
331     /// @param _spender The address of the account able to transfer the tokens
332     /// @return Amount of remaining tokens of _owner that _spender is allowed
333     ///  to spend
334     function allowance(address _owner, address _spender
335     ) constant returns (uint256 remaining) {
336         return allowed[_owner][_spender];
337     }
338 
339     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
340     ///  its behalf, and then a function is triggered in the contract that is
341     ///  being approved, `_spender`. This allows users to use their tokens to
342     ///  interact with contracts in one function call instead of two
343     /// @param _spender The address of the contract able to transfer the tokens
344     /// @param _amount The amount of tokens to be approved for transfer
345     /// @return True if the function call was successful
346     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
347     ) returns (bool success) {
348         if (!approve(_spender, _amount)) throw;
349 
350         ApproveAndCallFallBack(_spender).receiveApproval(
351             msg.sender,
352             _amount,
353             this,
354             _extraData
355         );
356 
357         return true;
358     }
359 
360     /// @dev This function makes it easy to get the total number of tokens
361     /// @return The total number of tokens
362     function totalSupply() constant returns (uint) {
363         return totalSupplyAt(block.number);
364     }
365 
366 
367 ////////////////
368 // Query balance and totalSupply in History
369 ////////////////
370 
371     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
372     /// @param _owner The address from which the balance will be retrieved
373     /// @param _blockNumber The block number when the balance is queried
374     /// @return The balance at `_blockNumber`
375     function balanceOfAt(address _owner, uint _blockNumber) constant
376         returns (uint) {
377 
378         // These next few lines are used when the balance of the token is
379         //  requested before a check point was ever created for this token, it
380         //  requires that the `parentToken.balanceOfAt` be queried at the
381         //  genesis block for that token as this contains initial balance of
382         //  this token
383         if ((balances[_owner].length == 0)
384             || (balances[_owner][0].fromBlock > _blockNumber)) {
385             if (address(parentToken) != 0) {
386                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
387             } else {
388                 // Has no parent
389                 return 0;
390             }
391 
392         // This will return the expected balance during normal situations
393         } else {
394             return getValueAt(balances[_owner], _blockNumber);
395         }
396     }
397 
398     /// @notice Total amount of tokens at a specific `_blockNumber`.
399     /// @param _blockNumber The block number when the totalSupply is queried
400     /// @return The total amount of tokens at `_blockNumber`
401     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
402 
403         // These next few lines are used when the totalSupply of the token is
404         //  requested before a check point was ever created for this token, it
405         //  requires that the `parentToken.totalSupplyAt` be queried at the
406         //  genesis block for this token as that contains totalSupply of this
407         //  token at this block number.
408         if ((totalSupplyHistory.length == 0)
409             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
410             if (address(parentToken) != 0) {
411                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
412             } else {
413                 return 0;
414             }
415 
416         // This will return the expected totalSupply during normal situations
417         } else {
418             return getValueAt(totalSupplyHistory, _blockNumber);
419         }
420     }
421 
422 ////////////////
423 // Clone Token Method
424 ////////////////
425 
426     /// @notice Creates a new clone token with the initial distribution being
427     ///  this token at `_snapshotBlock`
428     /// @param _cloneTokenName Name of the clone token
429     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
430     /// @param _cloneTokenSymbol Symbol of the clone token
431     /// @param _snapshotBlock Block when the distribution of the parent token is
432     ///  copied to set the initial distribution of the new clone token;
433     ///  if the block is zero than the actual block, the current block is used
434     /// @param _transfersEnabled True if transfers are allowed in the clone
435     /// @return The address of the new MiniMeToken Contract
436     function createCloneToken(
437         string _cloneTokenName,
438         uint8 _cloneDecimalUnits,
439         string _cloneTokenSymbol,
440         uint _snapshotBlock,
441         bool _transfersEnabled
442         ) returns(address) {
443         if (_snapshotBlock == 0) _snapshotBlock = block.number;
444         MiniMeToken cloneToken = tokenFactory.createCloneToken(
445             this,
446             _snapshotBlock,
447             _cloneTokenName,
448             _cloneDecimalUnits,
449             _cloneTokenSymbol,
450             _transfersEnabled
451             );
452 
453         cloneToken.changeController(msg.sender);
454 
455         // An event to make the token easy to find on the blockchain
456         NewCloneToken(address(cloneToken), _snapshotBlock);
457         return address(cloneToken);
458     }
459 
460 ////////////////
461 // Generate and destroy tokens
462 ////////////////
463 
464     /// @notice Generates `_amount` tokens that are assigned to `_owner`
465     /// @param _owner The address that will be assigned the new tokens
466     /// @param _amount The quantity of tokens generated
467     /// @return True if the tokens are generated correctly
468     function generateTokens(address _owner, uint _amount
469     ) onlyController returns (bool) {
470         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
471         if (curTotalSupply + _amount < curTotalSupply) throw; // Check for overflow
472         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
473         var previousBalanceTo = balanceOf(_owner);
474         if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
475         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
476         Transfer(0, _owner, _amount);
477         return true;
478     }
479 
480 
481     /// @notice Burns `_amount` tokens from `_owner`
482     /// @param _owner The address that will lose the tokens
483     /// @param _amount The quantity of tokens to burn
484     /// @return True if the tokens are burned correctly
485     function destroyTokens(address _owner, uint _amount
486     ) onlyController returns (bool) {
487         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
488         if (curTotalSupply < _amount) throw;
489         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
490         var previousBalanceFrom = balanceOf(_owner);
491         if (previousBalanceFrom < _amount) throw;
492         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
493         Transfer(_owner, 0, _amount);
494         return true;
495     }
496 
497 ////////////////
498 // Enable tokens transfers
499 ////////////////
500 
501 
502     /// @notice Enables token holders to transfer their tokens freely if true
503     /// @param _transfersEnabled True if transfers are allowed in the clone
504     function enableTransfers(bool _transfersEnabled) onlyController {
505         transfersEnabled = _transfersEnabled;
506     }
507 
508 ////////////////
509 // Internal helper functions to query and set a value in a snapshot array
510 ////////////////
511 
512     /// @dev `getValueAt` retrieves the number of tokens at a given block number
513     /// @param checkpoints The history of values being queried
514     /// @param _block The block number to retrieve the value at
515     /// @return The number of tokens being queried
516     function getValueAt(Checkpoint[] storage checkpoints, uint _block
517     ) constant internal returns (uint) {
518         if (checkpoints.length == 0) return 0;
519 
520         // Shortcut for the actual value
521         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
522             return checkpoints[checkpoints.length-1].value;
523         if (_block < checkpoints[0].fromBlock) return 0;
524 
525         // Binary search of the value in the array
526         uint min = 0;
527         uint max = checkpoints.length-1;
528         while (max > min) {
529             uint mid = (max + min + 1)/ 2;
530             if (checkpoints[mid].fromBlock<=_block) {
531                 min = mid;
532             } else {
533                 max = mid-1;
534             }
535         }
536         return checkpoints[min].value;
537     }
538 
539     /// @dev `updateValueAtNow` used to update the `balances` map and the
540     ///  `totalSupplyHistory`
541     /// @param checkpoints The history of data being updated
542     /// @param _value The new number of tokens
543     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
544     ) internal  {
545         if ((checkpoints.length == 0)
546         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
547                Checkpoint newCheckPoint = checkpoints[ checkpoints.length++ ];
548                newCheckPoint.fromBlock =  uint128(block.number);
549                newCheckPoint.value = uint128(_value);
550            } else {
551                Checkpoint oldCheckPoint = checkpoints[checkpoints.length-1];
552                oldCheckPoint.value = uint128(_value);
553            }
554     }
555 
556     /// @dev Internal function to determine if an address is a contract
557     /// @param _addr The address being queried
558     /// @return True if `_addr` is a contract
559     function isContract(address _addr) constant internal returns(bool) {
560         uint size;
561         if (_addr == 0) return false;
562         assembly {
563             size := extcodesize(_addr)
564         }
565         return size>0;
566     }
567 
568     /// @dev Helper function to return a min betwen the two uints
569     function min(uint a, uint b) internal returns (uint) {
570         return a < b ? a : b;
571     }
572 
573     /// @notice The fallback function: If the contract's controller has not been
574     ///  set to 0, then the `proxyPayment` method is called which relays the
575     ///  ether and creates tokens as described in the token controller contract
576     function ()  payable {
577         if (isContract(controller)) {
578             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
579                 throw;
580         } else {
581             throw;
582         }
583     }
584 
585 //////////
586 // Safety Methods
587 //////////
588 
589     /// @notice This method can be used by the controller to extract mistakenly
590     ///  sent tokens to this contract.
591     /// @param _token The address of the token contract that you want to recover
592     ///  set to 0 in case you want to extract ether.
593     function claimTokens(address _token) public onlyController {
594       if (_token == 0x0) {
595         controller.transfer(this.balance);
596         return;
597       }
598 
599       ERC20 token = ERC20(_token);
600       uint256 balance = token.balanceOf(this);
601       token.transfer(controller, balance);
602       ClaimedTokens(_token, controller, balance);
603     }
604 
605 ////////////////
606 // Events
607 ////////////////
608     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
609     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
610     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
611     event Approval(
612         address indexed _owner,
613         address indexed _spender,
614         uint256 _amount
615         );
616 
617 }
618 
619 
620 ////////////////
621 // MiniMeTokenFactory
622 ////////////////
623 
624 /// @dev This contract is used to generate clone contracts from a contract.
625 ///  In solidity this is the way to create a contract from a contract of the
626 ///  same class
627 contract MiniMeTokenFactory {
628 
629     /// @notice Update the DApp by creating a new token with new functionalities
630     ///  the msg.sender becomes the controller of this clone token
631     /// @param _parentToken Address of the token being cloned
632     /// @param _snapshotBlock Block of the parent token that will
633     ///  determine the initial distribution of the clone token
634     /// @param _tokenName Name of the new token
635     /// @param _decimalUnits Number of decimals of the new token
636     /// @param _tokenSymbol Token Symbol for the new token
637     /// @param _transfersEnabled If true, tokens will be able to be transferred
638     /// @return The address of the new token contract
639     function createCloneToken(
640         address _parentToken,
641         uint _snapshotBlock,
642         string _tokenName,
643         uint8 _decimalUnits,
644         string _tokenSymbol,
645         bool _transfersEnabled
646     ) returns (MiniMeToken) {
647         MiniMeToken newToken = new MiniMeToken(
648             this,
649             _parentToken,
650             _snapshotBlock,
651             _tokenName,
652             _decimalUnits,
653             _tokenSymbol,
654             _transfersEnabled
655             );
656 
657         newToken.changeController(msg.sender);
658         return newToken;
659     }
660 }
661 
662 contract PlaceHolder is Controlled, TokenController {
663   bool public transferable;
664   MiniMeToken apt;
665 
666   function PlaceHolder(address _apt) {
667     apt = MiniMeToken(_apt);
668   }
669 
670   /// @notice Called when `_owner` sends ether to the MiniMe Token contract
671   /// @return True if the ether is accepted, false if it throws
672   function proxyPayment(address) payable returns (bool) {
673     return false;
674   }
675 
676   /// @notice Notifies the controller about a token transfer allowing the
677   ///  controller to react if desired
678   /// @return False if the controller does not authorize the transfer
679   function onTransfer(address, address, uint256) returns (bool) {
680     return transferable;
681   }
682 
683   /// @notice Notifies the controller about an approval allowing the
684   ///  controller to react if desired
685   /// @return False if the controller does not authorize the approval
686   function onApprove(address, address, uint) returns (bool) {
687     return transferable;
688   }
689 
690   function allowTransfers(bool _transferable) onlyController {
691     transferable = _transferable;
692   }
693 
694   /// @notice Generates `_amount` tokens that are assigned to `_owner`
695   /// @param _owner The address that will be assigned the new tokens
696   /// @param _amount The quantity of tokens generated
697   /// @return True if the tokens are generated correctly
698   function generateTokens(address _owner, uint _amount
699   ) onlyController returns (bool) {
700     return apt.generateTokens(_owner, _amount);
701   }
702 
703   /// @notice The owner of this contract can change the controller of the APT token
704   ///  Please, be sure that the owner is a trusted agent or 0x0 address.
705   /// @param _newController The address of the new controller
706   function changeAPTController(address _newController) public onlyController {
707     apt.changeController(_newController);
708   }
709 
710   //////////
711   // Safety Methods
712   //////////
713 
714   /// @notice This method can be used by the controller to extract mistakenly
715   ///  sent tokens to this contract.
716   /// @param _token The address of the token contract that you want to recover
717   ///  set to 0 in case you want to extract ether.
718   function claimTokens(address _token) public onlyController {
719     if (apt.controller() == address(this)) {
720       apt.claimTokens(_token);
721     }
722 
723     if (_token == 0x0) {
724       controller.transfer(this.balance);
725       return;
726     }
727 
728     ERC20 token = ERC20(_token);
729     uint256 balance = token.balanceOf(this);
730     token.transfer(controller, balance);
731     ClaimedTokens(_token, controller, balance);
732   }
733 
734   event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
735 }