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
272     struct ReclaimOperation {
273         Ownable other;
274         address admin;
275         uint deferBlock;
276     }
277 
278     struct ChangeBurnBoundsOperation {
279         uint newMin;
280         uint newMax;
281         address admin;
282         uint deferBlock;
283     }
284 
285     struct ChangeStakingFeesOperation {
286         uint80 _transferFeeNumerator;
287         uint80 _transferFeeDenominator;
288         uint80 _mintFeeNumerator;
289         uint80 _mintFeeDenominator;
290         uint256 _mintFeeFlat;
291         uint80 _burnFeeNumerator;
292         uint80 _burnFeeDenominator;
293         uint256 _burnFeeFlat;
294         address admin;
295         uint deferBlock;
296     }
297 
298     struct ChangeStakerOperation {
299         address newStaker;
300         address admin;
301         uint deferBlock;
302     }
303 
304     struct DelegateOperation {
305         DelegateERC20 delegate;
306         address admin;
307         uint deferBlock;
308     }
309 
310     struct SetDelegatedFromOperation {
311         address source;
312         address admin;
313         uint deferBlock;
314     }
315 
316     struct ChangeTrueUSDOperation {
317         TrueUSD newContract;
318         address admin;
319         uint deferBlock;
320     }
321 
322     struct ChangeNameOperation {
323         string name;
324         string symbol;
325         address admin;
326         uint deferBlock;
327     }
328 
329     address public admin;
330     TrueUSD public trueUSD;
331     MintOperation[] public mintOperations;
332     TransferChildOperation[] public transferChildOperations;
333     ReclaimOperation[] public reclaimOperations;
334     ChangeBurnBoundsOperation public changeBurnBoundsOperation;
335     ChangeStakingFeesOperation public changeStakingFeesOperation;
336     ChangeStakerOperation public changeStakerOperation;
337     DelegateOperation public delegateOperation;
338     SetDelegatedFromOperation public setDelegatedFromOperation;
339     ChangeTrueUSDOperation public changeTrueUSDOperation;
340     ChangeNameOperation public changeNameOperation;
341 
342     modifier onlyAdminOrOwner() {
343         require(msg.sender == admin || msg.sender == owner);
344         _;
345     }
346 
347     function computeDeferBlock() private view returns (uint) {
348         if (msg.sender == owner) {
349             return block.number;
350         } else {
351             return block.number.add(blocksDelay);
352         }
353     }
354 
355     // starts with no admin
356     function TimeLockedController(address _trueUSD) public {
357         trueUSD = TrueUSD(_trueUSD);
358     }
359 
360     event MintOperationEvent(address indexed _to, uint256 amount, uint deferBlock, uint opIndex);
361     event TransferChildOperationEvent(address indexed _child, address indexed _newOwner, uint deferBlock, uint opIndex);
362     event ReclaimOperationEvent(address indexed other, uint deferBlock, uint opIndex);
363     event ChangeBurnBoundsOperationEvent(uint newMin, uint newMax, uint deferBlock);
364     event ChangeStakingFeesOperationEvent(uint80 _transferFeeNumerator,
365                                             uint80 _transferFeeDenominator,
366                                             uint80 _mintFeeNumerator,
367                                             uint80 _mintFeeDenominator,
368                                             uint256 _mintFeeFlat,
369                                             uint80 _burnFeeNumerator,
370                                             uint80 _burnFeeDenominator,
371                                             uint256 _burnFeeFlat,
372                                             uint deferBlock);
373     event ChangeStakerOperationEvent(address newStaker, uint deferBlock);
374     event DelegateOperationEvent(DelegateERC20 delegate, uint deferBlock);
375     event SetDelegatedFromOperationEvent(address source, uint deferBlock);
376     event ChangeTrueUSDOperationEvent(TrueUSD newContract, uint deferBlock);
377     event ChangeNameOperationEvent(string name, string symbol, uint deferBlock);
378     event AdminshipTransferred(address indexed previousAdmin, address indexed newAdmin);
379 
380     // admin initiates a request to mint _amount TrueUSD for account _to
381     function requestMint(address _to, uint256 _amount) public onlyAdminOrOwner {
382         uint deferBlock = computeDeferBlock();
383         MintOperation memory op = MintOperation(_to, _amount, admin, deferBlock);
384         MintOperationEvent(_to, _amount, deferBlock, mintOperations.length);
385         mintOperations.push(op);
386     }
387 
388     // admin initiates a request to transfer _child to _newOwner
389     // Can be used e.g. to upgrade this TimeLockedController contract.
390     function requestTransferChild(Ownable _child, address _newOwner) public onlyAdminOrOwner {
391         uint deferBlock = computeDeferBlock();
392         TransferChildOperation memory op = TransferChildOperation(_child, _newOwner, admin, deferBlock);
393         TransferChildOperationEvent(_child, _newOwner, deferBlock, transferChildOperations.length);
394         transferChildOperations.push(op);
395     }
396 
397     // admin initiates a request to transfer ownership of a contract from trueUSD
398     // to this TimeLockedController. Can be used e.g. to reclaim balance sheet
399     // in order to transfer it to an upgraded TrueUSD contract.
400     function requestReclaim(Ownable other) public onlyAdminOrOwner {
401         uint deferBlock = computeDeferBlock();
402         ReclaimOperation memory op = ReclaimOperation(other, admin, deferBlock);
403         ReclaimOperationEvent(other, deferBlock, reclaimOperations.length);
404         reclaimOperations.push(op);
405     }
406 
407     // admin initiates a request that the minimum and maximum amounts that any TrueUSD user can
408     // burn become newMin and newMax
409     function requestChangeBurnBounds(uint newMin, uint newMax) public onlyAdminOrOwner {
410         uint deferBlock = computeDeferBlock();
411         changeBurnBoundsOperation = ChangeBurnBoundsOperation(newMin, newMax, admin, deferBlock);
412         ChangeBurnBoundsOperationEvent(newMin, newMax, deferBlock);
413     }
414 
415     // admin initiates a request that the staking fee be changed
416     function requestChangeStakingFees(uint80 _transferFeeNumerator,
417                                         uint80 _transferFeeDenominator,
418                                         uint80 _mintFeeNumerator,
419                                         uint80 _mintFeeDenominator,
420                                         uint256 _mintFeeFlat,
421                                         uint80 _burnFeeNumerator,
422                                         uint80 _burnFeeDenominator,
423                                         uint256 _burnFeeFlat) public onlyAdminOrOwner {
424         uint deferBlock = computeDeferBlock();
425         changeStakingFeesOperation = ChangeStakingFeesOperation(_transferFeeNumerator,
426                                                                     _transferFeeDenominator,
427                                                                     _mintFeeNumerator,
428                                                                     _mintFeeDenominator,
429                                                                     _mintFeeFlat,
430                                                                     _burnFeeNumerator,
431                                                                     _burnFeeDenominator,
432                                                                     _burnFeeFlat,
433                                                                     admin,
434                                                                     deferBlock);
435         ChangeStakingFeesOperationEvent(_transferFeeNumerator,
436                                           _transferFeeDenominator,
437                                           _mintFeeNumerator,
438                                           _mintFeeDenominator,
439                                           _mintFeeFlat,
440                                           _burnFeeNumerator,
441                                           _burnFeeDenominator,
442                                           _burnFeeFlat,
443                                           deferBlock);
444     }
445 
446     // admin initiates a request that the recipient of the staking fee be changed to newStaker
447     function requestChangeStaker(address newStaker) public onlyAdminOrOwner {
448         uint deferBlock = computeDeferBlock();
449         changeStakerOperation = ChangeStakerOperation(newStaker, admin, deferBlock);
450         ChangeStakerOperationEvent(newStaker, deferBlock);
451     }
452 
453     // admin initiates a request that future ERC20 calls to trueUSD be delegated to _delegate
454     function requestDelegation(DelegateERC20 _delegate) public onlyAdminOrOwner {
455         uint deferBlock = computeDeferBlock();
456         delegateOperation = DelegateOperation(_delegate, admin, deferBlock);
457         DelegateOperationEvent(_delegate, deferBlock);
458     }
459 
460     // admin initiates a request that incoming delegate* calls from _source be
461     // accepted by trueUSD
462     function requestDelegatedFrom(address _source) public onlyAdminOrOwner {
463         uint deferBlock = computeDeferBlock();
464         setDelegatedFromOperation = SetDelegatedFromOperation(_source, admin, deferBlock);
465         SetDelegatedFromOperationEvent(_source, deferBlock);
466     }
467 
468     // admin initiates a request that this contract's trueUSD pointer be updated to newContract
469     function requestReplaceTrueUSD(TrueUSD newContract) public onlyAdminOrOwner {
470         uint deferBlock = computeDeferBlock();
471         changeTrueUSDOperation = ChangeTrueUSDOperation(newContract, admin, deferBlock);
472         ChangeTrueUSDOperationEvent(newContract, deferBlock);
473     }
474 
475     // admin initiates a request that trueUSD's name and symbol be changed
476     function requestNameChange(string name, string symbol) public onlyAdminOrOwner {
477         uint deferBlock = computeDeferBlock();
478         changeNameOperation = ChangeNameOperation(name, symbol, admin, deferBlock);
479         ChangeNameOperationEvent(name, symbol, deferBlock);
480     }
481 
482     // after a day, admin finalizes mint request by providing the
483     // index of the request (visible in the MintOperationEvent accompanying the original request)
484     function finalizeMint(uint index) public onlyAdminOrOwner {
485         MintOperation memory op = mintOperations[index];
486         require(op.admin == admin); //checks that the requester's adminship has not been revoked
487         require(op.deferBlock <= block.number); //checks that enough time has elapsed
488         address to = op.to;
489         uint256 amount = op.amount;
490         delete mintOperations[index];
491         trueUSD.mint(to, amount);
492     }
493 
494     // after a day, admin finalizes the transfer of a child contract by providing the
495     // index of the request (visible in the TransferChildOperationEvent accompanying the original request)
496     function finalizeTransferChild(uint index) public onlyAdminOrOwner {
497         TransferChildOperation memory op = transferChildOperations[index];
498         require(op.admin == admin);
499         require(op.deferBlock <= block.number);
500         Ownable _child = op.child;
501         address _newOwner = op.newOwner;
502         delete transferChildOperations[index];
503         _child.transferOwnership(_newOwner);
504     }
505 
506     function finalizeReclaim(uint index) public onlyAdminOrOwner {
507         ReclaimOperation memory op = reclaimOperations[index];
508         require(op.admin == admin);
509         require(op.deferBlock <= block.number);
510         Ownable other = op.other;
511         delete reclaimOperations[index];
512         trueUSD.reclaimContract(other);
513     }
514 
515     // after a day, admin finalizes the burn bounds change
516     function finalizeChangeBurnBounds() public onlyAdminOrOwner {
517         require(changeBurnBoundsOperation.admin == admin);
518         require(changeBurnBoundsOperation.deferBlock <= block.number);
519         uint newMin = changeBurnBoundsOperation.newMin;
520         uint newMax = changeBurnBoundsOperation.newMax;
521         delete changeBurnBoundsOperation;
522         trueUSD.changeBurnBounds(newMin, newMax);
523     }
524 
525     // after a day, admin finalizes the staking fee change
526     function finalizeChangeStakingFees() public onlyAdminOrOwner {
527         require(changeStakingFeesOperation.admin == admin);
528         require(changeStakingFeesOperation.deferBlock <= block.number);
529         uint80 _transferFeeNumerator = changeStakingFeesOperation._transferFeeNumerator;
530         uint80 _transferFeeDenominator = changeStakingFeesOperation._transferFeeDenominator;
531         uint80 _mintFeeNumerator = changeStakingFeesOperation._mintFeeNumerator;
532         uint80 _mintFeeDenominator = changeStakingFeesOperation._mintFeeDenominator;
533         uint256 _mintFeeFlat = changeStakingFeesOperation._mintFeeFlat;
534         uint80 _burnFeeNumerator = changeStakingFeesOperation._burnFeeNumerator;
535         uint80 _burnFeeDenominator = changeStakingFeesOperation._burnFeeDenominator;
536         uint256 _burnFeeFlat = changeStakingFeesOperation._burnFeeFlat;
537         delete changeStakingFeesOperation;
538         trueUSD.changeStakingFees(_transferFeeNumerator,
539                                   _transferFeeDenominator,
540                                   _mintFeeNumerator,
541                                   _mintFeeDenominator,
542                                   _mintFeeFlat,
543                                   _burnFeeNumerator,
544                                   _burnFeeDenominator,
545                                   _burnFeeFlat);
546     }
547 
548     // after a day, admin finalizes the staking fees recipient change
549     function finalizeChangeStaker() public onlyAdminOrOwner {
550         require(changeStakerOperation.admin == admin);
551         require(changeStakerOperation.deferBlock <= block.number);
552         address newStaker = changeStakerOperation.newStaker;
553         delete changeStakerOperation;
554         trueUSD.changeStaker(newStaker);
555     }
556 
557     // after a day, admin finalizes the delegation
558     function finalizeDelegation() public onlyAdminOrOwner {
559         require(delegateOperation.admin == admin);
560         require(delegateOperation.deferBlock <= block.number);
561         DelegateERC20 delegate = delegateOperation.delegate;
562         delete delegateOperation;
563         trueUSD.delegateToNewContract(delegate);
564     }
565 
566     function finalizeSetDelegatedFrom() public onlyAdminOrOwner {
567         require(setDelegatedFromOperation.admin == admin);
568         require(setDelegatedFromOperation.deferBlock <= block.number);
569         address source = setDelegatedFromOperation.source;
570         delete setDelegatedFromOperation;
571         trueUSD.setDelegatedFrom(source);
572     }
573 
574     function finalizeReplaceTrueUSD() public onlyAdminOrOwner {
575         require(changeTrueUSDOperation.admin == admin);
576         require(changeTrueUSDOperation.deferBlock <= block.number);
577         TrueUSD newContract = changeTrueUSDOperation.newContract;
578         delete changeTrueUSDOperation;
579         trueUSD = newContract;
580     }
581 
582     function finalizeChangeName() public onlyAdminOrOwner {
583         require(changeNameOperation.admin == admin);
584         require(changeNameOperation.deferBlock <= block.number);
585         string memory name = changeNameOperation.name;
586         string memory symbol = changeNameOperation.symbol;
587         delete changeNameOperation;
588         trueUSD.changeName(name, symbol);
589     }
590 
591     // Owner of this contract (immediately) replaces the current admin with newAdmin
592     function transferAdminship(address newAdmin) public onlyOwner {
593         AdminshipTransferred(admin, newAdmin);
594         admin = newAdmin;
595     }
596 
597     // admin (immediately) updates a whitelist/blacklist
598     function updateList(address list, address entry, bool flag) public onlyAdminOrOwner {
599         AddressList(list).changeList(entry, flag);
600     }
601 
602     function issueClaimOwnership(address _other) public onlyAdminOrOwner {
603         Claimable other = Claimable(_other);
604         other.claimOwnership();
605     }
606 }
607 
608 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
609 }
610 
611 contract AllowanceSheet is Claimable {
612     using SafeMath for uint256;
613 
614     mapping (address => mapping (address => uint256)) public allowanceOf;
615 
616     function addAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
617         allowanceOf[tokenHolder][spender] = allowanceOf[tokenHolder][spender].add(value);
618     }
619 
620     function subAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
621         allowanceOf[tokenHolder][spender] = allowanceOf[tokenHolder][spender].sub(value);
622     }
623 
624     function setAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
625         allowanceOf[tokenHolder][spender] = value;
626     }
627 }
628 
629 contract BalanceSheet is Claimable {
630     using SafeMath for uint256;
631 
632     mapping (address => uint256) public balanceOf;
633 
634     function addBalance(address addr, uint256 value) public onlyOwner {
635         balanceOf[addr] = balanceOf[addr].add(value);
636     }
637 
638     function subBalance(address addr, uint256 value) public onlyOwner {
639         balanceOf[addr] = balanceOf[addr].sub(value);
640     }
641 
642     function setBalance(address addr, uint256 value) public onlyOwner {
643         balanceOf[addr] = value;
644     }
645 }
646 
647 contract ERC20Basic {
648   function totalSupply() public view returns (uint256);
649   function balanceOf(address who) public view returns (uint256);
650   function transfer(address to, uint256 value) public returns (bool);
651   event Transfer(address indexed from, address indexed to, uint256 value);
652 }
653 
654 contract BasicToken is ERC20Basic, Claimable {
655   using SafeMath for uint256;
656 
657   BalanceSheet public balances;
658 
659   uint256 totalSupply_;
660 
661   function setBalanceSheet(address sheet) external onlyOwner {
662     balances = BalanceSheet(sheet);
663     balances.claimOwnership();
664   }
665 
666   /**
667   * @dev total number of tokens in existence
668   */
669   function totalSupply() public view returns (uint256) {
670     return totalSupply_;
671   }
672 
673   /**
674   * @dev transfer token for a specified address
675   * @param _to The address to transfer to.
676   * @param _value The amount to be transferred.
677   */
678   function transfer(address _to, uint256 _value) public returns (bool) {
679     transferAllArgsNoAllowance(msg.sender, _to, _value);
680     return true;
681   }
682 
683   function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal {
684     require(_to != address(0));
685     require(_from != address(0));
686     require(_value <= balances.balanceOf(_from));
687 
688     // SafeMath.sub will throw if there is not enough balance.
689     balances.subBalance(_from, _value);
690     balances.addBalance(_to, _value);
691     Transfer(_from, _to, _value);
692   }
693 
694   /**
695   * @dev Gets the balance of the specified address.
696   * @param _owner The address to query the the balance of.
697   * @return An uint256 representing the amount owned by the passed address.
698   */
699   function balanceOf(address _owner) public view returns (uint256 balance) {
700     return balances.balanceOf(_owner);
701   }
702 }
703 
704 contract BurnableToken is BasicToken {
705 
706   event Burn(address indexed burner, uint256 value);
707 
708   /**
709    * @dev Burns a specific amount of tokens.
710    * @param _value The amount of token to be burned.
711    */
712   function burn(uint256 _value) public {
713     require(_value <= balances.balanceOf(msg.sender));
714     // no need to require value <= totalSupply, since that would imply the
715     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
716 
717     address burner = msg.sender;
718     balances.subBalance(burner, _value);
719     totalSupply_ = totalSupply_.sub(_value);
720     Burn(burner, _value);
721     Transfer(burner, address(0), _value);
722   }
723 }
724 
725 contract ERC20 is ERC20Basic {
726   function allowance(address owner, address spender) public view returns (uint256);
727   function transferFrom(address from, address to, uint256 value) public returns (bool);
728   function approve(address spender, uint256 value) public returns (bool);
729   event Approval(address indexed owner, address indexed spender, uint256 value);
730 }
731 
732 library SafeERC20 {
733   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
734     assert(token.transfer(to, value));
735   }
736 
737   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
738     assert(token.transferFrom(from, to, value));
739   }
740 
741   function safeApprove(ERC20 token, address spender, uint256 value) internal {
742     assert(token.approve(spender, value));
743   }
744 }
745 
746 contract StandardToken is ERC20, BasicToken {
747 
748   AllowanceSheet public allowances;
749 
750   function setAllowanceSheet(address sheet) external onlyOwner {
751     allowances = AllowanceSheet(sheet);
752     allowances.claimOwnership();
753   }
754 
755   /**
756    * @dev Transfer tokens from one address to another
757    * @param _from address The address which you want to send tokens from
758    * @param _to address The address which you want to transfer to
759    * @param _value uint256 the amount of tokens to be transferred
760    */
761   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
762     transferAllArgsYesAllowance(_from, _to, _value, msg.sender);
763     return true;
764   }
765 
766   function transferAllArgsYesAllowance(address _from, address _to, uint256 _value, address spender) internal {
767     require(_value <= allowances.allowanceOf(_from, spender));
768 
769     allowances.subAllowance(_from, spender, _value);
770     transferAllArgsNoAllowance(_from, _to, _value);
771   }
772 
773   /**
774    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
775    *
776    * Beware that changing an allowance with this method brings the risk that someone may use both the old
777    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
778    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
779    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
780    * @param _spender The address which will spend the funds.
781    * @param _value The amount of tokens to be spent.
782    */
783   function approve(address _spender, uint256 _value) public returns (bool) {
784     approveAllArgs(_spender, _value, msg.sender);
785     return true;
786   }
787 
788   function approveAllArgs(address _spender, uint256 _value, address _tokenHolder) internal {
789     allowances.setAllowance(_tokenHolder, _spender, _value);
790     Approval(_tokenHolder, _spender, _value);
791   }
792 
793   /**
794    * @dev Function to check the amount of tokens that an owner allowed to a spender.
795    * @param _owner address The address which owns the funds.
796    * @param _spender address The address which will spend the funds.
797    * @return A uint256 specifying the amount of tokens still available for the spender.
798    */
799   function allowance(address _owner, address _spender) public view returns (uint256) {
800     return allowances.allowanceOf(_owner, _spender);
801   }
802 
803   /**
804    * @dev Increase the amount of tokens that an owner allowed to a spender.
805    *
806    * approve should be called when allowed[_spender] == 0. To increment
807    * allowed value is better to use this function to avoid 2 calls (and wait until
808    * the first transaction is mined)
809    * From MonolithDAO Token.sol
810    * @param _spender The address which will spend the funds.
811    * @param _addedValue The amount of tokens to increase the allowance by.
812    */
813   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
814     increaseApprovalAllArgs(_spender, _addedValue, msg.sender);
815     return true;
816   }
817 
818   function increaseApprovalAllArgs(address _spender, uint _addedValue, address tokenHolder) internal {
819     allowances.addAllowance(tokenHolder, _spender, _addedValue);
820     Approval(tokenHolder, _spender, allowances.allowanceOf(tokenHolder, _spender));
821   }
822 
823   /**
824    * @dev Decrease the amount of tokens that an owner allowed to a spender.
825    *
826    * approve should be called when allowed[_spender] == 0. To decrement
827    * allowed value is better to use this function to avoid 2 calls (and wait until
828    * the first transaction is mined)
829    * From MonolithDAO Token.sol
830    * @param _spender The address which will spend the funds.
831    * @param _subtractedValue The amount of tokens to decrease the allowance by.
832    */
833   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
834     decreaseApprovalAllArgs(_spender, _subtractedValue, msg.sender);
835     return true;
836   }
837 
838   function decreaseApprovalAllArgs(address _spender, uint _subtractedValue, address tokenHolder) internal {
839     uint oldValue = allowances.allowanceOf(tokenHolder, _spender);
840     if (_subtractedValue > oldValue) {
841       allowances.setAllowance(tokenHolder, _spender, 0);
842     } else {
843       allowances.subAllowance(tokenHolder, _spender, _subtractedValue);
844     }
845     Approval(tokenHolder, _spender, allowances.allowanceOf(tokenHolder, _spender));
846   }
847 
848 }
849 
850 contract CanDelegate is StandardToken {
851     // If this contract needs to be upgraded, the new contract will be stored
852     // in 'delegate' and any ERC20 calls to this contract will be delegated to that one.
853     DelegateERC20 public delegate;
854 
855     event DelegatedTo(address indexed newContract);
856 
857     // Can undelegate by passing in newContract = address(0)
858     function delegateToNewContract(DelegateERC20 newContract) public onlyOwner {
859         delegate = newContract;
860         DelegatedTo(delegate);
861     }
862 
863     // If a delegate has been designated, all ERC20 calls are forwarded to it
864     function transfer(address to, uint256 value) public returns (bool) {
865         if (delegate == address(0)) {
866             return super.transfer(to, value);
867         } else {
868             return delegate.delegateTransfer(to, value, msg.sender);
869         }
870     }
871 
872     function transferFrom(address from, address to, uint256 value) public returns (bool) {
873         if (delegate == address(0)) {
874             return super.transferFrom(from, to, value);
875         } else {
876             return delegate.delegateTransferFrom(from, to, value, msg.sender);
877         }
878     }
879 
880     function balanceOf(address who) public view returns (uint256) {
881         if (delegate == address(0)) {
882             return super.balanceOf(who);
883         } else {
884             return delegate.delegateBalanceOf(who);
885         }
886     }
887 
888     function approve(address spender, uint256 value) public returns (bool) {
889         if (delegate == address(0)) {
890             return super.approve(spender, value);
891         } else {
892             return delegate.delegateApprove(spender, value, msg.sender);
893         }
894     }
895 
896     function allowance(address _owner, address spender) public view returns (uint256) {
897         if (delegate == address(0)) {
898             return super.allowance(_owner, spender);
899         } else {
900             return delegate.delegateAllowance(_owner, spender);
901         }
902     }
903 
904     function totalSupply() public view returns (uint256) {
905         if (delegate == address(0)) {
906             return super.totalSupply();
907         } else {
908             return delegate.delegateTotalSupply();
909         }
910     }
911 
912     function increaseApproval(address spender, uint addedValue) public returns (bool) {
913         if (delegate == address(0)) {
914             return super.increaseApproval(spender, addedValue);
915         } else {
916             return delegate.delegateIncreaseApproval(spender, addedValue, msg.sender);
917         }
918     }
919 
920     function decreaseApproval(address spender, uint subtractedValue) public returns (bool) {
921         if (delegate == address(0)) {
922             return super.decreaseApproval(spender, subtractedValue);
923         } else {
924             return delegate.delegateDecreaseApproval(spender, subtractedValue, msg.sender);
925         }
926     }
927 }
928 
929 contract StandardDelegate is StandardToken, DelegateERC20 {
930     address public delegatedFrom;
931 
932     modifier onlySender(address source) {
933         require(msg.sender == source);
934         _;
935     }
936 
937     function setDelegatedFrom(address addr) onlyOwner public {
938         delegatedFrom = addr;
939     }
940 
941     // All delegate ERC20 functions are forwarded to corresponding normal functions
942     function delegateTotalSupply() public view returns (uint256) {
943         return totalSupply();
944     }
945 
946     function delegateBalanceOf(address who) public view returns (uint256) {
947         return balanceOf(who);
948     }
949 
950     function delegateTransfer(address to, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
951         transferAllArgsNoAllowance(origSender, to, value);
952         return true;
953     }
954 
955     function delegateAllowance(address owner, address spender) public view returns (uint256) {
956         return allowance(owner, spender);
957     }
958 
959     function delegateTransferFrom(address from, address to, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
960         transferAllArgsYesAllowance(from, to, value, origSender);
961         return true;
962     }
963 
964     function delegateApprove(address spender, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
965         approveAllArgs(spender, value, origSender);
966         return true;
967     }
968 
969     function delegateIncreaseApproval(address spender, uint addedValue, address origSender) onlySender(delegatedFrom) public returns (bool) {
970         increaseApprovalAllArgs(spender, addedValue, origSender);
971         return true;
972     }
973 
974     function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) onlySender(delegatedFrom) public returns (bool) {
975         decreaseApprovalAllArgs(spender, subtractedValue, origSender);
976         return true;
977     }
978 }
979 
980 contract PausableToken is StandardToken, Pausable {
981 
982   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
983     return super.transfer(_to, _value);
984   }
985 
986   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
987     return super.transferFrom(_from, _to, _value);
988   }
989 
990   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
991     return super.approve(_spender, _value);
992   }
993 
994   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
995     return super.increaseApproval(_spender, _addedValue);
996   }
997 
998   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
999     return super.decreaseApproval(_spender, _subtractedValue);
1000   }
1001 }
1002 
1003 contract TrueUSD is StandardDelegate, PausableToken, BurnableToken, NoOwner, CanDelegate {
1004     string public name = "TrueUSD";
1005     string public symbol = "TUSD";
1006     uint8 public constant decimals = 18;
1007 
1008     AddressList public canReceiveMintWhiteList;
1009     AddressList public canBurnWhiteList;
1010     AddressList public blackList;
1011     AddressList public noFeesList;
1012     uint256 public burnMin = 10000 * 10**uint256(decimals);
1013     uint256 public burnMax = 20000000 * 10**uint256(decimals);
1014 
1015     uint80 public transferFeeNumerator = 7;
1016     uint80 public transferFeeDenominator = 10000;
1017     uint80 public mintFeeNumerator = 0;
1018     uint80 public mintFeeDenominator = 10000;
1019     uint256 public mintFeeFlat = 0;
1020     uint80 public burnFeeNumerator = 0;
1021     uint80 public burnFeeDenominator = 10000;
1022     uint256 public burnFeeFlat = 0;
1023     address public staker;
1024 
1025     event ChangeBurnBoundsEvent(uint256 newMin, uint256 newMax);
1026     event Mint(address indexed to, uint256 amount);
1027     event WipedAccount(address indexed account, uint256 balance);
1028 
1029     function TrueUSD() public {
1030         totalSupply_ = 0;
1031         staker = msg.sender;
1032     }
1033 
1034     function setLists(AddressList _canReceiveMintWhiteList, AddressList _canBurnWhiteList, AddressList _blackList, AddressList _noFeesList) onlyOwner public {
1035         canReceiveMintWhiteList = _canReceiveMintWhiteList;
1036         canBurnWhiteList = _canBurnWhiteList;
1037         blackList = _blackList;
1038         noFeesList = _noFeesList;
1039     }
1040 
1041     function changeName(string _name, string _symbol) onlyOwner public {
1042         name = _name;
1043         symbol = _symbol;
1044     }
1045 
1046     //Burning functions as withdrawing money from the system. The platform will keep track of who burns coins,
1047     //and will send them back the equivalent amount of money (rounded down to the nearest cent).
1048     function burn(uint256 _value) public {
1049         require(canBurnWhiteList.onList(msg.sender));
1050         require(_value >= burnMin);
1051         require(_value <= burnMax);
1052         uint256 fee = payStakingFee(msg.sender, _value, burnFeeNumerator, burnFeeDenominator, burnFeeFlat, 0x0);
1053         uint256 remaining = _value.sub(fee);
1054         super.burn(remaining);
1055     }
1056 
1057     //Create _amount new tokens and transfer them to _to.
1058     //Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/MintableToken.sol
1059     function mint(address _to, uint256 _amount) onlyOwner public {
1060         require(canReceiveMintWhiteList.onList(_to));
1061         totalSupply_ = totalSupply_.add(_amount);
1062         balances.addBalance(_to, _amount);
1063         Mint(_to, _amount);
1064         Transfer(address(0), _to, _amount);
1065         payStakingFee(_to, _amount, mintFeeNumerator, mintFeeDenominator, mintFeeFlat, 0x0);
1066     }
1067 
1068     //Change the minimum and maximum amount that can be burned at once. Burning
1069     //may be disabled by setting both to 0 (this will not be done under normal
1070     //operation, but we can't add checks to disallow it without losing a lot of
1071     //flexibility since burning could also be as good as disabled
1072     //by setting the minimum extremely high, and we don't want to lock
1073     //in any particular cap for the minimum)
1074     function changeBurnBounds(uint newMin, uint newMax) onlyOwner public {
1075         require(newMin <= newMax);
1076         burnMin = newMin;
1077         burnMax = newMax;
1078         ChangeBurnBoundsEvent(newMin, newMax);
1079     }
1080 
1081     // transfer and transferFrom are both dispatched to this function, so we
1082     // check blacklist and pay staking fee here.
1083     function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal {
1084         require(!blackList.onList(_from));
1085         require(!blackList.onList(_to));
1086         super.transferAllArgsNoAllowance(_from, _to, _value);
1087         payStakingFee(_to, _value, transferFeeNumerator, transferFeeDenominator, 0, _from);
1088     }
1089 
1090     function wipeBlacklistedAccount(address account) public onlyOwner {
1091         require(blackList.onList(account));
1092         uint256 oldValue = balanceOf(account);
1093         balances.setBalance(account, 0);
1094         totalSupply_ = totalSupply_.sub(oldValue);
1095         WipedAccount(account, oldValue);
1096     }
1097 
1098     function payStakingFee(address payer, uint256 value, uint80 numerator, uint80 denominator, uint256 flatRate, address otherParticipant) private returns (uint256) {
1099         if (noFeesList.onList(payer) || noFeesList.onList(otherParticipant)) {
1100             return 0;
1101         }
1102         uint256 stakingFee = value.mul(numerator).div(denominator).add(flatRate);
1103         if (stakingFee > 0) {
1104             super.transferAllArgsNoAllowance(payer, staker, stakingFee);
1105         }
1106         return stakingFee;
1107     }
1108 
1109     function changeStakingFees(uint80 _transferFeeNumerator,
1110                                  uint80 _transferFeeDenominator,
1111                                  uint80 _mintFeeNumerator,
1112                                  uint80 _mintFeeDenominator,
1113                                  uint256 _mintFeeFlat,
1114                                  uint80 _burnFeeNumerator,
1115                                  uint80 _burnFeeDenominator,
1116                                  uint256 _burnFeeFlat) public onlyOwner {
1117         require(_transferFeeDenominator != 0);
1118         require(_mintFeeDenominator != 0);
1119         require(_burnFeeDenominator != 0);
1120         transferFeeNumerator = _transferFeeNumerator;
1121         transferFeeDenominator = _transferFeeDenominator;
1122         mintFeeNumerator = _mintFeeNumerator;
1123         mintFeeDenominator = _mintFeeDenominator;
1124         mintFeeFlat = _mintFeeFlat;
1125         burnFeeNumerator = _burnFeeNumerator;
1126         burnFeeDenominator = _burnFeeDenominator;
1127         burnFeeFlat = _burnFeeFlat;
1128     }
1129 
1130     function changeStaker(address newStaker) public onlyOwner {
1131         require(newStaker != address(0));
1132         staker = newStaker;
1133     }
1134 }