1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract ERC20Basic {
67   uint256 public totalSupply;
68   function balanceOf(address who) public constant returns (uint256);
69   function transfer(address to, uint256 value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   /**
79   * @dev transfer token for a specified address
80   * @param _to The address to transfer to.
81   * @param _value The amount to be transferred.
82   */
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85 
86     // SafeMath.sub will throw if there is not enough balance.
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98   function balanceOf(address _owner) public constant returns (uint256 balance) {
99     return balances[_owner];
100   }
101 
102 }
103 
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public constant returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124 
125     uint256 _allowance = allowed[_from][msg.sender];
126 
127     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
128     // require (_value <= _allowance);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = _allowance.sub(_value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    *
140    * Beware that changing an allowance with this method brings the risk that someone may use both the old
141    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144    * @param _spender The address which will spend the funds.
145    * @param _value The amount of tokens to be spent.
146    */
147   function approve(address _spender, uint256 _value) public returns (bool) {
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
160     return allowed[_owner][_spender];
161   }
162 
163   /**
164    * approve should be called when allowed[_spender] == 0. To increment
165    * allowed value is better to use this function to avoid 2 calls (and wait until
166    * the first transaction is mined)
167    * From MonolithDAO Token.sol
168    */
169   function increaseApproval (address _spender, uint _addedValue)
170     returns (bool success) {
171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176   function decreaseApproval (address _spender, uint _subtractedValue)
177     returns (bool success) {
178     uint oldValue = allowed[msg.sender][_spender];
179     if (_subtractedValue > oldValue) {
180       allowed[msg.sender][_spender] = 0;
181     } else {
182       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183     }
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188 }
189 
190 contract MintableToken is StandardToken, Ownable {
191   event Mint(address indexed to, uint256 amount);
192   event MintFinished();
193 
194   bool public mintingFinished = false;
195 
196 
197   modifier canMint() {
198     require(!mintingFinished);
199     _;
200   }
201 
202   /**
203    * @dev Function to mint tokens
204    * @param _to The address that will receive the minted tokens.
205    * @param _amount The amount of tokens to mint.
206    * @return A boolean that indicates if the operation was successful.
207    */
208   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
209     totalSupply = totalSupply.add(_amount);
210     balances[_to] = balances[_to].add(_amount);
211     Mint(_to, _amount);
212     Transfer(0x0, _to, _amount);
213     return true;
214   }
215 
216   /**
217    * @dev Function to stop minting new tokens.
218    * @return True if the operation was successful.
219    */
220   function finishMinting() onlyOwner public returns (bool) {
221     mintingFinished = true;
222     MintFinished();
223     return true;
224   }
225 }
226 
227 contract MultiOwners {
228 
229     event AccessGrant(address indexed owner);
230     event AccessRevoke(address indexed owner);
231     
232     mapping(address => bool) owners;
233     address public publisher;
234 
235 
236     function MultiOwners() {
237         owners[msg.sender] = true;
238         publisher = msg.sender;
239     }
240 
241     modifier onlyOwner() { 
242         require(owners[msg.sender] == true);
243         _; 
244     }
245 
246     function isOwner() constant returns (bool) {
247         return owners[msg.sender] ? true : false;
248     }
249 
250     function checkOwner(address maybe_owner) constant returns (bool) {
251         return owners[maybe_owner] ? true : false;
252     }
253 
254 
255     function grant(address _owner) onlyOwner {
256         owners[_owner] = true;
257         AccessGrant(_owner);
258     }
259 
260     function revoke(address _owner) onlyOwner {
261         require(_owner != publisher);
262         require(msg.sender != _owner);
263 
264         owners[_owner] = false;
265         AccessRevoke(_owner);
266     }
267 }
268 
269 contract Haltable is MultiOwners {
270     bool public halted;
271 
272     modifier stopInEmergency {
273         require(!halted);
274         _;
275     }
276 
277     modifier onlyInEmergency {
278         require(halted);
279         _;
280     }
281 
282     // called by the owner on emergency, triggers stopped state
283     function halt() external onlyOwner {
284         halted = true;
285     }
286 
287     // called by the owner on end of emergency, returns to normal state
288     function unhalt() external onlyOwner onlyInEmergency {
289         halted = false;
290     }
291 
292 }
293 
294 contract StagePercentageStep is MultiOwners {
295     using SafeMath for uint256;
296 
297     string public name;
298     uint256 public tokenPriceInETH;
299     uint256 public mintCapInETH;
300     uint256 public mintCapInUSD;
301     uint256 public mintCapInTokens;
302     uint256 public hardCapInTokens;
303     uint256 public totalWei;
304     uint256 public bonusAvailable;
305     uint256 public bonusTotalSupply;
306     
307 
308     struct Round {
309         uint256 windowInTokens;
310         uint256 windowInETH;
311         uint256 accInETH;
312         uint256 accInTokens;
313         uint256 nextAccInETH;
314         uint256 nextAccInTokens;
315         uint256 discount;
316         uint256 priceInETH;
317         uint256 weightPercentage;
318     }
319     
320     Round[] public rounds;
321     
322     function StagePercentageStep(string _name) {
323         name = _name;
324     }
325     
326     function totalEther() public constant returns(uint256) {
327         return totalWei.div(1e18);
328     }
329 
330     function registerRound(uint256 priceDiscount, uint256 weightPercentage) internal {
331         uint256 windowInETH;
332         uint256 windowInTokens;
333         uint256 accInETH = 0;
334         uint256 accInTokens = 0;
335         uint256 priceInETH;
336         
337         
338         priceInETH = tokenPriceInETH.mul(100-priceDiscount).div(100);
339         windowInETH = mintCapInETH.mul(weightPercentage).div(100);
340         windowInTokens = windowInETH.mul(1e18).div(priceInETH);
341 
342         if(rounds.length > 0) {
343             accInTokens = accInTokens.add(rounds[rounds.length-1].nextAccInTokens);
344             accInETH = accInETH.add(rounds[rounds.length-1].nextAccInETH);
345         }
346 
347         rounds.push(Round({
348             windowInETH: windowInETH,
349             windowInTokens: windowInTokens,
350             accInETH: accInETH,
351             accInTokens: accInTokens,
352             nextAccInETH: accInETH + windowInETH,
353             nextAccInTokens: accInTokens + windowInTokens,
354             weightPercentage: weightPercentage,
355             discount: priceDiscount,
356             priceInETH: priceInETH
357         }));
358         mintCapInTokens = mintCapInTokens.add(windowInTokens);
359         hardCapInTokens = mintCapInTokens.mul(120).div(100);
360     }
361     
362     /*
363      * @dev calculate amount
364      * @param _value ether to be converted to tokens
365      * @param _totalEthers total received ETH
366      * @return tokens amount that we should send to our dear investor
367      * @return odd ethers amount, which contract should send back
368      */
369     function calcAmount(
370         uint256 _amount,
371         uint256 _totalEthers
372     ) public constant returns (uint256 estimate, uint256 amount) {
373         Round memory round;
374         uint256 totalEthers = _totalEthers;
375         amount = _amount;
376         
377         for(uint256 i; i<rounds.length; i++) {
378             round = rounds[i];
379 
380             if(!(totalEthers >= round.accInETH && totalEthers < round.nextAccInETH)) {
381                 continue;
382             }
383             
384             if(totalEthers.add(amount) < round.nextAccInETH) {
385                 return (estimate + amount.mul(1e18).div(round.priceInETH), 0);
386             }
387 
388             amount = amount.sub(round.nextAccInETH.sub(totalEthers));
389             estimate = estimate + (
390                 round.nextAccInETH.sub(totalEthers).mul(1e18).div(round.priceInETH)
391             );
392             totalEthers = round.nextAccInETH;
393         }
394         return (estimate, amount);
395     }    
396 }
397 
398 contract SessiaCrowdsale is StagePercentageStep, Haltable {
399     using SafeMath for uint256;
400 
401     // min wei per tx
402     uint256 public ethPriceInUSD = 680e2; // 460 USD per one ETH
403     uint256 public minimalUSD = 680e2; // minimal sale 500 USD
404     uint256 public minimalWei = minimalUSD.mul(1e18).div(ethPriceInUSD); // 1.087 ETH
405 
406     // Token
407     SessiaToken public token;
408 
409     // Withdraw wallet
410     address public wallet;
411 
412     // period
413     uint256 public startTime;
414     uint256 public endTime;
415 
416     //
417     address public bonusMintingAgent;
418 
419 
420     event ETokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
421     event ETransferOddEther(address indexed beneficiary, uint256 value);
422     event ESetBonusMintingAgent(address agent);
423     event ESetStartTime(uint256 new_startTime);
424     event ESetEndTime(uint256 new_endTime);
425     event EManualMinting(address indexed beneficiary, uint256 value, uint256 amount);
426     event EBonusMinting(address indexed beneficiary, uint256 value);
427 
428 
429     modifier validPurchase() {
430         bool nonZeroPurchase = msg.value != 0;
431         
432         require(withinPeriod() && nonZeroPurchase);
433 
434         _;        
435     }
436 
437     function SessiaCrowdsale(
438         uint256 _startTime,  // 1526482800 05/16/2018 @ 3:00pm (UTC)
439         uint256 _endTime,  //  1537110000 09/16/2018 @ 3:00pm (UTC)
440         address _wallet,  // 0x62926204Fb0f6B01D9530C0d2AcCe194b07dEfA8
441         address _bonusMintingAgent
442     )
443         public
444         StagePercentageStep("Pre-ITO") 
445      {
446         require(_startTime >= 0);
447         require(_endTime > _startTime);
448 
449         token = new SessiaToken();
450         token.grant(_bonusMintingAgent);
451         token.grant(_wallet);
452 
453         bonusMintingAgent = _bonusMintingAgent;
454         wallet = _wallet;
455 
456         startTime = _startTime;
457         endTime = _endTime;
458 
459         tokenPriceInETH = 1e15; // 0.001 ETH
460         mintCapInUSD = 3000000e2; // 3.000.000 USD * 100 cents
461         mintCapInETH = mintCapInUSD.mul(1e18).div(ethPriceInUSD);
462     
463         registerRound({priceDiscount: 30, weightPercentage: 10});
464         registerRound({priceDiscount: 20, weightPercentage: 20});
465         registerRound({priceDiscount: 10, weightPercentage: 30});
466         registerRound({priceDiscount: 0, weightPercentage: 40});
467     
468         require(bonusMintingAgent != 0);
469         require(wallet != 0x0);
470     }
471 
472     function withinPeriod() constant public returns (bool) {
473         return (now >= startTime && now <= endTime);
474     }
475 
476     // @return false if crowdsale event was ended
477     function running() constant public returns (bool) {
478         return withinPeriod() && !token.mintingFinished();
479     }
480 
481     /*
482      * @dev change agent for bonus minting
483      * @praram agent new agent address
484      */
485     function setBonusMintingAgent(address agent) public onlyOwner {
486         require(agent != address(this));
487         token.revoke(bonusMintingAgent);
488         token.grant(agent);
489         bonusMintingAgent = agent;
490         ESetBonusMintingAgent(agent);
491     }
492 
493     // @return current stage name
494     function stageName() constant public returns (string) {
495         bool beforePeriod = (now < startTime);
496 
497         if(beforePeriod) {
498             return "Not started";
499         }
500 
501         if(withinPeriod()) {
502             return name;
503         } 
504 
505         return "Finished";
506     }
507 
508     /*
509      * @dev fallback for processing ether
510      */
511     function() public payable {
512         return buyTokens(msg.sender);
513     }
514 
515     /*
516      * @dev set start date
517      * @param _at — new start date
518      */
519     function setStartTime(uint256 _at) public onlyOwner {
520         require(block.timestamp < _at); // should be great than current block timestamp
521         require(_at < endTime);
522 
523         startTime = _at;
524         ESetStartTime(_at);
525     }
526 
527     /*
528      * @dev set end date
529      * @param _at — new end date
530      */
531     function setEndTime(uint256 _at) public onlyOwner {
532         require(startTime < _at);  // should be great than current block timestamp
533 
534         endTime = _at;
535         ESetEndTime(_at);
536     }
537 
538     /*
539      * @dev Large Token Holder minting 
540      * @param to - mint to address
541      * @param amount - how much mint
542      */
543     function bonusMinting(address to, uint256 amount) stopInEmergency public {
544         require(msg.sender == bonusMintingAgent || isOwner());
545         require(amount <= bonusAvailable);
546         require(token.totalSupply() + amount <= hardCapInTokens);
547 
548         bonusTotalSupply = bonusTotalSupply.add(amount);
549         bonusAvailable = bonusAvailable.sub(amount);
550         EBonusMinting(to, amount);
551         token.mint(to, amount);
552     }
553 
554     /*
555      * @dev sell token and send to contributor address
556      * @param contributor address
557      */
558     function buyTokens(address contributor) payable stopInEmergency validPurchase public {
559         require(contributor != 0x0);
560         require(msg.value >= minimalWei);
561 
562         uint256 amount;
563         uint256 odd_ethers;
564         uint256 ethers;
565         
566         (amount, odd_ethers) = calcAmount(msg.value, totalWei);  
567         require(amount + token.totalSupply() + bonusAvailable <= hardCapInTokens);
568 
569         ethers = (msg.value.sub(odd_ethers));
570 
571         token.mint(contributor, amount); // fail if minting is finished
572         ETokenPurchase(contributor, ethers, amount);
573         totalWei = totalWei.add(ethers);
574 
575         if(odd_ethers > 0) {
576             require(odd_ethers < msg.value);
577             ETransferOddEther(contributor, odd_ethers);
578             contributor.transfer(odd_ethers);
579         }
580         bonusAvailable = bonusAvailable.add(amount.mul(20).div(100));
581 
582         wallet.transfer(ethers);
583     }
584 
585 
586     /*
587      * @dev manual tokens issuing
588      * @param contributor address, etheres
589      */
590     function manualMinting(address contributor, uint256 value) onlyOwner stopInEmergency public {
591         require(withinPeriod());
592         require(contributor != 0x0);
593         require(value >= minimalWei);
594 
595         uint256 amount;
596         uint256 odd_ethers;
597         uint256 ethers;
598         
599         (amount, odd_ethers) = calcAmount(value, totalWei);
600         require(amount + token.totalSupply() + bonusAvailable <= hardCapInTokens);
601 
602         ethers = value.sub(odd_ethers);
603 
604         token.mint(contributor, amount); // fail if minting is finished
605         EManualMinting(contributor, amount, ethers);
606         totalWei = totalWei.add(ethers);
607         bonusAvailable = bonusAvailable.add(amount.mul(20).div(100));
608     }
609 
610     function finishCrowdsale() onlyOwner public {
611         require(block.timestamp > endTime || (mintCapInETH - totalWei) <= 1e18);
612         require(!token.mintingFinished());
613 
614         if(bonusAvailable > 0) {
615             bonusMinting(wallet, bonusAvailable);
616         }
617         token.finishMinting();
618     }
619 
620 }
621 
622 contract SessiaToken is MintableToken, MultiOwners {
623 
624     string public constant name = "Sessia Kickers";
625     string public constant symbol = "PRE-KICK";
626     uint8 public constant decimals = 18;
627 
628     function transferFrom(address from, address to, uint256 value) public returns (bool) {
629         if(!isOwner()) {
630             revert();
631         }
632         return super.transferFrom(from, to, value);
633     }
634 
635     function transfer(address to, uint256 value) public returns (bool) {
636         if(!isOwner()) {
637             revert();
638         }
639         return super.transfer(to, value);
640     }
641 
642     function grant(address _owner) public {
643         require(publisher == msg.sender);
644         return super.grant(_owner);
645     }
646 
647     function revoke(address _owner) public {
648         require(publisher == msg.sender);
649         return super.revoke(_owner);
650     }
651 
652     function mint(address _to, uint256 _amount) public returns (bool) {
653         require(publisher == msg.sender);
654         return super.mint(_to, _amount);
655     }
656 
657 }