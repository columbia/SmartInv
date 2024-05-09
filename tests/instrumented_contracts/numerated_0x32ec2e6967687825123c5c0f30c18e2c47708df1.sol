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
719     tokenGenerationEnabled = true;
720     controller = msg.sender;
721     mayGenerateAddr = controller;
722   }
723 
724   function setGenerateAddr(address _addr) onlyController{
725     // we can appoint an address to be allowed to generate tokens
726     require( _addr != 0x0 );
727     mayGenerateAddr = _addr;
728   }
729 
730 
731   /// @notice this is default function called when ETH is send to this contract
732   ///   we use the campaign contract for selling tokens
733   function () payable {
734     revert();
735   }
736 
737   
738   /// @notice This function is copy-paste of the generateTokens of the original MiniMi contract
739   ///   except it uses mayGenerate modifier (original uses onlyController)
740   /// this is because we don't want the Sale campaign contract to be the controller
741   function generate_token_for(address _addrTo, uint _amount) mayGenerate returns (bool) {
742     
743     //balances[_addr] += _amount;
744    
745     uint curTotalSupply = totalSupply();
746     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow    
747     uint previousBalanceTo = balanceOf(_addrTo);
748     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
749     updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
750     updateValueAtNow(balances[_addrTo], previousBalanceTo + _amount);
751     Transfer(0, _addrTo, _amount);
752     return true;
753   }
754 
755   // overwrites the original function
756   function generateTokens(address _owner, uint _amount
757     ) onlyController returns (bool) {
758     revert();
759     generate_token_for(_owner, _amount);    
760   }
761 
762 
763   // permanently disables generation of new tokens
764   function finalize() mayGenerate {
765     tokenGenerationEnabled = false; //<- added after first audit
766     checkpointBlock = block.number;
767   }  
768 }
769 
770 
771 
772 
773 //import "./LinearTokenVault.sol";
774 
775 
776 
777 // simple time locked vault allows controlled extraction of tokens during a period of time
778 
779 
780 // Controlled is implemented in MiniMeToken.sol 
781 contract TokenVault is Controlled {
782 	using SafeMath for uint256;
783 
784 
785 	//address campaignAddr;
786 	TokenCampaign campaign;
787 	//uint256 tUnlock = 0;
788 	uint256 tDuration;
789 	uint256 tLock = 12 * 30 * (1 days); // 12 months 
790 	MiniMeToken token;
791 
792 	uint256 extracted = 0;
793 
794 	event Extract(address indexed _to, uint256 _amount);
795 
796 	function TokenVault(
797 		address _tokenAddress,
798 	 	address _campaignAddress,
799 	 	uint256 _tDuration
800 	 	) {
801 
802 			require( _tDuration > 0);
803 			tDuration = _tDuration;
804 
805 			//campaignAddr = _campaignAddress;
806 			token = RealistoToken(_tokenAddress);
807 			campaign = TokenCampaign(_campaignAddress);
808 		}
809 
810 	/// WE DONT USE IT ANYMORE
811 	/// sale campaign calls this function to set the time lock
812 	/// @param _tUnlock - Unix timestamp of the first date 
813 	///							on which tokens become available
814 	//function setTimeLock(uint256 _tUnlock){
815 		// prevent change of the timestamp by anybody other than token sale contract
816 		// once unlock time is set it cannot be changed
817 		//require( (msg.sender == campaignAddr) && (tUnlock == 0));
818 	//	tUnlock = _tUnlock;
819 	//}
820 
821 	/// @notice Send all available tokens to a given address
822 	function extract(address _to) onlyController {
823 		
824 		require (_to != 0x0);
825 
826 		uint256 available = availableNow();
827 	
828 		require( available > 0 );
829 
830 		extracted = extracted.add(available);
831 		assert( token.transfer(_to, available) );
832 		
833 
834 		Extract(_to, available);
835 
836 	}
837 
838 	// returns amount of tokens held in this vault
839 	function balance() returns (uint256){
840 		return token.balanceOf(address(this));
841 	}
842 
843 	function get_unlock_time() returns (uint256){
844 		return campaign.tFinalized() + tLock;
845 	}
846 
847 	// returns amount of tokens available for extraction now
848 	function availableNow() returns (uint256){
849 		
850 		uint256 tUnlock = get_unlock_time();
851 		uint256 tNow = now;
852 
853 		// if before unlock time or unlock time is not set  => 0 is available 
854 		if (tNow < tUnlock ) { return 0; }
855 
856 		uint256 remaining = balance();
857 
858 		// if after longer than tDuration since unlock time => everything that is left is available
859 		if (tNow > tUnlock + tDuration) { return remaining; }
860 
861 		// otherwise:
862 		// compute how many extractions remaining based on time
863 
864 			// time delta
865 		uint256 t = (tNow.sub(tUnlock)).mul(remaining.add(extracted));
866 		return (t.div(tDuration)).sub(extracted);
867 	}
868 
869 }
870 
871 
872 contract rea_token_interface{
873   uint8 public decimals;
874   function generate_token_for(address _addr,uint _amount) returns (bool);
875   function finalize();
876 }
877 
878 
879 // Controlled is implemented in MiniMeToken.sol
880 contract TokenCampaign is Controlled{
881   using SafeMath for uint256;
882 
883   // this is our token
884   rea_token_interface public token;
885 
886   TokenVault teamVault;
887 
888  
889   ///////////////////////////////////
890   //
891   // constants related to token sale
892 
893   // after slae ends, additional tokens will be generated
894   // according to the following rules,
895   // where 100% correspond to the number of sold tokens
896 
897   // percent of tokens to be generated for the team
898   uint256 public constant PRCT_TEAM = 10;
899   // percent of tokens to be generated for bounty
900   uint256 public constant PRCT_BOUNTY = 3;
901  
902   // we keep ETH in the contract until the sale is finalized
903   // however a small part of every contribution goes to opperational costs
904   // percent of ETH going to operational account
905   uint256 public constant PRCT_ETH_OP = 10;
906 
907   uint8 public constant decimals = 18;
908   uint256 public constant scale = (uint256(10) ** decimals);
909 
910 
911   // how many tokens for one ETH
912   // we may adjust this number before deployment based on the market conditions
913   uint256 public constant baseRate = 330; //<-- unscaled
914 
915   // we want to limit the number of available tokens during the bonus stage 
916   // payments during the bonus stage will not be accepted after the TokenTreshold is reached or exceeded
917   // we may adjust this number before deployment based on the market conditions
918 
919   uint256 public constant bonusTokenThreshold = 2000000 * scale ; //<--- new 
920 
921   // minmal contribution, Wei
922   uint256 public constant minContribution = (1 ether) / 100;
923 
924   // bonus structure, Wei
925   uint256 public constant bonusMinContribution = (1 ether) /10;
926   // 
927   uint256 public constant bonusAdd = 99; // + 30% <-- corrected
928   uint256 public constant stage_1_add = 50;// + 15,15% <-- corrected
929   uint256 public constant stage_2_add = 33;// + 10%
930   uint256 public constant stage_3_add = 18;// + 5,45%
931   
932   ////////////////////////////////////////////////////////
933   //
934   // folowing addresses need to be set in the constructor
935   // we also have setter functions which allow to change
936   // an address if it is compromised or something happens
937 
938   // destination for team's share
939   // this should point to an instance of TokenVault contract
940   address public teamVaultAddr = 0x0;
941   
942   // destination for reward tokens
943   address public bountyVaultAddr;
944 
945   // destination for collected Ether
946   address public trusteeVaultAddr;
947   
948   // destination for operational costs account
949   address public opVaultAddr;
950   
951 
952   // adress of our token
953   address public tokenAddr;
954 
955 
956   // address of our bitcoin payment processing robot
957   // the robot is allowed to generate tokens without
958   // sending ether
959   // we do it to have more granular rights controll 
960   address public robotAddr;
961   
962   
963   /////////////////////////////////
964   // Realted to Campaign
965 
966 
967   // @check ensure that state transitions are 
968   // only in one direction
969   // 4 - passive, not accepting funds
970   // 3 - is not used
971   // 2 - active main sale, accepting funds
972   // 1 - closed, not accepting funds 
973   // 0 - finalized, not accepting funds
974   uint8 public campaignState = 4; 
975   bool public paused = false;
976 
977   // keeps track of tokens generated so far, scaled value
978   uint256 public tokensGenerated = 0;
979 
980   // total Ether raised (= Ether paid into the contract)
981   uint256 public amountRaised = 0; 
982 
983   
984   // this is the address where the funds 
985   // will be transfered after the sale ends
986   
987   // time in seconds since epoch 
988   // set to midnight of saturday January 1st, 4000
989   uint256 public tCampaignStart = 64060588800;
990   uint256 public tBonusStageEnd = 7 * (1 days);
991   uint256 public tRegSaleStart = 8 * (1 days);
992   uint256 public t_1st_StageEnd = 15 * (1 days);
993   uint256 public t_2nd_StageEnd = 22* (1 days);
994   uint256 public t_3rd_StageEnd = 29 * (1 days);
995   uint256 public tCampaignEnd = 38 * (1 days);
996   uint256 public tFinalized = 64060588800;
997 
998   //////////////////////////////////////////////
999   //
1000   // Modifiers
1001 
1002   /// @notice The robot is allowed to generate tokens 
1003   ///   without sending ether
1004   ///  We do it to have more granular rights controll 
1005   modifier onlyRobot () { 
1006    require(msg.sender == robotAddr); 
1007    _;
1008   }
1009 
1010   //////////////////////////////////////////////
1011   //
1012   // Events
1013  
1014   event CampaignOpen(uint256 time);
1015   event CampaignClosed(uint256 time);
1016   event CampaignPausd(uint256 time);
1017   event CampaignResumed(uint256 time);
1018   event TokenGranted(address indexed backer, uint amount, string ref);
1019   event TokenGranted(address indexed backer, uint amount);
1020   event TotalRaised(uint raised);
1021   event Finalized(uint256 time);
1022   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
1023  
1024 
1025   /// @notice Constructor
1026   /// @param _tokenAddress Our token's address
1027   /// @param  _trusteeAddress Team share 
1028   /// @param  _opAddress Team share 
1029   /// @param  _bountyAddress Team share 
1030   /// @param  _robotAddress Address of our processing backend
1031   function TokenCampaign(
1032     address _tokenAddress,
1033     address _trusteeAddress,
1034     address _opAddress,
1035     address _bountyAddress,
1036     address _robotAddress)
1037   {
1038 
1039     controller = msg.sender;
1040     
1041     /// set addresses     
1042     tokenAddr = _tokenAddress;
1043     //teamVaultAddr = _teamAddress;
1044     trusteeVaultAddr = _trusteeAddress; 
1045     opVaultAddr = _opAddress;
1046     bountyVaultAddr = _bountyAddress;
1047     robotAddr = _robotAddress;
1048 
1049     /// reference our token
1050     token = rea_token_interface(tokenAddr);
1051    
1052     // adjust 'constants' for decimals used
1053     // decimals = token.decimals(); // should be 18
1054    
1055   }
1056 
1057 
1058   //////////////////////////////////////////////////
1059   ///
1060   /// Functions that do not change contract state
1061   function get_presale_goal() constant returns (bool){
1062     if ((now <= tBonusStageEnd) && (tokensGenerated >= bonusTokenThreshold)){
1063       return true;
1064     } else {
1065       return false;
1066     }
1067   }
1068 
1069   /// @notice computes the current rate
1070   ///  according to time passed since the start
1071   /// @return amount of tokens per ETH
1072   function get_rate() constant returns (uint256){
1073     
1074     // obviously one gets 0 tokens
1075     // if campaign not yet started
1076     // or is already over
1077     if (now < tCampaignStart) return 0;
1078     if (now > tCampaignEnd) return 0;
1079     
1080     // compute rate per ETH based on time
1081     // assumes that time marks are increasing
1082     // from tBonusStageEnd through t_3rd_StageEnd
1083     // adjust by factor 'scale' depending on token's decimals
1084     // NOTE: can't cause overflow since all numbers are known at compile time
1085     if (now <= tBonusStageEnd)
1086       return scale * (baseRate + bonusAdd);
1087 
1088     if (now <= t_1st_StageEnd)
1089       return scale * (baseRate + stage_1_add);
1090     
1091     else if (now <= t_2nd_StageEnd)
1092       return scale * (baseRate + stage_2_add);
1093     
1094     else if (now <= t_3rd_StageEnd)
1095       return scale * (baseRate + stage_3_add);
1096     
1097     else 
1098       return baseRate * scale; 
1099   }
1100 
1101 
1102   /////////////////////////////////////////////
1103   ///
1104   /// Functions that change contract state
1105 
1106   ///
1107   /// Setters
1108   ///
1109 
1110 
1111   /// this is only for emergency case
1112   function setRobotAddr(address _newRobotAddr) public onlyController {
1113     require( _newRobotAddr != 0x0 );
1114     robotAddr = _newRobotAddr;
1115   }
1116 
1117   // we have to set team token address before campaign start
1118   function setTeamAddr(address _newTeamAddr) public onlyController {
1119      require( campaignState > 2 && _newTeamAddr != 0x0 );
1120      teamVaultAddr = _newTeamAddr;
1121      teamVault = TokenVault(teamVaultAddr);
1122   }
1123  
1124 
1125 
1126   /// @notice  Puts campaign into active state  
1127   ///  only controller can do that
1128   ///  only possible if team token Vault is set up
1129   ///  WARNING: usual caveats apply to the Ethereum's interpretation of time
1130   function startSale() public onlyController {
1131     // we only can start if team token Vault address is set
1132     require( campaignState > 2 && teamVaultAddr != 0x0);
1133 
1134     campaignState = 2;
1135 
1136     uint256 tNow = now;
1137     // assume timestamps will not cause overflow
1138     tCampaignStart = tNow;
1139     tBonusStageEnd += tNow;
1140     tRegSaleStart += tNow;
1141     t_1st_StageEnd += tNow;
1142     t_2nd_StageEnd += tNow;
1143     t_3rd_StageEnd += tNow;
1144     tCampaignEnd += tNow;
1145 
1146     CampaignOpen(now);
1147   }
1148 
1149 
1150   /// @notice Pause sale
1151   ///   just in case we have some troubles 
1152   ///   Note that time marks are not updated
1153   function pauseSale() public onlyController {
1154     require( campaignState  == 2 );
1155     paused = true;
1156     CampaignPausd(now);
1157   }
1158 
1159 
1160   /// @notice Resume sale
1161   function resumeSale() public onlyController {
1162     require( campaignState  == 2 );
1163     paused = false;
1164     CampaignResumed(now);
1165   }
1166 
1167 
1168 
1169   /// @notice Puts the camapign into closed state
1170   ///   only controller can do so
1171   ///   only possible from the active state
1172   ///   we can call this function if we want to stop sale before end time 
1173   ///   and be able to perform 'finalizeCampaign()' immediately
1174   function closeSale() public onlyController {
1175     require( campaignState  == 2 );
1176     campaignState = 1;
1177 
1178     CampaignClosed(now);
1179   }   
1180 
1181 
1182 
1183   /// @notice Finalizes the campaign
1184   ///   Get funds out, generates team, bounty and reserve tokens
1185   function finalizeCampaign() public {     
1186       
1187       /// only if sale was closed or 48 hours = 2880 minutes have passed since campaign end
1188       /// we leave this time to complete possibly pending orders
1189       /// from offchain contributions 
1190       
1191       require ( (campaignState == 1) ||
1192                 ((campaignState != 0) && (now > tCampaignEnd + (2880 minutes))));
1193       
1194       campaignState = 0;
1195 
1196      
1197 
1198       // forward funds to the trustee 
1199       // since we forward a fraction of the incomming ether on every contribution
1200       // 'amountRaised' IS NOT equal to the contract's balance
1201       // we use 'this.balance' instead
1202 
1203       trusteeVaultAddr.transfer(this.balance);
1204       
1205       
1206       uint256 bountyTokens = (tokensGenerated.mul(PRCT_BOUNTY)).div(100);
1207       
1208       uint256 teamTokens = (tokensGenerated.mul(PRCT_TEAM)).div(100);
1209       
1210       // generate bounty tokens 
1211       assert( do_grant_tokens(bountyVaultAddr, bountyTokens) );
1212       // generate team tokens
1213       // time lock team tokens before transfer
1214       
1215       // we dont use it anymore
1216       //teamVault.setTimeLock( tCampaignEnd + 6 * (6 minutes));  
1217       
1218       tFinalized = now;
1219 
1220       // generate all the tokens
1221       assert( do_grant_tokens(teamVaultAddr, teamTokens) );
1222       
1223       // prevent further token generation
1224       token.finalize();     
1225 
1226       // notify the world
1227       Finalized(tFinalized);
1228    }
1229 
1230 
1231   /// @notice triggers token generaton for the recipient
1232   ///  can be called only from the token sale contract itself
1233   ///  side effect: increases the generated tokens counter 
1234   ///  CAUTION: we do not check campaign state and parameters assuming that's calee's task
1235   function do_grant_tokens(address _to, uint256 _nTokens) internal returns (bool){
1236     
1237     require( token.generate_token_for(_to, _nTokens) );
1238     
1239     tokensGenerated = tokensGenerated.add(_nTokens);
1240     
1241     return true;
1242   }
1243 
1244 
1245   ///  @notice processes the contribution
1246   ///   checks campaign state, time window and minimal contribution
1247   ///   throws if one of the conditions fails
1248   function process_contribution(address _toAddr) internal {
1249     
1250     require ((campaignState == 2)   // active main sale
1251          && (now <= tCampaignEnd)   // within time window
1252          && (paused == false));     // not on hold
1253       
1254 
1255     // contributions are not possible before regular sale starts 
1256     if ( (now > tBonusStageEnd) && //<--- new
1257          (now < tRegSaleStart)){ //<--- new
1258       revert(); //<--- new
1259     }
1260 
1261     // during the bonus phase we require a minimal eth contribution 
1262     if ((now <= tBonusStageEnd) && 
1263         ((msg.value < bonusMinContribution ) ||
1264         (tokensGenerated >= bonusTokenThreshold))) //<--- new, revert if bonusThreshold is exceeded 
1265     {
1266       revert();
1267     }      
1268 
1269     
1270   
1271     // otherwise we check that Eth sent is sufficient to generate at least one token
1272     // though our token has decimals we don't want nanocontributions
1273     require ( msg.value >= minContribution );
1274 
1275     // compute the rate
1276     // NOTE: rate is scaled to account for token decimals
1277     uint256 rate = get_rate();
1278     
1279     // compute the amount of tokens to be generated
1280     uint256 nTokens = (rate.mul(msg.value)).div(1 ether);
1281     
1282     // compute the fraction of ETH going to op account
1283     uint256 opEth = (PRCT_ETH_OP.mul(msg.value)).div(100);
1284 
1285     // transfer to op account 
1286     opVaultAddr.transfer(opEth);
1287     
1288     // @todo check success (NOTE we have no cap now so success is assumed)
1289     // side effect: do_grant_tokens updates the "tokensGenerated" variable
1290     require( do_grant_tokens(_toAddr, nTokens) );
1291 
1292 
1293     amountRaised = amountRaised.add(msg.value);
1294     
1295     // notify the world
1296     TokenGranted(_toAddr, nTokens);
1297     TotalRaised(amountRaised);
1298   }
1299 
1300 
1301   /// @notice Gnenerate token "manually" without payment
1302   ///  We intend to use this to generate tokens from Bitcoin contributions without 
1303   ///  without Ether being sent to this contract
1304   ///  Note that this function can be triggered only by our BTC processing robot.  
1305   ///  A string reference is passed and logged for better book keeping
1306   ///  side effect: increases the generated tokens counter via do_grant_tokens
1307   /// @param _toAddr benificiary address
1308   /// @param _nTokens amount of tokens to be generated
1309   /// @param _ref payment reference e.g. Bitcoin address used for contribution 
1310   function grant_token_from_offchain(address _toAddr, uint _nTokens, string _ref) public onlyRobot {
1311     require ( (campaignState == 2)
1312               ||(campaignState == 1));
1313 
1314     do_grant_tokens(_toAddr, _nTokens);
1315     TokenGranted(_toAddr, _nTokens, _ref);
1316   }
1317 
1318 
1319   /// @notice This function handles receiving Ether in favor of a third party address
1320   ///   we can use this function for buying tokens on behalf
1321   /// @param _toAddr the address which will receive tokens
1322   function proxy_contribution(address _toAddr) public payable {
1323     require ( _toAddr != 0x0 );
1324     /// prevent contracts from buying tokens
1325     /// we assume it is still usable for a while
1326     /// we aknowledge the fact that this prevents ALL contracts including MultiSig's
1327     /// from contributing, it is intended and we add a corresponding statement 
1328     /// to our Terms and the ICO site
1329     require( msg.sender == tx.origin );
1330     process_contribution(_toAddr);
1331   }
1332 
1333 
1334   /// @notice This function handles receiving Ether
1335   function () payable {
1336     /// prevent contracts from buying tokens
1337     /// we assume it is still usable for a while
1338     /// we aknowledge the fact that this prevents ALL contracts including MultiSig's
1339     /// from contributing, it is intended and we add a corresponding statement 
1340     /// to our Terms and the ICO site
1341     require( msg.sender == tx.origin );
1342     process_contribution(msg.sender);  
1343   }
1344 
1345   //////////
1346   // Safety Methods
1347   //////////
1348 
1349   /* inspired by MiniMeToken.sol */
1350 
1351   /// @notice This method can be used by the controller to extract mistakenly
1352   ///  sent tokens to this contract.
1353   function claimTokens(address _tokenAddr) public onlyController {
1354      
1355      // if (_token == 0x0) {
1356      //     controller.transfer(this.balance);
1357      //     return;
1358      // }
1359 
1360       ERC20Basic some_token = ERC20Basic(_tokenAddr);
1361       uint balance = some_token.balanceOf(this);
1362       some_token.transfer(controller, balance);
1363       ClaimedTokens(_tokenAddr, controller, balance);
1364   }
1365 }