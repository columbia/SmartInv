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
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title Ownable
74  * @dev The Ownable contract has an owner address, and provides basic authorization control
75  * functions, this simplifies the implementation of "user permissions".
76  */
77 contract Ownable {
78   address public owner;
79 
80 
81   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83 
84   /**
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86    * account.
87    */
88   function Ownable() public {
89     owner = msg.sender;
90   }
91 
92   /**
93    * @dev Throws if called by any account other than the owner.
94    */
95   modifier onlyOwner() {
96     require(msg.sender == owner);
97     _;
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address newOwner) public onlyOwner {
105     require(newOwner != address(0));
106     emit OwnershipTransferred(owner, newOwner);
107     owner = newOwner;
108   }
109 
110 }
111 
112 /**
113  * @title Pausable
114  * @dev Base contract which allows children to implement an emergency stop mechanism.
115  */
116 contract Pausable is Ownable {
117   event Pause();
118   event Unpause();
119 
120   bool public paused = false;
121 
122 
123   /**
124    * @dev Modifier to make a function callable only when the contract is not paused.
125    */
126   modifier whenNotPaused() {
127     require(!paused);
128     _;
129   }
130 
131   /**
132    * @dev Modifier to make a function callable only when the contract is paused.
133    */
134   modifier whenPaused() {
135     require(paused);
136     _;
137   }
138 
139   /**
140    * @dev called by the owner to pause, triggers stopped state
141    */
142   function pause() onlyOwner whenNotPaused public {
143     paused = true;
144     emit Pause();
145   }
146 
147   /**
148    * @dev called by the owner to unpause, returns to normal state
149    */
150   function unpause() onlyOwner whenPaused public {
151     paused = false;
152     emit Unpause();
153   }
154 }
155 
156 contract Bugis_Crowdsale is Pausable {
157   using SafeMath for uint256;
158 
159   
160   ERC20 public token;
161 
162   // Address where funds are collected
163   address public wallet;
164 
165   // How many token units a buyer gets per wei
166   uint256 public rate;
167 
168   // Amount of wei raised
169   uint256 public weiRaised;
170   
171   // Max amount of wei accepted in the crowdsale
172   uint256 public cap;
173   
174   // Min amount of wei an investor can send
175   uint256 public minInvest;
176   
177   // Crowdsale opening time
178   uint256 public openingTime;
179   
180   // Crowdsale closing time
181   uint256 public closingTime;
182 
183   /**
184    * Event for token purchase logging
185    * @param purchaser who paid for the tokens
186    * @param beneficiary who got the tokens
187    * @param value weis paid for purchase
188    * @param amount amount of tokens purchased
189    */
190   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
191 
192   function Bugis_Crowdsale() public {
193     rate = 1000;
194     wallet = owner;
195     token = ERC20(0x1cd74dD56b0929f1505c6e1f9Bdf57fb31D60631);
196     cap = 300 * 1 ether;
197     minInvest = 0.1 * 1 ether;
198     openingTime = 0;    // Defined by function start()
199     closingTime = 0;    // Defined by function start()
200   }
201 
202   // -----------------------------------------
203   // Crowdsale external interface
204   // -----------------------------------------
205 
206   /**
207    * @dev fallback function ***DO NOT OVERRIDE***
208    */
209   function () external payable {
210     buyTokens(msg.sender);
211   }
212 
213   /**
214    * @dev low level token purchase ***DO NOT OVERRIDE***
215    * @param _beneficiary Address performing the token purchase
216    */
217   function buyTokens(address _beneficiary) public payable {
218 
219     uint256 weiAmount = msg.value;
220     _preValidatePurchase(_beneficiary, weiAmount);
221 
222     // calculate token amount to be created
223     uint256 tokens = _getTokenAmount(weiAmount);
224 
225     // update state
226     weiRaised = weiRaised.add(weiAmount);
227 
228     _processPurchase(_beneficiary, tokens);
229     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
230 
231     _forwardFunds();
232   }
233 
234   // -----------------------------------------
235   // Internal interface (extensible)
236   // -----------------------------------------
237 
238   /**
239    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
240    * @param _beneficiary Address performing the token purchase
241    * @param _weiAmount Value in wei involved in the purchase
242    */
243   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotPaused {
244     require(_beneficiary != address(0));
245     require(_weiAmount >= minInvest);
246     require(weiRaised.add(_weiAmount) <= cap);
247     require(now >= openingTime && now <= closingTime);
248   }
249 
250   /**
251    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
252    * @param _beneficiary Address performing the token purchase
253    * @param _tokenAmount Number of tokens to be emitted
254    */
255   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
256     token.transfer(_beneficiary, _tokenAmount);
257   }
258 
259   /**
260    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
261    * @param _beneficiary Address receiving the tokens
262    * @param _tokenAmount Number of tokens to be purchased
263    */
264   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
265     _deliverTokens(_beneficiary, _tokenAmount);
266   }
267 
268   /**
269    * @dev Override to extend the way in which ether is converted to tokens.
270    * @param _weiAmount Value in wei to be converted into tokens
271    * @return Number of tokens that can be purchased with the specified _weiAmount
272    */
273   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
274     return _weiAmount.mul(rate);
275   }
276 
277   /**
278    * @dev Determines how ETH is stored/forwarded on purchases.
279    */
280   function _forwardFunds() internal {
281     wallet.transfer(msg.value);
282   }
283   
284   /**
285    * @dev called by the owner to start the crowdsale
286    */
287   function start() public onlyOwner {
288     openingTime = now;            
289     closingTime =  now + 16 days;
290   }
291   
292   /**
293    * @dev Checks whether the cap has been reached. 
294    * @return Whether the cap was reached
295    */
296   function capReached() public view returns (bool) {
297     return weiRaised >= cap;
298   }
299   
300   /**
301    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
302    * @return Whether crowdsale period has elapsed
303    */
304   function hasClosed() public view returns (bool) {
305     return now > closingTime;
306   }
307 
308   /**
309    * @dev called by the owner to withdraw unsold tokens
310    */
311   function withdrawTokens() public onlyOwner {
312     uint256 unsold = token.balanceOf(this);
313     token.transfer(owner, unsold);
314   }
315     
316 }