1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // SencTokenSale - SENC Token Sale Contract
5 //
6 // Copyright (c) 2018 InfoCorp Technologies Pte Ltd.
7 // http://www.sentinel-chain.org/
8 //
9 // The MIT Licence.
10 // ----------------------------------------------------------------------------
11 
12 // ----------------------------------------------------------------------------
13 // The SENC Token Sale is organised as follows:
14 // 1. 10% (50,000,000) of total supply will be minted and sent to founding team weallet.
15 // 2. 20% (100,000,000) of total supply will be minted and sent to early supporter wallet.
16 // 3. 20% (100,000,000) of total supply will be minted and sent to presale wallet.
17 // 4. 20% (100,000,000) of total supply will be available for minting and purchase by public.
18 // 5. 30% (150,000,000) of total supply will be minted and sent to treaury wallet.
19 // 6. Public sale is designed to be made available in batches.
20 // 
21 // Tokens can only be purchased by contributors depending on the batch that
22 // contributors are assigned to in the WhiteListed smart contract to prevent a
23 // gas war. Each batch will be assigned a timestamp. Contributors can only 
24 // make purchase once the current timestamp on the main net is above the 
25 // batch's assigned timestamp.
26 //    - batch 0: start_date 00:01   (guaranteed allocations)
27 //    - batch 1: start_date+1 00:01 (guaranteed allocations)
28 //    - batch 2: start_date+2 00:01 (guaranteed and non-guaranteed allocations)
29 //    - batch 3: start_date+2 12:01 (guaranteed and non-guaranteed allocations)
30 // ----------------------------------------------------------------------------
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38   function Ownable() public {
39     owner = msg.sender;
40   }
41 
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   function transferOwnership(address newOwner) public onlyOwner {
48     require(newOwner != address(0));
49     OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54 
55 contract Pausable is Ownable {
56   event Pause();
57   event Unpause();
58 
59   bool public paused = false;
60 
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   modifier whenPaused() {
67     require(paused);
68     _;
69   }
70 
71   function pause() onlyOwner whenNotPaused public {
72     paused = true;
73     Pause();
74   }
75 
76   function unpause() onlyOwner whenPaused public {
77     paused = false;
78     Unpause();
79   }
80 }
81 
82 contract ERC20Basic {
83   function totalSupply() public view returns (uint256);
84   function balanceOf(address who) public view returns (uint256);
85   function transfer(address to, uint256 value) public returns (bool);
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) public view returns (uint256);
91   function transferFrom(address from, address to, uint256 value) public returns (bool);
92   function approve(address spender, uint256 value) public returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 contract BasicToken is ERC20Basic {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100 
101   uint256 totalSupply_;
102 
103   function totalSupply() public view returns (uint256) {
104     return totalSupply_;
105   }
106 
107   function transfer(address _to, uint256 _value) public returns (bool) {
108     require(_to != address(0));
109     require(_value <= balances[msg.sender]);
110 
111     // SafeMath.sub will throw if there is not enough balance.
112     balances[msg.sender] = balances[msg.sender].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     Transfer(msg.sender, _to, _value);
115     return true;
116   }
117 
118   function balanceOf(address _owner) public view returns (uint256 balance) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
129     require(_to != address(0));
130     require(_value <= balances[_from]);
131     require(_value <= allowed[_from][msg.sender]);
132 
133     balances[_from] = balances[_from].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
136     Transfer(_from, _to, _value);
137     return true;
138   }
139 
140   function approve(address _spender, uint256 _value) public returns (bool) {
141     allowed[msg.sender][_spender] = _value;
142     Approval(msg.sender, _spender, _value);
143     return true;
144   }
145  
146   function allowance(address _owner, address _spender) public view returns (uint256) {
147     return allowed[_owner][_spender];
148   }
149 
150   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
151     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
152     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
153     return true;
154   }
155 
156   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
157     uint oldValue = allowed[msg.sender][_spender];
158     if (_subtractedValue > oldValue) {
159       allowed[msg.sender][_spender] = 0;
160     } else {
161       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
162     }
163     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166 
167 }
168 
169 contract PausableToken is StandardToken, Pausable {
170 
171   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
172     return super.transfer(_to, _value);
173   }
174 
175   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
176     return super.transferFrom(_from, _to, _value);
177   }
178 
179   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
180     return super.approve(_spender, _value);
181   }
182 
183   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
184     return super.increaseApproval(_spender, _addedValue);
185   }
186 
187   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
188     return super.decreaseApproval(_spender, _subtractedValue);
189   }
190 }
191 
192 contract OperatableBasic {
193     function setPrimaryOperator (address addr) public;
194     function setSecondaryOperator (address addr) public;
195     function isPrimaryOperator(address addr) public view returns (bool);
196     function isSecondaryOperator(address addr) public view returns (bool);
197 }
198 
199 contract Operatable is Ownable, OperatableBasic {
200     address public primaryOperator;
201     address public secondaryOperator;
202 
203     modifier canOperate() {
204         require(msg.sender == primaryOperator || msg.sender == secondaryOperator || msg.sender == owner);
205         _;
206     }
207 
208     function Operatable() public {
209         primaryOperator = owner;
210         secondaryOperator = owner;
211     }
212 
213     function setPrimaryOperator (address addr) public onlyOwner {
214         primaryOperator = addr;
215     }
216 
217     function setSecondaryOperator (address addr) public onlyOwner {
218         secondaryOperator = addr;
219     }
220 
221     function isPrimaryOperator(address addr) public view returns (bool) {
222         return (addr == primaryOperator);
223     }
224 
225     function isSecondaryOperator(address addr) public view returns (bool) {
226         return (addr == secondaryOperator);
227     }
228 }
229 
230 contract Salvageable is Operatable {
231     // Salvage other tokens that are accidentally sent into this token
232     function emergencyERC20Drain(ERC20 oddToken, uint amount) public canOperate {
233         if (address(oddToken) == address(0)) {
234             owner.transfer(amount);
235             return;
236         }
237         oddToken.transfer(owner, amount);
238     }
239 }
240 
241 contract WhiteListedBasic is OperatableBasic {
242     function addWhiteListed(address[] addrs, uint[] batches, uint[] weiAllocation) external;
243     function getAllocated(address addr) public view returns (uint);
244     function getBatchNumber(address addr) public view returns (uint);
245     function getWhiteListCount() public view returns (uint);
246     function isWhiteListed(address addr) public view returns (bool);
247     function removeWhiteListed(address addr) public;
248     function setAllocation(address[] addrs, uint[] allocation) public;
249     function setBatchNumber(address[] addrs, uint[] batch) public;
250 }
251 
252 library SafeMath {
253 
254   /**
255   * @dev Multiplies two numbers, throws on overflow.
256   */
257   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
258     if (a == 0) {
259       return 0;
260     }
261     uint256 c = a * b;
262     assert(c / a == b);
263     return c;
264   }
265 
266   /**
267   * @dev Integer division of two numbers, truncating the quotient.
268   */
269   function div(uint256 a, uint256 b) internal pure returns (uint256) {
270     // assert(b > 0); // Solidity automatically throws when dividing by 0
271     uint256 c = a / b;
272     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
273     return c;
274   }
275 
276   /**
277   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
278   */
279   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
280     assert(b <= a);
281     return a - b;
282   }
283 
284   /**
285   * @dev Adds two numbers, throws on overflow.
286   */
287   function add(uint256 a, uint256 b) internal pure returns (uint256) {
288     uint256 c = a + b;
289     assert(c >= a);
290     return c;
291   }
292 }
293 
294 
295 contract SencTokenConfig {
296     string public constant NAME = "Sentinel Chain Token";
297     string public constant SYMBOL = "SENC";
298     uint8 public constant DECIMALS = 18;
299     uint public constant DECIMALSFACTOR = 10 ** uint(DECIMALS);
300     uint public constant TOTALSUPPLY = 500000000 * DECIMALSFACTOR;
301 }
302 
303 contract SencToken is PausableToken, SencTokenConfig, Salvageable {
304     using SafeMath for uint;
305 
306     string public name = NAME;
307     string public symbol = SYMBOL;
308     uint8 public decimals = DECIMALS;
309     bool public mintingFinished = false;
310 
311     event Mint(address indexed to, uint amount);
312     event MintFinished();
313 
314     modifier canMint() {
315         require(!mintingFinished);
316         _;
317     }
318 
319     function SencToken() public {
320         paused = true;
321     }
322 
323     function pause() onlyOwner public {
324         revert();
325     }
326 
327     function unpause() onlyOwner public {
328         super.unpause();
329     }
330 
331     function mint(address _to, uint _amount) onlyOwner canMint public returns (bool) {
332         require(totalSupply_.add(_amount) <= TOTALSUPPLY);
333         totalSupply_ = totalSupply_.add(_amount);
334         balances[_to] = balances[_to].add(_amount);
335         Mint(_to, _amount);
336         Transfer(address(0), _to, _amount);
337         return true;
338     }
339 
340     function finishMinting() onlyOwner canMint public returns (bool) {
341         mintingFinished = true;
342         MintFinished();
343         return true;
344     }
345 
346     // Airdrop tokens from bounty wallet to contributors as long as there are enough balance
347     function airdrop(address bountyWallet, address[] dests, uint[] values) public onlyOwner returns (uint) {
348         require(dests.length == values.length);
349         uint i = 0;
350         while (i < dests.length && balances[bountyWallet] >= values[i]) {
351             this.transferFrom(bountyWallet, dests[i], values[i]);
352             i += 1;
353         }
354         return(i);
355     }
356 }
357 
358 contract SencTokenSaleConfig is SencTokenConfig {
359     uint public constant TOKEN_FOUNDINGTEAM =  50000000 * DECIMALSFACTOR;
360     uint public constant TOKEN_EARLYSUPPORTERS = 100000000 * DECIMALSFACTOR;
361     uint public constant TOKEN_PRESALE = 100000000 * DECIMALSFACTOR;
362     uint public constant TOKEN_TREASURY = 150000000 * DECIMALSFACTOR;
363     uint public constant MILLION = 1000000;
364     uint public constant PUBLICSALE_USD_PER_MSENC =  80000;
365     uint public constant PRIVATESALE_USD_PER_MSENC =  64000;
366     uint public constant MIN_CONTRIBUTION      = 120 finney;
367 }
368 
369 contract SencTokenSale is SencTokenSaleConfig, Ownable, Pausable, Salvageable {
370     using SafeMath for uint;
371     bool public isFinalized = false;
372 
373     SencToken public token;
374     uint[] public batchStartTimes;
375     uint public endTime;
376     uint public startTime;
377     address public agTechWallet;        // InfoCorp AgTech Wallet Address to receive ETH
378     uint public usdPerMEth;             // USD per million ETH. E.g. ETHUSD 844.81 is specified as 844,810,000
379     uint public publicSaleSencPerMEth;  // Amount of token 1 million ETH can buy in public sale
380     uint public privateSaleSencPerMEth; // Amount of token 1 million ETH can buy in private sale
381     uint public weiRaised;              // Amount of raised money in WEI
382     WhiteListedBasic public whiteListed;
383     uint public numContributors;        // Discrete number of contributors
384 
385     mapping (address => uint) public contributions; // to allow them to have multiple spends
386 
387     event Finalized();
388     event TokenPurchase(address indexed beneficiary, uint value, uint amount);
389     event TokenPresale(address indexed purchaser, uint amount);
390     event TokenFoundingTeam(address purchaser, uint amount);
391     event TokenTreasury(address purchaser, uint amount);
392     event EarlySupporters(address purchaser, uint amount);
393 
394     function SencTokenSale(uint[] _batchStartTimes, uint _endTime, uint _usdPerMEth, uint _presaleWei,
395         WhiteListedBasic _whiteListed, address _agTechWallet,  address _foundingTeamWallet,
396         address _earlySupportersWallet, address _treasuryWallet, address _presaleWallet, address _tokenIssuer
397     ) public {
398         require(_batchStartTimes.length > 0);
399         // require (now < batchStartTimes[0]);
400         for (uint i = 0; i < _batchStartTimes.length - 1; i++) {
401             require(_batchStartTimes[i+1] > _batchStartTimes[i]);
402         }
403         require(_endTime >= _batchStartTimes[_batchStartTimes.length - 1]);
404         require(_usdPerMEth > 0);
405         require(_whiteListed != address(0));
406         require(_agTechWallet != address(0));
407         require(_foundingTeamWallet != address(0));
408         require(_earlySupportersWallet != address(0));
409         require(_presaleWallet != address(0));
410         require(_treasuryWallet != address(0));
411         owner = _tokenIssuer;
412 
413         batchStartTimes = _batchStartTimes;
414         startTime = _batchStartTimes[0];
415         endTime = _endTime;
416         agTechWallet = _agTechWallet;
417         whiteListed = _whiteListed;
418         weiRaised = _presaleWei;
419         usdPerMEth = _usdPerMEth;
420         publicSaleSencPerMEth = usdPerMEth.mul(MILLION).div(PUBLICSALE_USD_PER_MSENC);
421         privateSaleSencPerMEth = usdPerMEth.mul(MILLION).div(PRIVATESALE_USD_PER_MSENC);
422 
423         // Let the token stuff begin
424         token = new SencToken();
425 
426         // Mint initial tokens
427         mintEarlySupportersTokens(_earlySupportersWallet, TOKEN_EARLYSUPPORTERS);
428         mintPresaleTokens(_presaleWallet, TOKEN_PRESALE);
429         mintTreasuryTokens(_treasuryWallet, TOKEN_TREASURY);
430         mintFoundingTeamTokens(_foundingTeamWallet, TOKEN_FOUNDINGTEAM);
431     }
432 
433     function getBatchStartTimesLength() public view returns (uint) {
434         return batchStartTimes.length;
435     }
436 
437     function updateBatchStartTime(uint _batchNumber, uint _batchStartTime) public canOperate {
438         batchStartTimes[_batchNumber] = _batchStartTime;
439 	for (uint i = 0; i < batchStartTimes.length - 1; i++) {
440             require(batchStartTimes[i+1] > batchStartTimes[i]);
441         }
442     }
443 
444     function updateEndTime(uint _endTime) public canOperate {
445 	require(_endTime >= batchStartTimes[batchStartTimes.length - 1]);
446         endTime = _endTime;
447     }
448 
449     function updateUsdPerMEth(uint _usdPerMEth) public canOperate {
450         require(now < batchStartTimes[0]);
451         usdPerMEth = _usdPerMEth;
452         publicSaleSencPerMEth = usdPerMEth.mul(MILLION).div(PUBLICSALE_USD_PER_MSENC);
453         privateSaleSencPerMEth = usdPerMEth.mul(MILLION).div(PRIVATESALE_USD_PER_MSENC);
454     }
455 
456     function mintEarlySupportersTokens(address addr, uint amount) internal {
457         token.mint(addr, amount);
458         EarlySupporters(addr, amount);
459     }
460 
461     function mintTreasuryTokens(address addr, uint amount) internal {
462         token.mint(addr, amount);
463         TokenTreasury(addr, amount);
464     }
465 
466     function mintFoundingTeamTokens(address addr, uint amount) internal {
467         token.mint(addr, amount);
468         TokenFoundingTeam(addr, amount);
469     }
470 
471     function mintPresaleTokens(address addr, uint amount) internal {
472         token.mint(addr, amount);
473         TokenPresale(addr, amount);
474     }
475 
476     // Only fallback function can be used to buy tokens
477     function () external payable {
478         buyTokens(msg.sender, msg.value);
479     }
480 
481     function buyTokens(address beneficiary, uint weiAmount) internal whenNotPaused {
482         require(beneficiary != address(0));
483         require(isWhiteListed(beneficiary));
484         require(isWithinPeriod(beneficiary));
485         require(isWithinAllocation(beneficiary, weiAmount));
486 
487         uint tokens = weiAmount.mul(publicSaleSencPerMEth).div(MILLION);
488         weiRaised = weiRaised.add(weiAmount);
489 
490         if (contributions[beneficiary] == 0) {
491             numContributors++;
492         }
493 
494         contributions[beneficiary] = contributions[beneficiary].add(weiAmount);
495         token.mint(beneficiary, tokens);
496         TokenPurchase(beneficiary, weiAmount, tokens);
497 
498         forwardFunds();
499     }
500 
501     function ethRaised() public view returns(uint) {
502         return weiRaised.div(10 ** 18);
503     }
504 
505     function usdRaised() public view returns(uint) {
506         return weiRaised.mul(usdPerMEth).div(MILLION);
507     }
508 
509     function sencSold() public view returns(uint) {
510         return token.totalSupply();
511     }
512 
513     function sencBalance() public view returns(uint) {
514         return token.TOTALSUPPLY().sub(token.totalSupply());
515     }
516 
517     // This can be used after the sale is over and tokens are unpaused
518     function reclaimTokens() external canOperate {
519         uint balance = token.balanceOf(this);
520         token.transfer(owner, balance);
521     }
522 
523     // Batch is in 0..n-1 format
524     function isBatchActive(uint batch) public view returns (bool) {
525         if (now > endTime) {
526             return false;
527         }
528         if (uint(batch) >= batchStartTimes.length) {
529             return false;
530         }
531         if (now > batchStartTimes[batch]) {
532             return true;
533         }
534         return false;
535     }
536 
537     // Returns
538     // 0                           - not started
539     // 1..batchStartTimes.length   - batch plus 1
540     // batchStartTimes.length + 1  - ended
541     function batchActive() public view returns (uint) {
542         if (now > endTime) {
543             return batchStartTimes.length + 1;
544         }
545         for (uint i = batchStartTimes.length; i > 0; i--) {
546             if (now > batchStartTimes[i-1]) {
547                 return i;
548             }
549         }
550         return 0;
551     }
552 
553     // Return true if crowdsale event has ended
554     function hasEnded() public view returns (bool) {
555         return now > endTime;
556     }
557 
558     // Send ether to the fund collection wallet
559     function forwardFunds() internal {
560         agTechWallet.transfer(msg.value);
561     }
562 
563     // Buyer must be whitelisted
564     function isWhiteListed(address beneficiary) internal view returns (bool) {
565         return whiteListed.isWhiteListed(beneficiary);
566     }
567 
568     // Buyer must by within assigned batch period
569     function isWithinPeriod(address beneficiary) internal view returns (bool) {
570         uint batchNumber = whiteListed.getBatchNumber(beneficiary);
571         return now >= batchStartTimes[batchNumber] && now <= endTime;
572     }
573 
574     // Buyer must by withint allocated amount
575     function isWithinAllocation(address beneficiary, uint weiAmount) internal view returns (bool) {
576         uint allocation = whiteListed.getAllocated(beneficiary);
577         return (weiAmount >= MIN_CONTRIBUTION) && (weiAmount.add(contributions[beneficiary]) <= allocation);
578     }
579 
580     // Must be called after crowdsale ends, to do some extra finalization
581     function finalize() onlyOwner public {
582         require(!isFinalized);
583         require(hasEnded());
584 
585         finalization();
586         Finalized();
587 
588         isFinalized = true;
589     }
590 
591     // Stops the minting and transfer token ownership to sale owner. Mints unsold tokens to owner
592     function finalization() internal {
593         token.mint(owner,sencBalance());
594         token.finishMinting();
595         token.transferOwnership(owner);
596     }
597 }