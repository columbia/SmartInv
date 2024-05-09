1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 }
41 
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54       return 0;
55     }
56     uint256 c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     // uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return a / b;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) public view returns (uint256);
107   function transferFrom(address from, address to, uint256 value) public returns (bool);
108   function approve(address spender, uint256 value) public returns (bool);
109   event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117   using SafeMath for uint256;
118 
119   mapping(address => uint256) balances;
120 
121   uint256 totalSupply_;
122 
123   /**
124   * @dev total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return totalSupply_;
128   }
129 
130   /**
131   * @dev transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[msg.sender]);
138 
139     balances[msg.sender] = balances[msg.sender].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     Transfer(msg.sender, _to, _value);
142     return true;
143   }
144  
145 
146   /**
147   * @dev Gets the balance of the specified address.
148   * @param _owner The address to query the the balance of.
149   * @return An uint256 representing the amount owned by the passed address.
150   */
151   function balanceOf(address _owner) public view returns (uint256 balance) {
152     return balances[_owner];
153   }
154 
155 }
156 
157 
158 
159 /**
160  * @title Standard ERC20 token
161  *
162  * @dev Implementation of the basic standard token.
163  * @dev https://github.com/ethereum/EIPs/issues/20
164  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
165  */
166 contract StandardToken is ERC20, BasicToken {
167 
168   mapping (address => mapping (address => uint256)) internal allowed;
169 
170 
171   /**
172    * @dev Transfer tokens from one address to another
173    * @param _from address The address which you want to send tokens from
174    * @param _to address The address which you want to transfer to
175    * @param _value uint256 the amount of tokens to be transferred
176    */
177   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
178     require(_to != address(0));
179     require(_value <= balances[_from]);
180     require(_value <= allowed[_from][msg.sender]);
181 
182     balances[_from] = balances[_from].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185     Transfer(_from, _to, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191    *
192    * Beware that changing an allowance with this method brings the risk that someone may use both the old
193    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
194    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
195    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196    * @param _spender The address which will spend the funds.
197    * @param _value The amount of tokens to be spent.
198    */
199   function approve(address _spender, uint256 _value) public returns (bool) {
200     allowed[msg.sender][_spender] = _value;
201     Approval(msg.sender, _spender, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Function to check the amount of tokens that an owner allowed to a spender.
207    * @param _owner address The address which owns the funds.
208    * @param _spender address The address which will spend the funds.
209    * @return A uint256 specifying the amount of tokens still available for the spender.
210    */
211   function allowance(address _owner, address _spender) public view returns (uint256) {
212     return allowed[_owner][_spender];
213   }
214 
215   /**
216    * @dev Increase the amount of tokens that an owner allowed to a spender.
217    *
218    * approve should be called when allowed[_spender] == 0. To increment
219    * allowed value is better to use this function to avoid 2 calls (and wait until
220    * the first transaction is mined)
221    * From MonolithDAO Token.sol
222    * @param _spender The address which will spend the funds.
223    * @param _addedValue The amount of tokens to increase the allowance by.
224    */
225   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
226     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
227     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231   /**
232    * @dev Decrease the amount of tokens that an owner allowed to a spender.
233    *
234    * approve should be called when allowed[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
242     uint oldValue = allowed[msg.sender][_spender];
243     if (_subtractedValue > oldValue) {
244       allowed[msg.sender][_spender] = 0;
245     } else {
246       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247     }
248     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252 }
253 
254 
255 
256 /**
257  * @title Burnable Token
258  * @dev Token that can be irreversibly burned (destroyed).
259  */
260 contract BurnableToken is StandardToken {
261 
262   event Burn(address indexed burner, uint256 value);
263 
264   /**
265    * @dev Burns a specific amount of tokens.
266    * @param _value The amount of token to be burned.
267    */
268   function burn(uint256 _value) public {
269     require(_value <= balances[msg.sender]);
270     // no need to require value <= totalSupply, since that would imply the
271     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
272 
273     address burner = msg.sender;
274     balances[burner] = balances[burner].sub(_value);
275     totalSupply_ = totalSupply_.sub(_value);
276     Burn(burner, _value);
277     Transfer(burner, address(0), _value);
278   }
279 }
280 
281 
282 
283 
284 
285 /**
286  * @title Pausable
287  * @dev Base contract which allows children to implement an emergency stop mechanism.
288  */
289 contract Pausable is Ownable {
290   
291   event Pause();
292   event Unpause();
293 
294   bool public paused = false;
295 
296 
297   /**
298    * @dev Modifier to make a function callable only when the contract is not paused.
299    */
300   modifier whenNotPaused() {
301     require(!paused);
302     _;
303   }
304   
305 
306   /**
307    * @dev Modifier to make a function callable only when the contract is paused.
308    */
309   modifier whenPaused() {
310     require(paused);
311     _;
312   }
313 
314   /**
315    * @dev called by the owner to pause, triggers stopped state
316    */
317   function pause() onlyOwner whenNotPaused public {
318     paused = true;
319     Pause();
320   }
321 
322   /**
323    * @dev called by the owner to unpause, returns to normal state
324    */
325   function unpause() onlyOwner whenPaused public {
326     paused = false;
327     Unpause();
328   }
329 }
330 
331 
332 
333 /**
334  * @title Pausable token
335  * @dev StandardToken modified with pausable transfers.
336  **/
337 contract PausableToken is BurnableToken, Pausable {
338     
339   address public icoContract;
340   
341   function setIcoContract(address _icoContract) public onlyOwner {
342     require(_icoContract != address(0));
343     icoContract = _icoContract;
344   }
345   function removeIcoContract() public onlyOwner {
346     icoContract = address(0);
347   }
348   
349   modifier whenNotPausedOrIcoContract() {
350     require(icoContract == msg.sender || !paused);
351     _;
352   }
353   
354   function transfer(address _to, uint256 _value) public whenNotPausedOrIcoContract returns (bool) {
355     return super.transfer(_to, _value);
356   }
357 
358   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
359     return super.transferFrom(_from, _to, _value);
360   }
361 
362   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
363     return super.approve(_spender, _value);
364   }
365 
366   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
367     return super.increaseApproval(_spender, _addedValue);
368   }
369 
370   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
371     return super.decreaseApproval(_spender, _subtractedValue);
372   }
373 }
374 
375 
376 /**
377  * @title Mintable token
378  * @dev Simple ERC20 Token example, with mintable token creation
379  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
380  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
381  */
382 contract MintableToken is PausableToken {
383   event Mint(address indexed to, uint256 amount);
384   event MintFinished();
385 
386   bool public mintingFinished = false;
387 
388 
389   modifier canMint() {
390     require(!mintingFinished);
391     _;
392   }
393 
394   /**
395    * @dev Function to mint tokens
396    * @param _to The address that will receive the minted tokens.
397    * @param _amount The amount of tokens to mint.
398    * @return A boolean that indicates if the operation was successful.
399    */
400   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
401     totalSupply_ = totalSupply_.add(_amount);
402     balances[_to] = balances[_to].add(_amount);
403     Mint(_to, _amount);
404     Transfer(address(0), _to, _amount);
405     return true;
406   }
407 
408   /**
409    * @dev Function to stop minting new tokens.
410    * @return True if the operation was successful.
411    */
412   function finishMinting() onlyOwner canMint public returns (bool) {
413     mintingFinished = true;
414     MintFinished();
415     return true;
416   }
417 }
418 
419 
420 
421 contract DetailedERC20 {
422   string public name;
423   string public symbol;
424   uint8 public decimals;
425 
426   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
427     name = _name;
428     symbol = _symbol;
429     decimals = _decimals;
430   }
431 }
432 
433 
434 
435 contract MonsterBitToken is MintableToken, DetailedERC20 {
436     
437   function MonsterBitToken() public DetailedERC20("MonsterBit", "MB", 18) {
438   }
439   
440 }