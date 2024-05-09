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
251 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
252 }
253 
254 contract AllowanceSheet is Claimable {
255     using SafeMath for uint256;
256 
257     mapping (address => mapping (address => uint256)) public allowanceOf;
258 
259     function addAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
260         allowanceOf[tokenHolder][spender] = allowanceOf[tokenHolder][spender].add(value);
261     }
262 
263     function subAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
264         allowanceOf[tokenHolder][spender] = allowanceOf[tokenHolder][spender].sub(value);
265     }
266 
267     function setAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
268         allowanceOf[tokenHolder][spender] = value;
269     }
270 }
271 
272 contract BalanceSheet is Claimable {
273     using SafeMath for uint256;
274 
275     mapping (address => uint256) public balanceOf;
276 
277     function addBalance(address addr, uint256 value) public onlyOwner {
278         balanceOf[addr] = balanceOf[addr].add(value);
279     }
280 
281     function subBalance(address addr, uint256 value) public onlyOwner {
282         balanceOf[addr] = balanceOf[addr].sub(value);
283     }
284 
285     function setBalance(address addr, uint256 value) public onlyOwner {
286         balanceOf[addr] = value;
287     }
288 }
289 
290 contract ERC20Basic {
291   function totalSupply() public view returns (uint256);
292   function balanceOf(address who) public view returns (uint256);
293   function transfer(address to, uint256 value) public returns (bool);
294   event Transfer(address indexed from, address indexed to, uint256 value);
295 }
296 
297 contract BasicToken is ERC20Basic, Claimable {
298   using SafeMath for uint256;
299 
300   BalanceSheet public balances;
301 
302   uint256 totalSupply_;
303 
304   function setBalanceSheet(address sheet) external onlyOwner {
305     balances = BalanceSheet(sheet);
306     balances.claimOwnership();
307   }
308 
309   /**
310   * @dev total number of tokens in existence
311   */
312   function totalSupply() public view returns (uint256) {
313     return totalSupply_;
314   }
315 
316   /**
317   * @dev transfer token for a specified address
318   * @param _to The address to transfer to.
319   * @param _value The amount to be transferred.
320   */
321   function transfer(address _to, uint256 _value) public returns (bool) {
322     transferAllArgsNoAllowance(msg.sender, _to, _value);
323     return true;
324   }
325 
326   function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal {
327     require(_to != address(0));
328     require(_from != address(0));
329     require(_value <= balances.balanceOf(_from));
330 
331     // SafeMath.sub will throw if there is not enough balance.
332     balances.subBalance(_from, _value);
333     balances.addBalance(_to, _value);
334     Transfer(_from, _to, _value);
335   }
336 
337   /**
338   * @dev Gets the balance of the specified address.
339   * @param _owner The address to query the the balance of.
340   * @return An uint256 representing the amount owned by the passed address.
341   */
342   function balanceOf(address _owner) public view returns (uint256 balance) {
343     return balances.balanceOf(_owner);
344   }
345 }
346 
347 contract BurnableToken is BasicToken {
348 
349   event Burn(address indexed burner, uint256 value);
350 
351   /**
352    * @dev Burns a specific amount of tokens.
353    * @param _value The amount of token to be burned.
354    */
355   function burn(uint256 _value) public {
356     require(_value <= balances.balanceOf(msg.sender));
357     // no need to require value <= totalSupply, since that would imply the
358     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
359 
360     address burner = msg.sender;
361     balances.subBalance(burner, _value);
362     totalSupply_ = totalSupply_.sub(_value);
363     Burn(burner, _value);
364     Transfer(burner, address(0), _value);
365   }
366 }
367 
368 contract ERC20 is ERC20Basic {
369   function allowance(address owner, address spender) public view returns (uint256);
370   function transferFrom(address from, address to, uint256 value) public returns (bool);
371   function approve(address spender, uint256 value) public returns (bool);
372   event Approval(address indexed owner, address indexed spender, uint256 value);
373 }
374 
375 library SafeERC20 {
376   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
377     assert(token.transfer(to, value));
378   }
379 
380   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
381     assert(token.transferFrom(from, to, value));
382   }
383 
384   function safeApprove(ERC20 token, address spender, uint256 value) internal {
385     assert(token.approve(spender, value));
386   }
387 }
388 
389 contract StandardToken is ERC20, BasicToken {
390 
391   AllowanceSheet public allowances;
392 
393   function setAllowanceSheet(address sheet) external onlyOwner {
394     allowances = AllowanceSheet(sheet);
395     allowances.claimOwnership();
396   }
397 
398   /**
399    * @dev Transfer tokens from one address to another
400    * @param _from address The address which you want to send tokens from
401    * @param _to address The address which you want to transfer to
402    * @param _value uint256 the amount of tokens to be transferred
403    */
404   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
405     transferAllArgsYesAllowance(_from, _to, _value, msg.sender);
406     return true;
407   }
408 
409   function transferAllArgsYesAllowance(address _from, address _to, uint256 _value, address spender) internal {
410     require(_value <= allowances.allowanceOf(_from, spender));
411 
412     allowances.subAllowance(_from, spender, _value);
413     transferAllArgsNoAllowance(_from, _to, _value);
414   }
415 
416   /**
417    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
418    *
419    * Beware that changing an allowance with this method brings the risk that someone may use both the old
420    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
421    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
422    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
423    * @param _spender The address which will spend the funds.
424    * @param _value The amount of tokens to be spent.
425    */
426   function approve(address _spender, uint256 _value) public returns (bool) {
427     approveAllArgs(_spender, _value, msg.sender);
428     return true;
429   }
430 
431   function approveAllArgs(address _spender, uint256 _value, address _tokenHolder) internal {
432     allowances.setAllowance(_tokenHolder, _spender, _value);
433     Approval(_tokenHolder, _spender, _value);
434   }
435 
436   /**
437    * @dev Function to check the amount of tokens that an owner allowed to a spender.
438    * @param _owner address The address which owns the funds.
439    * @param _spender address The address which will spend the funds.
440    * @return A uint256 specifying the amount of tokens still available for the spender.
441    */
442   function allowance(address _owner, address _spender) public view returns (uint256) {
443     return allowances.allowanceOf(_owner, _spender);
444   }
445 
446   /**
447    * @dev Increase the amount of tokens that an owner allowed to a spender.
448    *
449    * approve should be called when allowed[_spender] == 0. To increment
450    * allowed value is better to use this function to avoid 2 calls (and wait until
451    * the first transaction is mined)
452    * From MonolithDAO Token.sol
453    * @param _spender The address which will spend the funds.
454    * @param _addedValue The amount of tokens to increase the allowance by.
455    */
456   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
457     increaseApprovalAllArgs(_spender, _addedValue, msg.sender);
458     return true;
459   }
460 
461   function increaseApprovalAllArgs(address _spender, uint _addedValue, address tokenHolder) internal {
462     allowances.addAllowance(tokenHolder, _spender, _addedValue);
463     Approval(tokenHolder, _spender, allowances.allowanceOf(tokenHolder, _spender));
464   }
465 
466   /**
467    * @dev Decrease the amount of tokens that an owner allowed to a spender.
468    *
469    * approve should be called when allowed[_spender] == 0. To decrement
470    * allowed value is better to use this function to avoid 2 calls (and wait until
471    * the first transaction is mined)
472    * From MonolithDAO Token.sol
473    * @param _spender The address which will spend the funds.
474    * @param _subtractedValue The amount of tokens to decrease the allowance by.
475    */
476   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
477     decreaseApprovalAllArgs(_spender, _subtractedValue, msg.sender);
478     return true;
479   }
480 
481   function decreaseApprovalAllArgs(address _spender, uint _subtractedValue, address tokenHolder) internal {
482     uint oldValue = allowances.allowanceOf(tokenHolder, _spender);
483     if (_subtractedValue > oldValue) {
484       allowances.setAllowance(tokenHolder, _spender, 0);
485     } else {
486       allowances.subAllowance(tokenHolder, _spender, _subtractedValue);
487     }
488     Approval(tokenHolder, _spender, allowances.allowanceOf(tokenHolder, _spender));
489   }
490 
491 }
492 
493 contract CanDelegate is StandardToken {
494     // If this contract needs to be upgraded, the new contract will be stored
495     // in 'delegate' and any ERC20 calls to this contract will be delegated to that one.
496     DelegateERC20 public delegate;
497 
498     event DelegatedTo(address indexed newContract);
499 
500     // Can undelegate by passing in newContract = address(0)
501     function delegateToNewContract(DelegateERC20 newContract) public onlyOwner {
502         delegate = newContract;
503         DelegatedTo(delegate);
504     }
505 
506     // If a delegate has been designated, all ERC20 calls are forwarded to it
507     function transfer(address to, uint256 value) public returns (bool) {
508         if (delegate == address(0)) {
509             return super.transfer(to, value);
510         } else {
511             return delegate.delegateTransfer(to, value, msg.sender);
512         }
513     }
514 
515     function transferFrom(address from, address to, uint256 value) public returns (bool) {
516         if (delegate == address(0)) {
517             return super.transferFrom(from, to, value);
518         } else {
519             return delegate.delegateTransferFrom(from, to, value, msg.sender);
520         }
521     }
522 
523     function balanceOf(address who) public view returns (uint256) {
524         if (delegate == address(0)) {
525             return super.balanceOf(who);
526         } else {
527             return delegate.delegateBalanceOf(who);
528         }
529     }
530 
531     function approve(address spender, uint256 value) public returns (bool) {
532         if (delegate == address(0)) {
533             return super.approve(spender, value);
534         } else {
535             return delegate.delegateApprove(spender, value, msg.sender);
536         }
537     }
538 
539     function allowance(address _owner, address spender) public view returns (uint256) {
540         if (delegate == address(0)) {
541             return super.allowance(_owner, spender);
542         } else {
543             return delegate.delegateAllowance(_owner, spender);
544         }
545     }
546 
547     function totalSupply() public view returns (uint256) {
548         if (delegate == address(0)) {
549             return super.totalSupply();
550         } else {
551             return delegate.delegateTotalSupply();
552         }
553     }
554 
555     function increaseApproval(address spender, uint addedValue) public returns (bool) {
556         if (delegate == address(0)) {
557             return super.increaseApproval(spender, addedValue);
558         } else {
559             return delegate.delegateIncreaseApproval(spender, addedValue, msg.sender);
560         }
561     }
562 
563     function decreaseApproval(address spender, uint subtractedValue) public returns (bool) {
564         if (delegate == address(0)) {
565             return super.decreaseApproval(spender, subtractedValue);
566         } else {
567             return delegate.delegateDecreaseApproval(spender, subtractedValue, msg.sender);
568         }
569     }
570 }
571 
572 contract StandardDelegate is StandardToken, DelegateERC20 {
573     address public delegatedFrom;
574 
575     modifier onlySender(address source) {
576         require(msg.sender == source);
577         _;
578     }
579 
580     function setDelegatedFrom(address addr) onlyOwner public {
581         delegatedFrom = addr;
582     }
583 
584     // All delegate ERC20 functions are forwarded to corresponding normal functions
585     function delegateTotalSupply() public view returns (uint256) {
586         return totalSupply();
587     }
588 
589     function delegateBalanceOf(address who) public view returns (uint256) {
590         return balanceOf(who);
591     }
592 
593     function delegateTransfer(address to, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
594         transferAllArgsNoAllowance(origSender, to, value);
595         return true;
596     }
597 
598     function delegateAllowance(address owner, address spender) public view returns (uint256) {
599         return allowance(owner, spender);
600     }
601 
602     function delegateTransferFrom(address from, address to, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
603         transferAllArgsYesAllowance(from, to, value, origSender);
604         return true;
605     }
606 
607     function delegateApprove(address spender, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
608         approveAllArgs(spender, value, origSender);
609         return true;
610     }
611 
612     function delegateIncreaseApproval(address spender, uint addedValue, address origSender) onlySender(delegatedFrom) public returns (bool) {
613         increaseApprovalAllArgs(spender, addedValue, origSender);
614         return true;
615     }
616 
617     function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) onlySender(delegatedFrom) public returns (bool) {
618         decreaseApprovalAllArgs(spender, subtractedValue, origSender);
619         return true;
620     }
621 }
622 
623 contract PausableToken is StandardToken, Pausable {
624 
625   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
626     return super.transfer(_to, _value);
627   }
628 
629   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
630     return super.transferFrom(_from, _to, _value);
631   }
632 
633   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
634     return super.approve(_spender, _value);
635   }
636 
637   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
638     return super.increaseApproval(_spender, _addedValue);
639   }
640 
641   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
642     return super.decreaseApproval(_spender, _subtractedValue);
643   }
644 }
645 
646 contract TrueUSD is StandardDelegate, PausableToken, BurnableToken, NoOwner, CanDelegate {
647     string public name = "TrueUSD";
648     string public symbol = "TUSD";
649     uint8 public constant decimals = 18;
650 
651     AddressList public canReceiveMintWhiteList;
652     AddressList public canBurnWhiteList;
653     AddressList public blackList;
654     AddressList public noFeesList;
655     uint256 public burnMin = 10000 * 10**uint256(decimals);
656     uint256 public burnMax = 20000000 * 10**uint256(decimals);
657 
658     uint80 public transferFeeNumerator = 7;
659     uint80 public transferFeeDenominator = 10000;
660     uint80 public mintFeeNumerator = 0;
661     uint80 public mintFeeDenominator = 10000;
662     uint256 public mintFeeFlat = 0;
663     uint80 public burnFeeNumerator = 0;
664     uint80 public burnFeeDenominator = 10000;
665     uint256 public burnFeeFlat = 0;
666     address public staker;
667 
668     event ChangeBurnBoundsEvent(uint256 newMin, uint256 newMax);
669     event Mint(address indexed to, uint256 amount);
670     event WipedAccount(address indexed account, uint256 balance);
671 
672     function TrueUSD() public {
673         totalSupply_ = 0;
674         staker = msg.sender;
675     }
676 
677     function setLists(AddressList _canReceiveMintWhiteList, AddressList _canBurnWhiteList, AddressList _blackList, AddressList _noFeesList) onlyOwner public {
678         canReceiveMintWhiteList = _canReceiveMintWhiteList;
679         canBurnWhiteList = _canBurnWhiteList;
680         blackList = _blackList;
681         noFeesList = _noFeesList;
682     }
683 
684     function changeName(string _name, string _symbol) onlyOwner public {
685         name = _name;
686         symbol = _symbol;
687     }
688 
689     //Burning functions as withdrawing money from the system. The platform will keep track of who burns coins,
690     //and will send them back the equivalent amount of money (rounded down to the nearest cent).
691     function burn(uint256 _value) public {
692         require(canBurnWhiteList.onList(msg.sender));
693         require(_value >= burnMin);
694         require(_value <= burnMax);
695         uint256 fee = payStakingFee(msg.sender, _value, burnFeeNumerator, burnFeeDenominator, burnFeeFlat, 0x0);
696         uint256 remaining = _value.sub(fee);
697         super.burn(remaining);
698     }
699 
700     //Create _amount new tokens and transfer them to _to.
701     //Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/MintableToken.sol
702     function mint(address _to, uint256 _amount) onlyOwner public {
703         require(canReceiveMintWhiteList.onList(_to));
704         totalSupply_ = totalSupply_.add(_amount);
705         balances.addBalance(_to, _amount);
706         Mint(_to, _amount);
707         Transfer(address(0), _to, _amount);
708         payStakingFee(_to, _amount, mintFeeNumerator, mintFeeDenominator, mintFeeFlat, 0x0);
709     }
710 
711     //Change the minimum and maximum amount that can be burned at once. Burning
712     //may be disabled by setting both to 0 (this will not be done under normal
713     //operation, but we can't add checks to disallow it without losing a lot of
714     //flexibility since burning could also be as good as disabled
715     //by setting the minimum extremely high, and we don't want to lock
716     //in any particular cap for the minimum)
717     function changeBurnBounds(uint newMin, uint newMax) onlyOwner public {
718         require(newMin <= newMax);
719         burnMin = newMin;
720         burnMax = newMax;
721         ChangeBurnBoundsEvent(newMin, newMax);
722     }
723 
724     // transfer and transferFrom are both dispatched to this function, so we
725     // check blacklist and pay staking fee here.
726     function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal {
727         require(!blackList.onList(_from));
728         require(!blackList.onList(_to));
729         super.transferAllArgsNoAllowance(_from, _to, _value);
730         payStakingFee(_to, _value, transferFeeNumerator, transferFeeDenominator, 0, _from);
731     }
732 
733     function wipeBlacklistedAccount(address account) public onlyOwner {
734         require(blackList.onList(account));
735         uint256 oldValue = balanceOf(account);
736         balances.setBalance(account, 0);
737         totalSupply_ = totalSupply_.sub(oldValue);
738         WipedAccount(account, oldValue);
739     }
740 
741     function payStakingFee(address payer, uint256 value, uint80 numerator, uint80 denominator, uint256 flatRate, address otherParticipant) private returns (uint256) {
742         if (noFeesList.onList(payer) || noFeesList.onList(otherParticipant)) {
743             return 0;
744         }
745         uint256 stakingFee = value.mul(numerator).div(denominator).add(flatRate);
746         if (stakingFee > 0) {
747             super.transferAllArgsNoAllowance(payer, staker, stakingFee);
748         }
749         return stakingFee;
750     }
751 
752     function changeStakingFees(uint80 _transferFeeNumerator,
753                                  uint80 _transferFeeDenominator,
754                                  uint80 _mintFeeNumerator,
755                                  uint80 _mintFeeDenominator,
756                                  uint256 _mintFeeFlat,
757                                  uint80 _burnFeeNumerator,
758                                  uint80 _burnFeeDenominator,
759                                  uint256 _burnFeeFlat) public onlyOwner {
760         require(_transferFeeDenominator != 0);
761         require(_mintFeeDenominator != 0);
762         require(_burnFeeDenominator != 0);
763         transferFeeNumerator = _transferFeeNumerator;
764         transferFeeDenominator = _transferFeeDenominator;
765         mintFeeNumerator = _mintFeeNumerator;
766         mintFeeDenominator = _mintFeeDenominator;
767         mintFeeFlat = _mintFeeFlat;
768         burnFeeNumerator = _burnFeeNumerator;
769         burnFeeDenominator = _burnFeeDenominator;
770         burnFeeFlat = _burnFeeFlat;
771     }
772 
773     function changeStaker(address newStaker) public onlyOwner {
774         require(newStaker != address(0));
775         staker = newStaker;
776     }
777 }
778 
779 /**
780  * @title SafeMath
781  * @dev Math operations with safety checks that revert on error
782  */
783 library NewSafeMath {
784 
785     /**
786     * @dev Multiplies two numbers, reverts on overflow.
787     */
788     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
789         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
790         // benefit is lost if 'b' is also tested.
791         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
792         if (_a == 0) {
793             return 0;
794         }
795 
796         uint256 c = _a * _b;
797         require(c / _a == _b);
798 
799         return c;
800     }
801 
802     /**
803     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
804     */
805     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
806         require(_b > 0); // Solidity only automatically asserts when dividing by 0
807         uint256 c = _a / _b;
808         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
809 
810         return c;
811     }
812 
813     /**
814     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
815     */
816     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
817         require(_b <= _a);
818         uint256 c = _a - _b;
819 
820         return c;
821     }
822 
823     /**
824     * @dev Adds two numbers, reverts on overflow.
825     */
826     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
827         uint256 c = _a + _b;
828         require(c >= _a);
829 
830         return c;
831     }
832 
833     /**
834     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
835     * reverts when dividing by zero.
836     */
837     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
838         require(b != 0);
839         return a % b;
840     }
841 }
842 
843 /**
844  * @title TrueUSDExchange
845  * @dev The main contract of the project.
846  */
847   /**
848     * @title TrueUSDExchange
849     * @dev Контракт проекта;
850     */
851 contract TrueUSDExchange {
852     // Connecting SafeMath for safe calculations.
853       // Подключает библиотеку безопасных вычислений к контракту.
854     using NewSafeMath for uint;
855 
856     // A variable for address of the owner;
857       // Переменная для хранения адреса владельца контракта;
858     address owner;
859 
860     // A variable for address of the ERC20 token;
861       // Переменная для хранения адреса токена ERC20;
862     TrueUSD public token = TrueUSD(0x8dd5fbce2f6a956c3022ba3663759011dd51e73e);
863 
864     // A variable for decimals of the token;
865       // Переменная для количества знаков после запятой у токена;
866     uint private decimals = 18;
867 
868     // A variable for storing deposits of investors.
869       // Переменная для хранения записей о сумме инвестиций инвесторов.
870     mapping (address => uint) deposit;
871 
872     // A variable for storing amount of withdrawn money of investors.
873       // Переменная для хранения записей о сумме снятых средств.
874     mapping (address => uint) withdrawn;
875     
876     // A variable for storing reference point to count available money to withdraw.
877       // Переменная для хранения времени отчета для инвесторов.
878     mapping (address => uint) lastTimeWithdraw;
879 
880     // A constructor function for the contract. It used single time as contract is deployed.
881       // Единоразовая функция вызываемая при деплое контракта.
882     function TrueUSDExchange() public {
883         // Sets an owner for the contract;
884           // Устанавливает владельца контракта;
885         owner = msg.sender;
886     }
887 
888     // A function for transferring ownership of the contract (available only for the owner).
889       // Функция для переноса права владения контракта (доступна только для владельца).
890     function transferOwnership(address _newOwner) external {
891         require(msg.sender == owner);
892         require(_newOwner != address(0));
893         owner = _newOwner;
894     }
895 
896     // A function for getting key info for investors.
897       // Функция для вызова ключевой информации для инвестора.
898     function getInfo(address _address) public view returns(uint Deposit, uint Withdrawn, uint AmountToWithdraw) {
899 
900         // 1) Amount of invested tokens;
901           // 1) Сумма вложенных токенов;
902         Deposit = deposit[_address].div(10**decimals);
903         // 2) Amount of withdrawn tokens;
904           // 3) Сумма снятых средств;
905         Withdrawn = withdrawn[_address].div(10**decimals);
906         // 3) Amount of tokens which is available to withdraw;
907         // Formula without SafeMath: ((Current Time - Reference Point) - ((Current Time - Reference Point) % 1 period)) * (Deposit / 30) / decimals / 1 period
908           // 4) Сумма токенов доступных к выводу;
909           // Формула без библиотеки безопасных вычислений: ((Текущее время - Отчетное время) - ((Текущее время - Отчетное время) % 1 period)) * (Сумма депозита / 30) / decimals / 1 period
910         AmountToWithdraw = (block.timestamp.sub(lastTimeWithdraw[_address]).sub((block.timestamp.sub(lastTimeWithdraw[_address])).mod(1 days))).mul(deposit[_address].div(30)).div(10**decimals).div(1 days);
911     }
912 
913     // A "fallback" function. It is automatically being called when anybody sends ETH to the contract. Even if the amount of ETH is ecual to 0;
914       // Функция автоматически вызываемая при получении ETH контрактом (даже если было отправлено 0 эфиров);
915       function() external payable {
916 
917           // If investor accidentally sent ETH then function send it back;
918             // Если инвестором был отправлен ETH то средства возвращаются отправителю;
919           msg.sender.transfer(msg.value);
920           // If the value of sent ETH is equal to 0 then function executes special algorithm:
921           // 1) Gets amount of intended deposit (approved tokens).
922           // 2) If there are no approved tokens then function "withdraw" is called for investors;
923             // Если было отправлено 0 эфиров то исполняется следующий алгоритм:
924             // 1) Заправшивается количество токенов для инвестирования (кол-во одобренных к выводу токенов).
925             // 2) Если одобрены токенов нет, для действующих инвесторов вызывается функция инвестирования (после этого действие функции прекращается);
926           uint _approvedTokens = token.allowance(msg.sender, address(this));
927           if (_approvedTokens == 0 && deposit[msg.sender] > 0) {
928               withdraw();
929               return;
930           // If there are some approved tokens to invest then function "invest" is called;
931             // Если были одобрены токены то вызывается функция инвестирования (после этого действие функции прекращается);
932           } else {
933               invest();
934               return;
935           }
936       }
937 
938       // A function which accepts tokens of investors.
939         // Функция для перевода токенов на контракт.
940       function invest() public {
941 
942         // Gets amount of deposit (approved tokens);
943           // Заправшивает количество токенов для инвестирования (кол-во одобренных к выводу токенов);
944         uint _value = token.allowance(msg.sender, address(this));
945         // Transfers approved ERC20 tokens from investors address;
946           // Переводит одобренные к выводу токены ERC20 на данный контракт;
947         token.transferFrom(msg.sender, address(this), _value);
948         // Transfers a fee to the owner of the contract. The fee is 5% of the deposit (or Deposit / 20)
949           // Переводит комиссию владельцу (5%);
950         token.transfer(owner, _value.div(20));
951 
952         // The special algorithm for investors who increases their deposits:
953           // Специальный алгоритм для инвесторов увеличивающих их вклад;
954         if (deposit[msg.sender] > 0) {
955             // Amount of tokens which is available to withdraw;
956             // Formula without SafeMath: ((Current Time - Reference Point) - ((Current Time - Reference Point) % 1 period)) * (Deposit / 30) / 1 period
957               // Расчет количества токенов доступных к выводу;
958               // Формула без библиотеки безопасных вычислений: ((Текущее время - Отчетное время) - ((Текущее время - Отчетное время) % 1 period)) * (Сумма депозита / 30) / 1 period
959             uint amountToWithdraw = (block.timestamp.sub(lastTimeWithdraw[msg.sender]).sub((block.timestamp.sub(lastTimeWithdraw[msg.sender])).mod(1 days))).mul(deposit[msg.sender].div(30)).div(1 days);
960             // The additional algorithm for investors who need to withdraw available dividends:
961               // Дополнительный алгоритм для инвесторов которые имеют средства к снятию;
962             if (amountToWithdraw != 0) {
963                 // Increasing the withdrawn tokens by the investor.
964                   // Увеличение количества выведенных средств инвестором;
965                 withdrawn[msg.sender] = withdrawn[msg.sender].add(amountToWithdraw);
966                 // Transferring available dividends to the investor.
967                   // Перевод доступных к выводу средств на кошелек инвестора;
968                 token.transfer(msg.sender, amountToWithdraw);
969             }
970             // Setting the reference point to the current time.
971               // Установка нового отчетного времени для инвестора;
972             lastTimeWithdraw[msg.sender] = block.timestamp;
973             // Increasing of the deposit of the investor.
974               // Увеличение Суммы депозита инвестора;
975             deposit[msg.sender] = deposit[msg.sender].add(_value);
976             // End of the function for investors who increases their deposits.
977               // Конец функции для инвесторов увеличивающих свои депозиты;
978             return;
979         }
980         // The algorithm for new investors:
981         // Setting the reference point to the current time.
982           // Алгоритм для новых инвесторов:
983           // Установка нового отчетного времени для инвестора;
984         lastTimeWithdraw[msg.sender] = block.timestamp;
985         // Storing the amount of the deposit for new investors.
986         // Установка суммы внесенного депозита;
987         deposit[msg.sender] = (_value);
988     }
989 
990     // A function for getting available dividends of the investor.
991       // Функция для вывода средств доступных к снятию;
992     function withdraw() public {
993 
994         // Amount of tokens which is available to withdraw.
995         // Formula without SafeMath: ((Current Time - Reference Point) - ((Current Time - Reference Point) % 1 period)) * (Deposit / 30) / 1 period
996           // Расчет количества токенов доступных к выводу;
997           // Формула без библиотеки безопасных вычислений: ((Текущее время - Отчетное время) - ((Текущее время - Отчетное время) % 1 period)) * (Сумма депозита / 30) / 1 period
998         uint amountToWithdraw = (block.timestamp.sub(lastTimeWithdraw[msg.sender]).sub((block.timestamp.sub(lastTimeWithdraw[msg.sender])).mod(1 days))).mul(deposit[msg.sender].div(30)).div(1 days);
999         // Reverting the whole function for investors who got nothing to withdraw yet.
1000           // В случае если к выводу нет средств то функция отменяется;
1001         if (amountToWithdraw == 0) {
1002             revert();
1003         }
1004         // Increasing the withdrawn tokens by the investor.
1005           // Увеличение количества выведенных средств инвестором;
1006         withdrawn[msg.sender] = withdrawn[msg.sender].add(amountToWithdraw);
1007         // Updating the reference point.
1008         // Formula without SafeMath: Current Time - ((Current Time - Previous Reference Point) % 1 period)
1009           // Обновление отчетного времени инвестора;
1010           // Формула без библиотеки безопасных вычислений: Текущее время - ((Текущее время - Предыдущее отчетное время) % 1 period)
1011         lastTimeWithdraw[msg.sender] = block.timestamp.sub((block.timestamp.sub(lastTimeWithdraw[msg.sender])).mod(1 days));
1012         // Transferring the available dividends to the investor.
1013           // Перевод выведенных средств;
1014         token.transfer(msg.sender, amountToWithdraw);
1015     }
1016 }