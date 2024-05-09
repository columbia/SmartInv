1 // Datarius tokensale smart contract.
2 // Developed by Phenom.Team <info@phenom.team>
3 pragma solidity ^0.4.15;
4 
5 /**
6  *   @title SafeMath
7  *   @dev Math operations with safety checks that throw on error
8  */
9 
10 library SafeMath {
11 
12   function mul(uint a, uint b) internal constant returns (uint) {
13     if (a == 0) {
14       return 0;
15     }
16     uint c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint a, uint b) internal constant returns(uint) {
22     assert(b > 0);
23     uint c = a / b;
24     assert(a == b * c + a % b);
25     return c;
26   }
27 
28   function sub(uint a, uint b) internal constant returns(uint) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint a, uint b) internal constant returns(uint) {
34     uint c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 /**
41  *   @title ERC20
42  *   @dev Standart ERC20 token interface
43  */
44 
45 contract ERC20 {
46     uint public totalSupply = 0;
47 
48     mapping(address => uint) balances;
49     mapping(address => mapping (address => uint)) allowed;
50 
51     function balanceOf(address _owner) constant returns (uint);
52     function transfer(address _to, uint _value) returns (bool);
53     function transferFrom(address _from, address _to, uint _value) returns (bool);
54     function approve(address _spender, uint _value) returns (bool);
55     function allowance(address _owner, address _spender) constant returns (uint);
56 
57     event Transfer(address indexed _from, address indexed _to, uint _value);
58     event Approval(address indexed _owner, address indexed _spender, uint _value);
59 
60 } 
61 
62 /**
63  *   @title DatariusICO contract  - takes funds from users and issues tokens
64  */
65 contract DatariusICO {
66     // DTRC - Datarius token contract
67     using SafeMath for uint;
68     DatariusToken public DTRC = new DatariusToken(this);
69     ERC20 public preSaleToken;
70 
71     // Token price parameters
72     // These parametes can be changed only by manager of contract
73     uint public tokensPerDollar = 100;
74     uint public rateEth = 1176; // Rate USD per ETH
75     uint public tokenPrice = tokensPerDollar * rateEth; // DTRC per ETH
76     uint public DatToDtrcNumerator = 4589059589;
77     uint public DatToDtrcDenominator = 100000000;
78 
79     //Crowdsale parameters
80     uint constant softCap = 1000000 * tokensPerDollar * 1e18; 
81     uint constant hardCap = 51000000 * tokensPerDollar * 1e18;
82     uint constant bountyPart = 2; // 2% of TotalSupply for BountyFund
83     uint constant partnersPart = 5; // 5% of TotalSupply for ParnersFund
84     uint constant teamPart = 5; // 5% of TotalSupply for TeamFund
85     uint constant reservePart = 15; // 15% of TotalSupply for ResrveFund
86     uint constant publicIcoPart = 73; // 73% of TotalSupply for publicICO
87     uint public soldAmount = 0;
88     uint startTime = 0;
89     // Output ethereum addresses
90     address public Company;
91     address public BountyFund;
92     address public PartnersFund;
93     address public TeamFund;
94     address public ReserveFund;
95     address public Manager; // Manager controls contract
96     address public ReserveManager; // // Manager controls contract
97     address public Controller_Address1; // First address that is used to buy tokens for other cryptos
98     address public Controller_Address2; // Second address that is used to buy tokens for other cryptos
99     address public Controller_Address3; // Third address that is used to buy tokens for other cryptos
100     address public RefundManager; // Refund manager address
101     address public Oracle; // Oracle address
102 
103     // Possible ICO statuses
104     enum StatusICO {
105         Created,
106         Started,
107         Paused,
108         Finished
109     }
110     StatusICO statusICO = StatusICO.Created;
111     
112     // Mappings
113     mapping(address => uint) public investmentsInEth; // Mapping for remembering ether of investors
114     mapping(address => uint) public tokensEth; // Mapping for remembering tokens of investors who invest in ETH
115     mapping(address => uint) public tokensOtherCrypto; // Mapping for remembering tokens of investors who invest in other crypto currencies
116     mapping(address => bool) public swaped;
117     // Events Log
118     event LogStartICO();
119     event LogPause();
120     event LogFinishICO();
121     event LogBuyForInvestor(address investor, uint DTRCValue, string txHash);
122     event LogSwapTokens(address investor, uint tokensAmount);
123     event LogReturnEth(address investor, uint eth);
124     event LogReturnOtherCrypto(address investor, string logString);
125 
126     // Modifiers
127     // Allows execution by the managers only
128     modifier managersOnly { 
129         require(
130             (msg.sender == Manager) ||
131             (msg.sender == ReserveManager)
132         );
133         _; 
134      }
135     // Allows execution by the contract manager only
136     modifier refundManagersOnly { 
137         require(msg.sender == RefundManager);
138         _; 
139      }
140     // Allows execution by the oracle only
141     modifier oracleOnly { 
142         require(msg.sender == Oracle);
143         _; 
144      }
145     // Allows execution by the one of controllers only
146     modifier controllersOnly {
147         require(
148             (msg.sender == Controller_Address1)||
149             (msg.sender == Controller_Address2)||
150             (msg.sender == Controller_Address3)
151         );
152         _;
153     }
154 
155    /**
156     *   @dev Contract constructor function
157     */
158     function DatariusICO(
159         address _preSaleToken,
160         address _Company,
161         address _BountyFund,
162         address _PartnersFund,
163         address _ReserveFund,
164         address _TeamFund,
165         address _Manager,
166         address _ReserveManager,
167         address _Controller_Address1,
168         address _Controller_Address2,
169         address _Controller_Address3,
170         address _RefundManager,
171         address _Oracle
172         ) public {
173         preSaleToken = ERC20(_preSaleToken);
174         Company = _Company;
175         BountyFund = _BountyFund;
176         PartnersFund = _PartnersFund;
177         ReserveFund = _ReserveFund;
178         TeamFund = _TeamFund;
179         Manager = _Manager;
180         ReserveManager = _ReserveManager;
181         Controller_Address1 = _Controller_Address1;
182         Controller_Address2 = _Controller_Address2;
183         Controller_Address3 = _Controller_Address3;
184         RefundManager = _RefundManager;
185         Oracle = _Oracle;
186     }
187 
188    /**
189     *   @dev Function to set rate of ETH and update token price
190     *   @param _rateEth       current ETH rate
191     */
192     function setRate(uint _rateEth) external oracleOnly {
193         rateEth = _rateEth;
194         tokenPrice = tokensPerDollar.mul(rateEth);
195     }
196 
197    /**
198     *   @dev Function to start ICO
199     *   Sets ICO status to Started, inits startTime
200     */
201     function startIco() external managersOnly {
202         require(statusICO == StatusICO.Created || statusICO == StatusICO.Paused);
203         if(statusICO == StatusICO.Created) {
204           startTime = now;
205         }
206         statusICO = StatusICO.Started;
207         LogStartICO();
208     }
209 
210    /**
211     *   @dev Function to pause ICO
212     *   Sets ICO status to Paused
213     */
214     function pauseIco() external managersOnly {
215        require(statusICO == StatusICO.Started);
216        statusICO = StatusICO.Paused;
217        LogPause();
218     }
219 
220    /**
221     *   @dev Function to finish ICO
222     *   Emits tokens for bounty company, partners and team
223     */
224     function finishIco() external managersOnly {
225         require(statusICO == StatusICO.Started || statusICO == StatusICO.Paused);
226         uint alreadyMinted = DTRC.totalSupply();
227         uint totalAmount = alreadyMinted.mul(100).div(publicIcoPart);
228         DTRC.mintTokens(BountyFund, bountyPart.mul(totalAmount).div(100));
229         DTRC.mintTokens(PartnersFund, partnersPart.mul(totalAmount).div(100));
230         DTRC.mintTokens(TeamFund, teamPart.mul(totalAmount).div(100));
231         DTRC.mintTokens(ReserveFund, reservePart.mul(totalAmount).div(100));
232         if (soldAmount >= softCap) {
233             DTRC.defrost();
234         }
235         statusICO = StatusICO.Finished;
236         LogFinishICO();
237     }
238 
239    /**
240     *   @dev Function to swap tokens from pre-sale
241     *   @param _investor     pre-sale tokens holder address
242     */
243     function swapTokens(address _investor) external managersOnly {
244          require(!swaped[_investor] && statusICO != StatusICO.Finished);
245          swaped[_investor] = true;
246          uint tokensToSwap = preSaleToken.balanceOf(_investor);
247          uint DTRCTokens = tokensToSwap.mul(DatToDtrcNumerator).div(DatToDtrcDenominator);
248          DTRC.mintTokens(_investor, DTRCTokens);
249          LogSwapTokens(_investor, tokensToSwap);
250     }
251    /**
252     *   @dev Fallback function calls buy(address _investor, uint _DTRCValue) function to issue tokens
253     *        when investor sends ETH to address of ICO contract and then stores investment amount 
254     */
255     function() external payable {
256         buy(msg.sender, msg.value.mul(tokenPrice));
257         investmentsInEth[msg.sender] = investmentsInEth[msg.sender].add(msg.value); 
258     }
259 
260    /**
261     *   @dev Function to issues tokens for investors who made purchases in other cryptocurrencies
262     *   @param _investor     address the tokens will be issued to
263     *   @param _txHash       transaction hash of investor's payment
264     *   @param _DTRCValue    number of DTRC tokens
265     */
266 
267     function buyForInvestor(
268         address _investor, 
269         uint _DTRCValue, 
270         string _txHash
271     ) 
272         external 
273         controllersOnly {
274         require(statusICO == StatusICO.Started);
275         require(soldAmount + _DTRCValue <= hardCap);
276         uint bonus = getBonus(_DTRCValue);
277         uint total = _DTRCValue.add(bonus);
278         DTRC.mintTokens(_investor, total);
279         soldAmount = soldAmount.add(_DTRCValue);
280         tokensOtherCrypto[_investor] = tokensOtherCrypto[_investor].add(total); 
281         LogBuyForInvestor(_investor, total, _txHash);
282     }
283 
284    /**
285     *   @dev Function to issue tokens for investors who paid in ether
286     *   @param _investor     address which the tokens will be issued tokens
287     *   @param _DTRCValue    number of DTRC tokens
288     */
289     function buy(address _investor, uint _DTRCValue) internal {
290         require(statusICO == StatusICO.Started);
291         require(soldAmount + _DTRCValue <= hardCap);
292         uint bonus = getBonus(_DTRCValue);
293         uint total = _DTRCValue.add(bonus);
294         DTRC.mintTokens(_investor, total);
295         soldAmount = soldAmount.add(_DTRCValue);
296         tokensEth[msg.sender] = tokensEth[msg.sender].add(total); 
297     }
298 
299    /**
300     *   @dev Calculates bonus 
301     *   @param _value        amount of tokens
302     *   @return              bonus value
303     */
304     function getBonus(uint _value) public constant returns (uint) {
305         uint bonus = 0;
306         if(now <= startTime + 6 hours) {
307             bonus = _value.mul(30).div(100);
308             return bonus;
309         }
310         if(now <= startTime + 12 hours) {
311             bonus = _value.mul(25).div(100);
312             return bonus;
313         }
314         if(now <= startTime + 24 hours) {
315             bonus = _value.mul(20).div(100);
316             return bonus;
317         }
318         if(now <= startTime + 48 hours) {
319             bonus = _value.mul(15).div(100);
320             return bonus;
321         }
322         if(now <= startTime + 15 days) {
323             bonus = _value.mul(10).div(100);
324             return bonus;
325         }
326     return bonus;
327     }
328 
329    /**
330     *   @dev Allows investors to return their investment after the ICO is over
331     *   in the case when the SoftCap was not achieved
332     */
333     function refundEther() public {
334         require(
335             statusICO == StatusICO.Finished && 
336             soldAmount < softCap && 
337             investmentsInEth[msg.sender] > 0
338         );
339         uint ethToRefund = investmentsInEth[msg.sender];
340         investmentsInEth[msg.sender] = 0;
341         uint tokensToBurn = tokensEth[msg.sender];
342         tokensEth[msg.sender] = 0;
343         DTRC.burnTokens(msg.sender, tokensToBurn);
344         msg.sender.transfer(ethToRefund);
345         LogReturnEth(msg.sender, ethToRefund);
346     }
347 
348    /**
349     *   @dev Burn tokens of investors who paid in other cryptocurrencies after the ICO is over
350     *   in the case when the SoftCap was not achieved
351     *   @param _investor     address which the tokens will be burnt
352     *   @param _logString    string which contain payment information
353     */
354     function refundOtherCrypto(
355         address _investor, 
356         string _logString
357     ) 
358         public
359         refundManagersOnly {
360         require(
361             statusICO == StatusICO.Finished && 
362             soldAmount < softCap
363         );
364         uint tokensToBurn = tokensOtherCrypto[_investor];
365         tokensOtherCrypto[_investor] = 0;
366         DTRC.burnTokens(_investor, tokensToBurn);
367         LogReturnOtherCrypto(_investor, _logString);
368     }
369 
370    /**
371     *   @dev Allows Company withdraw investments when ICO is over and soft cap achieved
372     */
373     function withdrawEther() external managersOnly {
374         require(statusICO == StatusICO.Finished && soldAmount >= softCap);
375         Company.transfer(this.balance);
376     }
377 
378 }
379 
380 /**
381  *   @title DatariusToken
382  *   @dev Datarius token contract
383  */
384 contract DatariusToken is ERC20 {
385     using SafeMath for uint;
386     string public name = "Datarius Credit";
387     string public symbol = "DTRC";
388     uint public decimals = 18;
389 
390     // Ico contract address
391     address public ico;
392     event Burn(address indexed from, uint value);
393     
394     // Tokens transfer ability status
395     bool public tokensAreFrozen = true;
396 
397     // Allows execution by the owner only
398     modifier icoOnly { 
399         require(msg.sender == ico); 
400         _; 
401     }
402 
403    /**
404     *   @dev Contract constructor function sets Ico address
405     *   @param _ico          ico address
406     */
407     function DatariusToken(address _ico) public {
408        ico = _ico;
409     }
410 
411    /**
412     *   @dev Function to mint tokens
413     *   @param _holder       beneficiary address the tokens will be issued to
414     *   @param _value        number of tokens to issue
415     */
416     function mintTokens(address _holder, uint _value) external icoOnly {
417        require(_value > 0);
418        balances[_holder] = balances[_holder].add(_value);
419        totalSupply = totalSupply.add(_value);
420        Transfer(0x0, _holder, _value);
421     }
422 
423 
424    /**
425     *   @dev Function to enable token transfers
426     */
427     function defrost() external icoOnly {
428        tokensAreFrozen = false;
429     }
430 
431 
432    /**
433     *   @dev Burn Tokens
434     *   @param _holder       token holder address which the tokens will be burnt
435     *   @param _value        number of tokens to burn
436     */
437     function burnTokens(address _holder, uint _value) external icoOnly {
438         require(balances[_holder] > 0);
439         totalSupply = totalSupply.sub(_value);
440         balances[_holder] = balances[_holder].sub(_value);
441         Burn(_holder, _value);
442     }
443 
444    /**
445     *   @dev Get balance of tokens holder
446     *   @param _holder        holder's address
447     *   @return               balance of investor
448     */
449     function balanceOf(address _holder) constant returns (uint) {
450          return balances[_holder];
451     }
452 
453    /**
454     *   @dev Send coins
455     *   throws on any error rather then return a false flag to minimize
456     *   user errors
457     *   @param _to           target address
458     *   @param _amount       transfer amount
459     *
460     *   @return true if the transfer was successful
461     */
462     function transfer(address _to, uint _amount) public returns (bool) {
463         require(!tokensAreFrozen);
464         balances[msg.sender] = balances[msg.sender].sub(_amount);
465         balances[_to] = balances[_to].add(_amount);
466         Transfer(msg.sender, _to, _amount);
467         return true;
468     }
469 
470    /**
471     *   @dev An account/contract attempts to get the coins
472     *   throws on any error rather then return a false flag to minimize user errors
473     *
474     *   @param _from         source address
475     *   @param _to           target address
476     *   @param _amount       transfer amount
477     *
478     *   @return true if the transfer was successful
479     */
480     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
481         require(!tokensAreFrozen);
482         balances[_from] = balances[_from].sub(_amount);
483         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
484         balances[_to] = balances[_to].add(_amount);
485         Transfer(_from, _to, _amount);
486         return true;
487      }
488 
489 
490    /**
491     *   @dev Allows another account/contract to spend some tokens on its behalf
492     *   throws on any error rather then return a false flag to minimize user errors
493     *
494     *   also, to minimize the risk of the approve/transferFrom attack vector
495     *   approve has to be called twice in 2 separate transactions - once to
496     *   change the allowance to 0 and secondly to change it to the new allowance
497     *   value
498     *
499     *   @param _spender      approved address
500     *   @param _amount       allowance amount
501     *
502     *   @return true if the approval was successful
503     */
504     function approve(address _spender, uint _amount) public returns (bool) {
505         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
506         allowed[msg.sender][_spender] = _amount;
507         Approval(msg.sender, _spender, _amount);
508         return true;
509     }
510 
511    /**
512     *   @dev Function to check the amount of tokens that an owner allowed to a spender.
513     *
514     *   @param _owner        the address which owns the funds
515     *   @param _spender      the address which will spend the funds
516     *
517     *   @return              the amount of tokens still avaible for the spender
518     */
519     function allowance(address _owner, address _spender) constant returns (uint) {
520         return allowed[_owner][_spender];
521     }
522 }