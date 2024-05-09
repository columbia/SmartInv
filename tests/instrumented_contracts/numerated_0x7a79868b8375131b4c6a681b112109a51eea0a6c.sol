1 pragma solidity >= 0.5.12;
2 
3 interface ERC20 {
4     function totalSupply() external view returns (uint);
5     function balanceOf(address tokenOwner) external view returns (uint balance);
6     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
7     function transfer(address to, uint tokens) external returns (bool success);
8     function approve(address spender, uint tokens) external returns (bool success);
9     function transferFrom(address from, address to, uint tokens) external returns (bool success);
10     event Transfer(address indexed from, address indexed to, uint tokens);
11     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
12 }
13 
14 /**
15  * @title  ChainValidator interface
16  * @author Jakub Fornadel
17  * @notice External chain validator contract, can be used for more sophisticated validation of new validators and transactors, e.g. custom min. required conditions,
18  *         concrete users whitelisting, etc...
19  **/
20 interface ChainValidator {
21     /**
22      * @notice Validation function for new validators
23      * 
24      * @param vesting               How many tokens new validator wants to vest
25      * @param acc                   Account address of the validator
26      * @param mining                Flag if validator is going to mine. 
27      *                               mining == false in case validateNewValidator is called during vestInChain method
28      *                               mining == true in case validateNewValidator is called during startMining method
29      * @param actNumOfValidators    How many active validators is currently in chain
30      **/
31     function validateNewValidator(uint256 vesting, address acc, bool mining, uint256 actNumOfValidators) external returns (bool);
32     
33     /**
34      * @notice Validation function for new transactors
35      * 
36      * @param deposit               How many tokens new transactor wants to deposit
37      * @param acc                   Account address of the transactor
38      * @param actNumOfTransactors   How many whitelisted transactors (their deposit balance >= min. required balance) is currently in chain
39      **/
40     function validateNewTransactor(uint256 deposit, address acc, uint256 actNumOfTransactors) external returns (bool);
41 }
42 
43 /**
44  * @title   Lition Registry Contract
45  * @author  Jakub Fornadel
46  * @notice  This contract is used for anchoring statistics (users gas consumption, validators stats - blocks mined, etc...) from Lition blockchain network into the ethereum, 
47  *          base on which users consumption and validators rewards in LIT (ERC20) tokens are calculated and distributed
48  **/
49 contract LitionRegistry {
50     using SafeMath for uint256;
51     
52     /**************************************************************************************************************************/
53     /************************************************** Constants *************************************************************/
54     /**************************************************************************************************************************/
55     
56     // Token precision. 1 LIT token = 1*10^18
57     uint256 constant LIT_PRECISION               = 10**18;
58     
59     // Largest tx fee fixed at 0.1 LIT
60     uint256 constant LARGEST_TX_FEE              = LIT_PRECISION/10;
61     
62     // Min notary period = 1440 blocks (2 hours)
63     uint256 constant MIN_NOTARY_PERIOD           = 1440;    // mainnet: 1440, testnet: 60 
64     
65     // Max notary period = 34560 blocks (48 hours)
66     uint256 constant MAX_NOTARY_PERIOD           = 34560;
67     
68     // Time after which chain becomes inactive in case there was no successfull notary processed
69     // Users can then increase/descrease their vesting/deposit instantly and bypass 2-step process with confirmations.
70     uint256 constant CHAIN_INACTIVITY_TIMEOUT    = 7 days;  // mainnet: 7, testnet 1 days 
71     
72     // Time after which validators can withdraw their vesting
73     uint256 constant VESTING_LOCKUP_TIMEOUT      = 7 days;  // mainnet: 7, testnet 1 days
74     
75     // Max num of characters in chain url
76     uint256 constant MAX_URL_LENGTH              = 100;
77     
78     // Max num of characters in chain description
79     uint256 constant MAX_DESCRIPTION_LENGTH      = 200;
80     
81     // Min. required deposit for all chains
82     uint256 constant LITION_MIN_REQUIRED_DEPOSIT = 1000*LIT_PRECISION;
83     
84     // Min. required vesting for all chains
85     uint256 constant LITION_MIN_REQUIRED_VESTING = 1000*LIT_PRECISION;
86     
87     
88     /**************************************************************************************************************************/
89     /**************************************************** Events **************************************************************/
90     /**************************************************************************************************************************/
91     
92     // New chain was registered
93     event NewChain(uint256 chainId, string description, string endpoint);
94     
95     // Deposit request created
96     // in case confirmed == true, tokens were transferred and account's deposit balance was updated
97     // in case confirmed == false, listener needs to wait for another DepositInChain event with confirmed flag == true.
98     // It can paired up with the first event if first 4 parameters are the same
99     event DepositInChain(uint256 indexed chainId, address indexed account, uint256 deposit, uint256 lastNotaryBlock, bool confirmed);
100     
101     // Vesting request created
102     // in case confirmed == true, tokens were transferred and account's vesting balance was updated
103     // in case confirmed == false, listener needs to wait for another VestInChain event with confirmed flag == true.
104     // It can paired up with the first event if first 4 parameters are the same
105     event VestInChain(uint256 indexed chainId, address indexed account, uint256 vesting, uint256 lastNotaryBlock, bool confirmed);
106     
107     // if whitelisted == true  - allow user to transact
108     // if whitelisted == false - do not allow user to transact
109     event AccountWhitelisted(uint256 indexed chainId, address indexed account, bool whitelisted);
110     
111     // Validator start/stop mining
112     event AccountMining(uint256 indexed chainId, address indexed account, bool mining);
113 
114     // Validator's new mining reward 
115     event MiningReward(uint256 indexed chainId, address indexed account, uint256 reward);
116     
117     // New notary was processed
118     event Notary(uint256 indexed chainId, uint256 lastBlock, uint256 blocksProcessed);
119     
120     // Manual notary reset was processed
121     event NotaryReset(uint256 indexed chainId, uint256 lastValidBlock, uint256 resetBlock);
122     
123 
124     /**************************************************************************************************************************/
125     /***************************************** Structs related to the list of users *******************************************/
126     /**************************************************************************************************************************/
127     
128     // Iterable map that is used only together with the Users mapping as data holder
129     struct IterableMap {
130         // map of indexes to the list array
131         // indexes are shifted +1 compared to the real indexes of this list, because 0 means non-existing element
132         mapping(address => uint256) listIndex;
133         // list of addresses 
134         address[]                   list;        
135     }
136     
137     struct VestingRequest {
138         // Flag if there is ongoing request for user
139         bool                    exist;
140         // Last notary block number when the request was accepted 
141         uint256                 notaryBlock;
142         // New value of vesting to be set
143         uint256                 newVesting;
144     }
145     
146     struct Validator {
147         // Flag if validator mined at least 1 block in current notary window
148         bool                    currentNotaryMined;
149         // Flag if validator mined at least 1 block in the previous notary window
150         bool                    prevNotaryMined;
151         // Vesting request
152         VestingRequest          vestingRequest;
153         // Actual user's vesting
154         uint256                  vesting;
155         // Last time when the user increased his vesting balance. It is used to calculate the time when he can withdraw his vesting 
156         uint256                 lastVestingIncreaseTime;
157     }
158     
159     // Only full deposit withdrawals are saved as deposit requests - other types of deposits do not need to be confirmed
160     struct DepositWithdrawalRequest {
161         // Last notary block number when the request was accepted 
162         uint256                  notaryBlock;
163         // Flag if there is ongoing request for user
164         bool                     exist;
165     }
166     
167     struct Transactor {
168         // Actual user's deposit
169         uint256                  deposit;
170         // DepositWithdrawalRequest request
171         DepositWithdrawalRequest depositWithdrawalRequest;
172         // Flag if user is whitelisted (allowed to transact) -> actual deposit must be greater than min. required deposit condition 
173         bool                     whitelisted;
174     }
175     
176     struct User {
177         // Transactor's data
178         Transactor   transactor;
179         
180         // Validator's data
181         Validator    validator;
182     }
183 
184     
185     /**************************************************************************************************************************/
186     /***************************************************** Other structs ******************************************************/
187     /**************************************************************************************************************************/
188     
189     ERC20 token;
190     
191     struct LastNotary {
192         // Timestamp(eth block time), when last notary was accepted
193         uint256 timestamp;
194         // Actual Lition block number, when the last notary was accepted
195         uint256 block;
196     }
197     
198     struct ChainInfo {
199         // Internal chain ID
200         uint256                         id;
201         
202         // Min. required deposit for transactors (more sophisticated conditions might be set in external validator contract)
203         // Must be >= MIN_REQUIRED_DEPOSIT (1000 LIT)
204         uint256                         minRequiredDeposit;
205         
206         // Min. required vesting for validators (more sophisticated conditions might be set in external validator contract)
207         // Must be >= MIN_REQUIRED_VESTING (1000 LIT)
208         uint256                         minRequiredVesting;
209         
210         // Actual number of whitelisted transactors (their current depost > min.required deposit)
211         uint256                         actNumOfTransactors;
212         
213         // Max number of active validators for chain. There is no limit to how many users can vest.
214         // Tthis is limit for active validators (startMining function) 
215         // 0  means unlimited
216         // It must be some reasonable value together with min. required vesting condition as 
217         // too small num of validators limit with too low min. required vesting condition might lead to chain being stuck
218         uint256                         maxNumOfValidators;
219         
220         // Max number of users(transactors) for chain.
221         // Tthis is limit for whitelisted transactors (their current depost > min.required deposit)
222         // 0  means unlimited
223         // It must be some reasonable value together with min. required deposit condition as 
224         // too small num of validators limit with too low min. required deposit condition might lead to chain being stuck
225         uint256                         maxNumOfTransactors;
226         
227         // Required vesting balance for reward bonus to be applied  
228         // 0 means no bonus is ever appliedm must be >= MIN_REQUIRED_VESTING (1000 LIT)
229         uint256                         rewardBonusRequiredVesting;
230         
231         // Reward bonus percentage, must be > 0%
232         uint256                         rewardBonusPercentage;
233         
234         // How much vesting in total is vested in the chain by the active validators
235         uint256                         totalVesting;
236         
237         // Number of blocks after which notary is called, 1 block is generated every 5 seconds, e.g notaryPeriod = 1440 blocks = 2 hours
238         uint256                         notaryPeriod;
239         
240         // When was the last notary function called (block and time)
241         LastNotary                      lastNotary;
242         
243         // Flag for condition to be checked during notary:
244         // InvolvedVesting of validators who signed notary statistics must be greater than 50% of chain total vesting(sum of all active validator's vesting)
245         // to notary statistics to be accepted is accepted
246         bool                            involvedVestingNotaryCond;
247         
248         // Flag for condition to be checked during notary:
249         // Number of validators who signed notary statistics must be greater or equal than 2/3+1 of all active validators
250         // to notary statistics to be accepted is accepted
251         bool                            participationNotaryCond;
252         
253         // Flag that says if the chain was already(& sucessfully) registered
254         bool                            registered;
255         
256         // Flag that says if chain is active - num of active validators > 0 && first block was already mined 
257         bool                            active;
258         
259         // Address of the chain creator
260         address                         creator;
261         
262         // Validator with the smallest vesting balance among all existing validators
263         // In case someone vests more tokens, he will replace the one with smallest vesting balance
264         address                         lastValidator;
265         
266         // Smart-contract for validating min.required deposit and vesting
267         ChainValidator                  chainValidator;
268         
269         // Chain description
270         string                          description;
271         
272         // Chain endpoint
273         string                          endpoint;
274         
275         // List of existing users - all users, who have deposited or vested
276         IterableMap                     users;
277         
278         // List of existing validators - only those who vested enough and are actively mining are here
279         // Active validator are in separate array because of heavy processing furing notary (no need to filter them out of users thanks tot this)
280         IterableMap                     validators;
281         
282         // Mapping data holder for users (validators & transactors) data
283         mapping(address => User)        usersData;
284     }
285     
286     // Registered chains
287     mapping(uint256 => ChainInfo)   private chains;
288     
289     // Next chain id
290     uint256                         public  nextId = 0;
291 
292     
293     /**************************************************************************************************************************/
294     /************************************ Contract interface - external/public functions **************************************/
295     /**************************************************************************************************************************/
296     
297     /**
298      * @notice Requests vest in chain
299      *
300      * @param chainId  ChainId that sender wants to interact with
301      * 
302      * @param vesting  New requested vesting balance. Possible scenarios:
303      *                 1. vesting == 0 
304      *                      - stopMining must be called first
305      *                      - can be called after VESTING_LOCKUP_TIMEOUT (7 days) since the last vesting increase
306      *                      - vestingRequest is created
307      *                      - if chain.active == true
308      *                           * confirmVestInChain can be called in the next notary window to finalize full vesting withdrawal
309      *                      - if chain.active == false
310      *                           * confirmVestInChain can be called immediately to finalize full vesting withdrawal
311      *                 
312      *                 2. vesting == actual validators vesting balance
313      *                      - not allowed
314      * 
315      *                 3. vesting > actual validators vesting balance
316      *                      - in case all active validators slots are taken, vesting must be > than the lastValidator vesting (last == smallest vesting among all active validators) 
317      *                      - vestingRequest is created
318      *                      - LIT token transfer is processed
319      *                      - if chain.active == true
320      *                           * confirmVestInChain can be called in the next notary window to finalize vesting increase
321      *                      - if chain.active == false
322      *                           * confirmVestInChain can be called immediately to finalize full vesting increase
323      *
324      *                 4. vesting < actual validators vesting balance
325      *                      - can be called after VESTING_LOCKUP_TIMEOUT (7 days) since the last vesting increase
326      *                      - processed immediately, no confirmation needed
327      *                      - LIT token transfer is processed
328      **/
329     function requestVestInChain(uint256 chainId, uint256 vesting) external {
330         ChainInfo storage chain = chains[chainId];
331         Validator storage validator = chain.usersData[msg.sender].validator;
332         
333         // Enable users to vest into registered (but non-active) chain and start minig so it becomes active
334         require(chain.registered == true,                                 "Non-registered chain");
335         require(transactorExist(chain, msg.sender) == false,              "Validator cannot be transactor at the same time. Withdraw your depoist or use different account");
336         require(vestingRequestExist(chain, msg.sender) == false,          "There is already one vesting request being processed for this acc");
337         
338         // Checks if chain is active, if not set it active flag to false 
339         checkAndSetChainActivity(chain);
340         
341         // Full vesting withdrawal
342         if (vesting == 0) {
343             require(validatorExist(chain, msg.sender) == true,            "Non-existing validator account (0 vesting balance)");
344             require(activeValidatorExist(chain, msg.sender) == false,     "StopMinig must be called first");
345             
346             // In case user wants to withdraw full vesting and chain is active, check vesting lockup timeout
347             if (chain.active == true) {
348                 require(validator.lastVestingIncreaseTime + VESTING_LOCKUP_TIMEOUT < now,  "Unable to decrease vesting balance, validators need to wait VESTING_LOCKUP_TIMEOUT(7 days) since the last increase");
349             }
350         }
351         // Vest in chain or withdraw just part of vesting
352         else {
353             require(validator.vesting != vesting,                         "Cannot vest the same amount of tokens as you already has vested");
354             require(vesting >= chain.minRequiredVesting,                  "User does not meet min.required vesting condition");
355             
356             if (chain.chainValidator != ChainValidator(0)) {
357                 require(chain.chainValidator.validateNewValidator(vesting, msg.sender, false /* not mining yet */, chain.validators.list.length), "Validator not allowed by external chainvalidator SC");
358             }
359             
360             // In case user wants to decrease vesting and chain is active, check vesting lockup timeout
361             if (vesting < validator.vesting) {
362                 if (chain.active == true) {
363                     require(validator.lastVestingIncreaseTime + VESTING_LOCKUP_TIMEOUT < now,  "Unable to decrease vesting balance, validators need to wait VESTING_LOCKUP_TIMEOUT(7 days) since the last increase");
364                 }
365             }
366             // In case user wants to increase vesting, do not allow him if there is no more places for active validators and user does not vest more than the the one with smallest vesting balance 
367             else if (chain.maxNumOfValidators != 0 && chain.validators.list.length >= chain.maxNumOfValidators) {
368            
369                 require(vesting > chain.usersData[chain.lastValidator].validator.vesting, "Upper limit of validators reached. Must vest more than the last validator to be able to start mining and replace him");
370             }
371         }
372         
373         requestVest(chain, vesting, msg.sender);
374     }
375     
376     /**
377      * @notice Confirms existing vesting request
378      *
379      * @param chainId ChainId that sender wants to interact with
380      *                
381      *                Possible values for existing vestig request:
382      *                1. vesting == 0 
383      *                      - vestingRequest is deleted
384      *                      - LIT token transfer is processed 
385      *                      - validator's vesting balance is updated
386      *                2. vesting > actual validators vesting balance
387      *                      - vestingRequest is deleted
388      *                      - validator's vesting balance is updated
389      * 
390      *                - if chain.active == true
391      *                      * confirmVestInChain can be called in the next notary window after the one, in which change was requeted
392      *                - if chain.active == false
393      *                      * confirmVestInChain can be called immediately
394      **/
395     function confirmVestInChain(uint256 chainId) external {
396         ChainInfo storage chain = chains[chainId];
397         
398         // Enable users to confirm vesting request into registered (but non-active) chain and start minig so it becomes active
399         require(chain.registered == true, "Non-registered chain");
400         require(vestingRequestExist(chain, msg.sender) == true, "Non-existing vesting request");
401         
402         // Checks if chain is active, if not set it active flag to false 
403         checkAndSetChainActivity(chain);
404         
405         // Chain is active
406         if (chain.active == true) {
407             require(chain.lastNotary.block > chain.usersData[msg.sender].validator.vestingRequest.notaryBlock, "Confirm can be called in the next notary window after request was accepted");    
408         }
409         
410         confirmVest(chain, msg.sender);
411     }
412     
413     /**
414      * @notice Requests deposit in chain
415      *
416      * @param chainId  ChainId that sender wants to interact with
417      * 
418      * @param deposit  New requested deposit balance. Possible scenarios:
419      *                 1. deposit == 0 
420      *                      - depositWithdrawalRequest is created
421      *                      - validators whitelisted flag is set to false and AccountWhitelisted event is emmited
422      *                      - if chain.active == true
423      *                           * confirmDepositWithdrawalFromChain can be called in the next notary window to finalize full deposit withdrawal
424      *                      - if chain.active == false
425      *                           * confirmDepositWithdrawalFromChain can be called immediately to finalize full deposit withdrawal
426      *                 
427      *                 2. deposit == actual transactors deposit balance
428      *                      - not allowed
429      * 
430      *                 3. deposit > actual validators deposit balance
431      *                      - processed immediately, no confirmation needed
432      * 
433      *                 4. deposit < actual validators deposit balance
434      *                      - processed immediately, no confirmation needed
435      **/
436     function requestDepositInChain(uint256 chainId, uint256 deposit) external {
437         ChainInfo storage chain = chains[chainId];
438         
439         require(chain.registered == true,                                             "Non-registered chain");
440         require(validatorExist(chain, msg.sender) == false,                           "Transactor cannot be validator at the same time. Withdraw your vesting or use different account");
441         require(depositWithdrawalRequestExist(chain, msg.sender) == false,            "There is already existing withdrawal request being processed for this acc");
442         
443         // Checks if chain is active, if not set it active flag to false 
444         checkAndSetChainActivity(chain);
445         
446         // Withdraw whole deposit
447         if (deposit == 0) {
448             require(transactorExist(chain, msg.sender) == true,                       "Non-existing transactor account (0 deposit balance)");
449         }
450         // Deposit in chain or withdraw just part of deposit
451         else {
452             require(chain.usersData[msg.sender].transactor.deposit != deposit,        "Cannot deposit the same amount of tokens as you already has deposited");
453             require(deposit >= chain.minRequiredDeposit,                              "User does not meet min.required deposit condition");
454             
455             if (chain.chainValidator != ChainValidator(0)) {
456                 require(chain.chainValidator.validateNewTransactor(deposit, msg.sender, chain.actNumOfTransactors), "Transactor not allowed by external chainvalidator SC");
457             }
458             
459             // Upper limit of transactors reached
460             if (chain.maxNumOfTransactors != 0 && chain.usersData[msg.sender].transactor.whitelisted == false) {
461                 require(chain.actNumOfTransactors <= chain.maxNumOfTransactors, "Upper limit of transactors reached");
462             }
463         }
464                 
465         requestDeposit(chain, deposit, msg.sender);
466     }
467     
468     /**
469      * @notice Confirms existing full deposit withdrawal request
470      *
471      * @param chainId ChainId that sender wants to interact with
472      *                Possible values for existing full deposit withdrawal request:
473      *                1. deposit == 0 
474      *                      - depositWithdrawalRequest is deleted
475      *                      - LIT token transfer is processed 
476      *                      - validator's vesting balance is updated
477      * 
478      *                - if chain.active == true
479      *                      * confirmDepositWithdrawalFromChain can be called in the next notary window after the one, in which change was requeted
480      *                - if chain.active == false
481      *                      * confirmDepositWithdrawalFromChain can be called immediately
482      **/
483     function confirmDepositWithdrawalFromChain(uint256 chainId) external {
484         ChainInfo storage chain = chains[chainId];
485 
486         require(chain.registered == true, "Non-registered chain");
487         require(depositWithdrawalRequestExist(chain, msg.sender) == true, "Non-existing deposit withdrawal request");
488         
489         // Checks if chain is active, if not set it active flag to false 
490         checkAndSetChainActivity(chain);
491         
492         // Chain is active
493         if (chain.active == true) {
494             require(chain.lastNotary.block > chain.usersData[msg.sender].transactor.depositWithdrawalRequest.notaryBlock, "Confirm can be called in the next notary window after request was accepted");
495         }
496         
497         confirmDepositWithdrawal(chain, msg.sender);
498     }
499     
500     /**
501      * @notice Internally creates/registers new chain.
502      * 
503      * @param description                     Description of the chain (e.g name, short purpose description, etc...). Max 200 characters
504      *                                         Cannot be empty. Max num of characters is 200
505      * @param initEndpoint                    Chain endpoint, might be a website with chain description, condition to join and nodes ip:port addresses that can be used fo joining
506      *                                         Cannot be empty. Max num of characters is 100
507      * @param chainValidator                  External validator contract, might imolement more sophisticated rules for joing the chain as validator or as user (e.g. accounts whitelisting, etc...)
508      *                                         0 means no external validator contract
509      * @param minRequiredDeposit              Min.required deposit to become transactor (user). It must be some reasonable number as user should never be able to run out of tokens during notaryPeriod considering 
510      *                                         max. tx fee is fixed to 0.1 LIT tokens E.g. there is private chain with whitelisted users and user creator know they will send max. 100 000 txs / notaryPeriod. 
511      *                                         Min. required deposit should be then 10 000 LIT tokens. 
512      *                                         It is something like prebought credit for transactions that is required to have on your account before each notary. In fact, users will have to deposit more than minRequiredDeposit as 
513      *                                         they will be automatically blacklisted during the notary even if they sent only 1 tx, because their deposit balance would be < minRequiredDeposit before the next notary. 
514      *                                         On top of this condition, chain creator might implement more sophisticated condition in external validator contract
515      *                                         0 means default (1000 LIT), otherwise must be >= 1000 LIT tokens
516      * @param minRequiredVesting              Min.required deposit to become validator.
517      *                                         On top of this condition, chain creator might implement more sophisticated condition in external validator contract
518      *                                         0 means default (1000 LIT), otherwise must be >= 1000 LIT tokens
519      * @param rewardBonusRequiredVesting      Min. required vesting balance for bonus reward to be applied.
520      *                                         0 means that chain will not support rewards bonus 
521      * @param rewardBonusPercentage           Reward bonus (percentage) to be applied if validator's vesting balance >= rewardBonusRequiredVesting.
522      *                                         In case rewardBonusRequiredVesting > 0, rewardBonusPercentage must be > 0%, otherwise it is ignored
523      * @param notaryPeriod                    Notary period in blocks (1 block every 5s), it is basically time interval notary periodic calls where users consumptions are processed and rewards distributed. 
524      *                                         Must be in range <1440 (2 hours), 34560 (48 hours)>
525      * @param maxNumOfValidators              Max. number of active validators (those who vested and started mining). As Lition is using BFT consensus alg., it is recommended to use max no more than 51 validators(21 recommended).
526      *                                         On top of this condition, chain creator might implement more sophisticated condition in external validator contract
527      *                                         0 means unlimited
528      * @param maxNumOfTransactors             Max. number of transactors/users (those who deposited. It is recommended to restrict this number as notary will not be able to process theoretically unlimited number of users
529      *                                         On top of this condition, chain creator might implement more sophisticated condition in external validator contract
530      *                                         0 means unlimited
531      * @param involvedVestingNotaryCond       Flag, if 50% invloved vesting condition should be checked during notary. It means that vesting balances sum of those validators, who signed statistics 
532      *                                         sent to the notary must be > 50% of the sum of all active validators vesting balances on chain 
533      *                                         At least one of the involvedVestingNotaryCond or participationNotaryCond must be specified
534      * @param participationNotaryCond         Flag, 2/3 + 1 participation condition should be checked during notary. It means that more or equal to 2/3+1 of all active validators on chain 
535      *                                         must sign statistics sent to the notary for notary to be accepted 
536      *                                         At least one of the involvedVestingNotaryCond or participationNotaryCond must be specified
537      * 
538      * @return chainId of the created chain
539      **/ 
540     function registerChain(string memory description, string memory initEndpoint, ChainValidator chainValidator, uint256 minRequiredDeposit, uint256 minRequiredVesting, uint256 rewardBonusRequiredVesting, uint256 rewardBonusPercentage, 
541                            uint256 notaryPeriod, uint256 maxNumOfValidators, uint256 maxNumOfTransactors, bool involvedVestingNotaryCond, bool participationNotaryCond) public returns (uint256 chainId) {
542         require(bytes(description).length > 0 && bytes(description).length <= MAX_DESCRIPTION_LENGTH,   "Chain description length must be: > 0 && <= MAX_DESCRIPTION_LENGTH(200)");
543         require(bytes(initEndpoint).length > 0 && bytes(initEndpoint).length <= MAX_URL_LENGTH,         "Chain endpoint length must be: > 0 && <= MAX_URL_LENGTH(100)");
544         require(notaryPeriod >= MIN_NOTARY_PERIOD && notaryPeriod <= MAX_NOTARY_PERIOD,                 "Notary period must be in range <MIN_NOTARY_PERIOD(1440), MAX_NOTARY_PERIOD(34560)>");
545         require(involvedVestingNotaryCond == true || participationNotaryCond == true,                   "At least one notary condition must be specified");
546         
547         if (minRequiredDeposit > 0) {
548             require(minRequiredDeposit >= LITION_MIN_REQUIRED_DEPOSIT,                                  "Min. required deposit for all chains must be >= LITION_MIN_REQUIRED_DEPOSIT (1000 LIT)");
549         }
550         
551         if (minRequiredVesting > 0) {
552             require(minRequiredVesting >= LITION_MIN_REQUIRED_VESTING,                                  "Min. required vesting for all chains must be >= LITION_MIN_REQUIRED_VESTING (1000 LIT)");
553         }
554         
555         if (rewardBonusRequiredVesting > 0) {
556             require(rewardBonusPercentage > 0,                                                          "Reward bonus percentage must be > 0%");    
557         }
558     
559         chainId                         = nextId;
560         ChainInfo storage chain         = chains[chainId];
561         
562         chain.id                        = chainId;
563         chain.description               = description;
564         chain.endpoint                  = initEndpoint;
565         chain.minRequiredDeposit        = minRequiredDeposit;
566         chain.minRequiredVesting        = minRequiredVesting;
567         chain.notaryPeriod              = notaryPeriod;
568         chain.registered                = true;
569         chain.creator                   = msg.sender;
570         
571         if (chainValidator != ChainValidator(0)) {
572             chain.chainValidator = chainValidator;
573         }
574         
575         // Sets min required deposit
576         if (minRequiredDeposit == 0) {
577             chain.minRequiredDeposit = LITION_MIN_REQUIRED_DEPOSIT;
578         } 
579         else {
580             chain.minRequiredDeposit = minRequiredDeposit;
581         }
582         
583         // Sets min required vesting
584         if (minRequiredVesting == 0) {
585             chain.minRequiredVesting = LITION_MIN_REQUIRED_VESTING;
586         } 
587         else {
588             chain.minRequiredVesting = minRequiredVesting;
589         }
590 
591         
592         if (involvedVestingNotaryCond == true) {
593             chain.involvedVestingNotaryCond  = true;    
594         }
595         
596         if (participationNotaryCond == true) {
597             chain.participationNotaryCond    = true;
598         }
599         
600         if (maxNumOfValidators > 0) {
601             chain.maxNumOfValidators         = maxNumOfValidators;
602         }
603         
604         if (maxNumOfTransactors > 0) {
605             chain.maxNumOfTransactors        = maxNumOfTransactors;
606         }
607         
608         if (rewardBonusRequiredVesting > 0) {
609             chain.rewardBonusRequiredVesting = rewardBonusRequiredVesting;
610             chain.rewardBonusPercentage      = rewardBonusPercentage;
611         }
612         
613         emit NewChain(chainId, description, initEndpoint);
614         
615         nextId++;
616     }
617     
618     /**
619      * @notice Sets some of the static chain details. Only chain creator can call this method
620      *
621      * @param chainId       ChainId that sender wants to interact with
622      * @param description   New chain description (e.g name, short purpose description, etc...)
623      * @param endpoint      New chain endpoint, might be a website with chain description, condition to join and nodes ip:port addresses that can be used fo joining
624      **/
625     function setChainStaticDetails(uint256 chainId, string calldata description, string calldata endpoint) external {
626         ChainInfo storage chain = chains[chainId];
627         require(msg.sender == chain.creator, "Only chain creator can call this method");
628     
629         require(bytes(description).length <= MAX_DESCRIPTION_LENGTH,   "Chain description length must be: > 0 && <= MAX_DESCRIPTION_LENGTH(200)");
630         require(bytes(endpoint).length <= MAX_URL_LENGTH,              "Chain endpoint length must be: > 0 && <= MAX_URL_LENGTH(100)");
631         
632         if (bytes(description).length > 0) {
633             chain.description = description;
634         }
635         if (bytes(endpoint).length > 0) {
636             chain.endpoint = endpoint;
637         }
638     }
639     
640     /**
641      * @notice Returns chain static details (those that do not change).
642      *
643      * @param chainId                         ChainId that sender wants to interact with
644      * 
645      * @return description                   Description of the chain (e.g name, short purpose description, etc...)
646      * @return endpoint                      Chain endpoint, might be a website with chain description, condition to join and nodes ip:port addresses that can be used fo joining
647      * @return registered                    Flag if chain with specified chainId is registered
648      * @return minRequiredDeposit            Min.required deposit to become transactor (user). 
649      *                                        On top of this condition, chain creator might implement more sophisticated condition in external validator contract
650      * @return minRequiredVesting            Min.required deposit to become validator.
651      *                                        On top of this condition, chain creator might implement more sophisticated condition in external validator contract
652      * @return rewardBonusRequiredVesting    Min. required vesting balance for bonus reward to be applied.
653      *                                        In case rewardBonusRequiredVesting == 0, there is no reward bonus fot this chain
654      * @return rewardBonusPercentage         Reward bonus (percentage) to be applied if validator's vesting balance >= rewardBonusRequiredVesting.
655      * @return notaryPeriod                  Notary period in blocks (1 block every 5s), it is basically time interval notary periodic calls where users consumptions are processed and rewards distributed. 
656      * @return maxNumOfValidators            Max. number of active validators (those who vested and started mining).
657      *                                        On top of this condition, chain creator might implement more sophisticated condition in external validator contract
658      *                                        0 means unlimited
659      * @return maxNumOfTransactors           Max. number of transactors/users (those who deposited.
660      *                                        On top of this condition, chain creator might implement more sophisticated condition in external validator contract
661      *                                        0 means unlimited
662      * @return involvedVestingNotaryCond     Flag, if 50% invloved vesting condition is checked during notary. It means that vesting balances sum of those validators, who signed statistics 
663      *                                        sent to the notary must be > 50% of the sum of all active validators vesting balances on chain 
664      * @return participationNotaryCond       Flag, 2/3 + 1 participation condition is checked during notary. It means that more or equal to 2/3+1 of all active validators on chain 
665      *                                        must sign statistics sent to the notary for notary to be accepted 
666      **/
667     function getChainStaticDetails(uint256 chainId) external view returns (string memory description, string memory endpoint, bool registered, uint256 minRequiredDeposit, uint256 minRequiredVesting, 
668                                                                            uint256 rewardBonusRequiredVesting, uint256 rewardBonusPercentage, uint256 notaryPeriod, uint256 maxNumOfValidators, 
669                                                                            uint256 maxNumOfTransactors, bool involvedVestingNotaryCond, bool participationNotaryCond) {
670         ChainInfo storage chain = chains[chainId];
671         
672         description                 = chain.description;
673         endpoint                    = chain.endpoint;
674         registered                  = chain.registered;
675         minRequiredDeposit          = chain.minRequiredDeposit;
676         minRequiredVesting          = chain.minRequiredVesting;
677         rewardBonusRequiredVesting  = chain.rewardBonusRequiredVesting;
678         rewardBonusPercentage       = chain.rewardBonusPercentage;
679         notaryPeriod                = chain.notaryPeriod;
680         maxNumOfValidators          = chain.maxNumOfValidators;
681         maxNumOfTransactors         = chain.maxNumOfTransactors;
682         involvedVestingNotaryCond   = chain.involvedVestingNotaryCond;
683         participationNotaryCond     = chain.participationNotaryCond;
684     }
685     
686     /**
687      * @notice Returns dynamic chain details
688      *
689      * @param chainId                    ChainId that sender wants to interact with
690      * 
691      * @return active                    Flag if chain is active. 
692      *                                   True if there is > 0 active validatoes and there was successfull notary processed during last CHAIN_INACTIVITY_TIMEOUT (7 days), otherwise false
693      * @return totalVesting              Actual chain total vesting - sum of all active validators vesting balance 
694      * @return validatorsCount           Number of chain active validators
695      * @return transactorsCount          Number of chain whitelisted transactors (their deposit balance >= min. required deposit)
696      * @return lastValidatorVesting      Vesting of the last active validator (with the smallest vesting balance among all active validators). He is to be
697      *                                    by anyone who vests more and want to become validator
698      * @return lastNotaryBlock           Last processed block from Lition blockchain network during the last notary
699      * @return lastNotaryTimestamp       Time of the last notary
700      **/
701     function getChainDynamicDetails(uint256 chainId) public view returns (bool active, uint256 totalVesting, uint256 validatorsCount, uint256 transactorsCount,
702                                                                           uint256 lastValidatorVesting, uint256 lastNotaryBlock, uint256 lastNotaryTimestamp) {
703         ChainInfo storage chain = chains[chainId];
704         
705         active               = chain.active;
706         totalVesting         = chain.totalVesting;
707         validatorsCount      = chain.validators.list.length;
708         transactorsCount     = chain.actNumOfTransactors;
709         lastValidatorVesting = chain.usersData[chain.lastValidator].validator.vesting;   
710         lastNotaryBlock      = chain.lastNotary.block;
711         lastNotaryTimestamp  = chain.lastNotary.timestamp;
712     }
713     
714     /**
715      * @notice Returns user details
716      *
717      * @param chainId                           ChainId that sender wants to interact with
718      * @param acc                               Account to get details about
719      * 
720      * @return deposit                         Actual deposit balance
721      * @return whitelisted                     Flag if user is allowed to transact (his deposit balance >= min. requred deposit)
722      * @return vesting                         Actual veseting balance
723      * @return lastVestingIncreaseTime         Last time, when validator increased his vesting. Validators then have to wait VESTING_LOCKUP_TIMEOUT (14 days)
724      *                                          since lastVestingIncreaseTime before they can withraw full or just part of the vesting
725      * @return mining                          Flag if user validator is actively mining (called startMining method)
726      * @return prevNotaryMined                 Flag if validator mined at least one block during the previous notary window
727      * @return vestingReqExist                 Flag if there is onoging request for vesting increse or full withdrawal
728      * @return vestingReqNotary                Last known block accepted by notary in time when vesting request was created
729      * @return vestingReqValue                 New value of vesting specified in request
730      * @return depositFullWithdrawalReqExist   Flag if there is onoging request for deposit full withdrawal
731      * @return depositReqNotary                Last known block accepted by notary in time when deposit withdrawal request was created
732      **/
733     function getUserDetails(uint256 chainId, address acc) external view returns (uint256 deposit, bool whitelisted, 
734                                                                                  uint256 vesting, uint256 lastVestingIncreaseTime, bool mining, bool prevNotaryMined,
735                                                                                  bool vestingReqExist, uint256 vestingReqNotary, uint256 vestingReqValue,
736                                                                                  bool depositFullWithdrawalReqExist, uint256 depositReqNotary) {
737         ChainInfo storage chain = chains[chainId];
738         User storage user       = chain.usersData[acc];
739          
740         deposit                 = user.transactor.deposit;
741         whitelisted             = user.transactor.whitelisted;
742         vesting                 = user.validator.vesting;
743         lastVestingIncreaseTime = user.validator.lastVestingIncreaseTime;
744         mining                  = activeValidatorExist(chain, acc);
745         prevNotaryMined         = user.validator.currentNotaryMined;  
746         
747         if (vestingRequestExist(chain, acc)) {
748             vestingReqExist            = true;
749             vestingReqNotary           = user.validator.vestingRequest.notaryBlock;
750             vestingReqValue            = user.validator.vestingRequest.newVesting;
751         }
752         
753         if (depositWithdrawalRequestExist(chain, acc)) {
754             depositFullWithdrawalReqExist  = true;
755             depositReqNotary               = user.transactor.depositWithdrawalRequest.notaryBlock;
756         }
757     }
758     
759     /**
760      * @notice Notarization function - calculates user consumption as well as validators rewards. First, calculate hash from statistics sent to the notary, then, 
761      *        do ec_recover of the signatures to determine signers, checks if there is enough signers (total vesting of signers > 50% of all vestings) or total num of signes >= 2/3+1 out of all validators
762      *        and calculates users consuptions and validators rewards. Consuptions are deducted from the transactors deposit balances and rewards are added to the validators vesting balances.
763      *        In case chain.active flag is false, it sets it to true.
764      *        All active validators, who did not mine at least 1 block during last 2 notary windows are automatically removed from list of active validators
765      * 
766      * @param chainId          ChainId that sender wants to interact with
767      * @param notaryStartBlock Start block of statistics from Lition blockchain network     
768      * @param notaryEndBlock   End block of statistics from Lition blockchain network    
769      * @param validators       List of validators from Lition blockchain network
770      * @param blocksMined      List of mined blocks counts by validators 
771      * @param users            List of users (transactors) from Lition blockchain network
772      * @param userGas          List of users sums of gas consumption for all transactions they sent 
773      * @param largestTx        Gas consumption of the largest (most expensive) transaction in statistics 
774      * @param v, r, s          Parts of ecc signatures
775      * 
776      * @dev MiningReward(uint256 indexed chainId, address indexed account, uint256 reward) for each calculated reward
777      * @dev Notary(uint256 indexed chainId, uint256 lastBlock, uint256 blocksProcessed) at the end of notary
778      **/
779     function notary(uint256 chainId, uint256 notaryStartBlock, uint256 notaryEndBlock, address[] memory validators, uint32[] memory blocksMined,
780                     address[] memory users, uint64[] memory userGas, uint64 largestTx,
781                     uint8[] memory v, bytes32[] memory r, bytes32[] memory s) public {
782                   
783         ChainInfo storage chain = chains[chainId];
784         require(chain.registered    == true,                            "Invalid chain data: Non-registered chain");
785         require(validatorExist(chain, msg.sender) == true,              "Sender must have vesting balance > 0");
786         require(chain.totalVesting  > 0,                                "Current chain total_vesting == 0, there are no active validators");
787         
788         require(validators.length       > 0,                            "Invalid statistics data: validators.length == 0");
789         require(validators.length       == blocksMined.length,          "Invalid statistics data: validators.length != num of block mined");
790         if (chain.maxNumOfValidators != 0) {
791             require(validators.length   <= chain.maxNumOfValidators,    "Invalid statistics data: validators.length > maxNumOfValidators");
792             require(v.length            <= chain.maxNumOfValidators,    "Invalid statistics data: signatures.length > maxNumOfValidators");
793         }
794         
795         if (chain.maxNumOfTransactors != 0) {
796             require(users.length    <= chain.maxNumOfTransactors,   "Invalid statistics data: users.length > maxNumOfTransactors");
797         }
798         require(users.length        > 0,                            "Invalid statistics data: users.length == 0");
799         require(users.length        == userGas.length,              "Invalid statistics data: users.length != usersGas.length");
800         
801         require(v.length            == r.length,                    "Invalid statistics data: v.length != r.length");
802         require(v.length            == s.length,                    "Invalid statistics data: v.length != s.length");
803         require(notaryStartBlock    >  chain.lastNotary.block,      "Invalid statistics data: notaryBlock_start <= last known notary block");
804         require(notaryEndBlock      >  notaryStartBlock,            "Invalid statistics data: notaryEndBlock <= notaryStartBlock");
805         require(largestTx           >  0,                           "Invalid statistics data: Largest tx <= 0");
806         
807         bytes32 signatureHash = keccak256(abi.encodePacked(notaryEndBlock, validators, blocksMined, users, userGas, largestTx));
808         
809         // Validates notary conditions(involvedVesting && participation) to statistics to be accepted
810         validateNotaryConditions(chain, signatureHash, v, r, s);
811         
812         // Calculates total cost based on user's usage durint current notary window
813         uint256 totalCost = processUsersConsumptions(chain, users, userGas, largestTx);
814         
815         // In case totalCost == 0, something is wrong and there is no need for notary to continue as there is no tokens to be distributed to the validators.
816         // There is probably ongoing coordinated attack based on invalid statistics sent to the notary
817         require(totalCost > 0, "Invalid statistics data: users totalUsageCost == 0");
818         
819         // How many block could validator mined since the last notary in case he did sign every possible block 
820         uint256 maxBlocksMined = (notaryEndBlock - notaryStartBlock) + 1;
821         
822         // Calculates total involved vesting from provided list of validators and removes all validators that did not mine during last 2 notyary windows
823         uint256 totalInvolvedVesting = processNotaryValidators(chain, validators, blocksMined, maxBlocksMined);
824         
825         // In case totalInvolvedVesting == 0, something is wrong and there is no need for notary to continue as rewards cannot be calculated. It might happen
826         // as edge case when the last validator stopped mining durint current notary window or there is ongoing coordinated attack based on invalid statistics sent to the notary
827         require(totalInvolvedVesting > 0, "totalInvolvedVesting == 0. Invalid statistics or 0 active validators left in the chain");
828         
829         // Calculates and process validator's rewards based on their participation rate and vesting balance
830         processValidatorsRewards(chain, totalInvolvedVesting, validators, blocksMined, maxBlocksMined, totalCost);
831         
832         // Updates info when the last notary was processed 
833         chain.lastNotary.block = notaryEndBlock;
834         chain.lastNotary.timestamp = now;
835         
836         if (chain.active == false) {
837             chain.active = true;
838         }
839         
840         emit Notary(chainId, notaryEndBlock, maxBlocksMined);
841     }
842     
843     /**
844      * @notice Manually resets last accepted notary block & timestamp. Only chain creator can call this method
845      *
846      * @param chainId           ChainId that sender wants to interact with
847      * @param resetBlock        New last accepted notary block number
848      * @param processRequests   Flag if notary block set in vesting/deposit requests should be set
849      * @param unvoteValidators  Flag if stopMining should be called for all active validators
850      **/
851     function resetNotary(uint256 chainId, uint256 resetBlock, bool processRequests, bool unvoteValidators) external {
852         ChainInfo storage chain = chains[chainId];
853         require(msg.sender == chain.creator, "Only chain creator can call this method");
854         
855         // Manually updates info when the last notary was processed 
856         uint256 lastValidBlock = chain.lastNotary.block;
857         chain.lastNotary.block = resetBlock;
858         
859         if (processRequests == true) {
860           bool end = false;
861           for (uint256 batch = 0; end == false; batch++) {
862               end = resetRequests(chainId, resetBlock, batch);
863           }
864         }
865         
866         if (unvoteValidators == true) {
867             removeValidators(chainId, chain.validators.list);
868         }
869     
870         emit NotaryReset(chainId, lastValidBlock, resetBlock);               
871     }
872     
873     /**
874      * @notice Manually removes validators from list of active validators(stop Mining is called)
875      *
876      * @param chainId       ChainId that sender wants to interact with
877      * @param validators    List of validators (their addresses) to beremoved from list of active validators
878      **/
879     function removeValidators(uint256 chainId, address[] memory validators) public {
880         ChainInfo storage chain = chains[chainId];
881         require(msg.sender == chain.creator, "Only chain creator can call this method");
882         
883         for (uint256 i = 0; i < validators.length; i++) {
884             if (activeValidatorExist(chain, validators[i]) == true) {
885                 activeValidatorRemove(chain, validators[i]);
886             }
887         }
888     }
889     
890     /**
891      * @notice Manually resets notary block in vesting/deposit requests of users. Only chain creator can call this method
892      *
893      * @param chainId       ChainId that sender wants to interact with
894      * @param resetBlock    New notary to be set in requests
895      * @param batch         Batch number to be fetched. If the list is too big it cannot return all validators in one call. Instead, users are fetching batches of 100 account at a time 
896      *
897      * @return end          Flag if there are no more users(their requests) to be processed left. To get all users, caller should fetch all batches until he sees end == true
898      **/
899     function resetRequests(uint256 chainId, uint256 resetBlock, uint256 batch) public returns (bool end) {
900         ChainInfo storage chain = chains[chainId];
901         require(msg.sender == chain.creator, "Only chain creator can call this method");
902         
903         uint256 usersTotalCount = chain.users.list.length;
904         uint256 i;
905         for(i = batch * 100; i < (batch + 1)*100 && i < usersTotalCount; i++) {
906             User storage user = chain.usersData[chain.users.list[i]];
907             
908             if (user.transactor.depositWithdrawalRequest.exist == true) {
909               user.transactor.depositWithdrawalRequest.notaryBlock = resetBlock;
910             }
911             
912             if (user.validator.vestingRequest.exist == true) {
913               user.validator.vestingRequest.notaryBlock = resetBlock;
914             }
915         }
916         
917         if (i >= usersTotalCount) {
918             end = true;
919         }
920         else {
921             end = false;
922         }
923     }
924     
925     /**
926      * @notice Returns list of transactors (users) that are allowed to transact - their deposit >= min. required deposit (their accounts)
927      *
928      * @param chainId       ChainId that sender wants to interact with
929      * @param batch         Batch number to be fetched. If the list is too big it cannot return all validators in one call. Instead, users are fetching batches of 100 account at a time 
930      * 
931      * @return validators  List(batch of 100) of account
932      * @return count       How many accounts are returned in specified batch
933      * @return end         Flag if there are no more accounts left. To get all accounts, caller should fetch all batches until he sees end == true
934      **/
935     function getTransactors(uint256 chainId, uint256 batch) external view returns (address[100] memory transactors, uint256 count, bool end) {
936         return getUsers(chains[chainId], true, batch);
937     }
938     
939     /**
940      * @notice Returns list of active and non-active validators (their accounts)
941      *
942      * @param chainId       ChainId that sender wants to interact with
943      * @param batch         Batch number to be fetched. If the list is too big it cannot return all validators in one call. Instead, users are fetching batches of 100 account at a time 
944      * 
945      * @return validators  List(batch of 100) of account
946      * @return count       How many accounts are returned in specified batch
947      * @return end         Flag if there are no more accounts left. To get all accounts, caller should fetch all batches until he sees end == true
948      **/
949     function getAllowedToValidate(uint256 chainId, uint256 batch) view external returns (address[100] memory validators, uint256 count, bool end) {
950         return getUsers(chains[chainId], false, batch);
951     }
952     
953     /**
954      * @notice Returns list of active validators (their accounts)
955      *
956      * @param chainId       ChainId that sender wants to interact with
957      * @param batch         Batch number to be fetched. If the list is too big it cannot return all validators in one call. Instead, users are fetching batches of 100 account at a time 
958      * 
959      * @return validators  List(batch of 100) of account
960      * @return count       How many accounts are returned in specified batch
961      * @return end         Flag if there are no more accounts left. To get all accounts, caller should fetch all batches until he sees end == true
962      **/
963     function getValidators(uint256 chainId, uint256 batch) view external returns (address[100] memory validators, uint256 count, bool end) {
964         ChainInfo storage chain = chains[chainId];
965         
966         count = 0;
967         uint256 validatorsTotalCount = chain.validators.list.length;
968         
969         address acc;
970         uint256 i;
971         for(i = batch * 100; i < (batch + 1)*100 && i < validatorsTotalCount; i++) {
972             acc = chain.validators.list[i];
973             
974             validators[count] = acc;
975             count++;
976         }
977         
978         if (i >= validatorsTotalCount) {
979             end = true;
980         }
981         else {
982             end = false;
983         }
984     }
985     
986     /**
987      * @notice Sets mining validator's mining flag to true and emit event so other nodes vote him
988      *
989      * @param chainId ChainId that sender wants to interact with
990      * 
991      * @dev AccountMining(uint256 indexed chainId, address indexed account, bool mining) event with mining == true
992      **/
993     function startMining(uint256 chainId) external {
994         ChainInfo storage chain = chains[chainId];
995         address acc = msg.sender;
996         uint256 validatorVesting = chain.usersData[acc].validator.vesting;
997         
998         require(chain.registered == true,                         "Non-registered chain");
999         require(validatorExist(chain, acc) == true,               "Non-existing validator (0 vesting balance)");
1000         require(vestingRequestExist(chain, acc) == false,         "Cannot start mining - there is ongoing vesting request");
1001         
1002         if (chain.chainValidator != ChainValidator(0)) {
1003             require(chain.chainValidator.validateNewValidator(validatorVesting, acc, true /* mining */, chain.validators.list.length) == true, "Validator not allowed by external chainvalidator SC");
1004         }
1005         
1006         if (activeValidatorExist(chain, acc) == true) {
1007             // Emit event even if validator is already active - user might want to explicitely emit this event in case something went wrong on the nodes and
1008             // others did not vote him
1009             emit AccountMining(chainId, acc, true);
1010             
1011             return;
1012         }
1013             
1014         // Upper limit of validators reached
1015         if (chain.maxNumOfValidators != 0 && chain.validators.list.length >= chain.maxNumOfValidators) {
1016             require(validatorVesting > chain.usersData[chain.lastValidator].validator.vesting, "Upper limit of validators reached. Must vest more than the last validator to replace him");
1017             activeValidatorReplace(chain, acc);
1018         }
1019         // There is still empty place for new validator
1020         else {
1021             activeValidatorInsert(chain, acc);
1022         }
1023     }
1024   
1025     /**
1026      * @notice Sets mining validator's mining flag to false and emit event so other nodes unvote. In case stopMining is called 
1027      *        by the last active validator, so there is 0 active validators left, it sets chain.active flag to false 
1028      *
1029      * @param chainId ChainId that sender wants to interact with
1030      * 
1031      * @dev AccountMining(uint256 indexed chainId, address indexed account, bool mining) event with mining == false
1032      **/
1033     function stopMining(uint256 chainId) external {
1034         ChainInfo storage chain = chains[chainId];
1035         address acc = msg.sender;
1036         
1037         require(chain.registered == true, "Non-registered chain");
1038         require(validatorExist(chain, acc) == true, "Non-existing validator (0 vesting balance)");
1039     
1040         if (activeValidatorExist(chain, acc) == false) {
1041             // Emit event even if validator is already inactive - user might want to explicitely emit this event in case something went wrong on the nodes and
1042             // others did not unvote him
1043             emit AccountMining(chainId, acc, false);
1044             
1045             return;
1046         }
1047         
1048         activeValidatorRemove(chain, acc);
1049     }
1050     
1051 
1052     /**************************************************************************************************************************/
1053     /**************************************** Functions related to the list of users ******************************************/
1054     /**************************************************************************************************************************/
1055     
1056     // Adds acc from the map
1057     function insertAcc(IterableMap storage map, address acc) internal {
1058         map.list.push(acc);
1059         // indexes are stored + 1   
1060         map.listIndex[acc] = map.list.length;
1061     }
1062     
1063     // Removes acc from the map
1064     function removeAcc(IterableMap storage map, address acc) internal {
1065         uint256 index = map.listIndex[acc];
1066         require(index > 0 && index <= map.list.length, "RemoveAcc invalid index");
1067         
1068         // Move an last element of array into the vacated key slot.
1069         uint256 foundIndex = index - 1;
1070         uint256 lastIndex  = map.list.length - 1;
1071     
1072         map.listIndex[map.list[lastIndex]] = foundIndex + 1;
1073         map.list[foundIndex] = map.list[lastIndex];
1074         map.list.length--;
1075     
1076         // Deletes element
1077         map.listIndex[acc] = 0;
1078     }
1079     
1080     // Returns true, if acc exists in the iterable map, otherwise false
1081     function existAcc(IterableMap storage map, address acc) internal view returns (bool) {
1082         return map.listIndex[acc] != 0;
1083     }
1084     
1085     // Inits validator data holder in the users mapping and inserts it into the list of users
1086     function validatorCreate(ChainInfo storage chain, address acc, uint256 vesting) internal {
1087         Validator storage validator     = chain.usersData[acc].validator;
1088         
1089         validator.vesting                   = vesting;
1090         validator.lastVestingIncreaseTime   = now;
1091         // Inits previously notary windows as mined so validator does not get removed from the list of actively mining validators right after the creation
1092         validator.currentNotaryMined        = true;
1093         validator.prevNotaryMined           = true;
1094         
1095         
1096         // No need to check if validatorExist for the same acc as it is not possible to have vesting > 0 & deosit > 0 at the same time
1097         insertAcc(chain.users, acc);
1098     }
1099     
1100     // Deinits validator data holder in the users mapping and removes it from the list of users
1101     function validatorDelete(ChainInfo storage chain, address acc) internal {
1102         Validator storage validator = chain.usersData[acc].validator;
1103         
1104         if (activeValidatorExist(chain, acc) == true) {
1105             activeValidatorRemove(chain, acc);
1106         }
1107         
1108         validator.vesting                   = 0;
1109         validator.lastVestingIncreaseTime   = 0;
1110         validator.currentNotaryMined        = false;
1111         validator.prevNotaryMined           = false;
1112         
1113         // No need to check if transactorExist for the same acc as it is not possible to have vesting > 0 & deosit > 0 at the same time
1114         removeAcc(chain.users, acc);
1115     }
1116     
1117     // Inserts validator into the list of actively mining validators
1118     function activeValidatorInsert(ChainInfo storage chain, address acc) internal {
1119         Validator storage validator = chain.usersData[acc].validator;
1120         
1121         // Updates lastValidator in case this is first validator or new validator's vesting balance is less
1122         if (chain.validators.list.length == 0 || validator.vesting <= chain.usersData[chain.lastValidator].validator.vesting) {
1123             chain.lastValidator = acc;
1124         }
1125         
1126         insertAcc(chain.validators, acc);   
1127         
1128         // Updates chain total vesting
1129         chain.totalVesting = chain.totalVesting.add(validator.vesting);
1130         
1131         emit AccountMining(chain.id, acc, true);
1132     }
1133     
1134     // Removes validator from the list of actively mining validators
1135     function activeValidatorRemove(ChainInfo storage chain, address acc) internal {
1136         Validator storage validator = chain.usersData[acc].validator;
1137         
1138         removeAcc(chain.validators, acc);   
1139         
1140         // Updates chain total vesting
1141         chain.totalVesting = chain.totalVesting.sub(validator.vesting);
1142         
1143         // If there is no active validator left, set chain.active flag to false so others might vest in chain without
1144         // waiting for the next notary window to be processed
1145         if (chain.validators.list.length == 0) {
1146             chain.active = false;
1147             chain.lastValidator = address(0x0);
1148         }
1149         // There are still some active validators left
1150         else {
1151             // If lastValidator is being removed, find a new validator with the smallest vesting balance
1152             if (chain.lastValidator == acc) {
1153                 resetLastActiveValidator(chain);
1154             }
1155         }
1156         
1157         emit AccountMining(chain.id, acc, false);
1158     }
1159     
1160     // Replaces lastValidator for the new one in the list of actively mining validators
1161     function activeValidatorReplace(ChainInfo storage chain, address acc) internal {
1162         address accToBeReplaced                 = chain.lastValidator;
1163         Validator memory validatorToBeReplaced  = chain.usersData[accToBeReplaced].validator;
1164         Validator memory newValidator           = chain.usersData[acc].validator;
1165         
1166         // Updates chain total vesting
1167         chain.totalVesting = chain.totalVesting.sub(validatorToBeReplaced.vesting);
1168         chain.totalVesting = chain.totalVesting.add(newValidator.vesting);
1169         
1170         // Updates active validarors list
1171         removeAcc(chain.validators, accToBeReplaced);
1172         insertAcc(chain.validators, acc);
1173         
1174         // Finds a new validator with the smallest vesting balance
1175         resetLastActiveValidator(chain);
1176         
1177         emit AccountMining(chain.id, accToBeReplaced, false);
1178         emit AccountMining(chain.id, acc, true);
1179     }
1180     
1181     // Resets last validator - the one with the smallest vesting balance
1182     function resetLastActiveValidator(ChainInfo storage chain) internal {
1183         address foundLastValidatorAcc     = chain.validators.list[0];
1184         uint256 foundLastValidatorVesting = chain.usersData[foundLastValidatorAcc].validator.vesting;
1185         
1186         address actValidatorAcc;
1187         uint256 actValidatorVesting;
1188         for (uint256 i = 1; i < chain.validators.list.length; i++) {
1189             actValidatorAcc     = chain.validators.list[i];
1190             actValidatorVesting = chain.usersData[actValidatorAcc].validator.vesting;
1191             
1192             if (actValidatorVesting <= foundLastValidatorVesting) {
1193                 foundLastValidatorAcc     = actValidatorAcc;
1194                 foundLastValidatorVesting = actValidatorVesting;
1195             }
1196         }
1197         
1198         chain.lastValidator = foundLastValidatorAcc;
1199     }
1200     
1201     // Returns true, if acc is in the list of actively mining validators, otherwise false
1202     function activeValidatorExist(ChainInfo storage chain, address acc) internal view returns (bool) {
1203         return existAcc(chain.validators, acc);
1204     }
1205     
1206     // Returns true, if acc hase vesting > 0, otherwise false
1207     function validatorExist(ChainInfo storage chain, address acc) internal view returns (bool) {
1208         return chain.usersData[acc].validator.vesting > 0;
1209     }
1210     
1211     // Inits transactor data holder in the users mapping and inserts it into the list of users
1212     function transactorCreate(ChainInfo storage chain, address acc, uint256 deposit) internal {
1213         Transactor storage transactor = chain.usersData[acc].transactor;
1214         
1215         transactor.deposit = deposit;
1216         transactorWhitelist(chain, acc);
1217         
1218         // No need to check if validatorExist for the same acc as it is not possible to have vesting > 0 & deosit > 0 at the same time
1219         insertAcc(chain.users, acc);
1220     }
1221     
1222     // Deinits transactor data holder in the users mapping and removes it from the list of users
1223     function transactorDelete(ChainInfo storage chain, address acc) internal {
1224         Transactor storage transactor = chain.usersData[acc].transactor;
1225         
1226         transactor.deposit = 0;
1227         transactorBlacklist(chain, acc);
1228         
1229         // No need to check if validatorExist for the same acc as it is not possible to have vesting > 0 & deosit > 0 at the same time
1230         removeAcc(chain.users, acc);
1231     }
1232     
1233     // Returns true, if acc hase deposit > 0, otherwise false
1234     function transactorExist(ChainInfo storage chain, address acc) internal view returns (bool) {
1235         return chain.usersData[acc].transactor.deposit > 0;
1236     }
1237     
1238     // Blacklists transactor
1239     function transactorBlacklist(ChainInfo storage chain, address acc) internal {
1240         Transactor storage transactor   = chain.usersData[acc].transactor;
1241         
1242         if (transactor.whitelisted == true) {
1243             chain.actNumOfTransactors--;
1244             
1245             transactor.whitelisted = false;
1246             emit AccountWhitelisted(chain.id, acc, false);
1247         }
1248     }
1249     
1250     // Whitelists transactor
1251     function transactorWhitelist(ChainInfo storage chain, address acc) internal {
1252         Transactor storage transactor   = chain.usersData[acc].transactor;
1253         
1254         if (transactor.whitelisted == false) {
1255             chain.actNumOfTransactors++;
1256             
1257             transactor.whitelisted = true;
1258             emit AccountWhitelisted(chain.id, acc, true);
1259         }
1260     }
1261     
1262     // Returns list of users
1263     function getUsers(ChainInfo storage chain, bool transactorsFlag, uint256 batch) internal view returns (address[100] memory users, uint256 count, bool end) {
1264         count = 0;
1265         uint256 usersTotalCount = chain.users.list.length;
1266         
1267         address acc;
1268         uint256 i;
1269         for(i = batch * 100; i < (batch + 1)*100 && i < usersTotalCount; i++) {
1270             acc = chain.users.list[i];
1271             
1272             // Get transactors (only those who are whitelisted - their depist passed min.required conditions)
1273             if (transactorsFlag == true) {
1274                 if (chain.usersData[acc].transactor.whitelisted == false) {
1275                     continue;
1276                 } 
1277             }
1278             // Get validators (active and non-active)
1279             else {
1280                 if (chain.usersData[acc].validator.vesting == 0) {
1281                     continue;
1282                 }
1283             }
1284             
1285             users[count] = acc;
1286             count++;
1287         }
1288         
1289         if (i >= usersTotalCount) {
1290             end = true;
1291         }
1292         else {
1293             end = false;
1294         }
1295     }
1296     
1297     /**************************************************************************************************************************/
1298     /*********************************** Functions related to the vesting/deposit requests ************************************/
1299     /**************************************************************************************************************************/
1300     
1301     // Creates new vesting request
1302     function vestingRequestCreate(ChainInfo storage chain, address acc, uint256 vesting) internal {
1303         VestingRequest storage request = chain.usersData[acc].validator.vestingRequest;
1304         
1305         request.exist       = true;
1306         request.newVesting  = vesting;
1307         request.notaryBlock = chain.lastNotary.block; 
1308     }
1309 
1310     // Creates new deposit withdrawal request
1311     function depositWithdrawalRequestCreate(ChainInfo storage chain, address acc) internal {
1312         DepositWithdrawalRequest storage request = chain.usersData[acc].transactor.depositWithdrawalRequest;
1313         
1314         request.exist       = true;
1315         request.notaryBlock = chain.lastNotary.block; 
1316     }
1317     
1318     function vestingRequestDelete(ChainInfo storage chain, address acc) internal {
1319         // There is ongoing deposit request for this account - only reset vesting request
1320         VestingRequest storage request = chain.usersData[acc].validator.vestingRequest;
1321         request.exist          = false;
1322         request.notaryBlock    = 0;
1323         request.newVesting     = 0;
1324     }
1325     
1326     function depositWithdrawalRequestDelete(ChainInfo storage chain, address acc) internal {
1327         // There is ongoing vesting request for this account - only reset vesting request
1328         DepositWithdrawalRequest storage request = chain.usersData[acc].transactor.depositWithdrawalRequest;
1329         request.exist          = false;
1330         request.notaryBlock    = 0;
1331     }
1332     
1333     // Checks if acc has any ongoing vesting request
1334     function vestingRequestExist(ChainInfo storage chain, address acc) internal view returns (bool) {
1335         return chain.usersData[acc].validator.vestingRequest.exist;
1336     }
1337     
1338     // Checks if acc has any ongoing DEPOSIT WITHDRAWAL request
1339     function depositWithdrawalRequestExist(ChainInfo storage chain, address acc) internal view returns (bool) {
1340         return chain.usersData[acc].transactor.depositWithdrawalRequest.exist;
1341     }
1342     
1343     // Full vesting withdrawal  and vesting increase are procesed in 2 steps with confirmaition
1344     // Immediate full withdrawal is not allowed as validators might already mine some blocks so they can get rewards 
1345     // based on theirs vesting balance for that
1346     function requestVest(ChainInfo storage chain, uint256 vesting, address acc) internal {
1347         Validator storage validator = chain.usersData[acc].validator;
1348         
1349         uint256 validatorVesting = validator.vesting;
1350         
1351         // Vesting increase - process in 2 steps
1352         if (vesting > validatorVesting) {
1353             uint256 toVest = vesting - validatorVesting;
1354             token.transferFrom(acc, address(this), toVest);
1355         }
1356         // Vesting decrease - process immediately
1357         else if (vesting != 0) {
1358             uint256 toWithdraw = validatorVesting - vesting;
1359             
1360             validator.vesting = vesting;    
1361             
1362             // If validator is actively mining, decrease chain's total vesting
1363             if (activeValidatorExist(chain, acc) == true) {
1364                 chain.totalVesting = chain.totalVesting.sub(toWithdraw);
1365                 
1366                 // Updates lastValidator in case it is needed - if user is decreasing vesting and there ist last validator 
1367                 // with the same amount of tokens, keep him as last one because he had lower vesting for more time
1368                 if (acc != chain.lastValidator && validator.vesting < chain.usersData[chain.lastValidator].validator.vesting) {
1369                     chain.lastValidator = acc;
1370                 }
1371             }
1372             
1373             // Transfers tokens
1374             token.transfer(acc, toWithdraw);
1375             
1376             emit VestInChain(chain.id, acc, vesting, chain.lastNotary.block, true);
1377             return;
1378         }
1379         // else full vesting withdrawal - process in 2 steps
1380         
1381         vestingRequestCreate(chain, acc, vesting);
1382         emit VestInChain(chain.id, acc, vesting, chain.usersData[acc].validator.vestingRequest.notaryBlock, false);
1383         
1384         return;
1385     }
1386     
1387     function confirmVest(ChainInfo storage chain, address acc) internal {
1388         Validator storage validator             = chain.usersData[acc].validator;
1389         VestingRequest memory request           = chain.usersData[acc].validator.vestingRequest;
1390         
1391         vestingRequestDelete(chain, acc);
1392         uint256 origVesting = validator.vesting;
1393         
1394         // Vesting increase
1395         if (request.newVesting > origVesting) {
1396             // Non-existing validator - internally creates new one
1397             if (validatorExist(chain, acc) == false) {
1398                 validatorCreate(chain, acc, request.newVesting);
1399             }
1400             // Existing validator
1401             else {
1402                 validator.vesting = request.newVesting;
1403                 validator.lastVestingIncreaseTime = now;
1404                 
1405                 if (activeValidatorExist(chain, acc) == true) {
1406                     chain.totalVesting = chain.totalVesting.add(request.newVesting - origVesting);
1407                     
1408                     // Updates last validator in case it is him who is increasing vesting balance
1409                     if (acc == chain.lastValidator) {
1410                         resetLastActiveValidator(chain);
1411                     }
1412                 }    
1413             }
1414         }
1415         // Full vesting withdrawal - stopMining must be called before
1416         else {
1417             uint256 toWithdraw = origVesting;
1418             validatorDelete(chain, acc);
1419             
1420             // Transfers tokens
1421             token.transfer(acc, toWithdraw);
1422         }
1423         
1424         emit VestInChain(chain.id, acc, request.newVesting, request.notaryBlock, true);
1425     }
1426     
1427     function requestDeposit(ChainInfo storage chain, uint256 deposit, address acc) internal {
1428         Transactor storage transactor = chain.usersData[acc].transactor;
1429         
1430         // If user wants to withdraw whole deposit
1431         if (deposit == 0) {
1432             depositWithdrawalRequestCreate(chain, acc);
1433             transactorBlacklist(chain, acc);
1434             emit DepositInChain(chain.id, acc, deposit, chain.usersData[acc].transactor.depositWithdrawalRequest.notaryBlock, false);  
1435           
1436             return;
1437         }
1438       
1439         // If user wants to deposit in chain, process it immediately
1440         uint256 actTransactorDeposit = transactor.deposit;
1441         
1442         if(actTransactorDeposit > deposit) {
1443             transactor.deposit = deposit;
1444          
1445             uint256 toWithdraw = actTransactorDeposit - deposit;
1446             token.transfer(acc, toWithdraw);
1447         } else {
1448             uint256 toDeposit = deposit - actTransactorDeposit;
1449             token.transferFrom(acc, address(this), toDeposit);
1450          
1451             // First deposit - create internally new user
1452             if (transactorExist(chain, acc) == false) {
1453                 transactorCreate(chain, acc, deposit);
1454             }
1455             else {
1456                 transactor.deposit = deposit;
1457                 transactorWhitelist(chain, acc);
1458             }
1459         }
1460         
1461         emit DepositInChain(chain.id, acc, deposit, chain.lastNotary.block, true);
1462     }
1463     
1464     function confirmDepositWithdrawal(ChainInfo storage chain, address acc) internal {
1465         Transactor storage transactor   = chain.usersData[acc].transactor;
1466         
1467         uint256 toWithdraw              = transactor.deposit;
1468         uint256 requestNotaryBlock      = transactor.depositWithdrawalRequest.notaryBlock;
1469         
1470         transactorDelete(chain, acc);
1471         depositWithdrawalRequestDelete(chain, acc);
1472         
1473         // Withdraw whole deposit
1474         token.transfer(acc, toWithdraw);
1475         
1476         emit DepositInChain(chain.id, acc, 0, requestNotaryBlock, true);
1477     }
1478     
1479     /**************************************************************************************************************************/
1480     /*************************************************** Other functions ******************************************************/
1481     /**************************************************************************************************************************/
1482 
1483     constructor(ERC20 _token) public {
1484         token = _token;
1485     }
1486   
1487     // Process users consumption based on their usage
1488     function processUsersConsumptions(ChainInfo storage chain, address[] memory users, uint64[] memory userGas, uint64 largestTxGas) internal returns (uint256 totalCost) {
1489         // Total usage cost in LIT tokens
1490         totalCost = 0;
1491         
1492         // Individual user's usage cost in LIT tokens
1493         uint256 userCost;
1494         
1495         uint256 transactorDeposit;
1496         address acc;
1497         for(uint256 i = 0; i < users.length; i++) {
1498             acc = users[i];
1499             Transactor storage transactor = chain.usersData[acc].transactor;
1500             transactorDeposit = transactor.deposit;
1501             
1502             // This can happen only if there is non-registered transactor(user) in statistics, which means that there is probaly
1503             // ongoing coordinated attack based on invalid statistics sent to the notary
1504             // Ignores non-registred user
1505             if (transactorExist(chain, acc) == false || userGas[i] == 0) {
1506                 // Let nodes know that this user is not allowed to transact only if chain is active - in case it is not and becomes active again 
1507                 // there might be some users that already withdrawed their deposit  
1508                 if (chain.active == true) {
1509                     emit AccountWhitelisted(chain.id, users[i], false);
1510                 }
1511                 continue;
1512             }
1513             
1514             userCost = (userGas[i] * LARGEST_TX_FEE) / largestTxGas;
1515             
1516             // This can happen only if user runs out of tokens(which should not happen due to min.required deposit)
1517             if(userCost > transactorDeposit ) {
1518                 userCost = transactorDeposit;
1519             
1520                 transactorDelete(chain, acc);
1521             }
1522             else {
1523                 transactorDeposit = transactorDeposit.sub(userCost);
1524                 
1525                 // Updates user's stored deposit balance based on his usage
1526                 transactor.deposit = transactorDeposit;
1527                 
1528                 // Check if user's deposit balance is >= min. required deposit conditions
1529                 if (transactorDeposit < chain.minRequiredDeposit) {
1530                     transactorBlacklist(chain, acc);
1531                 }
1532             }
1533             
1534             // Adds user's cost to the total cost
1535             totalCost = totalCost.add(userCost);
1536         }
1537     }
1538     
1539     // Calculates validators invloved total vesting and removes validators that did not mine at all during the last 2 notary windows
1540     function processNotaryValidators(ChainInfo storage chain, address[] memory validators, uint32[] memory blocksMined, uint256 maxBlocksMined) internal returns (uint256 totalInvolvedVesting) {
1541         // Array of flags if active validators mined this notary window 
1542         bool[] memory miningValidators = new bool[](chain.validators.list.length); 
1543         
1544         // Selected validator's account address, index and vesting balance
1545         address actValidatorAcc;
1546         uint256 actValidatorIdx;
1547         uint256 actValidatorVesting;
1548         
1549         for(uint256 i = 0; i < validators.length; i++) {
1550             actValidatorAcc = validators[i];
1551         
1552             // Validators, who are not actively mining anymore (their node probably crashed) do not receive no rewaeds
1553             if (activeValidatorExist(chain, actValidatorAcc) == false || blocksMined[i] == 0) {
1554                 continue;
1555             }
1556             
1557             actValidatorIdx = chain.validators.listIndex[actValidatorAcc] - 1;
1558             
1559             // In case there miningValidators[actValidatorIdx] is already true, it means the same validator address is twice in the statistics,
1560             // This should never happen, ignore such validators 
1561             if (miningValidators[actValidatorIdx] == true) {
1562                 continue;
1563             }
1564             else {
1565                 miningValidators[actValidatorIdx] = true;
1566             }
1567             
1568             actValidatorVesting = chain.usersData[actValidatorAcc].validator.vesting;
1569             
1570             // In case rewardBonusRequiredVesting is specified && actValidatorVesting is bigger, apply bonus
1571             if (chain.rewardBonusRequiredVesting > 0 && actValidatorVesting >= chain.rewardBonusRequiredVesting) {
1572                 actValidatorVesting = actValidatorVesting.mul(chain.rewardBonusPercentage + 100) / 100;
1573             }
1574             
1575             totalInvolvedVesting = totalInvolvedVesting.add(actValidatorVesting.mul(blocksMined[i])); 
1576         }
1577         totalInvolvedVesting /= maxBlocksMined;
1578 
1579         // Process miningValidators from statistics and set current validators(registered in sc as active validators) mining flags accordingly
1580         for(uint256 i = 0; i < chain.validators.list.length; i++) {
1581             actValidatorAcc = chain.validators.list[i];
1582             
1583             Validator storage validator = chain.usersData[actValidatorAcc].validator;
1584             validator.prevNotaryMined   = validator.currentNotaryMined;
1585             
1586             if (miningValidators[i] == true) {
1587                 validator.currentNotaryMined = true;
1588             }
1589             else {
1590                 validator.currentNotaryMined = false;
1591             }
1592         }
1593         
1594         // Deletes validators who did not mine in the last 2 notary windows 
1595         uint256 activeValidatorsCount = chain.validators.list.length; 
1596         for (uint256 i = 0; i < activeValidatorsCount; ) {
1597             actValidatorAcc = chain.validators.list[i];
1598             Validator memory validator = chain.usersData[actValidatorAcc].validator;
1599            
1600             if (validator.currentNotaryMined == true || validator.prevNotaryMined == true) {
1601                 i++;
1602                 continue;
1603             }
1604            
1605             activeValidatorRemove(chain, actValidatorAcc);
1606             activeValidatorsCount--;
1607         } 
1608      
1609         delete miningValidators;   
1610     }
1611 
1612     // Process validators rewards based on their participation rate(how many blocks they signed) and their vesting balance
1613     function processValidatorsRewards(ChainInfo storage chain, uint256 totalInvolvedVesting, address[] memory validators, uint32[] memory blocksMined, uint256 maxBlocksMined, uint256 litToDistribute) internal {
1614         // Array of flags if active validators mined this notary window 
1615         bool[] memory miningValidators = new bool[](chain.validators.list.length); 
1616         
1617         // Selected validator's account address and vesting balance
1618         address actValidatorAcc;
1619         uint256 actValidatorIdx;
1620         uint256 actValidatorVesting;
1621         uint256 actValidatorReward;
1622         
1623         // Whats left after all rewards are distributed (math rounding)
1624         uint256 litToDistributeRest = litToDistribute;
1625         
1626         // Runs through all validators and calculates their reward based on:
1627         //     1. How many blocks out of max_blocks_mined each validator signed
1628         //     2. How many token each validator vested
1629         for(uint256 i = 0; i < validators.length; i++) {
1630             actValidatorAcc = validators[i];
1631             
1632             // Validators, who are not actively mining anymore (their node probably crashed) do not receive no rewaeds
1633             if (activeValidatorExist(chain, actValidatorAcc) == false || blocksMined[i] == 0) {
1634                 continue;
1635             } 
1636             
1637             actValidatorIdx = chain.validators.listIndex[actValidatorAcc] - 1;
1638             
1639             // In case there miningValidators[actValidatorIdx] is already true, it means the same validator address is twice in the statistics,
1640             // This should never happen, ignore such validators 
1641             if (miningValidators[actValidatorIdx] == true) {
1642                 continue;
1643             }
1644             else {
1645                 miningValidators[actValidatorIdx] = true;
1646             }
1647             
1648             Validator storage actValidator = chain.usersData[actValidatorAcc].validator;
1649             actValidatorVesting = actValidator.vesting;
1650             
1651             // In case rewardBonusRequiredVesting is specified && actValidatorVesting is bigger, apply bonus
1652             if (chain.rewardBonusRequiredVesting > 0 && actValidatorVesting >= chain.rewardBonusRequiredVesting) {
1653                 actValidatorVesting = actValidatorVesting.mul(chain.rewardBonusPercentage + 100) / 100;
1654             }
1655         
1656             actValidatorReward = actValidatorVesting.mul(blocksMined[i]).mul(litToDistribute) / maxBlocksMined / totalInvolvedVesting;
1657             
1658             litToDistributeRest = litToDistributeRest.sub(actValidatorReward);
1659             
1660             // Add rewards to the validator's vesting balance
1661             actValidator.vesting = actValidator.vesting.add(actValidatorReward);
1662             
1663             emit MiningReward(chain.id, actValidatorAcc, actValidatorReward);
1664         }
1665         
1666         if(litToDistributeRest > 0) {
1667             // Add the rest(math rounding) to the validator, who called notary function
1668             Validator storage sender = chain.usersData[msg.sender].validator;
1669             
1670             sender.vesting = sender.vesting.add(litToDistributeRest);
1671             
1672             if (activeValidatorExist(chain, msg.sender) == false) {
1673                 chain.totalVesting = chain.totalVesting.sub(litToDistributeRest);
1674             }
1675             
1676             emit MiningReward(chain.id, msg.sender, litToDistributeRest);
1677         }
1678         
1679         // Updates chain total vesting
1680         chain.totalVesting = chain.totalVesting.add(litToDistribute); 
1681         
1682         // As validators vestings were updated, last validator might change so find a new one
1683         resetLastActiveValidator(chain);
1684 
1685         delete miningValidators;
1686     }
1687    
1688    // Validates notary conditions(involvedVesting && participation) to statistics to be accepted
1689     function validateNotaryConditions(ChainInfo storage chain, bytes32 signatureHash, uint8[] memory v, bytes32[] memory r, bytes32[] memory s) internal view {
1690         uint256 involvedVestingSum = 0;
1691         uint256 involvedSignaturesCount = 0;
1692         
1693         bool[] memory signedValidators = new bool[](chain.validators.list.length); 
1694         
1695         address signerAcc;
1696         for(uint256 i = 0; i < v.length; i++) {
1697             signerAcc = ecrecover(signatureHash, v[i], r[i], s[i]);
1698             
1699             // In case statistics is signed by validator, who is not registered in SC, ignore him   
1700             if (activeValidatorExist(chain, signerAcc) == false) {
1701                 continue;
1702             }
1703             
1704             uint256 validatorIdx = chain.validators.listIndex[signerAcc] - 1;
1705             
1706             // In case there is duplicit signature from the same validator, ignore it
1707             if (signedValidators[validatorIdx] == true) {
1708                 continue;
1709             }
1710             else {
1711                 signedValidators[validatorIdx] = true;
1712             }
1713             
1714             
1715             involvedVestingSum = involvedVestingSum.add(chain.usersData[signerAcc].validator.vesting);
1716             involvedSignaturesCount++;
1717         }
1718         
1719         delete signedValidators;
1720         
1721         // There must be more than 50% out of total possible vesting involved in signatures
1722         if (chain.involvedVestingNotaryCond == true) {
1723             // There must be more than 50% out of total possible vesting involved
1724             involvedVestingSum = involvedVestingSum.mul(2);
1725             require(involvedVestingSum > chain.totalVesting, "Invalid statistics data: involvedVesting <= 50% of chain.totalVesting");
1726         }
1727         
1728         
1729         // There must be more than 2/3 + 1 out of all active validators unique signatures
1730         if (chain.participationNotaryCond == true) {
1731             uint256 actNumOfValidators = chain.validators.list.length;
1732             
1733             // min. number of active validators for BFT to work properly is 4
1734             if (actNumOfValidators >= 4) {
1735                 uint256 minRequiredSignaturesCount = ((2 * actNumOfValidators) / 3) + 1;
1736                 
1737                 require(involvedSignaturesCount >= minRequiredSignaturesCount, "Invalid statistics data: Not enough signatures provided (2/3 + 1 cond)");
1738             }
1739             // if there is less than 4 active validators, everyone has to sign statistics
1740             else {
1741                 require(involvedSignaturesCount == actNumOfValidators, "Invalid statistics data: Not enough signatures provided (involvedSignatures == activeValidatorsCount)");
1742             }
1743         }
1744     }
1745    
1746     // Checks if chain is active(successfull notary processed during last CHAIN_INACTIVITY_TIMEOUT), if not set it active flag to false
1747     // If last notary is older than CHAIN_INACTIVITY_TIMEOUT, it means that validators cannot reach consensus or there is no active validator and chain is basically stuck.
1748     function checkAndSetChainActivity(ChainInfo storage chain) internal {
1749         if (chain.active == true && chain.lastNotary.timestamp + CHAIN_INACTIVITY_TIMEOUT < now) {
1750             chain.active = false;   
1751         }
1752     }
1753 }
1754 
1755 // SafeMath library. Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
1756 library SafeMath {
1757     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1758         uint256 c = a + b;
1759         require(c >= a, "SafeMath: addition overflow");
1760 
1761         return c;
1762     }
1763 
1764     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1765         require(b <= a, "SafeMath: subtraction overflow");
1766         uint256 c = a - b;
1767 
1768         return c;
1769     }
1770 
1771     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1772         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1773         // benefit is lost if 'b' is also tested.
1774         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1775         if (a == 0) {
1776             return 0;
1777         }
1778 
1779         uint256 c = a * b;
1780         require(c / a == b, "SafeMath: multiplication overflow");
1781 
1782         return c;
1783     }
1784 }