1 pragma solidity ^0.4.19;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23   address public owner;
24 
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28 
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   function Ownable() public {
34     owner = msg.sender;
35   }
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address newOwner) public onlyOwner {
50     require(newOwner != address(0));
51     emit OwnershipTransferred(owner, newOwner);
52     owner = newOwner;
53   }
54 
55 }
56 
57 /**
58  * @title Pausable
59  * @dev Base contract which allows children to implement an emergency stop mechanism.
60  */
61 contract Pausable is Ownable {
62   event Pause();
63   event Unpause();
64 
65   bool public paused = false;
66 
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is not paused.
70    */
71   modifier whenNotPaused() {
72     require(!paused);
73     _;
74   }
75 
76   /**
77    * @dev Modifier to make a function callable only when the contract is paused.
78    */
79   modifier whenPaused() {
80     require(paused);
81     _;
82   }
83 
84   /**
85    * @dev called by the owner to pause, triggers stopped state
86    */
87   function pause() onlyOwner whenNotPaused public {
88     paused = true;
89     emit Pause();
90   }
91 
92   /**
93    * @dev called by the owner to unpause, returns to normal state
94    */
95   function unpause() onlyOwner whenPaused public {
96     paused = false;
97     emit Unpause();
98   }
99 }
100 
101 /**
102  * @title SafeMath
103  * @dev Math operations with safety checks that throw on error
104  */
105 library SafeMath {
106 
107   /**
108   * @dev Multiplies two numbers, throws on overflow.
109   */
110   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111     if (a == 0) {
112       return 0;
113     }
114     uint256 c = a * b;
115     assert(c / a == b);
116     return c;
117   }
118 
119   /**
120   * @dev Integer division of two numbers, truncating the quotient.
121   */
122   function div(uint256 a, uint256 b) internal pure returns (uint256) {
123     // assert(b > 0); // Solidity automatically throws when dividing by 0
124     uint256 c = a / b;
125     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126     return c;
127   }
128 
129   /**
130   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
131   */
132   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133     assert(b <= a);
134     return a - b;
135   }
136 
137   /**
138   * @dev Adds two numbers, throws on overflow.
139   */
140   function add(uint256 a, uint256 b) internal pure returns (uint256) {
141     uint256 c = a + b;
142     assert(c >= a);
143     return c;
144   }
145 }
146 
147 /**
148  * @title Crowdsale
149  * @dev Crowdsale is a base contract for managing a token crowdsale,
150  * allowing investors to purchase tokens with ether. This contract implements
151  * such functionality in its most fundamental form and can be extended to provide additional
152  * functionality and/or custom behavior.
153  * The external interface represents the basic interface for purchasing tokens, and conform
154  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
155  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
156  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
157  * behavior.
158  */
159 
160 contract Crowdsale is Pausable {
161   using SafeMath for uint256;
162 
163   // The token being sold VIVID
164   // 0x7d8467f9621535c71bdab07529b33e4bd0d3f0ef
165   ERC20 public token;
166 
167   //Wallet where funds will be 
168   //0xe5DfC8b68d3473c41435bE29bea9D991BfB70895
169   address public tokenWallet;
170 
171   // Address where funds are collected
172   // 0x8330E12E1Be12D4302440AE351eF4385342b397A
173   address public wallet;
174 
175   // How many token units a buyer gets per wei
176   // should be set to 10000
177   uint256 public baseRate;
178 
179   // Amount of wei raised
180   uint256 public weiRaised;
181 
182   uint256 public cap;
183 
184   uint256 public openingTime;
185 
186   uint256 firstTierRate = 20;
187   uint256 secondTierRate = 10;
188   uint256 thirdTierRate = 5;
189 
190   mapping(address => uint256) public balances;
191 
192   modifier onlyWhileOpen {
193     require(now >= openingTime && weiRaised < cap);
194     _;
195   }
196   /**
197    * Event for token purchase logging
198    * @param purchaser who paid for the tokens
199    * @param beneficiary who got the tokens
200    * @param value weis paid for purchase
201    * @param amount amount of tokens purchased
202    */
203   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
204 
205   /**
206    * @param _rate Number of token units a buyer gets per wei
207    * @param _wallet Address where collected funds will be forwarded to
208    * @param _token Address of the token being sold
209    */
210   function Crowdsale(uint256 _openingTime, uint256 _rate, address _wallet, ERC20 _token, uint256 _cap, address _tokenWallet) public {
211     require(_rate > 0);
212     require(_wallet != address(0));
213     require(_token != address(0));
214     require(_cap > 0);
215     require(_tokenWallet != address(0));
216 
217     openingTime = _openingTime;
218     baseRate = _rate;
219     wallet = _wallet;
220     token = _token;
221     cap = _cap;
222     tokenWallet = _tokenWallet;
223   }
224 
225   function capReached() public view returns (bool) {
226     return weiRaised >= cap;
227   }
228 
229   function remainingTokens() public view returns (uint256) {
230     return token.allowance(tokenWallet, this);
231   }
232 
233   /**
234    * @dev Withdraw tokens only after crowdsale ends.
235    */
236   function withdrawTokens() public {
237     require(capReached());
238     uint256 amount = balances[msg.sender];
239     require(amount > 0);
240     balances[msg.sender] = 0;
241     _deliverTokens(msg.sender, amount);
242   }
243 
244   /**
245    * @dev Withdraw tokens or other users.
246    */
247   function withdrawTokensFor(address _accountToWithdrawFor) public onlyOwner {
248     uint256 amount = balances[_accountToWithdrawFor];
249     require(amount > 0);
250     balances[_accountToWithdrawFor] = 0;
251     _deliverTokens(_accountToWithdrawFor, amount);
252   }
253 
254   // -----------------------------------------
255   // Crowdsale external interface
256   // -----------------------------------------
257 
258   /**
259    * @dev fallback function ***DO NOT OVERRIDE***
260    */
261   function () external whenNotPaused payable {
262     buyTokens(msg.sender);
263   }
264 
265   /**
266    * @dev low level token purchase ***DO NOT OVERRIDE***
267    * @param _beneficiary Address performing the token purchase
268    */
269   function buyTokens(address _beneficiary) public payable {
270 
271     uint256 weiAmount = msg.value;
272     _preValidatePurchase(_beneficiary, weiAmount);
273 
274     // calculate token amount to be created
275     uint256 tokens = _getTokenAmount(weiAmount);
276 
277     // update state
278     weiRaised = weiRaised.add(weiAmount);
279 
280     _processPurchase(_beneficiary, tokens);
281     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
282     
283     _forwardFunds();
284   }
285 
286   // -----------------------------------------
287   // Internal interface (extensible)
288   // -----------------------------------------
289 
290   /**
291    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
292    * @param _beneficiary Address performing the token purchase
293    * @param _weiAmount Value in wei involved in the purchase
294    */
295   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view onlyWhileOpen {
296     require(_beneficiary != address(0));
297     //Minimum Purchase is going to be .01 Ether
298     //.01 = 10000000000000000
299     require(_weiAmount > 10000000000000000);
300     require(weiRaised.add(_weiAmount) <= cap);
301   }
302 
303   /**
304    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
305    * @param _beneficiary Address performing the token purchase
306    * @param _tokenAmount Number of tokens to be emitted
307    */
308   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
309     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
310   }
311 
312   /**
313    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
314    * @param _beneficiary Address receiving the tokens
315    * @param _tokenAmount Number of tokens to be purchased
316    */
317   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
318     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
319   }
320 
321   /**
322    * @dev Override to extend the way in which ether is converted to tokens.
323    * @param _weiAmount Value in wei to be converted into tokens
324    * @return Number of tokens that can be purchased with the specified _weiAmount
325    */
326   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
327       uint256 bonusRate;
328       uint256 realRate;
329 	  if (weiRaised <= 450 ether) {
330 		   bonusRate = baseRate.mul(firstTierRate).div(100);
331 		   realRate = baseRate.add(bonusRate);
332 		  return _weiAmount.mul(realRate);
333 	  } else if (weiRaised <= 800 ether) {
334 		   bonusRate = baseRate.mul(secondTierRate).div(100);
335 		   realRate = baseRate.add(bonusRate);
336 		  return _weiAmount.mul(realRate);
337 	  } else if (weiRaised <= 3000 ether) {
338 		   bonusRate = baseRate.mul(thirdTierRate).div(100);
339 		   realRate = baseRate.add(bonusRate);
340 		  return _weiAmount.mul(realRate);
341 	  } else {
342 		  return _weiAmount.mul(baseRate);
343 	  }
344   }
345 
346   /**
347    * @dev Determines how ETH is stored/forwarded on purchases.
348    */
349   function _forwardFunds() internal {
350     wallet.transfer(msg.value);
351   }
352 }