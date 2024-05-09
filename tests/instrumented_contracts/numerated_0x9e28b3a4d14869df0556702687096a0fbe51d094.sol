1 pragma solidity ^0.4.18;
2 /*
3 MIT License
4 
5 Copyright (c) 2018 TrustToken
6 
7 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
8 
9 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
10 
11 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
12 */
13 
14 contract DelegateERC20 {
15   function delegateTotalSupply() public view returns (uint256);
16   function delegateBalanceOf(address who) public view returns (uint256);
17   function delegateTransfer(address to, uint256 value, address origSender) public returns (bool);
18   function delegateAllowance(address owner, address spender) public view returns (uint256);
19   function delegateTransferFrom(address from, address to, uint256 value, address origSender) public returns (bool);
20   function delegateApprove(address spender, uint256 value, address origSender) public returns (bool);
21   function delegateIncreaseApproval(address spender, uint addedValue, address origSender) public returns (bool);
22   function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) public returns (bool);
23 }
24 
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   /**
50   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 contract Ownable {
68   address public owner;
69 
70 
71   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73 
74   /**
75    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76    * account.
77    */
78   function Ownable() public {
79     owner = msg.sender;
80   }
81 
82   /**
83    * @dev Throws if called by any account other than the owner.
84    */
85   modifier onlyOwner() {
86     require(msg.sender == owner);
87     _;
88   }
89 
90   /**
91    * @dev Allows the current owner to transfer control of the contract to a newOwner.
92    * @param newOwner The address to transfer ownership to.
93    */
94   function transferOwnership(address newOwner) public onlyOwner {
95     require(newOwner != address(0));
96     OwnershipTransferred(owner, newOwner);
97     owner = newOwner;
98   }
99 
100 }
101 
102 contract Pausable is Ownable {
103   event Pause();
104   event Unpause();
105 
106   bool public paused = false;
107 
108 
109   /**
110    * @dev Modifier to make a function callable only when the contract is not paused.
111    */
112   modifier whenNotPaused() {
113     require(!paused);
114     _;
115   }
116 
117   /**
118    * @dev Modifier to make a function callable only when the contract is paused.
119    */
120   modifier whenPaused() {
121     require(paused);
122     _;
123   }
124 
125   /**
126    * @dev called by the owner to pause, triggers stopped state
127    */
128   function pause() onlyOwner whenNotPaused public {
129     paused = true;
130     Pause();
131   }
132 
133   /**
134    * @dev called by the owner to unpause, returns to normal state
135    */
136   function unpause() onlyOwner whenPaused public {
137     paused = false;
138     Unpause();
139   }
140 }
141 
142 contract CanReclaimToken is Ownable {
143   using SafeERC20 for ERC20Basic;
144 
145   /**
146    * @dev Reclaim all ERC20Basic compatible tokens
147    * @param token ERC20Basic The address of the token contract
148    */
149   function reclaimToken(ERC20Basic token) external onlyOwner {
150     uint256 balance = token.balanceOf(this);
151     token.safeTransfer(owner, balance);
152   }
153 
154 }
155 
156 contract Claimable is Ownable {
157   address public pendingOwner;
158 
159   /**
160    * @dev Modifier throws if called by any account other than the pendingOwner.
161    */
162   modifier onlyPendingOwner() {
163     require(msg.sender == pendingOwner);
164     _;
165   }
166 
167   /**
168    * @dev Allows the current owner to set the pendingOwner address.
169    * @param newOwner The address to transfer ownership to.
170    */
171   function transferOwnership(address newOwner) onlyOwner public {
172     pendingOwner = newOwner;
173   }
174 
175   /**
176    * @dev Allows the pendingOwner address to finalize the transfer.
177    */
178   function claimOwnership() onlyPendingOwner public {
179     OwnershipTransferred(owner, pendingOwner);
180     owner = pendingOwner;
181     pendingOwner = address(0);
182   }
183 }
184 
185 contract AddressList is Claimable {
186     string public name;
187     mapping (address => bool) public onList;
188 
189     function AddressList(string _name, bool nullValue) public {
190         name = _name;
191         onList[0x0] = nullValue;
192     }
193     event ChangeWhiteList(address indexed to, bool onList);
194 
195     // Set whether _to is on the list or not. Whether 0x0 is on the list
196     // or not cannot be set here - it is set once and for all by the constructor.
197     function changeList(address _to, bool _onList) onlyOwner public {
198         require(_to != 0x0);
199         if (onList[_to] != _onList) {
200             onList[_to] = _onList;
201             ChangeWhiteList(_to, _onList);
202         }
203     }
204 }
205 
206 contract HasNoContracts is Ownable {
207 
208   /**
209    * @dev Reclaim ownership of Ownable contracts
210    * @param contractAddr The address of the Ownable to be reclaimed.
211    */
212   function reclaimContract(address contractAddr) external onlyOwner {
213     Ownable contractInst = Ownable(contractAddr);
214     contractInst.transferOwnership(owner);
215   }
216 }
217 
218 contract HasNoEther is Ownable {
219 
220   /**
221   * @dev Constructor that rejects incoming Ether
222   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
223   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
224   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
225   * we could use assembly to access msg.value.
226   */
227   function HasNoEther() public payable {
228     require(msg.value == 0);
229   }
230 
231   /**
232    * @dev Disallows direct send by settings a default function without the `payable` flag.
233    */
234   function() external {
235   }
236 
237   /**
238    * @dev Transfer all Ether held by the contract to the owner.
239    */
240   function reclaimEther() external onlyOwner {
241     assert(owner.send(this.balance));
242   }
243 }
244 
245 contract HasNoTokens is CanReclaimToken {
246 
247  /**
248   * @dev Reject all ERC223 compatible tokens
249   * @param from_ address The address that is transferring the tokens
250   * @param value_ uint256 the amount of the specified token
251   * @param data_ Bytes The data passed from the caller.
252   */
253   function tokenFallback(address from_, uint256 value_, bytes data_) external {
254     from_;
255     value_;
256     data_;
257     revert();
258   }
259 
260 }
261 
262 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
263 }
264 
265 contract AllowanceSheet is Claimable {
266     using SafeMath for uint256;
267 
268     mapping (address => mapping (address => uint256)) public allowanceOf;
269 
270     function addAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
271         allowanceOf[tokenHolder][spender] = allowanceOf[tokenHolder][spender].add(value);
272     }
273 
274     function subAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
275         allowanceOf[tokenHolder][spender] = allowanceOf[tokenHolder][spender].sub(value);
276     }
277 
278     function setAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
279         allowanceOf[tokenHolder][spender] = value;
280     }
281 }
282 
283 contract BalanceSheet is Claimable {
284     using SafeMath for uint256;
285 
286     mapping (address => uint256) public balanceOf;
287 
288     function addBalance(address addr, uint256 value) public onlyOwner {
289         balanceOf[addr] = balanceOf[addr].add(value);
290     }
291 
292     function subBalance(address addr, uint256 value) public onlyOwner {
293         balanceOf[addr] = balanceOf[addr].sub(value);
294     }
295 
296     function setBalance(address addr, uint256 value) public onlyOwner {
297         balanceOf[addr] = value;
298     }
299 }
300 
301 contract ERC20Basic {
302   function totalSupply() public view returns (uint256);
303   function balanceOf(address who) public view returns (uint256);
304   function transfer(address to, uint256 value) public returns (bool);
305   event Transfer(address indexed from, address indexed to, uint256 value);
306 }
307 
308 contract BasicToken is ERC20Basic, Claimable {
309   using SafeMath for uint256;
310 
311   BalanceSheet public balances;
312 
313   uint256 totalSupply_;
314 
315   function setBalanceSheet(address sheet) external onlyOwner {
316     balances = BalanceSheet(sheet);
317     balances.claimOwnership();
318   }
319 
320   /**
321   * @dev total number of tokens in existence
322   */
323   function totalSupply() public view returns (uint256) {
324     return totalSupply_;
325   }
326 
327   /**
328   * @dev transfer token for a specified address
329   * @param _to The address to transfer to.
330   * @param _value The amount to be transferred.
331   */
332   function transfer(address _to, uint256 _value) public returns (bool) {
333     transferAllArgsNoAllowance(msg.sender, _to, _value);
334     return true;
335   }
336 
337   function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal {
338     require(_to != address(0));
339     require(_from != address(0));
340     require(_value <= balances.balanceOf(_from));
341 
342     // SafeMath.sub will throw if there is not enough balance.
343     balances.subBalance(_from, _value);
344     balances.addBalance(_to, _value);
345     Transfer(_from, _to, _value);
346   }
347 
348   /**
349   * @dev Gets the balance of the specified address.
350   * @param _owner The address to query the the balance of.
351   * @return An uint256 representing the amount owned by the passed address.
352   */
353   function balanceOf(address _owner) public view returns (uint256 balance) {
354     return balances.balanceOf(_owner);
355   }
356 }
357 
358 contract BurnableToken is BasicToken {
359 
360   event Burn(address indexed burner, uint256 value);
361 
362   /**
363    * @dev Burns a specific amount of tokens.
364    * @param _value The amount of token to be burned.
365    */
366   function burn(uint256 _value) public {
367     require(_value <= balances.balanceOf(msg.sender));
368     // no need to require value <= totalSupply, since that would imply the
369     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
370 
371     address burner = msg.sender;
372     balances.subBalance(burner, _value);
373     totalSupply_ = totalSupply_.sub(_value);
374     Burn(burner, _value);
375     Transfer(burner, address(0), _value);
376   }
377 }
378 
379 contract ERC20 is ERC20Basic {
380   function allowance(address owner, address spender) public view returns (uint256);
381   function transferFrom(address from, address to, uint256 value) public returns (bool);
382   function approve(address spender, uint256 value) public returns (bool);
383   event Approval(address indexed owner, address indexed spender, uint256 value);
384 }
385 
386 library SafeERC20 {
387   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
388     assert(token.transfer(to, value));
389   }
390 
391   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
392     assert(token.transferFrom(from, to, value));
393   }
394 
395   function safeApprove(ERC20 token, address spender, uint256 value) internal {
396     assert(token.approve(spender, value));
397   }
398 }
399 
400 contract StandardToken is ERC20, BasicToken {
401 
402   AllowanceSheet public allowances;
403 
404   function setAllowanceSheet(address sheet) external onlyOwner {
405     allowances = AllowanceSheet(sheet);
406     allowances.claimOwnership();
407   }
408 
409   /**
410    * @dev Transfer tokens from one address to another
411    * @param _from address The address which you want to send tokens from
412    * @param _to address The address which you want to transfer to
413    * @param _value uint256 the amount of tokens to be transferred
414    */
415   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
416     transferAllArgsYesAllowance(_from, _to, _value, msg.sender);
417     return true;
418   }
419 
420   function transferAllArgsYesAllowance(address _from, address _to, uint256 _value, address spender) internal {
421     require(_value <= allowances.allowanceOf(_from, spender));
422 
423     allowances.subAllowance(_from, spender, _value);
424     transferAllArgsNoAllowance(_from, _to, _value);
425   }
426 
427   /**
428    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
429    *
430    * Beware that changing an allowance with this method brings the risk that someone may use both the old
431    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
432    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
433    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
434    * @param _spender The address which will spend the funds.
435    * @param _value The amount of tokens to be spent.
436    */
437   function approve(address _spender, uint256 _value) public returns (bool) {
438     approveAllArgs(_spender, _value, msg.sender);
439     return true;
440   }
441 
442   function approveAllArgs(address _spender, uint256 _value, address _tokenHolder) internal {
443     allowances.setAllowance(_tokenHolder, _spender, _value);
444     Approval(_tokenHolder, _spender, _value);
445   }
446 
447   /**
448    * @dev Function to check the amount of tokens that an owner allowed to a spender.
449    * @param _owner address The address which owns the funds.
450    * @param _spender address The address which will spend the funds.
451    * @return A uint256 specifying the amount of tokens still available for the spender.
452    */
453   function allowance(address _owner, address _spender) public view returns (uint256) {
454     return allowances.allowanceOf(_owner, _spender);
455   }
456 
457   /**
458    * @dev Increase the amount of tokens that an owner allowed to a spender.
459    *
460    * approve should be called when allowed[_spender] == 0. To increment
461    * allowed value is better to use this function to avoid 2 calls (and wait until
462    * the first transaction is mined)
463    * From MonolithDAO Token.sol
464    * @param _spender The address which will spend the funds.
465    * @param _addedValue The amount of tokens to increase the allowance by.
466    */
467   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
468     increaseApprovalAllArgs(_spender, _addedValue, msg.sender);
469     return true;
470   }
471 
472   function increaseApprovalAllArgs(address _spender, uint _addedValue, address tokenHolder) internal {
473     allowances.addAllowance(tokenHolder, _spender, _addedValue);
474     Approval(tokenHolder, _spender, allowances.allowanceOf(tokenHolder, _spender));
475   }
476 
477   /**
478    * @dev Decrease the amount of tokens that an owner allowed to a spender.
479    *
480    * approve should be called when allowed[_spender] == 0. To decrement
481    * allowed value is better to use this function to avoid 2 calls (and wait until
482    * the first transaction is mined)
483    * From MonolithDAO Token.sol
484    * @param _spender The address which will spend the funds.
485    * @param _subtractedValue The amount of tokens to decrease the allowance by.
486    */
487   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
488     decreaseApprovalAllArgs(_spender, _subtractedValue, msg.sender);
489     return true;
490   }
491 
492   function decreaseApprovalAllArgs(address _spender, uint _subtractedValue, address tokenHolder) internal {
493     uint oldValue = allowances.allowanceOf(tokenHolder, _spender);
494     if (_subtractedValue > oldValue) {
495       allowances.setAllowance(tokenHolder, _spender, 0);
496     } else {
497       allowances.subAllowance(tokenHolder, _spender, _subtractedValue);
498     }
499     Approval(tokenHolder, _spender, allowances.allowanceOf(tokenHolder, _spender));
500   }
501 
502 }
503 
504 contract CanDelegate is StandardToken {
505     // If this contract needs to be upgraded, the new contract will be stored
506     // in 'delegate' and any ERC20 calls to this contract will be delegated to that one.
507     DelegateERC20 public delegate;
508 
509     event DelegatedTo(address indexed newContract);
510 
511     // Can undelegate by passing in newContract = address(0)
512     function delegateToNewContract(DelegateERC20 newContract) public onlyOwner {
513         delegate = newContract;
514         DelegatedTo(delegate);
515     }
516 
517     // If a delegate has been designated, all ERC20 calls are forwarded to it
518     function transfer(address to, uint256 value) public returns (bool) {
519         if (delegate == address(0)) {
520             return super.transfer(to, value);
521         } else {
522             return delegate.delegateTransfer(to, value, msg.sender);
523         }
524     }
525 
526     function transferFrom(address from, address to, uint256 value) public returns (bool) {
527         if (delegate == address(0)) {
528             return super.transferFrom(from, to, value);
529         } else {
530             return delegate.delegateTransferFrom(from, to, value, msg.sender);
531         }
532     }
533 
534     function balanceOf(address who) public view returns (uint256) {
535         if (delegate == address(0)) {
536             return super.balanceOf(who);
537         } else {
538             return delegate.delegateBalanceOf(who);
539         }
540     }
541 
542     function approve(address spender, uint256 value) public returns (bool) {
543         if (delegate == address(0)) {
544             return super.approve(spender, value);
545         } else {
546             return delegate.delegateApprove(spender, value, msg.sender);
547         }
548     }
549 
550     function allowance(address _owner, address spender) public view returns (uint256) {
551         if (delegate == address(0)) {
552             return super.allowance(_owner, spender);
553         } else {
554             return delegate.delegateAllowance(_owner, spender);
555         }
556     }
557 
558     function totalSupply() public view returns (uint256) {
559         if (delegate == address(0)) {
560             return super.totalSupply();
561         } else {
562             return delegate.delegateTotalSupply();
563         }
564     }
565 
566     function increaseApproval(address spender, uint addedValue) public returns (bool) {
567         if (delegate == address(0)) {
568             return super.increaseApproval(spender, addedValue);
569         } else {
570             return delegate.delegateIncreaseApproval(spender, addedValue, msg.sender);
571         }
572     }
573 
574     function decreaseApproval(address spender, uint subtractedValue) public returns (bool) {
575         if (delegate == address(0)) {
576             return super.decreaseApproval(spender, subtractedValue);
577         } else {
578             return delegate.delegateDecreaseApproval(spender, subtractedValue, msg.sender);
579         }
580     }
581 }
582 
583 contract StandardDelegate is StandardToken, DelegateERC20 {
584     address public delegatedFrom;
585 
586     modifier onlySender(address source) {
587         require(msg.sender == source);
588         _;
589     }
590 
591     function setDelegatedFrom(address addr) onlyOwner public {
592         delegatedFrom = addr;
593     }
594 
595     // All delegate ERC20 functions are forwarded to corresponding normal functions
596     function delegateTotalSupply() public view returns (uint256) {
597         return totalSupply();
598     }
599 
600     function delegateBalanceOf(address who) public view returns (uint256) {
601         return balanceOf(who);
602     }
603 
604     function delegateTransfer(address to, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
605         transferAllArgsNoAllowance(origSender, to, value);
606         return true;
607     }
608 
609     function delegateAllowance(address owner, address spender) public view returns (uint256) {
610         return allowance(owner, spender);
611     }
612 
613     function delegateTransferFrom(address from, address to, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
614         transferAllArgsYesAllowance(from, to, value, origSender);
615         return true;
616     }
617 
618     function delegateApprove(address spender, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
619         approveAllArgs(spender, value, origSender);
620         return true;
621     }
622 
623     function delegateIncreaseApproval(address spender, uint addedValue, address origSender) onlySender(delegatedFrom) public returns (bool) {
624         increaseApprovalAllArgs(spender, addedValue, origSender);
625         return true;
626     }
627 
628     function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) onlySender(delegatedFrom) public returns (bool) {
629         decreaseApprovalAllArgs(spender, subtractedValue, origSender);
630         return true;
631     }
632 }
633 
634 contract PausableToken is StandardToken, Pausable {
635 
636   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
637     return super.transfer(_to, _value);
638   }
639 
640   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
641     return super.transferFrom(_from, _to, _value);
642   }
643 
644   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
645     return super.approve(_spender, _value);
646   }
647 
648   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
649     return super.increaseApproval(_spender, _addedValue);
650   }
651 
652   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
653     return super.decreaseApproval(_spender, _subtractedValue);
654   }
655 }
656 
657 contract USDDigital is StandardDelegate, PausableToken, BurnableToken, NoOwner, CanDelegate {
658     string public name = "USDDigital";
659     string public symbol = "USDD";
660     uint8 public constant decimals = 18;
661 
662     AddressList public canReceiveMintWhiteList;
663     AddressList public canBurnWhiteList;
664     AddressList public blackList;
665     AddressList public noFeesList;
666     uint256 public burnMin = 10000 * 10**uint256(decimals);
667     uint256 public burnMax = 20000000 * 10**uint256(decimals);
668 
669     uint80 public transferFeeNumerator = 7;
670     uint80 public transferFeeDenominator = 10000;
671     uint80 public mintFeeNumerator = 0;
672     uint80 public mintFeeDenominator = 10000;
673     uint256 public mintFeeFlat = 0;
674     uint80 public burnFeeNumerator = 0;
675     uint80 public burnFeeDenominator = 10000;
676     uint256 public burnFeeFlat = 0;
677     address public staker;
678 
679     event ChangeBurnBoundsEvent(uint256 newMin, uint256 newMax);
680     event Mint(address indexed to, uint256 amount);
681     event WipedAccount(address indexed account, uint256 balance);
682 
683     function USDDigital() public {
684         totalSupply_ = 0;
685         staker = msg.sender;
686     }
687 
688     function setLists(AddressList _canReceiveMintWhiteList, AddressList _canBurnWhiteList, AddressList _blackList, AddressList _noFeesList) onlyOwner public {
689         canReceiveMintWhiteList = _canReceiveMintWhiteList;
690         canBurnWhiteList = _canBurnWhiteList;
691         blackList = _blackList;
692         noFeesList = _noFeesList;
693     }
694 
695     function changeName(string _name, string _symbol) onlyOwner public {
696         name = _name;
697         symbol = _symbol;
698     }
699 
700     //Burning functions as withdrawing money from the system. The platform will keep track of who burns coins,
701     //and will send them back the equivalent amount of money (rounded down to the nearest cent).
702     function burn(uint256 _value) public {
703         require(canBurnWhiteList.onList(msg.sender));
704         require(_value >= burnMin);
705         require(_value <= burnMax);
706         uint256 fee = payStakingFee(msg.sender, _value, burnFeeNumerator, burnFeeDenominator, burnFeeFlat, 0x0);
707         uint256 remaining = _value.sub(fee);
708         super.burn(remaining);
709     }
710 
711     //Create _amount new tokens and transfer them to _to.
712     //Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/MintableToken.sol
713     function mint(address _to, uint256 _amount) onlyOwner public {
714         require(canReceiveMintWhiteList.onList(_to));
715         totalSupply_ = totalSupply_.add(_amount);
716         balances.addBalance(_to, _amount);
717         Mint(_to, _amount);
718         Transfer(address(0), _to, _amount);
719         payStakingFee(_to, _amount, mintFeeNumerator, mintFeeDenominator, mintFeeFlat, 0x0);
720     }
721 
722     //Change the minimum and maximum amount that can be burned at once. Burning
723     //may be disabled by setting both to 0 (this will not be done under normal
724     //operation, but we can't add checks to disallow it without losing a lot of
725     //flexibility since burning could also be as good as disabled
726     //by setting the minimum extremely high, and we don't want to lock
727     //in any particular cap for the minimum)
728     function changeBurnBounds(uint newMin, uint newMax) onlyOwner public {
729         require(newMin <= newMax);
730         burnMin = newMin;
731         burnMax = newMax;
732         ChangeBurnBoundsEvent(newMin, newMax);
733     }
734 
735     // transfer and transferFrom are both dispatched to this function, so we
736     // check blacklist and pay staking fee here.
737     function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal {
738         require(!blackList.onList(_from));
739         require(!blackList.onList(_to));
740         super.transferAllArgsNoAllowance(_from, _to, _value);
741         payStakingFee(_to, _value, transferFeeNumerator, transferFeeDenominator, 0, _from);
742     }
743 
744     function wipeBlacklistedAccount(address account) public onlyOwner {
745         require(blackList.onList(account));
746         uint256 oldValue = balanceOf(account);
747         balances.setBalance(account, 0);
748         totalSupply_ = totalSupply_.sub(oldValue);
749         WipedAccount(account, oldValue);
750     }
751 
752     function payStakingFee(address payer, uint256 value, uint80 numerator, uint80 denominator, uint256 flatRate, address otherParticipant) private returns (uint256) {
753         if (noFeesList.onList(payer) || noFeesList.onList(otherParticipant)) {
754             return 0;
755         }
756         uint256 stakingFee = value.mul(numerator).div(denominator).add(flatRate);
757         if (stakingFee > 0) {
758             super.transferAllArgsNoAllowance(payer, staker, stakingFee);
759         }
760         return stakingFee;
761     }
762 
763     function changeStakingFees(uint80 _transferFeeNumerator,
764                                  uint80 _transferFeeDenominator,
765                                  uint80 _mintFeeNumerator,
766                                  uint80 _mintFeeDenominator,
767                                  uint256 _mintFeeFlat,
768                                  uint80 _burnFeeNumerator,
769                                  uint80 _burnFeeDenominator,
770                                  uint256 _burnFeeFlat) public onlyOwner {
771         require(_transferFeeDenominator != 0);
772         require(_mintFeeDenominator != 0);
773         require(_burnFeeDenominator != 0);
774         transferFeeNumerator = _transferFeeNumerator;
775         transferFeeDenominator = _transferFeeDenominator;
776         mintFeeNumerator = _mintFeeNumerator;
777         mintFeeDenominator = _mintFeeDenominator;
778         mintFeeFlat = _mintFeeFlat;
779         burnFeeNumerator = _burnFeeNumerator;
780         burnFeeDenominator = _burnFeeDenominator;
781         burnFeeFlat = _burnFeeFlat;
782     }
783 
784     function changeStaker(address newStaker) public onlyOwner {
785         require(newStaker != address(0));
786         staker = newStaker;
787     }
788 }