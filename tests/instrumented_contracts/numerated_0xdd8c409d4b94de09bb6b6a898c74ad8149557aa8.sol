1 pragma solidity ^0.4.19;
2 
3 
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   function Ownable() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 
47 
48 /**
49  * @title Pausable
50  * @dev Base contract which allows children to implement an emergency stop mechanism.
51  */
52 contract Pausable is Ownable {
53   event Pause();
54   event Unpause();
55 
56   bool public paused = false;
57 
58 
59   /**
60    * @dev Modifier to make a function callable only when the contract is not paused.
61    */
62   modifier whenNotPaused() {
63     require(!paused);
64     _;
65   }
66 
67   /**
68    * @dev Modifier to make a function callable only when the contract is paused.
69    */
70   modifier whenPaused() {
71     require(paused);
72     _;
73   }
74 
75   /**
76    * @dev called by the owner to pause, triggers stopped state
77    */
78   function pause() onlyOwner whenNotPaused public {
79     paused = true;
80     Pause();
81   }
82 
83   /**
84    * @dev called by the owner to unpause, returns to normal state
85    */
86   function unpause() onlyOwner whenPaused public {
87     paused = false;
88     Unpause();
89   }
90 }
91 
92 
93 /**
94  * @title ERC20Basic
95  * @dev Simpler version of ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/179
97  */
98 contract ERC20Basic {
99   function totalSupply() public view returns (uint256);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 
106 /**
107  * @title SafeMath
108  * @dev Math operations with safety checks that throw on error
109  */
110 library SafeMath {
111 
112   /**
113   * @dev Multiplies two numbers, throws on overflow.
114   */
115   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116     if (a == 0) {
117       return 0;
118     }
119     uint256 c = a * b;
120     assert(c / a == b);
121     return c;
122   }
123 
124   /**
125   * @dev Integer division of two numbers, truncating the quotient.
126   */
127   function div(uint256 a, uint256 b) internal pure returns (uint256) {
128     // assert(b > 0); // Solidity automatically throws when dividing by 0
129     uint256 c = a / b;
130     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
131     return c;
132   }
133 
134   /**
135   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
136   */
137   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138     assert(b <= a);
139     return a - b;
140   }
141 
142   /**
143   * @dev Adds two numbers, throws on overflow.
144   */
145   function add(uint256 a, uint256 b) internal pure returns (uint256) {
146     uint256 c = a + b;
147     assert(c >= a);
148     return c;
149   }
150 }
151 
152 
153 /**
154  * @title Basic token
155  * @dev Basic version of StandardToken, with no allowances.
156  */
157 contract BasicToken is ERC20Basic {
158   using SafeMath for uint256;
159 
160   mapping(address => uint256) balances;
161 
162   uint256 totalSupply_;
163 
164   /**
165   * @dev total number of tokens in existence
166   */
167   function totalSupply() public view returns (uint256) {
168     return totalSupply_;
169   }
170 
171   /**
172   * @dev transfer token for a specified address
173   * @param _to The address to transfer to.
174   * @param _value The amount to be transferred.
175   */
176   function transfer(address _to, uint256 _value) public returns (bool) {
177     require(_to != address(0));
178     require(_value <= balances[msg.sender]);
179 
180     // SafeMath.sub will throw if there is not enough balance.
181     balances[msg.sender] = balances[msg.sender].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     Transfer(msg.sender, _to, _value);
184     return true;
185   }
186 
187   /**
188   * @dev Gets the balance of the specified address.
189   * @param _owner The address to query the the balance of.
190   * @return An uint256 representing the amount owned by the passed address.
191   */
192   function balanceOf(address _owner) public view returns (uint256 balance) {
193     return balances[_owner];
194   }
195 
196 }
197 
198 
199 
200 
201 
202 
203 /**
204  * @title ERC20 interface
205  * @dev see https://github.com/ethereum/EIPs/issues/20
206  */
207 contract ERC20 is ERC20Basic {
208   function allowance(address owner, address spender) public view returns (uint256);
209   function transferFrom(address from, address to, uint256 value) public returns (bool);
210   function approve(address spender, uint256 value) public returns (bool);
211   event Approval(address indexed owner, address indexed spender, uint256 value);
212 }
213 
214 
215 /**
216  * @title Standard ERC20 token
217  *
218  * @dev Implementation of the basic standard token.
219  * @dev https://github.com/ethereum/EIPs/issues/20
220  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
221  */
222 contract StandardToken is ERC20, BasicToken {
223 
224   mapping (address => mapping (address => uint256)) internal allowed;
225 
226 
227   /**
228    * @dev Transfer tokens from one address to another
229    * @param _from address The address which you want to send tokens from
230    * @param _to address The address which you want to transfer to
231    * @param _value uint256 the amount of tokens to be transferred
232    */
233   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
234     require(_to != address(0));
235     require(_value <= balances[_from]);
236     require(_value <= allowed[_from][msg.sender]);
237 
238     balances[_from] = balances[_from].sub(_value);
239     balances[_to] = balances[_to].add(_value);
240     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
241     Transfer(_from, _to, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
247    *
248    * Beware that changing an allowance with this method brings the risk that someone may use both the old
249    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
250    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
251    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252    * @param _spender The address which will spend the funds.
253    * @param _value The amount of tokens to be spent.
254    */
255   function approve(address _spender, uint256 _value) public returns (bool) {
256     allowed[msg.sender][_spender] = _value;
257     Approval(msg.sender, _spender, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Function to check the amount of tokens that an owner allowed to a spender.
263    * @param _owner address The address which owns the funds.
264    * @param _spender address The address which will spend the funds.
265    * @return A uint256 specifying the amount of tokens still available for the spender.
266    */
267   function allowance(address _owner, address _spender) public view returns (uint256) {
268     return allowed[_owner][_spender];
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    *
274    * approve should be called when allowed[_spender] == 0. To increment
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param _spender The address which will spend the funds.
279    * @param _addedValue The amount of tokens to increase the allowance by.
280    */
281   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
282     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
283     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284     return true;
285   }
286 
287   /**
288    * @dev Decrease the amount of tokens that an owner allowed to a spender.
289    *
290    * approve should be called when allowed[_spender] == 0. To decrement
291    * allowed value is better to use this function to avoid 2 calls (and wait until
292    * the first transaction is mined)
293    * From MonolithDAO Token.sol
294    * @param _spender The address which will spend the funds.
295    * @param _subtractedValue The amount of tokens to decrease the allowance by.
296    */
297   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
298     uint oldValue = allowed[msg.sender][_spender];
299     if (_subtractedValue > oldValue) {
300       allowed[msg.sender][_spender] = 0;
301     } else {
302       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
303     }
304     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305     return true;
306   }
307 
308 }
309 
310 
311 
312 /**
313  * @title Mintable token
314  * @dev Simple ERC20 Token example, with mintable token creation
315  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
316  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
317  */
318 contract MintableToken is StandardToken, Ownable {
319   event Mint(address indexed to, uint256 amount);
320   event MintFinished();
321 
322   bool public mintingFinished = false;
323 
324 
325   modifier canMint() {
326     require(!mintingFinished);
327     _;
328   }
329 
330   /**
331    * @dev Function to mint tokens
332    * @param _to The address that will receive the minted tokens.
333    * @param _amount The amount of tokens to mint.
334    * @return A boolean that indicates if the operation was successful.
335    */
336   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
337     totalSupply_ = totalSupply_.add(_amount);
338     balances[_to] = balances[_to].add(_amount);
339     Mint(_to, _amount);
340     Transfer(address(0), _to, _amount);
341     return true;
342   }
343 
344   /**
345    * @dev Function to stop minting new tokens.
346    * @return True if the operation was successful.
347    */
348   function finishMinting() onlyOwner canMint public returns (bool) {
349     mintingFinished = true;
350     MintFinished();
351     return true;
352   }
353 }
354 
355 
356 contract ThinkCoin is MintableToken {
357   string public name = "ThinkCoin";
358   string public symbol = "TCO";
359   uint8 public decimals = 18;
360   uint256 public cap;
361 
362   function ThinkCoin(uint256 _cap) public {
363     require(_cap > 0);
364     cap = _cap;
365   }
366 
367   // override
368   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
369     require(totalSupply_.add(_amount) <= cap);
370     return super.mint(_to, _amount);
371   }
372 
373   // override
374   function transfer(address _to, uint256 _value) public returns (bool) {
375     require(mintingFinished == true);
376     return super.transfer(_to, _value);
377   }
378 
379   // override
380   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
381     require(mintingFinished == true);
382     return super.transferFrom(_from, _to, _value);
383   }
384 
385   function() public payable {
386     revert();
387   }
388 }
389 
390 
391 
392 
393 
394 
395 contract LockingContract is Ownable {
396   using SafeMath for uint256;
397 
398   event NotedTokens(address indexed _beneficiary, uint256 _tokenAmount);
399   event ReleasedTokens(address indexed _beneficiary);
400   event ReducedLockingTime(uint256 _newUnlockTime);
401 
402   ERC20 public tokenContract;
403   mapping(address => uint256) public tokens;
404   uint256 public totalTokens;
405   uint256 public unlockTime;
406 
407   function isLocked() public view returns(bool) {
408     return now < unlockTime;
409   }
410 
411   modifier onlyWhenUnlocked() {
412     require(!isLocked());
413     _;
414   }
415 
416   modifier onlyWhenLocked() {
417     require(isLocked());
418     _;
419   }
420 
421   function LockingContract(ERC20 _tokenContract, uint256 _unlockTime) public {
422     require(_unlockTime > 0);
423     unlockTime = _unlockTime;
424     tokenContract = _tokenContract;
425   }
426 
427   function balanceOf(address _owner) public view returns (uint256 balance) {
428     return tokens[_owner];
429   }
430 
431   // Should only be done from another contract.
432   // To ensure that the LockingContract can release all noted tokens later,
433   // one should mint/transfer tokens to the LockingContract's account prior to noting
434   function noteTokens(address _beneficiary, uint256 _tokenAmount) external onlyOwner onlyWhenLocked {
435     uint256 tokenBalance = tokenContract.balanceOf(this);
436     require(tokenBalance == totalTokens.add(_tokenAmount));
437 
438     tokens[_beneficiary] = tokens[_beneficiary].add(_tokenAmount);
439     totalTokens = totalTokens.add(_tokenAmount);
440     NotedTokens(_beneficiary, _tokenAmount);
441   }
442 
443   function releaseTokens(address _beneficiary) public onlyWhenUnlocked {
444     uint256 amount = tokens[_beneficiary];
445     tokens[_beneficiary] = 0;
446     require(tokenContract.transfer(_beneficiary, amount)); 
447     totalTokens = totalTokens.sub(amount);
448     ReleasedTokens(_beneficiary);
449   }
450 
451   function reduceLockingTime(uint256 _newUnlockTime) public onlyOwner onlyWhenLocked {
452     require(_newUnlockTime >= now);
453     require(_newUnlockTime < unlockTime);
454     unlockTime = _newUnlockTime;
455     ReducedLockingTime(_newUnlockTime);
456   }
457 }
458 
459 
460 
461 
462 
463 contract Crowdsale is Ownable, Pausable {
464   using SafeMath for uint256;
465 
466   event MintProposed(address indexed _beneficiary, uint256 _tokenAmount);
467   event MintLockedProposed(address indexed _beneficiary, uint256 _tokenAmount);
468   event MintApproved(address indexed _beneficiary, uint256 _tokenAmount);
469   event MintLockedApproved(address indexed _beneficiary, uint256 _tokenAmount);
470   event MintedAllocation(address indexed _beneficiary, uint256 _tokenAmount);
471   event ProposerChanged(address _newProposer);
472   event ApproverChanged(address _newApprover);
473 
474   ThinkCoin public token;
475   LockingContract public lockingContract;
476   address public proposer; // proposes mintages of tokens
477   address public approver; // approves proposed mintages
478   mapping(address => uint256) public mintProposals;
479   mapping(address => uint256) public mintLockedProposals;
480   uint256 public proposedTotal = 0;
481   uint256 public saleCap;
482   uint256 public saleStartTime;
483   uint256 public saleEndTime;
484 
485   function Crowdsale(ThinkCoin _token,
486                      uint256 _lockingPeriod,
487                      address _proposer,
488                      address _approver,
489                      uint256 _saleCap,
490                      uint256 _saleStartTime,
491                      uint256 _saleEndTime
492                      ) public {
493     require(_saleCap > 0);
494     require(_saleStartTime < _saleEndTime);
495     require(_saleEndTime > now);
496     require(_lockingPeriod > 0);
497     require(_proposer != _approver);
498     require(_saleCap <= _token.cap());
499     require(address(_token) != 0x0);
500 
501     token = _token;
502     lockingContract = new LockingContract(token, _saleEndTime.add(_lockingPeriod));    
503     proposer = _proposer;
504     approver = _approver;
505     saleCap = _saleCap;
506     saleStartTime = _saleStartTime;
507     saleEndTime = _saleEndTime;
508   }
509 
510   modifier saleStarted() {
511     require(now >= saleStartTime);
512     _;
513   }
514 
515   modifier saleNotEnded() {
516     require(now < saleEndTime);
517     _;
518   }
519 
520   modifier saleEnded() {
521     require(now >= saleEndTime);
522     _;
523   }
524 
525   modifier onlyProposer() {
526     require(msg.sender == proposer);
527     _;
528   }
529 
530   modifier onlyApprover() {
531     require(msg.sender == approver);
532     _;
533   }
534 
535   function exceedsSaleCap(uint256 _additionalAmount) internal view returns(bool) {
536     uint256 totalSupply = token.totalSupply();
537     return totalSupply.add(_additionalAmount) > saleCap;
538   }
539 
540   modifier notExceedingSaleCap(uint256 _amount) {
541     require(!exceedsSaleCap(_amount));
542     _;
543   }
544 
545   function proposeMint(address _beneficiary, uint256 _tokenAmount) public onlyProposer saleStarted saleNotEnded
546                                                                           notExceedingSaleCap(proposedTotal.add(_tokenAmount)) {
547     require(_tokenAmount > 0);
548     require(mintProposals[_beneficiary] == 0);
549     proposedTotal = proposedTotal.add(_tokenAmount);
550     mintProposals[_beneficiary] = _tokenAmount;
551     MintProposed(_beneficiary, _tokenAmount);
552   }
553 
554   function proposeMintLocked(address _beneficiary, uint256 _tokenAmount) public onlyProposer saleStarted saleNotEnded
555                                                                          notExceedingSaleCap(proposedTotal.add(_tokenAmount)) {
556     require(_tokenAmount > 0);
557     require(mintLockedProposals[_beneficiary] == 0);
558     proposedTotal = proposedTotal.add(_tokenAmount);
559     mintLockedProposals[_beneficiary] = _tokenAmount;
560     MintLockedProposed(_beneficiary, _tokenAmount);
561   }
562 
563   function clearProposal(address _beneficiary) public onlyApprover {
564     proposedTotal = proposedTotal.sub(mintProposals[_beneficiary]);
565     mintProposals[_beneficiary] = 0;
566   }
567 
568   function clearProposalLocked(address _beneficiary) public onlyApprover {
569     proposedTotal = proposedTotal.sub(mintLockedProposals[_beneficiary]);
570     mintLockedProposals[_beneficiary] = 0;
571   }
572 
573   function approveMint(address _beneficiary, uint256 _tokenAmount) public onlyApprover saleStarted
574                                                                    notExceedingSaleCap(_tokenAmount) {
575     require(_tokenAmount > 0);
576     require(mintProposals[_beneficiary] == _tokenAmount);
577     mintProposals[_beneficiary] = 0;
578     token.mint(_beneficiary, _tokenAmount);
579     MintApproved(_beneficiary, _tokenAmount);
580   }
581 
582   function approveMintLocked(address _beneficiary, uint256 _tokenAmount) public onlyApprover saleStarted
583                                                                          notExceedingSaleCap(_tokenAmount) {
584     require(_tokenAmount > 0);
585     require(mintLockedProposals[_beneficiary] == _tokenAmount);
586     mintLockedProposals[_beneficiary] = 0;
587     token.mint(lockingContract, _tokenAmount);
588     lockingContract.noteTokens(_beneficiary, _tokenAmount);
589     MintLockedApproved(_beneficiary, _tokenAmount);
590   }
591 
592   function mintAllocation(address _beneficiary, uint256 _tokenAmount) public onlyOwner saleEnded {
593     require(_tokenAmount > 0);
594     token.mint(_beneficiary, _tokenAmount);
595     MintedAllocation(_beneficiary, _tokenAmount);
596   }
597 
598   function finishMinting() public onlyOwner saleEnded {
599     require(proposedTotal == 0);
600     token.finishMinting();
601     transferTokenOwnership();
602   }
603 
604   function transferTokenOwnership() public onlyOwner saleEnded {
605     token.transferOwnership(msg.sender);
606   }
607 
608   function changeProposer(address _newProposer) public onlyOwner {
609     require(_newProposer != approver);
610     proposer = _newProposer;
611     ProposerChanged(_newProposer);
612   }
613 
614   function changeApprover(address _newApprover) public onlyOwner {
615     require(_newApprover != proposer);
616     approver = _newApprover;
617     ApproverChanged(_newApprover);
618   }
619 }