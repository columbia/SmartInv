1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: contracts/TokenVesting.sol
97 
98 /**
99  * @title Vesting contract for SDT
100  * @dev see https://send.sd/token
101  */
102 contract TokenVesting is Ownable {
103   using SafeMath for uint256;
104 
105   address public ico;
106   bool public initialized;
107   bool public active;
108   ERC20Basic public token;
109   mapping (address => TokenGrant[]) public grants;
110 
111   uint256 public circulatingSupply = 0;
112 
113   struct TokenGrant {
114     uint256 value;
115     uint256 claimed;
116     uint256 vesting;
117     uint256 start;
118   }
119 
120   event NewTokenGrant (
121     address indexed to,
122     uint256 value,
123     uint256 start,
124     uint256 vesting
125   );
126 
127   event NewTokenClaim (
128     address indexed holder,
129     uint256 value
130   );
131 
132   modifier icoResticted() {
133     require(msg.sender == ico);
134     _;
135   }
136 
137   modifier isActive() {
138     require(active);
139     _;
140   }
141 
142   function TokenVesting() public {
143     active = false;
144   }
145 
146   function init(address _token, address _ico) public onlyOwner {
147     token = ERC20Basic(_token);
148     ico = _ico;
149     initialized = true;
150     active = true;
151   }
152 
153   function stop() public isActive onlyOwner {
154     active = false;
155   }
156 
157   function resume() public onlyOwner {
158     require(!active);
159     require(initialized);
160     active = true;
161   }
162 
163   /**
164   * @dev Grant vested tokens.
165   * @notice Only for ICO contract address.
166   * @param _to Addres to grant tokens to.
167   * @param _value Number of tokens granted.
168   * @param _vesting Vesting finish timestamp.
169   * @param _start Vesting start timestamp.
170   */
171   function grantVestedTokens(
172       address _to,
173       uint256 _value,
174       uint256 _start,
175       uint256 _vesting
176   ) public icoResticted isActive {
177     require(_value > 0);
178     require(_vesting > _start);
179     require(grants[_to].length < 10);
180 
181     TokenGrant memory grant = TokenGrant(_value, 0, _vesting, _start);
182     grants[_to].push(grant);
183 
184     NewTokenGrant(_to, _value, _start, _vesting);
185   }
186 
187   /**
188   * @dev Claim all vested tokens up to current date for myself
189   */
190   function claimTokens() public {
191     claim(msg.sender);
192   }
193 
194   /**
195   * @dev Claim all vested tokens up to current date in behaviour of an user
196   * @param _to address Addres to claim tokens
197   */
198   function claimTokensFor(address _to) public onlyOwner {
199     claim(_to);
200   }
201 
202   /**
203   * @dev Get claimable tokens
204   */
205   function claimableTokens() public constant returns (uint256) {
206     address _to = msg.sender;
207     uint256 numberOfGrants = grants[_to].length;
208 
209     if (numberOfGrants == 0) {
210       return 0;
211     }
212 
213     uint256 claimable = 0;
214     uint256 claimableFor = 0;
215     for (uint256 i = 0; i < numberOfGrants; i++) {
216       claimableFor = calculateVestedTokens(
217         grants[_to][i].value,
218         grants[_to][i].vesting,
219         grants[_to][i].start,
220         grants[_to][i].claimed
221       );
222       claimable = claimable.add(claimableFor);
223     }
224     return claimable;
225   }
226 
227   /**
228   * @dev Get all veted tokens
229   */
230   function totalVestedTokens() public constant returns (uint256) {
231     address _to = msg.sender;
232     uint256 numberOfGrants = grants[_to].length;
233 
234     if (numberOfGrants == 0) {
235       return 0;
236     }
237 
238     uint256 claimable = 0;
239     for (uint256 i = 0; i < numberOfGrants; i++) {
240       claimable = claimable.add(
241         grants[_to][i].value.sub(grants[_to][i].claimed)
242       );
243     }
244     return claimable;
245   }
246 
247   /**
248   * @dev Calculate vested claimable tokens on current time
249   * @param _tokens Number of tokens granted
250   * @param _vesting Vesting finish timestamp
251   * @param _start Vesting start timestamp
252   * @param _claimed Number of tokens already claimed
253   */
254   function calculateVestedTokens(
255       uint256 _tokens,
256       uint256 _vesting,
257       uint256 _start,
258       uint256 _claimed
259   ) internal constant returns (uint256) {
260     uint256 time = block.timestamp;
261 
262     if (time < _start) {
263       return 0;
264     }
265 
266     if (time >= _vesting) {
267       return _tokens.sub(_claimed);
268     }
269 
270     uint256 vestedTokens = _tokens.mul(time.sub(_start)).div(
271       _vesting.sub(_start)
272     );
273 
274     return vestedTokens.sub(_claimed);
275   }
276 
277   /**
278   * @dev Claim all vested tokens up to current date
279   */
280   function claim(address _to) internal {
281     uint256 numberOfGrants = grants[_to].length;
282 
283     if (numberOfGrants == 0) {
284       return;
285     }
286 
287     uint256 claimable = 0;
288     uint256 claimableFor = 0;
289     for (uint256 i = 0; i < numberOfGrants; i++) {
290       claimableFor = calculateVestedTokens(
291         grants[_to][i].value,
292         grants[_to][i].vesting,
293         grants[_to][i].start,
294         grants[_to][i].claimed
295       );
296       claimable = claimable.add(claimableFor);
297       grants[_to][i].claimed = grants[_to][i].claimed.add(claimableFor);
298     }
299 
300     token.transfer(_to, claimable);
301     circulatingSupply += claimable;
302 
303     NewTokenClaim(_to, claimable);
304   }
305 }
306 
307 // File: zeppelin-solidity/contracts/token/BasicToken.sol
308 
309 /**
310  * @title Basic token
311  * @dev Basic version of StandardToken, with no allowances.
312  */
313 contract BasicToken is ERC20Basic {
314   using SafeMath for uint256;
315 
316   mapping(address => uint256) balances;
317 
318   /**
319   * @dev transfer token for a specified address
320   * @param _to The address to transfer to.
321   * @param _value The amount to be transferred.
322   */
323   function transfer(address _to, uint256 _value) public returns (bool) {
324     require(_to != address(0));
325     require(_value <= balances[msg.sender]);
326 
327     // SafeMath.sub will throw if there is not enough balance.
328     balances[msg.sender] = balances[msg.sender].sub(_value);
329     balances[_to] = balances[_to].add(_value);
330     Transfer(msg.sender, _to, _value);
331     return true;
332   }
333 
334   /**
335   * @dev Gets the balance of the specified address.
336   * @param _owner The address to query the the balance of.
337   * @return An uint256 representing the amount owned by the passed address.
338   */
339   function balanceOf(address _owner) public view returns (uint256 balance) {
340     return balances[_owner];
341   }
342 
343 }
344 
345 // File: zeppelin-solidity/contracts/token/BurnableToken.sol
346 
347 /**
348  * @title Burnable Token
349  * @dev Token that can be irreversibly burned (destroyed).
350  */
351 contract BurnableToken is BasicToken {
352 
353     event Burn(address indexed burner, uint256 value);
354 
355     /**
356      * @dev Burns a specific amount of tokens.
357      * @param _value The amount of token to be burned.
358      */
359     function burn(uint256 _value) public {
360         require(_value <= balances[msg.sender]);
361         // no need to require value <= totalSupply, since that would imply the
362         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
363 
364         address burner = msg.sender;
365         balances[burner] = balances[burner].sub(_value);
366         totalSupply = totalSupply.sub(_value);
367         Burn(burner, _value);
368     }
369 }
370 
371 // File: contracts/TokenSale.sol
372 
373 /**
374  * @title Crowdsale contract
375  * @dev see https://send.sd/crowdsale
376  */
377 contract TokenSale is Ownable {
378   using SafeMath for uint256;
379 
380   /* Leave 10 tokens margin error in order to succedd
381   with last pool allocation in case hard cap is reached */
382   uint256 constant public HARD_CAP = 70000000 ether;
383   uint256 constant public VESTING_TIME = 90 days;
384   uint256 public weiUsdRate = 1;
385   uint256 public btcUsdRate = 1;
386 
387   uint256 public vestingEnds;
388   uint256 public startTime;
389   uint256 public endTime;
390   address public wallet;
391 
392   uint256 public vestingStarts;
393 
394   uint256 public soldTokens;
395   uint256 public raised;
396 
397   bool public activated = false;
398   bool public isStopped = false;
399   bool public isFinalized = false;
400 
401   BurnableToken public token;
402   TokenVesting public vesting;
403 
404   event NewBuyer(
405     address indexed holder,
406     uint256 sndAmount,
407     uint256 usdAmount,
408     uint256 ethAmount,
409     uint256 btcAmount
410   );
411 
412   event ClaimedTokens(
413     address indexed _token,
414     address indexed _controller,
415     uint256 _amount
416   );
417 
418   modifier validAddress(address _address) {
419     require(_address != address(0x0));
420     _;
421   }
422 
423   modifier isActive() {
424     require(activated);
425     require(!isStopped);
426     require(!isFinalized);
427     require(block.timestamp >= startTime);
428     require(block.timestamp <= endTime);
429     _;
430   }
431 
432   function TokenSale(
433       uint256 _startTime,
434       uint256 _endTime,
435       address _wallet,
436       uint256 _vestingStarts
437   ) public validAddress(_wallet) {
438     require(_startTime > block.timestamp - 60);
439     require(_endTime > startTime);
440     require(_vestingStarts > startTime);
441 
442     vestingStarts = _vestingStarts;
443     vestingEnds = vestingStarts.add(VESTING_TIME);
444     startTime = _startTime;
445     endTime = _endTime;
446     wallet = _wallet;
447   }
448 
449   /**
450    * @dev set an exchange rate in wei
451    * @param _rate uint256 The new exchange rate
452    */
453   function setWeiUsdRate(uint256 _rate) public onlyOwner {
454     require(_rate > 0);
455     weiUsdRate = _rate;
456   }
457 
458   /**
459    * @dev set an exchange rate in satoshis
460    * @param _rate uint256 The new exchange rate
461    */
462   function setBtcUsdRate(uint256 _rate) public onlyOwner {
463     require(_rate > 0);
464     btcUsdRate = _rate;
465   }
466 
467   /**
468    * @dev initialize the contract and set token
469    */
470   function initialize(
471       address _sdt,
472       address _vestingContract,
473       address _icoCostsPool,
474       address _distributionContract
475   ) public validAddress(_sdt) validAddress(_vestingContract) onlyOwner {
476     require(!activated);
477     activated = true;
478 
479     token = BurnableToken(_sdt);
480     vesting = TokenVesting(_vestingContract);
481 
482     // 1% reserve is released on deploy
483     token.transfer(_icoCostsPool, 7000000 ether);
484     token.transfer(_distributionContract, 161000000 ether);
485 
486     //early backers allocation
487     uint256 threeMonths = vestingStarts.add(90 days);
488 
489     updateStats(0, 43387693 ether);
490     grantVestedTokens(0x02f807E6a1a59F8714180B301Cba84E76d3B4d06, 22572063 ether, vestingStarts, threeMonths);
491     grantVestedTokens(0x3A1e89dD9baDe5985E7Eb36E9AFd200dD0E20613, 15280000 ether, vestingStarts, threeMonths);
492     grantVestedTokens(0xA61c9A0E96eC7Ceb67586fC8BFDCE009395D9b21, 250000 ether, vestingStarts, threeMonths);
493     grantVestedTokens(0x26C9899eA2F8940726BbCC79483F2ce07989314E, 100000 ether, vestingStarts, threeMonths);
494     grantVestedTokens(0xC88d5031e00BC316bE181F0e60971e8fEdB9223b, 1360000 ether, vestingStarts, threeMonths);
495     grantVestedTokens(0x38f4cAD7997907741FA0D912422Ae59aC6b83dD1, 250000 ether, vestingStarts, threeMonths);
496     grantVestedTokens(0x2b2992e51E86980966c42736C458e2232376a044, 105000 ether, vestingStarts, threeMonths);
497     grantVestedTokens(0xdD0F60610052bE0976Cf8BEE576Dbb3a1621a309, 140000 ether, vestingStarts, threeMonths);
498     grantVestedTokens(0xd61B4F33D3413827baa1425E2FDa485913C9625B, 740000 ether, vestingStarts, threeMonths);
499     grantVestedTokens(0xE6D4a77D01C680Ebbc0c84393ca598984b3F45e3, 505630 ether, vestingStarts, threeMonths);
500     grantVestedTokens(0x35D3648c29Ac180D5C7Ef386D52de9539c9c487a, 150000 ether, vestingStarts, threeMonths);
501     grantVestedTokens(0x344a6130d187f51ef0DAb785e10FaEA0FeE4b5dE, 967500 ether, vestingStarts, threeMonths);
502     grantVestedTokens(0x026cC76a245987f3420D0FE30070B568b4b46F68, 967500 ether, vestingStarts, threeMonths);
503   }
504 
505   function finalize(
506       address _poolA,
507       address _poolB,
508       address _poolC,
509       address _poolD
510   )
511       public
512       validAddress(_poolA)
513       validAddress(_poolB)
514       validAddress(_poolC)
515       validAddress(_poolD)
516       onlyOwner
517   {
518     grantVestedTokens(_poolA, 175000000 ether, vestingStarts, vestingStarts.add(7 years));
519     grantVestedTokens(_poolB, 168000000 ether, vestingStarts, vestingStarts.add(7 years));
520     grantVestedTokens(_poolC, 70000000 ether, vestingStarts, vestingStarts.add(7 years));
521     grantVestedTokens(_poolD, 48999990 ether, vestingStarts, vestingStarts.add(4 years));
522 
523     token.burn(token.balanceOf(this));
524   }
525 
526   function stop() public onlyOwner isActive returns(bool) {
527     isStopped = true;
528     return true;
529   }
530 
531   function resume() public onlyOwner returns(bool) {
532     require(isStopped);
533     isStopped = false;
534     return true;
535   }
536 
537   function () public payable {
538     uint256 usd = msg.value.div(weiUsdRate);
539     doPurchase(usd, msg.value, 0, msg.sender, vestingEnds);
540     forwardFunds();
541   }
542 
543   function btcPurchase(
544       address _beneficiary,
545       uint256 _btcValue
546   ) public onlyOwner validAddress(_beneficiary) {
547     uint256 usd = _btcValue.div(btcUsdRate);
548     doPurchase(usd, 0, _btcValue, _beneficiary, vestingEnds);
549   }
550 
551   /**
552   * @dev Number of tokens is given by:
553   * usd * 100 ether / 14
554   */
555   function computeTokens(uint256 _usd) public pure returns(uint256) {
556     return _usd.mul(100 ether).div(14);
557   }
558 
559   //////////
560   // Safety Methods
561   //////////
562   /// @notice This method can be used by the controller to extract mistakenly
563   ///  sent tokens to this contract.
564   /// @param _token The address of the token contract that you want to recover
565   ///  set to 0 in case you want to extract ether.
566   function claimTokens(address _token) public onlyOwner {
567     require(_token != address(token));
568     if (_token == 0x0) {
569       owner.transfer(this.balance);
570       return;
571     }
572 
573     ERC20Basic erc20token = ERC20Basic(_token);
574     uint256 balance = erc20token.balanceOf(this);
575     erc20token.transfer(owner, balance);
576     ClaimedTokens(_token, owner, balance);
577   }
578 
579   function forwardFunds() internal {
580     wallet.transfer(msg.value);
581   }
582 
583   /**
584    * @notice The owner of this contract is the owner of token's contract
585    * @param _usd amount invested in USD
586    * @param _eth amount invested in ETH y contribution was made in ETH, 0 otherwise
587    * @param _btc amount invested in BTC y contribution was made in BTC, 0 otherwise
588    * @param _address Address to send tokens to
589    * @param _vestingEnds vesting finish timestamp
590    */
591   function doPurchase(
592       uint256 _usd,
593       uint256 _eth,
594       uint256 _btc,
595       address _address,
596       uint256 _vestingEnds
597   )
598       internal
599       isActive
600       returns(uint256)
601   {
602     require(_usd >= 10);
603 
604     uint256 soldAmount = computeTokens(_usd);
605 
606     updateStats(_usd, soldAmount);
607     grantVestedTokens(_address, soldAmount, vestingStarts, _vestingEnds);
608     NewBuyer(_address, soldAmount, _usd, _eth, _btc);
609 
610     return soldAmount;
611   }
612 
613   /**
614    * @dev Helper function to update collected and allocated tokens stats
615    */
616   function updateStats(uint256 usd, uint256 tokens) internal {
617     raised = raised.add(usd);
618     soldTokens = soldTokens.add(tokens);
619 
620     require(soldTokens <= HARD_CAP);
621   }
622 
623   /**
624    * @dev grant vested tokens
625    * @param _to Adress to grant vested tokens
626    * @param _value number of tokens to grant
627    * @param _start vesting start timestamp
628    * @param _vesting vesting finish timestamp
629    */
630   function grantVestedTokens(
631       address _to,
632       uint256 _value,
633       uint256 _start,
634       uint256 _vesting
635   ) internal {
636     token.transfer(vesting, _value);
637     vesting.grantVestedTokens(_to, _value, _start, _vesting);
638   }
639 }