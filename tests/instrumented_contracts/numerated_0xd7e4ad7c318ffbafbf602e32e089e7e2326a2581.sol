1 pragma solidity ^0.4.18;
2 
3 /**
4  * DocTailor: https://www.doctailor.com
5  */
6 
7 // ==== Open Zeppelin library ===
8 
9 /**
10  * @title ERC20Basic
11  * @dev Simpler version of ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/179
13  */
14 contract ERC20Basic {
15   function totalSupply() public view returns (uint256);
16   function balanceOf(address who) public view returns (uint256);
17   function transfer(address to, uint256 value) public returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 /**
22  * @title ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/20
24  */
25 contract ERC20 is ERC20Basic {
26   function allowance(address owner, address spender) public view returns (uint256);
27   function transferFrom(address from, address to, uint256 value) public returns (bool);
28   function approve(address spender, uint256 value) public returns (bool);
29   event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 /**
33    @title ERC827 interface, an extension of ERC20 token standard
34 
35    Interface of a ERC827 token, following the ERC20 standard with extra
36    methods to transfer value and data and execute calls in transfers and
37    approvals.
38  */
39 contract ERC827 is ERC20 {
40 
41   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
42   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
43   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
44 
45 }
46 
47 /**
48  * @title SafeERC20
49  * @dev Wrappers around ERC20 operations that throw on failure.
50  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
51  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
52  */
53 library SafeERC20 {
54   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
55     assert(token.transfer(to, value));
56   }
57 
58   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
59     assert(token.transferFrom(from, to, value));
60   }
61 
62   function safeApprove(ERC20 token, address spender, uint256 value) internal {
63     assert(token.approve(spender, value));
64   }
65 }
66 
67 /**
68  * @title SafeMath
69  * @dev Math operations with safety checks that throw on error
70  */
71 library SafeMath {
72   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73     if (a == 0) {
74       return 0;
75     }
76     uint256 c = a * b;
77     assert(c / a == b);
78     return c;
79   }
80 
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     // assert(b > 0); // Solidity automatically throws when dividing by 0
83     uint256 c = a / b;
84     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85     return c;
86   }
87 
88   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89     assert(b <= a);
90     return a - b;
91   }
92 
93   function add(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a + b;
95     assert(c >= a);
96     return c;
97   }
98 }
99 
100 
101 /**
102  * @title Ownable
103  * @dev The Ownable contract has an owner address, and provides basic authorization control
104  * functions, this simplifies the implementation of "user permissions".
105  */
106 contract Ownable {
107   address public owner;
108 
109 
110   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111 
112 
113   /**
114    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
115    * account.
116    */
117   function Ownable() public {
118     owner = msg.sender;
119   }
120 
121   /**
122    * @dev Throws if called by any account other than the owner.
123    */
124   modifier onlyOwner() {
125     require(msg.sender == owner);
126     _;
127   }
128 
129   /**
130    * @dev Allows the current owner to transfer control of the contract to a newOwner.
131    * @param newOwner The address to transfer ownership to.
132    */
133   function transferOwnership(address newOwner) public onlyOwner {
134     require(newOwner != address(0));
135     OwnershipTransferred(owner, newOwner);
136     owner = newOwner;
137   }
138 
139 }
140 
141 /**
142  * @title Contracts that should not own Ether
143  * @author Remco Bloemen <remco@2π.com>
144  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
145  * in the contract, it will allow the owner to reclaim this ether.
146  * @notice Ether can still be send to this contract by:
147  * calling functions labeled `payable`
148  * `selfdestruct(contract_address)`
149  * mining directly to the contract address
150 */
151 contract HasNoEther is Ownable {
152 
153   /**
154   * @dev Constructor that rejects incoming Ether
155   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
156   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
157   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
158   * we could use assembly to access msg.value.
159   */
160   function HasNoEther() public payable {
161     require(msg.value == 0);
162   }
163 
164   /**
165    * @dev Disallows direct send by settings a default function without the `payable` flag.
166    */
167   function() external {
168   }
169 
170   /**
171    * @dev Transfer all Ether held by the contract to the owner.
172    */
173   function reclaimEther() external onlyOwner {
174     assert(owner.send(this.balance));
175   }
176 }
177 
178 /**
179  * @title Contracts that should not own Contracts
180  * @author Remco Bloemen <remco@2π.com>
181  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
182  * of this contract to reclaim ownership of the contracts.
183  */
184 contract HasNoContracts is Ownable {
185 
186   /**
187    * @dev Reclaim ownership of Ownable contracts
188    * @param contractAddr The address of the Ownable to be reclaimed.
189    */
190   function reclaimContract(address contractAddr) external onlyOwner {
191     Ownable contractInst = Ownable(contractAddr);
192     contractInst.transferOwnership(owner);
193   }
194 }
195 
196 /**
197  * @title Contracts that should be able to recover tokens
198  * @author SylTi
199  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
200  * This will prevent any accidental loss of tokens.
201  */
202 contract CanReclaimToken is Ownable {
203   using SafeERC20 for ERC20Basic;
204 
205   /**
206    * @dev Reclaim all ERC20Basic compatible tokens
207    * @param token ERC20Basic The address of the token contract
208    */
209   function reclaimToken(ERC20Basic token) external onlyOwner {
210     uint256 balance = token.balanceOf(this);
211     token.safeTransfer(owner, balance);
212   }
213 
214 }
215 
216 /**
217  * @title Contracts that should not own Tokens
218  * @author Remco Bloemen <remco@2π.com>
219  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
220  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
221  * owner to reclaim the tokens.
222  */
223 contract HasNoTokens is CanReclaimToken {
224 
225  /**
226   * @dev Reject all ERC23 compatible tokens
227   * @param from_ address The address that is transferring the tokens
228   * @param value_ uint256 the amount of the specified token
229   * @param data_ Bytes The data passed from the caller.
230   */
231   function tokenFallback(address from_, uint256 value_, bytes data_) pure external {
232     from_;
233     value_;
234     data_;
235     revert();
236   }
237 
238 }
239 
240 /**
241  * @title Base contract for contracts that should not own things.
242  * @author Remco Bloemen <remco@2π.com>
243  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
244  * Owned contracts. See respective base contracts for details.
245  */
246 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
247 }
248 
249 /**
250  * @title Destructible
251  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
252  */
253 contract Destructible is Ownable {
254 
255   function Destructible() public payable { }
256 
257   /**
258    * @dev Transfers the current balance to the owner and terminates the contract.
259    */
260   function destroy() onlyOwner public {
261     selfdestruct(owner);
262   }
263 
264   function destroyAndSend(address _recipient) onlyOwner public {
265     selfdestruct(_recipient);
266   }
267 }
268 
269 /**
270  * @title Basic token
271  * @dev Basic version of StandardToken, with no allowances.
272  */
273 contract BasicToken is ERC20Basic {
274   using SafeMath for uint256;
275 
276   mapping(address => uint256) balances;
277 
278   uint256 totalSupply_;
279 
280   /**
281   * @dev total number of tokens in existence
282   */
283   function totalSupply() public view returns (uint256) {
284     return totalSupply_;
285   }
286 
287   /**
288   * @dev transfer token for a specified address
289   * @param _to The address to transfer to.
290   * @param _value The amount to be transferred.
291   */
292   function transfer(address _to, uint256 _value) public returns (bool) {
293     require(_to != address(0));
294     require(_value <= balances[msg.sender]);
295 
296     // SafeMath.sub will throw if there is not enough balance.
297     balances[msg.sender] = balances[msg.sender].sub(_value);
298     balances[_to] = balances[_to].add(_value);
299     Transfer(msg.sender, _to, _value);
300     return true;
301   }
302 
303   /**
304   * @dev Gets the balance of the specified address.
305   * @param _owner The address to query the the balance of.
306   * @return An uint256 representing the amount owned by the passed address.
307   */
308   function balanceOf(address _owner) public view returns (uint256 balance) {
309     return balances[_owner];
310   }
311 
312 }
313 
314 /**
315  * @title Standard ERC20 token
316  *
317  * @dev Implementation of the basic standard token.
318  * @dev https://github.com/ethereum/EIPs/issues/20
319  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
320  */
321 contract StandardToken is ERC20, BasicToken {
322 
323   mapping (address => mapping (address => uint256)) internal allowed;
324 
325 
326   /**
327    * @dev Transfer tokens from one address to another
328    * @param _from address The address which you want to send tokens from
329    * @param _to address The address which you want to transfer to
330    * @param _value uint256 the amount of tokens to be transferred
331    */
332   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
333     require(_to != address(0));
334     require(_value <= balances[_from]);
335     require(_value <= allowed[_from][msg.sender]);
336 
337     balances[_from] = balances[_from].sub(_value);
338     balances[_to] = balances[_to].add(_value);
339     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
340     Transfer(_from, _to, _value);
341     return true;
342   }
343 
344   /**
345    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
346    *
347    * Beware that changing an allowance with this method brings the risk that someone may use both the old
348    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
349    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
350    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
351    * @param _spender The address which will spend the funds.
352    * @param _value The amount of tokens to be spent.
353    */
354   function approve(address _spender, uint256 _value) public returns (bool) {
355     allowed[msg.sender][_spender] = _value;
356     Approval(msg.sender, _spender, _value);
357     return true;
358   }
359 
360   /**
361    * @dev Function to check the amount of tokens that an owner allowed to a spender.
362    * @param _owner address The address which owns the funds.
363    * @param _spender address The address which will spend the funds.
364    * @return A uint256 specifying the amount of tokens still available for the spender.
365    */
366   function allowance(address _owner, address _spender) public view returns (uint256) {
367     return allowed[_owner][_spender];
368   }
369 
370   /**
371    * @dev Increase the amount of tokens that an owner allowed to a spender.
372    *
373    * approve should be called when allowed[_spender] == 0. To increment
374    * allowed value is better to use this function to avoid 2 calls (and wait until
375    * the first transaction is mined)
376    * From MonolithDAO Token.sol
377    * @param _spender The address which will spend the funds.
378    * @param _addedValue The amount of tokens to increase the allowance by.
379    */
380   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
381     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
382     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
383     return true;
384   }
385 
386   /**
387    * @dev Decrease the amount of tokens that an owner allowed to a spender.
388    *
389    * approve should be called when allowed[_spender] == 0. To decrement
390    * allowed value is better to use this function to avoid 2 calls (and wait until
391    * the first transaction is mined)
392    * From MonolithDAO Token.sol
393    * @param _spender The address which will spend the funds.
394    * @param _subtractedValue The amount of tokens to decrease the allowance by.
395    */
396   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
397     uint oldValue = allowed[msg.sender][_spender];
398     if (_subtractedValue > oldValue) {
399       allowed[msg.sender][_spender] = 0;
400     } else {
401       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
402     }
403     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
404     return true;
405   }
406 
407 }
408 
409 /**
410  * @title Mintable token
411  * @dev Simple ERC20 Token example, with mintable token creation
412  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
413  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
414  */
415 contract MintableToken is StandardToken, Ownable {
416   event Mint(address indexed to, uint256 amount);
417   event MintFinished();
418 
419   bool public mintingFinished = false;
420 
421 
422   modifier canMint() {
423     require(!mintingFinished);
424     _;
425   }
426 
427   /**
428    * @dev Function to mint tokens
429    * @param _to The address that will receive the minted tokens.
430    * @param _amount The amount of tokens to mint.
431    * @return A boolean that indicates if the operation was successful.
432    */
433   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
434     totalSupply_ = totalSupply_.add(_amount);
435     balances[_to] = balances[_to].add(_amount);
436     Mint(_to, _amount);
437     Transfer(address(0), _to, _amount);
438     return true;
439   }
440 
441   /**
442    * @dev Function to stop minting new tokens.
443    * @return True if the operation was successful.
444    */
445   function finishMinting() onlyOwner canMint public returns (bool) {
446     mintingFinished = true;
447     MintFinished();
448     return true;
449   }
450 }
451 
452 /**
453    @title ERC827, an extension of ERC20 token standard
454 
455    Implementation the ERC827, following the ERC20 standard with extra
456    methods to transfer value and data and execute calls in transfers and
457    approvals.
458    Uses OpenZeppelin StandardToken.
459  */
460 contract ERC827Token is ERC827, StandardToken {
461 
462   /**
463      @dev Addition to ERC20 token methods. It allows to
464      approve the transfer of value and execute a call with the sent data.
465 
466      Beware that changing an allowance with this method brings the risk that
467      someone may use both the old and the new allowance by unfortunate
468      transaction ordering. One possible solution to mitigate this race condition
469      is to first reduce the spender's allowance to 0 and set the desired value
470      afterwards:
471      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
472 
473      @param _spender The address that will spend the funds.
474      @param _value The amount of tokens to be spent.
475      @param _data ABI-encoded contract call to call `_to` address.
476 
477      @return true if the call function was executed successfully
478    */
479   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
480     require(_spender != address(this));
481 
482     super.approve(_spender, _value);
483 
484     require(_spender.call(_data));
485 
486     return true;
487   }
488 
489   /**
490      @dev Addition to ERC20 token methods. Transfer tokens to a specified
491      address and execute a call with the sent data on the same transaction
492 
493      @param _to address The address which you want to transfer to
494      @param _value uint256 the amout of tokens to be transfered
495      @param _data ABI-encoded contract call to call `_to` address.
496 
497      @return true if the call function was executed successfully
498    */
499   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
500     require(_to != address(this));
501 
502     super.transfer(_to, _value);
503 
504     require(_to.call(_data));
505     return true;
506   }
507 
508   /**
509      @dev Addition to ERC20 token methods. Transfer tokens from one address to
510      another and make a contract call on the same transaction
511 
512      @param _from The address which you want to send tokens from
513      @param _to The address which you want to transfer to
514      @param _value The amout of tokens to be transferred
515      @param _data ABI-encoded contract call to call `_to` address.
516 
517      @return true if the call function was executed successfully
518    */
519   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
520     require(_to != address(this));
521 
522     super.transferFrom(_from, _to, _value);
523 
524     require(_to.call(_data));
525     return true;
526   }
527 
528   /**
529    * @dev Addition to StandardToken methods. Increase the amount of tokens that
530    * an owner allowed to a spender and execute a call with the sent data.
531    *
532    * approve should be called when allowed[_spender] == 0. To increment
533    * allowed value is better to use this function to avoid 2 calls (and wait until
534    * the first transaction is mined)
535    * From MonolithDAO Token.sol
536    * @param _spender The address which will spend the funds.
537    * @param _addedValue The amount of tokens to increase the allowance by.
538    * @param _data ABI-encoded contract call to call `_spender` address.
539    */
540   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
541     require(_spender != address(this));
542 
543     super.increaseApproval(_spender, _addedValue);
544 
545     require(_spender.call(_data));
546 
547     return true;
548   }
549 
550   /**
551    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
552    * an owner allowed to a spender and execute a call with the sent data.
553    *
554    * approve should be called when allowed[_spender] == 0. To decrement
555    * allowed value is better to use this function to avoid 2 calls (and wait until
556    * the first transaction is mined)
557    * From MonolithDAO Token.sol
558    * @param _spender The address which will spend the funds.
559    * @param _subtractedValue The amount of tokens to decrease the allowance by.
560    * @param _data ABI-encoded contract call to call `_spender` address.
561    */
562   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
563     require(_spender != address(this));
564 
565     super.decreaseApproval(_spender, _subtractedValue);
566 
567     require(_spender.call(_data));
568 
569     return true;
570   }
571 
572 }
573 
574 // ==== DOCT Contracts ===
575 
576 contract DOCTToken is MintableToken, ERC827Token, NoOwner {
577     string public symbol = 'DOCT';
578     string public name = 'DocTailor';
579     uint8 public constant decimals = 8;
580 
581     address founder;                //founder address to allow him transfer tokens even when transfers disabled
582     bool public transferEnabled;    //allows to dissable transfers while minting and in case of emergency
583 
584     function setFounder(address _founder) onlyOwner public {
585         founder = _founder;
586     }
587     function setTransferEnabled(bool enable) onlyOwner public {
588         transferEnabled = enable;
589     }
590     modifier canTransfer() {
591         require( transferEnabled || msg.sender == founder || msg.sender == owner);
592         _;
593     }
594     
595     function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
596         return super.transfer(_to, _value);
597     }
598     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
599         return super.transferFrom(_from, _to, _value);
600     }
601     function transfer(address _to, uint256 _value, bytes _data) canTransfer public returns (bool) {
602         return super.transfer(_to, _value, _data);
603     }
604     function transferFrom(address _from, address _to, uint256 _value, bytes _data) canTransfer public returns (bool) {
605         return super.transferFrom(_from, _to, _value, _data);
606     }
607 }
608 
609 /**
610  * @title DocTailor Crowdsale
611  */
612 contract DOCTCrowdsale is Ownable, HasNoContracts, CanReclaimToken, Destructible {
613     using SafeMath for uint256;
614 
615     uint256 constant  DOCT_TO_ETH_DECIMALS = 10000000000;    //Need this because ETH decimals is 18, while DOCT decimals is 8.
616 
617     DOCTToken public token;
618 
619     struct Round {
620         uint256 start;          //Timestamp of crowdsale round start
621         uint256 end;            //Timestamp of crowdsale round end
622         uint256 rate;           //Rate: how much TOKEN one will get fo 1 ETH during this round
623         uint256 rateBulk;       //Rate for bulk purshases
624         uint256 bulkThreshold;  //If purshase more than this amount, bulk rate applied
625     }
626     Round[] public rounds;          //Array of crowdsale rounds
627     uint256 public hardCap;         //Max amount of tokens to mint
628     uint256 public tokensMinted;    //Amount of tokens already minted
629     bool public finalized;          //crowdsale is finalized
630 
631     function DOCTCrowdsale (
632         uint256 _hardCap,
633         uint256[] roundStarts,
634         uint256[] roundEnds,
635         uint256[] roundRates,
636         uint256[] roundRatesBulk,
637         uint256[] roundBulkThreshold
638     ) public {
639         token = new DOCTToken();
640         token.setFounder(owner);
641         token.setTransferEnabled(false);
642 
643         tokensMinted = token.totalSupply();
644 
645         //Check all paramaters are correct and create rounds
646         require(_hardCap > 0);                    //Need something to sell
647         hardCap = _hardCap;
648 
649         initRounds(roundStarts, roundEnds, roundRates, roundRatesBulk, roundBulkThreshold);
650     }
651     function initRounds(uint256[] roundStarts, uint256[] roundEnds, uint256[] roundRates, uint256[] roundRatesBulk, uint256[] roundBulkThreshold) internal {
652         require(
653             (roundStarts.length > 0)  &&                //There should be at least one round
654             (roundStarts.length == roundEnds.length) &&
655             (roundStarts.length == roundRates.length) &&
656             (roundStarts.length == roundRatesBulk.length) &&
657             (roundStarts.length == roundBulkThreshold.length)
658         );                   
659         uint256 prevRoundEnd = now;
660         rounds.length = roundStarts.length;             //initialize rounds array
661         for(uint8 i=0; i < roundStarts.length; i++){
662             rounds[i] = Round({start:roundStarts[i], end:roundEnds[i], rate:roundRates[i], rateBulk:roundRatesBulk[i], bulkThreshold:roundBulkThreshold[i]});
663             Round storage r = rounds[i];
664             require(prevRoundEnd <= r.start);
665             require(r.start < r.end);
666             require(r.bulkThreshold > 0);
667             prevRoundEnd = rounds[i].end;
668         }
669     }
670     function setRound(uint8 roundNum, uint256 start, uint256 end, uint256 rate, uint256 rateBulk, uint256 bulkThreshold) onlyOwner external {
671         uint8 round = roundNum-1;
672         if(round > 0){
673             require(rounds[round - 1].end <= start);
674         }
675         if(round < rounds.length - 1){
676             require(end <= rounds[round + 1].start);   
677         }
678         rounds[round].start = start;
679         rounds[round].end = end;
680         rounds[round].rate = rate;
681         rounds[round].rateBulk = rateBulk;
682         rounds[round].bulkThreshold = bulkThreshold;
683     }
684 
685 
686     /**
687     * @notice Buy tokens
688     */
689     function() payable public {
690         require(msg.value > 0);
691         require(crowdsaleRunning());
692 
693         uint256 rate = currentRate(msg.value);
694         require(rate > 0);
695         uint256 tokens = rate.mul(msg.value).div(DOCT_TO_ETH_DECIMALS);
696         mintTokens(msg.sender, tokens);
697     }
698 
699     /**
700     * @notice Mint tokens for purshases with Non-Ether currencies
701     * @param beneficiary whom to send tokend
702     * @param amount how much tokens to send
703     * param message reason why we are sending tokens (not stored anythere, only in transaction itself)
704     */
705     function saleNonEther(address beneficiary, uint256 amount, string /*message*/) onlyOwner external{
706         mintTokens(beneficiary, amount);
707     }
708 
709     /**
710     * @notice Bulk mint tokens (different amounts)
711     * @param beneficiaries array whom to send tokend
712     * @param amounts array how much tokens to send
713     * param message reason why we are sending tokens (not stored anythere, only in transaction itself)
714     */
715     function bulkTokenSend(address[] beneficiaries, uint256[] amounts, string /*message*/) onlyOwner external{
716         require(beneficiaries.length == amounts.length);
717         for(uint32 i=0; i < beneficiaries.length; i++){
718             mintTokens(beneficiaries[i], amounts[i]);
719         }
720     }
721     /**
722     * @notice Bulk mint tokens (same amounts)
723     * @param beneficiaries array whom to send tokend
724     * @param amount how much tokens to send
725     * param message reason why we are sending tokens (not stored anythere, only in transaction itself)
726     */
727     function bulkTokenSend(address[] beneficiaries, uint256 amount, string /*message*/) onlyOwner external{
728         require(amount > 0);
729         for(uint32 i=0; i < beneficiaries.length; i++){
730             mintTokens(beneficiaries[i], amount);
731         }
732     }
733 
734     /**
735     * @notice Shows if crowdsale is running
736     */ 
737     function crowdsaleRunning() constant public returns(bool){
738         return !finalized && (tokensMinted < hardCap) && (currentRoundNum() > 0);
739     }
740 
741     /**
742     * @notice Fetches current Round number
743     * @return round number (index in rounds array + 1) or 0 if none
744     */
745     function currentRoundNum() view public returns(uint8) {
746         for(uint8 i=0; i < rounds.length; i++){
747             if( (now > rounds[i].start) && (now <= rounds[i].end) ) return i+1;
748         }
749         return 0;
750     }
751     /**
752     * @notice Fetches current rate (how many tokens you get for 1 ETH)
753     * @param amount how much ether is received
754     * @return calculated rate or zero if no round of crowdsale is running
755     */
756     function currentRate(uint256 amount) view public returns(uint256) {
757         uint8 roundNum = currentRoundNum();
758         if(roundNum == 0) {
759             return 0;
760         }else{
761             uint8 round = roundNum-1;
762             if(amount < rounds[round].bulkThreshold){
763                 return rounds[round].rate;
764             }else{
765                 return rounds[round].rateBulk;
766             }
767         }
768     }
769 
770     /**
771     * @dev Helper function to mint tokens and increase tokensMinted counter
772     */
773     function mintTokens(address beneficiary, uint256 amount) internal {
774         tokensMinted = tokensMinted.add(amount);
775         require(tokensMinted <= hardCap);
776         assert(token.mint(beneficiary, amount));
777     }
778 
779     /**
780     * @notice Sends collected funds to owner
781     */
782     function claimEther() public onlyOwner {
783         if(this.balance > 0){
784             owner.transfer(this.balance);
785         }
786     }
787 
788     /**
789     * @notice Finalizes ICO: changes token ownership to founder, allows token transfers
790     */
791     function finalizeCrowdsale() onlyOwner public {
792         finalized = true;
793         assert(token.finishMinting());
794         token.setTransferEnabled(true);
795         token.transferOwnership(owner);
796         claimEther();
797     }
798 
799 }