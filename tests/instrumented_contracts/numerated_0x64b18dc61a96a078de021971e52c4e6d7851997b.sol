1 pragma solidity ^0.4.20;
2 
3 // ----------------------------------------------------------------------------
4 //    __  __    _    _  _______    _    _____ ___  _     ___ ___  
5 //   |  \/  |  / \  | |/ / ____|  / \  |  ___/ _ \| |   |_ _/ _ \ 
6 //   | |\/| | / _ \ | ' /|  _|   / _ \ | |_ | | | | |    | | | | |
7 //   | |  | |/ ___ \| . \| |___ / ___ \|  _|| |_| | |___ | | |_| |
8 //   |_|  |_/_/   \_\_|\_\_____/_/   \_\_|   \___/|_____|___\___/ 
9 //
10 //                    https://www.makeafolio.com              
11 //
12 //            All in one cryptocurrency portfolio management
13 // ----------------------------------------------------------------------------
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54   address public owner;
55 
56 
57   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   function Ownable() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) public onlyOwner {
81     require(newOwner != address(0));
82     OwnershipTransferred(owner, newOwner);
83     owner = newOwner;
84   }
85 
86 }
87 
88 /**
89  * @title ERC20Basic
90  * @dev Simpler version of ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/179
92  */
93 contract ERC20Basic {
94   function totalSupply() public view returns (uint256);
95   function balanceOf(address who) public view returns (uint256);
96   function transfer(address to, uint256 value) public returns (bool);
97   event Transfer(address indexed from, address indexed to, uint256 value);
98 }
99 
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public view returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
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
139     // SafeMath.sub will throw if there is not enough balance.
140     balances[msg.sender] = balances[msg.sender].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     Transfer(msg.sender, _to, _value);
143     return true;
144   }
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
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * @dev https://github.com/ethereum/EIPs/issues/20
163  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177     require(_to != address(0));
178     require(_value <= balances[_from]);
179     require(_value <= allowed[_from][msg.sender]);
180 
181     balances[_from] = balances[_from].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184     Transfer(_from, _to, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190    *
191    * Beware that changing an allowance with this method brings the risk that someone may use both the old
192    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195    * @param _spender The address which will spend the funds.
196    * @param _value The amount of tokens to be spent.
197    */
198   function approve(address _spender, uint256 _value) public returns (bool) {
199     allowed[msg.sender][_spender] = _value;
200     Approval(msg.sender, _spender, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Function to check the amount of tokens that an owner allowed to a spender.
206    * @param _owner address The address which owns the funds.
207    * @param _spender address The address which will spend the funds.
208    * @return A uint256 specifying the amount of tokens still available for the spender.
209    */
210   function allowance(address _owner, address _spender) public view returns (uint256) {
211     return allowed[_owner][_spender];
212   }
213 
214   /**
215    * @dev Increase the amount of tokens that an owner allowed to a spender.
216    *
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param _spender The address which will spend the funds.
222    * @param _addedValue The amount of tokens to increase the allowance by.
223    */
224   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
225     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
226     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230   /**
231    * @dev Decrease the amount of tokens that an owner allowed to a spender.
232    *
233    * approve should be called when allowed[_spender] == 0. To decrement
234    * allowed value is better to use this function to avoid 2 calls (and wait until
235    * the first transaction is mined)
236    * From MonolithDAO Token.sol
237    * @param _spender The address which will spend the funds.
238    * @param _subtractedValue The amount of tokens to decrease the allowance by.
239    */
240   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
241     uint oldValue = allowed[msg.sender][_spender];
242     if (_subtractedValue > oldValue) {
243       allowed[msg.sender][_spender] = 0;
244     } else {
245       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246     }
247     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251 }
252 
253 
254 
255 /**
256  * @title Mintable token
257  * @dev Simple ERC20 Token example, with mintable token creation
258  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
259  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
260  */
261 contract MintableToken is StandardToken, Ownable {
262   event Mint(address indexed to, uint256 amount);
263   event MintFinished();
264 
265   bool public mintingFinished = false;
266 
267 
268   modifier canMint() {
269     require(!mintingFinished);
270     _;
271   }
272 
273   /**
274    * @dev Function to mint tokens
275    * @param _to The address that will receive the minted tokens.
276    * @param _amount The amount of tokens to mint.
277    * @return A boolean that indicates if the operation was successful.
278    */
279   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
280     totalSupply_ = totalSupply_.add(_amount);
281     balances[_to] = balances[_to].add(_amount);
282     Mint(_to, _amount);
283     Transfer(address(0), _to, _amount);
284     return true;
285   }
286 
287   /**
288    * @dev Function to stop minting new tokens.
289    * @return True if the operation was successful.
290    */
291   function finishMinting() onlyOwner canMint public returns (bool) {
292     mintingFinished = true;
293     MintFinished();
294     return true;
295   }
296 }
297 
298 /**
299  * @title Capped token
300  * @dev Mintable token with a token cap.
301  */
302 contract CappedToken is MintableToken {
303 
304   uint256 public cap;
305 
306   function CappedToken(uint256 _cap) public {
307     require(_cap > 0);
308     cap = _cap;
309   }
310 
311   /**
312    * @dev Function to mint tokens
313    * @param _to The address that will receive the minted tokens.
314    * @param _amount The amount of tokens to mint.
315    * @return A boolean that indicates if the operation was successful.
316    */
317   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
318     require(totalSupply_.add(_amount) <= cap);
319 
320     return super.mint(_to, _amount);
321   }
322 
323 }
324 
325 
326 
327 /**
328  * @title Burnable Token
329  * @dev Token that can be irreversibly burned (destroyed).
330  */
331 contract BurnableToken is BasicToken {
332 
333   event Burn(address indexed burner, uint256 value);
334 
335   /**
336    * @dev Burns a specific amount of tokens.
337    * @param _value The amount of token to be burned.
338    */
339   function burn(uint256 _value) public {
340     require(_value <= balances[msg.sender]);
341     // no need to require value <= totalSupply, since that would imply the
342     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
343 
344     address burner = msg.sender;
345     balances[burner] = balances[burner].sub(_value);
346     totalSupply_ = totalSupply_.sub(_value);
347     Burn(burner, _value);
348   }
349 }
350 
351 
352 
353 /**
354  * @title Pausable
355  * @dev Base contract which allows children to implement an emergency stop mechanism.
356  */
357 contract Pausable is Ownable {
358   event Pause();
359   event Unpause();
360 
361   bool public paused = false;
362 
363 
364   /**
365    * @dev Modifier to make a function callable only when the contract is not paused.
366    */
367   modifier whenNotPaused() {
368     require(!paused);
369     _;
370   }
371 
372   /**
373    * @dev Modifier to make a function callable only when the contract is paused.
374    */
375   modifier whenPaused() {
376     require(paused);
377     _;
378   }
379 
380   /**
381    * @dev called by the owner to pause, triggers stopped state
382    */
383   function pause() onlyOwner whenNotPaused public {
384     paused = true;
385     Pause();
386   }
387 
388   /**
389    * @dev called by the owner to unpause, returns to normal state
390    */
391   function unpause() onlyOwner whenPaused public {
392     paused = false;
393     Unpause();
394   }
395 }
396 
397 /**
398  * @title Pausable token
399  * @dev StandardToken modified with pausable transfers.
400  **/
401 contract PausableToken is StandardToken, Pausable {
402 
403   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
404     return super.transfer(_to, _value);
405   }
406 
407   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
408     return super.transferFrom(_from, _to, _value);
409   }
410 
411   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
412     return super.approve(_spender, _value);
413   }
414 
415   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
416     return super.increaseApproval(_spender, _addedValue);
417   }
418 
419   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
420     return super.decreaseApproval(_spender, _subtractedValue);
421   }
422 }
423 
424 contract Token is StandardToken , MintableToken, BurnableToken, PausableToken {
425 
426     string public constant name = 'MAKEAFOLIO';
427     string public constant symbol = 'MAF';
428     uint8 public constant decimals = 18;
429 
430     function Token()
431         public
432         payable
433         
434     {
435         
436                 uint premintAmount = 35000000*10**uint(decimals);
437                 totalSupply_ = totalSupply_.add(premintAmount);
438                 balances[msg.sender] = balances[msg.sender].add(premintAmount);
439                 Transfer(address(0), msg.sender, premintAmount);
440 
441             
442         
443     }
444     
445     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
446         return ERC20Basic(tokenAddress).transfer(owner, tokens);
447     }
448 }