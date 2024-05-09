1 pragma solidity ^0.4.13;
2 
3 /// @dev This contract is used to generate clone contracts from a contract.
4 ///  In solidity this is the way to create a contract from a contract of the
5 ///  same class
6 contract MiniMeTokenFactory {
7 
8     function MiniMeTokenFactory() {
9     }
10 
11     /// @notice Update the DApp by creating a new token with new functionalities
12     ///  the msg.sender becomes the controller of this clone token
13     /// @param _parentToken Address of the token being cloned
14     /// @param _snapshotBlock Block of the parent token that will
15     ///  determine the initial distribution of the clone token
16     /// @param _tokenName Name of the new token
17     /// @param _decimalUnits Number of decimals of the new token
18     /// @param _tokenSymbol Token Symbol for the new token
19     /// @param _transfersEnabled If true, tokens will be able to be transferred
20     /// @return The address of the new token contract
21     function createCloneToken(
22         address _parentToken,
23         uint _snapshotBlock,
24         string _tokenName,
25         uint8 _decimalUnits,
26         string _tokenSymbol,
27         bool _transfersEnabled
28     ) returns (MiniMeToken) 
29     {
30         MiniMeToken newToken = new MiniMeToken(
31             this,
32             _parentToken,
33             _snapshotBlock,
34             _tokenName,
35             _decimalUnits,
36             _tokenSymbol,
37             _transfersEnabled
38             );
39 
40         newToken.changeController(msg.sender);
41         return newToken;
42     }
43 }
44 
45 /// @dev The token controller contract must implement these functions
46 contract TokenController {
47     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
48     /// @param _owner The address that sent the ether to create tokens
49     /// @return True if the ether is accepted, false if it throws
50     function proxyPayment(address _owner) payable returns(bool);
51 
52     /// @notice Notifies the controller about a token transfer allowing the
53     ///  controller to react if desired
54     /// @param _from The origin of the transfer
55     /// @param _to The destination of the transfer
56     /// @param _amount The amount of the transfer
57     /// @return False if the controller does not authorize the transfer
58     function onTransfer(address _from, address _to, uint _amount) returns(bool);
59 
60     /// @notice Notifies the controller about an approval allowing the
61     ///  controller to react if desired
62     /// @param _owner The address that calls `approve()`
63     /// @param _spender The spender in the `approve()` call
64     /// @param _amount The amount in the `approve()` call
65     /// @return False if the controller does not authorize the approval
66     function onApprove(address _owner, address _spender, uint _amount)
67         returns(bool);
68 }
69 
70 
71 contract Controlled {
72     /// @notice The address of the controller is the only address that can call
73     ///  a function with this modifier
74     modifier onlyController { require(msg.sender == controller); _; }
75 
76     address public controller;
77 
78     function Controlled() { controller = msg.sender;}
79 
80     /// @notice Changes the controller of the contract
81     /// @param _newController The new controller of the contract
82     function changeController(address _newController) onlyController {
83         controller = _newController;
84     }
85 }
86 
87 contract ApproveAndCallFallBack {
88     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
89 }
90 
91 /*
92     Copyright 2016, Jordi Baylina
93 
94     This program is free software: you can redistribute it and/or modify
95     it under the terms of the GNU General Public License as published by
96     the Free Software Foundation, either version 3 of the License, or
97     (at your option) any later version.
98 
99     This program is distributed in the hope that it will be useful,
100     but WITHOUT ANY WARRANTY; without even the implied warranty of
101     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
102     GNU General Public License for more details.
103 
104     You should have received a copy of the GNU General Public License
105     along with this program.  If not, see <http://www.gnu.org/licenses/>.
106  */
107 
108 /// @title MiniMeToken Contract
109 /// @author Jordi Baylina
110 /// @dev This token contract's goal is to make it easy for anyone to clone this
111 ///  token using the token distribution at a given block, this will allow DAO's
112 ///  and DApps to upgrade their features in a decentralized manner without
113 ///  affecting the original token
114 /// @dev It is ERC20 compliant, but still needs to under go further testing.
115 
116 /// @dev The actual token contract, the default controller is the msg.sender
117 ///  that deploys the contract, so usually this token will be deployed by a
118 ///  token controller contract, which Giveth will call a "Campaign"
119 contract MiniMeToken is Controlled {
120 
121     string public name;                //The Token's name: e.g. DigixDAO Tokens
122     uint8 public decimals;             //Number of decimals of the smallest unit
123     string public symbol;              //An identifier: e.g. REP
124     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
125 
126 
127     /// @dev `Checkpoint` is the structure that attaches a block number to a
128     ///  given value, the block number attached is the one that last changed the
129     ///  value
130     struct  Checkpoint {
131 
132         // `fromBlock` is the block number that the value was generated from
133         uint128 fromBlock;
134 
135         // `value` is the amount of tokens at a specific block number
136         uint128 value;
137     }
138 
139     // `parentToken` is the Token address that was cloned to produce this token;
140     //  it will be 0x0 for a token that was not cloned
141     MiniMeToken public parentToken;
142 
143     // `parentSnapShotBlock` is the block number from the Parent Token that was
144     //  used to determine the initial distribution of the Clone Token
145     uint public parentSnapShotBlock;
146 
147     // `creationBlock` is the block number that the Clone Token was created
148     uint public creationBlock;
149 
150     // `balances` is the map that tracks the balance of each address, in this
151     //  contract when the balance changes the block number that the change
152     //  occurred is also included in the map
153     mapping (address => Checkpoint[]) balances;
154 
155     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
156     mapping (address => mapping (address => uint256)) allowed;
157 
158     // Tracks the history of the `totalSupply` of the token
159     Checkpoint[] totalSupplyHistory;
160 
161     // Flag that determines if the token is transferable or not.
162     bool public transfersEnabled;
163 
164     // The factory used to create new clone tokens
165     MiniMeTokenFactory public tokenFactory;
166 
167 ////////////////
168 // Constructor
169 ////////////////
170 
171     /// @notice Constructor to create a MiniMeToken
172     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
173     ///  will create the Clone token contracts, the token factory needs to be
174     ///  deployed first
175     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
176     ///  new token
177     /// @param _parentSnapShotBlock Block of the parent token that will
178     ///  determine the initial distribution of the clone token, set to 0 if it
179     ///  is a new token
180     /// @param _tokenName Name of the new token
181     /// @param _decimalUnits Number of decimals of the new token
182     /// @param _tokenSymbol Token Symbol for the new token
183     /// @param _transfersEnabled If true, tokens will be able to be transferred
184     function MiniMeToken(
185         address _tokenFactory,
186         address _parentToken,
187         uint _parentSnapShotBlock,
188         string _tokenName,
189         uint8 _decimalUnits,
190         string _tokenSymbol,
191         bool _transfersEnabled
192     ) 
193     Controlled()
194     {
195         tokenFactory = MiniMeTokenFactory(_tokenFactory);
196         name = _tokenName;                                 // Set the name
197         decimals = _decimalUnits;                          // Set the decimals
198         symbol = _tokenSymbol;                             // Set the symbol
199         parentToken = MiniMeToken(_parentToken);
200         parentSnapShotBlock = _parentSnapShotBlock;
201         transfersEnabled = _transfersEnabled;
202         creationBlock = block.number;
203     }
204 
205 
206 ///////////////////
207 // ERC20 Methods
208 ///////////////////
209 
210     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
211     /// @param _to The address of the recipient
212     /// @param _amount The amount of tokens to be transferred
213     /// @return Whether the transfer was successful or not
214     function transfer(address _to, uint256 _amount) returns (bool success) {
215         require(transfersEnabled);
216         return doTransfer(msg.sender, _to, _amount);
217     }
218 
219     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
220     ///  is approved by `_from`
221     /// @param _from The address holding the tokens being transferred
222     /// @param _to The address of the recipient
223     /// @param _amount The amount of tokens to be transferred
224     /// @return True if the transfer was successful
225     function transferFrom(address _from, address _to, uint256 _amount
226     ) returns (bool success) {
227 
228         // The controller of this contract can move tokens around at will,
229 
230         //  controller of this contract, which in most situations should be
231         //  another open source smart contract or 0x0
232         if (msg.sender != controller) {
233             require(transfersEnabled);
234 
235             // The standard ERC 20 transferFrom functionality
236             if (allowed[_from][msg.sender] < _amount) return false;
237             allowed[_from][msg.sender] -= _amount;
238         }
239         return doTransfer(_from, _to, _amount);
240     }
241 
242     /// @dev This is the actual transfer function in the token contract, it can
243     ///  only be called by other functions in this contract.
244     /// @param _from The address holding the tokens being transferred
245     /// @param _to The address of the recipient
246     /// @param _amount The amount of tokens to be transferred
247     /// @return True if the transfer was successful
248     function doTransfer(address _from, address _to, uint _amount
249     ) internal returns(bool) {
250 
251            if (_amount == 0) {
252                return true;
253            }
254 
255            require(parentSnapShotBlock < block.number);
256 
257            // Do not allow transfer to 0x0 or the token contract itself
258            require((_to != 0) && (_to != address(this)));
259 
260            // If the amount being transfered is more than the balance of the
261            //  account the transfer returns false
262            var previousBalanceFrom = balanceOfAt(_from, block.number);
263            if (previousBalanceFrom < _amount) {
264                return false;
265            }
266 
267            // First update the balance array with the new value for the address
268            //  sending the tokens
269            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
270 
271            // Then update the balance array with the new value for the address
272            //  receiving the tokens
273            var previousBalanceTo = balanceOfAt(_to, block.number);
274            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
275            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
276 
277            // An event to make the transfer easy to find on the blockchain
278            Transfer(_from, _to, _amount);
279 
280            return true;
281     }
282 
283     /// @param _owner The address that's balance is being requested
284     /// @return The balance of `_owner` at the current block
285     function balanceOf(address _owner) constant returns (uint256 balance) {
286         return balanceOfAt(_owner, block.number);
287     }
288 
289     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
290     ///  its behalf. This is a modified version of the ERC20 approve function
291     ///  to be a little bit safer
292     /// @param _spender The address of the account able to transfer the tokens
293     /// @param _amount The amount of tokens to be approved for transfer
294     /// @return True if the approval was successful
295     function approve(address _spender, uint256 _amount) returns (bool success) {
296         require(transfersEnabled);
297 
298         // To change the approve amount you first have to reduce the addresses`
299         //  allowance to zero by calling `approve(_spender,0)` if it is not
300         //  already 0 to mitigate the race condition described here:
301         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
302         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
303 
304         allowed[msg.sender][_spender] = _amount;
305         Approval(msg.sender, _spender, _amount);
306         return true;
307     }
308 
309     /// @dev This function makes it easy to read the `allowed[]` map
310     /// @param _owner The address of the account that owns the token
311     /// @param _spender The address of the account able to transfer the tokens
312     /// @return Amount of remaining tokens of _owner that _spender is allowed
313     ///  to spend
314     function allowance(address _owner, address _spender
315     ) constant returns (uint256 remaining) {
316         return allowed[_owner][_spender];
317     }
318 
319     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
320     ///  its behalf, and then a function is triggered in the contract that is
321     ///  being approved, `_spender`. This allows users to use their tokens to
322     ///  interact with contracts in one function call instead of two
323     /// @param _spender The address of the contract able to transfer the tokens
324     /// @param _amount The amount of tokens to be approved for transfer
325     /// @return True if the function call was successful
326     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
327     ) returns (bool success) {
328         require(approve(_spender, _amount));
329 
330         ApproveAndCallFallBack(_spender).receiveApproval(
331             msg.sender,
332             _amount,
333             this,
334             _extraData
335         );
336 
337         return true;
338     }
339 
340     /// @dev This function makes it easy to get the total number of tokens
341     /// @return The total number of tokens
342     function totalSupply() constant returns (uint) {
343         return totalSupplyAt(block.number);
344     }
345 
346 
347 ////////////////
348 // Query balance and totalSupply in History
349 ////////////////
350 
351     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
352     /// @param _owner The address from which the balance will be retrieved
353     /// @param _blockNumber The block number when the balance is queried
354     /// @return The balance at `_blockNumber`
355     function balanceOfAt(address _owner, uint _blockNumber) constant
356         returns (uint) {
357 
358         // These next few lines are used when the balance of the token is
359         //  requested before a check point was ever created for this token, it
360         //  requires that the `parentToken.balanceOfAt` be queried at the
361         //  genesis block for that token as this contains initial balance of
362         //  this token
363         if ((balances[_owner].length == 0)
364             || (balances[_owner][0].fromBlock > _blockNumber)) {
365             if (address(parentToken) != 0) {
366                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
367             } else {
368                 // Has no parent
369                 return 0;
370             }
371 
372         // This will return the expected balance during normal situations
373         } else {
374             return getValueAt(balances[_owner], _blockNumber);
375         }
376     }
377 
378     /// @notice Total amount of tokens at a specific `_blockNumber`.
379     /// @param _blockNumber The block number when the totalSupply is queried
380     /// @return The total amount of tokens at `_blockNumber`
381     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
382 
383         // These next few lines are used when the totalSupply of the token is
384         //  requested before a check point was ever created for this token, it
385         //  requires that the `parentToken.totalSupplyAt` be queried at the
386         //  genesis block for this token as that contains totalSupply of this
387         //  token at this block number.
388         if ((totalSupplyHistory.length == 0)
389             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
390             if (address(parentToken) != 0) {
391                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
392             } else {
393                 return 0;
394             }
395 
396         // This will return the expected totalSupply during normal situations
397         } else {
398             return getValueAt(totalSupplyHistory, _blockNumber);
399         }
400     }
401 
402 ////////////////
403 // Clone Token Method
404 ////////////////
405 
406     /// @notice Creates a new clone token with the initial distribution being
407     ///  this token at `_snapshotBlock`
408     /// @param _cloneTokenName Name of the clone token
409     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
410     /// @param _cloneTokenSymbol Symbol of the clone token
411     /// @param _snapshotBlock Block when the distribution of the parent token is
412     ///  copied to set the initial distribution of the new clone token;
413     ///  if the block is zero than the actual block, the current block is used
414     /// @param _transfersEnabled True if transfers are allowed in the clone
415     /// @return The address of the new MiniMeToken Contract
416     function createCloneToken(
417         string _cloneTokenName,
418         uint8 _cloneDecimalUnits,
419         string _cloneTokenSymbol,
420         uint _snapshotBlock,
421         bool _transfersEnabled
422         ) returns(address) {
423         if (_snapshotBlock == 0) _snapshotBlock = block.number;
424         MiniMeToken cloneToken = tokenFactory.createCloneToken(
425             this,
426             _snapshotBlock,
427             _cloneTokenName,
428             _cloneDecimalUnits,
429             _cloneTokenSymbol,
430             _transfersEnabled
431             );
432 
433         cloneToken.changeController(msg.sender);
434 
435         // An event to make the token easy to find on the blockchain
436         NewCloneToken(address(cloneToken), _snapshotBlock);
437         return address(cloneToken);
438     }
439 
440 ////////////////
441 // Generate and destroy tokens
442 ////////////////
443 
444 
445     /// @notice Generates `_amount` tokens that are assigned to `_owner`
446     /// @param _owner The address that will be assigned the new tokens
447     /// @param _amount The quantity of tokens generated
448     /// @return True if the tokens are generated correctly
449     function generateTokens(address _owner, uint _amount
450     ) onlyController returns (bool) {
451         uint curTotalSupply = totalSupply();
452         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
453         uint previousBalanceTo = balanceOf(_owner);
454         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
455         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
456         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
457         Transfer(0, _owner, _amount);
458         return true;
459     }
460 
461 
462     /// @notice Burns `_amount` tokens from `_owner`
463     /// @param _owner The address that will lose the tokens
464     /// @param _amount The quantity of tokens to burn
465     /// @return True if the tokens are burned correctly
466     function destroyTokens(address _owner, uint _amount
467     ) onlyController returns (bool) {
468         uint curTotalSupply = totalSupply();
469         require(curTotalSupply >= _amount);
470         uint previousBalanceFrom = balanceOf(_owner);
471         require(previousBalanceFrom >= _amount);
472         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
473         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
474         Transfer(_owner, 0, _amount);
475         return true;
476     }
477 
478 ////////////////
479 // Enable tokens transfers
480 ////////////////
481 
482 
483     /// @notice Enables token holders to transfer their tokens freely if true
484     /// @param _transfersEnabled True if transfers are allowed in the clone
485     function enableTransfers(bool _transfersEnabled) onlyController {
486         transfersEnabled = _transfersEnabled;
487     }
488 
489 ////////////////
490 // Internal helper functions to query and set a value in a snapshot array
491 ////////////////
492 
493     /// @dev `getValueAt` retrieves the number of tokens at a given block number
494     /// @param checkpoints The history of values being queried
495     /// @param _block The block number to retrieve the value at
496     /// @return The number of tokens being queried
497     function getValueAt(Checkpoint[] storage checkpoints, uint _block
498     ) constant internal returns (uint) {
499         if (checkpoints.length == 0) return 0;
500 
501         // Shortcut for the actual value
502         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
503             return checkpoints[checkpoints.length-1].value;
504         if (_block < checkpoints[0].fromBlock) return 0;
505 
506         // Binary search of the value in the array
507         uint min = 0;
508         uint max = checkpoints.length-1;
509         while (max > min) {
510             uint mid = (max + min + 1)/ 2;
511             if (checkpoints[mid].fromBlock<=_block) {
512                 min = mid;
513             } else {
514                 max = mid-1;
515             }
516         }
517         return checkpoints[min].value;
518     }
519 
520     /// @dev `updateValueAtNow` used to update the `balances` map and the
521     ///  `totalSupplyHistory`
522     /// @param checkpoints The history of data being updated
523     /// @param _value The new number of tokens
524     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
525     ) internal  {
526         if ((checkpoints.length == 0)
527         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
528                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
529                newCheckPoint.fromBlock =  uint128(block.number);
530                newCheckPoint.value = uint128(_value);
531            } else {
532                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
533                oldCheckPoint.value = uint128(_value);
534            }
535     }
536 
537     /// @dev Internal function to determine if an address is a contract
538     /// @param _addr The address being queried
539     /// @return True if `_addr` is a contract
540     function isContract(address _addr) constant internal returns(bool) {
541         uint size;
542         if (_addr == 0) return false;
543         assembly {
544             size := extcodesize(_addr)
545         }
546         return size>0;
547     }
548 
549     /// @dev Helper function to return a min betwen the two uints
550     function min(uint a, uint b) internal returns (uint) {
551         return a < b ? a : b;
552     }
553 
554     /// @notice The fallback function: If the contract's controller has not been
555     ///  set to 0, then the `proxyPayment` method is called which relays the
556     ///  ether and creates tokens as described in the token controller contract
557     function () payable {
558         // Fail any transfers into the token contract
559         require(false);
560     }
561 
562 //////////
563 // Safety Methods
564 //////////
565 
566     /// @notice This method can be used by the controller to extract mistakenly
567     ///  sent tokens to this contract.
568     /// @param _token The address of the token contract that you want to recover
569     ///  set to 0 in case you want to extract ether.
570     function claimTokens(address _token) onlyController {
571         if (_token == 0x0) {
572             controller.transfer(this.balance);
573             return;
574         }
575 
576         MiniMeToken token = MiniMeToken(_token);
577         uint balance = token.balanceOf(this);
578         token.transfer(controller, balance);
579         ClaimedTokens(_token, controller, balance);
580     }
581 
582 ////////////////
583 // Events
584 ////////////////
585     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
586     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
587     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
588     event Approval(
589         address indexed _owner,
590         address indexed _spender,
591         uint256 _amount
592         );
593 
594 }
595 
596 /**
597  * @title SafeMath
598  * @dev Math operations with safety checks that throw on error
599  */
600 library SafeMath {
601   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
602     uint256 c = a * b;
603     assert(a == 0 || c / a == b);
604     return c;
605   }
606 
607   function div(uint256 a, uint256 b) internal constant returns (uint256) {
608     // assert(b > 0); // Solidity automatically throws when dividing by 0
609     uint256 c = a / b;
610     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
611     return c;
612   }
613 
614   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
615     assert(b <= a);
616     return a - b;
617   }
618 
619   function add(uint256 a, uint256 b) internal constant returns (uint256) {
620     uint256 c = a + b;
621     assert(c >= a);
622     return c;
623   }
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
876 
877 /**
878  * @title Ownable
879  * @dev The Ownable contract has an owner address, and provides basic authorization control
880  * functions, this simplifies the implementation of "user permissions".
881  */
882 contract Ownable {
883   address public owner;
884 
885 
886   /**
887    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
888    * account.
889    */
890   function Ownable() {
891     owner = msg.sender;
892   }
893 
894 
895   /**
896    * @dev Throws if called by any account other than the owner.
897    */
898   modifier onlyOwner() {
899     require(msg.sender == owner);
900     _;
901   }
902 
903 
904   /**
905    * @dev Allows the current owner to transfer control of the contract to a newOwner.
906    * @param newOwner The address to transfer ownership to.
907    */
908   function transferOwnership(address newOwner) onlyOwner {
909     if (newOwner != address(0)) {
910       owner = newOwner;
911     }
912   }
913 
914 }
915 
916 /**
917  * @title Pausable
918  * @dev Base contract which allows children to implement an emergency stop mechanism.
919  */
920 contract Pausable is Ownable {
921   event Pause();
922   event Unpause();
923 
924   bool public paused = false;
925 
926 
927   /**
928    * @dev modifier to allow actions only when the contract IS paused
929    */
930   modifier whenNotPaused() {
931     require(!paused);
932     _;
933   }
934 
935   /**
936    * @dev modifier to allow actions only when the contract IS NOT paused
937    */
938   modifier whenPaused {
939     require(paused);
940     _;
941   }
942 
943   /**
944    * @dev called by the owner to pause, triggers stopped state
945    */
946   function pause() onlyOwner whenNotPaused returns (bool) {
947     paused = true;
948     Pause();
949     return true;
950   }
951 
952   /**
953    * @dev called by the owner to unpause, returns to normal state
954    */
955   function unpause() onlyOwner whenPaused returns (bool) {
956     paused = false;
957     Unpause();
958     return true;
959   }
960 }
961 
962 /**
963  * @title Crowdsale 
964  * @dev Crowdsale is a base contract for managing a token crowdsale.
965  * Crowdsales have a start and end block, where investors can make
966  * token purchases and the crowdsale will assign them tokens based
967  * on a token per ETH rate. Funds collected are forwarded to a wallet 
968  * as they arrive.
969  */
970 contract Crowdsale {
971   using SafeMath for uint256;
972 
973   // The token being sold
974   SwarmToken public token;
975 
976   // start and end time where investments are allowed (both inclusive)
977   uint256 public startTime;
978   uint256 public endTime;
979 
980   // address where funds are collected
981   address public wallet;
982 
983   // Initial rate of how many tokens a buyer gets per ETH the send in.
984   uint256 public rate;
985 
986   // amount of raised ETH in wei
987   uint256 public weiRaised;
988 
989   /**
990    * event for token purchase logging
991    * @param purchaser who paid for the tokens
992    * @param beneficiary who got the tokens
993    * @param value weis paid for purchase
994    * @param amount amount of tokens purchased
995    */ 
996   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
997 
998   /**
999    * Constructor to save off args defining the sale.
1000    */
1001   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _token) {
1002     require(_startTime >= block.timestamp);
1003     require(_endTime >= _startTime);
1004     require(_rate > 0);
1005     require(_wallet != 0x0);
1006 
1007 
1008     startTime = _startTime;
1009     endTime = _endTime;
1010     rate = _rate;
1011     wallet = _wallet;
1012     token = SwarmToken(_token);
1013   }
1014 
1015   // fallback function can be used to buy tokens
1016   function () payable {
1017     buyTokens(msg.sender);
1018   }
1019 
1020   // low level token purchase function
1021   function buyTokens(address beneficiary) payable;
1022 
1023   // send ether to the fund collection wallet
1024   // override to create custom fund forwarding mechanisms
1025   function forwardFunds() internal {
1026     wallet.transfer(msg.value);
1027   }
1028 
1029   // @return true if the transaction can buy tokens
1030   function validPurchase() internal constant returns (bool) {
1031     uint256 current = block.timestamp;
1032     bool withinPeriod = current >= startTime && current <= endTime;
1033     bool nonZeroPurchase = msg.value != 0;
1034     return withinPeriod && nonZeroPurchase;
1035   }
1036 
1037   // @return true if crowdsale event has ended
1038   function hasEnded() public constant returns (bool) {
1039     return block.timestamp > endTime;
1040   }
1041 }
1042 
1043 /**
1044  * @title FinalizableCrowdsale
1045  * @dev Extension of Crowsdale where an owner can do extra work
1046  * after finishing. By default, it will end token minting.
1047  */
1048 contract FinalizableCrowdsale is Crowdsale, Pausable {
1049   using SafeMath for uint256;
1050 
1051   bool public isFinalized = false;
1052 
1053   event Finalized();
1054 
1055   /**
1056    * Pass through constructor to parents.
1057    */
1058   function FinalizableCrowdsale (
1059     uint256 _startTime,
1060     uint256 _endTime,
1061     uint256 _rate,
1062     address _wallet,
1063     address _token
1064   )
1065     Crowdsale(_startTime, _endTime, _rate, _wallet, _token)
1066     Ownable()
1067   {
1068   }
1069 
1070   // should be called after crowdsale ends, to do
1071   // some extra finalization work
1072   function finalize() onlyOwner {
1073     require(!isFinalized);
1074     require(hasEnded());
1075 
1076     // Set the flag to prevent another finalization
1077     isFinalized = true;
1078 
1079     // Call the finalization function in the implementing class.
1080     finalization();
1081 
1082     // Trigger the finalized event.
1083     Finalized();
1084   }
1085 
1086   // end token minting on finalization
1087   // override this with custom logic if needed
1088   function finalization() internal;
1089 
1090 }
1091 
1092 /**
1093  * @title SwarmCrowdsale
1094  * @dev SwarmCrowdsale is a contract for managing a token crowdsale.
1095  * Crowdsales have a start and end time stamp, where investors can make
1096  * token purchases and the crowdsale will assign them tokens based
1097  * on a token per ETH rate. Funds collected are forwarded to a wallet
1098  * as they arrive.
1099  * 
1100  * Time values are in seconds since unix epoch.
1101  *
1102  * Rate is initial value of ETH in USD.  Each token starts out costing approx 1 USD and increases
1103  * as tokens are sold.  rate = USD price of ETH (e.g. "300")
1104  *
1105  * Wallet is the address where all incoming funds will be forwarded.  Should be a multisig for security.
1106  *
1107  * @author poole_party via tokensoft.io
1108  */
1109 contract SwarmCrowdsale is FinalizableCrowdsale {
1110   using SafeMath for uint256;  
1111 
1112   // The amount of tokens sold during the crowdsale
1113   uint256 public baseTokensSold = 0;
1114 
1115   // Token base units are 18 decimals
1116   uint256 constant TOKEN_DECIMALS = 10**18;
1117 
1118   // Target tokens sold is 33 million
1119   uint256 constant TOKEN_TARGET_SOLD = 33333333 * TOKEN_DECIMALS;
1120 
1121   // Cap on the crowdsale for number of tokens - 33,333,333 tokens
1122   uint256 constant MAX_TOKEN_SALE_CAP = 33333333 * TOKEN_DECIMALS;
1123 
1124   bool public initialized = false;
1125 
1126   /**
1127    * Pass through constructor to parent.
1128    */
1129   function SwarmCrowdsale (
1130     uint256 _startTime,
1131     uint256 _endTime,
1132     uint256 _rate,
1133     address _wallet,
1134     address _token,
1135     uint256 _baseTokensSold
1136   )
1137     FinalizableCrowdsale(_startTime, _endTime, _rate, _wallet, _token)
1138   {
1139     baseTokensSold = _baseTokensSold;
1140   }
1141 
1142   /**
1143   * Allows any pre-allocations to bet set for presale purchases or team member allocations.
1144   */
1145   function presaleMint(address _to, uint256 _amt) onlyOwner {
1146     require(!initialized);
1147 
1148     token.mint(_to, _amt);
1149   }
1150 
1151   /**
1152   * Allows a list of pre-allocations to bet set for presale purchases or team member allocations.
1153   */
1154   function multiPresaleMint(address[] _toArray, uint256[] _amtArray) onlyOwner {
1155     require(!initialized);
1156 
1157     // Ensure the array has items
1158     require(_toArray.length > 0);
1159 
1160     // Ensure the arrays are the same length
1161     require(_toArray.length == _amtArray.length);
1162 
1163     // Iterate over the 
1164     for (uint i = 0; i < _toArray.length; i++) {
1165       token.mint(_toArray[i], _amtArray[i]);
1166     }    
1167   }
1168 
1169   /**
1170   * Sets the intitialized flag to true so that the presale can start and minting is finished
1171   */
1172   function initializeToken() onlyOwner {
1173     // Allow this to only be called once by the owner.
1174     require(!initialized);
1175     initialized = true;
1176   }
1177 
1178   /**
1179   * Allows the owner to set the tokens sold, based on the number of presale purchases
1180   */
1181   function setBaseTokensSold(uint256 _baseTokensSold) onlyOwner {
1182     baseTokensSold = _baseTokensSold;
1183   }
1184 
1185   /**
1186    * Function to allow users to purchase tokens based on the calculated sale rate.
1187    */
1188   function buyTokens(address beneficiary) public payable whenNotPaused {
1189     require(beneficiary != 0x0);
1190     require(validPurchase());
1191     require(initialized);
1192 
1193     uint256 weiAmount = msg.value;
1194 
1195     // Calculate token amount to be created.
1196     // Uses dynamic price calculator based on current number of sold tokens.
1197     uint256 tokens = weiAmount.mul(getSaleRate(baseTokensSold));
1198 
1199     // update state
1200     weiRaised = weiRaised.add(weiAmount);
1201     baseTokensSold = baseTokensSold.add(tokens);
1202 
1203     // Enforce the cap on the crowd sale - do not allow a sale to go over the max
1204     require(baseTokensSold <= MAX_TOKEN_SALE_CAP);
1205 
1206     // Mint the tokens for the purchaser
1207     token.mint(beneficiary, tokens);    
1208     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
1209     
1210     forwardFunds();
1211   }
1212 
1213   /**
1214     * Overrides Base Function.
1215     * Take any finalization actions here
1216     * Ends token minting on finalization
1217     */
1218     function finalization() internal whenNotPaused {
1219 
1220       // Handle unsold token logic
1221       transferUnallocatedTokens();
1222 
1223       // Complete minting and start vesting of token
1224       token.finishMinting();
1225 
1226       // Transfer ownership to the wallet
1227       token.changeController(wallet);
1228     }
1229 
1230     /**
1231      * According to the terms of the sale, a minimum of 33 million tokens are to allocated for the crowd sale.
1232      * If the public does not buy 33 million tokens then the amount sold is subtracted from 33 million and allocated to the Swarm Foundation.
1233      * This function will mint any remaining tokens of the 33 minimum to the "wallet" account.
1234      */
1235     function transferUnallocatedTokens() internal {      
1236 
1237       // If the minimum amount sold was met, then take no action
1238       if (baseTokensSold > TOKEN_TARGET_SOLD) {
1239         return;
1240       }
1241 
1242       // Minimum tokens were not sold.  Get the amount to transfer and assign to wallet address.
1243       uint256 amountToTransfer = TOKEN_TARGET_SOLD.sub(baseTokensSold);
1244       token.mint(wallet, amountToTransfer);
1245     }
1246 
1247   /**
1248     * Gets the current price of the tokens based on the current sold amount (currentBaseTokensSold).
1249     * The variable "rate" from the base class is the initial purchase multiplier.
1250     * As new tokens get purchased, the price increases according the the algorithm outlined in the whitepaper.
1251     * Each generation you will get less tokens per ETH sent in.
1252     * param - uint256 currentTokensSold Amount of tokens already sold in "base units".
1253     * returns - uint256 Current number of tokens you get for each ETH sent in.
1254     */
1255   function getSaleRate(uint256 currentBaseTokensSold) public constant returns (uint256) {
1256 
1257     // Base units per token
1258     uint decimals = TOKEN_DECIMALS;
1259 
1260     // Get the whole units of tokens sold
1261     uint256 wholeTokensSold = currentBaseTokensSold.div(decimals);
1262 
1263     // Get the current generation of the token sale.  Each gen is 1 million whole tokens.
1264     uint256 generation = wholeTokensSold.div(10**6);
1265 
1266     // Init the price multiplier at 0.  It should always go through the loop below at least once.
1267     uint256 priceMultiplier = 0;
1268 
1269     // Each generation adds on a price premium that decreases with each generation.
1270     for (uint i = 0; i <= generation; i++) {
1271 
1272       // The multiplier is calculated at 10^18 units since uint256 can't handle decimals.
1273       priceMultiplier = priceMultiplier.add(decimals.div(1 + i));
1274     }
1275 
1276     // Return the initial rate divided by the multiplier.
1277     // To ensure int division doesn't truncate, using rate * 10^18 in numerator.      
1278     // If initial rate is 300 then the second generation should return => 300*10^18 / 1.5*10^18  => 200 (e.g less tokens per ETH the second gen)
1279     return rate.mul(decimals).div(priceMultiplier);
1280   }
1281 
1282   /**
1283    * Convenience method for users.
1284    */
1285   function getCurrentSaleRate() public constant returns (uint256) {
1286     return getSaleRate(baseTokensSold);
1287   }
1288 }