1 pragma solidity ^0.4.23;
2 library SafeMath {
3 
4   /**
5   * @dev Multiplies two numbers, throws on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8     if (a == 0) {
9       return 0;
10     }
11     c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   /**
17   * @dev Integer division of two numbers, truncating the quotient.
18   */
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     // uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return a / b;
24   }
25 
26   /**
27   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
28   */
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   /**
35   * @dev Adds two numbers, throws on overflow.
36   */
37   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
38     c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 contract Ownable {
45   address public owner;
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49   constructor() public {
50     owner = msg.sender;
51   }
52 
53     modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58     function transferOwnership(address newOwner) public onlyOwner {
59     require(newOwner != address(0));
60     emit OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 }
64 
65 contract Pausable is Ownable {
66   event Pause();
67   event Unpause();
68 
69   bool public paused = false;
70   /**
71    * @dev Modifier to make a function callable only when the contract is not paused.
72    */
73   modifier whenNotPaused() {
74     require(!paused);
75     _;
76   }
77 
78   /**
79    * @dev Modifier to make a function callable only when the contract is paused.
80    */
81   modifier whenPaused() {
82     require(paused);
83     _;
84   }
85 
86   /**
87    * @dev called by the owner to pause, triggers stopped state
88    */
89   function pause() onlyOwner whenNotPaused public {
90     paused = true;
91     emit Pause();
92   }
93 
94   /**
95    * @dev called by the owner to unpause, returns to normal state
96    */
97   function unpause() onlyOwner whenPaused public {
98     paused = false;
99     emit Unpause();
100   }
101 }
102 
103 contract ERC20Basic {
104   function totalSupply() public view returns (uint256);
105   function balanceOf(address who) public view returns (uint256);
106   function transfer(address to, uint256 value) public returns (bool);
107   event Transfer(address indexed from, address indexed to, uint256 value);
108 }
109 
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 contract BasicToken is ERC20Basic {
118   using SafeMath for uint256;
119 
120   mapping(address => uint256) balances;
121 
122   uint256 totalSupply_;
123 
124   /**
125   * @dev total number of tokens in existence
126   */
127   function totalSupply() public view returns (uint256) {
128     return totalSupply_;
129   }
130 
131   /**
132   * @dev transfer token for a specified address
133   * @param _to The address to transfer to.
134   * @param _value The amount to be transferred.
135   */
136   function transfer(address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_value <= balances[msg.sender]);
139 
140     balances[msg.sender] = balances[msg.sender].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     emit Transfer(msg.sender, _to, _value);
143     return true;
144   }
145 
146   /**
147   * @dev Gets the balance of the specified address.
148   * @param _owner The address to query the the balance of.
149   * @return An uint256 representing the amount owned by the passed address.
150   */
151   function balanceOf(address _owner) public view returns (uint256) {
152     return balances[_owner];
153   }
154 }
155 
156 contract StandardToken is ERC20, BasicToken {
157   mapping (address => mapping (address => uint256)) internal allowed;
158 
159   /**
160    * @dev Transfer tokens from one address to another
161    * @param _from address The address which you want to send tokens from
162    * @param _to address The address which you want to transfer to
163    * @param _value uint256 the amount of tokens to be transferred
164    */
165   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
166     require(_to != address(0));
167     require(_value <= balances[_from]);
168     require(_value <= allowed[_from][msg.sender]);
169 
170     balances[_from] = balances[_from].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
173     emit Transfer(_from, _to, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
179    *
180    * Beware that changing an allowance with this method brings the risk that someone may use both the old
181    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
182    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
183    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184    * @param _spender The address which will spend the funds.
185    * @param _value The amount of tokens to be spent.
186    */
187   function approve(address _spender, uint256 _value) public returns (bool) {
188     allowed[msg.sender][_spender] = _value;
189     emit Approval(msg.sender, _spender, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Function to check the amount of tokens that an owner allowed to a spender.
195    * @param _owner address The address which owns the funds.
196    * @param _spender address The address which will spend the funds.
197    * @return A uint256 specifying the amount of tokens still available for the spender.
198    */
199   function allowance(address _owner, address _spender) public view returns (uint256) {
200     return allowed[_owner][_spender];
201   }
202 
203   /**
204    * @dev Increase the amount of tokens that an owner allowed to a spender.
205    *
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param _spender The address which will spend the funds.
211    * @param _addedValue The amount of tokens to increase the allowance by.
212    */
213   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
214     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    *
222    * approve should be called when allowed[_spender] == 0. To decrement
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param _spender The address which will spend the funds.
227    * @param _subtractedValue The amount of tokens to decrease the allowance by.
228    */
229   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
230     uint oldValue = allowed[msg.sender][_spender];
231     if (_subtractedValue > oldValue) {
232       allowed[msg.sender][_spender] = 0;
233     } else {
234       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
235     }
236     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240 }
241 
242 contract PausableToken is StandardToken, Pausable {
243 
244   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
245     return super.transfer(_to, _value);
246   }
247 
248   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
249     return super.transferFrom(_from, _to, _value);
250   }
251 
252   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
253     return super.approve(_spender, _value);
254   }
255 
256   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
257     return super.increaseApproval(_spender, _addedValue);
258   }
259 
260   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
261     return super.decreaseApproval(_spender, _subtractedValue);
262   }
263 }
264 
265 contract MintableToken is StandardToken, Ownable, Pausable {
266   event Mint(address indexed to, uint256 amount);
267   event MintFinished();
268 
269   bool public mintingFinished = false;
270 
271   modifier canMint() {
272     require(!mintingFinished);
273     _;
274   }
275 
276   /**
277    * @dev Function to mint tokens
278    * @param _to The address that will receive the minted tokens.
279    * @param _amount The amount of tokens to mint.
280    * @return A boolean that indicates if the operation was successful.
281    */
282   function mint(address _to, uint256 _amount) onlyOwner canMint whenNotPaused public returns (bool) {
283     totalSupply_ = totalSupply_.add(_amount);
284     balances[_to] = balances[_to].add(_amount);
285     emit Mint(_to, _amount);
286     emit Transfer(address(0), _to, _amount);
287     return true;
288   }
289 
290   /**
291    * @dev Function to stop minting new tokens.
292    * @return True if the operation was successful.
293    */
294   function finishMinting() onlyOwner canMint public returns (bool) {
295     mintingFinished = true;
296     emit MintFinished();
297     return true;
298   }
299 }
300 
301 contract CappedToken is MintableToken {
302 
303   uint256 public cap;
304 
305   constructor(uint256 _cap) public {
306     require(_cap > 0);
307     cap = _cap;
308   }
309 
310   /**
311    * @dev Function to mint tokens
312    * @param _to The address that will receive the minted tokens.
313    * @param _amount The amount of tokens to mint.
314    * @return A boolean that indicates if the operation was successful.
315    */
316   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
317     require(totalSupply_.add(_amount) <= cap);
318     return super.mint(_to, _amount);
319   }
320 }
321 
322 contract BurnableToken is BasicToken, Ownable, Pausable {
323 
324   event Burn(address indexed burner, uint256 value);
325 
326   /**
327    * @dev Burns a specific amount of tokens.
328    * @param _value The amount of token to be burned.
329    */
330   function burn(uint256 _value) onlyOwner whenNotPaused public {
331     _burn(msg.sender, _value);
332   }
333 
334   function _burn(address _who, uint256 _value) internal {
335     require(_value <= balances[_who]);
336     // no need to require value <= totalSupply, since that would imply the
337     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
338 
339     balances[_who] = balances[_who].sub(_value);
340     totalSupply_ = totalSupply_.sub(_value);
341     emit Burn(_who, _value);
342     emit Transfer(_who, address(0), _value);
343   }
344 }
345 
346 
347 contract MilkToken is CappedToken, BurnableToken, PausableToken {
348   string public constant name = "PURCOW MILK TOKEN";
349   string public constant symbol = "MILK";
350   uint256 public constant decimals = 18;
351   uint256 public constant UNIT = 10 ** 8;
352 
353   uint256 public constant TOTAL_VALUE = 80 * UNIT * 10 ** decimals;
354   uint256 public constant COMMUNITY_PERCENT = 60;
355   uint256 public constant FOUNDATION_PERCENT = 40;
356   uint256 public COMMUNITY_CAPPED_VALUE = TOTAL_VALUE.mul(COMMUNITY_PERCENT).div(100);
357   uint256 public FOUNDATION_CAPPED_VALUE = TOTAL_VALUE.sub(COMMUNITY_CAPPED_VALUE);
358   uint256 public INITIAL_TOTAL_SUPPLY = 0;
359 
360   address owner_address;
361   address foundation_address;
362 
363   constructor() CappedToken(TOTAL_VALUE)  public {
364     totalSupply_ = INITIAL_TOTAL_SUPPLY;
365     owner_address = msg.sender;
366     balances[owner_address] = totalSupply_;
367     emit Transfer(address(0), owner_address, totalSupply_);
368   }
369 
370   function set_foundtion_addr(address addr) onlyOwner public{
371     foundation_address = addr;
372   }
373   /**
374    * @dev Mint a specific amount of tokens.
375    * @param trade_minted The amount of token to be minted by trading
376    *        and meanwhile mint the foundation token by percent
377    */
378   function set_mint(uint256 trade_minted) onlyOwner public{
379     require(foundation_address != address(0));
380     require(trade_minted <= COMMUNITY_CAPPED_VALUE);
381     uint256 foundation_mint = trade_minted.mul(FOUNDATION_PERCENT).div(COMMUNITY_PERCENT);
382     super.mint(owner_address, trade_minted);
383     super.mint(foundation_address, foundation_mint);
384   }
385   /**
386    * @dev Burn a specific amount of tokens.
387    * @param burned_value The amount of community token to be burned by owner
388    * and meanwhile burn the foundation token by percent
389    */
390   function set_burned(uint256 burned_value) onlyOwner public{
391     require(foundation_address != address(0));
392     uint256 foundation_burned = burned_value.mul(FOUNDATION_PERCENT).div(COMMUNITY_PERCENT);
393     super._burn(owner_address, burned_value);
394     super._burn(foundation_address, foundation_burned);
395   }
396 
397   /**
398   * @dev allow owner to transfer ownership to newOwner
399   * @param new_owner_address The address to transfer ownership to.
400   */
401   function transferOwnership(address new_owner_address) onlyOwner whenNotPaused public {
402     require(new_owner_address != address(0));
403     owner_address = new_owner_address;
404     super.transferOwnership(new_owner_address);
405   }
406 
407   /**
408    * @dev send fixed value to multi addresses
409    * @param addresses The address list
410    * @param value The fixed value
411    */
412   function batch_send(address[] addresses, uint256 value) onlyOwner whenNotPaused public{
413     require(addresses.length < 255);
414     require(value.mul(addresses.length) <= balances[msg.sender]);
415     for(uint i = 0; i < addresses.length; i++)
416     {
417       transfer(addresses[i], value);
418     }
419   }
420 
421   function() payable public{
422     revert();
423   }
424 
425 }