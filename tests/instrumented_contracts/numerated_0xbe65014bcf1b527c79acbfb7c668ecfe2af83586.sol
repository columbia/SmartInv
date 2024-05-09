1 pragma solidity ^0.4.18;
2 
3 /**
4  * WorldCoin: https://worldcoin.cash
5  */
6 
7 //====== Open Zeppelin Library =====
8 /**
9  * @title ERC20Basic
10  * @dev Simpler version of ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/179
12  */
13 contract ERC20Basic {
14   uint256 public totalSupply;
15   function balanceOf(address who) public view returns (uint256);
16   function transfer(address to, uint256 value) public returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36     if (a == 0) {
37       return 0;
38     }
39     uint256 c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 /**
64  * @title SafeERC20
65  * @dev Wrappers around ERC20 operations that throw on failure.
66  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
67  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
68  */
69 library SafeERC20 {
70   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
71     assert(token.transfer(to, value));
72   }
73 
74   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
75     assert(token.transferFrom(from, to, value));
76   }
77 
78   function safeApprove(ERC20 token, address spender, uint256 value) internal {
79     assert(token.approve(spender, value));
80   }
81 }
82 
83 /**
84  * @title Ownable
85  * @dev The Ownable contract has an owner address, and provides basic authorization control
86  * functions, this simplifies the implementation of "user permissions".
87  */
88 contract Ownable {
89   address public owner;
90 
91 
92   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93 
94 
95   /**
96    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
97    * account.
98    */
99   function Ownable() public {
100     owner = msg.sender;
101   }
102 
103 
104   /**
105    * @dev Throws if called by any account other than the owner.
106    */
107   modifier onlyOwner() {
108     require(msg.sender == owner);
109     _;
110   }
111 
112 
113   /**
114    * @dev Allows the current owner to transfer control of the contract to a newOwner.
115    * @param newOwner The address to transfer ownership to.
116    */
117   function transferOwnership(address newOwner) public onlyOwner {
118     require(newOwner != address(0));
119     OwnershipTransferred(owner, newOwner);
120     owner = newOwner;
121   }
122 
123 }
124 
125 /**
126  * @title Contracts that should not own Ether
127  * @author Remco Bloemen <remco@2π.com>
128  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
129  * in the contract, it will allow the owner to reclaim this ether.
130  * @notice Ether can still be send to this contract by:
131  * calling functions labeled `payable`
132  * `selfdestruct(contract_address)`
133  * mining directly to the contract address
134 */
135 contract HasNoEther is Ownable {
136 
137   /**
138   * @dev Constructor that rejects incoming Ether
139   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
140   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
141   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
142   * we could use assembly to access msg.value.
143   */
144   function HasNoEther() public payable {
145     require(msg.value == 0);
146   }
147 
148   /**
149    * @dev Disallows direct send by settings a default function without the `payable` flag.
150    */
151   function() external {
152   }
153 
154   /**
155    * @dev Transfer all Ether held by the contract to the owner.
156    */
157   function reclaimEther() external onlyOwner {
158     assert(owner.send(this.balance));
159   }
160 }
161 
162 /**
163  * @title Contracts that should not own Contracts
164  * @author Remco Bloemen <remco@2π.com>
165  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
166  * of this contract to reclaim ownership of the contracts.
167  */
168 contract HasNoContracts is Ownable {
169 
170   /**
171    * @dev Reclaim ownership of Ownable contracts
172    * @param contractAddr The address of the Ownable to be reclaimed.
173    */
174   function reclaimContract(address contractAddr) external onlyOwner {
175     Ownable contractInst = Ownable(contractAddr);
176     contractInst.transferOwnership(owner);
177   }
178 }
179 
180 /**
181  * @title Contracts that should be able to recover tokens
182  * @author SylTi
183  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
184  * This will prevent any accidental loss of tokens.
185  */
186 contract CanReclaimToken is Ownable {
187   using SafeERC20 for ERC20Basic;
188 
189   /**
190    * @dev Reclaim all ERC20Basic compatible tokens
191    * @param token ERC20Basic The address of the token contract
192    */
193   function reclaimToken(ERC20Basic token) external onlyOwner {
194     uint256 balance = token.balanceOf(this);
195     token.safeTransfer(owner, balance);
196   }
197 
198 }
199 
200 /**
201  * @title Contracts that should not own Tokens
202  * @author Remco Bloemen <remco@2π.com>
203  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
204  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
205  * owner to reclaim the tokens.
206  */
207 contract HasNoTokens is CanReclaimToken {
208 
209  /**
210   * @dev Reject all ERC23 compatible tokens
211   * @param from_ address The address that is transferring the tokens
212   * @param value_ uint256 the amount of the specified token
213   * @param data_ Bytes The data passed from the caller.
214   */
215   function tokenFallback(address from_, uint256 value_, bytes data_) external {
216     from_;
217     value_;
218     data_;
219     revert();
220   }
221 
222 }
223 
224 /**
225  * @title Basic token
226  * @dev Basic version of StandardToken, with no allowances.
227  */
228 contract BasicToken is ERC20Basic {
229   using SafeMath for uint256;
230 
231   mapping(address => uint256) balances;
232 
233   /**
234   * @dev transfer token for a specified address
235   * @param _to The address to transfer to.
236   * @param _value The amount to be transferred.
237   */
238   function transfer(address _to, uint256 _value) public returns (bool) {
239     require(_to != address(0));
240     require(_value <= balances[msg.sender]);
241 
242     // SafeMath.sub will throw if there is not enough balance.
243     balances[msg.sender] = balances[msg.sender].sub(_value);
244     balances[_to] = balances[_to].add(_value);
245     Transfer(msg.sender, _to, _value);
246     return true;
247   }
248 
249   /**
250   * @dev Gets the balance of the specified address.
251   * @param _owner The address to query the the balance of.
252   * @return An uint256 representing the amount owned by the passed address.
253   */
254   function balanceOf(address _owner) public view returns (uint256 balance) {
255     return balances[_owner];
256   }
257 
258 }
259 /**
260  * @title Standard ERC20 token
261  *
262  * @dev Implementation of the basic standard token.
263  * @dev https://github.com/ethereum/EIPs/issues/20
264  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
265  */
266 contract StandardToken is ERC20, BasicToken {
267 
268   mapping (address => mapping (address => uint256)) internal allowed;
269 
270 
271   /**
272    * @dev Transfer tokens from one address to another
273    * @param _from address The address which you want to send tokens from
274    * @param _to address The address which you want to transfer to
275    * @param _value uint256 the amount of tokens to be transferred
276    */
277   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
278     require(_to != address(0));
279     require(_value <= balances[_from]);
280     require(_value <= allowed[_from][msg.sender]);
281 
282     balances[_from] = balances[_from].sub(_value);
283     balances[_to] = balances[_to].add(_value);
284     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
285     Transfer(_from, _to, _value);
286     return true;
287   }
288 
289   /**
290    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
291    *
292    * Beware that changing an allowance with this method brings the risk that someone may use both the old
293    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
294    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
295    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
296    * @param _spender The address which will spend the funds.
297    * @param _value The amount of tokens to be spent.
298    */
299   function approve(address _spender, uint256 _value) public returns (bool) {
300     allowed[msg.sender][_spender] = _value;
301     Approval(msg.sender, _spender, _value);
302     return true;
303   }
304 
305   /**
306    * @dev Function to check the amount of tokens that an owner allowed to a spender.
307    * @param _owner address The address which owns the funds.
308    * @param _spender address The address which will spend the funds.
309    * @return A uint256 specifying the amount of tokens still available for the spender.
310    */
311   function allowance(address _owner, address _spender) public view returns (uint256) {
312     return allowed[_owner][_spender];
313   }
314 
315   /**
316    * approve should be called when allowed[_spender] == 0. To increment
317    * allowed value is better to use this function to avoid 2 calls (and wait until
318    * the first transaction is mined)
319    * From MonolithDAO Token.sol
320    */
321   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
322     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
323     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324     return true;
325   }
326 
327   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
328     uint oldValue = allowed[msg.sender][_spender];
329     if (_subtractedValue > oldValue) {
330       allowed[msg.sender][_spender] = 0;
331     } else {
332       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
333     }
334     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
335     return true;
336   }
337 
338 }
339 
340 /**
341  * @title Mintable token
342  * @dev Simple ERC20 Token example, with mintable token creation
343  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
344  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
345  */
346 
347 contract MintableToken is StandardToken, Ownable {
348   event Mint(address indexed to, uint256 amount);
349   event MintFinished();
350 
351   bool public mintingFinished = false;
352 
353 
354   modifier canMint() {
355     require(!mintingFinished);
356     _;
357   }
358 
359   /**
360    * @dev Function to mint tokens
361    * @param _to The address that will receive the minted tokens.
362    * @param _amount The amount of tokens to mint.
363    * @return A boolean that indicates if the operation was successful.
364    */
365   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
366     totalSupply = totalSupply.add(_amount);
367     balances[_to] = balances[_to].add(_amount);
368     Mint(_to, _amount);
369     Transfer(address(0), _to, _amount);
370     return true;
371   }
372 
373   /**
374    * @dev Function to stop minting new tokens.
375    * @return True if the operation was successful.
376    */
377   function finishMinting() onlyOwner canMint public returns (bool) {
378     mintingFinished = true;
379     MintFinished();
380     return true;
381   }
382 }
383 
384 
385 //====== BurnableToken =====
386 
387 contract BurnableToken is StandardToken {
388     using SafeMath for uint256;
389 
390     event Burn(address indexed from, uint256 amount);
391     event BurnRewardIncreased(address indexed from, uint256 value);
392 
393     /**
394     * @dev Sending ether to contract increases burning reward 
395     */
396     function() payable public {
397         if(msg.value > 0){
398             BurnRewardIncreased(msg.sender, msg.value);    
399         }
400     }
401 
402     /**
403      * @dev Calculates how much ether one will receive in reward for burning tokens
404      * @param _amount of tokens to be burned
405      */
406     function burnReward(uint256 _amount) public constant returns(uint256){
407         return this.balance.mul(_amount).div(totalSupply);
408     }
409 
410     /**
411     * @dev Burns tokens and send reward
412     * This is internal function because it DOES NOT check 
413     * if _from has allowance to burn tokens.
414     * It is intended to be used in transfer() and transferFrom() which do this check.
415     * @param _from The address which you want to burn tokens from
416     * @param _amount of tokens to be burned
417     */
418     function burn(address _from, uint256 _amount) internal returns(bool){
419         require(balances[_from] >= _amount);
420         
421         uint256 reward = burnReward(_amount);
422         assert(this.balance - reward > 0);
423 
424         balances[_from] = balances[_from].sub(_amount);
425         totalSupply = totalSupply.sub(_amount);
426         //assert(totalSupply >= 0); //Check is not needed because totalSupply.sub(value) will already throw if this condition is not met
427         
428         _from.transfer(reward);
429         Burn(_from, _amount);
430         Transfer(_from, address(0), _amount);
431         return true;
432     }
433 
434     /**
435     * @dev Transfers or burns tokens
436     * Burns tokens transferred to this contract itself or to zero address
437     * @param _to The address to transfer to or token contract address to burn.
438     * @param _value The amount to be transferred.
439     */
440     function transfer(address _to, uint256 _value) public returns (bool) {
441         if( (_to == address(this)) || (_to == 0) ){
442             return burn(msg.sender, _value);
443         }else{
444             return super.transfer(_to, _value);
445         }
446     }
447 
448     /**
449     * @dev Transfer tokens from one address to another 
450     * or burns them if _to is this contract or zero address
451     * @param _from address The address which you want to send tokens from
452     * @param _to address The address which you want to transfer to
453     * @param _value uint256 the amout of tokens to be transfered
454     */
455     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
456         if( (_to == address(this)) || (_to == 0) ){
457             var _allowance = allowed[_from][msg.sender];
458             //require (_value <= _allowance); //Check is not needed because _allowance.sub(_value) will already throw if this condition is not met
459             allowed[_from][msg.sender] = _allowance.sub(_value);
460             return burn(_from, _value);
461         }else{
462             return super.transferFrom(_from, _to, _value);
463         }
464     }
465 
466 }
467 
468 
469 
470 //====== WorldCoin Contracts =====
471 
472 /**
473  * @title WorldCoin token
474  */
475 contract WorldCoin is BurnableToken, MintableToken, HasNoContracts, HasNoTokens { //MintableToken is StandardToken, Ownable
476     using SafeMath for uint256;
477 
478     string public name = "World Coin Network";
479     string public symbol = "WCN";
480     uint256 public decimals = 18;
481 
482 
483     /**
484      * Allow transfer only after crowdsale finished
485      */
486     modifier canTransfer() {
487         require(mintingFinished);
488         _;
489     }
490     
491     function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
492         return BurnableToken.transfer(_to, _value);
493     }
494 
495     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
496         return BurnableToken.transferFrom(_from, _to, _value);
497     }
498 
499 }
500 
501 /**
502  * @title WorldCoin Crowdsale
503  */
504 contract WorldCoinCrowdsale is Ownable, HasNoContracts, HasNoTokens {
505     using SafeMath for uint256;
506 
507     uint32 private constant PERCENT_DIVIDER = 100;
508 
509     WorldCoin public token;
510 
511     struct Round {
512         uint256 start;      //Timestamp of crowdsale round start
513         uint256 end;        //Timestamp of crowdsale round end
514         uint256 rate;       //Rate: how much TOKEN one will get fo 1 ETH during this round
515     }
516     Round[] public rounds;  //Array of crowdsale rounds
517 
518 
519     uint256 public founderPercent;      //how many tokens will be sent to founder (percent of purshased token)
520     uint256 public partnerBonusPercent; //referral partner bonus (percent of purshased token)
521     uint256 public referralBonusPercent;//referral buyer bonus (percent of purshased token)
522     uint256 public hardCap;             //Maximum amount of tokens mined
523     uint256 public totalCollected;      //total amount of collected funds (in ethereum wei)
524     uint256 public tokensMinted;        //total amount of minted tokens
525     bool public finalized;              //crowdsale is finalized
526 
527     /**
528      * @dev WorldCoin Crowdsale Contract
529      * @param _founderPercent Amount of tokens sent to founder with each purshase (percent of purshased token)
530      * @param _partnerBonusPercent Referral partner bonus (percent of purshased token)
531      * @param _referralBonusPercent Referral buyer bonus (percent of purshased token)
532      * @param _hardCap Maximum amount of ether (in wei) to be collected during crowdsale
533      * @param roundStarts List of round start timestams
534      * @param roundEnds List of round end timestams 
535      * @param roundRates List of round rates (tokens for 1 ETH)
536      */
537     function WorldCoinCrowdsale (
538         uint256 _founderPercent,
539         uint256 _partnerBonusPercent,
540         uint256 _referralBonusPercent,
541         uint256 _hardCap,
542         uint256[] roundStarts,
543         uint256[] roundEnds,
544         uint256[] roundRates
545     ) public {
546 
547         //Check all paramaters are correct and create rounds
548         require(_hardCap > 0);                    //Need something to sell
549         require(
550             (roundStarts.length > 0)  &&                //There should be at least one round
551             (roundStarts.length == roundEnds.length) &&
552             (roundStarts.length == roundRates.length)
553         );                   
554         uint256 prevRoundEnd = now;
555         rounds.length = roundStarts.length;             //initialize rounds array
556         for(uint8 i=0; i < roundStarts.length; i++){
557             rounds[i] = Round(roundStarts[i], roundEnds[i], roundRates[i]);
558             Round storage r = rounds[i];
559             require(prevRoundEnd <= r.start);
560             require(r.start < r.end);
561             require(r.rate > 0);
562             prevRoundEnd = rounds[i].end;
563         }
564 
565         hardCap = _hardCap;
566         partnerBonusPercent = _partnerBonusPercent;
567         referralBonusPercent = _referralBonusPercent;
568         founderPercent = _founderPercent;
569         //founderPercentWithReferral = founderPercent * (rate + partnerBonusPercent + referralBonusPercent) / rate;  //Did not use SafeMath here, because this parameters defined by contract creator should not be malicious. Also have checked result on the next line.
570         //assert(founderPercentWithReferral >= founderPercent);
571 
572         token = new WorldCoin();
573     }
574 
575     /**
576     * @dev Fetches current Round number
577     * @return round number (index in rounds array + 1) or 0 if none
578     */
579     function currentRoundNum() constant public returns(uint8) {
580         for(uint8 i=0; i < rounds.length; i++){
581             if( (now > rounds[i].start) && (now <= rounds[i].end) ) return i+1;
582         }
583         return 0;
584     }
585     /**
586     * @dev Fetches current rate (how many tokens you get for 1 ETH)
587     * @return calculated rate or zero if no round of crowdsale is running
588     */
589     function currentRate() constant public returns(uint256) {
590         uint8 roundNum = currentRoundNum();
591         if(roundNum == 0) {
592             return 0;
593         }else{
594             return rounds[roundNum-1].rate;
595         }
596     }
597 
598     function firstRoundStartTimestamp() constant public returns(uint256){
599         return rounds[0].start;
600     }
601     function lastRoundEndTimestamp() constant public returns(uint256){
602         return rounds[rounds.length - 1].end;
603     }
604 
605     /**
606     * @dev Shows if crowdsale is running
607     */ 
608     function crowdsaleRunning() constant public returns(bool){
609         return !finalized && (tokensMinted < hardCap) && (currentRoundNum() > 0);
610     }
611 
612     /**
613     * @dev Buy WorldCoin tokens
614     */
615     function() payable public {
616         sale(msg.sender, 0x0);
617     } 
618 
619     /**
620     * @dev Buy WorldCoin tokens witn referral program
621     */
622     function sale(address buyer, address partner) public payable {
623         if(!crowdsaleRunning()) revert();
624         require(msg.value > 0);
625         uint256 rate = currentRate();
626         assert(rate > 0);
627 
628         uint256 referralTokens; uint256 partnerTokens; uint256 ownerTokens;
629         uint256 tokens = rate.mul(msg.value);
630         assert(tokens > 0);
631         totalCollected = totalCollected.add(msg.value);
632         if(partner == 0x0){
633             ownerTokens     = tokens.mul(founderPercent).div(PERCENT_DIVIDER);
634             mintTokens(buyer, tokens);
635             mintTokens(owner, ownerTokens);
636         }else{
637             partnerTokens   = tokens.mul(partnerBonusPercent).div(PERCENT_DIVIDER);
638             referralTokens  = tokens.mul(referralBonusPercent).div(PERCENT_DIVIDER);
639             ownerTokens     = (tokens.add(partnerTokens).add(referralTokens)).mul(founderPercent).div(PERCENT_DIVIDER);
640             
641             uint256 totalBuyerTokens = tokens.add(referralTokens);
642             mintTokens(buyer, totalBuyerTokens);
643             mintTokens(partner, partnerTokens);
644             mintTokens(owner, ownerTokens);
645         }
646     }
647 
648     /**
649     * @notice Mint tokens for purshases with Non-Ether currencies
650     * @param beneficiary whom to send tokend
651     * @param amount how much tokens to send
652     * param message reason why we are sending tokens (not stored anythere, only in transaction itself)
653     */
654     function saleNonEther(address beneficiary, uint256 amount, string /*message*/) public onlyOwner {
655         mintTokens(beneficiary, amount);
656     }
657 
658     /**
659     * @notice Updates rate for the round
660     */
661     function setRoundRate(uint32 roundNum, uint256 rate) public onlyOwner {
662         require(roundNum < rounds.length);
663         rounds[roundNum].rate = rate;
664     }
665 
666 
667     /**
668     * @notice Sends collected funds to owner
669     * May be executed only if goal reached and no refunds are possible
670     */
671     function claimEther() public onlyOwner {
672         if(this.balance > 0){
673             owner.transfer(this.balance);
674         }
675     }
676 
677     /**
678     * @notice Finalizes ICO when one of conditions met:
679     * - end time reached OR
680     * - no more tokens available (cap reached) OR
681     * - message sent by owner
682     */
683     function finalizeCrowdsale() public {
684         require ( (now > lastRoundEndTimestamp()) || (totalCollected == hardCap) || (msg.sender == owner) );
685         finalized = token.finishMinting();
686         token.transferOwnership(owner);
687         if(this.balance > 0){
688             owner.transfer(this.balance);
689         }
690     }
691 
692     /**
693     * @dev Helper function to mint tokens and increase tokensMinted counter
694     */
695     function mintTokens(address beneficiary, uint256 amount) internal {
696         tokensMinted = tokensMinted.add(amount);
697         require(tokensMinted <= hardCap);
698         assert(token.mint(beneficiary, amount));
699     }
700 }