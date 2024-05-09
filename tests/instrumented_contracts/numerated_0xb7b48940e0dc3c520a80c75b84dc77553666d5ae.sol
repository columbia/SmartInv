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
254 contract ERC20Basic {
255   function totalSupply() public view returns (uint256);
256   function balanceOf(address who) public view returns (uint256);
257   function transfer(address to, uint256 value) public returns (bool);
258   event Transfer(address indexed from, address indexed to, uint256 value);
259 }
260 
261 contract BasicToken is ERC20Basic {
262   using SafeMath for uint256;
263 
264   mapping(address => uint256) balances;
265 
266   uint256 totalSupply_;
267 
268   /**
269   * @dev total number of tokens in existence
270   */
271   function totalSupply() public view returns (uint256) {
272     return totalSupply_;
273   }
274 
275   /**
276   * @dev transfer token for a specified address
277   * @param _to The address to transfer to.
278   * @param _value The amount to be transferred.
279   */
280   function transfer(address _to, uint256 _value) public returns (bool) {
281     require(_to != address(0));
282     require(_value <= balances[msg.sender]);
283 
284     // SafeMath.sub will throw if there is not enough balance.
285     balances[msg.sender] = balances[msg.sender].sub(_value);
286     balances[_to] = balances[_to].add(_value);
287     Transfer(msg.sender, _to, _value);
288     return true;
289   }
290 
291   /**
292   * @dev Gets the balance of the specified address.
293   * @param _owner The address to query the the balance of.
294   * @return An uint256 representing the amount owned by the passed address.
295   */
296   function balanceOf(address _owner) public view returns (uint256 balance) {
297     return balances[_owner];
298   }
299 
300 }
301 
302 contract BurnableToken is BasicToken {
303 
304   event Burn(address indexed burner, uint256 value);
305 
306   /**
307    * @dev Burns a specific amount of tokens.
308    * @param _value The amount of token to be burned.
309    */
310   function burn(uint256 _value) public {
311     require(_value <= balances[msg.sender]);
312     // no need to require value <= totalSupply, since that would imply the
313     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
314 
315     address burner = msg.sender;
316     balances[burner] = balances[burner].sub(_value);
317     totalSupply_ = totalSupply_.sub(_value);
318     Burn(burner, _value);
319   }
320 }
321 
322 contract ERC20 is ERC20Basic {
323   function allowance(address owner, address spender) public view returns (uint256);
324   function transferFrom(address from, address to, uint256 value) public returns (bool);
325   function approve(address spender, uint256 value) public returns (bool);
326   event Approval(address indexed owner, address indexed spender, uint256 value);
327 }
328 
329 library SafeERC20 {
330   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
331     assert(token.transfer(to, value));
332   }
333 
334   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
335     assert(token.transferFrom(from, to, value));
336   }
337 
338   function safeApprove(ERC20 token, address spender, uint256 value) internal {
339     assert(token.approve(spender, value));
340   }
341 }
342 
343 contract StandardToken is ERC20, BasicToken {
344 
345   mapping (address => mapping (address => uint256)) internal allowed;
346 
347 
348   /**
349    * @dev Transfer tokens from one address to another
350    * @param _from address The address which you want to send tokens from
351    * @param _to address The address which you want to transfer to
352    * @param _value uint256 the amount of tokens to be transferred
353    */
354   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
355     require(_to != address(0));
356     require(_value <= balances[_from]);
357     require(_value <= allowed[_from][msg.sender]);
358 
359     balances[_from] = balances[_from].sub(_value);
360     balances[_to] = balances[_to].add(_value);
361     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
362     Transfer(_from, _to, _value);
363     return true;
364   }
365 
366   /**
367    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
368    *
369    * Beware that changing an allowance with this method brings the risk that someone may use both the old
370    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
371    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
372    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
373    * @param _spender The address which will spend the funds.
374    * @param _value The amount of tokens to be spent.
375    */
376   function approve(address _spender, uint256 _value) public returns (bool) {
377     allowed[msg.sender][_spender] = _value;
378     Approval(msg.sender, _spender, _value);
379     return true;
380   }
381 
382   /**
383    * @dev Function to check the amount of tokens that an owner allowed to a spender.
384    * @param _owner address The address which owns the funds.
385    * @param _spender address The address which will spend the funds.
386    * @return A uint256 specifying the amount of tokens still available for the spender.
387    */
388   function allowance(address _owner, address _spender) public view returns (uint256) {
389     return allowed[_owner][_spender];
390   }
391 
392   /**
393    * @dev Increase the amount of tokens that an owner allowed to a spender.
394    *
395    * approve should be called when allowed[_spender] == 0. To increment
396    * allowed value is better to use this function to avoid 2 calls (and wait until
397    * the first transaction is mined)
398    * From MonolithDAO Token.sol
399    * @param _spender The address which will spend the funds.
400    * @param _addedValue The amount of tokens to increase the allowance by.
401    */
402   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
403     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
404     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
405     return true;
406   }
407 
408   /**
409    * @dev Decrease the amount of tokens that an owner allowed to a spender.
410    *
411    * approve should be called when allowed[_spender] == 0. To decrement
412    * allowed value is better to use this function to avoid 2 calls (and wait until
413    * the first transaction is mined)
414    * From MonolithDAO Token.sol
415    * @param _spender The address which will spend the funds.
416    * @param _subtractedValue The amount of tokens to decrease the allowance by.
417    */
418   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
419     uint oldValue = allowed[msg.sender][_spender];
420     if (_subtractedValue > oldValue) {
421       allowed[msg.sender][_spender] = 0;
422     } else {
423       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
424     }
425     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
426     return true;
427   }
428 
429 }
430 
431 contract PausableToken is StandardToken, Pausable {
432 
433   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
434     return super.transfer(_to, _value);
435   }
436 
437   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
438     return super.transferFrom(_from, _to, _value);
439   }
440 
441   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
442     return super.approve(_spender, _value);
443   }
444 
445   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
446     return super.increaseApproval(_spender, _addedValue);
447   }
448 
449   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
450     return super.decreaseApproval(_spender, _subtractedValue);
451   }
452 }
453 
454 contract TrueUSD is PausableToken, BurnableToken, NoOwner, Claimable {
455     string public constant name = "TrueUSD";
456     string public constant symbol = "TUSD";
457     uint8 public constant decimals = 18;
458 
459     AddressList public canReceiveMintWhitelist;
460     AddressList public canBurnWhiteList;
461     AddressList public blackList;
462     uint256 public burnMin = 10000 * 10**uint256(decimals);
463     uint256 public burnMax = 20000000 * 10**uint256(decimals);
464 
465     uint80 public transferFeeNumerator = 7;
466     uint80 public transferFeeDenominator = 10000;
467     uint80 public mintFeeNumerator = 0;
468     uint80 public mintFeeDenominator = 10000;
469     uint256 public mintFeeFlat = 0;
470     uint80 public burnFeeNumerator = 0;
471     uint80 public burnFeeDenominator = 10000;
472     uint256 public burnFeeFlat = 0;
473     address public insurer;
474 
475     // If this contract needs to be upgraded, the new contract will be stored
476     // in 'delegate' and any ERC20 calls to this contract will be delegated to that one.
477     DelegateERC20 public delegate;
478 
479     event ChangeBurnBoundsEvent(uint256 newMin, uint256 newMax);
480     event Mint(address indexed to, uint256 amount);
481     event WipedAccount(address indexed account, uint256 balance);
482     event DelegatedTo(address indexed newContract);
483 
484     function TrueUSD(address _canMintWhiteList, address _canBurnWhiteList, address _blackList) public {
485         totalSupply_ = 0;
486         canReceiveMintWhitelist = AddressList(_canMintWhiteList);
487         canBurnWhiteList = AddressList(_canBurnWhiteList);
488         blackList = AddressList(_blackList);
489         insurer = msg.sender;
490     }
491 
492     //Burning functions as withdrawing money from the system. The platform will keep track of who burns coins,
493     //and will send them back the equivalent amount of money (rounded down to the nearest cent).
494     function burn(uint256 _value) public {
495         require(canBurnWhiteList.onList(msg.sender));
496         require(_value >= burnMin);
497         require(_value <= burnMax);
498         uint256 fee = payInsuranceFee(msg.sender, _value, burnFeeNumerator, burnFeeDenominator, burnFeeFlat);
499         uint256 remaining = _value.sub(fee);
500         super.burn(remaining);
501     }
502 
503     //Create _amount new tokens and transfer them to _to.
504     //Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/MintableToken.sol
505     function mint(address _to, uint256 _amount) onlyOwner public {
506         require(canReceiveMintWhitelist.onList(_to));
507         totalSupply_ = totalSupply_.add(_amount);
508         balances[_to] = balances[_to].add(_amount);
509         Mint(_to, _amount);
510         Transfer(address(0), _to, _amount);
511         payInsuranceFee(_to, _amount, mintFeeNumerator, mintFeeDenominator, mintFeeFlat);
512     }
513 
514     //Change the minimum and maximum amount that can be burned at once. Burning
515     //may be disabled by setting both to 0 (this will not be done under normal
516     //operation, but we can't add checks to disallow it without losing a lot of
517     //flexibility since burning could also be as good as disabled
518     //by setting the minimum extremely high, and we don't want to lock
519     //in any particular cap for the minimum)
520     function changeBurnBounds(uint newMin, uint newMax) onlyOwner public {
521         require(newMin <= newMax);
522         burnMin = newMin;
523         burnMax = newMax;
524         ChangeBurnBoundsEvent(newMin, newMax);
525     }
526 
527     function transfer(address to, uint256 value) public returns (bool) {
528         require(!blackList.onList(msg.sender));
529         require(!blackList.onList(to));
530         if (delegate == address(0)) {
531             bool result = super.transfer(to, value);
532             payInsuranceFee(to, value, transferFeeNumerator, transferFeeDenominator, 0);
533             return result;
534         } else {
535             return delegate.delegateTransfer(to, value, msg.sender);
536         }
537     }
538 
539     function transferFrom(address from, address to, uint256 value) public returns (bool) {
540         require(!blackList.onList(from));
541         require(!blackList.onList(to));
542         if (delegate == address(0)) {
543             bool result = super.transferFrom(from, to, value);
544             payInsuranceFee(to, value, transferFeeNumerator, transferFeeDenominator, 0);
545             return result;
546         } else {
547             return delegate.delegateTransferFrom(from, to, value, msg.sender);
548         }
549     }
550 
551     function balanceOf(address who) public view returns (uint256) {
552         if (delegate == address(0)) {
553             return super.balanceOf(who);
554         } else {
555             return delegate.delegateBalanceOf(who);
556         }
557     }
558 
559     function approve(address spender, uint256 value) public returns (bool) {
560         if (delegate == address(0)) {
561             return super.approve(spender, value);
562         } else {
563             return delegate.delegateApprove(spender, value, msg.sender);
564         }
565     }
566 
567     function allowance(address _owner, address spender) public view returns (uint256) {
568         if (delegate == address(0)) {
569             return super.allowance(_owner, spender);
570         } else {
571             return delegate.delegateAllowance(_owner, spender);
572         }
573     }
574 
575     function totalSupply() public view returns (uint256) {
576         if (delegate == address(0)) {
577             return super.totalSupply();
578         } else {
579             return delegate.delegateTotalSupply();
580         }
581     }
582 
583     function increaseApproval(address spender, uint addedValue) public returns (bool) {
584         if (delegate == address(0)) {
585             return super.increaseApproval(spender, addedValue);
586         } else {
587             return delegate.delegateIncreaseApproval(spender, addedValue, msg.sender);
588         }
589     }
590 
591     function decreaseApproval(address spender, uint subtractedValue) public returns (bool) {
592         if (delegate == address(0)) {
593             return super.decreaseApproval(spender, subtractedValue);
594         } else {
595             return delegate.delegateDecreaseApproval(spender, subtractedValue, msg.sender);
596         }
597     }
598 
599     function wipeBlacklistedAccount(address account) public onlyOwner {
600         require(blackList.onList(account));
601         uint256 oldValue = balanceOf(account);
602         balances[account] = 0;
603         totalSupply_ = totalSupply_.sub(oldValue);
604         WipedAccount(account, oldValue);
605     }
606 
607     function payInsuranceFee(address payer, uint256 value, uint80 numerator, uint80 denominator, uint256 flatRate) private returns (uint256) {
608         uint256 insuranceFee = value.mul(numerator).div(denominator).add(flatRate);
609         if (insuranceFee > 0) {
610             transferFromWithoutAllowance(payer, insurer, insuranceFee);
611         }
612         return insuranceFee;
613     }
614 
615     // based on 'transfer' in https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
616     function transferFromWithoutAllowance(address from, address _to, uint256 _value) private {
617         assert(_to != address(0));
618         assert(_value <= balances[from]);
619         balances[from] = balances[from].sub(_value);
620         balances[_to] = balances[_to].add(_value);
621         Transfer(from, _to, _value);
622     }
623 
624     function changeInsuranceFees(uint80 _transferFeeNumerator,
625                                  uint80 _transferFeeDenominator,
626                                  uint80 _mintFeeNumerator,
627                                  uint80 _mintFeeDenominator,
628                                  uint256 _mintFeeFlat,
629                                  uint80 _burnFeeNumerator,
630                                  uint80 _burnFeeDenominator,
631                                  uint256 _burnFeeFlat) public onlyOwner {
632         require(_transferFeeDenominator != 0);
633         require(_mintFeeDenominator != 0);
634         require(_burnFeeDenominator != 0);
635         transferFeeNumerator = _transferFeeNumerator;
636         transferFeeDenominator = _transferFeeDenominator;
637         mintFeeNumerator = _mintFeeNumerator;
638         mintFeeDenominator = _mintFeeDenominator;
639         mintFeeFlat = _mintFeeFlat;
640         burnFeeNumerator = _burnFeeNumerator;
641         burnFeeDenominator = _burnFeeDenominator;
642         burnFeeFlat = _burnFeeFlat;
643     }
644 
645     function changeInsurer(address newInsurer) public onlyOwner {
646         require(newInsurer != address(0));
647         insurer = newInsurer;
648     }
649 
650     // Can undelegate by passing in newContract = address(0)
651     function delegateToNewContract(address newContract) public onlyOwner {
652         delegate = DelegateERC20(newContract);
653         DelegatedTo(newContract);
654     }
655 }