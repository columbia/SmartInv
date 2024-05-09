1 // Play2liveICO tokensale smart contract.
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
48     mapping(address => uint256) balances;
49     mapping(address => mapping (address => uint256)) allowed;
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
63  *   @title Play2liveICO contract  - takes funds from users and issues tokens
64  */
65 contract Play2liveICO {
66     // LUC - Level Up Coin token contract
67     using SafeMath for uint;
68     LucToken public LUC = new LucToken(this);
69     Presale public preSaleToken;
70 
71     // Token price parameters
72     // These parametes can be changed only by manager of contract
73     uint public tokensPerDollar = 20;
74     uint public rateEth = 446; // Rate USD per ETH
75     uint public tokenPrice = tokensPerDollar * rateEth; // DTRC per ETH
76     //Crowdsale parameters
77     uint constant publicIcoPart = 625; // 62,5% of TotalSupply for BountyFund
78     uint constant operationsPart = 111;
79     uint constant foundersPart = 104;
80     uint constant partnersPart = 78; // 7,8% of TotalSupply for parnersFund
81     uint constant advisorsPart = 72;
82     uint constant bountyPart = 10; // 1% of TotalSupply for BountyFund
83     uint constant hardCap = 30000000 * tokensPerDollar * 1e18; // 
84     uint public soldAmount = 0;
85     // Output ethereum addresses
86     address public Company;
87     address public OperationsFund;
88     address public FoundersFund;
89     address public PartnersFund;
90     address public AdvisorsFund;
91     address public BountyFund;
92     address public Manager; // Manager controls contract
93     address public Controller_Address1; // First address that is used to buy tokens for other cryptos
94     address public Controller_Address2; // Second address that is used to buy tokens for other cryptos
95     address public Controller_Address3; // Third address that is used to buy tokens for other cryptos
96     address public Oracle; // Oracle address
97 
98     // Possible ICO statuses
99     enum StatusICO {
100         Created,
101         PreIcoStarted,
102         PreIcoPaused,
103         PreIcoFinished,
104         IcoStarted,
105         IcoPaused,
106         IcoFinished
107     }
108     StatusICO statusICO = StatusICO.Created;
109     
110     // Mappings
111     mapping(address => bool) public swaped;
112     mapping (address => string) public keys;
113     
114     // Events Log
115     event LogStartPreICO();
116     event LogPausePreICO();
117     event LogFinishPreICO();
118     event LogStartICO();
119     event LogPauseICO();
120     event LogFinishICO();
121     event LogBuyForInvestor(address investor, uint lucValue, string txHash);
122     event LogSwapTokens(address investor, uint tokensAmount);
123     event LogRegister(address investor, string key);
124 
125     // Modifiers
126     // Allows execution by the manager only
127     modifier managerOnly { 
128         require(msg.sender == Manager);
129         _; 
130      }
131     // Allows execution by the oracle only
132     modifier oracleOnly { 
133         require(msg.sender == Oracle);
134         _; 
135      }
136     // Allows execution by the one of controllers only
137     modifier controllersOnly {
138         require(
139             (msg.sender == Controller_Address1)||
140             (msg.sender == Controller_Address2)||
141             (msg.sender == Controller_Address3)
142         );
143         _;
144     }
145 
146 
147    /**
148     *   @dev Contract constructor function
149     */
150     function Play2liveICO(
151         address _preSaleToken,
152         address _Company,
153         address _OperationsFund,
154         address _FoundersFund,
155         address _PartnersFund,
156         address _AdvisorsFund,
157         address _BountyFund,
158         address _Manager,
159         address _Controller_Address1,
160         address _Controller_Address2,
161         address _Controller_Address3,
162         address _Oracle
163         ) public {
164         preSaleToken = Presale(_preSaleToken);
165         Company = _Company;
166         OperationsFund = _OperationsFund;
167         FoundersFund = _FoundersFund;
168         PartnersFund = _PartnersFund;
169         AdvisorsFund = _AdvisorsFund;
170         BountyFund = _BountyFund;
171         Manager = _Manager;
172         Controller_Address1 = _Controller_Address1;
173         Controller_Address2 = _Controller_Address2;
174         Controller_Address3 = _Controller_Address3;
175         Oracle = _Oracle;
176     }
177 
178    /**
179     *   @dev Function to set rate of ETH and update token price
180     *   @param _rateEth       current ETH rate
181     */
182     function setRate(uint _rateEth) external oracleOnly {
183         rateEth = _rateEth;
184         tokenPrice = tokensPerDollar.mul(rateEth);
185     }
186 
187    /**
188     *   @dev Function to start PreICO
189     *   Sets ICO status to PreIcoStarted
190     */
191     function startPreIco() external managerOnly {
192         require(statusICO == StatusICO.Created || statusICO == StatusICO.PreIcoPaused);
193         statusICO = StatusICO.PreIcoStarted;
194         LogStartPreICO();
195     }
196 
197    /**
198     *   @dev Function to pause PreICO
199     *   Sets ICO status to PreIcoPaused
200     */
201     function pausePreIco() external managerOnly {
202        require(statusICO == StatusICO.PreIcoStarted);
203        statusICO = StatusICO.PreIcoPaused;
204        LogPausePreICO();
205     }
206 
207    /**
208     *   @dev Function to finish PreICO
209     *   Sets ICO status to PreIcoFinished
210     */
211     function finishPreIco() external managerOnly {
212         require(statusICO == StatusICO.PreIcoStarted || statusICO == StatusICO.PreIcoPaused);
213         statusICO = StatusICO.PreIcoFinished;
214         LogFinishPreICO();
215     }
216 
217    /**
218     *   @dev Function to start ICO
219     *   Sets ICO status to IcoStarted
220     */
221     function startIco() external managerOnly {
222         require(statusICO == StatusICO.PreIcoFinished || statusICO == StatusICO.IcoPaused);
223         statusICO = StatusICO.IcoStarted;
224         LogStartICO();
225     }
226 
227    /**
228     *   @dev Function to pause ICO
229     *   Sets ICO status to IcoPaused
230     */
231     function pauseIco() external managerOnly {
232        require(statusICO == StatusICO.IcoStarted);
233        statusICO = StatusICO.IcoPaused;
234        LogPauseICO();
235     }
236 
237    /**
238     *   @dev Function to finish ICO
239     *   Sets ICO status to IcoFinished and  emits tokens for funds
240     */
241     function finishIco() external managerOnly {
242         require(statusICO == StatusICO.IcoStarted || statusICO == StatusICO.IcoPaused);
243         uint alreadyMinted = LUC.totalSupply();
244         uint totalAmount = alreadyMinted.mul(1000).div(publicIcoPart);
245         LUC.mintTokens(OperationsFund, operationsPart.mul(totalAmount).div(1000));
246         LUC.mintTokens(FoundersFund, foundersPart.mul(totalAmount).div(1000));
247         LUC.mintTokens(PartnersFund, partnersPart.mul(totalAmount).div(1000));
248         LUC.mintTokens(AdvisorsFund, advisorsPart.mul(totalAmount).div(1000));
249         LUC.mintTokens(BountyFund, bountyPart.mul(totalAmount).div(1000));
250         statusICO = StatusICO.IcoFinished;
251         LogFinishICO();
252     }
253 
254    /**
255     *   @dev Unfreeze tokens(enable token transfers)
256     */
257     function unfreeze() external managerOnly {
258         require(statusICO == StatusICO.IcoFinished);
259         LUC.defrost();
260     }
261     
262    /**
263     *   @dev Function to swap tokens from pre-sale
264     *   @param _investor     pre-sale tokens holder address
265     */
266     function swapTokens(address _investor) external managerOnly {
267          require(statusICO != StatusICO.IcoFinished);
268          require(!swaped[_investor]);
269          swaped[_investor] = true;
270          uint tokensToSwap = preSaleToken.balanceOf(_investor);
271          LUC.mintTokens(_investor, tokensToSwap);
272          soldAmount = soldAmount.add(tokensToSwap);
273          LogSwapTokens(_investor, tokensToSwap);
274     }
275    /**
276     *   @dev Fallback function calls buy(address _investor, uint _DTRCValue) function to issue tokens
277     *        when investor sends ETH to address of ICO contract and then stores investment amount 
278     */
279     function() external payable {
280         if (statusICO == StatusICO.PreIcoStarted) {
281             require(msg.value >= 100 finney);
282         }
283         buy(msg.sender, msg.value.mul(tokenPrice)); 
284     }
285 
286    /**
287     *   @dev Function to issues tokens for investors who made purchases in other cryptocurrencies
288     *   @param _investor     address the tokens will be issued to
289     *   @param _txHash       transaction hash of investor's payment
290     *   @param _lucValue     number of LUC tokens
291     */
292 
293     function buyForInvestor(
294         address _investor, 
295         uint _lucValue, 
296         string _txHash
297     ) 
298         external 
299         controllersOnly {
300         buy(_investor, _lucValue);
301         LogBuyForInvestor(_investor, _lucValue, _txHash);
302     }
303 
304    /**
305     *   @dev Function to issue tokens for investors who paid in ether
306     *   @param _investor     address which the tokens will be issued tokens
307     *   @param _lucValue     number of LUC tokens
308     */
309     function buy(address _investor, uint _lucValue) internal {
310         require(statusICO == StatusICO.PreIcoStarted || statusICO == StatusICO.IcoStarted);
311         uint bonus = getBonus(_lucValue);
312         uint total = _lucValue.add(bonus);
313         require(soldAmount + _lucValue <= hardCap);
314         LUC.mintTokens(_investor, total);
315         soldAmount = soldAmount.add(_lucValue);
316     }
317 
318 
319 
320    /**
321     *   @dev Function to calculates bonuses 
322     *   @param _value        amount of tokens
323     *   @return              bonus value
324     */
325     function getBonus(uint _value) public constant returns (uint) {
326         uint bonus = 0;
327         if (statusICO == StatusICO.PreIcoStarted) {
328             if (now < 1517356800) {
329                 bonus = _value.mul(30).div(100);
330                 return bonus;
331             } else {
332                 bonus = _value.mul(25).div(100);
333                 return bonus;                
334             }
335         }
336         if (statusICO == StatusICO.IcoStarted) {
337             if (now < 1518652800) {
338                 bonus = _value.mul(10).div(100);
339                 return bonus;                   
340             }
341             if (now < 1518912000) {
342                 bonus = _value.mul(9).div(100);
343                 return bonus;                   
344             }
345             if (now < 1519171200) {
346                 bonus = _value.mul(8).div(100);
347                 return bonus;                   
348             }
349             if (now < 1519344000) {
350                 bonus = _value.mul(7).div(100);
351                 return bonus;                   
352             }
353             if (now < 1519516800) {
354                 bonus = _value.mul(6).div(100);
355                 return bonus;                   
356             }
357             if (now < 1519689600) {
358                 bonus = _value.mul(5).div(100);
359                 return bonus;                   
360             }
361             if (now < 1519862400) {
362                 bonus = _value.mul(4).div(100);
363                 return bonus;                   
364             }
365             if (now < 1520035200) {
366                 bonus = _value.mul(3).div(100);
367                 return bonus;                   
368             }
369             if (now < 1520208000) {
370                 bonus = _value.mul(2).div(100);
371                 return bonus;                   
372             } else {
373                 bonus = _value.mul(1).div(100);
374                 return bonus;                   
375             }
376         }
377         return bonus;
378     }
379 
380    /**
381     *   @dev Allows invetsot to register thier Level Up Chain address
382     */
383     function register(string _key) public {
384         keys[msg.sender] = _key;
385         LogRegister(msg.sender, _key);
386     }
387 
388    /**
389     *   @dev Allows Company withdraw investments
390     */
391     function withdrawEther() external managerOnly {
392         Company.transfer(this.balance);
393     }
394 
395 }
396 
397 /**
398  *   @title LucToken
399  *   @dev Luc token contract
400  */
401 contract LucToken is ERC20 {
402     using SafeMath for uint;
403     string public name = "Level Up Coin";
404     string public symbol = "LUC";
405     uint public decimals = 18;
406 
407     // Ico contract address
408     address public ico;
409     
410     // Tokens transfer ability status
411     bool public tokensAreFrozen = true;
412 
413     // Allows execution by the owner only
414     modifier icoOnly { 
415         require(msg.sender == ico); 
416         _; 
417     }
418 
419    /**
420     *   @dev Contract constructor function sets Ico address
421     *   @param _ico          ico address
422     */
423     function LucToken(address _ico) public {
424        ico = _ico;
425     }
426 
427    /**
428     *   @dev Function to mint tokens
429     *   @param _holder       beneficiary address the tokens will be issued to
430     *   @param _value        number of tokens to issue
431     */
432     function mintTokens(address _holder, uint _value) external icoOnly {
433        require(_value > 0);
434        balances[_holder] = balances[_holder].add(_value);
435        totalSupply = totalSupply.add(_value);
436        Transfer(0x0, _holder, _value);
437     }
438 
439 
440    /**
441     *   @dev Function to enable token transfers
442     */
443     function defrost() external icoOnly {
444        tokensAreFrozen = false;
445     }
446 
447    /**
448     *   @dev Get balance of tokens holder
449     *   @param _holder        holder's address
450     *   @return               balance of investor
451     */
452     function balanceOf(address _holder) constant returns (uint256) {
453          return balances[_holder];
454     }
455 
456    /**
457     *   @dev Send coins
458     *   throws on any error rather then return a false flag to minimize
459     *   user errors
460     *   @param _to           target address
461     *   @param _amount       transfer amount
462     *
463     *   @return true if the transfer was successful
464     */
465     function transfer(address _to, uint256 _amount) public returns (bool) {
466         require(!tokensAreFrozen);
467         balances[msg.sender] = balances[msg.sender].sub(_amount);
468         balances[_to] = balances[_to].add(_amount);
469         Transfer(msg.sender, _to, _amount);
470         return true;
471     }
472 
473    /**
474     *   @dev An account/contract attempts to get the coins
475     *   throws on any error rather then return a false flag to minimize user errors
476     *
477     *   @param _from         source address
478     *   @param _to           target address
479     *   @param _amount       transfer amount
480     *
481     *   @return true if the transfer was successful
482     */
483     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
484         require(!tokensAreFrozen);
485         balances[_from] = balances[_from].sub(_amount);
486         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
487         balances[_to] = balances[_to].add(_amount);
488         Transfer(_from, _to, _amount);
489         return true;
490      }
491 
492 
493    /**
494     *   @dev Allows another account/contract to spend some tokens on its behalf
495     *   throws on any error rather then return a false flag to minimize user errors
496     *
497     *   also, to minimize the risk of the approve/transferFrom attack vector
498     *   approve has to be called twice in 2 separate transactions - once to
499     *   change the allowance to 0 and secondly to change it to the new allowance
500     *   value
501     *
502     *   @param _spender      approved address
503     *   @param _amount       allowance amount
504     *
505     *   @return true if the approval was successful
506     */
507     function approve(address _spender, uint256 _amount) public returns (bool) {
508         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
509         allowed[msg.sender][_spender] = _amount;
510         Approval(msg.sender, _spender, _amount);
511         return true;
512     }
513 
514    /**
515     *   @dev Function to check the amount of tokens that an owner allowed to a spender.
516     *
517     *   @param _owner        the address which owns the funds
518     *   @param _spender      the address which will spend the funds
519     *
520     *   @return              the amount of tokens still avaible for the spender
521     */
522     function allowance(address _owner, address _spender) constant returns (uint256) {
523         return allowed[_owner][_spender];
524     }
525 }
526 
527 
528 
529 
530 
531 contract tokenLUCG {
532     /* Public variables of the token */
533         string public name;
534         string public symbol;
535         uint8 public decimals;
536         uint256 public totalSupply = 0;
537 
538 
539         function tokenLUCG (string _name, string _symbol, uint8 _decimals){
540             name = _name;
541             symbol = _symbol;
542             decimals = _decimals;
543 
544         }
545     /* This creates an array with all balances */
546         mapping (address => uint256) public balanceOf;
547 
548 }
549 
550 contract Presale is tokenLUCG {
551 
552         using SafeMath for uint;
553         string name = 'Level Up Coin Gold';
554         string symbol = 'LUCG';
555         uint8 decimals = 18;
556         address manager;
557         address public ico;
558 
559         function Presale (address _manager) tokenLUCG (name, symbol, decimals){
560              manager = _manager;
561 
562         }
563 
564         event Transfer(address _from, address _to, uint256 amount);
565         event Burn(address _from, uint256 amount);
566 
567         modifier onlyManager{
568              require(msg.sender == manager);
569             _;
570         }
571 
572         modifier onlyIco{
573              require(msg.sender == ico);
574             _;
575         }
576         function mintTokens(address _investor, uint256 _mintedAmount) public onlyManager {
577              balanceOf[_investor] = balanceOf[_investor].add(_mintedAmount);
578              totalSupply = totalSupply.add(_mintedAmount);
579              Transfer(this, _investor, _mintedAmount);
580 
581         }
582 
583         function burnTokens(address _owner) public onlyIco{
584              uint  tokens = balanceOf[_owner];
585              require(balanceOf[_owner] != 0);
586              balanceOf[_owner] = 0;
587              totalSupply = totalSupply.sub(tokens);
588              Burn(_owner, tokens);
589         }
590 
591         function setIco(address _ico) onlyManager{
592             ico = _ico;
593         }
594 }