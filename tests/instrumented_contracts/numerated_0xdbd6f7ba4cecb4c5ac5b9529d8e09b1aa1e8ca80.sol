1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21     function allowance(address owner, address spender) public view returns (uint256);
22     function transferFrom(address from, address to, uint256 value) public returns (bool);
23     function approve(address spender, uint256 value) public returns (bool);
24     event Approval(
25         address indexed owner,
26         address indexed spender,
27         uint256 value
28     );
29 }
30 
31 
32 /**
33  * @title SafeMath
34  * @dev Math operations with safety checks that throw on error
35  */
36 library SafeMath {
37 
38    /**
39     * @dev Multiplies two numbers, throws on overflow.
40     */
41     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
43         // benefit is lost if 'b' is also tested.
44         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45         if (a == 0) {
46             return 0;
47         }
48 
49         c = a * b;
50         assert(c / a == b);
51         return c;
52     }
53 
54     /**
55      * @dev Integer division of two numbers, truncating the quotient.
56      */
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         // assert(b > 0); // Solidity automatically throws when dividing by 0
59         // uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61         return a / b;
62     }
63 
64    /**
65     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
66     */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         assert(b <= a);
69         return a - b;
70     }
71 
72    /**
73     * @dev Adds two numbers, throws on overflow.
74     */
75     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
76         c = a + b;
77         assert(c >= a);
78         return c;
79     }
80 }
81 
82 contract Ownable {
83     address public owner;
84 
85 
86     event OwnershipRenounced(address indexed previousOwner);
87     event OwnershipTransferred(
88         address indexed previousOwner,
89         address indexed newOwner
90     );
91 
92 
93    /**
94     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
95     * account.
96     */
97     constructor() public {
98         owner = msg.sender;
99     }
100 
101    /**
102     * @dev Throws if called by any account other than the owner.
103     */
104     modifier onlyOwner() {
105         require(msg.sender == owner);
106         _;
107     }
108 
109    /**
110     * @dev Allows the current owner to transfer control of the contract to a newOwner.
111     * @param newOwner The address to transfer ownership to.
112     */
113     function transferOwnership(address newOwner) public onlyOwner {
114         require(newOwner != address(0));
115         emit OwnershipTransferred(owner, newOwner);
116         owner = newOwner;
117     }
118 
119    /**
120     * @dev Allows the current owner to relinquish control of the contract.
121     */
122     function renounceOwnership() public onlyOwner {
123         emit OwnershipRenounced(owner);
124         owner = address(0);
125     }
126 }
127 
128 
129 /**
130  * @title ICO Rocket Fuel contract for LastMile service.
131  */
132 contract IcoRocketFuel is Ownable {
133 
134     using SafeMath for uint256;
135 
136     // Crowdsale states
137     enum States {Active, Refunding, Closed}
138 
139     struct Crowdsale {
140         address owner;        // Crowdsale proposer
141         address refundWallet; // Tokens for sale will refund to this wallet
142         uint256 cap;          // Hard cap
143         uint256 goal;         // Soft cap
144         uint256 raised;       // wei raised
145         uint256 rate;         // Sell rate. Set to 10 means 1 Wei = 10 token units
146         uint256 minInvest;    // Minimum investment in Wei
147         uint256 closingTime;  // Crowdsale closing time
148         bool earlyClosure;    // Whether allow early closure
149         uint8 commission;     // Commission percentage. Set to 10 means 10%
150         States state;         // Crowdsale current state
151     }
152 
153     // When crowdsale is closed, commissions will transfer to this wallet.
154     address public commissionWallet;    
155 
156     // Use crowdsales[token] to get corresponding crowdsale.
157     // The token is an ERC20 token address.
158     mapping(address => Crowdsale) public crowdsales;
159 
160     // Use deposits[buyer][token] to get deposited Wei for buying the token.
161     // The buyer is the buyer address.
162     // The token is an ERC20 token address.
163     mapping (address => mapping(address => uint256)) public deposits;
164 
165     modifier onlyCrowdsaleOwner(address _token) {
166         require(
167             msg.sender == crowdsales[_token].owner,
168             "Failed to call function due to permission denied."
169         );
170         _;
171     }
172 
173     modifier inState(address _token, States _state) {
174         require(
175             crowdsales[_token].state == _state,
176             "Failed to call function due to crowdsale is not in right state."
177         );
178         _;
179     }
180 
181     modifier nonZeroAddress(address _token) {
182         require(
183             _token != address(0),
184             "Failed to call function due to address is 0x0."
185         );
186         _;
187     }
188 
189     event CommissionWalletUpdated(
190         address indexed _previoudWallet, // Previous commission wallet address
191         address indexed _newWallet       // New commission wallet address
192     );
193 
194     event CrowdsaleCreated(
195         address indexed _owner, // Crowdsale proposer
196         address indexed _token, // ERC20 token for crowdsale
197         address _refundWallet,  // Tokens for sale will refund to this wallet
198         uint256 _cap,           // Hard cap
199         uint256 _goal,          // Soft cap
200         uint256 _rate,          // Sell rate. Set to 10 means 1 Wei = 10 token units
201         uint256 closingTime,    // Crowdsale closing time
202         bool earlyClosure,      // Whether allow early closure
203         uint8 _commission       // Commission percentage. Set to 10 means 10%
204     );
205 
206     event TokenBought(
207         address indexed _buyer, // Buyer address
208         address indexed _token, // Bought ERC20 token address
209         uint256 _value          // Spent wei amount
210     );
211 
212     event CrowdsaleClosed(
213         address indexed _setter, // Address who closed crowdsale
214         address indexed _token   // Token address
215     );
216 
217     event CommissionPaid(
218         address indexed _payer,       // Commission payer        
219         address indexed _token,       // Paid from this crowdsale
220         address indexed _beneficiary, // Commission paid to this wallet
221         uint256 _value                // Paid commission in Wei amount
222     );
223 
224     event RefundsEnabled(
225         address indexed _setter, // Address who enabled refunds
226         address indexed _token   // Token address
227     );
228 
229     event CrowdsaleTokensRefunded(
230         address indexed _token,        // ERC20 token for crowdsale
231         address indexed _refundWallet, // Token will refund to this wallet
232         uint256 _value                 // Refuned amount
233     );
234 
235     event RaisedWeiClaimed(
236         address indexed _beneficiary, // Who claimed refunds
237         address indexed _token,       // Refund from this crowdsale
238         uint256 _value                // Raised Wei amount
239     );
240 
241     event TokenClaimed(
242         address indexed _beneficiary, // Who claimed refunds
243         address indexed _token,       // Refund from this crowdsale
244         uint256 _value                // Refund Wei amount 
245     );
246 
247     event CrowdsalePaused(
248         address indexed _owner, // Current contract owner
249         address indexed _token  // Paused crowdsale
250     );
251 
252     event WeiRefunded(
253         address indexed _beneficiary, // Who claimed refunds
254         address indexed _token,       // Refund from this crowdsale
255         uint256 _value                // Refund Wei amount 
256     );
257 
258     // Note no default constructor is required, but 
259     // remember to set commission wallet before operating.
260 
261     /**
262      * Set crowdsale commission wallet.
263      *
264      * @param _newWallet New commission wallet
265      */
266     function setCommissionWallet(
267         address _newWallet
268     )
269         onlyOwner
270         nonZeroAddress(_newWallet)
271         external
272     {
273         emit CommissionWalletUpdated(commissionWallet, _newWallet);
274         commissionWallet = _newWallet;
275     }
276 
277     /**
278      * Create a crowdsale.
279      *
280      * @param _token Deployed ERC20 token address
281      * @param _refundWallet Tokens for sale will refund to this wallet
282      * @param _cap Crowdsale cap
283      * @param _goal Crowdsale goal
284      * @param _rate Token sell rate. Set to 10 means 1 Wei = 10 token units
285      * @param _minInvest Minimum investment in Wei
286      * @param _closingTime Crowdsale closing time
287      * @param _earlyClosure True: allow early closure; False: not allow
288      * @param _commission Commission percentage. Set to 10 means 10%
289      */
290     function createCrowdsale(
291         address _token,
292         address _refundWallet,
293         uint256 _cap,
294         uint256 _goal,
295         uint256 _rate,
296         uint256 _minInvest,
297         uint256 _closingTime,
298         bool _earlyClosure,
299         uint8 _commission
300     )
301         nonZeroAddress(_token)
302         nonZeroAddress(_refundWallet)
303         external
304     {
305         require(
306             crowdsales[_token].owner == address(0),
307             "Failed to create crowdsale due to the crowdsale is existed."
308         );
309 
310         require(
311             _goal <= _cap,
312             "Failed to create crowdsale due to goal is larger than cap."
313         );
314 
315         require(
316             _minInvest > 0,
317             "Failed to create crowdsale due to minimum investment is 0."
318         );
319 
320         require(
321             _commission <= 100,
322             "Failed to create crowdsale due to commission is larger than 100."
323         );
324 
325         // Leverage SafeMath to help potential overflow of maximum token untis.
326         _cap.mul(_rate);
327 
328         crowdsales[_token] = Crowdsale({
329             owner: msg.sender,
330             refundWallet: _refundWallet,
331             cap: _cap,
332             goal: _goal,
333             raised: 0,
334             rate: _rate,
335             minInvest: _minInvest,
336             closingTime: _closingTime,
337             earlyClosure: _earlyClosure,
338             state: States.Active,
339             commission: _commission
340         });
341 
342         emit CrowdsaleCreated(
343             msg.sender, 
344             _token,
345             _refundWallet,
346             _cap, 
347             _goal, 
348             _rate,
349             _closingTime,
350             _earlyClosure,
351             _commission
352         );
353     }
354 
355     /**
356      * Buy token with Wei.
357      *
358      * The Wei will be deposited until crowdsale is finalized.
359      * If crowdsale is success, raised Wei will be transfered to the token.
360      * If crowdsale is fail, buyer can refund the Wei.
361      *
362      * Note The minimum investment is 1 ETH.
363      * Note the big finger issue is expected to be handled by frontends.
364      *
365      * @param _token Deployed ERC20 token address
366      */
367     function buyToken(
368         address _token
369     )
370         inState(_token, States.Active)
371         nonZeroAddress(_token)
372         external
373         payable
374     {
375         require(
376             msg.value >= crowdsales[_token].minInvest,
377             "Failed to buy token due to less than minimum investment."
378         );
379 
380         require(
381             crowdsales[_token].raised.add(msg.value) <= (
382                 crowdsales[_token].cap
383             ),
384             "Failed to buy token due to exceed cap."
385         );
386 
387         require(
388             // solium-disable-next-line security/no-block-members
389             block.timestamp < crowdsales[_token].closingTime,
390             "Failed to buy token due to crowdsale is closed."
391         );
392 
393         deposits[msg.sender][_token] = (
394             deposits[msg.sender][_token].add(msg.value)
395         );
396         crowdsales[_token].raised = crowdsales[_token].raised.add(msg.value);
397         emit TokenBought(msg.sender, _token, msg.value);        
398     }
399 
400     /**
401      * Check whether crowdsale goal was reached or not.
402      *
403      * Goal reached condition:
404      * 1. total raised wei >= goal (soft cap); and
405      * 2. Right amout of token is prepared for this contract.
406      *
407      * @param _token Deployed ERC20 token
408      * @return Whether crowdsale goal was reached or not
409      */
410     function _goalReached(
411         ERC20 _token
412     )
413         nonZeroAddress(_token)
414         private
415         view
416         returns(bool) 
417     {
418         return (crowdsales[_token].raised >= crowdsales[_token].goal) && (
419             _token.balanceOf(address(this)) >= 
420             crowdsales[_token].raised.mul(crowdsales[_token].rate)
421         );
422     }
423 
424     /**
425      * Pay commission by raised Wei amount of crowdsale.
426      *
427      * @param _token Deployed ERC20 token address
428      */
429     function _payCommission(
430         address _token
431     )
432         nonZeroAddress(_token)
433         inState(_token, States.Closed)
434         onlyCrowdsaleOwner(_token)
435         private
436     {
437         // Calculate commission, update rest raised Wei, and pay commission.
438         uint256 _commission = crowdsales[_token].raised
439             .mul(uint256(crowdsales[_token].commission))
440             .div(100);
441         crowdsales[_token].raised = crowdsales[_token].raised.sub(_commission);
442         emit CommissionPaid(msg.sender, _token, commissionWallet, _commission);
443         commissionWallet.transfer(_commission);
444     }
445 
446     /**
447      * Refund crowdsale tokens to refund wallet.
448      *
449      * @param _token Deployed ERC20 token
450      * @param _beneficiary Crowdsale tokens will refund to this wallet
451      */
452     function _refundCrowdsaleTokens(
453         ERC20 _token,
454         address _beneficiary
455     ) 
456         nonZeroAddress(_token)
457         inState(_token, States.Refunding)
458         private
459     {
460         // Set raised Wei to 0 to prevent unknown issues 
461         // which might take Wei away. 
462         // Theoretically, this step is unnecessary due to there is no available
463         // function for crowdsale owner to claim raised Wei.
464         crowdsales[_token].raised = 0;
465 
466         uint256 _value = _token.balanceOf(address(this));
467         emit CrowdsaleTokensRefunded(_token, _beneficiary, _value);
468 
469         if (_value > 0) {         
470             // Refund all tokens for crowdsale to refund wallet.
471             _token.transfer(_beneficiary, _token.balanceOf(address(this)));
472         }
473     }
474 
475     /**
476      * Enable refunds of crowdsale.
477      *
478      * @param _token Deployed ERC20 token address
479      */
480     function _enableRefunds(
481         address _token
482     )
483         nonZeroAddress(_token)
484         inState(_token, States.Active)
485         private        
486     {
487         // Set state to Refunding while preventing reentry.
488         crowdsales[_token].state = States.Refunding;
489         emit RefundsEnabled(msg.sender, _token);
490     }
491 
492     /**
493      * Finalize a crowdsale.
494      *
495      * Once a crowdsale is finalized, its state could be
496      * either Closed (success) or Refunding (fail).
497      *
498      * @param _token Deployed ERC20 token address
499      */
500     function finalize(
501         address _token
502     )
503         nonZeroAddress(_token)
504         inState(_token, States.Active)        
505         onlyCrowdsaleOwner(_token)
506         external
507     {
508         require(                    
509             crowdsales[_token].earlyClosure || (
510             // solium-disable-next-line security/no-block-members
511             block.timestamp >= crowdsales[_token].closingTime),                   
512             "Failed to finalize due to crowdsale is opening."
513         );
514 
515         if (_goalReached(ERC20(_token))) {
516             // Set state to Closed whiling preventing reentry.
517             crowdsales[_token].state = States.Closed;
518             emit CrowdsaleClosed(msg.sender, _token);
519             _payCommission(_token);                        
520         } else {
521             _enableRefunds(_token);
522             _refundCrowdsaleTokens(
523                 ERC20(_token), 
524                 crowdsales[_token].refundWallet
525             );
526         }
527     }
528 
529     /**
530      * Pause crowdsale, which will set the crowdsale state to Refunding.
531      *
532      * Note only pause crowdsales which are suspicious/scams.
533      *
534      * @param _token Deployed ERC20 token address
535      */
536     function pauseCrowdsale(
537         address _token
538     )        
539         nonZeroAddress(_token)
540         onlyOwner
541         inState(_token, States.Active)
542         external
543     {
544         emit CrowdsalePaused(msg.sender, _token);
545         _enableRefunds(_token);
546         _refundCrowdsaleTokens(ERC20(_token), crowdsales[_token].refundWallet);
547     }
548 
549     /**
550      * Claim crowdsale raised Wei.
551      *
552      * @param _token Deployed ERC20 token address
553      */
554     function claimRaisedWei(
555         address _token,
556         address _beneficiary
557     )
558         nonZeroAddress(_token)
559         nonZeroAddress(_beneficiary)
560         inState(_token, States.Closed)
561         onlyCrowdsaleOwner(_token)
562         external
563     {
564         require(
565             crowdsales[_token].raised > 0,
566             "Failed to claim raised Wei due to raised Wei is 0."
567         );
568 
569         uint256 _raisedWei = crowdsales[_token].raised;
570         crowdsales[_token].raised = 0;
571         emit RaisedWeiClaimed(msg.sender, _token, _raisedWei);
572         _beneficiary.transfer(_raisedWei);
573     }
574 
575     /**
576      * Claim token, which will transfer bought token amount to buyer.
577      *
578      * @param _token Deployed ERC20 token address
579      */
580     function claimToken(
581         address _token
582     )
583         nonZeroAddress(_token)
584         inState(_token, States.Closed)        
585         external 
586     {
587         require(
588             deposits[msg.sender][_token] > 0,
589             "Failed to claim token due to deposit is 0."
590         );
591 
592         // Calculate token unit amount to be transferred. 
593         uint256 _value = (
594             deposits[msg.sender][_token].mul(crowdsales[_token].rate)
595         );
596         deposits[msg.sender][_token] = 0;
597         emit TokenClaimed(msg.sender, _token, _value);
598         ERC20(_token).transfer(msg.sender, _value);
599     }
600 
601     /**
602      * Claim refund, which will transfer refunded Wei amount back to buyer.
603      *
604      * @param _token Deployed ERC20 token address
605      */
606     function claimRefund(
607         address _token
608     )
609         nonZeroAddress(_token)
610         inState(_token, States.Refunding)        
611         public 
612     {
613         require(
614             deposits[msg.sender][_token] > 0,
615             "Failed to claim refund due to deposit is 0."
616         );
617 
618         uint256 _value = deposits[msg.sender][_token];
619         deposits[msg.sender][_token] = 0;
620         emit WeiRefunded(msg.sender, _token, _value);
621         msg.sender.transfer(_value);
622     }
623 }