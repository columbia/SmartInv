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
253     function lockSeedInvestors() external onlyOwner {
254         uint tokenDecimalsMultiplicator = 10 ** 18;
255 
256         // Seed investors
257 
258         address contributor1 = address(0xA0473967Bf75a9D6cA84A58975D26b6Fd3eecB32);
259         TokenTimelock t1c1 = new TokenTimelock(token, contributor1, 1541030400);
260         TokenTimelock t2c1 = new TokenTimelock(token, contributor1, 1572566400);
261         TokenTimelock t3c1 = new TokenTimelock(token, contributor1, 1604188800);
262 
263         token.mint(t1c1, 2 * (10 ** 6) * tokenDecimalsMultiplicator);
264         token.mint(t2c1, 2 * (10 ** 6) * tokenDecimalsMultiplicator);
265         token.mint(t3c1, 2 * (10 ** 6) * tokenDecimalsMultiplicator);
266 
267         emit LockCreated(contributor1, t1c1, t2c1, t3c1);
268 
269         address contributor2 = address(0x7ff9837FebAACbD1d1d91066F9DC5bbE1Bf1C023);
270         TokenTimelock t1c2 = new TokenTimelock(token, contributor2, 1541030400);
271         TokenTimelock t2c2 = new TokenTimelock(token, contributor2, 1572566400);
272         TokenTimelock t3c2 = new TokenTimelock(token, contributor2, 1604188800);
273 
274         token.mint(t1c2, 2 * (10 ** 6) * tokenDecimalsMultiplicator);
275         token.mint(t2c2, 2 * (10 ** 6) * tokenDecimalsMultiplicator);
276         token.mint(t3c2, 2 * (10 ** 6) * tokenDecimalsMultiplicator);
277 
278         emit LockCreated(contributor2, t1c2, t2c2, t3c2);
279 
280         address contributor3 = address(0xe4a7d4f7C358A56eA191Bb0aC3D8074327504Ac4);
281         TokenTimelock t1c3 = new TokenTimelock(token, contributor3, 1541030400);
282         TokenTimelock t2c3 = new TokenTimelock(token, contributor3, 1572566400);
283         TokenTimelock t3c3 = new TokenTimelock(token, contributor3, 1604188800);
284 
285         token.mint(t1c3, 25 * (10 ** 5) * tokenDecimalsMultiplicator);
286         token.mint(t2c3, 25 * (10 ** 5) * tokenDecimalsMultiplicator);
287         token.mint(t3c3, 3 * (10 ** 6) * tokenDecimalsMultiplicator);
288 
289         emit LockCreated(contributor2, t1c3, t2c3, t3c3);
290     }
291 
292     function lockTeamAndReserve() external onlyOwner {
293         uint tokenDecimalsMultiplicator = 10 ** 18;
294 
295         // Team lockup
296 
297         address team = address(0x17abe2BA2Af3559A45C016F02EA5677017AA3362);
298         TokenTimelock t1c1 = new TokenTimelock(token, team, 1541030400);
299         TokenTimelock t2c1 = new TokenTimelock(token, team, 1572566400);
300         TokenTimelock t3c1 = new TokenTimelock(token, team, 1604188800);
301 
302         token.mint(t1c1, 20 * (10 ** 6) * tokenDecimalsMultiplicator);
303         token.mint(t2c1, 20 * (10 ** 6) * tokenDecimalsMultiplicator);
304         token.mint(t3c1, 20 * (10 ** 6) * tokenDecimalsMultiplicator);
305 
306         emit LockCreated(team, t1c1, t2c1, t3c1);
307 
308         // Reserve lockup
309 
310         address reserve = address(0xE8bE756Ddd148dA0e2B440876A0Dc2FAC8BBE7A7);
311         TokenTimelock t1c2 = new TokenTimelock(token, reserve, 1541030400);
312         TokenTimelock t2c2 = new TokenTimelock(token, reserve, 1572566400);
313         TokenTimelock t3c2 = new TokenTimelock(token, reserve, 1604188800);
314 
315         token.mint(t1c2, 20 * (10 ** 6) * tokenDecimalsMultiplicator);
316         token.mint(t2c2, 20 * (10 ** 6) * tokenDecimalsMultiplicator);
317         token.mint(t3c2, 20 * (10 ** 6) * tokenDecimalsMultiplicator);
318 
319         emit LockCreated(reserve, t1c2, t2c2, t3c2);
320     }
321 
322     function () payable external {
323         Stage currentStage = getStage();
324 
325         require(currentStage != Stage.Inactive);
326 
327         uint currentRate = getCurrentRate();
328         uint tokensBought = msg.value * (10 ** 18) / currentRate;
329 
330         token.transfer(msg.sender, tokensBought);
331         advanceStage(tokensBought, currentStage);
332     }
333 
334     function getCurrentRate() public view returns (uint) {
335         uint currentSaleTime;
336         Stage currentStage = getStage();
337 
338         if(currentStage == Stage.Presale) {
339             currentSaleTime = now - presaleStartDate;
340             uint presaleCoef = currentSaleTime * 100 / (presaleEndDate - presaleStartDate);
341             
342             return 262500000000000 + 35000000000000 * presaleCoef / 100;
343         }
344         
345         if(currentStage == Stage.Crowdsale) {
346             currentSaleTime = now - crowdsaleStartDate;
347             uint crowdsaleCoef = currentSaleTime * 100 / (crowdsaleEndDate - crowdsaleStartDate);
348 
349             return 315000000000000 + 35000000000000 * crowdsaleCoef / 100;
350         }
351 
352         if(currentStage == Stage.FlashSale) {
353             return 234500000000000;
354         }
355 
356         revert();
357     }
358 
359     function getStage() public view returns (Stage) {
360         if(now >= crowdsaleStartDate && now < crowdsaleEndDate) {
361             return Stage.Crowdsale;
362         }
363 
364         if(now >= presaleStartDate) {
365             if(now < presaleStartDate + 1 days)
366                 return Stage.FlashSale;
367 
368             if(now < presaleEndDate)
369                 return Stage.Presale;
370         }
371 
372         return Stage.Inactive;
373     }
374 
375     function bulkTransfer(uint32[] _payment_ids, address[] _receivers, uint256[] _amounts)
376         external onlyOwner validateInput(_payment_ids, _receivers, _amounts) {
377 
378         bool success = false;
379 
380         for (uint i = 0; i < _receivers.length; i++) {
381             if (!processedTransactions[_payment_ids[i]]) {
382                 success = token.transfer(_receivers[i], _amounts[i]);
383                 processedTransactions[_payment_ids[i]] = success;
384 
385                 if (!success)
386                     break;
387 
388                 advanceStage(_amounts[i], getStage());
389             }
390         }
391     }
392 
393     function transferTokensToOwner() external onlyOwner {
394         token.transfer(owner, token.balanceOf(address(this)));
395     }
396 
397     function advanceStage(uint tokensBought, Stage currentStage) internal {
398         if(currentStage == Stage.Presale || currentStage == Stage.FlashSale) {
399             if(tokensBought <= presaleTokenBalance)
400             {
401                 presaleTokenBalance -= tokensBought;
402                 return;
403             }
404         }
405         
406         if(currentStage == Stage.Crowdsale) {
407             if(tokensBought <= crowdsaleTokenBalance)
408             {
409                 crowdsaleTokenBalance -= tokensBought;
410                 return;
411             }
412         }
413 
414         revert();
415     }
416 
417     function withdrawFunds() external nonReentrant {
418         require(crowdsaleFundsWallet == msg.sender);
419 
420         crowdsaleFundsWallet.transfer(address(this).balance);
421     }
422 
423     function setPresaleStartDate(uint32 _presaleStartDate) external onlyOwner {
424         presaleStartDate = _presaleStartDate;
425     }
426 
427     function setPresaleEndDate(uint32 _presaleEndDate) external onlyOwner {
428         presaleEndDate = _presaleEndDate;
429     }
430 
431     function setCrowdsaleStartDate(uint32 _crowdsaleStartDate) external onlyOwner {
432         crowdsaleStartDate = _crowdsaleStartDate;
433     }
434 
435     function setCrowdsaleEndDate(uint32 _crowdsaleEndDate) external onlyOwner {
436         crowdsaleEndDate = _crowdsaleEndDate;
437     }
438 }
439 
440 contract ERC20Basic {
441     function totalSupply() public view returns (uint256);
442     function balanceOf(address who) public view returns (uint256);
443     function transfer(address to, uint256 value) public returns (bool);
444     event Transfer(address indexed from, address indexed to, uint256 value);
445 }
446 
447 contract ERC20 is ERC20Basic {
448     function allowance(address owner, address spender) public view returns (uint256);
449     function transferFrom(address from, address to, uint256 value) public returns (bool);
450     function approve(address spender, uint256 value) public returns (bool);
451     event Approval(address indexed owner, address indexed spender, uint256 value);
452 }
453 
454 contract BasicToken is ERC20Basic {
455 
456     mapping(address => uint256) balances;
457 
458     uint256 totalSupply_;
459 
460     /**
461     * @dev total number of tokens in existence
462     */
463     function totalSupply() public view returns (uint256) {
464         return totalSupply_;
465     }
466 
467     /**
468     * @dev transfer token for a specified address
469     * @param _to The address to transfer to.
470     * @param _value The amount to be transferred.
471     */
472     function transfer(address _to, uint256 _value) public returns (bool) {
473         require(_to != address(0));
474         require(_value <= balances[msg.sender]);
475 
476         balances[msg.sender] = balances[msg.sender] - _value;
477         balances[_to] = balances[_to] + _value;
478         emit Transfer(msg.sender, _to, _value);
479         return true;
480     }
481 
482     /**
483     * @dev Gets the balance of the specified address.
484     * @param _owner The address to query the the balance of.
485     * @return An uint256 representing the amount owned by the passed address.
486     */
487     function balanceOf(address _owner) public view returns (uint256 balance) {
488         return balances[_owner];
489     }
490 
491 }
492 
493 contract StandardToken is ERC20, BasicToken {
494 
495     mapping (address => mapping (address => uint256)) internal allowed;
496 
497 
498     /**
499     * @dev Transfer tokens from one address to another
500     * @param _from address The address which you want to send tokens from
501     * @param _to address The address which you want to transfer to
502     * @param _value uint256 the amount of tokens to be transferred
503     */
504     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
505         require(_to != address(0));
506         require(_value <= balances[_from]);
507         require(_value <= allowed[_from][msg.sender]);
508 
509         balances[_from] = balances[_from] - _value;
510         balances[_to] = balances[_to] + _value;
511         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
512         emit Transfer(_from, _to, _value);
513         return true;
514     }
515 
516     /**
517     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
518     *
519     * Beware that changing an allowance with this method brings the risk that someone may use both the old
520     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
521     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
522     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
523     * @param _spender The address which will spend the funds.
524     * @param _value The amount of tokens to be spent.
525     */
526     function approve(address _spender, uint256 _value) public returns (bool) {
527         allowed[msg.sender][_spender] = _value;
528         emit Approval(msg.sender, _spender, _value);
529 
530         return true;
531     }
532 
533     /**
534     * @dev Function to check the amount of tokens that an owner allowed to a spender.
535     * @param _owner address The address which owns the funds.
536     * @param _spender address The address which will spend the funds.
537     * @return A uint256 specifying the amount of tokens still available for the spender.
538     */
539     function allowance(address _owner, address _spender) public view returns (uint256) {
540         return allowed[_owner][_spender];
541     }
542 
543     /**
544     * @dev Increase the amount of tokens that an owner allowed to a spender.
545     *
546     * approve should be called when allowed[_spender] == 0. To increment
547     * allowed value is better to use this function to avoid 2 calls (and wait until
548     * the first transaction is mined)
549     * From MonolithDAO Token.sol
550     * @param _spender The address which will spend the funds.
551     * @param _addedValue The amount of tokens to increase the allowance by.
552     */
553     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
554         allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;
555         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
556 
557         return true;
558     }
559 
560     /**
561     * @dev Decrease the amount of tokens that an owner allowed to a spender.
562     *
563     * approve should be called when allowed[_spender] == 0. To decrement
564     * allowed value is better to use this function to avoid 2 calls (and wait until
565     * the first transaction is mined)
566     * From MonolithDAO Token.sol
567     * @param _spender The address which will spend the funds.
568     * @param _subtractedValue The amount of tokens to decrease the allowance by.
569     */
570     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
571         uint oldValue = allowed[msg.sender][_spender];
572         if (_subtractedValue >= oldValue) {
573             allowed[msg.sender][_spender] = 0;
574         } else {
575             allowed[msg.sender][_spender] = oldValue - _subtractedValue;
576         }
577         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
578 
579         return true;
580     }
581 
582 }
583 
584 contract MintableToken is StandardToken, Ownable {
585     event Mint(address indexed to, uint256 amount);
586     event MintFinished();
587 
588     bool public mintingFinished = false;
589 
590 
591     modifier canMint() {
592         require(!mintingFinished);
593 
594         _;
595     }
596 
597     /**
598     * @dev Function to mint tokens
599     * @param _to The address that will receive the minted tokens.
600     * @param _amount The amount of tokens to mint.
601     * @return A boolean that indicates if the operation was successful.
602     */
603     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
604         totalSupply_ = totalSupply_ + _amount;
605         balances[_to] = balances[_to] + _amount;
606 
607         emit Mint(_to, _amount);
608         emit Transfer(address(0), _to, _amount);
609 
610         return true;
611     }
612 
613     /**
614     * @dev Function to stop minting new tokens.
615     * @return True if the operation was successful.
616     */
617     function finishMinting() onlyOwner canMint public returns (bool) {
618         mintingFinished = true;
619         emit MintFinished();
620 
621         return true;
622     }
623 }
624 
625 contract DetailedERC20 is ERC20 {
626     string public name;
627     string public symbol;
628     uint8 public decimals;
629 
630     constructor (string _name, string _symbol, uint8 _decimals) public {
631         name = _name;
632         symbol = _symbol;
633         decimals = _decimals;
634     }
635 }
636 
637 contract PausableToken is StandardToken, Pausable {
638 
639     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
640         return super.transfer(_to, _value);
641     }
642 
643     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
644         return super.transferFrom(_from, _to, _value);
645     }
646 
647     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
648         return super.approve(_spender, _value);
649     }
650 
651     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
652         return super.increaseApproval(_spender, _addedValue);
653     }
654 
655     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
656         return super.decreaseApproval(_spender, _subtractedValue);
657     }
658 }
659 
660 contract CappedToken is MintableToken {
661 
662     uint256 public cap;
663 
664     constructor(uint256 _cap) public {
665         require(_cap > 0);
666 
667         cap = _cap;
668     }
669 
670     /**
671     * @dev Function to mint tokens
672     * @param _to The address that will receive the minted tokens.
673     * @param _amount The amount of tokens to mint.
674     * @return A boolean that indicates if the operation was successful.
675     */
676     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
677         require(totalSupply_ + _amount <= cap);
678 
679         return super.mint(_to, _amount);
680     }
681 }
682 
683 contract BurnableToken is BasicToken {
684 
685     event Burn(address indexed burner, uint256 value);
686 
687     /**
688     * @dev Burns a specific amount of tokens.
689     * @param _value The amount of token to be burned.
690     */
691     function burn(uint256 _value) public {
692         _burn(msg.sender, _value);
693     }
694 
695     function _burn(address _who, uint256 _value) internal {
696         require(_value <= balances[_who]);
697         // no need to require value <= totalSupply, since that would imply the
698         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
699 
700         balances[_who] = balances[_who] - _value;
701         totalSupply_ = totalSupply_ - _value;
702         emit Burn(_who, _value);
703         emit Transfer(_who, address(0), _value);
704     }
705 }
706 
707 contract StandardBurnableToken is BurnableToken, StandardToken {
708 
709     /**
710     * @dev Burns a specific amount of tokens from the target address and decrements allowance
711     * @param _from address The address which you want to send tokens from
712     * @param _value uint256 The amount of token to be burned
713     */
714     function burnFrom(address _from, uint256 _value) public {
715         require(_value <= allowed[_from][msg.sender]);
716         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
717         // this function needs to emit an event with the updated approval.
718         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
719         _burn(_from, _value);
720     }
721 }
722 
723 contract W12Token is StandardBurnableToken, CappedToken, DetailedERC20, PausableToken  {
724     constructor() CappedToken(400*(10**24)) DetailedERC20("W12 Token", "W12", 18) public { }
725 }