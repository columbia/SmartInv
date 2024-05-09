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
195 contract NamableAddressList is AddressList {
196     function NamableAddressList(string _name, bool nullValue)
197         AddressList(_name, nullValue) public {}
198 
199     function changeName(string _name) onlyOwner public {
200         name = _name;
201     }
202 }
203 
204 contract HasNoContracts is Ownable {
205 
206   /**
207    * @dev Reclaim ownership of Ownable contracts
208    * @param contractAddr The address of the Ownable to be reclaimed.
209    */
210   function reclaimContract(address contractAddr) external onlyOwner {
211     Ownable contractInst = Ownable(contractAddr);
212     contractInst.transferOwnership(owner);
213   }
214 }
215 
216 contract HasNoEther is Ownable {
217 
218   /**
219   * @dev Constructor that rejects incoming Ether
220   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
221   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
222   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
223   * we could use assembly to access msg.value.
224   */
225   function HasNoEther() public payable {
226     require(msg.value == 0);
227   }
228 
229   /**
230    * @dev Disallows direct send by settings a default function without the `payable` flag.
231    */
232   function() external {
233   }
234 
235   /**
236    * @dev Transfer all Ether held by the contract to the owner.
237    */
238   function reclaimEther() external onlyOwner {
239     assert(owner.send(this.balance));
240   }
241 }
242 
243 contract HasNoTokens is CanReclaimToken {
244 
245  /**
246   * @dev Reject all ERC223 compatible tokens
247   * @param from_ address The address that is transferring the tokens
248   * @param value_ uint256 the amount of the specified token
249   * @param data_ Bytes The data passed from the caller.
250   */
251   function tokenFallback(address from_, uint256 value_, bytes data_) external {
252     from_;
253     value_;
254     data_;
255     revert();
256   }
257 
258 }
259 
260 contract TimeLockedController is HasNoEther, HasNoTokens, Claimable {
261     using SafeMath for uint256;
262 
263     // 6 hours, assuming a 15 second blocktime.
264     // As long as this isn't too far off from reality it doesn't really matter.
265     uint public constant blocksDelay = 6*60*60/15;
266 
267     struct MintOperation {
268         address to;
269         uint256 amount;
270         address admin;
271         uint deferBlock;
272     }
273 
274     address public admin;
275     TrueUSD public trueUSD;
276     MintOperation[] public mintOperations;
277 
278     modifier onlyAdminOrOwner() {
279         require(msg.sender == admin || msg.sender == owner);
280         _;
281     }
282 
283     event MintOperationEvent(address indexed _to, uint256 amount, uint deferBlock, uint opIndex);
284     event TransferChildEvent(address indexed _child, address indexed _newOwner);
285     event ReclaimEvent(address indexed other);
286     event ChangeBurnBoundsEvent(uint newMin, uint newMax);
287     event ChangeStakingFeesEvent(uint80 _transferFeeNumerator,
288                                             uint80 _transferFeeDenominator,
289                                             uint80 _mintFeeNumerator,
290                                             uint80 _mintFeeDenominator,
291                                             uint256 _mintFeeFlat,
292                                             uint80 _burnFeeNumerator,
293                                             uint80 _burnFeeDenominator,
294                                             uint256 _burnFeeFlat);
295     event ChangeStakerEvent(address newStaker);
296     event DelegateEvent(DelegateERC20 delegate);
297     event SetDelegatedFromEvent(address source);
298     event ChangeTrueUSDEvent(TrueUSD newContract);
299     event ChangeNameEvent(string name, string symbol);
300     event AdminshipTransferred(address indexed previousAdmin, address indexed newAdmin);
301 
302     // admin initiates a request to mint _amount TrueUSD for account _to
303     function requestMint(address _to, uint256 _amount) public onlyAdminOrOwner {
304         uint deferBlock = block.number;
305         if (msg.sender != owner) {
306             deferBlock = deferBlock.add(blocksDelay);
307         }
308         MintOperation memory op = MintOperation(_to, _amount, admin, deferBlock);
309         MintOperationEvent(_to, _amount, deferBlock, mintOperations.length);
310         mintOperations.push(op);
311     }
312 
313     // after a day, admin finalizes mint request by providing the
314     // index of the request (visible in the MintOperationEvent accompanying the original request)
315     function finalizeMint(uint index) public onlyAdminOrOwner {
316         MintOperation memory op = mintOperations[index];
317         require(op.admin == admin); //checks that the requester's adminship has not been revoked
318         require(op.deferBlock <= block.number); //checks that enough time has elapsed
319         address to = op.to;
320         uint256 amount = op.amount;
321         delete mintOperations[index];
322         trueUSD.mint(to, amount);
323     }
324 
325     // Transfer ownership of _child to _newOwner
326     // Can be used e.g. to upgrade this TimeLockedController contract.
327     function transferChild(Ownable _child, address _newOwner) public onlyOwner {
328         TransferChildEvent(_child, _newOwner);
329         _child.transferOwnership(_newOwner);
330     }
331 
332     // Transfer ownership of a contract from trueUSD
333     // to this TimeLockedController. Can be used e.g. to reclaim balance sheet
334     // in order to transfer it to an upgraded TrueUSD contract.
335     function requestReclaim(Ownable other) public onlyOwner {
336         ReclaimEvent(other);
337         trueUSD.reclaimContract(other);
338     }
339 
340     // Change the minimum and maximum amounts that TrueUSD users can
341     // burn to newMin and newMax
342     function changeBurnBounds(uint newMin, uint newMax) public onlyOwner {
343         ChangeBurnBoundsEvent(newMin, newMax);
344         trueUSD.changeBurnBounds(newMin, newMax);
345     }
346 
347     // Change the transaction fees charged on transfer/mint/burn
348     function changeStakingFees(uint80 _transferFeeNumerator,
349                                uint80 _transferFeeDenominator,
350                                uint80 _mintFeeNumerator,
351                                uint80 _mintFeeDenominator,
352                                uint256 _mintFeeFlat,
353                                uint80 _burnFeeNumerator,
354                                uint80 _burnFeeDenominator,
355                                uint256 _burnFeeFlat) public onlyOwner {
356         ChangeStakingFeesEvent(_transferFeeNumerator,
357                                           _transferFeeDenominator,
358                                           _mintFeeNumerator,
359                                           _mintFeeDenominator,
360                                           _mintFeeFlat,
361                                           _burnFeeNumerator,
362                                           _burnFeeDenominator,
363                                           _burnFeeFlat);
364         trueUSD.changeStakingFees(_transferFeeNumerator,
365                                   _transferFeeDenominator,
366                                   _mintFeeNumerator,
367                                   _mintFeeDenominator,
368                                   _mintFeeFlat,
369                                   _burnFeeNumerator,
370                                   _burnFeeDenominator,
371                                   _burnFeeFlat);
372     }
373 
374     // Change the recipient of staking fees to newStaker
375     function changeStaker(address newStaker) public onlyOwner {
376         ChangeStakerEvent(newStaker);
377         trueUSD.changeStaker(newStaker);
378     }
379 
380     // Future ERC20 calls to trueUSD be delegated to _delegate
381     function delegateToNewContract(DelegateERC20 delegate) public onlyOwner {
382         DelegateEvent(delegate);
383         trueUSD.delegateToNewContract(delegate);
384     }
385 
386     // Incoming delegate* calls from _source will be accepted by trueUSD
387     function setDelegatedFrom(address _source) public onlyOwner {
388         SetDelegatedFromEvent(_source);
389         trueUSD.setDelegatedFrom(_source);
390     }
391 
392     // Update this contract's trueUSD pointer to newContract (e.g. if the
393     // contract is upgraded)
394     function setTrueUSD(TrueUSD newContract) public onlyOwner {
395         ChangeTrueUSDEvent(newContract);
396         trueUSD = newContract;
397     }
398 
399     // change trueUSD's name and symbol
400     function changeName(string name, string symbol) public onlyOwner {
401         ChangeNameEvent(name, symbol);
402         trueUSD.changeName(name, symbol);
403     }
404 
405     // Replace the current admin with newAdmin
406     function transferAdminship(address newAdmin) public onlyOwner {
407         AdminshipTransferred(admin, newAdmin);
408         admin = newAdmin;
409     }
410 
411     // Swap out TrueUSD's address lists
412     function setLists(AddressList _canReceiveMintWhiteList, AddressList _canBurnWhiteList, AddressList _blackList, AddressList _noFeesList) onlyOwner public {
413         trueUSD.setLists(_canReceiveMintWhiteList, _canBurnWhiteList, _blackList, _noFeesList);
414     }
415 
416     // Update a whitelist/blacklist
417     function updateList(address list, address entry, bool flag) public onlyAdminOrOwner {
418         AddressList(list).changeList(entry, flag);
419     }
420 
421     // Rename a whitelist/blacklist
422     function renameList(address list, string name) public onlyAdminOrOwner {
423         NamableAddressList(list).changeName(name);
424     }
425 
426     // Claim ownership of an arbitrary Claimable contract
427     function issueClaimOwnership(address _other) public onlyAdminOrOwner {
428         Claimable other = Claimable(_other);
429         other.claimOwnership();
430     }
431 }
432 
433 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
434 }
435 
436 contract AllowanceSheet is Claimable {
437     using SafeMath for uint256;
438 
439     mapping (address => mapping (address => uint256)) public allowanceOf;
440 
441     function addAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
442         allowanceOf[tokenHolder][spender] = allowanceOf[tokenHolder][spender].add(value);
443     }
444 
445     function subAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
446         allowanceOf[tokenHolder][spender] = allowanceOf[tokenHolder][spender].sub(value);
447     }
448 
449     function setAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
450         allowanceOf[tokenHolder][spender] = value;
451     }
452 }
453 
454 contract BalanceSheet is Claimable {
455     using SafeMath for uint256;
456 
457     mapping (address => uint256) public balanceOf;
458 
459     function addBalance(address addr, uint256 value) public onlyOwner {
460         balanceOf[addr] = balanceOf[addr].add(value);
461     }
462 
463     function subBalance(address addr, uint256 value) public onlyOwner {
464         balanceOf[addr] = balanceOf[addr].sub(value);
465     }
466 
467     function setBalance(address addr, uint256 value) public onlyOwner {
468         balanceOf[addr] = value;
469     }
470 }
471 
472 contract ERC20Basic {
473   function totalSupply() public view returns (uint256);
474   function balanceOf(address who) public view returns (uint256);
475   function transfer(address to, uint256 value) public returns (bool);
476   event Transfer(address indexed from, address indexed to, uint256 value);
477 }
478 
479 contract BasicToken is ERC20Basic, Claimable {
480   using SafeMath for uint256;
481 
482   BalanceSheet public balances;
483 
484   uint256 totalSupply_;
485 
486   function setBalanceSheet(address sheet) external onlyOwner {
487     balances = BalanceSheet(sheet);
488     balances.claimOwnership();
489   }
490 
491   /**
492   * @dev total number of tokens in existence
493   */
494   function totalSupply() public view returns (uint256) {
495     return totalSupply_;
496   }
497 
498   /**
499   * @dev transfer token for a specified address
500   * @param _to The address to transfer to.
501   * @param _value The amount to be transferred.
502   */
503   function transfer(address _to, uint256 _value) public returns (bool) {
504     transferAllArgsNoAllowance(msg.sender, _to, _value);
505     return true;
506   }
507 
508   function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal {
509     require(_to != address(0));
510     require(_from != address(0));
511     require(_value <= balances.balanceOf(_from));
512 
513     // SafeMath.sub will throw if there is not enough balance.
514     balances.subBalance(_from, _value);
515     balances.addBalance(_to, _value);
516     Transfer(_from, _to, _value);
517   }
518 
519   /**
520   * @dev Gets the balance of the specified address.
521   * @param _owner The address to query the the balance of.
522   * @return An uint256 representing the amount owned by the passed address.
523   */
524   function balanceOf(address _owner) public view returns (uint256 balance) {
525     return balances.balanceOf(_owner);
526   }
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
538     require(_value <= balances.balanceOf(msg.sender));
539     // no need to require value <= totalSupply, since that would imply the
540     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
541 
542     address burner = msg.sender;
543     balances.subBalance(burner, _value);
544     totalSupply_ = totalSupply_.sub(_value);
545     Burn(burner, _value);
546     Transfer(burner, address(0), _value);
547   }
548 }
549 
550 contract ERC20 is ERC20Basic {
551   function allowance(address owner, address spender) public view returns (uint256);
552   function transferFrom(address from, address to, uint256 value) public returns (bool);
553   function approve(address spender, uint256 value) public returns (bool);
554   event Approval(address indexed owner, address indexed spender, uint256 value);
555 }
556 
557 library SafeERC20 {
558   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
559     assert(token.transfer(to, value));
560   }
561 
562   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
563     assert(token.transferFrom(from, to, value));
564   }
565 
566   function safeApprove(ERC20 token, address spender, uint256 value) internal {
567     assert(token.approve(spender, value));
568   }
569 }
570 
571 contract StandardToken is ERC20, BasicToken {
572 
573   AllowanceSheet public allowances;
574 
575   function setAllowanceSheet(address sheet) external onlyOwner {
576     allowances = AllowanceSheet(sheet);
577     allowances.claimOwnership();
578   }
579 
580   /**
581    * @dev Transfer tokens from one address to another
582    * @param _from address The address which you want to send tokens from
583    * @param _to address The address which you want to transfer to
584    * @param _value uint256 the amount of tokens to be transferred
585    */
586   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
587     transferAllArgsYesAllowance(_from, _to, _value, msg.sender);
588     return true;
589   }
590 
591   function transferAllArgsYesAllowance(address _from, address _to, uint256 _value, address spender) internal {
592     require(_value <= allowances.allowanceOf(_from, spender));
593 
594     allowances.subAllowance(_from, spender, _value);
595     transferAllArgsNoAllowance(_from, _to, _value);
596   }
597 
598   /**
599    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
600    *
601    * Beware that changing an allowance with this method brings the risk that someone may use both the old
602    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
603    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
604    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
605    * @param _spender The address which will spend the funds.
606    * @param _value The amount of tokens to be spent.
607    */
608   function approve(address _spender, uint256 _value) public returns (bool) {
609     approveAllArgs(_spender, _value, msg.sender);
610     return true;
611   }
612 
613   function approveAllArgs(address _spender, uint256 _value, address _tokenHolder) internal {
614     allowances.setAllowance(_tokenHolder, _spender, _value);
615     Approval(_tokenHolder, _spender, _value);
616   }
617 
618   /**
619    * @dev Function to check the amount of tokens that an owner allowed to a spender.
620    * @param _owner address The address which owns the funds.
621    * @param _spender address The address which will spend the funds.
622    * @return A uint256 specifying the amount of tokens still available for the spender.
623    */
624   function allowance(address _owner, address _spender) public view returns (uint256) {
625     return allowances.allowanceOf(_owner, _spender);
626   }
627 
628   /**
629    * @dev Increase the amount of tokens that an owner allowed to a spender.
630    *
631    * approve should be called when allowed[_spender] == 0. To increment
632    * allowed value is better to use this function to avoid 2 calls (and wait until
633    * the first transaction is mined)
634    * From MonolithDAO Token.sol
635    * @param _spender The address which will spend the funds.
636    * @param _addedValue The amount of tokens to increase the allowance by.
637    */
638   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
639     increaseApprovalAllArgs(_spender, _addedValue, msg.sender);
640     return true;
641   }
642 
643   function increaseApprovalAllArgs(address _spender, uint _addedValue, address tokenHolder) internal {
644     allowances.addAllowance(tokenHolder, _spender, _addedValue);
645     Approval(tokenHolder, _spender, allowances.allowanceOf(tokenHolder, _spender));
646   }
647 
648   /**
649    * @dev Decrease the amount of tokens that an owner allowed to a spender.
650    *
651    * approve should be called when allowed[_spender] == 0. To decrement
652    * allowed value is better to use this function to avoid 2 calls (and wait until
653    * the first transaction is mined)
654    * From MonolithDAO Token.sol
655    * @param _spender The address which will spend the funds.
656    * @param _subtractedValue The amount of tokens to decrease the allowance by.
657    */
658   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
659     decreaseApprovalAllArgs(_spender, _subtractedValue, msg.sender);
660     return true;
661   }
662 
663   function decreaseApprovalAllArgs(address _spender, uint _subtractedValue, address tokenHolder) internal {
664     uint oldValue = allowances.allowanceOf(tokenHolder, _spender);
665     if (_subtractedValue > oldValue) {
666       allowances.setAllowance(tokenHolder, _spender, 0);
667     } else {
668       allowances.subAllowance(tokenHolder, _spender, _subtractedValue);
669     }
670     Approval(tokenHolder, _spender, allowances.allowanceOf(tokenHolder, _spender));
671   }
672 
673 }
674 
675 contract CanDelegate is StandardToken {
676     // If this contract needs to be upgraded, the new contract will be stored
677     // in 'delegate' and any ERC20 calls to this contract will be delegated to that one.
678     DelegateERC20 public delegate;
679 
680     event DelegatedTo(address indexed newContract);
681 
682     // Can undelegate by passing in newContract = address(0)
683     function delegateToNewContract(DelegateERC20 newContract) public onlyOwner {
684         delegate = newContract;
685         DelegatedTo(delegate);
686     }
687 
688     // If a delegate has been designated, all ERC20 calls are forwarded to it
689     function transfer(address to, uint256 value) public returns (bool) {
690         if (delegate == address(0)) {
691             return super.transfer(to, value);
692         } else {
693             return delegate.delegateTransfer(to, value, msg.sender);
694         }
695     }
696 
697     function transferFrom(address from, address to, uint256 value) public returns (bool) {
698         if (delegate == address(0)) {
699             return super.transferFrom(from, to, value);
700         } else {
701             return delegate.delegateTransferFrom(from, to, value, msg.sender);
702         }
703     }
704 
705     function balanceOf(address who) public view returns (uint256) {
706         if (delegate == address(0)) {
707             return super.balanceOf(who);
708         } else {
709             return delegate.delegateBalanceOf(who);
710         }
711     }
712 
713     function approve(address spender, uint256 value) public returns (bool) {
714         if (delegate == address(0)) {
715             return super.approve(spender, value);
716         } else {
717             return delegate.delegateApprove(spender, value, msg.sender);
718         }
719     }
720 
721     function allowance(address _owner, address spender) public view returns (uint256) {
722         if (delegate == address(0)) {
723             return super.allowance(_owner, spender);
724         } else {
725             return delegate.delegateAllowance(_owner, spender);
726         }
727     }
728 
729     function totalSupply() public view returns (uint256) {
730         if (delegate == address(0)) {
731             return super.totalSupply();
732         } else {
733             return delegate.delegateTotalSupply();
734         }
735     }
736 
737     function increaseApproval(address spender, uint addedValue) public returns (bool) {
738         if (delegate == address(0)) {
739             return super.increaseApproval(spender, addedValue);
740         } else {
741             return delegate.delegateIncreaseApproval(spender, addedValue, msg.sender);
742         }
743     }
744 
745     function decreaseApproval(address spender, uint subtractedValue) public returns (bool) {
746         if (delegate == address(0)) {
747             return super.decreaseApproval(spender, subtractedValue);
748         } else {
749             return delegate.delegateDecreaseApproval(spender, subtractedValue, msg.sender);
750         }
751     }
752 }
753 
754 contract StandardDelegate is StandardToken, DelegateERC20 {
755     address public delegatedFrom;
756 
757     modifier onlySender(address source) {
758         require(msg.sender == source);
759         _;
760     }
761 
762     function setDelegatedFrom(address addr) onlyOwner public {
763         delegatedFrom = addr;
764     }
765 
766     // All delegate ERC20 functions are forwarded to corresponding normal functions
767     function delegateTotalSupply() public view returns (uint256) {
768         return totalSupply();
769     }
770 
771     function delegateBalanceOf(address who) public view returns (uint256) {
772         return balanceOf(who);
773     }
774 
775     function delegateTransfer(address to, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
776         transferAllArgsNoAllowance(origSender, to, value);
777         return true;
778     }
779 
780     function delegateAllowance(address owner, address spender) public view returns (uint256) {
781         return allowance(owner, spender);
782     }
783 
784     function delegateTransferFrom(address from, address to, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
785         transferAllArgsYesAllowance(from, to, value, origSender);
786         return true;
787     }
788 
789     function delegateApprove(address spender, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
790         approveAllArgs(spender, value, origSender);
791         return true;
792     }
793 
794     function delegateIncreaseApproval(address spender, uint addedValue, address origSender) onlySender(delegatedFrom) public returns (bool) {
795         increaseApprovalAllArgs(spender, addedValue, origSender);
796         return true;
797     }
798 
799     function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) onlySender(delegatedFrom) public returns (bool) {
800         decreaseApprovalAllArgs(spender, subtractedValue, origSender);
801         return true;
802     }
803 }
804 
805 contract PausableToken is StandardToken, Pausable {
806 
807   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
808     return super.transfer(_to, _value);
809   }
810 
811   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
812     return super.transferFrom(_from, _to, _value);
813   }
814 
815   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
816     return super.approve(_spender, _value);
817   }
818 
819   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
820     return super.increaseApproval(_spender, _addedValue);
821   }
822 
823   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
824     return super.decreaseApproval(_spender, _subtractedValue);
825   }
826 }
827 
828 contract TrueUSD is StandardDelegate, PausableToken, BurnableToken, NoOwner, CanDelegate {
829     string public name = "TrueUSD";
830     string public symbol = "TUSD";
831     uint8 public constant decimals = 18;
832 
833     AddressList public canReceiveMintWhiteList;
834     AddressList public canBurnWhiteList;
835     AddressList public blackList;
836     AddressList public noFeesList;
837     uint256 public burnMin = 10000 * 10**uint256(decimals);
838     uint256 public burnMax = 20000000 * 10**uint256(decimals);
839 
840     uint80 public transferFeeNumerator = 7;
841     uint80 public transferFeeDenominator = 10000;
842     uint80 public mintFeeNumerator = 0;
843     uint80 public mintFeeDenominator = 10000;
844     uint256 public mintFeeFlat = 0;
845     uint80 public burnFeeNumerator = 0;
846     uint80 public burnFeeDenominator = 10000;
847     uint256 public burnFeeFlat = 0;
848     address public staker;
849 
850     event ChangeBurnBoundsEvent(uint256 newMin, uint256 newMax);
851     event Mint(address indexed to, uint256 amount);
852     event WipedAccount(address indexed account, uint256 balance);
853 
854     function TrueUSD() public {
855         totalSupply_ = 0;
856         staker = msg.sender;
857     }
858 
859     function setLists(AddressList _canReceiveMintWhiteList, AddressList _canBurnWhiteList, AddressList _blackList, AddressList _noFeesList) onlyOwner public {
860         canReceiveMintWhiteList = _canReceiveMintWhiteList;
861         canBurnWhiteList = _canBurnWhiteList;
862         blackList = _blackList;
863         noFeesList = _noFeesList;
864     }
865 
866     function changeName(string _name, string _symbol) onlyOwner public {
867         name = _name;
868         symbol = _symbol;
869     }
870 
871     //Burning functions as withdrawing money from the system. The platform will keep track of who burns coins,
872     //and will send them back the equivalent amount of money (rounded down to the nearest cent).
873     function burn(uint256 _value) public {
874         require(canBurnWhiteList.onList(msg.sender));
875         require(_value >= burnMin);
876         require(_value <= burnMax);
877         uint256 fee = payStakingFee(msg.sender, _value, burnFeeNumerator, burnFeeDenominator, burnFeeFlat, 0x0);
878         uint256 remaining = _value.sub(fee);
879         super.burn(remaining);
880     }
881 
882     //Create _amount new tokens and transfer them to _to.
883     //Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/MintableToken.sol
884     function mint(address _to, uint256 _amount) onlyOwner public {
885         require(canReceiveMintWhiteList.onList(_to));
886         totalSupply_ = totalSupply_.add(_amount);
887         balances.addBalance(_to, _amount);
888         Mint(_to, _amount);
889         Transfer(address(0), _to, _amount);
890         payStakingFee(_to, _amount, mintFeeNumerator, mintFeeDenominator, mintFeeFlat, 0x0);
891     }
892 
893     //Change the minimum and maximum amount that can be burned at once. Burning
894     //may be disabled by setting both to 0 (this will not be done under normal
895     //operation, but we can't add checks to disallow it without losing a lot of
896     //flexibility since burning could also be as good as disabled
897     //by setting the minimum extremely high, and we don't want to lock
898     //in any particular cap for the minimum)
899     function changeBurnBounds(uint newMin, uint newMax) onlyOwner public {
900         require(newMin <= newMax);
901         burnMin = newMin;
902         burnMax = newMax;
903         ChangeBurnBoundsEvent(newMin, newMax);
904     }
905 
906     // transfer and transferFrom are both dispatched to this function, so we
907     // check blacklist and pay staking fee here.
908     function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal {
909         require(!blackList.onList(_from));
910         require(!blackList.onList(_to));
911         super.transferAllArgsNoAllowance(_from, _to, _value);
912         payStakingFee(_to, _value, transferFeeNumerator, transferFeeDenominator, 0, _from);
913     }
914 
915     function wipeBlacklistedAccount(address account) public onlyOwner {
916         require(blackList.onList(account));
917         uint256 oldValue = balanceOf(account);
918         balances.setBalance(account, 0);
919         totalSupply_ = totalSupply_.sub(oldValue);
920         WipedAccount(account, oldValue);
921     }
922 
923     function payStakingFee(address payer, uint256 value, uint80 numerator, uint80 denominator, uint256 flatRate, address otherParticipant) private returns (uint256) {
924         if (noFeesList.onList(payer) || noFeesList.onList(otherParticipant)) {
925             return 0;
926         }
927         uint256 stakingFee = value.mul(numerator).div(denominator).add(flatRate);
928         if (stakingFee > 0) {
929             super.transferAllArgsNoAllowance(payer, staker, stakingFee);
930         }
931         return stakingFee;
932     }
933 
934     function changeStakingFees(uint80 _transferFeeNumerator,
935                                  uint80 _transferFeeDenominator,
936                                  uint80 _mintFeeNumerator,
937                                  uint80 _mintFeeDenominator,
938                                  uint256 _mintFeeFlat,
939                                  uint80 _burnFeeNumerator,
940                                  uint80 _burnFeeDenominator,
941                                  uint256 _burnFeeFlat) public onlyOwner {
942         require(_transferFeeDenominator != 0);
943         require(_mintFeeDenominator != 0);
944         require(_burnFeeDenominator != 0);
945         transferFeeNumerator = _transferFeeNumerator;
946         transferFeeDenominator = _transferFeeDenominator;
947         mintFeeNumerator = _mintFeeNumerator;
948         mintFeeDenominator = _mintFeeDenominator;
949         mintFeeFlat = _mintFeeFlat;
950         burnFeeNumerator = _burnFeeNumerator;
951         burnFeeDenominator = _burnFeeDenominator;
952         burnFeeFlat = _burnFeeFlat;
953     }
954 
955     function changeStaker(address newStaker) public onlyOwner {
956         require(newStaker != address(0));
957         staker = newStaker;
958     }
959 }