1 pragma solidity ^0.4.18;
2 /*
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
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
60 contract ERC20 is ERC20Basic {
61   function allowance(address owner, address spender) public view returns (uint256);
62   function transferFrom(address from, address to, uint256 value) public returns (bool);
63   function approve(address spender, uint256 value) public returns (bool);
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   uint256 totalSupply_;
72 
73   /**
74   * @dev total number of tokens in existence
75   */
76   function totalSupply() public view returns (uint256) {
77     return totalSupply_;
78   }
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     // SafeMath.sub will throw if there is not enough balance.
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256 balance) {
102     return balances[_owner];
103   }
104 
105 }
106 contract Ownable {
107   address public owner;
108 
109 
110   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111 
112 
113   /**
114    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
115    * account.
116    */
117   function Ownable() public {
118     owner = msg.sender;
119   }
120 
121 
122   /**
123    * @dev Throws if called by any account other than the owner.
124    */
125   modifier onlyOwner() {
126     require(msg.sender == owner);
127     _;
128   }
129 
130 
131   /**
132    * @dev Allows the current owner to transfer control of the contract to a newOwner.
133    * @param newOwner The address to transfer ownership to.
134    */
135   function transferOwnership(address newOwner) public onlyOwner {
136     require(newOwner != address(0));
137     OwnershipTransferred(owner, newOwner);
138     owner = newOwner;
139   }
140 
141 }
142 
143 /**
144  * @title Standard ERC20 token
145  *
146  * @dev Implementation of the basic standard token.
147  * @dev https://github.com/ethereum/EIPs/issues/20
148  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
149  */
150 contract StandardToken is ERC20, BasicToken{
151 
152   mapping (address => mapping (address => uint256)) internal allowed;
153 
154 
155   /**
156    * @dev Transfer tokens from one address to another
157    * @param _from address The address which you want to send tokens from
158    * @param _to address The address which you want to transfer to
159    * @param _value uint256 the amount of tokens to be transferred
160    */
161   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
162     require(_to != address(0));
163     require(_value <= balances[_from]);
164     require(_value <= allowed[_from][msg.sender]);
165 
166     balances[_from] = balances[_from].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169     Transfer(_from, _to, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175    *
176    * Beware that changing an allowance with this method brings the risk that someone may use both the old
177    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180    * @param _spender The address which will spend the funds.
181    * @param _value The amount of tokens to be spent.
182    */
183   function approve(address _spender, uint256 _value) public returns (bool) {
184     allowed[msg.sender][_spender] = _value;
185     Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(address _owner, address _spender) public view returns (uint256) {
196     return allowed[_owner][_spender];
197   }
198 
199   /**
200    * @dev Increase the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To increment
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _addedValue The amount of tokens to increase the allowance by.
208    */
209   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
210     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
211     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215   /**
216    * @dev Decrease the amount of tokens that an owner allowed to a spender.
217    *
218    * approve should be called when allowed[_spender] == 0. To decrement
219    * allowed value is better to use this function to avoid 2 calls (and wait until
220    * the first transaction is mined)
221    * From MonolithDAO Token.sol
222    * @param _spender The address which will spend the funds.
223    * @param _subtractedValue The amount of tokens to decrease the allowance by.
224    */
225   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
226     uint oldValue = allowed[msg.sender][_spender];
227     if (_subtractedValue > oldValue) {
228       allowed[msg.sender][_spender] = 0;
229     } else {
230       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
231     }
232     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236 }
237 /*
238     This create Sancoj token and give all amount to creator.
239 */
240 contract SancojTokenContract is StandardToken,Ownable {
241     string public constant symbol = "SANC";   
242     string public constant name = "Sancoj";
243     uint8 public constant decimals = 18;
244     uint256 public constant INITIAL_SUPPLY = 100000000000 * (10 ** uint256(decimals));
245     /**
246      * Token contract constructor
247      *
248      * setting msg sender as owner
249      */
250     function SancojTokenContract ()public {
251         totalSupply_ = INITIAL_SUPPLY;
252         
253         // Mint tokens
254         balances[msg.sender] = totalSupply_;
255         Transfer(address(0x0), msg.sender, totalSupply_);
256         // Approve allowance for admin account
257         owner = msg.sender;
258     }
259     // This notifies clients about the amount burnt
260     event Burn(address indexed from, uint256 value);
261     
262     //this function will revert all ether paid to this contract
263     function () public payable {
264         revert();
265     }
266     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
267         return ERC20(tokenAddress).transfer(owner, tokens);
268     }
269     function burn(uint256 _value) public returns (bool success) {
270         require(balances[msg.sender] >= _value);   // Check if the sender has enough
271         balances[msg.sender] =balances[msg.sender].sub( _value);            // Subtract from the sender
272         totalSupply_ = totalSupply_.sub(_value);                      // Updates totalSupply
273         Burn(msg.sender, _value);
274         return true;
275     }
276     /**
277      * Destroy tokens from other account
278      *
279      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
280      *
281      * @param _from the address of the sender
282      * @param _value the amount of money to burn
283      */
284     function burnFrom(address _from, uint256 _value) public returns (bool success) {
285         require(balances[_from] >= _value);                // Check if the targeted balance is enough
286         require(_value <= allowed[_from][msg.sender]);    // Check allowance
287         balances[_from] = balances[_from].sub(_value);                       // Subtract from the targeted balance
288         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
289         totalSupply_ = totalSupply_.sub(_value);                              // Update totalSupply
290         Burn(_from, _value);
291         return true;
292     }
293 
294     
295 }
296 
297 
298 /**
299  * @title Crowdsale
300  * @dev Crowdsale is a base contract for managing a token crowdsale,
301  * allowing investors to purchase tokens with ether. This contract implements
302  * such functionality in its most fundamental form and can be extended to provide additional
303  * functionality and/or custom behavior.
304  * The external interface represents the basic interface for purchasing tokens, and conform
305  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
306  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
307  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
308  * behavior.
309  */
310 contract Crowdsale  is Ownable{
311   using SafeMath for uint256;
312 
313   // The token being sold
314   SancojTokenContract public token;
315 
316   // Address where funds are collected
317   address public wallet;
318 
319   // How many token units a buyer gets per wei
320   uint256 public rate;
321 
322   // Amount of wei raised
323   uint256 public weiRaised;
324   
325   //Address which allow contract to spend
326   address public tokenWallet;
327 
328   /**
329    * Event for token purchase logging
330    * @param purchaser who paid for the tokens
331    * @param beneficiary who got the tokens
332    * @param value weis paid for purchase
333    * @param amount amount of tokens purchased
334    */
335   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
336 
337   /**
338    * @param _rate Number of token units a buyer gets per wei
339    * @param _wallet Address where collected funds will be forwarded to
340    * @param _token Address of the token being sold
341    */
342   function Crowdsale(uint256 _rate, address _wallet, SancojTokenContract _token, address _tokenWallet, address _owner) public {
343     require(_rate > 0);
344     require(_wallet != address(0));
345     require(_token != address(0));
346     require(_tokenWallet != address(0));
347 
348     rate = _rate;
349     wallet = _wallet;
350     token = _token;
351     tokenWallet = _tokenWallet;
352     owner = _owner;
353   }
354 
355   // -----------------------------------------
356   // Crowdsale external interface
357   // -----------------------------------------
358 
359   /**
360    * @dev fallback function ***DO NOT OVERRIDE***
361    */
362   function () external payable {
363     buyTokens(msg.sender);
364   }
365 
366   /**
367    * @dev low level token purchase ***DO NOT OVERRIDE***
368    * @param _beneficiary Address performing the token purchase
369    */
370   function buyTokens(address _beneficiary) public payable {
371 
372     uint256 weiAmount = msg.value;
373     _preValidatePurchase(_beneficiary, weiAmount);
374 
375     // calculate token amount to be created
376     uint256 tokens = _getTokenAmount(weiAmount);
377 
378     // update state
379     weiRaised = weiRaised.add(weiAmount);
380 
381     _processPurchase(_beneficiary, tokens);
382     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
383 
384     _forwardFunds();
385   }
386 
387   // -----------------------------------------
388   // Internal interface (extensible)
389   // -----------------------------------------
390 
391   /**
392    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
393    * @param _beneficiary Address performing the token purchase
394    * @param _weiAmount Value in wei involved in the purchase
395    */
396   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
397     require(_beneficiary != address(0));
398     require(_weiAmount != 0);
399   }
400   /**
401    * @dev Checks the amount of tokens left in the allowance.
402    * @return Amount of tokens left in the allowance
403    */
404   function remainingTokens() public view returns (uint256) {
405     return token.allowance(tokenWallet, this);
406   }
407 
408   
409   /**
410    * @dev Overrides parent behavior by transferring tokens from wallet.
411    * @param _beneficiary Token purchaser
412    * @param _tokenAmount Amount of tokens purchased
413    */
414   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
415     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
416   }
417   /**
418    * @dev Burn remianing tokens after the ico,
419    * @param _tokenAmount Amount of token left after ico and to be burn
420   */
421   function _burnTokens(uint256 _tokenAmount)  onlyOwner public{
422       token.burnFrom(tokenWallet, _tokenAmount);
423   }
424 
425   /**
426    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
427    * @param _beneficiary Address receiving the tokens
428    * @param _tokenAmount Number of tokens to be purchased
429    */
430   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
431     _deliverTokens(_beneficiary, _tokenAmount);
432   }
433 
434   /**
435    * @dev Override to extend the way in which ether is converted to tokens.
436    * @param _weiAmount Value in wei to be converted into tokens
437    * @return Number of tokens that can be purchased with the specified _weiAmount
438    */
439   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
440     return _weiAmount.mul(rate);
441   }
442 
443   /**
444    * @dev Determines how ETH is stored/forwarded on purchases.
445    */
446   function _forwardFunds() internal {
447     wallet.transfer(msg.value);
448   }
449 }