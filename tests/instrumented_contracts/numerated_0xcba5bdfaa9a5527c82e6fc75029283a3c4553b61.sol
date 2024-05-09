1 pragma solidity ^0.4.17;
2 
3 contract iTinyTokenPreSale {
4     using SafeMath for uint256;
5     
6     iTinyToken public token;
7     MiniMeTokenFactory public tokenFactory;
8 
9     address public beneficiary;
10     uint256 public amountRaised;
11     uint256 public bonus;
12 
13     uint256 constant public exchange = 6400;
14     uint256 constant public minSaleAmount = 6400000000000000000000;
15 
16     function iTinyTokenPreSale(
17         address _tokenFactory,
18         address _beneficiary
19     ) public {
20         // Create iTinyToken
21         token = new iTinyToken(_tokenFactory);
22         // Generate all iTinyTokens and send them 
23         token.generateTokens(this, 10000000000000000000000000); // 10.000.000 iTinyTokens
24         // Deactivate the control of the iTinyToken Smart Contract
25         token.changeController(0x0);
26         beneficiary = _beneficiary;
27         bonus = 0; // 0% Initial bonus
28     }
29 
30     function () public payable {
31         uint256 amount = msg.value;
32         uint256 tokenAmount = amount.mul(exchange);
33         assert(tokenAmount >= minSaleAmount);
34         tokenAmount = tokenAmount.add(tokenAmount.percent(bonus));
35         amountRaised = amountRaised.add(amount);
36         token.transfer(msg.sender, tokenAmount);
37     }
38 
39     function WithdrawETH(uint256 _amount) public {
40         require(msg.sender == beneficiary);
41         msg.sender.transfer(_amount);
42     }
43 
44     function WithdrawTokens(uint256 _amount) public {
45         require(msg.sender == beneficiary);
46         token.transfer(beneficiary, _amount);
47     }
48 
49     function TransferTokens(address _to, uint _amount) public {
50         require(msg.sender == beneficiary);
51         token.transfer(_to, _amount);
52     }
53 
54     function ChangeBonus(uint256 _bonus) public {
55         require(msg.sender == beneficiary);
56         bonus = _bonus;
57     }
58 }
59 
60 /*
61     Copyright 2016, Jordi Baylina
62 
63     This program is free software: you can redistribute it and/or modify
64     it under the terms of the GNU General Public License as published by
65     the Free Software Foundation, either version 3 of the License, or
66     (at your option) any later version.
67 
68     This program is distributed in the hope that it will be useful,
69     but WITHOUT ANY WARRANTY; without even the implied warranty of
70     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
71     GNU General Public License for more details.
72 
73     You should have received a copy of the GNU General Public License
74     along with this program.  If not, see <http://www.gnu.org/licenses/>.
75  */
76 
77 /// @title MiniMeToken Contract
78 /// @author Jordi Baylina
79 /// @dev This token contract's goal is to make it easy for anyone to clone this
80 ///  token using the token distribution at a given block, this will allow DAO's
81 ///  and DApps to upgrade their features in a decentralized manner without
82 ///  affecting the original token
83 /// @dev It is ERC20 compliant, but still needs to under go further testing.
84 
85 
86 /// @dev The token controller contract must implement these functions
87 contract TokenController {
88     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
89     /// @param _owner The address that sent the ether to create tokens
90     /// @return True if the ether is accepted, false if it throws
91     function proxyPayment(address _owner) payable returns(bool);
92 
93     /// @notice Notifies the controller about a token transfer allowing the
94     ///  controller to react if desired
95     /// @param _from The origin of the transfer
96     /// @param _to The destination of the transfer
97     /// @param _amount The amount of the transfer
98     /// @return False if the controller does not authorize the transfer
99     function onTransfer(address _from, address _to, uint _amount) returns(bool);
100 
101     /// @notice Notifies the controller about an approval allowing the
102     ///  controller to react if desired
103     /// @param _owner The address that calls `approve()`
104     /// @param _spender The spender in the `approve()` call
105     /// @param _amount The amount in the `approve()` call
106     /// @return False if the controller does not authorize the approval
107     function onApprove(address _owner, address _spender, uint _amount)
108         returns(bool);
109 }
110 
111 contract Controlled {
112     /// @notice The address of the controller is the only address that can call
113     ///  a function with this modifier
114     modifier onlyController { require(msg.sender == controller); _; }
115 
116     address public controller;
117 
118     function Controlled() { controller = msg.sender;}
119 
120     /// @notice Changes the controller of the contract
121     /// @param _newController The new controller of the contract
122     function changeController(address _newController) onlyController {
123         controller = _newController;
124     }
125 }
126 
127 contract ApproveAndCallFallBack {
128     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
129 }
130 
131 /// @dev The actual token contract, the default controller is the msg.sender
132 ///  that deploys the contract, so usually this token will be deployed by a
133 ///  token controller contract, which Giveth will call a "Campaign"
134 contract MiniMeToken is Controlled {
135 
136     string public name;                //The Token's name: e.g. DigixDAO Tokens
137     uint8 public decimals;             //Number of decimals of the smallest unit
138     string public symbol;              //An identifier: e.g. REP
139     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
140 
141 
142     /// @dev `Checkpoint` is the structure that attaches a block number to a
143     ///  given value, the block number attached is the one that last changed the
144     ///  value
145     struct  Checkpoint {
146 
147         // `fromBlock` is the block number that the value was generated from
148         uint128 fromBlock;
149 
150         // `value` is the amount of tokens at a specific block number
151         uint128 value;
152     }
153 
154     // `parentToken` is the Token address that was cloned to produce this token;
155     //  it will be 0x0 for a token that was not cloned
156     MiniMeToken public parentToken;
157 
158     // `parentSnapShotBlock` is the block number from the Parent Token that was
159     //  used to determine the initial distribution of the Clone Token
160     uint public parentSnapShotBlock;
161 
162     // `creationBlock` is the block number that the Clone Token was created
163     uint public creationBlock;
164 
165     // `balances` is the map that tracks the balance of each address, in this
166     //  contract when the balance changes the block number that the change
167     //  occurred is also included in the map
168     mapping (address => Checkpoint[]) balances;
169 
170     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
171     mapping (address => mapping (address => uint256)) allowed;
172 
173     // Tracks the history of the `totalSupply` of the token
174     Checkpoint[] totalSupplyHistory;
175 
176     // Flag that determines if the token is transferable or not.
177     bool public transfersEnabled;
178 
179     // The factory used to create new clone tokens
180     MiniMeTokenFactory public tokenFactory;
181 
182 ////////////////
183 // Constructor
184 ////////////////
185 
186     /// @notice Constructor to create a MiniMeToken
187     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
188     ///  will create the Clone token contracts, the token factory needs to be
189     ///  deployed first
190     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
191     ///  new token
192     /// @param _parentSnapShotBlock Block of the parent token that will
193     ///  determine the initial distribution of the clone token, set to 0 if it
194     ///  is a new token
195     /// @param _tokenName Name of the new token
196     /// @param _decimalUnits Number of decimals of the new token
197     /// @param _tokenSymbol Token Symbol for the new token
198     /// @param _transfersEnabled If true, tokens will be able to be transferred
199     function MiniMeToken(
200         address _tokenFactory,
201         address _parentToken,
202         uint _parentSnapShotBlock,
203         string _tokenName,
204         uint8 _decimalUnits,
205         string _tokenSymbol,
206         bool _transfersEnabled
207     ) {
208         tokenFactory = MiniMeTokenFactory(_tokenFactory);
209         name = _tokenName;                                 // Set the name
210         decimals = _decimalUnits;                          // Set the decimals
211         symbol = _tokenSymbol;                             // Set the symbol
212         parentToken = MiniMeToken(_parentToken);
213         parentSnapShotBlock = _parentSnapShotBlock;
214         transfersEnabled = _transfersEnabled;
215         creationBlock = block.number;
216     }
217 
218 
219 ///////////////////
220 // ERC20 Methods
221 ///////////////////
222 
223     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
224     /// @param _to The address of the recipient
225     /// @param _amount The amount of tokens to be transferred
226     /// @return Whether the transfer was successful or not
227     function transfer(address _to, uint256 _amount) returns (bool success) {
228         require(transfersEnabled);
229         return doTransfer(msg.sender, _to, _amount);
230     }
231 
232     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
233     ///  is approved by `_from`
234     /// @param _from The address holding the tokens being transferred
235     /// @param _to The address of the recipient
236     /// @param _amount The amount of tokens to be transferred
237     /// @return True if the transfer was successful
238     function transferFrom(address _from, address _to, uint256 _amount
239     ) returns (bool success) {
240 
241         // The controller of this contract can move tokens around at will,
242         //  this is important to recognize! Confirm that you trust the
243         //  controller of this contract, which in most situations should be
244         //  another open source smart contract or 0x0
245         if (msg.sender != controller) {
246             require(transfersEnabled);
247 
248             // The standard ERC 20 transferFrom functionality
249             if (allowed[_from][msg.sender] < _amount) return false;
250             allowed[_from][msg.sender] -= _amount;
251         }
252         return doTransfer(_from, _to, _amount);
253     }
254 
255     /// @dev This is the actual transfer function in the token contract, it can
256     ///  only be called by other functions in this contract.
257     /// @param _from The address holding the tokens being transferred
258     /// @param _to The address of the recipient
259     /// @param _amount The amount of tokens to be transferred
260     /// @return True if the transfer was successful
261     function doTransfer(address _from, address _to, uint _amount
262     ) internal returns(bool) {
263 
264            if (_amount == 0) {
265                return true;
266            }
267 
268            require(parentSnapShotBlock < block.number);
269 
270            // Do not allow transfer to 0x0 or the token contract itself
271            require((_to != 0) && (_to != address(this)));
272 
273            // If the amount being transfered is more than the balance of the
274            //  account the transfer returns false
275            var previousBalanceFrom = balanceOfAt(_from, block.number);
276            if (previousBalanceFrom < _amount) {
277                return false;
278            }
279 
280            // Alerts the token controller of the transfer
281            if (isContract(controller)) {
282                require(TokenController(controller).onTransfer(_from, _to, _amount));
283            }
284 
285            // First update the balance array with the new value for the address
286            //  sending the tokens
287            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
288 
289            // Then update the balance array with the new value for the address
290            //  receiving the tokens
291            var previousBalanceTo = balanceOfAt(_to, block.number);
292            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
293            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
294 
295            // An event to make the transfer easy to find on the blockchain
296            Transfer(_from, _to, _amount);
297 
298            return true;
299     }
300 
301     /// @param _owner The address that's balance is being requested
302     /// @return The balance of `_owner` at the current block
303     function balanceOf(address _owner) constant returns (uint256 balance) {
304         return balanceOfAt(_owner, block.number);
305     }
306 
307     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
308     ///  its behalf. This is a modified version of the ERC20 approve function
309     ///  to be a little bit safer
310     /// @param _spender The address of the account able to transfer the tokens
311     /// @param _amount The amount of tokens to be approved for transfer
312     /// @return True if the approval was successful
313     function approve(address _spender, uint256 _amount) returns (bool success) {
314         require(transfersEnabled);
315 
316         // To change the approve amount you first have to reduce the addresses`
317         //  allowance to zero by calling `approve(_spender,0)` if it is not
318         //  already 0 to mitigate the race condition described here:
319         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
320         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
321 
322         // Alerts the token controller of the approve function call
323         if (isContract(controller)) {
324             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
325         }
326 
327         allowed[msg.sender][_spender] = _amount;
328         Approval(msg.sender, _spender, _amount);
329         return true;
330     }
331 
332     /// @dev This function makes it easy to read the `allowed[]` map
333     /// @param _owner The address of the account that owns the token
334     /// @param _spender The address of the account able to transfer the tokens
335     /// @return Amount of remaining tokens of _owner that _spender is allowed
336     ///  to spend
337     function allowance(address _owner, address _spender
338     ) constant returns (uint256 remaining) {
339         return allowed[_owner][_spender];
340     }
341 
342     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
343     ///  its behalf, and then a function is triggered in the contract that is
344     ///  being approved, `_spender`. This allows users to use their tokens to
345     ///  interact with contracts in one function call instead of two
346     /// @param _spender The address of the contract able to transfer the tokens
347     /// @param _amount The amount of tokens to be approved for transfer
348     /// @return True if the function call was successful
349     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
350     ) returns (bool success) {
351         require(approve(_spender, _amount));
352 
353         ApproveAndCallFallBack(_spender).receiveApproval(
354             msg.sender,
355             _amount,
356             this,
357             _extraData
358         );
359 
360         return true;
361     }
362 
363     /// @dev This function makes it easy to get the total number of tokens
364     /// @return The total number of tokens
365     function totalSupply() constant returns (uint) {
366         return totalSupplyAt(block.number);
367     }
368 
369 
370 ////////////////
371 // Query balance and totalSupply in History
372 ////////////////
373 
374     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
375     /// @param _owner The address from which the balance will be retrieved
376     /// @param _blockNumber The block number when the balance is queried
377     /// @return The balance at `_blockNumber`
378     function balanceOfAt(address _owner, uint _blockNumber) constant
379         returns (uint) {
380 
381         // These next few lines are used when the balance of the token is
382         //  requested before a check point was ever created for this token, it
383         //  requires that the `parentToken.balanceOfAt` be queried at the
384         //  genesis block for that token as this contains initial balance of
385         //  this token
386         if ((balances[_owner].length == 0)
387             || (balances[_owner][0].fromBlock > _blockNumber)) {
388             if (address(parentToken) != 0) {
389                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
390             } else {
391                 // Has no parent
392                 return 0;
393             }
394 
395         // This will return the expected balance during normal situations
396         } else {
397             return getValueAt(balances[_owner], _blockNumber);
398         }
399     }
400 
401     /// @notice Total amount of tokens at a specific `_blockNumber`.
402     /// @param _blockNumber The block number when the totalSupply is queried
403     /// @return The total amount of tokens at `_blockNumber`
404     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
405 
406         // These next few lines are used when the totalSupply of the token is
407         //  requested before a check point was ever created for this token, it
408         //  requires that the `parentToken.totalSupplyAt` be queried at the
409         //  genesis block for this token as that contains totalSupply of this
410         //  token at this block number.
411         if ((totalSupplyHistory.length == 0)
412             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
413             if (address(parentToken) != 0) {
414                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
415             } else {
416                 return 0;
417             }
418 
419         // This will return the expected totalSupply during normal situations
420         } else {
421             return getValueAt(totalSupplyHistory, _blockNumber);
422         }
423     }
424 
425 ////////////////
426 // Clone Token Method
427 ////////////////
428 
429     /// @notice Creates a new clone token with the initial distribution being
430     ///  this token at `_snapshotBlock`
431     /// @param _cloneTokenName Name of the clone token
432     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
433     /// @param _cloneTokenSymbol Symbol of the clone token
434     /// @param _snapshotBlock Block when the distribution of the parent token is
435     ///  copied to set the initial distribution of the new clone token;
436     ///  if the block is zero than the actual block, the current block is used
437     /// @param _transfersEnabled True if transfers are allowed in the clone
438     /// @return The address of the new MiniMeToken Contract
439     function createCloneToken(
440         string _cloneTokenName,
441         uint8 _cloneDecimalUnits,
442         string _cloneTokenSymbol,
443         uint _snapshotBlock,
444         bool _transfersEnabled
445         ) returns(address) {
446         if (_snapshotBlock == 0) _snapshotBlock = block.number;
447         MiniMeToken cloneToken = tokenFactory.createCloneToken(
448             this,
449             _snapshotBlock,
450             _cloneTokenName,
451             _cloneDecimalUnits,
452             _cloneTokenSymbol,
453             _transfersEnabled
454             );
455 
456         cloneToken.changeController(msg.sender);
457 
458         // An event to make the token easy to find on the blockchain
459         NewCloneToken(address(cloneToken), _snapshotBlock);
460         return address(cloneToken);
461     }
462 
463 ////////////////
464 // Generate and destroy tokens
465 ////////////////
466 
467     /// @notice Generates `_amount` tokens that are assigned to `_owner`
468     /// @param _owner The address that will be assigned the new tokens
469     /// @param _amount The quantity of tokens generated
470     /// @return True if the tokens are generated correctly
471     function generateTokens(address _owner, uint _amount
472     ) onlyController returns (bool) {
473         uint curTotalSupply = totalSupply();
474         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
475         uint previousBalanceTo = balanceOf(_owner);
476         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
477         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
478         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
479         Transfer(0, _owner, _amount);
480         return true;
481     }
482 
483 
484     /// @notice Burns `_amount` tokens from `_owner`
485     /// @param _owner The address that will lose the tokens
486     /// @param _amount The quantity of tokens to burn
487     /// @return True if the tokens are burned correctly
488     function destroyTokens(address _owner, uint _amount
489     ) onlyController returns (bool) {
490         uint curTotalSupply = totalSupply();
491         require(curTotalSupply >= _amount);
492         uint previousBalanceFrom = balanceOf(_owner);
493         require(previousBalanceFrom >= _amount);
494         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
495         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
496         Transfer(_owner, 0, _amount);
497         return true;
498     }
499 
500 ////////////////
501 // Enable tokens transfers
502 ////////////////
503 
504 
505     /// @notice Enables token holders to transfer their tokens freely if true
506     /// @param _transfersEnabled True if transfers are allowed in the clone
507     function enableTransfers(bool _transfersEnabled) onlyController {
508         transfersEnabled = _transfersEnabled;
509     }
510 
511 ////////////////
512 // Internal helper functions to query and set a value in a snapshot array
513 ////////////////
514 
515     /// @dev `getValueAt` retrieves the number of tokens at a given block number
516     /// @param checkpoints The history of values being queried
517     /// @param _block The block number to retrieve the value at
518     /// @return The number of tokens being queried
519     function getValueAt(Checkpoint[] storage checkpoints, uint _block
520     ) constant internal returns (uint) {
521         if (checkpoints.length == 0) return 0;
522 
523         // Shortcut for the actual value
524         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
525             return checkpoints[checkpoints.length-1].value;
526         if (_block < checkpoints[0].fromBlock) return 0;
527 
528         // Binary search of the value in the array
529         uint min = 0;
530         uint max = checkpoints.length-1;
531         while (max > min) {
532             uint mid = (max + min + 1)/ 2;
533             if (checkpoints[mid].fromBlock<=_block) {
534                 min = mid;
535             } else {
536                 max = mid-1;
537             }
538         }
539         return checkpoints[min].value;
540     }
541 
542     /// @dev `updateValueAtNow` used to update the `balances` map and the
543     ///  `totalSupplyHistory`
544     /// @param checkpoints The history of data being updated
545     /// @param _value The new number of tokens
546     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
547     ) internal  {
548         if ((checkpoints.length == 0)
549         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
550                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
551                newCheckPoint.fromBlock =  uint128(block.number);
552                newCheckPoint.value = uint128(_value);
553            } else {
554                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
555                oldCheckPoint.value = uint128(_value);
556            }
557     }
558 
559     /// @dev Internal function to determine if an address is a contract
560     /// @param _addr The address being queried
561     /// @return True if `_addr` is a contract
562     function isContract(address _addr) constant internal returns(bool) {
563         uint size;
564         if (_addr == 0) return false;
565         assembly {
566             size := extcodesize(_addr)
567         }
568         return size>0;
569     }
570 
571     /// @dev Helper function to return a min betwen the two uints
572     function min(uint a, uint b) internal returns (uint) {
573         return a < b ? a : b;
574     }
575 
576     /// @notice The fallback function: If the contract's controller has not been
577     ///  set to 0, then the `proxyPayment` method is called which relays the
578     ///  ether and creates tokens as described in the token controller contract
579     function ()  payable {
580         require(isContract(controller));
581         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
582     }
583 
584 //////////
585 // Safety Methods
586 //////////
587 
588     /// @notice This method can be used by the controller to extract mistakenly
589     ///  sent tokens to this contract.
590     /// @param _token The address of the token contract that you want to recover
591     ///  set to 0 in case you want to extract ether.
592     function claimTokens(address _token) onlyController {
593         if (_token == 0x0) {
594             controller.transfer(this.balance);
595             return;
596         }
597 
598         MiniMeToken token = MiniMeToken(_token);
599         uint balance = token.balanceOf(this);
600         token.transfer(controller, balance);
601         ClaimedTokens(_token, controller, balance);
602     }
603 
604 ////////////////
605 // Events
606 ////////////////
607     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
608     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
609     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
610     event Approval(
611         address indexed _owner,
612         address indexed _spender,
613         uint256 _amount
614         );
615 
616 }
617 
618 
619 ////////////////
620 // MiniMeTokenFactory
621 ////////////////
622 
623 /// @dev This contract is used to generate clone contracts from a contract.
624 ///  In solidity this is the way to create a contract from a contract of the
625 ///  same class
626 contract MiniMeTokenFactory {
627 
628     /// @notice Update the DApp by creating a new token with new functionalities
629     ///  the msg.sender becomes the controller of this clone token
630     /// @param _parentToken Address of the token being cloned
631     /// @param _snapshotBlock Block of the parent token that will
632     ///  determine the initial distribution of the clone token
633     /// @param _tokenName Name of the new token
634     /// @param _decimalUnits Number of decimals of the new token
635     /// @param _tokenSymbol Token Symbol for the new token
636     /// @param _transfersEnabled If true, tokens will be able to be transferred
637     /// @return The address of the new token contract
638     function createCloneToken(
639         address _parentToken,
640         uint _snapshotBlock,
641         string _tokenName,
642         uint8 _decimalUnits,
643         string _tokenSymbol,
644         bool _transfersEnabled
645     ) returns (MiniMeToken) {
646         MiniMeToken newToken = new MiniMeToken(
647             this,
648             _parentToken,
649             _snapshotBlock,
650             _tokenName,
651             _decimalUnits,
652             _tokenSymbol,
653             _transfersEnabled
654             );
655 
656         newToken.changeController(msg.sender);
657         return newToken;
658     }
659 }
660 
661 /**
662  * Math operations with safety checks
663  */
664 library SafeMath {
665   function mul(uint a, uint b) internal returns (uint) {
666     uint c = a * b;
667     assert(a == 0 || c / a == b);
668     return c;
669   }
670 
671   function div(uint a, uint b) internal returns (uint) {
672     // assert(b > 0); // Solidity automatically throws when dividing by 0
673     uint c = a / b;
674     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
675     return c;
676   }
677 
678   function sub(uint a, uint b) internal returns (uint) {
679     assert(b <= a);
680     return a - b;
681   }
682 
683   function add(uint a, uint b) internal returns (uint) {
684     uint c = a + b;
685     assert(c >= a);
686     return c;
687   }
688 
689   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
690     return a >= b ? a : b;
691   }
692 
693   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
694     return a < b ? a : b;
695   }
696 
697   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
698     return a >= b ? a : b;
699   }
700 
701   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
702     return a < b ? a : b;
703   }
704 
705   function percent(uint a, uint b) internal returns (uint) {
706     uint c = a * b;
707     assert(a == 0 || c / a == b);
708     return c / 100;
709   }
710 }
711 
712 contract iTinyToken is MiniMeToken {
713     // @dev iTinyToken constructor just parametrizes the MiniMeToken constructor
714     function iTinyToken(address _tokenFactory)
715             MiniMeToken(
716                 _tokenFactory,
717                 0x0,                         // no parent token
718                 0,                           // no snapshot block number from parent
719                 "iTinyToken",                // Token name
720                 18,                          // Decimals
721                 "ITT",                       // Symbol
722                 true                         // Enable transfers
723             ) {}
724 }