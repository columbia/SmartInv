1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * See https://github.com/ethereum/EIPs/issues/179
58  */
59 contract ERC20Basic {
60   function totalSupply() public view returns (uint256);
61   function balanceOf(address who) public view returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   uint256 totalSupply_;
76 
77   /**
78   * @dev Total number of tokens in existence
79   */
80   function totalSupply() public view returns (uint256) {
81     return totalSupply_;
82   }
83 
84   /**
85   * @dev Transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_value <= balances[msg.sender]);
91     require(_to != address(0));
92 
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     emit Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of.
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) public view returns (uint256) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115   function allowance(address owner, address spender) public view returns (uint256);
116   function transferFrom(address from, address to, uint256 value) public returns (bool);
117   function approve(address spender, uint256 value) public returns (bool);
118   event Approval(address indexed owner,address indexed spender,uint256 value);
119 }
120 
121 
122 /**
123  * @title Standard ERC20 token
124  *
125  * @dev Implementation of the basic standard token.
126  * https://github.com/ethereum/EIPs/issues/20
127  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
128  */
129 contract StandardToken is ERC20, BasicToken {
130 
131   mapping (address => mapping (address => uint256)) internal allowed;
132 
133 
134   /**
135    * @dev Transfer tokens from one address to another
136    * @param _from address The address which you want to send tokens from
137    * @param _to address The address which you want to transfer to
138    * @param _value uint256 the amount of tokens to be transferred
139    */
140   function transferFrom(address _from,address _to,uint256 _value) public returns (bool){
141     require(_value <= balances[_from]);
142     require(_value <= allowed[_from][msg.sender]);
143     require(_to != address(0));
144 
145     balances[_from] = balances[_from].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148     emit Transfer(_from, _to, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    * Beware that changing an allowance with this method brings the risk that someone may use both the old
155    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) public returns (bool) {
162     allowed[msg.sender][_spender] = _value;
163     emit Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173   function allowance(address _owner,address _spender) public view returns (uint256){
174     return allowed[_owner][_spender];
175   }
176 
177   /**
178    * @dev Increase the amount of tokens that an owner allowed to a spender.
179    * approve should be called when allowed[_spender] == 0. To increment
180    * allowed value is better to use this function to avoid 2 calls (and wait until
181    * the first transaction is mined)
182    * From MonolithDAO Token.sol
183    * @param _spender The address which will spend the funds.
184    * @param _addedValue The amount of tokens to increase the allowance by.
185    */
186   function increaseApproval(address _spender,uint256 _addedValue) public returns (bool){
187     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
188     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192   /**
193    * @dev Decrease the amount of tokens that an owner allowed to a spender.
194    * approve should be called when allowed[_spender] == 0. To decrement
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param _spender The address which will spend the funds.
199    * @param _subtractedValue The amount of tokens to decrease the allowance by.
200    */
201   function decreaseApproval(address _spender,uint256 _subtractedValue) public returns (bool){
202     uint256 oldValue = allowed[msg.sender][_spender];
203     if (_subtractedValue >= oldValue) {
204       allowed[msg.sender][_spender] = 0;
205     } else {
206       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207     }
208     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212 }
213 
214 /**
215  * @title Ownable
216  * @dev The Ownable contract has an owner address, and provides basic authorization control
217  * functions, this simplifies the implementation of "user permissions".
218  */
219 contract Ownable {
220   address public owner;
221 
222 
223   event OwnershipRenounced(address indexed previousOwner);
224   event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);
225 
226 
227   /**
228    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
229    * account.
230    */
231   constructor() public {
232     owner = msg.sender;
233   }
234 
235   /**
236    * @dev Throws if called by any account other than the owner.
237    */
238   modifier onlyOwner() {
239     require(msg.sender == owner);
240     _;
241   }
242 
243   /**
244    * @dev Allows the current owner to relinquish control of the contract.
245    * @notice Renouncing to ownership will leave the contract without an owner.
246    * It will not be possible to call the functions with the `onlyOwner`
247    * modifier anymore.
248    */
249   function renounceOwnership() public onlyOwner {
250     emit OwnershipRenounced(owner);
251     owner = address(0);
252   }
253 
254   /**
255    * @dev Allows the current owner to transfer control of the contract to a newOwner.
256    * @param _newOwner The address to transfer ownership to.
257    */
258   function transferOwnership(address _newOwner) public onlyOwner {
259     _transferOwnership(_newOwner);
260   }
261 
262   /**
263    * @dev Transfers control of the contract to a newOwner.
264    * @param _newOwner The address to transfer ownership to.
265    */
266   function _transferOwnership(address _newOwner) internal {
267     require(_newOwner != address(0));
268     emit OwnershipTransferred(owner, _newOwner);
269     owner = _newOwner;
270   }
271 }
272 
273 /**
274  * @title Pausable
275  * @dev Base contract which allows children to implement an emergency stop mechanism.
276  */
277 contract Pausable is Ownable {
278   event Pause();
279   event Unpause();
280 
281   bool public paused = false;
282 
283 
284   /**
285    * @dev Modifier to make a function callable only when the contract is not paused.
286    */
287   modifier whenNotPaused() {
288     require(!paused);
289     _;
290   }
291 
292   /**
293    * @dev Modifier to make a function callable only when the contract is paused.
294    */
295   modifier whenPaused() {
296     require(paused);
297     _;
298   }
299 
300   /**
301    * @dev called by the owner to pause, triggers stopped state
302    */
303   function pause() onlyOwner whenNotPaused public {
304     paused = true;
305     emit Pause();
306   }
307 
308   /**
309    * @dev called by the owner to unpause, returns to normal state
310    */
311   function unpause() onlyOwner whenPaused public {
312     paused = false;
313     emit Unpause();
314   }
315 }
316 
317 
318 contract MintableToken is StandardToken, Ownable {
319   event Mint(address indexed to, uint256 amount);
320   event MintFinished();
321 
322   bool public mintingFinished = false;
323 
324 
325   modifier canMint() {
326     require(!mintingFinished);
327     _;
328   }
329 
330   modifier hasMintPermission() {
331     require(msg.sender == owner);
332     _;
333   }
334 
335   /**
336    * @dev Function to mint tokens
337    * @param _to The address that will receive the minted tokens.
338    * @param _amount The amount of tokens to mint.
339    * @return A boolean that indicates if the operation was successful.
340    */
341   function mint(address _to,uint256 _amount) hasMintPermission canMint public returns (bool){
342     totalSupply_ = totalSupply_.add(_amount);
343     balances[_to] = balances[_to].add(_amount);
344     emit Mint(_to, _amount);
345     emit Transfer(address(0), _to, _amount);
346     return true;
347   }
348 
349   /**
350    * @dev Function to stop minting new tokens.
351    * @return True if the operation was successful.
352    */
353   function finishMinting() onlyOwner canMint public returns (bool) {
354     mintingFinished = true;
355     emit MintFinished();
356     return true;
357   }
358 }
359 
360 /**
361  * @title Burnable Token
362  * @dev Token that can be irreversibly burned (destroyed).
363  */
364 contract BurnableToken is BasicToken {
365 
366   event Burn(address indexed burner, uint256 value);
367 
368   /**
369    * @dev Burns a specific amount of tokens.
370    * @param _value The amount of token to be burned.
371    */
372   function burn(uint256 _value) public {
373     _burn(msg.sender, _value);
374   }
375 
376   function _burn(address _who, uint256 _value) internal {
377     require(_value <= balances[_who]);
378     // no need to require value <= totalSupply, since that would imply the
379     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
380 
381     balances[_who] = balances[_who].sub(_value);
382     totalSupply_ = totalSupply_.sub(_value);
383     emit Burn(_who, _value);
384     emit Transfer(_who, address(0), _value);
385   }
386 }
387 
388 contract PausableToken is StandardToken, Pausable {
389 
390   function transfer(address _to,uint256 _value) public whenNotPaused returns (bool){
391     return super.transfer(_to, _value);
392   }
393 
394   function transferFrom(address _from,address _to,uint256 _value) public whenNotPaused returns (bool){
395     return super.transferFrom(_from, _to, _value);
396   }
397 
398   function approve(address _spender,uint256 _value) public whenNotPaused returns (bool){
399     return super.approve(_spender, _value);
400   }
401 
402   function increaseApproval(address _spender,uint _addedValue) public whenNotPaused returns (bool success){
403     return super.increaseApproval(_spender, _addedValue);
404   }
405 
406   function decreaseApproval(address _spender,uint _subtractedValue) public whenNotPaused returns (bool success){
407     return super.decreaseApproval(_spender, _subtractedValue);
408   }
409 }
410 
411 
412 contract ArtRightToken is PausableToken,MintableToken,BurnableToken{
413 
414     string public name = 'Art Right';
415     string public symbol = 'AR';
416     uint8 public decimals = 18;
417     uint public INITIAL_SUPPLY = 10000000000;
418 
419 
420     constructor() public {
421         totalSupply_ = INITIAL_SUPPLY * 10 ** uint256(decimals);
422         balances[msg.sender] = totalSupply_;
423     }
424 
425 }