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
304     address public admin;
305     TrueUSD public trueUSD;
306     AddressList public canBurnWhiteList;
307     AddressList public canReceiveMintWhitelist;
308     AddressList public blackList;
309     MintOperation[] public mintOperations;
310     TransferChildOperation[] public transferChildOperations;
311     ChangeBurnBoundsOperation public changeBurnBoundsOperation;
312     ChangeStakingFeesOperation public changeStakingFeesOperation;
313     ChangeStakerOperation public changeStakerOperation;
314     DelegateOperation public delegateOperation;
315 
316     modifier onlyAdminOrOwner() {
317         require(msg.sender == admin || msg.sender == owner);
318         _;
319     }
320 
321     function computeDeferBlock() private view returns (uint) {
322         if (msg.sender == owner) {
323             return block.number;
324         } else {
325             return block.number.add(blocksDelay);
326         }
327     }
328 
329     // starts with no admin
330     function TimeLockedController(address _trueUSD, address _canBurnWhiteList, address _canReceiveMintWhitelist, address _blackList) public {
331         trueUSD = TrueUSD(_trueUSD);
332         canBurnWhiteList = AddressList(_canBurnWhiteList);
333         canReceiveMintWhitelist = AddressList(_canReceiveMintWhitelist);
334         blackList = AddressList(_blackList);
335     }
336 
337     event MintOperationEvent(address indexed _to, uint256 amount, uint deferBlock, uint opIndex);
338     event TransferChildOperationEvent(address indexed _child, address indexed _newOwner, uint deferBlock, uint opIndex);
339     event ChangeBurnBoundsOperationEvent(uint newMin, uint newMax, uint deferBlock);
340     event ChangeStakingFeesOperationEvent(uint80 _transferFeeNumerator,
341                                             uint80 _transferFeeDenominator,
342                                             uint80 _mintFeeNumerator,
343                                             uint80 _mintFeeDenominator,
344                                             uint256 _mintFeeFlat,
345                                             uint80 _burnFeeNumerator,
346                                             uint80 _burnFeeDenominator,
347                                             uint256 _burnFeeFlat,
348                                             uint deferBlock);
349     event ChangeStakerOperationEvent(address newStaker, uint deferBlock);
350     event DelegateOperationEvent(DelegateERC20 delegate, uint deferBlock);
351     event AdminshipTransferred(address indexed previousAdmin, address indexed newAdmin);
352 
353     // admin initiates a request to mint _amount TrueUSD for account _to
354     function requestMint(address _to, uint256 _amount) public onlyAdminOrOwner {
355         uint deferBlock = computeDeferBlock();
356         MintOperation memory op = MintOperation(_to, _amount, admin, deferBlock);
357         MintOperationEvent(_to, _amount, deferBlock, mintOperations.length);
358         mintOperations.push(op);
359     }
360 
361     // admin initiates a request to transfer _child to _newOwner
362     // Can be used e.g. to upgrade this TimeLockedController contract.
363     function requestTransferChild(Ownable _child, address _newOwner) public onlyAdminOrOwner {
364         uint deferBlock = computeDeferBlock();
365         TransferChildOperation memory op = TransferChildOperation(_child, _newOwner, admin, deferBlock);
366         TransferChildOperationEvent(_child, _newOwner, deferBlock, transferChildOperations.length);
367         transferChildOperations.push(op);
368     }
369 
370     // admin initiates a request that the minimum and maximum amounts that any TrueUSD user can
371     // burn become newMin and newMax
372     function requestChangeBurnBounds(uint newMin, uint newMax) public onlyAdminOrOwner {
373         uint deferBlock = computeDeferBlock();
374         changeBurnBoundsOperation = ChangeBurnBoundsOperation(newMin, newMax, admin, deferBlock);
375         ChangeBurnBoundsOperationEvent(newMin, newMax, deferBlock);
376     }
377 
378     // admin initiates a request that the staking fee be changed
379     function requestChangeStakingFees(uint80 _transferFeeNumerator,
380                                         uint80 _transferFeeDenominator,
381                                         uint80 _mintFeeNumerator,
382                                         uint80 _mintFeeDenominator,
383                                         uint256 _mintFeeFlat,
384                                         uint80 _burnFeeNumerator,
385                                         uint80 _burnFeeDenominator,
386                                         uint256 _burnFeeFlat) public onlyAdminOrOwner {
387         uint deferBlock = computeDeferBlock();
388         changeStakingFeesOperation = ChangeStakingFeesOperation(_transferFeeNumerator,
389                                                                     _transferFeeDenominator,
390                                                                     _mintFeeNumerator,
391                                                                     _mintFeeDenominator,
392                                                                     _mintFeeFlat,
393                                                                     _burnFeeNumerator,
394                                                                     _burnFeeDenominator,
395                                                                     _burnFeeFlat,
396                                                                     admin,
397                                                                     deferBlock);
398         ChangeStakingFeesOperationEvent(_transferFeeNumerator,
399                                           _transferFeeDenominator,
400                                           _mintFeeNumerator,
401                                           _mintFeeDenominator,
402                                           _mintFeeFlat,
403                                           _burnFeeNumerator,
404                                           _burnFeeDenominator,
405                                           _burnFeeFlat,
406                                           deferBlock);
407     }
408 
409     // admin initiates a request that the recipient of the staking fee be changed to newStaker
410     function requestChangeStaker(address newStaker) public onlyAdminOrOwner {
411         uint deferBlock = computeDeferBlock();
412         changeStakerOperation = ChangeStakerOperation(newStaker, admin, deferBlock);
413         ChangeStakerOperationEvent(newStaker, deferBlock);
414     }
415 
416     // admin initiates a request that future ERC20 calls to trueUSD be delegated to _delegate
417     function requestDelegation(DelegateERC20 _delegate) public onlyAdminOrOwner {
418         uint deferBlock = computeDeferBlock();
419         delegateOperation = DelegateOperation(_delegate, admin, deferBlock);
420         DelegateOperationEvent(_delegate, deferBlock);
421     }
422 
423     // after a day, admin finalizes mint request by providing the
424     // index of the request (visible in the MintOperationEvent accompanying the original request)
425     function finalizeMint(uint index) public onlyAdminOrOwner {
426         MintOperation memory op = mintOperations[index];
427         require(op.admin == admin); //checks that the requester's adminship has not been revoked
428         require(op.deferBlock <= block.number); //checks that enough time has elapsed
429         address to = op.to;
430         uint256 amount = op.amount;
431         delete mintOperations[index];
432         trueUSD.mint(to, amount);
433     }
434 
435     // after a day, admin finalizes the transfer of a child contract by providing the
436     // index of the request (visible in the TransferChildOperationEvent accompanying the original request)
437     function finalizeTransferChild(uint index) public onlyAdminOrOwner {
438         TransferChildOperation memory op = transferChildOperations[index];
439         require(op.admin == admin);
440         require(op.deferBlock <= block.number);
441         Ownable _child = op.child;
442         address _newOwner = op.newOwner;
443         delete transferChildOperations[index];
444         _child.transferOwnership(_newOwner);
445     }
446 
447     // after a day, admin finalizes the burn bounds change
448     function finalizeChangeBurnBounds() public onlyAdminOrOwner {
449         require(changeBurnBoundsOperation.admin == admin);
450         require(changeBurnBoundsOperation.deferBlock <= block.number);
451         uint newMin = changeBurnBoundsOperation.newMin;
452         uint newMax = changeBurnBoundsOperation.newMax;
453         delete changeBurnBoundsOperation;
454         trueUSD.changeBurnBounds(newMin, newMax);
455     }
456 
457     // after a day, admin finalizes the staking fee change
458     function finalizeChangeStakingFees() public onlyAdminOrOwner {
459         require(changeStakingFeesOperation.admin == admin);
460         require(changeStakingFeesOperation.deferBlock <= block.number);
461         uint80 _transferFeeNumerator = changeStakingFeesOperation._transferFeeNumerator;
462         uint80 _transferFeeDenominator = changeStakingFeesOperation._transferFeeDenominator;
463         uint80 _mintFeeNumerator = changeStakingFeesOperation._mintFeeNumerator;
464         uint80 _mintFeeDenominator = changeStakingFeesOperation._mintFeeDenominator;
465         uint256 _mintFeeFlat = changeStakingFeesOperation._mintFeeFlat;
466         uint80 _burnFeeNumerator = changeStakingFeesOperation._burnFeeNumerator;
467         uint80 _burnFeeDenominator = changeStakingFeesOperation._burnFeeDenominator;
468         uint256 _burnFeeFlat = changeStakingFeesOperation._burnFeeFlat;
469         delete changeStakingFeesOperation;
470         trueUSD.changeStakingFees(_transferFeeNumerator,
471                                   _transferFeeDenominator,
472                                   _mintFeeNumerator,
473                                   _mintFeeDenominator,
474                                   _mintFeeFlat,
475                                   _burnFeeNumerator,
476                                   _burnFeeDenominator,
477                                   _burnFeeFlat);
478     }
479 
480     // after a day, admin finalizes the staking fees recipient change
481     function finalizeChangeStaker() public onlyAdminOrOwner {
482         require(changeStakerOperation.admin == admin);
483         require(changeStakerOperation.deferBlock <= block.number);
484         address newStaker = changeStakerOperation.newStaker;
485         delete changeStakerOperation;
486         trueUSD.changeStaker(newStaker);
487     }
488 
489     // after a day, admin finalizes the delegation
490     function finalizeDelegation() public onlyAdminOrOwner {
491         require(delegateOperation.admin == admin);
492         require(delegateOperation.deferBlock <= block.number);
493         address delegate = delegateOperation.delegate;
494         delete delegateOperation;
495         trueUSD.delegateToNewContract(delegate);
496     }
497 
498     // Owner of this contract (immediately) replaces the current admin with newAdmin
499     function transferAdminship(address newAdmin) public onlyOwner {
500         AdminshipTransferred(admin, newAdmin);
501         admin = newAdmin;
502     }
503 
504     // admin (immediately) updates a whitelist/blacklist
505     function updateList(address list, address entry, bool flag) public onlyAdminOrOwner {
506         AddressList(list).changeList(entry, flag);
507     }
508 
509     function issueClaimOwnership(address _other) public onlyAdminOrOwner {
510         Claimable other = Claimable(_other);
511         other.claimOwnership();
512     }
513 }
514 
515 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
516 }
517 
518 contract ERC20Basic {
519   function totalSupply() public view returns (uint256);
520   function balanceOf(address who) public view returns (uint256);
521   function transfer(address to, uint256 value) public returns (bool);
522   event Transfer(address indexed from, address indexed to, uint256 value);
523 }
524 
525 contract BasicToken is ERC20Basic {
526   using SafeMath for uint256;
527 
528   mapping(address => uint256) balances;
529 
530   uint256 totalSupply_;
531 
532   /**
533   * @dev total number of tokens in existence
534   */
535   function totalSupply() public view returns (uint256) {
536     return totalSupply_;
537   }
538 
539   /**
540   * @dev transfer token for a specified address
541   * @param _to The address to transfer to.
542   * @param _value The amount to be transferred.
543   */
544   function transfer(address _to, uint256 _value) public returns (bool) {
545     require(_to != address(0));
546     require(_value <= balances[msg.sender]);
547 
548     // SafeMath.sub will throw if there is not enough balance.
549     balances[msg.sender] = balances[msg.sender].sub(_value);
550     balances[_to] = balances[_to].add(_value);
551     Transfer(msg.sender, _to, _value);
552     return true;
553   }
554 
555   /**
556   * @dev Gets the balance of the specified address.
557   * @param _owner The address to query the the balance of.
558   * @return An uint256 representing the amount owned by the passed address.
559   */
560   function balanceOf(address _owner) public view returns (uint256 balance) {
561     return balances[_owner];
562   }
563 
564 }
565 
566 contract BurnableToken is BasicToken {
567 
568   event Burn(address indexed burner, uint256 value);
569 
570   /**
571    * @dev Burns a specific amount of tokens.
572    * @param _value The amount of token to be burned.
573    */
574   function burn(uint256 _value) public {
575     require(_value <= balances[msg.sender]);
576     // no need to require value <= totalSupply, since that would imply the
577     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
578 
579     address burner = msg.sender;
580     balances[burner] = balances[burner].sub(_value);
581     totalSupply_ = totalSupply_.sub(_value);
582     Burn(burner, _value);
583   }
584 }
585 
586 contract ERC20 is ERC20Basic {
587   function allowance(address owner, address spender) public view returns (uint256);
588   function transferFrom(address from, address to, uint256 value) public returns (bool);
589   function approve(address spender, uint256 value) public returns (bool);
590   event Approval(address indexed owner, address indexed spender, uint256 value);
591 }
592 
593 library SafeERC20 {
594   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
595     assert(token.transfer(to, value));
596   }
597 
598   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
599     assert(token.transferFrom(from, to, value));
600   }
601 
602   function safeApprove(ERC20 token, address spender, uint256 value) internal {
603     assert(token.approve(spender, value));
604   }
605 }
606 
607 contract StandardToken is ERC20, BasicToken {
608 
609   mapping (address => mapping (address => uint256)) internal allowed;
610 
611 
612   /**
613    * @dev Transfer tokens from one address to another
614    * @param _from address The address which you want to send tokens from
615    * @param _to address The address which you want to transfer to
616    * @param _value uint256 the amount of tokens to be transferred
617    */
618   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
619     require(_to != address(0));
620     require(_value <= balances[_from]);
621     require(_value <= allowed[_from][msg.sender]);
622 
623     balances[_from] = balances[_from].sub(_value);
624     balances[_to] = balances[_to].add(_value);
625     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
626     Transfer(_from, _to, _value);
627     return true;
628   }
629 
630   /**
631    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
632    *
633    * Beware that changing an allowance with this method brings the risk that someone may use both the old
634    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
635    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
636    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
637    * @param _spender The address which will spend the funds.
638    * @param _value The amount of tokens to be spent.
639    */
640   function approve(address _spender, uint256 _value) public returns (bool) {
641     allowed[msg.sender][_spender] = _value;
642     Approval(msg.sender, _spender, _value);
643     return true;
644   }
645 
646   /**
647    * @dev Function to check the amount of tokens that an owner allowed to a spender.
648    * @param _owner address The address which owns the funds.
649    * @param _spender address The address which will spend the funds.
650    * @return A uint256 specifying the amount of tokens still available for the spender.
651    */
652   function allowance(address _owner, address _spender) public view returns (uint256) {
653     return allowed[_owner][_spender];
654   }
655 
656   /**
657    * @dev Increase the amount of tokens that an owner allowed to a spender.
658    *
659    * approve should be called when allowed[_spender] == 0. To increment
660    * allowed value is better to use this function to avoid 2 calls (and wait until
661    * the first transaction is mined)
662    * From MonolithDAO Token.sol
663    * @param _spender The address which will spend the funds.
664    * @param _addedValue The amount of tokens to increase the allowance by.
665    */
666   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
667     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
668     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
669     return true;
670   }
671 
672   /**
673    * @dev Decrease the amount of tokens that an owner allowed to a spender.
674    *
675    * approve should be called when allowed[_spender] == 0. To decrement
676    * allowed value is better to use this function to avoid 2 calls (and wait until
677    * the first transaction is mined)
678    * From MonolithDAO Token.sol
679    * @param _spender The address which will spend the funds.
680    * @param _subtractedValue The amount of tokens to decrease the allowance by.
681    */
682   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
683     uint oldValue = allowed[msg.sender][_spender];
684     if (_subtractedValue > oldValue) {
685       allowed[msg.sender][_spender] = 0;
686     } else {
687       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
688     }
689     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
690     return true;
691   }
692 
693 }
694 
695 contract PausableToken is StandardToken, Pausable {
696 
697   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
698     return super.transfer(_to, _value);
699   }
700 
701   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
702     return super.transferFrom(_from, _to, _value);
703   }
704 
705   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
706     return super.approve(_spender, _value);
707   }
708 
709   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
710     return super.increaseApproval(_spender, _addedValue);
711   }
712 
713   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
714     return super.decreaseApproval(_spender, _subtractedValue);
715   }
716 }
717 
718 contract TrueUSD is PausableToken, BurnableToken, NoOwner, Claimable {
719     string public constant name = "TrueUSD";
720     string public constant symbol = "TUSD";
721     uint8 public constant decimals = 18;
722 
723     AddressList public canReceiveMintWhitelist;
724     AddressList public canBurnWhiteList;
725     AddressList public blackList;
726     uint256 public burnMin = 10000 * 10**uint256(decimals);
727     uint256 public burnMax = 20000000 * 10**uint256(decimals);
728 
729     uint80 public transferFeeNumerator = 0;
730     uint80 public transferFeeDenominator = 10000;
731     uint80 public mintFeeNumerator = 0;
732     uint80 public mintFeeDenominator = 10000;
733     uint256 public mintFeeFlat = 0;
734     uint80 public burnFeeNumerator = 0;
735     uint80 public burnFeeDenominator = 10000;
736     uint256 public burnFeeFlat = 0;
737     address public staker;
738 
739     // If this contract needs to be upgraded, the new contract will be stored
740     // in 'delegate' and any ERC20 calls to this contract will be delegated to that one.
741     DelegateERC20 public delegate;
742 
743     event ChangeBurnBoundsEvent(uint256 newMin, uint256 newMax);
744     event Mint(address indexed to, uint256 amount);
745     event WipedAccount(address indexed account, uint256 balance);
746     event DelegatedTo(address indexed newContract);
747 
748     function TrueUSD(address _canMintWhiteList, address _canBurnWhiteList, address _blackList) public {
749         totalSupply_ = 0;
750         canReceiveMintWhitelist = AddressList(_canMintWhiteList);
751         canBurnWhiteList = AddressList(_canBurnWhiteList);
752         blackList = AddressList(_blackList);
753         staker = msg.sender;
754     }
755 
756     //Burning functions as withdrawing money from the system. The platform will keep track of who burns coins,
757     //and will send them back the equivalent amount of money (rounded down to the nearest cent).
758     function burn(uint256 _value) public {
759         require(canBurnWhiteList.onList(msg.sender));
760         require(_value >= burnMin);
761         require(_value <= burnMax);
762         uint256 fee = payStakingFee(msg.sender, _value, burnFeeNumerator, burnFeeDenominator, burnFeeFlat);
763         uint256 remaining = _value.sub(fee);
764         super.burn(remaining);
765     }
766 
767     //Create _amount new tokens and transfer them to _to.
768     //Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/MintableToken.sol
769     function mint(address _to, uint256 _amount) onlyOwner public {
770         require(canReceiveMintWhitelist.onList(_to));
771         totalSupply_ = totalSupply_.add(_amount);
772         balances[_to] = balances[_to].add(_amount);
773         Mint(_to, _amount);
774         Transfer(address(0), _to, _amount);
775         payStakingFee(_to, _amount, mintFeeNumerator, mintFeeDenominator, mintFeeFlat);
776     }
777 
778     //Change the minimum and maximum amount that can be burned at once. Burning
779     //may be disabled by setting both to 0 (this will not be done under normal
780     //operation, but we can't add checks to disallow it without losing a lot of
781     //flexibility since burning could also be as good as disabled
782     //by setting the minimum extremely high, and we don't want to lock
783     //in any particular cap for the minimum)
784     function changeBurnBounds(uint newMin, uint newMax) onlyOwner public {
785         require(newMin <= newMax);
786         burnMin = newMin;
787         burnMax = newMax;
788         ChangeBurnBoundsEvent(newMin, newMax);
789     }
790 
791     function transfer(address to, uint256 value) public returns (bool) {
792         require(!blackList.onList(msg.sender));
793         require(!blackList.onList(to));
794         if (delegate == address(0)) {
795             bool result = super.transfer(to, value);
796             payStakingFee(to, value, transferFeeNumerator, transferFeeDenominator, 0);
797             return result;
798         } else {
799             return delegate.delegateTransfer(to, value, msg.sender);
800         }
801     }
802 
803     function transferFrom(address from, address to, uint256 value) public returns (bool) {
804         require(!blackList.onList(from));
805         require(!blackList.onList(to));
806         if (delegate == address(0)) {
807             bool result = super.transferFrom(from, to, value);
808             payStakingFee(to, value, transferFeeNumerator, transferFeeDenominator, 0);
809             return result;
810         } else {
811             return delegate.delegateTransferFrom(from, to, value, msg.sender);
812         }
813     }
814 
815     function balanceOf(address who) public view returns (uint256) {
816         if (delegate == address(0)) {
817             return super.balanceOf(who);
818         } else {
819             return delegate.delegateBalanceOf(who);
820         }
821     }
822 
823     function approve(address spender, uint256 value) public returns (bool) {
824         if (delegate == address(0)) {
825             return super.approve(spender, value);
826         } else {
827             return delegate.delegateApprove(spender, value, msg.sender);
828         }
829     }
830 
831     function allowance(address _owner, address spender) public view returns (uint256) {
832         if (delegate == address(0)) {
833             return super.allowance(_owner, spender);
834         } else {
835             return delegate.delegateAllowance(_owner, spender);
836         }
837     }
838 
839     function totalSupply() public view returns (uint256) {
840         if (delegate == address(0)) {
841             return super.totalSupply();
842         } else {
843             return delegate.delegateTotalSupply();
844         }
845     }
846 
847     function increaseApproval(address spender, uint addedValue) public returns (bool) {
848         if (delegate == address(0)) {
849             return super.increaseApproval(spender, addedValue);
850         } else {
851             return delegate.delegateIncreaseApproval(spender, addedValue, msg.sender);
852         }
853     }
854 
855     function decreaseApproval(address spender, uint subtractedValue) public returns (bool) {
856         if (delegate == address(0)) {
857             return super.decreaseApproval(spender, subtractedValue);
858         } else {
859             return delegate.delegateDecreaseApproval(spender, subtractedValue, msg.sender);
860         }
861     }
862 
863     function wipeBlacklistedAccount(address account) public onlyOwner {
864         require(blackList.onList(account));
865         uint256 oldValue = balanceOf(account);
866         balances[account] = 0;
867         totalSupply_ = totalSupply_.sub(oldValue);
868         WipedAccount(account, oldValue);
869     }
870 
871     function payStakingFee(address payer, uint256 value, uint80 numerator, uint80 denominator, uint256 flatRate) private returns (uint256) {
872         uint256 stakingFee = value.mul(numerator).div(denominator).add(flatRate);
873         if (stakingFee > 0) {
874             transferFromWithoutAllowance(payer, staker, stakingFee);
875         }
876         return stakingFee;
877     }
878 
879     // based on 'transfer' in https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
880     function transferFromWithoutAllowance(address from, address _to, uint256 _value) private {
881         assert(_to != address(0));
882         assert(_value <= balances[from]);
883         balances[from] = balances[from].sub(_value);
884         balances[_to] = balances[_to].add(_value);
885         Transfer(from, _to, _value);
886     }
887 
888     function changeStakingFees(uint80 _transferFeeNumerator,
889                                  uint80 _transferFeeDenominator,
890                                  uint80 _mintFeeNumerator,
891                                  uint80 _mintFeeDenominator,
892                                  uint256 _mintFeeFlat,
893                                  uint80 _burnFeeNumerator,
894                                  uint80 _burnFeeDenominator,
895                                  uint256 _burnFeeFlat) public onlyOwner {
896         require(_transferFeeDenominator != 0);
897         require(_mintFeeDenominator != 0);
898         require(_burnFeeDenominator != 0);
899         transferFeeNumerator = _transferFeeNumerator;
900         transferFeeDenominator = _transferFeeDenominator;
901         mintFeeNumerator = _mintFeeNumerator;
902         mintFeeDenominator = _mintFeeDenominator;
903         mintFeeFlat = _mintFeeFlat;
904         burnFeeNumerator = _burnFeeNumerator;
905         burnFeeDenominator = _burnFeeDenominator;
906         burnFeeFlat = _burnFeeFlat;
907     }
908 
909     function changeStaker(address newStaker) public onlyOwner {
910         require(newStaker != address(0));
911         staker = newStaker;
912     }
913 
914     // Can undelegate by passing in newContract = address(0)
915     function delegateToNewContract(address newContract) public onlyOwner {
916         delegate = DelegateERC20(newContract);
917         DelegatedTo(newContract);
918     }
919 }