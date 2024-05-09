1 pragma solidity ^0.4.14;
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
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() {
49     owner = msg.sender;
50   }
51 
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) onlyOwner {
67     require(newOwner != address(0));      
68     owner = newOwner;
69   }
70 
71 }
72 
73 
74 interface GlobexSci {
75   function totalSupply() constant returns (uint256 totalSupply);
76   function balanceOf(address _owner) constant returns (uint256 balance);
77   function transfer(address _to, uint256 _value) returns (bool success);
78   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
79   function approve(address _spender, uint256 _value) returns (bool success);
80   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
81 }
82 
83 
84 /**
85  * @title  
86  * @dev DatCrowdSale is a contract for managing a token crowdsale.
87  * GlobexSciCrowdSale have a start and end date, where investors can make
88  * token purchases and the crowdsale will assign them tokens based
89  * on a token per ETH rate. Funds collected are forwarded to a refundable valut 
90  * as they arrive.
91  */
92 contract GlobexSciICO is Ownable {
93   using SafeMath for uint256;
94 
95   // The token being sold
96   GlobexSci public token = GlobexSci(0x88dBd3f9E6809FC24d27B9403371Af1cC089ba9e);
97 
98   // start and end date where investments are allowed (both inclusive)
99   uint256 public startDate = 1524182400; //Wed, 20 Apr 2018 00:00:00 +0000
100   
101   // Minimum amount to participate
102   uint256 public minimumParticipationAmount = 100000000000000000 wei; //0.1 ether
103 
104   // address where funds are collected
105   address wallet;
106 
107   // how many token units a buyer gets per ether
108   uint256 rate = 500;
109 
110   // amount of raised money in wei
111   uint256 public weiRaised;
112 
113   //flag for final of crowdsale
114   bool public isFinalized = false;
115 
116   //cap for the sale
117   uint256 public cap = 60000000000000000000000 wei; //60000 ether
118  
119     uint week1 = 1 * 7 * 1 days;
120     uint week2 = 2 * 7 * 1 days;
121     uint week3 = 3 * 7 * 1 days;
122     uint week4 = 4 * 7 * 1 days;
123     uint week5 = 5 * 7 * 1 days;
124 
125   event Finalized();
126 
127   /**
128    * event for token purchase logging
129    * @param purchaser who paid for the tokens
130    * @param beneficiary who got the tokens
131    * @param value weis paid for purchase
132    * @param amount amount of tokens purchased
133    */ 
134   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
135 
136 
137   /**
138   * @notice Log an event for each funding contributed during the public phase
139   * @notice Events are not logged when the constructor is being executed during
140   *         deployment, so the preallocations will not be logged
141   */
142   event LogParticipation(address indexed sender, uint256 value, uint256 timestamp);
143 
144 
145   
146   function GlobexSciICO() {
147     wallet = msg.sender;
148   }
149 
150     //When a user buys our token they will recieve:,
151     //    - Week 1 - they will recieve 25% bonus
152     //    - Week 2 - they will revieve 15% bonus
153     //    - Week 3 - They will recieve 10% bonus
154     //    - Week 4 - they will recieve no bonus
155     //    - Week 5 - they will recieve no bonus
156   function getBonus() constant returns (uint256 price) {
157         uint currentDate = now;
158 
159         if (currentDate < startDate + week1) {
160             return 25;
161         }
162 
163         if (currentDate > startDate + week1 && currentDate < startDate + week2) {
164             return 20;
165         }
166 
167         if (currentDate > startDate + week2 && currentDate < startDate + week3) {
168             return 15;
169         }
170         if (currentDate > startDate + week3 && currentDate < startDate + week4) {
171             return 10;
172         }
173         if (currentDate > startDate + week4 && currentDate < startDate + week5) {
174             return 5;
175         }
176         return 0; 
177     }
178   
179 
180   // fallback function can be used to buy tokens
181   function () payable {
182     buyTokens(msg.sender);
183   }
184 
185   // low level token purchase function
186   function buyTokens(address beneficiary) payable {
187     require(beneficiary != 0x0);
188     require(validPurchase());
189 
190     //get ammount in wei
191     uint256 weiAmount = msg.value;
192 
193     // calculate token amount to be created
194     uint256 tokens = weiAmount.mul(rate);
195     uint bonus = getBonus();
196     tokens = tokens + tokens * bonus / 100;
197 
198     //purchase tokens and transfer to beneficiary
199     token.transfer(beneficiary, tokens);
200 
201     // update state
202     weiRaised = weiRaised.add(weiAmount);
203 
204     //Token purchase event
205     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
206 
207     //forward funds to wallet
208     forwardFunds();
209   }
210 
211 
212   // send ether to the fund collection wallet
213   // override to create custom fund forwarding mechanisms
214   function forwardFunds() internal {
215     wallet.transfer(msg.value);
216   }
217 
218   // should be called after crowdsale ends or to emergency stop the sale
219   function finalize() onlyOwner {
220     require(!isFinalized);
221     uint256 unsoldTokens = token.balanceOf(this);
222     token.transfer(wallet, unsoldTokens);
223     isFinalized = true;
224     Finalized();
225   }
226 
227 
228   // @return true if the transaction can buy tokens
229   // check for valid time period, min amount and within cap
230   function validPurchase() internal constant returns (bool) {
231     bool withinPeriod = startDate <= now;
232     bool nonZeroPurchase = msg.value != 0;
233     bool minAmount = msg.value >= minimumParticipationAmount;
234     bool withinCap = weiRaised.add(msg.value) <= cap;
235 
236     return withinPeriod && nonZeroPurchase && minAmount && !isFinalized && withinCap;
237   }
238 
239     // @return true if the goal is reached
240   function capReached() public constant returns (bool) {
241     return weiRaised >= cap;
242   }
243 
244   // @return true if crowdsale event has ended
245   function hasEnded() public constant returns (bool) {
246     return isFinalized;
247   }
248 
249 }