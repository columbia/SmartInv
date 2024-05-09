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
120   /**
121    * event for token purchase logging
122    * @param purchaser who paid for the tokens
123    * @param beneficiary who got the tokens
124    * @param value weis paid for purchase
125    * @param amount amount of tokens purchased
126    * @param releaseTime tokens unlock time
127    */
128   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount, uint256 releaseTime);
129   
130   /**
131    * event upon endTime updated
132    */
133   event EndTimeUpdated();
134   
135   /**
136    * Dragon token price updated
137    */
138   event DragonPriceUpdated();
139   
140   /**
141    * event for token releasing
142    * @param holder who is releasing his tokens
143    */
144   event TokenReleased(address indexed holder, uint256 amount);
145 
146 
147   function Crowdsale() public {
148   
149     owner = 0xF615Ac471E066b5ae4BD211CC5044c7a31E89C4e; // overriding owner
150     startTime = now;
151     endTime = 1521187200;
152     rate = 5000000000000000; // price in wei
153     wallet = 0xF615Ac471E066b5ae4BD211CC5044c7a31E89C4e;
154     token = DragonToken(0x814F67fA286f7572B041D041b1D99b432c9155Ee);
155     tokenReserve = 0xF615Ac471E066b5ae4BD211CC5044c7a31E89C4e;
156   }
157 
158   // fallback function can be used to buy tokens
159   function () external payable {
160     buyTokens(msg.sender);
161   }
162 
163   // low level token purchase function
164   function buyTokens(address beneficiary) public payable {
165     require(beneficiary != address(0));
166     require(validPurchase());
167 
168     uint256 weiAmount = msg.value;
169 
170     // calculate token amount to be created
171     uint256 tokens = getTokenAmount(weiAmount);
172 
173     // update state
174     weiRaised = weiRaised.add(weiAmount);
175 
176     uint256 lockedFor = assignTokens(beneficiary, tokens);
177     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens, lockedFor);
178 
179     forwardFunds();
180   }
181 
182   // @return true if crowdsale event has ended
183   function hasEnded() public view returns (bool) {
184     return now > endTime;
185   }
186 
187   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
188     uint256 amount = weiAmount.div(rate);
189     return amount.mul(100000000); // multiply with decimals
190   }
191 
192   // send ether to the fund collection wallet
193   function forwardFunds() internal {
194     wallet.transfer(msg.value);
195   }
196 
197   // @return true if the transaction can buy tokens
198   function validPurchase() internal view returns (bool) {
199     bool withinPeriod = now >= startTime && now <= endTime;
200     bool nonZeroPurchase = msg.value != 0;
201     return withinPeriod && nonZeroPurchase;
202   }
203 
204   function updateEndTime(uint256 newTime) onlyOwner external {
205     require(newTime > startTime);
206     endTime = newTime;
207     EndTimeUpdated();
208   }
209   
210   function updateDragonPrice(uint256 weiAmount) onlyOwner external {
211     require(weiAmount > 0);
212     rate = weiAmount;
213     DragonPriceUpdated();
214   }
215   
216   mapping(address => uint256) balances;
217   mapping(address => uint256) releaseTime;
218   function assignTokens(address beneficiary, uint256 amount) private returns(uint256 lockedFor){
219       lockedFor = now + 45 days;
220       balances[beneficiary] = balances[beneficiary].add(amount);
221       releaseTime[beneficiary] = lockedFor;
222   }
223   
224   /**
225   * @dev Gets the balance of the specified address.
226   * @param _owner The address to query the the balance of.
227   * @return An uint256 representing the amount owned by the passed address.
228   */
229   function balanceOf(address _owner) public view returns (uint256 balance) {
230     return balances[_owner].div(100000000);
231   }
232   
233 
234   function unlockTime(address _owner) public view returns (uint256 time) {
235     return releaseTime[_owner];
236   }
237 
238   /**
239    * @notice Transfers tokens held by timelock to beneficiary.
240    */
241   function releaseDragonTokens() public {
242     require(now >= releaseTime[msg.sender]);
243     
244     uint256 amount = balances[msg.sender];
245     require(amount > 0);
246     
247     balances[msg.sender] = 0;
248     if(!token.transferFrom(tokenReserve,msg.sender,amount)){
249         revert();
250     }
251 
252     TokenReleased(msg.sender,amount);
253   }
254   
255 }