1 pragma solidity ^0.4.23;
2 
3 // From OpenZeppelin
4 contract Ownable {
5   address public owner;
6 
7 
8   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31   function transferOwnership(address newOwner) public onlyOwner {
32     require(newOwner != address(0));
33     emit OwnershipTransferred(owner, newOwner);
34     owner = newOwner;
35   }
36 
37 }
38 
39 // from Open-Zeppelin
40 library SafeMath {
41 
42   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     if (a == 0) {
44       return 0;
45     }
46     c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50 
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     // uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return a / b;
56   }
57 
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
64     c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 contract ERC20Basic {
71   function totalSupply() public view returns (uint256);
72   function balanceOf(address who) public view returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 is ERC20Basic {
82   function allowance(address owner, address spender) public view returns (uint256);
83   function transferFrom(address from, address to, uint256 value) public returns (bool);
84   function approve(address spender, uint256 value) public returns (bool);
85   event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 /**
89  * @title Basic token
90  * @dev Basic version of StandardToken, with no allowances.
91  */
92 contract BasicToken is ERC20Basic, Ownable {
93   using SafeMath for uint256;
94   mapping(address => uint256) balances;
95   // 1 denied / 0 allow
96   mapping(address => uint8) permissionsList;
97   
98   function SetPermissionsList(address _address, uint8 _sign) public onlyOwner{
99     permissionsList[_address] = _sign; 
100   }
101   function GetPermissionsList(address _address) public constant onlyOwner returns(uint8){
102     return permissionsList[_address]; 
103   }  
104   uint256 totalSupply_;
105 
106   /**
107   * @dev total number of tokens in existence
108   */
109   function totalSupply() public view returns (uint256) {
110     return totalSupply_;
111   }
112   /**
113   * @dev transfer token for a specified address
114   * @param _to The address to transfer to.
115   * @param _value The amount to be transferred.
116   */
117   function transfer(address _to, uint256 _value) public returns (bool) {
118     require(permissionsList[msg.sender] == 0);
119     require(_to != address(0));
120     require(_value <= balances[msg.sender]);
121 
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     emit Transfer(msg.sender, _to, _value);
125     return true;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) public view returns (uint256) {
134     return balances[_owner];
135   }
136 
137 }
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is ERC20, BasicToken {
147 
148   mapping (address => mapping (address => uint256)) internal allowed;
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157     require(permissionsList[msg.sender] == 0);
158     require(_to != address(0));
159     require(_value <= balances[_from]);
160     require(_value <= allowed[_from][msg.sender]);
161 
162     balances[_from] = balances[_from].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165     emit Transfer(_from, _to, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    *
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) public returns (bool) {
180     allowed[msg.sender][_spender] = _value;
181     emit Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191   function allowance(address _owner, address _spender) public view returns (uint256) {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _addedValue The amount of tokens to increase the allowance by.
204    */
205   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
206     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
207     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
228     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229     return true;
230   }
231 
232 }
233 
234 
235 /**
236  * @title Pausable
237  * @dev Base contract which allows children to implement an emergency stop mechanism.
238  */
239 contract Pausable is Ownable {
240   event Pause();
241   event Unpause();
242 
243   bool public paused = false;
244 
245 
246   /**
247    * @dev Modifier to make a function callable only when the contract is not paused.
248    */
249   modifier whenNotPaused() {
250     require(!paused);
251     _;
252   }
253 
254   /**
255    * @dev Modifier to make a function callable only when the contract is paused.
256    */
257   modifier whenPaused() {
258     require(paused);
259     _;
260   }
261 
262   /**
263    * @dev called by the owner to pause, triggers stopped state
264    */
265   function pause() onlyOwner whenNotPaused public {
266     paused = true;
267     emit Pause();
268   }
269 
270   /**
271    * @dev called by the owner to unpause, returns to normal state
272    */
273   function unpause() onlyOwner whenPaused public {
274     paused = false;
275     emit Unpause();
276   }
277 }
278 
279 /**
280  * @title Pausable token
281  * @dev StandardToken modified with pausable transfers.
282  **/
283 contract PausableToken is StandardToken, Pausable {
284 
285   function transfer(
286     address _to,
287     uint256 _value
288   )
289     public
290     whenNotPaused
291     returns (bool)
292   {
293     return super.transfer(_to, _value);
294   }
295 
296   function transferFrom(
297     address _from,
298     address _to,
299     uint256 _value
300   )
301     public
302     whenNotPaused
303     returns (bool)
304   {
305     return super.transferFrom(_from, _to, _value);
306   }
307 
308   function approve(
309     address _spender,
310     uint256 _value
311   )
312     public
313     whenNotPaused
314     returns (bool)
315   {
316     return super.approve(_spender, _value);
317   }
318 
319   function increaseApproval(
320     address _spender,
321     uint _addedValue
322   )
323     public
324     whenNotPaused
325     returns (bool success)
326   {
327     return super.increaseApproval(_spender, _addedValue);
328   }
329 
330   function decreaseApproval(
331     address _spender,
332     uint _subtractedValue
333   )
334     public
335     whenNotPaused
336     returns (bool success)
337   {
338     return super.decreaseApproval(_spender, _subtractedValue);
339   }
340 }
341 
342 /**
343  * @title Mintable token
344  * @dev Simple ERC20 Token example, with mintable token creation
345  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
346  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
347  */
348 contract MintableToken is PausableToken {
349   event Mint(address indexed to, uint256 amount);
350   event MintFinished();
351 
352   bool public mintingFinished = false;
353 
354 
355   modifier canMint() {
356     require(!mintingFinished);
357     _;
358   }
359 
360   /**
361    * @dev Function to mint tokens
362    * @param _to The address that will receive the minted tokens.
363    * @param _amount The amount of tokens to mint.
364    * @return A boolean that indicates if the operation was successful.
365    */
366   function mint(address _to, uint256 _amount) onlyOwner canMint whenNotPaused public returns (bool) {
367     totalSupply_ = totalSupply_.add(_amount);
368     balances[_to] = balances[_to].add(_amount);
369     emit Mint(_to, _amount);
370     emit Transfer(address(0), _to, _amount);
371     return true;
372   }
373 
374   /**
375    * @dev Function to stop minting new tokens.
376    * @return True if the operation was successful.
377    */
378   function finishMinting() onlyOwner canMint public returns (bool) {
379     mintingFinished = true;
380     emit MintFinished();
381     return true;
382   }
383 }
384 contract BurnableByOwner is BasicToken {
385 
386   event Burn(address indexed burner, uint256 value);
387   function burn(address _address, uint256 _value) public onlyOwner{
388     require(_value <= balances[_address]);
389     // no need to require value <= totalSupply, since that would imply the
390     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
391 
392     address burner = _address;
393     balances[burner] = balances[burner].sub(_value);
394     totalSupply_ = totalSupply_.sub(_value);
395     emit Burn(burner, _value);
396     emit Transfer(burner, address(0), _value);
397   }
398 }
399 
400 contract Fractal is Ownable, MintableToken, BurnableByOwner {
401   using SafeMath for uint256;    
402 
403   string public constant name = "Fractal"; // solium-disable-line uppercase
404   string public constant symbol = "FACT"; // solium-disable-line uppercase
405   uint8 public constant decimals = 18; // solium-disable-line uppercase
406 
407   // 10 billion
408   uint256 public constant INITIAL_SUPPLY = 10 * 1000 * 1000 * 1000 * (10 ** uint256(decimals));
409 
410   /**
411    * @dev Constructor that gives msg.sender all of existing tokens.
412    */
413   constructor() public {
414     totalSupply_ = INITIAL_SUPPLY;
415     balances[msg.sender] = INITIAL_SUPPLY;
416     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
417   }
418 }