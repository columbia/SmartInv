1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   mapping (address => bool) public owners;
31 
32   event OwnershipAdded(address indexed assigner, address indexed newOwner);
33   event OwnershipDeleted(address indexed assigner, address indexed deletedOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owners[msg.sender] = true;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(owners[msg.sender] == true);
50     _;
51   }
52   
53   function addOwner(address newOwner) onlyOwner public {
54     require(newOwner != address(0));
55     OwnershipAdded(msg.sender, newOwner);
56     owners[newOwner] = true;
57   }
58   
59   function removeOwner(address removedOwner) onlyOwner public {
60     require(removedOwner != address(0));
61     OwnershipDeleted(msg.sender, removedOwner);
62     delete owners[removedOwner];
63   }
64 
65 }
66 
67 contract Pausable is Ownable {
68   event Pause();
69   event Unpause();
70 
71   bool public paused = false;
72 
73 
74   /**
75    * @dev Modifier to make a function callable only when the contract is not paused.
76    */
77   modifier whenNotPaused() {
78     require(!paused);
79     _;
80   }
81 
82   /**
83    * @dev Modifier to make a function callable only when the contract is paused.
84    */
85   modifier whenPaused() {
86     require(paused);
87     _;
88   }
89 
90   /**
91    * @dev called by the owner to pause, triggers stopped state
92    */
93   function pause() onlyOwner whenNotPaused public {
94     paused = true;
95     Pause();
96   }
97 
98   /**
99    * @dev called by the owner to unpause, returns to normal state
100    */
101   function unpause() onlyOwner whenPaused public {
102     paused = false;
103     Unpause();
104   }
105 }
106 
107 contract ERC20Basic {
108   uint256 public totalSupply;
109   function balanceOf(address who) public constant returns (uint256);
110   function transfer(address to, uint256 value) public returns (bool);
111   event Transfer(address indexed from, address indexed to, uint256 value);
112 }
113 
114 contract BasicToken is ERC20Basic {
115   using SafeMath for uint256;
116 
117   mapping(address => uint256) balances;
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126 
127     // SafeMath.sub will throw if there is not enough balance.
128     balances[msg.sender] = balances[msg.sender].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     Transfer(msg.sender, _to, _value);
131     return true;
132   }
133 
134   /**
135   * @dev Gets the balance of the specified address.
136   * @param _owner The address to query the the balance of.
137   * @return An uint256 representing the amount owned by the passed address.
138   */
139   function balanceOf(address _owner) public constant returns (uint256 balance) {
140     return balances[_owner];
141   }
142 
143 }
144 
145 contract ERC20 is ERC20Basic {
146   function allowance(address owner, address spender) public constant returns (uint256);
147   function transferFrom(address from, address to, uint256 value) public returns (bool);
148   function approve(address spender, uint256 value) public returns (bool);
149   event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 contract StandardToken is ERC20, BasicToken {
153 
154   mapping (address => mapping (address => uint256)) allowed;
155 
156 
157   /**
158    * @dev Transfer tokens from one address to another
159    * @param _from address The address which you want to send tokens from
160    * @param _to address The address which you want to transfer to
161    * @param _value uint256 the amount of tokens to be transferred
162    */
163   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
164     require(_to != address(0));
165 
166     uint256 _allowance = allowed[_from][msg.sender];
167 
168     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
169     // require (_value <= _allowance);
170 
171     balances[_from] = balances[_from].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     allowed[_from][msg.sender] = _allowance.sub(_value);
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
200   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
201     return allowed[_owner][_spender];
202   }
203 
204   /**
205    * approve should be called when allowed[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    */
210   function increaseApproval (address _spender, uint _addedValue)
211     returns (bool success) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   function decreaseApproval (address _spender, uint _subtractedValue)
218     returns (bool success) {
219     uint oldValue = allowed[msg.sender][_spender];
220     if (_subtractedValue > oldValue) {
221       allowed[msg.sender][_spender] = 0;
222     } else {
223       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224     }
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229 }
230 
231 contract PausableToken is StandardToken, Pausable {
232 
233   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
234     return super.transfer(_to, _value);
235   }
236 
237   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
238     return super.transferFrom(_from, _to, _value);
239   }
240 
241   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
242     return super.approve(_spender, _value);
243   }
244 
245   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
246     return super.increaseApproval(_spender, _addedValue);
247   }
248 
249   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
250     return super.decreaseApproval(_spender, _subtractedValue);
251   }
252 }
253 
254 contract NineetToken is PausableToken {
255   string constant public name = "Nineet Token";
256   string constant public symbol = "NNT";
257   uint256 constant public decimals = 18;
258 
259   uint256 constant public initialSupply = 85000000 * (10**decimals); // 85 million
260 
261   // where all created tokens should be assigned
262   address public initialWallet;
263 
264   function NineetToken(address _initialWallet) {
265     require (_initialWallet != 0x0);
266 
267     initialWallet = _initialWallet;
268 
269     // asign all tokens to the contract creator
270     totalSupply = initialSupply;
271     balances[initialWallet] = initialSupply;
272 
273     addOwner(initialWallet);
274   }
275 
276   event Burn(address indexed burner, uint256 value);
277 
278   /**
279    * @dev Burns a specific amount of tokens.
280    * @param _value The amount of token to be burned.
281    */
282   function burn(uint256 _value) public onlyOwner {
283     require(_value > 0);
284 
285     address burner = msg.sender;
286     balances[burner] = balances[burner].sub(_value);
287     totalSupply = totalSupply.sub(_value);
288     Burn(burner, _value);
289   }
290 }
291 
292 contract NineetPresale is Pausable {
293   using SafeMath for uint256;
294 
295   // The token being sold
296   NineetToken public token;
297   uint256 constant public decimals = 18;
298   uint256 constant public BASE = 10**decimals;
299 
300   // start and end timestamps where investments are allowed (both inclusive)
301   uint256 public startTime;
302   uint256 public endTime;
303 
304   // address where funds are collected
305   address public wallet;
306 
307   // amount of raised money in wei
308   uint256 public weiRaised;
309 
310   // Sold presale tokens
311   uint256 public soldTokens;
312 
313   // Presale token limit
314   uint256 constant public soldTokensLimit = 1700000 * BASE; // 2% for presale
315 
316   /**
317    * event for token purchase logging
318    * @param purchaser who paid for the tokens
319    * @param beneficiary who got the tokens
320    * @param value weis paid for purchase
321    * @param amount amount of tokens purchased
322    */
323   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
324 
325   function NineetPresale(uint256 _startTime, uint256 _endTime, address _wallet) {
326     // require(_startTime >= now);
327     require(_endTime >= _startTime);
328     require(_wallet != 0x0);
329 
330     startTime = _startTime;
331     endTime = _endTime;
332     wallet = _wallet;
333     
334     token = createTokenContract();
335   }
336 
337   function createTokenContract() internal returns (NineetToken) {
338     return new NineetToken(wallet);
339   }
340   
341   function () payable whenNotPaused {
342     buyTokens(msg.sender);
343   }
344 
345   // low level token purchase function
346   function buyTokens(address beneficiary) public payable whenNotPaused {
347     require(beneficiary != 0x0);
348     require(validPurchase());
349 
350     uint256 weiAmount = msg.value;
351 
352     // calculate token amount to be created
353     uint256 presalePrice = getPrice(weiAmount);
354     uint256 tokens = weiAmount.div(presalePrice) * BASE;
355 
356     // do not allow to buy over pre-sale limit
357     uint256 newSoldTokens = soldTokens.add(tokens);
358     require(newSoldTokens <= soldTokensLimit);
359 
360     // update state
361     weiRaised = weiRaised.add(weiAmount);
362     soldTokens = newSoldTokens;
363 
364     token.transfer(beneficiary, tokens);
365     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
366 
367     forwardFunds();
368   }
369 
370   function getPrice(uint256 weiAmount) public returns(uint256) {
371     if (weiAmount >= 20 * BASE) { // if >= 20 ether
372       // 60% discount
373       return 400000000000000; // 0.0004 ether
374     } else if (weiAmount >= 10 * BASE) { // if >= 10 ether
375       // 50% discount
376       return 500000000000000; // 0.0005 ether
377     } else {
378       // 40% is base presale discount
379       return 600000000000000; // 0.0006 ether
380     }
381   }
382 
383   // send ether to the fund collection wallet
384   // override to create custom fund forwarding mechanisms
385   function forwardFunds() internal {
386     wallet.transfer(msg.value);
387   }
388 
389   // @return true if the transaction can buy tokens
390   function validPurchase() internal constant returns (bool) {
391     bool withinPeriod = now >= startTime && now <= endTime;
392     bool nonZeroPurchase = msg.value != 0;
393     return withinPeriod && nonZeroPurchase;
394   }
395 
396   // @return true if crowdsale event has ended
397   function hasEnded() public constant returns (bool) {
398     bool capReached = soldTokens >= soldTokensLimit;
399     return (now > endTime) || capReached;
400   }
401 
402   // @return true if presale is active
403   function isActive() public constant returns (bool) {
404     return (now > startTime) && !(hasEnded());
405   }
406 
407   function getTokensForPresale() public onlyOwner {
408     token.transferFrom(wallet, address(this), soldTokensLimit);
409   }
410 
411   // transfer unsold tokens back to the wallet
412   function returnTokensToWallet() public onlyOwner {
413     require (soldTokens < soldTokensLimit);
414     require (now > endTime);
415 
416     token.transfer(wallet, soldTokensLimit - soldTokens);
417   }
418 
419   function grantAccessForToken() public onlyOwner {
420     token.addOwner(msg.sender);
421   }
422 
423 }