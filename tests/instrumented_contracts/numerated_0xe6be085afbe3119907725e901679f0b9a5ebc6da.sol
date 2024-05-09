1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 interface token {
38     function mint(address _to, uint256 _amount) public returns (bool);     
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
40     function transferOwnership(address newOwner) public;
41     
42 }
43 
44 /**
45  * @title Ownable
46  * @dev The Ownable contract has an owner address, and provides basic authorization control
47  * functions, this simplifies the implementation of "user permissions".
48  */
49 contract Ownable {
50     address public owner;
51 
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56     /**
57     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58     * account.
59     */
60     function Ownable() public {
61         owner = msg.sender;
62     }
63 
64     /**
65     * @dev Throws if called by any account other than the owner.
66     */
67     modifier onlyOwner() {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     /**
73     * @dev Allows the current owner to transfer control of the contract to a newOwner.
74     * @param newOwner The address to transfer ownership to.
75     */
76     function transferOwnership(address newOwner) public onlyOwner {
77         require(newOwner != address(0));
78         emit OwnershipTransferred(owner, newOwner);
79         owner = newOwner;
80     }
81 
82 }
83 
84 
85 /**
86  * @title Crowdsale
87  * @dev Crowdsale is a base contract for managing a token crowdsale.
88  * Crowdsales have a start and end timestamps, where investors can make
89  * token purchases and the crowdsale will assign them tokens based
90  * on a token per ETH rate. Funds collected are forwarded to a wallet
91  * as they arrive.
92  */
93 contract Crowdsale {
94     using SafeMath for uint256;
95 
96     // The token being sold
97     token public tokenReward;
98 
99     // start and end timestamps where investments are allowed (both inclusive)
100     uint256 public startTime;
101     uint256 public endTime;
102 
103     // address where funds are collected
104     address public wallet;
105 
106     // how many token units a buyer gets per wei
107     uint256 public rate;
108 
109     // amount of raised money in wei
110     uint256 public weiRaised;
111 
112     /**
113     * event for token purchase logging
114     * @param purchaser who paid for the tokens
115     * @param beneficiary who got the tokens
116     * @param value weis paid for purchase
117     * @param amount amount of tokens purchased
118     */
119     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
120 
121 
122     function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _token) public {
123         //require(_startTime >= now);
124         require(_endTime >= _startTime);
125         require(_rate > 0);
126         require(_wallet != address(0));
127 
128         // token = createTokenContract();
129         tokenReward = token(_token);
130         startTime = _startTime;
131         endTime = _endTime;
132         rate = _rate;
133         wallet = _wallet;
134     }
135 
136     // creates the token to be sold.
137     // override this method to have crowdsale of a specific mintable token.
138     // function createTokenContract() internal returns (MintableToken) {
139     //     return new MintableToken();
140     // }
141 
142     // send ether to the fund collection wallet
143     // override to create custom fund forwarding mechanisms
144     function forwardFunds() internal {
145         wallet.transfer(msg.value);
146     }
147 
148     // @return true if the transaction can buy tokens
149     function validPurchase() internal view returns (bool) {
150         bool withinPeriod = now >= startTime && now <= endTime;
151         bool nonZeroPurchase = msg.value != 0;
152         return withinPeriod && nonZeroPurchase;
153     }
154 
155     // @return true if crowdsale event has ended
156     function hasEnded() public view returns (bool) {
157         return now > endTime;
158     }
159 
160 
161 }
162 
163 /**
164  * @title RefundVault
165  * @dev This contract is used for storing funds while a crowdsale
166  * is in progress. Supports refunding the money if crowdsale fails,
167  * and forwarding it if crowdsale is successful.
168  */
169 contract RefundVault is Ownable {
170     using SafeMath for uint256;
171 
172     enum State { Active, Refunding, Closed }
173 
174     mapping (address => uint256) public deposited;
175     address public wallet;
176     State public state;
177 
178     event Closed();
179     event RefundsEnabled();
180     event Refunded(address indexed beneficiary, uint256 weiAmount);
181 
182     function RefundVault(address _wallet) public {
183         require(_wallet != address(0));
184         wallet = _wallet;
185         state = State.Active;
186     }
187 
188     function deposit(address investor) onlyOwner public payable {
189         require(state == State.Active);
190         deposited[investor] = deposited[investor].add(msg.value);
191     }
192 
193     function close() onlyOwner public {
194         require(state == State.Active);
195         state = State.Closed;
196         emit Closed();
197         wallet.transfer(this.balance);
198     }
199 
200     function enableRefunds() onlyOwner public {
201         require(state == State.Active);
202         state = State.Refunding;
203         emit RefundsEnabled();
204     }
205 
206     function refund(address investor) public {
207         require(state == State.Refunding);
208         uint256 depositedValue = deposited[investor];
209         deposited[investor] = 0;
210         investor.transfer(depositedValue);
211         emit Refunded(investor, depositedValue);
212     }
213 }
214 
215 
216 /**
217  * @title FinalizableCrowdsale
218  * @dev Extension of Crowdsale where an owner can do extra work
219  * after finishing.
220  */
221 contract FinalizableCrowdsale is Crowdsale, Ownable {
222     using SafeMath for uint256;
223 
224     bool public isFinalized = false;
225 
226     event Finalized();
227 
228     /**
229     * @dev Must be called after crowdsale ends, to do some extra finalization
230     * work. Calls the contract's finalization function.
231     */
232     function finalize() onlyOwner public {
233         require(!isFinalized);
234         require(hasEnded());
235 
236         finalization();
237         emit Finalized();
238 
239         isFinalized = true;
240     }
241 
242   /**
243    * @dev Can be overridden to add finalization logic. The overriding function
244    * should call super.finalization() to ensure the chain of finalization is
245    * executed entirely.
246    */
247     function finalization() internal {
248     }
249 }
250 /**
251  * @title RefundableCrowdsale
252  * @dev Extension of Crowdsale contract that adds a funding goal, and
253  * the possibility of users getting a refund if goal is not met.
254  * Uses a RefundVault as the crowdsale's vault.
255  */
256 contract RefundableCrowdsale is FinalizableCrowdsale {
257     using SafeMath for uint256;
258 
259     // minimum amount of funds to be raised in weis
260     uint256 public goal;
261 
262     // refund vault used to hold funds while crowdsale is running
263     RefundVault public vault;
264 
265     function RefundableCrowdsale(uint256 _goal) public {
266         require(_goal > 0);
267         vault = new RefundVault(wallet);
268         goal = _goal;
269     }
270 
271     // We're overriding the fund forwarding from Crowdsale.
272     // In addition to sending the funds, we want to call
273     // the RefundVault deposit function
274     function forwardFunds() internal {
275         vault.deposit.value(msg.value)(msg.sender);
276     }
277 
278     // if crowdsale is unsuccessful, investors can claim refunds here
279     function claimRefund() public {
280         require(isFinalized);
281         require(!goalReached());
282 
283         vault.refund(msg.sender);
284     }
285 
286     // vault finalization task, called when owner calls finalize()
287     function finalization() internal {
288         if (!goalReached()) {
289             vault.enableRefunds(); 
290         } 
291 
292         super.finalization();
293     }
294 
295     function goalReached() public view returns (bool) {
296         return weiRaised >= goal;
297     }
298 
299 }
300 
301 /**
302  * @title CappedCrowdsale
303  * @dev Extension of Crowdsale with a max amount of funds raised
304  */
305 contract CappedCrowdsale is Crowdsale {
306     using SafeMath for uint256;
307 
308     uint256 public cap;
309 
310     function CappedCrowdsale(uint256 _cap) public {
311         require(_cap > 0);
312         cap = _cap;
313     }
314 
315 
316     // overriding Crowdsale#hasEnded to add cap logic
317     // @return true if crowdsale event has ended
318     function hasEnded() public view returns (bool) {
319         bool capReached = weiRaised >= cap;
320         return super.hasEnded() || capReached;
321     }
322 
323 }
324 
325 contract ControlledAccess is Ownable {
326     address public signer;
327     event SignerTransferred(address indexed previousSigner, address indexed newSigner);
328 
329      /**
330     * @dev Throws if called by any account other than the signer.
331     */
332     modifier onlySigner() {
333         require(msg.sender == signer);
334         _;
335     }
336     /**
337     * @dev Allows the current owner to transfer the signer of the contract to a newSigner.
338     * @param newSigner The address to transfer signership to.
339     */
340 
341     function transferSigner(address newSigner) public onlyOwner {
342         require(newSigner != address(0));
343         emit SignerTransferred(signer, newSigner);
344         signer = newSigner;
345     }
346     
347    /* 
348     * @dev Requires msg.sender to have valid access message.
349     * @param _v ECDSA signature parameter v.
350     * @param _r ECDSA signature parameters r.
351     * @param _s ECDSA signature parameters s.
352     */
353     modifier onlyValidAccess(uint8 _v, bytes32 _r, bytes32 _s) 
354     {
355         require(isValidAccessMessage(msg.sender,_v,_r,_s) );
356         _;
357     }
358  
359     /* 
360     * @dev Verifies if message was signed by owner to give access to _add for this contract.
361     *      Assumes Geth signature prefix.
362     * @param _add Address of agent with access
363     * @param _v ECDSA signature parameter v.
364     * @param _r ECDSA signature parameters r.
365     * @param _s ECDSA signature parameters s.
366     * @return Validity of access message for a given address.
367     */
368     function isValidAccessMessage(
369         address _add,
370         uint8 _v, 
371         bytes32 _r, 
372         bytes32 _s) 
373         view public returns (bool)
374     {
375         bytes32 hash = keccak256(this, _add);
376         return signer == ecrecover(
377             keccak256("\x19Ethereum Signed Message:\n32", hash),
378             _v,
379             _r,
380             _s
381         );
382     }
383 }
384 
385 contract ElepigCrowdsale is CappedCrowdsale, RefundableCrowdsale, ControlledAccess {
386     using SafeMath for uint256;
387     
388     // ICO Stage  
389     // ============
390     enum CrowdsaleStage { PreICO, ICO1, ICO2, ICO3, ICO4 } //Sale has pre-ico and 4 bonus rounds
391     CrowdsaleStage public stage = CrowdsaleStage.PreICO; // By default stage is Pre ICO
392     // =============
393 
394     address public community;    
395 
396   // Token Distribution
397     // =============================
398     // 150MM of Elepig are already minted. 
399     uint256 public totalTokensForSale = 150000000000000000000000000;  // 150 EPGs will be sold in Crowdsale (50% of total tokens for community) 
400     uint256 public totalTokensForSaleDuringPreICO = 30000000000000000000000000; // 30MM out of 150MM EPGs will be sold during Pre ICO
401     uint256 public totalTokensForSaleDuringICO1 = 37500000000000000000000000;   // 37.5MM out of 150MM EPGs will be sold during Bonus Round 1
402     uint256 public totalTokensForSaleDuringICO2 = 37500000000000000000000000;   // 37.5MM out of 150MM EPGs will be sold during Bonus Round 2
403     uint256 public totalTokensForSaleDuringICO3 = 30000000000000000000000000;   // 30MM out of 150MM EPGs will be sold during Bonus Round 3
404     uint256 public totalTokensForSaleDuringICO4 = 15000000000000000000000000;   // 15MM out of 150MM EPGs will be sold during Bonus Round 4
405   // ==============================
406 
407     // Amount raised
408     // ==================
409     
410     // store amount sold at each stage of sale
411     uint256 public totalWeiRaisedDuringPreICO;
412     uint256 public totalWeiRaisedDuringICO1;
413     uint256 public totalWeiRaisedDuringICO2;
414     uint256 public totalWeiRaisedDuringICO3;
415     uint256 public totalWeiRaisedDuringICO4;
416     uint256 public totalWeiRaised;
417 
418 
419     // store amount sold at each stage of sale
420     uint256 public totalTokensPreICO;
421     uint256 public totalTokensICO1;
422     uint256 public totalTokensICO2;
423     uint256 public totalTokensICO3;
424     uint256 public totalTokensICO4;
425     uint256 public tokensMinted;
426     
427 
428     uint256 public airDropsClaimed = 0;
429     // ===================
430 
431     mapping (address => bool) public airdrops;
432     mapping (address => bool) public blacklist;
433     
434     
435     // Events
436     event EthTransferred(string text);
437     event EthRefunded(string text);
438    
439 
440 
441     // Constructor
442     // ============
443     function ElepigCrowdsale(
444         uint256 _startTime,
445         uint256 _endTime,
446         uint256 _rate,
447         address _wallet,
448         uint256 _goal,
449         uint256 _cap,
450         address _communityAddress,
451         address _token,
452         address _signer
453     ) 
454     CappedCrowdsale(_cap) FinalizableCrowdsale() RefundableCrowdsale(_goal) Crowdsale( _startTime, _endTime,  _rate, _wallet, _token) public {
455         require(_goal <= _cap);   // goal is softcap
456         require(_signer != address(0));
457         require(_communityAddress != address(0));
458         require(_token != address(0));
459 
460 
461         community = _communityAddress; // sets address of community wallet - address where tokens not sold will be minted
462         signer = _signer; // sets original address of signer
463 
464         
465     }
466     
467 
468   // =========================================================
469   // Crowdsale Stage Management
470   // =========================================================
471 
472   // Change Crowdsale Stage. Available Options: PreICO, ICO1, ICO2, ICO3, ICO4
473     function setCrowdsaleStage(uint value) public onlyOwner {
474         require(value <= 4);
475         if (uint(CrowdsaleStage.PreICO) == value) {
476             rate = 2380; // 1 EPG = 0.00042 ETH
477             stage = CrowdsaleStage.PreICO;
478         } else if (uint(CrowdsaleStage.ICO1) == value) {
479             rate = 2040; // 1 EPG = 0.00049 ETH
480             stage = CrowdsaleStage.ICO1;
481         }
482         else if (uint(CrowdsaleStage.ICO2) == value) {
483             rate = 1785; // 1 EPG = 0.00056 ETH
484             stage = CrowdsaleStage.ICO2;
485         }
486         else if (uint(CrowdsaleStage.ICO3) == value) {
487             rate = 1587; // 1 EPG = 0.00063 ETH
488             stage = CrowdsaleStage.ICO3;
489         }
490         else if (uint(CrowdsaleStage.ICO4) == value) {
491             rate = 1503; // 1 EPG = 0.000665 ETH
492             stage = CrowdsaleStage.ICO4;
493         }
494     }
495 
496 
497     // Change the current rate
498     function setCurrentRate(uint256 _rate) private {
499         rate = _rate;
500     }    
501     // ================ Stage Management Over =====================
502 
503     // ============================================================
504     //                     Address Management 
505     // ============================================================
506 
507 
508     // adding an address to the blacklist, addresses on this list cannot send ETH to the contract     
509     function addBlacklistAddress (address _address) public onlyOwner {
510         blacklist[_address] = true;
511     }
512     
513     // removing an address from the blacklist    
514     function removeBlacklistAddress (address _address) public onlyOwner {
515         blacklist[_address] = false;
516     } 
517 
518     // ================= Address Management Over ==================
519 
520 
521     // Token Purchase, function will be called when 'data' is sent in 
522     // FOR KYC
523     function donate(uint8 _v, bytes32 _r, bytes32 _s) 
524     onlyValidAccess(_v,_r,_s) public payable{
525         require(msg.value >= 150000000000000000); // minimum limit - no max
526         require(blacklist[msg.sender] == false); // require that the sender is not in the blacklist      
527         
528         require(validPurchase()); // after ico start date and not value of 0  
529         
530         uint256 tokensThatWillBeMintedAfterPurchase = msg.value.mul(rate);
531 
532         // if Pre-ICO sale limit is reached, refund sender
533         if ((stage == CrowdsaleStage.PreICO) && (totalTokensPreICO + tokensThatWillBeMintedAfterPurchase > totalTokensForSaleDuringPreICO)) {
534             msg.sender.transfer(msg.value); // Refund them
535             emit EthRefunded("PreICO Limit Hit");
536             return;
537         } 
538         if ((stage == CrowdsaleStage.ICO1) && (totalTokensICO1 + tokensThatWillBeMintedAfterPurchase > totalTokensForSaleDuringICO1)) {
539             msg.sender.transfer(msg.value); // Refund them
540             emit EthRefunded("ICO1 Limit Hit");
541             return;
542 
543         }         
544         if ((stage == CrowdsaleStage.ICO2) && (totalTokensICO2 + tokensThatWillBeMintedAfterPurchase > totalTokensForSaleDuringICO2)) {
545             msg.sender.transfer(msg.value); // Refund them
546             emit EthRefunded("ICO2 Limit Hit");
547             return;
548 
549         }  
550         if ((stage == CrowdsaleStage.ICO3) && (totalTokensICO3 + tokensThatWillBeMintedAfterPurchase > totalTokensForSaleDuringICO3)) {
551             msg.sender.transfer(msg.value); // Refund them
552             emit EthRefunded("ICO3 Limit Hit");
553             return;        
554         } 
555 
556         if ((stage == CrowdsaleStage.ICO4) && (totalTokensICO4 + tokensThatWillBeMintedAfterPurchase > totalTokensForSaleDuringICO4)) {
557             msg.sender.transfer(msg.value); // Refund them
558             emit EthRefunded("ICO4 Limit Hit");
559             return;
560         } else {                
561             // calculate token amount to be created
562             uint256 tokens = msg.value.mul(rate);
563             weiRaised = weiRaised.add(msg.value);          
564 
565             // mint token
566             tokenReward.mint(msg.sender, tokens);
567             emit TokenPurchase(msg.sender, msg.sender, msg.value, tokens);
568             forwardFunds();            
569             // end of buy tokens
570 
571             if (stage == CrowdsaleStage.PreICO) {
572                 totalWeiRaisedDuringPreICO = totalWeiRaisedDuringPreICO.add(msg.value);
573                 totalTokensPreICO = totalTokensPreICO.add(tokensThatWillBeMintedAfterPurchase);    
574             } else if (stage == CrowdsaleStage.ICO1) {
575                 totalWeiRaisedDuringICO1 = totalWeiRaisedDuringICO1.add(msg.value);
576                 totalTokensICO1 = totalTokensICO1.add(tokensThatWillBeMintedAfterPurchase);
577             } else if (stage == CrowdsaleStage.ICO2) {
578                 totalWeiRaisedDuringICO2 = totalWeiRaisedDuringICO2.add(msg.value);
579                 totalTokensICO2 = totalTokensICO2.add(tokensThatWillBeMintedAfterPurchase);
580             } else if (stage == CrowdsaleStage.ICO3) {
581                 totalWeiRaisedDuringICO3 = totalWeiRaisedDuringICO3.add(msg.value);
582                 totalTokensICO3 = totalTokensICO3.add(tokensThatWillBeMintedAfterPurchase);
583             } else if (stage == CrowdsaleStage.ICO4) {
584                 totalWeiRaisedDuringICO4 = totalWeiRaisedDuringICO4.add(msg.value);
585                 totalTokensICO4 = totalTokensICO4.add(tokensThatWillBeMintedAfterPurchase);
586             }
587 
588         }
589         // update state
590         tokensMinted = tokensMinted.add(tokensThatWillBeMintedAfterPurchase);      
591         
592     }
593 
594     // =========================
595     function () external payable {
596         revert();
597     }
598 
599     function forwardFunds() internal {
600         // if Wei raised greater than softcap, send to wallet else put in refund vault
601         if (goalReached()) {
602             wallet.transfer(msg.value);
603             emit EthTransferred("forwarding funds to wallet");
604         } else  {
605             emit EthTransferred("forwarding funds to refundable vault");
606             super.forwardFunds();
607         }
608     }
609   
610      /**
611     * @dev perform a transfer of allocations (recommend doing in batches of 80 due to gas block limit)
612     * @param _from is the address the tokens will come from
613     * @param _recipient is a list of recipients
614     * @param _premium is a bool of if the list of addresses are premium or not
615     */
616     function airdropTokens(address _from, address[] _recipient, bool _premium) public onlyOwner {
617         uint airdropped;
618         uint tokens;
619 
620         if(_premium == true) {
621             tokens = 500000000000000000000;
622         } else {
623             tokens = 50000000000000000000;
624         }
625 
626         for(uint256 i = 0; i < _recipient.length; i++)
627         {
628             if (!airdrops[_recipient[i]]) {
629                 airdrops[_recipient[i]] = true;
630                 require(tokenReward.transferFrom(_from, _recipient[i], tokens));
631                 airdropped = airdropped.add(tokens);
632             }
633         }
634         
635         airDropsClaimed = airDropsClaimed.add(airdropped);
636     }
637 
638   // Finish: Mint Extra Tokens as needed before finalizing the Crowdsale.
639   // ====================================================================
640 
641     function finish() public onlyOwner {
642 
643         require(!isFinalized);
644         
645         if(tokensMinted < totalTokensForSale) {
646 
647             uint256 unsoldTokens = totalTokensForSale - tokensMinted;            
648             tokenReward.mint(community, unsoldTokens);
649             
650         }
651              
652         finalize();
653     } 
654 
655     // if goal reached, manually close the vault
656     function releaseVault() public onlyOwner {
657         require(goalReached());
658         vault.close();
659     }
660 
661     // transfers ownership of contract back to wallet
662     function transferTokenOwnership(address _newOwner) public onlyOwner {
663         tokenReward.transferOwnership(_newOwner);
664     }
665   // ===============================
666 
667   
668 }