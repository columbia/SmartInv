1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32 
33   /**
34   * @dev Multiplies two numbers, throws on overflow.
35   */
36   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37     if (a == 0) {
38       return 0;
39     }
40     uint256 c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   /**
56   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256) {
67     uint256 c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 /**
74  * @title Ownable
75  * @dev The Ownable contract has an owner address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Ownable {
79   address public owner;
80 
81 
82   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83 
84 
85   /**
86    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
87    * account.
88    */
89   function Ownable() public {
90     owner = msg.sender;
91   }
92 
93   /**
94    * @dev Throws if called by any account other than the owner.
95    */
96   modifier onlyOwner() {
97     require(msg.sender == owner);
98     _;
99   }
100 
101   /**
102    * @dev Allows the current owner to transfer control of the contract to a newOwner.
103    * @param newOwner The address to transfer ownership to.
104    */
105   function transferOwnership(address newOwner) public onlyOwner {
106     require(newOwner != address(0));
107     OwnershipTransferred(owner, newOwner);
108     owner = newOwner;
109   }
110 
111 }
112 
113 
114 
115 
116 /**
117  * @title Crowdsale
118  * @dev Crowdsale is a base contract for managing a token crowdsale,
119  * allowing investors to purchase tokens with ether. This contract implements
120  * such functionality in its most fundamental form and can be extended to provide additional
121  * functionality and/or custom behavior.
122  * The external interface represents the basic interface for purchasing tokens, and conform
123  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
124  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
125  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
126  * behavior.
127  */
128 
129 contract Crowdsale {
130   using SafeMath for uint256;
131 
132   // The token being sold
133   ERC20 public token;
134 
135   // Address where funds are collected
136   address public wallet;
137 
138   // How many token units a buyer gets per wei
139   uint256 public rate;
140 
141   // Amount of wei raised
142   uint256 public weiRaised;
143 
144   /**
145    * Event for token purchase logging
146    * @param purchaser who paid for the tokens
147    * @param beneficiary who got the tokens
148    * @param value weis paid for purchase
149    * @param amount amount of tokens purchased
150    */
151   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
152 
153   /**
154    * @param _rate Number of token units a buyer gets per wei
155    * @param _wallet Address where collected funds will be forwarded to
156    * @param _token Address of the token being sold
157    */
158   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
159     require(_rate > 0);
160     require(_wallet != address(0));
161     require(_token != address(0));
162 
163     rate = _rate;
164     wallet = _wallet;
165     token = _token;
166   }
167 
168   // -----------------------------------------
169   // Crowdsale external interface
170   // -----------------------------------------
171 
172   /**
173    * @dev fallback function ***DO NOT OVERRIDE***
174    */
175   function () external payable {
176     buyTokens(msg.sender);
177   }
178 
179   /**
180    * @dev low level token purchase ***DO NOT OVERRIDE***
181    * @param _beneficiary Address performing the token purchase
182    */
183   function buyTokens(address _beneficiary) public payable {
184 
185     uint256 weiAmount = msg.value;
186     _preValidatePurchase(_beneficiary, weiAmount);
187 
188     // calculate token amount to be created
189     uint256 tokens = _getTokenAmount(weiAmount);
190 
191     // update state
192     weiRaised = weiRaised.add(weiAmount);
193 
194     _processPurchase(_beneficiary, tokens);
195     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
196 
197     _updatePurchasingState(_beneficiary, weiAmount);
198 
199     _forwardFunds();
200     _postValidatePurchase(_beneficiary, weiAmount);
201   }
202 
203   // -----------------------------------------
204   // Internal interface (extensible)
205   // -----------------------------------------
206 
207   /**
208    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
209    * @param _beneficiary Address performing the token purchase
210    * @param _weiAmount Value in wei involved in the purchase
211    */
212   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
213     require(_beneficiary != address(0));
214     require(_weiAmount != 0);
215   }
216 
217   /**
218    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
219    * @param _beneficiary Address performing the token purchase
220    * @param _weiAmount Value in wei involved in the purchase
221    */
222   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
223     // optional override
224   }
225 
226   /**
227    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
228    * @param _beneficiary Address performing the token purchase
229    * @param _tokenAmount Number of tokens to be emitted
230    */
231   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
232     token.transfer(_beneficiary, _tokenAmount);
233   }
234 
235   /**
236    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
237    * @param _beneficiary Address receiving the tokens
238    * @param _tokenAmount Number of tokens to be purchased
239    */
240   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
241     _deliverTokens(_beneficiary, _tokenAmount);
242   }
243 
244   /**
245    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
246    * @param _beneficiary Address receiving the tokens
247    * @param _weiAmount Value in wei involved in the purchase
248    */
249   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
250     // optional override
251   }
252 
253   /**
254    * @dev Override to extend the way in which ether is converted to tokens.
255    * @param _weiAmount Value in wei to be converted into tokens
256    * @return Number of tokens that can be purchased with the specified _weiAmount
257    */
258   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
259     return _weiAmount.mul(rate);
260   }
261 
262   /**
263    * @dev Determines how ETH is stored/forwarded on purchases.
264    */
265   function _forwardFunds() internal {
266     wallet.transfer(msg.value);
267   }
268 }
269 
270 
271 
272 /**
273  * @title TimedCrowdsale
274  * @dev Crowdsale accepting contributions only within a time frame.
275  */
276 contract TimedCrowdsale is Crowdsale {
277   using SafeMath for uint256;
278 
279   uint256 public openingTime;
280   uint256 public closingTime;
281 
282   /**
283    * @dev Reverts if not in crowdsale time range. 
284    */
285   modifier onlyWhileOpen {
286     require(now >= openingTime && now <= closingTime);
287     _;
288   }
289 
290   /**
291    * @dev Constructor, takes crowdsale opening and closing times.
292    * @param _openingTime Crowdsale opening time
293    * @param _closingTime Crowdsale closing time
294    */
295   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
296     require(_openingTime >= now);
297     require(_closingTime >= _openingTime);
298 
299     openingTime = _openingTime;
300     closingTime = _closingTime;
301   }
302 
303   /**
304    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
305    * @return Whether crowdsale period has elapsed
306    */
307   function hasClosed() public view returns (bool) {
308     return now > closingTime;
309   }
310   
311   /**
312    * @dev Extend parent behavior requiring to be within contributing period
313    * @param _beneficiary Token purchaser
314    * @param _weiAmount Amount of wei contributed
315    */
316   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
317     super._preValidatePurchase(_beneficiary, _weiAmount);
318   }
319 
320 }
321 
322 /**
323  * @title CrowdsaleRDC0
324  * @dev Crowdsale-0
325  */
326 contract CrowdsaleRDC0 is TimedCrowdsale, Ownable {
327     
328     function CrowdsaleRDC0(ERC20 _token, uint256 _startTime, uint256 _finishTime,  uint _rate, address _wallet ) TimedCrowdsale(_startTime, _finishTime)  Crowdsale( _rate, _wallet, _token ) public payable {
329     }
330         
331 		
332 	function _forwardFunds() internal {     
333         wallet.transfer(msg.value);
334     }
335     
336     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
337         super._preValidatePurchase(_beneficiary, _weiAmount);
338     }
339     
340     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
341         token.transfer(_beneficiary, _tokenAmount);
342     }	
343     
344     function changeWallet( address _wallet ) onlyOwner public {
345 		require( _wallet != address(0));
346 		wallet = _wallet;
347 	}
348 }