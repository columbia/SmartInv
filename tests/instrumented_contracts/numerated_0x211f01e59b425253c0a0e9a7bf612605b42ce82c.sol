1 /**
2  *  @title Kleros
3  *  @author Clément Lesaege - <clement@lesaege.com>
4  *  This code implements a simple version of Kleros.
5  *  Bug Bounties: This code hasn't undertaken a bug bounty program yet.
6  */
7 
8 pragma solidity ^0.4.24;
9 
10 
11 contract ApproveAndCallFallBack {
12     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
13 }
14 
15 /// @dev The token controller contract must implement these functions
16 contract TokenController {
17     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
18     /// @param _owner The address that sent the ether to create tokens
19     /// @return True if the ether is accepted, false if it throws
20     function proxyPayment(address _owner) public payable returns(bool);
21 
22     /// @notice Notifies the controller about a token transfer allowing the
23     ///  controller to react if desired
24     /// @param _from The origin of the transfer
25     /// @param _to The destination of the transfer
26     /// @param _amount The amount of the transfer
27     /// @return False if the controller does not authorize the transfer
28     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
29 
30     /// @notice Notifies the controller about an approval allowing the
31     ///  controller to react if desired
32     /// @param _owner The address that calls `approve()`
33     /// @param _spender The spender in the `approve()` call
34     /// @param _amount The amount in the `approve()` call
35     /// @return False if the controller does not authorize the approval
36     function onApprove(address _owner, address _spender, uint _amount) public
37         returns(bool);
38 }
39 
40 contract Controlled {
41     /// @notice The address of the controller is the only address that can call
42     ///  a function with this modifier
43     modifier onlyController { require(msg.sender == controller); _; }
44 
45     address public controller;
46 
47     function Controlled() public { controller = msg.sender;}
48 
49     /// @notice Changes the controller of the contract
50     /// @param _newController The new controller of the contract
51     function changeController(address _newController) public onlyController {
52         controller = _newController;
53     }
54 }
55 
56 /// @dev The actual token contract, the default controller is the msg.sender
57 ///  that deploys the contract, so usually this token will be deployed by a
58 ///  token controller contract, which Giveth will call a "Campaign"
59 contract Pinakion is Controlled {
60 
61     string public name;                //The Token's name: e.g. DigixDAO Tokens
62     uint8 public decimals;             //Number of decimals of the smallest unit
63     string public symbol;              //An identifier: e.g. REP
64     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
65 
66 
67     /// @dev `Checkpoint` is the structure that attaches a block number to a
68     ///  given value, the block number attached is the one that last changed the
69     ///  value
70     struct  Checkpoint {
71 
72         // `fromBlock` is the block number that the value was generated from
73         uint128 fromBlock;
74 
75         // `value` is the amount of tokens at a specific block number
76         uint128 value;
77     }
78 
79     // `parentToken` is the Token address that was cloned to produce this token;
80     //  it will be 0x0 for a token that was not cloned
81     Pinakion public parentToken;
82 
83     // `parentSnapShotBlock` is the block number from the Parent Token that was
84     //  used to determine the initial distribution of the Clone Token
85     uint public parentSnapShotBlock;
86 
87     // `creationBlock` is the block number that the Clone Token was created
88     uint public creationBlock;
89 
90     // `balances` is the map that tracks the balance of each address, in this
91     //  contract when the balance changes the block number that the change
92     //  occurred is also included in the map
93     mapping (address => Checkpoint[]) balances;
94 
95     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
96     mapping (address => mapping (address => uint256)) allowed;
97 
98     // Tracks the history of the `totalSupply` of the token
99     Checkpoint[] totalSupplyHistory;
100 
101     // Flag that determines if the token is transferable or not.
102     bool public transfersEnabled;
103 
104     // The factory used to create new clone tokens
105     MiniMeTokenFactory public tokenFactory;
106 
107 ////////////////
108 // Constructor
109 ////////////////
110 
111     /// @notice Constructor to create a Pinakion
112     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
113     ///  will create the Clone token contracts, the token factory needs to be
114     ///  deployed first
115     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
116     ///  new token
117     /// @param _parentSnapShotBlock Block of the parent token that will
118     ///  determine the initial distribution of the clone token, set to 0 if it
119     ///  is a new token
120     /// @param _tokenName Name of the new token
121     /// @param _decimalUnits Number of decimals of the new token
122     /// @param _tokenSymbol Token Symbol for the new token
123     /// @param _transfersEnabled If true, tokens will be able to be transferred
124     function Pinakion(
125         address _tokenFactory,
126         address _parentToken,
127         uint _parentSnapShotBlock,
128         string _tokenName,
129         uint8 _decimalUnits,
130         string _tokenSymbol,
131         bool _transfersEnabled
132     ) public {
133         tokenFactory = MiniMeTokenFactory(_tokenFactory);
134         name = _tokenName;                                 // Set the name
135         decimals = _decimalUnits;                          // Set the decimals
136         symbol = _tokenSymbol;                             // Set the symbol
137         parentToken = Pinakion(_parentToken);
138         parentSnapShotBlock = _parentSnapShotBlock;
139         transfersEnabled = _transfersEnabled;
140         creationBlock = block.number;
141     }
142 
143 
144 ///////////////////
145 // ERC20 Methods
146 ///////////////////
147 
148     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
149     /// @param _to The address of the recipient
150     /// @param _amount The amount of tokens to be transferred
151     /// @return Whether the transfer was successful or not
152     function transfer(address _to, uint256 _amount) public returns (bool success) {
153         require(transfersEnabled);
154         doTransfer(msg.sender, _to, _amount);
155         return true;
156     }
157 
158     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
159     ///  is approved by `_from`
160     /// @param _from The address holding the tokens being transferred
161     /// @param _to The address of the recipient
162     /// @param _amount The amount of tokens to be transferred
163     /// @return True if the transfer was successful
164     function transferFrom(address _from, address _to, uint256 _amount
165     ) public returns (bool success) {
166 
167         // The controller of this contract can move tokens around at will,
168         //  this is important to recognize! Confirm that you trust the
169         //  controller of this contract, which in most situations should be
170         //  another open source smart contract or 0x0
171         if (msg.sender != controller) {
172             require(transfersEnabled);
173 
174             // The standard ERC 20 transferFrom functionality
175             require(allowed[_from][msg.sender] >= _amount);
176             allowed[_from][msg.sender] -= _amount;
177         }
178         doTransfer(_from, _to, _amount);
179         return true;
180     }
181 
182     /// @dev This is the actual transfer function in the token contract, it can
183     ///  only be called by other functions in this contract.
184     /// @param _from The address holding the tokens being transferred
185     /// @param _to The address of the recipient
186     /// @param _amount The amount of tokens to be transferred
187     /// @return True if the transfer was successful
188     function doTransfer(address _from, address _to, uint _amount
189     ) internal {
190 
191            if (_amount == 0) {
192                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
193                return;
194            }
195 
196            require(parentSnapShotBlock < block.number);
197 
198            // Do not allow transfer to 0x0 or the token contract itself
199            require((_to != 0) && (_to != address(this)));
200 
201            // If the amount being transfered is more than the balance of the
202            //  account the transfer throws
203            var previousBalanceFrom = balanceOfAt(_from, block.number);
204 
205            require(previousBalanceFrom >= _amount);
206 
207            // Alerts the token controller of the transfer
208            if (isContract(controller)) {
209                require(TokenController(controller).onTransfer(_from, _to, _amount));
210            }
211 
212            // First update the balance array with the new value for the address
213            //  sending the tokens
214            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
215 
216            // Then update the balance array with the new value for the address
217            //  receiving the tokens
218            var previousBalanceTo = balanceOfAt(_to, block.number);
219            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
220            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
221 
222            // An event to make the transfer easy to find on the blockchain
223            Transfer(_from, _to, _amount);
224 
225     }
226 
227     /// @param _owner The address that's balance is being requested
228     /// @return The balance of `_owner` at the current block
229     function balanceOf(address _owner) public constant returns (uint256 balance) {
230         return balanceOfAt(_owner, block.number);
231     }
232 
233     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
234     ///  its behalf. This is the standard version to allow backward compatibility.
235     /// @param _spender The address of the account able to transfer the tokens
236     /// @param _amount The amount of tokens to be approved for transfer
237     /// @return True if the approval was successful
238     function approve(address _spender, uint256 _amount) public returns (bool success) {
239         require(transfersEnabled);
240 
241         // Alerts the token controller of the approve function call
242         if (isContract(controller)) {
243             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
244         }
245 
246         allowed[msg.sender][_spender] = _amount;
247         Approval(msg.sender, _spender, _amount);
248         return true;
249     }
250 
251     /// @dev This function makes it easy to read the `allowed[]` map
252     /// @param _owner The address of the account that owns the token
253     /// @param _spender The address of the account able to transfer the tokens
254     /// @return Amount of remaining tokens of _owner that _spender is allowed
255     ///  to spend
256     function allowance(address _owner, address _spender
257     ) public constant returns (uint256 remaining) {
258         return allowed[_owner][_spender];
259     }
260 
261     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
262     ///  its behalf, and then a function is triggered in the contract that is
263     ///  being approved, `_spender`. This allows users to use their tokens to
264     ///  interact with contracts in one function call instead of two
265     /// @param _spender The address of the contract able to transfer the tokens
266     /// @param _amount The amount of tokens to be approved for transfer
267     /// @return True if the function call was successful
268     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
269     ) public returns (bool success) {
270         require(approve(_spender, _amount));
271 
272         ApproveAndCallFallBack(_spender).receiveApproval(
273             msg.sender,
274             _amount,
275             this,
276             _extraData
277         );
278 
279         return true;
280     }
281 
282     /// @dev This function makes it easy to get the total number of tokens
283     /// @return The total number of tokens
284     function totalSupply() public constant returns (uint) {
285         return totalSupplyAt(block.number);
286     }
287 
288 
289 ////////////////
290 // Query balance and totalSupply in History
291 ////////////////
292 
293     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
294     /// @param _owner The address from which the balance will be retrieved
295     /// @param _blockNumber The block number when the balance is queried
296     /// @return The balance at `_blockNumber`
297     function balanceOfAt(address _owner, uint _blockNumber) public constant
298         returns (uint) {
299 
300         // These next few lines are used when the balance of the token is
301         //  requested before a check point was ever created for this token, it
302         //  requires that the `parentToken.balanceOfAt` be queried at the
303         //  genesis block for that token as this contains initial balance of
304         //  this token
305         if ((balances[_owner].length == 0)
306             || (balances[_owner][0].fromBlock > _blockNumber)) {
307             if (address(parentToken) != 0) {
308                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
309             } else {
310                 // Has no parent
311                 return 0;
312             }
313 
314         // This will return the expected balance during normal situations
315         } else {
316             return getValueAt(balances[_owner], _blockNumber);
317         }
318     }
319 
320     /// @notice Total amount of tokens at a specific `_blockNumber`.
321     /// @param _blockNumber The block number when the totalSupply is queried
322     /// @return The total amount of tokens at `_blockNumber`
323     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
324 
325         // These next few lines are used when the totalSupply of the token is
326         //  requested before a check point was ever created for this token, it
327         //  requires that the `parentToken.totalSupplyAt` be queried at the
328         //  genesis block for this token as that contains totalSupply of this
329         //  token at this block number.
330         if ((totalSupplyHistory.length == 0)
331             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
332             if (address(parentToken) != 0) {
333                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
334             } else {
335                 return 0;
336             }
337 
338         // This will return the expected totalSupply during normal situations
339         } else {
340             return getValueAt(totalSupplyHistory, _blockNumber);
341         }
342     }
343 
344 ////////////////
345 // Clone Token Method
346 ////////////////
347 
348     /// @notice Creates a new clone token with the initial distribution being
349     ///  this token at `_snapshotBlock`
350     /// @param _cloneTokenName Name of the clone token
351     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
352     /// @param _cloneTokenSymbol Symbol of the clone token
353     /// @param _snapshotBlock Block when the distribution of the parent token is
354     ///  copied to set the initial distribution of the new clone token;
355     ///  if the block is zero than the actual block, the current block is used
356     /// @param _transfersEnabled True if transfers are allowed in the clone
357     /// @return The address of the new MiniMeToken Contract
358     function createCloneToken(
359         string _cloneTokenName,
360         uint8 _cloneDecimalUnits,
361         string _cloneTokenSymbol,
362         uint _snapshotBlock,
363         bool _transfersEnabled
364         ) public returns(address) {
365         if (_snapshotBlock == 0) _snapshotBlock = block.number;
366         Pinakion cloneToken = tokenFactory.createCloneToken(
367             this,
368             _snapshotBlock,
369             _cloneTokenName,
370             _cloneDecimalUnits,
371             _cloneTokenSymbol,
372             _transfersEnabled
373             );
374 
375         cloneToken.changeController(msg.sender);
376 
377         // An event to make the token easy to find on the blockchain
378         NewCloneToken(address(cloneToken), _snapshotBlock);
379         return address(cloneToken);
380     }
381 
382 ////////////////
383 // Generate and destroy tokens
384 ////////////////
385 
386     /// @notice Generates `_amount` tokens that are assigned to `_owner`
387     /// @param _owner The address that will be assigned the new tokens
388     /// @param _amount The quantity of tokens generated
389     /// @return True if the tokens are generated correctly
390     function generateTokens(address _owner, uint _amount
391     ) public onlyController returns (bool) {
392         uint curTotalSupply = totalSupply();
393         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
394         uint previousBalanceTo = balanceOf(_owner);
395         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
396         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
397         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
398         Transfer(0, _owner, _amount);
399         return true;
400     }
401 
402 
403     /// @notice Burns `_amount` tokens from `_owner`
404     /// @param _owner The address that will lose the tokens
405     /// @param _amount The quantity of tokens to burn
406     /// @return True if the tokens are burned correctly
407     function destroyTokens(address _owner, uint _amount
408     ) onlyController public returns (bool) {
409         uint curTotalSupply = totalSupply();
410         require(curTotalSupply >= _amount);
411         uint previousBalanceFrom = balanceOf(_owner);
412         require(previousBalanceFrom >= _amount);
413         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
414         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
415         Transfer(_owner, 0, _amount);
416         return true;
417     }
418 
419 ////////////////
420 // Enable tokens transfers
421 ////////////////
422 
423 
424     /// @notice Enables token holders to transfer their tokens freely if true
425     /// @param _transfersEnabled True if transfers are allowed in the clone
426     function enableTransfers(bool _transfersEnabled) public onlyController {
427         transfersEnabled = _transfersEnabled;
428     }
429 
430 ////////////////
431 // Internal helper functions to query and set a value in a snapshot array
432 ////////////////
433 
434     /// @dev `getValueAt` retrieves the number of tokens at a given block number
435     /// @param checkpoints The history of values being queried
436     /// @param _block The block number to retrieve the value at
437     /// @return The number of tokens being queried
438     function getValueAt(Checkpoint[] storage checkpoints, uint _block
439     ) constant internal returns (uint) {
440         if (checkpoints.length == 0) return 0;
441 
442         // Shortcut for the actual value
443         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
444             return checkpoints[checkpoints.length-1].value;
445         if (_block < checkpoints[0].fromBlock) return 0;
446 
447         // Binary search of the value in the array
448         uint min = 0;
449         uint max = checkpoints.length-1;
450         while (max > min) {
451             uint mid = (max + min + 1)/ 2;
452             if (checkpoints[mid].fromBlock<=_block) {
453                 min = mid;
454             } else {
455                 max = mid-1;
456             }
457         }
458         return checkpoints[min].value;
459     }
460 
461     /// @dev `updateValueAtNow` used to update the `balances` map and the
462     ///  `totalSupplyHistory`
463     /// @param checkpoints The history of data being updated
464     /// @param _value The new number of tokens
465     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
466     ) internal  {
467         if ((checkpoints.length == 0)
468         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
469                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
470                newCheckPoint.fromBlock =  uint128(block.number);
471                newCheckPoint.value = uint128(_value);
472            } else {
473                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
474                oldCheckPoint.value = uint128(_value);
475            }
476     }
477 
478     /// @dev Internal function to determine if an address is a contract
479     /// @param _addr The address being queried
480     /// @return True if `_addr` is a contract
481     function isContract(address _addr) constant internal returns(bool) {
482         uint size;
483         if (_addr == 0) return false;
484         assembly {
485             size := extcodesize(_addr)
486         }
487         return size>0;
488     }
489 
490     /// @dev Helper function to return a min betwen the two uints
491     function min(uint a, uint b) pure internal returns (uint) {
492         return a < b ? a : b;
493     }
494 
495     /// @notice The fallback function: If the contract's controller has not been
496     ///  set to 0, then the `proxyPayment` method is called which relays the
497     ///  ether and creates tokens as described in the token controller contract
498     function () public payable {
499         require(isContract(controller));
500         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
501     }
502 
503 //////////
504 // Safety Methods
505 //////////
506 
507     /// @notice This method can be used by the controller to extract mistakenly
508     ///  sent tokens to this contract.
509     /// @param _token The address of the token contract that you want to recover
510     ///  set to 0 in case you want to extract ether.
511     function claimTokens(address _token) public onlyController {
512         if (_token == 0x0) {
513             controller.transfer(this.balance);
514             return;
515         }
516 
517         Pinakion token = Pinakion(_token);
518         uint balance = token.balanceOf(this);
519         token.transfer(controller, balance);
520         ClaimedTokens(_token, controller, balance);
521     }
522 
523 ////////////////
524 // Events
525 ////////////////
526     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
527     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
528     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
529     event Approval(
530         address indexed _owner,
531         address indexed _spender,
532         uint256 _amount
533         );
534 
535 }
536 
537 
538 ////////////////
539 // MiniMeTokenFactory
540 ////////////////
541 
542 /// @dev This contract is used to generate clone contracts from a contract.
543 ///  In solidity this is the way to create a contract from a contract of the
544 ///  same class
545 contract MiniMeTokenFactory {
546 
547     /// @notice Update the DApp by creating a new token with new functionalities
548     ///  the msg.sender becomes the controller of this clone token
549     /// @param _parentToken Address of the token being cloned
550     /// @param _snapshotBlock Block of the parent token that will
551     ///  determine the initial distribution of the clone token
552     /// @param _tokenName Name of the new token
553     /// @param _decimalUnits Number of decimals of the new token
554     /// @param _tokenSymbol Token Symbol for the new token
555     /// @param _transfersEnabled If true, tokens will be able to be transferred
556     /// @return The address of the new token contract
557     function createCloneToken(
558         address _parentToken,
559         uint _snapshotBlock,
560         string _tokenName,
561         uint8 _decimalUnits,
562         string _tokenSymbol,
563         bool _transfersEnabled
564     ) public returns (Pinakion) {
565         Pinakion newToken = new Pinakion(
566             this,
567             _parentToken,
568             _snapshotBlock,
569             _tokenName,
570             _decimalUnits,
571             _tokenSymbol,
572             _transfersEnabled
573             );
574 
575         newToken.changeController(msg.sender);
576         return newToken;
577     }
578 }
579 
580 contract RNG{
581 
582     /** @dev Contribute to the reward of a random number.
583      *  @param _block Block the random number is linked to.
584      */
585     function contribute(uint _block) public payable;
586 
587     /** @dev Request a random number.
588      *  @param _block Block linked to the request.
589      */
590     function requestRN(uint _block) public payable {
591         contribute(_block);
592     }
593 
594     /** @dev Get the random number.
595      *  @param _block Block the random number is linked to.
596      *  @return RN Random Number. If the number is not ready or has not been required 0 instead.
597      */
598     function getRN(uint _block) public returns (uint RN);
599 
600     /** @dev Get a uncorrelated random number. Act like getRN but give a different number for each sender.
601      *  This is to prevent users from getting correlated numbers.
602      *  @param _block Block the random number is linked to.
603      *  @return RN Random Number. If the number is not ready or has not been required 0 instead.
604      */
605     function getUncorrelatedRN(uint _block) public returns (uint RN) {
606         uint baseRN=getRN(_block);
607         if (baseRN==0)
608             return 0;
609         else
610             return uint(keccak256(msg.sender,baseRN));
611     }
612 
613  }
614 
615 /** Simple Random Number Generator returning the blockhash.
616  *  Allows saving the random number for use in the future.
617  *  It allows the contract to still access the blockhash even after 256 blocks.
618  *  The first party to call the save function gets the reward.
619  */
620 contract BlockHashRNG is RNG {
621 
622     mapping (uint => uint) public randomNumber; // randomNumber[block] is the random number for this block, 0 otherwise.
623     mapping (uint => uint) public reward; // reward[block] is the amount to be paid to the party w.
624 
625 
626 
627     /** @dev Contribute to the reward of a random number.
628      *  @param _block Block the random number is linked to.
629      */
630     function contribute(uint _block) public payable { reward[_block]+=msg.value; }
631 
632 
633     /** @dev Return the random number. If it has not been saved and is still computable compute it.
634      *  @param _block Block the random number is linked to.
635      *  @return RN Random Number. If the number is not ready or has not been requested 0 instead.
636      */
637     function getRN(uint _block) public returns (uint RN) {
638         RN=randomNumber[_block];
639         if (RN==0){
640             saveRN(_block);
641             return randomNumber[_block];
642         }
643         else
644             return RN;
645     }
646 
647     /** @dev Save the random number for this blockhash and give the reward to the caller.
648      *  @param _block Block the random number is linked to.
649      */
650     function saveRN(uint _block) public {
651         if (blockhash(_block) != 0x0)
652             randomNumber[_block] = uint(blockhash(_block));
653         if (randomNumber[_block] != 0) { // If the number is set.
654             uint rewardToSend = reward[_block];
655             reward[_block] = 0;
656             msg.sender.send(rewardToSend); // Note that the use of send is on purpose as we don't want to block in case msg.sender has a fallback issue.
657         }
658     }
659 
660 }
661 
662 
663 /** Random Number Generator returning the blockhash with a backup behaviour.
664  *  Allows saving the random number for use in the future. 
665  *  It allows the contract to still access the blockhash even after 256 blocks.
666  *  The first party to call the save function gets the reward.
667  *  If no one calls the contract within 256 blocks, the contract fallback in returning the blockhash of the previous block.
668  */
669 contract BlockHashRNGFallback is BlockHashRNG {
670     
671     /** @dev Save the random number for this blockhash and give the reward to the caller.
672      *  @param _block Block the random number is linked to.
673      */
674     function saveRN(uint _block) public {
675         if (_block<block.number && randomNumber[_block]==0) {// If the random number is not already set and can be.
676             if (blockhash(_block)!=0x0) // Normal case.
677                 randomNumber[_block]=uint(blockhash(_block));
678             else // The contract was not called in time. Fallback to returning previous blockhash.
679                 randomNumber[_block]=uint(blockhash(block.number-1));
680         }
681         if (randomNumber[_block] != 0) { // If the random number is set.
682             uint rewardToSend=reward[_block];
683             reward[_block]=0;
684             msg.sender.send(rewardToSend); // Note that the use of send is on purpose as we don't want to block in case the msg.sender has a fallback issue.
685         }
686     }
687     
688 }
689 
690 /** @title Arbitrable
691  *  Arbitrable abstract contract.
692  *  When developing arbitrable contracts, we need to:
693  *  -Define the action taken when a ruling is received by the contract. We should do so in executeRuling.
694  *  -Allow dispute creation. For this a function must:
695  *      -Call arbitrator.createDispute.value(_fee)(_choices,_extraData);
696  *      -Create the event Dispute(_arbitrator,_disputeID,_rulingOptions);
697  */
698 contract Arbitrable{
699     Arbitrator public arbitrator;
700     bytes public arbitratorExtraData; // Extra data to require particular dispute and appeal behaviour.
701 
702     modifier onlyArbitrator {require(msg.sender==address(arbitrator)); _;}
703 
704     /** @dev To be raised when a ruling is given.
705      *  @param _arbitrator The arbitrator giving the ruling.
706      *  @param _disputeID ID of the dispute in the Arbitrator contract.
707      *  @param _ruling The ruling which was given.
708      */
709     event Ruling(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _ruling);
710 
711     /** @dev To be emmited when meta-evidence is submitted.
712      *  @param _metaEvidenceID Unique identifier of meta-evidence.
713      *  @param _evidence A link to the meta-evidence JSON.
714      */
715     event MetaEvidence(uint indexed _metaEvidenceID, string _evidence);
716 
717     /** @dev To be emmited when a dispute is created to link the correct meta-evidence to the disputeID
718      *  @param _arbitrator The arbitrator of the contract.
719      *  @param _disputeID ID of the dispute in the Arbitrator contract.
720      *  @param _metaEvidenceID Unique identifier of meta-evidence.
721      */
722     event Dispute(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _metaEvidenceID);
723 
724     /** @dev To be raised when evidence are submitted. Should point to the ressource (evidences are not to be stored on chain due to gas considerations).
725      *  @param _arbitrator The arbitrator of the contract.
726      *  @param _disputeID ID of the dispute in the Arbitrator contract.
727      *  @param _party The address of the party submiting the evidence. Note that 0x0 refers to evidence not submitted by any party.
728      *  @param _evidence A URI to the evidence JSON file whose name should be its keccak256 hash followed by .json.
729      */
730     event Evidence(Arbitrator indexed _arbitrator, uint indexed _disputeID, address _party, string _evidence);
731 
732     /** @dev Constructor. Choose the arbitrator.
733      *  @param _arbitrator The arbitrator of the contract.
734      *  @param _arbitratorExtraData Extra data for the arbitrator.
735      */
736     constructor(Arbitrator _arbitrator, bytes _arbitratorExtraData) public {
737         arbitrator = _arbitrator;
738         arbitratorExtraData = _arbitratorExtraData;
739     }
740 
741     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
742      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
743      *  @param _disputeID ID of the dispute in the Arbitrator contract.
744      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
745      */
746     function rule(uint _disputeID, uint _ruling) public onlyArbitrator {
747         emit Ruling(Arbitrator(msg.sender),_disputeID,_ruling);
748 
749         executeRuling(_disputeID,_ruling);
750     }
751 
752 
753     /** @dev Execute a ruling of a dispute.
754      *  @param _disputeID ID of the dispute in the Arbitrator contract.
755      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
756      */
757     function executeRuling(uint _disputeID, uint _ruling) internal;
758 }
759 
760 /** @title Arbitrator
761  *  Arbitrator abstract contract.
762  *  When developing arbitrator contracts we need to:
763  *  -Define the functions for dispute creation (createDispute) and appeal (appeal). Don't forget to store the arbitrated contract and the disputeID (which should be unique, use nbDisputes).
764  *  -Define the functions for cost display (arbitrationCost and appealCost).
765  *  -Allow giving rulings. For this a function must call arbitrable.rule(disputeID,ruling).
766  */
767 contract Arbitrator{
768 
769     enum DisputeStatus {Waiting, Appealable, Solved}
770 
771     modifier requireArbitrationFee(bytes _extraData) {require(msg.value>=arbitrationCost(_extraData)); _;}
772     modifier requireAppealFee(uint _disputeID, bytes _extraData) {require(msg.value>=appealCost(_disputeID, _extraData)); _;}
773 
774     /** @dev To be raised when a dispute can be appealed.
775      *  @param _disputeID ID of the dispute.
776      */
777     event AppealPossible(uint _disputeID);
778 
779     /** @dev To be raised when a dispute is created.
780      *  @param _disputeID ID of the dispute.
781      *  @param _arbitrable The contract which created the dispute.
782      */
783     event DisputeCreation(uint indexed _disputeID, Arbitrable _arbitrable);
784 
785     /** @dev To be raised when the current ruling is appealed.
786      *  @param _disputeID ID of the dispute.
787      *  @param _arbitrable The contract which created the dispute.
788      */
789     event AppealDecision(uint indexed _disputeID, Arbitrable _arbitrable);
790 
791     /** @dev Create a dispute. Must be called by the arbitrable contract.
792      *  Must be paid at least arbitrationCost(_extraData).
793      *  @param _choices Amount of choices the arbitrator can make in this dispute.
794      *  @param _extraData Can be used to give additional info on the dispute to be created.
795      *  @return disputeID ID of the dispute created.
796      */
797     function createDispute(uint _choices, bytes _extraData) public requireArbitrationFee(_extraData) payable returns(uint disputeID)  {}
798 
799     /** @dev Compute the cost of arbitration. It is recommended not to increase it often, as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
800      *  @param _extraData Can be used to give additional info on the dispute to be created.
801      *  @return fee Amount to be paid.
802      */
803     function arbitrationCost(bytes _extraData) public constant returns(uint fee);
804 
805     /** @dev Appeal a ruling. Note that it has to be called before the arbitrator contract calls rule.
806      *  @param _disputeID ID of the dispute to be appealed.
807      *  @param _extraData Can be used to give extra info on the appeal.
808      */
809     function appeal(uint _disputeID, bytes _extraData) public requireAppealFee(_disputeID,_extraData) payable {
810         emit AppealDecision(_disputeID, Arbitrable(msg.sender));
811     }
812 
813     /** @dev Compute the cost of appeal. It is recommended not to increase it often, as it can be higly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
814      *  @param _disputeID ID of the dispute to be appealed.
815      *  @param _extraData Can be used to give additional info on the dispute to be created.
816      *  @return fee Amount to be paid.
817      */
818     function appealCost(uint _disputeID, bytes _extraData) public constant returns(uint fee);
819 
820     /** @dev Return the status of a dispute.
821      *  @param _disputeID ID of the dispute to rule.
822      *  @return status The status of the dispute.
823      */
824     function disputeStatus(uint _disputeID) public constant returns(DisputeStatus status);
825 
826     /** @dev Return the current ruling of a dispute. This is useful for parties to know if they should appeal.
827      *  @param _disputeID ID of the dispute.
828      *  @return ruling The ruling which has been given or the one which will be given if there is no appeal.
829      */
830     function currentRuling(uint _disputeID) public constant returns(uint ruling);
831 
832 }
833 
834 
835 
836 contract Kleros is Arbitrator, ApproveAndCallFallBack {
837 
838     // **************************** //
839     // *    Contract variables    * //
840     // **************************** //
841 
842     // Variables which should not change after initialization.
843     Pinakion public pinakion;
844     uint public constant NON_PAYABLE_AMOUNT = (2**256 - 2) / 2; // An astronomic amount, practically can't be paid.
845 
846     // Variables which will subject to the governance mechanism.
847     // Note they will only be able to be changed during the activation period (because a session assumes they don't change after it).
848     RNG public rng; // Random Number Generator used to draw jurors.
849     uint public arbitrationFeePerJuror = 0.05 ether; // The fee which will be paid to each juror.
850     uint16 public defaultNumberJuror = 3; // Number of drawn jurors unless specified otherwise.
851     uint public minActivatedToken = 0.1 * 1e18; // Minimum of tokens to be activated (in basic units).
852     uint[5] public timePerPeriod; // The minimum time each period lasts (seconds).
853     uint public alpha = 2000; // alpha in ‱ (1 / 10 000).
854     uint constant ALPHA_DIVISOR = 1e4; // Amount we need to divided alpha in ‱ to get the float value of alpha.
855     uint public maxAppeals = 5; // Number of times a dispute can be appealed. When exceeded appeal cost becomes NON_PAYABLE_AMOUNT.
856     // Initially, the governor will be an address controlled by the Kleros team. At a later stage,
857     // the governor will be switched to a governance contract with liquid voting.
858     address public governor; // Address of the governor contract.
859 
860     // Variables changing during day to day interaction.
861     uint public session = 1;      // Current session of the court.
862     uint public lastPeriodChange; // The last time we changed of period (seconds).
863     uint public segmentSize;      // Size of the segment of activated tokens.
864     uint public rnBlock;          // The block linked with the RN which is requested.
865     uint public randomNumber;     // Random number of the session.
866 
867     enum Period {
868         Activation, // When juror can deposit their tokens and parties give evidences.
869         Draw,       // When jurors are drawn at random, note that this period is fast.
870         Vote,       // Where jurors can vote on disputes.
871         Appeal,     // When parties can appeal the rulings.
872         Execution   // When where token redistribution occurs and Kleros call the arbitrated contracts.
873     }
874 
875     Period public period;
876 
877     struct Juror {
878         uint balance;      // The amount of tokens the contract holds for this juror.
879         uint atStake;      // Total number of tokens the jurors can loose in disputes they are drawn in. Those tokens are locked. Note that we can have atStake > balance but it should be statistically unlikely and does not pose issues.
880         uint lastSession;  // Last session the tokens were activated.
881         uint segmentStart; // Start of the segment of activated tokens.
882         uint segmentEnd;   // End of the segment of activated tokens.
883     }
884 
885     mapping (address => Juror) public jurors;
886 
887     struct Vote {
888         address account; // The juror who casted the vote.
889         uint ruling;     // The ruling which was given.
890     }
891 
892     struct VoteCounter {
893         uint winningChoice; // The choice which currently has the highest amount of votes. Is 0 in case of a tie.
894         uint winningCount;  // The number of votes for winningChoice. Or for the choices which are tied.
895         mapping (uint => uint) voteCount; // voteCount[choice] is the number of votes for choice.
896     }
897 
898     enum DisputeState {
899         Open,       // The dispute is opened but the outcome is not available yet (this include when jurors voted but appeal is still possible).
900         Resolving,  // The token repartition has started. Note that if it's done in just one call, this state is skipped.
901         Executable, // The arbitrated contract can be called to enforce the decision.
902         Executed    // Everything has been done and the dispute can't be interacted with anymore.
903     }
904 
905     struct Dispute {
906         Arbitrable arbitrated;       // Contract to be arbitrated.
907         uint session;                // First session the dispute was schedule.
908         uint appeals;                // Number of appeals.
909         uint choices;                // The number of choices available to the jurors.
910         uint16 initialNumberJurors;  // The initial number of jurors.
911         uint arbitrationFeePerJuror; // The fee which will be paid to each juror.
912         DisputeState state;          // The state of the dispute.
913         Vote[][] votes;              // The votes in the form vote[appeals][voteID].
914         VoteCounter[] voteCounter;   // The vote counters in the form voteCounter[appeals].
915         mapping (address => uint) lastSessionVote; // Last session a juror has voted on this dispute. Is 0 if he never did.
916         uint currentAppealToRepartition; // The current appeal we are repartitioning.
917         AppealsRepartitioned[] appealsRepartitioned; // Track a partially repartitioned appeal in the form AppealsRepartitioned[appeal].
918     }
919 
920     enum RepartitionStage { // State of the token repartition if oneShotTokenRepartition would throw because there are too many votes.
921         Incoherent,
922         Coherent,
923         AtStake,
924         Complete
925     }
926 
927     struct AppealsRepartitioned {
928         uint totalToRedistribute;   // Total amount of tokens we have to redistribute.
929         uint nbCoherent;            // Number of coherent jurors for session.
930         uint currentIncoherentVote; // Current vote for the incoherent loop.
931         uint currentCoherentVote;   // Current vote we need to count.
932         uint currentAtStakeVote;    // Current vote we need to count.
933         RepartitionStage stage;     // Use with multipleShotTokenRepartition if oneShotTokenRepartition would throw.
934     }
935 
936     Dispute[] public disputes;
937 
938     // **************************** //
939     // *          Events          * //
940     // **************************** //
941 
942     /** @dev Emitted when we pass to a new period.
943      *  @param _period The new period.
944      *  @param _session The current session.
945      */
946     event NewPeriod(Period _period, uint indexed _session);
947 
948     /** @dev Emitted when a juror wins or loses tokens.
949       * @param _account The juror affected.
950       * @param _disputeID The ID of the dispute.
951       * @param _amount The amount of parts of token which was won. Can be negative for lost amounts.
952       */
953     event TokenShift(address indexed _account, uint _disputeID, int _amount);
954 
955     /** @dev Emited when a juror wins arbitration fees.
956       * @param _account The account affected.
957       * @param _disputeID The ID of the dispute.
958       * @param _amount The amount of weis which was won.
959       */
960     event ArbitrationReward(address indexed _account, uint _disputeID, uint _amount);
961 
962     // **************************** //
963     // *         Modifiers        * //
964     // **************************** //
965     modifier onlyBy(address _account) {require(msg.sender == _account); _;}
966     modifier onlyDuring(Period _period) {require(period == _period); _;}
967     modifier onlyGovernor() {require(msg.sender == governor); _;}
968 
969 
970     /** @dev Constructor.
971      *  @param _pinakion The address of the pinakion contract.
972      *  @param _rng The random number generator which will be used.
973      *  @param _timePerPeriod The minimal time for each period (seconds).
974      *  @param _governor Address of the governor contract.
975      */
976     constructor(Pinakion _pinakion, RNG _rng, uint[5] _timePerPeriod, address _governor) public {
977         pinakion = _pinakion;
978         rng = _rng;
979         lastPeriodChange = now;
980         timePerPeriod = _timePerPeriod;
981         governor = _governor;
982     }
983 
984     // **************************** //
985     // *  Functions interacting   * //
986     // *  with Pinakion contract  * //
987     // **************************** //
988 
989     /** @dev Callback of approveAndCall - transfer pinakions of a juror in the contract. Should be called by the pinakion contract. TRUSTED.
990      *  @param _from The address making the transfer.
991      *  @param _amount Amount of tokens to transfer to Kleros (in basic units).
992      */
993     function receiveApproval(address _from, uint _amount, address, bytes) public onlyBy(pinakion) {
994         require(pinakion.transferFrom(_from, this, _amount));
995 
996         jurors[_from].balance += _amount;
997     }
998 
999     /** @dev Withdraw tokens. Note that we can't withdraw the tokens which are still atStake. 
1000      *  Jurors can't withdraw their tokens if they have deposited some during this session.
1001      *  This is to prevent jurors from withdrawing tokens they could loose.
1002      *  @param _value The amount to withdraw.
1003      */
1004     function withdraw(uint _value) public {
1005         Juror storage juror = jurors[msg.sender];
1006         require(juror.atStake <= juror.balance); // Make sure that there is no more at stake than owned to avoid overflow.
1007         require(_value <= juror.balance-juror.atStake);
1008         require(juror.lastSession != session);
1009 
1010         juror.balance -= _value;
1011         require(pinakion.transfer(msg.sender,_value));
1012     }
1013 
1014     // **************************** //
1015     // *      Court functions     * //
1016     // *    Modifying the state   * //
1017     // **************************** //
1018 
1019     /** @dev To call to go to a new period. TRUSTED.
1020      */
1021     function passPeriod() public {
1022         require(now-lastPeriodChange >= timePerPeriod[uint8(period)]);
1023 
1024         if (period == Period.Activation) {
1025             rnBlock = block.number + 1;
1026             rng.requestRN(rnBlock);
1027             period = Period.Draw;
1028         } else if (period == Period.Draw) {
1029             randomNumber = rng.getUncorrelatedRN(rnBlock);
1030             require(randomNumber != 0);
1031             period = Period.Vote;
1032         } else if (period == Period.Vote) {
1033             period = Period.Appeal;
1034         } else if (period == Period.Appeal) {
1035             period = Period.Execution;
1036         } else if (period == Period.Execution) {
1037             period = Period.Activation;
1038             ++session;
1039             segmentSize = 0;
1040             rnBlock = 0;
1041             randomNumber = 0;
1042         }
1043 
1044 
1045         lastPeriodChange = now;
1046         NewPeriod(period, session);
1047     }
1048 
1049 
1050     /** @dev Deposit tokens in order to have chances of being drawn. Note that once tokens are deposited, 
1051      *  there is no possibility of depositing more.
1052      *  @param _value Amount of tokens (in basic units) to deposit.
1053      */
1054     function activateTokens(uint _value) public onlyDuring(Period.Activation) {
1055         Juror storage juror = jurors[msg.sender];
1056         require(_value <= juror.balance);
1057         require(_value >= minActivatedToken);
1058         require(juror.lastSession != session); // Verify that tokens were not already activated for this session.
1059 
1060         juror.lastSession = session;
1061         juror.segmentStart = segmentSize;
1062         segmentSize += _value;
1063         juror.segmentEnd = segmentSize;
1064 
1065     }
1066 
1067     /** @dev Vote a ruling. Juror must input the draw ID he was drawn.
1068      *  Note that the complexity is O(d), where d is amount of times the juror was drawn.
1069      *  Since being drawn multiple time is a rare occurrence and that a juror can always vote with less weight than it has, it is not a problem.
1070      *  But note that it can lead to arbitration fees being kept by the contract and never distributed.
1071      *  @param _disputeID The ID of the dispute the juror was drawn.
1072      *  @param _ruling The ruling given.
1073      *  @param _draws The list of draws the juror was drawn. Draw numbering starts at 1 and the numbers should be increasing.
1074      */
1075     function voteRuling(uint _disputeID, uint _ruling, uint[] _draws) public onlyDuring(Period.Vote) {
1076         Dispute storage dispute = disputes[_disputeID];
1077         Juror storage juror = jurors[msg.sender];
1078         VoteCounter storage voteCounter = dispute.voteCounter[dispute.appeals];
1079         require(dispute.lastSessionVote[msg.sender] != session); // Make sure juror hasn't voted yet.
1080         require(_ruling <= dispute.choices);
1081         // Note that it throws if the draws are incorrect.
1082         require(validDraws(msg.sender, _disputeID, _draws));
1083 
1084         dispute.lastSessionVote[msg.sender] = session;
1085         voteCounter.voteCount[_ruling] += _draws.length;
1086         if (voteCounter.winningCount < voteCounter.voteCount[_ruling]) {
1087             voteCounter.winningCount = voteCounter.voteCount[_ruling];
1088             voteCounter.winningChoice = _ruling;
1089         } else if (voteCounter.winningCount==voteCounter.voteCount[_ruling] && _draws.length!=0) { // Verify draw length to be non-zero to avoid the possibility of setting tie by casting 0 votes.
1090             voteCounter.winningChoice = 0; // It's currently a tie.
1091         }
1092         for (uint i = 0; i < _draws.length; ++i) {
1093             dispute.votes[dispute.appeals].push(Vote({
1094                 account: msg.sender,
1095                 ruling: _ruling
1096             }));
1097         }
1098 
1099         juror.atStake += _draws.length * getStakePerDraw();
1100         uint feeToPay = _draws.length * dispute.arbitrationFeePerJuror;
1101         msg.sender.transfer(feeToPay);
1102         ArbitrationReward(msg.sender, _disputeID, feeToPay);
1103     }
1104 
1105     /** @dev Steal part of the tokens and the arbitration fee of a juror who failed to vote.
1106      *  Note that a juror who voted but without all his weight can't be penalized.
1107      *  It is possible to not penalize with the maximum weight.
1108      *  But note that it can lead to arbitration fees being kept by the contract and never distributed.
1109      *  @param _jurorAddress Address of the juror to steal tokens from.
1110      *  @param _disputeID The ID of the dispute the juror was drawn.
1111      *  @param _draws The list of draws the juror was drawn. Numbering starts at 1 and the numbers should be increasing.
1112      */
1113     function penalizeInactiveJuror(address _jurorAddress, uint _disputeID, uint[] _draws) public {
1114         Dispute storage dispute = disputes[_disputeID];
1115         Juror storage inactiveJuror = jurors[_jurorAddress];
1116         require(period > Period.Vote);
1117         require(dispute.lastSessionVote[_jurorAddress] != session); // Verify the juror hasn't voted.
1118         dispute.lastSessionVote[_jurorAddress] = session; // Update last session to avoid penalizing multiple times.
1119         require(validDraws(_jurorAddress, _disputeID, _draws));
1120         uint penality = _draws.length * minActivatedToken * 2 * alpha / ALPHA_DIVISOR;
1121         penality = (penality < inactiveJuror.balance) ? penality : inactiveJuror.balance; // Make sure the penality is not higher than the balance.
1122         inactiveJuror.balance -= penality;
1123         TokenShift(_jurorAddress, _disputeID, -int(penality));
1124         jurors[msg.sender].balance += penality / 2; // Give half of the penalty to the caller.
1125         TokenShift(msg.sender, _disputeID, int(penality / 2));
1126         jurors[governor].balance += penality / 2; // The other half to the governor.
1127         TokenShift(governor, _disputeID, int(penality / 2));
1128         msg.sender.transfer(_draws.length*dispute.arbitrationFeePerJuror); // Give the arbitration fees to the caller.
1129     }
1130 
1131     /** @dev Execute all the token repartition.
1132      *  Note that this function could consume to much gas if there is too much votes. 
1133      *  It is O(v), where v is the number of votes for this dispute.
1134      *  In the next version, there will also be a function to execute it in multiple calls 
1135      *  (but note that one shot execution, if possible, is less expensive).
1136      *  @param _disputeID ID of the dispute.
1137      */
1138     function oneShotTokenRepartition(uint _disputeID) public onlyDuring(Period.Execution) {
1139         Dispute storage dispute = disputes[_disputeID];
1140         require(dispute.state == DisputeState.Open);
1141         require(dispute.session+dispute.appeals <= session);
1142 
1143         uint winningChoice = dispute.voteCounter[dispute.appeals].winningChoice;
1144         uint amountShift = getStakePerDraw();
1145         for (uint i = 0; i <= dispute.appeals; ++i) {
1146             // If the result is not a tie, some parties are incoherent. Note that 0 (refuse to arbitrate) winning is not a tie.
1147             // Result is a tie if the winningChoice is 0 (refuse to arbitrate) and the choice 0 is not the most voted choice.
1148             // Note that in case of a "tie" among some choices including 0, parties who did not vote 0 are considered incoherent.
1149             if (winningChoice!=0 || (dispute.voteCounter[dispute.appeals].voteCount[0] == dispute.voteCounter[dispute.appeals].winningCount)) {
1150                 uint totalToRedistribute = 0;
1151                 uint nbCoherent = 0;
1152                 // First loop to penalize the incoherent votes.
1153                 for (uint j = 0; j < dispute.votes[i].length; ++j) {
1154                     Vote storage vote = dispute.votes[i][j];
1155                     if (vote.ruling != winningChoice) {
1156                         Juror storage juror = jurors[vote.account];
1157                         uint penalty = amountShift<juror.balance ? amountShift : juror.balance;
1158                         juror.balance -= penalty;
1159                         TokenShift(vote.account, _disputeID, int(-penalty));
1160                         totalToRedistribute += penalty;
1161                     } else {
1162                         ++nbCoherent;
1163                     }
1164                 }
1165                 if (nbCoherent == 0) { // No one was coherent at this stage. Give the tokens to the governor.
1166                     jurors[governor].balance += totalToRedistribute;
1167                     TokenShift(governor, _disputeID, int(totalToRedistribute));
1168                 } else { // otherwise, redistribute them.
1169                     uint toRedistribute = totalToRedistribute / nbCoherent; // Note that few fractions of tokens can be lost but due to the high amount of decimals we don't care.
1170                     // Second loop to redistribute.
1171                     for (j = 0; j < dispute.votes[i].length; ++j) {
1172                         vote = dispute.votes[i][j];
1173                         if (vote.ruling == winningChoice) {
1174                             juror = jurors[vote.account];
1175                             juror.balance += toRedistribute;
1176                             TokenShift(vote.account, _disputeID, int(toRedistribute));
1177                         }
1178                     }
1179                 }
1180             }
1181             // Third loop to lower the atStake in order to unlock tokens.
1182             for (j = 0; j < dispute.votes[i].length; ++j) {
1183                 vote = dispute.votes[i][j];
1184                 juror = jurors[vote.account];
1185                 juror.atStake -= amountShift; // Note that it can't underflow due to amountShift not changing between vote and redistribution.
1186             }
1187         }
1188         dispute.state = DisputeState.Executable; // Since it was solved in one shot, go directly to the executable step.
1189     }
1190 
1191     /** @dev Execute token repartition on a dispute for a specific number of votes.
1192      *  This should only be called if oneShotTokenRepartition will throw because there are too many votes (will use too much gas).
1193      *  Note that There are 3 iterations per vote. e.g. A dispute with 1 appeal (2 sessions) and 3 votes per session will have 18 iterations
1194      *  @param _disputeID ID of the dispute.
1195      *  @param _maxIterations the maxium number of votes to repartition in this iteration
1196      */
1197     function multipleShotTokenRepartition(uint _disputeID, uint _maxIterations) public onlyDuring(Period.Execution) {
1198         Dispute storage dispute = disputes[_disputeID];
1199         require(dispute.state <= DisputeState.Resolving);
1200         require(dispute.session+dispute.appeals <= session);
1201         dispute.state = DisputeState.Resolving; // Mark as resolving so oneShotTokenRepartition cannot be called on dispute.
1202 
1203         uint winningChoice = dispute.voteCounter[dispute.appeals].winningChoice;
1204         uint amountShift = getStakePerDraw();
1205         uint currentIterations = 0; // Total votes we have repartitioned this iteration.
1206         for (uint i = dispute.currentAppealToRepartition; i <= dispute.appeals; ++i) {
1207             // Allocate space for new AppealsRepartitioned.
1208             if (dispute.appealsRepartitioned.length < i+1) {
1209                 dispute.appealsRepartitioned.length++;
1210             }
1211 
1212             // If the result is a tie, no parties are incoherent and no need to move tokens. Note that 0 (refuse to arbitrate) winning is not a tie.
1213             if (winningChoice==0 && (dispute.voteCounter[dispute.appeals].voteCount[0] != dispute.voteCounter[dispute.appeals].winningCount)) {
1214                 // If ruling is a tie we can skip to at stake.
1215                 dispute.appealsRepartitioned[i].stage = RepartitionStage.AtStake;
1216             }
1217 
1218             // First loop to penalize the incoherent votes.
1219             if (dispute.appealsRepartitioned[i].stage == RepartitionStage.Incoherent) {
1220                 for (uint j = dispute.appealsRepartitioned[i].currentIncoherentVote; j < dispute.votes[i].length; ++j) {
1221                     if (currentIterations >= _maxIterations) {
1222                         return;
1223                     }
1224                     Vote storage vote = dispute.votes[i][j];
1225                     if (vote.ruling != winningChoice) {
1226                         Juror storage juror = jurors[vote.account];
1227                         uint penalty = amountShift<juror.balance ? amountShift : juror.balance;
1228                         juror.balance -= penalty;
1229                         TokenShift(vote.account, _disputeID, int(-penalty));
1230                         dispute.appealsRepartitioned[i].totalToRedistribute += penalty;
1231                     } else {
1232                         ++dispute.appealsRepartitioned[i].nbCoherent;
1233                     }
1234 
1235                     ++dispute.appealsRepartitioned[i].currentIncoherentVote;
1236                     ++currentIterations;
1237                 }
1238 
1239                 dispute.appealsRepartitioned[i].stage = RepartitionStage.Coherent;
1240             }
1241 
1242             // Second loop to reward coherent voters
1243             if (dispute.appealsRepartitioned[i].stage == RepartitionStage.Coherent) {
1244                 if (dispute.appealsRepartitioned[i].nbCoherent == 0) { // No one was coherent at this stage. Give the tokens to the governor.
1245                     jurors[governor].balance += dispute.appealsRepartitioned[i].totalToRedistribute;
1246                     TokenShift(governor, _disputeID, int(dispute.appealsRepartitioned[i].totalToRedistribute));
1247                     dispute.appealsRepartitioned[i].stage = RepartitionStage.AtStake;
1248                 } else { // Otherwise, redistribute them.
1249                     uint toRedistribute = dispute.appealsRepartitioned[i].totalToRedistribute / dispute.appealsRepartitioned[i].nbCoherent; // Note that few fractions of tokens can be lost but due to the high amount of decimals we don't care.
1250                     // Second loop to redistribute.
1251                     for (j = dispute.appealsRepartitioned[i].currentCoherentVote; j < dispute.votes[i].length; ++j) {
1252                         if (currentIterations >= _maxIterations) {
1253                             return;
1254                         }
1255                         vote = dispute.votes[i][j];
1256                         if (vote.ruling == winningChoice) {
1257                             juror = jurors[vote.account];
1258                             juror.balance += toRedistribute;
1259                             TokenShift(vote.account, _disputeID, int(toRedistribute));
1260                         }
1261 
1262                         ++currentIterations;
1263                         ++dispute.appealsRepartitioned[i].currentCoherentVote;
1264                     }
1265 
1266                     dispute.appealsRepartitioned[i].stage = RepartitionStage.AtStake;
1267                 }
1268             }
1269 
1270             if (dispute.appealsRepartitioned[i].stage == RepartitionStage.AtStake) {
1271                 // Third loop to lower the atStake in order to unlock tokens.
1272                 for (j = dispute.appealsRepartitioned[i].currentAtStakeVote; j < dispute.votes[i].length; ++j) {
1273                     if (currentIterations >= _maxIterations) {
1274                         return;
1275                     }
1276                     vote = dispute.votes[i][j];
1277                     juror = jurors[vote.account];
1278                     juror.atStake -= amountShift; // Note that it can't underflow due to amountShift not changing between vote and redistribution.
1279 
1280                     ++currentIterations;
1281                     ++dispute.appealsRepartitioned[i].currentAtStakeVote;
1282                 }
1283 
1284                 dispute.appealsRepartitioned[i].stage = RepartitionStage.Complete;
1285             }
1286 
1287             if (dispute.appealsRepartitioned[i].stage == RepartitionStage.Complete) {
1288                 ++dispute.currentAppealToRepartition;
1289             }
1290         }
1291 
1292         dispute.state = DisputeState.Executable;
1293     }
1294 
1295     // **************************** //
1296     // *      Court functions     * //
1297     // *     Constant and Pure    * //
1298     // **************************** //
1299 
1300     /** @dev Return the amount of jurors which are or will be drawn in the dispute.
1301      *  The number of jurors is doubled and 1 is added at each appeal. We have proven the formula by recurrence.
1302      *  This avoid having a variable number of jurors which would be updated in order to save gas.
1303      *  @param _disputeID The ID of the dispute we compute the amount of jurors.
1304      *  @return nbJurors The number of jurors which are drawn.
1305      */
1306     function amountJurors(uint _disputeID) public view returns (uint nbJurors) {
1307         Dispute storage dispute = disputes[_disputeID];
1308         return (dispute.initialNumberJurors + 1) * 2**dispute.appeals - 1;
1309     }
1310 
1311     /** @dev Must be used to verify that a juror has been draw at least _draws.length times.
1312      *  We have to require the user to specify the draws that lead the juror to be drawn.
1313      *  Because doing otherwise (looping through all draws) could consume too much gas.
1314      *  @param _jurorAddress Address of the juror we want to verify draws.
1315      *  @param _disputeID The ID of the dispute the juror was drawn.
1316      *  @param _draws The list of draws the juror was drawn. It draw numbering starts at 1 and the numbers should be increasing.
1317      *  Note that in most cases this list will just contain 1 number.
1318      *  @param valid true if the draws are valid.
1319      */
1320     function validDraws(address _jurorAddress, uint _disputeID, uint[] _draws) public view returns (bool valid) {
1321         uint draw = 0;
1322         Juror storage juror = jurors[_jurorAddress];
1323         Dispute storage dispute = disputes[_disputeID];
1324         uint nbJurors = amountJurors(_disputeID);
1325 
1326         if (juror.lastSession != session) return false; // Make sure that the tokens were deposited for this session.
1327         if (dispute.session+dispute.appeals != session) return false; // Make sure there is currently a dispute.
1328         if (period <= Period.Draw) return false; // Make sure that jurors are already drawn.
1329         for (uint i = 0; i < _draws.length; ++i) {
1330             if (_draws[i] <= draw) return false; // Make sure that draws are always increasing to avoid someone inputing the same multiple times.
1331             draw = _draws[i];
1332             if (draw > nbJurors) return false;
1333             uint position = uint(keccak256(randomNumber, _disputeID, draw)) % segmentSize; // Random position on the segment for draw.
1334             require(position >= juror.segmentStart);
1335             require(position < juror.segmentEnd);
1336         }
1337 
1338         return true;
1339     }
1340 
1341     // **************************** //
1342     // *   Arbitrator functions   * //
1343     // *   Modifying the state    * //
1344     // **************************** //
1345 
1346     /** @dev Create a dispute. Must be called by the arbitrable contract.
1347      *  Must be paid at least arbitrationCost().
1348      *  @param _choices Amount of choices the arbitrator can make in this dispute.
1349      *  @param _extraData Null for the default number. Otherwise, first 16 bytes will be used to return the number of jurors.
1350      *  @return disputeID ID of the dispute created.
1351      */
1352     function createDispute(uint _choices, bytes _extraData) public payable returns (uint disputeID) {
1353         uint16 nbJurors = extraDataToNbJurors(_extraData);
1354         require(msg.value >= arbitrationCost(_extraData));
1355 
1356         disputeID = disputes.length++;
1357         Dispute storage dispute = disputes[disputeID];
1358         dispute.arbitrated = Arbitrable(msg.sender);
1359         if (period < Period.Draw) // If drawing did not start schedule it for the current session.
1360             dispute.session = session;
1361         else // Otherwise schedule it for the next one.
1362             dispute.session = session+1;
1363         dispute.choices = _choices;
1364         dispute.initialNumberJurors = nbJurors;
1365         dispute.arbitrationFeePerJuror = arbitrationFeePerJuror; // We store it as the general fee can be changed through the governance mechanism.
1366         dispute.votes.length++;
1367         dispute.voteCounter.length++;
1368 
1369         DisputeCreation(disputeID, Arbitrable(msg.sender));
1370         return disputeID;
1371     }
1372 
1373     /** @dev Appeal a ruling. Note that it has to be called before the arbitrator contract calls rule.
1374      *  @param _disputeID ID of the dispute to be appealed.
1375      *  @param _extraData Standard but not used by this contract.
1376      */
1377     function appeal(uint _disputeID, bytes _extraData) public payable onlyDuring(Period.Appeal) {
1378         super.appeal(_disputeID,_extraData);
1379         Dispute storage dispute = disputes[_disputeID];
1380         require(msg.value >= appealCost(_disputeID, _extraData));
1381         require(dispute.session+dispute.appeals == session); // Dispute of the current session.
1382         require(dispute.arbitrated == msg.sender);
1383         
1384         dispute.appeals++;
1385         dispute.votes.length++;
1386         dispute.voteCounter.length++;
1387     }
1388 
1389     /** @dev Execute the ruling of a dispute which is in the state executable. UNTRUSTED.
1390      *  @param disputeID ID of the dispute to execute the ruling.
1391      */
1392     function executeRuling(uint disputeID) public {
1393         Dispute storage dispute = disputes[disputeID];
1394         require(dispute.state == DisputeState.Executable);
1395 
1396         dispute.state = DisputeState.Executed;
1397         dispute.arbitrated.rule(disputeID, dispute.voteCounter[dispute.appeals].winningChoice);
1398     }
1399 
1400     // **************************** //
1401     // *   Arbitrator functions   * //
1402     // *    Constant and pure     * //
1403     // **************************** //
1404 
1405     /** @dev Compute the cost of arbitration. It is recommended not to increase it often, 
1406      *  as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
1407      *  @param _extraData Null for the default number. Other first 16 bits will be used to return the number of jurors.
1408      *  @return fee Amount to be paid.
1409      */
1410     function arbitrationCost(bytes _extraData) public view returns (uint fee) {
1411         return extraDataToNbJurors(_extraData) * arbitrationFeePerJuror;
1412     }
1413 
1414     /** @dev Compute the cost of appeal. It is recommended not to increase it often, 
1415      *  as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
1416      *  @param _disputeID ID of the dispute to be appealed.
1417      *  @param _extraData Is not used there.
1418      *  @return fee Amount to be paid.
1419      */
1420     function appealCost(uint _disputeID, bytes _extraData) public view returns (uint fee) {
1421         Dispute storage dispute = disputes[_disputeID];
1422 
1423         if(dispute.appeals >= maxAppeals) return NON_PAYABLE_AMOUNT;
1424 
1425         return (2*amountJurors(_disputeID) + 1) * dispute.arbitrationFeePerJuror;
1426     }
1427 
1428     /** @dev Compute the amount of jurors to be drawn.
1429      *  @param _extraData Null for the default number. Other first 16 bits will be used to return the number of jurors.
1430      *  Note that it does not check that the number of jurors is odd, but users are advised to choose a odd number of jurors.
1431      */
1432     function extraDataToNbJurors(bytes _extraData) internal view returns (uint16 nbJurors) {
1433         if (_extraData.length < 2)
1434             return defaultNumberJuror;
1435         else
1436             return (uint16(_extraData[0]) << 8) + uint16(_extraData[1]);
1437     }
1438 
1439     /** @dev Compute the minimum activated pinakions in alpha.
1440      *  Note there may be multiple draws for a single user on a single dispute.
1441      */
1442     function getStakePerDraw() public view returns (uint minActivatedTokenInAlpha) {
1443         return (alpha * minActivatedToken) / ALPHA_DIVISOR;
1444     }
1445 
1446 
1447     // **************************** //
1448     // *     Constant getters     * //
1449     // **************************** //
1450 
1451     /** @dev Getter for account in Vote.
1452      *  @param _disputeID ID of the dispute.
1453      *  @param _appeals Which appeal (or 0 for the initial session).
1454      *  @param _voteID The ID of the vote for this appeal (or initial session).
1455      *  @return account The address of the voter.
1456      */
1457     function getVoteAccount(uint _disputeID, uint _appeals, uint _voteID) public view returns (address account) {
1458         return disputes[_disputeID].votes[_appeals][_voteID].account;
1459     }
1460 
1461     /** @dev Getter for ruling in Vote.
1462      *  @param _disputeID ID of the dispute.
1463      *  @param _appeals Which appeal (or 0 for the initial session).
1464      *  @param _voteID The ID of the vote for this appeal (or initial session).
1465      *  @return ruling The ruling given by the voter.
1466      */
1467     function getVoteRuling(uint _disputeID, uint _appeals, uint _voteID) public view returns (uint ruling) {
1468         return disputes[_disputeID].votes[_appeals][_voteID].ruling;
1469     }
1470 
1471     /** @dev Getter for winningChoice in VoteCounter.
1472      *  @param _disputeID ID of the dispute.
1473      *  @param _appeals Which appeal (or 0 for the initial session).
1474      *  @return winningChoice The currently winning choice (or 0 if it's tied). Note that 0 can also be return if the majority refuses to arbitrate.
1475      */
1476     function getWinningChoice(uint _disputeID, uint _appeals) public view returns (uint winningChoice) {
1477         return disputes[_disputeID].voteCounter[_appeals].winningChoice;
1478     }
1479 
1480     /** @dev Getter for winningCount in VoteCounter.
1481      *  @param _disputeID ID of the dispute.
1482      *  @param _appeals Which appeal (or 0 for the initial session).
1483      *  @return winningCount The amount of votes the winning choice (or those who are tied) has.
1484      */
1485     function getWinningCount(uint _disputeID, uint _appeals) public view returns (uint winningCount) {
1486         return disputes[_disputeID].voteCounter[_appeals].winningCount;
1487     }
1488 
1489     /** @dev Getter for voteCount in VoteCounter.
1490      *  @param _disputeID ID of the dispute.
1491      *  @param _appeals Which appeal (or 0 for the initial session).
1492      *  @param _choice The choice.
1493      *  @return voteCount The amount of votes the winning choice (or those who are tied) has.
1494      */
1495     function getVoteCount(uint _disputeID, uint _appeals, uint _choice) public view returns (uint voteCount) {
1496         return disputes[_disputeID].voteCounter[_appeals].voteCount[_choice];
1497     }
1498 
1499     /** @dev Getter for lastSessionVote in Dispute.
1500      *  @param _disputeID ID of the dispute.
1501      *  @param _juror The juror we want to get the last session he voted.
1502      *  @return lastSessionVote The last session the juror voted.
1503      */
1504     function getLastSessionVote(uint _disputeID, address _juror) public view returns (uint lastSessionVote) {
1505         return disputes[_disputeID].lastSessionVote[_juror];
1506     }
1507 
1508     /** @dev Is the juror drawn in the draw of the dispute.
1509      *  @param _disputeID ID of the dispute.
1510      *  @param _juror The juror.
1511      *  @param _draw The draw. Note that it starts at 1.
1512      *  @return drawn True if the juror is drawn, false otherwise.
1513      */
1514     function isDrawn(uint _disputeID, address _juror, uint _draw) public view returns (bool drawn) {
1515         Dispute storage dispute = disputes[_disputeID];
1516         Juror storage juror = jurors[_juror];
1517         if (juror.lastSession != session
1518         || (dispute.session+dispute.appeals != session)
1519         || period<=Period.Draw
1520         || _draw>amountJurors(_disputeID)
1521         || _draw==0
1522         || segmentSize==0
1523         ) {
1524             return false;
1525         } else {
1526             uint position = uint(keccak256(randomNumber,_disputeID,_draw)) % segmentSize;
1527             return (position >= juror.segmentStart) && (position < juror.segmentEnd);
1528         }
1529 
1530     }
1531 
1532     /** @dev Return the current ruling of a dispute. This is useful for parties to know if they should appeal.
1533      *  @param _disputeID ID of the dispute.
1534      *  @return ruling The current ruling which will be given if there is no appeal. If it is not available, return 0.
1535      */
1536     function currentRuling(uint _disputeID) public view returns (uint ruling) {
1537         Dispute storage dispute = disputes[_disputeID];
1538         return dispute.voteCounter[dispute.appeals].winningChoice;
1539     }
1540 
1541     /** @dev Return the status of a dispute.
1542      *  @param _disputeID ID of the dispute to rule.
1543      *  @return status The status of the dispute.
1544      */
1545     function disputeStatus(uint _disputeID) public view returns (DisputeStatus status) {
1546         Dispute storage dispute = disputes[_disputeID];
1547         if (dispute.session+dispute.appeals < session) // Dispute of past session.
1548             return DisputeStatus.Solved;
1549         else if(dispute.session+dispute.appeals == session) { // Dispute of current session.
1550             if (dispute.state == DisputeState.Open) {
1551                 if (period < Period.Appeal)
1552                     return DisputeStatus.Waiting;
1553                 else if (period == Period.Appeal)
1554                     return DisputeStatus.Appealable;
1555                 else return DisputeStatus.Solved;
1556             } else return DisputeStatus.Solved;
1557         } else return DisputeStatus.Waiting; // Dispute for future session.
1558     }
1559 
1560     // **************************** //
1561     // *     Governor Functions   * //
1562     // **************************** //
1563 
1564     /** @dev General call function where the contract execute an arbitrary call with data and ETH following governor orders.
1565      *  @param _data Transaction data.
1566      *  @param _value Transaction value.
1567      *  @param _target Transaction target.
1568      */
1569     function executeOrder(bytes32 _data, uint _value, address _target) public onlyGovernor {
1570         _target.call.value(_value)(_data);
1571     }
1572 
1573     /** @dev Setter for rng.
1574      *  @param _rng An instance of RNG.
1575      */
1576     function setRng(RNG _rng) public onlyGovernor {
1577         rng = _rng;
1578     }
1579 
1580     /** @dev Setter for arbitrationFeePerJuror.
1581      *  @param _arbitrationFeePerJuror The fee which will be paid to each juror.
1582      */
1583     function setArbitrationFeePerJuror(uint _arbitrationFeePerJuror) public onlyGovernor {
1584         arbitrationFeePerJuror = _arbitrationFeePerJuror;
1585     }
1586 
1587     /** @dev Setter for defaultNumberJuror.
1588      *  @param _defaultNumberJuror Number of drawn jurors unless specified otherwise.
1589      */
1590     function setDefaultNumberJuror(uint16 _defaultNumberJuror) public onlyGovernor {
1591         defaultNumberJuror = _defaultNumberJuror;
1592     }
1593 
1594     /** @dev Setter for minActivatedToken.
1595      *  @param _minActivatedToken Minimum of tokens to be activated (in basic units).
1596      */
1597     function setMinActivatedToken(uint _minActivatedToken) public onlyGovernor {
1598         minActivatedToken = _minActivatedToken;
1599     }
1600 
1601     /** @dev Setter for timePerPeriod.
1602      *  @param _timePerPeriod The minimum time each period lasts (seconds).
1603      */
1604     function setTimePerPeriod(uint[5] _timePerPeriod) public onlyGovernor {
1605         timePerPeriod = _timePerPeriod;
1606     }
1607 
1608     /** @dev Setter for alpha.
1609      *  @param _alpha Alpha in ‱.
1610      */
1611     function setAlpha(uint _alpha) public onlyGovernor {
1612         alpha = _alpha;
1613     }
1614 
1615     /** @dev Setter for maxAppeals.
1616      *  @param _maxAppeals Number of times a dispute can be appealed. When exceeded appeal cost becomes NON_PAYABLE_AMOUNT.
1617      */
1618     function setMaxAppeals(uint _maxAppeals) public onlyGovernor {
1619         maxAppeals = _maxAppeals;
1620     }
1621 
1622     /** @dev Setter for governor.
1623      *  @param _governor Address of the governor contract.
1624      */
1625     function setGovernor(address _governor) public onlyGovernor {
1626         governor = _governor;
1627     }
1628 }