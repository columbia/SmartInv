1 pragma solidity ^0.4.18;
2 
3 /************************************************** */
4 /* WhenHub Token Smart Contract                     */
5 /* Author: Nik Kalyani  nik@whenhub.com             */
6 /* Copyright (c) 2018 CalendarTree, Inc.            */
7 /* https://interface.whenhub.com                    */
8 /************************************************** */
9 contract WHENToken {
10     using SafeMath for uint256;
11 
12     mapping(address => uint256) balances;                               // Token balance for each address
13     mapping (address => mapping (address => uint256)) internal allowed; // Approval granted to transfer tokens by one address to another address
14 
15     /* ERC20 fields */
16     string public name;
17     string public symbol;
18     uint public decimals = 18;
19     string public sign = "￦";
20     string public logoPng = "https://github.com/WhenHub/WHEN/raw/master/assets/when-token-icon.png";
21 
22 
23     /* Each registered user on WhenHub Interface Network has a record in this contract */
24     struct User {
25         bool isRegistered;                                              // Flag to indicate user was registered 
26         uint256 seedJiffys;                                             // Tracks free tokens granted to user       
27         uint256 interfaceEscrowJiffys;                                  // Tracks escrow tokens used in Interfaces      
28         address referrer;                                               // Tracks who referred this user
29     }
30  
31     // IcoBurnAuthorized is used to determine when remaining ICO tokens should be burned
32     struct IcoBurnAuthorized {
33         bool contractOwner;                                              // Flag to indicate ContractOwner has authorized
34         bool platformManager;                                            // Flag to indicate PlatformManager has authorized
35         bool icoOwner;                                                   // Flag to indicate SupportManager has authorized
36     }
37 
38     // PurchaseCredit is used to track purchases made by USD when user isn't already registered
39     struct PurchaseCredit {
40         uint256 jiffys;                                                  // Number of jiffys purchased
41         uint256 purchaseTimestamp;                                       // Date/time of original purchase
42     }
43 
44     mapping(address => PurchaseCredit) purchaseCredits;                  // Temporary store for USD-purchased tokens
45 
46     uint private constant ONE_WEEK = 604800;
47     uint private constant SECONDS_IN_MONTH = 2629743;
48     uint256 private constant ICO_START_TIMESTAMP = 1521471600; // 3/19/2018 08:00:00 PDT
49 
50     uint private constant BASIS_POINTS_TO_PERCENTAGE = 10000;                         // All fees are expressed in basis points. This makes conversion easier
51 
52     /* Token allocations per published WhenHub token economics */
53     uint private constant ICO_TOKENS = 350000000;                              // Tokens available for public purchase
54     uint private constant PLATFORM_TOKENS = 227500000;                         // Tokens available for network seeding
55     uint private constant COMPANY_TOKENS = 262500000;                          // Tokens available to WhenHub for employees and future expansion
56     uint private constant PARTNER_TOKENS = 17500000;                           // Tokens available for WhenHub partner inventives
57     uint private constant FOUNDATION_TOKENS = 17500000;                        // Tokens available for WhenHub Foundationn charity
58 
59     /* Network seeding tokens */
60     uint constant INCENTIVE_TOKENS = 150000000;                         // Total pool of seed tokens for incentives
61     uint constant REFERRAL_TOKENS = 77500000;                           // Total pool of seed tokens for referral
62     uint256 private userSignupJiffys = 0;                                // Number of Jiffys per user who signs up
63     uint256 private referralSignupJiffys = 0;                            // Number of Jiffys per user(x2) referrer + referree
64    
65     uint256 private jiffysMultiplier;                                   // 10 ** decimals
66     uint256 private incentiveJiffysBalance;                             // Available balance of Jiffys for incentives
67     uint256 private referralJiffysBalance;                              // Available balance of Jiffys for referrals
68 
69     /* ICO variables */
70     uint256 private bonus20EndTimestamp = 0;                             // End of 20% ICO token bonus timestamp
71     uint256 private bonus10EndTimestamp = 0;                             // End of 10% ICO token bonus timestamp
72     uint256 private bonus5EndTimestamp = 0;                              // End of 5% ICO token bonus timestamp
73     uint private constant BUYER_REFERRER_BOUNTY = 3;                     // Referral bounty percentage
74 
75     IcoBurnAuthorized icoBurnAuthorized = IcoBurnAuthorized(false, false, false);
76 
77     /* Interface transaction settings */
78     bool private operational = true;                                    // Blocks all state changes throughout the contract if false
79                                                                         // Change using setOperatingStatus()
80 
81     uint256 public winNetworkFeeBasisPoints = 0;                       // Per transaction fee deducted from payment to Expert
82                                                                         // Change using setWinNetworkFeeBasisPoints()
83 
84     uint256 public weiExchangeRate = 500000000000000;                  // Exchange rate for 1 WHEN Token in Wei ($0.25/￦)
85                                                                         // Change using setWeiExchangeRate()
86 
87     uint256 public centsExchangeRate = 25;                             // Exchange rate for 1 WHEN Token in cents
88                                                                         // Change using setCentsExchangeRate()
89 
90     /* State variables */
91     address private contractOwner;                                      // Account used to deploy contract
92     address private platformManager;                                    // Account used by API for Interface app
93     address private icoOwner;                                           // Account from which ICO funds are disbursed
94     address private supportManager;                                     // Account used by support team to reimburse users
95     address private icoWallet;                                          // Account to which ICO ETH is sent
96 
97     mapping(address => User) private users;                             // All registered users   
98     mapping(address => uint256) private vestingEscrows;                 // Unvested tokens held in escrow
99 
100     mapping(address => uint256) private authorizedContracts;            // Contracts authorized to call this one           
101 
102     address[] private registeredUserLookup;                             // Lookup table of registered users     
103 
104     /* ERC-20 Contract Events */
105     event Approval          // Fired when an account authorizes another account to spend tokens on its behalf
106                             (
107                                 address indexed owner, 
108                                 address indexed spender, 
109                                 uint256 value
110                             );
111 
112     event Transfer          // Fired when tokens are transferred from one account to another
113                             (
114                                 address indexed from, 
115                                 address indexed to, 
116                                 uint256 value
117                             );
118 
119 
120     /* Interface app-specific Events */
121     event UserRegister      // Fired when a new user account (wallet) is registered
122                             (
123                                 address indexed user, 
124                                 uint256 value,
125                                 uint256 seedJiffys
126                             );                                 
127 
128     event UserRefer         // Fired when tokens are granted to a user for referring a new user
129                             (
130                                 address indexed user, 
131                                 address indexed referrer, 
132                                 uint256 value
133                             );                             
134 
135     event UserLink          // Fired when a previously existing user is linked to an account in the Interface DB
136                             (
137                                 address indexed user
138                             );
139 
140 
141     /**
142     * @dev Modifier that requires the "operational" boolean variable to be "true"
143     *      This is used on all state changing functions to pause the contract in 
144     *      the event there is an issue that needs to be fixed
145     */
146     modifier requireIsOperational() 
147     {
148         require(operational);
149         _;
150     }
151 
152     /**
153     * @dev Modifier that requires the "ContractOwner" account to be the function caller
154     */
155     modifier requireContractOwner()
156     {
157         require(msg.sender == contractOwner);
158         _;
159     }
160 
161     /**
162     * @dev Modifier that requires the "PlatformManager" account to be the function caller
163     */
164     modifier requirePlatformManager()
165     {
166         require(isPlatformManager(msg.sender));
167         _;
168     }
169 
170 
171     /********************************************************************************************/
172     /*                                       CONSTRUCTOR                                        */
173     /********************************************************************************************/
174 
175     /**
176     * @dev Contract constructor
177     *
178     * @param tokenName ERC-20 token name
179     * @param tokenSymbol ERC-20 token symbol
180     * @param platformAccount Account for making calls from Interface API (i.e. PlatformManager)
181     * @param icoAccount Account that holds ICO tokens (i.e. IcoOwner)
182     * @param supportAccount Account with limited access to manage Interface user support (i.e. SupportManager)
183     *
184     */
185     function WHENToken
186                             ( 
187                                 string tokenName, 
188                                 string tokenSymbol, 
189                                 address platformAccount, 
190                                 address icoAccount,
191                                 address supportAccount
192                             ) 
193                             public 
194     {
195 
196         name = tokenName;
197         symbol = tokenSymbol;
198 
199         jiffysMultiplier = 10 ** uint256(decimals);                             // Multiplier used throughout contract
200         incentiveJiffysBalance = INCENTIVE_TOKENS.mul(jiffysMultiplier);        // Network seeding tokens
201         referralJiffysBalance = REFERRAL_TOKENS.mul(jiffysMultiplier);          // User referral tokens
202 
203 
204         contractOwner = msg.sender;                                     // Owner of the contract
205         platformManager = platformAccount;                              // API account for Interface
206         icoOwner = icoAccount;                                          // Account with ICO tokens for settling Interface transactions
207         icoWallet = icoOwner;                                           // Account to which ICO ETH is sent
208         supportManager = supportAccount;                                // Support account with limited permissions
209 
210                 
211         // Create user records for accounts
212         users[contractOwner] = User(true, 0, 0, address(0));       
213         registeredUserLookup.push(contractOwner);
214 
215         users[platformManager] = User(true, 0, 0, address(0));   
216         registeredUserLookup.push(platformManager);
217 
218         users[icoOwner] = User(true, 0, 0, address(0));   
219         registeredUserLookup.push(icoOwner);
220 
221         users[supportManager] = User(true, 0, 0, address(0));   
222         registeredUserLookup.push(supportManager);
223 
224     }    
225 
226     /**
227     * @dev Contract constructor
228     *
229     * Initialize is to be called immediately after the supporting contracts are deployed.
230     *
231     * @param dataContract Address of the deployed InterfaceData contract
232     * @param appContract Address of the deployed InterfaceApp contract
233     * @param vestingContract Address of the deployed TokenVesting contract
234     *
235     */
236     function initialize
237                             (
238                                 address dataContract,
239                                 address appContract,
240                                 address vestingContract
241                             )
242                             external
243                             requireContractOwner
244     {        
245         require(bonus20EndTimestamp == 0);      // Ensures function cannot be called twice
246         authorizeContract(dataContract);        // Authorizes InterfaceData contract to make calls to this contract
247         authorizeContract(appContract);         // Authorizes InterfaceApp contract to make calls to this contract
248         authorizeContract(vestingContract);     // Authorizes TokenVesting contract to make calls to this contract
249         
250         bonus20EndTimestamp = ICO_START_TIMESTAMP.add(ONE_WEEK);
251         bonus10EndTimestamp = bonus20EndTimestamp.add(ONE_WEEK);
252         bonus5EndTimestamp = bonus10EndTimestamp.add(ONE_WEEK);
253 
254         // ICO tokens are allocated without vesting to ICO account for distribution during sale
255         balances[icoOwner] = ICO_TOKENS.mul(jiffysMultiplier);        
256 
257         // Platform tokens (a.k.a. network seeding tokens) are allocated without vesting
258         balances[platformManager] = balances[platformManager].add(PLATFORM_TOKENS.mul(jiffysMultiplier));        
259 
260         // Allocate all other tokens to contract owner without vesting
261         // These will be disbursed in initialize()
262         balances[contractOwner] = balances[contractOwner].add((COMPANY_TOKENS + PARTNER_TOKENS + FOUNDATION_TOKENS).mul(jiffysMultiplier));
263 
264         userSignupJiffys = jiffysMultiplier.mul(500);       // Initial signup incentive
265         referralSignupJiffys = jiffysMultiplier.mul(100);   // Initial referral incentive
266        
267     }
268 
269     /**
270     * @dev Token allocations for various accounts
271     *
272     * Called from TokenVesting to grant tokens to each account
273     *
274     */
275     function getTokenAllocations()
276                                 external
277                                 view
278                                 returns(uint256, uint256, uint256)
279     {
280         return (COMPANY_TOKENS.mul(jiffysMultiplier), PARTNER_TOKENS.mul(jiffysMultiplier), FOUNDATION_TOKENS.mul(jiffysMultiplier));
281     }
282 
283     /********************************************************************************************/
284     /*                                       ERC20 TOKEN                                        */
285     /********************************************************************************************/
286 
287     /**
288     * @dev Total supply of tokens
289     */
290     function totalSupply() 
291                             external 
292                             view 
293                             returns (uint) 
294     {
295         uint256 total = ICO_TOKENS.add(PLATFORM_TOKENS).add(COMPANY_TOKENS).add(PARTNER_TOKENS).add(FOUNDATION_TOKENS);
296         return total.mul(jiffysMultiplier);
297     }
298 
299     /**
300     * @dev Gets the balance of the calling address.
301     *
302     * @return An uint256 representing the amount owned by the calling address
303     */
304     function balance()
305                             public 
306                             view 
307                             returns (uint256) 
308     {
309         return balanceOf(msg.sender);
310     }
311 
312     /**
313     * @dev Gets the balance of the specified address.
314     *
315     * @param owner The address to query the balance of
316     * @return An uint256 representing the amount owned by the passed address
317     */
318     function balanceOf
319                             (
320                                 address owner
321                             ) 
322                             public 
323                             view 
324                             returns (uint256) 
325     {
326         return balances[owner];
327     }
328 
329     /**
330     * @dev Transfers token for a specified address
331     *
332     * Constraints are added to ensure that tokens granted for network
333     * seeding and tokens in escrow are not transferable
334     *
335     * @param to The address to transfer to.
336     * @param value The amount to be transferred.
337     * @return A bool indicating if the transfer was successful.
338     */
339     function transfer
340                             (
341                                 address to, 
342                                 uint256 value
343                             ) 
344                             public 
345                             requireIsOperational 
346                             returns (bool) 
347     {
348         require(to != address(0));
349         require(to != msg.sender);
350         require(value <= transferableBalanceOf(msg.sender));                                         
351 
352         balances[msg.sender] = balances[msg.sender].sub(value);
353         balances[to] = balances[to].add(value);
354         Transfer(msg.sender, to, value);
355         return true;
356     }
357 
358     /**
359     * @dev Transfers tokens from one address to another
360     *
361     * Constraints are added to ensure that tokens granted for network
362     * seeding and tokens in escrow are not transferable
363     *
364     * @param from address The address which you want to send tokens from
365     * @param to address The address which you want to transfer to
366     * @param value uint256 the amount of tokens to be transferred
367     * @return A bool indicating if the transfer was successful.
368     */
369     function transferFrom
370                             (
371                                 address from, 
372                                 address to, 
373                                 uint256 value
374                             ) 
375                             public 
376                             requireIsOperational 
377                             returns (bool) 
378     {
379         require(from != address(0));
380         require(value <= allowed[from][msg.sender]);
381         require(value <= transferableBalanceOf(from));                                         
382         require(to != address(0));
383         require(from != to);
384 
385         balances[from] = balances[from].sub(value);
386         balances[to] = balances[to].add(value);
387         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
388         Transfer(from, to, value);
389         return true;
390     }
391 
392     /**
393     * @dev Checks the amount of tokens that an owner allowed to a spender.
394     *
395     * @param owner address The address which owns the funds.
396     * @param spender address The address which will spend the funds.
397     * @return A uint256 specifying the amount of tokens still available for the spender.
398     */
399     function allowance
400                             (
401                                 address owner, 
402                                 address spender
403                             ) 
404                             public 
405                             view 
406                             returns (uint256) 
407     {
408         return allowed[owner][spender];
409     }
410 
411     /**
412     * @dev Approves the passed address to spend the specified amount of tokens on behalf of msg.sender.
413     *
414     * Beware that changing an allowance with this method brings the risk that someone may use both the old
415     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
416     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
417     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
418     * @param spender The address which will spend the funds.
419     * @param value The amount of tokens to be spent.
420     * @return A bool indicating success (always returns true)
421     */
422     function approve
423                             (
424                                 address spender, 
425                                 uint256 value
426                             ) 
427                             public 
428                             requireIsOperational 
429                             returns (bool) 
430     {
431         allowed[msg.sender][spender] = value;
432         Approval(msg.sender, spender, value);
433         return true;
434     }
435 
436     /**
437     * @dev Gets the balance of the specified address less greater of escrow tokens and free signup tokens.
438     *
439     * @param account The address to query the the balance of.
440     * @return An uint256 representing the transferable amount owned by the passed address.
441     */
442     function transferableBalanceOf
443                             (
444                                 address account
445                             ) 
446                             public 
447                             view 
448                             returns (uint256) 
449     {
450         require(account != address(0));
451 
452         if (users[account].isRegistered) {
453             uint256 restrictedJiffys = users[account].interfaceEscrowJiffys >= users[account].seedJiffys ? users[account].interfaceEscrowJiffys : users[account].seedJiffys;
454             return balances[account].sub(restrictedJiffys);
455         }
456         return balances[account];
457     }
458 
459    /**
460     * @dev Gets the balance of the specified address less escrow tokens
461     *
462     * Since seed tokens can be used to pay for Interface transactions
463     * this balance indicates what the user can afford to spend for such
464     * "internal" transactions ignoring distinction between paid and signup tokens
465     *
466     * @param account The address to query the balance of.
467     * @return An uint256 representing the spendable amount owned by the passed address.
468     */ 
469     function spendableBalanceOf
470                             (
471                                 address account
472                             ) 
473                             public 
474                             view 
475                             returns(uint256) 
476     {
477 
478         require(account != address(0));
479 
480         if (users[account].isRegistered) {
481             return balances[account].sub(users[account].interfaceEscrowJiffys);
482         }
483         return balances[account];
484     }
485 
486     /********************************************************************************************/
487     /*                                  WHENHUB INTERFACE                                       */
488     /********************************************************************************************/
489 
490 
491    /**
492     * @dev Get operating status of contract
493     *
494     * @return A bool that is the current operating status
495     */      
496     function isOperational() 
497                             public 
498                             view 
499                             returns(bool) 
500     {
501         return operational;
502     }
503 
504    /**
505     * @dev Sets contract operations on/off
506     *
507     * When operational mode is disabled, all write transactions except for this
508     * one will fail
509     * @return A bool that is the new operational mode
510     */    
511     function setOperatingStatus
512                             (
513                                 bool mode
514                             ) 
515                             external
516                             requireContractOwner 
517     {
518         operational = mode;
519     }
520 
521    /**
522     * @dev Authorizes ICO end and burn of remaining tokens
523     *
524     * ContractOwner, PlatformManager and IcoOwner must each call this function
525     * in any order. The third entity calling the function will cause the
526     * icoOwner account balance to be reset to 0.
527     */ 
528     function authorizeIcoBurn() 
529                             external
530     {
531         require(balances[icoOwner] > 0);
532         require((msg.sender == contractOwner) || (msg.sender == platformManager) || (msg.sender == icoOwner));
533 
534         if (msg.sender == contractOwner) {
535             icoBurnAuthorized.contractOwner = true;
536         } else if (msg.sender == platformManager) {
537             icoBurnAuthorized.platformManager = true;
538         } else if (msg.sender == icoOwner) {
539             icoBurnAuthorized.icoOwner = true;
540         }
541 
542         if (icoBurnAuthorized.contractOwner && icoBurnAuthorized.platformManager && icoBurnAuthorized.icoOwner) {
543             balances[icoOwner] = 0;
544         }
545     }
546 
547    /**
548     * @dev Sets fee used in Interface transactions
549     *
550     * A network fee is charged for each transaction represented
551     * as a percentage of the total fee payable to Experts. This fee
552     * is deducted from the amount paid by Callers to Experts.
553     * @param basisPoints The fee percentage expressed as basis points
554     */    
555     function setWinNetworkFee
556                             (
557                                 uint256 basisPoints
558                             ) 
559                             external 
560                             requireIsOperational 
561                             requireContractOwner
562     {
563         require(basisPoints >= 0);
564 
565         winNetworkFeeBasisPoints = basisPoints;
566     }
567 
568     /**
569     * @dev Sets signup tokens allocated for each user (based on availability)
570     *
571     * @param tokens The number of tokens each user gets
572     */    
573     function setUserSignupTokens
574                             (
575                                 uint256 tokens
576                             ) 
577                             external 
578                             requireIsOperational 
579                             requireContractOwner
580     {
581         require(tokens <= 10000);
582 
583         userSignupJiffys = jiffysMultiplier.mul(tokens);
584     }
585 
586     /**
587     * @dev Sets signup tokens allocated for each user (based on availability)
588     *
589     * @param tokens The number of tokens each referrer and referree get
590     */    
591     function setReferralSignupTokens
592                             (
593                                 uint256 tokens
594                             ) 
595                             external 
596                             requireIsOperational 
597                             requireContractOwner
598     {
599         require(tokens <= 10000);
600 
601         referralSignupJiffys = jiffysMultiplier.mul(tokens);
602     }
603 
604     /**
605     * @dev Sets wallet to which ICO ETH funds are sent
606     *
607     * @param account The address to which ETH funds are sent
608     */    
609     function setIcoWallet
610                             (
611                                 address account
612                             ) 
613                             external 
614                             requireIsOperational 
615                             requireContractOwner
616     {
617         require(account != address(0));
618 
619         icoWallet = account;
620     }
621 
622     /**
623     * @dev Authorizes a smart contract to call this contract
624     *
625     * @param account Address of the calling smart contract
626     */
627     function authorizeContract
628                             (
629                                 address account
630                             ) 
631                             public 
632                             requireIsOperational 
633                             requireContractOwner
634     {
635         require(account != address(0));
636 
637         authorizedContracts[account] = 1;
638     }
639 
640     /**
641     * @dev Deauthorizes a previously authorized smart contract from calling this contract
642     *
643     * @param account Address of the calling smart contract
644     */
645     function deauthorizeContract
646                             (
647                                 address account
648                             ) 
649                             external 
650                             requireIsOperational
651                             requireContractOwner 
652     {
653         require(account != address(0));
654 
655         delete authorizedContracts[account];
656     }
657 
658     /**
659     * @dev Checks if a contract is authorized to call this contract
660     *
661     * @param account Address of the calling smart contract
662     */
663     function isContractAuthorized
664                             (
665                                 address account
666                             ) 
667                             public 
668                             view
669                             returns(bool) 
670     {
671         return authorizedContracts[account] == 1;
672     }
673 
674     /**
675     * @dev Sets the Wei to WHEN exchange rate 
676     *
677     * @param rate Number of Wei for one WHEN token
678     */
679     function setWeiExchangeRate
680                             (
681                                 uint256 rate
682                             ) 
683                             external 
684                             requireIsOperational
685                             requireContractOwner
686     {
687         require(rate >= 0); // Cannot set to less than 0.0001 ETH/￦
688 
689         weiExchangeRate = rate;
690     }
691 
692     /**
693     * @dev Sets the U.S. cents to WHEN exchange rate 
694     *
695     * @param rate Number of cents for one WHEN token
696     */
697     function setCentsExchangeRate
698                             (
699                                 uint256 rate
700                             ) 
701                             external 
702                             requireIsOperational
703                             requireContractOwner
704     {
705         require(rate >= 1);
706 
707         centsExchangeRate = rate;
708     }
709 
710     /**
711     * @dev Sets the account that will be used for Platform Manager functions 
712     *
713     * @param account Account to replace existing Platform Manager
714     */
715     function setPlatformManager
716                             (
717                                 address account
718                             ) 
719                             external 
720                             requireIsOperational
721                             requireContractOwner
722     {
723         require(account != address(0));
724         require(account != platformManager);
725 
726         balances[account] = balances[account].add(balances[platformManager]);
727         balances[platformManager] = 0;
728 
729         if (!users[account].isRegistered) {
730             users[account] = User(true, 0, 0, address(0)); 
731             registeredUserLookup.push(account);
732         }
733 
734         platformManager = account; 
735     }
736 
737     /**
738     * @dev Checks if an account is the PlatformManager 
739     *
740     * @param account Account to check
741     */
742     function isPlatformManager
743                             (
744                                 address account
745                             ) 
746                             public
747                             view 
748                             returns(bool) 
749     {
750         return account == platformManager;
751     }
752 
753     /**
754     * @dev Checks if an account is the PlatformManager or SupportManager
755     *
756     * @param account Account to check
757     */
758     function isPlatformOrSupportManager
759                             (
760                                 address account
761                             ) 
762                             public
763                             view 
764                             returns(bool) 
765     {
766         return (account == platformManager) || (account == supportManager);
767     }
768 
769     /**
770     * @dev Gets address of SupportManager
771     *
772     */
773     function getSupportManager()
774                             public
775                             view 
776                             returns(address) 
777     {
778         return supportManager;
779     }
780 
781 
782     /**
783     * @dev Checks if referral tokens are available
784     *
785     * referralSignupTokens is doubled because both referrer
786     * and recipient get referral tokens
787     *
788     * @return A bool indicating if referral tokens are available
789     */    
790     function isReferralSupported() 
791                             public 
792                             view 
793                             returns(bool) 
794     {
795         uint256 requiredJiffys = referralSignupJiffys.mul(2);
796         return (referralJiffysBalance >= requiredJiffys) && (balances[platformManager] >= requiredJiffys);
797     }
798 
799     /**
800     * @dev Checks if user is a registered user
801     *
802     * @param account The address which owns the funds.
803     * @return A bool indicating if user is a registered user.
804     */
805     function isUserRegistered
806                             (
807                                 address account
808                             ) 
809                             public 
810                             view 
811                             returns(bool) 
812     {
813         return (account != address(0)) && users[account].isRegistered;
814     }
815 
816     /**
817     * @dev Checks pre-reqs and handles user registration
818     *
819     * @param account The address which is to be registered
820     * @param creditAccount The address which contains token credits from CC purchase
821     * @param referrer The address referred the account
822     */
823     function processRegisterUser
824                             (
825                                 address account, 
826                                 address creditAccount,
827                                 address referrer
828                             ) 
829                             private
830     {
831         require(account != address(0));                                             // No invalid account
832         require(!users[account].isRegistered);                                      // No double registration
833         require(referrer == address(0) ? true : users[referrer].isRegistered);      // Referrer, if present, must be a registered user
834         require(referrer != account);                                               // User can't refer her/himself
835 
836         // Initialize user with restricted jiffys
837         users[account] = User(true, 0, 0, referrer);
838         registeredUserLookup.push(account);
839 
840 
841         if (purchaseCredits[creditAccount].jiffys > 0) {
842             processPurchase(creditAccount, account, purchaseCredits[creditAccount].jiffys, purchaseCredits[creditAccount].purchaseTimestamp);
843             purchaseCredits[creditAccount].jiffys = 0;
844             delete purchaseCredits[creditAccount];
845         }
846 
847     }
848 
849     /**
850     * @dev Registers a user wallet with a referrer and deposits any applicable signup tokens
851     *
852     * @param account The wallet address
853     * @param creditAccount The address containing any tokens purchased with USD
854     * @param referrer The referring user address
855     * @return A uint256 with the user's token balance
856     */ 
857     function registerUser
858                             (
859                                 address account, 
860                                 address creditAccount,
861                                 address referrer
862                             ) 
863                             public 
864                             requireIsOperational 
865                             requirePlatformManager 
866                             returns(uint256) 
867     {
868                                     
869         processRegisterUser(account, creditAccount, referrer);
870         UserRegister(account, balanceOf(account), 0);          // Fire event
871 
872         return balanceOf(account);
873     }
874 
875     /**
876     * @dev Registers a user wallet with a referrer and deposits any applicable bonus tokens
877     *
878     * @param account The wallet address
879     * @param creditAccount The address containing any tokens purchased with USD
880     * @param referrer The referring user address
881     * @return A uint256 with the user's token balance
882     */
883     function registerUserBonus
884                             (
885                                 address account, 
886                                 address creditAccount,
887                                 address referrer
888                             ) 
889                             external 
890                             requireIsOperational 
891                             requirePlatformManager 
892                             returns(uint256) 
893     {
894         
895         processRegisterUser(account, creditAccount, referrer);
896 
897         
898         // Allocate if there are any remaining signup tokens
899         uint256 jiffys = 0;
900         if ((incentiveJiffysBalance >= userSignupJiffys) && (balances[platformManager] >= userSignupJiffys)) {
901             incentiveJiffysBalance = incentiveJiffysBalance.sub(userSignupJiffys);
902             users[account].seedJiffys = users[account].seedJiffys.add(userSignupJiffys);
903             transfer(account, userSignupJiffys);
904             jiffys = userSignupJiffys;
905         }
906 
907         UserRegister(account, balanceOf(account), jiffys);          // Fire event
908 
909        // Allocate referral tokens for both user and referrer if available       
910        if ((referrer != address(0)) && isReferralSupported()) {
911             referralJiffysBalance = referralJiffysBalance.sub(referralSignupJiffys.mul(2));
912 
913             // Referal tokens are restricted so it is necessary to update user's account
914             transfer(referrer, referralSignupJiffys);
915             users[referrer].seedJiffys = users[referrer].seedJiffys.add(referralSignupJiffys);
916 
917             transfer(account, referralSignupJiffys);
918             users[account].seedJiffys = users[account].seedJiffys.add(referralSignupJiffys);
919 
920             UserRefer(account, referrer, referralSignupJiffys);     // Fire event
921         }
922 
923         return balanceOf(account);
924     }
925 
926     /**
927     * @dev Adds Jiffys to escrow for a user
928     *
929     * Escrows track the number of Jiffys that the user may owe another user.
930     * This function is called by the InterfaceData contract when a caller
931     * subscribes to a call.
932     *
933     * @param account The wallet address
934     * @param jiffys The number of Jiffys to put into escrow
935     */ 
936     function depositEscrow
937                             (
938                                 address account, 
939                                 uint256 jiffys
940                             ) 
941                             external 
942                             requireIsOperational 
943     {
944         if (jiffys > 0) {
945             require(isContractAuthorized(msg.sender) || isPlatformManager(msg.sender));   
946             require(isUserRegistered(account));                                                     
947             require(spendableBalanceOf(account) >= jiffys);
948 
949             users[account].interfaceEscrowJiffys = users[account].interfaceEscrowJiffys.add(jiffys);
950         }
951     }
952 
953     /**
954     * @dev Refunds Jiffys from escrow for a user
955     *
956     * This function is called by the InterfaceData contract when a caller
957     * unsubscribes from a call.
958     *
959     * @param account The wallet address
960     * @param jiffys The number of Jiffys to remove from escrow
961     */ 
962     function refundEscrow
963                             (
964                                 address account, 
965                                 uint256 jiffys
966                             ) 
967                             external 
968                             requireIsOperational 
969     {
970         if (jiffys > 0) {
971             require(isContractAuthorized(msg.sender) || isPlatformManager(msg.sender));   
972             require(isUserRegistered(account));                                                     
973             require(users[account].interfaceEscrowJiffys >= jiffys);
974 
975             users[account].interfaceEscrowJiffys = users[account].interfaceEscrowJiffys.sub(jiffys);
976         }
977     }
978 
979     /**
980     * @dev Handles payment for an Interface transaction
981     *
982     * This function is called by the InterfaceData contract when the front-end
983     * application makes a settle() call indicating that the transaction is
984     * complete and it's time to pay the Expert. To prevent unauthorized use
985     * the function is only callable by a previously authorized contract and
986     * is limited to paying out funds previously escrowed.
987     *
988     * @param payer The account paying (i.e. a caller)
989     * @param payee The account being paid (i.e. the Expert)
990     * @param referrer The account that referred payer to payee
991     * @param referralFeeBasisPoints The referral fee payable to referrer
992     * @param billableJiffys The number of Jiffys for payment
993     * @param escrowJiffys The number of Jiffys held in escrow for Interface being paid
994     */ 
995     function pay
996                             (
997                                 address payer, 
998                                 address payee, 
999                                 address referrer, 
1000                                 uint256 referralFeeBasisPoints, 
1001                                 uint256 billableJiffys,
1002                                 uint256 escrowJiffys
1003                             ) 
1004                             external 
1005                             requireIsOperational 
1006                             returns(uint256, uint256)
1007     {
1008         require(isContractAuthorized(msg.sender));   
1009         require(billableJiffys >= 0);
1010         require(users[payer].interfaceEscrowJiffys >= billableJiffys);  // Only payment of Interface escrowed funds is allowed
1011         require(users[payee].isRegistered);
1012 
1013         // This function may be called if the Expert's surety is
1014         // being forfeited. In that case, the payment is made to the 
1015         // Support and then funds will be distributed as appropriate
1016         // to parties following a grievance process. Since the rules 
1017         // for forfeiture can get very complex, they are best handled 
1018         // off-contract. payee == supportManager indicates a forfeiture.
1019 
1020 
1021         // First, release Payer escrow
1022         users[payer].interfaceEscrowJiffys = users[payer].interfaceEscrowJiffys.sub(escrowJiffys);
1023         uint256 referralFeeJiffys = 0;
1024         uint256 winNetworkFeeJiffys = 0;
1025 
1026         if (billableJiffys > 0) {
1027 
1028             // Second, pay the payee
1029             processPayment(payer, payee, billableJiffys);
1030 
1031             // Payee is SupportManager if Expert surety is being forfeited, so skip referral and network fees
1032             if (payee != supportManager) {
1033 
1034                 // Third, Payee pays Referrer and referral fees due
1035                 if ((referralFeeBasisPoints > 0) && (referrer != address(0)) && (users[referrer].isRegistered)) {
1036                     referralFeeJiffys = billableJiffys.mul(referralFeeBasisPoints).div(BASIS_POINTS_TO_PERCENTAGE); // Basis points to percentage conversion
1037                     processPayment(payee, referrer, referralFeeJiffys);
1038                 }
1039 
1040                 // Finally, Payee pays contract owner WIN network fee
1041                 if (winNetworkFeeBasisPoints > 0) {
1042                     winNetworkFeeJiffys = billableJiffys.mul(winNetworkFeeBasisPoints).div(BASIS_POINTS_TO_PERCENTAGE); // Basis points to percentage conversion
1043                     processPayment(payee, contractOwner, winNetworkFeeJiffys);
1044                 }                    
1045             }
1046         }
1047 
1048         return(referralFeeJiffys, winNetworkFeeJiffys);
1049     }
1050     
1051     /**
1052     * @dev Handles actual token transfer for payment
1053     *
1054     * @param payer The account paying
1055     * @param payee The account being paid
1056     * @param jiffys The number of Jiffys for payment
1057     */     
1058     function processPayment
1059                                (
1060                                    address payer,
1061                                    address payee,
1062                                    uint256 jiffys
1063                                )
1064                                private
1065     {
1066         require(isUserRegistered(payer));
1067         require(isUserRegistered(payee));
1068         require(spendableBalanceOf(payer) >= jiffys);
1069 
1070         balances[payer] = balances[payer].sub(jiffys); 
1071         balances[payee] = balances[payee].add(jiffys);
1072         Transfer(payer, payee, jiffys);
1073 
1074         // In the event the payer had received any signup tokens, their value
1075         // would be stored in the seedJiffys property. When any contract payment
1076         // is made, we reduce the seedJiffys number. seedJiffys tracks how many
1077         // tokens are not allowed to be transferred out of an account. As a user
1078         // makes payments to other users, those tokens have served their purpose
1079         // of encouraging use of the network and are no longer are restricted.
1080         if (users[payer].seedJiffys >= jiffys) {
1081             users[payer].seedJiffys = users[payer].seedJiffys.sub(jiffys);
1082         } else {
1083             users[payer].seedJiffys = 0;
1084         }
1085            
1086     }
1087 
1088     /**
1089     * @dev Handles transfer of tokens for vesting grants
1090     *
1091     * This function is called by the TokenVesting contract. To prevent unauthorized 
1092     * use the function is only callable by a previously authorized contract.
1093     *
1094     * @param issuer The account granting tokens
1095     * @param beneficiary The account being granted tokens
1096     * @param vestedJiffys The number of vested Jiffys for immediate payment
1097     * @param unvestedJiffys The number of unvested Jiffys to be placed in escrow
1098     */     
1099     function vestingGrant
1100                             (
1101                                 address issuer, 
1102                                 address beneficiary, 
1103                                 uint256 vestedJiffys,
1104                                 uint256 unvestedJiffys
1105                             ) 
1106                             external 
1107                             requireIsOperational 
1108     {
1109         require(isContractAuthorized(msg.sender));   
1110         require(spendableBalanceOf(issuer) >= unvestedJiffys.add(vestedJiffys));
1111 
1112 
1113         // Any vestedJiffys are transferred immediately to the beneficiary
1114         if (vestedJiffys > 0) {
1115             balances[issuer] = balances[issuer].sub(vestedJiffys);
1116             balances[beneficiary] = balances[beneficiary].add(vestedJiffys);
1117             Transfer(issuer, beneficiary, vestedJiffys);
1118         }
1119 
1120         // Any unvestedJiffys are removed from the granting account balance
1121         // A corresponding number of Jiffys is added to the granting account's
1122         // vesting escrow balance.
1123         balances[issuer] = balances[issuer].sub(unvestedJiffys);
1124         vestingEscrows[issuer] = vestingEscrows[issuer].add(unvestedJiffys);
1125     }
1126 
1127 
1128     /**
1129     * @dev Handles transfer of tokens for vesting revokes and releases
1130     *
1131     * This function is called by the TokenVesting contract. To prevent unauthorized 
1132     * use the function is only callable by a previously authorized contract.
1133     *
1134     * @param issuer The account granting tokens
1135     * @param beneficiary The account being granted tokens
1136     * @param jiffys The number of Jiffys for release or revoke
1137     */     
1138     function vestingTransfer
1139                             (
1140                                 address issuer, 
1141                                 address beneficiary, 
1142                                 uint256 jiffys
1143                             ) 
1144                             external 
1145                             requireIsOperational 
1146     {
1147         require(isContractAuthorized(msg.sender));   
1148         require(vestingEscrows[issuer] >= jiffys);
1149 
1150         vestingEscrows[issuer] = vestingEscrows[issuer].sub(jiffys);
1151         balances[beneficiary] = balances[beneficiary].add(jiffys);
1152         Transfer(issuer, beneficiary, jiffys);
1153     }
1154 
1155 
1156     /**
1157     * @dev Gets an array of addresses registered with contract
1158     *
1159     * This can be used by API to enumerate all users
1160     */   
1161     function getRegisteredUsers() 
1162                                 external 
1163                                 view 
1164                                 requirePlatformManager 
1165                                 returns(address[]) 
1166     {
1167         return registeredUserLookup;
1168     }
1169 
1170 
1171     /**
1172     * @dev Gets an array of addresses registered with contract
1173     *
1174     * This can be used by API to enumerate all users
1175     */   
1176     function getRegisteredUser
1177                                 (
1178                                     address account
1179                                 ) 
1180                                 external 
1181                                 view 
1182                                 requirePlatformManager                                
1183                                 returns(uint256, uint256, uint256, address) 
1184     {
1185         require(users[account].isRegistered);
1186 
1187         return (balances[account], users[account].seedJiffys, users[account].interfaceEscrowJiffys, users[account].referrer);
1188     }
1189 
1190 
1191     /**
1192     * @dev Returns ICO-related state information for use by API
1193     */ 
1194     function getIcoInfo()
1195                                   public
1196                                   view
1197                                   returns(bool, uint256, uint256, uint256, uint256, uint256)
1198     {
1199         return (
1200                     balances[icoOwner] > 0, 
1201                     weiExchangeRate, 
1202                     centsExchangeRate, 
1203                     bonus20EndTimestamp, 
1204                     bonus10EndTimestamp, 
1205                     bonus5EndTimestamp
1206                 );
1207     }
1208 
1209     /********************************************************************************************/
1210     /*                                       TOKEN SALE                                         */
1211     /********************************************************************************************/
1212 
1213     /**
1214     * @dev Fallback function for buying ICO tokens. This is not expected to be called with
1215     *      default gas as it will most certainly fail.
1216     *
1217     */
1218     function() 
1219                             external 
1220                             payable 
1221     {
1222         buy(msg.sender);
1223     }
1224 
1225 
1226     /**
1227     * @dev Buy ICO tokens
1228     *
1229     * @param account Account that is buying tokens
1230     *
1231     */
1232     function buy
1233                             (
1234                                 address account
1235                             ) 
1236                             public 
1237                             payable 
1238                             requireIsOperational 
1239     {
1240         require(balances[icoOwner] > 0);
1241         require(account != address(0));        
1242         require(msg.value >= weiExchangeRate);    // Minimum 1 token
1243 
1244         uint256 weiReceived = msg.value;
1245 
1246         // Convert Wei to Jiffys based on the exchange rate
1247         uint256 buyJiffys = weiReceived.mul(jiffysMultiplier).div(weiExchangeRate);
1248         processPurchase(icoOwner, account, buyJiffys, now);
1249         icoWallet.transfer(msg.value);
1250     }
1251 
1252 
1253     /**
1254     * @dev Buy ICO tokens with USD
1255     *
1256     * @param account Account that is buying tokens
1257     * @param cents Purchase amount in cents
1258     *
1259     */    
1260     function buyUSD
1261                             (
1262                                 address account,
1263                                 uint256 cents
1264                             ) 
1265                             public 
1266                             requireIsOperational 
1267                             requirePlatformManager
1268     {
1269         require(balances[icoOwner] > 0);
1270         require(account != address(0));        
1271         require(cents >= centsExchangeRate);    // Minimum 1 token
1272 
1273 
1274 
1275         // Convert Cents to Jiffys based on the exchange rate
1276         uint256 buyJiffys = cents.mul(jiffysMultiplier).div(centsExchangeRate);
1277 
1278         if (users[account].isRegistered) {
1279             processPurchase(icoOwner, account, buyJiffys, now);
1280         } else {
1281             // Purchased credits will be transferred to account when user registers
1282             // They are kept in a holding area until then. We deduct buy+bonus from 
1283             // icoOwner because that is the amount that will eventually be credited.
1284             // However, we store the credit as buyJiffys so that the referral calculation
1285             // will be against the buy amount and not the buy+bonus amount
1286             uint256 totalJiffys = buyJiffys.add(calculatePurchaseBonus(buyJiffys, now));
1287             balances[icoOwner] = balances[icoOwner].sub(totalJiffys);
1288             balances[account] = balances[account].add(totalJiffys);
1289             purchaseCredits[account] = PurchaseCredit(buyJiffys, now);
1290             Transfer(icoOwner, account, buyJiffys);
1291         }
1292 
1293     }
1294 
1295     /**
1296     * @dev Process token purchase
1297     *
1298     * @param account Account that is buying tokens
1299     * @param buyJiffys Number of Jiffys purchased
1300     *
1301     */    
1302     function processPurchase
1303                             (
1304                                 address source,
1305                                 address account,
1306                                 uint256 buyJiffys,
1307                                 uint256 purchaseTimestamp
1308                             ) 
1309                             private 
1310     {
1311 
1312         uint256 totalJiffys = buyJiffys.add(calculatePurchaseBonus(buyJiffys, purchaseTimestamp));
1313 
1314 
1315         // Transfer purchased Jiffys to buyer
1316         require(transferableBalanceOf(source) >= totalJiffys);        
1317         balances[source] = balances[source].sub(totalJiffys);
1318         balances[account] = balances[account].add(totalJiffys);            
1319         Transfer(source, account, totalJiffys);
1320 
1321         // If the buyer has a referrer attached to their profile, then
1322         // transfer 3% of the purchased Jiffys to the referrer's account
1323         if (users[account].isRegistered && (users[account].referrer != address(0))) {
1324             address referrer = users[account].referrer;
1325             uint256 referralJiffys = (buyJiffys.mul(BUYER_REFERRER_BOUNTY)).div(100);
1326             if ((referralJiffys > 0) && (transferableBalanceOf(icoOwner) >= referralJiffys)) {
1327                 balances[icoOwner] = balances[icoOwner].sub(referralJiffys);
1328                 balances[referrer] = balances[referrer].add(referralJiffys);  
1329                 Transfer(icoOwner, referrer, referralJiffys);
1330             }            
1331         }
1332     }
1333 
1334     /**
1335     * @dev Calculates ICO bonus tokens
1336     *
1337     * @param buyJiffys Number of Jiffys purchased
1338     *
1339     */    
1340     function calculatePurchaseBonus
1341                             (
1342                                 uint256 buyJiffys,
1343                                 uint256 purchaseTimestamp
1344                             ) 
1345                             private 
1346                             view
1347                             returns(uint256)
1348     {
1349         uint256 bonusPercentage = 0;
1350 
1351         // Time-based bonus
1352         if (purchaseTimestamp <= bonus5EndTimestamp) {
1353             if (purchaseTimestamp <= bonus10EndTimestamp) {
1354                 if (purchaseTimestamp <= bonus20EndTimestamp) {
1355                     bonusPercentage = 20;
1356                 } else {
1357                     bonusPercentage = 10;
1358                 }
1359             } else {
1360                 bonusPercentage = 5;
1361             }
1362         }
1363 
1364         return (buyJiffys.mul(bonusPercentage)).div(100);
1365     }
1366     
1367 
1368 }   
1369 
1370 /*
1371 LICENSE FOR SafeMath and TokenVesting
1372 
1373 The MIT License (MIT)
1374 
1375 Copyright (c) 2016 Smart Contract Solutions, Inc.
1376 
1377 Permission is hereby granted, free of charge, to any person obtaining
1378 a copy of this software and associated documentation files (the
1379 "Software"), to deal in the Software without restriction, including
1380 without limitation the rights to use, copy, modify, merge, publish,
1381 distribute, sublicense, and/or sell copies of the Software, and to
1382 permit persons to whom the Software is furnished to do so, subject to
1383 the following conditions:
1384 
1385 The above copyright notice and this permission notice shall be included
1386 in all copies or substantial portions of the Software.
1387 
1388 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
1389 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
1390 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
1391 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
1392 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
1393 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
1394 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
1395 */
1396 
1397 
1398 library SafeMath {
1399 /* Copyright (c) 2016 Smart Contract Solutions, Inc. */
1400 /* See License at end of file                        */
1401 
1402     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1403         if (a == 0) {
1404         return 0;
1405         }
1406         uint256 c = a * b;
1407         assert(c / a == b);
1408         return c;
1409     }
1410 
1411     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1412         // assert(b > 0); // Solidity automatically throws when dividing by 0
1413         uint256 c = a / b;
1414         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1415         return c;
1416     }
1417 
1418     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1419         assert(b <= a);
1420         return a - b;
1421     }
1422 
1423     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1424         uint256 c = a + b;
1425         assert(c >= a);
1426         return c;
1427     }
1428 }