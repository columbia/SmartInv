1 pragma solidity ^0.4.18;
2 
3 contract DelegateERC20 {
4   function delegateTotalSupply() public view returns (uint256);
5   function delegateBalanceOf(address who) public view returns (uint256);
6   function delegateTransfer(address to, uint256 value, address origSender) public returns (bool);
7   function delegateAllowance(address owner, address spender) public view returns (uint256);
8   function delegateTransferFrom(address from, address to, uint256 value, address origSender) public returns (bool);
9   function delegateApprove(address spender, uint256 value, address origSender) public returns (bool);
10   function delegateIncreaseApproval(address spender, uint addedValue, address origSender) public returns (bool);
11   function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) public returns (bool);
12 }
13 
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, throws on overflow.
18   */
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   /**
39   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 contract Pausable is Ownable {
92   event Pause();
93   event Unpause();
94 
95   bool public paused = false;
96 
97 
98   /**
99    * @dev Modifier to make a function callable only when the contract is not paused.
100    */
101   modifier whenNotPaused() {
102     require(!paused);
103     _;
104   }
105 
106   /**
107    * @dev Modifier to make a function callable only when the contract is paused.
108    */
109   modifier whenPaused() {
110     require(paused);
111     _;
112   }
113 
114   /**
115    * @dev called by the owner to pause, triggers stopped state
116    */
117   function pause() onlyOwner whenNotPaused public {
118     paused = true;
119     Pause();
120   }
121 
122   /**
123    * @dev called by the owner to unpause, returns to normal state
124    */
125   function unpause() onlyOwner whenPaused public {
126     paused = false;
127     Unpause();
128   }
129 }
130 
131 contract CanReclaimToken is Ownable {
132   using SafeERC20 for ERC20Basic;
133 
134   /**
135    * @dev Reclaim all ERC20Basic compatible tokens
136    * @param token ERC20Basic The address of the token contract
137    */
138   function reclaimToken(ERC20Basic token) external onlyOwner {
139     uint256 balance = token.balanceOf(this);
140     token.safeTransfer(owner, balance);
141   }
142 
143 }
144 
145 contract Claimable is Ownable {
146   address public pendingOwner;
147 
148   /**
149    * @dev Modifier throws if called by any account other than the pendingOwner.
150    */
151   modifier onlyPendingOwner() {
152     require(msg.sender == pendingOwner);
153     _;
154   }
155 
156   /**
157    * @dev Allows the current owner to set the pendingOwner address.
158    * @param newOwner The address to transfer ownership to.
159    */
160   function transferOwnership(address newOwner) onlyOwner public {
161     pendingOwner = newOwner;
162   }
163 
164   /**
165    * @dev Allows the pendingOwner address to finalize the transfer.
166    */
167   function claimOwnership() onlyPendingOwner public {
168     OwnershipTransferred(owner, pendingOwner);
169     owner = pendingOwner;
170     pendingOwner = address(0);
171   }
172 }
173 
174 contract AddressList is Claimable {
175     string public name;
176     mapping (address => bool) public onList;
177 
178     function AddressList(string _name, bool nullValue) public {
179         name = _name;
180         onList[0x0] = nullValue;
181     }
182     event ChangeWhiteList(address indexed to, bool onList);
183 
184     // Set whether _to is on the list or not. Whether 0x0 is on the list
185     // or not cannot be set here - it is set once and for all by the constructor.
186     function changeList(address _to, bool _onList) onlyOwner public {
187         require(_to != 0x0);
188         if (onList[_to] != _onList) {
189             onList[_to] = _onList;
190             ChangeWhiteList(_to, _onList);
191         }
192     }
193 }
194 
195 contract HasNoContracts is Ownable {
196 
197   /**
198    * @dev Reclaim ownership of Ownable contracts
199    * @param contractAddr The address of the Ownable to be reclaimed.
200    */
201   function reclaimContract(address contractAddr) external onlyOwner {
202     Ownable contractInst = Ownable(contractAddr);
203     contractInst.transferOwnership(owner);
204   }
205 }
206 
207 contract HasNoEther is Ownable {
208 
209   /**
210   * @dev Constructor that rejects incoming Ether
211   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
212   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
213   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
214   * we could use assembly to access msg.value.
215   */
216   function HasNoEther() public payable {
217     require(msg.value == 0);
218   }
219 
220   /**
221    * @dev Disallows direct send by settings a default function without the `payable` flag.
222    */
223   function() external {
224   }
225 
226   /**
227    * @dev Transfer all Ether held by the contract to the owner.
228    */
229   function reclaimEther() external onlyOwner {
230     assert(owner.send(this.balance));
231   }
232 }
233 
234 contract HasNoTokens is CanReclaimToken {
235 
236  /**
237   * @dev Reject all ERC223 compatible tokens
238   * @param from_ address The address that is transferring the tokens
239   * @param value_ uint256 the amount of the specified token
240   * @param data_ Bytes The data passed from the caller.
241   */
242   function tokenFallback(address from_, uint256 value_, bytes data_) external {
243     from_;
244     value_;
245     data_;
246     revert();
247   }
248 
249 }
250 
251 contract TimeLockedController is HasNoEther, HasNoTokens, Claimable {
252     using SafeMath for uint256;
253 
254     // 24 hours, assuming a 15 second blocktime.
255     // As long as this isn't too far off from reality it doesn't really matter.
256     uint public constant blocksDelay = 24*60*60/15;
257 
258     struct MintOperation {
259         address to;
260         uint256 amount;
261         address admin;
262         uint deferBlock;
263     }
264 
265     struct TransferChildOperation {
266         Ownable child;
267         address newOwner;
268         address admin;
269         uint deferBlock;
270     }
271 
272     struct ChangeBurnBoundsOperation {
273         uint newMin;
274         uint newMax;
275         address admin;
276         uint deferBlock;
277     }
278 
279     struct ChangeStakingFeesOperation {
280         uint80 _transferFeeNumerator;
281         uint80 _transferFeeDenominator;
282         uint80 _mintFeeNumerator;
283         uint80 _mintFeeDenominator;
284         uint256 _mintFeeFlat;
285         uint80 _burnFeeNumerator;
286         uint80 _burnFeeDenominator;
287         uint256 _burnFeeFlat;
288         address admin;
289         uint deferBlock;
290     }
291 
292     struct ChangeStakerOperation {
293         address newStaker;
294         address admin;
295         uint deferBlock;
296     }
297 
298     struct DelegateOperation {
299         DelegateERC20 delegate;
300         address admin;
301         uint deferBlock;
302     }
303 
304     struct ChangeTrueUSDOperation {
305         TrueUSD newContract;
306         address admin;
307         uint deferBlock;
308     }
309 
310     address public admin;
311     TrueUSD public trueUSD;
312     MintOperation[] public mintOperations;
313     TransferChildOperation[] public transferChildOperations;
314     ChangeBurnBoundsOperation public changeBurnBoundsOperation;
315     ChangeStakingFeesOperation public changeStakingFeesOperation;
316     ChangeStakerOperation public changeStakerOperation;
317     DelegateOperation public delegateOperation;
318     ChangeTrueUSDOperation public changeTrueUSDOperation;
319 
320     modifier onlyAdminOrOwner() {
321         require(msg.sender == admin || msg.sender == owner);
322         _;
323     }
324 
325     function computeDeferBlock() private view returns (uint) {
326         if (msg.sender == owner) {
327             return block.number;
328         } else {
329             return block.number.add(blocksDelay);
330         }
331     }
332 
333     // starts with no admin
334     function TimeLockedController(address _trueUSD) public {
335         trueUSD = TrueUSD(_trueUSD);
336     }
337 
338     event MintOperationEvent(address indexed _to, uint256 amount, uint deferBlock, uint opIndex);
339     event TransferChildOperationEvent(address indexed _child, address indexed _newOwner, uint deferBlock, uint opIndex);
340     event ChangeBurnBoundsOperationEvent(uint newMin, uint newMax, uint deferBlock);
341     event ChangeStakingFeesOperationEvent(uint80 _transferFeeNumerator,
342                                             uint80 _transferFeeDenominator,
343                                             uint80 _mintFeeNumerator,
344                                             uint80 _mintFeeDenominator,
345                                             uint256 _mintFeeFlat,
346                                             uint80 _burnFeeNumerator,
347                                             uint80 _burnFeeDenominator,
348                                             uint256 _burnFeeFlat,
349                                             uint deferBlock);
350     event ChangeStakerOperationEvent(address newStaker, uint deferBlock);
351     event DelegateOperationEvent(DelegateERC20 delegate, uint deferBlock);
352     event ChangeTrueUSDOperationEvent(TrueUSD newContract, uint deferBlock);
353     event AdminshipTransferred(address indexed previousAdmin, address indexed newAdmin);
354 
355     // admin initiates a request to mint _amount TrueUSD for account _to
356     function requestMint(address _to, uint256 _amount) public onlyAdminOrOwner {
357         uint deferBlock = computeDeferBlock();
358         MintOperation memory op = MintOperation(_to, _amount, admin, deferBlock);
359         MintOperationEvent(_to, _amount, deferBlock, mintOperations.length);
360         mintOperations.push(op);
361     }
362 
363     // admin initiates a request to transfer _child to _newOwner
364     // Can be used e.g. to upgrade this TimeLockedController contract.
365     function requestTransferChild(Ownable _child, address _newOwner) public onlyAdminOrOwner {
366         uint deferBlock = computeDeferBlock();
367         TransferChildOperation memory op = TransferChildOperation(_child, _newOwner, admin, deferBlock);
368         TransferChildOperationEvent(_child, _newOwner, deferBlock, transferChildOperations.length);
369         transferChildOperations.push(op);
370     }
371 
372     // admin initiates a request that the minimum and maximum amounts that any TrueUSD user can
373     // burn become newMin and newMax
374     function requestChangeBurnBounds(uint newMin, uint newMax) public onlyAdminOrOwner {
375         uint deferBlock = computeDeferBlock();
376         changeBurnBoundsOperation = ChangeBurnBoundsOperation(newMin, newMax, admin, deferBlock);
377         ChangeBurnBoundsOperationEvent(newMin, newMax, deferBlock);
378     }
379 
380     // admin initiates a request that the staking fee be changed
381     function requestChangeStakingFees(uint80 _transferFeeNumerator,
382                                         uint80 _transferFeeDenominator,
383                                         uint80 _mintFeeNumerator,
384                                         uint80 _mintFeeDenominator,
385                                         uint256 _mintFeeFlat,
386                                         uint80 _burnFeeNumerator,
387                                         uint80 _burnFeeDenominator,
388                                         uint256 _burnFeeFlat) public onlyAdminOrOwner {
389         uint deferBlock = computeDeferBlock();
390         changeStakingFeesOperation = ChangeStakingFeesOperation(_transferFeeNumerator,
391                                                                     _transferFeeDenominator,
392                                                                     _mintFeeNumerator,
393                                                                     _mintFeeDenominator,
394                                                                     _mintFeeFlat,
395                                                                     _burnFeeNumerator,
396                                                                     _burnFeeDenominator,
397                                                                     _burnFeeFlat,
398                                                                     admin,
399                                                                     deferBlock);
400         ChangeStakingFeesOperationEvent(_transferFeeNumerator,
401                                           _transferFeeDenominator,
402                                           _mintFeeNumerator,
403                                           _mintFeeDenominator,
404                                           _mintFeeFlat,
405                                           _burnFeeNumerator,
406                                           _burnFeeDenominator,
407                                           _burnFeeFlat,
408                                           deferBlock);
409     }
410 
411     // admin initiates a request that the recipient of the staking fee be changed to newStaker
412     function requestChangeStaker(address newStaker) public onlyAdminOrOwner {
413         uint deferBlock = computeDeferBlock();
414         changeStakerOperation = ChangeStakerOperation(newStaker, admin, deferBlock);
415         ChangeStakerOperationEvent(newStaker, deferBlock);
416     }
417 
418     // admin initiates a request that future ERC20 calls to trueUSD be delegated to _delegate
419     function requestDelegation(DelegateERC20 _delegate) public onlyAdminOrOwner {
420         uint deferBlock = computeDeferBlock();
421         delegateOperation = DelegateOperation(_delegate, admin, deferBlock);
422         DelegateOperationEvent(_delegate, deferBlock);
423     }
424 
425     // admin initiates a request that this contract's trueUSD pointer be updated to newContract
426     function requestReplaceTrueUSD(TrueUSD newContract) public onlyAdminOrOwner {
427         uint deferBlock = computeDeferBlock();
428         changeTrueUSDOperation = ChangeTrueUSDOperation(newContract, admin, deferBlock);
429         ChangeTrueUSDOperationEvent(newContract, deferBlock);
430     }
431 
432     // after a day, admin finalizes mint request by providing the
433     // index of the request (visible in the MintOperationEvent accompanying the original request)
434     function finalizeMint(uint index) public onlyAdminOrOwner {
435         MintOperation memory op = mintOperations[index];
436         require(op.admin == admin); //checks that the requester's adminship has not been revoked
437         require(op.deferBlock <= block.number); //checks that enough time has elapsed
438         address to = op.to;
439         uint256 amount = op.amount;
440         delete mintOperations[index];
441         trueUSD.mint(to, amount);
442     }
443 
444     // after a day, admin finalizes the transfer of a child contract by providing the
445     // index of the request (visible in the TransferChildOperationEvent accompanying the original request)
446     function finalizeTransferChild(uint index) public onlyAdminOrOwner {
447         TransferChildOperation memory op = transferChildOperations[index];
448         require(op.admin == admin);
449         require(op.deferBlock <= block.number);
450         Ownable _child = op.child;
451         address _newOwner = op.newOwner;
452         delete transferChildOperations[index];
453         _child.transferOwnership(_newOwner);
454     }
455 
456     // after a day, admin finalizes the burn bounds change
457     function finalizeChangeBurnBounds() public onlyAdminOrOwner {
458         require(changeBurnBoundsOperation.admin == admin);
459         require(changeBurnBoundsOperation.deferBlock <= block.number);
460         uint newMin = changeBurnBoundsOperation.newMin;
461         uint newMax = changeBurnBoundsOperation.newMax;
462         delete changeBurnBoundsOperation;
463         trueUSD.changeBurnBounds(newMin, newMax);
464     }
465 
466     // after a day, admin finalizes the staking fee change
467     function finalizeChangeStakingFees() public onlyAdminOrOwner {
468         require(changeStakingFeesOperation.admin == admin);
469         require(changeStakingFeesOperation.deferBlock <= block.number);
470         uint80 _transferFeeNumerator = changeStakingFeesOperation._transferFeeNumerator;
471         uint80 _transferFeeDenominator = changeStakingFeesOperation._transferFeeDenominator;
472         uint80 _mintFeeNumerator = changeStakingFeesOperation._mintFeeNumerator;
473         uint80 _mintFeeDenominator = changeStakingFeesOperation._mintFeeDenominator;
474         uint256 _mintFeeFlat = changeStakingFeesOperation._mintFeeFlat;
475         uint80 _burnFeeNumerator = changeStakingFeesOperation._burnFeeNumerator;
476         uint80 _burnFeeDenominator = changeStakingFeesOperation._burnFeeDenominator;
477         uint256 _burnFeeFlat = changeStakingFeesOperation._burnFeeFlat;
478         delete changeStakingFeesOperation;
479         trueUSD.changeStakingFees(_transferFeeNumerator,
480                                   _transferFeeDenominator,
481                                   _mintFeeNumerator,
482                                   _mintFeeDenominator,
483                                   _mintFeeFlat,
484                                   _burnFeeNumerator,
485                                   _burnFeeDenominator,
486                                   _burnFeeFlat);
487     }
488 
489     // after a day, admin finalizes the staking fees recipient change
490     function finalizeChangeStaker() public onlyAdminOrOwner {
491         require(changeStakerOperation.admin == admin);
492         require(changeStakerOperation.deferBlock <= block.number);
493         address newStaker = changeStakerOperation.newStaker;
494         delete changeStakerOperation;
495         trueUSD.changeStaker(newStaker);
496     }
497 
498     // after a day, admin finalizes the delegation
499     function finalizeDelegation() public onlyAdminOrOwner {
500         require(delegateOperation.admin == admin);
501         require(delegateOperation.deferBlock <= block.number);
502         DelegateERC20 delegate = delegateOperation.delegate;
503         delete delegateOperation;
504         trueUSD.delegateToNewContract(delegate);
505     }
506 
507     function finalizeReplaceTrueUSD() public onlyAdminOrOwner {
508         require(changeTrueUSDOperation.admin == admin);
509         require(changeTrueUSDOperation.deferBlock <= block.number);
510         TrueUSD newContract = changeTrueUSDOperation.newContract;
511         delete changeTrueUSDOperation;
512         trueUSD = newContract;
513     }
514 
515     // Owner of this contract (immediately) replaces the current admin with newAdmin
516     function transferAdminship(address newAdmin) public onlyOwner {
517         AdminshipTransferred(admin, newAdmin);
518         admin = newAdmin;
519     }
520 
521     // admin (immediately) updates a whitelist/blacklist
522     function updateList(address list, address entry, bool flag) public onlyAdminOrOwner {
523         AddressList(list).changeList(entry, flag);
524     }
525 
526     function issueClaimOwnership(address _other) public onlyAdminOrOwner {
527         Claimable other = Claimable(_other);
528         other.claimOwnership();
529     }
530 }
531 
532 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
533 }
534 
535 contract ERC20Basic {
536   function totalSupply() public view returns (uint256);
537   function balanceOf(address who) public view returns (uint256);
538   function transfer(address to, uint256 value) public returns (bool);
539   event Transfer(address indexed from, address indexed to, uint256 value);
540 }
541 
542 contract BasicToken is ERC20Basic {
543   using SafeMath for uint256;
544 
545   mapping(address => uint256) balances;
546 
547   uint256 totalSupply_;
548 
549   /**
550   * @dev total number of tokens in existence
551   */
552   function totalSupply() public view returns (uint256) {
553     return totalSupply_;
554   }
555 
556   /**
557   * @dev transfer token for a specified address
558   * @param _to The address to transfer to.
559   * @param _value The amount to be transferred.
560   */
561   function transfer(address _to, uint256 _value) public returns (bool) {
562     require(_to != address(0));
563     require(_value <= balances[msg.sender]);
564 
565     // SafeMath.sub will throw if there is not enough balance.
566     balances[msg.sender] = balances[msg.sender].sub(_value);
567     balances[_to] = balances[_to].add(_value);
568     Transfer(msg.sender, _to, _value);
569     return true;
570   }
571 
572   /**
573   * @dev Gets the balance of the specified address.
574   * @param _owner The address to query the the balance of.
575   * @return An uint256 representing the amount owned by the passed address.
576   */
577   function balanceOf(address _owner) public view returns (uint256 balance) {
578     return balances[_owner];
579   }
580 
581 }
582 
583 contract BurnableToken is BasicToken {
584 
585   event Burn(address indexed burner, uint256 value);
586 
587   /**
588    * @dev Burns a specific amount of tokens.
589    * @param _value The amount of token to be burned.
590    */
591   function burn(uint256 _value) public {
592     require(_value <= balances[msg.sender]);
593     // no need to require value <= totalSupply, since that would imply the
594     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
595 
596     address burner = msg.sender;
597     balances[burner] = balances[burner].sub(_value);
598     totalSupply_ = totalSupply_.sub(_value);
599     Burn(burner, _value);
600   }
601 }
602 
603 contract ERC20 is ERC20Basic {
604   function allowance(address owner, address spender) public view returns (uint256);
605   function transferFrom(address from, address to, uint256 value) public returns (bool);
606   function approve(address spender, uint256 value) public returns (bool);
607   event Approval(address indexed owner, address indexed spender, uint256 value);
608 }
609 
610 library SafeERC20 {
611   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
612     assert(token.transfer(to, value));
613   }
614 
615   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
616     assert(token.transferFrom(from, to, value));
617   }
618 
619   function safeApprove(ERC20 token, address spender, uint256 value) internal {
620     assert(token.approve(spender, value));
621   }
622 }
623 
624 contract StandardToken is ERC20, BasicToken {
625 
626   mapping (address => mapping (address => uint256)) internal allowed;
627 
628 
629   /**
630    * @dev Transfer tokens from one address to another
631    * @param _from address The address which you want to send tokens from
632    * @param _to address The address which you want to transfer to
633    * @param _value uint256 the amount of tokens to be transferred
634    */
635   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
636     require(_to != address(0));
637     require(_value <= balances[_from]);
638     require(_value <= allowed[_from][msg.sender]);
639 
640     balances[_from] = balances[_from].sub(_value);
641     balances[_to] = balances[_to].add(_value);
642     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
643     Transfer(_from, _to, _value);
644     return true;
645   }
646 
647   /**
648    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
649    *
650    * Beware that changing an allowance with this method brings the risk that someone may use both the old
651    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
652    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
653    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
654    * @param _spender The address which will spend the funds.
655    * @param _value The amount of tokens to be spent.
656    */
657   function approve(address _spender, uint256 _value) public returns (bool) {
658     allowed[msg.sender][_spender] = _value;
659     Approval(msg.sender, _spender, _value);
660     return true;
661   }
662 
663   /**
664    * @dev Function to check the amount of tokens that an owner allowed to a spender.
665    * @param _owner address The address which owns the funds.
666    * @param _spender address The address which will spend the funds.
667    * @return A uint256 specifying the amount of tokens still available for the spender.
668    */
669   function allowance(address _owner, address _spender) public view returns (uint256) {
670     return allowed[_owner][_spender];
671   }
672 
673   /**
674    * @dev Increase the amount of tokens that an owner allowed to a spender.
675    *
676    * approve should be called when allowed[_spender] == 0. To increment
677    * allowed value is better to use this function to avoid 2 calls (and wait until
678    * the first transaction is mined)
679    * From MonolithDAO Token.sol
680    * @param _spender The address which will spend the funds.
681    * @param _addedValue The amount of tokens to increase the allowance by.
682    */
683   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
684     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
685     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
686     return true;
687   }
688 
689   /**
690    * @dev Decrease the amount of tokens that an owner allowed to a spender.
691    *
692    * approve should be called when allowed[_spender] == 0. To decrement
693    * allowed value is better to use this function to avoid 2 calls (and wait until
694    * the first transaction is mined)
695    * From MonolithDAO Token.sol
696    * @param _spender The address which will spend the funds.
697    * @param _subtractedValue The amount of tokens to decrease the allowance by.
698    */
699   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
700     uint oldValue = allowed[msg.sender][_spender];
701     if (_subtractedValue > oldValue) {
702       allowed[msg.sender][_spender] = 0;
703     } else {
704       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
705     }
706     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
707     return true;
708   }
709 
710 }
711 
712 contract PausableToken is StandardToken, Pausable {
713 
714   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
715     return super.transfer(_to, _value);
716   }
717 
718   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
719     return super.transferFrom(_from, _to, _value);
720   }
721 
722   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
723     return super.approve(_spender, _value);
724   }
725 
726   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
727     return super.increaseApproval(_spender, _addedValue);
728   }
729 
730   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
731     return super.decreaseApproval(_spender, _subtractedValue);
732   }
733 }
734 
735 contract TrueUSD is PausableToken, BurnableToken, NoOwner, Claimable {
736     string public constant name = "TrueUSD";
737     string public constant symbol = "TUSD";
738     uint8 public constant decimals = 18;
739 
740     AddressList public canReceiveMintWhitelist;
741     AddressList public canBurnWhiteList;
742     AddressList public blackList;
743     AddressList public noFeesList;
744     uint256 public burnMin = 10000 * 10**uint256(decimals);
745     uint256 public burnMax = 20000000 * 10**uint256(decimals);
746 
747     uint80 public transferFeeNumerator = 7;
748     uint80 public transferFeeDenominator = 10000;
749     uint80 public mintFeeNumerator = 0;
750     uint80 public mintFeeDenominator = 10000;
751     uint256 public mintFeeFlat = 0;
752     uint80 public burnFeeNumerator = 0;
753     uint80 public burnFeeDenominator = 10000;
754     uint256 public burnFeeFlat = 0;
755     address public staker;
756 
757     // If this contract needs to be upgraded, the new contract will be stored
758     // in 'delegate' and any ERC20 calls to this contract will be delegated to that one.
759     DelegateERC20 public delegate;
760 
761     event ChangeBurnBoundsEvent(uint256 newMin, uint256 newMax);
762     event Mint(address indexed to, uint256 amount);
763     event WipedAccount(address indexed account, uint256 balance);
764     event DelegatedTo(address indexed newContract);
765 
766     function TrueUSD(address _canMintWhiteList, address _canBurnWhiteList, address _blackList, address _noFeesList) public {
767         totalSupply_ = 0;
768         canReceiveMintWhitelist = AddressList(_canMintWhiteList);
769         canBurnWhiteList = AddressList(_canBurnWhiteList);
770         blackList = AddressList(_blackList);
771         noFeesList = AddressList(_noFeesList);
772         staker = msg.sender;
773     }
774 
775     //Burning functions as withdrawing money from the system. The platform will keep track of who burns coins,
776     //and will send them back the equivalent amount of money (rounded down to the nearest cent).
777     function burn(uint256 _value) public {
778         require(canBurnWhiteList.onList(msg.sender));
779         require(_value >= burnMin);
780         require(_value <= burnMax);
781         uint256 fee = payStakingFee(msg.sender, _value, burnFeeNumerator, burnFeeDenominator, burnFeeFlat, 0x0);
782         uint256 remaining = _value.sub(fee);
783         super.burn(remaining);
784     }
785 
786     //Create _amount new tokens and transfer them to _to.
787     //Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/MintableToken.sol
788     function mint(address _to, uint256 _amount) onlyOwner public {
789         require(canReceiveMintWhitelist.onList(_to));
790         totalSupply_ = totalSupply_.add(_amount);
791         balances[_to] = balances[_to].add(_amount);
792         Mint(_to, _amount);
793         Transfer(address(0), _to, _amount);
794         payStakingFee(_to, _amount, mintFeeNumerator, mintFeeDenominator, mintFeeFlat, 0x0);
795     }
796 
797     //Change the minimum and maximum amount that can be burned at once. Burning
798     //may be disabled by setting both to 0 (this will not be done under normal
799     //operation, but we can't add checks to disallow it without losing a lot of
800     //flexibility since burning could also be as good as disabled
801     //by setting the minimum extremely high, and we don't want to lock
802     //in any particular cap for the minimum)
803     function changeBurnBounds(uint newMin, uint newMax) onlyOwner public {
804         require(newMin <= newMax);
805         burnMin = newMin;
806         burnMax = newMax;
807         ChangeBurnBoundsEvent(newMin, newMax);
808     }
809 
810     function transfer(address to, uint256 value) public returns (bool) {
811         require(!blackList.onList(msg.sender));
812         require(!blackList.onList(to));
813         if (delegate == address(0)) {
814             bool result = super.transfer(to, value);
815             payStakingFee(to, value, transferFeeNumerator, transferFeeDenominator, 0, msg.sender);
816             return result;
817         } else {
818             return delegate.delegateTransfer(to, value, msg.sender);
819         }
820     }
821 
822     function transferFrom(address from, address to, uint256 value) public returns (bool) {
823         require(!blackList.onList(from));
824         require(!blackList.onList(to));
825         if (delegate == address(0)) {
826             bool result = super.transferFrom(from, to, value);
827             payStakingFee(to, value, transferFeeNumerator, transferFeeDenominator, 0, from);
828             return result;
829         } else {
830             return delegate.delegateTransferFrom(from, to, value, msg.sender);
831         }
832     }
833 
834     function balanceOf(address who) public view returns (uint256) {
835         if (delegate == address(0)) {
836             return super.balanceOf(who);
837         } else {
838             return delegate.delegateBalanceOf(who);
839         }
840     }
841 
842     function approve(address spender, uint256 value) public returns (bool) {
843         if (delegate == address(0)) {
844             return super.approve(spender, value);
845         } else {
846             return delegate.delegateApprove(spender, value, msg.sender);
847         }
848     }
849 
850     function allowance(address _owner, address spender) public view returns (uint256) {
851         if (delegate == address(0)) {
852             return super.allowance(_owner, spender);
853         } else {
854             return delegate.delegateAllowance(_owner, spender);
855         }
856     }
857 
858     function totalSupply() public view returns (uint256) {
859         if (delegate == address(0)) {
860             return super.totalSupply();
861         } else {
862             return delegate.delegateTotalSupply();
863         }
864     }
865 
866     function increaseApproval(address spender, uint addedValue) public returns (bool) {
867         if (delegate == address(0)) {
868             return super.increaseApproval(spender, addedValue);
869         } else {
870             return delegate.delegateIncreaseApproval(spender, addedValue, msg.sender);
871         }
872     }
873 
874     function decreaseApproval(address spender, uint subtractedValue) public returns (bool) {
875         if (delegate == address(0)) {
876             return super.decreaseApproval(spender, subtractedValue);
877         } else {
878             return delegate.delegateDecreaseApproval(spender, subtractedValue, msg.sender);
879         }
880     }
881 
882     function wipeBlacklistedAccount(address account) public onlyOwner {
883         require(blackList.onList(account));
884         uint256 oldValue = balanceOf(account);
885         balances[account] = 0;
886         totalSupply_ = totalSupply_.sub(oldValue);
887         WipedAccount(account, oldValue);
888     }
889 
890     function payStakingFee(address payer, uint256 value, uint80 numerator, uint80 denominator, uint256 flatRate, address otherParticipant) private returns (uint256) {
891         if (noFeesList.onList(payer) || noFeesList.onList(otherParticipant)) {
892             return 0;
893         }
894         uint256 stakingFee = value.mul(numerator).div(denominator).add(flatRate);
895         if (stakingFee > 0) {
896             transferFromWithoutAllowance(payer, staker, stakingFee);
897         }
898         return stakingFee;
899     }
900 
901     // based on 'transfer' in https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
902     function transferFromWithoutAllowance(address from, address _to, uint256 _value) private {
903         assert(_to != address(0));
904         assert(_value <= balances[from]);
905         balances[from] = balances[from].sub(_value);
906         balances[_to] = balances[_to].add(_value);
907         Transfer(from, _to, _value);
908     }
909 
910     function changeStakingFees(uint80 _transferFeeNumerator,
911                                  uint80 _transferFeeDenominator,
912                                  uint80 _mintFeeNumerator,
913                                  uint80 _mintFeeDenominator,
914                                  uint256 _mintFeeFlat,
915                                  uint80 _burnFeeNumerator,
916                                  uint80 _burnFeeDenominator,
917                                  uint256 _burnFeeFlat) public onlyOwner {
918         require(_transferFeeDenominator != 0);
919         require(_mintFeeDenominator != 0);
920         require(_burnFeeDenominator != 0);
921         transferFeeNumerator = _transferFeeNumerator;
922         transferFeeDenominator = _transferFeeDenominator;
923         mintFeeNumerator = _mintFeeNumerator;
924         mintFeeDenominator = _mintFeeDenominator;
925         mintFeeFlat = _mintFeeFlat;
926         burnFeeNumerator = _burnFeeNumerator;
927         burnFeeDenominator = _burnFeeDenominator;
928         burnFeeFlat = _burnFeeFlat;
929     }
930 
931     function changeStaker(address newStaker) public onlyOwner {
932         require(newStaker != address(0));
933         staker = newStaker;
934     }
935 
936     // Can undelegate by passing in newContract = address(0)
937     function delegateToNewContract(DelegateERC20 newContract) public onlyOwner {
938         delegate = newContract;
939         DelegatedTo(delegate);
940     }
941 }