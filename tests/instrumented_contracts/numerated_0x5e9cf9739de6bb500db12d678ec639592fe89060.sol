1 pragma solidity ^0.4.21;
2 
3 /**
4  * iron Bank Network
5  * https://www.ironbank.network
6  * Based on Open Zeppelin - https://github.com/OpenZeppelin/zeppelin-solidity
7  */
8 
9 /*
10  * @title SafeERC20
11  * @dev Wrappers around ERC20 operations that throw on failure.
12  */
13 library SafeERC20 {
14   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
15     assert(token.transfer(to, value));
16   }
17 
18   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
19     assert(token.transferFrom(from, to, value));
20   }
21 
22   function safeApprove(ERC20 token, address spender, uint256 value) internal {
23     assert(token.approve(spender, value));
24   }
25 }
26 
27 /**
28  * 
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34     if (a == 0) {
35       return 0;
36     }
37     uint256 c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 /**
62  * @title ERC20Basic
63  * @dev Simpler version of ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/179
65  */
66 contract ERC20Basic {
67   function totalSupply() public view returns (uint256);
68   function balanceOf(address who) public view returns (uint256);
69   function transfer(address to, uint256 value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20 is ERC20Basic {
78   function allowance(address owner, address spender) public view returns (uint256);
79   function transferFrom(address from, address to, uint256 value) public returns (bool);
80   function approve(address spender, uint256 value) public returns (bool);
81   event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 /**
85  * @title Ownable
86  * @dev The Ownable contract has an owner address, and provides basic authorization control
87  * functions, this simplifies the implementation of "user permissions".
88  */
89 contract Ownable {
90   address public owner;
91 
92   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93 
94   /**
95    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
96    * account.
97    */
98   function Ownable() public {
99     owner = msg.sender;
100   }
101 
102   /**
103    * @dev Throws if called by any account other than the owner.
104    */
105   modifier onlyOwner() {
106     require(msg.sender == owner);
107     _;
108   }
109 
110   /**
111    * @dev Allows the current owner to transfer control of the contract to a newOwner.
112    * @param newOwner The address to transfer ownership to.
113    */
114   function transferOwnership(address newOwner) public onlyOwner {
115     require(newOwner != address(0));
116     emit OwnershipTransferred(owner, newOwner);
117     owner = newOwner;
118   }
119 }
120 
121 /**
122  * @title PoolParty Token
123  * @author Alber Erre
124  * @notice Follow up token holders to give them collected fees in the future. Holders are stored in "HOLDersList"
125  * @dev This is the first part of the functionality, this contract just enable tracking token holders
126  * @dev Next part is defined as "PoolPartyPayRoll" contract
127  */
128 contract PoolPartyToken is Ownable {
129   using SafeMath for uint256;
130 
131   struct HOLDers {
132     address HOLDersAddress;
133   }
134 
135   HOLDers[] public HOLDersList;
136 
137   function _alreadyInList(address _thisHODLer) internal view returns(bool HolderinList) {
138 
139     bool result = false;
140     for (uint256 r = 0; r < HOLDersList.length; r++) {
141       if (HOLDersList[r].HOLDersAddress == _thisHODLer) {
142         result = true;
143         break;
144       }
145     }
146     return result;
147   }
148 
149   // Call AddHOLDer function every time a token is sold, "_alreadyInList" avoids duplicates
150   function AddHOLDer(address _thisHODLer) internal {
151 
152     if (_alreadyInList(_thisHODLer) == false) {
153       HOLDersList.push(HOLDers(_thisHODLer));
154     }
155   }
156 
157   function UpdateHOLDer(address _currentHODLer, address _newHODLer) internal {
158 
159     for (uint256 r = 0; r < HOLDersList.length; r++){
160       // Send individual token holder payroll
161       if (HOLDersList[r].HOLDersAddress == _currentHODLer) {
162         // write new holders address
163         HOLDersList[r].HOLDersAddress = _newHODLer;
164       }
165     }
166   }
167 }
168 
169 /**
170  * @title Basic token
171  * @dev Basic version of StandardToken, with no allowances.
172  */
173 contract BasicToken is PoolPartyToken, ERC20Basic {
174   using SafeMath for uint256;
175 
176   mapping(address => uint256) balances;
177 
178   uint256 totalSupply_;
179 
180   /**
181   * OpenBarrier modifier by Alber Erre
182   * @notice security trigger in case something fails during minting, token sale or Airdrop
183   */
184   bool public transferEnabled;    //allows contract to lock transfers in case of emergency
185 
186   modifier openBarrier() {
187       require(transferEnabled || msg.sender == owner);
188       _;
189   }
190 
191   /**
192   * @dev total number of tokens in existence
193   */
194   function totalSupply() public view returns (uint256) {
195     return totalSupply_;
196   }
197 
198   /**
199   * @dev transfer token for a specified address
200   * @param _to The address to transfer to.
201   * @param _value The amount to be transferred.
202   */
203   function transfer(address _to, uint256 _value) openBarrier public returns (bool) {
204     require(_to != address(0));
205     require(_value <= balances[msg.sender]);
206 
207     balances[msg.sender] = balances[msg.sender].sub(_value);
208     balances[_to] = balances[_to].add(_value);
209     emit Transfer(msg.sender, _to, _value);
210 
211     // update HODLer address, for iron profit distribution to iron holders - PoolParty
212     UpdateHOLDer(msg.sender, _to);
213 
214     return true;
215   }
216 
217   /**
218   * @dev Gets the balance of the specified address.
219   * @param _owner The address to query the the balance of.
220   * @return An uint256 representing the amount owned by the passed address.
221   */
222   function balanceOf(address _owner) public view returns (uint256 balance) {
223     return balances[_owner];
224   }
225 }
226 
227 /**
228  * @title PoolParty PayRoll
229  * @author Alber Erre
230  * @notice This enables fees distribution (Money!) among token holders
231  * @dev This is the second part of the PoolParty functionality, this contract allow us to distributed the fees collected...
232  * @dev ...between token holders, if you hold you get paid, that is the idea.
233  */
234 contract PoolPartyPayRoll is BasicToken {
235   using SafeMath for uint256;
236 
237   mapping (address => uint256) PayRollCount;
238 
239   // Manually spread iron profits to token holders
240   function _HOLDersPayRoll() onlyOwner public {
241 
242     uint256 _amountToPay = address(this).balance;
243     uint256 individualPayRoll = _amountToPay.div(uint256(HOLDersList.length));
244 
245     for (uint256 r = 0; r < HOLDersList.length; r++){
246       // Send individual token holder payroll
247       address HODLer = HOLDersList[r].HOLDersAddress;
248       HODLer.transfer(individualPayRoll);
249       // Add counter, to check how many times an address has been paid (the higher the most time this address has HODL)
250       PayRollCount[HOLDersList[r].HOLDersAddress] = PayRollCount[HOLDersList[r].HOLDersAddress].add(1);
251     }
252   }
253 
254   function PayRollHistory(address _thisHODLer) external view returns (uint256) {
255 
256     return uint256(PayRollCount[_thisHODLer]);
257   }
258 }
259 
260 /**
261  * @title Standard ERC20 token
262  *
263  * @dev Implementation of the basic standard token.
264  * @dev https://github.com/ethereum/EIPs/issues/20
265  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
266  */
267 contract StandardToken is PoolPartyPayRoll, ERC20 {
268 
269   mapping (address => mapping (address => uint256)) internal allowed;
270 
271   /**
272    * @dev Transfer tokens from one address to another
273    * @param _from address The address which you want to send tokens from
274    * @param _to address The address which you want to transfer to
275    * @param _value uint256 the amount of tokens to be transferred
276    */
277   function transferFrom(address _from, address _to, uint256 _value) openBarrier public returns (bool) {
278     require(_to != address(0));
279     require(_value <= balances[_from]);
280     require(_value <= allowed[_from][msg.sender]);
281 
282     balances[_from] = balances[_from].sub(_value);
283     balances[_to] = balances[_to].add(_value);
284     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
285     emit Transfer(_from, _to, _value);
286 
287     // update HODLer address, for iron profit distribution to iron holders - PoolParty
288     UpdateHOLDer(msg.sender, _to);
289 
290     return true;
291   }
292 
293   /**
294    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
295    *
296    * Beware that changing an allowance with this method brings the risk that someone may use both the old
297    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
298    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
299    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
300    * @param _spender The address which will spend the funds.
301    * @param _value The amount of tokens to be spent.
302    */
303   function approve(address _spender, uint256 _value) public returns (bool) {
304     allowed[msg.sender][_spender] = _value;
305     emit Approval(msg.sender, _spender, _value);
306     return true;
307   }
308 
309   /**
310    * @dev Function to check the amount of tokens that an owner allowed to a spender.
311    * @param _owner address The address which owns the funds.
312    * @param _spender address The address which will spend the funds.
313    * @return A uint256 specifying the amount of tokens still available for the spender.
314    */
315   function allowance(address _owner, address _spender) public view returns (uint256) {
316     return allowed[_owner][_spender];
317   }
318 
319   /**
320    * @dev Increase the amount of tokens that an owner allowed to a spender.
321    *
322    * approve should be called when allowed[_spender] == 0. To increment
323    * allowed value is better to use this function to avoid 2 calls (and wait until
324    * the first transaction is mined)
325    * From MonolithDAO Token.sol
326    * @param _spender The address which will spend the funds.
327    * @param _addedValue The amount of tokens to increase the allowance by.
328    */
329   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
330     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
331     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
332     return true;
333   }
334 
335   /**
336    * @dev Decrease the amount of tokens that an owner allowed to a spender.
337    *
338    * approve should be called when allowed[_spender] == 0. To decrement
339    * allowed value is better to use this function to avoid 2 calls (and wait until
340    * the first transaction is mined)
341    * From MonolithDAO Token.sol
342    * @param _spender The address which will spend the funds.
343    * @param _subtractedValue The amount of tokens to decrease the allowance by.
344    */
345   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
346     uint oldValue = allowed[msg.sender][_spender];
347     if (_subtractedValue > oldValue) {
348       allowed[msg.sender][_spender] = 0;
349     } else {
350       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
351     }
352     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
353     return true;
354   }
355 }
356 
357 /**
358  * @title Mintable token
359  * @dev Simple ERC20 Token example, with mintable token creation
360  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
361  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
362  */
363 contract MintableToken is StandardToken {
364   event Mint(address indexed to, uint256 amount);
365   event MintFinished();
366 
367   bool public mintingFinished = false;
368 
369 
370   modifier canMint() {
371     require(!mintingFinished);
372     _;
373   }
374 
375   /**
376    * @dev Function to mint tokens
377    * @param _to The address that will receive the minted tokens.
378    * @param _amount The amount of tokens to mint.
379    * @return A boolean that indicates if the operation was successful.
380    */
381   function mint(address _to, uint256 _amount) onlyOwner canMint external returns (bool) {
382     totalSupply_ = totalSupply_.add(_amount);
383     balances[_to] = balances[_to].add(_amount);
384 
385     // Add holder for future iron profits distribution - PoolParty
386     AddHOLDer(_to);
387 
388     emit Mint(_to, _amount);
389     emit Transfer(address(0), _to, _amount);
390     return true;
391   }
392 
393   /**
394    * @dev Function to stop minting new tokens.
395    * @return True if the operation was successful.
396    */
397   function finishMinting() onlyOwner canMint external returns (bool) {
398     mintingFinished = true;
399     emit MintFinished();
400     return true;
401   }
402 }
403 
404 /**
405  * @title Contracts that should be able to recover tokens
406  * @author SylTi
407  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
408  * This will prevent any accidental loss of tokens. - updated to "recoverERC20Token_SendbyMistake"
409  */
410 contract CanReclaimToken is Ownable {
411   using SafeERC20 for ERC20Basic;
412 
413   /**
414    * @dev Reclaim all ERC20Basic compatible tokens
415    * @param missing_token ERC20Basic The address of the token contract (missing_token)
416    */
417   function recoverERC20Token_SendbyMistake(ERC20Basic missing_token) external onlyOwner {
418     uint256 balance = missing_token.balanceOf(this);
419     missing_token.safeTransfer(owner, balance);
420   }
421 }
422 
423 /**
424  * @title Contracts that should not own Ether
425  * @author Remco Bloemen <remco@2π.com>
426  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
427  * in the contract, it will allow the owner to reclaim this ether.
428  * @notice Ether can still be send to this contract by:
429  * calling functions labeled `payable`
430  * `selfdestruct(contract_address)`
431  * mining directly to the contract address
432 */
433 contract HasEther is Ownable {
434 
435   /**
436    * @dev allows direct send by settings a default function with the `payable` flag.
437    */
438   function() public payable {
439   }
440 
441   /**
442    * @dev Transfer all Ether held by the contract to the owner.
443    */
444   function recoverETH_SendbyMistake() external onlyOwner {
445     // solium-disable-next-line security/no-send
446     assert(owner.send(address(this).balance));
447   }
448 }
449 
450 /**
451  * @title Contracts that should not own Contracts
452  * @notice updated to "reclaimChildOwnership", ease to remember function's nature @AlberEre
453  * @author Remco Bloemen <remco@2π.com>
454  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
455  * of this contract to reclaim ownership of the contracts.
456  */
457 contract HasNoContracts is Ownable {
458 
459   /**
460    * @dev Reclaim ownership of Ownable contracts
461    * @param contractAddr The address of the Ownable to be reclaimed.
462    */
463   function reclaimChildOwnership(address contractAddr) public onlyOwner {
464     Ownable contractInst = Ownable(contractAddr);
465     contractInst.transferOwnership(owner);
466   }
467 }
468 
469 /**
470  * @title iron Token Contract
471  * @notice "openBarrier" modifier applied, security check during minting process
472  */
473 contract IRONtoken is MintableToken, CanReclaimToken, HasEther, HasNoContracts {
474 
475   string public constant name = "iron Bank Network token"; // solium-disable-line uppercase
476   string public constant symbol = "IRON"; // solium-disable-line uppercase
477   uint8 public constant decimals = 18; // solium-disable-line uppercase
478 
479   function IRONtoken() public {
480   }
481 
482   function setBarrierAsOpen(bool enable) onlyOwner public {
483       // bool(false) during token sale, bool(true) once token sale is finished
484       transferEnabled = enable;
485   }
486 }
487 
488 /**
489  * @title iron Token Sale
490  */
491 contract IRONtokenSale is PoolPartyToken, CanReclaimToken, HasNoContracts {
492     using SafeMath for uint256;
493 
494     IRONtoken public token;
495 
496     struct Round {
497         uint256 start;          //Timestamp of token sale start (this stage)
498         uint256 end;            //Timestamp of token sale end (this stage)
499         uint256 rate;           //How much IRON you will receive per 1 ETH within this stage
500     }
501 
502     Round[] public rounds;          //Array of token sale stages
503     uint256 public hardCap;         //Max amount of tokens to mint
504     uint256 public tokensMinted;    //Amount of tokens already minted
505     bool public finalized;          //token sale is finalized
506 
507     function IRONtokenSale (uint256 _hardCap, uint256 _initMinted) public {
508 
509       token = new IRONtoken();
510       token.setBarrierAsOpen(false);
511       tokensMinted = token.totalSupply();
512       require(_hardCap > 0);
513       hardCap = _hardCap;
514       mintTokens(msg.sender, _initMinted);
515     }
516 
517     function addRound(uint256 StartTimeStamp, uint256 EndTimeStamp, uint256 Rate) onlyOwner public {
518       rounds.push(Round(StartTimeStamp, EndTimeStamp, Rate));
519     }
520 
521     /**
522     * @notice Mint tokens for Airdrops (only external) by Alber Erre
523     */
524     function saleAirdrop(address beneficiary, uint256 amount) onlyOwner external {
525         mintTokens(beneficiary, amount);
526     }
527     
528     /**
529     * @notice Mint tokens for multiple addresses for Airdrops (only external) - Alber Erre
530     */
531     function MultiplesaleAirdrop(address[] beneficiaries, uint256[] amounts) onlyOwner external {
532       for (uint256 r=0; r<beneficiaries.length; r++){
533         mintTokens(address(beneficiaries[r]), uint256(amounts[r]));
534       }
535     }
536     
537     /**
538     * @notice Shows if crowdsale is running
539     */ 
540     function ironTokensaleRunning() view public returns(bool){
541         return (!finalized && (tokensMinted < hardCap));
542     }
543 
544     function currentTime() view public returns(uint256) {
545       return uint256(block.timestamp);
546     }
547 
548     /**
549     * @notice Return current round according to current time
550     */ 
551     function RoundIndex() internal returns(uint256) {
552       uint256 index = 0;
553       for (uint256 r=0; r<rounds.length; r++){
554         if ( (rounds[r].start < uint256(block.timestamp)) && (uint256(block.timestamp) < rounds[r].end) ) {
555           index = r.add(1);
556         }
557       }
558       return index;
559     }
560 
561     function currentRound() view public returns(uint256) {
562       return RoundIndex();
563     }
564 
565     function currentRate() view public returns(uint256) {
566         uint256 thisRound = RoundIndex();
567         if (thisRound != 0) {
568             return uint256(rounds[thisRound.sub(1)].rate);
569         } else {
570             return 0;
571         }
572     }
573     
574     function _magic(uint256 _weiAmount) internal view returns (uint256) {
575       uint256 tokenRate = currentRate();
576       require(tokenRate > 0);
577       uint256 preTransformweiAmount = tokenRate.mul(_weiAmount);
578       uint256 transform = 10**18;
579       uint256 TransformedweiAmount = preTransformweiAmount.div(transform);
580       return TransformedweiAmount;
581     }
582 
583     /**
584      * @dev fallback function ***DO NOT OVERRIDE***
585      */
586     function () external payable {
587       require(msg.value > 0);
588       require(ironTokensaleRunning());
589       uint256 weiAmount = msg.value;
590       uint256 tokens = _magic(weiAmount);
591       JustForward(msg.value);
592       mintTokens(msg.sender, tokens);
593     }
594 
595     /**
596     * @notice mint tokens and apply PoolParty method (Alber Erre)
597     * @dev Helper function to mint tokens and increase tokensMinted counter
598     */
599     function mintTokens(address beneficiary, uint256 amount) internal {
600         tokensMinted = tokensMinted.add(amount);       
601 
602         require(tokensMinted <= hardCap);
603         assert(token.mint(beneficiary, amount));
604 
605         // Add holder for future iron profits distribution
606         AddHOLDer(beneficiary);
607     }
608 
609     function JustForward(uint256 weiAmount) internal {
610       owner.transfer(weiAmount);
611     }
612 
613     function forwardCollectedEther() onlyOwner public {
614         if(address(this).balance > 0){
615             owner.transfer(address(this).balance);
616         }
617     }
618 
619     /**
620     * @notice ICO End: "openBarrier" no longer applied, allows token transfers
621     */
622     function finalizeTokensale() onlyOwner public {
623         finalized = true;
624         assert(token.finishMinting());
625         token.setBarrierAsOpen(true);
626         token.transferOwnership(owner);
627         forwardCollectedEther();
628     }
629 }