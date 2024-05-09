1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   mapping (address => bool) public owners;
34 
35   event OwnershipAdded(address indexed assigner, address indexed newOwner);
36   event OwnershipDeleted(address indexed assigner, address indexed deletedOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owners[msg.sender] = true;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(owners[msg.sender] == true);
53     _;
54   }
55   
56   function addOwner(address newOwner) onlyOwner public {
57     require(newOwner != address(0));
58     OwnershipAdded(msg.sender, newOwner);
59     owners[newOwner] = true;
60   }
61   
62   function removeOwner(address removedOwner) onlyOwner public {
63     require(removedOwner != address(0));
64     OwnershipDeleted(msg.sender, removedOwner);
65     delete owners[removedOwner];
66   }
67 
68 }
69 
70 contract Pausable is Ownable {
71   event Pause();
72   event Unpause();
73 
74   bool public paused = false;
75 
76 
77   /**
78    * @dev Modifier to make a function callable only when the contract is not paused.
79    */
80   modifier whenNotPaused() {
81     require(!paused);
82     _;
83   }
84 
85   /**
86    * @dev Modifier to make a function callable only when the contract is paused.
87    */
88   modifier whenPaused() {
89     require(paused);
90     _;
91   }
92 
93   /**
94    * @dev called by the owner to pause, triggers stopped state
95    */
96   function pause() onlyOwner whenNotPaused public {
97     paused = true;
98     Pause();
99   }
100 
101   /**
102    * @dev called by the owner to unpause, returns to normal state
103    */
104   function unpause() onlyOwner whenPaused public {
105     paused = false;
106     Unpause();
107   }
108 }
109 
110 contract ERC20Basic {
111   uint256 public totalSupply;
112   function balanceOf(address who) public view returns (uint256);
113   function transfer(address to, uint256 value) public returns (bool);
114   event Transfer(address indexed from, address indexed to, uint256 value);
115 }
116 
117 contract BasicToken is ERC20Basic {
118   using SafeMath for uint256;
119 
120   mapping(address => uint256) balances;
121 
122   /**
123   * @dev transfer token for a specified address
124   * @param _to The address to transfer to.
125   * @param _value The amount to be transferred.
126   */
127   function transfer(address _to, uint256 _value) public returns (bool) {
128     require(_to != address(0));
129 
130     // SafeMath.sub will throw if there is not enough balance.
131     balances[msg.sender] = balances[msg.sender].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     Transfer(msg.sender, _to, _value);
134     return true;
135   }
136 
137   /**
138   * @dev Gets the balance of the specified address.
139   * @param _owner The address to query the the balance of.
140   * @return An uint256 representing the amount owned by the passed address.
141   */
142   function balanceOf(address _owner) public view returns (uint256 balance) {
143     return balances[_owner];
144   }
145 
146 }
147 
148 contract ERC20 is ERC20Basic {
149   function allowance(address owner, address spender) public view returns (uint256);
150   function transferFrom(address from, address to, uint256 value) public returns (bool);
151   function approve(address spender, uint256 value) public returns (bool);
152   event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 contract StandardToken is ERC20, BasicToken {
156 
157   mapping (address => mapping (address => uint256)) internal allowed;
158 
159 
160   /**
161    * @dev Transfer tokens from one address to another
162    * @param _from address The address which you want to send tokens from
163    * @param _to address The address which you want to transfer to
164    * @param _value uint256 the amount of tokens to be transferred
165    */
166   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
167     require(_to != address(0));
168     require(_value <= balances[_from]);
169     require(_value <= allowed[_from][msg.sender]);
170 
171     balances[_from] = balances[_from].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174     Transfer(_from, _to, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180    *
181    * Beware that changing an allowance with this method brings the risk that someone may use both the old
182    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185    * @param _spender The address which will spend the funds.
186    * @param _value The amount of tokens to be spent.
187    */
188   function approve(address _spender, uint256 _value) public returns (bool) {
189     allowed[msg.sender][_spender] = _value;
190     Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Function to check the amount of tokens that an owner allowed to a spender.
196    * @param _owner address The address which owns the funds.
197    * @param _spender address The address which will spend the funds.
198    * @return A uint256 specifying the amount of tokens still available for the spender.
199    */
200   function allowance(address _owner, address _spender) public view returns (uint256) {
201     return allowed[_owner][_spender];
202   }
203 
204   /**
205    * approve should be called when allowed[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    */
210   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
211     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
217     uint oldValue = allowed[msg.sender][_spender];
218     if (_subtractedValue > oldValue) {
219       allowed[msg.sender][_spender] = 0;
220     } else {
221       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
222     }
223     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224     return true;
225   }
226 
227 }
228 
229 contract PausableToken is StandardToken, Pausable {
230 
231   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
232     return super.transfer(_to, _value);
233   }
234 
235   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
236     return super.transferFrom(_from, _to, _value);
237   }
238 
239   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
240     return super.approve(_spender, _value);
241   }
242 
243   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
244     return super.increaseApproval(_spender, _addedValue);
245   }
246 
247   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
248     return super.decreaseApproval(_spender, _subtractedValue);
249   }
250 }
251 
252 contract NineetToken is PausableToken {
253   string constant public name = "Nineet Token";
254   string constant public symbol = "NNT";
255   uint256 constant public decimals = 18;
256 
257   uint256 constant public initialSupply = 85000000 * (10**decimals); // 85 million
258 
259   // where all created tokens should be assigned
260   address public initialWallet;
261 
262   function NineetToken(address _initialWallet) public {
263     require (_initialWallet != 0x0);
264 
265     initialWallet = _initialWallet;
266 
267     // asign all tokens to the contract creator
268     totalSupply = initialSupply;
269     balances[initialWallet] = initialSupply;
270 
271     addOwner(initialWallet);
272   }
273 
274   event Burn(address indexed burner, uint256 value);
275 
276   /**
277    * @dev Burns a specific amount of tokens.
278    * @param _value The amount of token to be burned.
279    */
280   function burn(uint256 _value) public onlyOwner {
281     require(_value > 0);
282 
283     address burner = msg.sender;
284     balances[burner] = balances[burner].sub(_value);
285     totalSupply = totalSupply.sub(_value);
286     Burn(burner, _value);
287   }
288 }
289 
290 contract NineetPresale is Pausable {
291   using SafeMath for uint256;
292 
293   // The token being sold
294   NineetToken public token;
295   uint256 constant public decimals = 18;
296   uint256 constant public BASE = 10**decimals;
297 
298   // start and end timestamps where investments are allowed (both inclusive)
299   uint256 public startTime;
300   uint256 public endTime;
301 
302   // address where funds are collected
303   address public wallet;
304 
305   // amount of raised money in wei
306   uint256 public weiRaised;
307 
308   // Sold presale tokens
309   uint256 public soldTokens;
310 
311   // Presale token limit
312   uint256 constant public soldTokensLimit = 1700000 * BASE; // 2% for presale
313 
314   /**
315    * event for token purchase logging
316    * @param purchaser who paid for the tokens
317    * @param beneficiary who got the tokens
318    * @param value weis paid for purchase
319    * @param amount amount of tokens purchased
320    */
321   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
322 
323   function NineetPresale(uint256 _startTime, uint256 _endTime, address _wallet) public {
324     // require(_startTime >= now);
325     require(_endTime >= _startTime);
326     require(_wallet != 0x0);
327 
328     startTime = _startTime;
329     endTime = _endTime;
330     wallet = _wallet;
331     
332     token = createTokenContract();
333   }
334 
335   function createTokenContract() internal returns (NineetToken) {
336     return new NineetToken(wallet);
337   }
338   
339   function () public payable whenNotPaused {
340     buyTokens(msg.sender);
341   }
342 
343   // low level token purchase function
344   function buyTokens(address beneficiary) public payable whenNotPaused {
345     require(beneficiary != 0x0);
346     require(validPurchase());
347 
348     uint256 weiAmount = msg.value;
349 
350     // calculate token amount to be created
351     uint256 presalePrice = getPrice(weiAmount);
352     uint256 tokens = weiAmount.div(presalePrice) * BASE;
353 
354     // do not allow to buy over pre-sale limit
355     uint256 newSoldTokens = soldTokens.add(tokens);
356     require(newSoldTokens <= soldTokensLimit);
357 
358     // update state
359     weiRaised = weiRaised.add(weiAmount);
360     soldTokens = newSoldTokens;
361 
362     token.transfer(beneficiary, tokens);
363     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
364 
365     forwardFunds();
366   }
367 
368   function getPrice(uint256 weiAmount) public pure returns(uint256) {
369     if (weiAmount >= 20 * BASE) { // if >= 20 ether
370       // 60% discount
371       return 400000000000000; // 0.0004 ether
372     } else if (weiAmount >= 10 * BASE) { // if >= 10 ether
373       // 50% discount
374       return 500000000000000; // 0.0005 ether
375     } else {
376       // 40% is base presale discount
377       return 600000000000000; // 0.0006 ether
378     }
379   }
380 
381   // send ether to the fund collection wallet
382   // override to create custom fund forwarding mechanisms
383   function forwardFunds() internal {
384     wallet.transfer(msg.value);
385   }
386 
387   // @return true if the transaction can buy tokens
388   function validPurchase() internal view returns (bool) {
389     bool withinPeriod = now >= startTime && now <= endTime;
390     bool nonZeroPurchase = msg.value != 0;
391     return withinPeriod && nonZeroPurchase;
392   }
393 
394   // @return true if crowdsale event has ended
395   function hasEnded() public view returns (bool) {
396     bool capReached = soldTokens >= soldTokensLimit;
397     return (now > endTime) || capReached;
398   }
399 
400   function getTokensForPresale() public onlyOwner {
401     token.transferFrom(wallet, address(this), soldTokensLimit);
402   }
403 
404   // transfer unsold tokens back to the wallet
405   function returnTokensToWallet() public onlyOwner {
406     require (soldTokens < soldTokensLimit);
407     require (now > endTime);
408 
409     token.transfer(wallet, soldTokensLimit - soldTokens);
410   }
411 
412   function grantAccessForToken() public onlyOwner {
413     token.addOwner(msg.sender);
414   }
415 
416 }