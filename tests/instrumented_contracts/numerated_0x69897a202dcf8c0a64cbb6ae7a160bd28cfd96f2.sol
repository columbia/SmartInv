1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public view returns (uint256);
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69   function approve(address spender, uint256 value) public returns (bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 
74 /**
75  * @title Basic token
76  * @dev Basic version of StandardToken, with no allowances.
77  */
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) balances;
82 
83   uint256 totalSupply_;
84 
85   /**
86   * @dev total number of tokens in existence
87   */
88   function totalSupply() public view returns (uint256) {
89     return totalSupply_;
90   }
91 
92   /**
93   * @dev transfer token for a specified address
94   * @param _to The address to transfer to.
95   * @param _value The amount to be transferred.
96   */
97   function transfer(address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[msg.sender]);
100 
101     balances[msg.sender] = balances[msg.sender].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     emit Transfer(msg.sender, _to, _value);
104     return true;
105   }
106 
107   /**
108   * @dev Gets the balance of the specified address.
109   * @param _owner The address to query the the balance of.
110   * @return An uint256 representing the amount owned by the passed address.
111   */
112   function balanceOf(address _owner) public view returns (uint256 balance) {
113     return balances[_owner];
114   }
115 
116 }
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implementation of the basic standard token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is ERC20, BasicToken {
126 
127   mapping (address => mapping (address => uint256)) internal allowed;
128 
129 
130   /**
131    * @dev Transfer tokens from one address to another
132    * @param _from address The address which you want to send tokens from
133    * @param _to address The address which you want to transfer to
134    * @param _value uint256 the amount of tokens to be transferred
135    */
136   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_value <= balances[_from]);
139     require(_value <= allowed[_from][msg.sender]);
140 
141     balances[_from] = balances[_from].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
144     emit Transfer(_from, _to, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
150    *
151    * Beware that changing an allowance with this method brings the risk that someone may use both the old
152    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
153    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
154    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155    * @param _spender The address which will spend the funds.
156    * @param _value The amount of tokens to be spent.
157    */
158   function approve(address _spender, uint256 _value) public returns (bool) {
159     allowed[msg.sender][_spender] = _value;
160     emit Approval(msg.sender, _spender, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Function to check the amount of tokens that an owner allowed to a spender.
166    * @param _owner address The address which owns the funds.
167    * @param _spender address The address which will spend the funds.
168    * @return A uint256 specifying the amount of tokens still available for the spender.
169    */
170   function allowance(address _owner, address _spender) public view returns (uint256) {
171     return allowed[_owner][_spender];
172   }
173 
174   /**
175    * @dev Increase the amount of tokens that an owner allowed to a spender.
176    *
177    * approve should be called when allowed[_spender] == 0. To increment
178    * allowed value is better to use this function to avoid 2 calls (and wait until
179    * the first transaction is mined)
180    * From MonolithDAO Token.sol
181    * @param _spender The address which will spend the funds.
182    * @param _addedValue The amount of tokens to increase the allowance by.
183    */
184   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
185     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190   /**
191    * @dev Decrease the amount of tokens that an owner allowed to a spender.
192    *
193    * approve should be called when allowed[_spender] == 0. To decrement
194    * allowed value is better to use this function to avoid 2 calls (and wait until
195    * the first transaction is mined)
196    * From MonolithDAO Token.sol
197    * @param _spender The address which will spend the funds.
198    * @param _subtractedValue The amount of tokens to decrease the allowance by.
199    */
200   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
201     uint oldValue = allowed[msg.sender][_spender];
202     if (_subtractedValue > oldValue) {
203       allowed[msg.sender][_spender] = 0;
204     } else {
205       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
206     }
207     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211 }
212 
213 /**
214  * @title Ownable
215  * @dev The Ownable contract has an owner address, and provides basic authorization control
216  * functions, this simplifies the implementation of "user permissions".
217  */
218 contract Ownable {
219   address public owner;
220 
221 
222   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
223 
224 
225   /**
226    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
227    * account.
228    */
229   function Ownable() public {
230     owner = msg.sender;
231   }
232 
233   /**
234    * @dev Throws if called by any account other than the owner.
235    */
236   modifier onlyOwner() {
237     require(msg.sender == owner);
238     _;
239   }
240 
241   /**
242    * @dev Allows the current owner to transfer control of the contract to a newOwner.
243    * @param newOwner The address to transfer ownership to.
244    */
245   function transferOwnership(address newOwner) public onlyOwner {
246     require(newOwner != address(0));
247     emit OwnershipTransferred(owner, newOwner);
248     owner = newOwner;
249   }
250 
251 }
252 
253 
254 /**
255  * @title Mintable token
256  * @dev Simple ERC20 Token example, with mintable token creation
257  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
258  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
259  */
260 contract MintableToken is StandardToken, Ownable {
261   event Mint(address indexed to, uint256 amount);
262   event MintFinished();
263 
264   bool public mintingFinished = false;
265 
266 
267   modifier canMint() {
268     require(!mintingFinished);
269     _;
270   }
271 
272   /**
273    * @dev Function to mint tokens
274    * @param _to The address that will receive the minted tokens.
275    * @param _amount The amount of tokens to mint.
276    * @return A boolean that indicates if the operation was successful.
277    */
278   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
279     totalSupply_ = totalSupply_.add(_amount);
280     balances[_to] = balances[_to].add(_amount);
281     emit Mint(_to, _amount);
282     emit Transfer(address(0), _to, _amount);
283     return true;
284   }
285 
286   /**
287    * @dev Function to stop minting new tokens.
288    * @return True if the operation was successful.
289    */
290   function finishMinting() onlyOwner canMint public returns (bool) {
291     mintingFinished = true;
292     emit MintFinished();
293     return true;
294   }
295 }
296 
297 contract VEC is Ownable, MintableToken {
298   using SafeMath for uint256;    
299   string public constant name = "Verified Emission Credit";
300   string public constant symbol = "VEC";
301   uint32 public constant decimals = 0;
302 
303   address public addressTeam; // address of vesting smart contract
304   uint public summTeam;
305 
306   function VEC() public {
307     summTeam =     9500000000;
308     addressTeam =     0x58a2CE10BAe7903829795Bca26A204360213C62e;
309     //Founders and supporters initial Allocations
310     mint(addressTeam, summTeam);
311   }
312 
313 }
314 
315 
316 contract Crowdsale is Ownable {
317   using SafeMath for uint256;
318 
319   // The token being sold
320   VEC public token;
321   //Total number of tokens sold on ICO
322   uint256 public allTokenICO;
323   //max tokens
324   uint256 public maxTokens; 
325   //max Ether
326   uint256 public maxEther; 
327   // Address where funds are collected
328   address public wallet;
329 
330   // How many token units a buyer gets per wei
331   uint256 public rate;
332 
333   // Amount of wei raised
334   uint256 public weiRaised;
335   //start ICO
336   uint256 public startICO;
337 
338   /**
339    * Event for token purchase logging
340    * @param purchaser who paid for the tokens
341    * @param beneficiary who got the tokens
342    * @param value weis paid for purchase
343    * @param amount amount of tokens purchased
344    */
345   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
346 
347 
348   function Crowdsale() public {
349     maxTokens = 500000000; 
350     maxEther = 10000 * 1 ether;
351     rate = 13062;
352     startICO =1523864288; // 04/16/2018 @ 7:38am (UTC)
353     wallet = 0xb382C19879d39E38B4fa77fE047FAdadE002fdAB;
354     token = createTokenContract();
355   }
356   function createTokenContract() internal returns (VEC) {
357     return new VEC();
358   }
359   function setRate(uint256 _rate) public onlyOwner{
360       rate = _rate;
361   }
362   // -----------------------------------------
363   // Crowdsale external interface
364   // -----------------------------------------
365 
366   function () external payable {
367     buyTokens(msg.sender);
368   }
369 
370   /**
371    * @dev low level token purchase ***DO NOT OVERRIDE***
372    * @param _beneficiary Address performing the token purchase
373    */
374   function buyTokens(address _beneficiary) public payable {
375     require(now >= startICO); 
376     require(msg.value <= maxEther);
377     require(allTokenICO <= maxTokens);
378     uint256 weiAmount = msg.value;
379     _preValidatePurchase(_beneficiary, weiAmount);
380 
381     // calculate token amount to be created
382     uint256 tokens = _getTokenAmount(weiAmount);
383 
384     // update state
385     weiRaised = weiRaised.add(weiAmount);
386         
387 
388     _processPurchase(_beneficiary, tokens);
389     // update state
390     allTokenICO = allTokenICO.add(tokens);
391     emit TokenPurchase(
392       msg.sender,
393       _beneficiary,
394       weiAmount,
395       tokens
396     );
397     _forwardFunds();
398   }
399 
400   // -----------------------------------------
401   // Internal interface (extensible)
402   // -----------------------------------------
403 
404   /**
405    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
406    * @param _beneficiary Address performing the token purchase
407    * @param _weiAmount Value in wei involved in the purchase
408    */
409   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal pure {
410     require(_beneficiary != address(0));
411     require(_weiAmount != 0);
412   }
413 
414 
415   /**
416    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
417    * @param _beneficiary Address performing the token purchase
418    * @param _tokenAmount Number of tokens to be emitted
419    */
420   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
421     token.mint(_beneficiary, _tokenAmount);
422   }
423 
424   /**
425    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
426    * @param _beneficiary Address receiving the tokens
427    * @param _tokenAmount Number of tokens to be purchased
428    */
429   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
430     _deliverTokens(_beneficiary, _tokenAmount);
431   }
432 
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