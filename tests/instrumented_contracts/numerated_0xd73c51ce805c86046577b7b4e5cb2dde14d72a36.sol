1 pragma solidity ^0.4.15;
2 
3 contract ERC20 {
4   function balanceOf(address who) constant returns (uint256);
5   function transfer(address to, uint256 value) returns (bool);
6   event Transfer(address indexed from, address indexed to, uint256 value);
7   function allowance(address owner, address spender) constant returns (uint256);
8   function transferFrom(address from, address to, uint256 value) returns (bool);
9   function approve(address spender, uint256 value) returns (bool);
10   event Approval(address indexed owner, address indexed spender, uint256 value);  
11 }
12 
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal constant returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal constant returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract BasicToken is ERC20 {
44     using SafeMath for uint256;
45 
46     mapping(address => uint256) balances;
47     mapping (address => mapping (address => uint256)) allowed;
48 
49     /**
50   * @dev transfer token for a specified address
51   * @param _to The address to transfer to.
52   * @param _value The amount to be transferred.
53   */
54 
55     function transfer(address _to, uint256 _value) returns (bool) {
56         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
57             balances[msg.sender] = balances[msg.sender].sub(_value);
58             balances[_to] = balances[_to].add(_value);
59             Transfer(msg.sender, _to, _value);
60             return true;
61         }else {
62             return false;
63         }
64     }
65     
66 
67     /**
68    * @dev Transfer tokens from one address to another
69    * @param _from address The address which you want to send tokens from
70    * @param _to address The address which you want to transfer to
71    * @param _value uint256 the amout of tokens to be transfered
72    */
73 
74     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
75       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
76         uint256 _allowance = allowed[_from][msg.sender];
77         allowed[_from][msg.sender] = _allowance.sub(_value);
78         balances[_to] = balances[_to].add(_value);
79         balances[_from] = balances[_from].sub(_value);
80         Transfer(_from, _to, _value);
81         return true;
82       } else {
83         return false;
84       }
85 }
86 
87 
88     /**
89   * @dev Gets the balance of the specified address.
90   * @param _owner The address to query the the balance of. 
91   * @return An uint256 representing the amount owned by the passed address.
92   */
93 
94     function balanceOf(address _owner) constant returns (uint256 balance) {
95     return balances[_owner];
96   }
97 
98   function approve(address _spender, uint256 _value) returns (bool) {
99 
100     // To change the approve amount you first have to reduce the addresses`
101     //  allowance to zero by calling `approve(_spender, 0)` if it is not
102     //  already 0 to mitigate the race condition described here:
103     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
105 
106     allowed[msg.sender][_spender] = _value;
107     Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111   /**
112    * @dev Function to check the amount of tokens that an owner allowed to a spender.
113    * @param _owner address The address which owns the funds.
114    * @param _spender address The address which will spend the funds.
115    * @return A uint256 specifing the amount of tokens still avaible for the spender.
116    */
117   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
118     return allowed[_owner][_spender];
119   }
120 
121 
122 }
123 
124 contract EPTToken is BasicToken {
125 
126     using SafeMath for uint256;
127 
128     string public name = "e-Pocket Token";                      //name of the token
129     string public symbol = "EPT";                               //symbol of the token
130     uint8 public decimals = 18;                                 //decimals
131     uint256 public initialSupply = 64000000 * 10**18;           //total supply of Tokens
132 
133     //variables
134     uint256 public totalAllocatedTokens;                         //variable to keep track of funds allocated
135     uint256 public tokensAllocatedToCrowdFund;                   //funds allocated to crowdfund
136     uint256 public foundersAllocation;                           //funds allocated to founder
137 
138     //addresses
139     address public founderMultiSigAddress;                       //Multi sign address of founder
140     address public crowdFundAddress;                             //Address of crowdfund contract
141 
142     //events
143     event ChangeFoundersWalletAddress(uint256 _blockTimeStamp, address indexed _foundersWalletAddress);
144     
145     //modifierss
146 
147     modifier nonZeroAddress(address _to){
148         require(_to != 0x0);
149         _;
150     }
151 
152     modifier onlyFounders(){
153         require(msg.sender == founderMultiSigAddress);
154         _;
155     }
156 
157     modifier onlyCrowdfund(){
158         require(msg.sender == crowdFundAddress);
159         _;
160     }
161 
162     /**
163         @dev EPTToken Constructor to initiate the variables with some input argument
164         @param _crowdFundAddress This is the address of the crowdfund which leads the distribution of tokens
165         @param _founderMultiSigAddress This is the address of the founder which have the hold over the contract.
166     
167      */
168     
169     function EPTToken(address _crowdFundAddress, address _founderMultiSigAddress) {
170         crowdFundAddress = _crowdFundAddress;
171         founderMultiSigAddress = _founderMultiSigAddress;
172     
173         //token allocation
174         tokensAllocatedToCrowdFund = 32 * 10**24;
175         foundersAllocation = 32 * 10**24;
176 
177         // Assigned balances
178         balances[crowdFundAddress] = tokensAllocatedToCrowdFund;
179         balances[founderMultiSigAddress] = foundersAllocation;
180 
181         totalAllocatedTokens = balances[founderMultiSigAddress];
182     }
183 
184     /**
185         @dev changeTotalSupply is the function used to variate the variable totalAllocatedTokens
186         @param _amount amount of tokens are sold out to increase the value of totalAllocatedTokens
187      */
188 
189     function changeTotalSupply(uint256 _amount) onlyCrowdfund {
190         totalAllocatedTokens += _amount;
191     }
192 
193 
194     /**
195         @dev changeFounderMultiSigAddress function use to change the ownership of the contract
196         @param _newFounderMultiSigAddress New address which will take the ownership of the contract
197      */
198     
199     function changeFounderMultiSigAddress(address _newFounderMultiSigAddress) onlyFounders nonZeroAddress(_newFounderMultiSigAddress) {
200         founderMultiSigAddress = _newFounderMultiSigAddress;
201         ChangeFoundersWalletAddress(now, founderMultiSigAddress);
202     }
203 
204   
205 }
206 
207 
208 contract EPTCrowdfund {
209     
210     using SafeMath for uint256;
211 
212     EPTToken public token;                                      // Token contract reference
213     
214     address public beneficiaryAddress;                          // Address where all funds get allocated 
215     address public founderAddress;                              // Founders address
216     uint256 public crowdfundStartTime = 1516579201;             // Monday, 22-Jan-18 00:00:01 UTC
217     uint256 public crowdfundEndTime = 1518998399;               // Sunday, 18-Feb-18 23:59:59 UTC
218     uint256 public presaleStartTime = 1513123201;               // Wednesday, 13-Dec-17 00:00:01
219     uint256 public presaleEndTime = 1516579199;                 // Sunday, 21-Jan-18 23:59:59
220     uint256 public ethRaised;                                   // Counter to track the amount raised
221     bool private tokenDeployed = false;                         // Flag to track the token deployment -- only can be set once
222     uint256 public tokenSold;                                   // Counter to track the amount of token sold
223     uint256 private ethRate;
224     
225     
226     //events
227     event ChangeFounderAddress(address indexed _newFounderAddress , uint256 _timestamp);
228     event TokenPurchase(address indexed _beneficiary, uint256 _value, uint256 _amount);
229     event CrowdFundClosed(uint256 _timestamp);
230     
231     enum State {PreSale, CrowdSale, Finish}
232     
233     //Modifiers
234     modifier onlyfounder() {
235         require(msg.sender == founderAddress);
236         _;
237     }
238 
239     modifier nonZeroAddress(address _to) {
240         require(_to != 0x0);
241         _;
242     }
243 
244     modifier onlyPublic() {
245         require(msg.sender != founderAddress);
246         _;
247     }
248 
249     modifier nonZeroEth() {
250         require(msg.value != 0);
251         _;
252     }
253 
254     modifier isTokenDeployed() {
255         require(tokenDeployed == true);
256         _;
257     }
258 
259     modifier isBetween() {
260         require(now >= presaleStartTime && now <= crowdfundEndTime);
261         _;
262     }
263 
264     /**
265         @dev EPTCrowdfund Constructor used to initialize the required variable.
266         @param _founderAddress Founder address 
267         @param _ethRate Rate of ether in dollars at the time of deployment.
268         @param _beneficiaryAddress Address that hold all funds collected from investors
269 
270      */
271 
272     function EPTCrowdfund(address _founderAddress, address _beneficiaryAddress, uint256 _ethRate) {
273         beneficiaryAddress = _beneficiaryAddress;
274         founderAddress = _founderAddress;
275         ethRate = uint256(_ethRate);
276     }
277    
278     /**
279         @dev setToken Function used to set the token address into the contract.
280         @param _tokenAddress variable that contains deployed token address 
281      */
282 
283     function setToken(address _tokenAddress) nonZeroAddress(_tokenAddress) onlyfounder {
284          require(tokenDeployed == false);
285          token = EPTToken(_tokenAddress);
286          tokenDeployed = true;
287     }
288     
289     
290     /**
291         @dev changeFounderWalletAddress used to change the wallet address or change the ownership
292         @param _newAddress new founder wallet address
293      */
294 
295     function changeFounderWalletAddress(address _newAddress) onlyfounder nonZeroAddress(_newAddress) {
296          founderAddress = _newAddress;
297          ChangeFounderAddress(founderAddress,now);
298     }
299 
300     
301     /**
302         @dev buyTokens function used to buy the tokens using ethers only. sale 
303             is only processed between start time and end time. 
304         @param _beneficiary address of the investor
305         @return bool 
306      */
307 
308     function buyTokens (address _beneficiary)
309     isBetween
310     onlyPublic
311     nonZeroAddress(_beneficiary)
312     nonZeroEth
313     isTokenDeployed
314     payable
315     public
316     returns (bool)
317     {
318          uint256 amount = msg.value.mul(((ethRate.mul(100)).div(getRate())));
319     
320         if (token.transfer(_beneficiary, amount)) {
321             fundTransfer(msg.value);
322             
323             ethRaised = ethRaised.add(msg.value);
324             tokenSold = tokenSold.add(amount);
325             token.changeTotalSupply(amount); 
326             TokenPurchase(_beneficiary, msg.value, amount);
327             return true;
328         }
329         return false;
330     }
331 
332     /**
333         @dev setEthRate function used to set the ether Rate
334         @param _newEthRate latest eth rate
335         @return bool
336      
337      */
338 
339     function setEthRate(uint256 _newEthRate) onlyfounder returns (bool) {
340         require(_newEthRate > 0);
341         ethRate = _newEthRate;
342         return true;
343     }
344 
345     /**
346         @dev getRate used to get the price of each token on weekly basis
347         @return uint256 price of each tokens in dollar
348     
349      */
350 
351     function getRate() internal returns(uint256) {
352 
353         if (getState() == State.PreSale) {
354             return 10;
355         } 
356         if(getState() == State.CrowdSale) {
357             if (now >= crowdfundStartTime + 3 weeks && now <= crowdfundEndTime) {
358                 return 30;
359              }
360             if (now >= crowdfundStartTime + 2 weeks) {
361                 return 25;
362             }
363             if (now >= crowdfundStartTime + 1 weeks) {
364                 return 20;
365             }
366             if (now >= crowdfundStartTime) {
367                 return 15;
368             }  
369         } else {
370             return 0;
371         }
372               
373     }  
374 
375     /**
376         @dev `getState` used to findout the state of the crowdfund
377         @return State 
378      */
379 
380     function getState() private returns(State) {
381         if (now >= crowdfundStartTime && now <= crowdfundEndTime) {
382             return State.CrowdSale;
383         }
384         if (now >= presaleStartTime && now <= presaleEndTime) {
385             return State.PreSale;
386         } else {
387             return State.Finish;
388         }
389 
390     }
391 
392     /**
393         @dev endCrowdFund called only after the end time of crowdfund . use to end the sale.
394         @return bool
395      */
396 
397     function endCrowdFund() onlyfounder returns(bool) {
398         require(now > crowdfundEndTime);
399         uint256 remainingtoken = token.balanceOf(this);
400 
401         if (remainingtoken != 0) {
402             token.transfer(founderAddress,remainingtoken);
403             CrowdFundClosed(now);
404             return true;
405         }
406         CrowdFundClosed(now);
407         return false;    
408  } 
409 
410     /**
411         @dev fundTransfer used to transfer collected ether into the beneficary address
412      */
413 
414     function fundTransfer(uint256 _funds) private {
415         beneficiaryAddress.transfer(_funds);
416     }
417 
418     // Crowdfund entry
419     // send ether to the contract address
420     // gas used 200000
421     function () payable {
422         buyTokens(msg.sender);
423     }
424 
425 }