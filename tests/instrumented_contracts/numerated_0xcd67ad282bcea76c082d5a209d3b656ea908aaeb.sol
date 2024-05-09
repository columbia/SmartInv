1 pragma solidity ^0.4.24;
2 
3 
4   /**
5   * @title SafeMath
6   * @dev Math operations with safety checks that throw on error
7   */
8   library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14       if (a == 0) {
15         return 0;
16       }
17       c = a * b;
18       assert(c / a == b);
19       return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26       return a / b;
27     }
28 
29     /**
30     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31     */
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33       assert(b <= a);
34       return a - b;
35     }
36 
37     /**
38     * @dev Adds two numbers, throws on overflow.
39     */
40     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
41       c = a + b;
42       assert(c >= a);
43       return c;
44     }
45 }
46 /**
47  * @title ERC20Basic
48  * @dev Simpler version of ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/179
50  */
51 contract ERC20Basic {
52   uint256 public totalSupply;
53   function balanceOf(address who) public view returns (uint256);
54   function transfer(address to, uint256 value) public returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 /**
59  * @title ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/20
61  */
62 contract ERC20 is ERC20Basic {
63   function allowance(address owner, address spender) public view returns (uint256);
64   function transferFrom(address from, address to, uint256 value) public returns (bool);
65   function approve(address spender, uint256 value) public returns (bool);
66   event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 /**
70  * @title Basic token
71  * @dev Basic version of StandardToken, with no allowances.
72  */
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   /**
79   * @dev transfer token for a specified address
80   * @param _to The address to transfer to.
81   * @param _value The amount to be transferred.
82   */
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85     require(_value <= balances[msg.sender]);
86 
87     uint previousBalances = balances[msg.sender] + balances[_to];
88     // SafeMath.sub will throw if there is not enough balance.
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     emit Transfer(msg.sender, _to, _value);
92     assert(balances[msg.sender] + balances[_to] == previousBalances); 
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
106 
107 /**
108  * @title Standard ERC20 token
109  *
110  * @dev Implementation of the basic standard token.
111  * @dev https://github.com/ethereum/EIPs/issues/20
112  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
113  */
114 contract StandardToken is ERC20, BasicToken {
115 
116   mapping (address => mapping (address => uint256)) internal allowed;
117 
118 
119   /**
120    * @dev Transfer tokens from one address to another
121    * @param _from address The address which you want to send tokens from
122    * @param _to address The address which you want to transfer to
123    * @param _value uint256 the amount of tokens to be transferred
124    */
125   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[_from]);
128     require(_value <= allowed[_from][msg.sender]);
129 
130     uint previousBalances = balances[_from] + balances[_to];
131     balances[_from] = balances[_from].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134     emit Transfer(_from, _to, _value);
135     assert(balances[_from] + balances[_to] == previousBalances); 
136     return true;
137   }
138 
139   /**
140    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
141    *
142    * Beware that changing an allowance with this method brings the risk that someone may use both the old
143    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
144    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
145    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146    * @param _spender The address which will spend the funds.
147    * @param _value The amount of tokens to be spent.
148    */
149   function approve(address _spender, uint256 _value) public returns (bool) {
150     allowed[msg.sender][_spender] = _value;
151     emit Approval(msg.sender, _spender, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Function to check the amount of tokens that an owner allowed to a spender.
157    * @param _owner address The address which owns the funds.
158    * @param _spender address The address which will spend the funds.
159    * @return A uint256 specifying the amount of tokens still available for the spender.
160    */
161   function allowance(address _owner, address _spender) public view returns (uint256) {
162     return allowed[_owner][_spender];
163   }
164 
165   /**
166    * approve should be called when allowed[_spender] == 0. To increment
167    * allowed value is better to use this function to avoid 2 calls (and wait until
168    * the first transaction is mined)
169    */
170   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
177     uint oldValue = allowed[msg.sender][_spender];
178     if (_subtractedValue > oldValue) {
179       allowed[msg.sender][_spender] = 0;
180     } else {
181       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
182     }
183     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184     return true;
185   }
186 
187 }
188 
189 /**
190  * @title Ownable
191  * @dev The Ownable contract has an owner address, and provides basic authorization control
192  * functions, this simplifies the implementation of "user permissions".
193  */
194 contract Ownable {
195   address public owner;
196 
197   /**
198    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
199    * account.
200    */
201   constructor() public{
202     owner = msg.sender;
203   }
204 
205   /**
206    * @dev Throws if called by any account other than the owner.
207    */
208   modifier onlyOwner() {
209     require(msg.sender == owner);
210     _;
211   }
212 
213 }
214 
215 /**
216  * @title Pausable
217  * @dev Base contract which allows children to implement an emergency stop mechanism.
218  */
219 contract Pausable is Ownable {
220   event Pause();
221   event Unpause();
222 
223   bool public paused = false;
224 
225 
226   /**
227    * @dev Modifier to make a function callable only when the contract is not paused.
228    */
229   modifier whenNotPaused() {
230     require(!paused);
231     _;
232   }
233 
234   /**
235    * @dev Modifier to make a function callable only when the contract is paused.
236    */
237   modifier whenPaused() {
238     require(paused);
239     _;
240   }
241 
242   /**
243    * @dev called by the owner to pause, triggers stopped state
244    */
245   function pause() onlyOwner whenNotPaused public {
246     paused = true;
247     emit Pause();
248   }
249 
250   /**
251    * @dev called by the owner to unpause, returns to normal state
252    */
253   function unpause() onlyOwner whenPaused public {
254     paused = false;
255     emit Unpause();
256   }
257 }
258 
259 /**
260  * @title Mintable token
261  * @dev Simple ERC20 Token example, with mintable token creation
262  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
263  */
264 contract MintableToken is StandardToken, Pausable {
265   event Mint(address indexed to, uint256 amount);
266   event MintFinished();
267 
268   bool public mintingFinished = false;
269 
270   modifier canMint() {
271     require(!mintingFinished);
272     _;
273   }
274 
275   modifier hasMintPermission() {
276     require(msg.sender == owner);
277     _;
278   }
279 
280   /**
281    * @dev Function to mint tokens
282    * @param _to The address that will receive the minted tokens.
283    * @param _amount The amount of tokens to mint.
284    * @return A boolean that indicates if the operation was successful.
285    */
286   function mint(
287     address _to,
288     uint256 _amount
289   )
290     hasMintPermission
291     canMint
292     public
293     returns (bool)
294   {
295     totalSupply = totalSupply.add(_amount);
296     balances[_to] = balances[_to].add(_amount);
297     emit Mint(_to, _amount);
298     emit Transfer(address(0), _to, _amount);
299     return true;
300   }
301 
302   /**
303    * @dev Function to stop minting new tokens.
304    * @return True if the operation was successful.
305    */
306   function finishMinting() onlyOwner canMint public returns (bool) {
307     mintingFinished = true;
308     emit MintFinished();
309     return true;
310   }
311 }
312 
313 /**
314  * @title Burnable Token
315  * @dev Token that can be irreversibly burned (destroyed).
316  */
317 contract BurnableToken is MintableToken {
318 
319   event Burn(address indexed burner, uint256 value);
320 
321   /**
322    * @dev Burns a specific amount of tokens.
323    * @param _value The amount of token to be burned.
324    */
325   function burn(uint256 _value) public {
326     _burn(msg.sender, _value);
327   }
328 
329   function _burn(address _who, uint256 _value) internal {
330     require(_value <= balances[_who]);
331     // no need to require value <= totalSupply, since that would imply the
332     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
333 
334     balances[_who] = balances[_who].sub(_value);
335     totalSupply = totalSupply.sub(_value);
336     emit Burn(_who, _value);
337     emit Transfer(_who, address(0), _value);
338   }
339 }
340 /**
341  * @title Pausable token
342  * @dev StandardToken modified with pausable transfers.
343  **/
344 contract PausableToken is BurnableToken {
345 
346   function transfer(
347     address _to,
348     uint256 _value
349   )
350     public
351     whenNotPaused
352     returns (bool)
353   {
354     return super.transfer(_to, _value);
355   }
356 
357   function transferFrom(
358     address _from,
359     address _to,
360     uint256 _value
361   )
362     public
363     whenNotPaused
364     returns (bool)
365   {
366     return super.transferFrom(_from, _to, _value);
367   }
368 
369   function approve(
370     address _spender,
371     uint256 _value
372   )
373     public
374     whenNotPaused
375     returns (bool)
376   {
377     return super.approve(_spender, _value);
378   }
379 
380   function increaseApproval(
381     address _spender,
382     uint _addedValue
383   )
384     public
385     whenNotPaused
386     returns (bool success)
387   {
388     return super.increaseApproval(_spender, _addedValue);
389   }
390 
391   function decreaseApproval(
392     address _spender,
393     uint _subtractedValue
394   )
395     public
396     whenNotPaused
397     returns (bool success)
398   {
399     return super.decreaseApproval(_spender, _subtractedValue);
400   }
401 }
402 /**
403  * @title RPHToken Token
404  *
405  * @dev Implementation of RPHToken Token based on the basic standard token.
406  */
407 contract RPHToken is  PausableToken{
408 
409     function () public {
410       //if ether is sent to this address, send it back.
411         revert();
412     }
413 
414     /**
415     * Public variables of the token
416     * The following variables are OPTIONAL vanities. One does not have to include them.
417     * They allow one to customise the token contract & in no way influences the core functionality.
418     * Some wallets/interfaces might not even bother to look at this information.
419     */
420     string public name;
421     uint8 public decimals=18;
422     string public symbol;
423     string public version = '1.0.0';
424 
425     /**
426      * @dev Function to check the amount of tokens that an owner allowed to a spender.
427      * @param _totalSupply total supply of the token.
428      * @param _name token name e.g RPHT Token.
429      * @param _symbol token symbol e.g RPHT.
430      */
431     constructor(uint256 _totalSupply, string _name, string _symbol) public {
432         totalSupply = _totalSupply * 10 ** uint256(decimals);
433         balances[msg.sender] = totalSupply;    // Give the creator all initial tokens
434         name = _name;
435         symbol = _symbol;
436     }
437 }