1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 /**
37  * @title SafeERC20
38  * @dev Wrappers around ERC20 operations that throw on failure.
39  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
40  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
41  */
42 library SafeERC20Transfer {
43   function safeTransfer(
44     IERC20 token,
45     address to,
46     uint256 value
47   )
48     internal
49   {
50     require(token.transfer(to, value));
51   }
52 }
53 
54 /**
55  * @title SafeMath
56  * @dev Math operations with safety checks that revert on error
57  */
58 library SafeMath {
59 
60   /**
61   * @dev Multiplies two numbers, reverts on overflow.
62   */
63   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65     // benefit is lost if 'b' is also tested.
66     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
67     if (a == 0) {
68       return 0;
69     }
70 
71     uint256 c = a * b;
72     require(c / a == b);
73 
74     return c;
75   }
76 
77   /**
78   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
79   */
80   function div(uint256 a, uint256 b) internal pure returns (uint256) {
81     require(b > 0); // Solidity only automatically asserts when dividing by 0
82     uint256 c = a / b;
83     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
84 
85     return c;
86   }
87 
88   /**
89   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
90   */
91   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92     require(b <= a);
93     uint256 c = a - b;
94 
95     return c;
96   }
97 
98   /**
99   * @dev Adds two numbers, reverts on overflow.
100   */
101   function add(uint256 a, uint256 b) internal pure returns (uint256) {
102     uint256 c = a + b;
103     require(c >= a);
104 
105     return c;
106   }
107 
108   /**
109   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
110   * reverts when dividing by zero.
111   */
112   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
113     require(b != 0);
114     return a % b;
115   }
116 }
117 
118 
119 /**
120  * @title Ownable
121  * @dev The Ownable contract has an owner address, and provides basic authorization control
122  * functions, this simplifies the implementation of "user permissions".
123  */
124 contract Ownable {
125   address private _owner;
126 
127   event OwnershipTransferred(
128     address indexed previousOwner,
129     address indexed newOwner
130   );
131 
132   /**
133    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
134    * account.
135    */
136   constructor() public {
137     _owner = msg.sender;
138     emit OwnershipTransferred(address(0), _owner);
139   }
140 
141   /**
142    * @return the address of the owner.
143    */
144   function owner() public view returns(address) {
145     return _owner;
146   }
147 
148   /**
149    * @dev Throws if called by any account other than the owner.
150    */
151   modifier onlyOwner() {
152     require(isOwner());
153     _;
154   }
155 
156   /**
157    * @return true if `msg.sender` is the owner of the contract.
158    */
159   function isOwner() public view returns(bool) {
160     return msg.sender == _owner;
161   }
162 
163   /**
164    * @dev Allows the current owner to relinquish control of the contract.
165    * @notice Renouncing to ownership will leave the contract without an owner.
166    * It will not be possible to call the functions with the `onlyOwner`
167    * modifier anymore.
168    */
169   function renounceOwnership() public onlyOwner {
170     emit OwnershipTransferred(_owner, address(0));
171     _owner = address(0);
172   }
173 
174   /**
175    * @dev Allows the current owner to transfer control of the contract to a newOwner.
176    * @param newOwner The address to transfer ownership to.
177    */
178   function transferOwnership(address newOwner) public onlyOwner {
179     _transferOwnership(newOwner);
180   }
181 
182   /**
183    * @dev Transfers control of the contract to a newOwner.
184    * @param newOwner The address to transfer ownership to.
185    */
186   function _transferOwnership(address newOwner) internal {
187     require(newOwner != address(0));
188     emit OwnershipTransferred(_owner, newOwner);
189     _owner = newOwner;
190   }
191 }
192 
193 /**
194  * @title Crowdsale
195  * @dev Crowdsale is a base contract for managing a token crowdsale,
196  * allowing investors to purchase tokens with ether. This contract implements
197  * such functionality in its most fundamental form and can be extended to provide additional
198  * functionality and/or custom behavior.
199  * The external interface represents the basic interface for purchasing tokens, and conform
200  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
201  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
202  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
203  * behavior.
204  */
205 contract Crowdsale is Ownable {
206   using SafeMath for uint256;
207   using SafeERC20Transfer for IERC20;
208 
209   // The token being sold
210   IERC20 private _token;
211 
212   // Address where funds are collected
213   address private _wallet;
214 
215   // Amount of wei raised
216   uint256 private _weiRaised;
217 
218   // ICO configuration
219   uint256 public privateICOrate = 4081; //tokens per ether
220   uint256 public preICOrate = 3278; //tokens per ether
221   uint256 public ICOrate = 1785; //tokens per ether
222   uint32 public privateICObonus = 30; // private ICO bonus
223   uint256 public privateICObonusLimit = 20000; // private ICO bonus limit
224   uint32 public preICObonus = 25; // pre ICO bonus
225   uint256 public preICObonusLimit = 10000; // pre ICO bonus limit
226   uint32 public ICObonus = 15; // ICO bonus
227   uint256 public ICObonusLimit = 10000; // ICO bonus limit
228   uint256 public startPrivateICO = 1550188800; // Private ICO start 15/02/2019 00:00:00
229   uint256 public startPreICO = 1551830400; // Pre ICO start 06/03/2019 00:00:00
230   uint256 public startICO = 1554595200; // ICO start 07/04/2019 00:00:00
231   uint256 public endICO = 1557273599; // ICO end 07/05/2019 23:59:59
232 
233   /**
234    * Event for token purchase logging
235    * @param purchaser who paid for the tokens
236    * @param beneficiary who got the tokens
237    * @param value weis paid for purchase
238    * @param amount amount of tokens purchased
239    */
240   event TokensPurchased(
241     address indexed purchaser,
242     address indexed beneficiary,
243     uint256 value,
244     uint256 amount
245   );
246 
247   /**
248    * Contract constructor
249    * @param wallet Address where collected funds will be forwarded to
250    * @param token Address of the token being sold
251    */
252   constructor(address newOwner, address wallet, IERC20 token) public {
253     require(wallet != address(0));
254     require(token != address(0));
255     require(newOwner != address(0));
256     transferOwnership(newOwner);
257     _wallet = wallet;
258     _token = token;
259   }
260 
261   // -----------------------------------------
262   // Crowdsale external interface
263   // -----------------------------------------
264 
265   /**
266    * @dev fallback function ***DO NOT OVERRIDE***
267    */
268   function () external payable {
269     buyTokens(msg.sender);
270   }
271 
272   /**
273    * @return the token being sold.
274    */
275   function token() public view returns(IERC20) {
276     return _token;
277   }
278 
279   /**
280    * @return the address where funds are collected.
281    */
282   function wallet() public view returns(address) {
283     return _wallet;
284   }
285 
286   /**
287    * @return the amount of wei raised.
288    */
289   function weiRaised() public view returns (uint256) {
290     return _weiRaised;
291   }
292 
293   /**
294    * send tokens sold for another currencies and bounty, advisors, etc
295    * @param beneficiary address of purchaser
296    * @param tokenAmount tokens amount
297    */
298   function sendTokens(address beneficiary, uint256 tokenAmount) public onlyOwner {
299     require(beneficiary != address(0));
300     require(tokenAmount > 0);
301     _token.safeTransfer(beneficiary, tokenAmount);
302   }
303 
304   /**
305    * @dev low level token purchase ***DO NOT OVERRIDE***
306    * @param beneficiary Address performing the token purchase
307    */
308   function buyTokens(address beneficiary) public payable {
309     uint256 weiAmount = msg.value;
310     _preValidatePurchase(beneficiary, weiAmount);
311 
312     // calculate token amount to be created
313     uint256 tokens = _getTokenAmount(weiAmount);
314 
315     // update state
316     _weiRaised = _weiRaised.add(weiAmount);
317 
318     _processPurchase(beneficiary, tokens);
319     emit TokensPurchased(
320       msg.sender,
321       beneficiary,
322       weiAmount,
323       tokens
324     );
325 
326     _forwardFunds(weiAmount);
327   }
328 
329   /**
330    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
331    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
332    *   super._preValidatePurchase(beneficiary, weiAmount);
333    *   require(weiRaised().add(weiAmount) <= cap);
334    * @param beneficiary Address performing the token purchase
335    * @param weiAmount Value in wei involved in the purchase
336    */
337   function _preValidatePurchase(
338     address beneficiary,
339     uint256 weiAmount
340   )
341     internal pure
342   {
343     require(beneficiary != address(0));
344     require(weiAmount > 0);
345   }
346 
347   /**
348    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
349    * @param beneficiary Address performing the token purchase
350    * @param tokenAmount Number of tokens to be emitted
351    */
352   function _deliverTokens(
353     address beneficiary,
354     uint256 tokenAmount
355   )
356     internal
357   {
358     _token.safeTransfer(beneficiary, tokenAmount);
359   }
360 
361   /**
362    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
363    * @param beneficiary Address receiving the tokens
364    * @param tokenAmount Number of tokens to be purchased
365    */
366   function _processPurchase(
367     address beneficiary,
368     uint256 tokenAmount
369   )
370     internal
371   {
372     _deliverTokens(beneficiary, tokenAmount);
373   }
374 
375   /**
376    * @dev The way in which ether is converted to tokens.
377    * @param weiAmount Value in wei to be converted into tokens
378    * @return Number of tokens that can be purchased with the specified _weiAmount
379    */
380   function _getTokenAmount(
381     uint256 weiAmount
382   )
383     internal view returns (uint256)
384   {
385     uint256 tokens;
386     uint256 bonusTokens;
387     if (now >= startPrivateICO && now < startPreICO) {
388       tokens = weiAmount.mul(privateICOrate).div(1e18);
389       if (tokens > privateICObonusLimit) {
390         bonusTokens = tokens.mul(privateICObonus).div(100);
391         tokens = tokens.add(bonusTokens);
392       }
393     } else if (now >= startPreICO && now < startICO) {
394       tokens = weiAmount.mul(preICOrate).div(1e18);
395       if (tokens > preICObonusLimit) {
396         bonusTokens = tokens.mul(preICObonus).div(100);
397         tokens = tokens.add(bonusTokens);
398       }
399     } else if (now >= startICO && now <= endICO) {
400       tokens = weiAmount.mul(ICOrate).div(1e18);
401       if (tokens > ICObonusLimit) {
402         bonusTokens = tokens.mul(ICObonus).div(100);
403         tokens = tokens.add(bonusTokens);
404       }      
405     } else {
406       tokens = weiAmount.mul(ICOrate).div(1e18);
407     }
408     return tokens;
409   }
410 
411   /**
412    * @dev Determines how ETH is stored/forwarded on purchases.
413    */
414   function _forwardFunds(uint256 weiAmount_) internal {
415     _wallet.transfer(weiAmount_);
416   }
417 }