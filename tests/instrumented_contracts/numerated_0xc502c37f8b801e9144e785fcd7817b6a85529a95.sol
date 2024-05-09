1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() public {
61     owner = msg.sender;
62   }
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) public onlyOwner {
77     require(newOwner != address(0));
78     OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 contract DragonToken{
85   function transferFrom(address _from, address _to, uint256 _value) returns(bool success);
86 }
87 
88 /**
89  * @title Crowdsale
90  * @dev Crowdsale is a base contract for managing a token crowdsale.
91  * Crowdsales have a start and end timestamps, where investors can make
92  * token purchases and the crowdsale will assign them tokens based
93  * on a token per ETH rate. Funds collected are forwarded to a wallet
94  * as they arrive. The contract requires a MintableToken that will be
95  * minted as contributions arrive, note that the crowdsale contract
96  * must be owner of the token in order to be able to mint it.
97  */
98 contract Crowdsale is Ownable{
99   using SafeMath for uint256;
100 
101   // The token being sold
102   DragonToken public token;
103   
104   // The address of token reserves
105   address public tokenReserve;
106 
107   // start and end timestamps where investments are allowed (both inclusive)
108   uint256 public startTime;
109   uint256 public endTime;
110 
111   // address where funds are collected
112   address public wallet;
113 
114   // token rate in wei
115   uint256 public rate;
116 
117   // amount of raised money in wei
118   uint256 public weiRaised;
119   
120   uint256 public tokensSold;
121 
122   /**
123    * event for token purchase logging
124    * @param purchaser who paid for the tokens
125    * @param beneficiary who got the tokens
126    * @param value weis paid for purchase
127    * @param amount amount of tokens purchased
128    * @param releaseTime tokens unlock time
129    */
130   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount, uint256 releaseTime);
131   
132   /**
133    * event upon endTime updated
134    */
135   event EndTimeUpdated();
136   
137   /**
138    * Dragon token price updated
139    */
140   event DragonPriceUpdated();
141   
142   /**
143    * event for token releasing
144    * @param holder who is releasing his tokens
145    */
146   event TokenReleased(address indexed holder, uint256 amount);
147 
148 
149   function Crowdsale() public {
150   
151     owner = 0xF615Ac471E066b5ae4BD211CC5044c7a31E89C4e; // overriding owner
152     startTime = now;
153     endTime = 1521187200;
154     rate = 5000000000000000; // price in wei
155     wallet = 0xF615Ac471E066b5ae4BD211CC5044c7a31E89C4e;
156     token = DragonToken(0x814F67fA286f7572B041D041b1D99b432c9155Ee);
157     tokenReserve = 0xF615Ac471E066b5ae4BD211CC5044c7a31E89C4e;
158   }
159 
160   // fallback function can be used to buy tokens
161   function () external payable {
162     buyTokens(msg.sender);
163   }
164 
165   // low level token purchase function
166   function buyTokens(address beneficiary) public payable {
167     require(beneficiary != address(0));
168     require(validPurchase());
169 
170     uint256 weiAmount = msg.value;
171 
172     // calculate token amount to be created
173     uint256 tokens = getTokenAmount(weiAmount);
174 
175     // update state
176     weiRaised = weiRaised.add(weiAmount);
177     tokensSold = tokensSold.add(tokens);
178 
179     uint256 lockedFor = assignTokens(beneficiary, tokens);
180     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens, lockedFor);
181 
182     forwardFunds();
183   }
184 
185   // @return true if crowdsale event has ended
186   function hasEnded() public view returns (bool) {
187     return now > endTime;
188   }
189 
190   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
191     uint256 amount = weiAmount.div(rate);
192     return amount.mul(100000000); // multiply with decimals
193   }
194 
195   // send ether to the fund collection wallet
196   function forwardFunds() internal {
197     wallet.transfer(msg.value);
198   }
199 
200   // @return true if the transaction can buy tokens
201   function validPurchase() internal view returns (bool) {
202     bool withinPeriod = now >= startTime && now <= endTime;
203     bool nonZeroPurchase = msg.value != 0;
204     return withinPeriod && nonZeroPurchase;
205   }
206 
207   function updateEndTime(uint256 newTime) onlyOwner external {
208     require(newTime > startTime);
209     endTime = newTime;
210     EndTimeUpdated();
211   }
212   
213   function updateDragonPrice(uint256 weiAmount) onlyOwner external {
214     require(weiAmount > 0);
215     rate = weiAmount;
216     DragonPriceUpdated();
217   }
218   
219   mapping(address => uint256) balances;
220   mapping(address => uint256) releaseTime;
221   function assignTokens(address beneficiary, uint256 amount) private returns(uint256 lockedFor){
222       lockedFor = now + 45 days;
223       balances[beneficiary] = balances[beneficiary].add(amount);
224       releaseTime[beneficiary] = lockedFor;
225   }
226   
227   /**
228   * @dev Gets the balance of the specified address.
229   * @param _owner The address to query the the balance of.
230   * @return An uint256 representing the amount owned by the passed address.
231   */
232   function balanceOf(address _owner) public view returns (uint256 balance) {
233     return balances[_owner];
234   }
235   
236 
237   function unlockTime(address _owner) public view returns (uint256 time) {
238     return releaseTime[_owner];
239   }
240 
241   /**
242    * @notice Transfers tokens held by timelock to beneficiary.
243    */
244   function releaseDragonTokens() public {
245     require(now >= releaseTime[msg.sender]);
246     
247     uint256 amount = balances[msg.sender];
248     require(amount > 0);
249     
250     balances[msg.sender] = 0;
251     if(!token.transferFrom(tokenReserve,msg.sender,amount)){
252         revert();
253     }
254 
255     TokenReleased(msg.sender,amount);
256   }
257   
258 }