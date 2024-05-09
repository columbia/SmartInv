1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5     function mul(uint a, uint b) internal returns (uint) {
6         uint c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint a, uint b) internal returns (uint) {
12         // assert(b > 0); // Solidity automatically throws when dividing by 0
13         uint c = a / b;
14         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17 
18     function sub(uint a, uint b) internal returns (uint) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint a, uint b) internal returns (uint) {
24         uint c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29 }
30 contract Ownable {
31     address public owner;
32 
33 
34     /**
35      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36      * account.
37      */
38     function Ownable() {
39         owner = msg.sender;
40     }
41 
42 
43     /**
44      * @dev Throws if called by any account other than the owner.
45      */
46     modifier onlyOwner() {
47         require(msg.sender == owner);
48         _;
49     }
50 
51 
52     /**
53      * @dev Allows the current owner to transfer control of the contract to a newOwner.
54      * @param newOwner The address to transfer ownership to.
55      */
56     function transferOwnership(address newOwner) onlyOwner {
57         require(newOwner != address(0));
58         owner = newOwner;
59     }
60 
61 }
62 contract ERC20 {
63     uint256 public totalSupply;
64     function balanceOf(address who) public constant returns (uint256);
65     function transfer(address to, uint256 value) public returns (bool);
66     function allowance(address owner, address spender) public constant returns (uint256);
67     function transferFrom(address from, address to, uint256 value) public returns (bool);
68     function approve(address spender, uint256 value) public returns (bool);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     event Burn(address indexed from, uint256 value);
72 }
73 contract ROKToken is ERC20, Ownable {
74     using SafeMath for uint256;
75 
76     string public constant name = "ROK Token";
77     string public constant symbol = "ROK";
78     uint8 public constant decimals = 18;
79     uint256 public constant INITIAL_SUPPLY = 100000000000000000000000000;
80 
81     mapping(address => uint256) balances;
82     mapping (address => mapping (address => uint256)) internal allowed;
83 
84     /**
85   * @dev Contructor that gives msg.sender all of existing tokens.
86   */
87     function ROKToken() {
88         totalSupply = INITIAL_SUPPLY;
89         balances[msg.sender] = INITIAL_SUPPLY;
90     }
91 
92 
93     /**
94     * @dev transfer token for a specified address
95     * @param _to The address to transfer to.
96     * @param _value The amount to be transferred.
97     */
98     function transfer(address _to, uint256 _value) public returns (bool) {
99         require(_to != address(0));
100         require(_value <= balances[msg.sender]);
101 
102         // SafeMath.sub will throw if there is not enough balance.
103         balances[msg.sender] = balances[msg.sender].sub(_value);
104         balances[_to] = balances[_to].add(_value);
105         Transfer(msg.sender, _to, _value);
106         return true;
107     }
108 
109     /**
110     * @dev Gets the balance of the specified address.
111     * @param _owner The address to query the the balance of.
112     * @return An uint256 representing the amount owned by the passed address.
113     */
114     function balanceOf(address _owner) public constant returns (uint256 balance) {
115         return balances[_owner];
116     }
117     /**
118      * @dev Transfer tokens from one address to another
119      * @param _from address The address which you want to send tokens from
120      * @param _to address The address which you want to transfer to
121      * @param _value uint256 the amount of tokens to be transferred
122      */
123     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
124         require(_to != address(0));
125         require(_value <= balances[_from]);
126         require(_value <= allowed[_from][msg.sender]);
127 
128         balances[_from] = balances[_from].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131         Transfer(_from, _to, _value);
132         return true;
133     }
134 
135     /**
136      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
137      *
138      * Beware that changing an allowance with this method brings the risk that someone may use both the old
139      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
140      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
141      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142      * @param _spender The address which will spend the funds.
143      * @param _value The amount of tokens to be spent.
144      */
145     function approve(address _spender, uint256 _value) public returns (bool) {
146         allowed[msg.sender][_spender] = _value;
147         Approval(msg.sender, _spender, _value);
148         return true;
149     }
150 
151     function unlockTransfer(address _spender, uint256 _value) public returns (bool) {
152 
153     }
154 
155     /**
156      * @dev Function to check the amount of tokens that an owner allowed to a spender.
157      * @param _owner address The address which owns the funds.
158      * @param _spender address The address which will spend the funds.
159      * @return A uint256 specifying the amount of tokens still available for the spender.
160      */
161     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
162         return allowed[_owner][_spender];
163     }
164 
165     /**
166      * approve should be called when allowed[_spender] == 0. To increment
167      * allowed value is better to use this function to avoid 2 calls (and wait until
168      * the first transaction is mined)
169      * From MonolithDAO Token.sol
170      */
171     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
172         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
173         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174         return true;
175     }
176 
177     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
178         uint oldValue = allowed[msg.sender][_spender];
179         if (_subtractedValue > oldValue) {
180             allowed[msg.sender][_spender] = 0;
181         } else {
182             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183         }
184         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185         return true;
186     }
187 
188     function burn(uint256 _value) public returns (bool success){
189         require(_value > 0);
190         require(_value <= balances[msg.sender]);
191         // no need to require value <= totalSupply, since that would imply the
192         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
193 
194         address burner = msg.sender;
195         balances[burner] = balances[burner].sub(_value);
196         totalSupply = totalSupply.sub(_value);
197         Burn(burner, _value);
198         return true;
199     }
200 }
201 contract Pausable is Ownable {
202     event Pause();
203 
204     event Unpause();
205 
206     bool public paused = false;
207 
208 
209     /**
210      * @dev modifier to allow actions only when the contract IS paused
211      */
212     modifier whenNotPaused() {
213         require(!paused);
214         _;
215     }
216 
217     /**
218      * @dev modifier to allow actions only when the contract IS NOT paused
219      */
220     modifier whenPaused() {
221         require(paused);
222         _;
223     }
224 
225     /**
226      * @dev called by the owner to pause, triggers stopped state
227      */
228     function pause() onlyOwner whenNotPaused {
229         paused = true;
230         Pause();
231     }
232 
233     /**
234      * @dev called by the owner to unpause, returns to normal state
235      */
236     function unpause() onlyOwner whenPaused {
237         paused = false;
238         Unpause();
239     }
240 }
241 contract PullPayment {
242     using SafeMath for uint256;
243 
244     mapping (address => uint256) public payments;
245 
246     uint256 public totalPayments;
247 
248     /**
249     * @dev Called by the payer to store the sent amount as credit to be pulled.
250     * @param dest The destination address of the funds.
251     * @param amount The amount to transfer.
252     */
253     function asyncSend(address dest, uint256 amount) internal {
254         payments[dest] = payments[dest].add(amount);
255         totalPayments = totalPayments.add(amount);
256     }
257 
258     /**
259     * @dev withdraw accumulated balance, called by payee.
260     */
261     function withdrawPayments() {
262         address payee = msg.sender;
263         uint256 payment = payments[payee];
264 
265         require(payment != 0);
266         require(this.balance >= payment);
267 
268         totalPayments = totalPayments.sub(payment);
269         payments[payee] = 0;
270 
271         assert(payee.send(payment));
272     }
273 }
274 
275 /*
276 *  Crowdsale Smart Contract for the Rockchain project
277 *  Author: Yosra Helal yosra.helal@rockchain.org
278 *  Contributor: Christophe Ozcan christophe.ozcan@crypto4all.com
279 *
280 *
281 *  MultiSig advisors Keys (3/5)
282 *
283 *  Christophe OZCAN        0x75dcB0Ba77e5f99f8ce6F01338Cb235DFE94260c
284 *  Jeff GUILBAULT          0x94ddC32c61BC9a799CdDea87e6a1D1316198b0Fa
285 *  Mark HAHNEL             0xFaE39043B8698CaA4F1417659B00737fa19b8ECC
286 *  Sébastien COLLIGNON     0xd70280108EaF321E100276F6D1b105Ee088CB016
287 *  Sébastien JEHAN         0xE4b0A48D3b1adA17000Fd080cd42DB3e8231752c
288 *
289 *
290 */
291 
292 contract Crowdsale is Pausable, PullPayment {
293     using SafeMath for uint256;
294 
295     address public owner;
296     ROKToken public rok;
297     address public escrow;                                                             // Address of Escrow Provider Wallet
298     address public bounty ;                                                            // Address dedicated for bounty services
299     address public team;                                                               // Adress for ROK token allocated to the team
300     uint256 public rateETH_ROK;                                                        // Rate Ether per ROK token
301     uint256 public constant minimumPurchase = 0.1 ether;                               // Minimum purchase size of incoming ETH
302     uint256 public constant maxFundingGoal = 100000 ether;                             // Maximum goal in Ether raised
303     uint256 public constant minFundingGoal = 18000 ether;                              // Minimum funding goal in Ether raised
304     uint256 public constant startDate = 1509534000;                                    // epoch timestamp representing the start date (1st november 2017 11:00 gmt)
305     uint256 public constant deadline = 1512126000;                                     // epoch timestamp representing the end date (1st december 2017 11:00 gmt)
306     uint256 public constant refundeadline = 1515927600;                                // epoch timestamp representing the end date of refund period (14th january 2018 11:00 gmt)
307     uint256 public savedBalance = 0;                                                   // Total amount raised in ETH
308     uint256 public savedBalanceToken = 0;                                              // Total ROK Token allocated
309     bool public crowdsaleclosed = false;                                               // To finalize crowdsale
310     mapping (address => uint256) balances;                                             // Balances in incoming Ether
311     mapping (address => uint256) balancesRokToken;                                     // Balances in ROK
312     mapping (address => bool) KYClist;
313 
314     // Events to record new contributions
315     event Contribution(address indexed _contributor, uint256 indexed _value, uint256 indexed _tokens);
316 
317     // Event to record each time Ether is paid out
318     event PayEther(
319     address indexed _receiver,
320     uint256 indexed _value,
321     uint256 indexed _timestamp
322     );
323 
324     // Event to record when tokens are burned.
325     event BurnTokens(
326     uint256 indexed _value,
327     uint256 indexed _timestamp
328     );
329 
330     // Initialization
331     function Crowdsale(){
332         owner = msg.sender;
333         // add address of the specific contract
334         rok = ROKToken(0xc9de4b7f0c3d991e967158e4d4bfa4b51ec0b114);
335         escrow = 0x049ca649c977ec36368f31762ff7220db0aae79f;
336         bounty = 0x50Cc6F2D548F7ecc22c9e9F994E4C0F34c7fE8d0;
337         team = 0x33462171A814d4eDa97Cf3a112abE218D05c53C2;
338         rateETH_ROK = 1000;
339     }
340 
341 
342     // Default Function, delegates to contribute function (for ease of use)
343     // WARNING: Not compatible with smart contract invocation, will exceed gas stipend!
344     // Only use from external accounts
345     function() payable whenNotPaused{
346         if (msg.sender == escrow){
347             balances[this] = msg.value;
348         }
349         else{
350             contribute(msg.sender);
351         }
352     }
353 
354     // Contribute Function, accepts incoming payments and tracks balances for each contributors
355     function contribute(address contributor) internal{
356         require(isStarted());
357         require(!isComplete());
358         assert((savedBalance.add(msg.value)) <= maxFundingGoal);
359         assert(msg.value >= minimumPurchase);
360         balances[contributor] = balances[contributor].add(msg.value);
361         savedBalance = savedBalance.add(msg.value);
362         uint256 Roktoken = rateETH_ROK.mul(msg.value) + getBonus(rateETH_ROK.mul(msg.value));
363         uint256 RokToSend = (Roktoken.mul(80)).div(100);
364         balancesRokToken[contributor] = balancesRokToken[contributor].add(RokToSend);
365         savedBalanceToken = savedBalanceToken.add(Roktoken);
366         escrow.transfer(msg.value);
367         PayEther(escrow, msg.value, now);
368     }
369 
370 
371     // Function to check if crowdsale has started yet
372     function isStarted() constant returns (bool) {
373         return now >= startDate;
374     }
375 
376     // Function to check if crowdsale is complete (
377     function isComplete() constant returns (bool) {
378         return (savedBalance >= maxFundingGoal) || (now > deadline) || (savedBalanceToken >= rok.totalSupply()) || (crowdsaleclosed == true);
379     }
380 
381     // Function to view current token balance of the crowdsale contract
382     function tokenBalance() constant returns (uint256 balance) {
383         return rok.balanceOf(address(this));
384     }
385 
386     // Function to check if crowdsale has been successful (has incoming contribution balance met, or exceeded the minimum goal?)
387     function isSuccessful() constant returns (bool) {
388         return (savedBalance >= minFundingGoal);
389     }
390 
391     // Function to check the Ether balance of a contributor
392     function checkEthBalance(address _contributor) constant returns (uint256 balance) {
393         return balances[_contributor];
394     }
395 
396     // Function to check the current Tokens Sold in the ICO
397     function checkRokSold() constant returns (uint256 total) {
398         return (savedBalanceToken);
399         // Function to check the current Tokens Sold in the ICO
400     }
401 
402     // Function to check the current Tokens affected to the team
403     function checkRokTeam() constant returns (uint256 totalteam) {
404         return (savedBalanceToken.mul(19).div(100));
405         // Function to check the current Tokens affected to the team
406     }
407 
408     // Function to check the current Tokens affected to bounty
409     function checkRokBounty() constant returns (uint256 totalbounty) {
410         return (savedBalanceToken.div(100));
411     }
412 
413     // Function to check the refund period is over
414     function refundPeriodOver() constant returns (bool){
415         return (now > refundeadline);
416     }
417 
418     // Function to check the refund period is over
419     function refundPeriodStart() constant returns (bool){
420         return (now > deadline);
421     }
422 
423     // function to check percentage of goal achieved
424     function percentOfGoal() constant returns (uint16 goalPercent) {
425         return uint16((savedBalance.mul(100)).div(minFundingGoal));
426     }
427 
428     // Calcul the ROK bonus according to the investment period
429     function getBonus(uint256 amount) internal constant returns (uint256) {
430         uint bonus = 0;
431         //   5 November 2017 11:00:00 GMT
432         uint firstbonusdate = 1509879600;
433         //  10 November 2017 11:00:00 GMT
434         uint secondbonusdate = 1510311600;
435 
436         //  if investment date is on the 10% bonus period then return bonus
437         if (now <= firstbonusdate) {bonus = amount.div(10);}
438         //  else if investment date is on the 5% bonus period then return bonus
439         else if (now <= secondbonusdate && now >= firstbonusdate) {bonus = amount.div(20);}
440         //  return amount without bonus
441         return bonus;
442     }
443 
444     // Function to set the balance of a sender
445     function setBalance(address sender,uint256 value) internal{
446         balances[sender] = value;
447     }
448 
449     // Only owner will finalize the crowdsale
450     function finalize() onlyOwner {
451         require(isStarted());
452         require(!isComplete());
453         crowdsaleclosed = true;
454     }
455 
456     // Function to pay out
457     function payout() onlyOwner {
458         if (isSuccessful() && isComplete()) {
459             rok.transfer(bounty, checkRokBounty());
460             payTeam();
461         }
462         else {
463             if (refundPeriodOver()) {
464                 escrow.transfer(savedBalance);
465                 PayEther(escrow, savedBalance, now);
466                 rok.transfer(bounty, checkRokBounty());
467                 payTeam();
468             }
469         }
470     }
471 
472     //Function to pay Team
473     function payTeam() internal {
474         assert(checkRokTeam() > 0);
475         rok.transfer(team, checkRokTeam());
476         if (checkRokSold() < rok.totalSupply()) {
477             // burn the rest of ROK
478             rok.burn(rok.totalSupply().sub(checkRokSold()));
479             //Log burn of tokens
480             BurnTokens(rok.totalSupply().sub(checkRokSold()), now);
481         }
482     }
483 
484     //Function to update KYC list
485     function updateKYClist(address[] allowed) onlyOwner{
486         for (uint i = 0; i < allowed.length; i++) {
487             if (KYClist[allowed[i]] == false) {
488                 KYClist[allowed[i]] = true;
489             }
490         }
491     }
492 
493     //Function to claim ROK tokens
494     function claim() public{
495         require(isComplete());
496         require(checkEthBalance(msg.sender) > 0);
497         if(checkEthBalance(msg.sender) <= (3 ether)){
498             rok.transfer(msg.sender,balancesRokToken[msg.sender]);
499             balancesRokToken[msg.sender] = 0;
500         }
501         else{
502             require(KYClist[msg.sender] == true);
503             rok.transfer(msg.sender,balancesRokToken[msg.sender]);
504             balancesRokToken[msg.sender] = 0;
505         }
506     }
507 
508     /* When MIN_CAP is not reach the smart contract will be credited to make refund possible by backers
509      * 1) backer call the "refund" function of the Crowdsale contract
510      * 2) backer call the "withdrawPayments" function of the Crowdsale contract to get a refund in ETH
511      */
512     function refund() public {
513         require(!isSuccessful());
514         require(refundPeriodStart());
515         require(!refundPeriodOver());
516         require(checkEthBalance(msg.sender) > 0);
517         uint ETHToSend = checkEthBalance(msg.sender);
518         setBalance(msg.sender,0);
519         asyncSend(msg.sender, ETHToSend);
520     }
521 
522     /* When MIN_CAP is not reach the smart contract will be credited to make refund possible by backers
523      * 1) backer call the "partialRefund" function of the Crowdsale contract with the partial amount of ETH to be refunded (value will be renseigned in WEI)
524      * 2) backer call the "withdrawPayments" function of the Crowdsale contract to get a refund in ETH
525      */
526     function partialRefund(uint256 value) public {
527         require(!isSuccessful());
528         require(refundPeriodStart());
529         require(!refundPeriodOver());
530         require(checkEthBalance(msg.sender) >= value);
531         setBalance(msg.sender,checkEthBalance(msg.sender).sub(value));
532         asyncSend(msg.sender, value);
533     }
534 
535 }