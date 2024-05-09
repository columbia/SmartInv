1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract ERC20 {
32   uint256 public totalSupply;
33   function balanceOf(address who) constant returns (uint256);
34   function transfer(address to, uint256 value) returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36   function allowance(address owner, address spender) constant returns (uint256);
37   function transferFrom(address from, address to, uint256 value) returns (bool);
38   function approve(address spender, uint256 value) returns (bool);
39   event Approval(address indexed owner, address indexed spender, uint256 value);
40     
41 }
42 
43 
44 contract BasicToken is ERC20 {
45     using SafeMath for uint256;
46 
47     mapping(address => uint256) balances;
48     mapping (address => mapping (address => uint256)) allowed;
49 
50     /**
51   * @dev transfer token for a specified address
52   * @param _to The address to transfer to.
53   * @param _value The amount to be transferred.
54   */
55 
56     function transfer(address _to, uint256 _value) returns (bool) {
57         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
58             balances[msg.sender] = balances[msg.sender].sub(_value);
59             balances[_to] = balances[_to].add(_value);
60             Transfer(msg.sender, _to, _value);
61             return true;
62         }else {
63             return false;
64         }
65     }
66     
67 
68     /**
69    * @dev Transfer tokens from one address to another
70    * @param _from address The address which you want to send tokens from
71    * @param _to address The address which you want to transfer to
72    * @param _value uint256 the amout of tokens to be transfered
73    */
74 
75     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
76       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
77         uint256 _allowance = allowed[_from][msg.sender];
78         allowed[_from][msg.sender] = _allowance.sub(_value);
79         balances[_to] = balances[_to].add(_value);
80         balances[_from] = balances[_from].sub(_value);
81         Transfer(_from, _to, _value);
82         return true;
83       } else {
84         return false;
85       }
86 }
87 
88 
89     /**
90   * @dev Gets the balance of the specified address.
91   * @param _owner The address to query the the balance of. 
92   * @return An uint256 representing the amount owned by the passed address.
93   */
94 
95     function balanceOf(address _owner) constant returns (uint256 balance) {
96     return balances[_owner];
97   }
98 
99   function approve(address _spender, uint256 _value) returns (bool) {
100 
101     // To change the approve amount you first have to reduce the addresses`
102     //  allowance to zero by calling `approve(_spender, 0)` if it is not
103     //  already 0 to mitigate the race condition described here:
104     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
105     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
106 
107     allowed[msg.sender][_spender] = _value;
108     Approval(msg.sender, _spender, _value);
109     return true;
110   }
111 
112   /**
113    * @dev Function to check the amount of tokens that an owner allowed to a spender.
114    * @param _owner address The address which owns the funds.
115    * @param _spender address The address which will spend the funds.
116    * @return A uint256 specifing the amount of tokens still avaible for the spender.
117    */
118   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
119     return allowed[_owner][_spender];
120   }
121 
122 
123 }
124 
125 
126 contract SPCToken is BasicToken {
127 
128 using SafeMath for uint256;
129 
130 string public name = "SecurityPlusCloud Token";              //name of the token
131 string public symbol = "SPC";                                // symbol of the token
132 uint8 public decimals = 18;                                  // decimals
133 uint256 public totalSupply = 500000000 * 10**18;             // total supply of SPC Tokens  
134 
135 // variables
136 uint256 public keyEmployeesAllocation;              // fund allocated to key employees 
137 uint256 public bountiesAllocation;                  // fund allocated to advisors 
138 uint256 public longTermBudgetAllocation;            // fund allocated to Market 
139 uint256 public bonusAllocation;                     // funds allocated to founders that in under vesting period
140 uint256 public totalAllocatedTokens;                // variable to keep track of funds allocated
141 uint256 public tokensAllocatedToCrowdFund;          // funds allocated to crowdfund
142 
143 // addresses
144 // multi sign address of founders which hold 
145 address public founderMultiSigAddress = 0x70b0ea058aee845342B09f1769a2bE8deB46aA86;     
146 address public crowdFundAddress;                    // address of crowdfund contract
147 address public owner;                               // owner of the contract
148 // bonus funds get allocated to below address
149 address public bonusAllocAddress = 0x95817119B58D195C10a935De6fA4141c2647Aa56;
150 // Address to allocate the bounties
151 address public bountiesAllocAddress = 0x6272A7521c60dE62aBc048f7B40F61f775B32d78;
152 // Address to allocate the LTB
153 address public longTermbudgetAllocAddress = 0x00a6858fe26c326c664a6B6499e47D72e98402Bb;
154 
155 //events
156 
157 event ChangeFoundersWalletAddress(uint256  _blockTimeStamp, address indexed _foundersWalletAddress);
158 
159 //modifiers
160 
161   modifier onlyCrowdFundAddress() {
162     require(msg.sender == crowdFundAddress);
163     _;
164   }
165 
166   modifier nonZeroAddress(address _to) {
167     require(_to != 0x0);
168     _;
169   }
170 
171   modifier onlyFounders() {
172     require(msg.sender == founderMultiSigAddress);
173     _;
174   }
175 
176 
177   
178    // creation of the token contract 
179    function SPCToken (address _crowdFundAddress) {
180     owner = msg.sender;
181     crowdFundAddress = _crowdFundAddress;
182 
183     // Token Distribution 
184     keyEmployeesAllocation = 50 * 10 ** 24;           // 10 % allocation of totalSupply 
185     bountiesAllocation = 35 * 10 ** 24;               // 7 % allocation of totalSupply 
186     tokensAllocatedToCrowdFund = 25 * 10 ** 25;       // 50 % allocation of totalSupply
187     longTermBudgetAllocation = 10 * 10 ** 25;         // 20 % allocation of totalSupply
188     bonusAllocation = 65 * 10 ** 24;                  // 13 % allocation of totalSupply
189 
190     // Assigned balances to respective stakeholders
191     balances[founderMultiSigAddress] = keyEmployeesAllocation;
192     balances[crowdFundAddress] = tokensAllocatedToCrowdFund;
193     balances[bonusAllocAddress] = bonusAllocation;
194     balances[bountiesAllocAddress] = bountiesAllocation;
195     balances[longTermbudgetAllocAddress] = longTermBudgetAllocation;
196 
197     totalAllocatedTokens = balances[founderMultiSigAddress] + balances[bonusAllocAddress] + balances[bountiesAllocAddress] + balances[longTermbudgetAllocAddress];
198   }
199 
200 // function to keep track of the total token allocation
201   function changeTotalSupply(uint256 _amount) onlyCrowdFundAddress {
202     totalAllocatedTokens += _amount;
203   }
204 
205 // function to change founder multisig wallet address            
206   function changeFounderMultiSigAddress(address _newFounderMultiSigAddress) onlyFounders nonZeroAddress(_newFounderMultiSigAddress) {
207     founderMultiSigAddress = _newFounderMultiSigAddress;
208     ChangeFoundersWalletAddress(now, founderMultiSigAddress);
209   }
210 
211 
212 // fallback function to restrict direct sending of ether
213   function () {
214     revert();
215   }
216 
217 }
218 
219 
220 
221 contract SPCCrowdFund {
222 
223     using SafeMath for uint256;
224     
225     SPCToken public token;                                    // Token contract reference
226 
227     //variables
228     uint256 public preSaleStartTime = 1509494401;             // Wednesday, 01-Nov-17 00:00:01 UTC     
229     uint256 public preSaleEndTime = 1510531199;               // Sunday, 12-Nov-17 23:59:59 UTC           
230     uint256 public crowdfundStartDate = 1511308801;           // Wednesday, 22-Nov-17 00:00:01 UTC
231     uint256 public crowdfundEndDate = 1515283199;             // Saturday, 06-Jan-18 23:59:59 UTC
232     uint256 public totalWeiRaised;                            // Counter to track the amount raised
233     uint256 public exchangeRateForETH = 300;                  // No. of SOC Tokens in 1 ETH
234     uint256 public exchangeRateForBTC = 4500;                 // No. of SPC Tokens in 1 BTC  
235     uint256 internal tokenSoldInPresale = 0;
236     uint256 internal tokenSoldInCrowdsale = 0;
237     uint256 internal minAmount = 1 * 10 ** 17;                // Equivalent to 0.1 ETH
238 
239     bool internal isTokenDeployed = false;                    // Flag to track the token deployment -- only can be set once
240  
241 
242      // addresses
243     // Founders multisig address
244     address public founderMultiSigAddress = 0xF50aCE12e0537111be782899Fd5c4f5f638340d5;                            
245     // Owner of the contract
246     address public owner;                                              
247     
248     enum State { PreSale, Crowdfund, Finish }
249 
250     //events
251     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount); 
252     event CrowdFundClosed(uint256 _blockTimeStamp);
253     event ChangeFoundersWalletAddress(uint256 _blockTimeStamp, address indexed _foundersWalletAddress);
254    
255     //Modifiers
256     modifier tokenIsDeployed() {
257         require(isTokenDeployed == true);
258         _;
259     }
260     modifier nonZeroEth() {
261         require(msg.value > 0);
262         _;
263     }
264 
265     modifier nonZeroAddress(address _to) {
266         require(_to != 0x0);
267         _;
268     }
269 
270     modifier onlyFounders() {
271         require(msg.sender == founderMultiSigAddress);
272         _;
273     }
274 
275     modifier onlyOwner() {
276         require(msg.sender == owner);
277         _;
278     }
279 
280     modifier onlyPublic() {
281         require(msg.sender != founderMultiSigAddress);
282         _;
283     }
284 
285     modifier inState(State state) {
286         require(getState() == state); 
287         _;
288     }
289 
290      // Constructor to initialize the local variables 
291     function SPCCrowdFund () {
292         owner = msg.sender;
293     }
294 
295     // Function to change the founders multisig address 
296      function setFounderMultiSigAddress(address _newFounderAddress) onlyFounders  nonZeroAddress(_newFounderAddress) {
297         founderMultiSigAddress = _newFounderAddress;
298         ChangeFoundersWalletAddress(now, founderMultiSigAddress);
299     }
300 
301     // Attach the token contract, can only be done once     
302     function setTokenAddress(address _tokenAddress) external onlyOwner nonZeroAddress(_tokenAddress) {
303         require(isTokenDeployed == false);
304         token = SPCToken(_tokenAddress);
305         isTokenDeployed = true;
306     }
307 
308     // function call after crowdFundEndTime.
309     // It transfers the remaining tokens to remainingTokenHolder address
310     function endCrowdfund() onlyFounders inState(State.Finish) returns (bool) {
311         require(now > crowdfundEndDate);
312         uint256 remainingToken = token.balanceOf(this);  // remaining tokens
313 
314         if (remainingToken != 0) 
315           token.transfer(founderMultiSigAddress, remainingToken); 
316         CrowdFundClosed(now);
317         return true; 
318     }
319 
320     // Buy token function call only in duration of crowdfund active 
321     function buyTokens(address beneficiary) 
322     nonZeroEth 
323     tokenIsDeployed 
324     onlyPublic 
325     nonZeroAddress(beneficiary) 
326     payable 
327     returns(bool) 
328     {
329         require(msg.value >= minAmount);
330 
331         if (getState() == State.PreSale) {
332             if (buyPreSaleTokens(beneficiary)) {
333                 return true;
334             }
335             return false;
336         } else {
337             require(now >= crowdfundStartDate && now <= crowdfundEndDate);
338             fundTransfer(msg.value);
339 
340             uint256 amount = getNoOfTokens(exchangeRateForETH, msg.value);
341             
342             if (token.transfer(beneficiary, amount)) {
343                 tokenSoldInCrowdsale = tokenSoldInCrowdsale.add(amount);
344                 token.changeTotalSupply(amount); 
345                 totalWeiRaised = totalWeiRaised.add(msg.value);
346                 TokenPurchase(beneficiary, msg.value, amount);
347                 return true;
348             } 
349             return false;
350         }
351        
352     }
353         
354     // function to buy the tokens at presale 
355     function buyPreSaleTokens(address beneficiary) internal returns(bool) {
356             
357             uint256 amount = getTokensForPreSale(exchangeRateForETH, msg.value);
358             fundTransfer(msg.value);
359 
360             if (token.transfer(beneficiary, amount)) {
361                 tokenSoldInPresale = tokenSoldInPresale.add(amount);
362                 token.changeTotalSupply(amount); 
363                 totalWeiRaised = totalWeiRaised.add(msg.value);
364                 TokenPurchase(beneficiary, msg.value, amount);
365                 return true;
366             }
367             return false;
368     }    
369 
370 // function to calculate the total no of tokens with bonus multiplication
371     function getNoOfTokens(uint256 _exchangeRate, uint256 _amount) internal constant returns (uint256) {
372          uint256 noOfToken = _amount.mul(_exchangeRate);
373          uint256 noOfTokenWithBonus = ((100 + getCurrentBonusRate()) * noOfToken ).div(100);
374          return noOfTokenWithBonus;
375     }
376 
377     function getTokensForPreSale(uint256 _exchangeRate, uint256 _amount) internal constant returns (uint256) {
378         uint256 noOfToken = _amount.mul(_exchangeRate);
379         uint256 noOfTokenWithBonus = ((100 + getCurrentBonusRate()) * noOfToken ).div(100);
380         if (noOfTokenWithBonus + tokenSoldInPresale > (50000000 * 10 ** 18) ) {
381             revert();
382         }
383         return noOfTokenWithBonus;
384     }
385 
386     // function to transfer the funds to founders account
387     function fundTransfer(uint256 weiAmount) internal {
388         founderMultiSigAddress.transfer(weiAmount);
389     }
390 
391 
392 // Get functions 
393 
394     // function to get the current state of the crowdsale
395     function getState() public constant returns(State) {
396         if (now >= preSaleStartTime && now <= preSaleEndTime) {
397             return State.PreSale;
398         }
399         if (now >= crowdfundStartDate && now <= crowdfundEndDate) {
400             return State.Crowdfund;
401         } 
402         return State.Finish;
403     }
404 
405 
406     // function provide the current bonus rate
407     function getCurrentBonusRate() internal returns (uint8) {
408         
409         if (getState() == State.PreSale) {
410            return 50;
411         } 
412         if (getState() == State.Crowdfund) {
413            if (tokenSoldInCrowdsale <= (100000000 * 10 ** 18) ) {
414                return 30;
415            }
416            if (tokenSoldInCrowdsale > (100000000 * 10 ** 18) && tokenSoldInCrowdsale <= (175000000 * 10 ** 18)) {
417                return 10;
418            } else {
419                return 0;
420            }
421         }
422     }
423 
424 
425     // provides the bonus % 
426     function currentBonus() public constant returns (uint8) {
427         return getCurrentBonusRate();
428     }
429 
430     // GET functions
431 
432     function getContractTimestamp() public constant returns ( 
433         uint256 _presaleStartDate, 
434         uint256 _presaleEndDate, 
435         uint256 _crowdsaleStartDate, 
436         uint256 _crowdsaleEndDate) 
437     {
438         return (preSaleStartTime, preSaleEndTime, crowdfundStartDate, crowdfundEndDate);
439     }
440 
441     function getExchangeRate() public constant returns (uint256 _exchangeRateForETH, uint256 _exchangeRateForBTC) {
442         return (exchangeRateForETH, exchangeRateForBTC);
443     }
444 
445     function getNoOfSoldToken() public constant returns (uint256 _tokenSoldInPresale , uint256 _tokenSoldInCrowdsale) {
446         return (tokenSoldInPresale, tokenSoldInCrowdsale);
447     }
448 
449     function getWeiRaised() public constant returns (uint256 _totalWeiRaised) {
450         return totalWeiRaised;
451     }
452 
453     // Crowdfund entry
454     // send ether to the contract address
455     // With at least 200 000 gas
456     function() public payable {
457         buyTokens(msg.sender);
458     }
459 }