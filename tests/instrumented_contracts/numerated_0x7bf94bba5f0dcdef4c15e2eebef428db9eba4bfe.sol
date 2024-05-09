1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9     function totalSupply() public view returns (uint256);
10 
11     function balanceOf(address _who) public view returns (uint256);
12 
13     function allowance(address _owner, address _spender)
14         public view returns (uint256);
15 
16     function transfer(address _to, uint256 _value) public returns (bool);
17 
18     function approve(address _spender, uint256 _value)
19         public returns (bool);
20 
21     function transferFrom(address _from, address _to, uint256 _value)
22         public returns (bool);
23 
24     event Transfer(
25         address indexed from,
26         address indexed to,
27         uint256 value
28     );
29 
30     event Approval(
31         address indexed owner,
32         address indexed spender,
33         uint256 value
34     );
35 }
36 
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that revert on error
41  */
42 library SafeMath {
43 
44     /**
45      * @dev Multiplies two numbers, reverts on overflow.
46      */
47     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
51         if (_a == 0) {
52             return 0;
53         }
54 
55         uint256 c = _a * _b;
56         require(c / _a == _b);
57 
58         return c;
59     }
60 
61     /**
62      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
63      */
64     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
65         require(_b > 0); // Solidity only automatically asserts when dividing by 0
66         uint256 c = _a / _b;
67         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
68 
69         return c;
70     }
71 
72     /**
73      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
74      */
75     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
76         require(_b <= _a);
77         uint256 c = _a - _b;
78 
79         return c;
80     }
81 
82     /**
83      * @dev Adds two numbers, reverts on overflow.
84      */
85     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
86         uint256 c = _a + _b;
87         require(c >= _a);
88 
89         return c;
90     }
91 
92     /**
93      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
94      * reverts when dividing by zero.
95      */
96     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
97         require(b != 0);
98         return a % b;
99     }
100 }
101 
102 /**
103  * @title Ownable
104  * @dev The Ownable contract has an owner address, and provides basic authorization control
105  * functions, this simplifies the implementation of "user permissions".
106  */
107 contract Ownable {
108     address public owner;
109 
110 
111     event OwnershipRenounced(address indexed previousOwner);
112     event OwnershipTransferred(
113         address indexed previousOwner,
114         address indexed newOwner
115     );
116 
117 
118     /**
119      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
120      * account.
121      */
122     constructor() public {
123         owner = msg.sender;
124     }
125 
126     /**
127      * @dev Throws if called by any account other than the owner.
128      */
129     modifier onlyOwner() {
130         require(msg.sender == owner);
131         _;
132     }
133 
134     /**
135      * @dev Allows the current owner to relinquish control of the contract.
136      * @notice Renouncing to ownership will leave the contract without an owner.
137      * It will not be possible to call the functions with the `onlyOwner`
138      * modifier anymore.
139      */
140     function renounceOwnership() public onlyOwner {
141         emit OwnershipRenounced(owner);
142         owner = address(0);
143     }
144 
145     /**
146      * @dev Allows the current owner to transfer control of the contract to a newOwner.
147      * @param _newOwner The address to transfer ownership to.
148      */
149     function transferOwnership(address _newOwner) public onlyOwner {
150         _transferOwnership(_newOwner);
151     }
152 
153     /**
154      * @dev Transfers control of the contract to a newOwner.
155      * @param _newOwner The address to transfer ownership to.
156      */
157     function _transferOwnership(address _newOwner) internal {
158         require(_newOwner != address(0));
159         emit OwnershipTransferred(owner, _newOwner);
160         owner = _newOwner;
161     }
162 }
163 
164 
165 /**
166  * @title ICO Rocket Fuel contract for LastMile service.
167  */
168 contract IcoRocketFuel is Ownable {
169 
170     using SafeMath for uint256;
171 
172     // Crowdsale states
173     enum States {Active, Refunding, Closed}
174 
175     struct Crowdsale {
176         address owner;        // Crowdsale proposer
177         address refundWallet; // Tokens for sale will refund to this wallet
178         uint256 cap;          // Hard cap
179         uint256 goal;         // Soft cap
180         uint256 raised;       // wei raised
181         uint256 rate;         // Sell rate. Set to 10 means 1 Wei = 10 token units
182         uint256 minInvest;    // Minimum investment in Wei
183         uint256 closingTime;  // Crowdsale closing time
184         bool earlyClosure;    // Whether allow early closure
185         uint8 commission;     // Commission percentage. Set to 10 means 10%
186         States state;         // Crowdsale current state
187     }
188 
189     // When crowdsale is closed, commissions will transfer to this wallet.
190     address public commissionWallet;    
191 
192     // Use crowdsales[token] to get corresponding crowdsale.
193     // The token is an ERC20 token address.
194     mapping(address => Crowdsale) public crowdsales;
195 
196     // Use deposits[buyer][token] to get deposited Wei for buying the token.
197     // The buyer is the buyer address.
198     // The token is an ERC20 token address.
199     mapping (address => mapping(address => uint256)) public deposits;
200 
201     modifier onlyCrowdsaleOwner(address _token) {
202         require(
203             msg.sender == crowdsales[_token].owner,
204             "Failed to call function due to permission denied."
205         );
206         _;
207     }
208 
209     modifier inState(address _token, States _state) {
210         require(
211             crowdsales[_token].state == _state,
212             "Failed to call function due to crowdsale is not in right state."
213         );
214         _;
215     }
216 
217     modifier nonZeroAddress(address _token) {
218         require(
219             _token != address(0),
220             "Failed to call function due to address is 0x0."
221         );
222         _;
223     }
224 
225     event CommissionWalletUpdated(
226         address indexed _previoudWallet, // Previous commission wallet address
227         address indexed _newWallet       // New commission wallet address
228     );
229 
230     event CrowdsaleCreated(
231         address indexed _owner, // Crowdsale proposer
232         address indexed _token, // ERC20 token for crowdsale
233         address _refundWallet,  // Tokens for sale will refund to this wallet
234         uint256 _cap,           // Hard cap
235         uint256 _goal,          // Soft cap
236         uint256 _rate,          // Sell rate. Set to 10 means 1 Wei = 10 token units
237         uint256 closingTime,    // Crowdsale closing time
238         bool earlyClosure,      // Whether allow early closure
239         uint8 _commission       // Commission percentage. Set to 10 means 10%
240     );
241 
242     event TokenBought(
243         address indexed _buyer, // Buyer address
244         address indexed _token, // Bought ERC20 token address
245         uint256 _value          // Spent wei amount
246     );
247 
248     event CrowdsaleClosed(
249         address indexed _setter, // Address who closed crowdsale
250         address indexed _token   // Token address
251     );
252 
253     event SurplusTokensRefunded(
254         address _token,       // ERC20 token for crowdsale
255         address _beneficiary, // Surplus tokens will refund to this wallet
256         uint256 _surplus      // Surplus token units
257     );
258 
259     event CommissionPaid(
260         address indexed _payer,       // Commission payer        
261         address indexed _token,       // Paid from this crowdsale
262         address indexed _beneficiary, // Commission paid to this wallet
263         uint256 _value                // Paid commission in Wei amount
264     );
265 
266     event RefundsEnabled(
267         address indexed _setter, // Address who enabled refunds
268         address indexed _token   // Token address
269     );
270 
271     event CrowdsaleTokensRefunded(
272         address indexed _token,        // ERC20 token for crowdsale
273         address indexed _refundWallet, // Token will refund to this wallet
274         uint256 _value                 // Refuned amount
275     );
276 
277     event RaisedWeiClaimed(
278         address indexed _beneficiary, // Who claimed refunds
279         address indexed _token,       // Refund from this crowdsale
280         uint256 _value                // Raised Wei amount
281     );
282 
283     event TokenClaimed(
284         address indexed _beneficiary, // Who claimed refunds
285         address indexed _token,       // Refund from this crowdsale
286         uint256 _value                // Refund Wei amount 
287     );
288 
289     event CrowdsalePaused(
290         address indexed _owner, // Current contract owner
291         address indexed _token  // Paused crowdsale
292     );
293 
294     event WeiRefunded(
295         address indexed _beneficiary, // Who claimed refunds
296         address indexed _token,       // Refund from this crowdsale
297         uint256 _value                // Refund Wei amount 
298     );
299 
300     // Note no default constructor is required, but 
301     // remember to set commission wallet before operating.
302 
303     /**
304      * Set crowdsale commission wallet.
305      *
306      * @param _newWallet New commission wallet
307      */
308     function setCommissionWallet(
309         address _newWallet
310     )
311         external
312         onlyOwner
313         nonZeroAddress(_newWallet)
314     {
315         emit CommissionWalletUpdated(commissionWallet, _newWallet);
316         commissionWallet = _newWallet;
317     }
318 
319     /**
320      * Create a crowdsale.
321      *
322      * @param _token Deployed ERC20 token address
323      * @param _refundWallet Tokens for sale will refund to this wallet
324      * @param _cap Crowdsale cap
325      * @param _goal Crowdsale goal
326      * @param _rate Token sell rate. Set to 10 means 1 Wei = 10 token units
327      * @param _minInvest Minimum investment in Wei
328      * @param _closingTime Crowdsale closing time
329      * @param _earlyClosure True: allow early closure; False: not allow
330      * @param _commission Commission percentage. Set to 10 means 10%
331      */
332     function createCrowdsale(
333         address _token,
334         address _refundWallet,
335         uint256 _cap,
336         uint256 _goal,
337         uint256 _rate,
338         uint256 _minInvest,
339         uint256 _closingTime,
340         bool _earlyClosure,
341         uint8 _commission
342     )
343         external
344         nonZeroAddress(_token)
345         nonZeroAddress(_refundWallet)
346     {
347         require(
348             crowdsales[_token].owner == address(0),
349             "Failed to create crowdsale due to the crowdsale is existed."
350         );
351 
352         require(
353             _goal <= _cap,
354             "Failed to create crowdsale due to goal is larger than cap."
355         );
356 
357         require(
358             _minInvest > 0,
359             "Failed to create crowdsale due to minimum investment is 0."
360         );
361 
362         require(
363             _commission <= 100,
364             "Failed to create crowdsale due to commission is larger than 100."
365         );
366 
367         // Leverage SafeMath to help potential overflow of maximum token untis.
368         _cap.mul(_rate);
369 
370         crowdsales[_token] = Crowdsale({
371             owner: msg.sender,
372             refundWallet: _refundWallet,
373             cap: _cap,
374             goal: _goal,
375             raised: 0,
376             rate: _rate,
377             minInvest: _minInvest,
378             closingTime: _closingTime,
379             earlyClosure: _earlyClosure,
380             state: States.Active,
381             commission: _commission
382         });
383 
384         emit CrowdsaleCreated(
385             msg.sender, 
386             _token,
387             _refundWallet,
388             _cap, 
389             _goal, 
390             _rate,
391             _closingTime,
392             _earlyClosure,
393             _commission
394         );
395     }
396 
397     /**
398      * Buy token with Wei.
399      *
400      * The Wei will be deposited until crowdsale is finalized.
401      * If crowdsale is success, raised Wei will be transfered to the token.
402      * If crowdsale is fail, buyer can refund the Wei.
403      *
404      * Note The minimum investment is 1 ETH.
405      * Note the big finger issue is expected to be handled by frontends.
406      *
407      * @param _token Deployed ERC20 token address
408      */
409     function buyToken(
410         address _token
411     )
412         external
413         inState(_token, States.Active)
414         nonZeroAddress(_token)
415         payable
416     {
417         require(
418             msg.value >= crowdsales[_token].minInvest,
419             "Failed to buy token due to less than minimum investment."
420         );
421 
422         require(
423             crowdsales[_token].raised.add(msg.value) <= (
424                 crowdsales[_token].cap
425             ),
426             "Failed to buy token due to exceed cap."
427         );
428 
429         require(
430             // solium-disable-next-line security/no-block-members
431             block.timestamp < crowdsales[_token].closingTime,
432             "Failed to buy token due to crowdsale is closed."
433         );
434 
435         deposits[msg.sender][_token] = (
436             deposits[msg.sender][_token].add(msg.value)
437         );
438         crowdsales[_token].raised = crowdsales[_token].raised.add(msg.value);
439         emit TokenBought(msg.sender, _token, msg.value);        
440     }
441 
442     /**
443      * Check whether crowdsale goal was reached or not.
444      *
445      * Goal reached condition:
446      * 1. total raised wei >= goal (soft cap); and
447      * 2. Right amout of token is prepared for this contract.
448      *
449      * @param _token Deployed ERC20 token
450      * @return Whether crowdsale goal was reached or not
451      */
452     function _goalReached(
453         ERC20 _token
454     )
455         private
456         nonZeroAddress(_token)
457         view
458         returns(bool) 
459     {
460         return (crowdsales[_token].raised >= crowdsales[_token].goal) && (
461             _token.balanceOf(address(this)) >= 
462             crowdsales[_token].raised.mul(crowdsales[_token].rate)
463         );
464     }
465 
466     /**
467      * Refund surplus tokens to refund wallet.
468      *
469      * @param _token Deployed ERC20 token
470      * @param _beneficiary Surplus tokens will refund to this wallet
471      */
472     function _refundSurplusTokens(
473         ERC20 _token,
474         address _beneficiary
475     )
476         private
477         nonZeroAddress(_token)
478         inState(_token, States.Closed)
479     {
480         uint256 _balance = _token.balanceOf(address(this));
481         uint256 _surplus = _balance.sub(
482             crowdsales[_token].raised.mul(crowdsales[_token].rate));
483         emit SurplusTokensRefunded(_token, _beneficiary, _surplus);
484 
485         if (_surplus > 0) {
486             // Refund surplus tokens to refund wallet.
487             _token.transfer(_beneficiary, _surplus);
488         }
489     }
490 
491     /**
492      * Pay commission by raised Wei amount of crowdsale.
493      *
494      * @param _token Deployed ERC20 token address
495      */
496     function _payCommission(
497         address _token
498     )
499         private
500         nonZeroAddress(_token)
501         inState(_token, States.Closed)
502         onlyCrowdsaleOwner(_token)
503     {
504         // Calculate commission, update rest raised Wei, and pay commission.
505         uint256 _commission = crowdsales[_token].raised
506             .mul(uint256(crowdsales[_token].commission))
507             .div(100);
508         crowdsales[_token].raised = crowdsales[_token].raised.sub(_commission);
509         emit CommissionPaid(msg.sender, _token, commissionWallet, _commission);
510         commissionWallet.transfer(_commission);
511     }
512 
513     /**
514      * Refund crowdsale tokens to refund wallet.
515      *
516      * @param _token Deployed ERC20 token
517      * @param _beneficiary Crowdsale tokens will refund to this wallet
518      */
519     function _refundCrowdsaleTokens(
520         ERC20 _token,
521         address _beneficiary
522     )
523         private
524         nonZeroAddress(_token)
525         inState(_token, States.Refunding)
526     {
527         // Set raised Wei to 0 to prevent unknown issues 
528         // which might take Wei away. 
529         // Theoretically, this step is unnecessary due to there is no available
530         // function for crowdsale owner to claim raised Wei.
531         crowdsales[_token].raised = 0;
532 
533         uint256 _value = _token.balanceOf(address(this));
534         emit CrowdsaleTokensRefunded(_token, _beneficiary, _value);
535 
536         if (_value > 0) {         
537             // Refund all tokens for crowdsale to refund wallet.
538             _token.transfer(_beneficiary, _token.balanceOf(address(this)));
539         }
540     }
541 
542     /**
543      * Enable refunds of crowdsale.
544      *
545      * @param _token Deployed ERC20 token address
546      */
547     function _enableRefunds(
548         address _token
549     )
550         private
551         nonZeroAddress(_token)
552         inState(_token, States.Active)      
553     {
554         // Set state to Refunding while preventing reentry.
555         crowdsales[_token].state = States.Refunding;
556         emit RefundsEnabled(msg.sender, _token);
557     }
558 
559     /**
560      * Finalize a crowdsale.
561      *
562      * Once a crowdsale is finalized, its state could be
563      * either Closed (success) or Refunding (fail).
564      *
565      * @param _token Deployed ERC20 token address
566      */
567     function finalize(
568         address _token
569     )
570         external
571         nonZeroAddress(_token)
572         inState(_token, States.Active)        
573         onlyCrowdsaleOwner(_token)
574     {
575         require(                    
576             crowdsales[_token].earlyClosure || (
577             // solium-disable-next-line security/no-block-members
578             block.timestamp >= crowdsales[_token].closingTime),                   
579             "Failed to finalize due to crowdsale is opening."
580         );
581 
582         if (_goalReached(ERC20(_token))) {
583             // Set state to Closed whiling preventing reentry.
584             crowdsales[_token].state = States.Closed;
585             emit CrowdsaleClosed(msg.sender, _token);
586             _refundSurplusTokens(
587                 ERC20(_token), 
588                 crowdsales[_token].refundWallet
589             );
590             _payCommission(_token);                        
591         } else {
592             _enableRefunds(_token);
593             _refundCrowdsaleTokens(
594                 ERC20(_token), 
595                 crowdsales[_token].refundWallet
596             );
597         }
598     }
599 
600     /**
601      * Pause crowdsale, which will set the crowdsale state to Refunding.
602      *
603      * Note only pause crowdsales which are suspicious/scams.
604      *
605      * @param _token Deployed ERC20 token address
606      */
607     function pauseCrowdsale(
608         address _token
609     )  
610         external      
611         nonZeroAddress(_token)
612         onlyOwner
613         inState(_token, States.Active)
614     {
615         emit CrowdsalePaused(msg.sender, _token);
616         _enableRefunds(_token);
617         _refundCrowdsaleTokens(ERC20(_token), crowdsales[_token].refundWallet);
618     }
619 
620     /**
621      * Claim crowdsale raised Wei.
622      *
623      * @param _token Deployed ERC20 token address
624      */
625     function claimRaisedWei(
626         address _token,
627         address _beneficiary
628     )
629         external
630         nonZeroAddress(_token)
631         nonZeroAddress(_beneficiary)
632         inState(_token, States.Closed)
633         onlyCrowdsaleOwner(_token)        
634     {
635         require(
636             crowdsales[_token].raised > 0,
637             "Failed to claim raised Wei due to raised Wei is 0."
638         );
639 
640         uint256 _raisedWei = crowdsales[_token].raised;
641         crowdsales[_token].raised = 0;
642         emit RaisedWeiClaimed(msg.sender, _token, _raisedWei);
643         _beneficiary.transfer(_raisedWei);
644     }
645 
646     /**
647      * Claim token, which will transfer bought token amount to buyer.
648      *
649      * @param _token Deployed ERC20 token address
650      */
651     function claimToken(
652         address _token
653     )
654         external 
655         nonZeroAddress(_token)
656         inState(_token, States.Closed)
657     {
658         require(
659             deposits[msg.sender][_token] > 0,
660             "Failed to claim token due to deposit is 0."
661         );
662 
663         // Calculate token unit amount to be transferred. 
664         uint256 _value = (
665             deposits[msg.sender][_token].mul(crowdsales[_token].rate)
666         );
667         deposits[msg.sender][_token] = 0;
668         emit TokenClaimed(msg.sender, _token, _value);
669         ERC20(_token).transfer(msg.sender, _value);
670     }
671 
672     /**
673      * Claim refund, which will transfer refunded Wei amount back to buyer.
674      *
675      * @param _token Deployed ERC20 token address
676      */
677     function claimRefund(
678         address _token
679     )
680         public
681         nonZeroAddress(_token)
682         inState(_token, States.Refunding)
683     {
684         require(
685             deposits[msg.sender][_token] > 0,
686             "Failed to claim refund due to deposit is 0."
687         );
688 
689         uint256 _value = deposits[msg.sender][_token];
690         deposits[msg.sender][_token] = 0;
691         emit WeiRefunded(msg.sender, _token, _value);
692         msg.sender.transfer(_value);
693     }
694 }