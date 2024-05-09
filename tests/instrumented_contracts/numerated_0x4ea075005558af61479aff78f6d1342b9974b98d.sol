1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
55     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
56     // benefit is lost if 'b' is also tested.
57     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
58     if (_a == 0) {
59       return 0;
60     }
61 
62     c = _a * _b;
63     assert(c / _a == _b);
64     return c;
65   }
66 
67   /**
68   * @dev Integer division of two numbers, truncating the quotient.
69   */
70   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
71     // assert(_b > 0); // Solidity automatically throws when dividing by 0
72     // uint256 c = _a / _b;
73     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
74     return _a / _b;
75   }
76 
77   /**
78   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
79   */
80   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
81     assert(_b <= _a);
82     return _a - _b;
83   }
84 
85   /**
86   * @dev Adds two numbers, throws on overflow.
87   */
88   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
89     c = _a + _b;
90     assert(c >= _a);
91     return c;
92   }
93 }
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * See https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address _who) public view returns (uint256);
103   function transfer(address _to, uint256 _value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address _owner, address _spender)
113     public view returns (uint256);
114 
115   function transferFrom(address _from, address _to, uint256 _value)
116     public returns (bool);
117 
118   function approve(address _spender, uint256 _value) public returns (bool);
119   event Approval(
120     address indexed owner,
121     address indexed spender,
122     uint256 value
123   );
124 }
125 
126 /**
127  * @title SafeERC20
128  * @dev Wrappers around ERC20 operations that throw on failure.
129  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
130  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
131  */
132 library SafeERC20 {
133   function safeTransfer(
134     ERC20Basic _token,
135     address _to,
136     uint256 _value
137   )
138     internal
139   {
140     require(_token.transfer(_to, _value));
141   }
142 
143   function safeTransferFrom(
144     ERC20 _token,
145     address _from,
146     address _to,
147     uint256 _value
148   )
149     internal
150   {
151     require(_token.transferFrom(_from, _to, _value));
152   }
153 
154   function safeApprove(
155     ERC20 _token,
156     address _spender,
157     uint256 _value
158   )
159     internal
160   {
161     require(_token.approve(_spender, _value));
162   }
163 }
164 
165 /**
166  * @title Crowdsale
167  * @dev Crowdsale is a base contract for managing a token crowdsale,
168  * allowing investors to purchase tokens with ether. This contract implements
169  * such functionality in its most fundamental form and can be extended to provide additional
170  * functionality and/or custom behavior.
171  * The external interface represents the basic interface for purchasing tokens, and conform
172  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
173  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
174  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
175  * behavior.
176  */
177 contract Crowdsale {
178   using SafeMath for uint256;
179   using SafeERC20 for ERC20;
180 
181   // The token being sold
182   ERC20 public token;
183 
184   // Address where funds are collected
185   address public wallet;
186 
187   // How many token units a buyer gets per wei.
188   // The rate is the conversion between wei and the smallest and indivisible token unit.
189   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
190   // 1 wei will give you 1 unit, or 0.001 TOK.
191   uint256 public rate = 9000;
192 
193   // Amount of wei raised
194   uint256 public weiRaised;
195   
196   uint256 public descending = 0 ether;
197   
198   uint256 public descendingCount = 0.05 ether;
199 
200   /**
201    * Event for token purchase logging
202    * @param purchaser who paid for the tokens
203    * @param beneficiary who got the tokens
204    * @param value weis paid for purchase
205    * @param amount amount of tokens purchased
206    */
207   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
208 
209   /**
210    * @param _wallet Address where collected funds will be forwarded to
211    * @param _token Address of the token being sold
212    */
213   constructor(address _wallet, ERC20 _token) public {
214     require(_wallet != address(0));
215     require(_token != address(0));
216 
217     wallet = _wallet;
218     token = _token;
219   }
220 
221   // -----------------------------------------
222   // Crowdsale external interface
223   // -----------------------------------------
224 
225   /**
226    * @dev fallback function ***DO NOT OVERRIDE***
227    */
228   function () external payable {
229     buyTokens(msg.sender);
230   }
231 
232   /**
233    * @dev low level token purchase ***DO NOT OVERRIDE***
234    * @param _beneficiary Address performing the token purchase
235    */
236   function buyTokens(address _beneficiary) public payable {
237 
238     uint256 weiAmount = msg.value;
239     _preValidatePurchase(_beneficiary, weiAmount);
240 
241     // calculate token amount to be created
242     uint256 tokens = _getTokenAmount(weiAmount);
243     
244     tokens = tokens.sub(descending);
245 
246     // update state
247     weiRaised = weiRaised.add(weiAmount);
248 
249     _processPurchase(_beneficiary, tokens);
250     emit TokenPurchase(
251       msg.sender,
252       _beneficiary,
253       weiAmount,
254       tokens
255     );
256 
257     _updatePurchasingState(_beneficiary, weiAmount);
258     _forwardFunds();
259     _postValidatePurchase(_beneficiary, weiAmount);
260     
261     descending = descending.add(descendingCount);
262   }
263 
264   // -----------------------------------------
265   // Internal interface (extensible)
266   // -----------------------------------------
267 
268   /**
269    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
270    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
271    *   super._preValidatePurchase(_beneficiary, _weiAmount);
272    *   require(weiRaised.add(_weiAmount) <= cap);
273    * @param _beneficiary Address performing the token purchase
274    * @param _weiAmount Value in wei involved in the purchase
275    */
276   function _preValidatePurchase(
277     address _beneficiary,
278     uint256 _weiAmount
279   )
280     internal
281   {
282     require(_beneficiary != address(0));
283     require(_weiAmount != 0);
284   }
285 
286   /**
287    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
288    * @param _beneficiary Address performing the token purchase
289    * @param _weiAmount Value in wei involved in the purchase
290    */
291   function _postValidatePurchase(
292     address _beneficiary,
293     uint256 _weiAmount
294   )
295     internal
296   {
297     // optional override
298   }
299 
300   /**
301    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
302    * @param _beneficiary Address performing the token purchase
303    * @param _tokenAmount Number of tokens to be emitted
304    */
305   function _deliverTokens(
306     address _beneficiary,
307     uint256 _tokenAmount
308   )
309     internal
310   {
311     token.safeTransfer(_beneficiary, _tokenAmount);
312   }
313 
314   /**
315    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
316    * @param _beneficiary Address receiving the tokens
317    * @param _tokenAmount Number of tokens to be purchased
318    */
319   function _processPurchase(
320     address _beneficiary,
321     uint256 _tokenAmount
322   )
323     internal
324   {
325     _deliverTokens(_beneficiary, _tokenAmount);
326   }
327 
328   /**
329    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
330    * @param _beneficiary Address receiving the tokens
331    * @param _weiAmount Value in wei involved in the purchase
332    */
333   function _updatePurchasingState(
334     address _beneficiary,
335     uint256 _weiAmount
336   )
337     internal
338   {
339     // optional override
340   }
341   
342   
343   /**
344    * @dev Override to extend the way in which ether is converted to tokens.
345    * @param _weiAmount Value in wei to be converted into tokens
346    * @return Number of tokens that can be purchased with the specified _weiAmount
347    */
348   function _getTokenAmount(uint256 _weiAmount)
349     internal view returns (uint256)
350   {
351     return _weiAmount.mul(rate);
352   }
353 
354   /**
355    * @dev Determines how ETH is stored/forwarded on purchases.
356    */
357   function _forwardFunds() internal {
358     wallet.transfer(msg.value);
359   }
360 }
361 
362 contract WINECrowdsale is Ownable, Crowdsale {
363 
364   constructor(address _wallet, ERC20 _token) public Crowdsale(_wallet, _token){
365       
366   }
367   
368   // validates an address - currently only checks that it isn't null
369   modifier validAddress(address _address) {
370       require(_address != 0x0);
371       _;
372   }
373 
374   // verifies that the address is different than this contract address
375   modifier notThis(address _address) {
376       require(_address != address(this));
377       _;
378   }
379 
380   function withdrawTokens(ERC20 _token, address _to, uint256 _amount) public onlyOwner validAddress(_token) validAddress(_to) notThis(_to)
381   {
382       assert(_token.transfer(_to, _amount));
383   }
384   
385   function setNewWallet(address _newWallet) public onlyOwner {
386       require(_newWallet != address(0));
387       wallet = _newWallet;
388   }
389 }