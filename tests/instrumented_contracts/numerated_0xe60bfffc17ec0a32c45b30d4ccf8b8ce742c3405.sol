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
123 contract BiQToken is BasicToken {
124 
125   using SafeMath for uint256;
126 
127   string public name = "BurstIQ Token";              //name of the token
128   string public symbol = "BiQ";                      // symbol of the token
129   uint8 public decimals = 18;                        // decimals
130   uint256 public totalSupply = 1000000000 * 10**18;  // total supply of BiQ Tokens
131 
132   // variables
133   uint256 public keyEmployeesAllocatedFund;           // fund allocated to key employees
134   uint256 public advisorsAllocation;                  // fund allocated to advisors
135   uint256 public marketIncentivesAllocation;          // fund allocated to Market
136   uint256 public vestingFounderAllocation;            // funds allocated to founders that in under vesting period
137   uint256 public totalAllocatedTokens;                // variable to keep track of funds allocated
138   uint256 public tokensAllocatedToCrowdFund;          // funds allocated to crowdfund
139   uint256 public saftInvestorAllocation;              // funds allocated to private presales and instituational investors
140 
141   bool public isPublicTokenReleased = false;          // flag to track the release the public token
142 
143   // addresses
144 
145   address public founderMultiSigAddress;              // multi sign address of founders which hold
146   address public advisorAddress;                      //  advisor address which hold advisorsAllocation funds
147   address public vestingFounderAddress;               // address of founder that hold vestingFounderAllocation
148   address public crowdFundAddress;                    // address of crowdfund contract
149 
150   // vesting period
151 
152   uint256 public preAllocatedTokensVestingTime;       // crowdfund start time + 6 months
153 
154   //events
155 
156   event ChangeFoundersWalletAddress(uint256  _blockTimeStamp, address indexed _foundersWalletAddress);
157   event TransferPreAllocatedFunds(uint256  _blockTimeStamp , address _to , uint256 _value);
158   event PublicTokenReleased(uint256 _blockTimeStamp);
159 
160   //modifiers
161 
162   modifier onlyCrowdFundAddress() {
163     require(msg.sender == crowdFundAddress);
164     _;
165   }
166 
167   modifier nonZeroAddress(address _to) {
168     require(_to != 0x0);
169     _;
170   }
171 
172   modifier onlyFounders() {
173     require(msg.sender == founderMultiSigAddress);
174     _;
175   }
176 
177   modifier onlyVestingFounderAddress() {
178     require(msg.sender == vestingFounderAddress);
179     _;
180   }
181 
182   modifier onlyAdvisorAddress() {
183     require(msg.sender == advisorAddress);
184     _;
185   }
186 
187   modifier isPublicTokenNotReleased() {
188     require(isPublicTokenReleased == false);
189     _;
190   }
191 
192 
193   // creation of the token contract
194   function BiQToken (address _crowdFundAddress, address _founderMultiSigAddress, address _advisorAddress, address _vestingFounderAddress) {
195     crowdFundAddress = _crowdFundAddress;
196     founderMultiSigAddress = _founderMultiSigAddress;
197     vestingFounderAddress = _vestingFounderAddress;
198     advisorAddress = _advisorAddress;
199 
200     // Token Distribution
201     vestingFounderAllocation = 18 * 10 ** 25 ;        // 18 % allocation of totalSupply
202     keyEmployeesAllocatedFund = 2 * 10 ** 25 ;        // 2 % allocation of totalSupply
203     advisorsAllocation = 5 * 10 ** 25 ;               // 5 % allocation of totalSupply
204     tokensAllocatedToCrowdFund = 60 * 10 ** 25 ;      // 60 % allocation of totalSupply
205     marketIncentivesAllocation = 5 * 10 ** 25 ;       // 5 % allocation of totalSupply
206     saftInvestorAllocation = 10 * 10 ** 25 ;          // 10 % alloaction of totalSupply
207 
208     // Assigned balances to respective stakeholders
209     balances[founderMultiSigAddress] = keyEmployeesAllocatedFund + saftInvestorAllocation;
210     balances[crowdFundAddress] = tokensAllocatedToCrowdFund;
211 
212     totalAllocatedTokens = balances[founderMultiSigAddress];
213     preAllocatedTokensVestingTime = now + 180 * 1 days;                // it should be 6 months period for vesting
214   }
215 
216   // function to keep track of the total token allocation
217   function changeTotalSupply(uint256 _amount) onlyCrowdFundAddress {
218     totalAllocatedTokens = totalAllocatedTokens.add(_amount);
219     tokensAllocatedToCrowdFund = tokensAllocatedToCrowdFund.sub(_amount);
220   }
221 
222   // function to change founder multisig wallet address
223   function changeFounderMultiSigAddress(address _newFounderMultiSigAddress) onlyFounders nonZeroAddress(_newFounderMultiSigAddress) {
224     founderMultiSigAddress = _newFounderMultiSigAddress;
225     ChangeFoundersWalletAddress(now, founderMultiSigAddress);
226   }
227 
228   // function for releasing the public tokens called once by the founder only
229   function releaseToken() onlyFounders isPublicTokenNotReleased {
230     isPublicTokenReleased = !isPublicTokenReleased;
231     PublicTokenReleased(now);
232   }
233 
234   // function to transfer market Incentives fund
235   function transferMarketIncentivesFund(address _to, uint _value) onlyFounders nonZeroAddress(_to)  returns (bool) {
236     if (marketIncentivesAllocation >= _value) {
237       marketIncentivesAllocation = marketIncentivesAllocation.sub(_value);
238       balances[_to] = balances[_to].add(_value);
239       totalAllocatedTokens = totalAllocatedTokens.add(_value);
240       TransferPreAllocatedFunds(now, _to, _value);
241       return true;
242     }
243     return false;
244   }
245 
246 
247   // fund transferred to vesting Founders address after 6 months
248   function getVestedFounderTokens() onlyVestingFounderAddress returns (bool) {
249     if (now >= preAllocatedTokensVestingTime && vestingFounderAllocation > 0) {
250       balances[vestingFounderAddress] = balances[vestingFounderAddress].add(vestingFounderAllocation);
251       totalAllocatedTokens = totalAllocatedTokens.add(vestingFounderAllocation);
252       vestingFounderAllocation = 0;
253       TransferPreAllocatedFunds(now, vestingFounderAddress, vestingFounderAllocation);
254       return true;
255     }
256     return false;
257   }
258 
259   // fund transferred to vesting advisor address after 6 months
260   function getVestedAdvisorTokens() onlyAdvisorAddress returns (bool) {
261     if (now >= preAllocatedTokensVestingTime && advisorsAllocation > 0) {
262       balances[advisorAddress] = balances[advisorAddress].add(advisorsAllocation);
263       totalAllocatedTokens = totalAllocatedTokens.add(advisorsAllocation);
264       advisorsAllocation = 0;
265       TransferPreAllocatedFunds(now, advisorAddress, advisorsAllocation);
266       return true;
267     } else {
268       return false;
269     }
270   }
271 
272   // overloaded transfer function to restrict the investor to transfer the token before the ICO sale ends
273   function transfer(address _to, uint256 _value) returns (bool) {
274     if (msg.sender == crowdFundAddress) {
275       return super.transfer(_to,_value);
276     } else {
277       if (isPublicTokenReleased) {
278         return super.transfer(_to,_value);
279       }
280       return false;
281     }
282   }
283 
284   // overloaded transferFrom function to restrict the investor to transfer the token before the ICO sale ends
285   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
286     if (msg.sender == crowdFundAddress) {
287       return super.transferFrom(_from, _to, _value);
288     } else {
289       if (isPublicTokenReleased) {
290         return super.transferFrom(_from, _to, _value);
291       }
292       return false;
293     }
294   }
295 
296   // fallback function to restrict direct sending of ether
297   function () {
298     revert();
299   }
300 
301 }