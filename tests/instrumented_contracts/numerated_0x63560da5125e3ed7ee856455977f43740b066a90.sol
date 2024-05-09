1 pragma solidity 0.4.24;
2 
3 contract ReentrancyGuard {
4     /**
5     * @dev We use a single lock for the whole contract.
6     */
7     bool private reentrancyLock = false;
8 
9     /**
10     * @dev Prevents a contract from calling itself, directly or indirectly.
11     * @notice If you mark a function `nonReentrant`, you should also
12     * mark it `external`. Calling one nonReentrant function from
13     * another is not supported. Instead, you can implement a
14     * `private` function doing the actual work, and a `external`
15     * wrapper marked as `nonReentrant`.
16     */
17     modifier nonReentrant() {
18         require(!reentrancyLock);
19         reentrancyLock = true;
20         _;
21         reentrancyLock = false;
22     }
23 }
24 
25 library SafeERC20 {
26     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
27         assert(token.transfer(to, value));
28     }
29 
30     function safeTransferFrom(
31         ERC20 token,
32         address from,
33         address to,
34         uint256 value
35     )
36         internal
37     {
38         assert(token.transferFrom(from, to, value));
39     }
40 
41     function safeApprove(ERC20 token, address spender, uint256 value) internal {
42         assert(token.approve(spender, value));
43     }
44 }
45 
46 contract Ownable {
47     address public owner;
48 
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52 
53     /**
54     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55     * account.
56     */
57     constructor() public {
58         owner = msg.sender;
59     }
60 
61     /**
62     * @dev Throws if called by any account other than the owner.
63     */
64     modifier onlyOwner() {
65         require(msg.sender == owner);
66 
67         _;
68     }
69 
70     /**
71     * @dev Allows the current owner to transfer control of the contract to a newOwner.
72     * @param newOwner The address to transfer ownership to.
73     */
74     function transferOwnership(address newOwner) public onlyOwner {
75         require(newOwner != address(0));
76 
77         emit OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79     }
80 
81 }
82 
83 contract Pausable is Ownable {
84     event Pause();
85     event Unpause();
86 
87     bool public paused = false;
88     
89     mapping (address=>bool) private whiteList;
90 
91     /**
92     * @dev Modifier to make a function callable only when the contract is not paused.
93     */
94     modifier whenNotPaused() {
95         require(!paused || whiteList[msg.sender]);
96 
97         _;
98     }
99 
100     /**
101     * @dev Modifier to make a function callable only when the contract is paused.
102     */
103     modifier whenPaused() {
104         require(paused || whiteList[msg.sender]);
105 
106         _;
107     }
108 
109     /**
110     * @dev called by the owner to pause, triggers stopped state
111     */
112     function pause() onlyOwner whenNotPaused public {
113         paused = true;
114 
115         emit Pause();
116     }
117 
118     /**
119     * @dev called by the owner to unpause, returns to normal state
120     */
121     function unpause() onlyOwner whenPaused public {
122         paused = false;
123 
124         emit Unpause();
125     }
126 
127     function addToWhiteList(address[] _whiteList) external onlyOwner {
128         require(_whiteList.length > 0);
129 
130         for(uint8 i = 0; i < _whiteList.length; i++) {
131             assert(_whiteList[i] != address(0));
132 
133             whiteList[_whiteList[i]] = true;
134         }
135     }
136 
137     function removeFromWhiteList(address[] _blackList) external onlyOwner {
138         require(_blackList.length > 0);
139 
140         for(uint8 i = 0; i < _blackList.length; i++) {
141             assert(_blackList[i] != address(0));
142 
143             whiteList[_blackList[i]] = true;
144         }
145     }
146 }
147 
148 contract W12TokenDistributor is Ownable {
149     W12Token public token;
150 
151     mapping(uint32 => bool) public processedTransactions;
152 
153     constructor() public {
154         token = new W12Token();
155     }
156 
157     function isTransactionSuccessful(uint32 id) external view returns (bool) {
158         return processedTransactions[id];
159     }
160 
161     modifier validateInput(uint32[] _payment_ids, address[] _receivers, uint256[] _amounts) {
162         require(_receivers.length == _amounts.length);
163         require(_receivers.length == _payment_ids.length);
164 
165         _;
166     }
167 
168     function transferTokenOwnership() external onlyOwner {
169         token.transferOwnership(owner);
170     }
171 }
172 
173 contract TokenTimelock {
174     using SafeERC20 for ERC20Basic;
175 
176     // ERC20 basic token contract being held
177     ERC20Basic public token;
178 
179     // beneficiary of tokens after they are released
180     address public beneficiary;
181 
182     // timestamp when token release is enabled
183     uint256 public releaseTime;
184 
185     constructor (ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
186         // solium-disable-next-line security/no-block-members
187         require(_releaseTime > block.timestamp);
188         token = _token;
189         beneficiary = _beneficiary;
190         releaseTime = _releaseTime;
191     }
192 
193     /**
194     * @notice Transfers tokens held by timelock to beneficiary.
195     */
196     function release() public {
197         // solium-disable-next-line security/no-block-members
198         require(block.timestamp >= releaseTime);
199 
200         uint256 amount = token.balanceOf(this);
201         require(amount > 0);
202 
203         token.safeTransfer(beneficiary, amount);
204     }
205 }
206 
207 contract W12Crowdsale is W12TokenDistributor, ReentrancyGuard {
208     uint public presaleStartDate = 1526817600;
209     uint public presaleEndDate = 1532088000;
210     uint public crowdsaleStartDate = 1532692800;
211     uint public crowdsaleEndDate = 1538049600;
212 
213     uint public presaleTokenBalance = 20 * (10 ** 24);
214     uint public crowdsaleTokenBalance = 80 * (10 ** 24);
215 
216     address public crowdsaleFundsWallet;
217 
218     enum Stage { Inactive, FlashSale, Presale, Crowdsale }
219 
220     event LockCreated(address indexed wallet, address timeLock1, address timeLock2, address timeLock3);
221 
222     constructor(address _crowdsaleFundsWallet) public {
223         require(_crowdsaleFundsWallet != address(0));
224 
225         // Wallet to hold collected Ether
226         crowdsaleFundsWallet = address(_crowdsaleFundsWallet);
227     }
228     
229     function setUpCrowdsale() external onlyOwner {
230         uint tokenDecimalsMultiplicator = 10 ** 18;
231 
232         // Tokens to sell during the first two phases of ICO
233         token.mint(address(this), presaleTokenBalance + crowdsaleTokenBalance);
234         // Partners
235         token.mint(address(0xDbdCEa0B020D4769D7EA0aF47Df8848d478D67d1),  8 * (10 ** 6) * tokenDecimalsMultiplicator);
236         // Bounty and support of ecosystem
237         token.mint(address(0x1309Bb4DBBB6F8B3DE1822b4Cf22570d44f79cde),  8 * (10 ** 6) * tokenDecimalsMultiplicator);
238         // Airdrop
239         token.mint(address(0x0B2F4A122c34c4ccACf4EBecE15dE571d67b4D0a),  4 * (10 ** 6) * tokenDecimalsMultiplicator);
240         
241         address[] storage whiteList;
242 
243         whiteList.push(address(this));
244         whiteList.push(address(0xDbdCEa0B020D4769D7EA0aF47Df8848d478D67d1));
245         whiteList.push(address(0x1309Bb4DBBB6F8B3DE1822b4Cf22570d44f79cde));
246         whiteList.push(address(0x0B2F4A122c34c4ccACf4EBecE15dE571d67b4D0a));
247         whiteList.push(address(0xd13B531160Cfe6CC2f9a5615524CA636A0A94D88));
248         whiteList.push(address(0x3BAF5A51E6212d311Bc567b60bE84Fc180d39805));
249 
250         token.addToWhiteList(whiteList);
251     }
252 
253     function () payable external {
254         Stage currentStage = getStage();
255 
256         require(currentStage != Stage.Inactive);
257 
258         uint currentRate = getCurrentRate();
259         uint tokensBought = msg.value * (10 ** 18) / currentRate;
260 
261         token.transfer(msg.sender, tokensBought);
262         advanceStage(tokensBought, currentStage);
263     }
264 
265     function getCurrentRate() public view returns (uint) {
266         uint currentSaleTime;
267         Stage currentStage = getStage();
268 
269         if(currentStage == Stage.Presale) {
270             currentSaleTime = now - presaleStartDate;
271             uint presaleCoef = currentSaleTime * 100 / (presaleEndDate - presaleStartDate);
272             
273             return 262500000000000 + 35000000000000 * presaleCoef / 100;
274         }
275         
276         if(currentStage == Stage.Crowdsale) {
277             currentSaleTime = now - crowdsaleStartDate;
278             uint crowdsaleCoef = currentSaleTime * 100 / (crowdsaleEndDate - crowdsaleStartDate);
279 
280             return 315000000000000 + 35000000000000 * crowdsaleCoef / 100;
281         }
282 
283         if(currentStage == Stage.FlashSale) {
284             return 234500000000000;
285         }
286 
287         revert();
288     }
289 
290     function getStage() public view returns (Stage) {
291         if(now >= crowdsaleStartDate && now < crowdsaleEndDate) {
292             return Stage.Crowdsale;
293         }
294 
295         if(now >= presaleStartDate) {
296             if(now < presaleStartDate + 1 days)
297                 return Stage.FlashSale;
298 
299             if(now < presaleEndDate)
300                 return Stage.Presale;
301         }
302 
303         return Stage.Inactive;
304     }
305 
306     function bulkTransfer(uint32[] _payment_ids, address[] _receivers, uint256[] _amounts)
307         external onlyOwner validateInput(_payment_ids, _receivers, _amounts) {
308 
309         bool success = false;
310 
311         for (uint i = 0; i < _receivers.length; i++) {
312             if (!processedTransactions[_payment_ids[i]]) {
313                 success = token.transfer(_receivers[i], _amounts[i]);
314                 processedTransactions[_payment_ids[i]] = success;
315 
316                 if (!success)
317                     break;
318 
319                 advanceStage(_amounts[i], getStage());
320             }
321         }
322     }
323 
324     function transferTokensToOwner() external onlyOwner {
325         token.transfer(owner, token.balanceOf(address(this)));
326     }
327 
328     function advanceStage(uint tokensBought, Stage currentStage) internal {
329         if(currentStage == Stage.Presale || currentStage == Stage.FlashSale) {
330             if(tokensBought <= presaleTokenBalance)
331             {
332                 presaleTokenBalance -= tokensBought;
333                 return;
334             }
335         }
336         
337         if(currentStage == Stage.Crowdsale) {
338             if(tokensBought <= crowdsaleTokenBalance)
339             {
340                 crowdsaleTokenBalance -= tokensBought;
341                 return;
342             }
343         }
344 
345         revert();
346     }
347 
348     function withdrawFunds() external nonReentrant {
349         require(crowdsaleFundsWallet == msg.sender);
350 
351         crowdsaleFundsWallet.transfer(address(this).balance);
352     }
353 
354     function setPresaleStartDate(uint32 _presaleStartDate) external onlyOwner {
355         presaleStartDate = _presaleStartDate;
356     }
357 
358     function setPresaleEndDate(uint32 _presaleEndDate) external onlyOwner {
359         presaleEndDate = _presaleEndDate;
360     }
361 
362     function setCrowdsaleStartDate(uint32 _crowdsaleStartDate) external onlyOwner {
363         crowdsaleStartDate = _crowdsaleStartDate;
364     }
365 
366     function setCrowdsaleEndDate(uint32 _crowdsaleEndDate) external onlyOwner {
367         crowdsaleEndDate = _crowdsaleEndDate;
368     }
369 }
370 
371 contract ERC20Basic {
372     function totalSupply() public view returns (uint256);
373     function balanceOf(address who) public view returns (uint256);
374     function transfer(address to, uint256 value) public returns (bool);
375     event Transfer(address indexed from, address indexed to, uint256 value);
376 }
377 
378 contract ERC20 is ERC20Basic {
379     function allowance(address owner, address spender) public view returns (uint256);
380     function transferFrom(address from, address to, uint256 value) public returns (bool);
381     function approve(address spender, uint256 value) public returns (bool);
382     event Approval(address indexed owner, address indexed spender, uint256 value);
383 }
384 
385 contract BasicToken is ERC20Basic {
386 
387     mapping(address => uint256) balances;
388 
389     uint256 totalSupply_;
390 
391     /**
392     * @dev total number of tokens in existence
393     */
394     function totalSupply() public view returns (uint256) {
395         return totalSupply_;
396     }
397 
398     /**
399     * @dev transfer token for a specified address
400     * @param _to The address to transfer to.
401     * @param _value The amount to be transferred.
402     */
403     function transfer(address _to, uint256 _value) public returns (bool) {
404         require(_to != address(0));
405         require(_value <= balances[msg.sender]);
406 
407         balances[msg.sender] = balances[msg.sender] - _value;
408         balances[_to] = balances[_to] + _value;
409         emit Transfer(msg.sender, _to, _value);
410         return true;
411     }
412 
413     /**
414     * @dev Gets the balance of the specified address.
415     * @param _owner The address to query the the balance of.
416     * @return An uint256 representing the amount owned by the passed address.
417     */
418     function balanceOf(address _owner) public view returns (uint256 balance) {
419         return balances[_owner];
420     }
421 
422 }
423 
424 contract StandardToken is ERC20, BasicToken {
425 
426     mapping (address => mapping (address => uint256)) internal allowed;
427 
428 
429     /**
430     * @dev Transfer tokens from one address to another
431     * @param _from address The address which you want to send tokens from
432     * @param _to address The address which you want to transfer to
433     * @param _value uint256 the amount of tokens to be transferred
434     */
435     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
436         require(_to != address(0));
437         require(_value <= balances[_from]);
438         require(_value <= allowed[_from][msg.sender]);
439 
440         balances[_from] = balances[_from] - _value;
441         balances[_to] = balances[_to] + _value;
442         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
443         emit Transfer(_from, _to, _value);
444         return true;
445     }
446 
447     /**
448     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
449     *
450     * Beware that changing an allowance with this method brings the risk that someone may use both the old
451     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
452     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
453     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
454     * @param _spender The address which will spend the funds.
455     * @param _value The amount of tokens to be spent.
456     */
457     function approve(address _spender, uint256 _value) public returns (bool) {
458         allowed[msg.sender][_spender] = _value;
459         emit Approval(msg.sender, _spender, _value);
460 
461         return true;
462     }
463 
464     /**
465     * @dev Function to check the amount of tokens that an owner allowed to a spender.
466     * @param _owner address The address which owns the funds.
467     * @param _spender address The address which will spend the funds.
468     * @return A uint256 specifying the amount of tokens still available for the spender.
469     */
470     function allowance(address _owner, address _spender) public view returns (uint256) {
471         return allowed[_owner][_spender];
472     }
473 
474     /**
475     * @dev Increase the amount of tokens that an owner allowed to a spender.
476     *
477     * approve should be called when allowed[_spender] == 0. To increment
478     * allowed value is better to use this function to avoid 2 calls (and wait until
479     * the first transaction is mined)
480     * From MonolithDAO Token.sol
481     * @param _spender The address which will spend the funds.
482     * @param _addedValue The amount of tokens to increase the allowance by.
483     */
484     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
485         allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;
486         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
487 
488         return true;
489     }
490 
491     /**
492     * @dev Decrease the amount of tokens that an owner allowed to a spender.
493     *
494     * approve should be called when allowed[_spender] == 0. To decrement
495     * allowed value is better to use this function to avoid 2 calls (and wait until
496     * the first transaction is mined)
497     * From MonolithDAO Token.sol
498     * @param _spender The address which will spend the funds.
499     * @param _subtractedValue The amount of tokens to decrease the allowance by.
500     */
501     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
502         uint oldValue = allowed[msg.sender][_spender];
503         if (_subtractedValue >= oldValue) {
504             allowed[msg.sender][_spender] = 0;
505         } else {
506             allowed[msg.sender][_spender] = oldValue - _subtractedValue;
507         }
508         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
509 
510         return true;
511     }
512 
513 }
514 
515 contract MintableToken is StandardToken, Ownable {
516     event Mint(address indexed to, uint256 amount);
517     event MintFinished();
518 
519     bool public mintingFinished = false;
520 
521 
522     modifier canMint() {
523         require(!mintingFinished);
524 
525         _;
526     }
527 
528     /**
529     * @dev Function to mint tokens
530     * @param _to The address that will receive the minted tokens.
531     * @param _amount The amount of tokens to mint.
532     * @return A boolean that indicates if the operation was successful.
533     */
534     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
535         totalSupply_ = totalSupply_ + _amount;
536         balances[_to] = balances[_to] + _amount;
537 
538         emit Mint(_to, _amount);
539         emit Transfer(address(0), _to, _amount);
540 
541         return true;
542     }
543 
544     /**
545     * @dev Function to stop minting new tokens.
546     * @return True if the operation was successful.
547     */
548     function finishMinting() onlyOwner canMint public returns (bool) {
549         mintingFinished = true;
550         emit MintFinished();
551 
552         return true;
553     }
554 }
555 
556 contract DetailedERC20 is ERC20 {
557     string public name;
558     string public symbol;
559     uint8 public decimals;
560 
561     constructor (string _name, string _symbol, uint8 _decimals) public {
562         name = _name;
563         symbol = _symbol;
564         decimals = _decimals;
565     }
566 }
567 
568 contract PausableToken is StandardToken, Pausable {
569 
570     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
571         return super.transfer(_to, _value);
572     }
573 
574     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
575         return super.transferFrom(_from, _to, _value);
576     }
577 
578     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
579         return super.approve(_spender, _value);
580     }
581 
582     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
583         return super.increaseApproval(_spender, _addedValue);
584     }
585 
586     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
587         return super.decreaseApproval(_spender, _subtractedValue);
588     }
589 }
590 
591 contract CappedToken is MintableToken {
592 
593     uint256 public cap;
594 
595     constructor(uint256 _cap) public {
596         require(_cap > 0);
597 
598         cap = _cap;
599     }
600 
601     /**
602     * @dev Function to mint tokens
603     * @param _to The address that will receive the minted tokens.
604     * @param _amount The amount of tokens to mint.
605     * @return A boolean that indicates if the operation was successful.
606     */
607     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
608         require(totalSupply_ + _amount <= cap);
609 
610         return super.mint(_to, _amount);
611     }
612 }
613 
614 contract BurnableToken is BasicToken {
615 
616     event Burn(address indexed burner, uint256 value);
617 
618     /**
619     * @dev Burns a specific amount of tokens.
620     * @param _value The amount of token to be burned.
621     */
622     function burn(uint256 _value) public {
623         _burn(msg.sender, _value);
624     }
625 
626     function _burn(address _who, uint256 _value) internal {
627         require(_value <= balances[_who]);
628         // no need to require value <= totalSupply, since that would imply the
629         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
630 
631         balances[_who] = balances[_who] - _value;
632         totalSupply_ = totalSupply_ - _value;
633         emit Burn(_who, _value);
634         emit Transfer(_who, address(0), _value);
635     }
636 }
637 
638 contract StandardBurnableToken is BurnableToken, StandardToken {
639 
640     /**
641     * @dev Burns a specific amount of tokens from the target address and decrements allowance
642     * @param _from address The address which you want to send tokens from
643     * @param _value uint256 The amount of token to be burned
644     */
645     function burnFrom(address _from, uint256 _value) public {
646         require(_value <= allowed[_from][msg.sender]);
647         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
648         // this function needs to emit an event with the updated approval.
649         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
650         _burn(_from, _value);
651     }
652 }
653 
654 contract W12Token is StandardBurnableToken, CappedToken, DetailedERC20, PausableToken  {
655     constructor() CappedToken(400*(10**24)) DetailedERC20("W12 Token", "W12", 18) public { }
656 }