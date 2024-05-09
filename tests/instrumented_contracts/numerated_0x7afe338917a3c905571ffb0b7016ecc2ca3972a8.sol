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
73  * @title Crowdsale
74  * @dev Crowdsale is a base contract for managing a token crowdsale,
75  * allowing investors to purchase tokens with ether. This contract implements
76  * such functionality in its most fundamental form and can be extended to provide additional
77  * functionality and/or custom behavior.
78  * The external interface represents the basic interface for purchasing tokens, and conform
79  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
80  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
81  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
82  * behavior.
83  */
84 
85 contract Crowdsale {
86   using SafeMath for uint256;
87 
88   // The token being sold
89   ERC20 public token;
90 
91   // Address where funds are collected
92   address public wallet;
93 
94   // How many token units a buyer gets per wei
95   uint256 public rate;
96 
97   // Amount of wei raised
98   uint256 public weiRaised;
99 
100   /**
101    * Event for token purchase logging
102    * @param purchaser who paid for the tokens
103    * @param beneficiary who got the tokens
104    * @param value weis paid for purchase
105    * @param amount amount of tokens purchased
106    */
107   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
108 
109   /**
110    * @param _rate Number of token units a buyer gets per wei
111    * @param _wallet Address where collected funds will be forwarded to
112    * @param _token Address of the token being sold
113    */
114   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
115     require(_rate > 0);
116     require(_wallet != address(0));
117     require(_token != address(0));
118 
119     rate = _rate;
120     wallet = _wallet;
121     token = _token;
122   }
123 
124   // -----------------------------------------
125   // Crowdsale external interface
126   // -----------------------------------------
127 
128   /**
129    * @dev fallback function ***DO NOT OVERRIDE***
130    */
131   function () external payable {
132     buyTokens(msg.sender);
133   }
134 
135   /**
136    * @dev low level token purchase ***DO NOT OVERRIDE***
137    * @param _beneficiary Address performing the token purchase
138    */
139   function buyTokens(address _beneficiary) public payable {
140 
141     uint256 weiAmount = msg.value;
142     _preValidatePurchase(_beneficiary, weiAmount);
143 
144     // calculate token amount to be created
145     uint256 tokens = _getTokenAmount(weiAmount);
146 
147     // update state
148     weiRaised = weiRaised.add(weiAmount);
149 
150     _processPurchase(_beneficiary, tokens);
151     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
152 
153     _updatePurchasingState(_beneficiary, weiAmount);
154 
155     _forwardFunds();
156     _postValidatePurchase(_beneficiary, weiAmount);
157   }
158 
159   // -----------------------------------------
160   // Internal interface (extensible)
161   // -----------------------------------------
162 
163   /**
164    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
165    * @param _beneficiary Address performing the token purchase
166    * @param _weiAmount Value in wei involved in the purchase
167    */
168   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
169     require(_beneficiary != address(0));
170     require(_weiAmount != 0);
171   }
172 
173   /**
174    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
175    * @param _beneficiary Address performing the token purchase
176    * @param _weiAmount Value in wei involved in the purchase
177    */
178   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
179     // optional override
180   }
181 
182   /**
183    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
184    * @param _beneficiary Address performing the token purchase
185    * @param _tokenAmount Number of tokens to be emitted
186    */
187   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
188     token.transfer(_beneficiary, _tokenAmount);
189   }
190 
191   /**
192    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
193    * @param _beneficiary Address receiving the tokens
194    * @param _tokenAmount Number of tokens to be purchased
195    */
196   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
197     _deliverTokens(_beneficiary, _tokenAmount);
198   }
199 
200   /**
201    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
202    * @param _beneficiary Address receiving the tokens
203    * @param _weiAmount Value in wei involved in the purchase
204    */
205   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
206     // optional override
207   }
208 
209   /**
210    * @dev Override to extend the way in which ether is converted to tokens.
211    * @param _weiAmount Value in wei to be converted into tokens
212    * @return Number of tokens that can be purchased with the specified _weiAmount
213    */
214   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
215     return _weiAmount.mul(rate);
216   }
217 
218   /**
219    * @dev Determines how ETH is stored/forwarded on purchases.
220    */
221   function _forwardFunds() internal {
222     wallet.transfer(msg.value);
223   }
224 }
225 
226 /**
227  * @title CappedCrowdsale
228  * @dev Crowdsale with a limit for total contributions.
229  */
230 contract CappedCrowdsale is Crowdsale {
231   using SafeMath for uint256;
232 
233   uint256 public cap;
234 
235   /**
236    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
237    * @param _cap Max amount of wei to be contributed
238    */
239   function CappedCrowdsale(uint256 _cap) public {
240     require(_cap > 0);
241     cap = _cap;
242   }
243 
244   /**
245    * @dev Checks whether the cap has been reached. 
246    * @return Whether the cap was reached
247    */
248   function capReached() public view returns (bool) {
249     return weiRaised >= cap;
250   }
251 
252   /**
253    * @dev Extend parent behavior requiring purchase to respect the funding cap.
254    * @param _beneficiary Token purchaser
255    * @param _weiAmount Amount of wei contributed
256    */
257   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
258     super._preValidatePurchase(_beneficiary, _weiAmount);
259     require(weiRaised.add(_weiAmount) <= cap);
260   }
261 
262 }
263 
264 /**
265  * @title Ownable
266  * @dev The Ownable contract has an owner address, and provides basic authorization control
267  * functions, this simplifies the implementation of "user permissions".
268  */
269 contract Ownable {
270   address public owner;
271 
272 
273   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
274 
275 
276   /**
277    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
278    * account.
279    */
280   function Ownable() public {
281     owner = msg.sender;
282   }
283 
284   /**
285    * @dev Throws if called by any account other than the owner.
286    */
287   modifier onlyOwner() {
288     require(msg.sender == owner);
289     _;
290   }
291 
292   /**
293    * @dev Allows the current owner to transfer control of the contract to a newOwner.
294    * @param newOwner The address to transfer ownership to.
295    */
296   function transferOwnership(address newOwner) public onlyOwner {
297     require(newOwner != address(0));
298     OwnershipTransferred(owner, newOwner);
299     owner = newOwner;
300   }
301 
302 }
303 
304 /**
305  * @title WavestreamPresale
306  * @dev Capped crowdsale with two wallets.
307  */
308 contract WavestreamPresale is CappedCrowdsale, Ownable {
309   using SafeMath for uint256;
310 
311   /**
312    * @dev Modifier to make a function callable only when the contract is not closed.
313    */
314   modifier whenNotClosed() {
315     require(!isClosed);
316     _;
317   }
318 
319   bool public isClosed = false;
320 
321   event Closed();
322 
323   // The raised funds are being transferred to two wallets. First, until total
324   // amout of wei raised is less than or equal to `priorityCap`, raised funds
325   // are transferred to `priorityWallet`. After that, raised funds are
326   // transferred to `wallet`.
327   uint256 public priorityCap;
328 
329   // Address where first priorityCap raised wei are transferred
330   address public priorityWallet;
331 
332   /**
333    * @dev Constructor
334    * @param _rate Number of token units a buyer gets per wei
335    * @param _priorityWallet Address where collected first raised _priorityCap wei
336    * @param _priorityCap Max amount of wei to be transferred to _priorityWallet
337    * @param _wallet Address where collected funds will be forwarded to after hitting the _priorityCap
338    * @param _cap Max amount of wei to be contributed
339    * @param _token Address of the token being sold
340    */
341   function WavestreamPresale(
342     uint256 _rate,
343     address _priorityWallet,
344     uint256 _priorityCap,
345     address _wallet,
346     uint256 _cap,
347     ERC20 _token
348   ) public
349     Crowdsale(_rate, _wallet, _token)
350     CappedCrowdsale(_cap)
351     Ownable()
352   {
353     require(_priorityCap > 0);
354     require(_priorityCap < _cap);
355     require(_priorityWallet != address(0));
356     require(_priorityWallet != _wallet);
357 
358     priorityWallet = _priorityWallet;
359     priorityCap = _priorityCap;
360   }
361 
362   /**
363    * @dev Close crowdsale, only for owner.
364    */
365   function closeCrowdsale() onlyOwner public {
366     require(!isClosed);
367 
368     isClosed = true;
369 
370     uint256 tokenBalance = token.balanceOf(address(this));
371     if (tokenBalance > 0) {
372       token.transfer(owner, tokenBalance);
373     }
374 
375     Closed();
376   }
377 
378   /**
379    * @dev Determines how ETH is stored/forwarded on purchases. Part of OpenZeppelin
380    * internal interface.
381    */
382   function _forwardFunds() internal {
383     if (weiRaised <= priorityCap) {
384       priorityWallet.transfer(msg.value);
385     } else {
386       uint256 weiRaisedBefore = weiRaised.sub(msg.value);
387 
388       if (weiRaisedBefore < priorityCap) {
389         uint256 transferToPriorityWallet = priorityCap.sub(weiRaisedBefore);
390         uint256 transferToWallet = weiRaised.sub(priorityCap);
391         priorityWallet.transfer(transferToPriorityWallet);
392         wallet.transfer(transferToWallet);
393       } else {
394         wallet.transfer(msg.value);
395       }
396     }
397   }
398 
399   /**
400    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
401    * Part of OpenZeppelin internal interface.
402    * @param _beneficiary Token purchaser
403    * @param _weiAmount Amount of wei contributed
404    */
405   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotClosed {
406     super._preValidatePurchase(_beneficiary, _weiAmount);
407   }
408 }