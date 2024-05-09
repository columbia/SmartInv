1 pragma solidity ^0.4.15;
2 
3 
4 /*
5 *  deex.exchange pre-ICO tokens smart contract
6 *  implements [ERC-20 Token Standard](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md)
7 *
8 *  Style
9 *  1) before start coding, run Python and type 'import this' in Python console.
10 *  2) we avoid using inheritance (contract B is A) as it makes code less clear for observer
11 *  ("Flat is better than nested", "Readability counts")
12 *  3) we avoid using -= ; =- ; +=; =+
13 *  see: https://github.com/ether-camp/virtual-accelerator/issues/8
14 *  https://www.ethnews.com/ethercamps-hkg-token-has-a-bug-and-needs-to-be-reissued
15 *  4) always explicitly mark variables and functions visibility ("Explicit is better than implicit")
16 *  5) every function except constructor should trigger at leas one event.
17 *  6) smart contracts have to be audited and reviewed, comment your code.
18 *
19 *  Code is published on https://github.com/thedeex/thedeex.github.io
20 */
21 
22 
23 /* "Interfaces" */
24 
25 //  this is expected from another contracts
26 //  if it wants to spend tokens of behalf of the token owner in our contract
27 //  this can be used in many situations, for example to convert pre-ICO tokens to ICO tokens
28 //  see 'approveAndCall' function
29 contract allowanceRecipient {
30     function receiveApproval(address _from, uint256 _value, address _inContract, bytes _extraData) returns (bool success);
31 }
32 
33 
34 // see:
35 // https://github.com/ethereum/EIPs/issues/677
36 contract tokenRecipient {
37     function tokenFallback(address _from, uint256 _value, bytes _extraData) returns (bool success);
38 }
39 
40 
41 contract DEEX {
42 
43     // ver. 2.0
44 
45     /* ---------- Variables */
46 
47     /* --- ERC-20 variables */
48 
49     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#name
50     // function name() constant returns (string name)
51     string public name = "deex";
52 
53     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#symbol
54     // function symbol() constant returns (string symbol)
55     string public symbol = "deex";
56 
57     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#decimals
58     // function decimals() constant returns (uint8 decimals)
59     uint8 public decimals = 0;
60 
61     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#totalsupply
62     // function totalSupply() constant returns (uint256 totalSupply)
63     // we start with zero and will create tokens as SC receives ETH
64     uint256 public totalSupply;
65 
66     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#balanceof
67     // function balanceOf(address _owner) constant returns (uint256 balance)
68     mapping (address => uint256) public balanceOf;
69 
70     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#allowance
71     // function allowance(address _owner, address _spender) constant returns (uint256 remaining)
72     mapping (address => mapping (address => uint256)) public allowance;
73 
74     /* ----- For tokens sale */
75 
76     uint256 public salesCounter = 0;
77 
78     uint256 public maxSalesAllowed;
79 
80     bool private transfersBetweenSalesAllowed;
81 
82     // initial value should be changed by the owner
83     uint256 public tokenPriceInWei = 0;
84 
85     uint256 public saleStartUnixTime = 0; // block.timestamp
86     uint256 public saleEndUnixTime = 0;  // block.timestamp
87 
88     /* --- administrative */
89     address public owner;
90 
91     // account that can set prices
92     address public priceSetter;
93 
94     // 0 - not set
95     uint256 private priceMaxWei = 0;
96     // 0 - not set
97     uint256 private priceMinWei = 0;
98 
99     // accounts holding tokens for for the team, for advisers and for the bounty campaign
100     mapping (address => bool) public isPreferredTokensAccount;
101 
102     bool public contractInitialized = false;
103 
104 
105     /* ---------- Constructor */
106     // do not forget about:
107     // https://medium.com/@codetractio/a-look-into-paritys-multisig-wallet-bug-affecting-100-million-in-ether-and-tokens-356f5ba6e90a
108     function DEEX() {
109         owner = msg.sender;
110 
111         // for testNet can be more than 2
112         // --------------------------------2------------------------------------------------------change  in production!
113         maxSalesAllowed = 2;
114         //
115         transfersBetweenSalesAllowed = true;
116     }
117 
118 
119     function initContract(address team, address advisers, address bounty) public onlyBy(owner) returns (bool){
120 
121         require(contractInitialized == false);
122         contractInitialized = true;
123 
124         priceSetter = msg.sender;
125 
126         totalSupply = 100000000;
127 
128         // tokens for sale go SC own account
129         balanceOf[this] = 75000000;
130 
131         // for the team
132         balanceOf[team] = balanceOf[team] + 15000000;
133         isPreferredTokensAccount[team] = true;
134 
135         // for advisers
136         balanceOf[advisers] = balanceOf[advisers] + 7000000;
137         isPreferredTokensAccount[advisers] = true;
138 
139         // for the bounty campaign
140         balanceOf[bounty] = balanceOf[bounty] + 3000000;
141         isPreferredTokensAccount[bounty] = true;
142 
143     }
144 
145     /* ---------- Events */
146 
147     /* --- ERC-20 events */
148     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#events
149 
150     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer-1
151     event Transfer(address indexed from, address indexed to, uint256 value);
152 
153     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approval
154     event Approval(address indexed _owner, address indexed spender, uint256 value);
155 
156     /* --- Administrative events:  */
157     event OwnerChanged(address indexed oldOwner, address indexed newOwner);
158 
159     /* ---- Tokens creation and sale events  */
160 
161     event PriceChanged(uint256 indexed newTokenPriceInWei);
162 
163     event SaleStarted(uint256 startUnixTime, uint256 endUnixTime, uint256 indexed saleNumber);
164 
165     event NewTokensSold(uint256 numberOfTokens, address indexed purchasedBy, uint256 indexed priceInWei);
166 
167     event Withdrawal(address indexed to, uint sumInWei);
168 
169     /* --- Interaction with other contracts events  */
170     event DataSentToAnotherContract(address indexed _from, address indexed _toContract, bytes _extraData);
171 
172     /* ---------- Functions */
173 
174     /* --- Modifiers  */
175     modifier onlyBy(address _account){
176         require(msg.sender == _account);
177 
178         _;
179     }
180 
181     /* --- ERC-20 Functions */
182     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#methods
183 
184     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer
185     function transfer(address _to, uint256 _value) public returns (bool){
186         return transferFrom(msg.sender, _to, _value);
187     }
188 
189     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transferfrom
190     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
191 
192         // transfers are possible only after sale is finished
193         // except for manager and preferred accounts
194 
195         bool saleFinished = saleIsFinished();
196         require(saleFinished || msg.sender == owner || isPreferredTokensAccount[msg.sender]);
197 
198         // transfers can be forbidden until final ICO is finished
199         // except for manager and preferred accounts
200         require(transfersBetweenSalesAllowed || salesCounter == maxSalesAllowed || msg.sender == owner || isPreferredTokensAccount[msg.sender]);
201 
202         // Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event (ERC-20)
203         require(_value >= 0);
204 
205         // The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism
206         require(msg.sender == _from || _value <= allowance[_from][msg.sender]);
207 
208         // check if _from account have required amount
209         require(_value <= balanceOf[_from]);
210 
211         // Subtract from the sender
212         balanceOf[_from] = balanceOf[_from] - _value;
213         //
214         // Add the same to the recipient
215         balanceOf[_to] = balanceOf[_to] + _value;
216 
217         // If allowance used, change allowances correspondingly
218         if (_from != msg.sender) {
219             allowance[_from][msg.sender] = allowance[_from][msg.sender] - _value;
220         }
221 
222         // event
223         Transfer(_from, _to, _value);
224 
225         return true;
226     }
227 
228     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approve
229     // there is and attack, see:
230     // https://github.com/CORIONplatform/solidity/issues/6,
231     // https://drive.google.com/file/d/0ByMtMw2hul0EN3NCaVFHSFdxRzA/view
232     // but this function is required by ERC-20
233     function approve(address _spender, uint256 _value) public returns (bool success){
234 
235         require(_value >= 0);
236 
237         allowance[msg.sender][_spender] = _value;
238 
239         // event
240         Approval(msg.sender, _spender, _value);
241 
242         return true;
243     }
244 
245     /*  ---------- Interaction with other contracts  */
246 
247     /* User can allow another smart contract to spend some shares in his behalf
248     *  (this function should be called by user itself)
249     *  @param _spender another contract's address
250     *  @param _value number of tokens
251     *  @param _extraData Data that can be sent from user to another contract to be processed
252     *  bytes - dynamically-sized byte array,
253     *  see http://solidity.readthedocs.io/en/v0.4.15/types.html#dynamically-sized-byte-array
254     *  see possible attack information in comments to function 'approve'
255     *  > this may be used to convert pre-ICO tokens to ICO tokens
256     */
257     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
258 
259         approve(_spender, _value);
260 
261         // 'spender' is another contract that implements code as prescribed in 'allowanceRecipient' above
262         allowanceRecipient spender = allowanceRecipient(_spender);
263 
264         // our contract calls 'receiveApproval' function of another contract ('allowanceRecipient') to send information about
265         // allowance and data sent by user
266         // 'this' is this (our) contract address
267         if (spender.receiveApproval(msg.sender, _value, this, _extraData)) {
268             DataSentToAnotherContract(msg.sender, _spender, _extraData);
269             return true;
270         }
271         else return false;
272     }
273 
274     function approveAllAndCall(address _spender, bytes _extraData) public returns (bool success) {
275         return approveAndCall(_spender, balanceOf[msg.sender], _extraData);
276     }
277 
278     /* https://github.com/ethereum/EIPs/issues/677
279     * transfer tokens with additional info to another smart contract, and calls its correspondent function
280     * @param address _to - another smart contract address
281     * @param uint256 _value - number of tokens
282     * @param bytes _extraData - data to send to another contract
283     * > this may be used to convert pre-ICO tokens to ICO tokens
284     */
285     function transferAndCall(address _to, uint256 _value, bytes _extraData) public returns (bool success){
286 
287         transferFrom(msg.sender, _to, _value);
288 
289         tokenRecipient receiver = tokenRecipient(_to);
290 
291         if (receiver.tokenFallback(msg.sender, _value, _extraData)) {
292             DataSentToAnotherContract(msg.sender, _to, _extraData);
293             return true;
294         }
295         else return false;
296     }
297 
298     // for example for conveting ALL tokens of user account to another tokens
299     function transferAllAndCall(address _to, bytes _extraData) public returns (bool success){
300         return transferAndCall(_to, balanceOf[msg.sender], _extraData);
301     }
302 
303     /* --- Administrative functions */
304 
305     function changeOwner(address _newOwner) public onlyBy(owner) returns (bool success){
306         //
307         require(_newOwner != address(0));
308 
309         address oldOwner = owner;
310         owner = _newOwner;
311 
312         OwnerChanged(oldOwner, _newOwner);
313 
314         return true;
315     }
316 
317     /* ---------- Create and sell tokens  */
318 
319     /* set time for start and time for end pre-ICO
320     * time is integer representing block timestamp
321     * in UNIX Time,
322     * see: https://www.epochconverter.com
323     * @param uint256 startTime - time to start
324     * @param uint256 endTime - time to end
325     * should be taken into account that
326     * "block.timestamp" can be influenced by miners to a certain degree.
327     * That means that a miner can "choose" the block.timestamp, to a certain degree,
328     * to change the outcome of a transaction in the mined block.
329     * see:
330     * http://solidity.readthedocs.io/en/v0.4.15/frequently-asked-questions.html#are-timestamps-now-block-timestamp-reliable
331     */
332 
333     function startSale(uint256 _startUnixTime, uint256 _endUnixTime) public onlyBy(owner) returns (bool success){
334 
335         require(balanceOf[this] > 0);
336         require(salesCounter < maxSalesAllowed);
337 
338         // time for sale can be set only if:
339         // this is first sale (saleStartUnixTime == 0 && saleEndUnixTime == 0) , or:
340         // previous sale finished ( saleIsFinished() )
341         require(
342         (saleStartUnixTime == 0 && saleEndUnixTime == 0) || saleIsFinished()
343         );
344         // time can be set only for future
345         require(_startUnixTime > now && _endUnixTime > now);
346         // end time should be later than start time
347         require(_endUnixTime - _startUnixTime > 0);
348 
349         saleStartUnixTime = _startUnixTime;
350         saleEndUnixTime = _endUnixTime;
351         salesCounter = salesCounter + 1;
352 
353         SaleStarted(_startUnixTime, _endUnixTime, salesCounter);
354 
355         return true;
356     }
357 
358     function saleIsRunning() public constant returns (bool){
359 
360         if (balanceOf[this] == 0) {
361             return false;
362         }
363 
364         if (saleStartUnixTime == 0 && saleEndUnixTime == 0) {
365             return false;
366         }
367 
368         if (now > saleStartUnixTime && now < saleEndUnixTime) {
369             return true;
370         }
371 
372         return false;
373     }
374 
375     function saleIsFinished() public constant returns (bool){
376 
377         if (balanceOf[this] == 0) {
378             return true;
379         }
380 
381         else if (
382         (saleStartUnixTime > 0 && saleEndUnixTime > 0)
383         && now > saleEndUnixTime) {
384 
385             return true;
386         }
387 
388         // <<<
389         return false;
390     }
391 
392     function changePriceSetter(address _priceSetter) public onlyBy(owner) returns (bool success) {
393         priceSetter = _priceSetter;
394         return true;
395     }
396 
397     function setMinMaxPriceInWei(uint256 _priceMinWei, uint256 _priceMaxWei) public onlyBy(owner) returns (bool success){
398         require(_priceMinWei >= 0 && _priceMaxWei >= 0);
399         priceMinWei = _priceMinWei;
400         priceMaxWei = _priceMaxWei;
401         return true;
402     }
403 
404 
405     function setTokenPriceInWei(uint256 _priceInWei) public onlyBy(priceSetter) returns (bool success){
406 
407         require(_priceInWei >= 0);
408 
409         // if 0 - not set
410         if (priceMinWei != 0 && _priceInWei < priceMinWei) {
411             tokenPriceInWei = priceMinWei;
412         }
413         else if (priceMaxWei != 0 && _priceInWei > priceMaxWei) {
414             tokenPriceInWei = priceMaxWei;
415         }
416         else {
417             tokenPriceInWei = _priceInWei;
418         }
419 
420         PriceChanged(tokenPriceInWei);
421 
422         return true;
423     }
424 
425     // allows sending ether and receiving tokens just using contract address
426     // warning:
427     // 'If the fallback function requires more than 2300 gas, the contract cannot receive Ether'
428     // see:
429     // https://ethereum.stackexchange.com/questions/21643/fallback-function-best-practices-when-registering-information
430     function() public payable {
431         buyTokens();
432     }
433 
434     //
435     function buyTokens() public payable returns (bool success){
436 
437         if (saleIsRunning() && tokenPriceInWei > 0) {
438 
439             uint256 numberOfTokens = msg.value / tokenPriceInWei;
440 
441             if (numberOfTokens <= balanceOf[this]) {
442 
443                 balanceOf[msg.sender] = balanceOf[msg.sender] + numberOfTokens;
444                 balanceOf[this] = balanceOf[this] - numberOfTokens;
445 
446                 NewTokensSold(numberOfTokens, msg.sender, tokenPriceInWei);
447 
448                 return true;
449             }
450             else {
451                 // (payable)
452                 revert();
453             }
454         }
455         else {
456             // (payable)
457             revert();
458         }
459     }
460 
461     /*  After sale contract owner
462     *  (can be another contract or account)
463     *  can withdraw all collected Ether
464     */
465     function withdrawAllToOwner() public onlyBy(owner) returns (bool) {
466 
467         // only after sale is finished:
468         require(saleIsFinished());
469         uint256 sumInWei = this.balance;
470 
471         if (
472         // makes withdrawal and returns true or false
473         !msg.sender.send(this.balance)
474         ) {
475             return false;
476         }
477         else {
478             // event
479             Withdrawal(msg.sender, sumInWei);
480             return true;
481         }
482     }
483 
484     /* ---------- Referral System */
485 
486     // list of registered referrers
487     // represented by keccak256(address) (returns bytes32)
488     // ! referrers can not be removed !
489     mapping (bytes32 => bool) private isReferrer;
490 
491     uint256 private referralBonus = 0;
492 
493     uint256 private referrerBonus = 0;
494     // tokens owned by referrers:
495     mapping (bytes32 => uint256) public referrerBalanceOf;
496 
497     mapping (bytes32 => uint) public referrerLinkedSales;
498 
499     function addReferrer(bytes32 _referrer) public onlyBy(owner) returns (bool success){
500         isReferrer[_referrer] = true;
501         return true;
502     }
503 
504     function removeReferrer(bytes32 _referrer) public onlyBy(owner) returns (bool success){
505         isReferrer[_referrer] = false;
506         return true;
507     }
508 
509     // bonuses are set in as integers (20%, 30%), initial 0%
510     function setReferralBonuses(uint256 _referralBonus, uint256 _referrerBonus) public onlyBy(owner) returns (bool success){
511         require(_referralBonus > 0 && _referrerBonus > 0);
512         referralBonus = _referralBonus;
513         referrerBonus = _referrerBonus;
514         return true;
515     }
516 
517     function buyTokensWithReferrerAddress(address _referrer) public payable returns (bool success){
518 
519         bytes32 referrer = keccak256(_referrer);
520 
521         if (saleIsRunning() && tokenPriceInWei > 0) {
522 
523             if (isReferrer[referrer]) {
524 
525                 uint256 numberOfTokens = msg.value / tokenPriceInWei;
526 
527                 if (numberOfTokens <= balanceOf[this]) {
528 
529                     referrerLinkedSales[referrer] = referrerLinkedSales[referrer] + numberOfTokens;
530 
531                     uint256 referralBonusTokens = (numberOfTokens * (100 + referralBonus) / 100) - numberOfTokens;
532                     uint256 referrerBonusTokens = (numberOfTokens * (100 + referrerBonus) / 100) - numberOfTokens;
533 
534                     balanceOf[this] = balanceOf[this] - numberOfTokens - referralBonusTokens - referrerBonusTokens;
535 
536                     balanceOf[msg.sender] = balanceOf[msg.sender] + (numberOfTokens + referralBonusTokens);
537 
538                     referrerBalanceOf[referrer] = referrerBalanceOf[referrer] + referrerBonusTokens;
539 
540                     NewTokensSold(numberOfTokens + referralBonusTokens, msg.sender, tokenPriceInWei);
541 
542                     return true;
543                 }
544                 else {
545                     // (payable)
546                     revert();
547                 }
548             }
549             else {
550                 // (payable)
551                 buyTokens();
552             }
553         }
554         else {
555             // (payable)
556             revert();
557         }
558     }
559 
560     event ReferrerBonusTokensTaken(address referrer, uint256 bonusTokensValue);
561 
562     function getReferrerBonusTokens() public returns (bool success){
563         require(saleIsFinished());
564         uint256 bonusTokens = referrerBalanceOf[keccak256(msg.sender)];
565         balanceOf[msg.sender] = balanceOf[msg.sender] + bonusTokens;
566         ReferrerBonusTokensTaken(msg.sender, bonusTokens);
567         return true;
568     }
569 
570 }