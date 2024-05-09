1 pragma solidity 0.5.0;
2 
3 
4 // ----------------------------------------------------------------------------
5 // ERC Token Standard #20 Interface
6 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
7 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
8 // 
9 // ----------------------------------------------------------------------------
10 contract ERC20Interface {
11     function totalSupply() public view returns (uint256);
12     function balanceOf(address who) public view returns (uint256);
13     function allowance(address approver, address spender) public view returns (uint256);
14     function transfer(address to, uint256 value) public returns (bool);
15     function approve(address spender, uint256 value) public returns (bool);
16     function transferFrom(address from, address to, uint256 value) public returns (bool);
17 
18     // solhint-disable-next-line no-simple-event-func-name
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed approver, address indexed spender, uint256 value);
21 }
22 
23 
24 
25 //
26 // base contract for all our horizon contracts and tokens
27 //
28 contract HorizonContractBase {
29     // The owner of the contract, set at contract creation to the creator.
30     address public owner;
31 
32     constructor() public {
33         owner = msg.sender;
34     }
35 
36     // Contract authorization - only allow the owner to perform certain actions.
37     modifier onlyOwner {
38         require(msg.sender == owner, "Only the owner can call this function.");
39         _;
40     }
41 }
42 
43 
44 
45 //
46 // Base contract that includes authorisation restrictions.
47 //
48 contract AuthorisedContractBase is HorizonContractBase {
49 
50     /**
51      * @notice The list of addresses that are allowed restricted privileges.
52      */
53     mapping(address => bool) public authorised;
54 
55     /**
56      * @notice Notify interested parties when an account's status changes.
57      */
58     event AuthorisationChanged(address indexed who, bool isAuthorised);
59 
60     /**
61      * @notice Sole constructor.  Add the owner to the authorised whitelist.
62      */
63     constructor() public {
64         // The contract owner is always authorised.
65         setAuthorised(msg.sender, true);
66     } 
67 
68     /**
69      * @notice Add or remove special privileges.
70      *
71      * @param who           The address of the contract.
72      * @param isAuthorised  Whether special privileges are allowed or not.
73      */
74     function setAuthorised(address who, bool isAuthorised) public onlyOwner {
75         authorised[who] = isAuthorised;
76         emit AuthorisationChanged(who, isAuthorised);
77     }
78 
79     /**
80      * Whether the specified address has special privileges or not.
81      *
82      * @param who       The address of the contract.
83      * @return True if address has special privileges, false otherwise.
84      */
85     function isAuthorised(address who) public view returns (bool) {
86         return authorised[who];
87     }
88 
89     /**
90      * @notice Restrict access to anyone nominated by the owner.
91      */
92     modifier onlyAuthorised() {
93         require(isAuthorised(msg.sender), "Access denied.");
94         _;
95     }
96 }
97 
98  
99 
100 /**
101  * @title SafeMath
102  * @dev Math operations with safety checks that throw on error
103  *
104  * Source: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
105  */
106 library SafeMath {
107     /**
108      * @dev Multiplies two numbers, throws on overflow.
109      */
110     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111         if (a == 0) {
112             return 0;
113         }
114         uint256 c = a * b;
115         assert(c / a == b);
116         return c;
117     }
118 
119     /**
120     * @dev Integer division of two numbers, truncating the quotient.
121     */
122     function div(uint256 a, uint256 b) internal pure returns (uint256) {
123         // assert(b > 0); // Solidity automatically throws when dividing by 0
124         // uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126         return a / b;
127     }
128 
129     /**
130     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
131     */
132     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133         assert(b <= a);
134         return a - b;
135     }
136 
137     /**
138     * @dev Adds two numbers, throws on overflow.
139     */
140     function add(uint256 a, uint256 b) internal pure returns (uint256) {
141         uint256 c = a + b;
142         assert(c >= a);
143         return c;
144     }
145 }
146 
147 /**
148  * VOXToken for the Talketh.io ICO by Horizon-Globex.com of Switzerland.
149  *
150  * An ERC20 standard
151  *
152  * Author: Horizon Globex GmbH Development Team
153  *
154  * Dev Notes
155  *   NOTE: There is no fallback function as this contract will never contain Ether, only the VOX tokens.
156  *   NOTE: There is no approveAndCall/receiveApproval or ERC223 functionality.
157  *   NOTE: Coins will never be minted beyond those at contract creation.
158  *   NOTE: Zero transfers are allowed - we don't want to break a valid transaction chain.
159  *   NOTE: There is no selfDestruct, changeOwner or migration path - this is the only contract.
160  */
161 
162 
163 contract VOXToken is ERC20Interface, AuthorisedContractBase {
164     using SafeMath for uint256;
165 
166     // Contract authorization - only allow the official KYC provider to perform certain actions.
167     modifier onlyKycProvider {
168         require(msg.sender == regulatorApprovedKycProvider, "Only the KYC Provider can call this function.");
169         _;
170     }
171 
172     // The approved KYC provider that verifies all ICO/TGE Contributors.
173     address public regulatorApprovedKycProvider;
174 
175     // Public identity variables of the token used by ERC20 platforms.
176     string public name = "Talketh";
177     string public symbol = "VOX";
178     
179     // There is no good reason to deviate from 18 decimals, see https://github.com/ethereum/EIPs/issues/724.
180     uint8 public decimals = 18;
181     
182     // The total supply of tokens, set at creation, decreased with burn.
183     uint256 public totalSupply_;
184 
185     // The supply of tokens, set at creation, to be allocated for the referral bonuses.
186     uint256 public rewardPool_;
187 
188     // The Initial Coin Offering is finished.
189     bool public isIcoComplete;
190 
191     // The balances of all accounts.
192     mapping (address => uint256) public balances;
193 
194     // KYC submission hashes accepted by KYC service provider for AML/KYC review.
195     bytes32[] public kycHashes;
196 
197     // Addresses authorized to transfer tokens on an account's behalf.
198     mapping (address => mapping (address => uint256)) internal allowanceCollection;
199 
200     // Lookup an ICO/TGE Contributor address to see if it was referred by another address (referee => referrer).
201     mapping (address => address) public referredBy;
202 
203     // Emitted when the Initial Coin Offering phase ends, see closeIco().
204     event IcoComplete();
205 
206     // Notification when tokens are burned by the owner.
207     event Burn(address indexed from, uint256 value);
208 
209     // Someone who was referred has purchased tokens, when the bonus is awarded log the details.
210     event ReferralRedeemed(address indexed referrer, address indexed referee, uint256 value);
211 
212     /**
213      * Initialise contract with the 50 million initial supply tokens, allocated to
214      * the creator of the contract (the owner).
215      */
216     constructor() public {
217         setAuthorised(msg.sender, true);                    // The owner is always approved.
218 
219         totalSupply_ = 50000000 * 10 ** uint256(decimals);   // Set the total supply of VOX Tokens.
220         balances[msg.sender] = totalSupply_;
221         rewardPool_ = 375000 * 10 ** uint256(decimals);   // Set the total supply of VOX Reward Tokens.
222     }
223 
224     /**
225      * The total number of tokens that exist.
226      */
227     function totalSupply() public view returns (uint256) {
228         return totalSupply_;
229     }
230 
231     /**
232      * The total number of reward pool tokens that remains.
233      */
234     function rewardPool() public onlyOwner view returns (uint256) {
235         return rewardPool_;
236     }
237 
238     /**
239      * Get the number of tokens for a specific account.
240      *
241      * @param who    The address to get the token balance of.
242      */
243     function balanceOf(address who) public view returns (uint256 balance) {
244         return balances[who];
245     }
246 
247     /**
248      * Get the current allowanceCollection that the approver has allowed 'spender' to spend on their behalf.
249      *
250      * See also: approve() and transferFrom().
251      *
252      * @param _approver  The account that owns the tokens.
253      * @param _spender   The account that can spend the approver's tokens.
254      */
255     function allowance(address _approver, address _spender) public view returns (uint256) {
256         return allowanceCollection[_approver][_spender];
257     }
258 
259     /**
260      * Add the link between the referrer and who they referred.
261      *
262      * ---- ICO-Platform Note ----
263      * The horizon-globex.com ICO platform offers functionality for referrers to sign-up
264      * to refer Contributors. Upon such referred Contributions, Company shall automatically
265      * award 1% of our "owner" VOX tokens to the referrer as coded by this Smart Contract.
266      *
267      * All referrers must successfully complete our ICO KYC review prior to being allowed on-board.
268      * -- End ICO-Platform Note --
269      *
270      * @param referrer  The person doing the referring.
271      * @param referee   The person that was referred.
272      */
273     function refer(address referrer, address referee) public onlyOwner {
274         require(referrer != address(0x0), "Referrer cannot be null");
275         require(referee != address(0x0), "Referee cannot be null");
276         require(!isIcoComplete, "Cannot add new referrals after ICO is complete.");
277 
278         referredBy[referee] = referrer;
279     }
280 
281     /**
282      * Transfer tokens from the caller's account to the recipient.
283      *
284      * @param to    The address of the recipient.
285      * @param value The number of tokens to send.
286      */
287     // solhint-disable-next-line no-simple-event-func-name
288     function transfer(address to, uint256 value) public returns (bool) {
289         return _transfer(msg.sender, to, value);
290     }
291 	
292     /**
293      * Transfer pre-approved tokens on behalf of an account.
294      *
295      * See also: approve() and allowance().
296      *
297      * @param from  The address of the sender
298      * @param to    The address of the recipient
299      * @param value The number of tokens to send
300      */
301     function transferFrom(address from, address to, uint256 value) public returns (bool) {
302         require(value <= allowanceCollection[from][msg.sender], "Amount to transfer is greater than allowance.");
303 		
304         allowanceCollection[from][msg.sender] = allowanceCollection[from][msg.sender].sub(value);
305         _transfer(from, to, value);
306         return true;
307     }
308 
309     /**
310      * Allow another address to spend tokens on your behalf.
311      *
312      * transferFrom can be called multiple times until the approved balance goes to zero.
313      * Subsequent calls to this function overwrite the previous balance.
314      * To change from a non-zero value to another non-zero value you must first set the
315      * allowance to zero - it is best to use safeApprove when doing this as you will
316      * manually have to check for transfers to ensure none happened before the zero allowance
317      * was set.
318      *
319      * @param _spender   The address authorized to spend your tokens.
320      * @param _value     The maximum amount of tokens they can spend.
321      */
322     function approve(address _spender, uint256 _value) public returns (bool) {
323         require(isAuthorised(_spender), "Target of approve has not passed KYC");
324         if(allowanceCollection[msg.sender][_spender] > 0 && _value != 0) {
325             revert("You cannot set a non-zero allowance to another non-zero, you must zero it first.");
326         }
327 
328         allowanceCollection[msg.sender][_spender] = _value;
329         emit Approval(msg.sender, _spender, _value);
330 
331         return true;
332     }
333 
334     /**
335      * Allow another address to spend tokens on your behalf while mitigating a double spend.
336      *
337      * Subsequent calls to this function overwrite the previous balance.
338      * The old value must match the current allowance otherwise this call reverts.
339      *
340      * @param spender   The address authorized to spend your tokens.
341      * @param value     The maximum amount of tokens they can spend.
342      * @param oldValue  The current allowance for this spender.
343      */
344     function safeApprove(address spender, uint256 value, uint256 oldValue) public returns (bool) {
345         require(isAuthorised(spender), "Target of safe approve has not passed KYC");
346         require(spender != address(0x0), "Cannot approve null address.");
347         require(oldValue == allowanceCollection[msg.sender][spender], "The expected old value did not match current allowance.");
348 
349         allowanceCollection[msg.sender][spender] = value;
350         emit Approval(msg.sender, spender, value);
351 
352         return true;
353     }
354 
355     /**
356      * The hash for all Know Your Customer information is calculated outside but stored here.
357      * This storage will be cleared once the ICO completes, see closeIco().
358      *
359      * ---- ICO-Platform Note ----
360      * The horizon-globex.com ICO platform's KYC app will register a hash of the Contributors
361      * KYC submission on the blockchain. Our Swiss financial-intermediary KYC provider will be 
362      * notified of the submission and retrieve the Contributor data for formal review.
363      *
364      * All Contributors must successfully complete our ICO KYC review prior to being allowed on-board.
365      * -- End ICO-Platform Note --
366      *
367      * @param sha   The hash of the customer data.
368     */
369     function setKycHash(bytes32 sha) public onlyOwner {
370         require(!isIcoComplete, "The ICO phase has ended, you can no longer set KYC hashes.");
371 
372         // This is deliberately vague to reduce the links to user data.  To verify users you
373         // must go through the KYC Provider firm off-chain.
374         kycHashes.push(sha);
375     }
376 
377     /**
378      * A user has passed KYC verification, store them on the blockchain in the order it happened.
379      * This will be cleared once the ICO completes, see closeIco().
380      *
381      * ---- ICO-Platform Note ----
382      * The horizon-globex.com ICO platform's registered KYC provider submits their approval
383      * for this Contributor to particpate using the ICO-Platform portal. 
384      *
385      * Each Contributor will then be sent the Ethereum, Bitcoin and IBAN account numbers to
386      * deposit their Approved Contribution in exchange for VOX Tokens.
387      * -- End ICO-Platform Note --
388      *
389      * @param who   The user's address.
390      */
391     function kycApproved(address who) public onlyKycProvider {
392         require(!isIcoComplete, "The ICO phase has ended, you can no longer approve.");
393         require(who != address(0x0), "Cannot approve a null address.");
394 
395         // NOTE: setAuthorised is onlyOwner, directly perform the actions as KYC Provider.
396         authorised[who] = true;
397         emit AuthorisationChanged(who, true);
398     }
399 
400     /**
401      * Set the address that has the authority to approve users by KYC.
402      *
403      * ---- ICO-Platform Note ----
404      * The horizon-globex.com ICO platform shall register a fully licensed Swiss KYC
405      * provider to assess each potential Contributor for KYC and AML under Swiss law. 
406      *
407      * -- End ICO-Platform Note --
408      *
409      * @param who   The address of the KYC provider.
410      */
411     function setKycProvider(address who) public onlyOwner {
412         regulatorApprovedKycProvider = who;
413     }
414 
415     /**
416      * Retrieve the KYC hash from the specified index.
417      *
418      * @param   index   The index into the array.
419      */
420     function getKycHash(uint256 index) public view returns (bytes32) {
421         return kycHashes[index];
422     }
423 
424     /**
425      * When someone referred (the referee) purchases tokens the referrer gets a 1% bonus from the central pool.
426      *
427      * ---- ICO-Platform Note ----
428      * The horizon-globex.com ICO platform's portal shall award referrers as part of the ICO
429      * VOX Token issuance procedure as overseen by the Swiss KYC provider. 
430      *
431      * -- End ICO-Platform Note --
432      *
433      * @param referee   The referred account who just purchased some tokens.
434      * @param referrer  The account that referred the one purchasing tokens.
435      * @param value     The number of tokens purchased by the referee.
436     */
437     function awardReferralBonus(address referee, address referrer, uint256 value) private {
438         uint256 bonus = value / 100;
439         balances[owner] = balances[owner].sub(bonus);
440         balances[referrer] = balances[referrer].add(bonus);
441         rewardPool_ -= bonus;
442         emit ReferralRedeemed(referee, referrer, bonus);
443     }
444 
445     /**
446      * During the ICO phase the owner will allocate tokens once KYC completes and funds are deposited.
447      *
448      * ---- ICO-Platform Note ----
449      * The horizon-globex.com ICO platform's portal shall issue VOX Token to Contributors on receipt of 
450      * the Approved Contribution funds at the KYC providers Escrow account/wallets.
451      * Only after VOX Tokens are issued to the Contributor can the Swiss KYC provider allow the transfer
452      * of funds from their Escrow to Company.
453      *
454      * -- End ICO-Platform Note --
455      *
456      * @param to       The recipient of the tokens.
457      * @param value    The number of tokens to send.
458      */
459     function icoTransfer(address to, uint256 value) public onlyOwner {
460         require(!isIcoComplete, "ICO is complete, use transfer().");
461 
462         // If an attempt is made to transfer more tokens than owned, transfer the remainder.
463         uint256 toTransfer = (value > (balances[msg.sender] - rewardPool_ )) ? (balances[msg.sender] - rewardPool_) : value;
464         
465         _transfer(msg.sender, to, toTransfer);
466 
467         // Handle a referred account receiving tokens.
468         address referrer = referredBy[to];
469         if(referrer != address(0x0)) {
470             referredBy[to] = address(0x0);
471             awardReferralBonus(to, referrer, toTransfer);
472         }
473     }
474 
475     /**
476      * End the ICO phase in accordance with KYC procedures and clean up.
477      *
478      * ---- ICO-Platform Note ----
479      * The horizon-globex.com ICO platform's portal shall halt the ICO at the end of the 
480      * Contribution Period, as defined in the ICO Terms and Conditions https://talketh.io/Terms.
481      *
482      * -- End ICO-Platform Note --
483      */
484     function closeIco() public onlyOwner {
485         require(!isIcoComplete, "The ICO phase has already ended, you cannot close it again.");
486         require((balances[owner] - rewardPool_) == 0, "Cannot close ICO when a balance remains in the owner account.");
487 
488         isIcoComplete = true;
489 
490         emit IcoComplete();
491     }
492 	
493     /**
494      * Internal transfer, can only be called by this contract
495      *
496      * @param from     The sender of the tokens.
497      * @param to       The recipient of the tokens.
498      * @param value    The number of tokens to send.
499      */
500     function _transfer(address from, address to, uint256 value) internal returns (bool) {
501         require(isAuthorised(to), "Target of transfer has not passed KYC");
502         require(from != address(0x0), "Cannot send tokens from null address");
503         require(to != address(0x0), "Cannot transfer tokens to null");
504         require(balances[from] >= value, "Insufficient funds");
505 
506         // Quick exit for zero, but allow it in case this transfer is part of a chain.
507         if(value == 0)
508             return true;
509 		
510         // Perform the transfer.
511         balances[from] = balances[from].sub(value);
512         balances[to] = balances[to].add(value);
513 		
514         // Any tokens sent to to owner are implicitly burned.
515         if (to == owner) {
516             _burn(to, value);
517         }
518 
519         return true;
520     }
521 
522     /**
523      * Permanently destroy tokens belonging to a user.
524      *
525      * @param addressToBurn    The owner of the tokens to burn.
526      * @param value            The number of tokens to burn.
527      */
528     function _burn(address addressToBurn, uint256 value) private returns (bool success) {
529         require(value > 0, "Tokens to burn must be greater than zero");
530         require(balances[addressToBurn] >= value, "Tokens to burn exceeds balance");
531 
532         balances[addressToBurn] = balances[addressToBurn].sub(value);
533         totalSupply_ = totalSupply_.sub(value);
534 
535         emit Burn(msg.sender, value);
536 
537         return true;
538     }
539 }