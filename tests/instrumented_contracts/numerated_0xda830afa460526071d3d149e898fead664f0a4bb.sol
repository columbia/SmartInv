1 // Smart contract used for the EatMeCoin Crowdsale 
2 //
3 // @author: Pavel Metelitsyn, Geejay101
4 // April 2018
5 
6 library SafeMath {
7   function mul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47   function percent(uint a, uint b) internal returns (uint) {
48     uint c = a * b;
49     assert(a == 0 || c / a == b);
50     return c / 100;
51   }
52 }
53 
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/179
59  */
60 
61  /* from OpenZeppelin library */
62  /* https://github.com/OpenZeppelin/zeppelin-solidity */
63 
64 contract ERC20Basic {
65   uint256 public totalSupply;
66   function balanceOf(address who) constant returns (uint256);
67   function transfer(address to, uint256 value) returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 /*
72     Copyright 2016, Jordi Baylina
73 
74     This program is free software: you can redistribute it and/or modify
75     it under the terms of the GNU General Public License as published by
76     the Free Software Foundation, either version 3 of the License, or
77     (at your option) any later version.
78 
79     This program is distributed in the hope that it will be useful,
80     but WITHOUT ANY WARRANTY; without even the implied warranty of
81     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
82     GNU General Public License for more details.
83 
84     You should have received a copy of the GNU General Public License
85     along with this program.  If not, see <http://www.gnu.org/licenses/>.
86  */
87 
88 /// @title MiniMeToken Contract
89 /// @author Jordi Baylina
90 /// @dev This token contract's goal is to make it easy for anyone to clone this
91 ///  token using the token distribution at a given block, this will allow DAO's
92 ///  and DApps to upgrade their features in a decentralized manner without
93 ///  affecting the original token
94 /// @dev It is ERC20 compliant, but still needs to under go further testing.
95 
96 
97 /// @dev The token controller contract must implement these functions
98 contract TokenController {
99     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
100     /// @param _owner The address that sent the ether to create tokens
101     /// @return True if the ether is accepted, false if it throws
102     function proxyPayment(address _owner) public payable returns(bool);
103 
104     /// @notice Notifies the controller about a token transfer allowing the
105     ///  controller to react if desired
106     /// @param _from The origin of the transfer
107     /// @param _to The destination of the transfer
108     /// @param _amount The amount of the transfer
109     /// @return False if the controller does not authorize the transfer
110     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
111 
112     /// @notice Notifies the controller about an approval allowing the
113     ///  controller to react if desired
114     /// @param _owner The address that calls `approve()`
115     /// @param _spender The spender in the `approve()` call
116     /// @param _amount The amount in the `approve()` call
117     /// @return False if the controller does not authorize the approval
118     function onApprove(address _owner, address _spender, uint _amount) public
119         returns(bool);
120 }
121 
122 contract Controlled {
123     /// @notice The address of the controller is the only address that can call
124     ///  a function with this modifier
125     modifier onlyController { require(msg.sender == controller); _; }
126 
127     address public controller;
128 
129     function Controlled() public { controller = msg.sender;}
130 
131     /// @notice Changes the controller of the contract
132     /// @param _newController The new controller of the contract
133     function changeController(address _newController) public onlyController {
134         controller = _newController;
135     }
136 }
137 
138 contract ApproveAndCallFallBack {
139     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
140 }
141 
142 /// @dev The actual token contract, the default controller is the msg.sender
143 ///  that deploys the contract, so usually this token will be deployed by a
144 ///  token controller contract, which Giveth will call a "Campaign"
145 contract MiniMeToken is Controlled {
146 
147     string public name;                //The Token's name: e.g. DigixDAO Tokens
148     uint8 public decimals;             //Number of decimals of the smallest unit
149     string public symbol;              //An identifier: e.g. REP
150     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
151 
152 
153     /// @dev `Checkpoint` is the structure that attaches a block number to a
154     ///  given value, the block number attached is the one that last changed the
155     ///  value
156     struct  Checkpoint {
157 
158         // `fromBlock` is the block number that the value was generated from
159         uint128 fromBlock;
160 
161         // `value` is the amount of tokens at a specific block number
162         uint128 value;
163     }
164 
165     // `parentToken` is the Token address that was cloned to produce this token;
166     //  it will be 0x0 for a token that was not cloned
167     MiniMeToken public parentToken;
168 
169     // `parentSnapShotBlock` is the block number from the Parent Token that was
170     //  used to determine the initial distribution of the Clone Token
171     uint public parentSnapShotBlock;
172 
173     // `creationBlock` is the block number that the Clone Token was created
174     uint public creationBlock;
175 
176     // `balances` is the map that tracks the balance of each address, in this
177     //  contract when the balance changes the block number that the change
178     //  occurred is also included in the map
179     mapping (address => Checkpoint[]) balances;
180 
181     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
182     mapping (address => mapping (address => uint256)) allowed;
183 
184     // Tracks the history of the `totalSupply` of the token
185     Checkpoint[] totalSupplyHistory;
186 
187     // Flag that determines if the token is transferable or not.
188     bool public transfersEnabled;
189 
190     // The factory used to create new clone tokens
191     MiniMeTokenFactory public tokenFactory;
192 
193 ////////////////
194 // Constructor
195 ////////////////
196 
197     /// @notice Constructor to create a MiniMeToken
198     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
199     ///  will create the Clone token contracts, the token factory needs to be
200     ///  deployed first
201     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
202     ///  new token
203     /// @param _parentSnapShotBlock Block of the parent token that will
204     ///  determine the initial distribution of the clone token, set to 0 if it
205     ///  is a new token
206     /// @param _tokenName Name of the new token
207     /// @param _decimalUnits Number of decimals of the new token
208     /// @param _tokenSymbol Token Symbol for the new token
209     /// @param _transfersEnabled If true, tokens will be able to be transferred
210     function MiniMeToken(
211         address _tokenFactory,
212         address _parentToken,
213         uint _parentSnapShotBlock,
214         string _tokenName,
215         uint8 _decimalUnits,
216         string _tokenSymbol,
217         bool _transfersEnabled
218     ) public {
219         tokenFactory = MiniMeTokenFactory(_tokenFactory);
220         name = _tokenName;                                 // Set the name
221         decimals = _decimalUnits;                          // Set the decimals
222         symbol = _tokenSymbol;                             // Set the symbol
223         parentToken = MiniMeToken(_parentToken);
224         parentSnapShotBlock = _parentSnapShotBlock;
225         transfersEnabled = _transfersEnabled;
226         creationBlock = block.number;
227     }
228 
229 
230 ///////////////////
231 // ERC20 Methods
232 ///////////////////
233 
234     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
235     /// @param _to The address of the recipient
236     /// @param _amount The amount of tokens to be transferred
237     /// @return Whether the transfer was successful or not
238     function transfer(address _to, uint256 _amount) public returns (bool success) {
239         require(transfersEnabled);
240         doTransfer(msg.sender, _to, _amount);
241         return true;
242     }
243 
244     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
245     ///  is approved by `_from`
246     /// @param _from The address holding the tokens being transferred
247     /// @param _to The address of the recipient
248     /// @param _amount The amount of tokens to be transferred
249     /// @return True if the transfer was successful
250     function transferFrom(address _from, address _to, uint256 _amount
251     ) public returns (bool success) {
252 
253         // The controller of this contract can move tokens around at will,
254         //  this is important to recognize! Confirm that you trust the
255         //  controller of this contract, which in most situations should be
256         //  another open source smart contract or 0x0
257         if (msg.sender != controller) {
258             require(transfersEnabled);
259 
260             // The standard ERC 20 transferFrom functionality
261             require(allowed[_from][msg.sender] >= _amount);
262             allowed[_from][msg.sender] -= _amount;
263         }
264         doTransfer(_from, _to, _amount);
265         return true;
266     }
267 
268     /// @dev This is the actual transfer function in the token contract, it can
269     ///  only be called by other functions in this contract.
270     /// @param _from The address holding the tokens being transferred
271     /// @param _to The address of the recipient
272     /// @param _amount The amount of tokens to be transferred
273     /// @return True if the transfer was successful
274     function doTransfer(address _from, address _to, uint _amount
275     ) internal {
276 
277            if (_amount == 0) {
278                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
279                return;
280            }
281 
282            require(parentSnapShotBlock < block.number);
283 
284            // Do not allow transfer to 0x0 or the token contract itself
285            require((_to != 0) && (_to != address(this)));
286 
287            // If the amount being transfered is more than the balance of the
288            //  account the transfer throws
289            var previousBalanceFrom = balanceOfAt(_from, block.number);
290 
291            require(previousBalanceFrom >= _amount);
292 
293            // Alerts the token controller of the transfer
294            if (isContract(controller)) {
295                require(TokenController(controller).onTransfer(_from, _to, _amount));
296            }
297 
298            // First update the balance array with the new value for the address
299            //  sending the tokens
300            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
301 
302            // Then update the balance array with the new value for the address
303            //  receiving the tokens
304            var previousBalanceTo = balanceOfAt(_to, block.number);
305            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
306            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
307 
308            // An event to make the transfer easy to find on the blockchain
309            Transfer(_from, _to, _amount);
310 
311     }
312 
313     /// @param _owner The address that's balance is being requested
314     /// @return The balance of `_owner` at the current block
315     function balanceOf(address _owner) public constant returns (uint256 balance) {
316         return balanceOfAt(_owner, block.number);
317     }
318 
319     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
320     ///  its behalf. This is a modified version of the ERC20 approve function
321     ///  to be a little bit safer
322     /// @param _spender The address of the account able to transfer the tokens
323     /// @param _amount The amount of tokens to be approved for transfer
324     /// @return True if the approval was successful
325     function approve(address _spender, uint256 _amount) public returns (bool success) {
326         require(transfersEnabled);
327 
328         // To change the approve amount you first have to reduce the addresses`
329         //  allowance to zero by calling `approve(_spender,0)` if it is not
330         //  already 0 to mitigate the race condition described here:
331         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
332         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
333 
334         // Alerts the token controller of the approve function call
335         if (isContract(controller)) {
336             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
337         }
338 
339         allowed[msg.sender][_spender] = _amount;
340         Approval(msg.sender, _spender, _amount);
341         return true;
342     }
343 
344     /// @dev This function makes it easy to read the `allowed[]` map
345     /// @param _owner The address of the account that owns the token
346     /// @param _spender The address of the account able to transfer the tokens
347     /// @return Amount of remaining tokens of _owner that _spender is allowed
348     ///  to spend
349     function allowance(address _owner, address _spender
350     ) public constant returns (uint256 remaining) {
351         return allowed[_owner][_spender];
352     }
353 
354     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
355     ///  its behalf, and then a function is triggered in the contract that is
356     ///  being approved, `_spender`. This allows users to use their tokens to
357     ///  interact with contracts in one function call instead of two
358     /// @param _spender The address of the contract able to transfer the tokens
359     /// @param _amount The amount of tokens to be approved for transfer
360     /// @return True if the function call was successful
361     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
362     ) public returns (bool success) {
363         require(approve(_spender, _amount));
364 
365         ApproveAndCallFallBack(_spender).receiveApproval(
366             msg.sender,
367             _amount,
368             this,
369             _extraData
370         );
371 
372         return true;
373     }
374 
375     /// @dev This function makes it easy to get the total number of tokens
376     /// @return The total number of tokens
377     function totalSupply() public constant returns (uint) {
378         return totalSupplyAt(block.number);
379     }
380 
381 
382 ////////////////
383 // Query balance and totalSupply in History
384 ////////////////
385 
386     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
387     /// @param _owner The address from which the balance will be retrieved
388     /// @param _blockNumber The block number when the balance is queried
389     /// @return The balance at `_blockNumber`
390     function balanceOfAt(address _owner, uint _blockNumber) public constant
391         returns (uint) {
392 
393         // These next few lines are used when the balance of the token is
394         //  requested before a check point was ever created for this token, it
395         //  requires that the `parentToken.balanceOfAt` be queried at the
396         //  genesis block for that token as this contains initial balance of
397         //  this token
398         if ((balances[_owner].length == 0)
399             || (balances[_owner][0].fromBlock > _blockNumber)) {
400             if (address(parentToken) != 0) {
401                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
402             } else {
403                 // Has no parent
404                 return 0;
405             }
406 
407         // This will return the expected balance during normal situations
408         } else {
409             return getValueAt(balances[_owner], _blockNumber);
410         }
411     }
412 
413     /// @notice Total amount of tokens at a specific `_blockNumber`.
414     /// @param _blockNumber The block number when the totalSupply is queried
415     /// @return The total amount of tokens at `_blockNumber`
416     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
417 
418         // These next few lines are used when the totalSupply of the token is
419         //  requested before a check point was ever created for this token, it
420         //  requires that the `parentToken.totalSupplyAt` be queried at the
421         //  genesis block for this token as that contains totalSupply of this
422         //  token at this block number.
423         if ((totalSupplyHistory.length == 0)
424             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
425             if (address(parentToken) != 0) {
426                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
427             } else {
428                 return 0;
429             }
430 
431         // This will return the expected totalSupply during normal situations
432         } else {
433             return getValueAt(totalSupplyHistory, _blockNumber);
434         }
435     }
436 
437 ////////////////
438 // Clone Token Method
439 ////////////////
440 
441     /// @notice Creates a new clone token with the initial distribution being
442     ///  this token at `_snapshotBlock`
443     /// @param _cloneTokenName Name of the clone token
444     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
445     /// @param _cloneTokenSymbol Symbol of the clone token
446     /// @param _snapshotBlock Block when the distribution of the parent token is
447     ///  copied to set the initial distribution of the new clone token;
448     ///  if the block is zero than the actual block, the current block is used
449     /// @param _transfersEnabled True if transfers are allowed in the clone
450     /// @return The address of the new MiniMeToken Contract
451     function createCloneToken(
452         string _cloneTokenName,
453         uint8 _cloneDecimalUnits,
454         string _cloneTokenSymbol,
455         uint _snapshotBlock,
456         bool _transfersEnabled
457         ) public returns(address) {
458         if (_snapshotBlock == 0) _snapshotBlock = block.number;
459         MiniMeToken cloneToken = tokenFactory.createCloneToken(
460             this,
461             _snapshotBlock,
462             _cloneTokenName,
463             _cloneDecimalUnits,
464             _cloneTokenSymbol,
465             _transfersEnabled
466             );
467 
468         cloneToken.changeController(msg.sender);
469 
470         // An event to make the token easy to find on the blockchain
471         NewCloneToken(address(cloneToken), _snapshotBlock);
472         return address(cloneToken);
473     }
474 
475 ////////////////
476 // Generate and destroy tokens
477 ////////////////
478 
479     /// @notice Generates `_amount` tokens that are assigned to `_owner`
480     /// @param _owner The address that will be assigned the new tokens
481     /// @param _amount The quantity of tokens generated
482     /// @return True if the tokens are generated correctly
483     function generateTokens(address _owner, uint _amount
484     ) public onlyController returns (bool) {
485         uint curTotalSupply = totalSupply();
486         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
487         uint previousBalanceTo = balanceOf(_owner);
488         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
489         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
490         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
491         Transfer(0, _owner, _amount);
492         return true;
493     }
494 
495 
496     /// @notice Burns `_amount` tokens from `_owner`
497     /// @param _owner The address that will lose the tokens
498     /// @param _amount The quantity of tokens to burn
499     /// @return True if the tokens are burned correctly
500     function destroyTokens(address _owner, uint _amount
501     ) onlyController public returns (bool) {
502         uint curTotalSupply = totalSupply();
503         require(curTotalSupply >= _amount);
504         uint previousBalanceFrom = balanceOf(_owner);
505         require(previousBalanceFrom >= _amount);
506         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
507         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
508         Transfer(_owner, 0, _amount);
509         return true;
510     }
511 
512 ////////////////
513 // Enable tokens transfers
514 ////////////////
515 
516 
517     /// @notice Enables token holders to transfer their tokens freely if true
518     /// @param _transfersEnabled True if transfers are allowed in the clone
519     function enableTransfers(bool _transfersEnabled) public onlyController {
520         transfersEnabled = _transfersEnabled;
521     }
522 
523 ////////////////
524 // Internal helper functions to query and set a value in a snapshot array
525 ////////////////
526 
527     /// @dev `getValueAt` retrieves the number of tokens at a given block number
528     /// @param checkpoints The history of values being queried
529     /// @param _block The block number to retrieve the value at
530     /// @return The number of tokens being queried
531     function getValueAt(Checkpoint[] storage checkpoints, uint _block
532     ) constant internal returns (uint) {
533         if (checkpoints.length == 0) return 0;
534 
535         // Shortcut for the actual value
536         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
537             return checkpoints[checkpoints.length-1].value;
538         if (_block < checkpoints[0].fromBlock) return 0;
539 
540         // Binary search of the value in the array
541         uint min = 0;
542         uint max = checkpoints.length-1;
543         while (max > min) {
544             uint mid = (max + min + 1)/ 2;
545             if (checkpoints[mid].fromBlock<=_block) {
546                 min = mid;
547             } else {
548                 max = mid-1;
549             }
550         }
551         return checkpoints[min].value;
552     }
553 
554     /// @dev `updateValueAtNow` used to update the `balances` map and the
555     ///  `totalSupplyHistory`
556     /// @param checkpoints The history of data being updated
557     /// @param _value The new number of tokens
558     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
559     ) internal  {
560         if ((checkpoints.length == 0)
561         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
562                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
563                newCheckPoint.fromBlock =  uint128(block.number);
564                newCheckPoint.value = uint128(_value);
565            } else {
566                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
567                oldCheckPoint.value = uint128(_value);
568            }
569     }
570 
571     /// @dev Internal function to determine if an address is a contract
572     /// @param _addr The address being queried
573     /// @return True if `_addr` is a contract
574     function isContract(address _addr) constant internal returns(bool) {
575         uint size;
576         if (_addr == 0) return false;
577         assembly {
578             size := extcodesize(_addr)
579         }
580         return size>0;
581     }
582 
583     /// @dev Helper function to return a min betwen the two uints
584     function min(uint a, uint b) pure internal returns (uint) {
585         return a < b ? a : b;
586     }
587 
588     /// @notice The fallback function: If the contract's controller has not been
589     ///  set to 0, then the `proxyPayment` method is called which relays the
590     ///  ether and creates tokens as described in the token controller contract
591     function () public payable {
592         require(isContract(controller));
593         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
594     }
595 
596 //////////
597 // Safety Methods
598 //////////
599 
600     /// @notice This method can be used by the controller to extract mistakenly
601     ///  sent tokens to this contract.
602     /// @param _token The address of the token contract that you want to recover
603     ///  set to 0 in case you want to extract ether.
604     function claimTokens(address _token) public onlyController {
605         if (_token == 0x0) {
606             controller.transfer(this.balance);
607             return;
608         }
609 
610         MiniMeToken token = MiniMeToken(_token);
611         uint balance = token.balanceOf(this);
612         token.transfer(controller, balance);
613         ClaimedTokens(_token, controller, balance);
614     }
615 
616 ////////////////
617 // Events
618 ////////////////
619     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
620     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
621     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
622     event Approval(
623         address indexed _owner,
624         address indexed _spender,
625         uint256 _amount
626         );
627 
628 }
629 
630 
631 ////////////////
632 // MiniMeTokenFactory
633 ////////////////
634 
635 /// @dev This contract is used to generate clone contracts from a contract.
636 ///  In solidity this is the way to create a contract from a contract of the
637 ///  same class
638 contract MiniMeTokenFactory {
639 
640     /// @notice Update the DApp by creating a new token with new functionalities
641     ///  the msg.sender becomes the controller of this clone token
642     /// @param _parentToken Address of the token being cloned
643     /// @param _snapshotBlock Block of the parent token that will
644     ///  determine the initial distribution of the clone token
645     /// @param _tokenName Name of the new token
646     /// @param _decimalUnits Number of decimals of the new token
647     /// @param _tokenSymbol Token Symbol for the new token
648     /// @param _transfersEnabled If true, tokens will be able to be transferred
649     /// @return The address of the new token contract
650     function createCloneToken(
651         address _parentToken,
652         uint _snapshotBlock,
653         string _tokenName,
654         uint8 _decimalUnits,
655         string _tokenSymbol,
656         bool _transfersEnabled
657     ) public returns (MiniMeToken) {
658         MiniMeToken newToken = new MiniMeToken(
659             this,
660             _parentToken,
661             _snapshotBlock,
662             _tokenName,
663             _decimalUnits,
664             _tokenSymbol,
665             _transfersEnabled
666             );
667 
668         newToken.changeController(msg.sender);
669         return newToken;
670     }
671 }
672 
673 
674 
675 contract EatMeCoin is MiniMeToken { 
676 
677   // we use this variable to store the number of the finalization block
678   uint256 public checkpointBlock;
679 
680   // address which is allowed to trigger tokens generation
681   address public mayGenerateAddr;
682 
683   // flag
684   bool tokenGenerationEnabled = true; //<- added after first audit
685 
686 
687   modifier mayGenerate() {
688     require ( (msg.sender == mayGenerateAddr) &&
689               (tokenGenerationEnabled == true) ); //<- added after first audit
690     _;
691   }
692 
693   // Constructor
694   function EatMeCoin(address _tokenFactory) 
695     MiniMeToken(
696       _tokenFactory,
697       0x0,
698       0,
699       "EatMeCoin",
700       18, // decimals
701       "EAT",
702       // SHOULD TRANSFERS BE ENABLED? -- NO
703       false){
704     
705     controller = msg.sender;
706     mayGenerateAddr = controller;
707   }
708 
709   function setGenerateAddr(address _addr) onlyController{
710     // we can appoint an address to be allowed to generate tokens
711     require( _addr != 0x0 );
712     mayGenerateAddr = _addr;
713   }
714 
715 
716   /// @notice this is default function called when ETH is send to this contract
717   ///   we use the campaign contract for selling tokens
718   function () payable {
719     revert();
720   }
721 
722   
723   /// @notice This function is copy-paste of the generateTokens of the original MiniMi contract
724   ///   except it uses mayGenerate modifier (original uses onlyController)
725   function generate_token_for(address _addrTo, uint256 _amount) mayGenerate returns (bool) {
726     
727     //balances[_addr] += _amount;
728    
729     uint256 curTotalSupply = totalSupply();
730     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow    
731     uint256 previousBalanceTo = balanceOf(_addrTo);
732     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
733     updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
734     updateValueAtNow(balances[_addrTo], previousBalanceTo + _amount);
735     Transfer(0, _addrTo, _amount);
736     return true;
737   }
738 
739   // overwrites the original function
740   function generateTokens(address _owner, uint256 _amount
741     ) onlyController returns (bool) {
742     revert();
743     generate_token_for(_owner, _amount);    
744   }
745 
746 
747   // permanently disables generation of new tokens
748   function finalize() mayGenerate {
749     tokenGenerationEnabled = false;
750     transfersEnabled = true;
751     checkpointBlock = block.number;
752   }  
753 }
754 
755 
756 contract eat_token_interface{
757   uint8 public decimals;
758   function generate_token_for(address _addr,uint256 _amount) returns (bool);
759   function finalize();
760 }
761 
762 // Controlled is implemented in MiniMeToken.sol
763 contract TokenCampaign is Controlled {
764   using SafeMath for uint256;
765 
766   // this is our token
767   eat_token_interface public token;
768 
769   uint8 public constant decimals = 18;
770 
771   uint256 public constant scale = (uint256(10) ** decimals);
772 
773   uint256 public constant hardcap = 100000000 * scale;
774 
775   ///////////////////////////////////
776   //
777   // constants related to token sale
778 
779   // after sale ends, additional tokens will be generated
780   // according to the following rules,
781   // where 100% correspond to the number of sold tokens
782 
783   // percent of reward tokens to be generated
784   uint256 public constant PRCT100_D_TEAM = 63; // % * 100 , 0.63%
785   uint256 public constant PRCT100_R_TEAM = 250; // % * 100 , 2.5%
786   uint256 public constant PRCT100_R2 = 150;  // % * 100 , 1.5%
787 
788   // fixed reward
789   uint256 public constant FIXEDREWARD_MM = 100000 * scale; // fixed
790 
791   // we keep some of the ETH in the contract until the sale is finalized
792   // percent of ETH going to operational and reserve account
793   uint256 public constant PRCT100_ETH_OP = 4000; // % * 100 , 2x 40%
794 
795   // preCrowd structure, Wei
796   uint256 public constant preCrowdMinContribution = (20 ether);
797 
798   // minmal contribution, Wei
799   uint256 public constant minContribution = (1 ether) / 100;
800 
801   // how many tokens for one ETH
802   uint256 public constant preCrowd_tokens_scaled = 7142857142857140000000; // 30% discount
803   uint256 public constant stage_1_tokens_scaled =  6250000000000000000000; // 20% discount
804   uint256 public constant stage_2_tokens_scaled =  5555555555555560000000; // 10% discount
805   uint256 public constant stage_3_tokens_scaled =  5000000000000000000000; //<-- scaled
806 
807   // Tokens allocated for each stage
808   uint256 public constant PreCrowdAllocation =  20000000 * scale ; // Tokens
809   uint256 public constant Stage1Allocation =    15000000 * scale ; // Tokens
810   uint256 public constant Stage2Allocation =    15000000 * scale ; // Tokens
811   uint256 public constant Stage3Allocation =    20000000 * scale ; // Tokens
812 
813   // keeps track of tokens allocated, scaled value
814   uint256 public tokensRemainingPreCrowd = PreCrowdAllocation;
815   uint256 public tokensRemainingStage1 = Stage1Allocation;
816   uint256 public tokensRemainingStage2 = Stage2Allocation;
817   uint256 public tokensRemainingStage3 = Stage3Allocation;
818 
819   // If necessary we can cap the maximum amount 
820   // of individual contributions in case contributions have exceeded the hardcap
821   // this avoids to cap the contributions already when funds flow in
822   uint256 public maxPreCrowdAllocationPerInvestor =  20000000 * scale ; // Tokens
823   uint256 public maxStage1AllocationPerInvestor =    15000000 * scale ; // Tokens
824   uint256 public maxStage2AllocationPerInvestor =    15000000 * scale ; // Tokens
825   uint256 public maxStage3AllocationPerInvestor =    20000000 * scale ; // Tokens
826 
827   // keeps track of tokens generated so far, scaled value
828   uint256 public tokensGenerated = 0;
829 
830   address[] public joinedCrowdsale;
831 
832   // total Ether raised (= Ether paid into the contract)
833   uint256 public amountRaised = 0; 
834 
835   // How much wei we have given back to investors.
836   uint256 public amountRefunded = 0;
837 
838 
839   ////////////////////////////////////////////////////////
840   //
841   // folowing addresses need to be set in the constructor
842   // we also have setter functions which allow to change
843   // an address if it is compromised or something happens
844 
845   // destination for D-team's share
846   address public dteamVaultAddr1;
847   address public dteamVaultAddr2;
848   address public dteamVaultAddr3;
849   address public dteamVaultAddr4;
850 
851   // destination for R-team's share
852   address public rteamVaultAddr;
853 
854   // advisor address
855   address public r2VaultAddr;
856 
857   // adivisor address
858   address public mmVaultAddr;
859   
860   // destination for reserve tokens
861   address public reserveVaultAddr;
862 
863   // destination for collected Ether
864   address public trusteeVaultAddr;
865   
866   // destination for operational costs account
867   address public opVaultAddr;
868 
869   // adress of our token
870   address public tokenAddr;
871   
872   // @check ensure that state transitions are 
873   // only in one direction
874   // 3 - passive, not accepting funds
875   // 2 - active main sale, accepting funds
876   // 1 - closed, not accepting funds 
877   // 0 - finalized, not accepting funds
878   uint8 public campaignState = 3; 
879   bool public paused = false;
880 
881   // time in seconds since epoch 
882   // set to midnight of saturday January 1st, 4000
883   uint256 public tCampaignStart = 64060588800;
884 
885   uint256 public t_1st_StageEnd = 5 * (1 days); // Stage1 3 days open
886   // for testing
887   // uint256 public t_1st_StageEnd = 3 * (1 hours); // Stage1 3 days open
888 
889   uint256 public t_2nd_StageEnd = 2 * (1 days); // Stage2 2 days open
890   // for testing
891   // uint256 public t_2nd_StageEnd = 2 * (1 hours); // Stage2 2 days open
892 
893   uint256 public tCampaignEnd = 35 * (1 days); // Stage3 35 days open
894   // for testing
895   // uint256 public tCampaignEnd = 35 * (1 hours); // Stage3 35 days open
896 
897   uint256 public tFinalized = 64060588800;
898 
899   // participant data
900   struct ParticipantListData {
901 
902     bool participatedFlag;
903 
904     uint256 contributedAmountPreAllocated;
905     uint256 contributedAmountPreCrowd;
906     uint256 contributedAmountStage1;
907     uint256 contributedAmountStage2;
908     uint256 contributedAmountStage3;
909 
910     uint256 preallocatedTokens;
911     uint256 allocatedTokens;
912 
913     uint256 spentAmount;
914   }
915 
916   /** participant addresses */
917   mapping (address => ParticipantListData) public participantList;
918 
919   uint256 public investorsProcessed = 0;
920   uint256 public investorsBatchSize = 100;
921 
922   bool public isWhiteListed = true;
923 
924   struct WhiteListData {
925     bool status;
926     uint256 maxCap;
927   }
928 
929   /** Whitelisted addresses */
930   mapping (address => WhiteListData) public participantWhitelist;
931 
932 
933   //////////////////////////////////////////////
934   //
935   // Events
936  
937   event CampaignOpen(uint256 timenow);
938   event CampaignClosed(uint256 timenow);
939   event CampaignPaused(uint256 timenow);
940   event CampaignResumed(uint256 timenow);
941 
942   event PreAllocated(address indexed backer, uint256 raised);
943   event RaisedPreCrowd(address indexed backer, uint256 raised);
944   event RaisedStage1(address indexed backer, uint256 raised);
945   event RaisedStage2(address indexed backer, uint256 raised);
946   event RaisedStage3(address indexed backer, uint256 raised);
947   event Airdropped(address indexed backer, uint256 tokensairdropped);
948 
949   event Finalized(uint256 timenow);
950 
951   event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
952 
953   // Address early participation whitelist status changed
954   event Whitelisted(address addr, bool status);
955 
956   // Refund was processed for a contributor
957   event Refund(address investor, uint256 weiAmount);
958 
959   /// @notice Constructor
960   /// @param _tokenAddress Our token's address
961   /// @param  _trusteeAddress Trustee address
962   /// @param  _opAddress Operational expenses address 
963   /// @param  _reserveAddress Project Token Reserve
964   function TokenCampaign(
965     address _tokenAddress,
966     address _dteamAddress1,
967     address _dteamAddress2,
968     address _dteamAddress3,
969     address _dteamAddress4,
970     address _rteamAddress,
971     address _r2Address,
972     address _mmAddress,
973     address _trusteeAddress,
974     address _opAddress,
975     address _reserveAddress)
976   {
977 
978     controller = msg.sender;
979     
980     /// set addresses     
981     tokenAddr = _tokenAddress;
982     dteamVaultAddr1 = _dteamAddress1;
983     dteamVaultAddr2 = _dteamAddress2;
984     dteamVaultAddr3 = _dteamAddress3;
985     dteamVaultAddr4 = _dteamAddress4;
986     rteamVaultAddr = _rteamAddress;
987     r2VaultAddr = _r2Address;
988     mmVaultAddr = _mmAddress;
989     trusteeVaultAddr = _trusteeAddress; 
990     opVaultAddr = _opAddress;
991     reserveVaultAddr = _reserveAddress;
992 
993     /// reference our token
994     token = eat_token_interface(tokenAddr);
995    
996   }
997 
998 
999   /////////////////////////////////////////////
1000   ///
1001   /// Functions that change contract state
1002 
1003   ///
1004   /// Setters
1005   ///
1006 
1007   /// @notice  Puts campaign into active state  
1008   ///  only controller can do that
1009   ///  only possible if team token Vault is set up
1010   ///  WARNING: usual caveats apply to the Ethereum's interpretation of time
1011   function startSale() public onlyController {
1012     require( campaignState > 2 );
1013 
1014     campaignState = 2;
1015 
1016     uint256 tNow = now;
1017     // assume timestamps will not cause overflow
1018     tCampaignStart = tNow;
1019     t_1st_StageEnd += tNow;
1020     t_2nd_StageEnd += tNow;
1021     tCampaignEnd += tNow;
1022 
1023     CampaignOpen(now);
1024   }
1025 
1026 
1027   /// @notice Pause sale
1028   ///   just in case we have some troubles 
1029   ///   Note that time marks are not updated
1030   function pauseSale() public onlyController {
1031     require( campaignState  == 2 );
1032     paused = true;
1033     CampaignPaused(now);
1034   }
1035 
1036 
1037   /// @notice Resume sale
1038   function resumeSale() public onlyController {
1039     require( campaignState  == 2 );
1040     paused = false;
1041     CampaignResumed(now);
1042   }
1043 
1044 
1045 
1046   /// @notice Puts the camapign into closed state
1047   ///   only controller can do so
1048   ///   only possible from the active state
1049   ///   we can call this function if we want to stop sale before end time 
1050   ///   and be able to perform 'finalizeCampaign()' immediately
1051   function closeSale() public onlyController {
1052     require( campaignState  == 2 );
1053     campaignState = 1;
1054 
1055     CampaignClosed(now);
1056   }   
1057 
1058 
1059   function setParticipantWhitelist(address addr, bool status, uint256 maxCap) public onlyController {
1060     participantWhitelist[addr] = WhiteListData({status:status, maxCap:maxCap});
1061     Whitelisted(addr, status);
1062   }
1063 
1064   function setMultipleParticipantWhitelist(address[] addrs, bool[] statuses, uint[] maxCaps) public onlyController {
1065     for (uint256 iterator = 0; iterator < addrs.length; iterator++) {
1066       setParticipantWhitelist(addrs[iterator], statuses[iterator], maxCaps[iterator]);
1067     }
1068   }
1069 
1070   function investorCount() public constant returns (uint256) {
1071     return joinedCrowdsale.length;
1072   }
1073 
1074   function contractBalance() public constant returns (uint256) {
1075     return this.balance;
1076   }
1077 
1078   /**
1079    * Investors can claim refund after finalisation.
1080    *
1081    * Note that any refunds from proxy buyers should be handled separately,
1082    * and not through this contract.
1083    */
1084   function refund() public {
1085     require (campaignState == 0);
1086 
1087     uint256 weiValue = participantList[msg.sender].contributedAmountPreCrowd;
1088     weiValue = weiValue.add(participantList[msg.sender].contributedAmountStage1);
1089     weiValue = weiValue.add(participantList[msg.sender].contributedAmountStage2);
1090     weiValue = weiValue.add(participantList[msg.sender].contributedAmountStage3);
1091     weiValue = weiValue.sub(participantList[msg.sender].spentAmount);
1092 
1093     if (weiValue <= 0) revert();
1094 
1095     participantList[msg.sender].contributedAmountPreCrowd = 0;
1096     participantList[msg.sender].contributedAmountStage1 = 0;
1097     participantList[msg.sender].contributedAmountStage2 = 0;
1098     participantList[msg.sender].contributedAmountStage3 = 0;
1099 
1100     amountRefunded = amountRefunded.add(weiValue);
1101 
1102     // send it
1103     if (!msg.sender.send(weiValue)) revert();
1104 
1105     // announce to world
1106     Refund(msg.sender, weiValue);
1107 
1108   }
1109 
1110   /// @notice Finalizes the campaign
1111   ///   Get funds out, generates team, reserve and reserve tokens
1112   function allocateInvestors() public onlyController {     
1113       
1114     /// only if sale was closed or 48 hours = 2880 minutes have passed since campaign end
1115     /// we leave this time to complete possibly pending orders from offchain contributions 
1116 
1117     require ( (campaignState == 1) || ((campaignState != 0) && (now > tCampaignEnd + (2880 minutes))));
1118 
1119     uint256 nTokens = 0;
1120     uint256 rate = 0;
1121     uint256 contributedAmount = 0; 
1122 
1123     uint256 investorsProcessedEnd = investorsProcessed + investorsBatchSize;
1124 
1125     if (investorsProcessedEnd > joinedCrowdsale.length) {
1126       investorsProcessedEnd = joinedCrowdsale.length;
1127     }
1128 
1129     for (uint256 i = investorsProcessed; i < investorsProcessedEnd; i++) {
1130 
1131         investorsProcessed++;
1132 
1133         address investorAddress = joinedCrowdsale[i];
1134 
1135         // PreCrowd stage
1136         contributedAmount = participantList[investorAddress].contributedAmountPreCrowd;
1137 
1138         if (isWhiteListed) {
1139 
1140             // is contributeAmount within whitelisted amount
1141             if (contributedAmount > participantWhitelist[investorAddress].maxCap) {
1142                 contributedAmount = participantWhitelist[investorAddress].maxCap;
1143             }
1144 
1145             // calculate remaining whitelisted amount
1146             if (contributedAmount>0) {
1147                 participantWhitelist[investorAddress].maxCap = participantWhitelist[investorAddress].maxCap.sub(contributedAmount);
1148             }
1149 
1150         }
1151 
1152         if (contributedAmount>0) {
1153 
1154             // calculate the number of tokens
1155             rate = preCrowd_tokens_scaled;
1156             nTokens = (rate.mul(contributedAmount)).div(1 ether);
1157 
1158             // check whether individual allocations are capped
1159             if (nTokens > maxPreCrowdAllocationPerInvestor) {
1160               nTokens = maxPreCrowdAllocationPerInvestor;
1161             }
1162 
1163             // If tokens are bigger than whats left in the stage, give the rest 
1164             if (tokensRemainingPreCrowd.sub(nTokens) < 0) {
1165                 nTokens = tokensRemainingPreCrowd;
1166             }
1167 
1168             // update spent amount
1169             participantList[joinedCrowdsale[i]].spentAmount = participantList[joinedCrowdsale[i]].spentAmount.add(nTokens.div(rate).mul(1 ether));
1170 
1171             // calculate leftover tokens for the stage 
1172             tokensRemainingPreCrowd = tokensRemainingPreCrowd.sub(nTokens);
1173 
1174             // update the new token holding
1175             participantList[investorAddress].allocatedTokens = participantList[investorAddress].allocatedTokens.add(nTokens);
1176 
1177         }
1178 
1179         //  stage1
1180         contributedAmount = participantList[investorAddress].contributedAmountStage1;
1181 
1182         if (isWhiteListed) {
1183 
1184             // is contributeAmount within whitelisted amount
1185             if (contributedAmount > participantWhitelist[investorAddress].maxCap) {
1186                 contributedAmount = participantWhitelist[investorAddress].maxCap;
1187             }
1188 
1189             // calculate remaining whitelisted amount
1190             if (contributedAmount>0) {
1191                 participantWhitelist[investorAddress].maxCap = participantWhitelist[investorAddress].maxCap.sub(contributedAmount);
1192             }
1193 
1194         }
1195 
1196         if (contributedAmount>0) {
1197 
1198             // calculate the number of tokens
1199             rate = stage_1_tokens_scaled;
1200             nTokens = (rate.mul(contributedAmount)).div(1 ether);
1201 
1202             // check whether individual allocations are capped
1203             if (nTokens > maxStage1AllocationPerInvestor) {
1204               nTokens = maxStage1AllocationPerInvestor;
1205             }
1206 
1207             // If tokens are bigger than whats left in the stage, give the rest 
1208             if (tokensRemainingStage1.sub(nTokens) < 0) {
1209                 nTokens = tokensRemainingStage1;
1210             }
1211 
1212             // update spent amount
1213             participantList[joinedCrowdsale[i]].spentAmount = participantList[joinedCrowdsale[i]].spentAmount.add(nTokens.div(rate).mul(1 ether));
1214 
1215             // calculate leftover tokens for the stage 
1216             tokensRemainingStage1 = tokensRemainingStage1.sub(nTokens);
1217 
1218             // update the new token holding
1219             participantList[investorAddress].allocatedTokens = participantList[investorAddress].allocatedTokens.add(nTokens);
1220 
1221         }
1222 
1223         //  stage2
1224         contributedAmount = participantList[investorAddress].contributedAmountStage2;
1225 
1226         if (isWhiteListed) {
1227 
1228             // is contributeAmount within whitelisted amount
1229             if (contributedAmount > participantWhitelist[investorAddress].maxCap) {
1230                 contributedAmount = participantWhitelist[investorAddress].maxCap;
1231             }
1232 
1233             // calculate remaining whitelisted amount
1234             if (contributedAmount>0) {
1235                 participantWhitelist[investorAddress].maxCap = participantWhitelist[investorAddress].maxCap.sub(contributedAmount);
1236             }
1237 
1238         }
1239 
1240         if (contributedAmount>0) {
1241 
1242             // calculate the number of tokens
1243             rate = stage_2_tokens_scaled;
1244             nTokens = (rate.mul(contributedAmount)).div(1 ether);
1245 
1246             // check whether individual allocations are capped
1247             if (nTokens > maxStage2AllocationPerInvestor) {
1248               nTokens = maxStage2AllocationPerInvestor;
1249             }
1250 
1251             // If tokens are bigger than whats left in the stage, give the rest 
1252             if (tokensRemainingStage2.sub(nTokens) < 0) {
1253                 nTokens = tokensRemainingStage2;
1254             }
1255 
1256             // update spent amount
1257             participantList[joinedCrowdsale[i]].spentAmount = participantList[joinedCrowdsale[i]].spentAmount.add(nTokens.div(rate).mul(1 ether));
1258 
1259             // calculate leftover tokens for the stage 
1260             tokensRemainingStage2 = tokensRemainingStage2.sub(nTokens);
1261 
1262             // update the new token holding
1263             participantList[investorAddress].allocatedTokens = participantList[investorAddress].allocatedTokens.add(nTokens);
1264 
1265         }
1266 
1267         //  stage3
1268         contributedAmount = participantList[investorAddress].contributedAmountStage3;
1269 
1270         if (isWhiteListed) {
1271 
1272             // is contributeAmount within whitelisted amount
1273             if (contributedAmount > participantWhitelist[investorAddress].maxCap) {
1274                 contributedAmount = participantWhitelist[investorAddress].maxCap;
1275             }
1276 
1277             // calculate remaining whitelisted amount
1278             if (contributedAmount>0) {
1279                 participantWhitelist[investorAddress].maxCap = participantWhitelist[investorAddress].maxCap.sub(contributedAmount);
1280             }
1281 
1282         }
1283 
1284         if (contributedAmount>0) {
1285 
1286             // calculate the number of tokens
1287             rate = stage_3_tokens_scaled;
1288             nTokens = (rate.mul(contributedAmount)).div(1 ether);
1289 
1290             // check whether individual allocations are capped
1291             if (nTokens > maxStage3AllocationPerInvestor) {
1292               nTokens = maxStage3AllocationPerInvestor;
1293             }
1294 
1295             // If tokens are bigger than whats left in the stage, give the rest 
1296             if (tokensRemainingStage3.sub(nTokens) < 0) {
1297                 nTokens = tokensRemainingStage3;
1298             }
1299 
1300             // update spent amount
1301             participantList[joinedCrowdsale[i]].spentAmount = participantList[joinedCrowdsale[i]].spentAmount.add(nTokens.div(rate).mul(1 ether));
1302 
1303             // calculate leftover tokens for the stage 
1304             tokensRemainingStage3 = tokensRemainingStage3.sub(nTokens);
1305 
1306             // update the new token holding
1307             participantList[investorAddress].allocatedTokens = participantList[investorAddress].allocatedTokens.add(nTokens);
1308 
1309         }
1310 
1311         do_grant_tokens(investorAddress, participantList[investorAddress].allocatedTokens);
1312 
1313     }
1314 
1315   }
1316 
1317   /// @notice Finalizes the campaign
1318   ///   Get funds out, generates team, reserve and reserve tokens
1319   function finalizeCampaign() public onlyController {     
1320       
1321     /// only if sale was closed or 48 hours = 2880 minutes have passed since campaign end
1322     /// we leave this time to complete possibly pending orders from offchain contributions 
1323 
1324     require ( (campaignState == 1) || ((campaignState != 0) && (now > tCampaignEnd + (2880 minutes))));
1325 
1326     campaignState = 0;
1327 
1328     // dteam tokens
1329     uint256 drewardTokens = (tokensGenerated.mul(PRCT100_D_TEAM)).div(10000);
1330 
1331     // rteam tokens
1332     uint256 rrewardTokens = (tokensGenerated.mul(PRCT100_R_TEAM)).div(10000);
1333 
1334     // r2 tokens
1335     uint256 r2rewardTokens = (tokensGenerated.mul(PRCT100_R2)).div(10000);
1336 
1337     // mm tokens
1338     uint256 mmrewardTokens = FIXEDREWARD_MM;
1339 
1340     do_grant_tokens(dteamVaultAddr1, drewardTokens);
1341     do_grant_tokens(dteamVaultAddr2, drewardTokens);
1342     do_grant_tokens(dteamVaultAddr3, drewardTokens);
1343     do_grant_tokens(dteamVaultAddr4, drewardTokens);     
1344     do_grant_tokens(rteamVaultAddr, rrewardTokens);
1345     do_grant_tokens(r2VaultAddr, r2rewardTokens);
1346     do_grant_tokens(mmVaultAddr, mmrewardTokens);
1347 
1348     // generate reserve tokens 
1349     // uint256 reserveTokens = rest of tokens under hardcap
1350     uint256 reserveTokens = hardcap.sub(tokensGenerated);
1351     do_grant_tokens(reserveVaultAddr, reserveTokens);
1352 
1353     // prevent further token generation
1354     token.finalize();
1355 
1356     tFinalized = now;
1357     
1358     // notify the world
1359     Finalized(tFinalized);
1360   }
1361 
1362 
1363   ///   Get funds out
1364   function retrieveFunds() public onlyController {     
1365 
1366       require (campaignState == 0);
1367       
1368       // forward funds to the trustee 
1369       // since we forward a fraction of the incomming ether on every contribution
1370       // 'amountRaised' IS NOT equal to the contract's balance
1371       // we use 'this.balance' instead
1372 
1373       // we do this manually to give people the chance to claim refunds in case of overpayments
1374 
1375       trusteeVaultAddr.transfer(this.balance);
1376 
1377   }
1378 
1379      ///   Get funds out
1380   function emergencyFinalize() public onlyController {     
1381 
1382     campaignState = 0;
1383 
1384     // prevent further token generation
1385     token.finalize();
1386 
1387   }
1388 
1389 
1390   /// @notice triggers token generaton for the recipient
1391   ///  can be called only from the token sale contract itself
1392   ///  side effect: increases the generated tokens counter 
1393   ///  CAUTION: we do not check campaign state and parameters assuming that's callee's task
1394   function do_grant_tokens(address _to, uint256 _nTokens) internal returns (bool){
1395     
1396     require( token.generate_token_for(_to, _nTokens) );
1397     
1398     tokensGenerated = tokensGenerated.add(_nTokens);
1399     
1400     return true;
1401   }
1402 
1403 
1404   ///  @notice processes the contribution
1405   ///   checks campaign state, time window and minimal contribution
1406   ///   throws if one of the conditions fails
1407   function process_contribution(address _toAddr) internal {
1408 
1409     require ((campaignState == 2)   // active main sale
1410          && (now <= tCampaignEnd)   // within time window
1411          && (paused == false));     // not on hold
1412     
1413     // we check that Eth sent is sufficient 
1414     // though our token has decimals we don't want nanocontributions
1415     require ( msg.value >= minContribution );
1416 
1417     amountRaised = amountRaised.add(msg.value);
1418 
1419     // check whether we know this investor, if not add him to list
1420     if (!participantList[_toAddr].participatedFlag) {
1421 
1422        // A new investor
1423        participantList[_toAddr].participatedFlag = true;
1424        joinedCrowdsale.push(_toAddr);
1425     }
1426 
1427     if ( msg.value >= preCrowdMinContribution ) {
1428 
1429       participantList[_toAddr].contributedAmountPreCrowd = participantList[_toAddr].contributedAmountPreCrowd.add(msg.value);
1430       
1431       // notify the world
1432       RaisedPreCrowd(_toAddr, msg.value);
1433 
1434     } else {
1435 
1436       if (now <= t_1st_StageEnd) {
1437 
1438         participantList[_toAddr].contributedAmountStage1 = participantList[_toAddr].contributedAmountStage1.add(msg.value);
1439 
1440         // notify the world
1441         RaisedStage1(_toAddr, msg.value);
1442 
1443       } else if (now <= t_2nd_StageEnd) {
1444 
1445         participantList[_toAddr].contributedAmountStage2 = participantList[_toAddr].contributedAmountStage2.add(msg.value);
1446 
1447         // notify the world
1448         RaisedStage2(_toAddr, msg.value);
1449 
1450       } else {
1451 
1452         participantList[_toAddr].contributedAmountStage3 = participantList[_toAddr].contributedAmountStage3.add(msg.value);
1453         
1454         // notify the world
1455         RaisedStage3(_toAddr, msg.value);
1456 
1457       }
1458 
1459     }
1460 
1461     // compute the fraction of ETH going to op account
1462     uint256 opEth = (PRCT100_ETH_OP.mul(msg.value)).div(10000);
1463 
1464     // transfer to op account 
1465     opVaultAddr.transfer(opEth);
1466 
1467     // transfer to reserve account 
1468     reserveVaultAddr.transfer(opEth);
1469 
1470   }
1471 
1472   /**
1473   * Preallocated tokens have been sold or given in airdrop before the actual crowdsale opens. 
1474   * This function mints the tokens and moves the crowdsale needle.
1475   *
1476   */
1477   function preallocate(address _toAddr, uint fullTokens, uint weiPaid) public onlyController {
1478 
1479     require (campaignState != 0);
1480 
1481     uint tokenAmount = fullTokens * scale;
1482     uint weiAmount = weiPaid ; // This can be also 0, we give out tokens for free
1483 
1484     if (!participantList[_toAddr].participatedFlag) {
1485 
1486        // A new investor
1487        participantList[_toAddr].participatedFlag = true;
1488        joinedCrowdsale.push(_toAddr);
1489 
1490     }
1491 
1492     participantList[_toAddr].contributedAmountPreAllocated = participantList[_toAddr].contributedAmountPreAllocated.add(weiAmount);
1493     participantList[_toAddr].preallocatedTokens = participantList[_toAddr].preallocatedTokens.add(tokenAmount);
1494 
1495     amountRaised = amountRaised.add(weiAmount);
1496 
1497     // side effect: do_grant_tokens updates the "tokensGenerated" variable
1498     require( do_grant_tokens(_toAddr, tokenAmount) );
1499 
1500     // notify the world
1501     PreAllocated(_toAddr, weiAmount);
1502 
1503   }
1504 
1505   function airdrop(address _toAddr, uint fullTokens) public onlyController {
1506 
1507     require (campaignState != 0);
1508 
1509     uint tokenAmount = fullTokens * scale;
1510 
1511     if (!participantList[_toAddr].participatedFlag) {
1512 
1513        // A new investor
1514        participantList[_toAddr].participatedFlag = true;
1515        joinedCrowdsale.push(_toAddr);
1516 
1517     }
1518 
1519     participantList[_toAddr].preallocatedTokens = participantList[_toAddr].allocatedTokens.add(tokenAmount);
1520 
1521     // side effect: do_grant_tokens updates the "tokensGenerated" variable
1522     require( do_grant_tokens(_toAddr, tokenAmount) );
1523 
1524     // notify the world
1525     Airdropped(_toAddr, fullTokens);
1526 
1527   }
1528 
1529   function multiAirdrop(address[] addrs, uint[] fullTokens) public onlyController {
1530 
1531     require (campaignState != 0);
1532 
1533     for (uint256 iterator = 0; iterator < addrs.length; iterator++) {
1534       airdrop(addrs[iterator], fullTokens[iterator]);
1535     }
1536   }
1537 
1538   // set individual preCrowd cap
1539   function setInvestorsBatchSize(uint256 _batchsize) public onlyController {
1540       investorsBatchSize = _batchsize;
1541   }
1542 
1543   // set individual preCrowd cap
1544   function setMaxPreCrowdAllocationPerInvestor(uint256 _cap) public onlyController {
1545       maxPreCrowdAllocationPerInvestor = _cap;
1546   }
1547 
1548   // set individual stage1Crowd cap
1549   function setMaxStage1AllocationPerInvestor(uint256 _cap) public onlyController {
1550       maxStage1AllocationPerInvestor = _cap;
1551   }
1552 
1553   // set individual stage2Crowd cap
1554   function setMaxStage2AllocationPerInvestor(uint256 _cap) public onlyController {
1555       maxStage2AllocationPerInvestor = _cap;
1556   }
1557 
1558   // set individual stage3Crowd cap
1559   function setMaxStage3AllocationPerInvestor(uint256 _cap) public onlyController {
1560       maxStage3AllocationPerInvestor = _cap;
1561   }
1562 
1563   function setdteamVaultAddr1(address _newAddr) public onlyController {
1564     require( _newAddr != 0x0 );
1565     dteamVaultAddr1 = _newAddr;
1566   }
1567 
1568   function setdteamVaultAddr2(address _newAddr) public onlyController {
1569     require( _newAddr != 0x0 );
1570     dteamVaultAddr2 = _newAddr;
1571   }
1572 
1573   function setdteamVaultAddr3(address _newAddr) public onlyController {
1574     require( _newAddr != 0x0 );
1575     dteamVaultAddr3 = _newAddr;
1576   }
1577 
1578   function setdteamVaultAddr4(address _newAddr) public onlyController {
1579     require( _newAddr != 0x0 );
1580     dteamVaultAddr4 = _newAddr;
1581   }
1582 
1583   function setrteamVaultAddr(address _newAddr) public onlyController {
1584     require( _newAddr != 0x0 );
1585     rteamVaultAddr = _newAddr;
1586   }
1587 
1588   function setr2VaultAddr(address _newAddr) public onlyController {
1589     require( _newAddr != 0x0 );
1590     r2VaultAddr = _newAddr;
1591   }
1592 
1593   function setmmVaultAddr(address _newAddr) public onlyController {
1594     require( _newAddr != 0x0 );
1595     mmVaultAddr = _newAddr;
1596   }
1597 
1598   function settrusteeVaultAddr(address _newAddr) public onlyController {
1599     require( _newAddr != 0x0 );
1600     trusteeVaultAddr = _newAddr;
1601   }
1602 
1603   function setopVaultAddr(address _newAddr) public onlyController {
1604     require( _newAddr != 0x0 );
1605     opVaultAddr = _newAddr;
1606   }
1607 
1608   function toggleWhitelist(bool _isWhitelisted) public onlyController {
1609     isWhiteListed = _isWhitelisted;
1610   }
1611 
1612   /// @notice This function handles receiving Ether in favor of a third party address
1613   ///   we can use this function for buying tokens on behalf
1614   /// @param _toAddr the address which will receive tokens
1615   function proxy_contribution(address _toAddr) public payable {
1616     require ( _toAddr != 0x0 );
1617 
1618     process_contribution(_toAddr);
1619   }
1620 
1621 
1622   /// @notice This function handles receiving Ether
1623   function () payable {
1624       process_contribution(msg.sender); 
1625   }
1626 
1627   /// This method can be used by the controller to extract mistakenly
1628   ///  sent tokens to this contract.
1629   function claimTokens(address _tokenAddr) public onlyController {
1630 
1631       ERC20Basic some_token = ERC20Basic(_tokenAddr);
1632       uint256 balance = some_token.balanceOf(this);
1633       some_token.transfer(controller, balance);
1634       ClaimedTokens(_tokenAddr, controller, balance);
1635   }
1636 }