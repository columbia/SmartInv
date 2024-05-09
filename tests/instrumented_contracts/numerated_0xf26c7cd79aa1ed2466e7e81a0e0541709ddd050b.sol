1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Crowdsale
5  * @dev Crowdsale is a base contract for managing a token crowdsale.
6  * Crowdsales have a start and end timestamps, where investors can make
7  * token purchases and the crowdsale will assign them tokens based
8  * on a token per ETH rate. Funds collected are forwarded to a wallet
9  * as they arrive.
10  */
11  
12  
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20  function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() public {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82   uint256 public totalSupply;
83   function balanceOf(address who) constant public returns (uint256);
84   function transfer(address to, uint256 value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 /**
89  * @title Basic token
90  * @dev Basic version of StandardToken, with no allowances.
91  */
92 contract BasicToken is ERC20Basic {
93   using SafeMath for uint256;
94 
95   mapping(address => uint256) tokenBalances;
96 
97   /**
98   * @dev transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(tokenBalances[msg.sender]>=_value);
104     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
105     tokenBalances[_to] = tokenBalances[_to].add(_value);
106     Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of.
113   * @return An uint256 representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) constant public returns (uint256 balance) {
116     return tokenBalances[_owner];
117   }
118 
119 }
120 
121 contract BTC20Token is BasicToken,Ownable {
122 
123    using SafeMath for uint256;
124    
125    //TODO: Change the name and the symbol
126    string public constant name = "BTC20";
127    string public constant symbol = "BTC20";
128    uint256 public constant decimals = 18;
129 
130    uint256 public constant INITIAL_SUPPLY = 21000000;
131    event Debug(string message, address addr, uint256 number);
132   /**
133    * @dev Contructor that gives msg.sender all of existing tokens.
134    */
135     function BTC20Token(address wallet) public {
136         owner = msg.sender;
137         totalSupply = INITIAL_SUPPLY * 10 ** 18;
138         tokenBalances[wallet] = totalSupply;   //Since we divided the token into 10^18 parts
139     }
140 
141     function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
142       require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell
143       tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance
144       tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance
145       Transfer(wallet, buyer, tokenAmount); 
146     }
147   function showMyTokenBalance(address addr) public view returns (uint tokenBalance) {
148         tokenBalance = tokenBalances[addr];
149     }
150 }
151 contract BTC20Crowdsale {
152   using SafeMath for uint256;
153  
154   // The token being sold
155   BTC20Token public token;
156 
157   // start and end timestamps where investments are allowed (both inclusive)
158   uint256 public startTime;
159   uint256 public endTime;
160 
161   // address where funds are collected
162   // address where tokens are deposited and from where we send tokens to buyers
163   address public wallet;
164 
165   // how many token units a buyer gets per wei
166   uint256 public ratePerWei = 50000;
167 
168   // amount of raised money in wei
169   uint256 public weiRaised;
170 
171   uint256 TOKENS_SOLD;
172   uint256 maxTokensToSale = 15000000 * 10 ** 18;
173   uint256 minimumContribution = 5 * 10 ** 16; //0.05 is the minimum contribution
174 
175   /**
176    * event for token purchase logging
177    * @param purchaser who paid for the tokens
178    * @param beneficiary who got the tokens
179    * @param value weis paid for purchase
180    * @param amount amount of tokens purchased
181    */
182   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
183 
184 
185   function BTC20Crowdsale(uint256 _startTime, address _wallet) public 
186   {
187     startTime = _startTime;   
188     endTime = startTime + 14 days;
189     
190     require(endTime >= startTime);
191     require(_wallet != 0x0);
192 
193     wallet = _wallet;
194     token = createTokenContract(wallet);
195     
196   }
197   // creates the token to be sold.
198   function createTokenContract(address wall) internal returns (BTC20Token) {
199     return new BTC20Token(wall);
200   }
201 
202 
203   // fallback function can be used to buy tokens
204   function () public payable {
205     buyTokens(msg.sender);
206   }
207 
208   //determine the rate of the token w.r.t. time elapsed
209   function determineBonus(uint tokens) internal view returns (uint256 bonus) {
210     uint256 timeElapsed = now - startTime;
211     uint256 timeElapsedInWeeks = timeElapsed.div(7 days);
212     if (timeElapsedInWeeks == 0)
213     {
214       bonus = tokens.mul(50); //50% bonus
215       bonus = bonus.div(100);
216     }
217     else if (timeElapsedInWeeks == 1)
218     {
219       bonus = tokens.mul(25); //25% bonus
220       bonus = bonus.div(100);
221     }
222     else
223     {
224         bonus = 0;   //No tokens to be transferred - ICO time is over
225     }
226   }
227 
228   // low level token purchase function
229   // Minimum purchase can be of 1 ETH
230   
231   function buyTokens(address beneficiary) public payable {
232     require(beneficiary != 0x0);
233     require(validPurchase());
234     require(msg.value>= minimumContribution);
235     require(TOKENS_SOLD<maxTokensToSale);
236     uint256 weiAmount = msg.value;
237     
238     // calculate token amount to be created
239     
240     uint256 tokens = weiAmount.mul(ratePerWei);
241     uint256 bonus = determineBonus(tokens);
242     tokens = tokens.add(bonus);
243     require(TOKENS_SOLD+tokens<=maxTokensToSale);
244     
245     // update state
246     weiRaised = weiRaised.add(weiAmount);
247 
248     token.mint(wallet, beneficiary, tokens); 
249     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
250     TOKENS_SOLD = TOKENS_SOLD.add(tokens);
251     forwardFunds();
252   }
253 
254   // send ether to the fund collection wallet
255   // override to create custom fund forwarding mechanisms
256   function forwardFunds() internal {
257     wallet.transfer(msg.value);
258   }
259 
260   // @return true if the transaction can buy tokens
261   function validPurchase() internal constant returns (bool) {
262     bool withinPeriod = now >= startTime && now <= endTime;
263     bool nonZeroPurchase = msg.value != 0;
264     return withinPeriod && nonZeroPurchase;
265   }
266 
267   // @return true if crowdsale event has ended
268   function hasEnded() public constant returns (bool) {
269     return now > endTime;
270   }
271   
272    
273     function changeEndDate(uint256 endTimeUnixTimestamp) public returns(bool) {
274         require (msg.sender == wallet);
275         endTime = endTimeUnixTimestamp;
276     }
277     function changeStartDate(uint256 startTimeUnixTimestamp) public returns(bool) {
278         require (msg.sender == wallet);
279         startTime = startTimeUnixTimestamp;
280     }
281     function setPriceRate(uint256 newPrice) public returns (bool) {
282         require (msg.sender == wallet);
283         ratePerWei = newPrice;
284     }
285     
286     function changeMinimumContribution(uint256 minContribution) public returns (bool) {
287         require (msg.sender == wallet);
288         minimumContribution = minContribution * 10 ** 15;
289     }
290 }