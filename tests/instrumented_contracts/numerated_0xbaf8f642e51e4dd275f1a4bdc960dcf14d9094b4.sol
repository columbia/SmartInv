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
23 //
24 // base contract for all our horizon contracts and tokens
25 //
26 contract HorizonContractBase {
27     // The owner of the contract, set at contract creation to the creator.
28     address public owner;
29 
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     // Contract authorization - only allow the owner to perform certain actions.
35     modifier onlyOwner {
36         require(msg.sender == owner, "Only the owner can call this function.");
37         _;
38     }
39 }
40 
41 //
42 // Base contract that includes authorisation restrictions.
43 //
44 contract AuthorisedContractBase is HorizonContractBase {
45 
46     /**
47      * @notice The list of addresses that are allowed restricted privileges.
48      */
49     mapping(address => bool) public authorised;
50 
51     /**
52      * @notice Notify interested parties when an account's status changes.
53      */
54     event AuthorisationChanged(address indexed who, bool isAuthorised);
55 
56     /**
57      * @notice Sole constructor.  Add the owner to the authorised whitelist.
58      */
59     constructor() public {
60         // The contract owner is always authorised.
61         setAuthorised(msg.sender, true);
62     } 
63 
64     /**
65      * @notice Add or remove special privileges.
66      *
67      * @param who           The address of the contract.
68      * @param isAuthorised  Whether special privileges are allowed or not.
69      */
70     function setAuthorised(address who, bool isAuthorised) public onlyOwner {
71         authorised[who] = isAuthorised;
72         emit AuthorisationChanged(who, isAuthorised);
73     }
74 
75     /**
76      * Whether the specified address has special privileges or not.
77      *
78      * @param who       The address of the contract.
79      * @return True if address has special privileges, false otherwise.
80      */
81     function isAuthorised(address who) public view returns (bool) {
82         return authorised[who];
83     }
84 
85     /**
86      * @notice Restrict access to anyone nominated by the owner.
87      */
88     modifier onlyAuthorised() {
89         require(isAuthorised(msg.sender), "Access denied.");
90         _;
91     }
92 }
93 
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  *
99  * Source: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
100  */
101 library SafeMath {
102     /**
103      * @dev Multiplies two numbers, throws on overflow.
104      */
105     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106         if (a == 0) {
107             return 0;
108         }
109         uint256 c = a * b;
110         assert(c / a == b);
111         return c;
112     }
113 
114     /**
115     * @dev Integer division of two numbers, truncating the quotient.
116     */
117     function div(uint256 a, uint256 b) internal pure returns (uint256) {
118         // assert(b > 0); // Solidity automatically throws when dividing by 0
119         // uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121         return a / b;
122     }
123 
124     /**
125     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
126     */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         assert(b <= a);
129         return a - b;
130     }
131 
132     /**
133     * @dev Adds two numbers, throws on overflow.
134     */
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         assert(c >= a);
138         return c;
139     }
140 }
141 
142 
143 /**
144  * VOXToken for the Talketh.io ICO by Horizon-Globex.com of Switzerland.
145  *
146  * An ERC20 standard
147  *
148  * Author: Horizon Globex GmbH Development Team
149  *
150  * Dev Notes
151  *   NOTE: There is no fallback function as this contract will never contain Ether, only the VOX tokens.
152  *   NOTE: There is no approveAndCall/receiveApproval or ERC223 functionality.
153  *   NOTE: Coins will never be minted beyond those at contract creation.
154  *   NOTE: Zero transfers are allowed - we don't want to break a valid transaction chain.
155  *   NOTE: There is no selfDestruct, changeOwner or migration path - this is the only contract.
156  */
157 
158 
159 contract VOXToken is ERC20Interface, AuthorisedContractBase {
160     using SafeMath for uint256;
161 
162     // Contract authorization - only allow the official KYC provider to perform certain actions.
163     modifier onlyKycProvider {
164         require(msg.sender == regulatorApprovedKycProvider, "Only the KYC Provider can call this function.");
165         _;
166     }
167 
168     // The approved KYC provider that verifies all ICO/TGE Contributors.
169     address public regulatorApprovedKycProvider;
170 
171     // Public identity variables of the token used by ERC20 platforms.
172     string public name = "Talketh";
173     string public symbol = "VOX";
174     
175     // There is no good reason to deviate from 18 decimals, see https://github.com/ethereum/EIPs/issues/724.
176     uint8 public decimals = 18;
177     
178     // The total supply of tokens, set at creation, decreased with burn.
179     uint256 public totalSupply_;
180 
181     // The supply of tokens, set at creation, to be allocated for the referral bonuses.
182     uint256 public rewardPool_;
183 
184     // The Initial Coin Offering is finished.
185     bool public isIcoComplete;
186 
187     // The balances of all accounts.
188     mapping (address => uint256) public balances;
189 
190     // KYC submission hashes accepted by KYC service provider for AML/KYC review.
191     bytes32[] public kycHashes;
192 
193     // Addresses authorized to transfer tokens on an account's behalf.
194     mapping (address => mapping (address => uint256)) internal allowanceCollection;
195 
196     // Lookup an ICO/TGE Contributor address to see if it was referred by another address (referee => referrer).
197     mapping (address => address) public referredBy;
198 
199     // Emitted when the Initial Coin Offering phase ends, see closeIco().
200     event IcoComplete();
201 
202     // Notification when tokens are burned by the owner.
203     event Burn(address indexed from, uint256 value);
204 
205     // Someone who was referred has purchased tokens, when the bonus is awarded log the details.
206     event ReferralRedeemed(address indexed referrer, address indexed referee, uint256 value);
207 
208     /**
209      * Initialise contract with the 50 million initial supply tokens, allocated to
210      * the creator of the contract (the owner).
211      */
212     constructor() public {
213         setAuthorised(msg.sender, true);                    // The owner is always approved.
214 
215         totalSupply_ = 50000000 * 10 ** uint256(decimals);   // Set the total supply of VOX Tokens.
216         balances[msg.sender] = totalSupply_;
217         rewardPool_ = 375000 * 10 ** uint256(decimals);   // Set the total supply of VOX Reward Tokens.
218     }
219 
220     /**
221      * The total number of tokens that exist.
222      */
223     function totalSupply() public view returns (uint256) {
224         return totalSupply_;
225     }
226 
227     /**
228      * The total number of reward pool tokens that remains.
229      */
230     function rewardPool() public onlyOwner view returns (uint256) {
231         return rewardPool_;
232     }
233 
234     /**
235      * Get the number of tokens for a specific account.
236      *
237      * @param who    The address to get the token balance of.
238      */
239     function balanceOf(address who) public view returns (uint256 balance) {
240         return balances[who];
241     }
242 
243     /**
244      * Get the current allowanceCollection that the approver has allowed 'spender' to spend on their behalf.
245      *
246      * See also: approve() and transferFrom().
247      *
248      * @param _approver  The account that owns the tokens.
249      * @param _spender   The account that can spend the approver's tokens.
250      */
251     function allowance(address _approver, address _spender) public view returns (uint256) {
252         return allowanceCollection[_approver][_spender];
253     }
254 
255     /**
256      * Add the link between the referrer and who they referred.
257      *
258      * ---- ICO-Platform Note ----
259      * The horizon-globex.com ICO platform offers functionality for referrers to sign-up
260      * to refer Contributors. Upon such referred Contributions, Company shall automatically
261      * award 1% of our "owner" VOX tokens to the referrer as coded by this Smart Contract.
262      *
263      * All referrers must successfully complete our ICO KYC review prior to being allowed on-board.
264      * -- End ICO-Platform Note --
265      *
266      * @param referrer  The person doing the referring.
267      * @param referee   The person that was referred.
268      */
269     function refer(address referrer, address referee) public onlyOwner {
270         require(referrer != address(0x0), "Referrer cannot be null");
271         require(referee != address(0x0), "Referee cannot be null");
272         require(!isIcoComplete, "Cannot add new referrals after ICO is complete.");
273 
274         referredBy[referee] = referrer;
275     }
276 
277     /**
278      * Transfer tokens from the caller's account to the recipient.
279      *
280      * @param to    The address of the recipient.
281      * @param value The number of tokens to send.
282      */
283     // solhint-disable-next-line no-simple-event-func-name
284     function transfer(address to, uint256 value) public returns (bool) {
285         return _transfer(msg.sender, to, value);
286     }
287 	
288     /**
289      * Transfer pre-approved tokens on behalf of an account.
290      *
291      * See also: approve() and allowance().
292      *
293      * @param from  The address of the sender
294      * @param to    The address of the recipient
295      * @param value The number of tokens to send
296      */
297     function transferFrom(address from, address to, uint256 value) public returns (bool) {
298         require(value <= allowanceCollection[from][msg.sender], "Amount to transfer is greater than allowance.");
299 		
300         allowanceCollection[from][msg.sender] = allowanceCollection[from][msg.sender].sub(value);
301         _transfer(from, to, value);
302         return true;
303     }
304 
305     /**
306      * Allow another address to spend tokens on your behalf.
307      *
308      * transferFrom can be called multiple times until the approved balance goes to zero.
309      * Subsequent calls to this function overwrite the previous balance.
310      * To change from a non-zero value to another non-zero value you must first set the
311      * allowance to zero - it is best to use safeApprove when doing this as you will
312      * manually have to check for transfers to ensure none happened before the zero allowance
313      * was set.
314      *
315      * @param _spender   The address authorized to spend your tokens.
316      * @param _value     The maximum amount of tokens they can spend.
317      */
318     function approve(address _spender, uint256 _value) public returns (bool) {
319         require(isAuthorised(_spender), "Target of approve has not passed KYC");
320         if(allowanceCollection[msg.sender][_spender] > 0 && _value != 0) {
321             revert("You cannot set a non-zero allowance to another non-zero, you must zero it first.");
322         }
323 
324         allowanceCollection[msg.sender][_spender] = _value;
325         emit Approval(msg.sender, _spender, _value);
326 
327         return true;
328     }
329 
330     /**
331      * Allow another address to spend tokens on your behalf while mitigating a double spend.
332      *
333      * Subsequent calls to this function overwrite the previous balance.
334      * The old value must match the current allowance otherwise this call reverts.
335      *
336      * @param spender   The address authorized to spend your tokens.
337      * @param value     The maximum amount of tokens they can spend.
338      * @param oldValue  The current allowance for this spender.
339      */
340     function safeApprove(address spender, uint256 value, uint256 oldValue) public returns (bool) {
341         require(isAuthorised(spender), "Target of safe approve has not passed KYC");
342         require(spender != address(0x0), "Cannot approve null address.");
343         require(oldValue == allowanceCollection[msg.sender][spender], "The expected old value did not match current allowance.");
344 
345         allowanceCollection[msg.sender][spender] = value;
346         emit Approval(msg.sender, spender, value);
347 
348         return true;
349     }
350 
351     /**
352      * The hash for all Know Your Customer information is calculated outside but stored here.
353      * This storage will be cleared once the ICO completes, see closeIco().
354      *
355      * ---- ICO-Platform Note ----
356      * The horizon-globex.com ICO platform's KYC app will register a hash of the Contributors
357      * KYC submission on the blockchain. Our Swiss financial-intermediary KYC provider will be 
358      * notified of the submission and retrieve the Contributor data for formal review.
359      *
360      * All Contributors must successfully complete our ICO KYC review prior to being allowed on-board.
361      * -- End ICO-Platform Note --
362      *
363      * @param sha   The hash of the customer data.
364     */
365     function setKycHash(bytes32 sha) public onlyOwner {
366         require(!isIcoComplete, "The ICO phase has ended, you can no longer set KYC hashes.");
367 
368         // This is deliberately vague to reduce the links to user data.  To verify users you
369         // must go through the KYC Provider firm off-chain.
370         kycHashes.push(sha);
371     }
372 
373     /**
374      * A user has passed KYC verification, store them on the blockchain in the order it happened.
375      * This will be cleared once the ICO completes, see closeIco().
376      *
377      * ---- ICO-Platform Note ----
378      * The horizon-globex.com ICO platform's registered KYC provider submits their approval
379      * for this Contributor to particpate using the ICO-Platform portal. 
380      *
381      * Each Contributor will then be sent the Ethereum, Bitcoin and IBAN account numbers to
382      * deposit their Approved Contribution in exchange for VOX Tokens.
383      * -- End ICO-Platform Note --
384      *
385      * @param who   The user's address.
386      */
387     function kycApproved(address who) public onlyKycProvider {
388         require(!isIcoComplete, "The ICO phase has ended, you can no longer approve.");
389         require(who != address(0x0), "Cannot approve a null address.");
390 
391         // NOTE: setAuthorised is onlyOwner, directly perform the actions as KYC Provider.
392         authorised[who] = true;
393         emit AuthorisationChanged(who, true);
394     }
395 
396     /**
397      * Set the address that has the authority to approve users by KYC.
398      *
399      * ---- ICO-Platform Note ----
400      * The horizon-globex.com ICO platform shall register a fully licensed Swiss KYC
401      * provider to assess each potential Contributor for KYC and AML under Swiss law. 
402      *
403      * -- End ICO-Platform Note --
404      *
405      * @param who   The address of the KYC provider.
406      */
407     function setKycProvider(address who) public onlyOwner {
408         regulatorApprovedKycProvider = who;
409     }
410 
411     /**
412      * Retrieve the KYC hash from the specified index.
413      *
414      * @param   index   The index into the array.
415      */
416     function getKycHash(uint256 index) public view returns (bytes32) {
417         return kycHashes[index];
418     }
419 
420     /**
421      * When someone referred (the referee) purchases tokens the referrer gets a 1% bonus from the central pool.
422      *
423      * ---- ICO-Platform Note ----
424      * The horizon-globex.com ICO platform's portal shall award referrers as part of the ICO
425      * VOX Token issuance procedure as overseen by the Swiss KYC provider. 
426      *
427      * -- End ICO-Platform Note --
428      *
429      * @param referee   The referred account who just purchased some tokens.
430      * @param referrer  The account that referred the one purchasing tokens.
431      * @param value     The number of tokens purchased by the referee.
432     */
433     function awardReferralBonus(address referee, address referrer, uint256 value) private {
434         uint256 bonus = value / 100;
435         balances[owner] = balances[owner].sub(bonus);
436         balances[referrer] = balances[referrer].add(bonus);
437         rewardPool_ -= bonus;
438         emit ReferralRedeemed(referee, referrer, bonus);
439     }
440 
441     /**
442      * During the ICO phase the owner will allocate tokens once KYC completes and funds are deposited.
443      *
444      * ---- ICO-Platform Note ----
445      * The horizon-globex.com ICO platform's portal shall issue VOX Token to Contributors on receipt of 
446      * the Approved Contribution funds at the KYC providers Escrow account/wallets.
447      * Only after VOX Tokens are issued to the Contributor can the Swiss KYC provider allow the transfer
448      * of funds from their Escrow to Company.
449      *
450      * -- End ICO-Platform Note --
451      *
452      * @param to       The recipient of the tokens.
453      * @param value    The number of tokens to send.
454      */
455     function icoTransfer(address to, uint256 value) public onlyOwner {
456         require(!isIcoComplete, "ICO is complete, use transfer().");
457 
458         // If an attempt is made to transfer more tokens than owned, transfer the remainder.
459         uint256 toTransfer = (value > (balances[msg.sender] - rewardPool_ )) ? (balances[msg.sender] - rewardPool_) : value;
460         
461         _transfer(msg.sender, to, toTransfer);
462 
463         // Handle a referred account receiving tokens.
464         address referrer = referredBy[to];
465         if(referrer != address(0x0)) {
466             referredBy[to] = address(0x0);
467             awardReferralBonus(to, referrer, toTransfer);
468         }
469     }
470 
471     /**
472      * End the ICO phase in accordance with KYC procedures and clean up.
473      *
474      * ---- ICO-Platform Note ----
475      * The horizon-globex.com ICO platform's portal shall halt the ICO at the end of the 
476      * Contribution Period, as defined in the ICO Terms and Conditions https://talketh.io/Terms.
477      *
478      * -- End ICO-Platform Note --
479      */
480     function closeIco() public onlyOwner {
481         require(!isIcoComplete, "The ICO phase has already ended, you cannot close it again.");
482         require((balances[owner] - rewardPool_) == 0, "Cannot close ICO when a balance remains in the owner account.");
483 
484         isIcoComplete = true;
485 
486         emit IcoComplete();
487     }
488 	
489     /**
490      * Internal transfer, can only be called by this contract
491      *
492      * @param from     The sender of the tokens.
493      * @param to       The recipient of the tokens.
494      * @param value    The number of tokens to send.
495      */
496     function _transfer(address from, address to, uint256 value) internal returns (bool) {
497         require(isAuthorised(to), "Target of transfer has not passed KYC");
498         require(from != address(0x0), "Cannot send tokens from null address");
499         require(to != address(0x0), "Cannot transfer tokens to null");
500         require(balances[from] >= value, "Insufficient funds");
501 
502         // Quick exit for zero, but allow it in case this transfer is part of a chain.
503         if(value == 0)
504             return true;
505 		
506         // Perform the transfer.
507         balances[from] = balances[from].sub(value);
508         balances[to] = balances[to].add(value);
509 		
510         // Any tokens sent to to owner are implicitly burned.
511         if (to == owner) {
512             _burn(to, value);
513         }
514 
515         emit Transfer(from, to, value);
516 
517         return true;
518     }
519 
520     /**
521      * Permanently destroy tokens belonging to a user.
522      *
523      * @param addressToBurn    The owner of the tokens to burn.
524      * @param value            The number of tokens to burn.
525      */
526     function _burn(address addressToBurn, uint256 value) private returns (bool success) {
527         require(value > 0, "Tokens to burn must be greater than zero");
528         require(balances[addressToBurn] >= value, "Tokens to burn exceeds balance");
529 
530         balances[addressToBurn] = balances[addressToBurn].sub(value);
531         totalSupply_ = totalSupply_.sub(value);
532 
533         emit Burn(msg.sender, value);
534 
535         return true;
536     }
537 }