1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23 
24   /**
25   * @dev Multiplies two numbers, throws on overflow.
26   */
27   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28     if (a == 0) {
29       return 0;
30     }
31     uint256 c = a * b;
32     assert(c / a == b);
33     return c;
34   }
35 
36   /**
37   * @dev Integer division of two numbers, truncating the quotient.
38   */
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   /**
47   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
48   */
49   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   /**
55   * @dev Adds two numbers, throws on overflow.
56   */
57   function add(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a + b;
59     assert(c >= a);
60     return c;
61   }
62 }
63 
64 
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   uint256 totalSupply_;
76 
77   /**
78   * @dev total number of tokens in existence
79   */
80   function totalSupply() public view returns (uint256) {
81     return totalSupply_;
82   }
83 
84   /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     // SafeMath.sub will throw if there is not enough balance.
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256 balance) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 
112 
113 
114 
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20 is ERC20Basic {
121   function allowance(address owner, address spender) public view returns (uint256);
122   function transferFrom(address from, address to, uint256 value) public returns (bool);
123   function approve(address spender, uint256 value) public returns (bool);
124   event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 
128 
129 /**
130  * @title Standard ERC20 token
131  *
132  * @dev Implementation of the basic standard token.
133  * @dev https://github.com/ethereum/EIPs/issues/20
134  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
135  */
136 contract StandardToken is ERC20, BasicToken {
137 
138   mapping (address => mapping (address => uint256)) internal allowed;
139 
140 
141   /**
142    * @dev Transfer tokens from one address to another
143    * @param _from address The address which you want to send tokens from
144    * @param _to address The address which you want to transfer to
145    * @param _value uint256 the amount of tokens to be transferred
146    */
147   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
148     require(_to != address(0));
149     require(_value <= balances[_from]);
150     require(_value <= allowed[_from][msg.sender]);
151 
152     balances[_from] = balances[_from].sub(_value);
153     balances[_to] = balances[_to].add(_value);
154     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
155     Transfer(_from, _to, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
161    *
162    * Beware that changing an allowance with this method brings the risk that someone may use both the old
163    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
164    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
165    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166    * @param _spender The address which will spend the funds.
167    * @param _value The amount of tokens to be spent.
168    */
169   function approve(address _spender, uint256 _value) public returns (bool) {
170     allowed[msg.sender][_spender] = _value;
171     Approval(msg.sender, _spender, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Function to check the amount of tokens that an owner allowed to a spender.
177    * @param _owner address The address which owns the funds.
178    * @param _spender address The address which will spend the funds.
179    * @return A uint256 specifying the amount of tokens still available for the spender.
180    */
181   function allowance(address _owner, address _spender) public view returns (uint256) {
182     return allowed[_owner][_spender];
183   }
184 
185   /**
186    * @dev Increase the amount of tokens that an owner allowed to a spender.
187    *
188    * approve should be called when allowed[_spender] == 0. To increment
189    * allowed value is better to use this function to avoid 2 calls (and wait until
190    * the first transaction is mined)
191    * From MonolithDAO Token.sol
192    * @param _spender The address which will spend the funds.
193    * @param _addedValue The amount of tokens to increase the allowance by.
194    */
195   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
196     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
197     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198     return true;
199   }
200 
201   /**
202    * @dev Decrease the amount of tokens that an owner allowed to a spender.
203    *
204    * approve should be called when allowed[_spender] == 0. To decrement
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _subtractedValue The amount of tokens to decrease the allowance by.
210    */
211   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
212     uint oldValue = allowed[msg.sender][_spender];
213     if (_subtractedValue > oldValue) {
214       allowed[msg.sender][_spender] = 0;
215     } else {
216       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
217     }
218     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 
222 }
223 
224 
225 /**
226  * @title Ownable
227  * @dev The Ownable contract has an owner address, and provides basic authorization control
228  * functions, this simplifies the implementation of "user permissions".
229  */
230 contract Ownable {
231   address public owner;
232 
233 
234   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
235 
236 
237   /**
238    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
239    * account.
240    */
241   function Ownable() public {
242     owner = msg.sender;
243   }
244 
245   /**
246    * @dev Throws if called by any account other than the owner.
247    */
248   modifier onlyOwner() {
249     require(msg.sender == owner);
250     _;
251   }
252 
253   /**
254    * @dev Allows the current owner to transfer control of the contract to a newOwner.
255    * @param newOwner The address to transfer ownership to.
256    */
257   function transferOwnership(address newOwner) public onlyOwner {
258     require(newOwner != address(0));
259     OwnershipTransferred(owner, newOwner);
260     owner = newOwner;
261   }
262 
263 }
264 
265 
266 contract Whitelist is Ownable {
267     mapping(address => bool) whitelist;
268     event AddedToWhitelist(address indexed account);
269     event RemovedFromWhitelist(address indexed account);
270 
271     modifier onlyWhitelisted() {
272         require(isWhitelisted(msg.sender));
273         _;
274     }
275 
276     function add(address _address) public onlyOwner {
277         whitelist[_address] = true;
278         emit AddedToWhitelist(_address);
279     }
280 
281     function remove(address _address) public onlyOwner {
282         whitelist[_address] = false;
283         emit RemovedFromWhitelist(_address);
284     }
285 
286     function isWhitelisted(address _address) public view returns(bool) {
287         return whitelist[_address];
288     }
289 }
290 
291 contract LockingContract is Ownable {
292     using SafeMath for uint256;
293 
294     event NotedTokens(address indexed _beneficiary, uint256 _tokenAmount);
295     event ReleasedTokens(address indexed _beneficiary);
296     event ReducedLockingTime(uint256 _newUnlockTime);
297 
298     ERC20 public tokenContract;
299     mapping(address => uint256) public tokens;
300     uint256 public totalTokens;
301     uint256 public unlockTime;
302 
303     function isLocked() public view returns(bool) {
304         return now < unlockTime;
305     }
306 
307     modifier onlyWhenUnlocked() {
308         require(!isLocked());
309         _;
310     }
311 
312     modifier onlyWhenLocked() {
313         require(isLocked());
314         _;
315     }
316 
317     function LockingContract(ERC20 _tokenContract, uint256 _unlockTime) public {
318         require(_unlockTime > now);
319         require(address(_tokenContract) != 0x0);
320         unlockTime = _unlockTime;
321         tokenContract = _tokenContract;
322     }
323 
324     function balanceOf(address _owner) public view returns (uint256 balance) {
325         return tokens[_owner];
326     }
327 
328     // Should only be done from another contract.
329     // To ensure that the LockingContract can release all noted tokens later,
330     // one should mint/transfer tokens to the LockingContract's account prior to noting
331     function noteTokens(address _beneficiary, uint256 _tokenAmount) external onlyOwner onlyWhenLocked {
332         uint256 tokenBalance = tokenContract.balanceOf(this);
333         require(tokenBalance >= totalTokens.add(_tokenAmount));
334 
335         tokens[_beneficiary] = tokens[_beneficiary].add(_tokenAmount);
336         totalTokens = totalTokens.add(_tokenAmount);
337         emit NotedTokens(_beneficiary, _tokenAmount);
338     }
339 
340     function releaseTokens(address _beneficiary) public onlyWhenUnlocked {
341         require(msg.sender == owner || msg.sender == _beneficiary);
342         uint256 amount = tokens[_beneficiary];
343         tokens[_beneficiary] = 0;
344         require(tokenContract.transfer(_beneficiary, amount)); 
345         totalTokens = totalTokens.sub(amount);
346         emit ReleasedTokens(_beneficiary);
347     }
348 
349     function reduceLockingTime(uint256 _newUnlockTime) public onlyOwner onlyWhenLocked {
350         require(_newUnlockTime >= now);
351         require(_newUnlockTime < unlockTime);
352         unlockTime = _newUnlockTime;
353         emit ReducedLockingTime(_newUnlockTime);
354     }
355 }
356 
357 
358 
359 
360 /**
361  * @title Mintable token
362  * @dev Simple ERC20 Token example, with mintable token creation
363  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
364  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
365  */
366 contract MintableToken is StandardToken, Ownable {
367   event Mint(address indexed to, uint256 amount);
368   event MintFinished();
369 
370   bool public mintingFinished = false;
371 
372 
373   modifier canMint() {
374     require(!mintingFinished);
375     _;
376   }
377 
378   /**
379    * @dev Function to mint tokens
380    * @param _to The address that will receive the minted tokens.
381    * @param _amount The amount of tokens to mint.
382    * @return A boolean that indicates if the operation was successful.
383    */
384   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
385     totalSupply_ = totalSupply_.add(_amount);
386     balances[_to] = balances[_to].add(_amount);
387     Mint(_to, _amount);
388     Transfer(address(0), _to, _amount);
389     return true;
390   }
391 
392   /**
393    * @dev Function to stop minting new tokens.
394    * @return True if the operation was successful.
395    */
396   function finishMinting() onlyOwner canMint public returns (bool) {
397     mintingFinished = true;
398     MintFinished();
399     return true;
400   }
401 }
402 
403 
404 contract CrowdfundableToken is MintableToken {
405     string public name;
406     string public symbol;
407     uint8 public decimals;
408     uint256 public cap;
409 
410     function CrowdfundableToken(uint256 _cap, string _name, string _symbol, uint8 _decimals) public {
411         require(_cap > 0);
412         require(bytes(_name).length > 0);
413         require(bytes(_symbol).length > 0);
414         cap = _cap;
415         name = _name;
416         symbol = _symbol;
417         decimals = _decimals;
418     }
419 
420     // override
421     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
422         require(totalSupply_.add(_amount) <= cap);
423         return super.mint(_to, _amount);
424     }
425 
426     // override
427     function transfer(address _to, uint256 _value) public returns (bool) {
428         require(mintingFinished == true);
429         return super.transfer(_to, _value);
430     }
431 
432     // override
433     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
434         require(mintingFinished == true);
435         return super.transferFrom(_from, _to, _value);
436     }
437 
438     function burn(uint amount) public {
439         totalSupply_ = totalSupply_.sub(amount);
440         balances[msg.sender] = balances[msg.sender].sub(amount);
441     }
442 }
443 
444 contract AllSporterCoin is CrowdfundableToken {
445     constructor() public 
446         CrowdfundableToken(260000000 * (10**18), "AllSporter Coin", "ALL", 18) {
447     }
448 }
449 
450 
451 contract Minter is Ownable {
452     using SafeMath for uint;
453 
454     /* --- EVENTS --- */
455 
456     event Minted(address indexed account, uint etherAmount, uint tokenAmount);
457     event Reserved(uint etherAmount);
458     event MintedReserved(address indexed account, uint etherAmount, uint tokenAmount);
459     event Unreserved(uint etherAmount);
460 
461     /* --- FIELDS --- */
462 
463     CrowdfundableToken public token;
464     uint public saleEtherCap;
465     uint public confirmedSaleEther;
466     uint public reservedSaleEther;
467 
468     /* --- MODIFIERS --- */
469 
470     modifier onlyInUpdatedState() {
471         updateState();
472         _;
473     }
474 
475     modifier upToSaleEtherCap(uint additionalEtherAmount) {
476         uint totalEtherAmount = confirmedSaleEther.add(reservedSaleEther).add(additionalEtherAmount);
477         require(totalEtherAmount <= saleEtherCap);
478         _;
479     }
480 
481     modifier onlyApprovedMinter() {
482         require(canMint(msg.sender));
483         _;
484     }
485 
486     modifier atLeastMinimumAmount(uint etherAmount) {
487         require(etherAmount >= getMinimumContribution());
488         _;
489     }
490 
491     modifier onlyValidAddress(address account) {
492         require(account != 0x0);
493         _;
494     }
495 
496     /* --- CONSTRUCTOR --- */
497 
498     constructor(CrowdfundableToken _token, uint _saleEtherCap) public onlyValidAddress(address(_token)) {
499         require(_saleEtherCap > 0);
500 
501         token = _token;
502         saleEtherCap = _saleEtherCap;
503     }
504 
505     /* --- PUBLIC / EXTERNAL METHODS --- */
506 
507     function transferTokenOwnership() external onlyOwner {
508         token.transferOwnership(owner);
509     }
510 
511     function reserve(uint etherAmount) external
512         onlyInUpdatedState
513         onlyApprovedMinter
514         upToSaleEtherCap(etherAmount)
515         atLeastMinimumAmount(etherAmount)
516     {
517         reservedSaleEther = reservedSaleEther.add(etherAmount);
518         updateState();
519         emit Reserved(etherAmount);
520     }
521 
522     function mintReserved(address account, uint etherAmount, uint tokenAmount) external
523         onlyInUpdatedState
524         onlyApprovedMinter
525     {
526         reservedSaleEther = reservedSaleEther.sub(etherAmount);
527         confirmedSaleEther = confirmedSaleEther.add(etherAmount);
528         require(token.mint(account, tokenAmount));
529         updateState();
530         emit MintedReserved(account, etherAmount, tokenAmount);
531     }
532 
533     function unreserve(uint etherAmount) public
534         onlyInUpdatedState
535         onlyApprovedMinter
536     {
537         reservedSaleEther = reservedSaleEther.sub(etherAmount);
538         updateState();
539         emit Unreserved(etherAmount);
540     }
541 
542     function mint(address account, uint etherAmount, uint tokenAmount) public
543         onlyInUpdatedState
544         onlyApprovedMinter
545         upToSaleEtherCap(etherAmount)
546     {
547         confirmedSaleEther = confirmedSaleEther.add(etherAmount);
548         require(token.mint(account, tokenAmount));
549         updateState();
550         emit Minted(account, etherAmount, tokenAmount);
551     }
552 
553     // abstract
554     function getMinimumContribution() public view returns(uint);
555 
556     // abstract
557     function updateState() public;
558 
559     // abstract
560     function canMint(address sender) public view returns(bool);
561 
562     // abstract
563     function getTokensForEther(uint etherAmount) public view returns(uint);
564 }
565 
566 contract DeferredKyc is Ownable {
567     using SafeMath for uint;
568 
569     /* --- EVENTS --- */
570 
571     event AddedToKyc(address indexed investor, uint etherAmount, uint tokenAmount);
572     event Approved(address indexed investor, uint etherAmount, uint tokenAmount);
573     event Rejected(address indexed investor, uint etherAmount, uint tokenAmount);
574     event RejectedWithdrawn(address indexed investor, uint etherAmount);
575     event ApproverTransferred(address newApprover);
576     event TreasuryUpdated(address newTreasury);
577 
578     /* --- FIELDS --- */
579 
580     address public treasury;
581     Minter public minter;
582     address public approver;
583     mapping(address => uint) public etherInProgress;
584     mapping(address => uint) public tokenInProgress;
585     mapping(address => uint) public etherRejected;
586 
587     /* --- MODIFIERS --- */ 
588 
589     modifier onlyApprover() {
590         require(msg.sender == approver);
591         _;
592     }
593 
594     modifier onlyValidAddress(address account) {
595         require(account != 0x0);
596         _;
597     }
598 
599     /* --- CONSTRUCTOR --- */
600 
601     constructor(Minter _minter, address _approver, address _treasury)
602         public
603         onlyValidAddress(address(_minter))
604         onlyValidAddress(_approver)
605         onlyValidAddress(_treasury)
606     {
607         minter = _minter;
608         approver = _approver;
609         treasury = _treasury;
610     }
611 
612     /* --- PUBLIC / EXTERNAL METHODS --- */
613 
614     function updateTreasury(address newTreasury) external onlyOwner {
615         treasury = newTreasury;
616         emit TreasuryUpdated(newTreasury);
617     }
618 
619     function addToKyc(address investor) external payable onlyOwner {
620         minter.reserve(msg.value);
621         uint tokenAmount = minter.getTokensForEther(msg.value);
622         require(tokenAmount > 0);
623         emit AddedToKyc(investor, msg.value, tokenAmount);
624 
625         etherInProgress[investor] = etherInProgress[investor].add(msg.value);
626         tokenInProgress[investor] = tokenInProgress[investor].add(tokenAmount);
627     }
628 
629     function approve(address investor) external onlyApprover {
630         minter.mintReserved(investor, etherInProgress[investor], tokenInProgress[investor]);
631         emit Approved(investor, etherInProgress[investor], tokenInProgress[investor]);
632         
633         uint value = etherInProgress[investor];
634         etherInProgress[investor] = 0;
635         tokenInProgress[investor] = 0;
636         treasury.transfer(value);
637     }
638 
639     function reject(address investor) external onlyApprover {
640         minter.unreserve(etherInProgress[investor]);
641         emit Rejected(investor, etherInProgress[investor], tokenInProgress[investor]);
642 
643         etherRejected[investor] = etherRejected[investor].add(etherInProgress[investor]);
644         etherInProgress[investor] = 0;
645         tokenInProgress[investor] = 0;
646     }
647 
648     function withdrawRejected() external {
649         uint value = etherRejected[msg.sender];
650         etherRejected[msg.sender] = 0;
651         (msg.sender).transfer(value);
652         emit RejectedWithdrawn(msg.sender, value);
653     }
654 
655     function forceWithdrawRejected(address investor) external onlyApprover {
656         uint value = etherRejected[investor];
657         etherRejected[investor] = 0;
658         (investor).transfer(value);
659         emit RejectedWithdrawn(investor, value);
660     }
661 
662     function transferApprover(address newApprover) external onlyApprover {
663         approver = newApprover;
664         emit ApproverTransferred(newApprover);
665     }
666 }