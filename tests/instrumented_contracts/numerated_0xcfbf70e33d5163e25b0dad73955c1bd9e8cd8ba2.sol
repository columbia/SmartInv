1 pragma solidity 0.5.9;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /// @dev It is ERC20 compliant, but still needs to under go further testing.
34 
35 contract Ownable {
36     address payable public owner;
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39     /**
40      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41      * account.
42      */
43     constructor () public {
44         owner = msg.sender;
45     }
46 
47     /**
48      * @dev Throws if called by any account other than the owner.
49      */
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param _newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address payable _newOwner) external onlyOwner {
60         require(_newOwner != address(0));
61         owner = _newOwner;
62         emit OwnershipTransferred(owner, _newOwner);
63     }
64 }
65 
66 contract ApproveAndCallFallBack {
67     function receiveApproval(address from, uint256 _amount, address _token, bytes calldata  _data) external;
68 }
69 
70 /// @dev The actual token contract, the default owner is the msg.sender
71 contract WINSToken is Ownable {
72 
73     string public name;                //The Token's name: e.g. DigixDAO Tokens
74     uint8 public decimals;             //Number of decimals of the smallest unit
75     string public symbol;              //An identifier: e.g. REP
76 
77     /// @dev `Checkpoint` is the structure that attaches a block number to a
78     ///  given value, the block number attached is the one that last changed the
79     ///  value
80     struct  Checkpoint {
81 
82         // `fromBlock` is the block number that the value was generated from
83         uint128 fromBlock;
84 
85         // `value` is the amount of tokens at a specific block number
86         uint128 value;
87     }
88 
89     // `creationBlock` is the block number that the Clone Token was created
90     uint public creationBlock;
91 
92     // Flag that determines if the token is transferable or not.
93     bool public transfersEnabled;
94 
95     // `balances` is the map that tracks the balance of each address, in this
96     //  contract when the balance changes the block number that the change
97     //  occurred is also included in the map
98     mapping (address => Checkpoint[]) balances;
99 
100     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
101     mapping (address => mapping (address => uint256)) allowed;
102 
103     // Tracks the history of the `totalSupply` of the token
104     Checkpoint[] totalSupplyHistory;
105     Checkpoint[] totalSupplyHolders;
106     mapping (address => bool) public holders;
107     uint public minHolderAmount = 20000 ether;
108 
109     ////////////////
110     // Events
111     ////////////////
112     event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
113     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
114     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
115 
116 
117     modifier whenTransfersEnabled() {
118         require(transfersEnabled);
119         _;
120     }
121 
122     ////////////////
123     // Constructor
124     ////////////////
125 
126 
127     constructor () public {
128         name = "WINS LIVE";
129         symbol = "WNL";
130         decimals = 18;
131         creationBlock = block.number;
132         transfersEnabled = true;
133 
134         //initial emission
135         uint _amount = 77777777 * (10 ** uint256(decimals));
136         updateValueAtNow(totalSupplyHistory, _amount);
137         updateValueAtNow(balances[msg.sender], _amount);
138 
139         holders[msg.sender] = true;
140         updateValueAtNow(totalSupplyHolders, _amount);
141         emit Transfer(address(0), msg.sender, _amount);
142     }
143 
144 
145     /// @notice The fallback function
146     function () external payable {}
147 
148     ///////////////////
149     // ERC20 Methods
150     ///////////////////
151 
152     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
153     /// @param _to The address of the recipient
154     /// @param _amount The amount of tokens to be transferred
155     /// @return Whether the transfer was successful or not
156     function transfer(address _to, uint256 _amount) whenTransfersEnabled external returns (bool) {
157         doTransfer(msg.sender, _to, _amount);
158         return true;
159     }
160 
161     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
162     ///  is approved by `_from`
163     /// @param _from The address holding the tokens being transferred
164     /// @param _to The address of the recipient
165     /// @param _amount The amount of tokens to be transferred
166     /// @return True if the transfer was successful
167     function transferFrom(address _from, address _to, uint256 _amount) whenTransfersEnabled external returns (bool) {
168         // The standard ERC 20 transferFrom functionality
169         require(allowed[_from][msg.sender] >= _amount);
170         allowed[_from][msg.sender] -= _amount;
171         doTransfer(_from, _to, _amount);
172         return true;
173     }
174 
175     /// @dev This is the actual transfer function in the token contract, it can
176     ///  only be called by other functions in this contract.
177     /// @param _from The address holding the tokens being transferred
178     /// @param _to The address of the recipient
179     /// @param _amount The amount of tokens to be transferred
180     /// @return True if the transfer was successful
181     function doTransfer(address _from, address _to, uint _amount) internal {
182 
183         if (_amount == 0) {
184             emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
185             return;
186         }
187 
188         // Do not allow transfer to 0x0 or the token contract itself
189         require((_to != address(0)) && (_to != address(this)));
190 
191         // If the amount being transfered is more than the balance of the
192         //  account the transfer throws
193         uint previousBalanceFrom = balanceOfAt(_from, block.number);
194 
195         require(previousBalanceFrom >= _amount);
196 
197         // First update the balance array with the new value for the address
198         //  sending the tokens
199         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
200 
201         // Then update the balance array with the new value for the address
202         //  receiving the tokens
203         uint previousBalanceTo = balanceOfAt(_to, block.number);
204         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
205         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
206 
207         // An event to make the transfer easy to find on the blockchain
208         emit Transfer(_from, _to, _amount);
209 
210 
211         uint curTotalSupplyHolders = totalSupplyHoldersAt(block.number);
212 
213         if (holders[_from]) {
214             if (previousBalanceFrom - _amount < minHolderAmount) {
215                 delete holders[_from];
216                 require(curTotalSupplyHolders >= previousBalanceFrom);
217                 curTotalSupplyHolders = curTotalSupplyHolders - previousBalanceFrom;
218                 updateValueAtNow(totalSupplyHolders, curTotalSupplyHolders);
219             } else {
220                 require(curTotalSupplyHolders >= _amount);
221                 curTotalSupplyHolders = curTotalSupplyHolders - _amount;
222                 updateValueAtNow(totalSupplyHolders, curTotalSupplyHolders);
223             }
224         }
225 
226         if (previousBalanceTo + _amount >= minHolderAmount) {
227             if (holders[_to]) {
228                 require(curTotalSupplyHolders + _amount >= curTotalSupplyHolders); // Check for overflow
229                 updateValueAtNow(totalSupplyHolders, curTotalSupplyHolders + _amount);
230             }
231 
232             if (!holders[_to]) {
233                 holders[_to] = true;
234                 require(curTotalSupplyHolders + previousBalanceTo + _amount >= curTotalSupplyHolders); // Check for overflow
235                 updateValueAtNow(totalSupplyHolders, curTotalSupplyHolders + previousBalanceTo + _amount);
236             }
237         }
238 
239 
240     }
241 
242     /// @param _owner The address that's balance is being requested
243     /// @return The balance of `_owner` at the current block
244     function balanceOf(address _owner) external view returns (uint256 balance) {
245         return balanceOfAt(_owner, block.number);
246     }
247 
248     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
249     ///  its behalf. This is a modified version of the ERC20 approve function
250     ///  to be a little bit safer
251     /// @param _spender The address of the account able to transfer the tokens
252     /// @param _amount The amount of tokens to be approved for transfer
253     /// @return True if the approval was successful
254     function approve(address _spender, uint256 _amount) whenTransfersEnabled public returns (bool) {
255         // To change the approve amount you first have to reduce the addresses`
256         //  allowance to zero by calling `approve(_spender,0)` if it is not
257         //  already 0 to mitigate the race condition described here:
258         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
260 
261         allowed[msg.sender][_spender] = _amount;
262         emit Approval(msg.sender, _spender, _amount);
263         return true;
264     }
265 
266     /**
267      * @dev Increase the amount of tokens that an owner allowed to a spender.
268      *
269      * approve should be called when allowance[_spender] == 0. To increment
270      * allowed value is better to use this function to avoid 2 calls (and wait until
271      * the first transaction is mined)
272      * From MonolithDAO Token.sol
273      * @param _spender The address which will spend the funds.
274      * @param _addedAmount The amount of tokens to increase the allowance by.
275      */
276     function increaseApproval(address _spender, uint _addedAmount) external returns (bool) {
277         require(allowed[msg.sender][_spender] + _addedAmount >= allowed[msg.sender][_spender]); // Check for overflow
278         allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedAmount;
279         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280         return true;
281     }
282 
283     /**
284      * @dev Decrease the amount of tokens that an owner allowed to a spender.
285      *
286      * approve should be called when allowance[_spender] == 0. To decrement
287      * allowed value is better to use this function to avoid 2 calls (and wait until
288      * the first transaction is mined)
289      * From MonolithDAO Token.sol
290      * @param _spender The address which will spend the funds.
291      * @param _subtractedAmount The amount of tokens to decrease the allowance by.
292      */
293     function decreaseApproval(address _spender, uint _subtractedAmount) external returns (bool)
294     {
295         uint oldValue = allowed[msg.sender][_spender];
296         if (_subtractedAmount >= oldValue) {
297             allowed[msg.sender][_spender] = 0;
298         } else {
299             allowed[msg.sender][_spender] = oldValue - _subtractedAmount;
300         }
301         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302         return true;
303     }
304 
305 
306     /// @dev This function makes it easy to read the `allowed[]` map
307     /// @param _owner The address of the account that owns the token
308     /// @param _spender The address of the account able to transfer the tokens
309     /// @return Amount of remaining tokens of _owner that _spender is allowed
310     ///  to spend
311     function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
312         return allowed[_owner][_spender];
313     }
314 
315     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
316     ///  its behalf, and then a function is triggered in the contract that is
317     ///  being approved, `_spender`. This allows users to use their tokens to
318     ///  interact with contracts in one function call instead of two
319     /// @param _spender The address of the contract able to transfer the tokens
320     /// @param _amount The amount of tokens to be approved for transfer
321     /// @return True if the function call was successful
322     function approveAndCall(address _spender, uint256 _amount, bytes calldata _extraData) external returns (bool) {
323         require(approve(_spender, _amount));
324 
325         ApproveAndCallFallBack(_spender).receiveApproval(
326             msg.sender,
327             _amount,
328             address(this),
329             _extraData
330         );
331 
332         return true;
333     }
334 
335     /// @dev This function makes it easy to get the total number of tokens
336     /// @return The total number of tokens
337     function totalSupply() external view returns (uint) {
338         return totalSupplyAt(block.number);
339     }
340 
341     function currentTotalSupplyHolders() external view returns (uint) {
342         return totalSupplyHoldersAt(block.number);
343     }
344 
345     ////////////////
346     // Query balance and totalSupply in History
347     ////////////////
348 
349     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
350     /// @param _owner The address from which the balance will be retrieved
351     /// @param _blockNumber The block number when the balance is queried
352     /// @return The balance at `_blockNumber`
353     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint) {
354         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
355             return 0;
356             // This will return the expected balance during normal situations
357         } else {
358             return getValueAt(balances[_owner], _blockNumber);
359         }
360     }
361 
362     /// @notice Total amount of tokens at a specific `_blockNumber`.
363     /// @param _blockNumber The block number when the totalSupply is queried
364     /// @return The total amount of tokens at `_blockNumber`
365     function totalSupplyAt(uint _blockNumber) public view returns(uint) {
366         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
367             return 0;
368             // This will return the expected totalSupply during normal situations
369         } else {
370             return getValueAt(totalSupplyHistory, _blockNumber);
371         }
372     }
373 
374 
375     function totalSupplyHoldersAt(uint _blockNumber) public view returns(uint) {
376         if ((totalSupplyHolders.length == 0) || (totalSupplyHolders[0].fromBlock > _blockNumber)) {
377             return 0;
378             // This will return the expected totalSupply during normal situations
379         } else {
380             return getValueAt(totalSupplyHolders, _blockNumber);
381         }
382     }
383 
384     function isHolder(address _holder) external view returns(bool) {
385         return holders[_holder];
386     }
387 
388 
389     function destroyTokens(uint _amount) onlyOwner public returns (bool) {
390         uint curTotalSupply = totalSupplyAt(block.number);
391         require(curTotalSupply >= _amount);
392         uint previousBalanceFrom = balanceOfAt(msg.sender, block.number);
393 
394         require(previousBalanceFrom >= _amount);
395         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
396         updateValueAtNow(balances[msg.sender], previousBalanceFrom - _amount);
397         emit Transfer(msg.sender, address(0), _amount);
398 
399         uint curTotalSupplyHolders = totalSupplyHoldersAt(block.number);
400         if (holders[msg.sender]) {
401             if (previousBalanceFrom - _amount < minHolderAmount) {
402                 delete holders[msg.sender];
403                 require(curTotalSupplyHolders >= previousBalanceFrom);
404                 updateValueAtNow(totalSupplyHolders, curTotalSupplyHolders - previousBalanceFrom);
405             } else {
406                 require(curTotalSupplyHolders >= _amount);
407                 updateValueAtNow(totalSupplyHolders, curTotalSupplyHolders - _amount);
408             }
409         }
410         return true;
411     }
412 
413 
414     ////////////////
415     // Enable tokens transfers
416     ////////////////
417 
418 
419     /// @notice Enables token holders to transfer their tokens freely if true
420     /// @param _transfersEnabled True if transfers are allowed in the clone
421     function enableTransfers(bool _transfersEnabled) public onlyOwner {
422         transfersEnabled = _transfersEnabled;
423     }
424 
425     ////////////////
426     // Internal helper functions to query and set a value in a snapshot array
427     ////////////////
428 
429     /// @dev `getValueAt` retrieves the number of tokens at a given block number
430     /// @param checkpoints The history of values being queried
431     /// @param _block The block number to retrieve the value at
432     /// @return The number of tokens being queried
433     function getValueAt(Checkpoint[] storage checkpoints, uint _block) view internal returns (uint) {
434         if (checkpoints.length == 0) return 0;
435 
436         // Shortcut for the actual value
437         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
438             return checkpoints[checkpoints.length-1].value;
439         if (_block < checkpoints[0].fromBlock) return 0;
440 
441         // Binary search of the value in the array
442         uint min = 0;
443         uint max = checkpoints.length-1;
444         while (max > min) {
445             uint mid = (max + min + 1)/ 2;
446             if (checkpoints[mid].fromBlock<=_block) {
447                 min = mid;
448             } else {
449                 max = mid-1;
450             }
451         }
452         return checkpoints[min].value;
453     }
454 
455     /// @dev `updateValueAtNow` used to update the `balances` map and the
456     ///  `totalSupplyHistory`
457     /// @param checkpoints The history of data being updated
458     /// @param _value The new number of tokens
459     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal  {
460         if ((checkpoints.length == 0)
461             || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
462             Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
463             newCheckPoint.fromBlock =  uint128(block.number);
464             newCheckPoint.value = uint128(_value);
465         } else {
466             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
467             oldCheckPoint.value = uint128(_value);
468         }
469     }
470 
471 
472     /// @dev Helper function to return a min betwen the two uints
473     function min(uint a, uint b) pure internal returns (uint) {
474         return a < b ? a : b;
475     }
476 
477 
478 
479     //////////
480     // Safety Methods
481     //////////
482 
483     /// @notice This method can be used by the owner to extract mistakenly
484     ///  sent tokens to this contract.
485     /// @param _token The address of the token contract that you want to recover
486     ///  set to 0 in case you want to extract ether.
487     function claimTokens(address payable _token) external onlyOwner {
488         if (_token == address(0)) {
489             owner.transfer(address(this).balance);
490             return;
491         }
492 
493         WINSToken token = WINSToken(_token);
494         uint balance = token.balanceOf(address(this));
495         token.transfer(owner, balance);
496         emit ClaimedTokens(_token, owner, balance);
497     }
498 
499 
500     function setMinHolderAmount(uint _minHolderAmount) external onlyOwner {
501         minHolderAmount = _minHolderAmount;
502     }
503 }
504 
505 
506 contract DividendManager is Ownable {
507     using SafeMath for uint;
508 
509     event DividendDeposited(address indexed _depositor, uint256 _blockNumber, uint256 _amount, uint256 _totalSupply, uint256 _dividendIndex);
510     event DividendClaimed(address indexed _claimer, uint256 _dividendIndex, uint256 _claim);
511     event DividendRecycled(address indexed _recycler, uint256 _blockNumber, uint256 _amount, uint256 _totalSupply, uint256 _dividendIndex);
512 
513     WINSToken public token;
514 
515     uint256 public RECYCLE_TIME = 365 days;
516     uint public minHolderAmount = 20000 ether;
517 
518     struct Dividend {
519         uint256 blockNumber;
520         uint256 timestamp;
521         uint256 amount;
522         uint256 claimedAmount;
523         uint256 totalSupply;
524         bool recycled;
525         mapping (address => bool) claimed;
526     }
527 
528     Dividend[] public dividends;
529 
530     mapping (address => uint256) dividendsClaimed;
531 
532     struct NotClaimed {
533         uint listIndex;
534         bool exists;
535     }
536 
537     mapping (address => NotClaimed) public notClaimed;
538     address[] public notClaimedList;
539 
540     modifier validDividendIndex(uint256 _dividendIndex) {
541         require(_dividendIndex < dividends.length);
542         _;
543     }
544 
545     constructor(address payable _token) public {
546         token = WINSToken(_token);
547     }
548 
549     function depositDividend() payable public {
550         uint256 currentSupply = token.totalSupplyHoldersAt(block.number);
551 
552         uint i;
553         for( i = 0; i < notClaimedList.length; i++) {
554             if (token.isHolder(notClaimedList[i])) {
555                 currentSupply = currentSupply.sub(token.balanceOf(notClaimedList[i]));
556             }
557         }
558 
559         uint256 dividendIndex = dividends.length;
560         uint256 blockNumber = SafeMath.sub(block.number, 1);
561         dividends.push(
562             Dividend(
563                 blockNumber,
564                 getNow(),
565                 msg.value,
566                 0,
567                 currentSupply,
568                 false
569             )
570         );
571         emit DividendDeposited(msg.sender, blockNumber, msg.value, currentSupply, dividendIndex);
572     }
573 
574 
575     function claimDividend(uint256 _dividendIndex) public validDividendIndex(_dividendIndex)
576     {
577         require(!notClaimed[msg.sender].exists);
578 
579         Dividend storage dividend = dividends[_dividendIndex];
580 
581         require(dividend.claimed[msg.sender] == false);
582         require(dividend.recycled == false);
583 
584         uint256 balance = token.balanceOfAt(msg.sender, dividend.blockNumber);
585         require(balance >= minHolderAmount);
586 
587         uint256 claim = balance.mul(dividend.amount).div(dividend.totalSupply);
588         dividend.claimed[msg.sender] = true;
589         dividend.claimedAmount = SafeMath.add(dividend.claimedAmount, claim);
590 
591         if (claim > 0) {
592             msg.sender.transfer(claim);
593             emit DividendClaimed(msg.sender, _dividendIndex, claim);
594         }
595     }
596 
597     function claimDividendAll() public {
598         require(dividendsClaimed[msg.sender] < dividends.length);
599         for (uint i = dividendsClaimed[msg.sender]; i < dividends.length; i++) {
600             if ((dividends[i].claimed[msg.sender] == false) && (dividends[i].recycled == false)) {
601                 dividendsClaimed[msg.sender] = SafeMath.add(i, 1);
602                 claimDividend(i);
603             }
604         }
605     }
606 
607     function recycleDividend(uint256 _dividendIndex) public
608     onlyOwner
609     validDividendIndex(_dividendIndex)
610     {
611         Dividend storage dividend = dividends[_dividendIndex];
612         require(dividend.recycled == false);
613         require(dividend.timestamp < SafeMath.sub(getNow(), RECYCLE_TIME));
614         dividends[_dividendIndex].recycled = true;
615         uint256 currentSupply = token.totalSupplyAt(block.number);
616         uint256 remainingAmount = SafeMath.sub(dividend.amount, dividend.claimedAmount);
617         uint256 dividendIndex = dividends.length;
618         uint256 blockNumber = SafeMath.sub(block.number, 1);
619         dividends.push(
620             Dividend(
621                 blockNumber,
622                 getNow(),
623                 remainingAmount,
624                 0,
625                 currentSupply,
626                 false
627             )
628         );
629         emit DividendRecycled(msg.sender, blockNumber, remainingAmount, currentSupply, dividendIndex);
630     }
631 
632     //Function is mocked for tests
633     function getNow() internal view returns (uint256) {
634         return now;
635     }
636 
637     function dividendsCount() external view returns (uint) {
638         return dividends.length;
639     }
640 
641 
642     function registerNotClaimed(address _notClaimed) onlyOwner public {
643         require(_notClaimed != address(0));
644         if (!notClaimed[_notClaimed].exists) {
645             notClaimed[_notClaimed] = NotClaimed({
646                 listIndex: notClaimedList.length,
647                 exists: true
648                 });
649             notClaimedList.push(_notClaimed);
650         }
651     }
652 
653 
654     function unregisterNotClaimed(address _notClaimed) onlyOwner public {
655         require(notClaimed[_notClaimed].exists && notClaimedList.length > 0);
656         uint lastIdx = notClaimedList.length - 1;
657         notClaimed[notClaimedList[lastIdx]].listIndex = notClaimed[_notClaimed].listIndex;
658         notClaimedList[notClaimed[_notClaimed].listIndex] = notClaimedList[lastIdx];
659         notClaimedList.length--;
660         delete notClaimed[_notClaimed];
661     }
662 
663     /// @notice This method can be used by the owner to extract mistakenly
664     ///  sent tokens to this contract.
665     /// @param _token The address of the token contract that you want to recover
666     ///  set to 0 in case you want to extract ether.
667     function claimTokens(address payable _token) external onlyOwner {
668         //        if (_token == 0x0) {
669         //            owner.transfer(address(this).balance);
670         //            return;
671         //        }
672 
673         WINSToken claimToken = WINSToken(_token);
674         uint balance = claimToken.balanceOf(address(this));
675         claimToken.transfer(owner, balance);
676     }
677 }