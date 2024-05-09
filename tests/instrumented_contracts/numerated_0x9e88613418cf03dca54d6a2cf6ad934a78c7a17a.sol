1 pragma solidity ^0.4.13;
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
33 /// @dev The token controller contract must implement these functions
34 contract TokenController {
35     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
36     /// @param _owner The address that sent the ether to create tokens
37     /// @return True if the ether is accepted, false if it throws
38     function proxyPayment(address _owner) payable returns(bool);
39 
40     /// @notice Notifies the controller about a token transfer allowing the
41     ///  controller to react if desired
42     /// @param _from The origin of the transfer
43     /// @param _to The destination of the transfer
44     /// @param _amount The amount of the transfer
45     /// @return False if the controller does not authorize the transfer
46     function onTransfer(address _from, address _to, uint _amount) returns(bool);
47 
48     /// @notice Notifies the controller about an approval allowing the
49     ///  controller to react if desired
50     /// @param _owner The address that calls `approve()`
51     /// @param _spender The spender in the `approve()` call
52     /// @param _amount The amount in the `approve()` call
53     /// @return False if the controller does not authorize the approval
54     function onApprove(address _owner, address _spender, uint _amount)
55         returns(bool);
56 }
57 
58 
59 contract Controlled {
60     /// @notice The address of the controller is the only address that can call
61     ///  a function with this modifier
62     modifier onlyController { require(msg.sender == controller); _; }
63 
64     address public controller;
65 
66     function Controlled() { controller = msg.sender;}
67 
68     /// @notice Changes the controller of the contract
69     /// @param _newController The new controller of the contract
70     function changeController(address _newController) onlyController {
71         controller = _newController;
72     }
73 }
74 
75 contract ApproveAndCallFallBack {
76     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
77 }
78 
79 /// @dev This contract is used to generate clone contracts from a contract.
80 ///  In solidity this is the way to create a contract from a contract of the
81 ///  same class
82 contract MiniMeTokenFactory {
83 
84     function MiniMeTokenFactory() {
85     }
86 
87     /// @notice Update the DApp by creating a new token with new functionalities
88     ///  the msg.sender becomes the controller of this clone token
89     /// @param _parentToken Address of the token being cloned
90     /// @param _snapshotBlock Block of the parent token that will
91     ///  determine the initial distribution of the clone token
92     /// @param _tokenName Name of the new token
93     /// @param _decimalUnits Number of decimals of the new token
94     /// @param _tokenSymbol Token Symbol for the new token
95     /// @param _transfersEnabled If true, tokens will be able to be transferred
96     /// @return The address of the new token contract
97     function createCloneToken(
98         address _parentToken,
99         uint _snapshotBlock,
100         string _tokenName,
101         uint8 _decimalUnits,
102         string _tokenSymbol,
103         bool _transfersEnabled
104     ) returns (MiniMeToken) 
105     {
106         MiniMeToken newToken = new MiniMeToken(
107             this,
108             _parentToken,
109             _snapshotBlock,
110             _tokenName,
111             _decimalUnits,
112             _tokenSymbol,
113             _transfersEnabled
114             );
115 
116         newToken.changeController(msg.sender);
117         return newToken;
118     }
119 }
120 
121 /*
122     Copyright 2016, Jordi Baylina
123 
124     This program is free software: you can redistribute it and/or modify
125     it under the terms of the GNU General Public License as published by
126     the Free Software Foundation, either version 3 of the License, or
127     (at your option) any later version.
128 
129     This program is distributed in the hope that it will be useful,
130     but WITHOUT ANY WARRANTY; without even the implied warranty of
131     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
132     GNU General Public License for more details.
133 
134     You should have received a copy of the GNU General Public License
135     along with this program.  If not, see <http://www.gnu.org/licenses/>.
136  */
137 
138 /// @title MiniMeToken Contract
139 /// @author Jordi Baylina
140 /// @dev This token contract's goal is to make it easy for anyone to clone this
141 ///  token using the token distribution at a given block, this will allow DAO's
142 ///  and DApps to upgrade their features in a decentralized manner without
143 ///  affecting the original token
144 /// @dev It is ERC20 compliant, but still needs to under go further testing.
145 
146 /// @dev The actual token contract, the default controller is the msg.sender
147 ///  that deploys the contract, so usually this token will be deployed by a
148 ///  token controller contract, which Giveth will call a "Campaign"
149 contract MiniMeToken is Controlled {
150 
151     string public name;                //The Token's name: e.g. DigixDAO Tokens
152     uint8 public decimals;             //Number of decimals of the smallest unit
153     string public symbol;              //An identifier: e.g. REP
154     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
155 
156 
157     /// @dev `Checkpoint` is the structure that attaches a block number to a
158     ///  given value, the block number attached is the one that last changed the
159     ///  value
160     struct  Checkpoint {
161 
162         // `fromBlock` is the block number that the value was generated from
163         uint128 fromBlock;
164 
165         // `value` is the amount of tokens at a specific block number
166         uint128 value;
167     }
168 
169     // `parentToken` is the Token address that was cloned to produce this token;
170     //  it will be 0x0 for a token that was not cloned
171     MiniMeToken public parentToken;
172 
173     // `parentSnapShotBlock` is the block number from the Parent Token that was
174     //  used to determine the initial distribution of the Clone Token
175     uint public parentSnapShotBlock;
176 
177     // `creationBlock` is the block number that the Clone Token was created
178     uint public creationBlock;
179 
180     // `balances` is the map that tracks the balance of each address, in this
181     //  contract when the balance changes the block number that the change
182     //  occurred is also included in the map
183     mapping (address => Checkpoint[]) balances;
184 
185     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
186     mapping (address => mapping (address => uint256)) allowed;
187 
188     // Tracks the history of the `totalSupply` of the token
189     Checkpoint[] totalSupplyHistory;
190 
191     // Flag that determines if the token is transferable or not.
192     bool public transfersEnabled;
193 
194     // The factory used to create new clone tokens
195     MiniMeTokenFactory public tokenFactory;
196 
197 ////////////////
198 // Constructor
199 ////////////////
200 
201     /// @notice Constructor to create a MiniMeToken
202     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
203     ///  will create the Clone token contracts, the token factory needs to be
204     ///  deployed first
205     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
206     ///  new token
207     /// @param _parentSnapShotBlock Block of the parent token that will
208     ///  determine the initial distribution of the clone token, set to 0 if it
209     ///  is a new token
210     /// @param _tokenName Name of the new token
211     /// @param _decimalUnits Number of decimals of the new token
212     /// @param _tokenSymbol Token Symbol for the new token
213     /// @param _transfersEnabled If true, tokens will be able to be transferred
214     function MiniMeToken(
215         address _tokenFactory,
216         address _parentToken,
217         uint _parentSnapShotBlock,
218         string _tokenName,
219         uint8 _decimalUnits,
220         string _tokenSymbol,
221         bool _transfersEnabled
222     ) 
223     Controlled()
224     {
225         tokenFactory = MiniMeTokenFactory(_tokenFactory);
226         name = _tokenName;                                 // Set the name
227         decimals = _decimalUnits;                          // Set the decimals
228         symbol = _tokenSymbol;                             // Set the symbol
229         parentToken = MiniMeToken(_parentToken);
230         parentSnapShotBlock = _parentSnapShotBlock;
231         transfersEnabled = _transfersEnabled;
232         creationBlock = block.number;
233     }
234 
235 
236 ///////////////////
237 // ERC20 Methods
238 ///////////////////
239 
240     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
241     /// @param _to The address of the recipient
242     /// @param _amount The amount of tokens to be transferred
243     /// @return Whether the transfer was successful or not
244     function transfer(address _to, uint256 _amount) returns (bool success) {
245         require(transfersEnabled);
246         return doTransfer(msg.sender, _to, _amount);
247     }
248 
249     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
250     ///  is approved by `_from`
251     /// @param _from The address holding the tokens being transferred
252     /// @param _to The address of the recipient
253     /// @param _amount The amount of tokens to be transferred
254     /// @return True if the transfer was successful
255     function transferFrom(address _from, address _to, uint256 _amount
256     ) returns (bool success) {
257 
258         // The controller of this contract can move tokens around at will,
259         //  this is important to recognize! Confirm that you trust the
260         //  controller of this contract, which in most situations should be
261         //  another open source smart contract or 0x0
262         if (msg.sender != controller) {
263             require(transfersEnabled);
264 
265             // The standard ERC 20 transferFrom functionality
266             if (allowed[_from][msg.sender] < _amount) return false;
267             allowed[_from][msg.sender] -= _amount;
268         }
269         return doTransfer(_from, _to, _amount);
270     }
271 
272     /// @dev This is the actual transfer function in the token contract, it can
273     ///  only be called by other functions in this contract.
274     /// @param _from The address holding the tokens being transferred
275     /// @param _to The address of the recipient
276     /// @param _amount The amount of tokens to be transferred
277     /// @return True if the transfer was successful
278     function doTransfer(address _from, address _to, uint _amount
279     ) internal returns(bool) {
280 
281            if (_amount == 0) {
282                return true;
283            }
284 
285            require(parentSnapShotBlock < block.number);
286 
287            // Do not allow transfer to 0x0 or the token contract itself
288            require((_to != 0) && (_to != address(this)));
289 
290            // If the amount being transfered is more than the balance of the
291            //  account the transfer returns false
292            var previousBalanceFrom = balanceOfAt(_from, block.number);
293            if (previousBalanceFrom < _amount) {
294                return false;
295            }
296 
297            // First update the balance array with the new value for the address
298            //  sending the tokens
299            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
300 
301            // Then update the balance array with the new value for the address
302            //  receiving the tokens
303            var previousBalanceTo = balanceOfAt(_to, block.number);
304            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
305            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
306 
307            // An event to make the transfer easy to find on the blockchain
308            Transfer(_from, _to, _amount);
309 
310            return true;
311     }
312 
313     /// @param _owner The address that's balance is being requested
314     /// @return The balance of `_owner` at the current block
315     function balanceOf(address _owner) constant returns (uint256 balance) {
316         return balanceOfAt(_owner, block.number);
317     }
318 
319     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
320     ///  its behalf. This is a modified version of the ERC20 approve function
321     ///  to be a little bit safer
322     /// @param _spender The address of the account able to transfer the tokens
323     /// @param _amount The amount of tokens to be approved for transfer
324     /// @return True if the approval was successful
325     function approve(address _spender, uint256 _amount) returns (bool success) {
326         require(transfersEnabled);
327 
328         // To change the approve amount you first have to reduce the addresses`
329         //  allowance to zero by calling `approve(_spender,0)` if it is not
330         //  already 0 to mitigate the race condition described here:
331         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
332         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
333 
334         allowed[msg.sender][_spender] = _amount;
335         Approval(msg.sender, _spender, _amount);
336         return true;
337     }
338 
339     /// @dev This function makes it easy to read the `allowed[]` map
340     /// @param _owner The address of the account that owns the token
341     /// @param _spender The address of the account able to transfer the tokens
342     /// @return Amount of remaining tokens of _owner that _spender is allowed
343     ///  to spend
344     function allowance(address _owner, address _spender
345     ) constant returns (uint256 remaining) {
346         return allowed[_owner][_spender];
347     }
348 
349     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
350     ///  its behalf, and then a function is triggered in the contract that is
351     ///  being approved, `_spender`. This allows users to use their tokens to
352     ///  interact with contracts in one function call instead of two
353     /// @param _spender The address of the contract able to transfer the tokens
354     /// @param _amount The amount of tokens to be approved for transfer
355     /// @return True if the function call was successful
356     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
357     ) returns (bool success) {
358         require(approve(_spender, _amount));
359 
360         ApproveAndCallFallBack(_spender).receiveApproval(
361             msg.sender,
362             _amount,
363             this,
364             _extraData
365         );
366 
367         return true;
368     }
369 
370     /// @dev This function makes it easy to get the total number of tokens
371     /// @return The total number of tokens
372     function totalSupply() constant returns (uint) {
373         return totalSupplyAt(block.number);
374     }
375 
376 
377 ////////////////
378 // Query balance and totalSupply in History
379 ////////////////
380 
381     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
382     /// @param _owner The address from which the balance will be retrieved
383     /// @param _blockNumber The block number when the balance is queried
384     /// @return The balance at `_blockNumber`
385     function balanceOfAt(address _owner, uint _blockNumber) constant
386         returns (uint) {
387 
388         // These next few lines are used when the balance of the token is
389         //  requested before a check point was ever created for this token, it
390         //  requires that the `parentToken.balanceOfAt` be queried at the
391         //  genesis block for that token as this contains initial balance of
392         //  this token
393         if ((balances[_owner].length == 0)
394             || (balances[_owner][0].fromBlock > _blockNumber)) {
395             if (address(parentToken) != 0) {
396                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
397             } else {
398                 // Has no parent
399                 return 0;
400             }
401 
402         // This will return the expected balance during normal situations
403         } else {
404             return getValueAt(balances[_owner], _blockNumber);
405         }
406     }
407 
408     /// @notice Total amount of tokens at a specific `_blockNumber`.
409     /// @param _blockNumber The block number when the totalSupply is queried
410     /// @return The total amount of tokens at `_blockNumber`
411     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
412 
413         // These next few lines are used when the totalSupply of the token is
414         //  requested before a check point was ever created for this token, it
415         //  requires that the `parentToken.totalSupplyAt` be queried at the
416         //  genesis block for this token as that contains totalSupply of this
417         //  token at this block number.
418         if ((totalSupplyHistory.length == 0)
419             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
420             if (address(parentToken) != 0) {
421                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
422             } else {
423                 return 0;
424             }
425 
426         // This will return the expected totalSupply during normal situations
427         } else {
428             return getValueAt(totalSupplyHistory, _blockNumber);
429         }
430     }
431 
432 ////////////////
433 // Clone Token Method
434 ////////////////
435 
436     /// @notice Creates a new clone token with the initial distribution being
437     ///  this token at `_snapshotBlock`
438     /// @param _cloneTokenName Name of the clone token
439     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
440     /// @param _cloneTokenSymbol Symbol of the clone token
441     /// @param _snapshotBlock Block when the distribution of the parent token is
442     ///  copied to set the initial distribution of the new clone token;
443     ///  if the block is zero than the actual block, the current block is used
444     /// @param _transfersEnabled True if transfers are allowed in the clone
445     /// @return The address of the new MiniMeToken Contract
446     function createCloneToken(
447         string _cloneTokenName,
448         uint8 _cloneDecimalUnits,
449         string _cloneTokenSymbol,
450         uint _snapshotBlock,
451         bool _transfersEnabled
452         ) returns(address) {
453         if (_snapshotBlock == 0) _snapshotBlock = block.number;
454         MiniMeToken cloneToken = tokenFactory.createCloneToken(
455             this,
456             _snapshotBlock,
457             _cloneTokenName,
458             _cloneDecimalUnits,
459             _cloneTokenSymbol,
460             _transfersEnabled
461             );
462 
463         cloneToken.changeController(msg.sender);
464 
465         // An event to make the token easy to find on the blockchain
466         NewCloneToken(address(cloneToken), _snapshotBlock);
467         return address(cloneToken);
468     }
469 
470 ////////////////
471 // Generate and destroy tokens
472 ////////////////
473 
474 
475     /// @notice Generates `_amount` tokens that are assigned to `_owner`
476     /// @param _owner The address that will be assigned the new tokens
477     /// @param _amount The quantity of tokens generated
478     /// @return True if the tokens are generated correctly
479     function generateTokens(address _owner, uint _amount
480     ) onlyController returns (bool) {
481         uint curTotalSupply = totalSupply();
482         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
483         uint previousBalanceTo = balanceOf(_owner);
484         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
485         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
486         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
487         Transfer(0, _owner, _amount);
488         return true;
489     }
490 
491 
492     /// @notice Burns `_amount` tokens from `_owner`
493     /// @param _owner The address that will lose the tokens
494     /// @param _amount The quantity of tokens to burn
495     /// @return True if the tokens are burned correctly
496     function destroyTokens(address _owner, uint _amount
497     ) onlyController returns (bool) {
498         uint curTotalSupply = totalSupply();
499         require(curTotalSupply >= _amount);
500         uint previousBalanceFrom = balanceOf(_owner);
501         require(previousBalanceFrom >= _amount);
502         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
503         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
504         Transfer(_owner, 0, _amount);
505         return true;
506     }
507 
508 ////////////////
509 // Enable tokens transfers
510 ////////////////
511 
512 
513     /// @notice Enables token holders to transfer their tokens freely if true
514     /// @param _transfersEnabled True if transfers are allowed in the clone
515     function enableTransfers(bool _transfersEnabled) onlyController {
516         transfersEnabled = _transfersEnabled;
517     }
518 
519 ////////////////
520 // Internal helper functions to query and set a value in a snapshot array
521 ////////////////
522 
523     /// @dev `getValueAt` retrieves the number of tokens at a given block number
524     /// @param checkpoints The history of values being queried
525     /// @param _block The block number to retrieve the value at
526     /// @return The number of tokens being queried
527     function getValueAt(Checkpoint[] storage checkpoints, uint _block
528     ) constant internal returns (uint) {
529         if (checkpoints.length == 0) return 0;
530 
531         // Shortcut for the actual value
532         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
533             return checkpoints[checkpoints.length-1].value;
534         if (_block < checkpoints[0].fromBlock) return 0;
535 
536         // Binary search of the value in the array
537         uint min = 0;
538         uint max = checkpoints.length-1;
539         while (max > min) {
540             uint mid = (max + min + 1)/ 2;
541             if (checkpoints[mid].fromBlock<=_block) {
542                 min = mid;
543             } else {
544                 max = mid-1;
545             }
546         }
547         return checkpoints[min].value;
548     }
549 
550     /// @dev `updateValueAtNow` used to update the `balances` map and the
551     ///  `totalSupplyHistory`
552     /// @param checkpoints The history of data being updated
553     /// @param _value The new number of tokens
554     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
555     ) internal  {
556         if ((checkpoints.length == 0)
557         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
558                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
559                newCheckPoint.fromBlock =  uint128(block.number);
560                newCheckPoint.value = uint128(_value);
561            } else {
562                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
563                oldCheckPoint.value = uint128(_value);
564            }
565     }
566 
567     /// @dev Internal function to determine if an address is a contract
568     /// @param _addr The address being queried
569     /// @return True if `_addr` is a contract
570     function isContract(address _addr) constant internal returns(bool) {
571         uint size;
572         if (_addr == 0) return false;
573         assembly {
574             size := extcodesize(_addr)
575         }
576         return size>0;
577     }
578 
579     /// @dev Helper function to return a min betwen the two uints
580     function min(uint a, uint b) internal returns (uint) {
581         return a < b ? a : b;
582     }
583 
584     /// @notice The fallback function: If the contract's controller has not been
585     ///  set to 0, then the `proxyPayment` method is called which relays the
586     ///  ether and creates tokens as described in the token controller contract
587     function () payable {
588         // Fail any transfers into the token contract
589         require(false);
590     }
591 
592 //////////
593 // Safety Methods
594 //////////
595 
596     /// @notice This method can be used by the controller to extract mistakenly
597     ///  sent tokens to this contract.
598     /// @param _token The address of the token contract that you want to recover
599     ///  set to 0 in case you want to extract ether.
600     function claimTokens(address _token) onlyController {
601         if (_token == 0x0) {
602             controller.transfer(this.balance);
603             return;
604         }
605 
606         MiniMeToken token = MiniMeToken(_token);
607         uint balance = token.balanceOf(this);
608         token.transfer(controller, balance);
609         ClaimedTokens(_token, controller, balance);
610     }
611 
612 ////////////////
613 // Events
614 ////////////////
615     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
616     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
617     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
618     event Approval(
619         address indexed _owner,
620         address indexed _spender,
621         uint256 _amount
622         );
623 
624 }
625 
626 /**
627  * This contract inherits from the MinimeToken and adds minting capability.
628  * When the sale is started, the token ownership is handed over to the Crowsdale contract.
629  * The crowdsale contract will not call the "generateTokens()" call directly in the MinimeToken, 
630  * but will instead use the minting functionality here.
631  */
632 contract MiniMeMintableToken is MiniMeToken {
633   using SafeMath for uint256;
634 
635   // Events to notify about Minting
636   event Mint(address indexed to, uint256 amount);
637   event MintFinished();
638 
639   // Flag to track whether minting is still allowed.
640   bool public mintingFinished = false;
641 
642   // This map will keep track of how many tokens were issued during the token sale.
643   // This value will then be used for vesting calculations from the point where the token contract is finished minting.
644   mapping (address => uint256) issuedTokens;
645 
646   // Modifier to allow minting of tokens.
647   modifier canMint() {
648     require(!mintingFinished);
649     _;
650   }
651 
652   // Pass through consructor
653   function MiniMeMintableToken(
654     address _tokenFactory,
655     address _parentToken,
656     uint _parentSnapShotBlock,
657     string _tokenName,
658     uint8 _decimalUnits,
659     string _tokenSymbol,
660     bool _transfersEnabled
661   ) 
662   MiniMeToken(
663     _tokenFactory,
664     _parentToken,
665     _parentSnapShotBlock,
666     _tokenName,
667     _decimalUnits,
668     _tokenSymbol,
669     _transfersEnabled
670   )
671   {
672   }
673 
674   /**
675    * @dev Function to mint tokens
676    * @param _to The address that will recieve the minted tokens.
677    * @param _amount The amount of tokens to mint.
678    * @return A boolean that indicates if the operation was successful.
679    */
680   function mint(address _to, uint256 _amount) onlyController canMint returns (bool) {
681 
682     // First, generate the tokens in the base Minime class balances.
683     generateTokens(_to, _amount);
684 
685     // Save off the amount that this account has been issued during the minting period so vesting can be calculated.
686     issuedTokens[_to] = issuedTokens[_to].add(_amount);
687 
688     // Trigger the minting event notification
689     Mint(_to, _amount);
690 
691     return true;
692   }
693 
694   /**
695    * @dev Function to stop minting new tokens.
696    * @return True if the operation was successful.
697    */
698   function finishMinting() onlyController canMint returns (bool) {
699 
700     // Set the minting finished so that tokens can be transferred once vested.
701     // This flag will prevent new tokens from being minted in the future.
702     mintingFinished = true;
703 
704     // Trigger the notification that minting has finished.
705     MintFinished();
706     
707     return true;
708   }
709 }
710 
711 /**
712  * This contract defines the tokens for the SWARM platform.
713  * It inherits from the MiniMeToken contract which allows sub-tokens to be created.
714  * This token also implements a vesting schedule on any tokens that are minted during the pre-sale.
715  * The MintableToken contract is adapted from the Open Zeppelin contract.
716  */
717 contract MiniMeVestedToken is MiniMeMintableToken {
718   using SafeMath for uint256;
719 
720   // This value will keep track of the time when the minting is finished after the crowd sale ends.
721   // Vesting will start accruing at this point in time.
722   uint256 public vestingStartTime = 0;
723 
724   // Default vesting period is 42 days, with a max of 8 periods
725   uint256 public vestingPeriodTime = 42 days;
726   uint256 public vestingTotalPeriods = 8;
727 
728   // Pass through consructor
729   function MiniMeVestedToken(
730     address _tokenFactory,
731     address _parentToken,
732     uint _parentSnapShotBlock,
733     string _tokenName,
734     uint8 _decimalUnits,
735     string _tokenSymbol,
736     bool _transfersEnabled
737   ) 
738   MiniMeMintableToken(
739     _tokenFactory,
740     _parentToken,
741     _parentSnapShotBlock,
742     _tokenName,
743     _decimalUnits,
744     _tokenSymbol,
745     _transfersEnabled
746   )
747   {
748   }
749 
750 ////////////////////
751 // Token Transfers
752 ////////////////////
753 
754   /**
755    * Modifier to functions to see if the vested balance is higher than requested transfer amount.
756    * Also enforces that the minting phase of the sale is over.
757    */
758   modifier canTransfer(address _sender, uint _value) {
759     require(mintingFinished);
760     require(_value <= vestedBalanceOf(_sender));
761     _;
762   }
763 
764   /**
765    * Override the base transfer class to enforce vesting requirement is met
766    */
767   function transfer(address _to, uint _value)
768     canTransfer(msg.sender, _value)
769     public
770     returns (bool success)
771   {
772     return super.transfer(_to, _value);
773   }
774 
775   /**
776    * Override the base transferFrom class to enforce vesting requirement is met
777    */
778   function transferFrom(address _from, address _to, uint _value)
779     canTransfer(_from, _value)
780     public
781     returns (bool success)
782   {
783     return super.transferFrom(_from, _to, _value);
784   }
785 
786 ////////////////////
787 // Token Vesting
788 ///////////////////
789 
790   /**
791    * Allow vesting schedule params to be overridden.
792    */
793   function setVestingParams(uint256 _vestingStartTime, uint256 _vestingTotalPeriods, uint256 _vestingPeriodTime) onlyController {
794     vestingStartTime = _vestingStartTime;
795     vestingTotalPeriods = _vestingTotalPeriods;
796     vestingPeriodTime = _vestingPeriodTime;
797   }
798 
799   /**
800     * Gets the number of vesting periods that have completed from the start time to the current time.
801     */
802   function getVestingPeriodsCompleted(uint256 _vestingStartTime, uint256 _currentTime) public constant returns (uint256) {
803       return _currentTime.sub(_vestingStartTime).div(vestingPeriodTime);
804   }
805 
806   /**
807     * Gets the vested balance for an account.
808     * initialBalance - The amount that was allocated at the start of vesting.
809     * currentBalance - The amount that is currently in the account.
810     * vestingStartTime - The time stamp (seconds since unix epoch) when vesting started.
811     * currentTime - The current time stamp (seconds since unix epoch).
812     */
813   function getVestedBalance(uint256 _initialBalance, uint256 _currentBalance, uint256 _vestingStartTime, uint256 _currentTime)
814       public constant returns (uint256)
815   {
816       // Short-cut if vesting hasn't started yet
817       if (_currentTime < _vestingStartTime) {
818         return 0;
819       }
820       
821       // Short-cut the vesting calculations if the vesting periods are completed
822       if (_currentTime >= _vestingStartTime.add(vestingPeriodTime.mul(vestingTotalPeriods))) {
823           return _currentBalance;
824       }
825 
826       // First, get the number of vesting periods completed
827       uint256 vestedPeriodsCompleted = getVestingPeriodsCompleted(_vestingStartTime, _currentTime);
828 
829       // Calculate the amount that should be withheld.
830       uint256 vestingPeriodsRemaining = vestingTotalPeriods.sub(vestedPeriodsCompleted);
831       uint256 unvestedBalance = _initialBalance.mul(vestingPeriodsRemaining).div(vestingTotalPeriods);
832 
833       // Return the current balance minus any that is still unvested.
834       return _currentBalance.sub(unvestedBalance);
835   }
836 
837   /**
838    * Convenience method - Get the vested balance of the address.
839    */
840   function vestedBalanceOf(address _owner) public constant returns (uint256 balance) {
841     return getVestedBalance(issuedTokens[_owner], balanceOf(_owner), vestingStartTime, block.timestamp);
842   }
843 
844   /**
845    * At the end of the sale, this should be called to trigger the vesting to start.
846    * Tokens cannot be transferred prior to this being called.
847    */
848   function finishMinting() onlyController canMint returns (bool) {
849     // Set the time stamp for tokens to start vesting
850     vestingStartTime = block.timestamp;
851 
852     return super.finishMinting();
853   }
854 }
855 
856 contract SwarmToken is MiniMeVestedToken {
857 
858   /**
859    * Constructor to initialize Swarm Token.
860    * Factory is pre-deployed and passed in.
861    *
862    * @author poole_party via tokensoft.io
863    */
864   function SwarmToken(address _tokenFactory)
865     MiniMeVestedToken(
866       _tokenFactory,
867       0x0,
868       0,
869       "Swarm Fund Token",
870       18,
871       "SWM",
872       true
873     )
874     {}    
875 }