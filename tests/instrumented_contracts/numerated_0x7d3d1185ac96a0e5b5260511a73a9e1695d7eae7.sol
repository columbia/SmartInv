1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 /**
46  * @title ERC20Basic
47  * @dev Simpler version of ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20Basic {
51   function totalSupply() public view returns (uint256);
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59 
60   mapping(address => uint256) balances;
61 
62   uint256 totalSupply_;
63 
64   /**
65   * @dev total number of tokens in existence
66   */
67   function totalSupply() public view returns (uint256) {
68     return totalSupply_;
69   }
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[msg.sender]);
79 
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     emit Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   /**
87   * @dev Gets the balance of the specified address.
88   * @param _owner The address to query the the balance of.
89   * @return An uint256 representing the amount owned by the passed address.
90   */
91   function balanceOf(address _owner) public view returns (uint256) {
92     return balances[_owner];
93   }
94 
95 }
96 
97 /**
98  * @title ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/20
100  */
101 contract ERC20 is ERC20Basic {
102   function allowance(address owner, address spender) public view returns (uint256);
103   function transferFrom(address from, address to, uint256 value) public returns (bool);
104   function approve(address spender, uint256 value) public returns (bool);
105   event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 contract StandardToken is ERC20, BasicToken {
109 
110   mapping (address => mapping (address => uint256)) internal allowed;
111 
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[_from]);
122     require(_value <= allowed[_from][msg.sender]);
123 
124     balances[_from] = balances[_from].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127     emit Transfer(_from, _to, _value);
128     return true;
129   }
130 
131   /**
132    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133    *
134    * Beware that changing an allowance with this method brings the risk that someone may use both the old
135    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138    * @param _spender The address which will spend the funds.
139    * @param _value The amount of tokens to be spent.
140    */
141   function approve(address _spender, uint256 _value) public returns (bool) {
142     allowed[msg.sender][_spender] = _value;
143     emit Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param _owner address The address which owns the funds.
150    * @param _spender address The address which will spend the funds.
151    * @return A uint256 specifying the amount of tokens still available for the spender.
152    */
153   function allowance(address _owner, address _spender) public view returns (uint256) {
154     return allowed[_owner][_spender];
155   }
156 
157   /**
158    * @dev Increase the amount of tokens that an owner allowed to a spender.
159    *
160    * approve should be called when allowed[_spender] == 0. To increment
161    * allowed value is better to use this function to avoid 2 calls (and wait until
162    * the first transaction is mined)
163    * From MonolithDAO Token.sol
164    * @param _spender The address which will spend the funds.
165    * @param _addedValue The amount of tokens to increase the allowance by.
166    */
167   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173   /**
174    * @dev Decrease the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To decrement
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _subtractedValue The amount of tokens to decrease the allowance by.
182    */
183   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
184     uint oldValue = allowed[msg.sender][_spender];
185     if (_subtractedValue > oldValue) {
186       allowed[msg.sender][_spender] = 0;
187     } else {
188       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
189     }
190     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 }
194 /**
195  * @title Ownable
196  * @dev The Ownable contract has an owner address, and provides basic authorization control 
197  * functions, this simplifies the implementation of "user permissions". 
198  */
199 contract Ownable {
200   address public owner;
201 
202 
203   event OwnershipRenounced(address indexed previousOwner);
204   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
205 
206 
207   /**
208    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
209    * account.
210    */
211   constructor() public {
212     owner = msg.sender;
213   }
214 
215   /**
216    * @dev Throws if called by any account other than the owner.
217    */
218   modifier onlyOwner() {
219     require(msg.sender == owner);
220     _;
221   }
222 
223   /**
224    * @dev Allows the current owner to transfer control of the contract to a newOwner.
225    * @param newOwner The address to transfer ownership to.
226    */
227   function transferOwnership(address newOwner) public onlyOwner {
228     require(newOwner != address(0));
229     emit OwnershipTransferred(owner, newOwner);
230     owner = newOwner;
231   }
232 
233   /**
234    * @dev Allows the current owner to relinquish control of the contract.
235    */
236   function renounceOwnership() public onlyOwner {
237     emit OwnershipRenounced(owner);
238     owner = address(0);
239   }
240 }
241 
242 
243 contract MintableToken is StandardToken, Ownable {
244   event Mint(address indexed to, uint256 amount);
245   event MintFinished();
246 
247   bool public mintingFinished = false;
248 
249 
250   modifier canMint() {
251     require(!mintingFinished);
252     _;
253   }
254 
255   modifier hasMintPermission() {
256     require(msg.sender == owner);
257     _;
258   }
259 
260   /**
261    * @dev Function to mint tokens
262    * @param _to The address that will receive the minted tokens.
263    * @param _amount The amount of tokens to mint.
264    * @return A boolean that indicates if the operation was successful.
265    */
266   function mint(address _to, uint256 _amount) hasMintPermission canMint public returns (bool) {
267     totalSupply_ = totalSupply_.add(_amount);
268     balances[_to] = balances[_to].add(_amount);
269     emit Mint(_to, _amount);
270     emit Transfer(address(0), _to, _amount);
271     return true;
272   }
273 
274   /**
275    * @dev Function to stop minting new tokens.
276    * @return True if the operation was successful.
277    */
278   function finishMinting() onlyOwner canMint public returns (bool) {
279     mintingFinished = true;
280     emit MintFinished();
281     return true;
282   }
283 }
284 
285 contract CappedToken is MintableToken {
286 
287   uint256 public cap;
288 
289   constructor(uint256 _cap) public {
290     require(_cap > 0);
291     cap = _cap;
292   }
293 
294   /**
295    * @dev Function to mint tokens
296    * @param _to The address that will receive the minted tokens.
297    * @param _amount The amount of tokens to mint.
298    * @return A boolean that indicates if the operation was successful.
299    */
300   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
301     require(totalSupply_.add(_amount) <= cap);
302 
303     return super.mint(_to, _amount);
304   }
305 
306 }
307 
308 
309 
310 /**
311  * @title BitplusToken
312  * @dev Very simple ERC20 Token
313  */
314 contract HabibiCoin is CappedToken {
315   string public name = "HabibiCoin";
316   string public symbol = "HBB";
317   uint256 public decimals = 18;
318   
319   constructor(uint256 _cap) CappedToken(_cap) Ownable() public { 
320   }  
321 }
322 
323 contract Crowdsale is Ownable {
324   using SafeMath for uint256;
325 
326   // The token being sold
327   ERC20 public token;
328 
329   // Address where funds are collected
330   address public wallet;
331 
332   // How many token units a buyer gets per wei
333   uint256 public rate;
334 
335   // Amount of wei raised
336   uint256 public weiRaised;
337 
338   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
339 
340   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
341     require(_rate > 0);
342     require(_wallet != address(0));
343     require(_token != address(0));
344 
345     rate = _rate;
346     wallet = _wallet;
347     token = _token;
348   }
349 
350   function () external payable {
351     buyTokens(msg.sender);
352   }
353 
354   function buyTokens(address _beneficiary) public payable {
355 
356     uint256 weiAmount = msg.value;
357     _preValidatePurchase(_beneficiary, weiAmount);
358 
359     // calculate token amount to be created
360     uint256 tokens = _getTokenAmount(weiAmount);
361 
362     // update state
363     weiRaised = weiRaised.add(weiAmount);
364 
365     _processPurchase(_beneficiary, tokens);
366     emit TokenPurchase(
367       msg.sender,
368       _beneficiary,
369       weiAmount,
370       tokens
371     );
372 
373     _forwardFunds();
374   }
375 
376   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
377     require(_beneficiary != address(0));
378     require(_weiAmount != 0);
379   }
380 
381   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
382     token.transfer(_beneficiary, _tokenAmount);
383   }
384 
385   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
386     _deliverTokens(_beneficiary, _tokenAmount);
387   }
388 
389   /**
390    * @dev Override to extend the way in which ether is converted to tokens.
391    * @param _weiAmount Value in wei to be converted into tokens
392    * @return Number of tokens that can be purchased with the specified _weiAmount
393    */
394   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
395     return _weiAmount.mul(rate);
396   }
397 
398   /**
399    * @dev Determines how ETH is stored/forwarded on purchases.
400    */
401   function _forwardFunds() internal {
402     wallet.transfer(msg.value);
403   }
404 }
405 
406 contract MintedCrowdsale is Crowdsale {
407 
408   /**
409    * @dev Overrides delivery by minting tokens upon purchase.
410    * @param _beneficiary Token purchaser
411    * @param _tokenAmount Number of tokens to be minted
412    */
413   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
414     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
415   }
416 }
417 
418 contract HabibiCrowdsale is MintedCrowdsale {
419 
420   // is crowdsale active
421   bool active;
422 
423   constructor(uint256 _rate, address _wallet, ERC20 _token) Crowdsale(_rate, _wallet, _token) Ownable() public {
424     active = true;
425   }
426   
427   function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
428       return HabibiCoin(token).mint(_to, _amount);
429   }
430   
431   function changeTokenOwner(address _to) public onlyOwner {
432       HabibiCoin(token).transferOwnership(_to);
433   }
434   
435   /**
436    * @dev Function to stop minting new tokens in crowdsale(initial distribution).
437    * @return True if the operation was successful.
438    */
439   function finishMinting() public onlyOwner returns (bool) {
440     return HabibiCoin(token).finishMinting();
441   }      
442   
443   function stopCrowdsale() public onlyOwner {
444       active = false;
445   }
446   
447   function startCrowdsale() public onlyOwner {
448       active = true;
449   }
450   
451   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal
452   {
453       require(active == true);
454       super._preValidatePurchase(_beneficiary, _weiAmount);
455   }
456   
457   function setNewRate(uint256 newRate) public onlyOwner
458   {
459       rate = newRate;
460   }
461 }