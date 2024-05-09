1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipRenounced(address indexed previousOwner);
7   event OwnershipTransferred(
8                              address indexed previousOwner,
9                              address indexed newOwner
10                              );
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   constructor() public {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership (address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     emit OwnershipTransferred(owner, newOwner);  
35 
36     owner = newOwner;
37   }
38 
39   /**
40    * @dev Allows the current owner to relinquish control of the contract.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 }
47 
48 contract ERC20Token {
49   using SafeMath for uint256;
50 
51   mapping(address => uint256) balances;
52 
53   uint256 totalSupply_;
54 
55   /**
56    * @dev total number of tokens in existence
57    */
58   function totalSupply() public view returns (uint256) {
59     return totalSupply_;
60   }
61 
62   /**
63    * @dev transfer token for a specified address
64    * @param _to The address to transfer to.
65    * @param _value The amount to be transferred.
66    */
67   function transfer(address _to, uint256 _value) public returns (bool) {
68     require(_to != address(0));
69     require(_value <= balances[msg.sender]);
70 
71     balances[msg.sender] = balances[msg.sender].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     emit Transfer(msg.sender, _to, _value);
74     return true;
75   }
76 
77   /**
78    * @dev Gets the balance of the specified address.
79    * @param _owner The address to query the the balance of.
80    * @return An uint256 representing the amount owned by the passed address.
81    */
82   function balanceOf(address _owner) public view returns (uint256) {
83     return balances[_owner];
84   }
85 
86   function allowance(address owner, address spender)
87     public view returns (uint256);
88 
89   function transferFrom(address from, address to, uint256 value)
90     public returns (bool);
91 
92   function approve(address spender, uint256 value) public returns (bool);
93   event Approval(address indexed owner, address indexed spender,uint256 value);
94   event Transfer(address indexed from, address indexed to, uint256 value);
95 }
96 
97 contract StandardToken is ERC20Token {
98   string public name;
99   string public symbol;
100   uint8 public decimals;
101 
102   constructor(string _name, string _symbol, uint8 _decimals) public {
103     name = _name;
104     symbol = _symbol;
105     decimals = _decimals;
106   }
107 
108   mapping (address => mapping (address => uint256)) internal allowed;
109 
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param _from address The address which you want to send tokens from
113    * @param _to address The address which you want to transfer to
114    * @param _value uint256 the amount of tokens to be transferred
115    */
116   function transferFrom(address _from, address _to, uint256 _value ) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[_from]);
119     require(_value <= allowed[_from][msg.sender]);
120 
121     balances[_from] = balances[_from].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124     emit Transfer(_from, _to, _value);
125     return true;
126   }
127 
128   /**
129    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
130    *
131    * Beware that changing an allowance with this method brings the risk that someone may use both the old
132    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
133    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
134    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135    * @param _spender The address which will spend the funds.
136    * @param _value The amount of tokens to be spent.
137    */
138   function approve(address _spender, uint256 _value) public returns (bool) {
139     allowed[msg.sender][_spender] = _value;
140     emit Approval(msg.sender, _spender, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Function to check the amount of tokens that an owner allowed to a spender.
146    * @param _owner address The address which owns the funds.
147    * @param _spender address The address which will spend the funds.
148    * @return A uint256 specifying the amount of tokens still available for the spender.
149    */
150   function allowance( address _owner,  address _spender) public view returns (uint256) {
151     return allowed[_owner][_spender];
152   }
153 
154   /**
155    * @dev Increase the amount of tokens that an owner allowed to a spender.
156    *
157    * approve should be called when allowed[_spender] == 0. To increment
158    * allowed value is better to use this function to avoid 2 calls (and wait until
159    * the first transaction is mined)
160    * From MonolithDAO Token.sol
161    * @param _spender The address which will spend the funds.
162    * @param _addedValue The amount of tokens to increase the allowance by.
163    */
164   function increaseApproval( address _spender, uint _addedValue) public returns (bool) {
165     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
166     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167     return true;
168   }
169 
170   /**
171    * @dev Decrease the amount of tokens that an owner allowed to a spender.
172    *
173    * approve should be called when allowed[_spender] == 0. To decrement
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    * @param _spender The address which will spend the funds.
178    * @param _subtractedValue The amount of tokens to decrease the allowance by.
179    */
180   function decreaseApproval( address _spender, uint _subtractedValue) public returns (bool) {
181     uint oldValue = allowed[msg.sender][_spender];
182     if (_subtractedValue > oldValue) {
183       allowed[msg.sender][_spender] = 0;
184     } else {
185       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
186     }
187     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191 }
192 
193 /**
194  * @title Burnable Token
195  * @dev Token that can be irreversibly burned (destroyed).
196  */
197 contract BurnableToken is StandardToken {
198     event Burn(address indexed burner, uint256 value);
199     /**
200      * @dev Burns a specific amount of tokens.
201      * @param _value The amount of token to be burned.
202      */
203     function burn(uint256 _value) public returns (bool) {
204         require(_value > 0);
205         require(_value <= balances[msg.sender]);
206         // no need to require value <= totalSupply_, since that would imply the
207         // sender's balance is greater than the totalSupply_, which *should* be an assertion failure
208         address burner = msg.sender;
209         balances[burner] = balances[burner].sub(_value);
210         totalSupply_ = totalSupply_.sub(_value);
211         emit Burn(burner, _value);
212         return true;
213     }
214 }
215 
216 contract FrozenableToken is BurnableToken, Ownable {
217   mapping (address => bool) public frozenAccount;
218   event FrozenFunds(address target, bool frozen);
219 
220   /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
221   /// @param target Address to be frozen
222   /// @param freeze either to freeze it or not
223   function freezeAccount(address target, bool freeze) onlyOwner public {
224       frozenAccount[target] = freeze;
225       emit FrozenFunds(target, freeze);
226   }
227 
228   function transfer( address _to, uint256 _value) public returns (bool) {
229     require(!frozenAccount[msg.sender]);                     // Check if sender is frozen
230     require(!frozenAccount[_to]);                       // Check if recipient is frozen
231 
232     return super.transfer(_to, _value);
233     }
234 
235   function transferFrom( address _from, address _to, uint256 _value) public returns (bool) {
236     require(!frozenAccount[_from]);                     // Check if sender is frozen
237     require(!frozenAccount[_to]);                       // Check if recipient is frozen
238 
239     return super.transferFrom(_from, _to, _value);
240   }
241 
242   function approve( address _spender, uint256 _value) public  returns (bool) {
243     require(!frozenAccount[msg.sender]);                     // Check if sender is frozen
244     require(!frozenAccount[_spender]);                       // Check if recipient is frozen
245 
246     return super.approve(_spender, _value);
247   }
248 
249   function increaseApproval( address _spender, uint _addedValue) public  returns (bool success) {
250     require(!frozenAccount[msg.sender]);                     // Check if sender is frozen
251     require(!frozenAccount[_spender]);                       // Check if recipient is frozen
252 
253     return super.increaseApproval(_spender, _addedValue);
254   }
255 
256   function decreaseApproval( address _spender, uint _subtractedValue) public  returns (bool success) {
257     require(!frozenAccount[msg.sender]);                     // Check if sender is frozen
258     require(!frozenAccount[_spender]);                       // Check if recipient is frozen
259 
260     return super.decreaseApproval(_spender, _subtractedValue);
261   }
262   
263 
264 }
265 
266 contract PausableToken is FrozenableToken {
267   event Pause();
268   event Unpause();
269 
270   bool public paused = false;
271 
272 
273   /**
274    * @dev Modifier to make a function callable only when the contract is not paused.
275    */
276   modifier whenNotPaused() {
277     require(!paused);
278     _;
279   }
280 
281   /**
282    * @dev Modifier to make a function callable only when the contract is paused.
283    */
284   modifier whenPaused() {
285     require(paused);
286     _;
287   }
288 
289   /**
290    * @dev called by the owner to pause, triggers stopped state
291    */
292   function pause() onlyOwner whenNotPaused public {
293     paused = true;
294     emit Pause();
295   }
296 
297   /**
298    * @dev called by the owner to unpause, returns to normal state
299    */
300   function unpause() onlyOwner whenPaused public {
301     paused = false;
302     emit Unpause();
303   }
304 
305   function transfer( address _to, uint256 _value) public whenNotPaused returns (bool) {
306     return super.transfer(_to, _value);
307   }
308 
309   function transferFrom( address _from, address _to, uint256 _value) public whenNotPaused returns (bool)
310   {
311     return super.transferFrom(_from, _to, _value);
312   }
313 
314   function approve( address _spender, uint256 _value) public whenNotPaused returns (bool) {
315     return super.approve(_spender, _value);
316   }
317 
318   function increaseApproval( address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
319     return super.increaseApproval(_spender, _addedValue);
320   }
321 
322   function decreaseApproval( address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
323     return super.decreaseApproval(_spender, _subtractedValue);
324   }
325 }
326 
327 contract CoinPoolCoin is PausableToken {
328 
329   using SafeMath for uint256;
330 
331   // One time switch to enable token transferability.
332   bool public transferable = false;
333 
334   // Record  wallet to allow transfering.
335   address public CPBWallet;
336 
337   // 2.1 billion tokens, 18 decimals.
338   uint public constant INITIAL_SUPPLY = 2.1e27;
339 
340   modifier onlyWhenTransferEnabled() {
341     if (!transferable) {
342       require(msg.sender == owner || msg.sender == CPBWallet);
343     }
344     _;
345   }
346 
347   modifier validDestination(address to) {
348     require(to != address(this));
349     _;
350   }
351 
352   constructor(address _CPBWallet) public StandardToken("CoinPool Coin", "CPB", 18) {
353 
354     require(_CPBWallet != address(0));
355     CPBWallet = _CPBWallet;
356     totalSupply_ = INITIAL_SUPPLY;
357     balances[_CPBWallet] = totalSupply_;
358     emit Transfer(address(0), _CPBWallet, totalSupply_);
359   }
360 
361   /// @dev Override to only allow tranfer.
362   function transferFrom(address _from, address _to, uint256 _value) public validDestination(_to) onlyWhenTransferEnabled returns (bool) {
363     return super.transferFrom(_from, _to, _value);
364   }
365 
366   /// @dev Override to only allow tranfer after being switched on.
367   function transfer(address _to, uint256 _value) public validDestination(_to) onlyWhenTransferEnabled returns (bool) {
368     return super.transfer(_to, _value);
369   }
370 
371   /**
372    * @dev One-time switch to enable transfer.
373    */
374   function enableTransfer() external onlyOwner {
375     transferable = true;
376   }
377 
378 }
379 
380 library SafeMath {
381 
382   /**
383    * @dev Multiplies two numbers, throws on overflow.
384    */
385   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
386     if (a == 0) {
387       return 0;
388     }
389     c = a * b;
390     assert(c / a == b);
391     return c;
392   }
393 
394   /**
395    * @dev Integer division of two numbers, truncating the quotient.
396    */
397   function div(uint256 a, uint256 b) internal pure returns (uint256) {
398     // assert(b > 0); // Solidity automatically throws when dividing by 0
399     // uint256 c = a / b;
400     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
401     return a / b;
402   }
403 
404   /**
405    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
406    */
407   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
408     assert(b <= a);
409     return a - b;
410   }
411 
412   /**
413    * @dev Adds two numbers, throws on overflow.
414    */
415   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
416     c = a + b;
417     assert(c >= a);
418     return c;
419   }
420 }