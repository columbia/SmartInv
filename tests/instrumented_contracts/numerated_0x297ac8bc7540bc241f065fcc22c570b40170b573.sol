1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6  pragma solidity ^0.4.18;
7 
8 /*************************************************************************
9  * import "./math/SafeMath.sol" : start
10  *************************************************************************/
11 
12 
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal constant returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal constant returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 /*************************************************************************
43  * import "./math/SafeMath.sol" : end
44  *************************************************************************/
45 /*************************************************************************
46  * import "./ownership/Ownable.sol" : start
47  *************************************************************************/
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54   address public owner;
55   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61   function Ownable() public { owner = msg.sender; }
62 
63   /**
64    * @dev Throws if called by any account other than the owner.
65    */
66   modifier onlyOwner() { require(msg.sender == owner); _; }
67 
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address newOwner) onlyOwner public {
74     require(newOwner != address(0));
75     OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78 
79 }/*************************************************************************
80  * import "./ownership/Ownable.sol" : end
81  *************************************************************************/
82 /*************************************************************************
83  * import "./TraceToken.sol" : start
84  *************************************************************************/
85 
86 /*************************************************************************
87  * import "./token/MintableToken.sol" : start
88  *************************************************************************/
89 
90 
91 /*************************************************************************
92  * import "./StandardToken.sol" : start
93  *************************************************************************/
94 
95 
96 /*************************************************************************
97  * import "./BasicToken.sol" : start
98  *************************************************************************/
99 
100 
101 /*************************************************************************
102  * import "./ERC20Basic.sol" : start
103  *************************************************************************/
104 
105 
106 /**
107  * @title ERC20Basic
108  * @dev Simpler version of ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/179
110  */
111 contract ERC20Basic {
112   uint256 public totalSupply;
113   function balanceOf(address who) public constant returns (uint256);
114   function transfer(address to, uint256 value) public returns (bool);
115   event Transfer(address indexed from, address indexed to, uint256 value);
116 }
117 /*************************************************************************
118  * import "./ERC20Basic.sol" : end
119  *************************************************************************/
120 
121 
122 
123 /**
124  * @title Basic token
125  * @dev Basic version of StandardToken, with no allowances.
126  */
127 contract BasicToken is ERC20Basic {
128   using SafeMath for uint256;
129 
130   mapping(address => uint256) balances;
131 
132   /**
133   * @dev transfer token for a specified address
134   * @param _to The address to transfer to.
135   * @param _value The amount to be transferred.
136   */
137   function transfer(address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[msg.sender]);
140 
141     // SafeMath.sub will throw if there is not enough balance.
142     balances[msg.sender] = balances[msg.sender].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     Transfer(msg.sender, _to, _value);
145     return true;
146   }
147 
148   /**
149   * @dev Gets the balance of the specified address.
150   * @param _owner The address to query the the balance of.
151   * @return An uint256 representing the amount owned by the passed address.
152   */
153   function balanceOf(address _owner) public constant returns (uint256 balance) {
154     return balances[_owner];
155   }
156 
157 }
158 /*************************************************************************
159  * import "./BasicToken.sol" : end
160  *************************************************************************/
161 /*************************************************************************
162  * import "./ERC20.sol" : start
163  *************************************************************************/
164 
165 
166 
167 
168 
169 /**
170  * @title ERC20 interface
171  * @dev see https://github.com/ethereum/EIPs/issues/20
172  */
173 contract ERC20 is ERC20Basic {
174   function allowance(address owner, address spender) public constant returns (uint256);
175   function transferFrom(address from, address to, uint256 value) public returns (bool);
176   function approve(address spender, uint256 value) public returns (bool);
177   event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 /*************************************************************************
180  * import "./ERC20.sol" : end
181  *************************************************************************/
182 
183 
184 /**
185  * @title Standard ERC20 token
186  *
187  * @dev Implementation of the basic standard token.
188  * @dev https://github.com/ethereum/EIPs/issues/20
189  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
190  */
191 contract StandardToken is ERC20, BasicToken {
192 
193   mapping (address => mapping (address => uint256)) internal allowed;
194 
195 
196   /**
197    * @dev Transfer tokens from one address to another
198    * @param _from address The address which you want to send tokens from
199    * @param _to address The address which you want to transfer to
200    * @param _value uint256 the amount of tokens to be transferred
201    */
202   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
203     require(_to != address(0));
204     require(_value <= balances[_from]);
205     require(_value <= allowed[_from][msg.sender]);
206 
207     balances[_from] = balances[_from].sub(_value);
208     balances[_to] = balances[_to].add(_value);
209     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
210     Transfer(_from, _to, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216    *
217    * Beware that changing an allowance with this method brings the risk that someone may use both the old
218    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221    * @param _spender The address which will spend the funds.
222    * @param _value The amount of tokens to be spent.
223    */
224   function approve(address _spender, uint256 _value) public returns (bool) {
225     // mitigating the race condition
226     assert(allowed[msg.sender][_spender] == 0 || _value == 0);
227     
228     allowed[msg.sender][_spender] = _value;
229     Approval(msg.sender, _spender, _value);
230     return true;
231   }
232 
233   /**
234    * @dev Function to check the amount of tokens that an owner allowed to a spender.
235    * @param _owner address The address which owns the funds.
236    * @param _spender address The address which will spend the funds.
237    * @return A uint256 specifying the amount of tokens still available for the spender.
238    */
239   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
240     return allowed[_owner][_spender];
241   }
242 
243   /**
244    * approve should be called when allowed[_spender] == 0. To increment
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    */
249   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
250     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
251     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
256     uint oldValue = allowed[msg.sender][_spender];
257     if (_subtractedValue > oldValue) {
258       allowed[msg.sender][_spender] = 0;
259     } else {
260       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
261     }
262     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263     return true;
264   }
265 
266 }
267 /*************************************************************************
268  * import "./StandardToken.sol" : end
269  *************************************************************************/
270 
271 
272 
273 
274 /**
275  * @title Mintable token
276  * @dev Simple ERC20 Token example, with mintable token creation
277  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
278  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
279  */
280 
281 contract MintableToken is StandardToken, Ownable {
282   event Mint(address indexed to, uint256 amount);
283   event MintFinished();
284 
285   bool public mintingFinished = false;
286 
287 
288   modifier canMint() {
289     require(!mintingFinished);
290     _;
291   }
292 
293   /**
294    * @dev Function to mint tokens
295    * @param _to The address that will receive the minted tokens.
296    * @param _amount The amount of tokens to mint.
297    * @return A boolean that indicates if the operation was successful.
298    */
299   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
300     totalSupply = totalSupply.add(_amount);
301     balances[_to] = balances[_to].add(_amount);
302     Mint(_to, _amount);
303     Transfer(0x0, _to, _amount);
304     return true;
305   }
306 
307   /**
308    * @dev Function to stop minting new tokens.
309    * @return True if the operation was successful.
310    */
311   function finishMinting() onlyOwner public returns (bool) {
312     mintingFinished = true;
313     MintFinished();
314     return true;
315   }
316 }
317 /*************************************************************************
318  * import "./token/MintableToken.sol" : end
319  *************************************************************************/
320 
321 contract TraceToken is MintableToken {
322 
323     string public constant name = 'Trace Token';
324     string public constant symbol = 'TRACE';
325     uint8 public constant decimals = 18;
326     bool public transferAllowed = false;
327 
328     event Transfer(address indexed from, address indexed to, uint256 value);
329     event TransferAllowed(bool transferIsAllowed);
330 
331     modifier canTransfer() {
332         require(mintingFinished && transferAllowed);
333         _;        
334     }
335 
336     function transferFrom(address from, address to, uint256 value) canTransfer public returns (bool) {
337         return super.transferFrom(from, to, value);
338     }
339 
340     function transfer(address to, uint256 value) canTransfer public returns (bool) {
341         return super.transfer(to, value);
342     }
343 
344     function mint(address contributor, uint256 amount) public returns (bool) {
345         return super.mint(contributor, amount);
346     }
347 
348     function endMinting(bool _transferAllowed) public returns (bool) {
349         transferAllowed = _transferAllowed;
350         TransferAllowed(_transferAllowed);
351         return super.finishMinting();
352     }
353 }
354 /*************************************************************************
355  * import "./TraceToken.sol" : end
356  *************************************************************************/
357 
358 contract TraceTokenSale is Ownable{
359 	using SafeMath for uint256;
360 
361 	// Presale token
362 	TraceToken public token;
363 
364   // amount of tokens in existance - 500mil TRACE = 5e26 Tracks
365   uint256 public constant TOTAL_NUM_TOKENS = 5e26; // 1 TRACE = 1e18 Tracks, all units in contract in Tracks
366   uint256 public constant tokensForSale = 25e25; // 50% of all tokens
367 
368   // totalEthers received
369   uint256 public totalEthers = 0;
370 
371   // Minimal possible cap in ethers
372   uint256 public constant softCap = 3984.064 ether; 
373   // Maximum possible cap in ethers
374   uint256 public constant hardCap = 17928.287 ether; 
375   
376   uint256 public constant presaleLimit = 7968.127 ether; 
377   bool public presaleLimitReached = false;
378 
379   // Minimum and maximum investments in Ether
380   uint256 public constant min_investment_eth = 0.5 ether; // fixed value, not changing
381   uint256 public constant max_investment_eth = 398.4064 ether; 
382 
383   uint256 public constant min_investment_presale_eth = 5 ether; // fixed value, not changing
384 
385   // refund if softCap is not reached
386   bool public refundAllowed = false;
387 
388   // pause flag
389   bool public paused = false;
390 
391   uint256 public constant bountyReward = 1e25;
392   uint256 public constant preicoAndAdvisors = 4e25;
393   uint256 public constant liquidityPool = 25e24;
394   uint256 public constant futureDevelopment = 1e26; 
395   uint256 public constant teamAndFounders = 75e24;  
396 
397   uint256 public leftOverTokens = 0;
398 
399   uint256[8] public founderAmounts = [uint256(teamAndFounders.div(8)),teamAndFounders.div(8),teamAndFounders.div(8),teamAndFounders.div(8),teamAndFounders.div(8),teamAndFounders.div(8),teamAndFounders.div(8),teamAndFounders.div(8)];
400   uint256[2]  public preicoAndAdvisorsAmounts = [ uint256(preicoAndAdvisors.mul(2).div(5)),preicoAndAdvisors.mul(2).div(5)];
401 
402 
403   // Withdraw multisig wallet
404   address public wallet;
405 
406   // Withdraw multisig wallet
407   address public teamAndFoundersWallet;
408 
409   // Withdraw multisig wallet
410   address public advisorsAndPreICO;
411 
412   // Token per ether
413   uint256 public constant token_per_wei = 12550;
414 
415   // start and end timestamp where investments are allowed (both inclusive)
416   uint256 public startTime;
417   uint256 public endTime;
418 
419   uint256 private constant weekInSeconds = 86400 * 7;
420 
421   // whitelist addresses and planned investment amounts
422   mapping(address => uint256) public whitelist;
423 
424   // amount of ether received from token buyers
425   mapping(address => uint256) public etherBalances;
426 
427   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
428   event Whitelist(address indexed beneficiary, uint256 value);
429   event SoftCapReached();
430   event Finalized();
431 
432   function TraceTokenSale(uint256 _startTime, address traceTokenAddress, address _wallet, address _teamAndFoundersWallet, address _advisorsAndPreICO) public {
433     require(_startTime >=  now);
434     require(_wallet != 0x0);
435     require(_teamAndFoundersWallet != 0x0);
436     require(_advisorsAndPreICO != 0x0);
437 
438     token = TraceToken(traceTokenAddress);
439     wallet = _wallet;
440     teamAndFoundersWallet = _teamAndFoundersWallet;
441     advisorsAndPreICO = _advisorsAndPreICO;
442     startTime = _startTime;
443     endTime = _startTime + 4 * weekInSeconds; // the sale lasts a maximum of 5 weeks
444     
445   }
446     /*
447      * @dev fallback for processing ether
448      */
449      function() public payable {
450        return buyTokens(msg.sender);
451      }
452 
453      function calcAmount() internal view returns (uint256) {
454 
455       if (totalEthers >= presaleLimit || startTime + 2 * weekInSeconds  < now ){
456         // presale has ended
457         return msg.value.mul(token_per_wei);
458         }else{
459           // presale ongoing
460           require(msg.value >= min_investment_presale_eth);
461 
462           /* discount 20 % in the first week - presale week 1 */
463           if (now <= startTime + weekInSeconds) {
464             return msg.value.mul(token_per_wei.mul(100)).div(80);
465 
466           }
467 
468           /* discount 15 % in the second week - presale week 2 */
469           if ( startTime +  weekInSeconds  < now ) {
470            return msg.value.mul(token_per_wei.mul(100)).div(85);
471          }
472        }
473 
474      }
475 
476     /*
477      * @dev sell token and send to contributor address
478      * @param contributor address
479      */
480      function buyTokens(address contributor) public payable {
481        require(!hasEnded());
482        require(!isPaused());
483        require(validPurchase());
484        require(checkWhitelist(contributor,msg.value));
485        uint256 amount = calcAmount();
486        require((token.totalSupply() + amount) <= TOTAL_NUM_TOKENS);
487        
488        whitelist[contributor] = whitelist[contributor].sub(msg.value);
489        etherBalances[contributor] = etherBalances[contributor].add(msg.value);
490 
491        totalEthers = totalEthers.add(msg.value);
492 
493        token.mint(contributor, amount);
494        require(totalEthers <= hardCap); 
495        TokenPurchase(0x0, contributor, msg.value, amount);
496      }
497 
498 
499      // @return user balance
500      function balanceOf(address _owner) public view returns (uint256 balance) {
501       return token.balanceOf(_owner);
502     }
503 
504     function checkWhitelist(address contributor, uint256 eth_amount) public view returns (bool) {
505      require(contributor!=0x0);
506      require(eth_amount>0);
507      return (whitelist[contributor] >= eth_amount);
508    }
509 
510    function addWhitelist(address contributor, uint256 eth_amount) onlyOwner public returns (bool) {
511      require(!hasEnded());
512      require(contributor!=0x0);
513      require(eth_amount>0);
514      Whitelist(contributor, eth_amount);
515      whitelist[contributor] = eth_amount;
516      return true;
517    }
518 
519    function addWhitelists(address[] contributors, uint256[] amounts) onlyOwner public returns (bool) {
520      require(!hasEnded());
521      address contributor;
522      uint256 amount;
523      require(contributors.length == amounts.length);
524 
525      for (uint i = 0; i < contributors.length; i++) {
526       contributor = contributors[i];
527       amount = amounts[i];
528       require(addWhitelist(contributor, amount));
529     }
530     return true;
531   }
532 
533 
534   function validPurchase() internal view returns (bool) {
535 
536    bool withinPeriod = now >= startTime && now <= endTime;
537    bool withinPurchaseLimits = msg.value >= min_investment_eth && msg.value <= max_investment_eth;
538    return withinPeriod && withinPurchaseLimits;
539  }
540 
541  function hasStarted() public view returns (bool) {
542   return now >= startTime;
543 }
544 
545 function hasEnded() public view returns (bool) {
546   return now > endTime || token.totalSupply() == TOTAL_NUM_TOKENS;
547 }
548 
549 
550 function hardCapReached() public view returns (bool) {
551   return hardCap.mul(999).div(1000) <= totalEthers; 
552 }
553 
554 function softCapReached() public view returns(bool) {
555   return totalEthers >= softCap;
556 }
557 
558 
559 function withdraw() onlyOwner public {
560   require(softCapReached());
561   require(this.balance > 0);
562 
563   wallet.transfer(this.balance);
564 }
565 
566 function withdrawTokenToFounders() onlyOwner public {
567   require(softCapReached());
568   require(hasEnded());
569 
570   if (now > startTime + 720 days && founderAmounts[7]!=0){
571     token.transfer(teamAndFoundersWallet, founderAmounts[7]);
572     founderAmounts[7] = 0;
573   }
574 
575   if (now > startTime + 630 days && founderAmounts[6]!=0){
576     token.transfer(teamAndFoundersWallet, founderAmounts[6]);
577     founderAmounts[6] = 0;
578   }
579   if (now > startTime + 540 days && founderAmounts[5]!=0){
580     token.transfer(teamAndFoundersWallet, founderAmounts[5]);
581     founderAmounts[5] = 0;
582   }
583   if (now > startTime + 450 days && founderAmounts[4]!=0){
584     token.transfer(teamAndFoundersWallet, founderAmounts[4]);
585     founderAmounts[4] = 0;
586   }
587   if (now > startTime + 360 days&& founderAmounts[3]!=0){
588     token.transfer(teamAndFoundersWallet, founderAmounts[3]);
589     founderAmounts[3] = 0;
590   }
591   if (now > startTime + 270 days && founderAmounts[2]!=0){
592     token.transfer(teamAndFoundersWallet, founderAmounts[2]);
593     founderAmounts[2] = 0;
594   }
595   if (now > startTime + 180 days && founderAmounts[1]!=0){
596     token.transfer(teamAndFoundersWallet, founderAmounts[1]);
597     founderAmounts[1] = 0;
598   }
599   if (now > startTime + 90 days && founderAmounts[0]!=0){
600     token.transfer(teamAndFoundersWallet, founderAmounts[0]);
601     founderAmounts[0] = 0;
602   }
603 }
604 
605 function withdrawTokensToAdvisors() onlyOwner public {
606   require(softCapReached());
607   require(hasEnded());
608 
609   if (now > startTime + 180 days && preicoAndAdvisorsAmounts[1]!=0){
610     token.transfer(advisorsAndPreICO, preicoAndAdvisorsAmounts[1]);
611     preicoAndAdvisorsAmounts[1] = 0;
612   }
613 
614   if (now > startTime + 90 days && preicoAndAdvisorsAmounts[0]!=0){
615     token.transfer(advisorsAndPreICO, preicoAndAdvisorsAmounts[0]);
616     preicoAndAdvisorsAmounts[0] = 0;
617   }
618 }
619 
620 function refund() public {
621   require(refundAllowed);
622   require(hasEnded());
623   require(!softCapReached());
624   require(etherBalances[msg.sender] > 0);
625   require(token.balanceOf(msg.sender) > 0);
626 
627   uint256 current_balance = etherBalances[msg.sender];
628   etherBalances[msg.sender] = 0;
629   token.transfer(this,token.balanceOf(msg.sender)); // burning tokens by sending back to contract
630   msg.sender.transfer(current_balance);
631 }
632 
633 
634 function finishCrowdsale() onlyOwner public returns (bool){
635   require(!token.mintingFinished());
636   require(hasEnded() || hardCapReached());
637 
638   if(softCapReached()) {
639     token.mint(wallet, bountyReward);
640     token.mint(advisorsAndPreICO,  preicoAndAdvisors.div(5)); //20% available immediately
641     token.mint(wallet, liquidityPool);
642     token.mint(wallet, futureDevelopment);
643     token.mint(this, teamAndFounders);
644     token.mint(this, preicoAndAdvisors.mul(4).div(5)); 
645     leftOverTokens = TOTAL_NUM_TOKENS.sub(token.totalSupply());
646     token.mint(wallet,leftOverTokens); // will be equaly distributed among all presale and sale contributors after the sale
647 
648     token.endMinting(true);
649     return true;
650     } else {
651       refundAllowed = true;
652       token.endMinting(false);
653       return false;
654     }
655 
656     Finalized();
657   }
658 
659 
660   // additional functionality, used to pause crowdsale for 24h
661   function pauseSale() onlyOwner public returns (bool){
662     paused = true;
663     return true;
664   }
665 
666   function unpauseSale() onlyOwner public returns (bool){
667     paused = false;
668     return true;
669   }
670 
671   function isPaused() public view returns (bool){
672     return paused;
673   }
674 }