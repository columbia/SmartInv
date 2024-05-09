1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // 'C. 6-4 BC' ERC20 Token Contract
5 //
6 // Symbol      : C64
7 // Name        : C. 6-4 BC
8 // Total supply: 100000000
9 // Decimals    : 18
10 // 30% to Development Team (0x1f900bE6D5Bf06EfBe3928086B46C7D3e67d3135)
11 //
12 //
13 //
14 // ----------------------------------------------------------------------------
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21 
22   /**
23   * @dev Multiplies two numbers, throws on overflow.
24   */
25   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     if (a == 0) {
27       return 0;
28     }
29     c = a * b;
30     assert(c / a == b);
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers, truncating the quotient.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     // uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return a / b;
42   }
43 
44   /**
45   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   /**
53   * @dev Adds two numbers, throws on overflow.
54   */
55   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
56     c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 
63 // ----------------------------------------------------------------------------
64 // ERC Token Standard #20 Interface
65 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
66 // ----------------------------------------------------------------------------
67 contract ERC20Interface {
68 
69     function totalSupply() public view returns (uint256);
70     function balanceOf(address who) public view returns (uint256);
71     function transfer(address to, uint256 value) public returns (bool);
72     function allowance(address owner, address spender) public view returns (uint256);
73     function transferFrom(address from, address to, uint256 value) public returns (bool);
74     function approve(address spender, uint256 value) public returns (bool);
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 
79 
80 // ----------------------------------------------------------------------------
81 // Ownable contract
82 // ----------------------------------------------------------------------------
83 contract Ownable {
84   address public owner;
85 
86   event OwnershipRenounced(address indexed previousOwner);
87   event OwnershipTransferred(
88     address indexed previousOwner,
89     address indexed newOwner
90   );
91 
92 
93   /**
94    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
95    * account.
96    */
97   constructor() public {
98     owner = msg.sender;
99   }
100 
101   /**
102    * @dev Throws if called by any account other than the owner.
103    */
104   modifier onlyOwner() {
105     require(msg.sender == owner);
106     _;
107   }
108 
109   /**
110    * @dev Allows the current owner to transfer control of the contract to a newOwner.
111    * @param newOwner The address to transfer ownership to.
112    */
113   function transferOwnership(address newOwner) public onlyOwner {
114     require(newOwner != address(0));
115     emit OwnershipTransferred(owner, newOwner);
116     owner = newOwner;
117     }
118 }
119 
120 // ----------------------------------------------------------------------------
121 // ERC20 Token, with the addition of symbol, name and decimals and assisted
122 // token transfers
123 // ----------------------------------------------------------------------------
124 contract C64 is ERC20Interface, Ownable {
125     using SafeMath for uint256;
126     string public symbol;
127     string public name;
128     uint8 public decimals;
129     uint256 totalSupply_;
130     uint256 d_fund;
131     uint256 public remainingSupply;
132 
133     mapping(address => uint256) balances;
134     mapping (address => mapping (address => uint256)) internal allowed;
135 
136     // ------------------------------------------------------------------------
137     // Constructor
138     // ------------------------------------------------------------------------
139     constructor () public {
140         symbol = "C64";
141         name = "C. 6-4 BC";
142         decimals = 18;
143         totalSupply_ = 100000000000000000000000000;
144         d_fund = totalSupply_ * 3/10;
145         remainingSupply = totalSupply_ - d_fund;
146         balances[0x1f900bE6D5Bf06EfBe3928086B46C7D3e67d3135] = d_fund;
147         balances[this] = remainingSupply;
148         emit Transfer(address(0), 0x1f900bE6D5Bf06EfBe3928086B46C7D3e67d3135, totalSupply_ * 3/10);
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Total supply
154     // ------------------------------------------------------------------------
155     function totalSupply() public constant returns (uint256) {
156         return totalSupply_;
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Get the token balance for account tokenOwner
162     // ------------------------------------------------------------------------
163     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
164         return balances[tokenOwner];
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Transfer the balance from token owner's account to to account
170     // - Owner's account must have sufficient balance to transfer
171     // - 0 value transfers are allowed
172     // ------------------------------------------------------------------------
173   function mint(address _to, uint256 _value) public onlyOwner returns (bool) {
174     require(_to != address(0));
175     require(_value <= balances[this]);
176 
177     balances[this] = balances[this].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     emit Transfer(msg.sender, _to, _value);
180     remainingSupply = balances[this];
181     return true;
182 }
183 
184 
185     // ------------------------------------------------------------------------
186     // Don't accept ETH
187     // ------------------------------------------------------------------------
188     function () public payable {
189       revert();
190 
191     }
192 
193 
194   /**
195   * @dev transfer token for a specified address
196   * @param _to The address to transfer to.
197   * @param _value The amount to be transferred.
198   */
199   function transfer(address _to, uint256 _value) public returns (bool) {
200     require(_to != address(0));
201     require(_value != 0);
202     require(_value <= balances[msg.sender]);
203 
204     balances[msg.sender] = balances[msg.sender].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     emit Transfer(msg.sender, _to, _value);
207     return true;
208 }
209 
210 
211     /**
212    * @dev Transfer tokens from one address to another
213    * @param _from address The address which you want to send tokens from
214    * @param _to address The address which you want to transfer to
215    * @param _value uint256 the amount of tokens to be transferred
216    */
217   function transferFrom(
218     address _from,
219     address _to,
220     uint256 _value
221   )
222     public
223     returns (bool)
224   {
225     require(_to != address(0));
226     require(_value != 0);
227     require(_value <= balances[_from]);
228     require(_value <= allowed[_from][msg.sender]);
229 
230     balances[_from] = balances[_from].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
233     emit Transfer(_from, _to, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
239    *
240    * Beware that changing an allowance with this method brings the risk that someone may use both the old
241    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
242    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
243    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244    * @param _spender The address which will spend the funds.
245    * @param _value The amount of tokens to be spent.
246    */
247   function approve(address _spender, uint256 _value) public returns (bool) {
248     allowed[msg.sender][_spender] = _value;
249     emit Approval(msg.sender, _spender, _value);
250     return true;
251   }
252 
253   /**
254    * @dev Function to check the amount of tokens that an owner allowed to a spender.
255    * @param _owner address The address which owns the funds.
256    * @param _spender address The address which will spend the funds.
257    * @return A uint256 specifying the amount of tokens still available for the spender.
258    */
259   function allowance(
260     address _owner,
261     address _spender
262    )
263     public
264     view
265     returns (uint256)
266   {
267     return allowed[_owner][_spender];
268   }
269 
270 }
271 
272 
273 /**
274  * @title Crowdsale
275  * @dev Crowdsale is a base contract for managing a token crowdsale,
276  * allowing investors to purchase tokens with ether. This contract implements
277  * such functionality in its most fundamental form and can be extended to provide additional
278  * functionality and/or custom behavior.
279  * The external interface represents the basic interface for purchasing tokens, and conform
280  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
281  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
282  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
283  * behavior.
284  */
285 contract Crowdsale {
286   using SafeMath for uint256;
287 
288   // The token being sold
289   C64 public token;
290 
291   // Address where funds are collected
292   address public wallet;
293 
294   // How many token units a buyer gets per wei
295   uint256 public rate;
296 
297   // Amount of wei raised
298   uint256 public weiRaised;
299 
300   /**
301    * Event for token purchase logging
302    * @param purchaser who paid for the tokens
303    * @param beneficiary who got the tokens
304    * @param value weis paid for purchase
305    * @param amount amount of tokens purchased
306    */
307   event TokenPurchase(
308     address indexed purchaser,
309     address indexed beneficiary,
310     uint256 value,
311     uint256 amount
312   );
313 
314   /**
315    * @param _rate Number of token units a buyer gets per wei
316    * @param _wallet Address where collected funds will be forwarded to
317    * @param _token Address of the token being sold
318    */
319   constructor(uint256 _rate, address _wallet, C64 _token) public {
320     require(_rate > 0);
321     require(_wallet != address(0));
322     require(_token != address(0));
323 
324     rate = _rate;
325     wallet = _wallet;
326     token = _token;
327   }
328 
329   // -----------------------------------------
330   // Crowdsale external interface
331   // -----------------------------------------
332 
333   /**
334    * @dev fallback function ***DO NOT OVERRIDE***
335    */
336   function () external payable {
337     buyTokens(msg.sender);
338   }
339 
340   /**
341    * @dev low level token purchase ***DO NOT OVERRIDE***
342    * @param _beneficiary Address performing the token purchase
343    */
344   function buyTokens(address _beneficiary) public payable {
345 
346     uint256 weiAmount = msg.value;
347     _preValidatePurchase(_beneficiary, weiAmount);
348 
349     // calculate token amount to be created
350     uint256 tokens = _getTokenAmount(weiAmount);
351 
352     // update state
353     weiRaised = weiRaised.add(weiAmount);
354 
355     _processPurchase(_beneficiary, tokens);
356     emit TokenPurchase(
357       msg.sender,
358       _beneficiary,
359       weiAmount,
360       tokens
361     );
362 
363 
364     _forwardFunds();
365   }
366 
367   // -----------------------------------------
368   // Internal interface (extensible)
369   // -----------------------------------------
370 
371   /**
372    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
373    * @param _beneficiary Address performing the token purchase
374    * @param _weiAmount Value in wei involved in the purchase
375    */
376   function _preValidatePurchase(
377     address _beneficiary,
378     uint256 _weiAmount
379   )
380     internal
381   {
382     require(_beneficiary != address(0));
383     require(_weiAmount != 0);
384   }
385 
386 
387   /**
388    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
389    * @param _beneficiary Address performing the token purchase
390    * @param _tokenAmount Number of tokens to be emitted
391    */
392   function _deliverTokens(
393     address _beneficiary,
394     uint256 _tokenAmount
395   )
396     internal
397   {
398     token.mint(_beneficiary, _tokenAmount);
399   }
400 
401   /**
402    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
403    * @param _beneficiary Address receiving the tokens
404    * @param _tokenAmount Number of tokens to be purchased
405    */
406   function _processPurchase(
407     address _beneficiary,
408     uint256 _tokenAmount
409   )
410     internal
411   {
412     _deliverTokens(_beneficiary, _tokenAmount);
413   }
414 
415 
416   /**
417    * @dev Override to extend the way in which ether is converted to tokens.
418    * @param _weiAmount Value in wei to be converted into tokens
419    * @return Number of tokens that can be purchased with the specified _weiAmount
420    */
421   function _getTokenAmount(uint256 _weiAmount)
422     internal view returns (uint256)
423   {
424     return _weiAmount.mul(rate);
425   }
426 
427   /**
428    * @dev Determines how ETH is stored/forwarded on purchases.
429    */
430   function _forwardFunds() internal {
431     wallet.transfer(msg.value);
432   }
433 }