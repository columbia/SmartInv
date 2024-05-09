1 pragma solidity ^0.4.19;
2 
3 /**
4  * BRX.SPACE (contact@brx.space)
5  * 
6  * BRX token is a virtual token, governed by ERC20-compatible
7  * Ethereum Smart Contract and secured by Ethereum Blockchain
8  *
9  * The official website is https://brx.space
10  * 
11  * The uints are all in wei and atto tokens (*10^-18)
12 
13  * The contract code itself, as usual, is at the end, after all the connected libraries
14  * Developed by 262dfb6c55bf6ac215fac30181bdbfb8a2872cc7e3ea7cffe3a001621bb559e2
15  */
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22   function mul(uint a, uint b) internal pure returns (uint) {
23     uint c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27   function div(uint a, uint b) internal pure returns (uint) {
28     uint c = a / b;
29     return c;
30   }
31   function sub(uint a, uint b) internal pure returns (uint) {
32     assert(b <= a);
33     return a - b;
34   }
35   function add(uint a, uint b) internal pure returns (uint) {
36     uint c = a + b;
37     assert(c >= a);
38     return c;
39   }
40   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
41     return a >= b ? a : b;
42   }
43   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
44     return a < b ? a : b;
45   }
46   function max256(uint a, uint b) internal pure returns (uint) {
47     return a >= b ? a : b;
48   }
49   function min256(uint a, uint b) internal pure returns (uint) {
50     return a < b ? a : b;
51   }
52 }
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/179
58  */
59 contract ERC20Basic {
60   uint public totalSupply;
61   function balanceOf(address who) public constant returns (uint);
62   function transfer(address to, uint value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint value);
64 }
65 
66 /**
67  * @title ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/20
69  */
70 contract ERC20 is ERC20Basic {
71   function allowance(address owner, address spender) public constant returns (uint);
72   function transferFrom(address from, address to, uint value) public returns (bool);
73   function approve(address spender, uint value) public returns (bool);
74   event Approval(address indexed owner, address indexed spender, uint value);
75 }
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances.
80  */
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint;
83 
84   mapping(address => uint) balances;
85 
86   /**
87    * Fix for the ERC20 short address attack  
88    */
89   modifier onlyPayloadSize(uint size) {
90    require(msg.data.length >= size + 4);
91    _;
92   }
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) returns (bool) {
100     require(_to != address(0) &&
101         _value <= balances[msg.sender]);
102 
103     // SafeMath.sub will throw if there is not enough balance.
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of.
113   * @return An uint representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) public constant returns (uint balance) {
116     return balances[_owner];
117   }
118   
119 }
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is ERC20, BasicToken {
129 
130   mapping (address => mapping (address => uint)) internal allowed;
131 
132   /**
133    * @dev Transfer tokens from one address to another
134    * @param _from address The address which you want to send tokens from
135    * @param _to address The address which you want to transfer to
136    * @param _value uint the amount of tokens to be transferred
137    */
138   function transferFrom(address _from, address _to, uint _value) public returns (bool) {
139     require(_to != address(0) &&
140         _value <= balances[_from] &&
141         _value <= allowed[_from][msg.sender]);
142 
143     balances[_from] = balances[_from].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146     Transfer(_from, _to, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152    *
153    * Beware that changing an allowance with this method brings the risk that someone may use both the old
154    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157    * @param _spender The address which will spend the funds.
158    * @param _value The amount of tokens to be spent.
159    */
160   function approve(address _spender, uint _value) public returns (bool) {
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Function to check the amount of tokens that an owner allowed to a spender.
168    * @param _owner address The address which owns the funds.
169    * @param _spender address The address which will spend the funds.
170    * @return A uint specifying the amount of tokens still available for the spender.
171    */
172   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
173     return allowed[_owner][_spender];
174   }
175 
176   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
177     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
178     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179     return true;
180   }
181   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
182     uint oldValue = allowed[msg.sender][_spender];
183     if (_subtractedValue > oldValue) {
184       allowed[msg.sender][_spender] = 0;
185     } else {
186       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
187     }
188     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192 }
193 
194 /**
195  * @title Ownable
196  * @dev The Ownable contract has an owner address, and provides basic authorization control
197  * functions, this simplifies the implementation of "user permissions".
198  */
199 contract Ownable {
200   address public owner;
201 
202   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
203 
204   /**
205    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
206    * account.
207    */
208   function Ownable() public {
209     owner = msg.sender;
210   }
211 
212 
213   /**
214    * @dev Throws if called by any account other than the owner.
215    */
216   modifier onlyOwner() {
217     require(msg.sender == owner);
218     _;
219   }
220 
221 
222   /**
223    * @dev Allows the current owner to transfer control of the contract to a newOwner.
224    * @param newOwner The address to transfer ownership to.
225    */
226   function transferOwnership(address newOwner) public onlyOwner {
227     require(newOwner != address(0));
228     OwnershipTransferred(owner, newOwner);
229     owner = newOwner;
230   }
231 
232 }
233 
234 
235 contract BRXToken is StandardToken, Ownable {
236   using SafeMath for uint;
237 
238   //---------------  Info for ERC20 explorers  -----------------//
239   string public constant name = "BRX Coin";
240   string public constant symbol = "BRX";
241   uint8 public constant decimals = 18;
242 
243   //----------------------  Constants  -------------------------//
244   uint private constant atto = 1000000000000000000;
245   uint private constant INITIAL_SUPPLY = 15000000 * atto; // 15 mln BRX. Impossible to mint more than this
246   uint public totalSupply = INITIAL_SUPPLY;
247 
248   //----------------------  Variables  -------------------------//
249   // Made up ICO address (designating the token pool reserved for ICO, no one has access to it)
250   address public ico_address = 0x1F01f01f01f01F01F01f01F01F01f01F01f01F01;
251   address public teamWallet = 0x58096c1dCd5f338530770B1f6Fe0AcdfB90Cc87B;
252   address public addrBRXPay = 0x2F02F02F02F02f02f02f02f02F02F02f02f02f02;
253 
254   uint private current_supply = 0; // Holding the number of all the coins in existence
255   uint private ico_starting_supply = 0; // How many atto tokens *were* available for sale at the beginning of the ICO
256   uint private current_price_atto_tokens_per_wei = 0; // Holding current price (determined by the algorithm in buy())
257 
258   //--------------  Flags describing ICO stages  ---------------//
259   bool private preSoldSharesDistributed = false; // Prevents accidental re-distribution of shares
260   bool private isICOOpened = false;
261   bool private isICOClosed = false;
262   // 3 stages:
263   // Contract has just been deployed and initialized. isICOOpened == false, isICOClosed == false
264   // ICO has started, now anybody can buy(). isICOOpened == true, isICOClosed == false
265   // ICO has finished, now the team can receive the ether. isICOOpened == false, isICOClosed == true
266 
267   //-------------------  Founder Members  ----------------------//
268   uint public founderMembers = 0;
269   mapping(uint => address) private founderOwner;
270   mapping(address => uint) founderMembersInvest;
271   
272   //----------------------  Premiums  --------------------------//
273   uint[] private premiumPacks;
274   mapping(address => bool) private premiumICOMember;
275   mapping(address => uint) private premiumPacksPaid;
276   mapping(address => bool) public frozenAccounts;
277 
278   //-----------------------  Events  ---------------------------//
279   event ICOOpened();
280   event ICOClosed();
281 
282   event PriceChanged(uint old_price, uint new_price);
283   event SupplyChanged(uint supply, uint old_supply);
284 
285   event FrozenFund(address _from, bool _freeze);
286 
287   event BRXAcquired(address account, uint amount_in_wei, uint amount_in_brx);
288   event BRXNewFounder(address account, uint amount_in_brx);
289 
290   // ***************************************************************************
291   // Constructor
292 
293   function BRXToken() public {
294     // Some percentage of the tokens is already reserved by early employees and investors
295     // Here we're initializing their balances
296     distributePreSoldShares();
297 
298     // Starting price
299     current_price_atto_tokens_per_wei = calculateCurrentPrice(1);
300 
301     // Some other initializations
302     premiumPacks.length = 0;
303   }
304 
305   // Sending ether directly to the contract invokes buy() and assigns tokens to the sender
306   function () public payable {
307     buy();
308   }
309 
310   // ------------------------------------------------------------------------
311   // Owner can transfer out any accidentally sent ERC20 tokens
312   // ------------------------------------------------------------------------
313   function transferAnyERC20Token(
314     address tokenAddress, uint tokens
315   ) public onlyOwner
316     returns (bool success) {
317     return StandardToken(tokenAddress).transfer(owner, tokens);
318   }
319 
320   // ***************************************************************************
321 
322   // Buy token by sending ether here
323   //
324   // Price is being determined by the algorithm in recalculatePrice()
325   // You can also send the ether directly to the contract address
326   function buy() public payable {
327     require(msg.value != 0 && isICOOpened == true && isICOClosed == false);
328 
329     // Deciding how many tokens can be bought with the ether received
330     uint tokens = getAttoTokensAmountPerWeiInternal(msg.value);
331 
332     // Don't allow to buy more than 1% per transaction (secures from huge investors swalling the whole thing in 1 second)
333     uint allowedInOneTransaction = current_supply / 100;
334     require(tokens < allowedInOneTransaction &&
335         tokens <= balances[ico_address]);
336 
337     // Transfer from the ICO pool
338     balances[ico_address] = balances[ico_address].sub(tokens); // if not enough, will throw
339     balances[msg.sender] = balances[msg.sender].add(tokens);
340     premiumICOMember[msg.sender] = true;
341     
342     // Check if sender has become a founder member
343     if (balances[msg.sender] >= 2000000000000000000000) {
344         if (founderMembersInvest[msg.sender] == 0) {
345             founderOwner[founderMembers] = msg.sender;
346             founderMembers++; BRXNewFounder(msg.sender, balances[msg.sender]);
347         }
348         founderMembersInvest[msg.sender] = balances[msg.sender];
349     }
350 
351     // Kick the price changing algo
352     uint old_price = current_price_atto_tokens_per_wei;
353     current_price_atto_tokens_per_wei = calculateCurrentPrice(getAttoTokensBoughtInICO());
354     if (current_price_atto_tokens_per_wei == 0) current_price_atto_tokens_per_wei = 1; // in case it is too small that it gets rounded to zero
355     if (current_price_atto_tokens_per_wei > old_price) current_price_atto_tokens_per_wei = old_price; // in case some weird overflow happens
356 
357     // Broadcasting price change event
358     if (old_price != current_price_atto_tokens_per_wei) PriceChanged(old_price, current_price_atto_tokens_per_wei);
359 
360     // Broadcasting the buying event
361     BRXAcquired(msg.sender, msg.value, tokens);
362   }
363 
364   // Formula for the dynamic price change algorithm
365   function calculateCurrentPrice(
366     uint attoTokensBought
367   ) private pure
368     returns (uint result) {
369     // see http://www.wolframalpha.com/input/?i=f(x)+%3D+395500000+%2F+(x+%2B+150000)+-+136
370     // mixing safe and usual math here because the division will throw on inconsistency
371     return (395500000 / ((attoTokensBought / atto) + 150000)).sub(136);
372   }
373 
374   // ***************************************************************************
375   // Functions for the contract owner
376 
377   function openICO() public onlyOwner {
378     require(isICOOpened == false && isICOClosed == false);
379     isICOOpened = true;
380 
381     ICOOpened();
382   }
383   function closeICO() public onlyOwner {
384     require(isICOClosed == false && isICOOpened == true);
385 
386     isICOOpened = false;
387     isICOClosed = true;
388 
389     // Redistribute ICO Tokens that were not bought as the first premiums
390     premiumPacks.length = 1;
391     premiumPacks[0] = balances[ico_address];
392     balances[ico_address] = 0;
393 
394     ICOClosed();
395   }
396   function pullEtherFromContract() public onlyOwner {
397     require(isICOClosed == true); // Only when ICO is closed
398     if (!teamWallet.send(this.balance)) {
399       revert();
400     }
401   }
402   function freezeAccount(
403     address _from, bool _freeze
404   ) public onlyOwner
405     returns (bool) {
406     frozenAccounts[_from] = _freeze;
407     FrozenFund(_from, _freeze);  
408     return true;
409   }
410   function setNewBRXPay(
411     address newBRXPay
412   ) public onlyOwner {
413     require(newBRXPay != address(0));
414     addrBRXPay = newBRXPay;
415   }
416   function transferFromBRXPay(
417     address _from, address _to, uint _value
418   ) public allowedPayments
419     returns (bool) {
420     require(msg.sender == addrBRXPay && balances[_to].add(_value) > balances[_to] &&
421     _value <= balances[_from] && !frozenAccounts[_from] &&
422     !frozenAccounts[_to] && _to != address(0));
423     
424     balances[_from] = balances[_from].sub(_value);
425     balances[_to] = balances[_to].add(_value);
426     Transfer(_from, _to, _value);
427     return true;
428   }
429   function setCurrentPricePerWei(
430     uint _new_price  
431   ) public onlyOwner
432   returns (bool) {
433     require(isICOClosed == true && _new_price > 0); // Only when ICO is closed
434     uint old_price = current_price_atto_tokens_per_wei;
435     current_price_atto_tokens_per_wei = _new_price;
436     PriceChanged(old_price, current_price_atto_tokens_per_wei);
437   }
438 
439   // ***************************************************************************
440   // Some percentage of the tokens is already reserved by early employees and investors
441   // Here we're initializing their balances
442 
443   function distributePreSoldShares() private onlyOwner {
444     // Making it impossible to call this function twice
445     require(preSoldSharesDistributed == false);
446     preSoldSharesDistributed = true;
447 
448     // Values are in atto tokens
449     balances[0xAEC5cbcCF89fc25e955A53A5a015f7702a14b629] = 7208811 * atto;
450     balances[0xAECDCB2a8e2cFB91869A9af30050BEa038034949] = 4025712 * atto;
451     balances[0xAECF0B1b6897195295FeeD1146F3732918a5b3E4] = 300275 * atto;
452     balances[0xAEC80F0aC04f389E84F3f4b39827087e393EB229] = 150000 * atto;
453     balances[0xAECc9545385d858D3142023d3c298a1662Aa45da] = 150000 * atto;
454     balances[0xAECE71616d07F609bd2CbD4122FbC9C4a2D11A9D] = 90000 * atto;
455     balances[0xAECee3E9686825e0c8ea65f1bC8b1aB613545B8e] = 75000 * atto;
456     balances[0xAECC8E8908cE17Dd6dCFFFDCCD561696f396148F] = 202 * atto;
457     current_supply = (7208811 + 4025712 + 300275 + 150000 + 150000 + 90000 + 75000 + 202) * atto;
458 
459     // Sending the rest to ICO pool
460     balances[ico_address] = INITIAL_SUPPLY.sub(current_supply);
461 
462     // Initializing the supply variables
463     ico_starting_supply = balances[ico_address];
464     current_supply = INITIAL_SUPPLY;
465     SupplyChanged(0, current_supply);
466   }
467 
468   // ***************************************************************************
469   // Some useful getters (although you can just query the public variables)
470 
471   function getIcoStatus() public view
472     returns (string result) {
473     return (isICOClosed) ? 'closed' : (isICOOpened) ? 'opened' : 'not opened' ;
474   }
475   function getCurrentPricePerWei() public view
476     returns (uint result) {
477     return current_price_atto_tokens_per_wei;
478   }
479   function getAttoTokensAmountPerWeiInternal(
480     uint value
481   ) public payable
482     returns (uint result) {
483     return value * current_price_atto_tokens_per_wei;
484   }
485   function getAttoTokensAmountPerWei(
486     uint value
487   ) public view
488   returns (uint result) {
489     return value * current_price_atto_tokens_per_wei;
490   }
491   function getAttoTokensLeftForICO() public view
492     returns (uint result) {
493     return balances[ico_address];
494   }
495   function getAttoTokensBoughtInICO() public view
496     returns (uint result) {
497     return ico_starting_supply - getAttoTokensLeftForICO();
498   }
499   function getPremiumPack(uint index) public view
500     returns (uint premium) {
501     return premiumPacks[index];
502   }
503   function getPremiumsAvailable() public view
504     returns (uint length) {
505     return premiumPacks.length;
506   }
507   function getBalancePremiumsPaid(
508     address account
509   ) public view
510     returns (uint result) {
511     return premiumPacksPaid[account];
512   }
513   function getAttoTokensToBeFounder() public view
514   returns (uint result) {
515     return 2000000000000000000000 / getCurrentPricePerWei();
516   }
517   function getFounderMembersInvest(
518     address account
519   ) public view
520     returns (uint result) {
521     return founderMembersInvest[account];
522   }
523   function getFounderMember(
524     uint index
525   ) public onlyOwner view
526     returns (address account) {
527     require(founderMembers >= index && founderOwner[index] != address(0));
528     return founderOwner[index];
529   }
530 
531   // ***************************************************************************
532   // Premiums
533 
534   function sendPremiumPack(
535     uint amount
536   ) public onlyOwner allowedPayments {
537     premiumPacks.length += 1;
538     premiumPacks[premiumPacks.length-1] = amount;
539     balances[msg.sender] = balances[msg.sender].sub(amount); // will throw and revert the whole thing if doesn't have this amount
540   }
541   function getPremiums() public allowedPayments
542     returns (uint amount) {
543     require(premiumICOMember[msg.sender]);
544     if (premiumPacks.length > premiumPacksPaid[msg.sender]) {
545       uint startPackIndex = premiumPacksPaid[msg.sender];
546       uint finishPackIndex = premiumPacks.length - 1;
547       uint owingTotal = 0;
548       for(uint i = startPackIndex; i <= finishPackIndex; i++) {
549         if (current_supply != 0) { // just in case
550           uint owing = balances[msg.sender] * premiumPacks[i] / current_supply;
551           balances[msg.sender] = balances[msg.sender].add(owing);
552           owingTotal = owingTotal + owing;
553         }
554       }
555       premiumPacksPaid[msg.sender] = premiumPacks.length;
556       return owingTotal;
557     } else {
558       revert();
559     }
560   }
561 
562   // ***************************************************************************
563   // Overriding payment functions to take control over the logic
564 
565   modifier allowedPayments() {
566     // Don't allow to transfer coins until the ICO ends
567     require(isICOOpened == false && isICOClosed == true && !frozenAccounts[msg.sender]);
568     _;
569   }
570   
571   function transferFrom(
572     address _from, address _to, uint _value
573   ) public allowedPayments
574     returns (bool) {
575     super.transferFrom(_from, _to, _value);
576   }
577   
578   function transfer(
579     address _to, uint _value
580   ) public onlyPayloadSize(2 * 32) allowedPayments
581     returns (bool) {
582     super.transfer(_to, _value);
583   }
584 
585 }