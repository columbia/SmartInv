1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract Pausable is Ownable {
81   event Pause();
82   event Unpause();
83 
84   bool public paused = false;
85 
86 
87   /**
88    * @dev Modifier to make a function callable only when the contract is not paused.
89    */
90   modifier whenNotPaused() {
91     require(!paused);
92     _;
93   }
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is paused.
97    */
98   modifier whenPaused() {
99     require(paused);
100     _;
101   }
102 
103   /**
104    * @dev called by the owner to pause, triggers stopped state
105    */
106   function pause() onlyOwner whenNotPaused public {
107     paused = true;
108     Pause();
109   }
110 
111   /**
112    * @dev called by the owner to unpause, returns to normal state
113    */
114   function unpause() onlyOwner whenPaused public {
115     paused = false;
116     Unpause();
117   }
118 }
119 
120 contract CanReclaimToken is Ownable {
121   using SafeERC20 for ERC20Basic;
122 
123   /**
124    * @dev Reclaim all ERC20Basic compatible tokens
125    * @param token ERC20Basic The address of the token contract
126    */
127   function reclaimToken(ERC20Basic token) external onlyOwner {
128     uint256 balance = token.balanceOf(this);
129     token.safeTransfer(owner, balance);
130   }
131 
132 }
133 
134 contract Claimable is Ownable {
135   address public pendingOwner;
136 
137   /**
138    * @dev Modifier throws if called by any account other than the pendingOwner.
139    */
140   modifier onlyPendingOwner() {
141     require(msg.sender == pendingOwner);
142     _;
143   }
144 
145   /**
146    * @dev Allows the current owner to set the pendingOwner address.
147    * @param newOwner The address to transfer ownership to.
148    */
149   function transferOwnership(address newOwner) onlyOwner public {
150     pendingOwner = newOwner;
151   }
152 
153   /**
154    * @dev Allows the pendingOwner address to finalize the transfer.
155    */
156   function claimOwnership() onlyPendingOwner public {
157     OwnershipTransferred(owner, pendingOwner);
158     owner = pendingOwner;
159     pendingOwner = address(0);
160   }
161 }
162 
163 contract AddressList is Claimable {
164     string public name;
165     mapping (address => bool) public onList;
166 
167     function AddressList(string _name, bool nullValue) public {
168         name = _name;
169         onList[0x0] = nullValue;
170     }
171     event ChangeWhiteList(address indexed to, bool onList);
172 
173     // Set whether _to is on the list or not. Whether 0x0 is on the list
174     // or not cannot be set here - it is set once and for all by the constructor.
175     function changeList(address _to, bool _onList) onlyOwner public {
176         require(_to != 0x0);
177         if (onList[_to] != _onList) {
178             onList[_to] = _onList;
179             ChangeWhiteList(_to, _onList);
180         }
181     }
182 }
183 
184 contract HasNoContracts is Ownable {
185 
186   /**
187    * @dev Reclaim ownership of Ownable contracts
188    * @param contractAddr The address of the Ownable to be reclaimed.
189    */
190   function reclaimContract(address contractAddr) external onlyOwner {
191     Ownable contractInst = Ownable(contractAddr);
192     contractInst.transferOwnership(owner);
193   }
194 }
195 
196 contract HasNoEther is Ownable {
197 
198   /**
199   * @dev Constructor that rejects incoming Ether
200   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
201   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
202   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
203   * we could use assembly to access msg.value.
204   */
205   function HasNoEther() public payable {
206     require(msg.value == 0);
207   }
208 
209   /**
210    * @dev Disallows direct send by settings a default function without the `payable` flag.
211    */
212   function() external {
213   }
214 
215   /**
216    * @dev Transfer all Ether held by the contract to the owner.
217    */
218   function reclaimEther() external onlyOwner {
219     assert(owner.send(this.balance));
220   }
221 }
222 
223 contract HasNoTokens is CanReclaimToken {
224 
225  /**
226   * @dev Reject all ERC223 compatible tokens
227   * @param from_ address The address that is transferring the tokens
228   * @param value_ uint256 the amount of the specified token
229   * @param data_ Bytes The data passed from the caller.
230   */
231   function tokenFallback(address from_, uint256 value_, bytes data_) external {
232     from_;
233     value_;
234     data_;
235     revert();
236   }
237 
238 }
239 
240 contract TimeLockedController is HasNoEther, HasNoTokens, Claimable {
241     using SafeMath for uint256;
242 
243     // 24 hours, assuming a 15 second blocktime.
244     // As long as this isn't too far off from reality it doesn't really matter.
245     uint public constant blocksDelay = 24*60*60/15;
246 
247     struct MintOperation {
248         address to;
249         uint256 amount;
250         address admin;
251         uint deferBlock;
252     }
253 
254     struct TransferOwnershipOperation {
255         address newOwner;
256         address admin;
257         uint deferBlock;
258     }
259 
260     struct ChangeBurnBoundsOperation {
261         uint newMin;
262         uint newMax;
263         address admin;
264         uint deferBlock;
265     }
266 
267     struct ChangeInsuranceFeesOperation {
268         uint80 _transferFeeNumerator;
269         uint80 _transferFeeDenominator;
270         uint80 _mintFeeNumerator;
271         uint80 _mintFeeDenominator;
272         uint256 _mintFeeFlat;
273         uint80 _burnFeeNumerator;
274         uint80 _burnFeeDenominator;
275         uint256 _burnFeeFlat;
276         address admin;
277         uint deferBlock;
278     }
279 
280     struct ChangeInsurerOperation {
281         address newInsurer;
282         address admin;
283         uint deferBlock;
284     }
285 
286     address public admin;
287     TrueUSD public child;
288     AddressList public canBurnWhiteList;
289     AddressList public canReceiveMintWhitelist;
290     AddressList public blackList;
291     MintOperation[] public mintOperations;
292     TransferOwnershipOperation public transferOwnershipOperation;
293     ChangeBurnBoundsOperation public changeBurnBoundsOperation;
294     ChangeInsuranceFeesOperation public changeInsuranceFeesOperation;
295     ChangeInsurerOperation public changeInsurerOperation;
296 
297     modifier onlyAdminOrOwner() {
298         require(msg.sender == admin || msg.sender == owner);
299         _;
300     }
301 
302     function computeDeferBlock() private view returns (uint) {
303         if (msg.sender == owner) {
304             return block.number;
305         } else {
306             return block.number.add(blocksDelay);
307         }
308     }
309 
310     // starts with no admin
311     function TimeLockedController(address _child, address _canBurnWhiteList, address _canReceiveMintWhitelist, address _blackList) public {
312         child = TrueUSD(_child);
313         canBurnWhiteList = AddressList(_canBurnWhiteList);
314         canReceiveMintWhitelist = AddressList(_canReceiveMintWhitelist);
315         blackList = AddressList(_blackList);
316     }
317 
318     event MintOperationEvent(address indexed _to, uint256 amount, uint deferBlock, uint opIndex);
319     event TransferOwnershipOperationEvent(address newOwner, uint deferBlock);
320     event ChangeBurnBoundsOperationEvent(uint newMin, uint newMax, uint deferBlock);
321     event ChangeInsuranceFeesOperationEvent(uint80 _transferFeeNumerator,
322                                             uint80 _transferFeeDenominator,
323                                             uint80 _mintFeeNumerator,
324                                             uint80 _mintFeeDenominator,
325                                             uint256 _mintFeeFlat,
326                                             uint80 _burnFeeNumerator,
327                                             uint80 _burnFeeDenominator,
328                                             uint256 _burnFeeFlat,
329                                             uint deferBlock);
330     event ChangeInsurerOperationEvent(address newInsurer, uint deferBlock);
331     event AdminshipTransferred(address indexed previousAdmin, address indexed newAdmin);
332 
333     // admin initiates a request to mint _amount TrueUSD for account _to
334     function requestMint(address _to, uint256 _amount) public onlyAdminOrOwner {
335         uint deferBlock = computeDeferBlock();
336         MintOperation memory op = MintOperation(_to, _amount, admin, deferBlock);
337         MintOperationEvent(_to, _amount, deferBlock, mintOperations.length);
338         mintOperations.push(op);
339     }
340 
341     // admin initiates a request to transfer ownership of the TrueUSD contract and all AddressLists to newOwner.
342     // Can be used e.g. to upgrade this TimeLockedController contract.
343     function requestTransferChildrenOwnership(address newOwner) public onlyAdminOrOwner {
344         uint deferBlock = computeDeferBlock();
345         transferOwnershipOperation = TransferOwnershipOperation(newOwner, admin, deferBlock);
346         TransferOwnershipOperationEvent(newOwner, deferBlock);
347     }
348 
349     // admin initiates a request that the minimum and maximum amounts that any TrueUSD user can
350     // burn become newMin and newMax
351     function requestChangeBurnBounds(uint newMin, uint newMax) public onlyAdminOrOwner {
352         uint deferBlock = computeDeferBlock();
353         changeBurnBoundsOperation = ChangeBurnBoundsOperation(newMin, newMax, admin, deferBlock);
354         ChangeBurnBoundsOperationEvent(newMin, newMax, deferBlock);
355     }
356 
357     // admin initiates a request that the insurance fee be changed
358     function requestChangeInsuranceFees(uint80 _transferFeeNumerator,
359                                         uint80 _transferFeeDenominator,
360                                         uint80 _mintFeeNumerator,
361                                         uint80 _mintFeeDenominator,
362                                         uint256 _mintFeeFlat,
363                                         uint80 _burnFeeNumerator,
364                                         uint80 _burnFeeDenominator,
365                                         uint256 _burnFeeFlat) public onlyAdminOrOwner {
366         uint deferBlock = computeDeferBlock();
367         changeInsuranceFeesOperation = ChangeInsuranceFeesOperation(_transferFeeNumerator,
368                                                                     _transferFeeDenominator,
369                                                                     _mintFeeNumerator,
370                                                                     _mintFeeDenominator,
371                                                                     _mintFeeFlat,
372                                                                     _burnFeeNumerator,
373                                                                     _burnFeeDenominator,
374                                                                     _burnFeeFlat,
375                                                                     admin,
376                                                                     deferBlock);
377         ChangeInsuranceFeesOperationEvent(_transferFeeNumerator,
378                                           _transferFeeDenominator,
379                                           _mintFeeNumerator,
380                                           _mintFeeDenominator,
381                                           _mintFeeFlat,
382                                           _burnFeeNumerator,
383                                           _burnFeeDenominator,
384                                           _burnFeeFlat,
385                                           deferBlock);
386     }
387 
388     // admin initiates a request that the recipient of the insurance fee be changed to newInsurer
389     function requestChangeInsurer(address newInsurer) public onlyAdminOrOwner {
390         uint deferBlock = computeDeferBlock();
391         changeInsurerOperation = ChangeInsurerOperation(newInsurer, admin, deferBlock);
392         ChangeInsurerOperationEvent(newInsurer, deferBlock);
393     }
394 
395     // after a day, beneficiary of a mint request finalizes it by providing the
396     // index of the request (visible in the MintOperationEvent accompanying the original request)
397     function finalizeMint(uint index) public onlyAdminOrOwner {
398         MintOperation memory op = mintOperations[index];
399         require(op.admin == admin); //checks that the requester's adminship has not been revoked
400         require(op.deferBlock <= block.number); //checks that enough time has elapsed
401         address to = op.to;
402         uint256 amount = op.amount;
403         delete mintOperations[index];
404         child.mint(to, amount);
405     }
406 
407     // after a day, admin finalizes the ownership change
408     function finalizeTransferChildrenOwnership() public onlyAdminOrOwner {
409         require(transferOwnershipOperation.admin == admin);
410         require(transferOwnershipOperation.deferBlock <= block.number);
411         address newOwner = transferOwnershipOperation.newOwner;
412         delete transferOwnershipOperation;
413         child.transferOwnership(newOwner);
414         canBurnWhiteList.transferOwnership(newOwner);
415         canReceiveMintWhitelist.transferOwnership(newOwner);
416         blackList.transferOwnership(newOwner);
417     }
418 
419     // after a day, admin finalizes the burn bounds change
420     function finalizeChangeBurnBounds() public onlyAdminOrOwner {
421         require(changeBurnBoundsOperation.admin == admin);
422         require(changeBurnBoundsOperation.deferBlock <= block.number);
423         uint newMin = changeBurnBoundsOperation.newMin;
424         uint newMax = changeBurnBoundsOperation.newMax;
425         delete changeBurnBoundsOperation;
426         child.changeBurnBounds(newMin, newMax);
427     }
428 
429     // after a day, admin finalizes the insurance fee change
430     function finalizeChangeInsuranceFees() public onlyAdminOrOwner {
431         require(changeInsuranceFeesOperation.admin == admin);
432         require(changeInsuranceFeesOperation.deferBlock <= block.number);
433         uint80 _transferFeeNumerator = changeInsuranceFeesOperation._transferFeeNumerator;
434         uint80 _transferFeeDenominator = changeInsuranceFeesOperation._transferFeeDenominator;
435         uint80 _mintFeeNumerator = changeInsuranceFeesOperation._mintFeeNumerator;
436         uint80 _mintFeeDenominator = changeInsuranceFeesOperation._mintFeeDenominator;
437         uint256 _mintFeeFlat = changeInsuranceFeesOperation._mintFeeFlat;
438         uint80 _burnFeeNumerator = changeInsuranceFeesOperation._burnFeeNumerator;
439         uint80 _burnFeeDenominator = changeInsuranceFeesOperation._burnFeeDenominator;
440         uint256 _burnFeeFlat = changeInsuranceFeesOperation._burnFeeFlat;
441         delete changeInsuranceFeesOperation;
442         child.changeInsuranceFees(_transferFeeNumerator,
443                                   _transferFeeDenominator,
444                                   _mintFeeNumerator,
445                                   _mintFeeDenominator,
446                                   _mintFeeFlat,
447                                   _burnFeeNumerator,
448                                   _burnFeeDenominator,
449                                   _burnFeeFlat);
450     }
451 
452     // after a day, admin finalizes the insurance fees recipient change
453     function finalizeChangeInsurer() public onlyAdminOrOwner {
454         require(changeInsurerOperation.admin == admin);
455         require(changeInsurerOperation.deferBlock <= block.number);
456         address newInsurer = changeInsurerOperation.newInsurer;
457         delete changeInsurerOperation;
458         child.changeInsurer(newInsurer);
459     }
460 
461     // Owner of this contract (immediately) replaces the current admin with newAdmin
462     function transferAdminship(address newAdmin) public onlyOwner {
463         AdminshipTransferred(admin, newAdmin);
464         admin = newAdmin;
465     }
466 
467     // admin (immediately) updates a whitelist/blacklist
468     function updateList(address list, address entry, bool flag) public onlyAdminOrOwner {
469         AddressList(list).changeList(entry, flag);
470     }
471 
472     function issueClaimOwnership(address _other) public onlyAdminOrOwner {
473         Claimable other = Claimable(_other);
474         other.claimOwnership();
475     }
476 }
477 
478 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
479 }
480 
481 contract ERC20Basic {
482   function totalSupply() public view returns (uint256);
483   function balanceOf(address who) public view returns (uint256);
484   function transfer(address to, uint256 value) public returns (bool);
485   event Transfer(address indexed from, address indexed to, uint256 value);
486 }
487 
488 contract BasicToken is ERC20Basic {
489   using SafeMath for uint256;
490 
491   mapping(address => uint256) balances;
492 
493   uint256 totalSupply_;
494 
495   /**
496   * @dev total number of tokens in existence
497   */
498   function totalSupply() public view returns (uint256) {
499     return totalSupply_;
500   }
501 
502   /**
503   * @dev transfer token for a specified address
504   * @param _to The address to transfer to.
505   * @param _value The amount to be transferred.
506   */
507   function transfer(address _to, uint256 _value) public returns (bool) {
508     require(_to != address(0));
509     require(_value <= balances[msg.sender]);
510 
511     // SafeMath.sub will throw if there is not enough balance.
512     balances[msg.sender] = balances[msg.sender].sub(_value);
513     balances[_to] = balances[_to].add(_value);
514     Transfer(msg.sender, _to, _value);
515     return true;
516   }
517 
518   /**
519   * @dev Gets the balance of the specified address.
520   * @param _owner The address to query the the balance of.
521   * @return An uint256 representing the amount owned by the passed address.
522   */
523   function balanceOf(address _owner) public view returns (uint256 balance) {
524     return balances[_owner];
525   }
526 
527 }
528 
529 contract BurnableToken is BasicToken {
530 
531   event Burn(address indexed burner, uint256 value);
532 
533   /**
534    * @dev Burns a specific amount of tokens.
535    * @param _value The amount of token to be burned.
536    */
537   function burn(uint256 _value) public {
538     require(_value <= balances[msg.sender]);
539     // no need to require value <= totalSupply, since that would imply the
540     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
541 
542     address burner = msg.sender;
543     balances[burner] = balances[burner].sub(_value);
544     totalSupply_ = totalSupply_.sub(_value);
545     Burn(burner, _value);
546   }
547 }
548 
549 contract ERC20 is ERC20Basic {
550   function allowance(address owner, address spender) public view returns (uint256);
551   function transferFrom(address from, address to, uint256 value) public returns (bool);
552   function approve(address spender, uint256 value) public returns (bool);
553   event Approval(address indexed owner, address indexed spender, uint256 value);
554 }
555 
556 library SafeERC20 {
557   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
558     assert(token.transfer(to, value));
559   }
560 
561   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
562     assert(token.transferFrom(from, to, value));
563   }
564 
565   function safeApprove(ERC20 token, address spender, uint256 value) internal {
566     assert(token.approve(spender, value));
567   }
568 }
569 
570 contract StandardToken is ERC20, BasicToken {
571 
572   mapping (address => mapping (address => uint256)) internal allowed;
573 
574 
575   /**
576    * @dev Transfer tokens from one address to another
577    * @param _from address The address which you want to send tokens from
578    * @param _to address The address which you want to transfer to
579    * @param _value uint256 the amount of tokens to be transferred
580    */
581   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
582     require(_to != address(0));
583     require(_value <= balances[_from]);
584     require(_value <= allowed[_from][msg.sender]);
585 
586     balances[_from] = balances[_from].sub(_value);
587     balances[_to] = balances[_to].add(_value);
588     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
589     Transfer(_from, _to, _value);
590     return true;
591   }
592 
593   /**
594    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
595    *
596    * Beware that changing an allowance with this method brings the risk that someone may use both the old
597    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
598    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
599    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
600    * @param _spender The address which will spend the funds.
601    * @param _value The amount of tokens to be spent.
602    */
603   function approve(address _spender, uint256 _value) public returns (bool) {
604     allowed[msg.sender][_spender] = _value;
605     Approval(msg.sender, _spender, _value);
606     return true;
607   }
608 
609   /**
610    * @dev Function to check the amount of tokens that an owner allowed to a spender.
611    * @param _owner address The address which owns the funds.
612    * @param _spender address The address which will spend the funds.
613    * @return A uint256 specifying the amount of tokens still available for the spender.
614    */
615   function allowance(address _owner, address _spender) public view returns (uint256) {
616     return allowed[_owner][_spender];
617   }
618 
619   /**
620    * @dev Increase the amount of tokens that an owner allowed to a spender.
621    *
622    * approve should be called when allowed[_spender] == 0. To increment
623    * allowed value is better to use this function to avoid 2 calls (and wait until
624    * the first transaction is mined)
625    * From MonolithDAO Token.sol
626    * @param _spender The address which will spend the funds.
627    * @param _addedValue The amount of tokens to increase the allowance by.
628    */
629   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
630     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
631     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
632     return true;
633   }
634 
635   /**
636    * @dev Decrease the amount of tokens that an owner allowed to a spender.
637    *
638    * approve should be called when allowed[_spender] == 0. To decrement
639    * allowed value is better to use this function to avoid 2 calls (and wait until
640    * the first transaction is mined)
641    * From MonolithDAO Token.sol
642    * @param _spender The address which will spend the funds.
643    * @param _subtractedValue The amount of tokens to decrease the allowance by.
644    */
645   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
646     uint oldValue = allowed[msg.sender][_spender];
647     if (_subtractedValue > oldValue) {
648       allowed[msg.sender][_spender] = 0;
649     } else {
650       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
651     }
652     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
653     return true;
654   }
655 
656 }
657 
658 contract PausableToken is StandardToken, Pausable {
659 
660   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
661     return super.transfer(_to, _value);
662   }
663 
664   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
665     return super.transferFrom(_from, _to, _value);
666   }
667 
668   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
669     return super.approve(_spender, _value);
670   }
671 
672   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
673     return super.increaseApproval(_spender, _addedValue);
674   }
675 
676   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
677     return super.decreaseApproval(_spender, _subtractedValue);
678   }
679 }
680 
681 contract TrueUSD is PausableToken, BurnableToken, NoOwner, Claimable {
682     string public constant name = "TrueUSD";
683     string public constant symbol = "TUSD";
684     uint8 public constant decimals = 18;
685 
686     AddressList public canReceiveMintWhitelist;
687     AddressList public canBurnWhiteList;
688     AddressList public blackList;
689     uint256 public burnMin = 10000 * 10**uint256(decimals);
690     uint256 public burnMax = 20000000 * 10**uint256(decimals);
691 
692     uint80 public transferFeeNumerator = 7;
693     uint80 public transferFeeDenominator = 10000;
694     uint80 public mintFeeNumerator = 0;
695     uint80 public mintFeeDenominator = 10000;
696     uint256 public mintFeeFlat = 0;
697     uint80 public burnFeeNumerator = 0;
698     uint80 public burnFeeDenominator = 10000;
699     uint256 public burnFeeFlat = 0;
700     address public insurer;
701 
702     event ChangeBurnBoundsEvent(uint256 newMin, uint256 newMax);
703     event Mint(address indexed to, uint256 amount);
704 
705     function TrueUSD(address _canMintWhiteList, address _canBurnWhiteList, address _blackList) public {
706         totalSupply_ = 0;
707         canReceiveMintWhitelist = AddressList(_canMintWhiteList);
708         canBurnWhiteList = AddressList(_canBurnWhiteList);
709         blackList = AddressList(_blackList);
710         insurer = msg.sender;
711     }
712 
713     //Burning functions as withdrawing money from the system. The platform will keep track of who burns coins,
714     //and will send them back the equivalent amount of money (rounded down to the nearest cent).
715     function burn(uint256 _value) public {
716         require(canBurnWhiteList.onList(msg.sender));
717         require(_value >= burnMin);
718         require(_value <= burnMax);
719         uint256 fee = payInsuranceFee(msg.sender, _value, burnFeeNumerator, burnFeeDenominator, burnFeeFlat);
720         uint256 remaining = _value.sub(fee);
721         super.burn(remaining);
722     }
723 
724     //Create _amount new tokens and transfer them to _to.
725     //Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/MintableToken.sol
726     function mint(address _to, uint256 _amount) onlyOwner public {
727         require(canReceiveMintWhitelist.onList(_to));
728         totalSupply_ = totalSupply_.add(_amount);
729         balances[_to] = balances[_to].add(_amount);
730         Mint(_to, _amount);
731         Transfer(address(0), _to, _amount);
732         payInsuranceFee(_to, _amount, mintFeeNumerator, mintFeeDenominator, mintFeeFlat);
733     }
734 
735     //Change the minimum and maximum amount that can be burned at once. Burning
736     //may be disabled by setting both to 0 (this will not be done under normal
737     //operation, but we can't add checks to disallow it without losing a lot of
738     //flexibility since burning could also be as good as disabled
739     //by setting the minimum extremely high, and we don't want to lock
740     //in any particular cap for the minimum)
741     function changeBurnBounds(uint newMin, uint newMax) onlyOwner public {
742         require(newMin <= newMax);
743         burnMin = newMin;
744         burnMax = newMax;
745         ChangeBurnBoundsEvent(newMin, newMax);
746     }
747 
748     function transfer(address to, uint256 value) public returns (bool) {
749         require(!blackList.onList(msg.sender));
750         require(!blackList.onList(to));
751         bool result = super.transfer(to, value);
752         payInsuranceFee(to, value, transferFeeNumerator, transferFeeDenominator, 0);
753         return result;
754     }
755 
756     function transferFrom(address from, address to, uint256 value) public returns (bool) {
757         require(!blackList.onList(from));
758         require(!blackList.onList(to));
759         bool result = super.transferFrom(from, to, value);
760         payInsuranceFee(to, value, transferFeeNumerator, transferFeeDenominator, 0);
761         return result;
762     }
763 
764     function payInsuranceFee(address payer, uint256 value, uint80 numerator, uint80 denominator, uint256 flatRate) private returns (uint256) {
765         uint256 insuranceFee = value.mul(numerator).div(denominator).add(flatRate);
766         if (insuranceFee > 0) {
767             transferFromWithoutAllowance(payer, insurer, insuranceFee);
768         }
769         return insuranceFee;
770     }
771 
772     // based on 'transfer' in https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
773     function transferFromWithoutAllowance(address from, address _to, uint256 _value) private {
774         assert(_to != address(0));
775         assert(_value <= balances[from]);
776         balances[from] = balances[from].sub(_value);
777         balances[_to] = balances[_to].add(_value);
778         Transfer(from, _to, _value);
779     }
780 
781     function changeInsuranceFees(uint80 _transferFeeNumerator,
782                                  uint80 _transferFeeDenominator,
783                                  uint80 _mintFeeNumerator,
784                                  uint80 _mintFeeDenominator,
785                                  uint256 _mintFeeFlat,
786                                  uint80 _burnFeeNumerator,
787                                  uint80 _burnFeeDenominator,
788                                  uint256 _burnFeeFlat) public onlyOwner {
789         require(_transferFeeDenominator != 0);
790         require(_mintFeeDenominator != 0);
791         require(_burnFeeDenominator != 0);
792         transferFeeNumerator = _transferFeeNumerator;
793         transferFeeDenominator = _transferFeeDenominator;
794         mintFeeNumerator = _mintFeeNumerator;
795         mintFeeDenominator = _mintFeeDenominator;
796         mintFeeFlat = _mintFeeFlat;
797         burnFeeNumerator = _burnFeeNumerator;
798         burnFeeDenominator = _burnFeeDenominator;
799         burnFeeFlat = _burnFeeFlat;
800     }
801 
802     function changeInsurer(address newInsurer) public onlyOwner {
803         require(newInsurer != address(0));
804         insurer = newInsurer;
805     }
806 }