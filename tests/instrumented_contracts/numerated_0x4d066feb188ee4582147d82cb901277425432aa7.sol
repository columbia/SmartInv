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
52     /**
53   * @dev transfer token for a specified address
54   * @param _to The address to transfer to.
55   * @param _value The amount to be transferred.
56   */
57 
58     function transfer(address _to, uint256 _value) returns (bool) {
59         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
60             balances[msg.sender] = balances[msg.sender].sub(_value);
61             balances[_to] = balances[_to].add(_value);
62             Transfer(msg.sender, _to, _value);
63             return true;
64         }else {
65             return false;
66         }
67     }
68     
69 
70     /**
71    * @dev Transfer tokens from one address to another
72    * @param _from address The address which you want to send tokens from
73    * @param _to address The address which you want to transfer to
74    * @param _value uint256 the amout of tokens to be transfered
75    */
76 
77     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
78       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
79         uint256 _allowance = allowed[_from][msg.sender];
80         allowed[_from][msg.sender] = _allowance.sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         balances[_from] = balances[_from].sub(_value);
83         Transfer(_from, _to, _value);
84         return true;
85       } else {
86         return false;
87       }
88 }
89 
90 
91     /**
92   * @dev Gets the balance of the specified address.
93   * @param _owner The address to query the the balance of. 
94   * @return An uint256 representing the amount owned by the passed address.
95   */
96 
97     function balanceOf(address _owner) constant returns (uint256 balance) {
98     return balances[_owner];
99   }
100 
101   function approve(address _spender, uint256 _value) returns (bool) {
102 
103     // To change the approve amount you first have to reduce the addresses`
104     //  allowance to zero by calling `approve(_spender, 0)` if it is not
105     //  already 0 to mitigate the race condition described here:
106     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
108 
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111     return true;
112   }
113 
114   /**
115    * @dev Function to check the amount of tokens that an owner allowed to a spender.
116    * @param _owner address The address which owns the funds.
117    * @param _spender address The address which will spend the funds.
118    * @return A uint256 specifing the amount of tokens still avaible for the spender.
119    */
120   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
121     return allowed[_owner][_spender];
122   }
123 
124 
125 }
126 
127 
128 contract DOWToken is BasicToken {
129 
130 using SafeMath for uint256;
131 
132 string public name = "DOW";                        //name of the token
133 string public symbol = "dow";                      // symbol of the token
134 uint8 public decimals = 18;                        // decimals
135 uint256 public initialSupply = 2000000000 * 10**18;  // total supply of dow Tokens  
136 
137 // variables
138 uint256 public foundersAllocation;                  // fund allocated to founders
139 uint256 public devAllocation;                       // fund allocated to developers 
140 uint256 public totalAllocatedTokens;                // variable to keep track of funds allocated
141 uint256 public tokensAllocatedToCrowdFund;          // funds allocated to crowdfund
142 // addresses
143 
144 address public founderMultiSigAddress;              // Multi sign address of founders which hold 
145 address public devTeamAddress;                      // Developemnt team address which hold devAllocation funds
146 address public crowdFundAddress;                    // Address of crowdfund contract
147 
148 
149 
150 //events
151 
152 event ChangeFoundersWalletAddress(uint256  _blockTimeStamp, address indexed _foundersWalletAddress);
153 
154 //modifiers
155 
156   modifier onlyCrowdFundAddress() {
157     require(msg.sender == crowdFundAddress);
158     _;
159   }
160 
161   modifier nonZeroAddress(address _to) {
162     require(_to != 0x0);
163     _;
164   }
165 
166   modifier onlyFounders() {
167     require(msg.sender == founderMultiSigAddress);
168     _;
169   }
170 
171   
172    // creation of the token contract 
173    function DOWToken (address _crowdFundAddress, address _founderMultiSigAddress, address _devTeamAddress) {
174     crowdFundAddress = _crowdFundAddress;
175     founderMultiSigAddress = _founderMultiSigAddress;
176     devTeamAddress = _devTeamAddress;
177 
178     // Token Distribution 
179     foundersAllocation = 50 * 10 ** 25;               // 25 % allocation of initialSupply 
180     devAllocation = 30 * 10 ** 25;                    // 15 % allocation of initialSupply 
181     tokensAllocatedToCrowdFund = 120 * 10 ** 25;      // 60 % allocation of initialSupply
182    
183     // Assigned balances to respective stakeholders
184     balances[founderMultiSigAddress] = foundersAllocation;
185     balances[devTeamAddress] = devAllocation;
186     balances[crowdFundAddress] = tokensAllocatedToCrowdFund;
187 
188     totalAllocatedTokens = balances[founderMultiSigAddress] + balances[devTeamAddress];
189   }
190 
191 
192 // function to keep track of the total token allocation
193   function addToAllocation(uint256 _amount) onlyCrowdFundAddress {
194     totalAllocatedTokens = totalAllocatedTokens.add(_amount);
195   }
196 
197 // function to change founder multisig wallet address            
198   function changeFounderMultiSigAddress(address _newFounderMultiSigAddress) onlyFounders nonZeroAddress(_newFounderMultiSigAddress) {
199     founderMultiSigAddress = _newFounderMultiSigAddress;
200     ChangeFoundersWalletAddress(now, founderMultiSigAddress);
201   }
202 
203 // fallback function to restrict direct sending of ether
204   function () {
205     revert();
206   }
207 
208 }
209 
210 
211 contract DOWCrowdfund {
212 
213     using SafeMath for uint256;
214     
215     DOWToken public token;                                 // Token contract reference
216 
217     //variables
218     uint256 public crowdfundStartTime;                     // Starting time of CrowdFund
219     uint256 public crowdfundEndTime;                       // End time of Crowdfund
220     uint256 public totalWeiRaised;                         // Counter to track the amount raised
221     uint256 public weekOneRate = 3000;                     // Calculated using priceOfEtherInUSD/priceOfDOWToken 
222     uint256 public weekTwoRate = 2000;                     // Calculated using priceOfEtherInUSD/priceOfDOWToken 
223     uint256 public weekThreeRate = 1500;                   // Calculated using priceOfEtherInUSD/priceOfDOWToken 
224     uint256 public weekFourthRate = 1200;                  // Calculated using priceOfEtherInUSD/priceOfDOWToken 
225     uint256 minimumFundingGoal = 5000 * 1 ether;           // Minimum amount of ethers required for a success of the crowdsale
226     uint256 MAX_FUNDING_GOAL = 400000 * 1 ether;           // Maximum amount of ethers can invested in the crowdsale
227     uint256 public totalDowSold = 0;
228     address public owner = 0x0;                            // Address of the owner or the deployer 
229 
230     bool  internal isTokenDeployed = false;                // Flag to track the token deployment -- only can be set once
231 
232     // addresses
233     address public founderMultiSigAddress;                 // Founders multisig address
234     address public remainingTokenHolder;                   // Remaining token holder address
235     //events
236     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount); 
237     event CrowdFundClosed(uint256 _blockTimeStamp);
238     event ChangeFoundersWalletAddress(uint256 _blockTimeStamp, address indexed _foundersWalletAddress);
239    
240     //Modifiers
241     modifier tokenIsDeployed() {
242         require(isTokenDeployed == true);
243         _;
244     }
245      modifier nonZeroEth() {
246         require(msg.value > 0);
247         _;
248     }
249 
250     modifier nonZeroAddress(address _to) {
251         require(_to != 0x0);
252         _;
253     }
254 
255 
256     modifier onlyFounders() {
257         require(msg.sender == founderMultiSigAddress);
258         _;
259     }
260 
261     modifier onlyPublic() {
262         require(msg.sender != founderMultiSigAddress);
263         _;
264     }
265 
266     modifier isBetween() {
267         require(now >= crowdfundStartTime && now <= crowdfundEndTime);
268         _;
269     }
270 
271     modifier onlyOwner() {
272         require(msg.sender == owner);
273         _;
274     }
275 
276     // Constructor to initialize the local variables 
277     function DOWCrowdfund (address _founderWalletAddress, address _remainingTokenHolder) {
278         founderMultiSigAddress = _founderWalletAddress;
279         remainingTokenHolder = _remainingTokenHolder;
280         owner = msg.sender;
281         crowdfundStartTime = 1510272001;  //Friday, 10-Nov-17 00:00:01 UTC 
282         crowdfundEndTime = 1512950399;    //Sunday, 10-Dec-17 23:59:59 UTC 
283     }
284 
285 
286     // Function to change the founders multisig address 
287     function ChangeFounderMultiSigAddress(address _newFounderAddress) onlyFounders nonZeroAddress(_newFounderAddress) {
288         founderMultiSigAddress = _newFounderAddress;
289         ChangeFoundersWalletAddress(now, founderMultiSigAddress);
290     }
291 
292     // Attach the token contract, can only be done once     
293     function setTokenAddress(address _tokenAddress) external onlyOwner nonZeroAddress(_tokenAddress) {
294         require(isTokenDeployed == false);
295         token = DOWToken(_tokenAddress);
296         isTokenDeployed = true;
297     }
298 
299 
300     // function call after crowdFundEndTime.
301     // It transfers the remaining tokens to remainingTokenHolder address
302     function endCrowdfund() onlyFounders returns (bool) {
303         require(now > crowdfundEndTime);
304         uint256 remainingToken = token.balanceOf(this);  // remaining tokens
305 
306         if (remainingToken != 0) {
307           token.transfer(remainingTokenHolder, remainingToken); 
308           CrowdFundClosed(now);
309           return true; 
310         } 
311         CrowdFundClosed(now);
312         return false;
313        
314     }
315 
316     // Buy token function call only in duration of crowdfund active 
317     function buyTokens(address beneficiary) 
318     nonZeroEth 
319     tokenIsDeployed 
320     onlyPublic
321     isBetween 
322     nonZeroAddress(beneficiary) 
323     payable 
324     returns(bool) 
325     {
326         if (totalWeiRaised.add(msg.value) > MAX_FUNDING_GOAL) 
327             revert();
328 
329             fundTransfer(msg.value);
330             uint256 amount = getNoOfTokens(msg.value);
331             
332             if (token.transfer(beneficiary, amount)) {
333                 token.addToAllocation(amount); 
334                 totalDowSold = totalDowSold.add(amount);
335                 totalWeiRaised = totalWeiRaised.add(msg.value);
336                 TokenPurchase(beneficiary, msg.value, amount);
337                 return true;
338             } 
339             return false;
340         }
341 
342     // function to transfer the funds to founders account
343     function fundTransfer(uint256 weiAmount) internal {
344         founderMultiSigAddress.transfer(weiAmount);
345     }
346 
347 // Get functions
348 
349     // function provide the token
350     function getNoOfTokens(uint256 investedAmount) internal returns (uint256) {
351         
352         if ( now > crowdfundStartTime + 3 weeks && now < crowdfundEndTime) {
353             return  investedAmount.mul(weekFourthRate);
354         }
355         if (now > crowdfundStartTime + 2 weeks) {
356             return investedAmount.mul(weekThreeRate);
357         }
358         if (now > crowdfundStartTime + 1 weeks) {
359             return investedAmount.mul(weekTwoRate);
360         }
361         if (now > crowdfundStartTime) {
362             return investedAmount.mul(weekOneRate);
363         }
364     }
365 
366     
367     // Crowdfund entry
368     // send ether to the contract address
369     // With at least 200 000 gas
370     function() public payable {
371         buyTokens(msg.sender);
372     }
373 }