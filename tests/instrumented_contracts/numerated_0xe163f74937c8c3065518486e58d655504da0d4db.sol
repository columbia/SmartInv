1 // AID tokensale smart contract.
2 // Developed by Phenom.Team <info@phenom.team>
3 
4 pragma solidity ^ 0.4.15;
5 
6 /**
7  *   @title SafeMath
8  *   @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12         uint256 c = a * b;
13         assert(a == 0 || c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal constant returns(uint256) {
18         assert(b > 0);
19         uint256 c = a / b;
20         assert(a == b * c + a % b);
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal constant returns(uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 
37 /**
38  *   @title ERC20
39  *   @dev Standart ERC20 token interface
40  */
41 contract ERC20 {
42     uint256 public totalSupply = 0;
43     mapping(address => uint256) balances;
44     mapping(address => mapping(address => uint256)) allowed;
45     function balanceOf(address _owner) public constant returns(uint256);
46     function transfer(address _to, uint256 _value) public returns(bool);
47     function transferFrom(address _from, address _to, uint256 _value) public returns(bool);
48     function approve(address _spender, uint256 _value) public returns(bool);
49     function allowance(address _owner, address _spender) public constant returns(uint256);
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 }
53 
54 /**
55  *   @title AidaICO contract  - takes funds from users and issues tokens
56  *   @dev AidaICO - it's the first ever contract for ICO which allows users to
57  *                  return their investments.
58  */
59 contract AidaICO {
60     // AID - Aida token contract
61     AidaToken public AID = new AidaToken(this);
62     using SafeMath for uint256;
63 
64     // Token price parameters
65     // These parameters can be changed only by oracle of contract
66     uint256 public Rate_Eth = 920; // Rate USD per ETH
67     uint256 public Tokens_Per_Dollar = 4; // Aida token per dollar
68     uint256 public Token_Price = Tokens_Per_Dollar.mul(Rate_Eth); // Aida token per ETH
69 
70     uint256 constant bountyPart = 10; // 1% of TotalSupply for BountyFund
71     uint256 constant partnersPart = 30; //3% f TotalSupply for PartnersFund
72     uint256 constant teamPart = 200; //20% of TotalSupply for TeamFund
73     uint256 constant icoAndPOfPart = 760; // 76% of TotalSupply for PublicICO and PrivateOffer
74     bool public returnPeriodExpired = false;
75     uint256 finishTime = 0;
76 
77     // Output ethereum addresses
78     address public Company;
79     address public BountyFund;
80     address public PartnersFund;
81     address public TeamFund;
82     address public Manager; // Manager controls contract
83     address public Controller_Address1; // First address that is used to buy tokens for other cryptos
84     address public Controller_Address2; // Second address that is used to buy tokens for other cryptos
85     address public Controller_Address3; // Third address that is used to buy tokens for other cryptos
86     address public Oracle; // Oracle address
87     address public RefundManager; // Refund manager address
88 
89     // Possible ICO statuses
90     enum StatusICO {
91         Created,
92         PreIcoStarted,
93         PreIcoPaused,
94         PreIcoFinished,
95         IcoStarted,
96         IcoPaused,
97         IcoFinished
98     }
99 
100     StatusICO statusICO = StatusICO.Created;
101 
102     // Mappings
103     mapping(address => uint256) public ethPreIco; // Mapping for remembering eth of investors who paid at PreICO
104     mapping(address => uint256) public ethIco; // Mapping for remembering eth of investors who paid at ICO
105     mapping(address => bool) public used; // Users can return their funds one time
106     mapping(address => uint256) public tokensPreIco; // Mapping for remembering tokens of investors who paid at preICO in ether
107     mapping(address => uint256) public tokensIco; // Mapping for remembering tokens of investors who paid at ICO in ethre
108     mapping(address => uint256) public tokensPreIcoInOtherCrypto; // Mapping for remembering tokens of investors who paid at preICO in other crypto currencies
109     mapping(address => uint256) public tokensIcoInOtherCrypto; // Mapping for remembering tokens of investors who paid at ICO in other crypto currencies
110 
111     // Events Log
112     event LogStartPreICO();
113     event LogPausePreICO();
114     event LogFinishPreICO();
115     event LogStartICO();
116     event LogPauseICO();
117     event LogFinishICO(address bountyFund, address partnersFund, address teamFund);
118     event LogBuyForInvestor(address investor, uint256 aidValue, string txHash);
119     event LogReturnEth(address investor, uint256 eth);
120     event LogReturnOtherCrypto(address investor, string logString);
121 
122     // Modifiers
123     // Allows execution by the refund manager only
124     modifier refundManagerOnly {
125         require(msg.sender == RefundManager);
126         _;
127     }
128     // Allows execution by the oracle only
129     modifier oracleOnly {
130         require(msg.sender == Oracle);
131         _;
132     }
133     // Allows execution by the contract manager only
134     modifier managerOnly {
135         require(msg.sender == Manager);
136         _;
137     }
138     // Allows execution by the one of controllers only
139     modifier controllersOnly {
140       require((msg.sender == Controller_Address1)
141            || (msg.sender == Controller_Address2)
142            || (msg.sender == Controller_Address3));
143       _;
144     }
145 
146 
147    /**
148     *   @dev Contract constructor function
149     */
150     function AidaICO(
151         address _Company,
152         address _BountyFund,
153         address _PartnersFund,
154         address _TeamFund,
155         address _Manager,
156         address _Controller_Address1,
157         address _Controller_Address2,
158         address _Controller_Address3,
159         address _Oracle,
160         address _RefundManager
161     )
162         public {
163         Company = _Company;
164         BountyFund = _BountyFund;
165         PartnersFund = _PartnersFund;
166         TeamFund = _TeamFund;
167         Manager = _Manager;
168         Controller_Address1 = _Controller_Address1;
169         Controller_Address2 = _Controller_Address2;
170         Controller_Address3 = _Controller_Address3;
171         Oracle = _Oracle;
172         RefundManager = _RefundManager;
173     }
174 
175    /**
176     *   @dev Set rate of ETH and update token price
177     *   @param _RateEth       current ETH rate
178     */
179     function setRate(uint256 _RateEth) external oracleOnly {
180         Rate_Eth = _RateEth;
181         Token_Price = Tokens_Per_Dollar.mul(Rate_Eth);
182     }
183 
184    /**
185     *   @dev Start PreIco
186     *   Set ICO status to PreIcoStarted
187     */
188     function startPreIco() external managerOnly {
189         require(statusICO == StatusICO.Created || statusICO == StatusICO.PreIcoPaused);
190         statusICO = StatusICO.PreIcoStarted;
191         LogStartPreICO();
192     }
193 
194    /**
195     *   @dev Pause PreIco
196     *   Set Ico status to PreIcoPaused
197     */
198     function pausePreIco() external managerOnly {
199         require(statusICO == StatusICO.PreIcoStarted);
200         statusICO = StatusICO.PreIcoPaused;
201         LogPausePreICO();
202     }
203    /**
204     *   @dev Finish PreIco
205     *   Set Ico status to PreIcoFinished
206     */
207     function finishPreIco() external managerOnly {
208         require(statusICO == StatusICO.PreIcoStarted || statusICO == StatusICO.PreIcoPaused);
209         statusICO = StatusICO.PreIcoFinished;
210         LogFinishPreICO();
211     }
212 
213    /**
214     *   @dev Start ICO
215     *   Set ICO status to IcoStarted
216     */
217     function startIco() external managerOnly {
218         require(statusICO == StatusICO.PreIcoFinished || statusICO == StatusICO.IcoPaused);
219         statusICO = StatusICO.IcoStarted;
220         LogStartICO();
221     }
222 
223    /**
224     *   @dev Pause Ico
225     *   Set Ico status to IcoPaused
226     */
227     function pauseIco() external managerOnly {
228         require(statusICO == StatusICO.IcoStarted);
229         statusICO = StatusICO.IcoPaused;
230         LogPauseICO();
231     }
232 
233    /**
234     *   @dev Finish ICO and emit tokens for bounty company, partners and team
235     */
236     function finishIco() external managerOnly {
237         require(statusICO == StatusICO.IcoStarted || statusICO == StatusICO.IcoPaused);
238         uint256 alreadyMinted = AID.totalSupply(); // = PublicICO
239         uint256 totalAmount = alreadyMinted.mul(1000).div(icoAndPOfPart);
240         AID.mintTokens(BountyFund, bountyPart.mul(totalAmount).div(1000));
241         AID.mintTokens(PartnersFund, partnersPart.mul(totalAmount).div(1000));
242         AID.mintTokens(TeamFund, teamPart.mul(totalAmount).div(1000));
243         statusICO = StatusICO.IcoFinished;
244         finishTime = now;
245         LogFinishICO(BountyFund, PartnersFund, TeamFund);
246     }
247 
248 
249    /**
250     *   @dev Unfreeze tokens(enable token transfers)
251     */
252     function enableTokensTransfer() external managerOnly {
253         AID.defrostTokens();
254     }
255 
256     /**
257     *   @dev Freeze tokens(disable token transfers)
258     */
259     function disableTokensTransfer() external managerOnly {
260         require((statusICO != StatusICO.IcoFinished) || (now <= finishTime + 21 days));
261         AID.frostTokens();
262     }
263 
264    /**
265     *   @dev Fallback function calls createTokensForEth() function to create tokens
266     *        when investor sends ETH to address of ICO contract
267     */
268     function() external payable {
269         require(statusICO == StatusICO.PreIcoStarted || statusICO == StatusICO.IcoStarted);
270         createTokensForEth(msg.sender, msg.value.mul(Token_Price));
271         rememberEther(msg.value, msg.sender);
272     }
273 
274    /**
275     *   @dev Store how many eth were invested by investor
276     *   @param _value        amount of invested ether in Wei
277     *   @param _investor     address of investor
278     */
279     function rememberEther(uint256 _value, address _investor) internal {
280         if (statusICO == StatusICO.PreIcoStarted) {
281             ethPreIco[_investor] = ethPreIco[_investor].add(_value);
282         }
283         if (statusICO == StatusICO.IcoStarted) {
284             ethIco[_investor] = ethIco[_investor].add(_value);
285         }
286     }
287 
288    /**
289     *   @dev Writes how many tokens investor received(for payments in ETH)
290     *   @param _value        amount of tokens
291     *   @param _investor     address of investor
292     */
293     function rememberTokensEth(uint256 _value, address _investor) internal {
294         if (statusICO == StatusICO.PreIcoStarted) {
295             tokensPreIco[_investor] = tokensPreIco[_investor].add(_value);
296         }
297         if (statusICO == StatusICO.IcoStarted) {
298             tokensIco[_investor] = tokensIco[_investor].add(_value);
299         }
300     }
301 
302    /**
303     *   @dev Writes how many tokens investor received(for payments in other cryptocurrencies)
304     *   @param _value        amount of tokens
305     *   @param _investor     address of investor
306     */
307     function rememberTokensOtherCrypto(uint256 _value, address _investor) internal {
308         if (statusICO == StatusICO.PreIcoStarted) {
309             tokensPreIcoInOtherCrypto[_investor] = tokensPreIcoInOtherCrypto[_investor].add(_value);
310         }
311         if (statusICO == StatusICO.IcoStarted) {
312             tokensIcoInOtherCrypto[_investor] = tokensIcoInOtherCrypto[_investor].add(_value);
313         }
314     }
315 
316    /**
317     *   @dev Issues tokens for users who made purchases in other cryptocurrencies
318     *   @param _investor     address the tokens will be issued to
319     *   @param _txHash       transaction hash of investor's payment
320     *   @param _aidValue     number of Aida tokens
321     */
322     function buyForInvestor(
323         address _investor,
324         uint256 _aidValue,
325         string _txHash
326     )
327         external
328         controllersOnly {
329         require(statusICO == StatusICO.PreIcoStarted || statusICO == StatusICO.IcoStarted);
330         createTokensForOtherCrypto(_investor, _aidValue);
331         LogBuyForInvestor(_investor, _aidValue, _txHash);
332     }
333 
334    /**
335     *   @dev Issue tokens for investors who paid in other cryptocurrencies
336     *   @param _investor     address which the tokens will be issued to
337     *   @param _aidValue     number of Aida tokens
338     */
339     function createTokensForOtherCrypto(address _investor, uint256 _aidValue) internal {
340         require(_aidValue > 0);
341         uint256 bonus = getBonus(_aidValue);
342         uint256 total = _aidValue.add(bonus);
343         rememberTokensOtherCrypto(total, _investor);
344         AID.mintTokens(_investor, total);
345     }
346 
347    /**
348     *   @dev Issue tokens for investors who paid in ether
349     *   @param _investor     address which the tokens will be issued to
350     *   @param _aidValue     number of Aida tokens
351     */
352     function createTokensForEth(address _investor, uint256 _aidValue) internal {
353         require(_aidValue > 0);
354         uint256 bonus = getBonus(_aidValue);
355         uint256 total = _aidValue.add(bonus);
356         rememberTokensEth(total, _investor);
357         AID.mintTokens(_investor, total);
358     }
359 
360    /**
361     *   @dev Calculates bonus if PreIco sales still not over
362     *   @param _value        amount of tokens
363     *   @return              bonus value
364     */
365     function getBonus(uint256 _value)
366         public
367         constant
368         returns(uint256)
369     {
370         uint256 bonus = 0;
371         if (statusICO == StatusICO.PreIcoStarted) {
372             bonus = _value.mul(15).div(100);
373         }
374         return bonus;
375     }
376 
377 
378   /**
379    *   @dev Enable returns of investments
380    */
381    function startRefunds() external managerOnly {
382         returnPeriodExpired = false;
383    }
384 
385   /**
386    *   @dev Disable returns of investments
387    */
388    function stopRefunds() external managerOnly {
389         returnPeriodExpired = true;
390    }
391 
392 
393    /**
394     *   @dev Allows investors to return their investments(in ETH)
395     *   if preICO or ICO return duration is not over yet
396     *   and burns tokens
397     */
398     function returnEther() public {
399         require(!used[msg.sender]);
400         require(!returnPeriodExpired);
401         uint256 eth = 0;
402         uint256 tokens = 0;
403         if (statusICO == StatusICO.PreIcoStarted) {
404             require(ethPreIco[msg.sender] > 0);
405             eth = ethPreIco[msg.sender];
406             tokens = tokensPreIco[msg.sender];
407             ethPreIco[msg.sender] = 0;
408             tokensPreIco[msg.sender] = 0;
409         }
410         if (statusICO == StatusICO.IcoStarted) {
411             require(ethIco[msg.sender] > 0);
412             eth = ethIco[msg.sender];
413             tokens = tokensIco[msg.sender];
414             ethIco[msg.sender] = 0;
415             tokensIco[msg.sender] = 0;
416         }
417         used[msg.sender] = true;
418         msg.sender.transfer(eth);
419         AID.burnTokens(msg.sender, tokens);
420         LogReturnEth(msg.sender, eth);
421     }
422 
423    /**
424     *   @dev Burn tokens of investors who paid in other cryptocurrencies
425     *   if preICO or ICO return duration is not over yet
426     *   @param _investor     address which tokens will be burnt
427     *   @param _logString    string which contains payment information
428     */
429     function returnOtherCrypto(
430         address _investor,
431         string _logString
432     )
433         external
434         refundManagerOnly {
435         uint256 tokens = 0;
436         require(!returnPeriodExpired);
437         if (statusICO == StatusICO.PreIcoStarted) {
438             tokens = tokensPreIcoInOtherCrypto[_investor];
439             tokensPreIcoInOtherCrypto[_investor] = 0;
440         }
441         if (statusICO == StatusICO.IcoStarted) {
442             tokens = tokensIcoInOtherCrypto[_investor];
443             tokensIcoInOtherCrypto[_investor] = 0;
444         }
445         AID.burnTokens(_investor, tokens);
446         LogReturnOtherCrypto(_investor, _logString);
447     }
448 
449    /**
450     *   @dev Allows Company withdraw investments
451     */
452     function withdrawEther() external managerOnly {
453         require(statusICO == StatusICO.PreIcoFinished || statusICO == StatusICO.IcoFinished);
454         Company.transfer(this.balance);
455     }
456 
457 }
458 
459 
460 /**
461  *   @title AidaToken
462  *   @dev Aida token contract
463  */
464 contract AidaToken is ERC20 {
465     using SafeMath for uint256;
466     string public name = "Aida TOKEN";
467     string public symbol = "AID";
468     uint256 public decimals = 18;
469 
470     // Ico contract address
471     address public ico;
472     event Burn(address indexed from, uint256 value);
473 
474     // Disables/enables token transfers
475     bool public tokensAreFrozen = true;
476 
477     // Allows execution by the owner only
478     modifier icoOnly {
479         require(msg.sender == ico);
480         _;
481     }
482 
483    /**
484     *   @dev Contract constructor function sets Ico address
485     *   @param _ico          ico address
486     */
487     function AidaToken(address _ico) public {
488         ico = _ico;
489     }
490 
491    /**
492     *   @dev Mint tokens
493     *   @param _holder       beneficiary address the tokens will be issued to
494     *   @param _value        number of tokens to issue
495     */
496     function mintTokens(address _holder, uint256 _value) external icoOnly {
497         require(_value > 0);
498         balances[_holder] = balances[_holder].add(_value);
499         totalSupply = totalSupply.add(_value);
500         Transfer(0x0, _holder, _value);
501     }
502 
503    /**
504     *   @dev Enables token transfers
505     */
506     function defrostTokens() external icoOnly {
507       tokensAreFrozen = false;
508     }
509 
510    /**
511     *   @dev Disables token transfers
512     */
513     function frostTokens() external icoOnly {
514       tokensAreFrozen = true;
515     }
516 
517    /**
518     *   @dev Burn Tokens
519     *   @param _investor     token holder address which the tokens will be burnt
520     *   @param _value        number of tokens to burn
521     */
522     function burnTokens(address _investor, uint256 _value) external icoOnly {
523         require(balances[_investor] > 0);
524         totalSupply = totalSupply.sub(_value);
525         balances[_investor] = balances[_investor].sub(_value);
526         Burn(_investor, _value);
527     }
528 
529    /**
530     *   @dev Get balance of investor
531     *   @param _owner        investor's address
532     *   @return              balance of investor
533     */
534     function balanceOf(address _owner) public constant returns(uint256) {
535       return balances[_owner];
536     }
537 
538    /**
539     *   @dev Send coins
540     *   throws on any error rather then return a false flag to minimize
541     *   user errors
542     *   @param _to           target address
543     *   @param _amount       transfer amount
544     *
545     *   @return true if the transfer was successful
546     */
547     function transfer(address _to, uint256 _amount) public returns(bool) {
548         require(!tokensAreFrozen);
549         balances[msg.sender] = balances[msg.sender].sub(_amount);
550         balances[_to] = balances[_to].add(_amount);
551         Transfer(msg.sender, _to, _amount);
552         return true;
553     }
554 
555    /**
556     *   @dev An account/contract attempts to get the coins
557     *   throws on any error rather then return a false flag to minimize user errors
558     *
559     *   @param _from         source address
560     *   @param _to           target address
561     *   @param _amount       transfer amount
562     *
563     *   @return true if the transfer was successful
564     */
565     function transferFrom(address _from, address _to, uint256 _amount) public returns(bool) {
566         require(!tokensAreFrozen);
567         balances[_from] = balances[_from].sub(_amount);
568         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
569         balances[_to] = balances[_to].add(_amount);
570         Transfer(_from, _to, _amount);
571         return true;
572     }
573 
574    /**
575     *   @dev Allows another account/contract to spend some tokens on its behalf
576     *   throws on any error rather then return a false flag to minimize user errors
577     *
578     *   also, to minimize the risk of the approve/transferFrom attack vector
579     *   approve has to be called twice in 2 separate transactions - once to
580     *   change the allowance to 0 and secondly to change it to the new allowance
581     *   value
582     *
583     *   @param _spender      approved address
584     *   @param _amount       allowance amount
585     *
586     *   @return true if the approval was successful
587     */
588     function approve(address _spender, uint256 _amount) public returns(bool) {
589         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
590         allowed[msg.sender][_spender] = _amount;
591         Approval(msg.sender, _spender, _amount);
592         return true;
593     }
594 
595    /**
596     *   @dev Function to check the amount of tokens that an owner allowed to a spender.
597     *
598     *   @param _owner        the address which owns the funds
599     *   @param _spender      the address which will spend the funds
600     *
601     *   @return              the amount of tokens still avaible for the spender
602     */
603     function allowance(address _owner, address _spender) public constant returns(uint256) {
604         return allowed[_owner][_spender];
605     }
606 }