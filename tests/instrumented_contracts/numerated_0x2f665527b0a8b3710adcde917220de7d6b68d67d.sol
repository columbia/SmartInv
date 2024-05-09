1 pragma solidity ^0.4.15;
2 
3 //import './lib/safeMath.sol';
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 // import './ERC20.sol';
35 contract ERC20 {
36   uint256 public totalSupply;
37   function transferFrom(address from, address to, uint256 value) returns (bool);
38   function transfer(address to, uint256 value) returns (bool);
39   function approve(address spender, uint256 value) returns (bool);
40   function allowance(address owner, address spender) constant returns (uint256);
41   function balanceOf(address who) constant returns (uint256);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 // import './helpers/BasicToken.sol';
47 contract BasicToken is ERC20 {
48     using SafeMath for uint256;
49 
50     mapping(address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;
52     
53 /**
54   * @dev transfer token for a specified address
55   * @param _to The address to transfer to.
56   * @param _value The amount to be transferred.
57   */
58     function transfer(address _to, uint256 _value) returns (bool) {
59         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
60             balances[msg.sender] = balances[msg.sender].sub(_value);
61             balances[_to] = balances[_to].add(_value);
62             Transfer(msg.sender, _to, _value);
63             return true;
64         }
65         return false;
66     }
67     
68 
69   /**
70    * @dev Transfer tokens from one address to another
71    * @param _from address The address which you want to send tokens from
72    * @param _to address The address which you want to transfer to
73    * @param _value uint256 the amout of tokens to be transfered
74    */
75     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
76       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
77         uint256 _allowance = allowed[_from][msg.sender];
78         allowed[_from][msg.sender] = _allowance.sub(_value);
79         balances[_to] = balances[_to].add(_value);
80         balances[_from] = balances[_from].sub(_value);
81         Transfer(_from, _to, _value);
82         return true;
83       }
84       return false;
85 }
86 
87 
88   /**
89   * @dev Gets the balance of the specified address.
90   * @param _owner The address to query the the balance of. 
91   * @return An uint256 representing the amount owned by the passed address.
92   */
93     function balanceOf(address _owner) constant returns (uint256 balance) {
94     return balances[_owner];
95   }
96 
97   function approve(address _spender, uint256 _value) returns (bool) {
98 
99     // To change the approve amount you first have to reduce the addresses`
100     //  allowance to zero by calling `approve(_spender, 0)` if it is not
101     //  already 0 to mitigate the race condition described here:
102     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
103     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
104 
105     allowed[msg.sender][_spender] = _value;
106     Approval(msg.sender, _spender, _value);
107     return true;
108   }
109 
110   /**
111    * @dev Function to check the amount of tokens that an owner allowed to a spender.
112    * @param _owner address The address which owns the funds.
113    * @param _spender address The address which will spend the funds.
114    * @return A uint256 specifing the amount of tokens still avaible for the spender.
115    */
116   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
117     return allowed[_owner][_spender];
118   }
119 
120 
121 }
122 
123 // import './BiQToken.sol';
124 contract BiQToken is BasicToken {
125 
126   using SafeMath for uint256;
127 
128   string public name = "BurstIQ Token";              //name of the token
129   string public symbol = "BiQ";                      // symbol of the token
130   uint8 public decimals = 18;                        // decimals
131   uint256 public totalSupply = 1000000000 * 10**18;  // total supply of BiQ Tokens
132 
133   // variables
134   uint256 public keyEmployeesAllocatedFund;           // fund allocated to key employees
135   uint256 public advisorsAllocation;                  // fund allocated to advisors
136   uint256 public marketIncentivesAllocation;          // fund allocated to Market
137   uint256 public vestingFounderAllocation;            // funds allocated to founders that in under vesting period
138   uint256 public totalAllocatedTokens;                // variable to keep track of funds allocated
139   uint256 public tokensAllocatedToCrowdFund;          // funds allocated to crowdfund
140   uint256 public saftInvestorAllocation;              // funds allocated to private presales and instituational investors
141 
142   bool public isPublicTokenReleased = false;          // flag to track the release the public token
143 
144   // addresses
145 
146   address public founderMultiSigAddress;              // multi sign address of founders which hold
147   address public advisorAddress;                      //  advisor address which hold advisorsAllocation funds
148   address public vestingFounderAddress;               // address of founder that hold vestingFounderAllocation
149   address public crowdFundAddress;                    // address of crowdfund contract
150 
151   // vesting period
152 
153   uint256 public preAllocatedTokensVestingTime;       // crowdfund start time + 6 months
154 
155   //events
156 
157   event ChangeFoundersWalletAddress(uint256  _blockTimeStamp, address indexed _foundersWalletAddress);
158   event TransferPreAllocatedFunds(uint256  _blockTimeStamp , address _to , uint256 _value);
159   event PublicTokenReleased(uint256 _blockTimeStamp);
160 
161   //modifiers
162 
163   modifier onlyCrowdFundAddress() {
164     require(msg.sender == crowdFundAddress);
165     _;
166   }
167 
168   modifier nonZeroAddress(address _to) {
169     require(_to != 0x0);
170     _;
171   }
172 
173   modifier onlyFounders() {
174     require(msg.sender == founderMultiSigAddress);
175     _;
176   }
177 
178   modifier onlyVestingFounderAddress() {
179     require(msg.sender == vestingFounderAddress);
180     _;
181   }
182 
183   modifier onlyAdvisorAddress() {
184     require(msg.sender == advisorAddress);
185     _;
186   }
187 
188   modifier isPublicTokenNotReleased() {
189     require(isPublicTokenReleased == false);
190     _;
191   }
192 
193 
194   // creation of the token contract
195   function BiQToken (address _crowdFundAddress, address _founderMultiSigAddress, address _advisorAddress, address _vestingFounderAddress) {
196     crowdFundAddress = _crowdFundAddress;
197     founderMultiSigAddress = _founderMultiSigAddress;
198     vestingFounderAddress = _vestingFounderAddress;
199     advisorAddress = _advisorAddress;
200 
201     // Token Distribution
202     vestingFounderAllocation = 18 * 10 ** 25 ;        // 18 % allocation of totalSupply
203     keyEmployeesAllocatedFund = 2 * 10 ** 25 ;        // 2 % allocation of totalSupply
204     advisorsAllocation = 5 * 10 ** 25 ;               // 5 % allocation of totalSupply
205     tokensAllocatedToCrowdFund = 60 * 10 ** 25 ;      // 60 % allocation of totalSupply
206     marketIncentivesAllocation = 5 * 10 ** 25 ;       // 5 % allocation of totalSupply
207     saftInvestorAllocation = 10 * 10 ** 25 ;          // 10 % alloaction of totalSupply
208 
209     // Assigned balances to respective stakeholders
210     balances[founderMultiSigAddress] = keyEmployeesAllocatedFund + saftInvestorAllocation;
211     balances[crowdFundAddress] = tokensAllocatedToCrowdFund;
212 
213     totalAllocatedTokens = balances[founderMultiSigAddress];
214     preAllocatedTokensVestingTime = now + 180 * 1 days;                // it should be 6 months period for vesting
215   }
216 
217   // function to keep track of the total token allocation
218   function changeTotalSupply(uint256 _amount) onlyCrowdFundAddress {
219     totalAllocatedTokens = totalAllocatedTokens.add(_amount);
220     tokensAllocatedToCrowdFund = tokensAllocatedToCrowdFund.sub(_amount);
221   }
222 
223   // function to change founder multisig wallet address
224   function changeFounderMultiSigAddress(address _newFounderMultiSigAddress) onlyFounders nonZeroAddress(_newFounderMultiSigAddress) {
225     founderMultiSigAddress = _newFounderMultiSigAddress;
226     ChangeFoundersWalletAddress(now, founderMultiSigAddress);
227   }
228 
229   // function for releasing the public tokens called once by the founder only
230   function releaseToken() onlyFounders isPublicTokenNotReleased {
231     isPublicTokenReleased = !isPublicTokenReleased;
232     PublicTokenReleased(now);
233   }
234 
235   // function to transfer market Incentives fund
236   function transferMarketIncentivesFund(address _to, uint _value) onlyFounders nonZeroAddress(_to)  returns (bool) {
237     if (marketIncentivesAllocation >= _value) {
238       marketIncentivesAllocation = marketIncentivesAllocation.sub(_value);
239       balances[_to] = balances[_to].add(_value);
240       totalAllocatedTokens = totalAllocatedTokens.add(_value);
241       TransferPreAllocatedFunds(now, _to, _value);
242       return true;
243     }
244     return false;
245   }
246 
247 
248   // fund transferred to vesting Founders address after 6 months
249   function getVestedFounderTokens() onlyVestingFounderAddress returns (bool) {
250     if (now >= preAllocatedTokensVestingTime && vestingFounderAllocation > 0) {
251       balances[vestingFounderAddress] = balances[vestingFounderAddress].add(vestingFounderAllocation);
252       totalAllocatedTokens = totalAllocatedTokens.add(vestingFounderAllocation);
253       vestingFounderAllocation = 0;
254       TransferPreAllocatedFunds(now, vestingFounderAddress, vestingFounderAllocation);
255       return true;
256     }
257     return false;
258   }
259 
260   // fund transferred to vesting advisor address after 6 months
261   function getVestedAdvisorTokens() onlyAdvisorAddress returns (bool) {
262     if (now >= preAllocatedTokensVestingTime && advisorsAllocation > 0) {
263       balances[advisorAddress] = balances[advisorAddress].add(advisorsAllocation);
264       totalAllocatedTokens = totalAllocatedTokens.add(advisorsAllocation);
265       advisorsAllocation = 0;
266       TransferPreAllocatedFunds(now, advisorAddress, advisorsAllocation);
267       return true;
268     } else {
269       return false;
270     }
271   }
272 
273   // overloaded transfer function to restrict the investor to transfer the token before the ICO sale ends
274   function transfer(address _to, uint256 _value) returns (bool) {
275     if (msg.sender == crowdFundAddress) {
276       return super.transfer(_to,_value);
277     } else {
278       if (isPublicTokenReleased) {
279         return super.transfer(_to,_value);
280       }
281       return false;
282     }
283   }
284 
285   // overloaded transferFrom function to restrict the investor to transfer the token before the ICO sale ends
286   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
287     if (msg.sender == crowdFundAddress) {
288       return super.transferFrom(_from, _to, _value);
289     } else {
290       if (isPublicTokenReleased) {
291         return super.transferFrom(_from, _to, _value);
292       }
293       return false;
294     }
295   }
296 
297   // fallback function to restrict direct sending of ether
298   function () {
299     revert();
300   }
301 
302 }
303 
304 contract BiQCrowdFund {
305 
306     using SafeMath for uint256;
307 
308     BiQToken public token;                                 // Token contract reference
309 
310     //variables
311     uint256 public crowdfundStartTime;                     // Starting time of CrowdFund
312     uint256 public crowdfundEndTime;                       // End time of Crowdfund
313     uint256 public totalWeiRaised = 0;                     // Counter to track the amount raised
314     uint256 public exchangeRate = 2307;                    // Calculated using priceOfEtherInUSD/priceOfBiQToken so 276.84/0.12
315     uint256 internal minAmount = 36.1219 * 10 ** 18;       // Calculated using 10k USD / 276.84 USD
316 
317     bool public isCrowdFundActive = false;                 // Flag to track the crowdfund active or not
318     bool internal isTokenDeployed = false;                 // Flag to track the token deployment -- only can be set once
319     bool internal hasCrowdFundStarted = false;             // Flag to track if the crowdfund started
320 
321     // addresses
322     address public founderMultiSigAddress;                 // Founders multisig address
323     address public remainingTokenHolder;                   // Address to hold the remaining tokens after crowdfund end
324     address public authorizerAddress;                      // Address of Authorizer who will authorize the investor
325 
326     // mapping
327     mapping (address => uint256) auth;                     // KYC authentication
328 
329     enum State { PreSale, CrowdFund }
330 
331     //events
332     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
333     event CrowdFundClosed(uint256 _blockTimeStamp);
334     event ChangeFoundersWalletAddress(uint256 _blockTimeStamp, address indexed _foundersWalletAddress);
335 
336     //Modifiers
337     modifier tokenIsDeployed() {
338         require(isTokenDeployed == true);
339         _;
340     }
341      modifier nonZeroEth() {
342         require(msg.value > 0);
343         _;
344     }
345 
346     modifier nonZeroAddress(address _to) {
347         require(_to != 0x0);
348         _;
349     }
350 
351     modifier checkCrowdFundActive() {
352         require(isCrowdFundActive == true);
353         _;
354     }
355 
356     modifier onlyFounders() {
357         require(msg.sender == founderMultiSigAddress);
358         _;
359     }
360 
361     modifier onlyPublic() {
362         require(msg.sender != founderMultiSigAddress);
363         _;
364     }
365 
366     modifier onlyAuthorizer() {
367         require(msg.sender == authorizerAddress);
368         _;
369     }
370 
371 
372     modifier inState(State state) {
373         require(getState() == state);
374         _;
375     }
376 
377     // Constructor to initialize the local variables
378     function BiQCrowdFund (address _founderWalletAddress, address _remainingTokenHolder, address _authorizerAddress) {
379         founderMultiSigAddress = _founderWalletAddress;
380         remainingTokenHolder = _remainingTokenHolder;
381         authorizerAddress = _authorizerAddress;
382     }
383 
384     // Function to change the founders multisig address
385     function setFounderMultiSigAddress(address _newFounderAddress) onlyFounders nonZeroAddress(_newFounderAddress) {
386         founderMultiSigAddress = _newFounderAddress;
387         ChangeFoundersWalletAddress(now, founderMultiSigAddress);
388     }
389 
390      function setAuthorizerAddress(address _newAuthorizerAddress) onlyFounders nonZeroAddress(_newAuthorizerAddress) {
391         authorizerAddress = _newAuthorizerAddress;
392     }
393 
394      function setRemainingTokenHolder(address _newRemainingTokenHolder) onlyFounders nonZeroAddress(_newRemainingTokenHolder) {
395         remainingTokenHolder = _newRemainingTokenHolder;
396     }
397 
398     // Attach the token contract, can only be done once
399     function setTokenAddress(address _tokenAddress) onlyFounders nonZeroAddress(_tokenAddress) {
400         require(isTokenDeployed == false);
401         token = BiQToken(_tokenAddress);
402         isTokenDeployed = true;
403     }
404 
405     // change the state of crowdfund
406     function changeCrowdfundState() tokenIsDeployed onlyFounders inState(State.CrowdFund) {
407         isCrowdFundActive = !isCrowdFundActive;
408     }
409 
410     // for KYC/AML
411     function authorize(address _to, uint256 max_amount) onlyAuthorizer {
412         auth[_to] = max_amount * 1 ether;
413     }
414 
415     // Buy token function call only in duration of crowdfund active
416     function buyTokens(address beneficiary) nonZeroEth tokenIsDeployed onlyPublic nonZeroAddress(beneficiary) payable returns(bool) {
417         // Only allow a certain amount for every investor
418         if (auth[beneficiary] < msg.value) {
419             revert();
420         }
421         auth[beneficiary] = auth[beneficiary].sub(msg.value);
422 
423         if (getState() == State.PreSale) {
424             if (buyPreSaleTokens(beneficiary)) {
425                 return true;
426             }
427             revert();
428         } else {
429             require(now < crowdfundEndTime && isCrowdFundActive);
430             fundTransfer(msg.value);
431 
432             uint256 amount = getNoOfTokens(exchangeRate, msg.value);
433 
434             if (token.transfer(beneficiary, amount)) {
435                 token.changeTotalSupply(amount);
436                 totalWeiRaised = totalWeiRaised.add(msg.value);
437                 TokenPurchase(beneficiary, msg.value, amount);
438                 return true;
439             }
440             revert();
441         }
442 
443     }
444 
445     // function to transfer the funds to founders account
446     function fundTransfer(uint256 weiAmount) internal {
447         founderMultiSigAddress.transfer(weiAmount);
448     }
449 
450     ///////////////////////////////////// Constant Functions /////////////////////////////////////
451 
452     // function to get the current state of the crowdsale
453    function getState() public constant returns(State) {
454         if (!isCrowdFundActive && !hasCrowdFundStarted) {
455             return State.PreSale;
456         }
457         return State.CrowdFund;
458    }
459 
460     // To get the authorized amount corresponding to an address
461    function getPreAuthorizedAmount(address _address) constant returns(uint256) {
462         return auth[_address];
463    }
464 
465    // get the amount of tokens a user would receive for a specific amount of ether
466    function calculateTotalTokenPerContribution(uint256 _totalETHContribution) public constant returns(uint256) {
467        if (getState() == State.PreSale) {
468            return getTokensForPreSale(exchangeRate, _totalETHContribution * 1 ether).div(10 ** 18);
469        }
470        return getNoOfTokens(exchangeRate, _totalETHContribution);
471    }
472 
473     // provides the bonus %
474     function currentBonus(uint256 _ethContribution) public constant returns (uint8) {
475         if (getState() == State.PreSale) {
476             return getPreSaleBonusRate(_ethContribution * 1 ether);
477         }
478         return getCurrentBonusRate();
479     }
480 
481 
482 ///////////////////////////////////// Presale Functions /////////////////////////////////////
483     // function to buy the tokens at presale with minimum investment = 10k USD
484     function buyPreSaleTokens(address beneficiary) internal returns(bool) {
485        // check the minimum investment should be 10k USD
486         if (msg.value < minAmount) {
487           revert();
488         } else {
489             fundTransfer(msg.value);
490             uint256 amount = getTokensForPreSale(exchangeRate, msg.value);
491 
492             if (token.transfer(beneficiary, amount)) {
493                 token.changeTotalSupply(amount);
494                 totalWeiRaised = totalWeiRaised.add(msg.value);
495                 TokenPurchase(beneficiary, msg.value, amount);
496                 return true;
497             }
498             return false;
499         }
500     }
501 
502     // function calculate the total no of tokens with bonus multiplication in the duration of presale
503     function getTokensForPreSale(uint256 _exchangeRate, uint256 _amount) internal returns (uint256) {
504         uint256 noOfToken = _amount.mul(_exchangeRate);
505         uint256 preSaleTokenQuantity = ((100 + getPreSaleBonusRate(_amount)) * noOfToken ).div(100);
506         return preSaleTokenQuantity;
507     }
508 
509     function getPreSaleBonusRate(uint256 _ethAmount) internal returns (uint8) {
510         if ( _ethAmount >= minAmount.mul(5) && _ethAmount < minAmount.mul(10)) {
511             return 30;
512         }
513         if (_ethAmount >= minAmount.mul(10)) {
514             return 35;
515         }
516         if (_ethAmount >= minAmount) {
517             return 25;
518         }
519     }
520 ///////////////////////////////////// Crowdfund Functions /////////////////////////////////////
521 
522     // Starts the crowdfund, can only be called once
523     function startCrowdfund(uint256 _exchangeRate) onlyFounders tokenIsDeployed inState(State.PreSale) {
524         if (_exchangeRate > 0 && !hasCrowdFundStarted) {
525             exchangeRate = _exchangeRate;
526             crowdfundStartTime = now;
527             crowdfundEndTime = crowdfundStartTime + 5 * 1 weeks; // end date is 5 weeks after the starting date
528             isCrowdFundActive = !isCrowdFundActive;
529             hasCrowdFundStarted = !hasCrowdFundStarted;
530         } else {
531             revert();
532         }
533     }
534 
535     // function call after crowdFundEndTime.
536     // It transfers the remaining tokens to remainingTokenHolder address
537     function endCrowdfund() onlyFounders returns (bool) {
538         require(now > crowdfundEndTime);
539         uint256 remainingToken = token.balanceOf(this);  // remaining tokens
540 
541         if (remainingToken != 0 && token.transfer(remainingTokenHolder, remainingToken)) {
542           return true;
543         } else {
544             return false;
545         }
546         CrowdFundClosed(now);
547     }
548 
549    // function to calculate the total no of tokens with bonus multiplication
550     function getNoOfTokens(uint256 _exchangeRate, uint256 _amount) internal returns (uint256) {
551          uint256 noOfToken = _amount.mul(_exchangeRate);
552          uint256 noOfTokenWithBonus = ((100 + getCurrentBonusRate()) * noOfToken).div(100);
553          return noOfTokenWithBonus;
554     }
555 
556     // function provide the current bonus rate
557     function getCurrentBonusRate() internal returns (uint8) {
558         if (now > crowdfundStartTime + 4 weeks) {
559             return 0;
560         }
561         if (now > crowdfundStartTime + 3 weeks) {
562             return 5;
563         }
564         if (now > crowdfundStartTime + 2 weeks) {
565             return 10;
566         }
567         if (now > crowdfundStartTime + 1 weeks) {
568             return 15;
569         }
570         if (now > crowdfundStartTime) {
571             return 20;
572         }
573     }
574 
575     // Crowdfund entry
576     // send ether to the contract address
577     // With at least 200 000 gas
578     function() public payable {
579         buyTokens(msg.sender);
580     }
581 }