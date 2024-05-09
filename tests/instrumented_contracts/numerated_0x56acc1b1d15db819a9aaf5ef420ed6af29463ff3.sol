1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ERC20 {
34   uint256 public totalSupply;
35   function balanceOf(address who) constant returns (uint256);
36   function transfer(address to, uint256 value) returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38   function allowance(address owner, address spender) constant returns (uint256);
39   function transferFrom(address from, address to, uint256 value) returns (bool);
40   function approve(address spender, uint256 value) returns (bool);
41   event Approval(address indexed owner, address indexed spender, uint256 value);
42     
43 }
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
69     /**
70    * @dev Transfer tokens from one address to another
71    * @param _from address The address which you want to send tokens from
72    * @param _to address The address which you want to transfer to
73    * @param _value uint256 the amout of tokens to be transfered
74    */
75 
76     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
77       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
78         uint256 _allowance = allowed[_from][msg.sender];
79         allowed[_from][msg.sender] = _allowance.sub(_value);
80         balances[_to] = balances[_to].add(_value);
81         balances[_from] = balances[_from].sub(_value);
82         Transfer(_from, _to, _value);
83         return true;
84       } else {
85         return false;
86       }
87 }
88 
89 
90     /**
91   * @dev Gets the balance of the specified address.
92   * @param _owner The address to query the the balance of. 
93   * @return An uint256 representing the amount owned by the passed address.
94   */
95 
96     function balanceOf(address _owner) constant returns (uint256 balance) {
97     return balances[_owner];
98   }
99 
100   function approve(address _spender, uint256 _value) returns (bool) {
101 
102     // To change the approve amount you first have to reduce the addresses`
103     //  allowance to zero by calling `approve(_spender, 0)` if it is not
104     //  already 0 to mitigate the race condition described here:
105     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
107 
108     allowed[msg.sender][_spender] = _value;
109     Approval(msg.sender, _spender, _value);
110     return true;
111   }
112 
113   /**
114    * @dev Function to check the amount of tokens that an owner allowed to a spender.
115    * @param _owner address The address which owns the funds.
116    * @param _spender address The address which will spend the funds.
117    * @return A uint256 specifing the amount of tokens still avaible for the spender.
118    */
119   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
120     return allowed[_owner][_spender];
121   }
122 
123 }
124 
125 contract TalentToken is BasicToken {
126 
127 using SafeMath for uint256;
128 
129 string public name = "Talent Token";              
130 string public symbol = "TAL";                               // Token's Symbol
131 uint8 public decimals = 18;                                 // How Many Decimals for Token
132 uint256 public totalSupply = 98000000 * 10**18;             // The total supply.
133 
134 // variables
135 uint256 public TotalTokens;                // variable to keep track of funds allocated
136 uint256 public LongTermProjectTokens;      // Funds to be used in the long term for the development of future projects.
137 uint256 public TeamFundsTokens;            // Funds for the team.
138 uint256 public IcoTokens;                  // Funds to be used for the ICO
139 uint256 public platformTokens;             // Tokens to be retained for future sale by various platforms.
140 
141 // addresses    
142 address public owner;                               // Owner of the Contract
143 address public crowdFundAddress;                    // Crowdfund Contract Address
144 address public founderAddress = 0xe3f38940A588922F2082FE30bCAe6bB0aa633a7b;
145 address public LongTermProjectTokensAddress = 0x689Aff79dCAbdFd611273703C62821baBb39823a;
146 address public teamFundsAddress = 0x2dd75A9A6C99B824811e3aCe16a63882Ff4C1C03;
147 address public platformTokensAddress = 0x5F0Be8081692a3A96d2ad10Ae5ce14488a045B10;
148 
149 //events
150 
151 event ChangeFoundersWalletAddress(uint256  _blockTimeStamp, address indexed _foundersWalletAddress);
152 
153 //modifiers
154 
155   modifier onlyCrowdFundAddress() {
156     require(msg.sender == crowdFundAddress);
157     _;
158   }
159 
160   modifier nonZeroAddress(address _to) {
161     require(_to != 0x0);
162     _;
163   }
164 
165   modifier onlyFounders() {
166     require(msg.sender == founderAddress);
167     _;
168   }
169   
170    // creation of the token contract 
171    function TalentToken (address _crowdFundAddress) {
172     owner = msg.sender;
173     crowdFundAddress = _crowdFundAddress;
174 
175     // Token Distribution 
176     LongTermProjectTokens = 22540000 * 10**18;    // 23 % allocation of totalSupply. Used for further development of projects.
177     TeamFundsTokens = 1960000 * 10**18;           // 2% of total tokens.
178     platformTokens = 19600000 * 10**18;           // 20% of total tokens.
179     IcoTokens = 53900000 * 10**18;                // ICO Tokens = 55% allocation of totalSupply
180 
181     //Assigned budget
182     balances[crowdFundAddress] = IcoTokens;
183     balances[LongTermProjectTokensAddress] = LongTermProjectTokens;
184     balances[teamFundsAddress] = TeamFundsTokens;
185     balances[platformTokensAddress] = platformTokens;
186 
187   }
188 
189 
190 // fallback function to restrict direct sending of ether
191   function () {
192     revert();
193   }
194 
195 }
196 
197 contract TalentICO {
198 
199     using SafeMath for uint256;
200     
201     TalentToken public token;                                 // Token contract reference
202          
203     uint256 public IcoStartDate = 1519862400;                 // March 1st, 2018, 00:00:00
204     uint256 public IcoEndDate = 1546300799;                   // 31st Dec, 11:59:59
205     uint256 public WeiRaised;                                 // Counter to track the amount raised
206     uint256 public initialExchangeRateForETH = 15000;         // Initial Number of Token per Ether
207     uint256 internal IcoTotalTokensSold = 0;
208     uint256 internal minAmount = 1 * 10 ** 17;                //The minimum amount to trade.
209     bool internal isTokenDeployed = false;                    // Flag to track the token deployment -- only can be set once
210 
211 
212      // Founder's Address
213     address public founderAddress = 0xe3f38940A588922F2082FE30bCAe6bB0aa633a7b;                            
214     // Owner of the contract
215     address public owner;                                              
216     
217     enum State {Crowdfund, Finish}
218 
219     //events
220     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount); 
221     event CrowdFundClosed(uint256 _blockTimeStamp);
222     event ChangeFoundersWalletAddress(uint256 _blockTimeStamp, address indexed _foundersWalletAddress);
223    
224     //Modifiers
225     modifier tokenIsDeployed() {
226         require(isTokenDeployed == true);
227         _;
228     }
229     modifier nonZeroEth() {
230         require(msg.value > 0);
231         _;
232     }
233 
234     modifier nonZeroAddress(address _to) {
235         require(_to != 0x0);
236         _;
237     }
238 
239     modifier onlyFounders() {
240         require(msg.sender == founderAddress);
241         _;
242     }
243 
244     modifier onlyOwner() {
245         require(msg.sender == owner);
246         _;
247     }
248 
249     modifier onlyPublic() {
250         require(msg.sender != founderAddress);
251         _;
252     }
253 
254     modifier inState(State state) {
255         require(getState() == state); 
256         _;
257     }
258 
259      // Constructor
260     function TalentICO () {
261         owner = msg.sender;
262     }
263 
264     function changeOwner(address newOwner) public onlyOwner returns (bool) {
265         owner = newOwner;
266     }
267 
268     // Used to attach the token's contract.
269     function setTokenAddress(address _tokenAddress) external onlyFounders nonZeroAddress(_tokenAddress) {
270         require(isTokenDeployed == false);
271         token = TalentToken(_tokenAddress);
272         isTokenDeployed = true;
273     }
274 
275 
276     // Used to change founder's address.
277      function setfounderAddress(address _newFounderAddress) onlyFounders  nonZeroAddress(_newFounderAddress) {
278         founderAddress = _newFounderAddress;
279         ChangeFoundersWalletAddress(now, founderAddress);
280     }
281 
282     // function call after ICO ends.
283     // Transfers Remaining Tokens to holder.
284     function ICOend() onlyFounders inState(State.Finish) returns (bool) {
285         require(now > IcoEndDate);
286         uint256 remainingToken = token.balanceOf(this);  // remaining tokens
287         if (remainingToken != 0) 
288           token.transfer(founderAddress, remainingToken); 
289         CrowdFundClosed(now);
290         return true; 
291     }
292 
293     // Allows users to buy tokens.
294     function buyTokens(address beneficiary) 
295     nonZeroEth 
296     tokenIsDeployed 
297     onlyPublic 
298     nonZeroAddress(beneficiary) 
299     payable 
300     returns(bool) 
301     {
302         require(msg.value >= minAmount);
303 
304         require(now >= IcoStartDate && now <= IcoEndDate);
305         fundTransfer(msg.value);
306 
307         uint256 amount = numberOfTokens(getCurrentExchangeRate(), msg.value);
308             
309         if (token.transfer(beneficiary, amount)) {
310             IcoTotalTokensSold = IcoTotalTokensSold.add(amount);
311             WeiRaised = WeiRaised.add(msg.value);
312             TokenPurchase(beneficiary, msg.value, amount);
313             return true;
314         } 
315 
316     return false;
317        
318     }
319 
320     // Function determines current exchange rate.
321     // This increases the price of the token, as time passes.
322     function getCurrentExchangeRate() internal view returns (uint256) {
323 
324         uint256 timeDiff = IcoEndDate - IcoStartDate;
325 
326         uint256 etherDiff = 11250; //Difference of exchange rate between start date and end date.
327 
328         uint256 initialTimeDiff = now - IcoStartDate;
329 
330         uint256 exchangeRateLess = (initialTimeDiff * etherDiff) / timeDiff;
331 
332         return (initialExchangeRateForETH - exchangeRateLess);    
333 
334     }
335            
336 
337 // Calculates total number of tokens.
338     function numberOfTokens(uint256 _exchangeRate, uint256 _amount) internal constant returns (uint256) {
339          uint256 noOfToken = _amount.mul(_exchangeRate);
340          return noOfToken;
341     }
342 
343     // Transfers funds to founder's account.
344     function fundTransfer(uint256 weiAmount) internal {
345         founderAddress.transfer(weiAmount);
346     }
347 
348 
349 // Get functions 
350 
351     // Gets the current state of the crowdsale
352     function getState() public constant returns(State) {
353 
354         if (now >= IcoStartDate && now <= IcoEndDate) {
355             return State.Crowdfund;
356         } 
357         return State.Finish;
358     }
359 
360     // GET functions
361 
362     function getExchangeRate() public constant returns (uint256 _exchangeRateForETH) {
363 
364         return getCurrentExchangeRate();
365     
366     }
367 
368     function getNoOfSoldToken() public constant returns (uint256 _IcoTotalTokensSold) {
369         return (IcoTotalTokensSold);
370     }
371 
372     function getWeiRaised() public constant returns (uint256 _WeiRaised) {
373         return WeiRaised;
374     }
375 
376     //Sends ether to founder's address.
377     function() public payable {
378         buyTokens(msg.sender);
379     }
380 }