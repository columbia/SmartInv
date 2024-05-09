1 pragma solidity ^0.4.23;
2 
3 interface ApproveAndCallFallBack {
4     function receiveApproval(
5         address from,
6         uint256 _amount,
7         address _token,
8         bytes _data
9     ) external;
10 }
11 
12 /**
13  * @dev The token controller contract must implement these functions
14  */
15 interface TokenController {
16     /**
17      * @notice Called when `_owner` sends ether to the MiniMe Token contract
18      * @param _owner The address that sent the ether to create tokens
19      * @return True if the ether is accepted, false if it throws
20      */
21     function proxyPayment(address _owner) external payable returns(bool);
22 
23     /**
24      * @notice Notifies the controller about a token transfer allowing the
25      *  controller to react if desired
26      * @param _from The origin of the transfer
27      * @param _to The destination of the transfer
28      * @param _amount The amount of the transfer
29      * @return False if the controller does not authorize the transfer
30      */
31     function onTransfer(address _from, address _to, uint _amount) external returns(bool);
32 
33     /**
34      * @notice Notifies the controller about an approval allowing the
35      *  controller to react if desired
36      * @param _owner The address that calls `approve()`
37      * @param _spender The spender in the `approve()` call
38      * @param _amount The amount in the `approve()` call
39      * @return False if the controller does not authorize the approval
40      */
41     function onApprove(address _owner, address _spender, uint _amount) external
42         returns(bool);
43 }
44 
45 
46 contract Controlled {
47     /// @notice The address of the controller is the only address that can call
48     ///  a function with this modifier
49     modifier onlyController { 
50         require(msg.sender == controller); 
51         _; 
52     }
53 
54     address public controller;
55 
56     constructor() internal { 
57         controller = msg.sender; 
58     }
59 
60     /// @notice Changes the controller of the contract
61     /// @param _newController The new controller of the contract
62     function changeController(address _newController) public onlyController {
63         controller = _newController;
64     }
65 }
66 
67 
68 /*
69     Copyright 2016, Jordi Baylina
70 
71     This program is free software: you can redistribute it and/or modify
72     it under the terms of the GNU General Public License as published by
73     the Free Software Foundation, either version 3 of the License, or
74     (at your option) any later version.
75 
76     This program is distributed in the hope that it will be useful,
77     but WITHOUT ANY WARRANTY; without even the implied warranty of
78     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
79     GNU General Public License for more details.
80 
81     You should have received a copy of the GNU General Public License
82     along with this program.  If not, see <http://www.gnu.org/licenses/>.
83  */
84 /**
85  * @title MiniMeToken Contract
86  * @author Jordi Baylina
87  * @dev This token contract's goal is to make it easy for anyone to clone this
88  *  token using the token distribution at a given block, this will allow DAO's
89  *  and DApps to upgrade their features in a decentralized manner without
90  *  affecting the original token
91  * @dev It is ERC20 compliant, but still needs to under go further testing.
92  */
93 
94 
95 
96 
97 
98 
99 
100 
101 // Abstract contract for the full ERC 20 Token standard
102 // https://github.com/ethereum/EIPs/issues/20
103 
104 interface ERC20Token {
105 
106     /**
107      * @notice send `_value` token to `_to` from `msg.sender`
108      * @param _to The address of the recipient
109      * @param _value The amount of token to be transferred
110      * @return Whether the transfer was successful or not
111      */
112     function transfer(address _to, uint256 _value) external returns (bool success);
113 
114     /**
115      * @notice `msg.sender` approves `_spender` to spend `_value` tokens
116      * @param _spender The address of the account able to transfer the tokens
117      * @param _value The amount of tokens to be approved for transfer
118      * @return Whether the approval was successful or not
119      */
120     function approve(address _spender, uint256 _value) external returns (bool success);
121 
122     /**
123      * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
124      * @param _from The address of the sender
125      * @param _to The address of the recipient
126      * @param _value The amount of token to be transferred
127      * @return Whether the transfer was successful or not
128      */
129     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
130 
131     /**
132      * @param _owner The address from which the balance will be retrieved
133      * @return The balance
134      */
135     function balanceOf(address _owner) external view returns (uint256 balance);
136 
137     /**
138      * @param _owner The address of the account owning tokens
139      * @param _spender The address of the account able to transfer the tokens
140      * @return Amount of remaining tokens allowed to spent
141      */
142     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
143 
144     /**
145      * @notice return total supply of tokens
146      */
147     function totalSupply() external view returns (uint256 supply);
148 
149     event Transfer(address indexed _from, address indexed _to, uint256 _value);
150     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
151 }
152 
153 
154 contract MiniMeTokenInterface is ERC20Token {
155 
156     /**
157      * @notice `msg.sender` approves `_spender` to send `_amount` tokens on
158      *  its behalf, and then a function is triggered in the contract that is
159      *  being approved, `_spender`. This allows users to use their tokens to
160      *  interact with contracts in one function call instead of two
161      * @param _spender The address of the contract able to transfer the tokens
162      * @param _amount The amount of tokens to be approved for transfer
163      * @return True if the function call was successful
164      */
165     function approveAndCall(
166         address _spender,
167         uint256 _amount,
168         bytes _extraData
169     ) 
170         external 
171         returns (bool success);
172 
173     /**    
174      * @notice Creates a new clone token with the initial distribution being
175      *  this token at `_snapshotBlock`
176      * @param _cloneTokenName Name of the clone token
177      * @param _cloneDecimalUnits Number of decimals of the smallest unit
178      * @param _cloneTokenSymbol Symbol of the clone token
179      * @param _snapshotBlock Block when the distribution of the parent token is
180      *  copied to set the initial distribution of the new clone token;
181      *  if the block is zero than the actual block, the current block is used
182      * @param _transfersEnabled True if transfers are allowed in the clone
183      * @return The address of the new MiniMeToken Contract
184      */
185     function createCloneToken(
186         string _cloneTokenName,
187         uint8 _cloneDecimalUnits,
188         string _cloneTokenSymbol,
189         uint _snapshotBlock,
190         bool _transfersEnabled
191     ) 
192         public
193         returns(address);
194 
195     /**    
196      * @notice Generates `_amount` tokens that are assigned to `_owner`
197      * @param _owner The address that will be assigned the new tokens
198      * @param _amount The quantity of tokens generated
199      * @return True if the tokens are generated correctly
200      */
201     function generateTokens(
202         address _owner,
203         uint _amount
204     )
205         public
206         returns (bool);
207 
208     /**
209      * @notice Burns `_amount` tokens from `_owner`
210      * @param _owner The address that will lose the tokens
211      * @param _amount The quantity of tokens to burn
212      * @return True if the tokens are burned correctly
213      */
214     function destroyTokens(
215         address _owner,
216         uint _amount
217     ) 
218         public
219         returns (bool);
220 
221     /**        
222      * @notice Enables token holders to transfer their tokens freely if true
223      * @param _transfersEnabled True if transfers are allowed in the clone
224      */
225     function enableTransfers(bool _transfersEnabled) public;
226 
227     /**    
228      * @notice This method can be used by the controller to extract mistakenly
229      *  sent tokens to this contract.
230      * @param _token The address of the token contract that you want to recover
231      *  set to 0 in case you want to extract ether.
232      */
233     function claimTokens(address _token) public;
234 
235     /**
236      * @dev Queries the balance of `_owner` at a specific `_blockNumber`
237      * @param _owner The address from which the balance will be retrieved
238      * @param _blockNumber The block number when the balance is queried
239      * @return The balance at `_blockNumber`
240      */
241     function balanceOfAt(
242         address _owner,
243         uint _blockNumber
244     ) 
245         public
246         constant
247         returns (uint);
248 
249     /**
250      * @notice Total amount of tokens at a specific `_blockNumber`.
251      * @param _blockNumber The block number when the totalSupply is queried
252      * @return The total amount of tokens at `_blockNumber`
253      */
254     function totalSupplyAt(uint _blockNumber) public view returns(uint);
255 
256 }
257 
258 
259 
260 
261 /*
262     Copyright 2016, Jordi Baylina
263 
264     This program is free software: you can redistribute it and/or modify
265     it under the terms of the GNU General Public License as published by
266     the Free Software Foundation, either version 3 of the License, or
267     (at your option) any later version.
268 
269     This program is distributed in the hope that it will be useful,
270     but WITHOUT ANY WARRANTY; without even the implied warranty of
271     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
272     GNU General Public License for more details.
273 
274     You should have received a copy of the GNU General Public License
275     along with this program.  If not, see <http://www.gnu.org/licenses/>.
276  */
277 /**
278  * @title MiniMeToken Contract
279  * @author Jordi Baylina
280  * @dev This token contract's goal is to make it easy for anyone to clone this
281  *  token using the token distribution at a given block, this will allow DAO's
282  *  and DApps to upgrade their features in a decentralized manner without
283  *  affecting the original token
284  * @dev It is ERC20 compliant, but still needs to under go further testing.
285  */
286 
287 
288 
289 
290 
291 
292 
293 /**
294  * @dev The actual token contract, the default controller is the msg.sender
295  *  that deploys the contract, so usually this token will be deployed by a
296  *  token controller contract, which Giveth will call a "Campaign"
297  */
298 contract MiniMeToken is MiniMeTokenInterface, Controlled {
299 
300     string public name;                //The Token's name: e.g. DigixDAO Tokens
301     uint8 public decimals;             //Number of decimals of the smallest unit
302     string public symbol;              //An identifier: e.g. REP
303     string public version = "MMT_0.1"; //An arbitrary versioning scheme
304 
305     /**
306      * @dev `Checkpoint` is the structure that attaches a block number to a
307      *  given value, the block number attached is the one that last changed the
308      *  value
309      */
310     struct Checkpoint {
311 
312         // `fromBlock` is the block number that the value was generated from
313         uint128 fromBlock;
314 
315         // `value` is the amount of tokens at a specific block number
316         uint128 value;
317     }
318 
319     // `parentToken` is the Token address that was cloned to produce this token;
320     //  it will be 0x0 for a token that was not cloned
321     MiniMeToken public parentToken;
322 
323     // `parentSnapShotBlock` is the block number from the Parent Token that was
324     //  used to determine the initial distribution of the Clone Token
325     uint public parentSnapShotBlock;
326 
327     // `creationBlock` is the block number that the Clone Token was created
328     uint public creationBlock;
329 
330     // `balances` is the map that tracks the balance of each address, in this
331     //  contract when the balance changes the block number that the change
332     //  occurred is also included in the map 
333     mapping (address => Checkpoint[]) balances;
334 
335     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
336     mapping (address => mapping (address => uint256)) allowed;
337 
338     // Tracks the history of the `totalSupply` of the token
339     Checkpoint[] totalSupplyHistory;
340 
341     // Flag that determines if the token is transferable or not.
342     bool public transfersEnabled;
343 
344     // The factory used to create new clone tokens
345     MiniMeTokenFactory public tokenFactory;
346 
347 ////////////////
348 // Constructor
349 ////////////////
350 
351     /** 
352      * @notice Constructor to create a MiniMeToken
353      * @param _tokenFactory The address of the MiniMeTokenFactory contract that
354      *  will create the Clone token contracts, the token factory needs to be
355      *  deployed first
356      * @param _parentToken Address of the parent token, set to 0x0 if it is a
357      *  new token
358      * @param _parentSnapShotBlock Block of the parent token that will
359      *  determine the initial distribution of the clone token, set to 0 if it
360      *  is a new token
361      * @param _tokenName Name of the new token
362      * @param _decimalUnits Number of decimals of the new token
363      * @param _tokenSymbol Token Symbol for the new token
364      * @param _transfersEnabled If true, tokens will be able to be transferred
365      */
366     constructor(
367         address _tokenFactory,
368         address _parentToken,
369         uint _parentSnapShotBlock,
370         string _tokenName,
371         uint8 _decimalUnits,
372         string _tokenSymbol,
373         bool _transfersEnabled
374     ) 
375         public
376     {
377         require(_tokenFactory != address(0)); //if not set, clone feature will not work properly
378         tokenFactory = MiniMeTokenFactory(_tokenFactory);
379         name = _tokenName;                                 // Set the name
380         decimals = _decimalUnits;                          // Set the decimals
381         symbol = _tokenSymbol;                             // Set the symbol
382         parentToken = MiniMeToken(_parentToken);
383         parentSnapShotBlock = _parentSnapShotBlock;
384         transfersEnabled = _transfersEnabled;
385         creationBlock = block.number;
386     }
387 
388 
389 ///////////////////
390 // ERC20 Methods
391 ///////////////////
392 
393     /**
394      * @notice Send `_amount` tokens to `_to` from `msg.sender`
395      * @param _to The address of the recipient
396      * @param _amount The amount of tokens to be transferred
397      * @return Whether the transfer was successful or not
398      */
399     function transfer(address _to, uint256 _amount) public returns (bool success) {
400         require(transfersEnabled);
401         return doTransfer(msg.sender, _to, _amount);
402     }
403 
404     /**
405      * @notice Send `_amount` tokens to `_to` from `_from` on the condition it
406      *  is approved by `_from`
407      * @param _from The address holding the tokens being transferred
408      * @param _to The address of the recipient
409      * @param _amount The amount of tokens to be transferred
410      * @return True if the transfer was successful
411      */
412     function transferFrom(
413         address _from,
414         address _to,
415         uint256 _amount
416     ) 
417         public 
418         returns (bool success)
419     {
420 
421         // The controller of this contract can move tokens around at will,
422         //  this is important to recognize! Confirm that you trust the
423         //  controller of this contract, which in most situations should be
424         //  another open source smart contract or 0x0
425         if (msg.sender != controller) {
426             require(transfersEnabled);
427 
428             // The standard ERC 20 transferFrom functionality
429             if (allowed[_from][msg.sender] < _amount) { 
430                 return false;
431             }
432             allowed[_from][msg.sender] -= _amount;
433         }
434         return doTransfer(_from, _to, _amount);
435     }
436 
437     /**
438      * @dev This is the actual transfer function in the token contract, it can
439      *  only be called by other functions in this contract.
440      * @param _from The address holding the tokens being transferred
441      * @param _to The address of the recipient
442      * @param _amount The amount of tokens to be transferred
443      * @return True if the transfer was successful
444      */
445     function doTransfer(
446         address _from,
447         address _to,
448         uint _amount
449     ) 
450         internal
451         returns(bool)
452     {
453 
454         if (_amount == 0) {
455             return true;
456         }
457 
458         require(parentSnapShotBlock < block.number);
459 
460         // Do not allow transfer to 0x0 or the token contract itself
461         require((_to != 0) && (_to != address(this)));
462 
463         // If the amount being transfered is more than the balance of the
464         //  account the transfer returns false
465         uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
466         if (previousBalanceFrom < _amount) {
467             return false;
468         }
469 
470         // Alerts the token controller of the transfer
471         if (isContract(controller)) {
472             require(TokenController(controller).onTransfer(_from, _to, _amount));
473         }
474 
475         // First update the balance array with the new value for the address
476         //  sending the tokens
477         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
478 
479         // Then update the balance array with the new value for the address
480         //  receiving the tokens
481         uint256 previousBalanceTo = balanceOfAt(_to, block.number);
482         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
483         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
484 
485         // An event to make the transfer easy to find on the blockchain
486         emit Transfer(_from, _to, _amount);
487 
488         return true;
489     }
490 
491     function doApprove(
492         address _from,
493         address _spender,
494         uint256 _amount
495     )
496         internal 
497         returns (bool)
498     {
499         require(transfersEnabled);
500 
501         // To change the approve amount you first have to reduce the addresses`
502         //  allowance to zero by calling `approve(_spender,0)` if it is not
503         //  already 0 to mitigate the race condition described here:
504         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
505         require((_amount == 0) || (allowed[_from][_spender] == 0));
506 
507         // Alerts the token controller of the approve function call
508         if (isContract(controller)) {
509             require(TokenController(controller).onApprove(_from, _spender, _amount));
510         }
511 
512         allowed[_from][_spender] = _amount;
513         emit Approval(_from, _spender, _amount);
514         return true;
515     }
516 
517     /**
518      * @param _owner The address that's balance is being requested
519      * @return The balance of `_owner` at the current block
520      */
521     function balanceOf(address _owner) external view returns (uint256 balance) {
522         return balanceOfAt(_owner, block.number);
523     }
524 
525     /**
526      * @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
527      *  its behalf. This is a modified version of the ERC20 approve function
528      *  to be a little bit safer
529      * @param _spender The address of the account able to transfer the tokens
530      * @param _amount The amount of tokens to be approved for transfer
531      * @return True if the approval was successful
532      */
533     function approve(address _spender, uint256 _amount) external returns (bool success) {
534         doApprove(msg.sender, _spender, _amount);
535     }
536 
537     /**
538      * @dev This function makes it easy to read the `allowed[]` map
539      * @param _owner The address of the account that owns the token
540      * @param _spender The address of the account able to transfer the tokens
541      * @return Amount of remaining tokens of _owner that _spender is allowed
542      *  to spend
543      */
544     function allowance(
545         address _owner,
546         address _spender
547     ) 
548         external
549         view
550         returns (uint256 remaining)
551     {
552         return allowed[_owner][_spender];
553     }
554     /**
555      * @notice `msg.sender` approves `_spender` to send `_amount` tokens on
556      *  its behalf, and then a function is triggered in the contract that is
557      *  being approved, `_spender`. This allows users to use their tokens to
558      *  interact with contracts in one function call instead of two
559      * @param _spender The address of the contract able to transfer the tokens
560      * @param _amount The amount of tokens to be approved for transfer
561      * @return True if the function call was successful
562      */
563     function approveAndCall(
564         address _spender,
565         uint256 _amount,
566         bytes _extraData
567     ) 
568         external 
569         returns (bool success)
570     {
571         require(doApprove(msg.sender, _spender, _amount));
572 
573         ApproveAndCallFallBack(_spender).receiveApproval(
574             msg.sender,
575             _amount,
576             this,
577             _extraData
578         );
579 
580         return true;
581     }
582 
583     /**
584      * @dev This function makes it easy to get the total number of tokens
585      * @return The total number of tokens
586      */
587     function totalSupply() external view returns (uint) {
588         return totalSupplyAt(block.number);
589     }
590 
591 
592 ////////////////
593 // Query balance and totalSupply in History
594 ////////////////
595 
596     /**
597      * @dev Queries the balance of `_owner` at a specific `_blockNumber`
598      * @param _owner The address from which the balance will be retrieved
599      * @param _blockNumber The block number when the balance is queried
600      * @return The balance at `_blockNumber`
601      */
602     function balanceOfAt(
603         address _owner,
604         uint _blockNumber
605     ) 
606         public
607         view
608         returns (uint) 
609     {
610 
611         // These next few lines are used when the balance of the token is
612         //  requested before a check point was ever created for this token, it
613         //  requires that the `parentToken.balanceOfAt` be queried at the
614         //  genesis block for that token as this contains initial balance of
615         //  this token
616         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
617             if (address(parentToken) != 0) {
618                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
619             } else {
620                 // Has no parent
621                 return 0;
622             }
623 
624         // This will return the expected balance during normal situations
625         } else {
626             return getValueAt(balances[_owner], _blockNumber);
627         }
628     }
629 
630     /**
631      * @notice Total amount of tokens at a specific `_blockNumber`.
632      * @param _blockNumber The block number when the totalSupply is queried
633      * @return The total amount of tokens at `_blockNumber`
634      */
635     function totalSupplyAt(uint _blockNumber) public view returns(uint) {
636 
637         // These next few lines are used when the totalSupply of the token is
638         //  requested before a check point was ever created for this token, it
639         //  requires that the `parentToken.totalSupplyAt` be queried at the
640         //  genesis block for this token as that contains totalSupply of this
641         //  token at this block number.
642         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
643             if (address(parentToken) != 0) {
644                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
645             } else {
646                 return 0;
647             }
648 
649         // This will return the expected totalSupply during normal situations
650         } else {
651             return getValueAt(totalSupplyHistory, _blockNumber);
652         }
653     }
654 
655 ////////////////
656 // Clone Token Method
657 ////////////////
658 
659     /**
660      * @notice Creates a new clone token with the initial distribution being
661      *  this token at `_snapshotBlock`
662      * @param _cloneTokenName Name of the clone token
663      * @param _cloneDecimalUnits Number of decimals of the smallest unit
664      * @param _cloneTokenSymbol Symbol of the clone token
665      * @param _snapshotBlock Block when the distribution of the parent token is
666      *  copied to set the initial distribution of the new clone token;
667      *  if the block is zero than the actual block, the current block is used
668      * @param _transfersEnabled True if transfers are allowed in the clone
669      * @return The address of the new MiniMeToken Contract
670      */
671     function createCloneToken(
672         string _cloneTokenName,
673         uint8 _cloneDecimalUnits,
674         string _cloneTokenSymbol,
675         uint _snapshotBlock,
676         bool _transfersEnabled
677         ) 
678             public
679             returns(address)
680         {
681         uint snapshotBlock = _snapshotBlock;
682         if (snapshotBlock == 0) {
683             snapshotBlock = block.number;
684         }
685         MiniMeToken cloneToken = tokenFactory.createCloneToken(
686             this,
687             snapshotBlock,
688             _cloneTokenName,
689             _cloneDecimalUnits,
690             _cloneTokenSymbol,
691             _transfersEnabled
692             );
693 
694         cloneToken.changeController(msg.sender);
695 
696         // An event to make the token easy to find on the blockchain
697         emit NewCloneToken(address(cloneToken), snapshotBlock);
698         return address(cloneToken);
699     }
700 
701 ////////////////
702 // Generate and destroy tokens
703 ////////////////
704     
705     /**
706      * @notice Generates `_amount` tokens that are assigned to `_owner`
707      * @param _owner The address that will be assigned the new tokens
708      * @param _amount The quantity of tokens generated
709      * @return True if the tokens are generated correctly
710      */
711     function generateTokens(
712         address _owner,
713         uint _amount
714     )
715         public
716         onlyController
717         returns (bool)
718     {
719         uint curTotalSupply = totalSupplyAt(block.number);
720         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
721         uint previousBalanceTo = balanceOfAt(_owner, block.number);
722         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
723         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
724         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
725         emit Transfer(0, _owner, _amount);
726         return true;
727     }
728 
729     /**
730      * @notice Burns `_amount` tokens from `_owner`
731      * @param _owner The address that will lose the tokens
732      * @param _amount The quantity of tokens to burn
733      * @return True if the tokens are burned correctly
734      */
735     function destroyTokens(
736         address _owner,
737         uint _amount
738     ) 
739         public
740         onlyController
741         returns (bool)
742     {
743         uint curTotalSupply = totalSupplyAt(block.number);
744         require(curTotalSupply >= _amount);
745         uint previousBalanceFrom = balanceOfAt(_owner, block.number);
746         require(previousBalanceFrom >= _amount);
747         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
748         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
749         emit Transfer(_owner, 0, _amount);
750         return true;
751     }
752 
753 ////////////////
754 // Enable tokens transfers
755 ////////////////
756 
757     /**
758      * @notice Enables token holders to transfer their tokens freely if true
759      * @param _transfersEnabled True if transfers are allowed in the clone
760      */
761     function enableTransfers(bool _transfersEnabled) public onlyController {
762         transfersEnabled = _transfersEnabled;
763     }
764 
765 ////////////////
766 // Internal helper functions to query and set a value in a snapshot array
767 ////////////////
768 
769     /**
770      * @dev `getValueAt` retrieves the number of tokens at a given block number
771      * @param checkpoints The history of values being queried
772      * @param _block The block number to retrieve the value at
773      * @return The number of tokens being queried
774      */
775     function getValueAt(
776         Checkpoint[] storage checkpoints,
777         uint _block
778     ) 
779         view
780         internal
781         returns (uint)
782     {
783         if (checkpoints.length == 0) {
784             return 0;
785         }
786 
787         // Shortcut for the actual value
788         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
789             return checkpoints[checkpoints.length-1].value;
790         }
791         if (_block < checkpoints[0].fromBlock) {
792             return 0;
793         }
794 
795         // Binary search of the value in the array
796         uint min = 0;
797         uint max = checkpoints.length-1;
798         while (max > min) {
799             uint mid = (max + min + 1) / 2;
800             if (checkpoints[mid].fromBlock<=_block) {
801                 min = mid;
802             } else {
803                 max = mid-1;
804             }
805         }
806         return checkpoints[min].value;
807     }
808 
809     /**
810      * @dev `updateValueAtNow` used to update the `balances` map and the
811      *  `totalSupplyHistory`
812      * @param checkpoints The history of data being updated
813      * @param _value The new number of tokens
814      */
815     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
816         if (
817             (checkpoints.length == 0) ||
818             (checkpoints[checkpoints.length - 1].fromBlock < block.number)) 
819         {
820             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
821             newCheckPoint.fromBlock = uint128(block.number);
822             newCheckPoint.value = uint128(_value);
823         } else {
824             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
825             oldCheckPoint.value = uint128(_value);
826         }
827     }
828 
829     /**
830      * @dev Internal function to determine if an address is a contract
831      * @param _addr The address being queried
832      * @return True if `_addr` is a contract
833      */
834     function isContract(address _addr) internal view returns(bool) {
835         uint size;
836         if (_addr == 0) {
837             return false;
838         }    
839         assembly {
840             size := extcodesize(_addr)
841         }
842         return size > 0;
843     }
844 
845     /**
846      * @dev Helper function to return a min betwen the two uints
847      */
848     function min(uint a, uint b) internal returns (uint) {
849         return a < b ? a : b;
850     }
851 
852     /**
853      * @notice The fallback function: If the contract's controller has not been
854      *  set to 0, then the `proxyPayment` method is called which relays the
855      *  ether and creates tokens as described in the token controller contract
856      */
857     function () public payable {
858         require(isContract(controller));
859         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
860     }
861 
862 //////////
863 // Safety Methods
864 //////////
865 
866     /**
867      * @notice This method can be used by the controller to extract mistakenly
868      *  sent tokens to this contract.
869      * @param _token The address of the token contract that you want to recover
870      *  set to 0 in case you want to extract ether.
871      */
872     function claimTokens(address _token) public onlyController {
873         if (_token == 0x0) {
874             controller.transfer(address(this).balance);
875             return;
876         }
877 
878         MiniMeToken token = MiniMeToken(_token);
879         uint balance = token.balanceOf(address(this));
880         token.transfer(controller, balance);
881         emit ClaimedTokens(_token, controller, balance);
882     }
883 
884 ////////////////
885 // Events
886 ////////////////
887     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
888     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
889     event NewCloneToken(address indexed _cloneToken, uint snapshotBlock);
890     event Approval(
891         address indexed _owner,
892         address indexed _spender,
893         uint256 _amount
894     );
895 
896 }
897 
898 ////////////////
899 // MiniMeTokenFactory
900 ////////////////
901 
902 /**
903  * @dev This contract is used to generate clone contracts from a contract.
904  *  In solidity this is the way to create a contract from a contract of the
905  *  same class
906  */
907 contract MiniMeTokenFactory {
908 
909     /**
910      * @notice Update the DApp by creating a new token with new functionalities
911      *  the msg.sender becomes the controller of this clone token
912      * @param _parentToken Address of the token being cloned
913      * @param _snapshotBlock Block of the parent token that will
914      *  determine the initial distribution of the clone token
915      * @param _tokenName Name of the new token
916      * @param _decimalUnits Number of decimals of the new token
917      * @param _tokenSymbol Token Symbol for the new token
918      * @param _transfersEnabled If true, tokens will be able to be transferred
919      * @return The address of the new token contract
920      */
921     function createCloneToken(
922         address _parentToken,
923         uint _snapshotBlock,
924         string _tokenName,
925         uint8 _decimalUnits,
926         string _tokenSymbol,
927         bool _transfersEnabled
928     ) public returns (MiniMeToken) {
929         MiniMeToken newToken = new MiniMeToken(
930             this,
931             _parentToken,
932             _snapshotBlock,
933             _tokenName,
934             _decimalUnits,
935             _tokenSymbol,
936             _transfersEnabled
937             );
938 
939         newToken.changeController(msg.sender);
940         return newToken;
941     }
942 }