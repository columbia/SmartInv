1 pragma solidity ^0.4.4;
2 
3 /*
4     Copyright 2016, Jordi Baylina
5 
6     This program is free software: you can redistribute it and/or modify
7     it under the terms of the GNU General Public License as published by
8     the Free Software Foundation, either version 3 of the License, or
9     (at your option) any later version.
10 
11     This program is distributed in the hope that it will be useful,
12     but WITHOUT ANY WARRANTY; without even the implied warranty of
13     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14     GNU General Public License for more details.
15 
16     You should have received a copy of the GNU General Public License
17     along with this program.  If not, see <http://www.gnu.org/licenses/>.
18  */
19 
20 /// @title MiniMeToken Contract
21 /// @author Jordi Baylina
22 /// @dev This token contract's goal is to make it easy to clone this token and
23 ///  spawn new tokens using the token distribution at a given block.
24 /// @dev It is ERC20 compliant, but still needs to under go further testing.
25 
26 
27 // The controller must implement this interface
28 contract TokenController {
29     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
30     /// @param _owner The address that sent the ether
31     /// @return True if the ether is accepted, false if it throws
32     function proxyPayment(address _owner) payable returns(bool);
33 
34     /// @notice Notifies the controller about a transfer
35     /// @param _from The origin of the transfer
36     /// @param _to The destination of the transfer
37     /// @param _amount The amount of the transfer
38     /// @return False if the controller does not authorize the transfer
39     function onTransfer(address _from, address _to, uint _amount) returns(bool);
40 
41     /// @notice Notifies the controller about an approval
42     /// @param _owner The address that calls `approve()`
43     /// @param _spender The spender in the `approve()` call
44     /// @param _amount The ammount in the `approve()` call
45     /// @return False if the controller does not authorize the approval
46     function onApprove(address _owner, address _spender, uint _amount)
47         returns(bool);
48 }
49 
50 contract Controlled {
51     /// @notice The address of the controller is the only address that can call
52     ///  a function with this modifier
53     modifier onlyController { if (msg.sender != controller) throw; _; }
54 
55     address public controller;
56 
57     function Controlled() { controller = msg.sender;}
58 
59     /// @notice Changes the controller of the contract
60     /// @param _newController The new controller of the contract
61     function changeController(address _newController) onlyController {
62         controller = _newController;
63     }
64 }
65 
66 contract MiniMeToken is Controlled {
67 
68     string public name;                //The Token's name: e.g. DigixDAO Tokens
69     uint8 public decimals;             //Number of decimals of the smallest unit
70     string public symbol;              //An identifier: e.g. REP
71     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
72 
73 
74     /// @dev `Checkpoint` is the structure that attaches a block number to the a
75     ///  given value
76     struct  Checkpoint {
77 
78         // `fromBlock` is the block number that the value was generated from
79         uint128 fromBlock;
80 
81         // `value` is the amount of tokens at a specific block number
82         uint128 value;
83     }
84 
85     // `parentToken` is the Token address that was cloned to produce this token;
86     //  it will be 0x0 for a token that was not cloned
87     MiniMeToken public parentToken;
88 
89     // `parentSnapShotBlock` is the Block number from the Parent Token that was
90     //  used to determine the initial distribution of the Clone Token
91     uint public parentSnapShotBlock;
92 
93     // `creationBlock` is the block number that the Clone Token was created
94     uint public creationBlock;
95 
96     // `balances` is the map that tracks the balance of each address
97     mapping (address => Checkpoint[]) balances;
98 
99     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
100     mapping (address => mapping (address => uint256)) allowed;
101 
102     // Tracks the history of the `totalSupply` of the token
103     Checkpoint[] totalSupplyHistory;
104 
105     // Flag that determines if the token is transferable or not.
106     bool public transfersEnabled;
107 
108     // The factory used to create new clone tokens
109     MiniMeTokenFactory public tokenFactory;
110 
111 ////////////////
112 // Constructor
113 ////////////////
114 
115     /// @notice Constructor to create a MiniMeToken
116     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
117     ///  will create the Clone token contracts
118     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
119     ///  new token
120     /// @param _parentSnapShotBlock Block of the parent token that will
121     ///  determine the initial distribution of the clone token, set to 0 if it
122     ///  is a new token
123     /// @param _tokenName Name of the new token
124     /// @param _decimalUnits Number of decimals of the new token
125     /// @param _tokenSymbol Token Symbol for the new token
126     /// @param _transfersEnabled If true, tokens will be able to be transferred
127     function MiniMeToken(
128         address _tokenFactory,
129         address _parentToken,
130         uint _parentSnapShotBlock,
131         string _tokenName,
132         uint8 _decimalUnits,
133         string _tokenSymbol,
134         bool _transfersEnabled
135     ) {
136         tokenFactory = MiniMeTokenFactory(_tokenFactory);
137         name = _tokenName;                                 // Set the name
138         decimals = _decimalUnits;                          // Set the decimals
139         symbol = _tokenSymbol;                             // Set the symbol
140         parentToken = MiniMeToken(_parentToken);
141         parentSnapShotBlock = _parentSnapShotBlock;
142         transfersEnabled = _transfersEnabled;
143         creationBlock = block.number;
144     }
145 
146 
147 ///////////////////
148 // ERC20 Methods
149 ///////////////////
150 
151     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
152     /// @param _to The address of the recipient
153     /// @param _amount The amount of tokens to be transferred
154     /// @return Whether the transfer was successful or not
155     function transfer(address _to, uint256 _amount) returns (bool success) {
156         if (!transfersEnabled) throw;
157         return doTransfer(msg.sender, _to, _amount);
158     }
159 
160     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
161     ///  is approved by `_from`
162     /// @param _from The address holding the tokens being transferred
163     /// @param _to The address of the recipient
164     /// @param _amount The amount of tokens to be transferred
165     /// @return True if the transfer was successful
166     function transferFrom(address _from, address _to, uint256 _amount
167     ) returns (bool success) {
168 
169         // The controller of this contract can move tokens around at will, this
170         //  is important to recognize! Confirm that you trust the controller of
171         //  this contract, which in most situations should be another open
172         //  source smart contract or 0x0
173         if (msg.sender != controller) {
174             if (!transfersEnabled) throw;
175 
176             // The standard ERC 20 transferFrom functionality
177             if (allowed[_from][msg.sender] < _amount) return false;
178             allowed[_from][msg.sender] -= _amount;
179         }
180         return doTransfer(_from, _to, _amount);
181     }
182 
183     function doTransfer(address _from, address _to, uint _amount
184     ) internal returns(bool) {
185 
186            if (_amount == 0) {
187                return true;
188            }
189 
190            // Do not allow transfer to 0x0 or the token contract itself
191            if ((_to == 0) || (_to == address(this))) throw;
192 
193            // If the amount being transfered is more than the balance of the
194            //  account the transfer returns false
195            var previousBalanceFrom = balanceOfAt(_from, block.number);
196            if (previousBalanceFrom < _amount) {
197                return false;
198            }
199 
200            if ((controller != 0)&&(isContract(controller))) {
201                if (!TokenController(controller).onTransfer(_from, _to, _amount))
202                throw;
203            }
204 
205            // First update the balance array with the new value for the address
206            //  sending the tokens
207            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
208 
209            // Then update the balance array with the new value for the address
210            //  receiving the tokens
211            var previousBalanceTo = balanceOfAt(_to, block.number);
212            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
213 
214            // An event to make the transfer easy to find on the blockchain
215            Transfer(_from, _to, _amount);
216 
217            return true;
218     }
219 
220     /// @param _owner The address that's balance is being requested
221     /// @return The balance of `_owner` at the current block
222     function balanceOf(address _owner) constant returns (uint256 balance) {
223         return balanceOfAt(_owner, block.number);
224     }
225 
226     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
227     ///  its behalf
228     /// @param _spender The address of the account able to transfer the tokens
229     /// @param _amount The amount of tokens to be approved for transfer
230     /// @return True if the approval was successful
231     function approve(address _spender, uint256 _amount) returns (bool success) {
232         if (!transfersEnabled) throw;
233 
234         // To change the approve amount you first have to reduce the addresses´
235         // allowance to zero by calling `approve(_spender,0)` if it is not
236         // already 0 https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237         if ((_amount!=0) && (allowed[msg.sender][_spender] !=0)) throw;
238 
239         if ((controller != 0)&&(isContract(controller))) {
240             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
241                 throw;
242         }
243 
244         allowed[msg.sender][_spender] = _amount;
245         Approval(msg.sender, _spender, _amount);
246         return true;
247     }
248 
249     /// @param _owner The address of the account that owns the token
250     /// @param _spender The address of the account able to transfer the tokens
251     /// @return Amount of remaining tokens of _owner that _spender is allowed
252     ///  to spend
253     function allowance(address _owner, address _spender
254     ) constant returns (uint256 remaining) {
255         return allowed[_owner][_spender];
256     }
257 
258     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
259     ///  its behalf, and then a function is triggered in the contract that is
260     ///  being approved, `_spender`
261     /// @param _spender The address of the contract able to transfer the tokens
262     /// @param _amount The amount of tokens to be approved for transfer
263     /// @return True if the function call was successful
264     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
265     ) returns (bool success) {
266         allowed[msg.sender][_spender] = _amount;
267         Approval(msg.sender, _spender, _amount);
268 
269         // This portion is copied from ConsenSys's Standard Token Contract. It
270         //  calls the receiveApproval function that is part of the contract that
271         //  is being approved (`_spender`). The function should look like:
272         //  `receiveApproval(address _from, uint256 _amount, address
273         //  _tokenContract, bytes _extraData)` It is assumed that the call
274         //  *should* succeed, otherwise one would use vanilla approve instead.
275         if(!_spender.call(
276             bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))),
277             msg.sender,
278             _amount,
279             this,
280             _extraData
281             )) { throw;
282         }
283         return true;
284     }
285 
286     /// @return The total amount of tokens
287     function totalSupply() constant returns (uint) {
288         return totalSupplyAt(block.number);
289     }
290 
291 
292 ////////////////
293 // Query balance and totalSupply in History
294 ////////////////
295 
296     /// @notice Queries the balance of `_owner` at a specific `_blockNumber`
297     /// @param _owner The address from which the balance will be retrieved
298     /// @param _blockNumber The block number when the balance is queried
299     /// @return The balance at `_blockNumber`
300     function balanceOfAt(address _owner, uint _blockNumber) constant
301         returns (uint) {
302 
303         // If the `_blockNumber` requested is before the genesis block for the
304         //  the token being queried, the value returned is 0
305         if (_blockNumber < creationBlock) {
306             return 0;
307 
308         // These next few lines are used when the balance of the token is
309         //  requested before a check point was ever created for this token, it
310         //  requires that the `parentToken.balanceOfAt` be queried at the
311         //  genesis block for that token as this contains initial balance of
312         //  this token
313         } else if ((balances[_owner].length == 0)
314             || (balances[_owner][0].fromBlock > _blockNumber)) {
315             if (address(parentToken) != 0) {
316                 return parentToken.balanceOfAt(_owner, parentSnapShotBlock);
317             } else {
318                 // Has no parent
319                 return 0;
320             }
321 
322         // This will return the expected balance during normal situations
323         } else {
324             return getValueAt( balances[_owner], _blockNumber);
325         }
326 
327     }
328 
329     /// @notice Total amount of tokens at a specific `_blockNumber`.
330     /// @param _blockNumber The block number when the totalSupply is queried
331     /// @return The total amount of tokens at `_blockNumber`
332     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
333 
334         // If the `_blockNumber` requested is before the genesis block for the
335         //  the token being queried, the value returned is 0
336         if (_blockNumber < creationBlock) {
337             return 0;
338 
339         // These next few lines are used when the totalSupply of the token is
340         //  requested before a check point was ever created for this token, it
341         //  requires that the `parentToken.totalSupplyAt` be queried at the
342         //  genesis block for this token as that contains totalSupply of this
343         //  token at this block number.
344         } else if ((totalSupplyHistory.length == 0)
345             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
346             if (address(parentToken) != 0) {
347                 return parentToken.totalSupplyAt(parentSnapShotBlock);
348             } else {
349                 return 0;
350             }
351 
352         // This will return the expected totalSupply during normal situations
353         } else {
354             return getValueAt( totalSupplyHistory, _blockNumber);
355         }
356     }
357 
358 ////////////////
359 // Clone Token Method
360 ////////////////
361 
362     /// @notice Creates a new clone token with the initial distribution being
363     ///  this token at `_snapshotBlock`
364     /// @param _cloneTokenName Name of the clone token
365     /// @param _cloneDecimalUnits Units of the clone token
366     /// @param _cloneTokenSymbol Symbol of the clone token
367     /// @param _snapshotBlock Block when the distribution of the parent token is
368     ///  copied to set the initial distribution of the new clone token;
369     ///  if the block is higher than the actual block, the current block is used
370     /// @param _transfersEnabled True if transfers are allowed in the clone
371     /// @return The address of the new MiniMeToken Contract
372     function createCloneToken(
373         string _cloneTokenName,
374         uint8 _cloneDecimalUnits,
375         string _cloneTokenSymbol,
376         uint _snapshotBlock,
377         bool _transfersEnabled
378         ) returns(address) {
379         if (_snapshotBlock > block.number) _snapshotBlock = block.number;
380         MiniMeToken cloneToken = tokenFactory.createCloneToken(
381             this,
382             _snapshotBlock,
383             _cloneTokenName,
384             _cloneDecimalUnits,
385             _cloneTokenSymbol,
386             _transfersEnabled
387             );
388 
389         cloneToken.changeController(msg.sender);
390 
391         // An event to make the token easy to find on the blockchain
392         NewCloneToken(address(cloneToken), _snapshotBlock);
393         return address(cloneToken);
394     }
395 
396 ////////////////
397 // Generate and destroy tokens
398 ////////////////
399 
400     /// @notice Generates `_amount` tokens that are assigned to `_owner`
401     /// @param _owner The address that will be assigned the new tokens
402     /// @param _amount The quantity of tokens generated
403     /// @return True if the tokens are generated correctly
404     function generateTokens(address _owner, uint _amount
405     ) onlyController returns (bool) {
406         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
407         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
408         var previousBalanceTo = balanceOf(_owner);
409         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
410         Transfer(0, _owner, _amount);
411         return true;
412     }
413 
414 
415     /// @notice Burns `_amount` tokens from `_owner`
416     /// @param _owner The address that will lose the tokens
417     /// @param _amount The quantity of tokens to burn
418     /// @return True if the tokens are burned correctly
419     function destroyTokens(address _owner, uint _amount
420     ) onlyController returns (bool) {
421         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
422         if (curTotalSupply < _amount) throw;
423         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
424         var previousBalanceFrom = balanceOf(_owner);
425         if (previousBalanceFrom < _amount) throw;
426         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
427         Transfer(_owner, 0, _amount);
428         return true;
429     }
430 
431 ////////////////
432 // Enable tokens transfers
433 ////////////////
434 
435 
436     /// @notice Enables token holders to transfer their tokens freely if true
437     /// @param _transfersEnabled True if transfers are allowed in the clone
438     function enableTransfers(bool _transfersEnabled) onlyController {
439         transfersEnabled = _transfersEnabled;
440     }
441 
442 ////////////////
443 // Internal helper functions to query and set a value in a snapshot array
444 ////////////////
445 
446     function getValueAt(Checkpoint[] storage checkpoints, uint _block
447     ) constant internal returns (uint) {
448         if (checkpoints.length == 0) return 0;
449         // Shortcut for the actual value
450         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
451             return checkpoints[checkpoints.length-1].value;
452         if (_block < checkpoints[0].fromBlock) return 0;
453 
454         // Binary search of the value in the array
455         uint min = 0;
456         uint max = checkpoints.length-1;
457         while (max > min) {
458             uint mid = (max + min + 1)/ 2;
459             if (checkpoints[mid].fromBlock<=_block) {
460                 min = mid;
461             } else {
462                 max = mid-1;
463             }
464         }
465         return checkpoints[min].value;
466     }
467 
468     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
469     ) internal  {
470         if ((checkpoints.length == 0)
471         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
472                Checkpoint newCheckPoint = checkpoints[ checkpoints.length++ ];
473                newCheckPoint.fromBlock =  uint128(block.number);
474                newCheckPoint.value = uint128(_value);
475            } else {
476                Checkpoint oldCheckPoint = checkpoints[checkpoints.length-1];
477                oldCheckPoint.value = uint128(_value);
478            }
479     }
480 
481     // Internal function to determine if an address is a cntract
482     function isContract(address _addr) constant internal returns(bool) {
483         uint size;
484         assembly {
485             size := extcodesize(_addr)
486         }
487         return size>0;
488     }
489 
490     /// @notice The fallback function: If the contract's controller has not been
491     /// set to 0, the ether is sent to the controller (normally the token
492     /// creation contract) using the `proxyPayment` method.
493     function ()  payable {
494         if (controller == 0) throw;
495         if (isContract(controller)) {
496             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
497                 throw;
498         } else {
499             if (! controller.send(msg.value)) throw;
500         }
501     }
502 
503 
504 ////////////////
505 // Events
506 ////////////////
507     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
508     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
509     event Approval(
510         address indexed _owner,
511         address indexed _spender,
512         uint256 _amount
513         );
514 
515 }
516 
517 
518 ////////////////
519 // MiniMeTokenFactory
520 ////////////////
521 
522 // This contract is used to generate clone contracts from a contract.
523 // In solidity this is the way to create a contract from a contract of the same
524 //  class
525 contract MiniMeTokenFactory {
526     function createCloneToken(
527         address _parentToken,
528         uint _snapshotBlock,
529         string _tokenName,
530         uint8 _decimalUnits,
531         string _tokenSymbol,
532         bool _transfersEnabled
533     ) returns (MiniMeToken) {
534         MiniMeToken newToken = new MiniMeToken(
535             this,
536             _parentToken,
537             _snapshotBlock,
538             _tokenName,
539             _decimalUnits,
540             _tokenSymbol,
541             _transfersEnabled
542             );
543 
544         newToken.changeController(msg.sender);
545         return newToken;
546     }
547 }
548 
549 
550 contract Owned {
551     /// Prevents methods from perfoming any value transfer
552     modifier noEther() {if (msg.value > 0) throw; _; }
553     /// Allows only the owner to call a function
554     modifier onlyOwner { if (msg.sender != owner) throw; _; }
555 
556     address owner;
557 
558     function Owned() { owner = msg.sender;}
559 
560 
561 
562     function changeOwner(address _newOwner) onlyOwner {
563         owner = _newOwner;
564     }
565 
566     function getOwner() noEther constant returns (address) {
567         return owner;
568     }
569 }
570 
571 
572 /// @title CampaignToken Contract
573 /// @author Jordi Baylina
574 /// @dev This is designed to control the ChairtyToken contract.
575 
576 contract Campaign is TokenController, Owned {
577 
578     uint public startFundingTime;       // In UNIX Time Format
579     uint public endFundingTime;         // In UNIX Time Format
580     uint public maximumFunding;         // In wei
581     uint public totalCollected;         // In wei
582     MiniMeToken public tokenContract;  // The new token for this Campaign
583     address public vaultAddress;       // The address to hold the funds donated
584 
585 /// @notice 'Campaign()' initiates the Campaign by setting its funding
586 /// parameters and creating the deploying the token contract
587 /// @dev There are several checks to make sure the parameters are acceptable
588 /// @param _startFundingTime The UNIX time that the Campaign will be able to
589 /// start receiving funds
590 /// @param _endFundingTime The UNIX time that the Campaign will stop being able
591 /// to receive funds
592 /// @param _maximumFunding In wei, the Maximum amount that the Campaign can
593 /// receive (currently the max is set at 10,000 ETH for the beta)
594 /// @param _vaultAddress The address that will store the donated funds
595 /// @param _tokenAddress Address of the token contract
596 
597     function Campaign(
598         uint _startFundingTime,
599         uint _endFundingTime,
600         uint _maximumFunding,
601         address _vaultAddress,
602         address _tokenAddress
603     ) {
604         if ((_endFundingTime < now) ||                // Cannot start in the past
605             (_endFundingTime <= _startFundingTime) ||
606             (_maximumFunding > 10000 ether) ||        // The Beta is limited
607             (_vaultAddress == 0))                    // To prevent burning ETH
608             {
609             throw;
610             }
611         startFundingTime = _startFundingTime;
612         endFundingTime = _endFundingTime;
613         maximumFunding = _maximumFunding;
614         tokenContract = MiniMeToken(_tokenAddress); // Deploys the Token Contract
615         vaultAddress = _vaultAddress;
616     }
617 
618 /// @dev The fallback function is called when ether is sent to the contract, it
619 /// simply calls `doPayment()` with the address that sent the ether as the
620 /// `_owner`. Payable is a required solidity modifier for functions to receive
621 /// ether, without this modifier they will throw
622 
623     function ()  payable {
624         doPayment(msg.sender);
625     }
626 
627 /////////////////
628 // TokenController interface
629 /////////////////
630 
631 /// @notice `proxyPayment()` allows the caller to send ether to the Campaign and
632 /// have the CampaignTokens created in an address of their choosing
633 /// @param _owner The address that will hold the newly created CampaignTokens
634 
635     function proxyPayment(address _owner) payable returns(bool) {
636         doPayment(_owner);
637         return true;
638     }
639 
640 /// @notice Notifies the controller about a transfer
641 /// @param _from The origin of the transfer
642 /// @param _to The destination of the transfer
643 /// @param _amount The amount of the transfer
644 /// @return False if the controller does not authorize the transfer
645     function onTransfer(address _from, address _to, uint _amount) returns(bool) {
646         return true;
647     }
648 
649 /// @notice Notifies the controller about an approval
650 /// @param _owner The address that calls `approve()`
651 /// @param _spender The spender in the `approve()` call
652 /// @param _amount The ammount in the `approve()` call
653 /// @return False if the controller does not authorize the approval
654     function onApprove(address _owner, address _spender, uint _amount)
655         returns(bool)
656     {
657         return true;
658     }
659 
660 
661 /// @dev `doPayment()` is an internal function that sends the ether that this
662 /// contract receives to the `vault` and creates campaignTokens in the
663 /// address of the `_owner` assuming the Campaign is still accepting funds
664 /// @param _owner The address that will hold the newly created CampaignTokens
665 
666     function doPayment(address _owner) internal {
667 
668 // First we check that the Campaign is allowed to receive this donation
669         if ((now<startFundingTime) ||
670             (now>endFundingTime) ||
671             (tokenContract.controller() == 0) ||           // Extra check
672             (msg.value == 0) ||
673             (totalCollected + msg.value > maximumFunding))
674         {
675             throw;
676         }
677 
678 //Track how much the Campaign has collected
679         totalCollected += msg.value;
680 
681 //Send the ether to the vault
682         if (!vaultAddress.send(msg.value)) {
683             throw;
684         }
685 
686 // Creates an equal amount of CampaignTokens as ether sent. The new CampaignTokens
687 // are created in the `_owner` address
688         if (!tokenContract.generateTokens(_owner, msg.value)) {
689             throw;
690         }
691 
692         return;
693     }
694 
695 /// @notice `finalizeFunding()` ends the Campaign by calling removing himself
696 /// as a controller.
697 /// @dev `finalizeFunding()` can only be called after the end of the funding period.
698 
699     function finalizeFunding() {
700         if (now < endFundingTime) throw;
701         tokenContract.changeController(0);
702     }
703 
704 ////////////
705 // Initial import from the old token
706 ////////////
707 
708     bool public sealed;
709 
710 
711     function fill(uint[] data) onlyOwner {
712         if (sealed)
713             throw;
714 
715         for (uint i=0; i< data.length; i+= 2) {
716             address dth = address(data[i]);
717             uint amount = uint(data[i+1]);
718             if (!tokenContract.generateTokens(dth, amount)) {
719                 throw;
720             }
721             totalCollected += amount;
722         }
723     }
724 
725     function seal() {
726         if (sealed)
727             throw;
728 
729         sealed= true;
730     }
731 
732     function setVault(address _newVaultAddress) onlyOwner {
733         vaultAddress = _newVaultAddress;
734     }
735 
736 }