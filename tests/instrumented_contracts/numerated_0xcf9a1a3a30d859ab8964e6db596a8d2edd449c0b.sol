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
265     struct TransferOwnershipOperation {
266         address newOwner;
267         address admin;
268         uint deferBlock;
269     }
270 
271     struct ChangeBurnBoundsOperation {
272         uint newMin;
273         uint newMax;
274         address admin;
275         uint deferBlock;
276     }
277 
278     struct ChangeInsuranceFeesOperation {
279         uint80 _transferFeeNumerator;
280         uint80 _transferFeeDenominator;
281         uint80 _mintFeeNumerator;
282         uint80 _mintFeeDenominator;
283         uint256 _mintFeeFlat;
284         uint80 _burnFeeNumerator;
285         uint80 _burnFeeDenominator;
286         uint256 _burnFeeFlat;
287         address admin;
288         uint deferBlock;
289     }
290 
291     struct ChangeInsurerOperation {
292         address newInsurer;
293         address admin;
294         uint deferBlock;
295     }
296 
297     address public admin;
298     TrueUSD public child;
299     AddressList public canBurnWhiteList;
300     AddressList public canReceiveMintWhitelist;
301     AddressList public blackList;
302     MintOperation[] public mintOperations;
303     TransferOwnershipOperation public transferOwnershipOperation;
304     ChangeBurnBoundsOperation public changeBurnBoundsOperation;
305     ChangeInsuranceFeesOperation public changeInsuranceFeesOperation;
306     ChangeInsurerOperation public changeInsurerOperation;
307 
308     modifier onlyAdminOrOwner() {
309         require(msg.sender == admin || msg.sender == owner);
310         _;
311     }
312 
313     function computeDeferBlock() private view returns (uint) {
314         if (msg.sender == owner) {
315             return block.number;
316         } else {
317             return block.number.add(blocksDelay);
318         }
319     }
320 
321     // starts with no admin
322     function TimeLockedController(address _child, address _canBurnWhiteList, address _canReceiveMintWhitelist, address _blackList) public {
323         child = TrueUSD(_child);
324         canBurnWhiteList = AddressList(_canBurnWhiteList);
325         canReceiveMintWhitelist = AddressList(_canReceiveMintWhitelist);
326         blackList = AddressList(_blackList);
327     }
328 
329     event MintOperationEvent(address indexed _to, uint256 amount, uint deferBlock, uint opIndex);
330     event TransferOwnershipOperationEvent(address newOwner, uint deferBlock);
331     event ChangeBurnBoundsOperationEvent(uint newMin, uint newMax, uint deferBlock);
332     event ChangeInsuranceFeesOperationEvent(uint80 _transferFeeNumerator,
333                                             uint80 _transferFeeDenominator,
334                                             uint80 _mintFeeNumerator,
335                                             uint80 _mintFeeDenominator,
336                                             uint256 _mintFeeFlat,
337                                             uint80 _burnFeeNumerator,
338                                             uint80 _burnFeeDenominator,
339                                             uint256 _burnFeeFlat,
340                                             uint deferBlock);
341     event ChangeInsurerOperationEvent(address newInsurer, uint deferBlock);
342     event AdminshipTransferred(address indexed previousAdmin, address indexed newAdmin);
343 
344     // admin initiates a request to mint _amount TrueUSD for account _to
345     function requestMint(address _to, uint256 _amount) public onlyAdminOrOwner {
346         uint deferBlock = computeDeferBlock();
347         MintOperation memory op = MintOperation(_to, _amount, admin, deferBlock);
348         MintOperationEvent(_to, _amount, deferBlock, mintOperations.length);
349         mintOperations.push(op);
350     }
351 
352     // admin initiates a request to transfer ownership of the TrueUSD contract and all AddressLists to newOwner.
353     // Can be used e.g. to upgrade this TimeLockedController contract.
354     function requestTransferChildrenOwnership(address newOwner) public onlyAdminOrOwner {
355         uint deferBlock = computeDeferBlock();
356         transferOwnershipOperation = TransferOwnershipOperation(newOwner, admin, deferBlock);
357         TransferOwnershipOperationEvent(newOwner, deferBlock);
358     }
359 
360     // admin initiates a request that the minimum and maximum amounts that any TrueUSD user can
361     // burn become newMin and newMax
362     function requestChangeBurnBounds(uint newMin, uint newMax) public onlyAdminOrOwner {
363         uint deferBlock = computeDeferBlock();
364         changeBurnBoundsOperation = ChangeBurnBoundsOperation(newMin, newMax, admin, deferBlock);
365         ChangeBurnBoundsOperationEvent(newMin, newMax, deferBlock);
366     }
367 
368     // admin initiates a request that the insurance fee be changed
369     function requestChangeInsuranceFees(uint80 _transferFeeNumerator,
370                                         uint80 _transferFeeDenominator,
371                                         uint80 _mintFeeNumerator,
372                                         uint80 _mintFeeDenominator,
373                                         uint256 _mintFeeFlat,
374                                         uint80 _burnFeeNumerator,
375                                         uint80 _burnFeeDenominator,
376                                         uint256 _burnFeeFlat) public onlyAdminOrOwner {
377         uint deferBlock = computeDeferBlock();
378         changeInsuranceFeesOperation = ChangeInsuranceFeesOperation(_transferFeeNumerator,
379                                                                     _transferFeeDenominator,
380                                                                     _mintFeeNumerator,
381                                                                     _mintFeeDenominator,
382                                                                     _mintFeeFlat,
383                                                                     _burnFeeNumerator,
384                                                                     _burnFeeDenominator,
385                                                                     _burnFeeFlat,
386                                                                     admin,
387                                                                     deferBlock);
388         ChangeInsuranceFeesOperationEvent(_transferFeeNumerator,
389                                           _transferFeeDenominator,
390                                           _mintFeeNumerator,
391                                           _mintFeeDenominator,
392                                           _mintFeeFlat,
393                                           _burnFeeNumerator,
394                                           _burnFeeDenominator,
395                                           _burnFeeFlat,
396                                           deferBlock);
397     }
398 
399     // admin initiates a request that the recipient of the insurance fee be changed to newInsurer
400     function requestChangeInsurer(address newInsurer) public onlyAdminOrOwner {
401         uint deferBlock = computeDeferBlock();
402         changeInsurerOperation = ChangeInsurerOperation(newInsurer, admin, deferBlock);
403         ChangeInsurerOperationEvent(newInsurer, deferBlock);
404     }
405 
406     // after a day, beneficiary of a mint request finalizes it by providing the
407     // index of the request (visible in the MintOperationEvent accompanying the original request)
408     function finalizeMint(uint index) public onlyAdminOrOwner {
409         MintOperation memory op = mintOperations[index];
410         require(op.admin == admin); //checks that the requester's adminship has not been revoked
411         require(op.deferBlock <= block.number); //checks that enough time has elapsed
412         address to = op.to;
413         uint256 amount = op.amount;
414         delete mintOperations[index];
415         child.mint(to, amount);
416     }
417 
418     // after a day, admin finalizes the ownership change
419     function finalizeTransferChildrenOwnership() public onlyAdminOrOwner {
420         require(transferOwnershipOperation.admin == admin);
421         require(transferOwnershipOperation.deferBlock <= block.number);
422         address newOwner = transferOwnershipOperation.newOwner;
423         delete transferOwnershipOperation;
424         child.transferOwnership(newOwner);
425         canBurnWhiteList.transferOwnership(newOwner);
426         canReceiveMintWhitelist.transferOwnership(newOwner);
427         blackList.transferOwnership(newOwner);
428     }
429 
430     // after a day, admin finalizes the burn bounds change
431     function finalizeChangeBurnBounds() public onlyAdminOrOwner {
432         require(changeBurnBoundsOperation.admin == admin);
433         require(changeBurnBoundsOperation.deferBlock <= block.number);
434         uint newMin = changeBurnBoundsOperation.newMin;
435         uint newMax = changeBurnBoundsOperation.newMax;
436         delete changeBurnBoundsOperation;
437         child.changeBurnBounds(newMin, newMax);
438     }
439 
440     // after a day, admin finalizes the insurance fee change
441     function finalizeChangeInsuranceFees() public onlyAdminOrOwner {
442         require(changeInsuranceFeesOperation.admin == admin);
443         require(changeInsuranceFeesOperation.deferBlock <= block.number);
444         uint80 _transferFeeNumerator = changeInsuranceFeesOperation._transferFeeNumerator;
445         uint80 _transferFeeDenominator = changeInsuranceFeesOperation._transferFeeDenominator;
446         uint80 _mintFeeNumerator = changeInsuranceFeesOperation._mintFeeNumerator;
447         uint80 _mintFeeDenominator = changeInsuranceFeesOperation._mintFeeDenominator;
448         uint256 _mintFeeFlat = changeInsuranceFeesOperation._mintFeeFlat;
449         uint80 _burnFeeNumerator = changeInsuranceFeesOperation._burnFeeNumerator;
450         uint80 _burnFeeDenominator = changeInsuranceFeesOperation._burnFeeDenominator;
451         uint256 _burnFeeFlat = changeInsuranceFeesOperation._burnFeeFlat;
452         delete changeInsuranceFeesOperation;
453         child.changeInsuranceFees(_transferFeeNumerator,
454                                   _transferFeeDenominator,
455                                   _mintFeeNumerator,
456                                   _mintFeeDenominator,
457                                   _mintFeeFlat,
458                                   _burnFeeNumerator,
459                                   _burnFeeDenominator,
460                                   _burnFeeFlat);
461     }
462 
463     // after a day, admin finalizes the insurance fees recipient change
464     function finalizeChangeInsurer() public onlyAdminOrOwner {
465         require(changeInsurerOperation.admin == admin);
466         require(changeInsurerOperation.deferBlock <= block.number);
467         address newInsurer = changeInsurerOperation.newInsurer;
468         delete changeInsurerOperation;
469         child.changeInsurer(newInsurer);
470     }
471 
472     // Owner of this contract (immediately) replaces the current admin with newAdmin
473     function transferAdminship(address newAdmin) public onlyOwner {
474         AdminshipTransferred(admin, newAdmin);
475         admin = newAdmin;
476     }
477 
478     // admin (immediately) updates a whitelist/blacklist
479     function updateList(address list, address entry, bool flag) public onlyAdminOrOwner {
480         AddressList(list).changeList(entry, flag);
481     }
482 
483     function issueClaimOwnership(address _other) public onlyAdminOrOwner {
484         Claimable other = Claimable(_other);
485         other.claimOwnership();
486     }
487 }
488 
489 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
490 }
491 
492 contract ERC20Basic {
493   function totalSupply() public view returns (uint256);
494   function balanceOf(address who) public view returns (uint256);
495   function transfer(address to, uint256 value) public returns (bool);
496   event Transfer(address indexed from, address indexed to, uint256 value);
497 }
498 
499 contract BasicToken is ERC20Basic {
500   using SafeMath for uint256;
501 
502   mapping(address => uint256) balances;
503 
504   uint256 totalSupply_;
505 
506   /**
507   * @dev total number of tokens in existence
508   */
509   function totalSupply() public view returns (uint256) {
510     return totalSupply_;
511   }
512 
513   /**
514   * @dev transfer token for a specified address
515   * @param _to The address to transfer to.
516   * @param _value The amount to be transferred.
517   */
518   function transfer(address _to, uint256 _value) public returns (bool) {
519     require(_to != address(0));
520     require(_value <= balances[msg.sender]);
521 
522     // SafeMath.sub will throw if there is not enough balance.
523     balances[msg.sender] = balances[msg.sender].sub(_value);
524     balances[_to] = balances[_to].add(_value);
525     Transfer(msg.sender, _to, _value);
526     return true;
527   }
528 
529   /**
530   * @dev Gets the balance of the specified address.
531   * @param _owner The address to query the the balance of.
532   * @return An uint256 representing the amount owned by the passed address.
533   */
534   function balanceOf(address _owner) public view returns (uint256 balance) {
535     return balances[_owner];
536   }
537 
538 }
539 
540 contract BurnableToken is BasicToken {
541 
542   event Burn(address indexed burner, uint256 value);
543 
544   /**
545    * @dev Burns a specific amount of tokens.
546    * @param _value The amount of token to be burned.
547    */
548   function burn(uint256 _value) public {
549     require(_value <= balances[msg.sender]);
550     // no need to require value <= totalSupply, since that would imply the
551     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
552 
553     address burner = msg.sender;
554     balances[burner] = balances[burner].sub(_value);
555     totalSupply_ = totalSupply_.sub(_value);
556     Burn(burner, _value);
557   }
558 }
559 
560 contract ERC20 is ERC20Basic {
561   function allowance(address owner, address spender) public view returns (uint256);
562   function transferFrom(address from, address to, uint256 value) public returns (bool);
563   function approve(address spender, uint256 value) public returns (bool);
564   event Approval(address indexed owner, address indexed spender, uint256 value);
565 }
566 
567 library SafeERC20 {
568   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
569     assert(token.transfer(to, value));
570   }
571 
572   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
573     assert(token.transferFrom(from, to, value));
574   }
575 
576   function safeApprove(ERC20 token, address spender, uint256 value) internal {
577     assert(token.approve(spender, value));
578   }
579 }
580 
581 contract StandardToken is ERC20, BasicToken {
582 
583   mapping (address => mapping (address => uint256)) internal allowed;
584 
585 
586   /**
587    * @dev Transfer tokens from one address to another
588    * @param _from address The address which you want to send tokens from
589    * @param _to address The address which you want to transfer to
590    * @param _value uint256 the amount of tokens to be transferred
591    */
592   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
593     require(_to != address(0));
594     require(_value <= balances[_from]);
595     require(_value <= allowed[_from][msg.sender]);
596 
597     balances[_from] = balances[_from].sub(_value);
598     balances[_to] = balances[_to].add(_value);
599     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
600     Transfer(_from, _to, _value);
601     return true;
602   }
603 
604   /**
605    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
606    *
607    * Beware that changing an allowance with this method brings the risk that someone may use both the old
608    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
609    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
610    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
611    * @param _spender The address which will spend the funds.
612    * @param _value The amount of tokens to be spent.
613    */
614   function approve(address _spender, uint256 _value) public returns (bool) {
615     allowed[msg.sender][_spender] = _value;
616     Approval(msg.sender, _spender, _value);
617     return true;
618   }
619 
620   /**
621    * @dev Function to check the amount of tokens that an owner allowed to a spender.
622    * @param _owner address The address which owns the funds.
623    * @param _spender address The address which will spend the funds.
624    * @return A uint256 specifying the amount of tokens still available for the spender.
625    */
626   function allowance(address _owner, address _spender) public view returns (uint256) {
627     return allowed[_owner][_spender];
628   }
629 
630   /**
631    * @dev Increase the amount of tokens that an owner allowed to a spender.
632    *
633    * approve should be called when allowed[_spender] == 0. To increment
634    * allowed value is better to use this function to avoid 2 calls (and wait until
635    * the first transaction is mined)
636    * From MonolithDAO Token.sol
637    * @param _spender The address which will spend the funds.
638    * @param _addedValue The amount of tokens to increase the allowance by.
639    */
640   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
641     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
642     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
643     return true;
644   }
645 
646   /**
647    * @dev Decrease the amount of tokens that an owner allowed to a spender.
648    *
649    * approve should be called when allowed[_spender] == 0. To decrement
650    * allowed value is better to use this function to avoid 2 calls (and wait until
651    * the first transaction is mined)
652    * From MonolithDAO Token.sol
653    * @param _spender The address which will spend the funds.
654    * @param _subtractedValue The amount of tokens to decrease the allowance by.
655    */
656   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
657     uint oldValue = allowed[msg.sender][_spender];
658     if (_subtractedValue > oldValue) {
659       allowed[msg.sender][_spender] = 0;
660     } else {
661       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
662     }
663     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
664     return true;
665   }
666 
667 }
668 
669 contract PausableToken is StandardToken, Pausable {
670 
671   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
672     return super.transfer(_to, _value);
673   }
674 
675   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
676     return super.transferFrom(_from, _to, _value);
677   }
678 
679   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
680     return super.approve(_spender, _value);
681   }
682 
683   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
684     return super.increaseApproval(_spender, _addedValue);
685   }
686 
687   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
688     return super.decreaseApproval(_spender, _subtractedValue);
689   }
690 }
691 
692 contract TrueUSD is PausableToken, BurnableToken, NoOwner, Claimable {
693     string public constant name = "TrueUSD";
694     string public constant symbol = "TUSD";
695     uint8 public constant decimals = 18;
696 
697     AddressList public canReceiveMintWhitelist;
698     AddressList public canBurnWhiteList;
699     AddressList public blackList;
700     uint256 public burnMin = 10000 * 10**uint256(decimals);
701     uint256 public burnMax = 20000000 * 10**uint256(decimals);
702 
703     uint80 public transferFeeNumerator = 7;
704     uint80 public transferFeeDenominator = 10000;
705     uint80 public mintFeeNumerator = 0;
706     uint80 public mintFeeDenominator = 10000;
707     uint256 public mintFeeFlat = 0;
708     uint80 public burnFeeNumerator = 0;
709     uint80 public burnFeeDenominator = 10000;
710     uint256 public burnFeeFlat = 0;
711     address public insurer;
712 
713     // If this contract needs to be upgraded, the new contract will be stored
714     // in 'delegate' and any ERC20 calls to this contract will be delegated to that one.
715     DelegateERC20 public delegate;
716 
717     event ChangeBurnBoundsEvent(uint256 newMin, uint256 newMax);
718     event Mint(address indexed to, uint256 amount);
719     event WipedAccount(address indexed account, uint256 balance);
720     event DelegatedTo(address indexed newContract);
721 
722     function TrueUSD(address _canMintWhiteList, address _canBurnWhiteList, address _blackList) public {
723         totalSupply_ = 0;
724         canReceiveMintWhitelist = AddressList(_canMintWhiteList);
725         canBurnWhiteList = AddressList(_canBurnWhiteList);
726         blackList = AddressList(_blackList);
727         insurer = msg.sender;
728     }
729 
730     //Burning functions as withdrawing money from the system. The platform will keep track of who burns coins,
731     //and will send them back the equivalent amount of money (rounded down to the nearest cent).
732     function burn(uint256 _value) public {
733         require(canBurnWhiteList.onList(msg.sender));
734         require(_value >= burnMin);
735         require(_value <= burnMax);
736         uint256 fee = payInsuranceFee(msg.sender, _value, burnFeeNumerator, burnFeeDenominator, burnFeeFlat);
737         uint256 remaining = _value.sub(fee);
738         super.burn(remaining);
739     }
740 
741     //Create _amount new tokens and transfer them to _to.
742     //Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/MintableToken.sol
743     function mint(address _to, uint256 _amount) onlyOwner public {
744         require(canReceiveMintWhitelist.onList(_to));
745         totalSupply_ = totalSupply_.add(_amount);
746         balances[_to] = balances[_to].add(_amount);
747         Mint(_to, _amount);
748         Transfer(address(0), _to, _amount);
749         payInsuranceFee(_to, _amount, mintFeeNumerator, mintFeeDenominator, mintFeeFlat);
750     }
751 
752     //Change the minimum and maximum amount that can be burned at once. Burning
753     //may be disabled by setting both to 0 (this will not be done under normal
754     //operation, but we can't add checks to disallow it without losing a lot of
755     //flexibility since burning could also be as good as disabled
756     //by setting the minimum extremely high, and we don't want to lock
757     //in any particular cap for the minimum)
758     function changeBurnBounds(uint newMin, uint newMax) onlyOwner public {
759         require(newMin <= newMax);
760         burnMin = newMin;
761         burnMax = newMax;
762         ChangeBurnBoundsEvent(newMin, newMax);
763     }
764 
765     function transfer(address to, uint256 value) public returns (bool) {
766         require(!blackList.onList(msg.sender));
767         require(!blackList.onList(to));
768         if (delegate == address(0)) {
769             bool result = super.transfer(to, value);
770             payInsuranceFee(to, value, transferFeeNumerator, transferFeeDenominator, 0);
771             return result;
772         } else {
773             return delegate.delegateTransfer(to, value, msg.sender);
774         }
775     }
776 
777     function transferFrom(address from, address to, uint256 value) public returns (bool) {
778         require(!blackList.onList(from));
779         require(!blackList.onList(to));
780         if (delegate == address(0)) {
781             bool result = super.transferFrom(from, to, value);
782             payInsuranceFee(to, value, transferFeeNumerator, transferFeeDenominator, 0);
783             return result;
784         } else {
785             return delegate.delegateTransferFrom(from, to, value, msg.sender);
786         }
787     }
788 
789     function balanceOf(address who) public view returns (uint256) {
790         if (delegate == address(0)) {
791             return super.balanceOf(who);
792         } else {
793             return delegate.delegateBalanceOf(who);
794         }
795     }
796 
797     function approve(address spender, uint256 value) public returns (bool) {
798         if (delegate == address(0)) {
799             return super.approve(spender, value);
800         } else {
801             return delegate.delegateApprove(spender, value, msg.sender);
802         }
803     }
804 
805     function allowance(address _owner, address spender) public view returns (uint256) {
806         if (delegate == address(0)) {
807             return super.allowance(_owner, spender);
808         } else {
809             return delegate.delegateAllowance(_owner, spender);
810         }
811     }
812 
813     function totalSupply() public view returns (uint256) {
814         if (delegate == address(0)) {
815             return super.totalSupply();
816         } else {
817             return delegate.delegateTotalSupply();
818         }
819     }
820 
821     function increaseApproval(address spender, uint addedValue) public returns (bool) {
822         if (delegate == address(0)) {
823             return super.increaseApproval(spender, addedValue);
824         } else {
825             return delegate.delegateIncreaseApproval(spender, addedValue, msg.sender);
826         }
827     }
828 
829     function decreaseApproval(address spender, uint subtractedValue) public returns (bool) {
830         if (delegate == address(0)) {
831             return super.decreaseApproval(spender, subtractedValue);
832         } else {
833             return delegate.delegateDecreaseApproval(spender, subtractedValue, msg.sender);
834         }
835     }
836 
837     function wipeBlacklistedAccount(address account) public onlyOwner {
838         require(blackList.onList(account));
839         uint256 oldValue = balanceOf(account);
840         balances[account] = 0;
841         totalSupply_ = totalSupply_.sub(oldValue);
842         WipedAccount(account, oldValue);
843     }
844 
845     function payInsuranceFee(address payer, uint256 value, uint80 numerator, uint80 denominator, uint256 flatRate) private returns (uint256) {
846         uint256 insuranceFee = value.mul(numerator).div(denominator).add(flatRate);
847         if (insuranceFee > 0) {
848             transferFromWithoutAllowance(payer, insurer, insuranceFee);
849         }
850         return insuranceFee;
851     }
852 
853     // based on 'transfer' in https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
854     function transferFromWithoutAllowance(address from, address _to, uint256 _value) private {
855         assert(_to != address(0));
856         assert(_value <= balances[from]);
857         balances[from] = balances[from].sub(_value);
858         balances[_to] = balances[_to].add(_value);
859         Transfer(from, _to, _value);
860     }
861 
862     function changeInsuranceFees(uint80 _transferFeeNumerator,
863                                  uint80 _transferFeeDenominator,
864                                  uint80 _mintFeeNumerator,
865                                  uint80 _mintFeeDenominator,
866                                  uint256 _mintFeeFlat,
867                                  uint80 _burnFeeNumerator,
868                                  uint80 _burnFeeDenominator,
869                                  uint256 _burnFeeFlat) public onlyOwner {
870         require(_transferFeeDenominator != 0);
871         require(_mintFeeDenominator != 0);
872         require(_burnFeeDenominator != 0);
873         transferFeeNumerator = _transferFeeNumerator;
874         transferFeeDenominator = _transferFeeDenominator;
875         mintFeeNumerator = _mintFeeNumerator;
876         mintFeeDenominator = _mintFeeDenominator;
877         mintFeeFlat = _mintFeeFlat;
878         burnFeeNumerator = _burnFeeNumerator;
879         burnFeeDenominator = _burnFeeDenominator;
880         burnFeeFlat = _burnFeeFlat;
881     }
882 
883     function changeInsurer(address newInsurer) public onlyOwner {
884         require(newInsurer != address(0));
885         insurer = newInsurer;
886     }
887 
888     // Can undelegate by passing in newContract = address(0)
889     function delegateToNewContract(address newContract) public onlyOwner {
890         delegate = DelegateERC20(newContract);
891         DelegatedTo(newContract);
892     }
893 }