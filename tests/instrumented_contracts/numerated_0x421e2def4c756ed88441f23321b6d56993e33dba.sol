1 pragma solidity 0.5.9;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 /**
33  * @title Ownable
34  * @dev The Ownable contract has an owner address, and provides basic authorization control
35  * functions, this simplifies the implementation of "user permissions".
36  */
37 contract Ownable {
38     address payable public owner;
39     mapping(address => bool) managers;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45      * account.
46      */
47     constructor () internal {
48         owner = msg.sender;
49         managers[msg.sender] = true;
50         emit OwnershipTransferred(address(0), owner);
51     }
52 
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(isOwner());
59         _;
60     }
61 
62 
63     modifier onlyManager() {
64         require(isManager(msg.sender));
65         _;
66     }
67     /**
68      * @return true if `msg.sender` is the owner of the contract.
69      */
70     function isOwner() public view returns (bool) {
71         return msg.sender == owner;
72     }
73 
74 
75     function isManager(address _manager) public view returns (bool) {
76         return managers[_manager];
77     }
78 
79 
80     function addManager(address _manager) external onlyOwner {
81         require(_manager != address(0));
82         managers[_manager] = true;
83     }
84 
85 
86     function delManager(address _manager) external onlyOwner {
87         require(managers[_manager]);
88         managers[_manager] = false;
89     }
90 
91     /**
92      * @dev Allows the current owner to transfer control of the contract to a newOwner.
93      * @param newOwner The address to transfer ownership to.
94      */
95     function transferOwnership(address payable newOwner) public onlyOwner {
96         require(newOwner != address(0));
97         emit OwnershipTransferred(owner, newOwner);
98         owner = newOwner;
99     }
100 }
101 
102 contract ApproveAndCallFallBack {
103     function receiveApproval(address from, uint256 _amount, address _token, bytes calldata _data) external;
104 }
105 
106 /// @dev The actual token contract, the default owner is the msg.sender
107 contract Token is Ownable {
108 
109     string public name;                //The Token's name: e.g. DigixDAO Tokens
110     uint8 public decimals;             //Number of decimals of the smallest unit
111     string public symbol;              //An identifier: e.g. REP
112 
113     /// @dev `Checkpoint` is the structure that attaches a block number to a
114     ///  given value, the block number attached is the one that last changed the
115     ///  value
116     struct  Checkpoint {
117 
118         // `fromBlock` is the block number that the value was generated from
119         uint128 fromBlock;
120 
121         // `value` is the amount of tokens at a specific block number
122         uint128 value;
123     }
124 
125 
126     // `parentSnapShotBlock` is the block number from the Parent Token that was
127     //  used to determine the initial distribution of the Clone Token
128     uint public parentSnapShotBlock;
129 
130     // `creationBlock` is the block number that the Clone Token was created
131     uint public creationBlock;
132 
133     // `balances` is the map that tracks the balance of each address, in this
134     //  contract when the balance changes the block number that the change
135     //  occurred is also included in the map
136     mapping (address => Checkpoint[]) balances;
137 
138     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
139     mapping (address => mapping (address => uint256)) allowed;
140 
141     // Tracks the history of the `totalSupply` of the token
142     Checkpoint[] totalSupplyHistory;
143 
144     ////////////////
145     // Events
146     ////////////////
147     event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
148     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
149     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
150 
151     ////////////////
152     // Constructor
153     ////////////////
154 
155     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
156     ///  new token
157     /// @param _parentSnapShotBlock Block of the parent token that will
158     ///  determine the initial distribution of the clone token, set to 0 if it
159     ///  is a new token
160     constructor () public {
161         name = "Blockchain Partners Coin";
162         symbol = "BPC";
163         decimals = 18;
164         parentSnapShotBlock = block.number;
165         creationBlock = block.number;
166 
167         //initial emission
168         uint _amount = 21000000 * (10 ** uint256(decimals));
169         updateValueAtNow(totalSupplyHistory, _amount);
170         updateValueAtNow(balances[msg.sender], _amount);
171         emit Transfer(address(0), msg.sender, _amount);
172     }
173 
174 
175     /// @notice The fallback function
176     function () external {}
177 
178     ///////////////////
179     // ERC20 Methods
180     ///////////////////
181 
182     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
183     /// @param _to The address of the recipient
184     /// @param _amount The amount of tokens to be transferred
185     /// @return Whether the transfer was successful or not
186     function transfer(address _to, uint256 _amount) external returns (bool success) {
187         doTransfer(msg.sender, _to, _amount);
188         return true;
189     }
190 
191     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
192     ///  is approved by `_from`
193     /// @param _from The address holding the tokens being transferred
194     /// @param _to The address of the recipient
195     /// @param _amount The amount of tokens to be transferred
196     /// @return True if the transfer was successful
197     function transferFrom(address _from, address _to, uint256 _amount) external returns (bool success) {
198         // The standard ERC 20 transferFrom functionality
199         require(allowed[_from][msg.sender] >= _amount);
200         allowed[_from][msg.sender] -= _amount;
201         doTransfer(_from, _to, _amount);
202         return true;
203     }
204 
205     /// @dev This is the actual transfer function in the token contract, it can
206     ///  only be called by other functions in this contract.
207     /// @param _from The address holding the tokens being transferred
208     /// @param _to The address of the recipient
209     /// @param _amount The amount of tokens to be transferred
210     /// @return True if the transfer was successful
211     function doTransfer(address _from, address _to, uint _amount) internal {
212 
213         if (_amount == 0) {
214             emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
215             return;
216         }
217 
218         require(parentSnapShotBlock < block.number);
219 
220         // Do not allow transfer to 0x0 or the token contract itself
221         require((_to != address(0)) && (_to != address(this)));
222 
223         // If the amount being transfered is more than the balance of the
224         //  account the transfer throws
225         uint previousBalanceFrom = balanceOfAt(_from, block.number);
226 
227         require(previousBalanceFrom >= _amount);
228 
229         // First update the balance array with the new value for the address
230         //  sending the tokens
231         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
232 
233         // Then update the balance array with the new value for the address
234         //  receiving the tokens
235         uint previousBalanceTo = balanceOfAt(_to, block.number);
236         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
237         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
238 
239         // An event to make the transfer easy to find on the blockchain
240         emit Transfer(_from, _to, _amount);
241 
242     }
243 
244     /// @param _owner The address that's balance is being requested
245     /// @return The balance of `_owner` at the current block
246     function balanceOf(address _owner) public view returns (uint256 balance) {
247         return balanceOfAt(_owner, block.number);
248     }
249 
250     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
251     ///  its behalf. This is a modified version of the ERC20 approve function
252     ///  to be a little bit safer
253     /// @param _spender The address of the account able to transfer the tokens
254     /// @param _amount The amount of tokens to be approved for transfer
255     /// @return True if the approval was successful
256     function approve(address _spender, uint256 _amount) public returns (bool success) {
257         // To change the approve amount you first have to reduce the addresses`
258         //  allowance to zero by calling `approve(_spender,0)` if it is not
259         //  already 0 to mitigate the race condition described here:
260         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
262 
263         allowed[msg.sender][_spender] = _amount;
264         emit Approval(msg.sender, _spender, _amount);
265         return true;
266     }
267 
268     /**
269      * @dev Increase the amount of tokens that an owner allowed to a spender.
270      *
271      * approve should be called when allowance[_spender] == 0. To increment
272      * allowed value is better to use this function to avoid 2 calls (and wait until
273      * the first transaction is mined)
274      * From MonolithDAO Token.sol
275      * @param _spender The address which will spend the funds.
276      * @param _addedAmount The amount of tokens to increase the allowance by.
277      */
278     function increaseApproval(address _spender, uint _addedAmount) external returns (bool) {
279         require(allowed[msg.sender][_spender] + _addedAmount >= allowed[msg.sender][_spender]); // Check for overflow
280         allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedAmount;
281         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282         return true;
283     }
284 
285     /**
286      * @dev Decrease the amount of tokens that an owner allowed to a spender.
287      *
288      * approve should be called when allowance[_spender] == 0. To decrement
289      * allowed value is better to use this function to avoid 2 calls (and wait until
290      * the first transaction is mined)
291      * From MonolithDAO Token.sol
292      * @param _spender The address which will spend the funds.
293      * @param _subtractedAmount The amount of tokens to decrease the allowance by.
294      */
295     function decreaseApproval(address _spender, uint _subtractedAmount) external returns (bool)
296     {
297         uint oldValue = allowed[msg.sender][_spender];
298         if (_subtractedAmount >= oldValue) {
299             allowed[msg.sender][_spender] = 0;
300         } else {
301             allowed[msg.sender][_spender] = oldValue - _subtractedAmount;
302         }
303         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304         return true;
305     }
306 
307 
308     /// @dev This function makes it easy to read the `allowed[]` map
309     /// @param _owner The address of the account that owns the token
310     /// @param _spender The address of the account able to transfer the tokens
311     /// @return Amount of remaining tokens of _owner that _spender is allowed
312     ///  to spend
313     function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
314         return allowed[_owner][_spender];
315     }
316 
317     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
318     ///  its behalf, and then a function is triggered in the contract that is
319     ///  being approved, `_spender`. This allows users to use their tokens to
320     ///  interact with contracts in one function call instead of two
321     /// @param _spender The address of the contract able to transfer the tokens
322     /// @param _amount The amount of tokens to be approved for transfer
323     /// @return True if the function call was successful
324     function approveAndCall(address _spender, uint256 _amount, bytes calldata _extraData) external returns (bool success) {
325         require(approve(_spender, _amount));
326 
327         ApproveAndCallFallBack(_spender).receiveApproval(
328             msg.sender,
329             _amount,
330             address(this),
331             _extraData
332         );
333 
334         return true;
335     }
336 
337     /// @dev This function makes it easy to get the total number of tokens
338     /// @return The total number of tokens
339     function totalSupply() public view returns (uint) {
340         return totalSupplyAt(block.number);
341     }
342 
343 
344     ////////////////
345     // Query balance and totalSupply in History
346     ////////////////
347 
348     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
349     /// @param _owner The address from which the balance will be retrieved
350     /// @param _blockNumber The block number when the balance is queried
351     /// @return The balance at `_blockNumber`
352     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint) {
353 
354         // These next few lines are used when the balance of the token is
355         //  requested before a check point was ever created for this token, it
356         //  requires that the `parentToken.balanceOfAt` be queried at the
357         //  genesis block for that token as this contains initial balance of
358         //  this token
359         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
360             return 0;
361             // This will return the expected balance during normal situations
362         } else {
363             return getValueAt(balances[_owner], _blockNumber);
364         }
365     }
366 
367     /// @notice Total amount of tokens at a specific `_blockNumber`.
368     /// @param _blockNumber The block number when the totalSupply is queried
369     /// @return The total amount of tokens at `_blockNumber`
370     function totalSupplyAt(uint _blockNumber) public view returns(uint) {
371 
372         // These next few lines are used when the totalSupply of the token is
373         //  requested before a check point was ever created for this token, it
374         //  requires that the `parentToken.totalSupplyAt` be queried at the
375         //  genesis block for this token as that contains totalSupply of this
376         //  token at this block number.
377         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
378             return 0;
379             // This will return the expected totalSupply during normal situations
380         } else {
381             return getValueAt(totalSupplyHistory, _blockNumber);
382         }
383     }
384 
385     ////////////////
386     // Internal helper functions to query and set a value in a snapshot array
387     ////////////////
388 
389     /// @dev `getValueAt` retrieves the number of tokens at a given block number
390     /// @param checkpoints The history of values being queried
391     /// @param _block The block number to retrieve the value at
392     /// @return The number of tokens being queried
393     function getValueAt(Checkpoint[] storage checkpoints, uint _block) view internal returns (uint) {
394         if (checkpoints.length == 0) return 0;
395 
396         // Shortcut for the actual value
397         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
398             return checkpoints[checkpoints.length-1].value;
399         if (_block < checkpoints[0].fromBlock) return 0;
400 
401         // Binary search of the value in the array
402         uint min = 0;
403         uint max = checkpoints.length-1;
404         while (max > min) {
405             uint mid = (max + min + 1)/ 2;
406             if (checkpoints[mid].fromBlock<=_block) {
407                 min = mid;
408             } else {
409                 max = mid-1;
410             }
411         }
412         return checkpoints[min].value;
413     }
414 
415     /// @dev `updateValueAtNow` used to update the `balances` map and the
416     ///  `totalSupplyHistory`
417     /// @param checkpoints The history of data being updated
418     /// @param _value The new number of tokens
419     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal  {
420         if ((checkpoints.length == 0)
421             || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
422             Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
423             newCheckPoint.fromBlock =  uint128(block.number);
424             newCheckPoint.value = uint128(_value);
425         } else {
426             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
427             oldCheckPoint.value = uint128(_value);
428         }
429     }
430 
431 
432     /// @dev Helper function to return a min betwen the two uints
433     function min(uint a, uint b) pure internal returns (uint) {
434         return a < b ? a : b;
435     }
436 
437 
438 
439 
440     /// @notice Generates `_amount` tokens that are assigned to `_owner`
441     /// @param _owner The address that will be assigned the new tokens
442     /// @param _amount The quantity of tokens generated
443     /// @return True if the tokens are generated correctly
444     function generateTokens(address _owner, uint _amount) public onlyOwner returns (bool) {
445         uint curTotalSupply = totalSupply();
446         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
447         uint previousBalanceTo = balanceOf(_owner);
448         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
449         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
450         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
451         emit Transfer(address(0), _owner, _amount);
452         return true;
453     }
454 
455     //////////
456     // Safety Methods
457     //////////
458 
459     /// @notice This method can be used by the owner to extract mistakenly
460     ///  sent tokens to this contract.
461     /// @param _token The address of the token contract that you want to recover
462     ///  set to 0 in case you want to extract ether.
463     function claimTokens(address _token) external onlyOwner {
464         if (_token == address(0)) {
465             owner.transfer(address(this).balance);
466             return;
467         }
468 
469         Token token = Token(_token);
470         uint balance = token.balanceOf(address(this));
471         token.transfer(owner, balance);
472         emit ClaimedTokens(_token, owner, balance);
473     }
474 }
475 
476 
477 contract DividendManager is Ownable {
478     using SafeMath for uint;
479 
480     event DividendDeposited(address indexed _depositor, uint256 _blockNumber, uint256 _amount, uint256 _totalSupply, uint256 _dividendIndex);
481     event DividendClaimed(address indexed _claimer, uint256 _dividendIndex, uint256 _claim);
482     event DividendRecycled(address indexed _recycler, uint256 _blockNumber, uint256 _amount, uint256 _totalSupply, uint256 _dividendIndex);
483 
484     Token public token;
485 
486     uint256 public RECYCLE_TIME = 365 days;
487 
488     struct Dividend {
489         uint256 blockNumber;
490         uint256 timestamp;
491         uint256 amount;
492         uint256 claimedAmount;
493         uint256 totalSupply;
494         bool recycled;
495         mapping (address => bool) claimed;
496     }
497 
498     Dividend[] public dividends;
499 
500     mapping (address => uint256) dividendsClaimed;
501 
502     modifier validDividendIndex(uint256 _dividendIndex) {
503         require(_dividendIndex < dividends.length);
504         _;
505     }
506 
507     constructor(address _token) public {
508         require(_token != address(0));
509         token = Token(_token);
510     }
511 
512     function depositDividend() payable public {
513         uint256 currentSupply = token.totalSupplyAt(block.number);
514         uint256 dividendIndex = dividends.length;
515         uint256 blockNumber = SafeMath.sub(block.number, 1);
516         dividends.push(
517             Dividend(
518                 blockNumber,
519                 getNow(),
520                 msg.value,
521                 0,
522                 currentSupply,
523                 false
524             )
525         );
526         emit DividendDeposited(msg.sender, blockNumber, msg.value, currentSupply, dividendIndex);
527     }
528 
529     function claimDividend(uint256 _dividendIndex) public
530     validDividendIndex(_dividendIndex)
531     {
532         Dividend storage dividend = dividends[_dividendIndex];
533         require(dividend.claimed[msg.sender] == false);
534         require(dividend.recycled == false);
535         uint256 balance = token.balanceOfAt(msg.sender, dividend.blockNumber);
536         uint256 claim = balance.mul(dividend.amount).div(dividend.totalSupply);
537         dividend.claimed[msg.sender] = true;
538         dividend.claimedAmount = SafeMath.add(dividend.claimedAmount, claim);
539         if (claim > 0) {
540             msg.sender.transfer(claim);
541             emit DividendClaimed(msg.sender, _dividendIndex, claim);
542         }
543     }
544 
545     function claimDividendAll() public {
546         require(dividendsClaimed[msg.sender] < dividends.length);
547         for (uint i = dividendsClaimed[msg.sender]; i < dividends.length; i++) {
548             if ((dividends[i].claimed[msg.sender] == false) && (dividends[i].recycled == false)) {
549                 dividendsClaimed[msg.sender] = SafeMath.add(i, 1);
550                 claimDividend(i);
551             }
552         }
553     }
554 
555     function recycleDividend(uint256 _dividendIndex) public
556     onlyOwner
557     validDividendIndex(_dividendIndex)
558     {
559         Dividend storage dividend = dividends[_dividendIndex];
560         require(dividend.recycled == false);
561         require(dividend.timestamp < SafeMath.sub(getNow(), RECYCLE_TIME));
562         dividends[_dividendIndex].recycled = true;
563         uint256 currentSupply = token.totalSupplyAt(block.number);
564         uint256 remainingAmount = SafeMath.sub(dividend.amount, dividend.claimedAmount);
565         uint256 dividendIndex = dividends.length;
566         uint256 blockNumber = SafeMath.sub(block.number, 1);
567         dividends.push(
568             Dividend(
569                 blockNumber,
570                 getNow(),
571                 remainingAmount,
572                 0,
573                 currentSupply,
574                 false
575             )
576         );
577         emit DividendRecycled(msg.sender, blockNumber, remainingAmount, currentSupply, dividendIndex);
578     }
579 
580     //Function is mocked for tests
581     function getNow() internal view returns (uint256) {
582         return now;
583     }
584 
585     function dividendsCount() external view returns (uint) {
586         return dividends.length;
587     }
588 
589     /// @notice This method can be used by the owner to extract mistakenly
590     ///  sent tokens to this contract.
591     /// @param _token The address of the token contract that you want to recover
592     ///  set to 0 in case you want to extract ether.
593     function claimTokens(address _token) external onlyOwner {
594         //        if (_token == 0x0) {
595         //            owner.transfer(address(this).balance);
596         //            return;
597         //        }
598 
599         Token claimToken = Token(_token);
600         uint balance = claimToken.balanceOf(address(this));
601         claimToken.transfer(owner, balance);
602     }
603 }
604 
605 
606 /**
607  * @title ERC20 interface
608  * @dev see https://eips.ethereum.org/EIPS/eip-20
609  */
610 interface IERC20 {
611     function transfer(address to, uint256 value) external returns (bool);
612     function approve(address spender, uint256 value) external returns (bool);
613     function transferFrom(address from, address to, uint256 value) external returns (bool);
614     function totalSupply() external view returns (uint256);
615     function balanceOf(address who) external view returns (uint256);
616     function allowance(address owner, address spender) external view returns (uint256);
617 
618     event Transfer(address indexed from, address indexed to, uint256 value);
619     event Approval(address indexed owner, address indexed spender, uint256 value);
620 }
621 
622 /**
623  * @title SafeERC20
624  * @dev Wrappers around ERC20 operations that throw on failure.
625  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
626  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
627  */
628 library SafeERC20 {
629     function safeTransfer(IERC20 token, address to, uint256 value) internal {
630         require(token.transfer(to, value));
631     }
632 
633     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
634         require(token.transferFrom(from, to, value));
635     }
636 
637     function safeApprove(IERC20 token, address spender, uint256 value) internal {
638         require(token.approve(spender, value));
639     }
640 }
641 
642 
643 contract sellTokens is Ownable {
644     using SafeMath for uint256;
645     using SafeERC20 for IERC20;
646 
647     IERC20 public token;
648     address payable public wallet;
649 
650     uint256 public rate;
651     uint256 public minPurchase;
652 
653     uint256 public weiRaised;
654     uint256 public tokenSold;
655 
656     event TokenPurchase(address indexed owner, uint weiAmount, uint tokens);
657 
658 
659     constructor(address payable _wallet, uint256 _rate, address _token, uint256 _minPurchase) public {
660         require(_token != address(0));
661         require(_wallet != address(0));
662         require(_rate > 0);
663 
664         token = IERC20(_token);
665         wallet = _wallet;
666         rate = _rate;
667         minPurchase = _minPurchase;
668     }
669 
670 
671     function() payable external {
672         buyTokens();
673     }
674 
675 
676     function buyTokens() payable public {
677         uint256 weiAmount = msg.value;
678         _preValidatePurchase(weiAmount);
679 
680         uint256 tokens = _getTokenAmount(weiAmount);
681 
682         if (tokens > token.balanceOf(address(this))) {
683             tokens = token.balanceOf(address(this));
684 
685             uint price = tokens.div(rate);
686 
687             uint _diff =  weiAmount.sub(price);
688 
689             if (_diff > 0) {
690                 msg.sender.transfer(_diff);
691                 weiAmount = weiAmount.sub(_diff);
692             }
693         }
694 
695         weiRaised = weiRaised.add(weiAmount);
696         tokenSold = tokenSold.add(tokens);
697         _processPurchase(msg.sender, tokens);
698 
699         emit TokenPurchase(msg.sender, weiAmount, tokens);
700 
701         _forwardFunds();
702     }
703 
704 
705     function _preValidatePurchase(uint256 _weiAmount) internal view {
706         require(token.balanceOf(address(this)) > 0);
707         require(_weiAmount >= minPurchase);
708     }
709 
710 
711     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
712         return _weiAmount.mul(rate);
713     }
714 
715 
716     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
717         token.safeTransfer(_beneficiary, _tokenAmount);
718     }
719 
720 
721     function _forwardFunds() internal {
722         wallet.transfer(msg.value);
723     }
724 
725 
726     function setRate(uint256 _rate) onlyOwner external {
727         rate = _rate;
728     }
729 
730 
731     function setMinPurchase(uint256 _minPurchase) onlyOwner external {
732         minPurchase = _minPurchase;
733     }
734 
735     function withdrawTokens(address _t) onlyOwner external {
736         IERC20 _token = IERC20(_t);
737         uint balance = _token.balanceOf(address(this));
738         _token.safeTransfer(owner, balance);
739     }
740 }
741 
742 
743 contract CompanyLog is Ownable {
744     struct Log {
745         uint time;
746         uint id;
747         uint price;
748         string description;
749     }
750 
751     mapping (uint => Log) public logs;
752     uint public lastLogId;
753 
754     event NewLog(uint time, uint id, uint price, string description);
755 
756     function addLog(uint _time, uint _id, uint _price, string calldata _description) onlyManager external {
757         uint256 _logId = lastLogId++;
758 
759         logs[_logId] = Log({
760             time : _time,
761             id : _id,
762             price : _price,
763             description: _description
764             });
765 
766         emit NewLog(_time, _id, _price, _description);
767     }
768 }