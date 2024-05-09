1 pragma solidity 0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // ERC Token Standard #20 Interface
5 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
6 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
7 // 
8 // ----------------------------------------------------------------------------
9 interface ERC20Interface {
10     function totalSupply() external view returns (uint256);
11     function balanceOf(address who) external view returns (uint256);
12     function allowance(address approver, address spender) external view returns (uint256);
13     function transfer(address to, uint256 value) external returns (bool);
14     function approve(address spender, uint256 value) external returns (bool);
15     function transferFrom(address from, address to, uint256 value) external returns (bool);
16 
17     // solhint-disable-next-line no-simple-event-func-name
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed approver, address indexed spender, uint256 value);
20 }
21 
22 //
23 // base contract for all our horizon contracts and tokens
24 //
25 contract HorizonContractBase {
26     // The owner of the contract, set at contract creation to the creator.
27     address public owner;
28 
29     constructor() public {
30         owner = msg.sender;
31     }
32 
33     // Contract authorization - only allow the owner to perform certain actions.
34     modifier onlyOwner {
35         require(msg.sender == owner, "Only the owner can call this function.");
36         _;
37     }
38 }
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  *
44  * Source: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
45  */
46 library SafeMath {
47     /**
48      * @dev Multiplies two numbers, throws on overflow.
49      */
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54         uint256 c = a * b;
55         assert(c / a == b);
56         return c;
57     }
58 
59     /**
60     * @dev Integer division of two numbers, truncating the quotient.
61     */
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         // assert(b > 0); // Solidity automatically throws when dividing by 0
64         // uint256 c = a / b;
65         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66         return a / b;
67     }
68 
69     /**
70     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
71     */
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         assert(b <= a);
74         return a - b;
75     }
76 
77     /**
78     * @dev Adds two numbers, throws on overflow.
79     */
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         assert(c >= a);
83         return c;
84     }
85 }
86 
87 /**
88  * ICOToken for the timelessluxurygroup.com by Horizon-Globex.com of Switzerland.
89  *
90  * An ERC20 standard
91  *
92  * Author: Horizon Globex GmbH Development Team
93  *
94  * Dev Notes
95  *   NOTE: There is no fallback function as this contract will never contain Ether, only the ICO tokens.
96  *   NOTE: There is no approveAndCall/receiveApproval or ERC223 functionality.
97  *   NOTE: Coins will never be minted beyond those at contract creation.
98  *   NOTE: Zero transfers are allowed - we don't want to break a valid transaction chain.
99  *   NOTE: There is no selfDestruct, changeOwner or migration path - this is the only contract.
100  */
101 
102 
103 contract ICOToken is ERC20Interface, HorizonContractBase {
104     using SafeMath for uint256;
105 
106     // Contract authorization - only allow the official KYC provider to perform certain actions.
107     modifier onlyKycProvider {
108         require(msg.sender == regulatorApprovedKycProvider, "Only the KYC Provider can call this function.");
109         _;
110     }
111 	
112 	// Contract authorization - only allow the official issuer to perform certain actions.
113     modifier onlyIssuer {
114         require(msg.sender == issuer, "Only the Issuer can call this function.");
115         _;
116     }
117 
118     // The approved KYC provider that verifies all ICO/TGE Contributors.
119     address public regulatorApprovedKycProvider;
120     
121     // The issuer
122     address public issuer;
123 
124     // Public identity variables of the token used by ERC20 platforms.
125     string public name;
126     string public symbol;
127     
128     // There is no good reason to deviate from 18 decimals, see https://github.com/ethereum/EIPs/issues/724.
129     uint8 public decimals = 18;
130     
131     // The total supply of tokens, set at creation, decreased with burn.
132     uint256 public totalSupply_;
133 
134     // The supply of tokens, set at creation, to be allocated for the referral bonuses.
135     uint256 public rewardPool_;
136 
137     // The Initial Coin Offering is finished.
138     bool public isIcoComplete;
139 
140     // The balances of all accounts.
141     mapping (address => uint256) public balances;
142 
143     // KYC submission hashes accepted by KYC service provider for AML/KYC review.
144     bytes32[] public kycHashes;
145 
146     // All users that have passed the external KYC verification checks.
147     address[] public kycValidated;
148 
149     // Addresses authorized to transfer tokens on an account's behalf.
150     mapping (address => mapping (address => uint256)) internal allowanceCollection;
151 
152     // Lookup an ICO/TGE Contributor address to see if it was referred by another address (referee => referrer).
153     mapping (address => address) public referredBy;
154 
155     // Emitted when the Initial Coin Offering phase ends, see closeIco().
156     event IcoComplete();
157 
158     // Notification when tokens are burned by the owner.
159     event Burn(address indexed from, uint256 value);
160     
161     // Emitted when mint event ocurred
162     // added by andrewju
163     event Mint(address indexed from, uint256 value);
164 
165     // Someone who was referred has purchased tokens, when the bonus is awarded log the details.
166     event ReferralRedeemed(address indexed referrer, address indexed referee, uint256 value);
167 
168     /**
169      * Initialise contract with the 50 million initial supply tokens, allocated to
170      * the creator of the contract (the owner).
171      */
172     constructor(uint256 totalSupply, string memory _name, string memory _symbol, uint256 _rewardPool) public {
173 		name = _name;
174 		symbol = _symbol;
175         totalSupply_ = totalSupply * 10 ** uint256(decimals);   // Set the total supply of ICO Tokens.
176         balances[msg.sender] = totalSupply_;
177         rewardPool_ = _rewardPool * 10 ** uint256(decimals);   // Set the total supply of ICO Reward Tokens.
178         
179         setKycProvider(msg.sender);
180         setIssuer(msg.sender);
181         
182     }
183 
184     /**
185      * The total number of tokens that exist.
186      */
187     function totalSupply() public view returns (uint256) {
188         return totalSupply_;
189     }
190 
191     /**
192      * The total number of reward pool tokens that remains.
193      */
194     function rewardPool() public onlyOwner view returns (uint256) {
195         return rewardPool_;
196     }
197 
198     /**
199      * Get the number of tokens for a specific account.
200      *
201      * @param who    The address to get the token balance of.
202      */
203     function balanceOf(address who) public view returns (uint256 balance) {
204         return balances[who];
205     }
206 
207     /**
208      * Get the current allowanceCollection that the approver has allowed 'spender' to spend on their behalf.
209      *
210      * See also: approve() and transferFrom().
211      *
212      * @param _approver  The account that owns the tokens.
213      * @param _spender   The account that can spend the approver's tokens.
214      */
215     function allowance(address _approver, address _spender) public view returns (uint256) {
216         return allowanceCollection[_approver][_spender];
217     }
218 
219     /**
220      * Add the link between the referrer and who they referred.
221      *
222      * ---- ICO-Platform Note ----
223      * The horizon-globex.com ICO platform offers functionality for referrers to sign-up
224      * to refer Contributors. Upon such referred Contributions, Company shall automatically
225      * award 1% of our "owner" ICO tokens to the referrer as coded by this Smart Contract.
226      *
227      * All referrers must successfully complete our ICO KYC review prior to being allowed on-board.
228      * -- End ICO-Platform Note --
229      *
230      * @param referrer  The person doing the referring.
231      * @param referee   The person that was referred.
232      */
233     function refer(address referrer, address referee) public onlyOwner {
234         require(referrer != address(0x0), "Referrer cannot be null");
235         require(referee != address(0x0), "Referee cannot be null");
236         require(!isIcoComplete, "Cannot add new referrals after ICO is complete.");
237 
238         referredBy[referee] = referrer;
239     }
240 
241     /**
242      * Transfer tokens from the caller's account to the recipient.
243      *
244      * @param to    The address of the recipient.
245      * @param value The number of tokens to send.
246      */
247     // solhint-disable-next-line no-simple-event-func-name
248     function transfer(address to, uint256 value) public returns (bool) {
249         return _transfer(msg.sender, to, value);
250     }
251 	
252     /**
253      * Transfer pre-approved tokens on behalf of an account.
254      *
255      * See also: approve() and allowance().
256      *
257      * @param from  The address of the sender
258      * @param to    The address of the recipient
259      * @param value The number of tokens to send
260      */
261     function transferFrom(address from, address to, uint256 value) public returns (bool) {
262         require(value <= allowanceCollection[from][msg.sender], "Amount to transfer is greater than allowance.");
263 		
264         allowanceCollection[from][msg.sender] = allowanceCollection[from][msg.sender].sub(value);
265         _transfer(from, to, value);
266         return true;
267     }
268 
269     /**
270      * Allow another address to spend tokens on your behalf.
271      *
272      * transferFrom can be called multiple times until the approved balance goes to zero.
273      * Subsequent calls to this function overwrite the previous balance.
274      * To change from a non-zero value to another non-zero value you must first set the
275      * allowance to zero - it is best to use safeApprove when doing this as you will
276      * manually have to check for transfers to ensure none happened before the zero allowance
277      * was set.
278      *
279      * @param _spender   The address authorized to spend your tokens.
280      * @param _value     The maximum amount of tokens they can spend.
281      */
282     function approve(address _spender, uint256 _value) public returns (bool) {
283         if(allowanceCollection[msg.sender][_spender] > 0 && _value != 0) {
284             revert("You cannot set a non-zero allowance to another non-zero, you must zero it first.");
285         }
286 
287         allowanceCollection[msg.sender][_spender] = _value;
288         emit Approval(msg.sender, _spender, _value);
289 
290         return true;
291     }
292 
293     /**
294      * Allow another address to spend tokens on your behalf while mitigating a double spend.
295      *
296      * Subsequent calls to this function overwrite the previous balance.
297      * The old value must match the current allowance otherwise this call reverts.
298      *
299      * @param spender   The address authorized to spend your tokens.
300      * @param value     The maximum amount of tokens they can spend.
301      * @param oldValue  The current allowance for this spender.
302      */
303     function safeApprove(address spender, uint256 value, uint256 oldValue) public returns (bool) {
304         require(spender != address(0x0), "Cannot approve null address.");
305         require(oldValue == allowanceCollection[msg.sender][spender], "The expected old value did not match current allowance.");
306 
307         allowanceCollection[msg.sender][spender] = value;
308         emit Approval(msg.sender, spender, value);
309 
310         return true;
311     }
312 
313     /**
314      * The hash for all Know Your Customer information is calculated outside but stored here.
315      * This storage will be cleared once the ICO completes, see closeIco().
316      *
317      * ---- ICO-Platform Note ----
318      * The horizon-globex.com ICO platform's KYC app will register a hash of the Contributors
319      * KYC submission on the blockchain. Our Swiss financial-intermediary KYC provider will be 
320      * notified of the submission and retrieve the Contributor data for formal review.
321      *
322      * All Contributors must successfully complete our ICO KYC review prior to being allowed on-board.
323      * -- End ICO-Platform Note --
324      *
325      * @param sha   The hash of the customer data.
326     */
327     function setKycHash(bytes32 sha) public onlyOwner {
328         require(!isIcoComplete, "The ICO phase has ended, you can no longer set KYC hashes.");
329 
330         kycHashes.push(sha);
331     }
332 
333     /**
334      * A user has passed KYC verification, store them on the blockchain in the order it happened.
335      * This will be cleared once the ICO completes, see closeIco().
336      *
337      * ---- ICO-Platform Note ----
338      * The horizon-globex.com ICO platform's registered KYC provider submits their approval
339      * for this Contributor to particpate using the ICO-Platform portal. 
340      *
341      * Each Contributor will then be sent the Ethereum, Bitcoin and IBAN account numbers to
342      * deposit their Approved Contribution in exchange for ICO Tokens.
343      * -- End ICO-Platform Note --
344      *
345      * @param who   The user's address.
346      */
347     function kycApproved(address who) public onlyKycProvider {
348         require(!isIcoComplete, "The ICO phase has ended, you can no longer approve.");
349         require(who != address(0x0), "Cannot approve a null address.");
350 
351         kycValidated.push(who);
352     }
353 
354     /**
355      * Set the address that has the authority to approve users by KYC.
356      *
357      * ---- ICO-Platform Note ----
358      * The horizon-globex.com ICO platform shall register a fully licensed Swiss KYC
359      * provider to assess each potential Contributor for KYC and AML under Swiss law. 
360      *
361      * -- End ICO-Platform Note --
362      *
363      * @param who   The address of the KYC provider.
364      */
365     function setKycProvider(address who) public onlyOwner {
366         regulatorApprovedKycProvider = who;
367     }
368     
369         /**
370      * Set the issuer address
371      *
372      * @param who   The address of the issuer.
373      */
374     function setIssuer(address who) public onlyOwner {
375         issuer = who;
376     }
377     
378     
379     /**
380      * Retrieve the KYC hash from the specified index.
381      *
382      * @param   index   The index into the array.
383      */
384     function getKycHash(uint256 index) public view returns (bytes32) {
385         return kycHashes[index];
386     }
387 
388     /**
389      * Retrieve the validated KYC address from the specified index.
390      *
391      * @param   index   The index into the array.
392      */
393     function getKycApproved(uint256 index) public view returns (address) {
394         return kycValidated[index];
395     }
396 
397     /**
398      * When someone referred (the referee) purchases tokens the referrer gets a 1% bonus from the central pool.
399      *
400      * ---- ICO-Platform Note ----
401      * The horizon-globex.com ICO platform's portal shall award referrers as part of the ICO
402      * ICO Token issuance procedure as overseen by the Swiss KYC provider. 
403      *
404      * -- End ICO-Platform Note --
405      *
406      * @param referee   The referred account who just purchased some tokens.
407      * @param referrer  The account that referred the one purchasing tokens.
408      * @param value     The number of tokens purchased by the referee.
409     */
410     function awardReferralBonus(address referee, address referrer, uint256 value) private {
411         uint256 bonus = value / 100;
412         balances[owner] = balances[owner].sub(bonus);
413         balances[referrer] = balances[referrer].add(bonus);
414         rewardPool_ -= bonus;
415         emit ReferralRedeemed(referee, referrer, bonus);
416     }
417 
418     /**
419      * During the ICO phase the owner will allocate tokens once KYC completes and funds are deposited.
420      *
421      * ---- ICO-Platform Note ----
422      * The horizon-globex.com ICO platform's portal shall issue ICO Token to Contributors on receipt of 
423      * the Approved Contribution funds at the KYC providers Escrow account/wallets.
424      * Only after ICO Tokens are issued to the Contributor can the Swiss KYC provider allow the transfer
425      * of funds from their Escrow to Company.
426      *
427      * -- End ICO-Platform Note --
428      *
429      * @param to       The recipient of the tokens.
430      * @param value    The number of tokens to send.
431      */
432     function icoTransfer(address to, uint256 value) public onlyOwner {
433         require(!isIcoComplete, "ICO is complete, use transfer().");
434 
435         // If an attempt is made to transfer more tokens than owned, transfer the remainder.
436         uint256 toTransfer = (value > (balances[msg.sender] - rewardPool_ )) ? (balances[msg.sender] - rewardPool_) : value;
437         
438         _transfer(msg.sender, to, toTransfer);
439 
440         // Handle a referred account receiving tokens.
441         address referrer = referredBy[to];
442         if(referrer != address(0x0)) {
443             referredBy[to] = address(0x0);
444             awardReferralBonus(to, referrer, toTransfer);
445         }
446     }
447 
448     /**
449      * End the ICO phase in accordance with KYC procedures and clean up.
450      *
451      * ---- ICO-Platform Note ----
452      * The horizon-globex.com ICO platform's portal shall halt the ICO at the end of the 
453      * Contribution Period, as defined in the ICO Terms and Conditions at timelessluxurygroup.com.
454      *
455      * -- End ICO-Platform Note --
456      */
457     function closeIco() public onlyOwner {
458         require(!isIcoComplete, "The ICO phase has already ended, you cannot close it again.");
459         require((balances[owner] - rewardPool_) == 0, "Cannot close ICO when a balance remains in the owner account.");
460 
461         isIcoComplete = true;
462         delete kycHashes;
463         delete kycValidated;
464 
465         emit IcoComplete();
466     }
467 	
468     /**
469      * Internal transfer, can only be called by this contract
470      *
471      * @param from     The sender of the tokens.
472      * @param to       The recipient of the tokens.
473      * @param value    The number of tokens to send.
474      */
475     function _transfer(address from, address to, uint256 value) internal returns (bool) {
476         require(from != address(0x0), "Cannot send tokens from null address");
477         require(to != address(0x0), "Cannot transfer tokens to null");
478         require(balances[from] >= value, "Insufficient funds");
479 
480         // Quick exit for zero, but allow it in case this transfer is part of a chain.
481         if(value == 0)
482             return true;
483 		
484         // Perform the transfer.
485         balances[from] = balances[from].sub(value);
486         balances[to] = balances[to].add(value);
487 		
488         // Any tokens sent to to owner are implicitly burned.
489         if (to == owner) {
490             _burn(to, value);
491         }
492 
493         return true;
494     }
495     
496     /**
497      * Permanently mint tokens to increase the totalSupply_.
498      *
499      * @param value            The number of tokens to mint.
500      */
501     function mint(uint256 value) public onlyIssuer {
502         require(value > 0, "Tokens to mint must be greater than zero");
503         balances[owner] = balances[owner].add(value);
504         totalSupply_ = totalSupply_.add(value);
505         
506         emit Mint(msg.sender, value);
507         
508     }
509     
510     /**
511      * Permanently destroy tokens from totalSupply_.
512      *
513      * @param value            The number of tokens to burn.
514      */
515     function burn(uint256 value) public onlyIssuer {
516         _burn(owner, value);
517     }
518 
519     /**
520      * Permanently destroy tokens belonging to a user.
521      *
522      * @param addressToBurn    The owner of the tokens to burn.
523      * @param value            The number of tokens to burn.
524      */
525     function _burn(address addressToBurn, uint256 value) private returns (bool success) {
526         require(value > 0, "Tokens to burn must be greater than zero");
527         require(balances[addressToBurn] >= value, "Tokens to burn exceeds balance");
528 
529         balances[addressToBurn] = balances[addressToBurn].sub(value);
530         totalSupply_ = totalSupply_.sub(value);
531 
532         emit Burn(msg.sender, value);
533 
534         return true;
535     }
536 }