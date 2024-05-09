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
120 //TODO: Change the name of the token
121 contract XrpcToken is BasicToken,Ownable {
122 
123    using SafeMath for uint256;
124    
125    //TODO: Change the name and the symbol
126    string public constant name = "XRPConnect";
127    string public constant symbol = "XRPC";
128    uint256 public constant decimals = 18;
129 
130    uint256 public constant INITIAL_SUPPLY = 10000000;
131    event Debug(string message, address addr, uint256 number);
132   /**
133    * @dev Contructor that gives msg.sender all of existing tokens.
134    */
135    //TODO: Change the name of the constructor
136     function XrpcToken(address wallet) public {
137         owner = msg.sender;
138         totalSupply = INITIAL_SUPPLY;
139         tokenBalances[wallet] = INITIAL_SUPPLY * 10 ** 18;   //Since we divided the token into 10^18 parts
140     }
141 
142     function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
143       require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell
144       tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance
145       tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance
146       Transfer(wallet, buyer, tokenAmount); 
147     }
148   function showMyTokenBalance(address addr) public view returns (uint tokenBalance) {
149         tokenBalance = tokenBalances[addr];
150     }
151 }
152 contract Crowdsale {
153   using SafeMath for uint256;
154  
155   // The token being sold
156   XrpcToken public token;
157 
158   // start and end timestamps where investments are allowed (both inclusive)
159   uint256 public startTime;
160   uint256 public endTime;
161 
162   // address where funds are collected
163   // address where tokens are deposited and from where we send tokens to buyers
164   address public wallet;
165 
166   // how many token units a buyer gets per wei
167   uint256 public rate;
168 
169   // amount of raised money in wei
170   uint256 public weiRaised;
171 
172 
173   // rates corresponding to each week in WEI not ETH (conversion is 1 ETH == 10^18 WEI)
174 
175   uint256 public week1Price = 2117;   
176   uint256 public week2Price = 1466;
177   uint256 public week3Price = 1121;
178   uint256 public week4Price = 907;
179   
180   bool ownerAmountPaid = false; 
181 
182   /**
183    * event for token purchase logging
184    * @param purchaser who paid for the tokens
185    * @param beneficiary who got the tokens
186    * @param value weis paid for purchase
187    * @param amount amount of tokens purchased
188    */
189   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
190 
191 
192   function Crowdsale(uint256 _startTime, address _wallet) public {
193     //TODO: Uncomment these before final deployment
194     require(_startTime >= now);
195     startTime = _startTime;
196     
197     //TODO: Comment this "startTime = now" before deployment -- this was for testing purposes only
198     //startTime = now;   
199     endTime = startTime + 30 days;
200     
201     require(endTime >= startTime);
202     require(_wallet != 0x0);
203 
204     wallet = _wallet;
205     token = createTokenContract(wallet);
206     
207   }
208 
209     function sendOwnerShares(address wal) public
210     {
211         require(msg.sender == wallet);
212         require(ownerAmountPaid == false);
213         uint256 ownerAmount = 350000*10**18;
214         token.mint(wallet, wal,ownerAmount);
215         ownerAmountPaid = true;
216     }
217   // creates the token to be sold.
218   // TODO: Change the name of the token
219   function createTokenContract(address wall) internal returns (XrpcToken) {
220     return new XrpcToken(wall);
221   }
222 
223 
224   // fallback function can be used to buy tokens
225   function () public payable {
226     buyTokens(msg.sender);
227   }
228 
229   //determine the rate of the token w.r.t. time elapsed
230   function determineRate() internal view returns (uint256 weekRate) {
231     uint256 timeElapsed = now - startTime;
232     uint256 timeElapsedInWeeks = timeElapsed.div(7 days);
233 
234     if (timeElapsedInWeeks == 0)
235       weekRate = week1Price;        //e.g. 3 days/7 days will be 0.4-- after truncation will be 0
236 
237     else if (timeElapsedInWeeks == 1)
238       weekRate = week2Price;        //e.g. 10 days/7 days will be 1.3 -- after truncation will be 1
239 
240     else if (timeElapsedInWeeks == 2)
241       weekRate = week3Price;        //e.g. 20 days/7 days will be 2.4 -- after truncation will be 2
242 
243     else if (timeElapsedInWeeks == 3)
244       weekRate = week4Price;        //e.g. 24 days/7 days will be 3.4 -- after truncation will be 3
245 
246     else
247     {
248         weekRate = 0;   //No tokens to be transferred - ICO time is over
249     }
250   }
251 
252   // low level token purchase function
253   // Minimum purchase can be of 1 ETH
254   
255   function buyTokens(address beneficiary) public payable {
256     require(beneficiary != 0x0);
257     require(validPurchase());
258 
259     uint256 weiAmount = msg.value;
260     //uint256 ethAmount = weiAmount.div(10 ** 18);
261 
262     // calculate token amount to be created
263     rate = determineRate();
264     uint256 tokens = weiAmount.mul(rate);
265 
266     // update state
267     weiRaised = weiRaised.add(weiAmount);
268 
269     token.mint(wallet, beneficiary, tokens); 
270     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
271 
272     forwardFunds();
273   }
274 
275   // send ether to the fund collection wallet
276   // override to create custom fund forwarding mechanisms
277   function forwardFunds() internal {
278     wallet.transfer(msg.value);
279   }
280 
281   // @return true if the transaction can buy tokens
282   function validPurchase() internal constant returns (bool) {
283     bool withinPeriod = now >= startTime && now <= endTime;
284     bool nonZeroPurchase = msg.value != 0;
285     return withinPeriod && nonZeroPurchase;
286   }
287 
288   // @return true if crowdsale event has ended
289   function hasEnded() public constant returns (bool) {
290     return now > endTime;
291   }
292     
293 }