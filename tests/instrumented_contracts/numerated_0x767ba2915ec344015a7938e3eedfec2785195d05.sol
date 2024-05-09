1 // This is the code fot the smart contract 
2 // used for the Realisto ICO 
3 //
4 // @author: Pavel Metelitsyn
5 // September 2017
6 
7 
8 pragma solidity ^0.4.15;
9 
10 
11 // import "./library.sol";
12 
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  * 
18  * Source: Zeppelin Solidity
19  */
20 
21 library SafeMath {
22   function mul(uint a, uint b) internal returns (uint) {
23     uint c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint a, uint b) internal returns (uint) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint a, uint b) internal returns (uint) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint a, uint b) internal returns (uint) {
41     uint c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 
46   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
47     return a >= b ? a : b;
48   }
49 
50   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
51     return a < b ? a : b;
52   }
53 
54   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
55     return a >= b ? a : b;
56   }
57 
58   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
59     return a < b ? a : b;
60   }
61 
62   function percent(uint a, uint b) internal returns (uint) {
63     uint c = a * b;
64     assert(a == 0 || c / a == b);
65     return c / 100;
66   }
67 }
68 
69 
70 /**
71  * @title ERC20Basic
72  * @dev Simpler version of ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/179
74  */
75 
76  /* from OpenZeppelin library */
77  /* https://github.com/OpenZeppelin/zeppelin-solidity */
78 
79 contract ERC20Basic {
80   uint256 public totalSupply;
81   function balanceOf(address who) constant returns (uint256);
82   function transfer(address to, uint256 value) returns (bool);
83   event Transfer(address indexed from, address indexed to, uint256 value);
84 }
85 
86 //import "./RealistoToken.sol";
87 
88 
89 /*
90     Copyright 2016, Jordi Baylina
91 
92     This program is free software: you can redistribute it and/or modify
93     it under the terms of the GNU General Public License as published by
94     the Free Software Foundation, either version 3 of the License, or
95     (at your option) any later version.
96 
97     This program is distributed in the hope that it will be useful,
98     but WITHOUT ANY WARRANTY; without even the implied warranty of
99     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
100     GNU General Public License for more details.
101 
102     You should have received a copy of the GNU General Public License
103     along with this program.  If not, see <http://www.gnu.org/licenses/>.
104  */
105 
106 /// @title MiniMeToken Contract
107 /// @author Jordi Baylina
108 /// @dev This token contract's goal is to make it easy for anyone to clone this
109 ///  token using the token distribution at a given block, this will allow DAO's
110 ///  and DApps to upgrade their features in a decentralized manner without
111 ///  affecting the original token
112 /// @dev It is ERC20 compliant, but still needs to under go further testing.
113 
114 
115 /// @dev The token controller contract must implement these functions
116 contract TokenController {
117     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
118     /// @param _owner The address that sent the ether to create tokens
119     /// @return True if the ether is accepted, false if it throws
120     function proxyPayment(address _owner) payable returns(bool);
121 
122     /// @notice Notifies the controller about a token transfer allowing the
123     ///  controller to react if desired
124     /// @param _from The origin of the transfer
125     /// @param _to The destination of the transfer
126     /// @param _amount The amount of the transfer
127     /// @return False if the controller does not authorize the transfer
128     function onTransfer(address _from, address _to, uint _amount) returns(bool);
129 
130     /// @notice Notifies the controller about an approval allowing the
131     ///  controller to react if desired
132     /// @param _owner The address that calls `approve()`
133     /// @param _spender The spender in the `approve()` call
134     /// @param _amount The amount in the `approve()` call
135     /// @return False if the controller does not authorize the approval
136     function onApprove(address _owner, address _spender, uint _amount)
137         returns(bool);
138 }
139 
140 contract Controlled {
141     /// @notice The address of the controller is the only address that can call
142     ///  a function with this modifier
143     modifier onlyController { require(msg.sender == controller); _; }
144 
145     address public controller;
146 
147     function Controlled() { controller = msg.sender;}
148 
149     /// @notice Changes the controller of the contract
150     /// @param _newController The new controller of the contract
151     function changeController(address _newController) onlyController {
152         controller = _newController;
153     }
154 }
155 
156 contract ApproveAndCallFallBack {
157     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
158 }
159 
160 /// @dev The actual token contract, the default controller is the msg.sender
161 ///  that deploys the contract, so usually this token will be deployed by a
162 ///  token controller contract, which Giveth will call a "Campaign"
163 contract MiniMeToken is Controlled {
164 
165     string public name;                //The Token's name: e.g. DigixDAO Tokens
166     uint8 public decimals;             //Number of decimals of the smallest unit
167     string public symbol;              //An identifier: e.g. REP
168     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
169 
170 
171     /// @dev `Checkpoint` is the structure that attaches a block number to a
172     ///  given value, the block number attached is the one that last changed the
173     ///  value
174     struct  Checkpoint {
175 
176         // `fromBlock` is the block number that the value was generated from
177         uint128 fromBlock;
178 
179         // `value` is the amount of tokens at a specific block number
180         uint128 value;
181     }
182 
183     // `parentToken` is the Token address that was cloned to produce this token;
184     //  it will be 0x0 for a token that was not cloned
185     MiniMeToken public parentToken;
186 
187     // `parentSnapShotBlock` is the block number from the Parent Token that was
188     //  used to determine the initial distribution of the Clone Token
189     uint public parentSnapShotBlock;
190 
191     // `creationBlock` is the block number that the Clone Token was created
192     uint public creationBlock;
193 
194     // `balances` is the map that tracks the balance of each address, in this
195     //  contract when the balance changes the block number that the change
196     //  occurred is also included in the map
197     mapping (address => Checkpoint[]) balances;
198 
199     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
200     mapping (address => mapping (address => uint256)) allowed;
201 
202     // Tracks the history of the `totalSupply` of the token
203     Checkpoint[] totalSupplyHistory;
204 
205     // Flag that determines if the token is transferable or not.
206     bool public transfersEnabled;
207 
208     // The factory used to create new clone tokens
209     MiniMeTokenFactory public tokenFactory;
210 
211 ////////////////
212 // Constructor
213 ////////////////
214 
215     /// @notice Constructor to create a MiniMeToken
216     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
217     ///  will create the Clone token contracts, the token factory needs to be
218     ///  deployed first
219     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
220     ///  new token
221     /// @param _parentSnapShotBlock Block of the parent token that will
222     ///  determine the initial distribution of the clone token, set to 0 if it
223     ///  is a new token
224     /// @param _tokenName Name of the new token
225     /// @param _decimalUnits Number of decimals of the new token
226     /// @param _tokenSymbol Token Symbol for the new token
227     /// @param _transfersEnabled If true, tokens will be able to be transferred
228     function MiniMeToken(
229         address _tokenFactory,
230         address _parentToken,
231         uint _parentSnapShotBlock,
232         string _tokenName,
233         uint8 _decimalUnits,
234         string _tokenSymbol,
235         bool _transfersEnabled
236     ) {
237         tokenFactory = MiniMeTokenFactory(_tokenFactory);
238         name = _tokenName;                                 // Set the name
239         decimals = _decimalUnits;                          // Set the decimals
240         symbol = _tokenSymbol;                             // Set the symbol
241         parentToken = MiniMeToken(_parentToken);
242         parentSnapShotBlock = _parentSnapShotBlock;
243         transfersEnabled = _transfersEnabled;
244         creationBlock = block.number;
245     }
246 
247 
248 ///////////////////
249 // ERC20 Methods
250 ///////////////////
251 
252     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
253     /// @param _to The address of the recipient
254     /// @param _amount The amount of tokens to be transferred
255     /// @return Whether the transfer was successful or not
256     function transfer(address _to, uint256 _amount) returns (bool success) {
257         require(transfersEnabled);
258         return doTransfer(msg.sender, _to, _amount);
259     }
260 
261     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
262     ///  is approved by `_from`
263     /// @param _from The address holding the tokens being transferred
264     /// @param _to The address of the recipient
265     /// @param _amount The amount of tokens to be transferred
266     /// @return True if the transfer was successful
267     function transferFrom(address _from, address _to, uint256 _amount
268     ) returns (bool success) {
269 
270         // The controller of this contract can move tokens around at will,
271         //  this is important to recognize! Confirm that you trust the
272         //  controller of this contract, which in most situations should be
273         //  another open source smart contract or 0x0
274         if (msg.sender != controller) {
275             require(transfersEnabled);
276 
277             // The standard ERC 20 transferFrom functionality
278             if (allowed[_from][msg.sender] < _amount) return false;
279             allowed[_from][msg.sender] -= _amount;
280         }
281         return doTransfer(_from, _to, _amount);
282     }
283 
284     /// @dev This is the actual transfer function in the token contract, it can
285     ///  only be called by other functions in this contract.
286     /// @param _from The address holding the tokens being transferred
287     /// @param _to The address of the recipient
288     /// @param _amount The amount of tokens to be transferred
289     /// @return True if the transfer was successful
290     function doTransfer(address _from, address _to, uint _amount
291     ) internal returns(bool) {
292 
293            if (_amount == 0) {
294                return true;
295            }
296 
297            require(parentSnapShotBlock < block.number);
298 
299            // Do not allow transfer to 0x0 or the token contract itself
300            require((_to != 0) && (_to != address(this)));
301 
302            // If the amount being transfered is more than the balance of the
303            //  account the transfer returns false
304            var previousBalanceFrom = balanceOfAt(_from, block.number);
305            if (previousBalanceFrom < _amount) {
306                return false;
307            }
308 
309            // Alerts the token controller of the transfer
310            if (isContract(controller)) {
311                require(TokenController(controller).onTransfer(_from, _to, _amount));
312            }
313 
314            // First update the balance array with the new value for the address
315            //  sending the tokens
316            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
317 
318            // Then update the balance array with the new value for the address
319            //  receiving the tokens
320            var previousBalanceTo = balanceOfAt(_to, block.number);
321            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
322            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
323 
324            // An event to make the transfer easy to find on the blockchain
325            Transfer(_from, _to, _amount);
326 
327            return true;
328     }
329 
330     /// @param _owner The address that's balance is being requested
331     /// @return The balance of `_owner` at the current block
332     function balanceOf(address _owner) constant returns (uint256 balance) {
333         return balanceOfAt(_owner, block.number);
334     }
335 
336     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
337     ///  its behalf. This is a modified version of the ERC20 approve function
338     ///  to be a little bit safer
339     /// @param _spender The address of the account able to transfer the tokens
340     /// @param _amount The amount of tokens to be approved for transfer
341     /// @return True if the approval was successful
342     function approve(address _spender, uint256 _amount) returns (bool success) {
343         require(transfersEnabled);
344 
345         // To change the approve amount you first have to reduce the addresses`
346         //  allowance to zero by calling `approve(_spender,0)` if it is not
347         //  already 0 to mitigate the race condition described here:
348         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
349         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
350 
351         // Alerts the token controller of the approve function call
352         if (isContract(controller)) {
353             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
354         }
355 
356         allowed[msg.sender][_spender] = _amount;
357         Approval(msg.sender, _spender, _amount);
358         return true;
359     }
360 
361     /// @dev This function makes it easy to read the `allowed[]` map
362     /// @param _owner The address of the account that owns the token
363     /// @param _spender The address of the account able to transfer the tokens
364     /// @return Amount of remaining tokens of _owner that _spender is allowed
365     ///  to spend
366     function allowance(address _owner, address _spender
367     ) constant returns (uint256 remaining) {
368         return allowed[_owner][_spender];
369     }
370 
371     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
372     ///  its behalf, and then a function is triggered in the contract that is
373     ///  being approved, `_spender`. This allows users to use their tokens to
374     ///  interact with contracts in one function call instead of two
375     /// @param _spender The address of the contract able to transfer the tokens
376     /// @param _amount The amount of tokens to be approved for transfer
377     /// @return True if the function call was successful
378     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
379     ) returns (bool success) {
380         require(approve(_spender, _amount));
381 
382         ApproveAndCallFallBack(_spender).receiveApproval(
383             msg.sender,
384             _amount,
385             this,
386             _extraData
387         );
388 
389         return true;
390     }
391 
392     /// @dev This function makes it easy to get the total number of tokens
393     /// @return The total number of tokens
394     function totalSupply() constant returns (uint) {
395         return totalSupplyAt(block.number);
396     }
397 
398 
399 ////////////////
400 // Query balance and totalSupply in History
401 ////////////////
402 
403     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
404     /// @param _owner The address from which the balance will be retrieved
405     /// @param _blockNumber The block number when the balance is queried
406     /// @return The balance at `_blockNumber`
407     function balanceOfAt(address _owner, uint _blockNumber) constant
408         returns (uint) {
409 
410         // These next few lines are used when the balance of the token is
411         //  requested before a check point was ever created for this token, it
412         //  requires that the `parentToken.balanceOfAt` be queried at the
413         //  genesis block for that token as this contains initial balance of
414         //  this token
415         if ((balances[_owner].length == 0)
416             || (balances[_owner][0].fromBlock > _blockNumber)) {
417             if (address(parentToken) != 0) {
418                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
419             } else {
420                 // Has no parent
421                 return 0;
422             }
423 
424         // This will return the expected balance during normal situations
425         } else {
426             return getValueAt(balances[_owner], _blockNumber);
427         }
428     }
429 
430     /// @notice Total amount of tokens at a specific `_blockNumber`.
431     /// @param _blockNumber The block number when the totalSupply is queried
432     /// @return The total amount of tokens at `_blockNumber`
433     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
434 
435         // These next few lines are used when the totalSupply of the token is
436         //  requested before a check point was ever created for this token, it
437         //  requires that the `parentToken.totalSupplyAt` be queried at the
438         //  genesis block for this token as that contains totalSupply of this
439         //  token at this block number.
440         if ((totalSupplyHistory.length == 0)
441             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
442             if (address(parentToken) != 0) {
443                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
444             } else {
445                 return 0;
446             }
447 
448         // This will return the expected totalSupply during normal situations
449         } else {
450             return getValueAt(totalSupplyHistory, _blockNumber);
451         }
452     }
453 
454 ////////////////
455 // Clone Token Method
456 ////////////////
457 
458     /// @notice Creates a new clone token with the initial distribution being
459     ///  this token at `_snapshotBlock`
460     /// @param _cloneTokenName Name of the clone token
461     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
462     /// @param _cloneTokenSymbol Symbol of the clone token
463     /// @param _snapshotBlock Block when the distribution of the parent token is
464     ///  copied to set the initial distribution of the new clone token;
465     ///  if the block is zero than the actual block, the current block is used
466     /// @param _transfersEnabled True if transfers are allowed in the clone
467     /// @return The address of the new MiniMeToken Contract
468     function createCloneToken(
469         string _cloneTokenName,
470         uint8 _cloneDecimalUnits,
471         string _cloneTokenSymbol,
472         uint _snapshotBlock,
473         bool _transfersEnabled
474         ) returns(address) {
475         if (_snapshotBlock == 0) _snapshotBlock = block.number;
476         MiniMeToken cloneToken = tokenFactory.createCloneToken(
477             this,
478             _snapshotBlock,
479             _cloneTokenName,
480             _cloneDecimalUnits,
481             _cloneTokenSymbol,
482             _transfersEnabled
483             );
484 
485         cloneToken.changeController(msg.sender);
486 
487         // An event to make the token easy to find on the blockchain
488         NewCloneToken(address(cloneToken), _snapshotBlock);
489         return address(cloneToken);
490     }
491 
492 ////////////////
493 // Generate and destroy tokens
494 ////////////////
495 
496     /// @notice Generates `_amount` tokens that are assigned to `_owner`
497     /// @param _owner The address that will be assigned the new tokens
498     /// @param _amount The quantity of tokens generated
499     /// @return True if the tokens are generated correctly
500     function generateTokens(address _owner, uint _amount
501     ) onlyController returns (bool) {
502         uint curTotalSupply = totalSupply();
503         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
504         uint previousBalanceTo = balanceOf(_owner);
505         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
506         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
507         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
508         Transfer(0, _owner, _amount);
509         return true;
510     }
511 
512 
513     /// @notice Burns `_amount` tokens from `_owner`
514     /// @param _owner The address that will lose the tokens
515     /// @param _amount The quantity of tokens to burn
516     /// @return True if the tokens are burned correctly
517     function destroyTokens(address _owner, uint _amount
518     ) onlyController returns (bool) {
519         uint curTotalSupply = totalSupply();
520         require(curTotalSupply >= _amount);
521         uint previousBalanceFrom = balanceOf(_owner);
522         require(previousBalanceFrom >= _amount);
523         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
524         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
525         Transfer(_owner, 0, _amount);
526         return true;
527     }
528 
529 ////////////////
530 // Enable tokens transfers
531 ////////////////
532 
533 
534     /// @notice Enables token holders to transfer their tokens freely if true
535     /// @param _transfersEnabled True if transfers are allowed in the clone
536     function enableTransfers(bool _transfersEnabled) onlyController {
537         transfersEnabled = _transfersEnabled;
538     }
539 
540 ////////////////
541 // Internal helper functions to query and set a value in a snapshot array
542 ////////////////
543 
544     /// @dev `getValueAt` retrieves the number of tokens at a given block number
545     /// @param checkpoints The history of values being queried
546     /// @param _block The block number to retrieve the value at
547     /// @return The number of tokens being queried
548     function getValueAt(Checkpoint[] storage checkpoints, uint _block
549     ) constant internal returns (uint) {
550         if (checkpoints.length == 0) return 0;
551 
552         // Shortcut for the actual value
553         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
554             return checkpoints[checkpoints.length-1].value;
555         if (_block < checkpoints[0].fromBlock) return 0;
556 
557         // Binary search of the value in the array
558         uint min = 0;
559         uint max = checkpoints.length-1;
560         while (max > min) {
561             uint mid = (max + min + 1)/ 2;
562             if (checkpoints[mid].fromBlock<=_block) {
563                 min = mid;
564             } else {
565                 max = mid-1;
566             }
567         }
568         return checkpoints[min].value;
569     }
570 
571     /// @dev `updateValueAtNow` used to update the `balances` map and the
572     ///  `totalSupplyHistory`
573     /// @param checkpoints The history of data being updated
574     /// @param _value The new number of tokens
575     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
576     ) internal  {
577         if ((checkpoints.length == 0)
578         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
579                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
580                newCheckPoint.fromBlock =  uint128(block.number);
581                newCheckPoint.value = uint128(_value);
582            } else {
583                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
584                oldCheckPoint.value = uint128(_value);
585            }
586     }
587 
588     /// @dev Internal function to determine if an address is a contract
589     /// @param _addr The address being queried
590     /// @return True if `_addr` is a contract
591     function isContract(address _addr) constant internal returns(bool) {
592         uint size;
593         if (_addr == 0) return false;
594         assembly {
595             size := extcodesize(_addr)
596         }
597         return size>0;
598     }
599 
600     /// @dev Helper function to return a min betwen the two uints
601     function min(uint a, uint b) internal returns (uint) {
602         return a < b ? a : b;
603     }
604 
605     /// @notice The fallback function: If the contract's controller has not been
606     ///  set to 0, then the `proxyPayment` method is called which relays the
607     ///  ether and creates tokens as described in the token controller contract
608     function ()  payable {
609         require(isContract(controller));
610         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
611     }
612 
613 //////////
614 // Safety Methods
615 //////////
616 
617     /// @notice This method can be used by the controller to extract mistakenly
618     ///  sent tokens to this contract.
619     /// @param _token The address of the token contract that you want to recover
620     ///  set to 0 in case you want to extract ether.
621     function claimTokens(address _token) onlyController {
622         if (_token == 0x0) {
623             controller.transfer(this.balance);
624             return;
625         }
626 
627         MiniMeToken token = MiniMeToken(_token);
628         uint balance = token.balanceOf(this);
629         token.transfer(controller, balance);
630         ClaimedTokens(_token, controller, balance);
631     }
632 
633 ////////////////
634 // Events
635 ////////////////
636     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
637     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
638     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
639     event Approval(
640         address indexed _owner,
641         address indexed _spender,
642         uint256 _amount
643         );
644 
645 }
646 
647 
648 ////////////////
649 // MiniMeTokenFactory
650 ////////////////
651 
652 /// @dev This contract is used to generate clone contracts from a contract.
653 ///  In solidity this is the way to create a contract from a contract of the
654 ///  same class
655 contract MiniMeTokenFactory {
656 
657     /// @notice Update the DApp by creating a new token with new functionalities
658     ///  the msg.sender becomes the controller of this clone token
659     /// @param _parentToken Address of the token being cloned
660     /// @param _snapshotBlock Block of the parent token that will
661     ///  determine the initial distribution of the clone token
662     /// @param _tokenName Name of the new token
663     /// @param _decimalUnits Number of decimals of the new token
664     /// @param _tokenSymbol Token Symbol for the new token
665     /// @param _transfersEnabled If true, tokens will be able to be transferred
666     /// @return The address of the new token contract
667     function createCloneToken(
668         address _parentToken,
669         uint _snapshotBlock,
670         string _tokenName,
671         uint8 _decimalUnits,
672         string _tokenSymbol,
673         bool _transfersEnabled
674     ) returns (MiniMeToken) {
675         MiniMeToken newToken = new MiniMeToken(
676             this,
677             _parentToken,
678             _snapshotBlock,
679             _tokenName,
680             _decimalUnits,
681             _tokenSymbol,
682             _transfersEnabled
683             );
684 
685         newToken.changeController(msg.sender);
686         return newToken;
687     }
688 }
689 
690 contract RealistoToken is MiniMeToken { 
691 
692   // we use this variable to store the number of the finalization block
693   uint256 public checkpointBlock;
694 
695   // address which is allowed to trigger tokens generation
696   address public mayGenerateAddr;
697 
698   // flag
699   bool tokenGenerationEnabled; //<- added after first audit
700 
701 
702   modifier mayGenerate() {
703     require ( (msg.sender == mayGenerateAddr) &&
704               (tokenGenerationEnabled == true) ); //<- added after first audit
705     _;
706   }
707 
708   // Constructor
709   function RealistoToken(address _tokenFactory) 
710     MiniMeToken(
711       _tokenFactory,
712       0x0,
713       0,
714       "Realisto Token",
715       18, // decimals
716       "REA",
717       // SHOULD TRANSFERS BE ENABLED? -- NO
718       false){
719    
720     controller = msg.sender;
721      tokenGenerationEnabled = true;
722     mayGenerateAddr = controller;
723   }
724 
725   function setGenerateAddr(address _addr) onlyController{
726     // we can appoint an address to be allowed to generate tokens
727     require( _addr != 0x0 );
728     mayGenerateAddr = _addr;
729   }
730 
731 
732   /// @notice this is default function called when ETH is send to this contract
733   ///   we use the campaign contract for selling tokens
734   function () payable {
735     revert();
736   }
737 
738   
739   /// @notice This function is copy-paste of the generateTokens of the original MiniMi contract
740   ///   except it uses mayGenerate modifier (original uses onlyController)
741   /// this is because we don't want the Sale campaign contract to be the controller
742   function generate_token_for(address _addrTo, uint _amount) mayGenerate returns (bool) {
743     
744     //balances[_addr] += _amount;
745    
746     uint curTotalSupply = totalSupply();
747     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow    
748     uint previousBalanceTo = balanceOf(_addrTo);
749     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
750     updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
751     updateValueAtNow(balances[_addrTo], previousBalanceTo + _amount);
752     Transfer(0, _addrTo, _amount);
753     return true;
754   }
755 
756   // overwrites the original function
757   function generateTokens(address _owner, uint _amount
758     ) onlyController returns (bool) {
759     revert();
760     generate_token_for(_owner, _amount);    
761   }
762 
763 
764   // permanently disables generation of new tokens
765   function finalize() mayGenerate {
766     tokenGenerationEnabled = false; //<- added after first audit
767     checkpointBlock = block.number;
768   }  
769 }