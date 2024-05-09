1 pragma solidity 0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
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
25   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26     if (a == 0) {
27       return 0;
28     }
29     uint256 c = a * b;
30     assert(c / a == b);
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers, truncating the quotient.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   /**
45   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   /**
53   * @dev Adds two numbers, throws on overflow.
54   */
55   function add(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   uint256 totalSupply_;
73 
74   /**
75   * @dev total number of tokens in existence
76   */
77   function totalSupply() public view returns (uint256) {
78     return totalSupply_;
79   }
80 
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[msg.sender]);
89 
90     // SafeMath.sub will throw if there is not enough balance.
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   /**
98   * @dev Gets the balance of the specified address.
99   * @param _owner The address to query the the balance of.
100   * @return An uint256 representing the amount owned by the passed address.
101   */
102   function balanceOf(address _owner) public view returns (uint256 balance) {
103     return balances[_owner];
104   }
105 
106 }
107 
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is ERC20, BasicToken {
129 
130   mapping (address => mapping (address => uint256)) internal allowed;
131 
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[_from]);
142     require(_value <= allowed[_from][msg.sender]);
143 
144     balances[_from] = balances[_from].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147     Transfer(_from, _to, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153    *
154    * Beware that changing an allowance with this method brings the risk that someone may use both the old
155    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) public returns (bool) {
162     allowed[msg.sender][_spender] = _value;
163     Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173   function allowance(address _owner, address _spender) public view returns (uint256) {
174     return allowed[_owner][_spender];
175   }
176 
177   /**
178    * @dev Increase the amount of tokens that an owner allowed to a spender.
179    *
180    * approve should be called when allowed[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _addedValue The amount of tokens to increase the allowance by.
186    */
187   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
188     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193   /**
194    * @dev Decrease the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To decrement
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _subtractedValue The amount of tokens to decrease the allowance by.
202    */
203   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
204     uint oldValue = allowed[msg.sender][_spender];
205     if (_subtractedValue > oldValue) {
206       allowed[msg.sender][_spender] = 0;
207     } else {
208       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209     }
210     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 
214 }
215 
216 
217 /**
218  * @title Burnable Token
219  * @dev Token that can be irreversibly burned (destroyed).
220  */
221 contract BurnableToken is BasicToken {
222 
223   event Burn(address indexed burner, uint256 value);
224 
225   /**
226    * @dev Burns a specific amount of tokens.
227    * @param _value The amount of token to be burned.
228    */
229   function burn(uint256 _value) public {
230     require(_value <= balances[msg.sender]);
231     // no need to require value <= totalSupply, since that would imply the
232     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
233 
234     address burner = msg.sender;
235     balances[burner] = balances[burner].sub(_value);
236     totalSupply_ = totalSupply_.sub(_value);
237     Burn(burner, _value);
238   }
239 }
240 
241 
242 /**
243  * @title Ownable
244  * @dev The Ownable contract has an owner address, and provides basic authorization control
245  * functions, this simplifies the implementation of "user permissions".
246  */
247 contract Ownable {
248   address public owner;
249 
250 
251   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
252 
253 
254   /**
255    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
256    * account.
257    */
258   function Ownable() public {
259     owner = msg.sender;
260   }
261 
262   /**
263    * @dev Throws if called by any account other than the owner.
264    */
265   modifier onlyOwner() {
266     require(msg.sender == owner);
267     _;
268   }
269 
270   /**
271    * @dev Allows the current owner to transfer control of the contract to a newOwner.
272    * @param newOwner The address to transfer ownership to.
273    */
274   function transferOwnership(address newOwner) public onlyOwner {
275     require(newOwner != address(0));
276     OwnershipTransferred(owner, newOwner);
277     owner = newOwner;
278   }
279 
280 }
281 
282 
283 /**
284  * @title Pausable
285  * @dev Base contract which allows children to implement an emergency stop mechanism.
286  */
287 contract Pausable is Ownable {
288   event Pause();
289   event Unpause();
290 
291   bool public paused = false;
292 
293 
294   /**
295    * @dev Modifier to make a function callable only when the contract is not paused.
296    */
297   modifier whenNotPaused() {
298     require(!paused);
299     _;
300   }
301 
302   /**
303    * @dev Modifier to make a function callable only when the contract is paused.
304    */
305   modifier whenPaused() {
306     require(paused);
307     _;
308   }
309 
310   /**
311    * @dev called by the owner to pause, triggers stopped state
312    */
313   function pause() onlyOwner whenNotPaused public {
314     paused = true;
315     Pause();
316   }
317 
318   /**
319    * @dev called by the owner to unpause, returns to normal state
320    */
321   function unpause() onlyOwner whenPaused public {
322     paused = false;
323     Unpause();
324   }
325 }
326 
327 
328 /**
329  * @title Pausable token
330  * @dev StandardToken modified with pausable transfers.
331  **/
332 contract PausableToken is StandardToken, Pausable {
333 
334   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
335     return super.transfer(_to, _value);
336   }
337 
338   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
339     return super.transferFrom(_from, _to, _value);
340   }
341 
342   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
343     return super.approve(_spender, _value);
344   }
345 
346   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
347     return super.increaseApproval(_spender, _addedValue);
348   }
349 
350   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
351     return super.decreaseApproval(_spender, _subtractedValue);
352   }
353 }
354 
355 
356 contract DetailedERC20 is ERC20 {
357   string public name;
358   string public symbol;
359   uint8 public decimals;
360 
361   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
362     name = _name;
363     symbol = _symbol;
364     decimals = _decimals;
365   }
366 }
367 
368 
369 contract StabitCoin is StandardToken, BurnableToken, PausableToken, DetailedERC20 {
370 
371     event Mint(address indexed to, uint256 amount);
372 
373     event MigrationSender(address indexed from , uint256 amount);
374 
375     event MigrationAddress(address indexed from , string stabitAddress);
376 
377     struct Migration {
378         string stabitcoinAddress;
379         uint256 amount;
380     }
381 
382     bool public migrationPeriod = false;
383 
384 
385     mapping (address => Migration) migrations;
386 
387     function StabitCoin(
388         uint256 _totalSupply
389     )
390     public
391     DetailedERC20("StabitCoin","STABIT",3)
392     {
393         totalSupply_ = totalSupply_.add(_totalSupply);
394         balances[msg.sender] = balances[msg.sender].add(_totalSupply);
395         Mint(msg.sender, _totalSupply);
396         Transfer(address(0), msg.sender, _totalSupply);
397     }
398 
399     modifier whenMigrationPeriod() {
400         require(migrationPeriod == true);
401         _;
402     }
403 
404     function migrationChain(uint256 _value) whenMigrationPeriod public {
405         require(_value <= balances[msg.sender]);
406 
407         balances[msg.sender] = balances[msg.sender].sub(_value);
408         totalSupply_ = totalSupply_.sub(_value);
409         migrations[msg.sender].amount += _value;
410         MigrationSender(msg.sender, _value);
411         Burn(msg.sender, _value);
412     }
413 
414     function showMigrationAmount(address _migrationAddress) public view returns (uint256) {
415         return migrations[_migrationAddress].amount;
416     }
417 
418     function setMigrationStabitcoinAddress(string _stabitcoinAddress) whenMigrationPeriod public {
419         migrations[msg.sender].stabitcoinAddress = _stabitcoinAddress;
420         MigrationAddress(msg.sender, _stabitcoinAddress);
421     }
422 
423     function showMigrationStabitcoinAddress(address _walletAddress) public view returns (string) {
424         return migrations[_walletAddress].stabitcoinAddress;
425     }
426 
427     function startMigration() onlyOwner public {
428         migrationPeriod = true;
429     }
430 
431     function stopMigration() onlyOwner public {
432         migrationPeriod = false;
433     }
434 }