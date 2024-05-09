1 pragma solidity ^0.4.17;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() public {
16     owner = msg.sender;
17   }
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner(){
22     require(msg.sender == owner);
23     _;
24   }
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner public {
30     if (newOwner != address(0)) {
31       owner = newOwner;
32     }
33   }
34 }
35 
36 /**
37  * @title Pausable
38  * @dev Base contract which allows children to implement an emergency stop mechanism.
39  */
40 contract Pausable is Ownable {
41   event Pause();
42   event Unpause();
43   bool public paused = false;
44   /**
45    * @dev modifier to allow actions only when the contract IS paused
46    */
47   modifier whenNotPaused() {
48     require (!paused);
49     _;
50   }
51   /**
52    * @dev modifier to allow actions only when the contract IS NOT paused
53    */
54   modifier whenPaused {
55     require (paused);
56     _;
57   }
58   /**
59    * @dev called by the owner to pause, triggers stopped state
60    */
61   function pause() onlyOwner whenNotPaused  public returns (bool) {
62     paused = true;
63     Pause();
64     return true;
65   }
66   /**
67    * @dev called by the owner to unpause, returns to normal state
68    */
69   function unpause() onlyOwner whenPaused public returns (bool) {
70     paused = false;
71     Unpause();
72     return true;
73   }
74 }
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) public constant returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) public constant returns (uint256);
93   function transferFrom(address from, address to, uint256 value) public returns (bool);
94   function approve(address spender, uint256 value) public returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 /**
99  * @title SafeMath
100  * @dev Math operations with safety checks that throw on error
101  */
102 library SafeMath {
103   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104     uint256 c = a * b;
105     assert(a == 0 || c / a == b);
106     return c;
107   }
108 
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   function add(uint256 a, uint256 b) internal pure returns (uint256) {
122     uint256 c = a + b;
123     assert(c >= a);
124     return c;
125   }
126 }
127 
128 /**
129  * @title Basic token
130  * @dev Basic version of StandardToken, with no allowances.
131  */
132 contract BasicToken is ERC20Basic {
133   using SafeMath for uint256;
134 
135   mapping(address => uint256) balances;
136 
137   /**
138   * @dev transfer token for a specified address
139   * @param _to The address to transfer to.
140     * @param _value The amount to be transferred.
141       */
142   function transfer(address _to, uint256 _value) public returns (bool){
143     require(_to != address(0));
144     require(_value <= balances[msg.sender]);
145     
146     balances[msg.sender] = balances[msg.sender].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     Transfer(msg.sender, _to, _value);
149     return true;
150   }
151 
152   /**
153   * @dev Gets the balance of the specified address.
154   * @param _owner The address to query the the balance of.
155     * @return An uint256 representing the amount owned by the passed address.
156     */
157   function balanceOf(address _owner) public constant returns (uint256 balance) {
158     return balances[_owner];
159   }
160 }
161 
162 
163 
164 /**
165  * @title Standard ERC20 token
166  *
167  * @dev Implementation of the basic standard token.
168  * @dev https://github.com/ethereum/EIPs/issues/20
169  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170  */
171 contract StandardToken is ERC20, BasicToken {
172 
173   mapping (address => mapping (address => uint256)) internal allowed;
174 
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param _from address The address which you want to send tokens from
179    * @param _to address The address which you want to transfer to
180    * @param _value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183     require(_to != address(0));
184     require(_value <= balances[_from]);
185     require(_value <= allowed[_from][msg.sender]);
186 
187     balances[_from] = balances[_from].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190     Transfer(_from, _to, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196    *
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param _owner address The address which owns the funds.
213    * @param _spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(address _owner, address _spender) public view returns (uint256) {
217     return allowed[_owner][_spender];
218   }
219 
220   /**
221    * @dev Increase the amount of tokens that an owner allowed to a spender.
222    *
223    * approve should be called when allowed[_spender] == 0. To increment
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _addedValue The amount of tokens to increase the allowance by.
229    */
230   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
231     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
232     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236   /**
237    * @dev Decrease the amount of tokens that an owner allowed to a spender.
238    *
239    * approve should be called when allowed[_spender] == 0. To decrement
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
247     uint oldValue = allowed[msg.sender][_spender];
248     if (_subtractedValue > oldValue) {
249       allowed[msg.sender][_spender] = 0;
250     } else {
251       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252     }
253     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 
257 }
258 
259 
260 /**
261  * @title Burnable Token
262  * @dev Token that can be irreversibly burned (destroyed).
263  */
264 contract BurnableToken is BasicToken {
265 
266   event Burn(address indexed burner, uint256 value);
267 
268   /**
269    * @dev Burns a specific amount of tokens.
270    * @param _value The amount of token to be burned.
271    */
272   function burn(uint256 _value) public {
273     _burn(msg.sender, _value);
274   }
275 
276   function _burn(address _who, uint256 _value) internal {
277     require(_value <= balances[_who]);
278     // no need to require value <= totalSupply, since that would imply the
279     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
280 
281     balances[_who] = balances[_who].sub(_value);
282     totalSupply = totalSupply.sub(_value);
283     Burn(_who, _value);
284     Transfer(_who, address(0), _value);
285   }
286 }
287 
288 /**
289  * @title Mintable token
290  * @dev Simple ERC20 Token example, with mintable token creation
291  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
292  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
293  */
294 contract MintableToken is StandardToken, Ownable {
295 
296   event Mint(address indexed to, uint256 amount);
297   event MintFinished();
298 
299   bool public mintingFinished = false;
300 
301   uint256 public oneCoin = 10 ** 18;
302   uint256 public maxTokens = 2000 * (10**6) * oneCoin;
303 
304 
305   modifier canMint() {
306     require(!mintingFinished);
307     _;
308   }
309 
310   /**
311   * @dev Function to mint tokens
312   * @param _to The address that will recieve the minted tokens.
313     * @param _amount The amount of tokens to mint.
314     * @return A boolean that indicates if the operation was successful.
315    */
316   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
317 
318     require(totalSupply.add(_amount) <= maxTokens); 
319 
320 
321     totalSupply = totalSupply.add(_amount);
322     balances[_to] = balances[_to].add(_amount);
323     Transfer(0X0, _to, _amount);
324     return true;
325   }
326 
327   /**
328   * @dev Function to stop minting new tokens.
329   * @return True if the operation was successful.
330    */
331   function finishMinting() onlyOwner public returns (bool) {
332     mintingFinished = true;
333     MintFinished();
334     return true;
335   }
336 }
337 
338 // ***********************************************************************************
339 // *************************** END OF THE BASIC **************************************
340 // ***********************************************************************************
341 
342 contract IrisToken is MintableToken, BurnableToken, Pausable {
343   // Coin Properties
344   string public name = "IRIS";
345   string public symbol = "IRIS";
346   uint256 public decimals = 18;
347 
348   // Special propeties
349   bool public tradingStarted = false;
350 
351   /**
352   * @dev modifier that throws if trading has not started yet
353    */
354   modifier hasStartedTrading() {
355     require(tradingStarted);
356     _;
357   }
358 
359   /**
360   * @dev Allows the owner to enable the trading. This can not be undone
361   */
362   function startTrading() public onlyOwner {
363     tradingStarted = true;
364   }
365 
366   /**
367   * @dev Allows anyone to transfer the Change tokens once trading has started
368   * @param _to the recipient address of the tokens.
369   * @param _value number of tokens to be transfered.
370    */
371   function transfer(address _to, uint _value) hasStartedTrading whenNotPaused public returns (bool) {
372     return super.transfer(_to, _value);
373   }
374 
375   /**
376   * @dev Allows anyone to transfer the Change tokens once trading has started
377   * @param _from address The address which you want to send tokens from
378   * @param _to address The address which you want to transfer to
379   * @param _value uint the amout of tokens to be transfered
380    */
381   function transferFrom(address _from, address _to, uint _value) hasStartedTrading whenNotPaused public returns (bool) {
382     return super.transferFrom(_from, _to, _value);
383   }
384 
385   function emergencyERC20Drain( ERC20 oddToken, uint amount ) public {
386     oddToken.transfer(owner, amount);
387   }
388 }
389 
390 contract IrisTokenPrivatSale is Ownable, Pausable{
391 
392   using SafeMath for uint256;
393 
394   // The token being sold
395   IrisToken public token;
396  
397 
398   uint256 public decimals = 18;  
399 
400   uint256 public oneCoin = 10**decimals;
401 
402   address public multiSig; 
403 
404   // ***************************
405   // amount of raised money in wei
406   uint256 public weiRaised;
407 
408   // amount of raised tokens
409   uint256 public tokenRaised;
410   
411   // number of participants in presale
412   uint256 public numberOfPurchasers = 0;
413 
414   event HostEther(address indexed buyer, uint256 value);
415   event TokenPlaced(address indexed beneficiary, uint256 amount); 
416   event SetWallet(address _newWallet);
417   event SendedEtherToMultiSig(address walletaddress, uint256 amountofether);
418 
419   function setWallet(address _newWallet) public onlyOwner {
420     multiSig = _newWallet;
421     SetWallet(_newWallet);
422 }
423   function IrisTokenPrivatSale() public {
424       
425 
426 
427 // *************************************
428 
429     multiSig = 0x02cb1ADc98e984A67a3d892Dbb7eD72b36dA7b07; // IRIS multiSig Wallet Address
430 
431 //**************************************    
432 
433     token = new IrisToken();
434    
435 }
436   
437 
438   function placeTokens(address beneficiary, uint256 _tokens) onlyOwner public {
439     
440     require(_tokens != 0);
441     require (beneficiary != 0x0);
442    // require(!hasEnded());
443     //require(tokenRaised.add(_tokens) <= maxTokens);
444 
445     if (token.balanceOf(beneficiary) == 0) {
446       numberOfPurchasers++;
447     }
448     tokenRaised = tokenRaised.add(_tokens); // so we can go slightly over
449     token.mint(beneficiary, _tokens);
450     TokenPlaced(beneficiary, _tokens); 
451   }
452 
453   // low level token purchase function
454   function buyTokens(address buyer, uint256 amount) whenNotPaused internal {
455     
456     require (multiSig != 0x0);
457     require (msg.value > 1 finney);
458     // update state
459     weiRaised = weiRaised.add(amount);
460    
461     HostEther(buyer, amount);
462     // send the ether to the MultiSig Wallet
463     multiSig.transfer(this.balance);     // better in case any other ether ends up here
464     SendedEtherToMultiSig(multiSig,amount);
465   }
466 
467   // transfer ownership of the token to the owner of the presale contract
468   function transferTokenContractOwnership(address _address) public onlyOwner {
469    
470     token.transferOwnership(_address);
471    
472   }
473 
474   // fallback function can be used to buy tokens
475   function () public payable {
476     buyTokens(msg.sender, msg.value);
477   }
478 
479   function emergencyERC20Drain( ERC20 oddToken, uint amount ) public onlyOwner{
480     oddToken.transfer(owner, amount);
481   }
482 }