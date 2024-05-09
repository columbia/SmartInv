1 pragma solidity 0.4.23;
2 
3 contract Migrations {
4     address public owner;
5     uint public lastCompletedMigration;
6 
7     modifier restricted() {
8         if (msg.sender == owner)
9             _;
10     }
11 
12     function Migrations() public {
13         owner = msg.sender;
14     }
15 
16     function setCompleted(uint completed) public restricted {
17         lastCompletedMigration = completed;
18     }
19 
20     function upgrade(address newAddress) public restricted {
21         Migrations upgraded = Migrations(newAddress);
22         upgraded.setCompleted(lastCompletedMigration);
23     }
24 }
25 
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  *
31  * Source: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
32  */
33 library SafeMath {
34     /**
35      * @dev Multiplies two numbers, throws on overflow.
36      */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         if (a == 0) {
39             return 0;
40         }
41         uint256 c = a * b;
42         assert(c / a == b);
43         return c;
44     }
45 
46     /**
47     * @dev Integer division of two numbers, truncating the quotient.
48     */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // assert(b > 0); // Solidity automatically throws when dividing by 0
51         // uint256 c = a / b;
52         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53         return a / b;
54     }
55 
56     /**
57     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58     */
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         assert(b <= a);
61         return a - b;
62     }
63 
64     /**
65     * @dev Adds two numbers, throws on overflow.
66     */
67     function add(uint256 a, uint256 b) internal pure returns (uint256) {
68         uint256 c = a + b;
69         assert(c >= a);
70         return c;
71     }
72 }
73 
74 
75 // ----------------------------------------------------------------------------
76 // ERC Token Standard #20 Interface
77 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
78 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
79 // 
80 // ----------------------------------------------------------------------------
81 contract ERC20Interface {
82     function totalSupply() public view returns (uint256);
83     function balanceOf(address who) public view returns (uint256);
84     function allowance(address approver, address spender) public view returns (uint256);
85     function transfer(address to, uint256 value) public returns (bool);
86     function approve(address spender, uint256 value) public returns (bool);
87     function transferFrom(address from, address to, uint256 value) public returns (bool);
88 
89     // solhint-disable-next-line no-simple-event-func-name
90     event Transfer(address indexed from, address indexed to, uint256 value);
91     event Approval(address indexed approver, address indexed spender, uint256 value);
92 }
93 
94 
95 //
96 // base contract for all our horizon contracts and tokens
97 //
98 contract HorizonContractBase {
99     // The owner of the contract, set at contract creation to the creator.
100     address public owner;
101 
102     constructor() public {
103         owner = msg.sender;
104     }
105 
106     // Contract authorization - only allow the owner to perform certain actions.
107     modifier onlyOwner {
108         require(msg.sender == owner);
109         _;
110     }
111 }
112 
113 
114 /**
115  * VOXToken for the Talketh.io ICO by Horizon-Globex.com of Switzerland.
116  *
117  * An ERC20 standard
118  *
119  * Author: Horizon Globex GmbH Development Team
120  *
121  * Dev Notes
122  *   NOTE: There is no fallback function as this contract will never contain Ether, only the VOX tokens.
123  *   NOTE: There is no approveAndCall/receiveApproval or ERC223 functionality.
124  *   NOTE: Coins will never be minted beyond those at contract creation.
125  *   NOTE: Zero transfers are allowed - we don't want to break a valid transaction chain.
126  *   NOTE: There is no selfDestruct, changeOwner or migration path - this is the only contract.
127  */
128 
129 
130 contract VOXToken is ERC20Interface, HorizonContractBase {
131     using SafeMath for uint256;
132 
133     // Contract authorization - only allow the official KYC provider to perform certain actions.
134     modifier onlyKycProvider {
135         require(msg.sender == regulatorApprovedKycProvider);
136         _;
137     }
138 
139     // The approved KYC provider that verifies all ICO/TGE Contributors.
140     address public regulatorApprovedKycProvider;
141 
142     // Public identity variables of the token used by ERC20 platforms.
143     string public name = "Talketh";
144     string public symbol = "VOX";
145     
146     // There is no good reason to deviate from 18 decimals, see https://github.com/ethereum/EIPs/issues/724.
147     uint8 public decimals = 18;
148     
149     // The total supply of tokens, set at creation, decreased with burn.
150     uint256 public totalSupply_;
151 
152     // The total supply of tokens, set at creation, to be allocated for the referral bonuses.
153     uint256 public rewardPool_;
154 
155     // The Initial Coin Offering is finished.
156     bool public isIcoComplete;
157 
158     // The balances of all accounts.
159     mapping (address => uint256) public balances;
160 
161     // KYC submission hashes accepted by KYC service provider for AML/KYC review.
162     bytes32[] public kycHashes;
163 
164     // All users that have passed the external KYC verification checks.
165     address[] public kycValidated;
166 
167     // Addresses authorized to transfer tokens on an account's behalf.
168     mapping (address => mapping (address => uint256)) internal allowanceCollection;
169 
170     // Lookup an ICO/TGE Contributor address to see if it was referred by another address (referee => referrer).
171     mapping (address => address) public referredBy;
172 
173     // Emitted when the Initial Coin Offering phase ends, see closeIco().
174     event IcoComplete();
175 
176     // Notification when tokens are burned by the owner.
177     event Burn(address indexed from, uint256 value);
178 
179     // Someone who was referred has purchased tokens, when the bonus is awarded log the details.
180     event ReferralRedeemed(address indexed referrer, address indexed referee, uint256 value);
181 
182     /**
183      * Initialise contract with the 50 million initial supply tokens, allocated to
184      * the creator of the contract (the owner).
185      */
186     constructor() public {
187         totalSupply_ = 50000000 * 10 ** uint256(decimals);   // Set the total supply of VOX Tokens.
188         balances[msg.sender] = totalSupply_;
189         rewardPool_ = 375000 * 10 ** uint256(decimals);   // Set the total supply of VOX Reward Tokens.
190     }
191 
192     /**
193      * The total number of tokens that exist.
194      */
195     function totalSupply() public view returns (uint256) {
196         return totalSupply_;
197     }
198 
199     /**
200      * The total number of reward pool tokens that remains.
201      */
202     function rewardPool() public onlyOwner view returns (uint256) {
203         return rewardPool_;
204     }
205 
206     /**
207      * Get the number of tokens for a specific account.
208      *
209      * @param who    The address to get the token balance of.
210      */
211     function balanceOf(address who) public view returns (uint256 balance) {
212         return balances[who];
213     }
214 
215     /**
216      * Get the current allowanceCollection that the approver has allowed 'spender' to spend on their behalf.
217      *
218      * See also: approve() and transferFrom().
219      *
220      * @param _approver  The account that owns the tokens.
221      * @param _spender   The account that can spend the approver's tokens.
222      */
223     function allowance(address _approver, address _spender) public view returns (uint256) {
224         return allowanceCollection[_approver][_spender];
225     }
226 
227     /**
228      * Add the link between the referrer and who they referred.
229      *
230      * ---- ICO-Platform Note ----
231      * The horizon-globex.com ICO platform offers functionality for referrers to sign-up
232      * to refer Contributors. Upon such referred Contributions, Company shall automatically
233      * award 1% of our "owner" VOX tokens to the referrer as coded by this Smart Contract.
234      *
235      * All referrers must successfully complete our ICO KYC review prior to being allowed on-board.
236      * -- End ICO-Platform Note --
237      *
238      * @param referrer  The person doing the referring.
239      * @param referee   The person that was referred.
240      */
241     function refer(address referrer, address referee) public onlyOwner {
242         require(referrer != 0x0, "Referrer cannot be null");
243         require(referee != 0x0, "Referee cannot be null");
244         require(!isIcoComplete, "Cannot add new referrals after ICO is complete.");
245 
246         referredBy[referee] = referrer;
247     }
248 
249     /**
250      * Transfer tokens from the caller's account to the recipient.
251      *
252      * @param to    The address of the recipient.
253      * @param value The number of tokens to send.
254      */
255     // solhint-disable-next-line no-simple-event-func-name
256     function transfer(address to, uint256 value) public returns (bool) {
257         return _transfer(msg.sender, to, value);
258     }
259 
260     /**
261      * Transfer pre-approved tokens on behalf of an account.
262      *
263      * See also: approve() and allowance().
264      *
265      * @param from  The address of the sender
266      * @param to    The address of the recipient
267      * @param value The number of tokens to send
268      */
269     function transferFrom(address from, address to, uint256 value) public returns (bool) {
270         require(value <= allowanceCollection[from][msg.sender], "Amount to transfer is greater than allowanceCollection.");
271 
272         allowanceCollection[from][msg.sender] = allowanceCollection[from][msg.sender].sub(value);
273         _transfer(from, to, value);
274         return true;
275     }
276 
277     /**
278      * Allow another address to spend tokens on your behalf.
279      *
280      * transferFrom can be called multiple times until the approved balance goes to zero.
281      * Subsequent calls to this function overwrite the previous balance.
282      * To change from a non-zero value to another non-zero value you must first set the
283      * allowanceCollection to zero - it is best to use safeApprove when doing this as you will
284      * manually have to check for transfers to ensure none happened before the zero allowanceCollection
285      * was set.
286      *
287      * @param _spender   The address authorized to spend your tokens.
288      * @param _value     The maximum amount of tokens they can spend.
289      */
290     function approve(address _spender, uint256 _value) public returns (bool) {
291         if(allowanceCollection[msg.sender][_spender] > 0 && _value != 0) {
292             revert("You cannot set a non-zero allowance to another non-zero, you must zero it first.");
293         }
294 
295         allowanceCollection[msg.sender][_spender] = _value;
296 
297         emit Approval(msg.sender, _spender, _value);
298 
299         return true;
300     }
301 
302     /**
303      * Allow another address to spend tokens on your behalf while mitigating a double spend.
304      *
305      * Subsequent calls to this function overwrite the previous balance.
306      * The old value must match the current allowance otherwise this call reverts.
307      *
308      * @param spender   The address authorized to spend your tokens.
309      * @param value     The maximum amount of tokens they can spend.
310      * @param oldValue  The current allowance for this spender.
311      */
312     function safeApprove(address spender, uint256 value, uint256 oldValue) public returns (bool) {
313         require(spender != 0x0, "Cannot approve null address.");
314         require(oldValue == allowanceCollection[msg.sender][spender], "The expected old value did not match current allowance.");
315 
316         allowanceCollection[msg.sender][spender] = value;
317         emit Approval(msg.sender, spender, value);
318 
319         return true;
320     }
321 
322     /**
323      * The hash for all Know Your Customer information is calculated outside but stored here.
324      * This storage will be cleared once the ICO completes, see closeIco().
325      *
326      * ---- ICO-Platform Note ----
327      * The horizon-globex.com ICO platform's KYC app will register a hash of the Contributors
328      * KYC submission on the blockchain. Our Swiss financial-intermediary KYC provider will be 
329      * notified of the submission and retrieve the Contributor data for formal review.
330      *
331      * All Contributors must successfully complete our ICO KYC review prior to being allowed on-board.
332      * -- End ICO-Platform Note --
333      *
334      * @param sha   The hash of the customer data.
335     */
336     function setKycHash(bytes32 sha) public onlyOwner {
337         require(!isIcoComplete, "The ICO phase has ended, you can no longer set KYC hashes.");
338 
339         kycHashes.push(sha);
340     }
341 
342     /**
343      * A user has passed KYC verification, store them on the blockchain in the order it happened.
344      * This will be cleared once the ICO completes, see closeIco().
345      *
346      * ---- ICO-Platform Note ----
347      * The horizon-globex.com ICO platform's registered KYC provider submits their approval
348      * for this Contributor to particpate using the ICO-Platform portal. 
349      *
350      * Each Contributor will then be sent the Ethereum, Bitcoin and IBAN account numbers to
351      * deposit their Approved Contribution in exchange for VOX Tokens.
352      * -- End ICO-Platform Note --
353      *
354      * @param who   The user's address.
355      */
356     function kycApproved(address who) public onlyKycProvider {
357         require(!isIcoComplete, "The ICO phase has ended, you can no longer approve.");
358         require(who != 0x0, "Cannot approve a null address.");
359 
360         kycValidated.push(who);
361     }
362 
363     /**
364      * Set the address that has the authority to approve users by KYC.
365      *
366      * ---- ICO-Platform Note ----
367      * The horizon-globex.com ICO platform shall register a fully licensed Swiss KYC
368      * provider to assess each potential Contributor for KYC and AML under Swiss law. 
369      *
370      * -- End ICO-Platform Note --
371      *
372      * @param who   The address of the KYC provider.
373      */
374     function setKycProvider(address who) public onlyOwner {
375         regulatorApprovedKycProvider = who;
376     }
377 
378     /**
379      * Retrieve the KYC hash from the specified index.
380      *
381      * @param   index   The index into the array.
382      */
383     function getKycHash(uint256 index) public view returns (bytes32) {
384         return kycHashes[index];
385     }
386 
387     /**
388      * Retrieve the validated KYC address from the specified index.
389      *
390      * @param   index   The index into the array.
391      */
392     function getKycApproved(uint256 index) public view returns (address) {
393         return kycValidated[index];
394     }
395 
396     /**
397      * When someone referred (the referee) purchases tokens the referrer gets a 1% bonus from the central pool.
398      *
399      * ---- ICO-Platform Note ----
400      * The horizon-globex.com ICO platform's portal shall award referrers as part of the ICO
401      * VOX Token issuance procedure as overseen by the Swiss KYC provider. 
402      *
403      * -- End ICO-Platform Note --
404      *
405      * @param referee   The referred account who just purchased some tokens.
406      * @param referrer  The account that referred the one purchasing tokens.
407      * @param value     The number of tokens purchased by the referee.
408     */
409     function awardReferralBonus(address referee, address referrer, uint256 value) private {
410         uint256 bonus = value / 100;
411         balances[owner] = balances[owner].sub(bonus);
412         balances[referrer] = balances[referrer].add(bonus);
413         rewardPool_ -= bonus;
414         emit ReferralRedeemed(referee, referrer, bonus);
415     }
416 
417     /**
418      * During the ICO phase the owner will allocate tokens once KYC completes and funds are deposited.
419      *
420      * ---- ICO-Platform Note ----
421      * The horizon-globex.com ICO platform's portal shall issue VOX Token to Contributors on receipt of 
422      * the Approved Contribution funds at the KYC providers Escrow account/wallets.
423      * Only after VOX Tokens are issued to the Contributor can the Swiss KYC provider allow the transfer
424      * of funds from their Escrow to Company.
425      *
426      * -- End ICO-Platform Note --
427      *
428      * @param to       The recipient of the tokens.
429      * @param value    The number of tokens to send.
430      */
431     function icoTransfer(address to, uint256 value) public onlyOwner {
432         require(!isIcoComplete, "ICO is complete, use transfer().");
433 
434         // If an attempt is made to transfer more tokens than owned, transfer the remainder.
435         uint256 toTransfer = (value > (balances[msg.sender] - rewardPool_ )) ? (balances[msg.sender] - rewardPool_) : value;
436         
437         _transfer(msg.sender, to, toTransfer);
438 
439         // Handle a referred account receiving tokens.
440         address referrer = referredBy[to];
441         if(referrer != 0x0) {
442             referredBy[to] = 0x0;
443             awardReferralBonus(to, referrer, toTransfer);
444         }
445     }
446 
447     /**
448      * End the ICO phase in accordance with KYC procedures and clean up.
449      *
450      * ---- ICO-Platform Note ----
451      * The horizon-globex.com ICO platform's portal shall halt the ICO at the end of the 
452      * Contribution Period, as defined in the ICO Terms and Conditions https://talketh.io/Terms.
453      *
454      * -- End ICO-Platform Note --
455      */
456     function closeIco() public onlyOwner {
457         require(!isIcoComplete, "The ICO phase has already ended, you cannot close it again.");
458         require((balances[owner] - rewardPool_) == 0, "Cannot close ICO when a balance remains in the owner account.");
459 
460         isIcoComplete = true;
461         delete kycHashes;
462         delete kycValidated;
463 
464         emit IcoComplete();
465     }
466 
467     /**
468      * Internal transfer, can only be called by this contract
469      *
470      * @param from     The sender of the tokens.
471      * @param to       The recipient of the tokens.
472      * @param value    The number of tokens to send.
473      */
474     function _transfer(address from, address to, uint256 value) internal returns (bool) {
475         require(from != 0x0, "Cannot send tokens from null address");
476         require(to != 0x0, "Cannot transfer tokens to null");
477         require(balances[from] >= value, "Insufficient funds");
478 
479         // Quick exit for zero, but allow it in case this transfer is part of a chain.
480         if(value == 0)
481             return true;
482 
483         // Perform the transfer.
484         balances[from] = balances[from].sub(value);
485         balances[to] = balances[to].add(value);
486 
487         // Any tokens sent to to owner are implicitly burned.
488         if (to == owner) {
489             _burn(to, value);
490         }
491 
492         emit Transfer(from, to, value);
493         
494         return true;
495     }
496 
497     /**
498      * Permanently destroy tokens belonging to a user.
499      *
500      * @param addressToBurn    The owner of the tokens to burn.
501      * @param value            The number of tokens to burn.
502      */
503     function _burn(address addressToBurn, uint256 value) private returns (bool success) {
504         require(value > 0, "Tokens to burn must be greater than zero");
505         require(balances[addressToBurn] >= value, "Tokens to burn exceeds balance");
506 
507         balances[addressToBurn] = balances[addressToBurn].sub(value);
508         totalSupply_ = totalSupply_.sub(value);
509 
510         emit Burn(msg.sender, value);
511 
512         return true;
513     }
514 }