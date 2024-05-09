1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 pragma solidity ^0.4.18;
17 
18 /**
19  * @title ERC20 interface
20  * @dev see https://github.com/ethereum/EIPs/issues/20
21  */
22 contract ERC20 is ERC20Basic {
23   function allowance(address owner, address spender) public view returns (uint256);
24   function transferFrom(address from, address to, uint256 value) public returns (bool);
25   function approve(address spender, uint256 value) public returns (bool);
26   event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 
30 pragma solidity ^0.4.18;
31 
32 
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 library SafeMath {
38 
39   /**
40   * @dev Multiplies two numbers, throws on overflow.
41   */
42   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43     if (a == 0) {
44       return 0;
45     }
46     uint256 c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers, truncating the quotient.
53   */
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     // assert(b > 0); // Solidity automatically throws when dividing by 0
56     uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return c;
59   }
60 
61   /**
62   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
63   */
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   /**
70   * @dev Adds two numbers, throws on overflow.
71   */
72   function add(uint256 a, uint256 b) internal pure returns (uint256) {
73     uint256 c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 pragma solidity ^0.4.18;
80 
81 /**
82  * @title Crowdsale
83  * @dev Crowdsale is a base contract for managing a token crowdsale,
84  * allowing investors to purchase tokens with ether. This contract implements
85  * such functionality in its most fundamental form and can be extended to provide additional
86  * functionality and/or custom behavior.
87  * The external interface represents the basic interface for purchasing tokens, and conform
88  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
89  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
90  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
91  * behavior.
92  */
93 
94 contract Crowdsale {
95   using SafeMath for uint256;
96 
97   // The token being sold
98   ERC20 public token;
99 
100   // Address where funds are collected
101   address public wallet;
102 
103   // How many token units a buyer gets per wei
104   uint256 public rate;
105 
106   // Amount of wei raised
107   uint256 public weiRaised;
108 
109   /**
110    * Event for token purchase logging
111    * @param purchaser who paid for the tokens
112    * @param beneficiary who got the tokens
113    * @param value weis paid for purchase
114    * @param amount amount of tokens purchased
115    */
116   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
117 
118   /**
119    * @param _rate Number of token units a buyer gets per wei
120    * @param _wallet Address where collected funds will be forwarded to
121    * @param _token Address of the token being sold
122    */
123   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
124     require(_rate > 0);
125     require(_wallet != address(0));
126     require(_token != address(0));
127 
128     rate = _rate;
129     wallet = _wallet;
130     token = _token;
131   }
132 
133   // -----------------------------------------
134   // Crowdsale external interface
135   // -----------------------------------------
136 
137   /**
138    * @dev fallback function ***DO NOT OVERRIDE***
139    */
140   function () external payable {
141     buyTokens(msg.sender);
142   }
143 
144   /**
145    * @dev low level token purchase ***DO NOT OVERRIDE***
146    * @param _beneficiary Address performing the token purchase
147    */
148   function buyTokens(address _beneficiary) public payable {
149 
150     uint256 weiAmount = msg.value;
151     _preValidatePurchase(_beneficiary, weiAmount);
152 
153     // calculate token amount to be created
154     uint256 tokens = _getTokenAmount(weiAmount);
155 
156     // update state
157     weiRaised = weiRaised.add(weiAmount);
158 
159     _processPurchase(_beneficiary, tokens);
160     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
161 
162     _updatePurchasingState(_beneficiary, weiAmount);
163 
164     _forwardFunds();
165     _postValidatePurchase(_beneficiary, weiAmount);
166   }
167 
168   // -----------------------------------------
169   // Internal interface (extensible)
170   // -----------------------------------------
171 
172   /**
173    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
174    * @param _beneficiary Address performing the token purchase
175    * @param _weiAmount Value in wei involved in the purchase
176    */
177   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
178     require(_beneficiary != address(0));
179     require(_weiAmount != 0);
180   }
181 
182   /**
183    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
184    * @param _beneficiary Address performing the token purchase
185    * @param _weiAmount Value in wei involved in the purchase
186    */
187   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
188     // optional override
189   }
190 
191   /**
192    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
193    * @param _beneficiary Address performing the token purchase
194    * @param _tokenAmount Number of tokens to be emitted
195    */
196   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
197     token.transfer(_beneficiary, _tokenAmount);
198   }
199 
200   /**
201    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
202    * @param _beneficiary Address receiving the tokens
203    * @param _tokenAmount Number of tokens to be purchased
204    */
205   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
206     _deliverTokens(_beneficiary, _tokenAmount);
207   }
208 
209   /**
210    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
211    * @param _beneficiary Address receiving the tokens
212    * @param _weiAmount Value in wei involved in the purchase
213    */
214   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
215     // optional override
216   }
217 
218   /**
219    * @dev Override to extend the way in which ether is converted to tokens.
220    * @param _weiAmount Value in wei to be converted into tokens
221    * @return Number of tokens that can be purchased with the specified _weiAmount
222    */
223   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
224     return _weiAmount.mul(rate);
225   }
226 
227   /**
228    * @dev Determines how ETH is stored/forwarded on purchases.
229    */
230   function _forwardFunds() internal {
231     wallet.transfer(msg.value);
232   }
233 }
234 
235 pragma solidity ^0.4.18;
236 
237 
238 /**
239  * @title Ownable
240  * @dev The Ownable contract has an owner address, and provides basic authorization control
241  * functions, this simplifies the implementation of "user permissions".
242  */
243 contract Ownable {
244   address public owner;
245 
246 
247   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
248 
249 
250   /**
251    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
252    * account.
253    */
254   function Ownable() public {
255     owner = msg.sender;
256   }
257 
258   /**
259    * @dev Throws if called by any account other than the owner.
260    */
261   modifier onlyOwner() {
262     require(msg.sender == owner);
263     _;
264   }
265 
266   /**
267    * @dev Allows the current owner to transfer control of the contract to a newOwner.
268    * @param newOwner The address to transfer ownership to.
269    */
270   function transferOwnership(address newOwner) public onlyOwner {
271     require(newOwner != address(0));
272     OwnershipTransferred(owner, newOwner);
273     owner = newOwner;
274   }
275 
276 }
277 
278 pragma solidity ^0.4.19;
279 
280 contract _Crowdsale is Crowdsale, Ownable {
281 
282     uint public fundingGoal;
283 
284     mapping(address => uint256) public balanceOf;
285     bool fundingGoalReached = false;
286     bool crowdsaleClosed = false;
287 
288     function _Crowdsale(address wallet, uint goal, uint rate, address token)
289         Crowdsale(rate, wallet, ERC20(token)) public {
290         fundingGoal = goal * 1 ether;
291     }
292 
293     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
294         // require(!crowdsaleClosed);
295         require(_weiAmount <= 10 ether && _weiAmount >= 1 finney);
296         super._preValidatePurchase(_beneficiary, _weiAmount);
297     }
298 
299     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
300         //token.transfer(_beneficiary, _tokenAmount);
301         token.transferFrom(owner, _beneficiary, _tokenAmount);
302     }
303 
304     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
305         return _weiAmount.div(10 ** rate);
306     }
307 
308     event GoalReached(address recipient, uint totalAmountRaised);
309 
310     function checkGoalReached() public {
311         if (weiRaised >= fundingGoal) {
312             GoalReached(wallet, weiRaised);
313         }
314     }
315 
316 }