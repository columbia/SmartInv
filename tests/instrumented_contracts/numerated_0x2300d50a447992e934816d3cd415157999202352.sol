1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84   function totalSupply() public view returns (uint256);
85   function balanceOf(address who) public view returns (uint256);
86   function transfer(address to, uint256 value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public view returns (uint256);
96   function transferFrom(address from, address to, uint256 value) public returns (bool);
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107   using SafeMath for uint256;
108 
109   mapping(address => uint256) balances;
110 
111   uint256 totalSupply_;
112 
113   /**
114   * @dev total number of tokens in existence
115   */
116   function totalSupply() public view returns (uint256) {
117     return totalSupply_;
118   }
119 
120   /**
121   * @dev transfer token for a specified address
122   * @param _to The address to transfer to.
123   * @param _value The amount to be transferred.
124   */
125   function transfer(address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[msg.sender]);
128 
129     // SafeMath.sub will throw if there is not enough balance.
130     balances[msg.sender] = balances[msg.sender].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of.
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) public view returns (uint256 balance) {
142     return balances[_owner];
143   }
144 
145 }
146 
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * @dev https://github.com/ethereum/EIPs/issues/20
153  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  */
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
205    * @dev Increase the amount of tokens that an owner allowed to a spender.
206    *
207    * approve should be called when allowed[_spender] == 0. To increment
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param _spender The address which will spend the funds.
212    * @param _addedValue The amount of tokens to increase the allowance by.
213    */
214   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
215     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220   /**
221    * @dev Decrease the amount of tokens that an owner allowed to a spender.
222    *
223    * approve should be called when allowed[_spender] == 0. To decrement
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _subtractedValue The amount of tokens to decrease the allowance by.
229    */
230   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
231     uint oldValue = allowed[msg.sender][_spender];
232     if (_subtractedValue > oldValue) {
233       allowed[msg.sender][_spender] = 0;
234     } else {
235       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236     }
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241 }
242 
243 
244 
245 /**
246  * @title Mintable token
247  * @dev Simple ERC20 Token example, with mintable token creation
248  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
249  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
250  */
251 contract MintableToken is StandardToken, Ownable {
252   event Mint(address indexed to, uint256 amount);
253   event MintFinished();
254 
255   bool public mintingFinished = false;
256 
257 
258   modifier canMint() {
259     require(!mintingFinished);
260     _;
261   }
262 
263   /**
264    * @dev Function to mint tokens
265    * @param _to The address that will receive the minted tokens.
266    * @param _amount The amount of tokens to mint.
267    * @return A boolean that indicates if the operation was successful.
268    */
269   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
270     totalSupply_ = totalSupply_.add(_amount);
271     balances[_to] = balances[_to].add(_amount);
272     Mint(_to, _amount);
273     Transfer(address(0), _to, _amount);
274     return true;
275   }
276 
277   /**
278    * @dev Function to stop minting new tokens.
279    * @return True if the operation was successful.
280    */
281   function finishMinting() onlyOwner canMint public returns (bool) {
282     mintingFinished = true;
283     MintFinished();
284     return true;
285   }
286 }
287 
288 /**
289  * @title Capped token
290  * @dev Mintable token with a token cap.
291  */
292 contract CappedToken is MintableToken {
293 
294   uint256 public cap;
295 
296   function CappedToken(uint256 _cap) public {
297     require(_cap > 0);
298     cap = _cap;
299   }
300 
301   /**
302    * @dev Function to mint tokens
303    * @param _to The address that will receive the minted tokens.
304    * @param _amount The amount of tokens to mint.
305    * @return A boolean that indicates if the operation was successful.
306    */
307   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
308     require(totalSupply_.add(_amount) <= cap);
309 
310     return super.mint(_to, _amount);
311   }
312 
313 }
314 
315 
316 
317 /**
318  * @title Burnable Token
319  * @dev Token that can be irreversibly burned (destroyed).
320  */
321 contract BurnableToken is BasicToken {
322 
323   event Burn(address indexed burner, uint256 value);
324 
325   /**
326    * @dev Burns a specific amount of tokens.
327    * @param _value The amount of token to be burned.
328    */
329   function burn(uint256 _value) public {
330     require(_value <= balances[msg.sender]);
331     // no need to require value <= totalSupply, since that would imply the
332     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
333 
334     address burner = msg.sender;
335     balances[burner] = balances[burner].sub(_value);
336     totalSupply_ = totalSupply_.sub(_value);
337     Burn(burner, _value);
338   }
339 }
340 
341 
342 
343 /**
344  * @title Pausable
345  * @dev Base contract which allows children to implement an emergency stop mechanism.
346  */
347 contract Pausable is Ownable {
348   event Pause();
349   event Unpause();
350 
351   bool public paused = false;
352 
353 
354   /**
355    * @dev Modifier to make a function callable only when the contract is not paused.
356    */
357   modifier whenNotPaused() {
358     require(!paused);
359     _;
360   }
361 
362   /**
363    * @dev Modifier to make a function callable only when the contract is paused.
364    */
365   modifier whenPaused() {
366     require(paused);
367     _;
368   }
369 
370   /**
371    * @dev called by the owner to pause, triggers stopped state
372    */
373   function pause() onlyOwner whenNotPaused public {
374     paused = true;
375     Pause();
376   }
377 
378   /**
379    * @dev called by the owner to unpause, returns to normal state
380    */
381   function unpause() onlyOwner whenPaused public {
382     paused = false;
383     Unpause();
384   }
385 }
386 
387 /**
388  * @title Pausable token
389  * @dev StandardToken modified with pausable transfers.
390  **/
391 contract PausableToken is StandardToken, Pausable {
392 
393   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
394     return super.transfer(_to, _value);
395   }
396 
397   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
398     return super.transferFrom(_from, _to, _value);
399   }
400 
401   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
402     return super.approve(_spender, _value);
403   }
404 
405   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
406     return super.increaseApproval(_spender, _addedValue);
407   }
408 
409   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
410     return super.decreaseApproval(_spender, _subtractedValue);
411   }
412 }
413 
414 contract Token is StandardToken , MintableToken, CappedToken, BurnableToken {
415 
416     string public constant name = 'ERCH';
417     string public constant symbol = 'ERCH';
418     uint8 public constant decimals = 8;
419 
420     function Token()
421         public
422         payable
423          CappedToken(10000000*10**uint(decimals))
424     {
425         
426                 uint premintAmount = 10000000*10**uint(decimals);
427                 totalSupply_ = totalSupply_.add(premintAmount);
428                 balances[msg.sender] = balances[msg.sender].add(premintAmount);
429                 Transfer(address(0), msg.sender, premintAmount);
430 
431             
432         
433     }
434 
435 }