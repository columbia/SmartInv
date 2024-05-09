1 pragma solidity ^0.4.15;
2 
3 
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
34 contract ERC20 {
35   uint256 public totalSupply;
36   function balanceOf(address who) constant returns (uint256);
37   function transfer(address to, uint256 value) returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39   function allowance(address owner, address spender) constant returns (uint256);
40   function transferFrom(address from, address to, uint256 value) returns (bool);
41   function approve(address spender, uint256 value) returns (bool);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43     
44 }
45 
46 contract BasicToken is ERC20 {
47     using SafeMath for uint256;
48 
49     mapping(address => uint256) balances;
50     mapping (address => mapping (address => uint256)) allowed;
51     
52     modifier nonZeroEth(uint _value) {
53       require(_value > 0);
54       _;
55     }
56 
57     modifier onlyPayloadSize() {
58       require(msg.data.length >= 68);
59       _;
60     }
61     /**
62   * @dev transfer token for a specified address
63   * @param _to The address to transfer to.
64   * @param _value The amount to be transferred.
65   */
66 
67     function transfer(address _to, uint256 _value) nonZeroEth(_value) onlyPayloadSize returns (bool) {
68         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]){
69             balances[msg.sender] = balances[msg.sender].sub(_value);
70             balances[_to] = balances[_to].add(_value);
71             Transfer(msg.sender, _to, _value);
72             return true;
73         }else{
74             return false;
75         }
76     }
77     
78 
79     /**
80    * @dev Transfer tokens from one address to another
81    * @param _from address The address which you want to send tokens from
82    * @param _to address The address which you want to transfer to
83    * @param _value uint256 the amout of tokens to be transfered
84    */
85 
86     function transferFrom(address _from, address _to, uint256 _value) nonZeroEth(_value) onlyPayloadSize returns (bool) {
87       if(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]){
88         uint256 _allowance = allowed[_from][msg.sender];
89         allowed[_from][msg.sender] = _allowance.sub(_value);
90         balances[_to] = balances[_to].add(_value);
91         balances[_from] = balances[_from].sub(_value);
92         Transfer(_from, _to, _value);
93         return true;
94       }else{
95         return false;
96       }
97 }
98 
99 
100     /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of. 
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105 
106     function balanceOf(address _owner) constant returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110   function approve(address _spender, uint256 _value) returns (bool) {
111 
112     // To change the approve amount you first have to reduce the addresses`
113     //  allowance to zero by calling `approve(_spender, 0)` if it is not
114     //  already 0 to mitigate the race condition described here:
115     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
116     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
117 
118     allowed[msg.sender][_spender] = _value;
119     Approval(msg.sender, _spender, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Function to check the amount of tokens that an owner allowed to a spender.
125    * @param _owner address The address which owns the funds.
126    * @param _spender address The address which will spend the funds.
127    * @return A uint256 specifing the amount of tokens still avaible for the spender.
128    */
129   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
130     return allowed[_owner][_spender];
131   }
132 
133 }
134 
135 
136 contract RPTToken is BasicToken {
137 
138 using SafeMath for uint256;
139 
140 string public name = "RPT Token";                  //name of the token
141 string public symbol = "RPT";                      // symbol of the token
142 uint8 public decimals = 18;                        // decimals
143 uint256 public totalSupply = 1000000000 * 10**18;  // total supply of RPT Tokens  
144 
145 // variables
146 uint256 public keyEmployeeAllocation;               // fund allocated to key employee
147 uint256 public totalAllocatedTokens;                // variable to regulate the funds allocation
148 uint256 public tokensAllocatedToCrowdFund;          // funds allocated to crowdfund
149 
150 // addresses
151 address public founderMultiSigAddress = 0xf96E905091d38ca25e06C014fE67b5CA939eE83D;    // multi sign address of founders which hold 
152 address public crowdFundAddress;                    // address of crowdfund contract
153 
154 //events
155 event ChangeFoundersWalletAddress(uint256  _blockTimeStamp, address indexed _foundersWalletAddress);
156 event TransferPreAllocatedFunds(uint256  _blockTimeStamp , address _to , uint256 _value);
157 
158 //modifiers
159   modifier onlyCrowdFundAddress() {
160     require(msg.sender == crowdFundAddress);
161     _;
162   }
163 
164   modifier nonZeroAddress(address _to) {
165     require(_to != 0x0);
166     _;
167   }
168 
169   modifier onlyFounders() {
170     require(msg.sender == founderMultiSigAddress);
171     _;
172   }
173 
174    // creation of the token contract 
175    function RPTToken (address _crowdFundAddress) {
176     crowdFundAddress = _crowdFundAddress;
177 
178     // Token Distribution  
179     tokensAllocatedToCrowdFund = 70 * 10 ** 25;        // 70 % allocation of totalSupply
180     keyEmployeeAllocation = 30 * 10 ** 25;             // 30 % allocation of totalSupply
181 
182     // Assigned balances to respective stakeholders
183     balances[founderMultiSigAddress] = keyEmployeeAllocation;
184     balances[crowdFundAddress] = tokensAllocatedToCrowdFund;
185 
186     totalAllocatedTokens = balances[founderMultiSigAddress];
187   }
188 
189 // function to keep track of the total token allocation
190   function changeTotalSupply(uint256 _amount) onlyCrowdFundAddress {
191     totalAllocatedTokens = totalAllocatedTokens.add(_amount);
192   }
193 
194 // function to change founder multisig wallet address            
195   function changeFounderMultiSigAddress(address _newFounderMultiSigAddress) onlyFounders nonZeroAddress(_newFounderMultiSigAddress) {
196     founderMultiSigAddress = _newFounderMultiSigAddress;
197     ChangeFoundersWalletAddress(now, founderMultiSigAddress);
198   }
199  
200 
201 }
202 
203 
204 contract RPTCrowdsale {
205 
206     using SafeMath for uint256;
207     
208     RPTToken public token;                                          // Token variable
209     //variables
210    
211     uint256 public totalWeiRaised;                                  // Flag to track the amount raised
212     uint32 public exchangeRate = 3000;                              // calculated using priceOfEtherInUSD/priceOfRPTToken 
213     uint256 public preDistriToAcquiantancesStartTime = 1510876801;  // Friday, 17-Nov-17 00:00:01 UTC
214     uint256 public preDistriToAcquiantancesEndTime = 1511827199;    // Monday, 27-Nov-17 23:59:59 UTC
215     uint256 public presaleStartTime = 1511827200;                   // Tuesday, 28-Nov-17 00:00:00 UTC
216     uint256 public presaleEndTime = 1513036799;                     // Monday, 11-Dec-17 23:59:59 UTC
217     uint256 public crowdfundStartTime = 1513036800;                 // Tuesday, 12-Dec-17 00:00:00 UTC
218     uint256 public crowdfundEndTime = 1515628799;                   // Wednesday, 10-Jan-18 23:59:59 UTC
219     bool internal isTokenDeployed = false;                          // Flag to track the token deployment
220     
221     // addresses
222     address public founderMultiSigAddress;                          // Founders multi sign address
223     address public remainingTokenHolder;                            // Address to hold the remaining tokens after crowdfund end
224     address public beneficiaryAddress;                              // All funds are transferred to this address
225     
226 
227     enum State { Acquiantances, PreSale, CrowdFund, Closed }
228 
229     //events
230     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount); 
231     event CrowdFundClosed(uint256 _blockTimeStamp);
232     event ChangeFoundersWalletAddress(uint256 _blockTimeStamp, address indexed _foundersWalletAddress);
233    
234     //Modifiers
235     modifier tokenIsDeployed() {
236         require(isTokenDeployed == true);
237         _;
238     }
239      modifier nonZeroEth() {
240         require(msg.value > 0);
241         _;
242     }
243 
244     modifier nonZeroAddress(address _to) {
245         require(_to != 0x0);
246         _;
247     }
248 
249     modifier onlyFounders() {
250         require(msg.sender == founderMultiSigAddress);
251         _;
252     }
253 
254     modifier onlyPublic() {
255         require(msg.sender != founderMultiSigAddress);
256         _;
257     }
258 
259     modifier inState(State state) {
260         require(getState() == state); 
261         _;
262     }
263 
264     modifier inBetween() {
265         require(now >= preDistriToAcquiantancesStartTime && now <= crowdfundEndTime);
266         _;
267     }
268 
269     // Constructor to initialize the local variables 
270     function RPTCrowdsale (address _founderWalletAddress, address _remainingTokenHolder, address _beneficiaryAddress) {
271         founderMultiSigAddress = _founderWalletAddress;
272         remainingTokenHolder = _remainingTokenHolder;
273         beneficiaryAddress = _beneficiaryAddress;
274     }
275 
276     // Function to change the founders multi sign address 
277      function setFounderMultiSigAddress(address _newFounderAddress) onlyFounders  nonZeroAddress(_newFounderAddress) {
278         founderMultiSigAddress = _newFounderAddress;
279         ChangeFoundersWalletAddress(now, founderMultiSigAddress);
280     }
281     
282     // Attach the token contract     
283     function setTokenAddress(address _tokenAddress) external onlyFounders nonZeroAddress(_tokenAddress) {
284         require(isTokenDeployed == false);
285         token = RPTToken(_tokenAddress);
286         isTokenDeployed = true;
287     }
288 
289 
290     // function call after crowdFundEndTime it transfers the remaining tokens to remainingTokenHolder address
291     function endCrowdfund() onlyFounders returns (bool) {
292         require(now > crowdfundEndTime);
293         uint256 remainingToken = token.balanceOf(this);  // remaining tokens
294 
295         if (remainingToken != 0) {
296           token.transfer(remainingTokenHolder, remainingToken); 
297           CrowdFundClosed(now);
298           return true; 
299         } else {
300             CrowdFundClosed(now);
301             return false;
302         }
303        
304     }
305 
306     // Buy token function call only in duration of crowdfund active 
307     function buyTokens(address beneficiary)
308     nonZeroEth 
309     tokenIsDeployed 
310     onlyPublic 
311     nonZeroAddress(beneficiary) 
312     inBetween
313     payable 
314     public 
315     returns(bool) 
316     {
317             fundTransfer(msg.value);
318 
319             uint256 amount = getNoOfTokens(exchangeRate, msg.value);
320             
321             if (token.transfer(beneficiary, amount)) {
322                 token.changeTotalSupply(amount); 
323                 totalWeiRaised = totalWeiRaised.add(msg.value);
324                 TokenPurchase(beneficiary, msg.value, amount);
325                 return true;
326             } 
327             return false;
328         
329     }
330 
331 
332     // function to transfer the funds to founders account
333     function fundTransfer(uint256 weiAmount) internal {
334         beneficiaryAddress.transfer(weiAmount);
335     }
336 
337 // Get functions 
338 
339     // function to get the current state of the crowdsale
340     function getState() internal constant returns(State) {
341         if (now >= preDistriToAcquiantancesStartTime && now <= preDistriToAcquiantancesEndTime) {
342             return State.Acquiantances;
343         } if (now >= presaleStartTime && now <= presaleEndTime) {
344             return State.PreSale;
345         } if (now >= crowdfundStartTime && now <= crowdfundEndTime) {
346             return State.CrowdFund;
347         } else {
348             return State.Closed;
349         }
350         
351     }
352 
353 
354    // function to calculate the total no of tokens with bonus multiplication
355     function getNoOfTokens(uint32 _exchangeRate, uint256 _amount) internal returns (uint256) {
356          uint256 noOfToken = _amount.mul(uint256(_exchangeRate));
357          uint256 noOfTokenWithBonus = ((uint256(100 + getCurrentBonusRate())).mul(noOfToken)).div(100);
358          return noOfTokenWithBonus;
359     }
360 
361     
362 
363     // function provide the current bonus rate
364     function getCurrentBonusRate() internal returns (uint8) {
365         
366         if (getState() == State.Acquiantances) {
367             return 40;
368         }
369         if (getState() == State.PreSale) {
370             return 20;
371         }
372         if (getState() == State.CrowdFund) {
373             return 0;
374         } else {
375             return 0;
376         }
377     }
378 
379     // provides the bonus % 
380     function getBonus() constant returns (uint8) {
381         return getCurrentBonusRate();
382     }
383 
384     // send ether to the contract address
385     // With at least 200 000 gas
386     function() public payable {
387         buyTokens(msg.sender);
388     }
389 }