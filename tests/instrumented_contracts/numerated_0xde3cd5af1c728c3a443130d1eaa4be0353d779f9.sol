1 pragma solidity 0.5.0;
2 
3 //
4 // base contract for all our horizon contracts and tokens
5 //
6 contract HorizonContractBase {
7     // The owner of the contract, set at contract creation to the creator.
8     address public owner;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     // Contract authorization - only allow the owner to perform certain actions.
15     modifier onlyOwner {
16         require(msg.sender == owner, "Only the owner can call this function.");
17         _;
18     }
19 }
20 
21 // ----------------------------------------------------------------------------
22 // ERC Token Standard #20 Interface
23 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
24 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
25 // 
26 // ----------------------------------------------------------------------------
27 interface ERC20Interface {
28     function totalSupply() external view returns (uint256);
29     function balanceOf(address who) external view returns (uint256);
30     function allowance(address approver, address spender) external view returns (uint256);
31     function transfer(address to, uint256 value) external returns (bool);
32     function approve(address spender, uint256 value) external returns (bool);
33     function transferFrom(address from, address to, uint256 value) external returns (bool);
34 
35     // solhint-disable-next-line no-simple-event-func-name
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed approver, address indexed spender, uint256 value);
38 }
39 
40 /**
41  * ICOToken for the timelessluxurygroup.com by Horizon-Globex.com of Switzerland.
42  *
43  * An ERC20 standard
44  *
45  * Author: Horizon Globex GmbH Development Team
46  *
47  * Dev Notes
48  *   NOTE: There is no fallback function as this contract will never contain Ether, only the ICO tokens.
49  *   NOTE: There is no approveAndCall/receiveApproval or ERC223 functionality.
50  *   NOTE: Coins will never be minted beyond those at contract creation.
51  *   NOTE: Zero transfers are allowed - we don't want to break a valid transaction chain.
52  *   NOTE: There is no selfDestruct, changeOwner or migration path - this is the only contract.
53  */
54 
55 
56 contract ICOToken is ERC20Interface, HorizonContractBase {
57     using SafeMath for uint256;
58 
59     // Contract authorization - only allow the official KYC provider to perform certain actions.
60     modifier onlyKycProvider {
61         require(msg.sender == regulatorApprovedKycProvider, "Only the KYC Provider can call this function.");
62         _;
63     }
64 	
65 	// Contract authorization - only allow the official issuer to perform certain actions.
66     modifier onlyIssuer {
67         require(msg.sender == issuer, "Only the Issuer can call this function.");
68         _;
69     }
70 
71     // The approved KYC provider that verifies all ICO/TGE Contributors.
72     address public regulatorApprovedKycProvider;
73     
74     // The issuer
75     address public issuer;
76 
77     // Public identity variables of the token used by ERC20 platforms.
78     string public name;
79     string public symbol;
80     
81     // There is no good reason to deviate from 18 decimals, see https://github.com/ethereum/EIPs/issues/724.
82     uint8 public decimals = 18;
83     
84     // The total supply of tokens, set at creation, decreased with burn.
85     uint256 public totalSupply_;
86 
87     // The supply of tokens, set at creation, to be allocated for the referral bonuses.
88     uint256 public rewardPool_;
89 
90     // The Initial Coin Offering is finished.
91     bool public isIcoComplete;
92 
93     // The balances of all accounts.
94     mapping (address => uint256) public balances;
95 
96     // KYC submission hashes accepted by KYC service provider for AML/KYC review.
97     bytes32[] public kycHashes;
98 
99     // All users that have passed the external KYC verification checks.
100     address[] public kycValidated;
101 
102     // Addresses authorized to transfer tokens on an account's behalf.
103     mapping (address => mapping (address => uint256)) internal allowanceCollection;
104 
105     // Lookup an ICO/TGE Contributor address to see if it was referred by another address (referee => referrer).
106     mapping (address => address) public referredBy;
107 
108     // Emitted when the Initial Coin Offering phase ends, see closeIco().
109     event IcoComplete();
110 
111     // Notification when tokens are burned by the owner.
112     event Burn(address indexed from, uint256 value);
113     
114     // Emitted when mint event ocurred
115     // added by andrewju
116     event Mint(address indexed from, uint256 value);
117 
118     // Someone who was referred has purchased tokens, when the bonus is awarded log the details.
119     event ReferralRedeemed(address indexed referrer, address indexed referee, uint256 value);
120 
121     /**
122      * Initialise contract with the 50 million initial supply tokens, allocated to
123      * the creator of the contract (the owner).
124      */
125     constructor(uint256 totalSupply, string memory _name, string memory _symbol, uint256 _rewardPool) public {
126 		name = _name;
127 		symbol = _symbol;
128         totalSupply_ = totalSupply * 10 ** uint256(decimals);   // Set the total supply of ICO Tokens.
129         balances[msg.sender] = totalSupply_;
130         rewardPool_ = _rewardPool * 10 ** uint256(decimals);   // Set the total supply of ICO Reward Tokens.
131         
132         setKycProvider(msg.sender);
133         setIssuer(msg.sender);
134         
135     }
136 
137     /**
138      * The total number of tokens that exist.
139      */
140     function totalSupply() public view returns (uint256) {
141         return totalSupply_;
142     }
143 
144     /**
145      * The total number of reward pool tokens that remains.
146      */
147     function rewardPool() public onlyOwner view returns (uint256) {
148         return rewardPool_;
149     }
150 
151     /**
152      * Get the number of tokens for a specific account.
153      *
154      * @param who    The address to get the token balance of.
155      */
156     function balanceOf(address who) public view returns (uint256 balance) {
157         return balances[who];
158     }
159 
160     /**
161      * Get the current allowanceCollection that the approver has allowed 'spender' to spend on their behalf.
162      *
163      * See also: approve() and transferFrom().
164      *
165      * @param _approver  The account that owns the tokens.
166      * @param _spender   The account that can spend the approver's tokens.
167      */
168     function allowance(address _approver, address _spender) public view returns (uint256) {
169         return allowanceCollection[_approver][_spender];
170     }
171 
172     /**
173      * Add the link between the referrer and who they referred.
174      *
175      * ---- ICO-Platform Note ----
176      * The horizon-globex.com ICO platform offers functionality for referrers to sign-up
177      * to refer Contributors. Upon such referred Contributions, Company shall automatically
178      * award 1% of our "owner" ICO tokens to the referrer as coded by this Smart Contract.
179      *
180      * All referrers must successfully complete our ICO KYC review prior to being allowed on-board.
181      * -- End ICO-Platform Note --
182      *
183      * @param referrer  The person doing the referring.
184      * @param referee   The person that was referred.
185      */
186     function refer(address referrer, address referee) public onlyOwner {
187         require(referrer != address(0x0), "Referrer cannot be null");
188         require(referee != address(0x0), "Referee cannot be null");
189         require(!isIcoComplete, "Cannot add new referrals after ICO is complete.");
190 
191         referredBy[referee] = referrer;
192     }
193 
194     /**
195      * Transfer tokens from the caller's account to the recipient.
196      *
197      * @param to    The address of the recipient.
198      * @param value The number of tokens to send.
199      */
200     // solhint-disable-next-line no-simple-event-func-name
201     function transfer(address to, uint256 value) public returns (bool) {
202         return _transfer(msg.sender, to, value);
203     }
204 	
205     /**
206      * Transfer pre-approved tokens on behalf of an account.
207      *
208      * See also: approve() and allowance().
209      *
210      * @param from  The address of the sender
211      * @param to    The address of the recipient
212      * @param value The number of tokens to send
213      */
214     function transferFrom(address from, address to, uint256 value) public returns (bool) {
215         require(value <= allowanceCollection[from][msg.sender], "Amount to transfer is greater than allowance.");
216 		
217         allowanceCollection[from][msg.sender] = allowanceCollection[from][msg.sender].sub(value);
218         _transfer(from, to, value);
219         return true;
220     }
221 
222     /**
223      * Allow another address to spend tokens on your behalf.
224      *
225      * transferFrom can be called multiple times until the approved balance goes to zero.
226      * Subsequent calls to this function overwrite the previous balance.
227      * To change from a non-zero value to another non-zero value you must first set the
228      * allowance to zero - it is best to use safeApprove when doing this as you will
229      * manually have to check for transfers to ensure none happened before the zero allowance
230      * was set.
231      *
232      * @param _spender   The address authorized to spend your tokens.
233      * @param _value     The maximum amount of tokens they can spend.
234      */
235     function approve(address _spender, uint256 _value) public returns (bool) {
236         if(allowanceCollection[msg.sender][_spender] > 0 && _value != 0) {
237             revert("You cannot set a non-zero allowance to another non-zero, you must zero it first.");
238         }
239 
240         allowanceCollection[msg.sender][_spender] = _value;
241         emit Approval(msg.sender, _spender, _value);
242 
243         return true;
244     }
245 
246     /**
247      * Allow another address to spend tokens on your behalf while mitigating a double spend.
248      *
249      * Subsequent calls to this function overwrite the previous balance.
250      * The old value must match the current allowance otherwise this call reverts.
251      *
252      * @param spender   The address authorized to spend your tokens.
253      * @param value     The maximum amount of tokens they can spend.
254      * @param oldValue  The current allowance for this spender.
255      */
256     function safeApprove(address spender, uint256 value, uint256 oldValue) public returns (bool) {
257         require(spender != address(0x0), "Cannot approve null address.");
258         require(oldValue == allowanceCollection[msg.sender][spender], "The expected old value did not match current allowance.");
259 
260         allowanceCollection[msg.sender][spender] = value;
261         emit Approval(msg.sender, spender, value);
262 
263         return true;
264     }
265 
266     /**
267      * The hash for all Know Your Customer information is calculated outside but stored here.
268      * This storage will be cleared once the ICO completes, see closeIco().
269      *
270      * ---- ICO-Platform Note ----
271      * The horizon-globex.com ICO platform's KYC app will register a hash of the Contributors
272      * KYC submission on the blockchain. Our Swiss financial-intermediary KYC provider will be 
273      * notified of the submission and retrieve the Contributor data for formal review.
274      *
275      * All Contributors must successfully complete our ICO KYC review prior to being allowed on-board.
276      * -- End ICO-Platform Note --
277      *
278      * @param sha   The hash of the customer data.
279     */
280     function setKycHash(bytes32 sha) public onlyOwner {
281         require(!isIcoComplete, "The ICO phase has ended, you can no longer set KYC hashes.");
282 
283         kycHashes.push(sha);
284     }
285 
286     /**
287      * A user has passed KYC verification, store them on the blockchain in the order it happened.
288      * This will be cleared once the ICO completes, see closeIco().
289      *
290      * ---- ICO-Platform Note ----
291      * The horizon-globex.com ICO platform's registered KYC provider submits their approval
292      * for this Contributor to particpate using the ICO-Platform portal. 
293      *
294      * Each Contributor will then be sent the Ethereum, Bitcoin and IBAN account numbers to
295      * deposit their Approved Contribution in exchange for ICO Tokens.
296      * -- End ICO-Platform Note --
297      *
298      * @param who   The user's address.
299      */
300     function kycApproved(address who) public onlyKycProvider {
301         require(!isIcoComplete, "The ICO phase has ended, you can no longer approve.");
302         require(who != address(0x0), "Cannot approve a null address.");
303 
304         kycValidated.push(who);
305     }
306 
307     /**
308      * Set the address that has the authority to approve users by KYC.
309      *
310      * ---- ICO-Platform Note ----
311      * The horizon-globex.com ICO platform shall register a fully licensed Swiss KYC
312      * provider to assess each potential Contributor for KYC and AML under Swiss law. 
313      *
314      * -- End ICO-Platform Note --
315      *
316      * @param who   The address of the KYC provider.
317      */
318     function setKycProvider(address who) public onlyOwner {
319         regulatorApprovedKycProvider = who;
320     }
321     
322         /**
323      * Set the issuer address
324      *
325      * @param who   The address of the issuer.
326      */
327     function setIssuer(address who) public onlyOwner {
328         issuer = who;
329     }
330     
331     
332     /**
333      * Retrieve the KYC hash from the specified index.
334      *
335      * @param   index   The index into the array.
336      */
337     function getKycHash(uint256 index) public view returns (bytes32) {
338         return kycHashes[index];
339     }
340 
341     /**
342      * Retrieve the validated KYC address from the specified index.
343      *
344      * @param   index   The index into the array.
345      */
346     function getKycApproved(uint256 index) public view returns (address) {
347         return kycValidated[index];
348     }
349 
350     /**
351      * When someone referred (the referee) purchases tokens the referrer gets a 1% bonus from the central pool.
352      *
353      * ---- ICO-Platform Note ----
354      * The horizon-globex.com ICO platform's portal shall award referrers as part of the ICO
355      * ICO Token issuance procedure as overseen by the Swiss KYC provider. 
356      *
357      * -- End ICO-Platform Note --
358      *
359      * @param referee   The referred account who just purchased some tokens.
360      * @param referrer  The account that referred the one purchasing tokens.
361      * @param value     The number of tokens purchased by the referee.
362     */
363     function awardReferralBonus(address referee, address referrer, uint256 value) private {
364         uint256 bonus = value / 100;
365         balances[owner] = balances[owner].sub(bonus);
366         balances[referrer] = balances[referrer].add(bonus);
367         rewardPool_ -= bonus;
368         emit ReferralRedeemed(referee, referrer, bonus);
369     }
370 
371     /**
372      * During the ICO phase the owner will allocate tokens once KYC completes and funds are deposited.
373      *
374      * ---- ICO-Platform Note ----
375      * The horizon-globex.com ICO platform's portal shall issue ICO Token to Contributors on receipt of 
376      * the Approved Contribution funds at the KYC providers Escrow account/wallets.
377      * Only after ICO Tokens are issued to the Contributor can the Swiss KYC provider allow the transfer
378      * of funds from their Escrow to Company.
379      *
380      * -- End ICO-Platform Note --
381      *
382      * @param to       The recipient of the tokens.
383      * @param value    The number of tokens to send.
384      */
385     function icoTransfer(address to, uint256 value) public onlyOwner {
386         require(!isIcoComplete, "ICO is complete, use transfer().");
387 
388         // If an attempt is made to transfer more tokens than owned, transfer the remainder.
389         uint256 toTransfer = (value > (balances[msg.sender] - rewardPool_ )) ? (balances[msg.sender] - rewardPool_) : value;
390         
391         _transfer(msg.sender, to, toTransfer);
392 
393         // Handle a referred account receiving tokens.
394         address referrer = referredBy[to];
395         if(referrer != address(0x0)) {
396             referredBy[to] = address(0x0);
397             awardReferralBonus(to, referrer, toTransfer);
398         }
399     }
400 
401     /**
402      * End the ICO phase in accordance with KYC procedures and clean up.
403      *
404      * ---- ICO-Platform Note ----
405      * The horizon-globex.com ICO platform's portal shall halt the ICO at the end of the 
406      * Contribution Period, as defined in the ICO Terms and Conditions at timelessluxurygroup.com.
407      *
408      * -- End ICO-Platform Note --
409      */
410     function closeIco() public onlyOwner {
411         require(!isIcoComplete, "The ICO phase has already ended, you cannot close it again.");
412         require((balances[owner] - rewardPool_) == 0, "Cannot close ICO when a balance remains in the owner account.");
413 
414         isIcoComplete = true;
415         delete kycHashes;
416         delete kycValidated;
417 
418         emit IcoComplete();
419     }
420 	
421     /**
422      * Internal transfer, can only be called by this contract
423      *
424      * @param from     The sender of the tokens.
425      * @param to       The recipient of the tokens.
426      * @param value    The number of tokens to send.
427      */
428     function _transfer(address from, address to, uint256 value) internal returns (bool) {
429         require(from != address(0x0), "Cannot send tokens from null address");
430         require(to != address(0x0), "Cannot transfer tokens to null");
431         require(balances[from] >= value, "Insufficient funds");
432 
433         // Quick exit for zero, but allow it in case this transfer is part of a chain.
434         if(value == 0)
435             return true;
436 		
437         // Perform the transfer.
438         balances[from] = balances[from].sub(value);
439         balances[to] = balances[to].add(value);
440 		
441         // Any tokens sent to to owner are implicitly burned.
442         if (to == owner) {
443             _burn(to, value);
444         }
445 
446         return true;
447     }
448     
449     /**
450      * Permanently mint tokens to increase the totalSupply_.
451      *
452      * @param value            The number of tokens to mint.
453      */
454     function mint(uint256 value) public onlyIssuer {
455         require(value > 0, "Tokens to mint must be greater than zero");
456         balances[owner] = balances[owner].add(value);
457         totalSupply_ = totalSupply_.add(value);
458         
459         emit Mint(msg.sender, value);
460         
461     }
462     
463     /**
464      * Permanently destroy tokens from totalSupply_.
465      *
466      * @param value            The number of tokens to burn.
467      */
468     function burn(uint256 value) public onlyIssuer {
469         _burn(owner, value);
470     }
471 
472     /**
473      * Permanently destroy tokens belonging to a user.
474      *
475      * @param addressToBurn    The owner of the tokens to burn.
476      * @param value            The number of tokens to burn.
477      */
478     function _burn(address addressToBurn, uint256 value) private returns (bool success) {
479         require(value > 0, "Tokens to burn must be greater than zero");
480         require(balances[addressToBurn] >= value, "Tokens to burn exceeds balance");
481 
482         balances[addressToBurn] = balances[addressToBurn].sub(value);
483         totalSupply_ = totalSupply_.sub(value);
484 
485         emit Burn(msg.sender, value);
486 
487         return true;
488     }
489 }
490 
491 /**
492  * @title SafeMath
493  * @dev Math operations with safety checks that throw on error
494  *
495  * Source: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
496  */
497 library SafeMath {
498     /**
499      * @dev Multiplies two numbers, throws on overflow.
500      */
501     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
502         if (a == 0) {
503             return 0;
504         }
505         uint256 c = a * b;
506         assert(c / a == b);
507         return c;
508     }
509 
510     /**
511     * @dev Integer division of two numbers, truncating the quotient.
512     */
513     function div(uint256 a, uint256 b) internal pure returns (uint256) {
514         // assert(b > 0); // Solidity automatically throws when dividing by 0
515         // uint256 c = a / b;
516         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
517         return a / b;
518     }
519 
520     /**
521     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
522     */
523     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
524         assert(b <= a);
525         return a - b;
526     }
527 
528     /**
529     * @dev Adds two numbers, throws on overflow.
530     */
531     function add(uint256 a, uint256 b) internal pure returns (uint256) {
532         uint256 c = a + b;
533         assert(c >= a);
534         return c;
535     }
536 }
537 
538 // ----------------------------------------------------------------------------
539 // TradeToken Standard #20 Interface
540 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
541 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
542 // 
543 // ----------------------------------------------------------------------------
544 interface TokenInterface {
545     function hold(address who, uint256 quantity) external returns(bool);
546 }
547 
548 /**
549  * A version of the Regulation D contract (https://www.investopedia.com/terms/r/regulationd.asp) with the
550  * added role of Transfer Agent to perform specialised actions.
551  *
552  * Part of the timelessluxurygroup.com ICO by Horizon-Globex.com of Switzerland.
553  *
554  * Author: Horizon Globex GmbH Development Team
555  */
556 contract RegD is HorizonContractBase {
557     using SafeMath for uint256;
558 
559     /**
560      * The details of the tokens bought.
561      */
562     struct Holding {
563         // The number of tokens purchased.
564         uint256 quantity;
565 
566         // The date and time when the tokens are no longer restricted.
567         uint256 releaseDate;
568 
569         // Whether the holder is an affiliate of the company or not.
570         bool isAffiliate;
571     }
572 
573     // Restrict functionality to the creator (owner) of the contract - the token issuer.
574     modifier onlyIssuer {
575         require(msg.sender == owner, "You must be issuer/owner to execute this function.");
576         _;
577     }
578 
579     // Restrict functionaly to the official Transfer Agent.
580     modifier onlyTransferAgent {
581         require(msg.sender == transferAgent, "You must be the Transfer Agent to execute this function.");
582         _;
583     }
584 
585     // The collection of all held tokens by user.
586     mapping(address => Holding) public heldTokens;
587 
588     // The ICO contract, where all tokens this contract holds originate from.
589     address public icoContract;
590 
591     // The ERC20 Token contract where tokens past their holding period are released to.
592     address public tokenContract;
593 
594     // The authorised Transfer Agent who performs specialist actions on this contract.
595     address public transferAgent;
596 
597     // Number of seconds a holding is held for before it can be released.
598     uint256 public expiry = 0;
599 
600     // Emitted when someone subject to Regulation D buys tokens and they are held here.
601     event TokensHeld(address indexed who, uint256 tokens, uint256 releaseDate);
602 
603     // Emitted when the tokens have passed their release date and have been returned to the original owner.
604     event TokensReleased(address indexed who, uint256 tokens);
605 
606     // The Transfer Agent moved tokens from an address to a new wallet, for escheatment obligations.
607     event TokensTransferred(address indexed from, address indexed to, uint256 tokens);
608 
609     // The Transfer Agent was unable to verify a token holder and needed to push out the release date.
610     event ReleaseDateChanged(address who, uint256 oldReleaseDate, uint256 newReleaseDate);
611 
612     // Extra restrictions apply to company affiliates, notify when the status of an address changes.
613     event AffiliateStatusChanged(address who, bool isAffiliate);
614 
615     /**
616      * @notice Create this contract and assign the ICO contract where the tokens originate from.
617      *
618      * @param icoContract_      The address of the ICO contract.
619      * @param expiry_           The number of seconds after holding before the tokens can be released.
620      */
621     constructor(address icoContract_, uint256 expiry_) public {
622         icoContract = icoContract_;
623         expiry = expiry_;
624     }
625 
626     /**
627      * @notice Set the address of the contract where tokens are released to after the holding period.
628      *
629      * @param tokenContract_    The contract address.
630      */
631     function setTokenContract(address tokenContract_) public onlyIssuer {
632         tokenContract = tokenContract_;
633     }
634 
635     /**
636      * @notice Set the address of the Transfer Agent.
637      *
638      * @param who   The wallet id of the Transfer Agent.
639      */
640     function setTransferAgent(address who) public onlyIssuer {
641         transferAgent = who;
642     }
643 
644     /**
645      * @notice Change the expiry for subsequent holdings, existing holdings are not affected.
646      *
647      * @param expiry_   The number of seconds after holding before the tokens can be released.
648      */
649     function setExpiry(uint256 expiry_) public onlyIssuer {
650         expiry = expiry_;
651     }
652 
653     /**
654      * @notice Keep a US Citizen's tokens for one year.
655      *
656      * @param who           The wallet of the US Citizen.
657      * @param quantity      The number of tokens to store.
658      */
659     function hold(address who, uint256 quantity) public onlyIssuer {
660         require(who != address(0x0), "The null address cannot own tokens.");
661         require(quantity != 0, "Quantity must be greater than zero.");
662         require(!isExistingHolding(who), "Cannot overwrite an existing holding, use a new wallet.");
663 
664         // Create the holding for the customer who will get these tokens once custody ends.
665         Holding memory holding = Holding(quantity, block.timestamp+expiry, false);
666         heldTokens[who] = holding;
667         emit TokensHeld(who, holding.quantity, holding.releaseDate);
668     }
669 	
670     /**
671      * @notice Hold tokens post-ICO with a variable release date on those tokens.
672      *
673      * @param who           The wallet of the US Citizen.
674      * @param quantity      The number of tokens to store.
675 	 * @param addedTime		The number of seconds to add to the current date to calculate the release date.
676      */
677     function postIcoHold(address who, uint256 quantity, uint256 addedTime) public onlyTransferAgent {
678         require(who != address(0x0), "The null address cannot own tokens.");
679         require(quantity != 0, "Quantity must be greater than zero.");
680         require(!isExistingHolding(who), "Cannot overwrite an existing holding, use a new wallet.");
681 
682         bool res = ERC20Interface(icoContract).transferFrom(who, address(this), quantity);
683         require(res, "Unable to complete Post-ICO Custody, token contract transfer failed.");
684         if(res) {
685             Holding memory holding = Holding(quantity, block.timestamp+addedTime, false);
686             heldTokens[who] = holding;
687             emit TokensHeld(who, holding.quantity, holding.releaseDate);
688         }
689     }
690 
691     /**
692     * @notice Check if a user's holding are eligible for release.
693     *
694     * @param who        The user to check the holding of.
695     * @return           True if can be released, false if not.
696     */
697     function canRelease(address who) public view returns (bool) {
698         Holding memory holding = heldTokens[who];
699         if(holding.releaseDate == 0 || holding.quantity == 0)
700             return false;
701 
702         return block.timestamp > holding.releaseDate;
703     }
704 
705     /**
706      * @notice Release the tokens once the holding period expires, transferring them back to the ERC20 contract to the holder.
707      *
708      * NOTE: This function preserves the isAffiliate flag of the holder.
709      *
710      * @param who       The owner of the tokens.
711      * @return          True on successful release, false on error.
712      */
713     function release(address who) public onlyTransferAgent returns (bool) {
714         require(tokenContract != address(0x0), "ERC20 Token contract is null, nowhere to release to.");
715         Holding memory holding = heldTokens[who];
716         require(!holding.isAffiliate, "To release tokens for an affiliate use partialRelease().");
717 
718         if(block.timestamp > holding.releaseDate) {
719             // Transfer the tokens from this contract's ownership to the original owner.
720             bool res = TokenInterface(tokenContract).hold(who, holding.quantity);
721             if(res) {
722                 heldTokens[who] = Holding(0, 0, holding.isAffiliate);
723                 emit TokensReleased(who, holding.quantity);
724                 return true;
725             }
726         }
727 
728         return false;
729     }
730 	
731     /**
732      * @notice Release some of an affiliate's tokens to a broker/trading wallet.
733      *
734      * @param who       		The owner of the tokens.
735 	 * @param tradingWallet		The broker/trader receiving the tokens.
736 	 * @param amount 			The number of tokens to release to the trading wallet.
737      */
738     function partialRelease(address who, address tradingWallet, uint256 amount) public onlyTransferAgent returns (bool) {
739         require(tokenContract != address(0x0), "ERC20 Token contract is null, nowhere to release to.");
740         require(tradingWallet != address(0x0), "The destination wallet cannot be null.");
741         require(!isExistingHolding(tradingWallet), "The destination wallet must be a new fresh wallet.");
742         Holding memory holding = heldTokens[who];
743         require(holding.isAffiliate, "Only affiliates can use this function; use release() for non-affiliates.");
744         require(amount <= holding.quantity, "The holding has less than the specified amount of tokens.");
745 
746         if(block.timestamp > holding.releaseDate) {
747 
748             // Send the tokens currently held by this contract on behalf of 'who' to the nominated wallet.
749             bool res = TokenInterface(tokenContract).hold(tradingWallet, amount);
750             if(res) {
751                 heldTokens[who] = Holding(holding.quantity.sub(amount), holding.releaseDate, holding.isAffiliate);
752                 emit TokensReleased(who, amount);
753                 return true;
754             }
755         }
756 
757         return false;
758     }
759 
760     /**
761      * @notice Under special circumstances the Transfer Agent needs to move tokens around.
762      *
763      * @dev As the release date is accurate to one second it is very unlikely release dates will
764      * match so an address that does not have a holding in this contract is required as the target.
765      *
766      * @param from      The current holder of the tokens.
767      * @param to        The recipient of the tokens - must be a 'clean' address.
768      * @param amount    The number of tokens to move.
769      */
770     function transfer(address from, address to, uint256 amount) public onlyTransferAgent returns (bool) {
771         require(to != address(0x0), "Cannot transfer tokens to the null address.");
772         require(amount > 0, "Cannot transfer zero tokens.");
773         Holding memory fromHolding = heldTokens[from];
774         require(fromHolding.quantity >= amount, "Not enough tokens to perform the transfer.");
775         require(!isExistingHolding(to), "Cannot overwrite an existing holding, use a new wallet.");
776 
777         heldTokens[from] = Holding(fromHolding.quantity.sub(amount), fromHolding.releaseDate, fromHolding.isAffiliate);
778         heldTokens[to] = Holding(amount, fromHolding.releaseDate, false);
779 
780         emit TokensTransferred(from, to, amount);
781 
782         return true;
783     }
784 
785     /**
786      * @notice The Transfer Agent may need to add time to the release date if they are unable to verify
787      * the holder in a timely manner.
788      *
789      * @param who       The holder of the tokens.
790      * @param tSeconds    The number of seconds to add to the release date.  NOTE: 'tSeconds' appears to
791      *                  be a reserved word.
792      */
793     function addTime(address who, int tSeconds) public onlyTransferAgent returns (bool) {
794         require(tSeconds != 0, "Time added cannot be zero.");
795         
796         Holding memory holding = heldTokens[who];
797         uint256 oldDate = holding.releaseDate;
798         uint256 newDate = tSeconds < 0 ? holding.releaseDate.sub(uint(-tSeconds)) : holding.releaseDate.add(uint(tSeconds));
799         heldTokens[who] = Holding(holding.quantity, newDate, holding.isAffiliate);
800         
801         emit ReleaseDateChanged(who, oldDate, heldTokens[who].releaseDate);
802         return true;
803     }
804 
805     /**
806      * @notice Company affiliates have added restriction, allow the Transfer Agent set/clear this flag
807      * as needed.
808      *
809      * @param who           The address being affiliated/unaffiliated.
810      * @param isAffiliate   Whether the address is an affiliate or not.
811      */
812     function setAffiliate(address who, bool isAffiliate) public onlyTransferAgent returns (bool) {
813         require(who != address(0x0), "The null address cannot be used.");
814 
815         Holding memory holding = heldTokens[who];
816         require(holding.isAffiliate != isAffiliate, "Attempt to set the same affiliate status that is already set.");
817 
818         heldTokens[who] = Holding(holding.quantity, holding.releaseDate, isAffiliate);
819 
820         emit AffiliateStatusChanged(who, isAffiliate);
821 
822         return true;
823     }
824 
825     /**
826      * @notice Check if a wallet is already in use, only new/fresh/clean wallets can hold tokens.
827      *
828      * @param who   The wallet to check.
829      * @return      True if the wallet is in use, false otherwise.
830      */
831     function isExistingHolding(address who) public view returns (bool) {
832         Holding memory h = heldTokens[who];
833         return (h.quantity != 0 || h.releaseDate != 0);
834     }
835 }