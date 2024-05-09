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
121 contract DRIVRNetworkToken is BasicToken,Ownable {
122 
123    using SafeMath for uint256;
124    
125    string public constant name = "DRIVR Network";
126    string public constant symbol = "DVR";
127    uint256 public constant decimals = 18;
128 
129    uint256 public constant INITIAL_SUPPLY = 750000000;
130   /**
131    * @dev Contructor that gives msg.sender all of existing tokens.
132    */
133     function DRIVRNetworkToken(address wallet) public {
134         owner = msg.sender;
135         totalSupply = INITIAL_SUPPLY * 10 ** 18;
136         tokenBalances[wallet] = totalSupply;   //Since we divided the token into 10^18 parts
137     }
138 
139     function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
140       require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell
141       tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance
142       tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance
143       Transfer(wallet, buyer, tokenAmount); 
144       totalSupply = totalSupply.sub(tokenAmount);
145     }
146     function showMyTokenBalance(address addr) public view returns (uint tokenBalance) {
147         tokenBalance = tokenBalances[addr];
148     }
149 }
150 contract DrivrCrowdsale {
151   using SafeMath for uint256;
152  
153   // The token being sold
154   DRIVRNetworkToken public token;
155 
156   // start and end timestamps where investments are allowed (both inclusive)
157   uint256 public startTime;
158   uint256 public endTime;
159 
160   // address where funds are collected
161   // address where tokens are deposited and from where we send tokens to buyers
162   address public wallet;
163 
164   // how many token units a buyer gets per wei
165   uint256 public ratePerWei = 20000;
166 
167   // amount of raised money in wei
168   uint256 public weiRaised;
169   uint256 public duration = 75 days; //2 weeks and 2 months are 75 days
170   uint256 TOKENS_SOLD;
171   uint256 maxTokensToSaleInPrivateInvestmentPhase = 172500000 * 10 ** 18;
172   uint256 maxTokensToSaleInPreICOPhase = 392500000 * 10 ** 18;
173   uint256 maxTokensToSaleInICOPhase = 655000000 * 10 ** 18;
174   uint256 maxTokensToSale = 655000000 * 10 ** 18;
175   
176   
177   /**
178    * event for token purchase logging
179    * @param purchaser who paid for the tokens
180    * @param beneficiary who got the tokens
181    * @param value weis paid for purchase
182    * @param amount amount of tokens purchased
183    */
184   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
185   event Debug(string message);
186 
187   function DrivrCrowdsale(uint256 _startTime, address _wallet) public 
188   {
189     require(_startTime >= now);
190     startTime = _startTime;   
191     endTime = startTime + duration;
192     
193     require(endTime >= startTime);
194     require(_wallet != 0x0);
195 
196     wallet = _wallet;
197     token = createTokenContract(wallet);
198   }
199   
200   // creates the token to be sold.
201   function createTokenContract(address wall) internal returns (DRIVRNetworkToken) {
202     return new DRIVRNetworkToken(wall);
203   }
204 
205   // fallback function can be used to buy tokens
206   function () public payable {
207     buyTokens(msg.sender);
208   }
209 
210     function determineBonus(uint tokens) internal view returns (uint256 bonus) 
211     {
212         uint256 timeElapsed = now - startTime;
213         uint256 timeElapsedInDays = timeElapsed.div(1 days);
214         if (timeElapsedInDays <15)
215         {
216             if (TOKENS_SOLD < maxTokensToSaleInPrivateInvestmentPhase)
217             {
218                 //15% bonus
219                 bonus = tokens.mul(15); //15% bonus
220                 bonus = bonus.div(100);
221                 require (TOKENS_SOLD + tokens + bonus <= maxTokensToSaleInPrivateInvestmentPhase);
222             }
223             else if (TOKENS_SOLD >= maxTokensToSaleInPrivateInvestmentPhase && TOKENS_SOLD < maxTokensToSaleInPreICOPhase)
224             {
225                 bonus = tokens.mul(10); //10% bonus
226                 bonus = bonus.div(100);
227                 require (TOKENS_SOLD + tokens + bonus <= maxTokensToSaleInPreICOPhase);
228             }
229             else if (TOKENS_SOLD >= maxTokensToSaleInPreICOPhase && TOKENS_SOLD < maxTokensToSaleInICOPhase)
230             {
231                 bonus = tokens.mul(5); //5% bonus
232                 bonus = bonus.div(100);
233                 require (TOKENS_SOLD + tokens + bonus <= maxTokensToSaleInICOPhase);
234             }
235             else 
236             {
237                 bonus = 0;
238             }
239         }
240         else if (timeElapsedInDays >= 15 && timeElapsedInDays<43)
241         {
242             if (TOKENS_SOLD < maxTokensToSaleInPreICOPhase)
243             {
244                 bonus = tokens.mul(10); //10% bonus
245                 bonus = bonus.div(100);
246                 require (TOKENS_SOLD + tokens + bonus <= maxTokensToSaleInPreICOPhase);
247             }
248             else if (TOKENS_SOLD >= maxTokensToSaleInPreICOPhase && TOKENS_SOLD < maxTokensToSaleInICOPhase)
249             {
250                 bonus = tokens.mul(5); //5% bonus
251                 bonus = bonus.div(100);
252                 require (TOKENS_SOLD + tokens + bonus <= maxTokensToSaleInICOPhase);
253             }
254             else 
255             {
256                 bonus = 0;
257             }
258         }
259         else if (timeElapsedInDays >= 43 && timeElapsedInDays<=75)
260         {
261             if (TOKENS_SOLD < maxTokensToSaleInICOPhase)
262             {
263                 bonus = tokens.mul(5); //5% bonus
264                 bonus = bonus.div(100);
265                 require (TOKENS_SOLD + tokens + bonus <= maxTokensToSaleInICOPhase);
266             }
267             else 
268             {
269                 bonus = 0;
270             }
271         }
272         else 
273         {
274             bonus = 0;
275         }
276     }
277   // low level token purchase function
278   // Minimum purchase can be of 1 ETH
279   
280   function buyTokens(address beneficiary) public payable {
281     
282     require(beneficiary != 0x0 && validPurchase() && TOKENS_SOLD<maxTokensToSale);
283     require(msg.value >= 1 * 10 ** 17);
284     uint256 weiAmount = msg.value;
285     
286     // calculate token amount to be created
287     
288     uint256 tokens = weiAmount.mul(ratePerWei);
289     uint256 bonus = determineBonus(tokens);
290     tokens = tokens.add(bonus);
291     require(TOKENS_SOLD+tokens<=maxTokensToSale);
292     
293     // update state
294     weiRaised = weiRaised.add(weiAmount);
295     token.mint(wallet, beneficiary, tokens); 
296     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
297     TOKENS_SOLD = TOKENS_SOLD.add(tokens);
298     forwardFunds();
299   }
300 
301   // send ether to the fund collection wallet
302   // override to create custom fund forwarding mechanisms
303   function forwardFunds() internal {
304     wallet.transfer(msg.value);
305   }
306 
307   // @return true if the transaction can buy tokens
308   function validPurchase() internal constant returns (bool) {
309     bool withinPeriod = now >= startTime && now <= endTime;
310     bool nonZeroPurchase = msg.value != 0;
311     return withinPeriod && nonZeroPurchase;
312   }
313 
314   // @return true if crowdsale event has ended
315   function hasEnded() public constant returns (bool) {
316     return now > endTime;
317   }
318   
319     function setPriceRate(uint256 newPrice) public returns (bool) {
320         require (msg.sender == wallet);
321         ratePerWei = newPrice;
322     }
323 }