1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
7         uint256 c = a * b;
8         assert(a == 0 || c / a == b);
9         return c;
10     }
11 
12     function div(uint256 a, uint256 b) internal constant returns(uint256) {
13         // assert(b > 0); // Solidity automatically throws when dividing by 0
14         uint256 c = a / b;
15         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal constant returns(uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 
32 contract ERC20 {
33     uint256 public totalSupply;
34     function balanceOf(address who) constant returns(uint256);
35     function transfer(address to, uint256 value) returns(bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     function allowance(address owner, address spender) constant returns(uint256);
38     function transferFrom(address from, address to, uint256 value) returns(bool);
39     function approve(address spender, uint256 value) returns(bool);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 
42 }
43 
44 
45 contract BasicToken is ERC20 {
46     using SafeMath for uint256;
47 
48     mapping(address => uint256) balances;
49     mapping (address => mapping (address => uint256)) allowed;
50 
51     /**
52   * @dev transfer token for a specified address
53   * @param _to The address to transfer to.
54   * @param _value The amount to be transferred.
55   */
56 
57     function transfer(address _to, uint256 _value) returns (bool) {
58         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
59             balances[msg.sender] = balances[msg.sender].sub(_value);
60             balances[_to] = balances[_to].add(_value);
61             Transfer(msg.sender, _to, _value);
62             return true;
63         }else {
64             return false;
65         }
66     }
67     
68 
69 
70     /**
71    * @dev Transfer tokens from one address to another
72    * @param _from address The address which you want to send tokens from
73    * @param _to address The address which you want to transfer to
74    * @param _value uint256 the amout of tokens to be transfered
75    */
76 
77     function transferFrom(address _from, address _to, uint256 _value) returns(bool) {
78         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
79             uint256 _allowance = allowed[_from][msg.sender];
80             allowed[_from][msg.sender] = _allowance.sub(_value);
81             balances[_to] = balances[_to].add(_value);
82             balances[_from] = balances[_from].sub(_value);
83             Transfer(_from, _to, _value);
84             return true;
85         } else {
86             return false;
87         }
88     }
89 
90 
91     /**
92   * @dev Gets the balance of the specified address.
93   * @param _owner The address to query the the balance of. 
94   * @return An uint256 representing the amount owned by the passed address.
95   */
96 
97     function balanceOf(address _owner) constant returns(uint256 balance) {
98         return balances[_owner];
99     }
100 
101     function approve(address _spender, uint256 _value) returns(bool) {
102 
103         // To change the approve amount you first have to reduce the addresses`
104         //  allowance to zero by calling `approve(_spender, 0)` if it is not
105         //  already 0 to mitigate the race condition described here:
106         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
108 
109         allowed[msg.sender][_spender] = _value;
110         Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     /**
115      * @dev Function to check the amount of tokens that an owner allowed to a spender.
116      * @param _owner address The address which owns the funds.
117      * @param _spender address The address which will spend the funds.
118      * @return A uint256 specifing the amount of tokens still avaible for the spender.
119      */
120     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
121         return allowed[_owner][_spender];
122     }
123 
124 
125 }
126 
127 
128 contract NOLLYCOIN is BasicToken {
129 
130     using SafeMath for uint256;
131 
132     string public name = "Nolly Coin";                        //name of the token
133     string public symbol = "NOLLY";                                // symbol of the token
134     uint8 public decimals = 18;                                  // decimals
135     uint256 public totalSupply = 500000000 * 10 ** 18;             // total supply of NOLLY Tokens  
136 
137     // variables
138     uint256 public reservedForFounders;              // fund allocated to key founder 
139     uint256 public bountiesAllocation;                  // fund allocated for bounty
140     uint256 public affiliatesAllocation;                  // fund allocated to affiliates 
141     uint256 public totalAllocatedTokens;                // variable to keep track of funds allocated
142     uint256 public tokensAllocatedToCrowdFund;          // funds allocated to crowdfund
143 
144 
145 
146     // addresses
147     // multi sign address of founders which hold 
148     address public founderMultiSigAddress =    0x59b645EB51B1e47e45F14A56F271030182393Efd;
149     address public bountiesAllocAddress = 0x6C2625A8b19c7Bfa88d1420120DE45A60dCD6e28;  //CHANGE THIS
150     address public affiliatesAllocAddress = 0x0f0345699Afa5EE03d2B089A5aF73C405885B592;  //CHANGE THIS
151     address public crowdFundAddress;                    // address of crowdfund contract   
152     address public owner;                               // owner of the contract
153     
154     
155 
156 
157     //events
158     event ChangeFoundersWalletAddress(uint256  _blockTimeStamp, address indexed _foundersWalletAddress);
159 
160     //modifiers
161     modifier onlyCrowdFundAddress() {
162         require(msg.sender == crowdFundAddress);
163         _;
164     }
165 
166     modifier nonZeroAddress(address _to) {
167         require(_to != 0x0);
168         _;
169     }
170 
171     modifier onlyFounders() {
172         require(msg.sender == founderMultiSigAddress);
173         _;
174     }
175 
176 
177 
178     // creation of the token contract 
179     function NOLLYCOIN(address _crowdFundAddress) {
180         owner = msg.sender;
181         crowdFundAddress = _crowdFundAddress;
182 
183 
184         // Token Distribution         
185         reservedForFounders        = 97500000 * 10 ** 18;           // 97,500,000 [19.50%]
186         tokensAllocatedToCrowdFund = 300000000 * 10 ** 18;      // 300,000,000NOLLY [50%]
187         // tokensAllocatedToPreICO    = 50000000 * 10 ** 18;       // 50,000,000 [10%]
188         affiliatesAllocation =       25000000 * 10 ** 18;               // 25, 000, 000[5.0 %]
189         bountiesAllocation         = 27750000 * 10 ** 18;               // 27,750,000[5.5%] 
190                                                 
191 
192 
193         // Assigned balances to respective stakeholders
194         balances[founderMultiSigAddress] = reservedForFounders;
195         balances[affiliatesAllocAddress] = affiliatesAllocation;
196         balances[crowdFundAddress] = tokensAllocatedToCrowdFund;
197         balances[bountiesAllocAddress] = bountiesAllocation;
198         totalAllocatedTokens = balances[founderMultiSigAddress] + balances[affiliatesAllocAddress] + balances[bountiesAllocAddress];
199     }
200 
201 
202     // function to keep track of the total token allocation
203     function changeTotalSupply(uint256 _amount) onlyCrowdFundAddress {
204         totalAllocatedTokens += _amount;
205     }
206 
207     // function to change founder multisig wallet address            
208     function changeFounderMultiSigAddress(address _newFounderMultiSigAddress) onlyFounders nonZeroAddress(_newFounderMultiSigAddress) {
209         founderMultiSigAddress = _newFounderMultiSigAddress;
210         ChangeFoundersWalletAddress(now, founderMultiSigAddress);
211     }
212 
213 
214     // fallback function to restrict direct sending of ether
215     function () {
216         revert();
217     }
218 
219 }
220 
221 
222 
223 contract NOLLYCOINCrowdFund {
224 
225     using SafeMath for uint256;
226 
227     NOLLYCOIN public token;                                    // Token contract reference
228 
229     //variables
230     uint256 public preSaleStartTime = 1514874072; //1519898430;             // 01-MARCH-18 00:10:00 UTC //CHANGE THIS    
231     uint256 public preSaleEndTime = 1522490430;               // 31-MARCH-18 00:10:00 UTC           //CHANGE THIS
232     uint256 public crowdfundStartDate = 1522576830;           // 1-APRIL-18 00:10:00 UTC      //CHANGE THIS
233     uint256 public crowdfundEndDate = 1525155672;             // 31-MARCH-17 00:10:00 UTC      //CHANGE THIS
234     uint256 public totalWeiRaised;                            // Counter to track the amount raised //CHANGE THIS
235     uint256 public exchangeRateForETH = 32000;                  // No. of NOLLY Tokens in 1 ETH  // CHANGE THIS 
236     uint256 public exchangeRateForBTC = 60000;                 // No. of NOLLY Tokens in 1 BTC  //CHANGE THIS
237     uint256 internal tokenSoldInPresale = 0;
238     uint256 internal tokenSoldInCrowdsale = 0;
239     uint256 internal minAmount = 1 * 10 ** 17;                // Equivalent to 0.1 ETH
240 
241     bool internal isTokenDeployed = false;                    // Flag to track the token deployment -- only can be set once
242 
243 
244     // addresses
245     // Founders multisig address
246     address public founderMultiSigAddress = 0x59b645EB51B1e47e45F14A56F271030182393Efd;   //CHANGE THIS                          
247     // Owner of the contract
248     address public owner;
249 
250     enum State { PreSale, Crowdfund, Finish }
251 
252     //events
253     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
254     event CrowdFundClosed(uint256 _blockTimeStamp);
255     event ChangeFoundersWalletAddress(uint256 _blockTimeStamp, address indexed _foundersWalletAddress);
256 
257     //Modifiers
258     modifier tokenIsDeployed() {
259         require(isTokenDeployed == true);
260         _;
261     }
262     modifier nonZeroEth() {
263         require(msg.value > 0);
264         _;
265     }
266 
267     modifier nonZeroAddress(address _to) {
268         require(_to != 0x0);
269         _;
270     }
271 
272     modifier onlyFounders() {
273         require(msg.sender == founderMultiSigAddress);
274         _;
275     }
276 
277     modifier onlyOwner() {
278         require(msg.sender == owner);
279         _;
280     }
281 
282     modifier onlyPublic() {
283         require(msg.sender != founderMultiSigAddress);
284         _;
285     }
286 
287     modifier inState(State state) {
288         require(getState() == state);
289         _;
290     }
291 
292     // Constructor to initialize the local variables 
293     function NOLLYCOINCrowdFund() {
294         owner = msg.sender;
295     }
296 
297     // Function to change the founders multisig address 
298     function setFounderMultiSigAddress(address _newFounderAddress) onlyFounders  nonZeroAddress(_newFounderAddress) {
299         founderMultiSigAddress = _newFounderAddress;
300         ChangeFoundersWalletAddress(now, founderMultiSigAddress);
301     }
302 
303     // Attach the token contract, can only be done once     
304     function setTokenAddress(address _tokenAddress) external onlyOwner nonZeroAddress(_tokenAddress) {
305         require(isTokenDeployed == false);
306         token = NOLLYCOIN(_tokenAddress);
307         isTokenDeployed = true;
308     }
309 
310     // function call after crowdFundEndTime.
311     // It transfers the remaining tokens to remainingTokenHolder address
312     function endCrowdfund() onlyFounders inState(State.Finish) returns(bool) {
313         require(now > crowdfundEndDate);
314         uint256 remainingToken = token.balanceOf(this);  // remaining tokens
315 
316         if (remainingToken != 0)
317             token.transfer(founderMultiSigAddress, remainingToken);
318         CrowdFundClosed(now);
319         return true;
320     }
321 
322     // Buy token function call only in duration of crowdfund active 
323     function buyTokens(address beneficiary) 
324     nonZeroEth 
325     tokenIsDeployed 
326     onlyPublic 
327     nonZeroAddress(beneficiary) 
328     payable 
329     returns(bool) 
330     {
331         require(msg.value >= minAmount);
332 
333         if (getState() == State.PreSale) {
334             if (buyPreSaleTokens(beneficiary)) {
335                 return true;
336             }
337             return false;
338         } else {
339             require(now >= crowdfundStartDate && now <= crowdfundEndDate);
340             fundTransfer(msg.value);
341 
342             uint256 amount = getNoOfTokens(exchangeRateForETH, msg.value);
343 
344             if (token.transfer(beneficiary, amount)) {
345                 tokenSoldInCrowdsale = tokenSoldInCrowdsale.add(amount);
346                 token.changeTotalSupply(amount);
347                 totalWeiRaised = totalWeiRaised.add(msg.value);
348                 TokenPurchase(beneficiary, msg.value, amount);
349                 return true;
350             }
351             return false;
352         }
353 
354     }
355 
356     // function to buy the tokens at presale 
357     function buyPreSaleTokens(address beneficiary) internal returns(bool) {
358 
359         uint256 amount = getTokensForPreSale(exchangeRateForETH, msg.value);
360         fundTransfer(msg.value);
361 
362         if (token.transfer(beneficiary, amount)) {
363             tokenSoldInPresale = tokenSoldInPresale.add(amount);
364             token.changeTotalSupply(amount);
365             totalWeiRaised = totalWeiRaised.add(msg.value);
366             TokenPurchase(beneficiary, msg.value, amount);
367             return true;
368         }
369         return false;
370     }
371 
372     // function to calculate the total no of tokens with bonus multiplication
373     function getNoOfTokens(uint256 _exchangeRate, uint256 _amount) internal constant returns(uint256) {
374         uint256 noOfToken = _amount.mul(_exchangeRate);
375         uint256 noOfTokenWithBonus = ((100 + getCurrentBonusRate()) * noOfToken).div(100);
376         return noOfTokenWithBonus;
377     }
378 
379     function getTokensForPreSale(uint256 _exchangeRate, uint256 _amount) internal constant returns(uint256) {
380         uint256 noOfToken = _amount.mul(_exchangeRate);
381         uint256 noOfTokenWithBonus = ((100 + getCurrentBonusRate()) * noOfToken).div(100);
382         if (noOfTokenWithBonus + tokenSoldInPresale > (50000000 * 10 ** 18)) { //change this to reflect current max
383             revert();
384         }
385         return noOfTokenWithBonus;
386     }
387 
388     // function to transfer the funds to founders account
389     function fundTransfer(uint256 weiAmount) internal {
390         founderMultiSigAddress.transfer(weiAmount);
391     }
392 
393 
394     // Get functions 
395 
396     // function to get the current state of the crowdsale
397     function getState() public constant returns(State) {
398        if (now >= preSaleStartTime && now <= preSaleEndTime) {
399             return State.PreSale;
400         }
401         if (now >= crowdfundStartDate && now <= crowdfundEndDate) {
402             return State.Crowdfund;
403         } 
404         return State.Finish;
405     }
406 
407 
408     // function provide the current bonus rate
409     function getCurrentBonusRate() internal returns(uint8) {
410 
411         if (getState() == State.PreSale) {
412             return 30; //presale bonus rate is 33%
413         }
414         if (getState() == State.Crowdfund) {
415             
416 
417         //  week 1: 8th of April 1523197901
418             if (now > crowdfundStartDate && now <= 1523197901) { 
419                 return 25;
420             }
421 
422         //  week 2: 15th of April 1523802701
423             if (now > 1523197901 && now <= 1523802701) { 
424                 return 20;
425             }
426 
427 
428         // week 3: 
429             if (now > 1523802701 && now <= 1524565102 ) {
430                 return 15;
431 
432             } else {
433 
434                 return 10;
435 
436             }
437         }
438     }
439 
440 
441     // provides the bonus % 
442     function currentBonus() public constant returns(uint8) {
443         return getCurrentBonusRate();
444     }
445 
446     // GET functions
447     function getContractTimestamp() public constant returns(
448         uint256 _presaleStartDate,
449         uint256 _presaleEndDate,
450         uint256 _crowdsaleStartDate,
451         uint256 _crowdsaleEndDate)
452     {
453         return (preSaleStartTime, preSaleEndTime, crowdfundStartDate, crowdfundEndDate);
454     }
455 
456     function getExchangeRate() public constant returns(uint256 _exchangeRateForETH, uint256 _exchangeRateForBTC) {
457         return (exchangeRateForETH, exchangeRateForBTC);
458     }
459 
460     function getNoOfSoldToken() public constant returns(uint256 _tokenSoldInPresale, uint256 _tokenSoldInCrowdsale) {
461         return (tokenSoldInPresale, tokenSoldInCrowdsale);
462     }
463 
464     function getWeiRaised() public constant returns(uint256 _totalWeiRaised) {
465         return totalWeiRaised;
466     }
467 
468     // Crowdfund entry
469     // send ether to the contract address
470     // With at least 200 000 gas
471     function() public payable {
472         buyTokens(msg.sender);
473     }
474 }