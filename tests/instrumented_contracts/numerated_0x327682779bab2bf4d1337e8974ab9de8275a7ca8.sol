1 pragma solidity ^0.4.13;
2 
3 // File: contracts\zeppelin\ownership\Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: contracts\zeppelin\math\SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal  returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal  returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal  returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal  returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 // File: contracts\zeppelin\token\ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public  returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: contracts\zeppelin\token\BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public  returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: contracts\zeppelin\token\ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public  returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: contracts\zeppelin\token\StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162   * @dev transfer token for a specified address
163   * @param _to The address to transfer to.
164   * @param _value The amount to be transferred.
165   */
166   function transfer(address _to, uint256 _value) public returns (bool) {
167     return BasicToken.transfer(_to, _value);
168   }
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
210   function allowance(address _owner, address _spender) public  returns (uint256) {
211     return allowed[_owner][_spender];
212   }
213 
214   /**
215    * approve should be called when allowed[_spender] == 0. To increment
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    */
220   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
221     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
227     uint oldValue = allowed[msg.sender][_spender];
228     if (_subtractedValue > oldValue) {
229       allowed[msg.sender][_spender] = 0;
230     } else {
231       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232     }
233     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237 }
238 
239 // File: contracts\zeppelin\token\MintableToken.sol
240 
241 /**
242  * @title Mintable token
243  * @dev Simple ERC20 Token example, with mintable token creation
244  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
245  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
246  */
247 
248 contract MintableToken is StandardToken, Ownable {
249   event Mint(address indexed to, uint256 amount);
250   event MintFinished();
251 
252   bool public mintingFinished = false;
253 
254 
255   modifier canMint() {
256     require(!mintingFinished);
257     _;
258   }
259 
260   /**
261    * @dev Function to mint tokens
262    * @param _to The address that will receive the minted tokens.
263    * @param _amount The amount of tokens to mint.
264    * @return A boolean that indicates if the operation was successful.
265    */
266   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
267     totalSupply = totalSupply.add(_amount);
268     balances[_to] = balances[_to].add(_amount);
269     Mint(_to, _amount);
270     Transfer(address(0), _to, _amount);
271     return true;
272   }
273 
274   /**
275    * @dev Function to stop minting new tokens.
276    * @return True if the operation was successful.
277    */
278   function finishMinting() onlyOwner canMint public returns (bool) {
279     mintingFinished = true;
280     MintFinished();
281     return true;
282   }
283 }
284 
285 // File: contracts\zeppelin\token\CappedToken.sol
286 
287 /**
288  * @title Capped token
289  * @dev Mintable token with a token cap.
290  */
291 
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
308     require(totalSupply.add(_amount) <= cap);
309 
310     return super.mint(_to, _amount);
311   }
312 
313 }
314 
315 // File: contracts\zeppelin\lifecycle\Pausable.sol
316 
317 /**
318  * @title Pausable
319  * @dev Base contract which allows children to implement an emergency stop mechanism.
320  */
321 contract Pausable is Ownable {
322   event Pause();
323   event Unpause();
324 
325   bool public paused = false;
326 
327 
328   /**
329    * @dev Modifier to make a function callable only when the contract is not paused.
330    */
331   modifier whenNotPaused() {
332     require(!paused);
333     _;
334   }
335 
336   /**
337    * @dev Modifier to make a function callable only when the contract is paused.
338    */
339   modifier whenPaused() {
340     require(paused);
341     _;
342   }
343 
344   /**
345    * @dev called by the owner to pause, triggers stopped state
346    */
347   function pause() onlyOwner whenNotPaused public {
348     paused = true;
349     Pause();
350   }
351 
352   /**
353    * @dev called by the owner to unpause, returns to normal state
354    */
355   function unpause() onlyOwner whenPaused public {
356     paused = false;
357     Unpause();
358   }
359 }
360 
361 // File: contracts\zeppelin\token\PausableToken.sol
362 
363 /**
364  * @title Pausable token
365  *
366  * @dev StandardToken modified with pausable transfers.
367  **/
368 
369 contract PausableToken is StandardToken, Pausable {
370 
371   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
372     return super.transfer(_to, _value);
373   }
374 
375   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
376     return super.transferFrom(_from, _to, _value);
377   }
378 
379   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
380     return super.approve(_spender, _value);
381   }
382 
383   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
384     return super.increaseApproval(_spender, _addedValue);
385   }
386 
387   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
388     return super.decreaseApproval(_spender, _subtractedValue);
389   }
390 }
391 
392 // File: contracts\BlockportToken.sol
393 
394 /// @title Blockport Token - Token code for our Blockport.nl Project
395 /// @author Jan Bolhuis, Wesley van Heije
396 //  Version 3, december 2017
397 //  This version is completely based on the Openzeppelin Solidity framework.
398 //
399 //  There will be a presale cap of 6.400.000 BPT Tokens
400 //  Minimum presale investment in Ether will be set at the start in the Presale contract; calculated on a weekly avarage for an amount of ~ 1000 Euro
401 //  Unsold presale tokens will be burnt, implemented as mintbale token as such that only sold tokens are minted.
402 //  Presale rate has a 33% bonus to the crowdsale to compensate the extra risk
403 //  The total supply of tokens (pre-sale + crowdsale) will be 49,600,000 BPT
404 //  Minimum crowdsale investment will be 0.1 ether
405 //  Mac cap for the crowdsale is 43,200,000 BPT
406 //  There is no bonus scheme for the crowdsale
407 //  Unsold Crowsdale tokens will be burnt, implemented as mintbale token as such that only sold tokens are minted.
408 //  On the amount tokens sold an additional 40% will be minted; this will be allocated to the Blockport company(20%) and the Blockport team(20%)
409 //  BPT tokens will be tradable straigt after the finalization of the crowdsale. This is implemented by being a pausable token that is unpaused at Crowdsale finalisation.
410 
411 
412 contract BlockportToken is CappedToken, PausableToken {
413 
414     string public constant name                 = "Blockport Token";
415     string public constant symbol               = "BPT";
416     uint public constant decimals               = 18;
417 
418     function BlockportToken(uint256 _totalSupply) 
419         CappedToken(_totalSupply) public {
420             paused = true;
421     }
422 }