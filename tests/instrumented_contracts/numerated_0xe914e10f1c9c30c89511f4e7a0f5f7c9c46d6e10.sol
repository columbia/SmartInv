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
92 contract GlobexSciPreSale is Ownable {
93   using SafeMath for uint256;
94 
95   // The token being sold
96   GlobexSci public token = GlobexSci(0x88dBd3f9E6809FC24d27B9403371Af1cC089ba9e);
97 
98   // start and end date where investments are allowed (both inclusive)
99   uint256 public startDate = 1517961600; //Wed, 07 Feb 2018 00:00:00 +0000
100   uint256 public endDate = 1520380800; //Web, 07 Mar 2018 00:00:00 +0000
101 
102   // Minimum amount to participate
103   uint256 public minimumParticipationAmount = 100000000000000000 wei; //0.1 ether
104 
105   // address where funds are collected
106   address wallet;
107 
108   // how many token units a buyer gets per ether
109   uint256 rate = 650;
110 
111   // amount of raised money in wei
112   uint256 public weiRaised;
113 
114   //flag for final of crowdsale
115   bool public isFinalized = false;
116 
117   //cap for the sale
118   uint256 public cap = 3076920000000000000000 wei; //3076 ether
119  
120 
121 
122   event Finalized();
123 
124   /**
125    * event for token purchase logging
126    * @param purchaser who paid for the tokens
127    * @param beneficiary who got the tokens
128    * @param value weis paid for purchase
129    * @param amount amount of tokens purchased
130    */ 
131   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
132 
133 
134   /**
135   * @notice Log an event for each funding contributed during the public phase
136   * @notice Events are not logged when the constructor is being executed during
137   *         deployment, so the preallocations will not be logged
138   */
139   event LogParticipation(address indexed sender, uint256 value, uint256 timestamp);
140 
141 
142   
143   function GlobexSciPreSale() {
144     wallet = msg.sender;
145   }
146 
147 
148   // fallback function can be used to buy tokens
149   function () payable {
150     buyTokens(msg.sender);
151   }
152 
153   // low level token purchase function
154   function buyTokens(address beneficiary) payable {
155     require(beneficiary != 0x0);
156     require(validPurchase());
157 
158     //get ammount in wei
159     uint256 weiAmount = msg.value;
160 
161     // calculate token amount to be created
162     uint256 tokens = weiAmount.mul(rate);
163 
164     //purchase tokens and transfer to beneficiary
165     token.transfer(beneficiary, tokens);
166 
167     // update state
168     weiRaised = weiRaised.add(weiAmount);
169 
170     //Token purchase event
171     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
172 
173     //forward funds to wallet
174     forwardFunds();
175   }
176 
177 
178   // send ether to the fund collection wallet
179   // override to create custom fund forwarding mechanisms
180   function forwardFunds() internal {
181     wallet.transfer(msg.value);
182   }
183 
184   // should be called after crowdsale ends or to emergency stop the sale
185   function finalize() onlyOwner {
186     require(!isFinalized);
187     uint256 unsoldTokens = token.balanceOf(this);
188     token.transfer(wallet, unsoldTokens);
189     isFinalized = true;
190     Finalized();
191   }
192 
193 
194   // @return true if the transaction can buy tokens
195   // check for valid time period, min amount and within cap
196   function validPurchase() internal constant returns (bool) {
197     bool withinPeriod = startDate <= now && endDate >= now;
198     bool nonZeroPurchase = msg.value != 0;
199     bool minAmount = msg.value >= minimumParticipationAmount;
200     bool withinCap = weiRaised.add(msg.value) <= cap;
201 
202     return withinPeriod && nonZeroPurchase && minAmount && !isFinalized && withinCap;
203   }
204 
205     // @return true if the goal is reached
206   function capReached() public constant returns (bool) {
207     return weiRaised >= cap;
208   }
209 
210   // @return true if crowdsale event has ended
211   function hasEnded() public constant returns (bool) {
212     return isFinalized;
213   }
214 
215 }