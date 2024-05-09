1 pragma solidity ^0.4.17;
2 
3 contract J8TTokenConfig {
4     // The J8T decimals
5     uint8 public constant TOKEN_DECIMALS = 8;
6 
7     // The J8T decimal factor to obtain luckys
8     uint256 public constant J8T_DECIMALS_FACTOR = 10**uint256(TOKEN_DECIMALS);
9 }
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   function Ownable() {
28     owner = msg.sender;
29   }
30 
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address newOwner) onlyOwner public {
46     require(newOwner != address(0));
47     OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 
51 }
52 
53 /**
54  * @title SafeMath
55  * @dev Math operations with safety checks that throw on error
56  */
57 library SafeMath {
58   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
59     uint256 c = a * b;
60     assert(a == 0 || c / a == b);
61     return c;
62   }
63 
64   function div(uint256 a, uint256 b) internal constant returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   function add(uint256 a, uint256 b) internal constant returns (uint256) {
77     uint256 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 /**
84  * @title ERC20Basic
85  * @dev Simpler version of ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/179
87  */
88 contract ERC20Basic {
89   uint256 public totalSupply;
90   function balanceOf(address who) public constant returns (uint256);
91   function transfer(address to, uint256 value) public returns (bool);
92   event Transfer(address indexed from, address indexed to, uint256 value);
93 }
94 
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances.
98  */
99 contract BasicToken is ERC20Basic {
100   using SafeMath for uint256;
101 
102   mapping(address => uint256) balances;
103 
104   /**
105   * @dev transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111 
112     // SafeMath.sub will throw if there is not enough balance.
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) public constant returns (uint256 balance) {
125     return balances[_owner];
126   }
127 
128 }
129 
130 /**
131  * @title ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/20
133  */
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender) public constant returns (uint256);
136   function transferFrom(address from, address to, uint256 value) public returns (bool);
137   function approve(address spender, uint256 value) public returns (bool);
138   event Approval(address indexed owner, address indexed spender, uint256 value);
139 }
140 
141 /**
142  * @title Standard ERC20 token
143  *
144  * @dev Implementation of the basic standard token.
145  * @dev https://github.com/ethereum/EIPs/issues/20
146  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
147  */
148 contract StandardToken is ERC20, BasicToken {
149 
150   mapping (address => mapping (address => uint256)) allowed;
151 
152 
153   /**
154    * @dev Transfer tokens from one address to another
155    * @param _from address The address which you want to send tokens from
156    * @param _to address The address which you want to transfer to
157    * @param _value uint256 the amount of tokens to be transferred
158    */
159   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
160     require(_to != address(0));
161 
162     uint256 _allowance = allowed[_from][msg.sender];
163 
164     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
165     // require (_value <= _allowance);
166 
167     balances[_from] = balances[_from].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     allowed[_from][msg.sender] = _allowance.sub(_value);
170     Transfer(_from, _to, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    *
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
197     return allowed[_owner][_spender];
198   }
199 
200   /**
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    */
206   function increaseApproval (address _spender, uint _addedValue)
207     returns (bool success) {
208     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
209     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 
213   function decreaseApproval (address _spender, uint _subtractedValue)
214     returns (bool success) {
215     uint oldValue = allowed[msg.sender][_spender];
216     if (_subtractedValue > oldValue) {
217       allowed[msg.sender][_spender] = 0;
218     } else {
219       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220     }
221     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225 }
226 
227 /**
228  * @title Burnable Token
229  * @dev Token that can be irreversibly burned (destroyed).
230  */
231 contract BurnableToken is StandardToken {
232 
233     event Burn(address indexed burner, uint256 value);
234 
235     /**
236      * @dev Burns a specific amount of tokens.
237      * @param _value The amount of token to be burned.
238      */
239     function burn(uint256 _value) public {
240         require(_value > 0);
241 
242         address burner = msg.sender;
243         balances[burner] = balances[burner].sub(_value);
244         totalSupply = totalSupply.sub(_value);
245         Burn(burner, _value);
246     }
247 }
248 
249 //////////////////////////////////////////////////////////////////////
250 // @title J8T Token                                                 //
251 // @dev ERC20 J8T Token                                             //
252 //                                                                  //
253 // J8T Tokens are divisible by 1e8 (100,000,000) base               //
254 //                                                                  //
255 // J8T are displayed using 8 decimal places of precision.           //
256 //                                                                  //
257 // 1 J8T is equivalent to 100000000 luckys:                         //
258 //   100000000 == 1 * 10**8 == 1e8 == One Hundred Million luckys    //
259 //                                                                  //
260 // 1,5 Billion J8T (total supply) is equivalent to:                 //
261 //   150000000000000000 == 1500000000 * 10**8 == 1,5e17 luckys      //
262 //                                                                  //
263 //////////////////////////////////////////////////////////////////////
264 
265 contract J8TToken is J8TTokenConfig, BurnableToken, Ownable {
266     string public constant name            = "J8T Token";
267     string public constant symbol          = "J8T";
268     uint256 public constant decimals       = TOKEN_DECIMALS;
269     uint256 public constant INITIAL_SUPPLY = 1500000000 * (10 ** uint256(decimals));
270 
271     event Transfer(address indexed _from, address indexed _to, uint256 _value);
272 
273     function J8TToken() {
274         totalSupply = INITIAL_SUPPLY;
275         balances[msg.sender] = INITIAL_SUPPLY;
276 
277         //https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer-1
278         //EIP 20: A token contract which creates new tokens SHOULD trigger a
279         //Transfer event with the _from address set to 0x0
280         //when tokens are created.
281         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
282      }
283 }
284 
285 
286 contract ACLManaged is Ownable {
287     
288     ///////////////////////////
289     // ACLManaged PROPERTIES //
290     ///////////////////////////
291 
292     // The operational acl address
293     address public opsAddress;
294 
295     // The admin acl address
296     address public adminAddress;
297 
298     ////////////////////////////////////////
299     // ACLManaged FUNCTIONS and MODIFIERS //
300     ////////////////////////////////////////
301 
302     function ACLManaged() public Ownable() {}
303 
304     // Updates the opsAddress propety with the new _opsAddress value
305     function setOpsAddress(address _opsAddress) external onlyOwner returns (bool) {
306         require(_opsAddress != address(0));
307         require(_opsAddress != address(this));
308 
309         opsAddress = _opsAddress;
310         return true;
311     }
312 
313     // Updates the adminAddress propety with the new _adminAddress value
314     function setAdminAddress(address _adminAddress) external onlyOwner returns (bool) {
315         require(_adminAddress != address(0));
316         require(_adminAddress != address(this));
317 
318         adminAddress = _adminAddress;
319         return true;
320     }
321 
322     //Checks if an address is owner
323     function isOwner(address _address) public view returns (bool) {
324         bool result = (_address == owner);
325         return result;
326     }
327 
328     //Checks if an address is operator
329     function isOps(address _address) public view returns (bool) {
330         bool result = (_address == opsAddress);
331         return result;
332     }
333 
334     //Checks if an address is ops or admin
335     function isOpsOrAdmin(address _address) public view returns (bool) {
336         bool result = (_address == opsAddress || _address == adminAddress);
337         return result;
338     }
339 
340     //Checks if an address is ops,owner or admin
341     function isOwnerOrOpsOrAdmin(address _address) public view returns (bool) {
342         bool result = (_address == opsAddress || _address == adminAddress || _address == owner);
343         return result;
344     }
345 
346     //Checks whether the msg.sender address is equal to the adminAddress property or not
347     modifier onlyAdmin() {
348         //Needs to be set. Default constructor will set 0x0;
349         address _address = msg.sender;
350         require(_address != address(0));
351         require(_address == adminAddress);
352         _;
353     }
354 
355     // Checks whether the msg.sender address is equal to the opsAddress property or not
356     modifier onlyOps() {
357         //Needs to be set. Default constructor will set 0x0;
358         address _address = msg.sender;
359         require(_address != address(0));
360         require(_address == opsAddress);
361         _;
362     }
363 
364     // Checks whether the msg.sender address is equal to the opsAddress or adminAddress property
365     modifier onlyAdminAndOps() {
366         //Needs to be set. Default constructor will set 0x0;
367         address _address = msg.sender;
368         require(_address != address(0));
369         require(_address == opsAddress || _address == adminAddress);
370         _;
371     }
372 }
373 
374 contract CrowdsaleConfig is J8TTokenConfig {
375     using SafeMath for uint256;
376 
377     // Default start token sale date is 28th February 15:00 SGP 2018
378     uint256 public constant START_TIMESTAMP = 1519801200;
379 
380     // Default end token sale date is 14th March 15:00 SGP 2018
381     uint256 public constant END_TIMESTAMP   = 1521010800;
382 
383     // The ETH decimal factor to obtain weis
384     uint256 public constant ETH_DECIMALS_FACTOR = 10**uint256(18);
385 
386     // The token sale supply 
387     uint256 public constant TOKEN_SALE_SUPPLY = 450000000 * J8T_DECIMALS_FACTOR;
388 
389     // The minimum contribution amount in weis
390     uint256 public constant MIN_CONTRIBUTION_WEIS = 0.1 ether;
391 
392     // The maximum contribution amount in weis
393     uint256 public constant MAX_CONTRIBUTION_WEIS = 10 ether;
394 
395     //@WARNING: WORKING WITH KILO-MULTIPLES TO AVOID IMPOSSIBLE DIVISIONS OF FLOATING POINTS.
396     uint256 constant dollar_per_kilo_token = 100; //0.1 dollar per token
397     uint256 public constant dollars_per_kilo_ether = 900000; //900$ per ether
398     //TOKENS_PER_ETHER = dollars_per_ether / dollar_per_token
399     uint256 public constant INITIAL_TOKENS_PER_ETHER = dollars_per_kilo_ether.div(dollar_per_kilo_token);
400 }
401 
402 contract Ledger is ACLManaged {
403     
404     using SafeMath for uint256;
405 
406     ///////////////////////
407     // Ledger PROPERTIES //
408     ///////////////////////
409 
410     // The Allocation struct represents a token sale purchase
411     // amountGranted is the amount of tokens purchased
412     // hasClaimedBonusTokens whether the allocation has been alredy claimed
413     struct Allocation {
414         uint256 amountGranted;
415         uint256 amountBonusGranted;
416         bool hasClaimedBonusTokens;
417     }
418 
419     // ContributionPhase enum cases are
420     // PreSaleContribution, the contribution has been made in the presale phase
421     // PartnerContribution, the contribution has been made in the private phase
422     enum ContributionPhase {
423         PreSaleContribution, PartnerContribution
424     }
425 
426     // Map of adresses that purchased tokens on the presale phase
427     mapping(address => Allocation) public presaleAllocations;
428 
429     // Map of adresses that purchased tokens on the private phase
430     mapping(address => Allocation) public partnerAllocations;
431 
432     // Reference to the J8TToken contract
433     J8TToken public tokenContract;
434 
435     // Reference to the Crowdsale contract
436     Crowdsale public crowdsaleContract;
437 
438     // Total private allocation, counting the amount of tokens from the
439     // partner and the presale phase
440     uint256 public totalPrivateAllocation;
441 
442     // Whether the token allocations can be claimed on the partner sale phase
443     bool public canClaimPartnerTokens;
444 
445     // Whether the token allocations can be claimed on the presale sale phase
446     bool public canClaimPresaleTokens;
447 
448     // Whether the bonus token allocations can be claimed
449     bool public canClaimPresaleBonusTokensPhase1;
450     bool public canClaimPresaleBonusTokensPhase2;
451 
452     // Whether the bonus token allocations can be claimed
453     bool public canClaimPartnerBonusTokensPhase1;
454     bool public canClaimPartnerBonusTokensPhase2;
455 
456     ///////////////////
457     // Ledger EVENTS //
458     ///////////////////
459 
460     // Triggered when an allocation has been granted
461     event AllocationGranted(address _contributor, uint256 _amount, uint8 _phase);
462 
463     // Triggered when an allocation has been revoked
464     event AllocationRevoked(address _contributor, uint256 _amount, uint8 _phase);
465 
466     // Triggered when an allocation has been claimed
467     event AllocationClaimed(address _contributor, uint256 _amount);
468 
469     // Triggered when a bonus allocation has been claimed
470     event AllocationBonusClaimed(address _contributor, uint256 _amount);
471 
472     // Triggered when crowdsale contract updated
473     event CrowdsaleContractUpdated(address _who, address _old_address, address _new_address);
474 
475     //Triggered when any can claim token boolean is updated. _type param indicates which is updated.
476     event CanClaimTokensUpdated(address _who, string _type, bool _oldCanClaim, bool _newCanClaim);
477 
478     //////////////////////
479     // Ledger FUNCTIONS //
480     //////////////////////
481 
482     // Ledger constructor
483     // Sets default values for canClaimPresaleTokens and canClaimPartnerTokens properties
484     function Ledger(J8TToken _tokenContract) public {
485         require(address(_tokenContract) != address(0));
486         tokenContract = _tokenContract;
487         canClaimPresaleTokens = false;
488         canClaimPartnerTokens = false;
489         canClaimPresaleBonusTokensPhase1 = false;
490         canClaimPresaleBonusTokensPhase2 = false;
491         canClaimPartnerBonusTokensPhase1 = false;
492         canClaimPartnerBonusTokensPhase2 = false;
493     }
494 
495     function () external payable {
496         claimTokens();
497     }
498 
499     // Revokes an allocation from the contributor with address _contributor
500     // Deletes the allocation from the corresponding mapping property and transfers
501     // the total amount of tokens of the allocation back to the Crowdsale contract
502     function revokeAllocation(address _contributor, uint8 _phase) public onlyAdminAndOps payable returns (uint256) {
503         require(_contributor != address(0));
504         require(_contributor != address(this));
505 
506         // Can't revoke  an allocation if the contribution phase is not in the ContributionPhase enum
507         ContributionPhase _contributionPhase = ContributionPhase(_phase);
508         require(_contributionPhase == ContributionPhase.PreSaleContribution ||
509                 _contributionPhase == ContributionPhase.PartnerContribution);
510 
511         uint256 grantedAllocation = 0;
512 
513         // Deletes the allocation from the respective mapping
514         if (_contributionPhase == ContributionPhase.PreSaleContribution) {
515             grantedAllocation = presaleAllocations[_contributor].amountGranted.add(presaleAllocations[_contributor].amountBonusGranted);
516             delete presaleAllocations[_contributor];
517         } else if (_contributionPhase == ContributionPhase.PartnerContribution) {
518             grantedAllocation = partnerAllocations[_contributor].amountGranted.add(partnerAllocations[_contributor].amountBonusGranted);
519             delete partnerAllocations[_contributor];
520         }
521 
522         // The granted amount allocation must be less that the current token supply on the contract
523         uint256 currentSupply = tokenContract.balanceOf(address(this));
524         require(grantedAllocation <= currentSupply);
525 
526         // Updates the total private allocation substracting the amount of tokens that has been revoked
527         require(grantedAllocation <= totalPrivateAllocation);
528         totalPrivateAllocation = totalPrivateAllocation.sub(grantedAllocation);
529         
530         // We sent back the amount of tokens that has been revoked to the corwdsale contract
531         require(tokenContract.transfer(address(crowdsaleContract), grantedAllocation));
532 
533         AllocationRevoked(_contributor, grantedAllocation, _phase);
534 
535         return grantedAllocation;
536 
537     }
538 
539     // Adds a new allocation for the contributor with address _contributor
540     function addAllocation(address _contributor, uint256 _amount, uint256 _bonus, uint8 _phase) public onlyAdminAndOps returns (bool) {
541         require(_contributor != address(0));
542         require(_contributor != address(this));
543 
544         // Can't create or update an allocation if the amount of tokens to be allocated is not greater than zero
545         require(_amount > 0);
546 
547         // Can't create an allocation if the contribution phase is not in the ContributionPhase enum
548         ContributionPhase _contributionPhase = ContributionPhase(_phase);
549         require(_contributionPhase == ContributionPhase.PreSaleContribution ||
550                 _contributionPhase == ContributionPhase.PartnerContribution);
551 
552 
553         uint256 totalAmount = _amount.add(_bonus);
554         uint256 totalGrantedAllocation = 0;
555         uint256 totalGrantedBonusAllocation = 0;
556 
557         // Fetch the allocation from the respective mapping and updates the granted amount of tokens
558         if (_contributionPhase == ContributionPhase.PreSaleContribution) {
559             totalGrantedAllocation = presaleAllocations[_contributor].amountGranted.add(_amount);
560             totalGrantedBonusAllocation = presaleAllocations[_contributor].amountBonusGranted.add(_bonus);
561             presaleAllocations[_contributor] = Allocation(totalGrantedAllocation, totalGrantedBonusAllocation, false);
562         } else if (_contributionPhase == ContributionPhase.PartnerContribution) {
563             totalGrantedAllocation = partnerAllocations[_contributor].amountGranted.add(_amount);
564             totalGrantedBonusAllocation = partnerAllocations[_contributor].amountBonusGranted.add(_bonus);
565             partnerAllocations[_contributor] = Allocation(totalGrantedAllocation, totalGrantedBonusAllocation, false);
566         }
567 
568         // Updates the contract data
569         totalPrivateAllocation = totalPrivateAllocation.add(totalAmount);
570 
571         AllocationGranted(_contributor, totalAmount, _phase);
572 
573         return true;
574     }
575 
576     // The claimTokens() function handles the contribution token claim.
577     // Tokens can only be claimed after we open this phase.
578     // The lockouts periods are defined by the foundation.
579     // There are 2 different lockouts:
580     //      Presale lockout
581     //      Partner lockout
582     //
583     // A contributor that has contributed in all the phases can claim
584     // all its tokens, but only the ones that are accesible to claim
585     // be transfered.
586     // 
587     // A contributor can claim its tokens after each phase has been opened
588     function claimTokens() public payable returns (bool) {
589         require(msg.sender != address(0));
590         require(msg.sender != address(this));
591 
592         uint256 amountToTransfer = 0;
593 
594         // We need to check if the contributor has made a contribution on each
595         // phase, presale and partner
596         Allocation storage presaleA = presaleAllocations[msg.sender];
597         if (presaleA.amountGranted > 0 && canClaimPresaleTokens) {
598             amountToTransfer = amountToTransfer.add(presaleA.amountGranted);
599             presaleA.amountGranted = 0;
600         }
601 
602         Allocation storage partnerA = partnerAllocations[msg.sender];
603         if (partnerA.amountGranted > 0 && canClaimPartnerTokens) {
604             amountToTransfer = amountToTransfer.add(partnerA.amountGranted);
605             partnerA.amountGranted = 0;
606         }
607 
608         // The amount to transfer must greater than zero
609         require(amountToTransfer > 0);
610 
611         // The amount to transfer must be less or equal to the current supply
612         uint256 currentSupply = tokenContract.balanceOf(address(this));
613         require(amountToTransfer <= currentSupply);
614         
615         // Transfer the token allocation to contributor
616         require(tokenContract.transfer(msg.sender, amountToTransfer));
617         AllocationClaimed(msg.sender, amountToTransfer);
618     
619         return true;
620     }
621 
622     function claimBonus() external payable returns (bool) {
623         require(msg.sender != address(0));
624         require(msg.sender != address(this));
625 
626         uint256 amountToTransfer = 0;
627 
628         // BONUS PHASE 1
629         Allocation storage presale = presaleAllocations[msg.sender];
630         if (presale.amountBonusGranted > 0 && !presale.hasClaimedBonusTokens && canClaimPresaleBonusTokensPhase1) {
631             uint256 amountPresale = presale.amountBonusGranted.div(2);
632             amountToTransfer = amountPresale;
633             presale.amountBonusGranted = amountPresale;
634             presale.hasClaimedBonusTokens = true;
635         }
636 
637         Allocation storage partner = partnerAllocations[msg.sender];
638         if (partner.amountBonusGranted > 0 && !partner.hasClaimedBonusTokens && canClaimPartnerBonusTokensPhase1) {
639             uint256 amountPartner = partner.amountBonusGranted.div(2);
640             amountToTransfer = amountToTransfer.add(amountPartner);
641             partner.amountBonusGranted = amountPartner;
642             partner.hasClaimedBonusTokens = true;
643         }
644 
645         // BONUS PHASE 2
646         if (presale.amountBonusGranted > 0 && canClaimPresaleBonusTokensPhase2) {
647             amountToTransfer = amountToTransfer.add(presale.amountBonusGranted);
648             presale.amountBonusGranted = 0;
649         }
650 
651         if (partner.amountBonusGranted > 0 && canClaimPartnerBonusTokensPhase2) {
652             amountToTransfer = amountToTransfer.add(partner.amountBonusGranted);
653             partner.amountBonusGranted = 0;
654         }
655 
656         // The amount to transfer must greater than zero
657         require(amountToTransfer > 0);
658 
659         // The amount to transfer must be less or equal to the current supply
660         uint256 currentSupply = tokenContract.balanceOf(address(this));
661         require(amountToTransfer <= currentSupply);
662         
663         // Transfer the token allocation to contributor
664         require(tokenContract.transfer(msg.sender, amountToTransfer));
665         AllocationBonusClaimed(msg.sender, amountToTransfer);
666 
667         return true;
668     }
669 
670     // Updates the canClaimPresaleTokens propety with the new _canClaimTokens value
671     function setCanClaimPresaleTokens(bool _canClaimTokens) external onlyAdmin returns (bool) {
672         bool _oldCanClaim = canClaimPresaleTokens;
673         canClaimPresaleTokens = _canClaimTokens;
674         CanClaimTokensUpdated(msg.sender, 'canClaimPresaleTokens', _oldCanClaim, _canClaimTokens);
675         return true;
676     }
677 
678     // Updates the canClaimPartnerTokens property with the new _canClaimTokens value
679     function setCanClaimPartnerTokens(bool _canClaimTokens) external onlyAdmin returns (bool) {
680         bool _oldCanClaim = canClaimPartnerTokens;
681         canClaimPartnerTokens = _canClaimTokens;
682         CanClaimTokensUpdated(msg.sender, 'canClaimPartnerTokens', _oldCanClaim, _canClaimTokens);
683         return true;
684     }
685 
686     // Updates the canClaimBonusTokens property with the new _canClaimTokens value
687     function setCanClaimPresaleBonusTokensPhase1(bool _canClaimTokens) external onlyAdmin returns (bool) {
688         bool _oldCanClaim = canClaimPresaleBonusTokensPhase1;
689         canClaimPresaleBonusTokensPhase1 = _canClaimTokens;
690         CanClaimTokensUpdated(msg.sender, 'canClaimPresaleBonusTokensPhase1', _oldCanClaim, _canClaimTokens);
691         return true;
692     }
693 
694     // Updates the canClaimBonusTokens property with the new _canClaimTokens value
695     function setCanClaimPresaleBonusTokensPhase2(bool _canClaimTokens) external onlyAdmin returns (bool) {
696         bool _oldCanClaim = canClaimPresaleBonusTokensPhase2;
697         canClaimPresaleBonusTokensPhase2 = _canClaimTokens;
698         CanClaimTokensUpdated(msg.sender, 'canClaimPresaleBonusTokensPhase2', _oldCanClaim, _canClaimTokens);
699         return true;
700     }
701 
702     // Updates the canClaimBonusTokens property with the new _canClaimTokens value
703     function setCanClaimPartnerBonusTokensPhase1(bool _canClaimTokens) external onlyAdmin returns (bool) {
704         bool _oldCanClaim = canClaimPartnerBonusTokensPhase1;
705         canClaimPartnerBonusTokensPhase1 = _canClaimTokens;
706         CanClaimTokensUpdated(msg.sender, 'canClaimPartnerBonusTokensPhase1', _oldCanClaim, _canClaimTokens);
707         return true;
708     }
709 
710     // Updates the canClaimBonusTokens property with the new _canClaimTokens value
711     function setCanClaimPartnerBonusTokensPhase2(bool _canClaimTokens) external onlyAdmin returns (bool) {
712         bool _oldCanClaim = canClaimPartnerBonusTokensPhase2;
713         canClaimPartnerBonusTokensPhase2 = _canClaimTokens;
714         CanClaimTokensUpdated(msg.sender, 'canClaimPartnerBonusTokensPhase2', _oldCanClaim, _canClaimTokens);
715         return true;
716     }
717 
718     // Updates the crowdsale contract property with the new _crowdsaleContract value
719     function setCrowdsaleContract(Crowdsale _crowdsaleContract) public onlyOwner returns (bool) {
720         address old_crowdsale_address = crowdsaleContract;
721 
722         crowdsaleContract = _crowdsaleContract;
723 
724         CrowdsaleContractUpdated(msg.sender, old_crowdsale_address, crowdsaleContract);
725 
726         return true;
727     }
728 }
729 
730 contract Crowdsale is ACLManaged, CrowdsaleConfig {
731 
732     using SafeMath for uint256;
733 
734     //////////////////////////
735     // Crowdsale PROPERTIES //
736     //////////////////////////
737 
738     // The J8TToken smart contract reference
739     J8TToken public tokenContract;
740 
741     // The Ledger smart contract reference
742     Ledger public ledgerContract;
743 
744     // The start token sale date represented as a timestamp
745     uint256 public startTimestamp;
746 
747     // The end token sale date represented as a timestamp
748     uint256 public endTimestamp;
749 
750     // Ratio of J8T tokens to per ether
751     uint256 public tokensPerEther;
752 
753     // The total amount of wei raised in the token sale
754     // Including presales (in eth) and public sale
755     uint256 public weiRaised;
756 
757     // The current total amount of tokens sold in the token sale
758     uint256 public totalTokensSold;
759 
760     // The minimum and maximum eth contribution accepted in the token sale
761     uint256 public minContribution;
762     uint256 public maxContribution;
763 
764     // The wallet address where the token sale sends all eth contributions
765     address public wallet;
766 
767     // Controls whether the token sale has finished or not
768     bool public isFinalized = false;
769 
770     // Map of adresses that requested to purchase tokens
771     // Contributors of the token sale are segmented as:
772     //  CannotContribute: Cannot contribute in any phase (uint8  - 0)
773     //  PreSaleContributor: Can contribute on both pre-sale and pubic sale phases (uint8  - 1)
774     //  PublicSaleContributor: Can contribute on he public sale phase (uint8  - 2)
775     mapping(address => WhitelistPermission) public whitelist;
776 
777     // Map of addresses that has already contributed on the token sale
778     mapping(address => bool) public hasContributed;
779 
780     enum WhitelistPermission {
781         CannotContribute, PreSaleContributor, PublicSaleContributor 
782     }
783 
784     //////////////////////
785     // Crowdsale EVENTS //
786     //////////////////////
787 
788     // Triggered when a contribution in the public sale has been processed correctly
789     event TokensPurchased(address _contributor, uint256 _amount);
790 
791     // Triggered when the whitelist has been updated
792     event WhiteListUpdated(address _who, address _account, WhitelistPermission _phase);
793 
794     // Triggered when the Crowdsale has been created
795     event ContractCreated();
796 
797     // Triggered when a presale has been added
798     // The phase parameter can be a strategic partner contribution or a presale contribution
799     event PresaleAdded(address _contributor, uint256 _amount, uint8 _phase);
800 
801     // Triggered when the tokensPerEther property has been updated
802     event TokensPerEtherUpdated(address _who, uint256 _oldValue, uint256 _newValue);
803 
804     // Triggered when the startTimestamp property has been updated
805     event StartTimestampUpdated(address _who, uint256 _oldValue, uint256 _newValue);
806 
807     // Triggered when the endTimestamp property has been updated
808     event EndTimestampUpdated(address _who, uint256 _oldValue, uint256 _newValue);
809 
810     // Triggered when the wallet property has been updated
811     event WalletUpdated(address _who, address _oldWallet, address _newWallet);
812 
813     // Triggered when the minContribution property has been updated
814     event MinContributionUpdated(address _who, uint256 _oldValue, uint256 _newValue);
815 
816     // Triggered when the maxContribution property has been updated
817     event MaxContributionUpdated(address _who, uint256 _oldValue, uint256 _newValue);
818 
819     // Triggered when the token sale has finalized
820     event Finalized(address _who, uint256 _timestamp);
821 
822     // Triggered when the token sale has finalized and there where still token to sale
823     // When the token are not sold, we burn them
824     event Burned(address _who, uint256 _amount, uint256 _timestamp);
825 
826     /////////////////////////
827     // Crowdsale FUNCTIONS //
828     /////////////////////////
829     
830 
831     // Crowdsale constructor
832     // Takes default values from the CrowdsaleConfig smart contract
833     function Crowdsale(
834         J8TToken _tokenContract,
835         Ledger _ledgerContract,
836         address _wallet
837     ) public
838     {
839         uint256 _start            = START_TIMESTAMP;
840         uint256 _end              = END_TIMESTAMP;
841         uint256 _supply           = TOKEN_SALE_SUPPLY;
842         uint256 _min_contribution = MIN_CONTRIBUTION_WEIS;
843         uint256 _max_contribution = MAX_CONTRIBUTION_WEIS;
844         uint256 _tokensPerEther   = INITIAL_TOKENS_PER_ETHER;
845 
846         require(_start > currentTime());
847         require(_end > _start);
848         require(_tokensPerEther > 0);
849         require(address(_tokenContract) != address(0));
850         require(address(_ledgerContract) != address(0));
851         require(_wallet != address(0));
852 
853         ledgerContract   = _ledgerContract;
854         tokenContract    = _tokenContract;
855         startTimestamp   = _start;
856         endTimestamp     = _end;
857         tokensPerEther   = _tokensPerEther;
858         minContribution = _min_contribution;
859         maxContribution = _max_contribution;
860         wallet           = _wallet;
861         totalTokensSold  = 0;
862         weiRaised        = 0;
863         isFinalized      = false;  
864 
865         ContractCreated();
866     }
867 
868     // Updates the tokenPerEther propety with the new _tokensPerEther value
869     function setTokensPerEther(uint256 _tokensPerEther) external onlyAdmin onlyBeforeSale returns (bool) {
870         require(_tokensPerEther > 0);
871 
872         uint256 _oldValue = tokensPerEther;
873         tokensPerEther = _tokensPerEther;
874 
875         TokensPerEtherUpdated(msg.sender, _oldValue, tokensPerEther);
876         return true;
877     }
878 
879     // Updates the startTimestamp propety with the new _start value
880     function setStartTimestamp(uint256 _start) external onlyAdmin returns (bool) {
881         require(_start < endTimestamp);
882         require(_start > currentTime());
883 
884         uint256 _oldValue = startTimestamp;
885         startTimestamp = _start;
886 
887         StartTimestampUpdated(msg.sender, _oldValue, startTimestamp);
888 
889         return true;
890     }
891 
892     // Updates the endTimestamp propety with the new _end value
893     function setEndTimestamp(uint256 _end) external onlyAdmin returns (bool) {
894         require(_end > startTimestamp);
895 
896         uint256 _oldValue = endTimestamp;
897         endTimestamp = _end;
898 
899         EndTimestampUpdated(msg.sender, _oldValue, endTimestamp);
900         
901         return true;
902     }
903 
904     // Updates the wallet propety with the new _newWallet value
905     function updateWallet(address _newWallet) external onlyAdmin returns (bool) {
906         require(_newWallet != address(0));
907         
908         address _oldValue = wallet;
909         wallet = _newWallet;
910         
911         WalletUpdated(msg.sender, _oldValue, wallet);
912         
913         return true;
914     }
915 
916     // Updates the minContribution propety with the new _newMinControbution value
917     function setMinContribution(uint256 _newMinContribution) external onlyAdmin returns (bool) {
918         require(_newMinContribution <= maxContribution);
919 
920         uint256 _oldValue = minContribution;
921         minContribution = _newMinContribution;
922         
923         MinContributionUpdated(msg.sender, _oldValue, minContribution);
924         
925         return true;
926     }
927 
928     // Updates the maxContribution propety with the new _newMaxContribution value
929     function setMaxContribution(uint256 _newMaxContribution) external onlyAdmin returns (bool) {
930         require(_newMaxContribution > minContribution);
931 
932         uint256 _oldValue = maxContribution;
933         maxContribution = _newMaxContribution;
934         
935         MaxContributionUpdated(msg.sender, _oldValue, maxContribution);
936         
937         return true;
938     }
939 
940     // Main public function.
941     function () external payable {
942         purchaseTokens();
943     }
944 
945     // Revokes a presale allocation from the contributor with address _contributor
946     // Updates the totalTokensSold property substracting the amount of tokens that where previously allocated
947     function revokePresale(address _contributor, uint8 _contributorPhase) external onlyAdmin returns (bool) {
948         require(_contributor != address(0));
949 
950         // We can only revoke allocations from pre sale or strategic partners
951         // ContributionPhase.PreSaleContribution == 0,  ContributionPhase.PartnerContribution == 1
952         require(_contributorPhase == 0 || _contributorPhase == 1);
953 
954         uint256 luckys = ledgerContract.revokeAllocation(_contributor, _contributorPhase);
955         
956         require(luckys > 0);
957         require(luckys <= totalTokensSold);
958         
959         totalTokensSold = totalTokensSold.sub(luckys);
960         
961         return true;
962     }
963 
964     // Adds a new presale allocation for the contributor with address _contributor
965     // We can only allocate presale before the token sale has been initialized
966     function addPresale(address _contributor, uint256 _tokens, uint256 _bonus, uint8 _contributorPhase) external onlyAdminAndOps onlyBeforeSale returns (bool) {
967         require(_tokens > 0);
968         require(_bonus > 0);
969 
970         // Converts the amount of tokens to our smallest J8T value, lucky
971         uint256 luckys = _tokens.mul(J8T_DECIMALS_FACTOR);
972         uint256 bonusLuckys = _bonus.mul(J8T_DECIMALS_FACTOR);
973         uint256 totalTokens = luckys.add(bonusLuckys);
974 
975         uint256 availableTokensToPurchase = tokenContract.balanceOf(address(this));
976         
977         require(totalTokens <= availableTokensToPurchase);
978 
979         // Insert the new allocation to the Ledger
980         require(ledgerContract.addAllocation(_contributor, luckys, bonusLuckys, _contributorPhase));
981         // Transfers the tokens form the Crowdsale contract to the Ledger contract
982         require(tokenContract.transfer(address(ledgerContract), totalTokens));
983 
984         // Updates totalTokensSold property
985         totalTokensSold = totalTokensSold.add(totalTokens);
986 
987         // If we reach the total amount of tokens to sell we finilize the token sale
988         availableTokensToPurchase = tokenContract.balanceOf(address(this));
989         if (availableTokensToPurchase == 0) {
990             finalization();
991         }
992 
993         // Trigger PresaleAdded event
994         PresaleAdded(_contributor, totalTokens, _contributorPhase);
995     }
996 
997     // The purchaseTokens function handles the token purchase flow
998     function purchaseTokens() public payable onlyDuringSale returns (bool) {
999         address contributor = msg.sender;
1000         uint256 weiAmount = msg.value;
1001 
1002         // A contributor can only contribute once on the public sale
1003         require(hasContributed[contributor] == false);
1004         // The contributor address must be whitelisted in order to be able to purchase tokens
1005         require(contributorCanContribute(contributor));
1006         // The weiAmount must be greater or equal than minContribution
1007         require(weiAmount >= minContribution);
1008         // The weiAmount cannot be greater than maxContribution
1009         require(weiAmount <= maxContribution);
1010         // The availableTokensToPurchase must be greater than 0
1011         require(totalTokensSold < TOKEN_SALE_SUPPLY);
1012         uint256 availableTokensToPurchase = TOKEN_SALE_SUPPLY.sub(totalTokensSold);
1013 
1014         // We need to convert the tokensPerEther to luckys (10**8)
1015         uint256 luckyPerEther = tokensPerEther.mul(J8T_DECIMALS_FACTOR);
1016 
1017         // In order to calculate the tokens amount to be allocated to the contrbutor
1018         // we need to multiply the amount of wei sent by luckyPerEther and divide the
1019         // result for the ether decimal factor (10**18)
1020         uint256 tokensAmount = weiAmount.mul(luckyPerEther).div(ETH_DECIMALS_FACTOR);
1021         
1022 
1023         uint256 refund = 0;
1024         uint256 tokensToPurchase = tokensAmount;
1025         
1026         // If the token purchase amount is bigger than the remaining token allocation
1027         // we can only sell the remainging tokens and refund the unused amount of eth
1028         if (availableTokensToPurchase < tokensAmount) {
1029             tokensToPurchase = availableTokensToPurchase;
1030             weiAmount = tokensToPurchase.mul(ETH_DECIMALS_FACTOR).div(luckyPerEther);
1031             refund = msg.value.sub(weiAmount);
1032         }
1033 
1034         // We update the token sale contract data
1035         totalTokensSold = totalTokensSold.add(tokensToPurchase);
1036         uint256 weiToPurchase = tokensToPurchase.div(tokensPerEther);
1037         weiRaised = weiRaised.add(weiToPurchase);
1038 
1039         // Transfers the tokens form the Crowdsale contract to contriutors wallet
1040         require(tokenContract.transfer(contributor, tokensToPurchase));
1041 
1042         // Issue a refund for any unused ether 
1043         if (refund > 0) {
1044             contributor.transfer(refund);
1045         }
1046 
1047         // Transfer ether contribution to the wallet
1048         wallet.transfer(weiAmount);
1049 
1050         // Update hasContributed mapping
1051         hasContributed[contributor] = true;
1052 
1053         TokensPurchased(contributor, tokensToPurchase);
1054 
1055         // If we reach the total amount of tokens to sell we finilize the token sale
1056         if (totalTokensSold == TOKEN_SALE_SUPPLY) {
1057             finalization();
1058         }
1059 
1060         return true;
1061     }
1062 
1063     // Updates the whitelist
1064     function updateWhitelist(address _account, WhitelistPermission _permission) external onlyAdminAndOps returns (bool) {
1065         require(_account != address(0));
1066         require(_permission == WhitelistPermission.PreSaleContributor || _permission == WhitelistPermission.PublicSaleContributor || _permission == WhitelistPermission.CannotContribute);
1067         require(!saleHasFinished());
1068 
1069         whitelist[_account] = _permission;
1070 
1071         address _who = msg.sender;
1072         WhiteListUpdated(_who, _account, _permission);
1073 
1074         return true;
1075     }
1076 
1077     function updateWhitelist_batch(address[] _accounts, WhitelistPermission _permission) external onlyAdminAndOps returns (bool) {
1078         require(_permission == WhitelistPermission.PreSaleContributor || _permission == WhitelistPermission.PublicSaleContributor || _permission == WhitelistPermission.CannotContribute);
1079         require(!saleHasFinished());
1080 
1081         for(uint i = 0; i < _accounts.length; ++i) {
1082             require(_accounts[i] != address(0));
1083             whitelist[_accounts[i]] = _permission;
1084             WhiteListUpdated(msg.sender, _accounts[i], _permission);
1085         }
1086 
1087         return true;
1088     }
1089 
1090     // Checks that the status of an address account
1091     // Contributors of the token sale are segmented as:
1092     //  PreSaleContributor: Can contribute on both pre-sale and pubic sale phases
1093     //  PublicSaleContributor: Can contribute on he public sale phase
1094     //  CannotContribute: Cannot contribute in any phase
1095     function contributorCanContribute(address _contributorAddress) private view returns (bool) {
1096         WhitelistPermission _contributorPhase = whitelist[_contributorAddress];
1097 
1098         if (_contributorPhase == WhitelistPermission.CannotContribute) {
1099             return false;
1100         }
1101 
1102         if (_contributorPhase == WhitelistPermission.PreSaleContributor || 
1103             _contributorPhase == WhitelistPermission.PublicSaleContributor) {
1104             return true;
1105         }
1106 
1107         return false;
1108     }
1109 
1110     // Returns the current time
1111     function currentTime() public view returns (uint256) {
1112         return now;
1113     }
1114 
1115     // Checks if the sale has finished
1116     function saleHasFinished() public view returns (bool) {
1117         if (isFinalized) {
1118             return true;
1119         }
1120 
1121         if (endTimestamp < currentTime()) {
1122             return true;
1123         }
1124 
1125         if (totalTokensSold == TOKEN_SALE_SUPPLY) {
1126             return true;
1127         }
1128 
1129         return false;
1130     }
1131 
1132     modifier onlyBeforeSale() {
1133         require(currentTime() < startTimestamp);
1134         _;
1135     }
1136 
1137     modifier onlyDuringSale() {
1138         uint256 _currentTime = currentTime();
1139         require(startTimestamp < _currentTime);
1140         require(_currentTime < endTimestamp);
1141         _;
1142     }
1143 
1144     modifier onlyPostSale() {
1145         require(endTimestamp < currentTime());
1146         _;
1147     }
1148 
1149     ///////////////////////
1150     // PRIVATE FUNCTIONS //
1151     ///////////////////////
1152 
1153     // This method is for to be called only for the owner. This way we protect for anyone who wanna finalize the ICO.
1154     function finalize() external onlyAdmin returns (bool) {
1155         return finalization();
1156     }
1157 
1158     // Only used by finalize and setFinalized.
1159     // Overloaded logic for two uses.
1160     // NOTE: In case finalize is called by an user and not from addPresale()/purchaseToken()
1161     // will diff total supply with sold supply to burn token.
1162     function finalization() private returns (bool) {
1163         require(!isFinalized);
1164 
1165         isFinalized = true;
1166 
1167         
1168         if (totalTokensSold < TOKEN_SALE_SUPPLY) {
1169             uint256 toBurn = TOKEN_SALE_SUPPLY.sub(totalTokensSold);
1170             tokenContract.burn(toBurn);
1171             Burned(msg.sender, toBurn, currentTime());
1172         }
1173 
1174         Finalized(msg.sender, currentTime());
1175 
1176         return true;
1177     }
1178 
1179     function saleSupply() public view returns (uint256) {
1180         return tokenContract.balanceOf(address(this));
1181     }
1182 }