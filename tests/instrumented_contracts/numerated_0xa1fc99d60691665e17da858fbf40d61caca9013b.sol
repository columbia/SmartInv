1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Afeli presale. version 1.0
5 //
6 // Begemot-Begemot Ltd 2018. The MIT Licence.
7 // ----------------------------------------------------------------------------
8 
9 
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58     
59   using SafeMath for uint256;
60   address public owner;
61 
62 
63   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   function Ownable() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     owner = newOwner;
89   }
90 
91 }
92 
93 contract ERC20Basic is Ownable {
94   function totalSupply() public view returns (uint256);
95   function balanceOf(address who) public view returns (uint256);
96   function transfer(address to, uint256 value) public returns (bool);
97   event Transfer(address indexed from, address indexed to, uint256 value);
98 }
99 
100 contract BasicToken is ERC20Basic {
101   using SafeMath for uint256;
102 
103   mapping(address => uint256) balances;
104 
105   uint256 totalSupply_;
106 
107   /**
108   * @dev total number of tokens in existence
109   */
110   function totalSupply() public view returns (uint256) {
111     return totalSupply_;
112   }
113 
114   /**
115   * @dev transfer token for a specified address
116   * @param _to The address to transfer to.
117   * @param _value The amount to be transferred.
118   */
119   function transfer(address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[msg.sender]);
122 
123     // SafeMath.sub will throw if there is not enough balance.
124     balances[msg.sender] = balances[msg.sender].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     Transfer(msg.sender, _to, _value);
127     return true;
128   }
129 
130   /**
131   * @dev Gets the balance of the specified address.
132   * @param _owner The address to query the the balance of.
133   * @return An uint256 representing the amount owned by the passed address.
134   */
135   function balanceOf(address _owner) public view returns (uint256 balance) {
136     return balances[_owner];
137   }
138 
139 }
140 
141 contract ERC20 is ERC20Basic {
142   function allowance(address owner, address spender) public view returns (uint256);
143   function transferFrom(address from, address to, uint256 value) public returns (bool);
144   function approve(address spender, uint256 value) public returns (bool);
145   event Approval(address indexed owner, address indexed spender, uint256 value);
146 }
147 
148 contract StandardToken is ERC20, BasicToken {
149 
150   mapping (address => mapping (address => uint256)) internal allowed;
151 
152 
153   /**
154    * @dev Transfer tokens from one address to another
155    * @param _from address The address which you want to send tokens from
156    * @param _to address The address which you want to transfer to
157    * @param _value uint256 the amount of tokens to be transferred
158    */
159   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
160     require(_to != address(0));
161     require(_value <= balances[_from]);
162     require(_value <= allowed[_from][msg.sender]);
163 
164     balances[_from] = balances[_from].sub(_value);
165     balances[_to] = balances[_to].add(_value);
166     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
167     Transfer(_from, _to, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173    *
174    * Beware that changing an allowance with this method brings the risk that someone may use both the old
175    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
176    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
177    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178    * @param _spender The address which will spend the funds.
179    * @param _value The amount of tokens to be spent.
180    */
181   function approve(address _spender, uint256 _value) public returns (bool) {
182     allowed[msg.sender][_spender] = _value;
183     return true;
184   }
185 
186   /**
187    * @dev Function to check the amount of tokens that an owner allowed to a spender.
188    * @param _owner address The address which owns the funds.
189    * @param _spender address The address which will spend the funds.
190    * @return A uint256 specifying the amount of tokens still available for the spender.
191    */
192   function allowance(address _owner, address _spender) public view returns (uint256) {
193     return allowed[_owner][_spender];
194   }
195 
196   /**
197    * @dev Increase the amount of tokens that an owner allowed to a spender.
198    *
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
207     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
208     return true;
209   }
210 
211   /**
212    * @dev Decrease the amount of tokens that an owner allowed to a spender.
213    *
214    * approve should be called when allowed[_spender] == 0. To decrement
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param _spender The address which will spend the funds.
219    * @param _subtractedValue The amount of tokens to decrease the allowance by.
220    */
221   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
222     uint oldValue = allowed[msg.sender][_spender];
223     if (_subtractedValue > oldValue) {
224       allowed[msg.sender][_spender] = 0;
225     } else {
226       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
227     }
228     return true;
229   }
230 
231 }
232 
233 contract BurnableToken is StandardToken {
234 
235   event Burn(address indexed burner, uint256 value);
236 
237   /**
238    * @dev Burns a specific amount of tokens.
239    * @param _value The amount of token to be burned.
240    */
241   function burn(uint256 _value) public {
242     require(_value <= balances[msg.sender]);
243     // no need to require value <= totalSupply, since that would imply the
244     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
245 
246     address burner = msg.sender;
247     balances[burner] = balances[burner].sub(_value);
248     totalSupply_ = totalSupply_.sub(_value);
249     Transfer(burner, address(0), _value);
250   }
251 }
252 
253 contract MintableToken is BurnableToken {
254   event Mint(address indexed to, uint256 amount);
255   event MintFinished();
256 
257   bool public mintingFinished = false;
258   address public saleAddress;
259 
260   modifier canMint() {
261     require(!mintingFinished);
262     _;
263   }
264   
265   modifier onlyManagment() {
266     require(msg.sender == owner || msg.sender == saleAddress);
267     _;
268   }
269 
270   function transferManagment(address newSaleAddress) public onlyOwner {
271     if (newSaleAddress != address(0)) {
272       saleAddress = newSaleAddress;
273     }
274   }
275 
276   /**
277    * @dev Function to mint tokens
278    * @param _to The address that will receive the minted tokens.
279    * @param _amount The amount of tokens to mint.
280    * @return A boolean that indicates if the operation was successful.
281    */
282   function mint(address _to, uint256 _amount) onlyManagment canMint public returns (bool) {
283     totalSupply_ = totalSupply_.add(_amount);
284     balances[_to] = balances[_to].add(_amount);
285     Transfer(address(0), _to, _amount);
286     return true;
287   }
288 
289   /**
290    * @dev Function to stop minting new tokens.
291    * @return True if the operation was successful.
292    */
293   function finishMinting() onlyOwner canMint public returns (bool) {
294     mintingFinished = true;
295     return true;
296   }
297 }
298 
299 contract AfeliCoin is MintableToken {
300 
301   string public name = "Afeli Coin";
302   string public symbol = "AEI";
303   uint8 public decimals = 18;
304   
305 }
306 
307 
308 /**
309  * @title Pausable
310  * @dev Base contract which allows children to implement an emergency stop mechanism.
311  */
312 contract Pausable is Ownable {
313 
314   bool public paused = false;
315 
316   /**
317    * @dev Modifier to make a function callable only when the contract is not paused.
318    */
319   modifier whenNotPaused() {
320     require(!paused);
321     _;
322   }
323 
324   /**
325    * @dev Modifier to make a function callable only when the contract is paused.
326    */
327   modifier whenPaused() {
328     require(paused);
329     _;
330   }
331 
332   /**
333    * @dev called by the owner to pause, triggers stopped state
334    */
335   function pause() onlyOwner whenNotPaused public {
336     paused = true;
337   }
338 
339   /**
340    * @dev called by the owner to unpause, returns to normal state
341    */
342   function unpause() onlyOwner whenPaused public {
343     paused = false;
344   }
345 }
346 
347 contract AfeliCoinPresale is Pausable {
348     using SafeMath for uint256;
349 
350     address public organisationWallet = 0xa56B96235903b1631BC355DC0CFD8511F31D883b;
351     AfeliCoin public tokenReward;
352 
353     uint256 public tokenPrice = 1000; // 1 token = 0.001 eth
354     uint256 public minimalPrice = 1000000000000000; // 0.001 eth
355     uint256 public discount = 25;
356     uint256 public amountRaised;
357 
358     bool public finished = false;
359     bool public presaleFail = false;
360 
361     mapping (address => uint256) public balanceOf;
362     event FundTransfer(address backer, uint amount, bool isContribution);
363 
364     function AfeliCoinPresale(address _tokenReward) public {
365         tokenReward = AfeliCoin(_tokenReward);
366     }
367 
368     modifier whenNotFinished() {
369         require(!finished);
370         _;
371     }
372 
373     modifier afterPresaleFail() {
374         require(presaleFail);
375         _;
376     }
377 
378     function () public payable {
379         buy(msg.sender);
380     }
381 
382     function buy(address buyer) whenNotPaused whenNotFinished public payable {
383         require(buyer != address(0));
384         require(msg.value != 0);
385         require(msg.value >= minimalPrice);
386 
387         uint256 amount = msg.value;
388         uint256 tokens = amount.mul(tokenPrice).mul(discount.add(100)).div(100);
389 
390         balanceOf[buyer] = balanceOf[buyer].add(amount);
391 
392         tokenReward.mint(buyer, tokens);
393         amountRaised = amountRaised.add(amount);
394     }
395 
396     function updatePrice(uint256 _tokenPrice) public onlyOwner {
397         tokenPrice = _tokenPrice;
398     }
399 
400     function updateMinimal(uint256 _minimalPrice) public onlyOwner {
401         minimalPrice = _minimalPrice;
402     }
403     
404     function updateDiscount(uint256 _discount) public onlyOwner {
405         discount = _discount;
406     }
407 
408     function finishPresale() public onlyOwner {
409         organisationWallet.transfer(amountRaised.mul(3).div(100));
410         owner.transfer(address(this).balance);
411         finished = true;
412     }
413 
414     function setPresaleFail() public onlyOwner {
415         finished = true;
416         presaleFail = true;
417     }
418 
419     function safeWithdrawal() public afterPresaleFail {
420         uint amount = balanceOf[msg.sender];
421         msg.sender.transfer(amount);
422         balanceOf[msg.sender] = 0;
423     }
424 
425 }